#!/bin/bash

set -euo pipefail

HERE=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)

source $HERE/../common.sh

if ! vim --version > /dev/null 2>&1; then
  echo "Installing vim"
  sudo apt update && sudo apt install -y vim
else
  echo "vim already installed. Skipping."
fi

install_vim_tools
