#!/bin/bash

yum install -y epel-release
yum -y update

# rkt
sed -i'' 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
setenforce Permissive
cp /vagrant/dependencies/cbs-rkt.repo /etc/yum.repos.d/cbs-rkt.repo
yum install -y rkt

# acbuild
tar xf /vagrant/dependencies/acbuild-v0.4.0.tar.gz
cp acbuild-v0.4.0/* /usr/bin/
rm -rf acbuild-v0.4.0

# node
# curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
# yum install -y nodejs-6.9.5

# # pm2
# npm install -g pm2

# couch dependencies
yum install -y autoconf autoconf-archive automake \
  curl-devel erlang-asn1 erlang-erts erlang-eunit \
  erlang-os_mon erlang-xmerl js-devel-1.8.5 libicu-devel \
  libtool perl-Test-Harness

mkdir ./couchdb
tar xzf /vagrant/dependencies/couchdb-2.0.0.tar.gz -C ./couchdb
chown -R vagrant ./couchdb
find ./couchdb -type d -exec chmod 0770 {} \;
chmod 0644 ./couchdb/etc/*

setsid ./couchdb/bin/couchdb >/dev/null 2>&1 < /dev/null &

sleep 2s

curl -X POST \
     -H 'Content-Type: application/json' \
     -d '{"action":"enable_cluster","username":"admin","password":"admin","bind_address":"0.0.0.0","port":"5984"}' \
     http://127.0.0.1:5984/_cluster_setup
curl -X PUT http://admin:admin@127.0.0.1:5984/_users
curl -X PUT http://admin:admin@127.0.0.1:5984/_replicator
curl -X PUT http://admin:admin@127.0.0.1:5984/_global_changes
