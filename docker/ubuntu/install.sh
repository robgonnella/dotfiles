#!/bin/bash

set -euo pipefail

if ! docker --version > /dev/null 2>&1; then
  sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88 # just verifies we have the key
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    test"
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker $USER
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "docker already installed. Skipping"
fi
