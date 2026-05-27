# Ensure fzf exists
command -v fzf >/dev/null 2>&1 || return

# Set fzf options
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#1e2430 \
  --color=bg:#0e1018 \
  --color=border:#222838 \
  --color=fg:#c8d0e0 \
  --color=fg+:#dce4f0 \
  --color=gutter:#0e1018 \
  --color=header:#80c8e0 \
  --color=hl:#80c8e0 \
  --color=hl+:#98d8f0 \
  --color=info:#586478 \
  --color=marker:#90c8a0 \
  --color=pointer:#80c8e0 \
  --color=prompt:#b0a0d8 \
  --color=spinner:#80c8e0"

# ----------------------------------------------------------------------------
# zhelp: list all fzf toolkit functions with brief descriptions
# ----------------------------------------------------------------------------
zhelp() {
  local file="${ZSH_FZF_FILE:-$HOME/.config/zsh/fzf.zsh}"

  [ ! -f "$file" ] && { echo "fzf function file not found: $file"; return 1; }

  # build a list of function names with descriptions (omit function names from description)
  local list
  list=$(awk '
    # skip horizontal lines
    /^# -+/ { next }

    # capture description line
    /^# [a-zA-Z0-9_]+:/ {
      desc=$0
      gsub(/^# /,"",desc)
      # remove "name: " from the beginning
      sub(/^[a-zA-Z0-9_]+: /,"",desc)
      next
    }

    # capture function definition immediately after description
    /^[a-zA-Z0-9_]+\(\)/ {
      if (desc != "") {
        func=$1
        gsub(/\(\)/,"",func)
        print func " -- " desc
        desc=""
      }
    }
  ' "$file" | grep -v '^zhelp ' )  # omit zhelp itself

  # show fzf menu
  local func
  func=$(echo "$list" | fzf --ansi --reverse --height=70% --prompt="❯ zhelp> ") || return

  # extract function name and run it
  local fname="${func%% --*}"
  $fname
}

# ----------------------------------------------------------------------------
# zb: fuzzy git branch switcher
# ----------------------------------------------------------------------------
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
            echo "branch: $branch"
            echo "----------------------------------------"
            upstream=$(git for-each-ref --format="%(upstream:short)" refs/heads/${branch#origin/})
            if [ -n "$upstream" ]; then
              echo "upstream: $upstream"
              git rev-list --left-right --count "$branch...$upstream" 2>/dev/null \
                | awk "{print \"ahead: \"$1\"  behind: \"$2}"
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

# ----------------------------------------------------------------------------
# zc: fuzzy git commit browser
# ----------------------------------------------------------------------------
zc() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "not inside a git repository"
    return 1
  }

  git log --oneline --decorate --color=always \
    | fzf --ansi \
          --reverse \
          --height=80% \
          --preview 'git show --color=always {1}' \
          --preview-window=down:55%
}

# ----------------------------------------------------------------------------
# za: fast apt package explorer
# ----------------------------------------------------------------------------
za() {
  command -v apt >/dev/null 2>&1 || {
    echo "apt not found"
    return 1
  }

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
              echo "package: $pkg"
              echo "----------------------------------------"
              apt-cache show "$pkg" 2>/dev/null \
                | grep -E "^(Package|Version|Installed-Size|Depends|Recommends|Suggests|Description)" \
                | head -n 40
              echo
              if dpkg -s "$pkg" >/dev/null 2>&1; then
                echo "✅ installed"
                dpkg -s "$pkg" | grep -E "Version|Installed-Size"
              else
                echo "❌ not installed"
              fi
            ' \
            --preview-window=right:60% \
            --bind 'ctrl-i:execute(sudo apt install {1})+reload(apt list 2>/dev/null)' \
            --bind 'ctrl-r:execute(sudo apt remove {1})+reload(apt list 2>/dev/null)'
  ) || return

  pkg=$(echo "$pkg" | cut -d/ -f1)
  
  # Clear the terminal grid so the output looks clean
  clear
  echo "========================================================================"
  echo " Detailed information for: $pkg"
  echo "========================================================================"
  
  # Show the full package details
  apt show "$pkg" 2>/dev/null
  
  echo "========================================================================"
  echo
  
  # Ask if the user wants to install the selected package
  print -rn "Do you want to install $pkg? (y/N) "
  read -q "opt"
  echo # Print a newline after the single-character read
  
  if [[ $opt == "y" ]]; then
    sudo apt install "$pkg"
  fi
}

# ----------------------------------------------------------------------------
# zproc: interactive process manager using fzf
# ----------------------------------------------------------------------------
zproc() {
  local pid

  # select a process
  pid=$(
    ps -eo pid,pcpu,pmem,comm --sort=-pcpu \
      | tail -n +2 \
      | fzf --ansi \
            --prompt="🔍 Process> " \
            --reverse \
            --height=70% \
            --delimiter=' ' \
            --with-nth=2.. \
            --preview 'pid=$(echo {} | awk "{print \$1}");
                        cmd=$(echo {} | awk "{print \$4}");
                        echo "command: $cmd";
                        echo "----------------------------------------";
                        echo "threads (first 10):";
                        ps -T -p $pid -o pid,tid,pcpu,pmem,stat,comm | head -n 10;
                        echo;
                        echo "cpu & mem summary:";
                        ps -p $pid -o pcpu,pmem' \
            --preview-window=down:55% \
            --bind "ctrl-k:execute-silent(kill -9 {1})+abort" \
            --bind "ctrl-b:execute(btop -p {1})+abort"
  ) || return

  pid=$(echo "$pid" | awk '{print $1}')
  echo "selected pid: $pid"

  # if a PID was selected, start live cpu/mem monitoring
  if [[ -n "$pid" ]]; then
    echo "monitoring cpu/mem for pid $pid (press ctrl-c to stop)"
    printf "%-6s %-6s\n" CPU% MEM%
    while sleep 1; do
      ps -p "$pid" -o pcpu=,pmem= \
        | awk '{printf "%-6s %-6s\n",$1,$2}'
    done
  fi
}

# ----------------------------------------------------------------------------
# zcd: fuzzy recursive directory jumper
# ----------------------------------------------------------------------------
zcd() {
  local dir

  dir=$(
    find . -type d \
      \( -path '*/\.git' -o -path '*/node_modules' -o -path '*/build' -o -path '*/dist' \) -prune \
      -o -type d -print 2>/dev/null \
    | sed 's|^\./||' \
    | fzf --ansi \
          --prompt="📁 cd> " \
          --height=70% \
          --reverse \
          --preview='
            echo "{}"
            echo "----------------------------------------"
            eza --tree --level=2 --icons {} 2>/dev/null || tree -L 2 {} 2>/dev/null || ls -la {}
          ' \
          --preview-window=right:60%
  ) || return

  cd "$dir"
}

# ----------------------------------------------------------------------------
# zv: fuzzy file opener in vim
# ----------------------------------------------------------------------------
zv() {
  local file

  file=$(
    find . -type f \
      \( -path '*/\.git/*' -o -path '*/node_modules/*' -o -path '*/build/*' -o -path '*/dist/*' \) -prune \
      -o -type f -print 2>/dev/null \
    | sed 's|^\./||' \
    | fzf --ansi \
          --prompt=" vim> " \
          --height=80% \
          --reverse \
          --preview='
            bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null \
              || sed -n "1,300p" {}
          ' \
          --preview-window=right:65%
  ) || return

  vim "$file"
}
