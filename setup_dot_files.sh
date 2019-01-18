#!/bin/zsh

# This script sets up symlinks to all the dotfiles
# in the user's home directory.

declare base=${HOME}/.dot

# Check for required dependencies before continuing:
if [[ ! -a $(which git) ]]; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

if [[ ! -a $(which stow) ]]; then
  echo "Error: stow is not installed. Please install stow first."
  exit 1
fi

if [[ ! -a $(which unzip) ]]; then
  echo "Error: unzip is not installed. Please install unzip first."
  exit 1
fi

# Set up tmux plugin manager
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set up font directory
declare fonts=${HOME}/.local/share/fonts
if [ ! -d ${fonts} ]; then
  mkdir -p ${fonts}
fi

# Font Awesome (version 4.7)
if [ ! -f ${fonts}/fontawesome-webfont.ttf ]; then
  curl -fLo /tmp/fontawesome.zip https://fontawesome.com/v4.7.0/assets/font-awesome-4.7.0.zip
  cd /tmp && unzip fontawesome.zip -d fontawesome
  cp /tmp/fontawesome/font-awesome-4.7.0/fonts/*.ttf ${fonts}
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
fc-cache -v

# Symlink everything in stow directory to home directory
cd ${base}/stow
for app in */; do
	stow -t ${HOME} $app
done;
