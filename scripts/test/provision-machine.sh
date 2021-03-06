#!/bin/bash

yum clean all

# install chrome
cp /vagrant/dependencies/chrome/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
yum install -y google-chrome-stable

# install firefox
yum install -y firefox.x86_64

# install xvfb
yum install -y xorg-x11-server-Xvfb.x86_64

# install couchdb
yum install -y autoconf autoconf-archive automake \
  curl-devel erlang-asn1 erlang-erts erlang-eunit \
  erlang-os_mon erlang-xmerl js-devel-1.8.5 libicu-devel \
  libtool perl-Test-Harness

mkdir ./couchdb
tar xzf /vagrant/dependencies/couchdb/latest/couchdb-2.0.0.tar.gz -C ./couchdb
chown -R vagrant ./couchdb
find ./couchdb -type d -exec chmod 0770 {} \;
chmod 0644 ./couchdb/etc/*

# start couchdb
# systemd-run --unit=luca-couchdb ./couchdb/bin/couchdb
setsid ./couchdb/bin/couchdb >/dev/null 2>&1 < /dev/null &

# sleep 2s
#
# curl -X POST \
#      -H 'Content-Type: application/json' \
#      -d '{"action":"enable_cluster","username":"admin","password":"admin","bind_address":"0.0.0.0","port":"5984"}' \
#      http://127.0.0.1:5984/_cluster_setup
# curl -X PUT http://admin:admin@127.0.0.1:5984/_users
# curl -X PUT http://admin:admin@127.0.0.1:5984/_replicator
# curl -X PUT http://admin:admin@127.0.0.1:5984/_global_changes
#
# curl -X PUT \
#      -H "Content-Type: application/json" \
#      -d '"vagrant"' \
#      http://admin:admin@127.0.0.1:5984/_node/couchdb@localhost/_config/admins/vagrant
