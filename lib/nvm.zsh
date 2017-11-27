# Node version from NVM
node_version() {
  [[ -f "$NVM_DIR/nvm.sh" ]] || return
  local node_version=$(nvm current)
  [[ -z "${node_version}" ]] && return
  NODE_ICON=$'\u2B22' # ⬢
  echo "%{$fg[magenta]%}[$NODE_ICON $node_version]%{$reset_color%}"
}