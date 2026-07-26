---
name: notion-skill
description: Manages Randy's Notion workspace — the AI Skills catalog, the Blue Dot Agency Tools reference, and the Work Log (daily/weekly progress notes). Handles requests like "add this skill to Notion", "log today's progress", "what did I work on this week", "add a note on HubSpot", or "pull today's monday tasks into my log". Always drives Notion live through the Notion MCP tools, never from memory. Has READ-ONLY access to monday.com — it only reads task names/status/descriptions to document them in Notion, and never creates, edits, or moves anything on a monday board.
---

# notion-skill

Manages Randy's Notion workspace across three areas, all under the same guardrail: this skill
always acts through the Notion MCP tools and never reports content from memory. Every
invocation must make at least one live MCP call before answering.

1. **AI Skills catalog** — the index of skills in the `agent-skills` GitHub repo.
2. **Blue Dot Agency Tools** — reference notes on tools/platforms the business runs on.
3. **Blue Dot Agency Work Log** — daily/weekly progress notes, optionally pulling task context
   from monday.com (read-only).

## Setup

The `mcp__claude_ai_Notion__*` tools are deferred. Before doing anything else, load the ones
this skill needs:

```
ToolSearch: select:mcp__claude_ai_Notion__notion-fetch,mcp__claude_ai_Notion__notion-create-pages,mcp__claude_ai_Notion__notion-update-page,mcp__claude_ai_Notion__notion-query-data-sources,mcp__claude_ai_Notion__notion-search,mcp__claude_ai_Notion__notion-update-data-source
```

For Work Log entries that reference monday.com tasks, also load these — **read-only tools
only**, see the Guardrails section:

```
ToolSearch: select:mcp__claude_ai_monday_com__get_board_items_page,mcp__claude_ai_monday_com__get_board_info,mcp__claude_ai_monday_com__board_insights,mcp__claude_ai_monday_com__get_updates
```

## Database reference

| Database | Data source (use for queries/creates) | Parent |
|---|---|---|
| AI Skills | `collection://3a79fced-c090-4523-ae5a-1d877d47c8e1` | workspace |
| Tools | `collection://58853d91-a1ad-449b-9004-6cec14ce5ed1` | Blue Dot Agency hub page (`3a90afb6-b302-81b5-8242-f86d7f730b3d`) |
| Work Log | `collection://7bd196ea-1d42-42c8-ae9f-4e0d8d63bf7f` | Blue Dot Agency hub page (`3a90afb6-b302-81b5-8242-f86d7f730b3d`) |

If any write reports an unknown property, the schema has drifted — `fetch` the data source URL
to get the current schema before retrying, and update the tables below.

### AI Skills schema

| Property | Type | Notes |
|---|---|---|
| Skill name | title | Must match `name:` in the skill's `SKILL.md` frontmatter |
| Description | text | Should match/summarize `description:` in frontmatter |
| Status | select | `Idea`, `In Progress`, `Active`, `Deprecated` |
| Category | multi-select | `MCP Integration`, `Dev Workflow`, `Automation`, `Docs/Research` |
| Repo Path | text | Relative path from repo root |

### Tools schema

| Property | Type | Notes |
|---|---|---|
| Name | title | Tool/platform name, e.g. "Vercel" |
| Category | select | `Hosting/Dev`, `CRM`, `E-commerce`, `Design`, `Marketing`, `Other` — add new options via `notion-update-data-source` if none fit |
| Status | select | `Active`, `Trial`, `Deprecated` |
| Link | url | Dashboard/login URL, optional |

The actual notes (what it's used for, config details, gotchas) live in the **page content**, not
a property — keep it a short bullet list, not prose.

### Work Log schema

| Property | Type | Notes |
|---|---|---|
| Name | title | `YYYY-MM-DD` for daily entries, `Week of YYYY-MM-DD` for weekly |
| Date | date | The day (daily) or the Monday of the week (weekly) |
| Entry Type | select | `Daily` or `Weekly` |

Page content format — keep it tight, bullets only, no prose paragraphs:

```
**Accomplished today**
- ...
- ...

**Tomorrow**
- ...

**Tasks referenced (monday.com)**
- Task name — status — [link if available]
```

For a `Weekly` entry, replace the two daily sections with a single **This week** bullet summary
(3-6 bullets max, roll up the daily entries rather than re-listing every task).

## Capabilities

### AI Skills catalog
- **Add a new skill**: `notion-create-pages` into the AI Skills data source when a new
  `.claude/skills/<name>/SKILL.md` is added to the repo. Pull `name`/`description` from
  frontmatter. Default `Status` to `In Progress` unless told it's finished.
- **Update a skill**: look up its page (search or query) to get the page ID — never guess one —
  then `notion-update-page` with `update_properties`, touching only what changed.
- **List/query**: `notion-query-data-sources` in `sql` mode against the AI Skills data source.

### Blue Dot Agency Tools
- **Add a tool**: `notion-create-pages` into the Tools data source. Set Name/Category/Status,
  and write the initial notes as a short bullet list in `content` (What it's used for / Account
  or plan / Notes) — don't fabricate details the user hasn't given you.
- **Update notes on a tool**: find the page (search by name in the Tools data source), then use
  `notion-update-page` with `update_content` (targeted search-and-replace) to add/amend a
  bullet, or `insert_content` to append a new dated note under a `**YYYY-MM-DD**` sub-heading if
  the tool wants a running history rather than a static summary.
- **List tools**: query the Tools data source, optionally filtered by Category or Status.

### Blue Dot Agency Work Log
This is where daily/weekly progress gets documented — always dated, always concise bullets.

- **Log today's progress**: 
  1. If the user wants monday.com tasks pulled in, use the **read-only** monday tools
     (`get_board_items_page` on board `5029840882`, filtered/scanned for items touched or
     relevant to today) to get task names, current Status, and descriptions. This is a read for
     context only — see Guardrails.
  2. Check whether a Work Log entry already exists for today's date (query the Work Log data
     source by `Date`). If it exists, append to it (`update_content`/`insert_content`) rather
     than creating a duplicate row for the same day.
  3. Create (or update) the entry: title `YYYY-MM-DD`, `Entry Type: Daily`, `Date` set to today.
     Content follows the format above — accomplished today, tomorrow's plan, tasks referenced.
     Ask the user what was accomplished and what's planned for tomorrow if they haven't said —
     don't invent progress that wasn't reported.
- **Weekly summary**: query the week's `Daily` entries from the Work Log data source (`Date`
  between Monday and Sunday of the target week), and roll them into one `Weekly` entry titled
  `Week of YYYY-MM-DD` (Monday's date) with a short bullet summary — don't just concatenate the
  daily bullets verbatim, condense to the notable outcomes.
- **Look back**: query by date range to answer "what did I do last week" / "what's still open
  from Tuesday" type questions, straight from the stored entries.

Always base Work Log answers on the query just run, not on earlier conversation context — the
log changes daily.

## Guardrails

- **Never write to monday.com from this skill.** This skill has read-only access to
  monday.com — it may call `get_board_items_page`, `get_board_info`, `board_insights`, and
  `get_updates` to pull task names/status/descriptions for documentation purposes, and nothing
  else. Never call `create_item`, `change_item_column_values`, `all_api_write` (write mode),
  `create_update`, `move_object`, `create_automation`, `manage_automations`, or any other
  monday write tool from this skill — not even if the user says "mark it done" while asking for
  a log entry. Updating monday itself is **monday-skill's** job; if the user wants the board
  changed, tell them so and hand off rather than doing it here.
- Never fabricate page IDs, property values, catalog/log/tool contents, or "accomplishments" —
  every claim must trace back to a tool call made in this invocation or something the user
  explicitly told you.
- Don't change database schemas (add/remove/rename properties) without the user asking — if a
  write fails on a missing property, report it and ask before running `notion-update-data-source`.
- Keep Work Log and Tools content genuinely concise — short bullets, not paragraphs. This is a
  personal reference log, not a report; optimize for "scan it in 10 seconds," not completeness.
