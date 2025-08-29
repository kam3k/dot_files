#!/bin/bash

apt-get update

apt-get install -y \
  vim-gtk3 `# for clipboard support in vim` \
  silversearcher-ag \
  stow \
  unzip \
  libclang-dev \
  clang-format \
  clang-tidy \
  cmake \
  cmake-curses-gui \
  build-essential \
  gdb \
  libpython3-dev \
  xclip `# for tmux yank` \
  meld \
  fd-find \
  zsh
