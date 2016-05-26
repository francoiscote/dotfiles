#!/usr/bin/env bash

# c -> ~/Code/
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# Git Aliases
alias gs='git status -sb'
alias gl='git pull'
alias gp='git push'
alias gd='!f() { [ \"$GIT_PREFIX\" != \"\" ] && cd "$GIT_PREFIX"; git diff --color $@ | diff-so-fancy | less --tabs=4 -RFX; }; f'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ga='git-all'
alias wtf='git-wtf'

# flushdns, because I can never remember the full thing
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# rock run shortcut
alias rockrun80="sudo HTTP_PORT=80 rock run"
alias rockrun80dev="sudo HTTP_PORT=80 rock --env dev run"
alias rcrb="rock clean; rock build"

# docker rock
# alias rocker="docker run --rm -i -t -v $(pwd):/code -w /code rockstack:latest /bin/bash"

# Source my ZSH
alias reload!="source ~/.zshrc";

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"
