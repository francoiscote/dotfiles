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
if which pyenv > /dev/null;  then
  eval "$(pyenv init -)"
fi

# -----------------------------------------
# RBENV
# -----------------------------------------
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi