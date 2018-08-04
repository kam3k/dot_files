export ZPLUG_HOME=~/.zplug

# Get zplug if it doesn't exist
if [[ ! -d $ZPLUG_HOME ]];then
    git clone https://github.com/b4b4r07/zplug $ZPLUG_HOME
fi

# Source zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "supercrabtree/k"
zplug "plugins/extract", from:oh-my-zsh 
zplug "lib/history", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Source plugins
zplug load

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Aliases
alias tmux='tmux -2'
alias ta='tmux a -t'
alias agc='ag -G ".*\.(cpp|h|hpp|cc)"'
alias agx='ag -G ".*\.(xml)"'
alias now='watch -x -t -n 0.01 date +%s.%N' 
alias o=xdg-open
alias k='k -h'
alias zs='pkgsearch'
alias cdg='cd "$(git rev-parse --show-cdup)"'

# ls colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Set FZF colours
export FZF_DEFAULT_OPTS="
  --color=bg+:19,bg:0,spinner:12,hl:11
  --color=fg:4,header:11,info:10,pointer:12
  --color=marker:12,fg+:6,prompt:10,hl+:11
"

# Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable Ctrl-x to edit command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

# Make and change into a directory
mkcd()
{
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Fuzzy checkout git branch with fzf
zb() 
{
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Log CPU and memory usage of a process
logpid() { while sleep 1; do  ps -p $1 -o pcpu= -o pmem= ; done; }

# Source localrc
[ -f ~/.localrc ] && source ~/.localrc
