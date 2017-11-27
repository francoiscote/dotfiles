# -----------------------------------------
# LOAD NVM
# -----------------------------------------
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# nvm autocompletion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# auto run `nvm use` when .nvmrc is present
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

# -----------------------------------------
# Utils
# -----------------------------------------
node_version() {
  [[ -f "$NVM_DIR/nvm.sh" ]] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  NODE_ICON=$'\u2B22' # ⬢
  echo "%F{magenta}[$NODE_ICON $nvm_prompt]%F{reset}"
}
