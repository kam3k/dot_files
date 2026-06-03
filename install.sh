#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo " Debian Sway Bootstrap Installer"
echo "======================================"

sudo apt update

# =========================================================
# 1. BASE SYSTEM
# =========================================================
echo "==> Installing base system tools"

sudo apt install -y \
  zsh \
  git \
  curl \
  stow \
  unzip \
  rsync \
  btop \
  ncdu \
  tree \
  jq \
  fzf \
  ripgrep \
  fd-find \
  build-essential \
  cmake \
  gdb \
  clangd \
  clang-format \
  tmux \
  python3 \
  python3-pip \
  libxml2-utils \
  foot

# =========================================================
# 1.5 DEFAULT SHELL (ZSH)
# =========================================================
echo "==> Setting default shell to zsh"

if command -v zsh >/dev/null 2>&1; then
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" "$USER" || true
  fi
fi

# =========================================================
# 2. FONTS
# =========================================================
echo "==> Installing fonts"

fonts="$HOME/.local/share/fonts"
mkdir -p "$fonts"

if ls "$fonts"/Iosevka* >/dev/null 2>&1; then
  echo "==> Iosevka already installed, skipping"
else
  tmp="/tmp/iosevka.zip"

  curl -fLo "$tmp" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip

  unzip -o "$tmp" -d /tmp/iosevka-fonts

  cp /tmp/iosevka-fonts/*.ttf "$fonts/" || true

  rm -rf /tmp/iosevka-fonts "$tmp"
fi

fc-cache -f

# =========================================================
# 3. NEOVIM
# =========================================================
echo "==> Checking Neovim installation"

if command -v nvim >/dev/null 2>&1; then
  echo "==> Neovim already installed, skipping build"
else
  echo "==> Building Neovim"

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

  rm -rf /tmp/neovim

  git clone --depth 1 --branch stable https://github.com/neovim/neovim /tmp/neovim

  cd /tmp/neovim

  make CMAKE_BUILD_TYPE=RelWithDebInfo \
       CMAKE_INSTALL_PREFIX="$HOME/.local"

  make install

  cd -
fi

# =========================================================
# 3.5 NEOVIM PLUGIN BOOTSTRAP (lazy.nvim)
# =========================================================
echo "==> Bootstrapping Neovim plugins (lazy.nvim)"

if command -v nvim >/dev/null 2>&1; then
  nvim --headless "+Lazy! sync" +qa || true
else
  echo "==> nvim not found, skipping plugin sync"
fi

# =========================================================
# 4. WAYLAND + SWAY CORE
# =========================================================
echo "==> Installing Wayland + Sway"

sudo apt install -y \
  sway \
  xwayland \
  swayidle \
  swaylock \
  fuzzel \
  wl-clipboard \
  grim \
  mako-notifier \
  slurp \
  wf-recorder \
  brightnessctl \
  playerctl \
  pipewire \
  wireplumber \
  pavucontrol \
  xdg-desktop-portal \
  xdg-desktop-portal-wlr \
  xdg-desktop-portal-gtk \
  dbus-user-session \
  xdg-user-dirs

# =========================================================
# 5. DESKTOP LAYER
# =========================================================
echo "==> Installing desktop apps"

sudo apt install -y \
  firefox-esr \
  network-manager \
  network-manager-gnome \
  blueman \
  udiskie \
  thunar \
  gvfs \
  gvfs-backends \
  xdg-utils

# =========================================================
# 5.5 SYSTEM SERVICES (ENABLE CORE DESKTOP BACKENDS)
# =========================================================

echo "==> Enabling system services"

sudo systemctl enable NetworkManager

sudo systemctl enable bluetooth || true

# =========================================================
# 6. DOTFILES (STOW)
# =========================================================
echo "==> Stowing dotfiles"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$DOTFILES_DIR/stow"

for pkg in */; do
  stow -D "$pkg" 2>/dev/null || true
  stow -t "$HOME" "$pkg"
done

cd -

# =========================================================
# 7. STARSHIP (RESTORED FROM POST INSTALL SCRIPT)
# =========================================================
echo "==> Installing Starship"

mkdir -p "$HOME/.local/bin"

curl -sS https://starship.rs/install.sh > /tmp/starship_install.sh

sh /tmp/starship_install.sh -y -b "$HOME/.local/bin"

# =========================================================
# 8. TMUX PLUGIN MANAGER (TPM) + INSTALL PLUGINS
# =========================================================
echo "==> Installing tmux plugin manager (TPM)"

mkdir -p "$HOME/.tmux/plugins"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Installing tmux plugins"

# Start a headless tmux session so TPM can install plugins
tmux start-server
tmux new-session -d

"$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

tmux kill-server

# =========================================================
# DONE
# =========================================================
echo "======================================"
echo " Install complete"
echo " Next step: reboot → sway"
echo "======================================"
