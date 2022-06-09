#!/bin/bash

if [ ! -f /bin/zsh ]; then
  echo "Installing zsh"
  install_package zsh
  chsh -s $(which zsh)
fi
