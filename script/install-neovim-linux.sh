#!/usr/bin/env bash

set -euo pipefail

VERSION="0.12.5"
BASE_URL="https://github.com/neovim/neovim/releases/download/v$VERSION"

case "$(uname -m)" in
  x86_64)
    ARCHIVE="nvim-linux-x86_64.tar.gz"
    SHA256="bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875"
    ;;
  aarch64|arm64)
    ARCHIVE="nvim-linux-arm64.tar.gz"
    SHA256="1aa5ca085249580ae0f91eb14f27ec0919773ff2d99a163d03f3d6c21ac29725"
    ;;
  *)
    printf 'Unsupported Linux architecture: %s\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

INSTALL_DIR="$HOME/.local/lib/nvim-$VERSION"
if [[ -x "$INSTALL_DIR/bin/nvim" ]]; then
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
  exit 0
fi

archive_path="$(mktemp "${TMPDIR:-/tmp}/nvim.XXXXXX.tar.gz")"
extract_dir="$(mktemp -d "${TMPDIR:-/tmp}/nvim.XXXXXX")"
trap 'rm -rf "$archive_path" "$extract_dir"' EXIT

curl --fail --location --show-error --silent \
  --proto '=https' --tlsv1.2 \
  "$BASE_URL/$ARCHIVE" \
  --output "$archive_path"
printf '%s  %s\n' "$SHA256" "$archive_path" | sha256sum --check --status

tar -xzf "$archive_path" -C "$extract_dir" --strip-components=1
mkdir -p "$HOME/.local/lib" "$HOME/.local/bin"
mv "$extract_dir" "$INSTALL_DIR"
ln -sfn "$INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
