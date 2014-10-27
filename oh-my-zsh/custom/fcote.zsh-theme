# Show colors only when connected through ssh
host(){
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg[yellow]%}%n%{$reset_color%} @ %{$fg[blue]%}%m%{$reset_color%}"
  else
    echo "%{$fg_bold[yellow]%}%n%{$reset_color%}"
  fi
}

# Replace home folder by ~
directory_name(){
  echo "%{$fg_bold[cyan]%}${PWD/#$HOME/~}/%\%{$reset_color%}"
}

## Override default git_prompt_info so we output the dirty state before the
# branch name. That way we can colorize it.
function git_prompt_info() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}



# LEFT Prompt
PROMPT=$'\n$(host) → $(directory_name) $(git_prompt_info) $(git_commits_ahead)\n› '

# Prefix
ZSH_THEME_GIT_PROMPT_PREFIX="→ "

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}"

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=""
ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX="[%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX="%{$reset_color%}]"

# Suffix
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"


# Right Prompt
# RPROMPT=$''
