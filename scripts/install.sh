#!/usr/bin/env bash
# Install this OpenClaw skill collection into ~/.openclaw/skills.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$REPO_DIR/skills"
DEST_DIR="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"

if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: skills directory not found: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"

for skill in "$SRC_DIR"/ljg-*; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  target="$DEST_DIR/$name"
  rm -rf "$target"
  mkdir -p "$target"
  tar -C "$skill" -cf - . | tar -C "$target" -xf -
  echo "Installed $name -> $target"
done

CARD_DIR="$DEST_DIR/ljg-card"
if [ -f "$CARD_DIR/package.json" ]; then
  if command -v npm >/dev/null 2>&1; then
    echo "Installing ljg-card Node dependencies..."
    (cd "$CARD_DIR" && npm install)
    if command -v npx >/dev/null 2>&1; then
      echo "Installing Playwright Chromium for ljg-card..."
      (cd "$CARD_DIR" && npx playwright install chromium)
    fi
  else
    echo "WARN: npm not found; ljg-card dependencies were not installed." >&2
  fi
fi

echo "Done. Restart OpenClaw or start a new session, then run: openclaw skills list | grep ljg"
