#!/bin/bash

# Install vundle
if [ ! -d ~/.vim/bundle/vundle ]; then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi

# Get fontawesome
if [ ! -f ~/.fonts/fontawesome-webfont.ttf ]; then
    curl -fLo ~/.fonts/fontawesome-webfont.ttf --create-dirs https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf
    fc-cache -vf ~/.fonts/
fi

# Get hack (font)
if [ ! -f ~/.fonts/Hack-Regular.ttf ]; then
    curl -fLo ~/.fonts/Hack-Regular.ttf https://github.com/powerline/fonts/blob/master/Hack/Hack-Regular.ttf
    fc-cache -vf ~/.fonts/
fi

# Make sure stow is installed
hash stow 2>/dev/null || { echo "Error: stow is not installed. Please install stow first."; exit 1;}

# Use stow to link dot files in home directory
cd ~/dot_files/stow
for app in */; do
	stow -t ${HOME} $app
done;
