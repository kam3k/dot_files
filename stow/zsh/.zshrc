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
alias o=xdg-open
alias cdg='cd "$(git rev-parse --show-cdup)"'
alias cds='cd "$(git rev-parse --show-superproject-working-tree)"'
alias fd='fdfind'
alias lt='ls -alhrt'
alias vim='nvim'
alias htop='btop'

# Set up fzf
source <(fzf --zsh)

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

# Switch git branches with fzf
zb() {
  local branch
  branch=$(
    git for-each-ref --sort=-committerdate refs/heads refs/remotes \
      --format='%(if)%(HEAD)%(then)*%(else) %(end) %(refname:short)' \
    | grep -v '\->' \
    | fzf --ansi \
          --prompt="  " \
          --height=70% \
          --reverse \
          --preview='
            branch=$(echo {} | sed "s/^[* ] //")
            echo "Branch: $branch"
            echo "----------------------------------------"

            upstream=$(git for-each-ref --format="%(upstream:short)" refs/heads/${branch#origin/})
            if [ -n "$upstream" ]; then
              echo "Upstream: $upstream"
              git rev-list --left-right --count "$branch...$upstream" 2>/dev/null | \
                awk "{print \"Ahead: \"$1\"  Behind: \"$2}"
            fi

            echo
            git log --graph --color=always \
              --pretty=format:"%C(auto)%h %C(blue)%ad %C(green)%an%C(reset) %s" \
              --date=short -n 10 "$branch"
          ' \
          --preview-window=down:55%
  ) || return

  branch=$(echo "$branch" | sed 's/^[* ] //')

  if [[ "$branch" == origin/* ]]; then
    git checkout -t "$branch"
  else
    git checkout "$branch"
  fi
}

# Manage apt packages with fzf
a() {
  local pkg

  pkg=$(
    apt list 2>/dev/null \
    | tail -n +2 \
    | fzf --ansi \
          --prompt="📦  " \
          --height=85% \
          --reverse \
          --delimiter="/" \
          --with-nth=1 \
          --preview='
            pkg=$(echo {} | cut -d/ -f1)

            echo "Package: $pkg"
            echo "----------------------------------------"

            # Show metadata (limit output for speed)
            apt-cache show "$pkg" 2>/dev/null | \
              grep -E "^(Package|Version|Installed-Size|Depends|Recommends|Suggests|Description)" \
              | head -n 40

            echo

            # Show install status
            if dpkg -s "$pkg" >/dev/null 2>&1; then
              echo "✅ Installed"
              dpkg -s "$pkg" | grep -E "Version|Installed-Size"
            else
              echo "❌ Not installed"
            fi
          ' \
          --preview-window=right:60% \
          --bind 'ctrl-i:execute(sudo apt install {1})+abort' \
          --bind 'ctrl-r:execute(sudo apt remove {1})+abort' \
          --bind 'ctrl-p:execute(sudo apt purge {1})+abort'
  ) || return

  pkg=$(echo "$pkg" | cut -d/ -f1)

  echo "Selected: $pkg"
}

# Source localrc
[ -f ~/.localrc ] && source ~/.localrc

# Use starship prompt
eval "$(starship init zsh)"
