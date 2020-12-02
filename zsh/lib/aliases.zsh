
# -----------------------------------------
# ALIASES
# -----------------------------------------

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Source my ZSH
alias reload!="source ~/.zshrc";

# TMUX
# Load tmuxp in current folder
alias tt="tmuxp load .tmuxp.yaml"
# kill server
alias tk="tmux kill-server"
# simpler tmuxinator alias
alias goto="tmuxinator"

# Docker
alias dockerprune="docker image prune -af && docker volume prune -f"