#!/bin/bash

set -euo pipefail

if ! direnv --version > /dev/null 2>&1; then
  echo "Installing direnv"
  sudo apt update && sudo apt install -y direnv
else
  echo "direnv already installed. Skipping"
fi
