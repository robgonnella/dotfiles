#!/bin/bash

install_volta() {
  if ! which volta >/dev/null 2>&1; then
    echo "Installing volta"
    curl https://get.volta.sh | bash
  else
    echo "volta already installed. Skipping."
  fi

  if ! node -v >/dev/null 2>&1; then
    echo "Installing node"
    $HOME/.volta/bin/volta install node
  else
    echo "node already installed. Skipping."
  fi
}
