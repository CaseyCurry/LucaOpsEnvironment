#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# create container
source $SCRIPT_DIR/../creators/nodejs.sh

# start container
systemd-run rkt run --net=host --insecure-options=image \
  /vagrant/containers/latest/nodejs-6.9.5-linux-amd64.aci
