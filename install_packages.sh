#!/bin/bash

apt-get update

apt-get install -y \
  zsh \
  git \
  btop \
  curl \
  ripgrep \
  stow \
  unzip \
  clangd \
  clang-format \
  cmake \
  build-essential \
  gdb \
  ncdu \
  rsync \
  meld \
  fd-find \
  foot \
  tmux \
  xclip \
  tree \
  fzf \
  black \
  libxml2-utils \
  jq \

  # Install latest nvim release
if [ ! -d /opt/nvim-linux-x86_64 ]; then
  curl -fLo /tmp/nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  cd /tmp && tar -xzf nvim-linux-x86_64.tar.gz
  mv /tmp/nvim-linux-x86_64 /opt/
fi
