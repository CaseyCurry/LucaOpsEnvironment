#!/bin/bash
acbuild begin
acbuild set-name luca.com/nodejs
acbuild label add version "latest"
acbuild copy /vagrant/dependencies/node-v6.9.5-statically-linked-linux-x64 \
  /node
acbuild set-exec -- /node -v
acbuild write /vagrant/containers/latest/nodejs-6.9.5-linux-amd64.aci
acbuild end
