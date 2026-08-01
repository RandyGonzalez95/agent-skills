---
source: https://fold-canary-med-tech.vercel.app/
date_ingested: 2026-07-26
---

## Design Spec: Fold Smart Scale (Canary MedTech)
Source: https://fold-canary-med-tech.vercel.app/

**Color:**
Named brand tokens (real hex, pulled from the compiled CSS, not the Tailwind default palette):
- `--color-navy: #1b3a4b` (aliased `--color-fold-navy`) — primary brand color, cool and trustworthy
- `--color-gold: #c5a55a` — the one accent color, used almost exclusively inside gradient scrims (never as a flat fill in what was sampled)
- `--color-kraft: #d5c3a7` — secondary warm neutral, paper/kraft tone
- `--color-charcoal: #48484a` — the *only* text color hue, reused at three opacity tiers instead of a separate gray scale: `--color-text-primary` (100%), `--color-text-secondary` (`#48484ab8`, ~72%), `--color-text-muted` (`#48484a80`, 50%)
- `--color-border: #48484a1f` — hairline border, same charcoal hue at ~12% opacity (no separate border-gray)
- `--color-bg` / `--color-surface` both alias to white (`#fff`)
- Full stock Tailwind stone/zinc/black scale is also compiled in but appears to be scaffolding, not the active brand palette

**Type:**
- Body/UI: **Inter** (`--font-sans` → `--font-inter`, also the site's `--default-font-family`) — confirmed as `body`'s actual rendered `font-family`
- Headings: **Outfit** (`--font-heading` → `--font-outfit`) — confirmed on rendered `h2` (62px, weight 500), distinct display face from body
- **Manrope** — confirmed rendered on body copy/testimonial text (`p`, plus multiple `article`/`h3`/`span` elements in what's structurally the testimonial section) at weight 500. *Correction from the first (static-CSS-only) pass of this spec: it was flagged there as "likely unused leftover" — real computed-style capture shows that was wrong. It's a real, deliberate secondary body face, not scaffolding.*
- **DM Sans** — confirmed rendered on `button` and nav `a` elements (12–16px, weight 400–600) — genuinely a UI/label face, not body copy
- Mono: **IBM Plex Mono** (`--default-mono-font-family`) — defined but no element in the sampled selectors rendered it; role still unconfirmed (likely numerals/labels, e.g. the "01/04" step markers, not checked directly)
- Weight scale: 300/400/500/600/700 all defined (light through bold)
- Scale: standard Tailwind steps, `text-xs` (.75rem) through `text-7xl` (4.5rem), each with matched line-height; `tracking-tight`/`tighter`/`widest` utilities present — consistent with tightened display headlines and widened small labels

**Spacing:**
Tailwind v4 token system (`--spacing: .25rem` base) plus a real custom layer specific to this brand:
- `--fold-section-gap`: 2rem (mobile) → 3rem (md) → 3.5rem (lg+) — deliberate, responsive section rhythm
- `--fold-frame-px` / `--fold-hero-inner-px`: a tuned "frame" padding system, also responsive
- A full `--fold-button-*` token set (height 3.125rem, wheel-size 1.625rem, icon-size 2.375rem, gap .875rem, asymmetric left/right padding) — the CTA button is a bespoke, carefully-dimensioned component, not a default button
- Page structure (from content pass): one long scroll — hero → pain points → "status quo" narrative → features → how-it-works → testimonials → why-fold → pre-order CTA → app mockup → gallery → FAQ → footer

**Backgrounds:**
- Full-bleed photography is the dominant background, not flat color fills
- Heavy linear-gradient scrim usage over images: mostly black-based darkening scrims (`#000` at graduated opacity) for text legibility, plus a distinct warm gold scrim (`#c5a55a` at low, multi-stop opacity) used as an accent wash rather than a bold graphic
- Backdrop-blur appears only once across the entire compiled stylesheet — this is **not** a glassmorphism design, despite blur utilities being defined in the token system
- Shadows are soft and diffused (`0 24px 48px -12/-14px` low-opacity black + a 1px hairline ring) — cards separate via soft shadow, not hard borders
- Border-radius is broad and consistently soft, from `.45rem` up to `2.5rem` plus full circles — rounded, approachable geometry is the default; sharp/zero-radius is the rare exception

**Motion:**
Confirmed via real computed-style capture (`animatingElements` in a live render, not static CSS guessing): motion here is restrained and almost entirely **hover/state-driven color and background transitions** (`transition-colors`, 0.15s–0.25s) on nav links and the custom FoldButton component (`FoldButton-module__*__btn`, `__iconCircle`) — not ambient or decorative. The one structurally distinct case is the testimonial `article` cards, which transition `opacity, transform` at 0.5s — consistent with a scroll-reveal/fade-in pattern on that section specifically, not site-wide. No CSS `@keyframes` were present. *Correction from the first pass: the earlier "single width/border-radius transition, possibly a progress wheel" guess wasn't reproduced here — real captured transitions are the hover/reveal pattern above instead. Treat this section as the current ground truth over the original static-CSS note.*

**Tone:** Fold Smart Scale is a wheelchair-first weight scale from Canary MedTech, positioned for wheelchair users, veterans, people with spinal cord injuries, caregivers, and clinical care teams. Copy leans on lived experience over marketing hyperbole ("You were never the problem. The assumption was."). Reads as a thoughtful, inclusive medical device — clinical precision blended with warmth, not enterprise-SaaS or consumer-luxury.

**Signature detail:** The navy/gold/kraft palette (cool trustworthy navy body, warm gold accent used only as gradient wash, kraft as a paper-warm neutral) paired with a single charcoal-at-three-opacities text system and a bespoke, precisely-dimensioned button/wheel component — restrained, considered "medical-device warmth" rather than clinical-cold or startup-flashy.

## Extraction method note
`WebFetch` on this URL only returns markdown-converted content — no raw CSS, class names, or hex values survive that conversion (confirmed by direct test). This spec was built in two passes:

1. **First pass**: raw HTML + the two compiled CSS bundles pulled directly via `curl` and grepped for custom properties, font-face rules, gradients, shadows, and radii. Real values, but couldn't confirm which defined tokens/fonts were actually applied to rendered elements, or observe real motion behavior.
2. **Second pass** (after `tools/extract.mjs` — Playwright — was wired into the skill): a real headless-browser render, reading actual `getComputedStyle` output and live animation/transition state. This corrected two things the first pass got wrong by inference alone — see the Type and Motion sections above for what changed and why. Screenshots (`screenshot-viewport.png`, `screenshot-full.png`) were also captured but not persisted into this knowledge file; re-run the tool if a visual reference is needed again.

Tone/content section came from a separate WebFetch pass, which is reliable for text content even though it's lossy for styling. Takeaway for future ingestions: prefer `tools/extract.mjs` from the start — the curl+grep fallback is real data but can still mislead when it can't tell which defined styles are actually in use.
