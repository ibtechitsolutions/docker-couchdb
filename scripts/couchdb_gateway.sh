#!/usr/bin/env bash

startCouchDbInBackground() {
  /usr/local/bin/couchdb -b
}

stopCouchDb() {
  /usr/local/bin/couchdb -d
}

isCouchDbRunnning() {
  numericRegEx="^[0-9]+$"
  if [ -n $1 ] && [[ $1 =~ $numericRegEx ]]; then
    port=$1
  else
    port=$PORT
  fi
  nc -z $IP_ADDRESS $port
  return $?
}

waitForCouchDb() {
  while ! isCouchDbRunnning $1; do
    sleep 1;
  done
}

createCouchDbUser() {
  curl -X PUT http://$IP_ADDRESS:$PORT/_config/admins/$USER -d '"'${PASS}'"'
}

createCouchDbDatabase() {
  curl -X PUT http://$USER:$PASS@$IP_ADDRESS:$PORT/$DB
}

createCouchDbDatabaseWithoutCredentials() {
  curl -X PUT http://$IP_ADDRESS:$PORT/$DB
}

setGeneratedPassword() {
  PASS=$(pwgen -s -1 16)
}
