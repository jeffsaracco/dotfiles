#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WANT_DESKTOP="${1:-false}"
WANT_SERVICES="${2:-false}"

if [[ "$EUID" -eq 0 ]]; then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  printf 'sudo is required to install apt packages.\n' >&2
  exit 1
fi

install_package_file() {
  local package_file="$1"
  local packages=()

  mapfile -t packages < "$package_file"
  if [[ "${#packages[@]}" -gt 0 ]]; then
    "${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive \
      apt-get install -y --no-install-recommends "${packages[@]}"
  fi
}

"${SUDO[@]}" env DEBIAN_FRONTEND=noninteractive apt-get update
install_package_file "$ROOT/packages/apt-base.txt"

if [[ "$WANT_DESKTOP" == true ]]; then
  install_package_file "$ROOT/packages/apt-desktop.txt"
fi

if [[ "$WANT_SERVICES" == true ]]; then
  install_package_file "$ROOT/packages/apt-services.txt"
fi
