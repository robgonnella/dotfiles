#!/bin/bash

set -euo pipefail

if [ ! -f /Applications/Rectangle.app/Contents/MacOS/Rectangle ]; then
  echo "Installing rectangle"
  brew install --cask rectangle
fi
