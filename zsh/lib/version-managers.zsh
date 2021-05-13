#!/bin/sh

# -----------------------------------------
# n
# -----------------------------------------
export N_PREFIX="$HOME/.n"
export PATH=$N_PREFIX/bin:$PATH

# -----------------------------------------
# PHPBREW
# -----------------------------------------
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# -----------------------------------------
# PYENV
# -----------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null; then  
  eval "$(pyenv init --path)"
fi

# -----------------------------------------
# RBENV
# -----------------------------------------
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi