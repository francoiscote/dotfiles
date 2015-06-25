# c -> ~/Code/
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# autocorrect is more annoying than helpful
unsetopt correct_all

# Git Aliases
alias gs='git status -sb'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias glog="git --no-pager log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ga='git-all'
alias wtf='git-wtf'

# flushdns, because I can never remember the full thing
alias flushdns="sudo discoveryutil mdnsflushcache"

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# source private stuff in a .localrc file
source $HOME/.localrc

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"
