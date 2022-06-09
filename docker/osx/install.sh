#!/bin/bash

set -euo pipefail

if ! docker --version > /dev/null 2>&1; then
  echo "docker for mac cannot be installed via this script"
  echo "visit - https://docs.docker.com/docker-for-mac/install/"
else
  echo "Skipping docker installation: Already installed"
fi
