#!/usr/bin/env bash

set -euo pipefail

# Claude Code's native installer puts the launcher at ~/.local/bin/claude and
# keeps it updated in the background, so only run it when it's missing.
if [[ -x "$HOME/.local/bin/claude" ]] || command -v claude >/dev/null 2>&1; then
  exit 0
fi

curl -fsSL https://claude.ai/install.sh | bash
