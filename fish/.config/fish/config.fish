# Load configs
# -----------------------------------------
source ~/.config/fish/lib/env.fish
source ~/.config/fish/lib/aliases.fish
source ~/.config/fish/lib/fisher.fish
source ~/.config/fish/lib/spacefish.fish


# COLORS
# -----------------------------------------
set -g fish_color_autosuggestion brblack
set -g fish_color_search_match --background=cyan
set -g fish_pager_color_completion brblack
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix blue
set -g fish_color_command green
set -g fish_color_error red
set -g fish_color_quote bryellow
set -g fish_color_param blue

# -----------------------------------------
# PHPBREW
# -----------------------------------------
if test -e ~/.phpbrew/phpbrew.fish
  source ~/.phpbrew/phpbrew.fish
end

# -----------------------------------------
# RBENV
# -----------------------------------------
if type -q rbenv
  eval rbenv init -
end

# -----------------------------------------
# PYENV
# -----------------------------------------
if type -q pyenv
  status --is-interactive; and source (pyenv init -|psub)
end

# source private stuff in a .localrc file
if test -e ~/.localrc
  source ~/.localrc
end