#!/bin/bash

set -euo pipefail

HERE=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)

source $HERE/../common.sh

if ! vim --version > /dev/null 2>&1; then
  echo "Installing vim"
  brew install vim
else
  echo "vim already installed. Skipping."
fi

install_vim_tools
