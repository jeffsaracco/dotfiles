#!/usr/bin/env bash

set -euo pipefail

ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"

if ! command -v git >/dev/null 2>&1; then
  printf 'git is required to install Oh My Zsh.\n' >&2
  exit 1
fi

if [[ -e "$ZSH_DIR" || -L "$ZSH_DIR" ]]; then
  if [[ ! -f "$ZSH_DIR/oh-my-zsh.sh" ]]; then
    printf '%s exists but is not an Oh My Zsh installation.\n' "$ZSH_DIR" >&2
    exit 1
  fi
  exit 0
fi

GIT_TERMINAL_PROMPT=0 git clone --depth=1 \
  https://github.com/ohmyzsh/ohmyzsh.git \
  "$ZSH_DIR"
