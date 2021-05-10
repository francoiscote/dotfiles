#!/bin/sh

# -----------------------------------------
# ZSH OPTIONS
# -----------------------------------------
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus

# -----------------------------------------
# ALIASES
# -----------------------------------------
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# List directory contents
alias lsa='ls -lah --color'
alias l='ls -lah --color'
alias ll='ls -lh --color'
alias la='ls -lAh --color'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'