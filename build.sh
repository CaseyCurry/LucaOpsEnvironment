#!/bin/bash
vagrant ssh

#install node
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
yum install -y nodejs-6.9.5

logout
