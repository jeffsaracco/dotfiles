#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WANT_DESKTOP="${1:-false}"
WANT_SERVICES="${2:-false}"
BREW="/opt/homebrew/bin/brew"

if [[ "$(uname -s)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
  printf 'brewstrap.sh supports Apple Silicon macOS only.\n' >&2
  exit 1
fi

if [[ ! -x "$BREW" ]]; then
  if ! xcode-select -p >/dev/null 2>&1 || ! xcrun --find clang >/dev/null 2>&1; then
    printf 'Xcode Command Line Tools are required. Run xcode-select --install, then retry.\n' >&2
    exit 1
  fi

  installer="$(mktemp "${TMPDIR:-/tmp}/homebrew-install.XXXXXX")"
  trap 'rm -f "$installer"' EXIT
  curl --fail --location --show-error --silent \
    --proto '=https' --tlsv1.2 \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    --output "$installer"
  NONINTERACTIVE=1 CI=1 /bin/bash "$installer"
fi

if [[ ! -x "$BREW" ]]; then
  printf 'Homebrew was not installed at %s.\n' "$BREW" >&2
  exit 1
fi

eval "$("$BREW" shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1

"$BREW" bundle install --file="$ROOT/Brewfile"

if [[ "$WANT_DESKTOP" == true ]]; then
  "$BREW" bundle install --file="$ROOT/Brewfile.desktop"
fi

if [[ "$WANT_SERVICES" == true ]]; then
  "$BREW" bundle install --file="$ROOT/Brewfile.services"
fi
