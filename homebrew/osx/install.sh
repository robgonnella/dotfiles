#!/bin/bash

set -euo pipefail

if ! brew --version > /dev/null 2>&1; then
  echo "Installing homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Installing coreutils"
  brew install \
    coreutils \
    findutils \
    gnu-tar \
    gnu-time \
    gnu-sed \
    gawk \
    gnutls \
    gnu-getopt \
    grep
else
  echo "homebrew already installed. Skipping"
fi
