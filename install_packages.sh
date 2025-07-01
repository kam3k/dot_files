#!/bin/bash

apt-get update

apt-get install -y \
  vim-gtk3 \ # for clipboard support in vim
  tmux \
  git \
  htop \
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
  xsel \ # for tmux-yank
