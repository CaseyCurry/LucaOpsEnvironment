#!/bin/bash
acbuild begin
acbuild set-name luca.com/$app_name
acbuild label add version "latest"
acbuild copy /vagrant/dependencies/$app_name/latest/$app_name-$version /node
acbuild set-exec -- /node -v
acbuild write /vagrant/containers/latest/$container_name
acbuild end
