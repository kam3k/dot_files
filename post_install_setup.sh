#!/bin/zsh

# Check for required dependencies before continuing:
if [[ ! -a $(which git) ]]; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

if [[ ! -a $(which curl) ]]; then
  echo "Error: curl is not installed. Please install curl first."
  exit 1
fi

if [[ ! -a $(which stow) ]]; then
  echo "Error: stow is not installed. Please install stow first."
  exit 1
fi

if [[ ! -a $(which unzip) ]]; then
  echo "Error: unzip is not installed. Please install unzip first."
  exit 1
fi

if [[ ! -a $(which vim) ]]; then
  echo "Error: vim is not installed. Please install vim first."
  exit 1
fi

if [[ ! -a $(which tmux) ]]; then
  echo "Error: tmux is not installed. Please install tmux first."
  exit 1
fi

# Symlink everything in stow directory to home directory
cd ${HOME}/.dot/stow
for app in */; do
	stow -t ${HOME} $app
done;

# Install vim plugins
vim +PlugInstall +qall

# Compile YouCompleteMe
~/.vim/plugged/YouCompleteMe/install.py --clang-completer

# Set up tmux plugin manager
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install tmux plugins by starting a server (but not attaching to it),
# creating a new session (but not attaching to it), installing the
# plugins, then killing the server
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server

# Set up font directory
declare fonts=${HOME}/.local/share/fonts
if [ ! -d ${fonts} ]; then
  mkdir -p ${fonts}
fi

# Font Awesome (version 5.7.2)
fontawesome_5_file="Font Awesome 5 Free-Regular-400.otf"
if [[ ! -f ${fonts}/$fontawesome_5_file ]]; then
  curl -fLo /tmp/font-awesome-5.zip https://use.fontawesome.com/releases/v5.7.2/fontawesome-free-5.7.2-desktop.zip
  cd /tmp && unzip font-awesome-5.zip
  cp /tmp/fontawesome-free-5.7.2-desktop/otfs/*.otf ${fonts}
fi

# Iosevka Term
if [ ! -f ${fonts}/iosevka-term-regular.ttf ]; then
  curl -fLo /tmp/iosevka-term.zip https://github.com/be5invis/Iosevka/releases/download/v2.0.0/02-iosevka-term-2.0.0.zip
  cd /tmp && unzip iosevka-term.zip -d iosevka-term
  cp /tmp/iosevka-term/ttf/*.ttf ${fonts}
fi

# Noto Sans
if [ ! -f ${fonts}/NotoSans-Regular.ttf ]; then
  curl -fLo /tmp/noto-sans.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSans-hinted.zip
  cd /tmp && unzip noto-sans.zip -d noto-sans
  cp /tmp/noto-sans/*.ttf ${fonts}
fi

# Refresh font cache
fc-cache
