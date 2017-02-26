#!/bin/bash

SCRIPTS_DIR=/vagrant/scripts
SERVICES_DIR=/vagrant/services
SERVICE_REGISTRY_API=http://localhost:12001

function startservice {
  SERVICE_DIR=$1
  SERVICE_NAME=$2
  VERSION=sudo cat $SERVICE_DIR/../version.txt
  source $SCRIPTS_DIR/containers/orchestrators/service.sh $SERVICE_NAME $VERSION
}

function startnode {
  source $SCRIPTS_DIR/containers/orchestrators/nodejs.sh
}

startnode

startservice $SERVICES_DIR/service-registry/api/dist service-registry-api
startservice $SERVICES_DIR/service-registry/client/dist service-registry-client

API_STATUS_CODE=$(curl -s -o /dev/null -I -w "%{http_code}" $SERVICE_REGISTRY_API)

if [ "$API_STATUS_CODE" != "200" ]
then
  sleep 2s
fi

startservice $SERVICES_DIR/categories/api/dist categories-api
startservice $SERVICES_DIR/users/api/dist users-api
startservice $SERVICES_DIR/users/client/dist users-client
startservice $SERVICES_DIR/checking-account/api/dist checking-account-api
startservice $SERVICES_DIR/checking-account/client/dist checking-account-client

sleep 1s

startservice /vagrant/application/dist application
