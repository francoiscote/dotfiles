# -----------------------------------------
# ALIASES
# -----------------------------------------

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Source my ZSH
alias reload!="source ~/.zshrc";

# Neovim
# -----------------------------------------
alias vim="nvim"

# Docker
# -----------------------------------------
alias dockerprune="docker image prune -af && docker volume prune -f"

# Herdr
# -----------------------------------------
alias tri="herdr-trifecta"