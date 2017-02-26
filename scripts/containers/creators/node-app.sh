#!/bin/bash
acbuild begin
acbuild dependency add luca.com/nodejs:latest
acbuild set-name luca.com/$app_name
acbuild label add version $version
acbuild copy "$dist_dir" /dist
acbuild set-exec -- /node /dist/host.js
acbuild write /vagrant/containers/latest/$container_name
acbuild end
