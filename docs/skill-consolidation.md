# Skill consolidation

On September 19, 2026, 31 custom source skills were consolidated into 21 generic skills. These now live in `skills/`, alongside the existing `cyber-security` skill. The temporary import and vendor export were removed after migration. Vendor packages are not part of this repository catalog.

Personal/client identities, fixed account IDs, private paths, prices, historical approvals, and inherited aesthetic defaults were removed from the reusable instructions.

| Previous skill | Current skill(s) | Reason |
|---|---|---|
| `banner-design` | [graphic-design](../skills/graphic-design/SKILL.md) | Merge static banner production with logo, icon and social-still workflows; remove stale platform rules and missing-tool requirements. |
| `brand` | [brand](../skills/brand/SKILL.md) | Keep reusable standards distinct from asset production and finished prose; replace fixed file paths with project sources. |
| `design-system` | [design-system](../skills/design-system/SKILL.md), [presentation-design](../skills/presentation-design/SKILL.md) | Retain token/component discipline; slide guidance consolidated in presentation-design. Legacy generators remain in source archive. |
| `design` | [graphic-design](../skills/graphic-design/SKILL.md), [presentation-design](../skills/presentation-design/SKILL.md), [brand](../skills/brand/SKILL.md), [design-system](../skills/design-system/SKILL.md), [web-design](../skills/web-design/SKILL.md) | Split broad router: graphic production here, slide work in presentation-design, foundations in brand/design-system, UI in web-design. |
| `monday-skill` | [monday](../skills/monday/SKILL.md) | Discover target board/schema live instead of embedding personal board and automation IDs. |
| `notion-skill` | [notion](../skills/notion/SKILL.md) | Discover target databases live; retain provenance, deduplication and task-source read boundaries. |
| `shopify-workflow` | [shopify-automation](../skills/shopify-automation/SKILL.md) | Retain Flow/custom tagging plans; replace static capability claims with verification and preserve unrelated tags. |
| `slides` | [presentation-design](../skills/presentation-design/SKILL.md) | Merge duplicated HTML slide narrative and production guidance with proposal decks. |
| `ui-styling` | [web-design](../skills/web-design/SKILL.md) | Merge accessible components and responsive styling; make framework choices conditional. |
| `ui-ux-pro-max` | [web-design](../skills/web-design/SKILL.md) | Retain search scripts, tests and CSV data as optional supporting resources; remove overlapping skill entrypoint. |
| `web-design-skill` | [web-design](../skills/web-design/SKILL.md) | Merge supplied-reference extraction and feedback; retain extractor, exclude old client style memory. |
| `web-design` | [web-design](../skills/web-design/SKILL.md) | Merge reference learning and component reuse; keep preference memory project-scoped. |
| `aron-sogi-filming` | [smartphone-filming](../skills/smartphone-filming/SKILL.md) | Retain phone setup and troubleshooting; remove named creator and personal notes. |
| `blue-dot-carousel-voice` | [carousels](../skills/carousels/SKILL.md) | Merge editorial narrative and measurement into the carousel production workflow. |
| `blue-dot-instagram-storytelling` | [video-scripts](../skills/video-scripts/SKILL.md) | Merge story and experiment modes with short instructional scripts. |
| `blue-dot-legal-audit` | [legal-review](../skills/legal-review/SKILL.md) | Retain twelve risk areas; remove client, named owners, and jurisdiction assumptions. |
| `blue-dot-proposal-decks` | [presentation-design](../skills/presentation-design/SKILL.md) | Merge proposal narrative and rendered contrast checks with slide design. |
| `blue-dot-sound-bites` | [sales-messaging](../skills/sales-messaging/SKILL.md) | Retain retrieval, rehearsal, adaptation, and evidence discipline; remove approved client scripts, prices, and biography. |
| `carousel-studio` | [carousels](../skills/carousels/SKILL.md) | Merge creation/import/upscale/redesign with editorial and product-fidelity guidance; remove provider and brand defaults. |
| `figma-workflow-development` | [workflow-mapping](../skills/workflow-mapping/SKILL.md) | Generalize business diagramming; retain Figma-specific prerequisites through available vendor guidance. |
| `fold-carousels` | [carousels](../skills/carousels/SKILL.md) | Retain storyboard, product fidelity, motion, export, and QA methods; remove product facts, visual identity, and exclusive asset IDs. |
| `ghl-automation-level-up` | [automation](../skills/automation/SKILL.md) | Generalize workflow engineering and adoption; retain conditional GoHighLevel capability checks. |
| `iris-human-copy` | [copywriting](../skills/copywriting/SKILL.md) | Merge voice-aware business copy and effective-copy tests. |
| `iris-voice` | [copywriting](../skills/copywriting/SKILL.md) | Merge cross-context voice calibration; replace fixed personal profile with user-supplied samples. |
| `iris-workspace-reset` | [workspace-cleanup](../skills/workspace-cleanup/SKILL.md) | Generalize inventory, handoff, and reversible cleanup; remove private workspace paths and taxonomy. |
| `script-writer-short-form` | [video-scripts](../skills/video-scripts/SKILL.md) | Retain concise instructional mode with flexible duration and wording. |
| `social-media-ideate` | [social-content](../skills/social-content/SKILL.md) | Retain capture, development, prioritization, and tracking; shorten repeated editorial guidance. |
| `social-media-ig-and-tt-audit` | [social-profile](../skills/social-profile/SKILL.md) | Rename to actual scope: bios and profile/video-opening clarity, not a full growth audit. |
| `the-fold` | [product-launch](../skills/product-launch/SKILL.md) | Retain claim ledger, launch ownership, presales, checkout and fulfillment methods; remove all product/client state. |
| `visual-prompt-director` | [visual-prompts](../skills/visual-prompts/SKILL.md) | Retain reference control, tool adaptation, shot/cue timing and iteration; remove mandatory intake questions. |
| `website-studio` | [web-design](../skills/web-design/SKILL.md) | Merge site intake, implementation and quality review; remove mandatory three-reference intake. |

## Preserved resources

Web-design retains the UI search engine, its tests and CSV data, the browser style extractor, and the website quality checklist. Model-specific generators, duplicate slide resources, client assets, and personal style history were excluded. Original repository versions remain available through Git history.

The source repository attributes the custom design bundle to NextLevelBuilder/ClaudeKit under MIT. Retained author/license metadata and source comments preserve provenance. UI search resources originate from ui-ux-pro-max; the browser extractor comes from web-design-skill. Curation does not relicense third-party work.
