#!/bin/sh

# -----------------------------------------
# PYENV
# -----------------------------------------
export PYENV_ROOT="/usr/local/var/pyenv"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# source private stuff
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi
