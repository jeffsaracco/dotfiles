#!/usr/bin/env bash

set -e

if [[ "$CODESPACES" = "true" ]]; then
  sudo apt install ruby-dev
  sudo gem install solargraph

  sudo chsh -s /usr/bin/zsh

  echo "Changing shell to zsh for ${USER}..."
  # Always want to use ZSH as my default shell (e.g. for SSH)
  if ! grep -q "${USER}.*/bin/zsh" /etc/passwd
  then
    sudo chsh -s /bin/zsh ${USER}
  fi
fi
