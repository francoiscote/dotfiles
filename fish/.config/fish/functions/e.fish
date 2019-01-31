#!/bin/fish
#
#
# Quick shortcut to an editor.
#
# This means that as I travel back and forth between editors, hey, I don't have
# to re-learn any arcane commands. Neat.
#
# USAGE:
#
#   $ e
#   # => opens the current directory in your code editor
#
#   $ e .
#   $ e /usr/local
#   # => opens the specified directory in your code editor

function e
    if type -q /usr/local/bin/code
        set CODEEDITOR 'code'
    else if type -q /usr/local/bin/atom-beta
        set CODEEDITOR 'atom-beta'
    else if type -q /usr/local/bin/atom
        set CODEEDITOR 'atom'
    else
        set CODEEDITOR 'vim'
    end

    if test (count $argv) -eq 0
        eval $CODEEDITOR .
    else
        eval $CODEEDITOR $argv
    end
end
