#!/bin/bash

# Script to unmount local network shares

# As a Oneliner
# sudo diskutil umount force  /Users/"$(whoami)"/Volumes/Share

JSON_FILE=nas.json

check_umount_err(){ error_state=$(echo $?)
if [[ "$error_state" != "0" ]];then
    sudo diskutil umount force "$1"
fi
}

# Capture array of mounted volumes
host_list=($(jq -r '.[] | .[] | .host' "$JSON_FILE" |sort -u))

for index in $(seq ${#host_list[@]})
do
  volumes=($(mount |\
    grep "$(whoami)"@"${host[@]}" |\
    cut -d '(' -f 1|\
    awk '{print $NF}'))

    for node in "${volumes[@]}"
    do
      sudo diskutil umount "$node"
      check_umount_err "$node"
    done
done
