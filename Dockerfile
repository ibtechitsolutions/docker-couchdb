FROM debian:wheezy

MAINTAINER Krzysztof Kobrzak <chris.kobrzak@gmail.com>

ENV COUCHDB_VERSION 1.6.1

# CouchDB dependencies and required utilities
RUN DEBIAN_FRONTEND=noninteractive && \
  apt-get update -y && \
  apt-get install -y --force-yes --no-install-recommends \
    build-essential \
    pwgen \
    netcat \
    wget \
    curl \
    erlang-dev \
    erlang-nox \
    libmozjs185-1.0 \
    libmozjs185-dev \
    libcurl4-openssl-dev \
    libicu-dev

# CouchDB installation from source
RUN DEBIAN_FRONTEND=noninteractive && \
  cd /usr/src && \
  wget -nv http://mirror.ox.ac.uk/sites/rsync.apache.org/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz && \
  tar -xzf apache-couchdb-$COUCHDB_VERSION.tar.gz && \
  cd /usr/src/apache-couchdb-$COUCHDB_VERSION && \
  ./configure && \
  make --quiet && \
  make install && \
  sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i /usr/local/etc/couchdb/default.ini

# CORS support in CouchDB
RUN sed -i '/\[httpd\]/a enable_cors=true' /usr/local/etc/couchdb/local.ini && \
 echo '[cors] \
  \norigins = * \
  \ncredentials = true \
  \nheaders = accept, authorization, content-type, origin, referer \
  \nmethods = GET, PUT, POST, HEAD' >> /usr/local/etc/couchdb/local.ini

RUN groupadd -r couchdb && \
  useradd -d /usr/local/var/lib/couchdb -g couchdb couchdb

ADD scripts /usr/local/scripts

RUN touch /usr/local/scripts/couchdb-not-inited && \
  chmod +x /usr/local/scripts/*.sh && \
  chown -R couchdb:couchdb /usr/local/scripts && \
  mkdir /var/lib/couchdb && \
  chown -R couchdb:couchdb /var/lib/couchdb && \
  chown -R couchdb:couchdb /usr/local/etc/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/lib/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/log/couchdb && \
  chown -R couchdb:couchdb /usr/local/var/run/couchdb && \
  chmod -R 0770 /usr/local/etc/couchdb && \
  chmod -R 0770 /usr/local/var/lib/couchdb && \
  chmod -R 0770 /usr/local/var/log/couchdb && \
  chmod -R 0770 /usr/local/var/run/couchdb

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/src/apache*

USER couchdb

ENTRYPOINT ["/usr/local/scripts/start_couchdb.sh"]
CMD [""]

EXPOSE 5984

WORKDIR /usr/local/scripts

# Expose our data, logs and configuration volumes
VOLUME ["/usr/local/var/lib/couchdb", "/usr/local/var/log/couchdb", "/usr/local/etc/couchdb"]
