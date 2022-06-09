#!/bin/bash

set -euo pipefail

if ! git --version > /dev/null 2>&1; then
  echo "Installing git"
  brew install git
else
  echo "Skipping git installation: Already installed"
fi
