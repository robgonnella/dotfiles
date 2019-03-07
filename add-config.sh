#!/bin/bash

set -e

currDir=`pwd`

add_nvm_config() {
  echo "adding nvm config"
  echo '
# NVM Setup
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
}

add_go_config() {
  echo "adding go config"
  echo '
# GOLANG Setup
# Set path to go directory
# https://golang.org/doc/install
export GOPATH="$HOME/code/go"' >> ~/.bashrc
}

add_path_extras() {
  echo "extending path"
  echo '
# ======================================
# Add script drectories to PATH
# =====================================
PATH="$HOME/.rbenv/bin:$PATH"                  # RBENV
PATH="/usr/local/bin:/usr/local/sbin:$PATH"    # Homebrew
PATH="/usr/local/heroku/bin:$PATH"             # Heroku Toolbelt
PATH="$(go env GOPATH)/bin:$PATH"              # Go bin' >> ~/.bashrc
}

add_all_config() {
  add_nvm_config
  add_go_config
  add_path_extras
  add_vundle
}

add_vundle() {
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || true
  mkdir -p ~/.vim/colors
  ln -s $currDir/vim/predawn.vim ~/.vim/colors/predawn.vim
}

while [[ $# -gt 0 ]]
do
action="$1"

case $action in
    --nvm) NVM=true; shift;;
    --go) GO=true; shift;;
    --path) PATH_EXTRAS=true; shift;;
    --vundle) VUNDLE=true; shift;;
    --all) ALL=true; shift;;
    *) # unknown option;;
esac
done

if [ -n "${ALL}" ]; then
  echo "adding all config"
  add_all_config
  exit 0
fi

if [ -n "${NVM}" ]; then
  add_nvm_config
fi

if [ -n "${GO}" ]; then
  add_go_config
fi

if [ -n "${PATH_EXTRAS}" ]; then
  add_path_extras
fi

if [ -n "${VUNDLE}" ]; then
  add_vundle
fi

exit 0