export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="avit"

plugins=(git zsh-autosuggestions extract)

source $ZSH/oh-my-zsh.sh

# Control is escape when tapped
xcape -e 'Control_L=Escape'

# Set ccache to use distcc if distcc is available:
if type distcc > /dev/null; then
  export CCACHE_PREFIX="distcc"
fi

alias eb='elderberry'
alias ebp='eb populate'
alias ebgp='eb git pull --ff-only'
alias ebm=CXX="'ccache /usr/bin/c++' eb make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
alias ebmd=CXX="'ccache /usr/bin/c++' eb make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug"
alias ebc='eb clean -y'
alias ebd='eb diff | less'
alias ebb='eb branch | egrep "\*|Module"'
alias ja='ninja -j32'
alias jat='ja tests'
alias run_tests='ja run_tests && catkin_test_results --verbose --all test_results'
alias tmux='tmux -2'

# ls colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Source ROS setup
[ -f /opt/ros/indigo/setup.zsh ] && source /opt/ros/indigo/setup.zsh

# Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# from John to fix issue building with ccache
export CCACHE_CPP2=true

# Colour gtest output
export GTEST_COLOR=yes

# Make and change into a directory
mkcd()
{
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Search in certain file types
alias agc='ag -G ".*\.(cpp|h|hpp|cc)"'
alias agx='ag -G ".*\.(xml)"'

# Get current time (seconds since epoch)
alias now='watch -x -t -n 0.01 date +%s.%N' 

# Open websites or files in default applications
alias o=xdg-open

# Fuzzy checkout of git branches with fzf
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Fuzzy switch tmux sessions with fzf
fs() {
    local session
      session=$(tmux list-sessions -F "#{session_name}" | \
            fzf --query="$1" --select-1 --exit-0) &&
              tmux switch-client -t "$session"
}

# Fuzzy copying git commit hashes to clipboard with fzf
fgc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  echo -n $(echo "$commit" | sed "s/ .*//") | xclip -selection c
}
