# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ -n "$SSH_CLIENT" ]]; then
      echo "%{$fg[yellow]%}%n%{$reset_color%} @ %{$fg[blue]%}%m%{$reset_color%}"
  else
      echo "%{$fg_bold[yellow]%}%n%{$reset_color%}"
  fi
}

# Replace home folder by ~
directory_name(){
  echo "%{$fg_bold[cyan]%}${PWD/#$HOME/~}/%\%{$reset_color%}"
}


# LEFT Prompt
PROMPT=$'\n$(prompt_context) → $(directory_name) $(git_prompt_info) $(git_prompt_status) \n› '

# Prefix
ZSH_THEME_GIT_PROMPT_PREFIX="\ue0a0 "

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}‼︎%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%}♒︎%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_REMOTE_MISSING="[%{$fg[red]%}\ue0a0%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="[ \ue0a0 "
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" ↑"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" ↓"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX=" ]"

# Suffix
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"


# Right Prompt
RPROMPT='$(git_prompt_remote) $(git_remote_status)'
