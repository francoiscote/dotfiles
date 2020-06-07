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

# tcl-tk
export PATH="$(brew --prefix tcl-tk)/bin:$PATH"
export LDFLAGS="-L$(brew --prefix tcl-tk)/lib"
export CPPFLAGS="-I$(brew --prefix tcl-tk)/include"
export PKG_CONFIG_PATH="$(brew --prefix tcl-tk)/lib/pkgconfig"
export CFLAGS="-I$(brew --prefix tcl-tk)/include"
export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I$(brew --prefix tcl-tk)/include' --with-tcltk-libs='-L$(brew --prefix tcl-tk)/lib -ltcl8.6 -ltk8.6'"

if which pyenv > /dev/null;  then
  eval "$(pyenv init -)"
fi

# -----------------------------------------
# RBENV
# -----------------------------------------
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi