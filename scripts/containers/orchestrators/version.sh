#!/bin/bash

SERVICE_NAME=$1
VERSION=$2
CONTAINER_NAME=$3
CONTAINER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../../../containers
HISTORY_DIR=$CONTAINER_DIR/history
LATEST_DIR=$CONTAINER_DIR/latest

# if the latest is not this version
if [ ! -e $LATEST_DIR/$CONTAINER_NAME ]
then
  # move existing latest to HISTORY_DIR
  mv -f $LATEST_DIR/$SERVICE_NAME* -t $HISTORY_DIR
  # create the container
  source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../service.sh $SERVICE_NAME $VERSION
fi

#start latest
