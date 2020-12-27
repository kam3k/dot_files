#!/bin/zsh

if [[ -a $(which jumpapp) ]]; then
  echo "Jumpapp is already installed."
  exit 0
fi

if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

curl -fLo /tmp/jumpapp.deb https://github.com/mkropat/jumpapp/releases/download/v1.1/jumpapp_1.1-1_all.deb
cd /tmp
apt install ./jumpapp.deb -y
