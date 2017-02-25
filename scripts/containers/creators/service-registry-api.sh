#!/bin/bash
acbuild begin
acbuild dependency add luca.com/nodejs:6.9.5
acbuild set-name luca.com/service-registry-api
acbuild label add version 1.0.0
acbuild copy /vagrant/dist /dist
acbuild set-exec -- /node /dist/host.js
acbuild write service-registry-api-1.0.0-linux-amd64.aci
acbuild end
