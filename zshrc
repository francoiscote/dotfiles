#!/usr/bin/env zsh

# -----------------------------------------
# CONFIGS
# -----------------------------------------
DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules,vendor}"
OS=`uname`
path=($DOTFILES/bin $path)
fpath=($DOTFILES/lib/completions $DOTFILES/vendor/zsh-users/zsh-completions/src $fpath)

export CLICOLOR=1
export EDITOR=vim
export QUOTING_STYLE=literal
export TERM=xterm-256color

# -----------------------------------------
# ZSH
# -----------------------------------------
setopt multios
setopt prompt_subst
setopt interactivecomments

autoload -U compaudit compinit

# -----------------------------------------
# VENDORS
# -----------------------------------------
source $DOTFILES/vendor/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
source $DOTFILES/vendor/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $DOTFILES/vendor/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
source $DOTFILES/vendor/olivierverdier/zsh-git-prompt/zshrc.sh


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
# Homebrew
brew_path=$(which brew)
if [[ -f $brew_path ]]
then
  #global brew
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# -----------------------------------------
# RBENV
# -----------------------------------------
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# -----------------------------------------
# NVM
# -----------------------------------------
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# nvm autocompletion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# auto run `nvm use` when .nvmrc is present
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

# -----------------------------------------
# PYENV
# -----------------------------------------
export PYENV_ROOT="/usr/local/var/pyenv"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# source private stuff
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi