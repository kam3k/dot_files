#!/bin/bash

apt-get update

apt-get install -y \
  vim-gtk3 `# for clipboard support in vim` \
  htop \
  stow \
  libclang-dev \
  ncdu \
  meld \
  fd-find \
  silversearcher-ag \
  xsel `# for tmux-yank` \
