#!/bin/bash

set -euo pipefail

HERE=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null 2>&1 && pwd)

source $HERE/../common.sh

sudo apt update && sudo apt install -y make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev


install_pyenv
