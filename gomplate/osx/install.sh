#!/bin/bash

if ! gomplate -v >/dev/null 2>&1; then
  echo "installing gomplate"
  brew install gomplate
else
  echo "gomplate already installed. Skipping."
fi
