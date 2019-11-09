#!/bin/bash
#
# Install script from:
# https://github.com/dave-tucker/dotfiles

DOTFILES_ROOT="`pwd`"

set -e

echo ''

info () {
  printf "\r  [\033[00;34m ➔ \033[0m] $1\n"
}

user () {
  printf "\r  [\033[0;33m ❖ \033[0m] $1 \n"
}

success () {
  printf "\r\033[2K  [\033[00;32m ✔ \033[0m] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31m ✖ \033[0m] $1\n"
  echo ''
  exit 1
}

overwrite_all=false
backup_all=false
skip_all=false

symlink_confirm () {
  source=$1
  dest=$2

  if [ -f $dest ] || [ -d $dest ] || [ -h $dest ]
  then

    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then
      user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

      case "$action" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac
    fi

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
    then
      rm -rf $dest
      success "removed $dest"
    fi

    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
    then
      mv $dest $dest\.BAK
      success "moved $dest to $dest.BAK"
    fi

    if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
    then
      symlink $source $dest
    else
      success "skipped $source"
    fi

  else
    symlink $source $dest
  fi
}

symlink () {
  ln -s $1 $2
  success "symlinked $1 to $2"
}

install_dotfiles () {
  info 'installing dotfiles'

  for source in `find $DOTFILES_ROOT -name \*.symlink`
  do
    dest="$HOME/.`basename \"${source%.*}\"`"
    symlink_confirm $source $dest
  done
}

./install-tools.sh
install_dotfiles
unset DOTFILES_ROOT

success "Installation complete!"
info "You must quit and relaunch terminal for changes to take effect"
