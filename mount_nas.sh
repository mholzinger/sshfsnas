#!/bin/bash

# Source post for commands in this script:
# https://susanqq.github.io/jekyll/pixyll/2017/09/05/remotefiles/

# Dependencies required for command to work:

# 1. Homebrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 2. FUSE and SSHFS
# brew cask install osxfuse
# brew install sshfs

# sudo sshfs -o allow_other,defer_permissions mikeholzinger@macmini:/tmp/id/ /tmp/id

JSON_FILE=nas.json

# This function borrowed from:
# https://apple.stackexchange.com/questions/697/how-can-i-mount-an-smb-share-from-the-command-line

function try_samba_mount
{

  # mount volume "smb://user@fqdn1/volume1"
  # mount volume "smb://user@fqdn2/volume2"

  osascript <<EOF
mount volume "$1"
EOF
}


# ----------------- NAS ----------------- #

# NAS address and mount points
nas_mount_points=$(jq '.nas | length' "$JSON_FILE")

for index in $(seq 0 $nas_mount_points)
do
  if [[ $index -eq $nas_mount_points ]]; then continue; fi

  host=$(jq -r .nas[$index].host < nas.json)
  local=$(jq -r .nas[$index].local < nas.json)
  remote=$(jq -r .nas[$index].remote < nas.json)

  echo sudo sshfs -o \
      sshfs_debug,allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa \
      "$(whoami)"@"$host":"$remote" "$local" | sh

#  echo "$index" "\"$host\"" "\"$local\"" "\"$remote\""
done

# ----------------- SMB ----------------- #

# SMB address and mount points
smb_mount_points=$(jq '.smb | length' "$JSON_FILE")

for index in $(seq 0 $smb_mount_points)
do
  if [[ $index -eq $smb_mount_points ]]; then continue; fi

  host=$(jq -r .smb[$index].host < nas.json)
  remote=$(jq -r .smb[$index].remote < nas.json)

  echo "$index" "\"$host\"" "\"$local\"" "\"$remote\""

  try_samba_mount "smb://$USER@$host/$remote"

done
