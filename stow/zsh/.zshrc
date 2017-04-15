export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="avit"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setxkbmap -layout us -option caps:escape

# Set ccache to use distcc if distcc is available:
if type distcc > /dev/null; then
  export CCACHE_PREFIX="distcc"
fi

alias eb='elderberry'
alias ebp='eb populate'
alias ebgp='eb git pull --ff-only'
alias ebm=CXX="'ccache /usr/bin/c++' eb make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
alias ebmd=CXX="'ccache /usr/bin/c++' eb make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug"
alias ebc='eb clean'
alias ebd='eb diff | less'
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

xcape -e 'Control_L=Escape' 
