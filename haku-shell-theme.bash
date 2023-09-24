# =================== haku-theme for bash ===================
# A colorful and informational bash prompt for developers.

# Display current Git branch and the short hash of the current commit
parse_git_info() {
    # Get the current branch name
    git_branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    # Get the short hash of the current commit
    git_hash=$(git rev-parse --short=8 HEAD 2> /dev/null)

    # If inside a Git repository, echo the branch and hash
    if [ "$git_branch" ] && [ "$git_hash" ]; then
        echo "\"$git_branch($git_hash)\" "
    elif [ "$git_branch" ]; then
        echo "\"$git_branch\" "
    fi
}

# Base PS1 string
BASE_PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w [UTC+8 $(TZ="Asia/Shanghai" date +"%T")] -\!-\n\$(parse_git_info)> "

# Apply color if enabled
if [ "$color_prompt" = yes ]; then
    chroot_color='\[\033[01;34m\]'
    user_host_color='\[\033[01;32m\]'
    path_color='\[\033[01;36m\]'
    time_color='\[\033[01;35m\]'
    git_branch_color='\[\033[01;33m\]'
    prompt_color='\[\033[01;92m\]'
    history_color='\[\033[01;94m\]'
    command_success_status_color='\[\033[01;32m\]'
    command_error_status_color='\[\033[01;31m\]'

    PS1="\$(if [ \$? -eq 0 ]; then echo \"${chroot_color}${debian_chroot:+($debian_chroot)}${user_host_color}\u@\h${path_color}:\w ${time_color}[UTC+8 $(TZ="Asia/Shanghai" date +"%T")] ${history_color}-\!- \[\033[00m\]\n${command_success_status_color}■ ${git_branch_color}\$(parse_git_info)${prompt_color}> \[\033[00m\]\"; else echo \"${chroot_color}${debian_chroot:+($debian_chroot)}${user_host_color}\u@\h${path_color}:\w ${time_color}[UTC+8 $(TZ="Asia/Shanghai" date +"%T")] ${history_color}-\!- \[\033[00m\]\n${command_error_status_color}error ${git_branch_color}\$(parse_git_info)${prompt_color}> \[\033[00m\]\"; fi)"

else
    PS1=$BASE_PS1
fi

# Cleanup
unset color_prompt force_color_prompt
# =================== haku-theme END ===================
