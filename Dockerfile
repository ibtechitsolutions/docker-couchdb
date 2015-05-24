FROM debian:wheezy

MAINTAINER Krzysztof Kobrzak <chris.kobrzak@gmail.com>

ENV COUCHDB_VERSION 1.6.1

# CouchDB dependencies and required utilities
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y --force-yes --no-install-recommends \
    build-essential \
    curl \
    erlang-dev \
    erlang-nox \
    libcurl4-openssl-dev \
    libicu-dev \
    libmozjs185-1.0 \
    libmozjs185-dev \
    netcat \
    pwgen

ADD scripts /usr/local/bin

RUN \
  groupadd -r couchdb && \
  useradd -d /usr/local/var/lib/couchdb -g couchdb couchdb && \
  chown -R couchdb:couchdb /usr/local/bin/* && \
  chmod -R +x /usr/local/bin/*

# CouchDB installation from source
RUN \
  DEBIAN_FRONTEND=noninteractive && \
  cd /usr/src && \
  curl -s -o apache-couchdb.tar.gz http://mirror.ox.ac.uk/sites/rsync.apache.org/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz && \
  tar -xzf apache-couchdb.tar.gz && \
  cd /usr/src/apache-couchdb-$COUCHDB_VERSION && \
  ./configure && \
  make --quiet && \
  make install

RUN \
  sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini && \
  # CORS support in CouchDB
  sed -i '/\[httpd\]/a enable_cors = true' /usr/local/etc/couchdb/local.ini && \
  echo '[cors] \
   \norigins = * \
   \ncredentials = true \
   \nheaders = accept, authorization, content-type, origin, referer \
   \nmethods = GET, PUT, POST, HEAD, DELETE' >> /usr/local/etc/couchdb/local.ini

RUN \
  mkdir /var/lib/couchdb && \
  touch /var/lib/couchdb/couchdb-not-inited && \
  chown -R couchdb:couchdb /var/lib/couchdb && \
  chown -R couchdb:couchdb /usr/local/etc/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/lib/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/log/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/run/couchdb && \
  chmod -R 0770 /usr/local/etc/couchdb && \
  chmod -R 0770 /usr/local/var/lib/couchdb && \
  chmod -R 0770 /usr/local/var/log/couchdb && \
  chmod -R 0770 /usr/local/var/run/couchdb

RUN \
  apt-get purge -y \
    binutils \
    build-essential \
    cpp \
    make \
    libcurl4-openssl-dev \
    libnspr4-dev \
    perl && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/src/apache*

USER couchdb

ENTRYPOINT ["start_couchdb"]
CMD [""]

EXPOSE 5984

WORKDIR /usr/local/var/lib/couchdb

# Expose our data, logs and configuration volumes
VOLUME ["/usr/local/var/lib/couchdb", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]
