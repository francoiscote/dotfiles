#!/bin/sh

# -----------------------------------------
# CONFIGS
# -----------------------------------------
DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules}"
OS=`uname`
path=($DOTFILES/bin $path)
fpath=($DOTFILES/lib/completions $fpath)

export CLICOLOR=1
export EDITOR=vim
export QUOTING_STYLE=literal

# fix "xdg-open fork-bomb" export your preferred browser from here
# export BROWSER=/bin/vivaldi-stable

# -----------------------------------------
# Default GPG Key
# (if you fork this repo, change this to your own!)
# -----------------------------------------
export GPGKEY=60C853AA


# -----------------------------------------
# ZSH OPTIONS
# -----------------------------------------
setopt multios
setopt prompt_subst
setopt interactivecomments

autoload -U compaudit compinit

# -----------------------------------------
# PURE PROMPT CUSTOMIZATIONS
# -----------------------------------------
PURE_PROMPT_SYMBOL=">"

# -----------------------------------------
# ANTIGEN
# -----------------------------------------
source /usr/local/share/antigen/antigen.zsh

antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# the lazy load is too slow on macOS right now
# export NVM_LAZY_LOAD=true
# antigen bundle lukechilds/zsh-nvm

antigen apply

# -----------------------------------------
# PATHS
# -----------------------------------------
# Zsh
export PATH="$ZSH/bin:$PATH"
# scripts
export PATH="$HOME/.scripts:$PATH"
# local bin
export PATH="$HOME/.local/bin:$PATH"
# /usr/bin
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
# python2.7 execs
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# ruby
export PATH="$HOME/.gem/ruby/2.4.0/bin:$PATH"
# OpenSSL fix for macOS
export PATH="/usr/local/opt/openssl/bin:$PATH"
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# -----------------------------------------
# SOURCE LIB/*.ZSH FILES
# -----------------------------------------
for config_file ($DOTFILES/zsh/lib/*.zsh); do
  source $config_file
done

# compinit must be done after sourcing all libs
compinit -i -d "${HOME}/.zcompdump"

# -----------------------------------------
# SHORTCUT COMMANDS
# -----------------------------------------
# c -> ~/Code/
c() { cd ~/Code/$1; }
_c() { _files -W ~/Code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# -----------------------------------------
# RIGHT PROMPT
# -----------------------------------------
prompt_nvm() {
  local nvm_prompt
  if type nvm >/dev/null 2>&1; then
    nvm_prompt=$(nvm current 2>/dev/null)
    [[ "${nvm_prompt}x" == "x" ]] && return
  elif type node >/dev/null 2>&1; then
    nvm_prompt="$(node --version)"
  else
    return
  fi
  nvm_prompt=${nvm_prompt}
  NODE_ICON=$'\u2B22' # ⬢
  echo "%F{magenta}[$NODE_ICON $nvm_prompt]%F{reset}"
}

prompt_pyenv() {
  local python_prompt
  if type python >/dev/null 2>&1; then
    python_version=$(python --version 2>/dev/null)
  else
    return
  fi
  python_prompt=${python_version}
  NODE_ICON=$'\u2B22' # ⬢
  echo "%F{yellow}[$NODE_ICON $python_prompt]%F{reset}"
}

RPROMPT='$(prompt_nvm)$(prompt_pyenv)'

# source private stuff in a .localrc file
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi
