#!/bin/bash

# Get directory of this script
export SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Make sure stow is installed
hash stow 2>/dev/null || { echo "Error: stow is not installed. Please install stow first."; exit 1;}

# Install vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Use stow to link dot files in home directory
cd $SCRIPT_DIR/stow
for app in */; do
    stow -t ${HOME} $app
done;

# Set terminal colours to hybrid
wget -O xt  http://git.io/v3D4d && chmod +x xt && ./xt && rm xt
