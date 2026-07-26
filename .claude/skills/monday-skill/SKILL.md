---
name: monday-skill
description: Manages the "Randy's Tasks" monday.com board — add tasks, change task status, and get prioritized recommendations of what to work on next. Always drives the board live through the monday.com MCP tools, never from memory or assumption. Use for requests like "add a task", "mark X as done/blocked/in progress", "what's blocked", "what should I work on next", or "show me my tasks".
---

# monday-skill

Manages the **Randy's Tasks** board on monday.com. This skill always acts through the
monday.com MCP tools — it never reports board state, task lists, or status from memory.
Every invocation must make at least one live MCP call before answering.

## Setup

The `mcp__claude_ai_monday_com__*` tools are deferred. Before doing anything else, load the
ones this skill needs:

```
ToolSearch: select:mcp__claude_ai_monday_com__get_board_items_page,mcp__claude_ai_monday_com__create_item,mcp__claude_ai_monday_com__change_item_column_values,mcp__claude_ai_monday_com__get_board_info,mcp__claude_ai_monday_com__board_insights,mcp__claude_ai_monday_com__create_update
```

If a task also needs one not in that list (e.g. `search`, `move_object`), load it in the same
batched ToolSearch call rather than one at a time.

## Board reference

| Item | ID |
|---|---|
| Board ("Randy's Tasks") | `5029840882` |
| Priority column | `color_mm556zzf` |
| Status column | `color_mm5592es` |
| Notes column | `text_mm55n0vp` |
| Category column (dropdown) | `dropdown_mm55kv9z` |
| Estimated Hours column | `numeric_mm55z519` |
| Due Date column | `date_mm5565m0` |

| Group | ID | Status(es) that route here |
|---|---|---|
| To Do | `topics` | Not Started |
| In Progress | `group_mm55bq4j` | In Progress |
| Blocked | `group_mm554kme` | Blocked, Waiting on Client |
| Done | `group_mm55pv3c` | Done |

Priority labels, highest to lowest urgency: **Critical ⚠️ > High > Medium > Low**.

These IDs were confirmed directly against the board. If any tool call reports a column, group,
or label that doesn't match this table (e.g. "column not found"), the board has changed —
re-run `get_board_info` on `5029840882`, update this table, and continue with the fresh data.

## How the board is wired

Five board automations already handle group placement — they move an item to the matching
group whenever its Status changes (Not Started→To Do, In Progress→In Progress, Blocked/Waiting
on Client→Blocked, Done→Done). **This skill only ever needs to change the Status column value.
Never manually move an item to a group** — setting Status is sufficient and avoids fighting the
automation.

There is no hard requirement enforcing a reason on Blocked/Waiting on Client (monday's
Validation Rules feature is gated to a higher plan tier than this account has). When blocking an
item, proactively ask for or suggest a reason and write it to the Notes column anyway — it's the
best available substitute for enforcement.

## Capabilities

### Add a task
Use `create_item` on board `5029840882`. New items default to the To Do group and "Not Started"
status automatically (top group). Set whatever the user specifies — Priority, Category,
Estimated Hours, Due Date, Notes — via column values on creation. If the user doesn't give a
priority, ask rather than guessing; priority drives the prioritization logic below.

### Change status
Use `change_item_column_values` (or `all_api_write`/`change_simple_column_value` if finer
control is needed) to set column `color_mm5592es` to the target label on the target item. Look
the item up first (by name via `search` or `get_board_items_page`) if you don't already have its
item ID — never guess an item ID.

If moving to Blocked or Waiting on Client, ask the user for a reason and write it to the Notes
column (`text_mm55n0vp`) in the same pass.

### Report / prioritize
Pull live data with `get_board_items_page` (include the Priority, Status, Due Date columns) or
`board_insights` for aggregate views (e.g. counts by status). To recommend what to work on next:

1. Exclude items already in Done.
2. Rank by priority: Critical > High > Medium > Low.
3. Within a priority tier, prefer items already In Progress over ones still in To Do (finish
   what's started before pulling in new work), then earlier Due Date.
4. Surface Blocked/Waiting on Client items separately as call-outs, not as "next work" — they're
   stalled, not actionable, until unblocked.

Always base the answer on the data just pulled, not on earlier context in the conversation —
board state changes between turns.

## Guardrails

- Never fabricate item IDs, column values, or board state — every claim about the board must
  trace back to a tool call made in this invocation.
- Structural changes (new automations, new groups/statuses, validation rules) are out of scope
  for this skill — that's board configuration, not task management. If asked, say so and handle
  it as a separate, explicit request.
