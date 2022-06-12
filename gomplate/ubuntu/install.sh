#!/bin/bash

if ! gomplate -v >/dev/null 2>&1; then
  echo "installing gomplate"
  sudo apt update && sudo apt install -y jq curl ca-certificates
  url=$(curl https://api.github.com/repos/hairyhenderson/gomplate/releases/latest | jq '.assets | .[] | select(.name=="gomplate_linux-amd64") | .browser_download_url')
  url="${url//\"/}"
  sudo curl -Lo /usr/local/bin/gomplate $url
  sudo chmod +x /usr/local/bin/gomplate
else
  echo "gomplate already installed. Skipping."
fi