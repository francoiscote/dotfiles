# PATHs
export PATH="/Applications/MAMP/bin/php/php5.5.17/bin:/Applications/MAMP/bin/apache2/bin:$HOME/.rbenv/shims:$ZSH/bin:$HOME/.android-sdk-macosx/tools:/usr/local/share/npm/bin:./bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$PATH"

# Add Brew Paths
brew_path=$(which brew)
if [[ -f $brew_path ]]
then
  export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"


# ZSH Configs
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="fcote"
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh/custom
plugins=(git github aws brew npm rsync tmux zsh_reload fcote)

# tmux plugin Configs
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_FIXTERM=false
ZSH_TMUX_ITERM2=true #forces -CC

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

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
