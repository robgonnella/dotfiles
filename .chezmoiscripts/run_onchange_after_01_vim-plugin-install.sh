#!/bin/bash

# Ensure this script runs on Brewfile changes by including a hash of its file contents:
# dot_vimrc: {{ include "dot_vimrc" | sha256sum }}

vim +PluginInstall +qall
