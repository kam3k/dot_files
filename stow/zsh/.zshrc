export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="bira"

plugins=(git z)

source $ZSH/oh-my-zsh.sh

setxkbmap -layout us -option caps:escape

export CCACHE_CPP2=true # required for ADTF

# Set ccache to use distcc if distcc is available:
if type distcc > /dev/null; then
  export CCACHE_PREFIX="distcc"
fi

alias eb='elderberry'
alias ebp='elderberry populate'
alias ebm=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
alias ebmd=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug"
alias ebc='elderberry clean'
alias ebd='elderberry diff | less'
alias ebt='ninja run_tests && catkin_test_results --verbose test_results'
alias ja='ninja -j48'
alias ebgp='elderberry git pull --ff-only'

alias tmux='tmux -2'

# Source ROS setup
[ -f /opt/ros/indigo/setup.zsh ] && source /opt/ros/indigo/setup.zsh
[ -f ~/workspace/devel/setup.zsh ] && source ~/workspace/devel/setup.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# from John to fix issue building with ccache
export CCACHE_CPP2=true
