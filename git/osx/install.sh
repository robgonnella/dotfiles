#!/bin/bash

set -euo pipefail

if ! git --version > /dev/null 2>&1; then
  echo "Installing git"
  brew install git
else
  echo "git already installed. Skipping."
fi
