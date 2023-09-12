# -----------------------------------------
# SHORTCUT COMMANDS
# -----------------------------------------

autoload -U compdef

# c -> ~/Code/
c() { cd ~/Code/$1; }
_c() { _files -W ~/Code -/; }
compdef _c c

# h -> ~/
h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h