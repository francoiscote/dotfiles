
#antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle zsh-users/zsh-autosuggestions
#antigen bundle tarrasch/zsh-autoenv
#antigen bundle felixr/docker-zsh-completion


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

# -----------------------------------------
# PYENV
# -----------------------------------------
export PYENV_ROOT="/usr/local/var/pyenv"
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi


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
# EDITOR: if ssh -> vim, else -> atom
# -----------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
  if [ -x /usr/local/bin/code ]; then
    export EDITOR='code'
  else
    export EDITOR='vim'
  fi
fi

# source private stuff in a .localrc file
if [[ -f $HOME/.localrc ]]; then
  source $HOME/.localrc
fi