#!/bin/bash

#install Node
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install -y nodejs-6.9.5

#install compiler
yum install -y gcc-c++ make

#install PM2
npm install -g pm2

#install CouchDB
yum install \
    autoconf autoconf autoconf-archive automake ncurses-devel \
    curl-devel erlang-asn1 erlang-erts erlang-eunit erlang-os_mon \
    erlang-xmerl help2man js-devel libicu-devel libtool perl-Test-Harness

wget http://www.erlang.org/download/otp_src_R14B01.tar.gz
tar -xvf otp_src_R14B01.tar.gz
cd otp_src_R14B01
./configure
make && make install

wget http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz
tar -xvf mozjs17.0.0.tar.gz
cd mozjs17.0.0/js/src/
./configure
make && make install

wget http://apache.forsale.plus/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz
tar -xvf apache-couchdb-2.0.0.tar.gz
cd apache-couchdb-2.0.0
./configure
make && make install

adduser --no-create-home couchdb
chown -R couchdb:couchdb /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb
ln -sf /usr/local/etc/rc.d/couchdb /etc/init.d/couchdb
chkconfig --add couchdb
chkconfig couchdb on

/etc/init.d/couchdb start
/etc/init.d/couchdb status
