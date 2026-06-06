export ZPLUG_HOME=~/.zplug

# Get zplug if it doesn't exist
if [[ ! -d $ZPLUG_HOME ]];then
    git clone https://github.com/b4b4r07/zplug $ZPLUG_HOME
fi

# Source zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "lib/history", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Source plugins
zplug load

# Options
setopt autopushd pushdignoredups

# Stop prompt from setting tmux title
DISABLE_AUTO_TITLE=true

# Autosuggestion colour
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#707880"

# Aliases
alias ls='ls --color=auto'
alias ta='tmux a -t'
alias now='watch -x -t -n 0.01 date +%s.%N' 
alias o='xdg-open'
alias cdg='cd "$(git rev-parse --show-cdup)"'
alias fd='fdfind'
alias lt='ls -alhrt'
alias vim='nvim'
alias htop='btop'
alias img='swappy-edit'
alias td='vim ~/.todo.txt'

# Set up fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Enable Ctrl-x to edit command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

# Add local to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Make and change into a directory
mkcd()
{
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Log CPU and memory usage of a process
logpid() { while sleep 1; do  ps -p $1 -o pcpu= -o pmem= ; done; }

# Source fzf.zsh
[ -f ~/.config/zsh/fzf.zsh ] && source ~/.config/zsh/fzf.zsh

# Source localrc
[ -f ~/.localrc ] && source ~/.localrc

# Use starship prompt
eval "$(starship init zsh)"
