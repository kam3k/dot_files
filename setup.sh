#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo " Pop!_OS setup"
echo "======================================"

# Create temp dir
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Record when apt was last updated so we don't keep checking if this
# script is run multiple times a day for updates
APT_STAMP="/tmp/apt-update-$(date +%Y%m%d)"

# Only attempt to install missing packages
ensure_packages() {
    local missing=()

    for pkg in "$@"; do
        dpkg -s "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
    done

    if (( ${#missing[@]} )); then
        sudo apt install -y "${missing[@]}"
    fi
}

# Only update fonts when they have changed
fonts_changed=false

# Only update apt when it needs to be updated
if [[ ! -f "$APT_STAMP" ]]; then
    sudo apt update
    touch "$APT_STAMP"
fi

# =========================================================
# BASE SYSTEM
# =========================================================
echo "==> Installing base system tools"

ensure_packages \
  zsh \
  git \
  curl \
  stow \
  unzip \
  rsync \
  btop \
  ncdu \
  tree \
  fontconfig \
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
  meld \
  foot \
  libxml2-utils

# =========================================================
# DEFAULT SHELL (ZSH)
# =========================================================
echo "==> Setting default shell to zsh"

if command -v zsh >/dev/null 2>&1; then
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)" "$USER" || true
  fi
fi

# =========================================================
# FONTS
# =========================================================
echo "==> Installing fonts"

fonts="$HOME/.local/share/fonts"
mkdir -p "$fonts"

# Iosevka
if ls "$fonts"/Iosevka* >/dev/null 2>&1; then
  echo "==> Iosevka already installed, skipping"
else
  tmp="$tmpdir/iosevka.zip"
  curl -fLo "$tmp" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip
  unzip -o "$tmp" -d "$tmpdir/iosevka-fonts"
  cp "$tmpdir"/iosevka-fonts/*.ttf "$fonts/"
  fonts_changed=true
fi

if $fonts_changed; then
    fc-cache -f
fi

# =========================================================
# NEOVIM
# =========================================================
echo "==> Checking Neovim installation"

if command -v nvim >/dev/null 2>&1; then
  echo "==> Neovim already installed, skipping build"
else
  echo "==> Building Neovim"

  ensure_packages \
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

  git clone --depth 1 --branch stable \
    https://github.com/neovim/neovim \
    "$tmpdir/neovim"

  cd "$tmpdir/neovim"

  make CMAKE_BUILD_TYPE=RelWithDebInfo \
       CMAKE_INSTALL_PREFIX="$HOME/.local"

  make install

  cd -
fi

echo "==> Bootstrapping Neovim plugins (lazy.nvim)"
if command -v nvim >/dev/null 2>&1; then
  if [[ "${SYNC_NVIM_PLUGINS:-0}" == "1" ]]; then
    nvim --headless "+Lazy! sync" +qa || true
  fi
else
  echo "==> nvim not found, skipping plugin sync"
fi

# =========================================================
# DOTFILES (STOW)
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
# STARSHIP
# =========================================================
echo "==> Installing Starship"

mkdir -p "$HOME/.local/bin"

if [[ ! -x "$HOME/.local/bin/starship" ]]; then
    curl -sS https://starship.rs/install.sh > "$tmpdir/starship_install.sh"
    sh "$tmpdir/starship_install.sh" -y -b "$HOME/.local/bin"
fi

# =========================================================
# TMUX PLUGIN MANAGER (TPM) + INSTALL PLUGINS
# =========================================================
echo "==> Installing tmux plugin manager (TPM)"

mkdir -p "$HOME/.tmux/plugins"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Installing tmux plugins"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    tmux start-server
    tmux new-session -d
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
    tmux kill-server
fi

# =========================================================
# DONE
# =========================================================
echo "======================================"
echo " Setup complete"
echo "======================================"
