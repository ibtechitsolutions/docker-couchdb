FROM ibtech/couchdb-base:2.1.0

MAINTAINER tecnologia@ibtech.inf.br

RUN usermod -u 10100 couchdb \
 && groupmod -g 10100 couchdb \
 && sed -i 's/\[httpd\]/\[httpd\]\nenable_cors = true/g' /opt/couchdb/etc/local.d/local.ini \
 && printf "[cors]\ncredentials = true\nheaders = accept, authorization, content-type, origin, referer\nmethods = GET,PUT,POST,HEAD,DELETE\norigins = *\n" >> /opt/couchdb/etc/local.d/local.ini
