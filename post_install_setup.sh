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

if [[ ! -a $(which tmux) ]]; then
  echo "Error: tmux is not installed. Please install tmux first."
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

# Load tilix settings
dconf load /com/gexperts/Tilix/ < ${HOME}/.dot/tilix/tilix.dconf

# Install vim plugins
vim +PlugInstall +qall

# Compile YouCompleteMe
~/.vim/plugged/YouCompleteMe/install.py --clangd-completer

# Set up tmux plugin manager
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins by starting a server (but not attaching to it),
# creating a new session (but not attaching to it), installing the
# plugins, then killing the server
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server
