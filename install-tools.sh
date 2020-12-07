#!/bin/bash

PLATFORM=`uname`

echo "Running setup: Platform: ${PLATFORM}"

install_package() {
  if [ "$PLATFORM" = "Darwin" ]; then
    brew update && brew install "$@"
  elif [ "$PLATFORM" = "Linux" ]; then
    sudo apt-get update && sudo apt-get install -y "$@"
  else
    echo "Unsupported platform: $PLATFORM"
    exit 1
  fi
}

install_homebrew() {
  if [ "$PLATFORM" = "Darwin" ]; then
    if ! brew --version > /dev/null 2>&1; then
        echo "Installing homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        echo "Installing coreutils"
        install_package coreutils
    else
        echo "Skipping homebrew installation: Already installed"
    fi
  fi
}

install_zsh() {
  # zsh installed by default on osx
  if [ ! -f /bin/zsh ] && [ "$PLATFORM" = "Linux" ]; then
    echo "Installing zsh"
    install_package zsh
    chsh -s $(which zsh)

  fi
}

install_git() {
  if ! git --version > /dev/null 2>&1; then
    echo "Installing git"
    install_package git
  else
    echo "Skipping git installation: Already installed"
  fi
}

install_vim() {
  if ! vim --version > /dev/null 2>&1; then
    echo "Installing vim"
    install_package vim
    # install vim tools
    mkdir -p ~/.vim/colors ~/.vim/bundle
    git clone https://github.com/jnurmine/Zenburn.git ~/.vim/zenburn
    git clone https://github.com/juanedi/predawn.vim.git ~/.vim/predawn
    git clone https://github.com/romainl/Apprentice.git ~/.vim/apprentice
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ln -s ~/.vim/predawn/colors/predawn.vim ~/.vim/colors/predawn.vim
    ln -s ~/.vim/zenburn/colors/zenburn.vim ~/.vim/colors/zenburn.vim
    ln -s ~/.vim/apprentice/colors/apprentice.vim ~/.vim/colors/apprentice.vim
  else
    echo "Skipping vim installation: Already installed"
  fi
}

install_docker() {
  if ! docker --version > /dev/null 2>&1; then
    if [ "$PLATFORM" = "Linux" ]; then
      install_package \
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
        stable"
      install_package docker-ce docker-ce-cli containerd.io
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
}

install_powerline_fonts() {
  if [ "$PLATFORM" = "Linux" ]; then
    install_package fonts-powerline
  else
    git clone https://github.com/powerline/fonts.git ~/fonts
    ~/fonts/install.sh
  fi
}

install_oh_my_zsh() {
  if [ ! -d ~/.oh-my-zsh ]; then
    echo "Installing oh-my-zsh"
    curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    echo "source \$HOME/.rc_ext" >> ~/.zshrc
    if [ "$PLATFORM" = "Linux" ]; then
      sed -i 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/g' ~/.zshrc
    elif [ "$PLATFORM" = "Darwin" ]; then
      sed -i '' 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/g' $HOME/.zshrc
    fi
  else
    echo "Skipping oh-my-zsh installation: Already installed"
  fi
}

install_homebrew
install_git
install_zsh
install_vim
install_docker
install_powerline_fonts
install_oh_my_zsh
echo "***************************"
echo "Installation complete. You must log out and log back in for changes to take effect"
echo "***************************"
