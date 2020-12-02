#!/bin/sh

# -----------------------------------------
# CONFIGS
# -----------------------------------------
DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules}"
OS=`uname`
path=($DOTFILES/bin $path)
fpath=($HOME/.zsh-completions $fpath)

# Brew completion paths
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

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

autoload -Uz compinit

# -----------------------------------------
# SPACESHIP THEME CONFIGS 
# (those ones need to be declared before sourcing the theme)
# the rest of the Spaceship configs are in lib/spaceship.sh
# -----------------------------------------
SPACESHIP_PROMPT_DEFAULT_PREFIX="_ "
SPACESHIP_GIT_SYMBOL="[]"

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

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
compinit

# -----------------------------------------
# SHORTCUT COMMANDSy
# -----------------------------------------
# c -> ~/Code/
c() { cd ~/Code/$1; }
_c() { _files -W ~/Code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# source private stuff in a .localrc file
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi