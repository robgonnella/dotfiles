#!/bin/bash

set -euo pipefail

if ! git --version > /dev/null 2>&1; then
  echo "Installing git"
  sudo apt update && sudo apt install -y git
else
  echo "Skipping git installation: Already installed"
fi
