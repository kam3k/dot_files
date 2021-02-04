#!/bin/zsh

if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

if [[ ! -a $(which unzip) ]]; then
  echo "Error: unzip is not installed. Please install unzip first."
  exit 1
fi

# Set up font directory
declare fonts=${HOME}/.local/share/fonts
if [ ! -d ${fonts} ]; then
  mkdir -p ${fonts}
fi

# Iosevka Term
if [ ! -f ${fonts}/iosevka-term-regular.ttf ]; then
  curl -fLo /tmp/iosevka-term.zip https://github.com/be5invis/Iosevka/releases/download/v4.5.0/ttf-iosevka-term-4.5.0.zip
  cd /tmp && unzip iosevka-term.zip -d iosevka-term
  cp /tmp/iosevka-term/ttf/*.ttf ${fonts}
fi

# Refresh font cache
fc-cache

