#!/usr/bin/env bash

if [[ -e /usr/local/scripts/couchdb-not-inited ]]; then
  echo "Initialising CouchDB..."
  /usr/local/scripts/initialise_couchdb.sh
fi

echo "Starting CouchDB..."
/usr/local/bin/couchdb