#!/bin/bash

SERVICE_NAME=$1
VERSION=$2

acbuild begin
acbuild dependency add luca.com/$SERVICE_NAME:latest
acbuild set-name luca.com/$SERVICE_NAME
acbuild label add version $VERSION
acbuild copy /vagrant/$SERVICE_NAME/dist /dist
acbuild set-exec -- /node /dist/host.js
acbuild write /vagrant/containers/latest/$SERVICE_NAME-$VERSION-linux-amd64.aci
acbuild end
