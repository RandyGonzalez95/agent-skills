# agent-skills

A portable, agent-harness-agnostic collection of 22 skills. The source catalog lives in `skills/<name>/`, independent of any model vendor or application's configuration directory.

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
| [automation](skills/automation/SKILL.md) | Plan, implement, and troubleshoot CRM and cross-app workflows, including GoHighLevel, with clear triggers, ownership, duplicate handling, and measurable outcomes. Use for automation builds and adoption plans rather than routine task or note edits. |
| [brand](skills/brand/SKILL.md) | Define or review brand positioning, voice, messaging, visual identity, and asset guidelines. Use for reusable brand standards and consistency reviews rather than individual copy or graphic deliverables. |
| [carousels](skills/carousels/SKILL.md) | Plan, write, design, import, upscale, or revise social media carousel sequences with consistent storytelling and accurate source assets. Use for social slides and covers, not website slider components. |
| [copywriting](skills/copywriting/SKILL.md) | Write or revise emails, outreach, website copy, founder stories, and social text using the user's intended meaning and supplied voice samples. Use for finished prose or voice matching; use brand for a reusable brand guide. |
| [cyber-security](skills/cyber-security/SKILL.md) | Review a local application workspace for security vulnerabilities in code, dependencies, configuration, user flows, and build/deployment workflows. Use for a security audit, vulnerability check, application hardening, or security-focused change review; provide evidence, prioritized fixes, and verification. Supports implementing fixes when requested. |
| [design-system](skills/design-system/SKILL.md) | Define and maintain design tokens, themes, component specifications, states, and design-to-code mappings. Use for systematic UI foundations rather than slide production or brand positioning. |
| [graphic-design](skills/graphic-design/SKILL.md) | Create logos, icon sets, banners, social stills, and identity mockups from a visual brief. Use for static graphic assets rather than full websites, slide decks, or multi-slide social narratives. |
| [legal-review](skills/legal-review/SKILL.md) | Review website, offer, subscription, testimonial, privacy, and AI-experience risks using evidence and applicable jurisdictions. Use for legal-risk spotting and launch readiness, with legal conclusions reserved for qualified counsel. |
| [monday](skills/monday/SKILL.md) | Read, create, update, and prioritize tasks on a user-selected monday.com board using live board data. Use for task management rather than general workflow automation design. |
| [notion](skills/notion/SKILL.md) | Maintain Notion knowledge catalogs, tool notes, work logs, and task documentation using live pages and schemas. Use for Notion records and source-grounded documentation, with external task boards read-only unless separately requested. |
| [presentation-design](skills/presentation-design/SKILL.md) | Plan and design presentation narratives, sales proposals, and HTML decks with clear slide roles and readable visuals. Use for deck structure and art direction; use the available format-specific tools for PowerPoint or native Slides editing. |
| [product-launch](skills/product-launch/SKILL.md) | Coordinate product claims, launch readiness, presales, ecommerce, CRM handoffs, and fulfillment using controlled facts and clear ownership. Use for product launch operations rather than a particular brand or product. |
| [sales-messaging](skills/sales-messaging/SKILL.md) | Develop, retrieve, rehearse, and adapt positioning statements, sales answers, objection responses, pricing explanations, and scope boundaries from a business's actual offer and evidence. |
| [shopify-automation](skills/shopify-automation/SKILL.md) | Turn Shopify smart-tag rules into Flow builder prompts or webhook and Admin API implementation plans. Use for customer/order tagging automations with explicit triggers, conditions, and tag lifecycle behavior. |
| [smartphone-filming](skills/smartphone-filming/SKILL.md) | Recommend practical phone-camera settings, shoot preparation, and troubleshooting for focus, stabilization, flicker, HDR, and simulated depth effects. Use for real filming rather than AI video generation or scriptwriting. |
| [social-content](skills/social-content/SKILL.md) | Capture, develop, prioritize, and organize social content ideas and editorial plans. Use for an idea inbox, content angles, pillars, calendars, or production tracking rather than finished copy or graphics. |
| [social-profile](skills/social-profile/SKILL.md) | Review and rewrite social bios, profile positioning, and opening-video clarity for Instagram, TikTok, and comparable platforms. Use for profile copy and presentation audits rather than account-wide growth claims. |
| [video-scripts](skills/video-scripts/SKILL.md) | Write short spoken scripts and shot plans for Reels, TikTok, instructional tips, founder stories, and experiment recaps. Use for scriptwriting rather than filming settings or finished video generation. |
| [visual-prompts](skills/visual-prompts/SKILL.md) | Develop and critique image, video, and caption-editing prompts using a visual brief, reference roles, and tool-aware settings. Use for prompt writing and art direction rather than automatically generating finished media. |
| [web-design](skills/web-design/SKILL.md) | Design, build, and review websites and application interfaces; analyze supplied visual references and apply project feedback. Includes responsive layout, accessible components, styling, and searchable UI guidance. Excludes purely backend work. |
| [workflow-mapping](skills/workflow-mapping/SKILL.md) | Model editable business workflows, customer journeys, sitemaps, and adjacent page or message frameworks. Use for diagrams and implementation handoffs in Figma, FigJam, or the user's chosen format, not live automation execution. |
| [workspace-cleanup](skills/workspace-cleanup/SKILL.md) | Audit skills and project work, consolidate duplicate guidance, preserve handoffs, and organize authorized workspace cleanup. Use for context resets, skill inventories, and reversible organization rather than automatic deletion. |

## Maintenance

Edit skills under `skills/` and rerun your chosen installer to update copies. Keep folder names and frontmatter names aligned. No external catalog is automatically synchronized.

Run `node scripts/validate-skills.cjs` for structural, optional metadata, local-reference and helper syntax checks. It checks the catalog's simple YAML subset, not general YAML or skill behavior. Python regression tests and browser workflows require their own runtimes.

See the [consolidation map](docs/skill-consolidation.md) for old-to-new names, scope boundaries and attribution.
