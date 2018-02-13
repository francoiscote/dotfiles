#!/bin/sh
# ------------------------
# Start Programs
# ------------------------

# Left Col: Chat, Dashboard, OBS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window "https://www.twitch.tv/popout/francois_js/chat" "https://www.twitch.tv/francois_js/dashboard"
open -a obs

# Middle Col: Main Browser and Editor
atom -n
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window https://github.com/francoiscote

# Right Column: terminal, Alert Box
open -a Hyper
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window https://streamlabs.com/alert-box/v3/0EBC1BEE88B1EC9FD2D9
