# Load configs
# -----------------------------------------
source ~/.config/fish/lib/env.fish
source ~/.config/fish/lib/aliases.fish
source ~/.config/fish/lib/fisher.fish
source ~/.config/fish/lib/spacefish.fish


# COLORS
# -----------------------------------------
set fish_color_autosuggestion brblack
set fish_color_command green
set fish_color_error red
set fish_color_quote bryellow
set fish_color_param blue

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