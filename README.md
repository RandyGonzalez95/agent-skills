# agent-skills

A portable, agent-harness-agnostic collection of 24 skills. The source catalog lives in `skills/<name>/`, independent of any model vendor or application's configuration directory.

Each skill is a folder containing `SKILL.md` and any supporting references, scripts, or data. The instructions do not require a particular model. Actual tool execution depends on the receiving harness and available integrations.

## Download and use

[Download the repository ZIP](https://github.com/RandyGonzalez95/agent-skills/archive/refs/heads/main.zip), or clone it:

```bash
git clone https://github.com/RandyGonzalez95/agent-skills.git
```

Copy the complete folder for each desired skill from `skills/` into your agent's documented skill location. A harness that reads `SKILL.md` can use these folders directly. For a model interface without skill discovery, provide the skill's instructions and relevant supporting files as context; that interface may still lack the tools needed to execute the workflow. No universal installation path or compatibility with every tool runtime is assumed.

Optional `agents/openai.yaml` files provide Codex UI metadata only. Other harnesses can ignore them; the portable instructions and resources do not depend on those files. No Claude- or Codex-specific directory is the source of truth.

## Install into any harness

Choose the destination directory explicitly. There is no default vendor target.

PowerShell:

```powershell
./scripts/install.ps1 -Destination ./my-agent/skills
./scripts/install.ps1 -Destination ./my-agent/skills -Skill copywriting
./scripts/install.ps1 -Destination ./my-agent/skills -WhatIf
```

Bash (macOS, Linux, or Git Bash):

```bash
./scripts/install.sh --dest ./my-agent/skills
./scripts/install.sh --dest ./my-agent/skills copywriting
./scripts/install.sh --dest ./my-agent/skills --dry-run
```

Use the actual skill directory supported by your chosen harness in place of `./my-agent/skills`. Both installers preserve previous copies in a timestamped sibling `skill-backups/` directory. Add `-RetireSuperseded` (PowerShell) or `--retire-superseded` (Bash) during a full installation to move old catalog names out of discovery. Unrelated skills remain untouched.

### Optional harness presets

```powershell
./scripts/install.ps1 -Target Claude
./scripts/install.ps1 -Target Codex
./scripts/install.ps1 -Target Both -RetireSuperseded
```

```bash
./scripts/install.sh --target claude
./scripts/install.sh --target codex
./scripts/install.sh --target both --retire-superseded
```

These are installation conveniences: Claude Code uses `~/.claude/skills`; Codex uses `$CODEX_HOME/skills` when set, otherwise `~/.codex/skills`. Presets do not alter the portable source. Optional Python, browser, or API dependencies are needed only for the workflows that use them and are not installed by these scripts.

## Catalog

| Skill | Purpose |
|---|---|
| [ai-slop](skills/ai-slop/SKILL.md) | Cut filler from prose and code names; apply saved writing preferences and maintain banned wording. |
| [automation](skills/automation/SKILL.md) | Build and troubleshoot CRM and cross-app automations, including GoHighLevel, with reliable triggers and handoffs. |
| [brand](skills/brand/SKILL.md) | Define brand positioning, voice, visual identity, and reusable guidelines; review assets for consistency. |
| [carousels](skills/carousels/SKILL.md) | Write, design, import, or revise social carousel slides and covers with consistent storytelling and source fidelity. |
| [copywriting](skills/copywriting/SKILL.md) | Write or revise emails, website copy, stories, and social text using supplied facts and voice samples. |
| [cyber-security](skills/cyber-security/SKILL.md) | Audit application code and workflows for security risks; verify authorization coverage and implement requested fixes. |
| [design-system](skills/design-system/SKILL.md) | Create and maintain UI tokens, themes, component contracts, and design-to-code mappings. |
| [feature-workflow](skills/feature-workflow/SKILL.md) | Implement features through requirements, design, tests, review, and authorized delivery; resume interrupted runs. |
| [graphic-design](skills/graphic-design/SKILL.md) | Create logos, icons, banners, social stills, and identity mockups from a visual brief. |
| [legal-review](skills/legal-review/SKILL.md) | Review website and launch risks involving privacy, claims, subscriptions, and AI against applicable law. |
| [monday](skills/monday/SKILL.md) | Read, update, and prioritize monday.com tasks using the selected board's live schema and records. |
| [notion](skills/notion/SKILL.md) | Maintain Notion catalogs, notes, work logs, and task documentation using live pages and schemas. |
| [presentation-design](skills/presentation-design/SKILL.md) | Plan and design presentation narratives, proposals, and HTML decks; guide slide structure and art direction. |
| [product-launch](skills/product-launch/SKILL.md) | Coordinate launch claims, readiness, presales, checkout, CRM handoffs, and fulfillment. |
| [sales-messaging](skills/sales-messaging/SKILL.md) | Develop, retrieve, adapt, and rehearse sales positioning, objections, pricing answers, and scope boundaries. |
| [shopify-automation](skills/shopify-automation/SKILL.md) | Translate Shopify customer/order tagging rules into Flow prompts or webhook and Admin API plans. |
| [smartphone-filming](skills/smartphone-filming/SKILL.md) | Choose phone-camera settings and troubleshoot focus, stabilization, flicker, HDR, and depth effects. |
| [social-content](skills/social-content/SKILL.md) | Capture and develop social content ideas, editorial calendars, and production plans. |
| [social-profile](skills/social-profile/SKILL.md) | Review and rewrite social bios and positioning; assess opening-video clarity. |
| [video-scripts](skills/video-scripts/SKILL.md) | Write short spoken video scripts and feasible shot plans for tips, stories, and experiments. |
| [visual-prompts](skills/visual-prompts/SKILL.md) | Write and critique image, video, editing, and caption prompts with clear reference roles and tool settings. |
| [web-design](skills/web-design/SKILL.md) | Design, build, and review responsive websites and app interfaces using project conventions and visual references. |
| [workflow-mapping](skills/workflow-mapping/SKILL.md) | Create editable workflow maps, customer journeys, sitemaps, and implementation handoffs. |
| [workspace-cleanup](skills/workspace-cleanup/SKILL.md) | Audit and consolidate skills or project files, preserving useful resources and recoverable handoffs. |

## Maintenance

Edit skills under `skills/` and rerun your chosen installer to update copies. Keep folder names and frontmatter names aligned. No external catalog is automatically synchronized.

Run `node scripts/validate-skills.cjs` for structural, optional metadata, local-reference and helper syntax checks. It checks the catalog's simple YAML subset, not general YAML or skill behavior. Python regression tests and browser workflows require their own runtimes.

See the [consolidation map](docs/skill-consolidation.md) for old-to-new names, scope boundaries and attribution.
