#!/bin/bash

# Install vim plugins
vim +PlugInstall +qall

# Install tmux plugins by starting a server (but not attaching to it),
# creating a new session (but not attaching to it), installing the
# plugins, then killing the server
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server
