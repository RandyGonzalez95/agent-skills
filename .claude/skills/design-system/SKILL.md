---
name: design-system
description: Define and maintain design tokens, themes, component specifications, states, and design-to-code mappings. Use for systematic UI foundations rather than slide production or brand positioning.
license: MIT
metadata:
  author: claudekit
  curation: Presentation work separated from reusable system foundations
---

# Design System

Inspect the current brand guide, token format, component library, frameworks, and consumers before changing them. Preserve existing contracts where practical; do not create a parallel system merely to use a preferred format.

## Token architecture

Use primitive values, semantic roles, and component-specific aliases where those layers solve actual reuse needs. For example, a raw blue value may feed an action-background role, which supplies a button background. Avoid adding layers with no consumers.

Define typography, spacing, surfaces, text, borders, focus, and motion by purpose. Describe units and naming conventions. Preserve theme-specific role mappings rather than flattening aliases into values that cannot change with the theme.

## Component contract

Specify anatomy, variants, supported sizes, interaction states, accessibility semantics, responsive behavior, and content limits. Include default, hover, focus, active, disabled, loading, error, and empty states only where relevant. Disabled is not a substitute for explaining unavailable actions.

For design-to-code handoff, map actual component and token names, ownership, and unresolved gaps. A design-library component does not prove the corresponding code implementation exists.

## Implementation and verification

Use the project's existing token pipeline and current framework documentation. Check missing/circular aliases, unit consistency, contrast on actual surfaces, theme switching, and representative component states. Preserve user edits in generated files by changing their real source.

Deliver the changed tokens/specifications, consumer examples when useful, and the checks performed. Keep slide layouts and deck narratives in presentation-design; brand identity decisions belong in brand. No external skill is required for ordinary token work.
