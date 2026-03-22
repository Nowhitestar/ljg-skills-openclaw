# ljg-skills

My custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Skills

| Skill | Description |
|-------|-------------|
| **ljg-card** | Content caster — transforms content into PNG visuals (long card, infograph, poster). Infograph mode uses a content-adaptive design system: the AI analyzes content density, structure, and emotion to generate unique visual compositions from scratch — no fixed template, style serves thought. |
| **ljg-paper** | Paper reader — academic paper analysis pipeline |
| **ljg-plain** | Plain language rewriter — makes complex content accessible |
| **ljg-rank** | 降秩引擎 — decomposes any domain to its irreducible generators (秩). Strips a field down to the minimum independent forces that generate all observable phenomena. |
| **ljg-x-download** | X media downloader — download images and videos from X/Twitter posts to ~/Downloads |
| **ljg-skill-map** | Skill map viewer — visual overview of all installed skills |
| **ljg-word** | English word mastery — deep-dive word deconstruction |
| **ljg-writes** | Writing engine — think through an idea by writing it out |

## Workflows

Workflows chain multiple skills into a single command.

| Workflow | Skills | Description |
|----------|--------|-------------|
| **ljg-paper-flow** | ljg-paper → ljg-card | Reads papers + casts cards in one go |
| **ljg-word-flow** | ljg-word → ljg-card -i | Deep-dive word analysis + infograph card in one go |

## Install

### Via Marketplace (Recommended)

```
/plugin marketplace add lijigang/ljg-skills
```

### Manual Install

```bash
git clone https://github.com/lijigang/ljg-skills.git ~/.claude/plugins/ljg-skills
```

Then restart Claude Code.

### ljg-card Dependencies

`ljg-card` requires Playwright for screenshot capture:

```bash
cd ~/.claude/plugins/ljg-skills && bash scripts/install.sh
```

Or manually:

```bash
cd ~/.claude/plugins/ljg-skills/skills/ljg-card && npm install && npx playwright install chromium
```
