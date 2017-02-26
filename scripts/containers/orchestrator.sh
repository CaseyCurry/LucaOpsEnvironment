#!/bin/bash

container_name=$app_name-$version-linux-amd64.aci
history_dir=/vagrant/containers/history
latest_dir=$history_dir/../latest

# if the latest is this version
if [ ! -e $latest_dir/$container_name ]
then
  # move latest to history to make room for new version
  for file in "$latest_dir/$app_name"*
  do
    if [ -e "$file" ]
    then
      mv -f "$file" "$history_dir"
    fi
  done
  # create the new version
  source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/creators/$creator
fi

# start container
systemd-run rkt run --net=host --insecure-options=image \
  /vagrant/containers/latest/$container_name
