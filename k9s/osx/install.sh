#!/bin/bash

set -euo pipefail

if ! k9s version > /dev/null 2>&1; then
  echo "Installing direnv"
  brew install k9s
else
  echo "k9s already installed. Skipping"
fi
