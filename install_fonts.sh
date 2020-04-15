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

# Font Awesome (version 4.7)
fontawesome_4_file="FontAwesome.otf"
if [[ ! -f ${fonts}/$fontawesome_4_file ]]; then
  curl -fLo /tmp/font-awesome-4.7.0.zip https://fontawesome.com/v4.7.0/assets/font-awesome-4.7.0.zip
  cd /tmp && unzip font-awesome-4.7.0.zip
  cp /tmp/font-awesome-4.7.0/fonts/*.otf ${fonts}
fi

# Iosevka Term
if [ ! -f ${fonts}/iosevka-term-regular.ttf ]; then
  curl -fLo /tmp/iosevka-term.zip https://github.com/be5invis/Iosevka/releases/download/v2.0.0/02-iosevka-term-2.0.0.zip
  cd /tmp && unzip iosevka-term.zip -d iosevka-term
  cp /tmp/iosevka-term/ttf/*.ttf ${fonts}
fi

# Noto Sans
if [ ! -f ${fonts}/NotoSans-Regular.ttf ]; then
  curl -fLo /tmp/noto-sans.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSans-hinted.zip
  cd /tmp && unzip noto-sans.zip -d noto-sans
  cp /tmp/noto-sans/*.ttf ${fonts}
fi

# Refresh font cache
fc-cache

