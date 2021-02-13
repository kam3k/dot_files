#!/bin/bash

# This script downloads and installs my patched suckless applications 
# (dwm, st, dmenu, slock)

SRC_PREFIX=${HOME}/.local/src

# Create source directory
if [ ! -d ${SRC_PREFIX} ]; then
  mkdir -p ${SRC_PREFIX}
fi

# Specify names of applications to install
apps=("dwm" "st" "dmenu" "slock")

# Clone and install each application
for app in ${apps[*]}; do
  if [ ! -d ${SRC_PREFIX}/${app}-flexipatch ]; then
    cd ${SRC_PREFIX}
    git clone https://github.com/kam3k/${app}-flexipatch 
  fi
  cd ${SRC_PREFIX}/${app}-flexipatch
  make clean install && make clean
done
