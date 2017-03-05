#!/bin/bash

# install java
yum install -y java-1.8.0-openjdk-src.x86_64

# install xvfb
yum install -y xorg-x11-server-Xvfb.x86_64

# install chrome
curl --silent -L https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -o google-chrome-stable_current_x86_64.rpm
yum install -y google-chrome-stable_current_x86_64.rpm

# curl --silent -L http://chrome.richardlloyd.org.uk/install_chrome.sh -o install_chrome.sh
# chmod u+x install_chrome.sh
# ./install_chrome.sh -f

yum install -y chromedriver.x86_64

# cp /opt/google/chrome/google-chrome /opt/google/chrome/google-chromedriver
# sed -i 's#$HERE/chrome#$HERE/chromedriver#g' /opt/google/chrome/google-chromedriver

# install firefox
# yum install -y firefox.x86_64

# couch dependencies
yum install -y autoconf autoconf-archive automake \
  curl-devel erlang-asn1 erlang-erts erlang-eunit \
  erlang-os_mon erlang-xmerl js-devel-1.8.5 libicu-devel \
  libtool perl-Test-Harness

mkdir ./couchdb
tar xzf /vagrant/dependencies/couchdb/latest/couchdb-2.0.0.tar.gz -C ./couchdb
chown -R vagrant ./couchdb
find ./couchdb -type d -exec chmod 0770 {} \;
chmod 0644 ./couchdb/etc/*

# systemd-run --unit=luca-couchdb ./couchdb/bin/couchdb
setsid ./couchdb/bin/couchdb >/dev/null 2>&1 < /dev/null &
#
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
