#!/bin/bash

# Get directory of this script
export SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Make sure stow is installed
hash stow 2>/dev/null || { echo "Error: stow is not installed. Please install stow first."; exit 1;}

# Install vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Get fontawesome
if [ ! -f ~/.fonts/fontawesome-webfont.ttf ]; then
    curl -fLo ~/.fonts/fontawesome-webfont.ttf --create-dirs https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf
fi

# Get Hack
if [ ! -f ~/.fonts/Hack-Regular.ttf ]; then
    echo "Hack download not setup yet."
fi

# Refresh fonts
fc-cache -vf ~/.fonts/

# Use stow to link dot files in home directory
cd $SCRIPT_DIR/stow
for app in */; do
    stow -t ${HOME} $app
done;
