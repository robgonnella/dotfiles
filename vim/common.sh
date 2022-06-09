#!/bin/bash

install_vim_tools() {
  if [ ! -d ~/.vim/colors ]; then
    echo "Vim: creating ~/.vim/colors directory"
    mkdir -p ~/.vim/colors
  fi

  if [ ! -d ~/.vim/bundle ]; then
    echo "Vim: creating ~/.vim/bundle directory"
    mkdir -p ~/.vim/bundle
  fi

  if [ ! -d ~/.vim/zenburn ]; then
    echo "Vim: installing zenburn theme"
    git clone https://github.com/jnurmine/Zenburn.git ~/.vim/zenburn
  fi

  if [ ! -d ~/.vim/predawn ]; then
    echo "Vim: installing predawn theme"
    git clone https://github.com/juanedi/predawn.vim.git ~/.vim/predawn
  fi

  if [ ! -d ~/.vim/apprentice ]; then
    echo "Vim: installing apprentice theme"
    git clone https://github.com/romainl/Apprentice.git ~/.vim/apprentice
  fi

  if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo "Vim: installing Vundle package manager"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  fi

  if [ ! -e ~/.vim/colors/zenburn.vim ]; then
    echo "Vim: linking zenburn color scheme"
    ln -s ~/.vim/zenburn/colors/zenburn.vim ~/.vim/colors/zenburn.vim
  fi

  if [ ! -e ~/.vim/colors/predawn.vim ]; then
    echo "Vim: linking predawn color scheme"
    ln -s ~/.vim/predawn/colors/predawn.vim ~/.vim/colors/predawn.vim
  fi

  if [ ! -e ~/.vim/colors/apprentice.vim ]; then
    echo "Vim: linking apprentice color scheme"
    ln -s ~/.vim/apprentice/colors/apprentice.vim ~/.vim/colors/apprentice.vim
  fi

  vim +PluginInstall +qall
}
