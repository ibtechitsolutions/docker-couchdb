# CouchDB Dockerfile

A Dockerfile that produces a Docker image for [Apache CouchDB](http://couchdb.apache.org/).

It is based on the [Ferran Rodenas's version](https://github.com/frodenas/docker-couchdb) but includes the following changes and improvements:

  - adds sample CORS configuration to CouchDB,
  - runs everything as user `couchdb`,
  - uses the most recent version of CouchDB (1.6.1 instead of 1.6),
  - is based on Debian Wheezy (instead of Ubuntu),
  - its Docker image is smaller.

## CouchDB version

The `master` branch currently hosts CouchDB 1.6.1.

## Usage

### Build the image

To create the image `kobretti/couchdb-cors`, execute the following command on the `docker-couchdb` directory:

```
$ docker build -t kobretti/couchdb-cors .
```

### Run the image

To run the image and bind to host port 5984:

```
$ docker run -d --name couchdb -p 5984:5984 kobretti/couchdb-cors
```

The first time you run your container, a new user `couchdb` with all privileges will be created with a random password.
To get the password, check the logs of the container by running:

```
docker logs <CONTAINER_ID>
```

You will see an output like the following:

```
========================================================
CouchDB User: "couchdb"
CouchDB Password: "jPp5fBJySeuJPTN8"
========================================================
```

#### Credentials

If you want to preset credentials instead of a random generated ones, you can set the following environment variables:

* `COUCHDB_USERNAME` to set a specific username
* `COUCHDB_PASSWORD` to set a specific password

On this example we will preset our custom username and password:

```
$ docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -e COUCHDB_USERNAME=myusername \
    -e COUCHDB_PASSWORD=mypassword \
    kobretti/couchdb-cors
```

#### Databases

If you want to create a database at container's boot time, you can set the following environment variables:

* `COUCHDB_DBNAME` to create a database

On this example we will preset our custom username and password and we will create a database:

```
$ docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -e COUCHDB_USERNAME=myusername \
    -e COUCHDB_PASSWORD=mypassword \
    -e COUCHDB_DBNAME=mydb \
    kobretti/couchdb-cors
```

#### Persistent data

The CouchDB server is configured to store data in the `/usr/local/var/lib/couchdb/` directory inside the container. You can map this path to a volume on the host so the data becomes independent of the running container:

```
$ mkdir -p /tmp/couchdb
$ docker run -d \
    --name couchdb \
    -p 5984:5984 \
    -v /tmp/couchdb:/usr/local/var/lib/couchdb \
    kobretti/couchdb-cors
```

## Copyright

Copyright (c) 2014 Ferran Rodenas, 2015 Krzysztof Kobrzak.  See [LICENCE](https://github.com/chris-kobrzak/docker-couchdb/blob/master/LICENCE) for details.
