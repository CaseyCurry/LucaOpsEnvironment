#!/bin/bash

SERVICE_NAME=$1
VERSION=$2
CONTAINER_NAME=$SERVICE_NAME-$VERSION-linux-amd64.aci

# manage container creation
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/version.sh \
  $SERVICE_NAME $VERSION $CONTAINER_NAME

# start container
systemd-run rkt run --net=host --insecure-options=image \
  $SCRIPT_DIR/../../../containers/latest/$CONTAINER_NAME
