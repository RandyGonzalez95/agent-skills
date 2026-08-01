# Ingested Reference Sites

One file per site the user has explicitly provided for design inspiration, named `<slug>.md`
(the domain, e.g. `stripe-com.md`). Never add a file here for a site browsed on this skill's
own initiative — see the Guardrails section of `../../SKILL.md`.

Each file:

```
---
source: <url>
date_ingested: YYYY-MM-DD
---

## Design Spec: [site name]
Source: [url]

**Color:** [palette summary — 3-5 key colors with roles]
**Type:** [font stack + scale + weight notes]
**Spacing:** [system + rhythm descriptor]
**Backgrounds:** [treatment summary]
**Motion:** [animation summary]
**Tone:** [one-sentence aesthetic positioning]
**Signature detail:** [the one thing that makes this site feel like itself]
```

If a request ingests multiple sites at once, append a synthesis block to the last file
processed, or to a dedicated `synthesis-<date>.md` if it doesn't belong to any single site:

```
## Synthesis: Shared Patterns
[what all/most sites agree on]

## Synthesis: Differentiators
[what each site does uniquely]

## Recommended Direction
[3-5 bullet spec ready for frontend-design handoff]
```
