---
name: visual-prompts
description: Develop and critique image, video, and caption-editing prompts using a visual brief, reference roles, and tool-aware settings. Use for prompt writing and art direction rather than automatically generating finished media.
---

# Visual Prompts

Identify the viewer outcome, hero subject, medium, reference assets, allowed changes, and target tool. Ask a consequential design question only when it resolves a material gap. Honor complete briefs and requests to proceed with assumptions.

## Define the brief

Record deliverable, audience/use, composition, light, palette/material, action/timing, exact copy/audio, invariants, and success criteria. Assign each reference a role such as identity, geometry, style, layout, motion, or audio; do not treat all references as interchangeable.

## Compile

- **Image:** Lead with subject, spatial relationships, framing, light, materials, and necessary exclusions. Prefer observable visual cues over piles of camera jargon or quality adjectives.
- **Edit:** State what changes, what stays, and which reference controls each. Exact logos, text, measurements, or source pixels may require compositing rather than generative redraw.
- **Video:** Describe a beginning, change, and end. Distinguish subject motion from camera motion. For multiple shots, provide independent prompts and a contiguous timeline whose durations sum to the requested runtime. Generation duration and final trim length are different.
- **Continuity:** Keep a compact invariant identity/product block with scene-specific changes. References and seeds support consistency but do not guarantee it. Prefer continuous source action or compatible end/start references where supported.
- **Captions:** Produce a cue/editing plan, not a video-generation prompt. Preserve transcript meaning, numbers, negations, and qualifications. Obtain actual timing. Text behind a subject needs a synchronized mask; otherwise use negative space.

Separate prompt text, tool settings, and assembly instructions. Verify the receiving interface's current schema before asserting supported inputs, durations, resolutions, reference syntax, or seed controls. Use a portable prompt and identify unchecked settings when verification is unavailable.

## Review and iterate

Check hierarchy, spatial/timing precision, coherent light and focus, reference compatibility, feasible settings, and protected exact copy. Explain the most consequential choices briefly. An unrendered prompt is a proposal, not a proven output.

When results are supplied, compare against the brief and change the smallest relevant instruction or setting. Keep a record of prompt, settings, sources, observed mismatch, and revision. If repeated failures persist, change the workflow rather than stacking adjectives.

For prompt comparisons, evaluate precision, reference control, feasibility, adaptability, and clarity of guidance. Keep editorial judgments separate from measured generation results. Read [effect recipes](references/effect-recipes.md) only when an optical, material, montage, or caption technique fits the brief.
