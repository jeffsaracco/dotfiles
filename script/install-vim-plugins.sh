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

if [[ ! -f "$HOME/.config/nvim/autoload/plug.vim" ]]; then
  printf 'The tracked vim-plug loader is not linked correctly.\n' >&2
  exit 1
fi

if [[ ! -f "$HOME/.config/nvim/plugin-snapshot.vim" ]]; then
  printf 'The reviewed plugin snapshot is not linked correctly.\n' >&2
  exit 1
fi

DOTFILES_NVIM_BOOTSTRAP=1 nvim -es \
  -u "$NVIM_CONFIG" \
  -i NONE \
  -S "$HOME/.config/nvim/plugin-snapshot.vim" \
  -c 'qa'

DOTFILES_NVIM_INSTALL_TOOLS=1 nvim -es \
  -u "$NVIM_CONFIG" \
  -i NONE \
  -c 'MasonInstall --sync css-lsp gopls html-lsp json-lsp lua-language-server ruby-lsp typescript-language-server vim-language-server' \
  -c 'qa'
