# -----------------------------------------
# PATHS

# Zsh
export PATH="$ZSH/bin:$PATH"

# usr/local
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# ./bin
export PATH="./bin:$PATH"

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


# rbenv
export PATH="$HOME/.rbenv/shims:$PATH"


# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"


# ZSH Configs
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fcote"
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh/custom
plugins=(aws autoenv brew git github npm pyenv rbenv rsync fcote)

#Bind KEYS
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char


# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='atom'
fi

# source Oh My Zsh
source $ZSH/oh-my-zsh.sh
