#!/bin/bash

yum install -y epel-release
yum -y update

#install node
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install -y nodejs-6.9.5

#install compiler
yum install -y gcc-c++ make

#install pm2
npm install -g pm2

#install couch
yum install -y \
  autoconf autoconf-archive automake \
  curl-devel erlang-asn1 erlang-erts erlang-eunit \
  erlang-os_mon erlang-xmerl help2man \
  js-devel-1.8.5 libicu-devel libtool perl-Test-Harness \
  erlang

cp -R /vagrant/resources/couchdb /home/vagrant
chown -R vagrant /home/vagrant/couchdb
find /home/vagrant/couchdb -type d -exec chmod 0770 {} \;
chmod 0644 /home/vagrant/couchdb/etc/*

# start couch
setsid couchdb/bin/couchdb >/dev/null 2>&1 < /dev/null &

sleep 3s

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"action":"enable_cluster","username":"admin","password":"admin","bind_address":"0.0.0.0","port":"5984"}' \
     http://127.0.0.1:5984/_cluster_setup
curl -X PUT http://admin:admin@127.0.0.1:5984/_users
curl -X PUT http://admin:admin@127.0.0.1:5984/_replicator
curl -X PUT http://admin:admin@127.0.0.1:5984/_global_changes
