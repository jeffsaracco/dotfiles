#!/usr/bin/env bash

set -euo pipefail

# Run bin/dotsync at login and every 15 minutes through a launchd agent.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'Skipping the dotsync agent (macOS only); run dotsync by hand here.\n'
  exit 0
fi

label=local.dotfiles.dotsync
plist="$HOME/Library/LaunchAgents/$label.plist"
log="$HOME/Library/Logs/dotsync.log"
domain="gui/$(id -u)"

mkdir -p "$(dirname "$plist")" "$(dirname "$log")"
cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>$ROOT/bin/dotsync</string>
  </array>
  <key>StartInterval</key>
  <integer>900</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$log</string>
  <key>StandardErrorPath</key>
  <string>$log</string>
</dict>
</plist>
PLIST

launchctl bootout "$domain/$label" 2>/dev/null || true
launchctl bootstrap "$domain" "$plist"
printf 'dotsync runs every 15 minutes; log: %s\n' "$log"
