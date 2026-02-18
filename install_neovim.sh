#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

echo "Installing build dependencies..."
sudo apt update
sudo apt install -y \
    ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    unzip \
    curl \
    git

# Define the installation location
INSTALL_PREFIX="$HOME/.local"
mkdir -p "$INSTALL_PREFIX"

# Clone Neovim source
echo "Cloning Neovim source..."
cd /tmp
rm -rf neovim
git clone --depth 1 --branch stable https://github.com/neovim/neovim
cd neovim

# Build Neovim
echo "Building Neovim (this may take a few minutes)..."
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"

# Install Neovim
echo "Installing to $INSTALL_PREFIX..."
make install
echo "..done."
