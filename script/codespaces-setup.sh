#!/usr/bin/env bash

set -e

if [[ "$CODESPACES" = "true" ]]; then
  sudo apt install fd-find

  sudo apt install ruby-dev
  sudo gem install solargraph

  sudo chsh -s /usr/bin/zsh

  sudo apt-get install build-essential procps curl file git
fi
