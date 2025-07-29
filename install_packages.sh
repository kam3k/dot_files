#!/bin/bash

apt-get update

apt-get install -y \
  vim-gtk3 `# for clipboard support in vim` \
  zsh \
  git \
  btop \
  curl \
  silversearcher-ag \
  stow \
  unzip \
  libclang-dev \
  clang-format \
  cmake \
  build-essential \
  gdb \
  ncdu \
  rsync \
  libpython3-dev \
  meld \
  fd-find \
  foot \
  tmux \
  xsel `# for tmux yank` \
