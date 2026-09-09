#!/usr/bin/env bash

set -euo pipefail

if [[ "${CODESPACES:-false}" != "true" ]]; then
  exit 0
fi

GPG_SIGNER="/.codespaces/bin/gh-gpgsign"

if [[ -x "$GPG_SIGNER" ]]; then
  git config --file "$HOME/.gitconfig.local" gpg.program "$GPG_SIGNER"
fi
