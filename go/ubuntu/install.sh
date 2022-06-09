#!/bin/bash

set -euo pipefail

install_golang() {
  if ! go version >/dev/null 2>&1; then
    local version=$(curl https://golang.org/VERSION?m=text)
    local arch=${version}.linux-amd64.tar.gz
    wget "https://dl.google.com/go/${arch}"
    rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf ${arch}
    rm ${arch}
  else
    echo "Golang already installed. Skipping."
  fi
}

install_golang
