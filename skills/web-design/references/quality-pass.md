# Website Quality Pass

Use this reference after the main implementation exists or when the user asks for a critique, refinement, or production-readiness pass.

## Product clarity

- Can a first-time visitor identify what this is, who it serves, and what to do next within a few seconds?
- Does the page order support the user's decision journey?
- Are claims specific, credible, and supported by supplied information?

## Visual coherence

- Is there one recognizable art direction rather than a collection of familiar UI patterns?
- Are type, color, spacing, surfaces, and imagery governed by reusable roles?
- Does emphasis follow importance, or is every section competing for attention?
- Are line lengths, alignment, and vertical rhythm comfortable at each breakpoint?

## Interaction and accessibility

- Can the primary journey be completed with a keyboard?
- Are focus indicators visible and logical?
- Do controls have accessible names, adequate target sizes, and appropriate semantics?
- Does meaning survive without color alone?
- Is motion reduced when the system preference requests it?
- Do forms explain errors near the relevant field and preserve entered data?

## Responsive behavior

- Check at approximately 360 px, 768 px, 1280 px, and one very wide viewport.
- Look for accidental horizontal scrolling, clipped text, orphaned headings, overcrowded navigation, and media with lost focal points.
- Confirm that content order and action priority still make sense on mobile.

## Technical finish

- Confirm links, buttons, routes, forms, and major interactive states.
- Check the browser console and network failures.
- Reserve image and media dimensions to avoid layout shifts.
- Verify page title, description, heading hierarchy, landmarks, and meaningful alternative text.
- Run the project's available type, lint, test, and build checks in proportion to the change.

Fix high-impact problems first: broken journeys, unreadable content, inaccessible controls, responsive failures, and misleading copy. Then refine aesthetics and micro-interactions.
