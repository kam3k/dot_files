#!/bin/bash

# This script downloads and installs my custom patched slock

# Install the build dependencies
apt-get install -y libxext-dev libxrandr-dev libimlib2-dev git make gcc

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
SRC_PREFIX=${USER_HOME}/.local/src

# Clone the source
if [ ! -d ${SRC_PREFIX}/slock-flexipatch ]; then
  mkdir -p ${SRC_PREFIX}
  cd ${SRC_PREFIX}
  git clone https://github.com/kam3k/slock-flexipatch 
fi

cd ${SRC_PREFIX}/slock-flexipatch
make clean install && make clean
