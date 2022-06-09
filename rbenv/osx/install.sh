#!/bin/bash

set -euo pipefail

if ! rbenv --version > /dev/null 2>&1; then
  echo "Installing rbenv"
  brew install rbenv
else
  echo "Skipping rbenv installation: Already installed"
fi
