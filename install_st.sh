#!/bin/bash

# This script downloads, configures, and builds simple terminal
# Adapted from script by John Daly (github.com/jmdaly)

# First, install the build dependencies
apt-get install -y libxft-dev curl make gcc libxext-dev

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
SRC_PREFIX=${USER_HOME}/.local/src
ST_VERSION=0.8.4

# Get the source
if [ ! -d ${SRC_PREFIX}/st-${ST_VERSION} ]; then
  curl -fLo /tmp/st-${ST_VERSION}.tar.gz http://dl.suckless.org/st/st-${ST_VERSION}.tar.gz
  mkdir -p ${SRC_PREFIX}
  cd ${SRC_PREFIX} && tar xvzf /tmp/st-${ST_VERSION}.tar.gz
fi

# Copy over my custom config
if [ -f ${USER_HOME}/.dot/st/config.def.h ]; then
  cp ${USER_HOME}/.dot/st/config.def.h ${SRC_PREFIX}/st-${ST_VERSION}/config.h
fi

cd ${SRC_PREFIX}/st-${ST_VERSION}
make clean install && make clean
