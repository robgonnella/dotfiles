#!/bin/bash

PLATFORM=`uname`

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

install_homebrew() {
  if ! brew --version > /dev/null 2>&1; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Installing coreutils"
    brew update && brew install coreutils
  else
    echo "Skipping homebrew installation: Already installed"
  fi
}

install_zsh() {
  # zsh installed by default on osx
  if [ ! -f /bin/zsh ] && [ "$PLATFORM" = "Linux" ]; then
    echo "Installing zsh"
    sudo apt-get update && sudo apt-get install -y zsh
    chsh -s $(which zsh)

  fi
}

install_spacemacs() {
  if ! emacs --version > /dev/null 2>&1; then
    echo "Installing emacs"
    if [ "$PLATFORM" = "Darwin" ]; then
        brew install emacs-plus 2>&1
    else
        sudo add-apt-repository ppa:kelleyk/emacs
        sudo apt-get update && sudo apt-get install -y emacs26
    fi
    mv ~/.emacs.d ~/.emacs.d.bak
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    git -C ~/.emacs.d checkout develop
  else
    echo "Skipping emacs installation: Already installed"
  fi
  if ! which ispell > /dev/null; then
    echo "Installing ispell"
    eval "$(get_pkg_install_command ispell)"
  fi
}

install_git() {
  if ! git --version > /dev/null 2>&1; then
    echo "Installing git"
    eval "$(get_pkg_install_command git)"
  else
    echo "Skipping git installation: Already installed"
  fi
}

install_vim() {
  if ! vim --version > /dev/null 2>&1; then
    echo "Installing vim"
    eval "$(get_pkg_install_command vim)"
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

install_go() {
  if ! go version > /dev/null 2>&1; then
    echo "Installing golang"
    if [ "$PLATFORM" = "Darwin" ]; then
      brew install go
    else
      sudo add-apt-repository ppa:longsleep/golang-backports
      sudo apt-get update
      sudo apt-get install -y golang-go
    fi
    mkdir -p ~/code/go/src ~/code/go/pkg ~/code/go/bin
  else
    echo "Skipping go installation: Already installed"
  fi
}

install_node() {
  if [ ! -d ~/.nvm ]; then
    echo "Installing nvm"
    if [ "$PLATFORM" = "Linux" ]; then
      eval "$(get_pkg_install_command) curl"
    fi
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
    sudo chown -R $USER ~/.nvm
  else
    echo "Skipping nvm installation: Already installed"
  fi
  if ! node --version > /dev/null 2>&1; then
    . ~/.nvm/nvm.sh
    nvm install node
  else
    echo "Skipping node installation: Already installed"
  fi
}

install_typescript() {
  echo "Installing typescript"
  npm install -g typescript typescript-formatter typescript-language-server tslint
}

install_yarn() {
  if ! yarn --version > /dev/null; then
    echo "Installiing yarn"
    if [ "$PLATFORM" = "Darwin" ]; then
      brew install yarn --ignore-dependencies
    else
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
      sudo apt-get update && sudo apt-get install --no-install-recommends yarn
    fi
  else
    echo "Skipping yarn installation: Already installed"
  fi
}

install_rbenv() {
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
      sudo chown -R $USER ~/.rbenv
    fi
  else
    echo "Skipping rbenv installation: Already installed"
  fi
}

install_docker() {
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
}

install_powerline_fonts() {
  if [ "$PLATFORM" = "Linux" ]; then
    sudo apt-get install fonts-powerline
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

if [ "$PLATFORM" = "Darwin" ]; then
  install_homebrew
fi

if [ "$PLATFORM" = "Linux" ]; then
  install_zsh
fi

install_git
install_vim
install_go
install_node
install_yarn
install_typescript
install_rbenv
install_docker
install_powerline_fonts
install_oh_my_zsh
install_spacemacs

echo "***************************"
echo "Installation complete. You must log out and log back in for changes to take effect"
echo "***************************"

