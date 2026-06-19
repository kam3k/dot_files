#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_FILE="$DOTFILES_DIR/stow/gnome/.config/dconf/gnome_settings.dconf"

echo "==> Dumping current GNOME settings to dotfiles repo..."
mkdir -p "$(dirname "$TARGET_FILE")"
dconf dump /org/gnome/ > "$TARGET_FILE"

echo "==> Done! GNOME preferences updated in your repo."
echo "==> New extension source files are managed automatically by Stow symlinks."
