FROM couchdb:1.6

MAINTAINER tecnologia@ibtech.inf.br

RUN sed -i 's/\[httpd\]/\[httpd\]\nenable_cors = true/g' /usr/local/etc/couchdb/local.ini \
 && printf "[cors]\norigins = *\n" >> /usr/local/etc/couchdb/local.ini
