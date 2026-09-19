---
name: web-design
description: Design, build, and review websites and application interfaces; analyze supplied visual references and apply project feedback. Includes responsive layout, accessible components, styling, and searchable UI guidance. Excludes purely backend work.
license: MIT
metadata:
  curation: Consolidated website, reference-analysis, UI styling, and design-intelligence workflows
---

# Web Design

Inspect the existing project, stack, components, assets, and established design decisions. Identify the audience, page purpose, primary action, required content, and constraints. For a new site, ask only for consequential gaps; do not require a fixed number of inspiration sites or contact fields that the site does not need.

## References and project memory

Analyze the user's supplied sites, images, screenshots, or source files. Extract transferable composition, hierarchy, typography, color, spacing, imagery, and interaction principles. Do not copy distinctive branding or text. A screenshot supports visual observations, not exact CSS values or unobserved behavior.

For exact website style extraction, read [reference analysis](references/reference-analysis.md). Use rendered styles and screenshots together; distinguish defined tokens from applied values and measured observations from proposals.

Keep reference notes, adopted components, project preferences, and feedback distinct in the existing project documentation. Record source and date. Generalize a preference across projects only when the user indicates that scope. Do not write new preferences into the installed skill or import the previous owner's style history.

## Design and build

Form a concise brief and one coherent visual direction. Define reusable roles for type, color, spacing, surfaces, imagery, and motion. Keep the existing stack unless the task calls for a change. Use established components before introducing a new library; external component sourcing is optional and must fit the project and its licenses.

Use the bundled [design search](references/design-search.md) when product, palette, typography, chart, interaction, or stack guidance would help. Results are candidate recommendations, not brand facts or authority over the user's choices.

Build semantic, responsive interfaces with named controls, visible focus, keyboard operation, understandable errors, and appropriate loading/empty states. Recompose mobile layouts instead of merely shrinking them. Preserve zoom, reduce motion when requested by the system preference, and reserve media dimensions to limit layout shifts.

For shadcn/ui, Tailwind, or another framework, inspect the installed version and current documentation before changing configuration. Do not force React, Tailwind, a particular animation library, or an unavailable skill onto every project.

Use supplied business facts and clearly marked placeholders. Do not invent testimonials, addresses, prices, metrics, or credentials. Implement the requested experience; a visual mockup does not establish that its backend works.

## Verify and deliver

Read [quality pass](references/quality-pass.md) for a complete page or substantial redesign. Inspect rendered output at relevant viewport sizes and exercise the primary journey. Run appropriate project checks and repair material failures. Report what works, where to view it, and remaining limitations. Use the requested hosting workflow when publication is in scope.
