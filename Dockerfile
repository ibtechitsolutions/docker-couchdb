FROM couchdb:1.6

MAINTAINER tecnologia@ibtech.inf.br

RUN usermod -u 10100 couchdb \
 && groupmod -g 10100 couchdb \
 && sed -i 's/\[httpd\]/\[httpd\]\nenable_cors = true/g' /usr/local/etc/couchdb/local.ini \
 && printf "[cors]\ncredentials = true\nheaders = accept, authorization, content-type, origin, referer\nmethods = GET,PUT,POST,HEAD,DELETE\norigins = *\n" >> /usr/local/etc/couchdb/local.ini
