## Override default git_prompt_info so we output the dirty state before the
# branch name. That way we can colorize it.
function git_prompt_info() {
    if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
        ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
        echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    fi
}

# get the difference between the local and remote branches
# FCote: modified to not show remote branch name, only the ahead/behing numbers. 
# Also added remote status detailed for equal
git_remote_status() {
    remote=${$(command git rev-parse --verify origin/$(current_branch) --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
        ahead=$(command git rev-list origin/$(current_branch)..HEAD 2>/dev/null | wc -l)
        behind=$(command git rev-list HEAD..origin/$(current_branch) 2>/dev/null | wc -l)

        if [ $ahead -gt 0 ] && [ $behind -eq 0 ]
        then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
        elif [ $behind -gt 0 ] && [ $ahead -eq 0 ] 
        then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]
        then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        fi

        if [ $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]
        then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
        fi

        echo $git_remote_status
    fi
}

# Gets the number of commits ahead from remote
# modified to compare with remote instead of upstream
function git_commits_ahead() {
  if $(echo "$(command git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    COMMITS=$(command git log origin/$(current_branch)..HEAD | grep '^commit' | wc -l | tr -d ' ')
    echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$COMMITS$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
  fi
}
