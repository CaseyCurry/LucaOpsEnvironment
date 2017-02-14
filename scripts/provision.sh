#!/bin/bash
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install -y nodejs-6.9.5
yum install -y gcc-c++ make
npm install -g pm2
