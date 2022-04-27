#!/usr/bin/env bash

set -e

BREWFILE=../Brewfile

OS="$(uname -s)"

if [[ "$OS" = "Darwin" ]]
then
  HOMEBREW_LOCATION=/usr/local/bin
elif [[ "$OS" = "Linux" ]]
then
  HOMEBREW_LOCATION=/home/linuxbrew/.linuxbrew/bin
fi

echo "looking for Homebrew installed in $HOMEBREW_LOCATION"

if [ ! -d "$HOMEBREW_LOCATION" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if [[ "$CODESPACES" = "true" ]]; then
  sudo apt-get install build-essential procps curl file git
fi

$(HOMEBREW_LOCATION)/brew bundle install --no-lock --file $(BREWFILE)
