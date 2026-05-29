#!/bin/bash

if [[ ! -x $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

if [[ ! -x $(which unzip) ]]; then
  echo "Error: unzip is not installed. Please install unzip first."
  exit 1
fi

# Set up font directory
declare fonts=${HOME}/.local/share/fonts
if [ ! -d "${fonts}" ]; then
  mkdir -p "${fonts}"
fi

# Iosevka Term Nerd Font
if [ ! -f "${fonts}/IosevkaTermNerdFont-Regular.ttf" ]; then
  echo "Downloading Iosevka Term Nerd Font..."
  curl -fLo /tmp/iosevka-term-nerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/IosevkaTerm.zip
  
  echo "Extracting fonts..."
  cd /tmp && unzip -o iosevka-term-nerd.zip -d iosevka-term-nerd
  
  # Copy over the TrueType files (.ttf) to your local font configuration directory
  cp /tmp/iosevka-term-nerd/*.ttf "${fonts}/"
  
  # Clean up the /tmp workspace
  rm -rf /tmp/iosevka-term-nerd.zip /tmp/iosevka-term-nerd
fi

# Refresh font cache
echo "Refreshing system font cache..."
fc-cache -f

echo "Installation complete!"
