#!/bin/bash

install_volta() {
  if ! which volta; then
    echo "Installing volta"
    curl https://get.volta.sh | bash
  fi

  if ! node -v; then
    echo "Installing node"
    $HOME/.volta/bin/volta install node
  fi
}
