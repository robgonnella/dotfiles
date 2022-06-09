#!/bin/bash

set -euo pipefail

HERE=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)

source $HERE/../common.sh

if ! which tmux >/dev/null 2>&1; then
  echo "Installing tmux"
  brew install tmux
else
  echo "tmux already installed. Skipping."
fi

setup_tpm
