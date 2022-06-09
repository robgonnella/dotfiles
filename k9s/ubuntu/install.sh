#!/bin/bash

set -euo pipefail

install_k9s() {
  if ! k9s version > /dev/null 2>&1; then
    echo "Installing k9s"

    sudo apt update && sudo apt install -y jq curl ca-certificates
    local url=$(curl https://api.github.com/repos/derailed/k9s/releases/latest | jq '.assets | .[] | select(.name=="k9s_Linux_x86_64.tar.gz") | .browser_download_url')
    local filename=$(basename "$url")
    local ext="${filename##*.}"

    url="${url//\"/}"
    curl -LO $url
    mkdir k9s_uncompressed

    trap "rm -rf ${filename} k9s_uncompressed" RETURN

    if [ "${ext}" = "gz" ]; then
      tar -C k9s_uncompressed -xvf $filename
      mv k9s_uncompressed/k9s /usr/local/bin/
    else
      echo "Unsupported file format ${filename}"
      exit 1
    fi
  else
    echo "k9s already installed. Skipping"
  fi
}

install_k9s
