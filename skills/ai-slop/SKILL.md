---
name: ai-slop
description: Cut filler from prose and code names; apply saved writing preferences and maintain banned wording.
---

# AI Slop

Simplify and cut by default. Delete repetition before rephrasing; add detail only when needed for meaning or requested. Apply this guidance to prose, names, comments, logs, and technical summaries.

Read [saved feedback](references/feedback.md) and [banned wording](references/banned-wording.md). For rewrites, also read [plain-language rewrites](references/plain-language.md).

## Preserve meaning

Apply bans to generated text and new names. Preserve exact quotes, user content, existing symbols, API names, required attribution, and local conventions unless editing them is requested. Technical accuracy and explicit user requirements override style defaults.

## Write plainly

- Lead with the point. Cut process narration, repeated summaries, filler, unnecessary hedges, and closing pleasantries. Preserve qualifications affecting certainty.
- Use complete sentences and familiar verbs. Explain unfamiliar terms; avoid identifier lists, arrow chains, and stacked parentheticals.
- Use bullets for lists and prose for arguments. Vary sentence length without decorative structure or three-adjective rhythms.
- Remove help that repeats controls or status. Keep setup details in documentation; retain permissions, costs, and destructive effects needed to act. Explain whether a blocker needs user action.
- Omit emoji, decorative headers, whole-sentence bold, contrast formulas, and labels above titles. Move useful small subtitles or footnotes around titles, charts, and tables into normal body text. Preserve data labels, legends, navigation, and required attribution.
- Use ASCII punctuation without invisible markers or stylistic signatures. This does not restrict letters in other languages. Do not claim these edits prove human authorship or evade detection.

## Names, comments, and logs

Match local casing, vocabulary, prefixes, and established abbreviations. Name the actual responsibility with enough context to avoid ambiguity. Generic role words such as Manager or Handler are fine when accurate or conventional. Prefer local predicate, Try/TryGet, callback, and event patterns.

Comment only on constraints the code cannot explain, such as ordering or platform quirks. Omit task narration and change-log prose. Write traceable diagnostic logs with appropriate severity; preserve structured/deferred logging and prefer interpolation when compatible.

## Maintain and check

For new banned wording, update the matching alphabetical list with a replacement or "cut"; merge duplicates. For broader corrections, fix the current work and save a brief, properly scoped lesson in [feedback](references/feedback.md). Ongoing learning is requested.

Maintain the source in `agent-skills/skills/ai-slop/`, then use its installer to update the installed copy unless the user defers installation or selects another source. If writing fails, apply the correction in conversation and identify the unsaved file. Confirm successful additions briefly.

Before delivery, scan wording and names, remove repetition, check punctuation and decorative labels, and read dense paragraphs for clarity. For rewrites, compare against the source for lost facts or changed meaning.
