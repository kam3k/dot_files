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
  htop \
  ncdu \
  tree \
  fontconfig \
  jq \
  fzf \
  silversearcher-ag \
  fd-find \
  build-essential \
  cmake \
  gdb \
  clangd \
  clang-format \
  tmux \
  python3 \
  python3-pip \
  pipx \
  meld \
  neovim \
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
echo "==> Setting up neovim"

mkdir -p ~/.local/share/nvim/site/pack/themes/start
if [ ! -d ~/.local/share/nvim/site/pack/themes/start/sora ]; then
    git clone https://github.com/Aejkatappaja/sora.git \
        ~/.local/share/nvim/site/pack/themes/start/sora
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
# GNOME SHELL CONFIGURATION
# =========================================================
echo "==> Restoring GNOME settings and extensions"

# Load the dconf registry first (restores visual settings and extension preferences)
if [[ -f "$HOME/.config/dconf/gnome_settings.dconf" ]]; then
    echo "==> Importing GNOME visual preferences and extension settings"
    dconf load /org/gnome/ < "$HOME/.config/dconf/gnome_settings.dconf"
fi

# Set up workspace switching keybinds
for i in {1..9}; do
  gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
done
for i in $(seq 10); do
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$i']"
done

# Ensure pipx path is exposed in the current subshell execution context
export PATH="$HOME/.local/bin:$PATH"

# Automatically install and enable extensions
my_extensions=(
  "BingWallpaper@ineffable-gmail.com"
  "caffeine@patapon.info"
  "instantworkspaceswitcher@amalantony.net"
  "monitor@astraext.github.io"
  "unblank@sun.wxg@gmail.com"
  "Bluetooth-Battery-Meter@maniacx.github.com"
  "live-lockscreen@nick-redwill"
  "SmartAutoMoveNG@lauinger-clan.de"
  "workspaces-by-open-apps@favo02.github.com"
)

# Install extensions using an isolated pipx environment runner
echo "==> Fetching and activating GNOME extensions"
echo "  -> Cleaning out existing local extension folders to prevent conflicts..."
for ext in "${my_extensions[@]}"; do
    rm -rf "$HOME/.local/share/gnome-shell/extensions/$ext"
done

echo "  -> Downloading extensions..."
pipx run gnome-extensions-cli install "${my_extensions[@]}" || true

echo "  -> Enabling extensions..."
for ext in "${my_extensions[@]}"; do
    pipx run gnome-extensions-cli enable "$ext" || true
done

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
