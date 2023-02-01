# -----------------------------------------
# ALIASES
# -----------------------------------------

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Source my ZSH
alias reload!="source ~/.zshrc";

# TMUX
# -----------------------------------------
# kill server
alias tkill="for s in \$(tmux list-sessions | awk '{print \$1}' | rg ':' -r '' | fzf); do tmux kill-session -t \$s; done;"

# Neovim
# -----------------------------------------
alias vim="nvim"

# Docker
# -----------------------------------------
alias dockerprune="docker image prune -af && docker volume prune -f"

# Lazygit
# -----------------------------------------
alias lg="lazygit"

# NPM / Yarn
# -----------------------------------------
alias ns="npm run start"
alias ys="yarn start"