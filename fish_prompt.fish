# Anchor - Elegant and minimalist theme for the fish shell
# https://github.com/n1c00o/fish-anchor

# Prompt -> ⚓ [folder] [git: (branch) (status)] [docker: (container name)] [ssh: user@host]  USER-INPUT

function fish_prompt
  # prompt
  set -l cmd_status_prompt ""
  set -l path_prompt ""
  set -l git_prompt ""
  set -l docker_prompt ""
  set -l ssh_prompt ""

  # info
  set -l last_command_status $status
  # set -l cwd (basename (prompt_pwd))
  set -l cwd (prompt_pwd)
  
  # symbols
  set -l prompt_symbol "⚓"
  set -l git_status_diverged_symbol "⥄"
  set -l git_status_ahead_symbol "↑"
  set -l git_status_behind_symbol "↓"
  set -l git_status_dirty_symbol "⨯"
  set -l git_status_none_symbol "◦"

  # colors
  set -l normal_color (set_color normal)
  set -l success_color (set_color green --bold)
  set -l error_color (set_color red --bold)
  set -l symbol_color (set_color white --bold)
  set -l ssh_color (set_color yellow --bold)
  set -l docker_color (set_color cyan --bold)
  set -l path_color (set_color white --bold)
  set -l git_color (set_color magenta --bold)
  set -l git_status_color (set_color white --bold)

  # Status
  if test $last_command_status -eq 0
    echo -n -s $success_color $prompt_symbol $normal_color
  else
    echo -n -s $error_color $prompt_symbol $normal_color
  end

  # Path
  echo -n -s " " $path_color $cwd $normal_color

  # Git repo
  if git_is_repo
    echo -n -s " " $git_color git_branch_name $normal_color
    set -l anchor_git_branch_status ""

    if git_is_touched
      echo -n -s $git_status_color $git_status_dirty_symbol
    else
      echo -n -s $git_status_color (git_ahead $git_status_ahead_symbol $git_status_behind_symbol $git_status_diverged_symbol $git_status_none_symbol) $normal_color
    end
  end

  # Docker
  if test -n "$DOCKER_MACHINE_NAME"
    echo -n -s " " $docker_color $DOCKER_MACHINE_NAME $normal_color
  end

  # SSH
  if test -n "$SSH_CONNECTION"
    echo -n -s " " $ssh_color (whoami) "@" (hostname) $normal_color
  end

  echo -n -s "  "
end
