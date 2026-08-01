---
name: web-design-skill
description: Use for visual/UI design work — analyzing reference sites the user explicitly provides ("get inspiration from this site", "what does X look like", "redesign based on these references"), building or reshaping UI ("design this page", "build this component", "make it look like X"), sourcing reusable components from 21st.dev, or recording/applying feedback on a design ("here's feedback on that design", "update our style guide", "what's our house style"). Maintains a persistent, self-updating design knowledge base (ingested reference specs, sourced components, a living house style guide, a feedback log) and delegates actual visual execution to the frontend-design plugin. Never analyzes or absorbs style from a website the user hasn't explicitly named — no autonomous browsing for "inspiration."
---

# web-design-skill

Owns the full loop for visual/UI design work in this workspace: pull structured style specs out
of reference sites, source reusable components from 21st.dev, hand execution to the
`frontend-design` plugin, and then remember what worked. The knowledge base under `knowledge/`
is what makes this "self-learning" — every build and every piece of feedback either gets logged
or, if it's a durable cross-project preference, folded into the house style guide so the next
build starts smarter than the last.

This skill replaces the old one-shot `web-design-research` skill — same extraction rigor, now
persisted instead of thrown away at the end of the conversation.

## Setup

`WebFetch` is deferred. Load it before doing anything else:

```
ToolSearch: select:WebFetch
```

For the build step, invoke the `frontend-design` plugin skill directly (its instructions load
into the turn — this skill does not reimplement its design process, it feeds it):

```
Skill: frontend-design:frontend-design
```

For site ingestion (Capability 1), this skill uses a real headless browser via `tools/extract.mjs`
(Playwright) — `WebFetch` alone only sees markdown-converted content, no CSS or class names
survive that conversion, so it cannot be trusted for color/type/spacing/motion. Before first use
in a given install location, verify the tool is bootstrapped (each location — the repo copy and
any globally-installed copy — maintains its own `node_modules`, so this may need to run more than
once across locations):

```
cd <this skill's base directory>/tools
# if node_modules is missing:
npm install
npx playwright install chromium
```

Run it with:

```
node tools/extract.mjs <url> <outDir>
```

`<outDir>` should be a scratchpad path — write `extracted.json` and the two screenshots there,
read them, then only the durable spec goes into `knowledge/sites/`.

## Knowledge base

All of it lives in `knowledge/` next to this file, so it travels with the skill when installed
globally (see repo README). Four parts, each with a distinct job — don't blend them:

| File/dir | Contents | Written when |
|---|---|---|
| `knowledge/sites/<slug>.md` | One Design Spec per reference site the user explicitly gave | Capability 1 |
| `knowledge/components.md` | 21st.dev components checked/sourced, adopted or not, and why | Capability 2 |
| `knowledge/style-guide.md` | Living, synthesized house style — durable preferences only | Capabilities 3 & 4 |
| `knowledge/feedback.md` | Dated log of feedback per build, whether it got generalized | Capability 4 |

See `knowledge/sites/README.md`, and the header notes inside `components.md`/`feedback.md`/
`style-guide.md`, for exact entry formats.

## Capabilities

### 1. Ingest a reference site

Only runs when the user names specific URL(s). If they ask for "inspiration" or "references"
without naming a site, ask them for one or more URLs — do not pick sites yourself. That
boundary is the whole point of this skill: it learns aesthetic language only from what's
explicitly handed to it.

For **each URL**:
1. Check `knowledge/sites/` first — if this site's already been ingested, skip refetching (say
   so) unless the user asks to refresh it.
2. `WebFetch` the page once for **content and tone only** (product/brand positioning, audience,
   what the page is for) — it's reliable for text, not for styling.
3. Run `node tools/extract.mjs <url> <scratchpad-dir>` for the actual design system. It gives
   real, ground-truth values, not guesses:
   - `customProperties` — every `--`-prefixed CSS custom property actually defined in a readable
     stylesheet (colors, fonts, spacing tokens, brand-specific tokens).
   - `computed` — real rendered styles (`getComputedStyle`) on `body`/`h1`/`h2`/`p`/`button`/`a`,
     which confirms which fonts/colors/sizes are *actually applied*, not merely defined
     somewhere and possibly unused.
   - `animatingElements` — elements with a non-`none` animation or a nonzero transition duration
     at capture time, with their real class names, durations, and properties — the closest thing
     to ground truth for "does this site actually move," and what it moves on (hover-driven
     `transition-colors`, entrance `opacity`/`transform` fades, etc).
   - The two screenshots — read them to judge color-in-context, real layout proportions, and
     overall visual weight, not just the tokens in isolation.
   - `stylesheetsBlocked` — if nonzero, some stylesheets were cross-origin and unreadable; say so
     rather than silently treating the readable subset as complete.
4. Synthesize into the fixed category order — Color / Typography / Spacing & Layout /
   Backgrounds / Motion / Tone — cross-checking `customProperties` (what's defined) against
   `computed` (what's actually used) explicitly, so a defined-but-unused token doesn't get
   reported as a real design decision.
5. Write `knowledge/sites/<slug>.md` (slug from the domain, e.g. `stripe-com.md`) with
   frontmatter `source:`/`date_ingested:` and the spec in the format shown in
   `knowledge/sites/README.md`. If the file already exists, update it in place rather than
   duplicating. Note in the file which method actually produced each part (extract.mjs vs.
   WebFetch) so a future reader knows what's ground-truth vs. content-only.
6. If multiple URLs were given in one request, add a **Synthesis** section (shared patterns,
   differentiators, a recommended direction) rather than leaving specs disconnected.

**Fallback**: if `tools/extract.mjs` can't run in this environment (Playwright not installable,
no network egress for the browser binary, etc.), fall back to downloading the raw HTML and any
linked CSS bundles directly (`curl` + grep for custom properties/`font-family`/gradients/
shadows/radii) rather than trusting `WebFetch`'s markdown conversion. Either way, say explicitly
which method was used — never blend a guess in silently to fill a gap either method left open.

### 2. Source components from 21st.dev

Before building any nontrivial UI piece from scratch, check whether 21st.dev already has a
matching component:

1. `WebFetch` 21st.dev search/listing pages for the component type needed (e.g. pricing table,
   nav bar, testimonial grid).
2. Evaluate candidates against the brief's style direction (from `style-guide.md` and/or any
   ingested site spec for this project) — don't adopt something that fights the established
   aesthetic just because it's convenient.
3. Log the outcome in `knowledge/components.md` regardless of whether you adopted it —
   Adopted as-is / Adapted / Rejected, with a one-line reason. This makes the log useful even
   when the answer was "no."

21st.dev is for component *parts*, not for house style learning — don't let it influence
`style-guide.md`. That knowledge stream is reserved for sites ingested under Capability 1 and
feedback under Capability 4.

### 3. Build or redesign a UI

1. Read `knowledge/style-guide.md` first. Apply established house style unless the brief
   explicitly asks for a distinct new direction — say so if you're deliberately diverging.
2. Check `knowledge/sites/*.md` for any reference relevant to this brief.
3. Run Capability 2 for reusable pieces the brief calls for.
4. Invoke the `frontend-design` plugin skill to actually execute, feeding it: the brief, the
   relevant style-guide entries, any ingested site specs, and any sourced components. Follow
   its brainstorm → plan → critique → build → critique process as written — this skill does not
   duplicate that logic.
5. After building, decide what's worth remembering (see Capability 4) — don't skip this step
   just because the user didn't explicitly ask for feedback yet; at minimum note in
   `components.md` what got used.

### 4. Record and apply feedback

When the user reacts to a design — during or after a build:

1. Append a dated entry to `knowledge/feedback.md`: what was built, the feedback (verbatim or
   close paraphrase), what you changed in response.
2. Decide if it's durable or one-off:
   - **Durable / cross-project** (e.g. "we always want more whitespace than this," "stop using
     rounded corners") → fold into the matching `style-guide.md` section, referencing this
     feedback entry as the source.
   - **One-off / project-specific** (e.g. "this particular hero image is wrong") → log in
     `feedback.md` only, do not generalize into the style guide.
   - If genuinely ambiguous which it is, ask rather than guessing — a wrong generalization
     pollutes every future build.
3. Never fold something into `style-guide.md` on your own inference alone — every entry there
   must trace to either real feedback or a pattern that's shown up more than once across actual
   builds, not a one-time guess about what the user "probably" wants.

## Guardrails

- **Never ingest or learn style from a site the user didn't explicitly name.** No proactive
  browsing "for inspiration." If no site was given and the brief is style-light, fall back to
  `style-guide.md` plus the `frontend-design` skill's own judgment.
- **21st.dev is component sourcing only** — never let it feed `style-guide.md`.
- **Don't hand-wave `style-guide.md` edits.** Every entry needs a traceable source (a feedback
  quote, a site spec, a repeated pattern across builds) and a date. Treat edits as
  append-then-consolidate, not silent overwrite — if reconciling contradictory entries, say what
  changed and why.
- **Never fabricate spec details.** Colors, fonts, spacing values, and component provenance must
  come from an actual `WebFetch` call made in this or a past invocation, never invented.
- Structural/config choices (renaming the knowledge base format, changing how the
  `frontend-design` plugin is invoked) are out of scope for a normal design request — if asked to
  change how this skill itself works, treat that as a separate, explicit request.
