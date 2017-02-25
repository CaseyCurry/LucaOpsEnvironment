#!/bin/bash

# create container
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../creators/nodejs.sh

# start container
rkt run --net=host --insecure-options=image nodejs-6.9.5-linux-amd64.aci
