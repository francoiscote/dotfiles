# -----------------------------------------
# ALIASES
# -----------------------------------------

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Source my ZSH
alias reload!="source ~/.zshrc";

# Load tmuxp in current folder
alias tt="tmuxp load .tmuxp.yaml"
# list tmux sessions
alias tl="tmux list-sessions"
