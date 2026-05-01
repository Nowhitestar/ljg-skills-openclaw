#!/usr/bin/env bash
# Scan installed OpenClaw skills and extract frontmatter metadata as JSON.
set -euo pipefail

ROOTS=()
[ -n "${OPENCLAW_WORKSPACE:-}" ] && ROOTS+=("$OPENCLAW_WORKSPACE/skills")
ROOTS+=("$PWD/skills")
ROOTS+=("$HOME/.openclaw/workspace/skills")
ROOTS+=("$HOME/.openclaw/workspace/.agents/skills")
ROOTS+=("$HOME/.agents/skills")
ROOTS+=("$HOME/.openclaw/skills")

first=1
echo "["
seen=""

json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().rstrip("\n"), ensure_ascii=False)[1:-1])'
}

for root in "${ROOTS[@]}"; do
  [ -d "$root" ] || continue
  for skill_dir in "$root"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue
    dir_name=$(basename "$skill_dir")
    case " $seen " in *" $dir_name "*) continue;; esac
    seen="$seen $dir_name"

    clean=$(tr -d '\r' < "$skill_file")
    frontmatter=$(printf '%s\n' "$clean" | awk 'BEGIN{n=0} /^---$/{n++; next} n==1{print} n==2{exit}')
    [ -z "$frontmatter" ] && continue

    name=$(echo "$frontmatter" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//' | tr -d '"')
    version=$(echo "$frontmatter" | grep -m1 '^version:' | sed 's/^version:[[:space:]]*//' | tr -d '"' || true)
    invocable=$(echo "$frontmatter" | grep -m1 '^user_invocable:' | sed 's/^user_invocable:[[:space:]]*//' | tr -d '"' || true)
    desc_line=$(echo "$frontmatter" | grep -m1 '^description:' || true)
    desc_value=$(echo "$desc_line" | sed 's/^description:[[:space:]]*//')

    if [[ "$desc_value" == '>'* ]] || [[ "$desc_value" == '|'* ]]; then
      desc=$(echo "$frontmatter" | sed -n '/^description:/,/^[a-zA-Z_][a-zA-Z0-9_-]*:/{ /^description:/d; /^[a-zA-Z_][a-zA-Z0-9_-]*:/d; p; }' | sed 's/^[[:space:]]*//' | tr -d '"' | tr '\n' ' ' | sed 's/[[:space:]]*$//')
    else
      desc=$(echo "$desc_value" | tr -d '"')
    fi

    short=$(echo "$desc" | sed 's/\. .*//' | sed 's/。.*//' | cut -c1-100)
    : "${name:=$dir_name}"
    : "${version:=-}"
    : "${invocable:=false}"

    if (( first )); then first=0; else echo ","; fi
    printf '  {"name":"%s","version":"%s","invocable":%s,"root":"%s","desc":"%s"}' \
      "$(printf '%s' "$name" | json_escape)" \
      "$(printf '%s' "$version" | json_escape)" \
      "$invocable" \
      "$(printf '%s' "$root" | json_escape)" \
      "$(printf '%s' "$short" | json_escape)"
  done
done

echo ""
echo "]"
