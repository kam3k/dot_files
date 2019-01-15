#!/bin/bash

# This downloads and installs Spotify.

# See if Spotify is already installed:
if hash spotify 2>/dev/null; then
  echo "Spotify already installed"
  exit 0
fi

# Add the Spotify repository signing keys to be able to verify downloaded packages
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

# Add the Spotify repository
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Update list of available packages
apt-get update

# Install Spotify
apt-get install -y spotify-client
