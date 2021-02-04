#!/bin/bash

# This script downloads and installs my custom patched dwm

# Install the build dependencies
apt-get install -y libx11-dev libxft-dev libxinerama-dev git make gcc

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
SRC_PREFIX=${USER_HOME}/.local/src

# Clone the source
if [ ! -d ${SRC_PREFIX}/dwm-flexipatch ]; then
  mkdir -p ${SRC_PREFIX}
  cd ${SRC_PREFIX}
  git clone https://github.com/kam3k/dwm-flexipatch 
fi

cd ${SRC_PREFIX}/dwm-flexipatch
make clean install && make clean
