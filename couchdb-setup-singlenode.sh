#!/bin/sh

if [ "$1" = "--sleep" ]
then
        sleep 5
fi

STATUS_DBUSER=`curl -s -I --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_users | head -n 1 | awk '{print $2}'`
STATUS_DBREPLICATOR=`curl -s -I --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_replicator | head -n 1 | awk '{print $2}'`
STATUS_DBGLOBALCHANGES=`curl -s -I --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_global_changes | head -n 1 | awk '{print $2}'`

if [ "$STATUS_DBUSER" = "404" ]
then
        curl -X PUT --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_users
fi

if [ "$STATUS_DBREPLICATOR" = "404" ]
then
        curl -X PUT --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_replicator
fi

if [ "$STATUS_DBGLOBALCHANGES" = "404" ]
then
        curl -X PUT --user "$COUCHDB_USER:$COUCHDB_PASSWORD" http://127.0.0.1:5984/_global_changes
fi
