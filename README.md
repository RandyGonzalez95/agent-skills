# agent-skills

Reusable skills for Claude Code and Codex. The repository is the source of truth; skills live under `.claude/skills/<name>/`. The catalog contains 21 consolidated skills plus the existing cyber-security skill.

## Install

On Windows, install the collection for both clients and retire superseded names:

```powershell
./scripts/install.ps1 -Target Both -RetireSuperseded
```

Use `-Target Claude` (default) or `-Target Codex` to select one client. Use `-Skill copywriting` for one skill, or `-WhatIf` to preview without changing files. Codex honors `CODEX_HOME` when set, otherwise uses `~/.codex/skills`; Claude Code uses `~/.claude/skills`. Previous copies and explicitly retired names are moved into timestamped `skill-backups` directories beside each client's skills directory. Unrelated skills and system/plugin packages are preserved.

The existing Bash installer installs into Claude Code on macOS/Linux/Git Bash:

```bash
./scripts/install.sh
./scripts/install.sh copywriting
./scripts/install.sh --dry-run
```

The Bash installer replaces same-name copies; it does not perform the legacy-name retirement or backups offered by the PowerShell installer. Skills with optional helper tools require those tools only when used; installation does not install Python or browser dependencies.

## Catalog

| Skill | Purpose |
|---|---|
| [automation](.claude/skills/automation/SKILL.md) | Plan, implement, and troubleshoot CRM and cross-app workflows, including GoHighLevel, with clear triggers, ownership, duplicate handling, and measurable outcomes. Use for automation builds and adoption plans rather than routine task or note edits. |
| [brand](.claude/skills/brand/SKILL.md) | Define or review brand positioning, voice, messaging, visual identity, and asset guidelines. Use for reusable brand standards and consistency reviews rather than individual copy or graphic deliverables. |
| [carousels](.claude/skills/carousels/SKILL.md) | Plan, write, design, import, upscale, or revise social media carousel sequences with consistent storytelling and accurate source assets. Use for social slides and covers, not website slider components. |
| [copywriting](.claude/skills/copywriting/SKILL.md) | Write or revise emails, outreach, website copy, founder stories, and social text using the user's intended meaning and supplied voice samples. Use for finished prose or voice matching; use brand for a reusable brand guide. |
| [cyber-security](.claude/skills/cyber-security/SKILL.md) | Review a local application workspace for security vulnerabilities in code, dependencies, configuration, user flows, and build/deployment workflows. Use for a security audit, vulnerability check, application hardening, or security-focused change review; provide evidence, prioritized fixes, and verification. Supports implementing fixes when requested. |
| [design-system](.claude/skills/design-system/SKILL.md) | Define and maintain design tokens, themes, component specifications, states, and design-to-code mappings. Use for systematic UI foundations rather than slide production or brand positioning. |
| [graphic-design](.claude/skills/graphic-design/SKILL.md) | Create logos, icon sets, banners, social stills, and identity mockups from a visual brief. Use for static graphic assets rather than full websites, slide decks, or multi-slide social narratives. |
| [legal-review](.claude/skills/legal-review/SKILL.md) | Review website, offer, subscription, testimonial, privacy, and AI-experience risks using evidence and applicable jurisdictions. Use for legal-risk spotting and launch readiness, with legal conclusions reserved for qualified counsel. |
| [monday](.claude/skills/monday/SKILL.md) | Read, create, update, and prioritize tasks on a user-selected monday.com board using live board data. Use for task management rather than general workflow automation design. |
| [notion](.claude/skills/notion/SKILL.md) | Maintain Notion knowledge catalogs, tool notes, work logs, and task documentation using live pages and schemas. Use for Notion records and source-grounded documentation, with external task boards read-only unless separately requested. |
| [presentation-design](.claude/skills/presentation-design/SKILL.md) | Plan and design presentation narratives, sales proposals, and HTML decks with clear slide roles and readable visuals. Use for deck structure and art direction; use the available format-specific tools for PowerPoint or native Slides editing. |
| [product-launch](.claude/skills/product-launch/SKILL.md) | Coordinate product claims, launch readiness, presales, ecommerce, CRM handoffs, and fulfillment using controlled facts and clear ownership. Use for product launch operations rather than a particular brand or product. |
| [sales-messaging](.claude/skills/sales-messaging/SKILL.md) | Develop, retrieve, rehearse, and adapt positioning statements, sales answers, objection responses, pricing explanations, and scope boundaries from a business's actual offer and evidence. |
| [shopify-automation](.claude/skills/shopify-automation/SKILL.md) | Turn Shopify smart-tag rules into Flow builder prompts or webhook and Admin API implementation plans. Use for customer/order tagging automations with explicit triggers, conditions, and tag lifecycle behavior. |
| [smartphone-filming](.claude/skills/smartphone-filming/SKILL.md) | Recommend practical phone-camera settings, shoot preparation, and troubleshooting for focus, stabilization, flicker, HDR, and simulated depth effects. Use for real filming rather than AI video generation or scriptwriting. |
| [social-content](.claude/skills/social-content/SKILL.md) | Capture, develop, prioritize, and organize social content ideas and editorial plans. Use for an idea inbox, content angles, pillars, calendars, or production tracking rather than finished copy or graphics. |
| [social-profile](.claude/skills/social-profile/SKILL.md) | Review and rewrite social bios, profile positioning, and opening-video clarity for Instagram, TikTok, and comparable platforms. Use for profile copy and presentation audits rather than account-wide growth claims. |
| [video-scripts](.claude/skills/video-scripts/SKILL.md) | Write short spoken scripts and shot plans for Reels, TikTok, instructional tips, founder stories, and experiment recaps. Use for scriptwriting rather than filming settings or finished video generation. |
| [visual-prompts](.claude/skills/visual-prompts/SKILL.md) | Develop and critique image, video, and caption-editing prompts using a visual brief, reference roles, and tool-aware settings. Use for prompt writing and art direction rather than automatically generating finished media. |
| [web-design](.claude/skills/web-design/SKILL.md) | Design, build, and review websites and application interfaces; analyze supplied visual references and apply project feedback. Includes responsive layout, accessible components, styling, and searchable UI guidance. Excludes purely backend work. |
| [workflow-mapping](.claude/skills/workflow-mapping/SKILL.md) | Model editable business workflows, customer journeys, sitemaps, and adjacent page or message frameworks. Use for diagrams and implementation handoffs in Figma, FigJam, or the user's chosen format, not live automation execution. |
| [workspace-cleanup](.claude/skills/workspace-cleanup/SKILL.md) | Audit skills and project work, consolidate duplicate guidance, preserve handoffs, and organize authorized workspace cleanup. Use for context resets, skill inventories, and reversible organization rather than automatic deletion. |

## Maintenance

Edit source skills here and rerun the installer to update local copies. Keep folder names and frontmatter names aligned. No external catalog is automatically synchronized by the installer.

Run `node scripts/validate-skills.cjs` for structural, metadata, local-reference and helper syntax checks. It checks the catalog's simple YAML subset, not general YAML or skill behavior. Python regression tests and the browser extraction workflow require their own runtimes.

See the [consolidation map](docs/skill-consolidation.md) for old-to-new names, scope boundaries and attribution.
