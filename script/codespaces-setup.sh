#!/usr/bin/env bash

set -e

if [[ "$CODESPACES" = "true" ]]; then
  sudo apt install ruby-dev
  sudo gem install solargraph

  sudo chsh -s /usr/bin/zsh
fi
