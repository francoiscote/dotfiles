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
export BROWSER=/bin/google-chrome-stable

# Allows Electron apps to trash files
export ELECTRON_TRASH=trash

export QT_STYLE_OVERIDE=GTK+

# -----------------------------------------
# Default GPG Key
# (if you fork this repo, change this to your own!)
# -----------------------------------------
export GPGKEY=8F02000860C853AA

# -----------------------------------------
# PATHS
# -----------------------------------------
# Zsh
export PATH="$ZSH/bin:$PATH"
# scripts
export PATH="$HOME/.scripts:$PATH"
# local bin
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# /usr/bin
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
# Node
export PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
# ruby
export PATH="/home/fcote/.gem/ruby/2.4.0/bin:$PATH"
# Firefox (installed Manually)
export PATH="/opt/firefox:$PATH"
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# -----------------------------------------
# ZSH OPTIONS
# -----------------------------------------
setopt multios
setopt prompt_subst
setopt interactivecomments

autoload -Uz compinit

# -----------------------------------------
# ZSH plugins
# -----------------------------------------
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -----------------------------------------
# SOURCE LIB/*.ZSH FILES
# -----------------------------------------
for config_file ($DOTFILES/zsh/lib/*.zsh); do
  source $config_file
done

# compinit must be done after sourcing all libs
#compinit -i -d "${HOME}/.zcompdump"
compinit

# -----------------------------------------
# SHORTCUT COMMANDS
# -----------------------------------------
# c -> ~/code/
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# source private stuff in a .localrc file
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi
fpath=($fpath "/home/fcote/.zfunctions")

# -----------------------------------------
# PROMPT
# -----------------------------------------
eval "$(starship init zsh)"
