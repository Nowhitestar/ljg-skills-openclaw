#!/usr/bin/env bash
# Usage: sync-push.sh <skill-name> <commit-message>
# Syncs a local OpenClaw ljg-* skill from ~/.openclaw/skills into this repo and pushes.
# Auto-bumps patch version in bundle metadata.

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <skill-name> <commit-message>" >&2
  exit 2
fi

SKILL="$1"
MSG="$2"
REPO="${LJG_SKILLS_REPO:-$HOME/.openclaw/workspace/ljg-skills-openclaw}"
LOCAL="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}/$SKILL"
TARGET="$REPO/skills/$SKILL"

if [ ! -d "$LOCAL" ]; then
  echo "ERROR: $LOCAL does not exist" >&2
  exit 1
fi

cd "$REPO"
git pull --rebase --quiet
rsync -av --delete --exclude='.git' "$LOCAL/" "$TARGET/"

bump_version() {
  local file="$1"
  [ -f "$file" ] || return 0
  local current
  current=$(grep -m1 '"version"' "$file" | sed 's/.*"\([0-9]*\.[0-9]*\.[0-9]*\)".*/\1/')
  [ -n "$current" ] || return 0
  local major minor patch
  major=$(echo "$current" | cut -d. -f1)
  minor=$(echo "$current" | cut -d. -f2)
  patch=$(echo "$current" | cut -d. -f3)
  local new_version="$major.$minor.$((patch + 1))"
  sed -i '' "s/\"version\": \"$current\"/\"version\": \"$new_version\"/" "$file"
  echo "$new_version"
}

NEW_VER=$(bump_version ".claude-plugin/plugin.json" || true)
bump_version ".claude-plugin/marketplace.json" >/dev/null || true

git add "skills/$SKILL" .claude-plugin/
git diff --cached --quiet && { echo "No changes to push."; exit 0; }
git commit -m "$MSG${NEW_VER:+ (v$NEW_VER)}"
git push
echo "Pushed $SKILL${NEW_VER:+ at collection v$NEW_VER}"
