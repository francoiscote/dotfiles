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
