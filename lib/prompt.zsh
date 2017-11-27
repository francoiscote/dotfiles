# -----------------------------------------
# PROMPT
# -----------------------------------------
function username() {
  if [[ `whoami` != 'fcote' ]]; then
    echo "%F{yellow}%n%F{reset}"
  fi
}

function server() {
  if [[ `hostname` != fcote-* ]]; then
    echo "%F{red}@%F{magenta}%m%F{reset} "
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{reset}"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="%F{yellow}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}✗"

git_super_status() {
  precmd_update_git_vars

  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH$ZSH_THEME_GIT_PROMPT_SEPARATOR"

    if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
    else
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi

    STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    echo "$STATUS"
  fi
}

PROMPT_USER="$(username)$(server)"
PROMPT='
%F{reset}$PROMPT_USER%F{blue}%~ $(git_super_status)
%F{240}› %F{reset}'

# Right Prompt
RPROMPT=$(node_version) # see lib/nvm.zsh for that function
