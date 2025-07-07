#!/bin/bash

# Check for required dependencies before continuing:
if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
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
cd ${HOME}/shared/dot/stow
for app in */; do
  stow -t ${HOME} $app
done;

# Install starship (prompt)
curl -sS https://starship.rs/install.sh > /tmp/starship_install.sh
mkdir -p ~/.local/bin
sh /tmp/starship_install.sh -y -b ~/.local/bin


# Install zellij (multiplexer)
curl -fLo /tmp/zellij.tar.gz https://github.com/zellij-org/zellij/releases/download/v0.42.2/zellij-x86_64-unknown-linux-musl.tar.gz
cd /tmp
tar -xzf zellij.tar.gz
mv zellij ~/.local/bin

# Install btop
curl -fLo btop.tbz https://github.com/aristocratos/btop/releases/download/v1.4.4/btop-x86_64-linux-musl.tbz
cd /tmp
tar -xjf btop.tbz
mv btop/bin/btop ~/.local/bin

# Install matplot++
curl -fLo /tmp/matplot.sh https://github.com/alandefreitas/matplotplusplus/releases/download/v1.1.0/matplotplusplus-1.1.0-Linux.sh
sudo sh /tmp/matplot.sh --prefix=/usr/local --skip-license --exclude-subdir

# Install vim plugins
vim +PlugInstall +qall

# Compile YouCompleteMe
~/.vim/plugged/YouCompleteMe/install.py --clangd-completer
