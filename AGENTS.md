# AGENTS.md

This repository is an OpenClaw skill collection. Each `skills/ljg-*` directory is a standalone skill containing a required `SKILL.md` and optional `references/`, `assets/`, or `scripts/`.

## Structure

```text
ljg-skills-openclaw/
├── skills/ljg-*/SKILL.md          # OpenClaw skills
├── skills/ljg-*/references/       # Optional reference docs
├── skills/ljg-*/assets/           # Optional templates/assets
├── scripts/install.sh             # Copy all skills to ~/.openclaw/skills
└── .claude-plugin/                # Compatibility bundle metadata; OpenClaw can load Claude bundles
```

## Safety rules

- Do not commit secrets, tokens, personal configs, generated PNGs, or `node_modules/`.
- Keep executable scripts small and auditable.
- Avoid adding network calls to skill scripts unless the skill clearly requires them and the README documents it.
- `ljg-card` is the only skill with runtime dependencies: Node.js + Playwright Chromium.

## Local test

```bash
bash scripts/install.sh
openclaw gateway restart
openclaw skills list --json | jq '.[] | select(.name | startswith("ljg-")) | .name'
bash ~/.openclaw/skills/ljg-skill-map/scripts/scan.sh
```
