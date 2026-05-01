# LJG Skills for OpenClaw

A curated OpenClaw skill collection for paper reading, concept analysis, visual cards, writing, travel research, and structured thinking workflows.

This fork converts the original Claude-oriented skill pack into an OpenClaw-ready collection while keeping the `.claude-plugin/` bundle metadata for compatibility with OpenClaw's bundle loader.

## Safety audit summary

Current repository state was checked for common dangerous patterns and secrets.

- No hardcoded API keys, OAuth tokens, private keys, or obvious credentials found.
- No `curl | bash`, `sudo`, `rm -rf`, `eval`, or hidden destructive install step found.
- The only dependency installer is `scripts/install.sh`, which copies skill folders into `~/.openclaw/skills` and optionally installs `ljg-card` dependencies with `npm install` + `npx playwright install chromium`.
- `ljg-card` contains a Node/Playwright screenshot workflow. Treat third-party npm dependencies as normal supply-chain risk; review `skills/ljg-card/package-lock.json` before use in high-security environments.

## Install

### Option A: clone and install into shared OpenClaw skills

```bash
git clone https://github.com/Nowhitestar/ljg-skills-openclaw.git
cd ljg-skills-openclaw
bash scripts/install.sh
openclaw gateway restart
```

The installer copies every `skills/ljg-*` directory to:

```text
~/.openclaw/skills/
```

Then start a new OpenClaw session or restart the gateway so skills are reloaded.

### Option B: install as an OpenClaw-compatible bundle

OpenClaw can load Claude-compatible bundles, so this also works:

```bash
git clone https://github.com/Nowhitestar/ljg-skills-openclaw.git
openclaw plugins install ./ljg-skills-openclaw
openclaw gateway restart
```

For day-to-day use, Option A is simpler and transparent.

## Verify

```bash
openclaw skills list | grep ljg
openclaw skills check --verbose | grep ljg
bash ~/.openclaw/skills/ljg-skill-map/scripts/scan.sh
```

## Skills

| Skill | Use it for |
|---|---|
| `ljg-card` | Cast content into PNG visual cards: long card, infograph, multi-card, sketchnote, comic, whiteboard, big-font attachment card |
| `ljg-learn` | Deconstruct a concept through eight dimensions and compress it into an insight |
| `ljg-paper` | Read a research paper for ideas rather than academic critique |
| `ljg-paper-river` | Trace a paper's intellectual lineage and problem evolution |
| `ljg-paper-flow` | Read a paper and generate a visual sketchnote/card in one workflow |
| `ljg-plain` | Rewrite content so a smart 12-year-old can understand it |
| `ljg-rank` | Reduce a domain to its irreducible generators |
| `ljg-think` | Drill vertically into the root of an idea, problem, or phenomenon |
| `ljg-word` | Deeply master an English word through semantic analysis |
| `ljg-word-flow` | Analyze English words and cast them into infograph cards |
| `ljg-writes` | Write a 1000–1500 word critical essay that peels an idea layer by layer |
| `ljg-invest` | Evaluate whether a project is an “order-generating machine” |
| `ljg-read` | Guided reading companion for books, essays, articles, papers, and news |
| `ljg-relationship` | Diagnose relationship issues through structure + psychoanalytic depth |
| `ljg-roundtable` | Run a structured, truth-seeking multi-perspective roundtable discussion |
| `ljg-travel` | Produce deep cultural travel research for museums and ancient architecture |
| `ljg-present` | Generate Takahashi-style or manifesto-style HTML slides |
| `ljg-skill-map` | Scan installed OpenClaw skills and render a visual map |

## Examples

Ask OpenClaw naturally:

```text
用 ljg-paper 读这篇论文：https://arxiv.org/abs/xxxx.xxxxx
把这段内容用 ljg-plain 说人话
用 ljg-card -i 把这篇文章做成信息图
用 ljg-word 解释 serendipity
圆桌讨论：AI 是否拥有真正创造力？
旅行研究：西安博物馆和古建路线
```

Most skills are instruction-only and run inside the agent. `ljg-card` and `ljg-present` generate local HTML/PNG artifacts, usually under `~/Downloads/`.

## ljg-card dependency notes

`ljg-card` uses Playwright to render HTML templates into PNG files. `scripts/install.sh` installs its dependencies automatically when `npm` is available.

Manual install:

```bash
cd ~/.openclaw/skills/ljg-card
npm install
npx playwright install chromium
```

## Development

- Add or edit skills under `skills/ljg-*`.
- Keep `SKILL.md` concise; put long mode-specific details in `references/`.
- Do not commit generated outputs, `node_modules/`, secrets, or personal config.
- Test with `openclaw skills list`, `openclaw skills check`, and a fresh OpenClaw session.

## License

MIT. Original skill ideas/content credit: lijigang/ljg-skills.
