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

# Get some powerline fonts
if [ ! -f ~/.fonts/Liberation\ Mono\ Powerline.ttf ]; then
    git clone https://github.com/powerline/fonts.git /tmp/fonts
    cd /tmp/fonts/LiberationMono
    cp *.ttf ~/.fonts
    cd /tmp/fonts/Hack
    cp *.ttf ~/.fonts
    cd /tmp/fonts/Meslo
    cp *.otf ~/.fonts
fi

# Refresh fonts
fc-cache -vf ~/.fonts/

# Use stow to link dot files in home directory
cd $SCRIPT_DIR/stow
for app in */; do
    stow -t ${HOME} $app
done;

# Set terminal colours to hybrid
/bin/bash $SCRIPT_DIR/hybrid.sh
