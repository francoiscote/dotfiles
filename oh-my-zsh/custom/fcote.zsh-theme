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


#Icons
FCOTE_THEME_ICON_DIRECTORY="@"
FCOTE_THEME_ICON_GIT_BRANCH="→"
FCOTE_THEME_ICON_GIT_UNTRACKED="!!"
FCOTE_THEME_ICON_GIT_STASHED="¿"
FCOTE_THEME_ICON_GIT_REPO="⦾"
FCOTE_THEME_ICON_GIT_PUSH="↑"
FCOTE_THEME_ICON_GIT_PULL="↓"

# LEFT Prompt
PROMPT=$'\n$(prompt_context) $FCOTE_THEME_ICON_DIRECTORY $(directory_name) $(git_prompt_info) $(git_prompt_status) \n› '

# Prefix
ZSH_THEME_GIT_PROMPT_PREFIX="$FCOTE_THEME_ICON_GIT_BRANCH "

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} $FCOTE_THEME_ICON_GIT_UNTRACKED%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%}$FCOTE_THEME_ICON_GIT_STASHED%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_REMOTE_MISSING="%{$fg[red]%}$FCOTE_THEME_ICON_GIT_REPO%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS=""

ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX=""
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$FCOTE_THEME_ICON_GIT_PUSH "
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$FCOTE_THEME_ICON_GIT_PULL "
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX=""

# Suffix
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"


# Right Prompt
RPROMPT='$(git_prompt_remote) $(git_remote_status)'
