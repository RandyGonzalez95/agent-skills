# agent-skills

Randy's collection of Claude Code skills. This repo is the source of truth for every skill;
each one is also tracked in the **AI Skills** database in Notion, which acts as a browsable
catalog (status, category, description) synced from what's actually here.

## Structure

```
.claude/skills/<skill-name>/SKILL.md   # one folder per skill
scripts/install.ps1                    # installer (Windows / PowerShell)
scripts/install.sh                     # installer (macOS / Linux / Git Bash)
```

Each skill folder can contain more than just `SKILL.md` (helper scripts, reference docs) —
whatever the skill needs. `install.ps1` / `install.sh` copy the whole folder.

## Installing skills locally

Skills in `.claude/skills/` are only active in *this* repo by default. To make them available
in every Claude Code project, install them into your global skills directory
(`~/.claude/skills`):

```powershell
# Windows (PowerShell)
./scripts/install.ps1              # install/update all skills
./scripts/install.ps1 -Skill notion-skill
./scripts/install.ps1 -WhatIf      # preview only
```

```bash
# macOS / Linux / Git Bash
./scripts/install.sh                 # install/update all skills
./scripts/install.sh notion-skill
./scripts/install.sh --dry-run       # preview only
```

Or just ask Claude: "install my skills locally" — it will run the right script for your shell.

Re-run the installer any time a skill changes; it overwrites the global copy with the repo
version, so the repo always wins.

## Adding a new skill

1. Create `.claude/skills/<name>/SKILL.md` with `name` and `description` frontmatter (see any
   existing skill for the format).
2. Ask Claude to add it to the Notion catalog (it uses `notion-skill` to do this) — or just
   mention the new skill and it'll do it as part of the same request.
3. Run the installer to make it available globally.

## Current skills

| Skill | Purpose |
|---|---|
| [monday-skill](.claude/skills/monday-skill/SKILL.md) | Manages the "Randy's Tasks" board on monday.com |
| [notion-skill](.claude/skills/notion-skill/SKILL.md) | Manages the AI Skills catalog in Notion |
| [web-design-skill](.claude/skills/web-design-skill/SKILL.md) | Self-learning UI/visual design: ingests user-given reference sites, sources components from 21st.dev, delegates execution to the frontend-design plugin, and remembers feedback |
| [shopify-workflow](.claude/skills/shopify-workflow/SKILL.md) | Generates Shopify Flow AI prompts and webhook/API plans from a smart-tag definition list |
