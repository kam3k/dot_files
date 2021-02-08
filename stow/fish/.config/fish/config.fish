# Path
set -x PATH $HOME/.local/bin $PATH

# Environment variables
set -x EDITOR vim

# Disable greeting
set -U fish_greeting

# Aliases
alias ta='tmux a -t'
alias o=xdg-open
alias cdg="cd (git rev-parse --show-cdup)"
alias ja='ninja'
alias cm='cmake -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=On -DCMAKE_BUILD_TYPE=RelWithDebInfo'
alias cmd='cmake -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=On -DCMAKE_BUILD_TYPE=Debug'
alias fd='fdfind'
alias a="apt-cache search '' | sort | cut --delimiter ' ' --fields 1 | fzf --multi --cycle --reverse --preview 'apt-cache show {1}' | xargs -r sudo apt install -y"
alias ar="autorandr"

# Colors (hybrid)
set --universal fish_color_autosuggestion 666666 # autosuggestions
set --universal fish_color_command        B294BB # commands
set --universal fish_color_comment        666666 # code comments
set --universal fish_color_cwd            81A2BE # current working directory in the default prompt
set --universal fish_color_end            F0C674 # process separators like ';' and '&'
set --universal fish_color_error          CC6666 # highlight potential errors
set --universal fish_color_escape         B5BD68 # highlight character escapes like '\n' and '\x70'
set --universal fish_color_match          B294BB # highlight matching parenthesis
set --universal fish_color_normal         C5C8C6 # default color
set --universal fish_color_operator       8ABEB7 # parameter expansion operators like '*' and '~'
set --universal fish_color_param          C5C8C6 # regular command parameters
set --universal fish_color_quote          B5BD68 # quoted blocks of text
set --universal fish_color_redirection    F0C674 # IO redirections
set --universal fish_color_search_match   --background 373B41 # highlight history search matches and the selected pager item (must be a background)
set --universal fish_color_selection      373B41 # when selecting text (in vi visual mode)

# color for fish default prompts item
set --universal fish_color_cancel         A54242 # the '^C' indicator on a canceled command
set --universal fish_color_user           B294BB # current username in some of fish default prompts
