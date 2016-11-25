export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="avit"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setxkbmap -layout us -option caps:escape

export CCACHE_CPP2=true # required for ADTF

alias eb='elderberry'
alias ebp='elderberry populate'
alias ebm=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release; cd build/ && ja"
alias ebmd=CXX="'ccache /usr/bin/c++' elderberry make --no-cpack --extra --use-ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug; cd build/ && ja"
alias ebc='elderberry clean'
alias ebd='elderberry diff | less'
alias ebt='ninja run_tests && catkin_test_results --verbose --all test_results'
alias ebgp='elderberry git pull --ff-only'
alias ja='ninja -j32'

alias tmux='tmux -2'

# Source ROS setup
[ -f /opt/ros/indigo/setup.zsh ] && source /opt/ros/indigo/setup.zsh
[ -f ~/workspace/devel/setup.zsh ] && source ~/workspace/devel/setup.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# from John to fix issue building with ccache
export CCACHE_CPP2=true
