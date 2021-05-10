#!/bin/sh

# ls colors
autoload -U colors && colors
#export LS_COLORS="Gxfxcxdxbxegedabagacad"

# Take advantage of $LS_COLORS for completion as well.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"