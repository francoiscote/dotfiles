# Antigen
# -----------------------------------------
source /usr/share/zsh/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle ~/.dotfiles/oh-my-zsh/custom/plugins/fcote

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle tarrasch/zsh-autoenv

antigen apply

antigen theme ~/.dotfiles/oh-my-zsh/custom/ fcote

# -----------------------------------------
# PATHS
# -----------------------------------------
# Zsh
export PATH="$ZSH/bin:$PATH"
# /usr/local
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# npm
export PATH="/usr/local/share/npm/bin:$PATH"
# Android SDK
export PATH="/Applications/android-sdk-macosx/tools:/Applications/android-sdk-macosx/platform-tools:/Applications/android-sdk-macosx/build-tools:$PATH"
# Homebrew
brew_path=$(which brew)
if [[ -f $brew_path ]]
then
  #global brew
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
  # PHP5.6 (for PEAR)
  export PATH="$(brew --prefix php56)/bin:$PATH"
fi
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# -----------------------------------------
# NVM
# -----------------------------------------
# nvm (manually source from homebrew install, do not use the oh-my-zsh nvm plugin)
export NVM_DIR=~/.nvm
if [[ -f $brew_path ]]
then
  source $(brew --prefix nvm)/nvm.sh
else
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
fi

# auto run `nvm use` when .nvmrc is present
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

# nvm autocompletion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion


# -----------------------------------------
# EDITOR: vom, atom-beta, atom
# -----------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    if [ -x /usr/local/bin/atom-beta ]; then
        export EDITOR='atom-beta'
    else
        export EDITOR='atom'
    fi
fi

# -----------------------------------------
# OSX Only: init env variables for docker-machine
# -----------------------------------------
if [ "$(uname)" = "Darwin" ]; then
  # setup env variables for docker machine
  eval "$(docker-machine env default)"
fi

# source private stuff in a .localrc file
source $HOME/.localrc
