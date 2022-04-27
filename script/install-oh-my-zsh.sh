#!/usr/bin/env bash

if [[ ! -d ~/.oh-my-zsh ]]
then
  ZSH= sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "oh-my-zsh is already installed"
  
fi
