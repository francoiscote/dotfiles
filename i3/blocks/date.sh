#!/bin/sh
#~/.dotfiles/i3/blocks/date.sh

case $BLOCK_BUTTON in
  1)gsimplecal ;;
  3)galculator ;;

esac

date '+%a, %b %d %H:%M'
