#!/bin/bash

setup_tpm() {
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Tmux: setting up tpm"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    echo "Tmux: tpm setup already exists. Skipping."
  fi
}
