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

if [[ ! -a $(which extract) ]]; then
  echo "Error: extract is not installed. Please install extract first."
  exit 1
fi

# Set up tmux plugin manager:
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Get the Base16 colour schemes and select colour scheme
mkdir -p ~/.config
if [ ! -d ~/.config/base16-shell ]; then
	git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
  base16_ocean
fi

# Set up fonts

# Font Awesome (version 4.7)
if [ ! -f ~/.fonts/fontawesome-webfont.ttf ]; then
  curl -fLo /tmp/fontawesome.zip https://fontawesome.com/v4.7.0/assets/font-awesome-4.7.0.zip
	cd /tmp && extract fontawesome.zip
  cp /tmp/fontawesome/font-awesome-4.7.0/fonts/*.ttf ~/.fonts
fi

# Iosevka Term
if [ ! -f ~/.fonts/iosevka-term-regular.ttf ]; then
  curl -fLo /tmp/iosevka-term.zip https://github.com/be6invis/Iosevka/releases/download/v2.0.0/02-iosevka-term-2.0.0.zip
	cd /tmp && extract iosevka-term.zip
  cp /tmp/iosevka-term/ttf/*.ttf ~/.fonts
fi

# Noto Sans
if [ ! -f ~/.fonts/iosevka-term-regular.ttf ]; then
  curl -fLo /tmp/noto-sans.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSans-hinted.zip
	cd /tmp && extract noto-sans.zip
  cp /tmp/noto-sans/*.ttf ~/.fonts
fi

# Set up all of the configs:
cd ${base}/stow

# This for loop iterates through all directories
# contained in the stow directory. This makes
# it easy to add configurations for new applications
# without having to modify this script.
for app in */; do
	stow -t ${HOME} $app
done;
