#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# herdr only loads plugins registered through `herdr plugin install|link`,
# so linking files into ~/.config/herdr/plugins is not enough.
if ! command -v herdr >/dev/null 2>&1; then
  exit 0
fi

installed="$(herdr plugin list)"

is_installed() {
  grep -q -- "- $1 " <<<"$installed"
}

github_plugins=(
  "chmarax.herdr-nvim ChmaraX/herdr-nvim"
  "herdr-beads miiraheart/herdr-beads"
  "herdr-spreader yuk1ty/herdr-spreader"
  "herdr-theme-picker qintmb/herdr-theme-picker"
)

for entry in "${github_plugins[@]}"; do
  read -r id repo <<<"$entry"
  if ! is_installed "$id"; then
    herdr plugin install --yes "$repo"
  fi
done

if ! is_installed jeff.switch; then
  herdr plugin link --enabled "$ROOT/home/config/herdr/plugins/switch"
fi
