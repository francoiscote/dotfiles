#!/bin/sh

# -----------------------------------------
# PHPBREW
# -----------------------------------------
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# -----------------------------------------
# PYENV
# -----------------------------------------
if which pyenv > /dev/null;  then
  eval "$(pyenv init -)"
fi

# -----------------------------------------
# RBENV
# -----------------------------------------
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi