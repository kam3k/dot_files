export ZPLUG_HOME=~/.zplug

# Get zplug if it doesn't exist
if [[ ! -d $ZPLUG_HOME ]];then
    git clone https://github.com/b4b4r07/zplug $ZPLUG_HOME
fi

# Source zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "supercrabtree/k"
zplug "urbainvaes/fzf-marks"
zplug "plugins/extract", from:oh-my-zsh 
zplug "denysdovhan/spaceship-zsh-theme", use:spaceship.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Source plugins
zplug load

# History management
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=10000
SAVEHIST=10000
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
setopt share_history

# Control is escape when tapped
if [ -z $XCAPE ]; then
  export XCAPE=1
  xcape -e 'Control_L=Escape'
fi

# Aliases
alias tmux='tmux -2'
alias agc='ag -G ".*\.(cpp|h|hpp|cc)"'
alias agx='ag -G ".*\.(xml)"'
alias now='watch -x -t -n 0.01 date +%s.%N' 
alias o=xdg-open
alias k='k -h'

# ls colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load color schemes
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Make and change into a directory
mkcd()
{
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Colorize output of less
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

# Auto ls when entering a directory
chpwd()
{
  ls
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

# Fuzzy checkout git commit with fzf
zc()
{
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# Fuzzy search for C++ man pages with fzf
zm()
{
  local pages page
  pages=$(man -k ^std:: | awk '{print $1}') &&
  page=$(echo "$pages" | fzf -i) &&
  man $page
}

# Fuzzy search apt packages with fzf (add --installed for installed packages)
zs() 
{
  local packages package
  packages=$(apt list $1 | sed 's/\/.*$//') &&
  package=$(echo "$packages" | fzf -i --tac) &&
  apt show $package
}

# Fuzzy install apt packages
zi() 
{
  local packages package
  packages=$(apt list $1 | sed 's/\/.*$//') &&
  package=$(echo "$packages" | fzf -i --tac) &&
  sudo apt install $package
}

# Fuzzy switch tmux session
zt() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# Source localrc
[ -f ~/.localrc ] && source ~/.localrc
