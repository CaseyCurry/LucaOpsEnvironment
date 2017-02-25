#!/bin/bash
sudo acbuild begin
sudo acbuild set-name luca.com/nodejs
sudo acbuild label add version "6.9.5"
sudo acbuild copy /vagrant/dependencies/node-v6.9.5-statically-linked-linux-x64 \
  /node
sudo acbuild set-exec -- /node -v
sudo acbuild write nodejs-6.9.5-linux-amd64.aci
sudo acbuild end
