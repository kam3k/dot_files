export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="bira"

plugins=(git z)

source $ZSH/oh-my-zsh.sh

setxkbmap -option ctrl:nocaps # Caps to control

export CCACHE_CPP2=true # required for ADTF

alias eb='elderberry'
alias ebp='elderberry populate --deep'
alias ebm=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
alias ebmd=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug"
alias ebc='elderberry clean'
alias ebd='elderberry diff | less'
alias ebt='ninja run_tests && catkin_test_results --verbose test_results'

# Source ROS setup
[ -f /opt/ros/indigo/setup.zsh ] && source /opt/ros/indigo/setup.zsh
[ -f ~/workspace/devel/setup.zsh ] && source ~/workspace/devel/setup.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh