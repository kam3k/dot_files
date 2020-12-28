#!/bin/bash

apt-get update

# Desktop
apt-get install -y \
  gdm3 \
  budgie-desktop \
  papirus-icon-theme \
  materia-gtk-theme \
  fonts-noto-core \
  openssh-server \
  nautilus

# Applications
apt-get install -y \
  firefox-esr \
  gedit \
  nomacs \
  evince \
  gnome-calculator \
  gnome-disk-utility \
  gnome-mpv \
  gnome-screenshot \
  tilix

# Utilities
apt-get install -y \
  htop \
  curl \
  stow \
  ncdu \
  rsync \
  tree \
  xsel \
  fd-find \
  xdg-utils \
  silversearcher-ag

# Development
apt-get install -y \
  vim-gtk \
  tmux \
  zsh \
  libclang-dev \
  clang-format \
  clang-tidy \
  cmake \
  cmake-curses-gui \
  ninja-build \
  build-essential \
  gdb \
  meld \
  python3-dev \
