#!/bin/bash

PLATFORM=`uname -s`

echo "Running setup: Platform: ${PLATFORM}"

get_pkg_install_command() {
  local pkg=$1
  if [ "$PLATFORM" = "Darwin" ]; then
    echo "brew update && brew install $pkg"
  elif [ "$PLATFORM" = "Linux" ]; then
    echo "sudo apt-get update && sudo apt-get install -y $pkg"
  else
    echo "Unsupported platform: $PLATFORM"
    exit 1
  fi
}

if [ "$PLATFORM" = "Darwin" ]; then
  # install homebrew:
  if ! brew --version > /dev/null 2>&1; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Installing coreutils"
    brew update && brew install coreutils
  else
    echo "Skipping homebrew installation: Already installed"
  fi
fi

# install git:
if ! git --version > /dev/null 2>&1; then
  echo "Installing git"
  eval "$(get_pkg_install_command git)"
  if [ "$PLATFORM" = "Darwin" ]; then
    eval "$(get_pkg_install_command bash-completion)"
  fi
else
  echo "Skipping git installation: Already installed"
fi

# install vim:
if ! vim --version > /dev/null 2>&1; then
  echo "Installing vim"
  eval "$(get_pkg_install_command vim)"
else
  echo "Skipping vim installation: Already installed"
fi

# install vim tools
mkdir -p ~/.vim/colors ~/.vim/bundle
git clone https://github.com/jnurmine/Zenburn.git ~/.vim/zenburn
git clone https://github.com/juanedi/predawn.vim.git ~/.vim/predawn
git clone https://github.com/romainl/Apprentice.git ~/.vim/apprentice
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s ~/.vim/predawn/colors/predawn.vim ~/.vim/colors/predawn.vim
ln -s ~/.vim/zenburn/colors/zenburn.vim ~/.vim/colors/zenburn.vim
ln -s ~/.vim/apprentice/colors/apprentice.vim ~/.vim/colors/apprentice.vim

# # install go:
if ! go version > /dev/null 2>&1; then
  echo "Installing golang"
  if [ "$PLATFORM" = "Darwin" ]; then
    eval "$(get_pkg_install_command go)"
  else
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt-get update
    eval "$(get_pkg_install_command golang-go)"
  fi
  mkdir -p ~/code/go/src ~/code/go/pkg ~/code/go/bin
else
  echo "Skipping go installation: Already installed"
fi

# install nvm:
if [ ! -d ~/.nvm ]; then
  echo "Installing nvm"
  if [ "$PLATFORM" = "Linux" ]; then
    eval "$(get_pkg_install_command) curl"
  fi
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
else
  echo "Skipping nvm installation: Already installed"
fi

# install rbenv:
if ! rbenv --version > /dev/null 2>&1; then
  echo "Installing rbenv"
  if [ "$PLATFORM" = "Darwin" ]; then
    eval "$(get_pkg_install_command) rbenv"
  else
    sudo apt update
    sudo apt install -y \
      autoconf \
      bison \
      build-essential \
      libssl-dev \
      libyaml-dev \
      libreadline6-dev \
      zlib1g-dev \
      libncurses5-dev \
      libffi-dev \
      libgdbm5 \
      libgdbm-dev
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    # install ruby-build as plugin for installing ruby versions
    mkdir -p ~/.rbenv/plugins
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi
else
  echo "Skipping rbenv installation: Already installed"
fi

# install docker:
if ! docker --version > /dev/null 2>&1; then
  if [ "$PLATFORM" = "Linux" ]; then
    sudo apt-get update
    sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88 # just verifies we have the key
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "docker for mac cannot be installed via this script"
    echo "visit - https://docs.docker.com/docker-for-mac/install/"
  fi
else
  echo "Skipping docker installation: Already installed"
fi
