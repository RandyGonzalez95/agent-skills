---
name: monday
description: Read, create, update, and prioritize tasks on a user-selected monday.com board using live board data. Use for task management rather than general workflow automation design.
---

# Monday

Discover available monday.com tools and their current schemas. Resolve the intended workspace/board from the request or current project configuration; ask when multiple plausible targets remain. Never inherit a board ID, column ID, or priority scheme from another account.

## Read before writing

Fetch the relevant board schema, groups, columns, labels, items, and pagination as needed. Resolve an item by live identity rather than guessing an ID. Read descriptions and relevant updates when they affect the task. If access is unavailable, state what cannot be verified rather than reporting memory as current board state.

For new tasks, use provided values and the board's actual defaults. Ask about missing priority only when necessary to perform the requested action; do not make optional metadata a universal blocker.

Change only requested fields. Before moving groups, inspect whether status automations already control placement. Do not assume every board has the same automations. Capture a supplied blocking reason and surface missing ownership or next action without inventing it.

## Prioritize and verify

Use the board's priority semantics, dependencies, due dates, and work already in progress. Exclude completed work; report blocked items separately from actionable recommendations. Make the ranking logic clear when the board does not define it.

After a write, read back the affected item and report its link and actual state. On schema drift, refresh schema before a bounded retry; do not silently create columns or labels. Structural board changes require that scope in the user's request.
