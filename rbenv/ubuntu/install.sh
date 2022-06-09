#!/bin/bash

set -euo pipefail

if ! rbenv --version > /dev/null 2>&1; then
  echo "Installing rbenv"
  sudo apt update && sudo apt install -y \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm-dev
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  # install ruby-build as plugin for installing ruby versions
  mkdir -p ~/.rbenv/plugins
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  sudo chown -R $USER ~/.rbenv
else
  echo "rbenv already installed. Skipping."
fi
