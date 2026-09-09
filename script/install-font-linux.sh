#!/usr/bin/env bash

set -euo pipefail

VERSION="3.5.1"
ARCHIVE="Hack.tar.xz"
SHA256="cdd389472e10e2261520140ff1b382b4f8a226af5fd0b2735b975d31151d9c3c"
FONT_DIR="$HOME/.local/share/fonts/HackNerdFont"

if [[ -f "$FONT_DIR/HackNerdFontMono-Regular.ttf" ]]; then
  exit 0
fi

archive_path="$(mktemp "${TMPDIR:-/tmp}/hack-nerd-font.XXXXXX.tar.xz")"
extract_dir="$(mktemp -d "${TMPDIR:-/tmp}/hack-nerd-font.XXXXXX")"
trap 'rm -rf "$archive_path" "$extract_dir"' EXIT

curl --fail --location --show-error --silent \
  --proto '=https' --tlsv1.2 \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v$VERSION/$ARCHIVE" \
  --output "$archive_path"
printf '%s  %s\n' "$SHA256" "$archive_path" | sha256sum --check --status

tar -xJf "$archive_path" -C "$extract_dir"
mkdir -p "$FONT_DIR"
cp "$extract_dir"/*.ttf "$FONT_DIR"/
fc-cache -f "$FONT_DIR"
