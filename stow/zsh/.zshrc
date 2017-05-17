# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="avit"
plugins=(git zsh-autosuggestions extract k)
source $ZSH/oh-my-zsh.sh

# Control is escape when tapped
xcape -e 'Control_L=Escape'

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
