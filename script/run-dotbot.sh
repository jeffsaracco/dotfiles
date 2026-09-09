#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${1:-$ROOT/install.conf.json}"
DOTBOT="$ROOT/dotbot/bin/dotbot"

if ! command -v git >/dev/null 2>&1; then
  printf 'git is required to initialize Dotbot and plugin submodules.\n' >&2
  exit 1
fi

if [[ ! -f "$CONFIG" ]]; then
  printf 'Dotbot configuration does not exist: %s\n' "$CONFIG" >&2
  exit 1
fi

git -C "$ROOT" submodule sync --quiet --recursive
git -C "$ROOT" submodule update --init --recursive

if [[ ! -x "$DOTBOT" ]]; then
  printf 'Dotbot is unavailable after initializing submodules.\n' >&2
  exit 1
fi

"$DOTBOT" -d "$ROOT" -c "$CONFIG"
