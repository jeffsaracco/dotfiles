#!/usr/bin/env bash

set -e

BREWFILE=../Brewfile

OS="$(uname -s)"

if [ "$OS" = "Darwin"]
  HOMEBREW_LOCATION=/usr/local/bin
else if [ "$OS" = "Linux"]
  HOMEBREW_LOCATION=/home/linuxbrew/.linuxbrew/bin
fi

if [ ! -d "$HOMEBREW_LOCATION" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

$(HOMEBREW_LOCATION)/brew bundle install --no-lock --file $(BREWFILE)
