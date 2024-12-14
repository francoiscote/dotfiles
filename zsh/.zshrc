#!/bin/sh

# -----------------------------------------
# CONFIGS
# -----------------------------------------
DOTFILES=$HOME/.dotfiles
GREP_EXCLUDE_DIR="{.git,.sass-cache,artwork,node_modules}"
OS=`uname`
PATH=$DOTFILES/bin:$PATH
FPATH=$HOME/.zsh-completions:$FPATH

# Brew completion paths
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
export HOMEBREW_NO_AUTO_UPDATE=1

export CLICOLOR=1
export VISUAL=nvim
export EDITOR="$VISUAL"
export QUOTING_STYLE=literal

export XDG_CONFIG_HOME="$HOME/.config"

# -----------------------------------------
# Default GPG Key
# (if you fork this repo, change this to your own!)
# -----------------------------------------
export GPG_TTY=8F02000860C853AA

# -----------------------------------------
# ZSH OPTIONS
# -----------------------------------------
setopt multios
setopt prompt_subst
setopt interactivecomments

autoload -U promptinit; promptinit
autoload -Uz compinit;compinit

# Move by word with alt+arrow
bindkey "[D" backward-word
bindkey "[C" forward-word
# Move and begining and end of line with cmd+arrow
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# -----------------------------------------
# PATHS
# -----------------------------------------
# Zsh
export PATH="$ZSH/bin:$PATH"
# local bin
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# /usr/bin
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
# python2.7 execs
export PATH="$HOME/Library/Python/2.7/bin:$PATH"
# ruby
export PATH="$HOME/.gem/ruby/2.4.0/bin:$PATH"
# rust
export PATH="$HOME/.cargo/bin:$PATH"
# OpenSSL fix for macOS
export PATH="/usr/local/opt/openssl/bin:$PATH"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/francois.cote/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/francois.cote/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/francois.cote/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/francois.cote/google-cloud-sdk/completion.zsh.inc'; fi
# Man Paths
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# -----------------------------------------
# SOURCE ZSH PLUGINS
# -----------------------------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -----------------------------------------
# SOURCE LIB/*.ZSH FILES
# -----------------------------------------
for config_file ($DOTFILES/zsh/lib/*.zsh); do
  source $config_file
done


# source private stuff in a .localrc file
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi

# Source Starship prompt
eval "$(starship init zsh)"

# Start or attach default tmux session
# ~/.local/bin/ta
