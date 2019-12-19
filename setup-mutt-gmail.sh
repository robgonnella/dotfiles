#!/bin/bash

set -euo pipefail

if [ "$(uname)" = "Darwin" ]; then
  echo "Installing mutt on osx"
  brew install mutt 2>&1
elif [ "$(uname)" = "Linux" ]; then
  echo "Installing mut on linux"
  sudo apt-get update && sudo apt-get install -y mutt
fi

touch ~/.muttrc

read -p "name: " name
read -p "username: " username
read -sp "password: " password

email=$username@gmail.com

cat > ~/.muttrc <<EOF
set imap_user = "$email"
set imap_pass = "$password"
set smtp_url = "smtp://$username@smtp.gmail.com:587/"
set smtp_pass = "$password"
set from = "$email"
set realname = "$name"
set folder = imaps://imap.gmail.com:993
set spoolfile = +INBOX
set postponed = +[Gmail]/Drafts
set header_cache = ~/.mutt/cache/headers
set message_cachedir = ~/.mutt/cache/bodies
set certificate_file = ~/.mutt/certificates
set move = no
set smtp_authenticators = gssapi:login
set sort = reverse-date-received
EOF
