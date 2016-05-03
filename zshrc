# -----------------------------------------
# PATHS

# Zsh
export PATH="$ZSH/bin:$PATH"

# /usr/local
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# ./bin
# export PATH="./bin:$PATH"

# npm
export PATH="/usr/local/share/npm/bin:$PATH"

# Android SDK
export PATH="/Applications/android-sdk-macosx/tools:/Applications/android-sdk-macosx/platform-tools:/Applications/android-sdk-macosx/build-tools:$PATH"

# MAMP
# export PATH="/Applications/MAMP/bin/php/php5.5.17/bin:/Applications/MAMP/bin/apache2/bin:$PATH"

# Homebrew
brew_path=$(which brew)
if [[ -f $brew_path ]]
then
  #global brew
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
  # PHP5.6 (for PEAR)
  export PATH="$(brew --prefix php56)/bin:$PATH"
fi

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

# Linux: load autoenv
if [ "$(uname)" != "Darwin" ]; then
  source ~/.autoenv/activate.sh
fi

# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"


# ZSH Configs
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fcote"
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh/custom
plugins=(aws autoenv brew brew-cask docker docker-compose git github npm pyenv rbenv rsync fcote)

#Bind KEYS
# bindkey '^[^[[D' backward-word
# bindkey '^[^[[C' forward-word
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line
# bindkey '^[[3~' delete-char
# bindkey '^[^N' newtab
# bindkey '^?' backward-delete-char


# Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    if [ -x /usr/local/bin/atom-beta ]; then
        export EDITOR='atom-beta'
    else
        export EDITOR='atom'
    fi
fi

if [ "$(uname)" = "Darwin" ]; then
  # setup env variables for docker machine
  eval "$(docker-machine env default)"
fi

# source Oh My Zsh
source $ZSH/oh-my-zsh.sh
