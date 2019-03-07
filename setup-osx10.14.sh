#!/bin/bash

# install homebrew:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brews:
brew update && brew install git vim go rbenv
mkdir -p ~/code/go/src ~/code/go/pkg ~/code/go/bin
echo "export GOPATH=$HOME/code/go" >> ~/.bachrc
echo "PATH=$(go env GOPATH)/bin:$PATH" >> ~/.bashrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# install nvm:
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# install docker:
echo "docker for mac cannot be installed via this script"
echo "visit - https://docs.docker.com/docker-for-mac/install/"
