#!/usr/bin/env bash
# Pick a directory with gtm find (fzf-like), then open a new tmux window
# with nvim on the left and a shell on the right.
dir=$("$HOME/.cargo/bin/gtm" find)
[ -z "$dir" ] && exit 0
tmux new-window -c "$dir" \; \
  send-keys 'nvim .' Enter \; \
  split-window -h -c "$dir"
