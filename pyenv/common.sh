#!/bin/bash

# common install
install_pyenv() {
  if [ ! -d ~/.pyenv ]; then
    echo "Installing pyenv"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src && cd -
    ~/.pyenv/bin/pyenv install 3.9.5
    ~/.pyenv/bin/pyenv global 3.9.5
  else
    echo "pyenv already installed. Skipping."
  fi

  if [ ! -d ~/.pyenv/plugins/pyenv-virtualenvwrapper ]; then
    echo "Setting up virtualenvwrapper"
    git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
  else
    echo "virtualenvwrapper already setup. Skipping."
  fi
}
