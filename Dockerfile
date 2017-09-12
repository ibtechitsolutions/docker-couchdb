FROM ibtech/couchdb-base:2.1.0

MAINTAINER tecnologia@ibtech.inf.br

RUN usermod -u 10100 couchdb \
 && groupmod -g 10100 couchdb \
 && printf "[httpd]\nenable_cors = true\n\n[cors]\ncredentials = true\nheaders = accept, authorization, content-type, origin, referer\nmethods = GET,PUT,POST,HEAD,DELETE\norigins = *\n" >> /opt/couchdb/etc/local.d/local.ini

COPY couchdb-setup-singlenode.sh /couchdb-setup-singlenode.sh