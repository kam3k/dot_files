function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -g red (set_color -o red)
  set -g blue (set_color -o blue)
  set -l green (set_color -o green)
  set -g normal (set_color normal)

  set -g whitespace ' '

  if test $last_status = 0
    set initial_indicator "$green•"
    set status_indicator "$normal❯"
  else
    set initial_indicator "$red✖"
    set status_indicator "$red❯"
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]

		set -l git_branch (_git_branch_name)
		set git_info "$normal ($blue$git_branch$normal)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow !"
      set git_info "$git_info$dirty"
    end

    if [ (_is_git_stashed) ]
      set -l stashed "$cyan ☰"
      set git_info "$git_info$stashed"
    end

    if [ (_is_git_unpushed) ]
      set -l unpushed "$green ↑"
      set git_info "$git_info$unpushed"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $status_indicator $whitespace
end

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _is_git_unpushed
  echo (command git cherry -v ^/dev/null)
end

function _is_git_stashed
  echo (command git stash list ^/dev/null)
end
