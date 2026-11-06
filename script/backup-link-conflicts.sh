#!/usr/bin/env bash

set -euo pipefail

# Dotbot refuses to replace real files or directories with links, so move any
# such link targets aside before it runs.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${1:-$ROOT/install.conf.json}"

python3 - "$ROOT" "$CONFIG" <<'EOF'
import json, os, sys, time

root = os.path.realpath(sys.argv[1])
stamp = time.strftime("%Y%m%d%H%M%S")

for directive in json.load(open(sys.argv[2])):
    for target in directive.get("link", {}):
        path = os.path.expanduser(target)
        if os.path.islink(path) or not os.path.exists(path):
            continue
        # Skip paths that already resolve into the repo through a linked parent.
        if os.path.commonpath([root, os.path.realpath(path)]) == root:
            continue
        backup = f"{path}.backup.{stamp}"
        os.rename(path, backup)
        print(f"Moved existing {target} to {backup}.")
EOF
