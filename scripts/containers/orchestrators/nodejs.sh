#!/bin/bash

# create container
source ${BASH_SOURCE[0]/../creators/nodejs.sh}

# start container
rkt run --net=host --insecure-options=image nodejs-6.9.5-linux-amd64.aci
