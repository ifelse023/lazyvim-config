#!/usr/bin/env bash
paths=$(yazi "$2" --chooser-file=/dev/stdout | while read -r; do printf "%q " "$REPLY"; done)
if [[ -n "$paths" ]]; then
  zellij action toggle-floating-panes
  zellij action write 27 # <Escape>
  zellij action write-chars ":e $paths"
  zellij action write 13 # <Enter>
else
  zellij action toggle-floating-panes
fi
