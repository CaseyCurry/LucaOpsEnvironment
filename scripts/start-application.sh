#!/bin/bash

orchestrator=/vagrant/scripts/containers/orchestrator.sh
services_dir=/vagrant/services
application_dir=/vagrant/application
dependecies_dir=/vagrant/dependencies

function startapp {
  dist_dir=$1
  app_name=$2
  version=`sudo cat "$dist_dir/../version.txt"`
  creator="node-app.sh"
  source $orchestrator
}

function startnode {
  app_name="nodejs"
  version="6.9.5"
  creator="nodejs.sh"
  source $orchestrator
}

startnode

sleep 1s

startapp "$services_dir/service-registry/api/dist" service-registry-api
startapp "$services_dir/service-registry/client/dist" service-registry-client
startapp "$services_dir/categories/api/dist" categories-api
startapp "$services_dir/users/api/dist" users-api
startapp "$services_dir/users/client/dist" users-client
startapp "$services_dir/checking-account/api/dist" checking-account-api
startapp "$services_dir/checking-account/client/dist" checking-account-client

sleep 1s

startapp "$application_dir/dist" application
