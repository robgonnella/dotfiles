#!/bin/bash

set -euo pipefail

if ! go version >/dev/null 2>&1; then
  echo "Install using pkg from https://go.dev/doc/install"
else
  echo "Golang already installed. Skipping."
fi
