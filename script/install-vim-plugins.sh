#!/usr/bin/env bash

set -euo pipefail

NVIM_CONFIG="$HOME/.config/nvim/init.vim"

if ! command -v nvim >/dev/null 2>&1; then
  printf 'nvim was not found after package installation.\n' >&2
  exit 1
fi

if [[ ! -f "$NVIM_CONFIG" ]]; then
  printf 'Neovim configuration is not linked correctly.\n' >&2
  exit 1
fi

nvim -es -u "$NVIM_CONFIG" -i NONE -c 'PlugInstall --sync' -c 'qa'
