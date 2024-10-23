#!/bin/bash

if [ ! -d $HOME/.oh-my-zsh/plugins/poetry ]; then
    mkdir $HOME/.oh-my-zsh/plugins/poetry
    poetry completions zsh > $HOME/.oh-my-zsh/plugins/poetry/_poetry
fi
