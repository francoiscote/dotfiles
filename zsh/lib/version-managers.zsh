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
# I don't remember why I had that, but running brew prefix is slow. Temporary disabling this
# TCLPREFIX="$(brew --prefix tcl-tk)"
# export PATH="$TCLPREFIX/bin:$PATH"
# export LDFLAGS="-L$TCLPREFIX/lib"
# export CPPFLAGS="-I$TCLPREFIX/include"
# export PKG_CONFIG_PATH="$TCLPREFIX/lib/pkgconfig"
# export CFLAGS="-I$TCLPREFIX/include"
# export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I$TCLPREFIX/include' --with-tcltk-libs='-L$TCLPREFIX/lib -ltcl8.6 -ltk8.6'"

if which pyenv > /dev/null;  then
  eval "$(pyenv init -)"
fi

# -----------------------------------------
# RBENV
# -----------------------------------------
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi