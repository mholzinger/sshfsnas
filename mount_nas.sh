#!/bin/bash

# Source post for commands in this script:
# https://susanqq.github.io/jekyll/pixyll/2017/09/05/remotefiles/

# Dependencies required for command to work:

# 1. Homebrew
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 2. FUSE and SSHFS
# brew cask install osxfuse
# brew install sshfs

# sudo sshfs -o allow_other,defer_permissions user@host:/tmp/id/ /tmp/id

JSON_FILE=nas.json

# NAS address and mount points
mount_points=$(jq '.[] | length' "$JSON_FILE")

for index in $(seq 0 ${#mount_points[@]})
do
  host=$(jq -r .nas[$index].host < nas.json)
  local=$(jq -r .nas[$index].local < nas.json)
  remote=$(jq -r .nas[$index].remote < nas.json)

  echo sudo sshfs -o \
      sshfs_debug,allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa \
      "$(whoami)"@"$host":"$remote" "$local" | sh
done
