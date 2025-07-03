#!/bin/bash

# Check for required dependencies before continuing:
if [[ ! -a $(which git) ]]; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

if [[ ! -a $(which stow) ]]; then
  echo "Error: stow is not installed. Please install stow first."
  exit 1
fi

if [[ ! -a $(which vim) ]]; then
  echo "Error: vim is not installed. Please install vim first."
  exit 1
fi

# Symlink everything in stow directory to home directory
cd ${HOME}/.dot/stow
for app in */; do
  stow -t ${HOME} $app
done;

# Install starship (prompt)
curl -sS https://starship.rs/install.sh > /tmp/starship_install.sh
mkdir -p ~/.local/bin
sh /tmp/starship_install.sh -y -b ~/.local/bin

# Install vim plugins
vim +PlugInstall +qall

# Compile YouCompleteMe
~/.vim/plugged/YouCompleteMe/install.py --clangd-completer
