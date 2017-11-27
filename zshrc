#!/usr/bin/env zsh

# -----------------------------------------
# CONFIGS
# -----------------------------------------
DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules,vendor}"
OS=`uname`
path=($DOTFILES/bin $path)
fpath=($DOTFILES/lib/completions $DOTFILES/vendor/zsh-users/zsh-completions/src $HOME/.zfunctions $fpath)

export CLICOLOR=1
export EDITOR=vim
export QUOTING_STYLE=literal
export TERM=xterm-256color

# -----------------------------------------
# ZSH OPTIONS & PROMPT
# -----------------------------------------
setopt multios
setopt prompt_subst
setopt interactivecomments

autoload -U compaudit compinit

autoload -U promptinit; promptinit
prompt pure 

# -----------------------------------------
# VENDORS
# -----------------------------------------
source $DOTFILES/vendor/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
source $DOTFILES/vendor/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $DOTFILES/vendor/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh

# -----------------------------------------
# SOURCE LIB/*.ZSH FILES
# -----------------------------------------
for config_file ($DOTFILES/lib/*.zsh); do
  source $config_file
done

# compinit must be done after sourcing all libs
compinit -i -d "${HOME}/.zcompdump"

# -----------------------------------------
# SHORTCUT COMMANDS
# -----------------------------------------
# c -> ~/Code/
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# -----------------------------------------
# ALIASES
# -----------------------------------------

# flushdns, because I can never remember the full thing
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Source my ZSH
alias reload!="source ~/.zshrc";

# -----------------------------------------
# PATHS
# -----------------------------------------
# Zsh
export PATH="$ZSH/bin:$PATH"
# .dotfiles bin
export PATH="$HOME/.dotfiles/bin:$PATH"
# /usr/local
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# Python 3.6
export PATH="$HOME/Library/Python/3.6/bin:$PATH"
# Homebrew
brew_path=$(which brew)
if [[ -f $brew_path ]]
then
  #global brew
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
