#!/bin/bash
sudo acbuild begin
sudo acbuild dependency add luca.com/nodejs:6.9.5
sudo acbuild set-name luca.com/service-registry-api
sudo acbuild label add version 1.0.0
sudo acbuild copy /vagrant/dist /dist
sudo acbuild set-exec -- /node /dist/host.js
sudo acbuild write service-registry-api-1.0.0-linux-amd64.aci
sudo acbuild end
