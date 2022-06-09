#!/bin/bash
#
# Install script from:
# https://github.com/dave-tucker/dotfiles

set -euo pipefail

DOTFILES_ROOT=$(pwd)
PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"

if [ "$PLATFORM" = "darwin" ]; then
  OS=osx
elif [ "$PLATFORM" = "linux" ] && [ -f /etc/os-release ]; then
  if cat /etc/os-release | grep ubuntu >/dev/null; then
    OS=ubuntu
  else
    echo "Unsupported platform"
    cat /etc/os-release
    exit 1
  fi
else
  echo "Unsupported platform"
  exit 1
fi

echo ''

info() {
  printf "\r  [\033[00;34m ➔ \033[0m] $1\n"
}

user() {
  printf "\r  [\033[0;33m ❖ \033[0m] $1 \n"
}

success() {
  printf "\r\033[2K  [\033[00;32m ✔ \033[0m] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31m ✖ \033[0m] $1\n"
  echo ''
  exit 1
}

overwrite_all=false
backup_all=false
skip_all=false

symlink_confirm() {
  source=$1
  dest=$2

  if [ -f $dest ] || [ -d $dest ] || [ -h $dest ]; then

    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" == "false" ] \
      && [ "$backup_all" == "false" ] \
      && [ "$skip_all" == "false" ]; then

      read -r -d '\0' output <<- EOF
File already exists: `basename $source`, what do you want to do?
[s]kip
[S]kip all
[o]verwrite
[O]verwrite all
[b]ackup
[B]ackup all?\0
EOF

      user "${output}"

      read -n 1 action

      case "$action" in
        o ) overwrite=true;;
        O ) overwrite_all=true;;
        b ) backup=true;;
        B ) backup_all=true;;
        s ) skip=true;;
        S ) skip_all=true;;
        * ) ;;
      esac
    fi

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
      rm -rf $dest
      success "removed $dest"
    fi

    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
      mv $dest $dest\.BAK
      success "moved $dest to $dest.BAK"
    fi

    if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
      symlink $source $dest
    else
      success "skipped $source"
    fi

  else
    symlink $source $dest
  fi
}

symlink() {
  ln -s $1 $2
  success "symlinked $1 to $2"
}

install_software() {
  for d in $DOTFILES_ROOT/*; do
    if [ ! -d $d ]; then
      continue
    fi
    echo "${d#$DOTFILES_ROOT/}"
    if [ -f "$d/$OS/install.sh" ]; then
      $d/$OS/install.sh
    else
      echo "$d/$OS/install.sh does not exist. Skipping"
    fi
  done
}

install_dotfiles() {
  info 'installing dotfiles'

  # install common dotfiles
  for d in $DOTFILES_ROOT/*; do
    if [ ! -d "$d" ]; then
      continue
    fi
    for src in $(find $d/$OS -name "*.symlink" -depth 1); do
      dest="$HOME/.`basename \"${src%.*}\"`"
      symlink_confirm $src $dest
    done
  done

  # install common dotfiles
  for src in $(find $DOTFILES_ROOT -name "*.symlink" -depth 2); do
    dest="$HOME/.`basename \"${src%.*}\"`"
    symlink_confirm $src $dest
  done
}

update_rc_file() {
  # add common tooling setup
  echo "" > $HOME/.rc_tools
  for src in $(find $DOTFILES_ROOT -name "ZSH" -depth 2); do
    cat $src >> $HOME/.rc_tools
    echo "" >> $HOME/.rc_tools
  done

  # add os specific tooling setup
  for d in $DOTFILES_ROOT/*; do
    if [ ! -d "$d" ]; then
      continue
    fi
    for src in $(find $d/$OS -name "ZSH" -depth 1); do
      cat $src >> $HOME/.rc_tools
      echo "" >> $HOME/.rc_tools
    done
  done
}

install_software
install_dotfiles
update_rc_file
unset DOTFILES_ROOT
unset PLATFORM
unset OS

success "Installation complete!"
info "You must quit and relaunch terminal for changes to take effect"
