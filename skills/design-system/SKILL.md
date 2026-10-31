---
name: design-system
description: Create and maintain UI tokens, themes, component contracts, and design-to-code mappings.
license: MIT
metadata:
  author: claudekit
  curation: Presentation work separated from reusable system foundations
---

# Design System

Inspect the brand guide, token pipeline, component library, frameworks, and consumers. Extend existing contracts instead of creating a parallel system.

## Define

Use primitive, semantic, and component layers only where reuse warrants them. Define typography, spacing, surfaces, text, borders, focus, and motion by purpose, with explicit units and naming. Preserve theme aliases rather than flattening them.

Specify component anatomy, variants, sizes, accessibility, responsive behavior, content limits, and relevant interaction states. Explain unavailable actions rather than relying on disabled styling alone.

Map actual design/code names, token references, ownership, and gaps. A design component does not establish an implemented code component.

## Verify and deliver

Use the existing pipeline and current framework documentation. Edit generated files through their source. Check missing/circular aliases, units, contrast on actual surfaces, theme switching, and representative states.

Deliver changed tokens/specifications, useful consumer examples, and verification results. Keep brand positioning and presentation layouts in their respective workflows.
