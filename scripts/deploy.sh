#!/bin/bash

# aws ec2 describe-instances --filter Name=tag:Name,Values=Luca --output text --query 'Reservations[*].Instances[*].State.Name'
#
# INSTANCE=$(aws ec2 describe-instances --filter Name=tag:Name,Values=Luca --output text --query 'Reservations[*].Instances[0].InstanceId'); who | aws ec2 start-instance --instance-ids "${INSTANCE#}"
#
# ssh -i ~/Documents/LucaInstance.pem centos@34.213.168.62
#
# scp -i ~/Documents/LucaInstance.pem ~/Documents/test centos@34.213.168.62:~/
#
# IP=$(aws ec2 describe-instances --filter Name=tag:Name,Values=Luca --output text --query 'Reservations[*].Instances[0].PublicIpAddress'); who | scp -o StrictHostKeyChecking=no -i ~/Documents/LucaInstance.pem test2 centos@"${IP#}":~
#
# if [ -z `ssh-keygen -F $IP` ]; then
#   ssh-keyscan -H $IP >> ~/.ssh/known_hosts
# fi

function get_instance_id {
  # if there are multiple instance where Name=Luca, this only selects the first instance; see the query argument
  instance_id=`aws ec2 describe-instances --filter Name=tag:Name,Values=Luca --output text --query 'Reservations[*].Instances[0].InstanceId'`
  echo instance_id: $instance_id
}

function get_ip_address {
  ip=`aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].PublicIpAddress'`

  if [ -z "$ip" ]
  then
    echo sleeping until ip address is assigned
    sleep 5s
    get_ip_address
  else
    echo ip: $ip
  fi
}

function get_instance_state {
  state=`aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'`
  echo state: $state
}

function start_instance {
  try_count=$((try_count + 1))
  echo try_count: $try_count

  # do not recurse endlessly
  if [ $try_count -gt 5 ]
  then
    echo ERROR: The instance could not be started.
    exit 1
  fi

  if [ "$state" = "running" ]
  then
    # do nothing
    echo the instance is already running
  elif [ "$state" = "stopped" ]
  then
    # start instance
    echo starting instance
    aws ec2 start-instances --instance-ids $instance_id
    echo started
  else
    # pause, re-check status, and try again
    echo sleeping until instance is started
    sleep $((10 * try_count))s
    get_instance_state
    start_instance
  fi
}

function transfer_containers {
  # if [ -z "`ssh-keygen -F $ip`" ]
  # then
  #   remove_host_after_transfer=true
  #   echo adding $ip to known_hosts
  #   ssh-keyscan -H -t rsa $ip >> /Users/caseycurry/.ssh/known_hosts
  # fi
  #
  # echo transferring containers
  # rsync -av --delete --progress --ignore-existing -e 'ssh -i /Users/caseycurry/Documents/LucaInstance.pem' '$directory_to_transfer' centos@$ip:~/containers
  # echo transferred
  #
  # if [ $remove_host_after_transfer ]
  # then
  #   echo removing $ip from known_hosts
  #   ssh-keygen -R $ip -f /Users/caseycurry/.ssh/known_hosts
  # fi
  scp -o StrictHostKeyChecking=no -i /Users/caseycurry/Documents/LucaInstance.pem '$directory_to_transfer' centos@$ip:~/containers
}

directory_to_transfer=`pwd`/$1
echo $directory_to_transfer
get_instance_id
get_instance_state

if [ "$state" = "terminated" ]
then
  echo ERROR: The instance is terminated.
  exit 1
fi

initial_state=$state
try_count=0
start_instance
get_ip_address
transfer_containers

# leave the machine in the same state it was found
if [ "$initial_state" != "running" ] &&
   [ "$initial_state" != "pending" ]
then
  echo stopping instance
  aws ec2 stop-instances --instance-ids $instance_id
  echo stopped
fi
