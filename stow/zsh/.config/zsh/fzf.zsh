# Ensure fzf exists
command -v fzf >/dev/null 2>&1 || return

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
            --bind 'ctrl-i:execute-silent(sudo apt install {1})+abort' \
            --bind 'ctrl-r:execute-silent(sudo apt remove {1})+abort' \
            --bind 'ctrl-p:execute-silent(sudo apt purge {1})+abort'
  ) || return

  pkg=$(echo "$pkg" | cut -d/ -f1)
  echo "selected: $pkg"
}

# ----------------------------------------------------------------------------
# zcd: fuzzy directory jump
# ----------------------------------------------------------------------------
zcd() {
  command -v fd >/dev/null 2>&1 || {
    echo "fd not found (install fd for best performance)"
    return 1
  }

  local dir

  dir=$(
    fd . --type d --hidden --exclude .git 2>/dev/null \
      | fzf --height=80% \
            --reverse \
            --preview 'ls -la --color=always {}' \
            --preview-window=right:60%
  ) || return

  cd "$dir"
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
