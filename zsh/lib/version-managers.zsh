#!/bin/sh

# -----------------------------------------
# NVM
# -----------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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