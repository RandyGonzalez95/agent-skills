---
name: notion-skill
description: Manages Randy's Notion workspace — the AI Skills catalog, the Blue Dot Agency Tools reference, the Work Log (daily/weekly progress notes), and Task Docs (deep documentation pulled from monday.com tasks, including linked docs). Handles requests like "add this skill to Notion", "log today's progress", "what did I work on this week", "add a note on HubSpot", "pull today's monday tasks into my log", "document this monday task", or "outline how to complete task X". Always drives Notion live through the Notion MCP tools, never from memory. Has READ-ONLY access to monday.com — it reads task names/status/descriptions/updates/attached docs to document them in Notion, and never creates, edits, or moves anything on a monday board.
---

# notion-skill

Manages Randy's Notion workspace across three areas, all under the same guardrail: this skill
always acts through the Notion MCP tools and never reports content from memory. Every
invocation must make at least one live MCP call before answering.

1. **AI Skills catalog** — the index of skills in the `agent-skills` GitHub repo.
2. **Blue Dot Agency Tools** — reference notes on tools/platforms the business runs on.
3. **Blue Dot Agency Work Log** — daily/weekly progress notes, optionally pulling task context
   from monday.com (read-only).
4. **Blue Dot Agency Task Docs** — deep documentation for a monday.com task: description, notes,
   update history, and the contents of any linked doc, distilled into a summary and a "how to
   complete this" outline (read-only against monday.com).

## Setup

The `mcp__claude_ai_Notion__*` tools are deferred. Before doing anything else, load the ones
this skill needs:

```
ToolSearch: select:mcp__claude_ai_Notion__notion-fetch,mcp__claude_ai_Notion__notion-create-pages,mcp__claude_ai_Notion__notion-update-page,mcp__claude_ai_Notion__notion-query-data-sources,mcp__claude_ai_Notion__notion-search,mcp__claude_ai_Notion__notion-update-data-source
```

For Work Log or Task Docs entries that reference monday.com tasks, also load these —
**read-only tools only**, see the Guardrails section:

```
ToolSearch: select:mcp__claude_ai_monday_com__get_board_items_page,mcp__claude_ai_monday_com__get_board_info,mcp__claude_ai_monday_com__board_insights,mcp__claude_ai_monday_com__get_updates,mcp__claude_ai_monday_com__get_assets
```

Task Docs also needs to read whatever a linked doc actually is. Load these as needed, on top of
the above — never guess a doc's contents, always fetch it:

```
ToolSearch: select:WebFetch,mcp__claude_ai_Google_Drive__read_file_content,mcp__claude_ai_Google_Drive__search_files,mcp__claude_ai_Google_Drive__get_file_metadata
```

- Google Docs/Sheets/Slides links (`docs.google.com`, `drive.google.com`) → Google Drive tools
  (`read_file_content`, or `search_files` first if you only have a name, not a link).
- A monday.com file/attachment (from an update's `assets` or a Files-type column) → `get_assets`
  with its asset ID to resolve a temporary download URL, then fetch that URL.
- Any other web link (Word Online, Notion, a generic doc URL, etc.) → `WebFetch`.
- If a link can't be read (permissions, not shared, unsupported format), say so explicitly in
  the Notion entry rather than guessing at the content or skipping it silently.

## Database reference

| Database | Data source (use for queries/creates) | Parent |
|---|---|---|
| AI Skills | `collection://3a79fced-c090-4523-ae5a-1d877d47c8e1` | workspace |
| Tools | `collection://58853d91-a1ad-449b-9004-6cec14ce5ed1` | Blue Dot Agency hub page (`3a90afb6-b302-81b5-8242-f86d7f730b3d`) |
| Work Log | `collection://7bd196ea-1d42-42c8-ae9f-4e0d8d63bf7f` | Blue Dot Agency hub page (`3a90afb6-b302-81b5-8242-f86d7f730b3d`) |
| Task Docs | `collection://1c5e3f45-0798-4d78-b477-a0dcac838b70` | Blue Dot Agency hub page (`3a90afb6-b302-81b5-8242-f86d7f730b3d`) |

Randy's default board is always **"Randy's Tasks"** (`5029840882`) unless he names a different
board.

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

### Task Docs schema

| Property | Type | Notes |
|---|---|---|
| Name | title | Task name, copied verbatim from monday |
| Monday Task | url | Link to the monday item |
| Monday Status | select | Snapshot of the Status column at sync time — mirrors monday's labels but is **not live**, see Guardrails |
| Priority | select | Snapshot of the Priority column: `Critical`, `High`, `Medium`, `Low` |
| Category | select | Snapshot of the Category column: `Development`, `Design`, `Testing`, `Documentation` |
| Source Doc | url | The linked doc (Google Doc, Word Online, etc.), if the task has one |
| Last Synced | date | The date this documentation was pulled — always today, not the task's due date |

Page content format:

```
**Task summary**
- 1-2 bullets: what the monday task itself is asking for

**Document summary**
- A real summary of the linked source doc's actual content — what it says, its structure,
  what it covers. This is a summary of the DOCUMENT, distinct from the task summary above.
  Omit this section only if there's no linked doc / no extra material beyond the task itself.

**Notes: how to complete this task**
- Concrete, actionable, ideally ordered steps for actually doing the work — synthesized from
  the doc + task, not just a copy of the doc's own outline. This is the actual point of the
  entry: someone should be able to read this section alone and know what to do next.

**Open questions** (only if the source material flags any)
- ...

**Source**
- What was actually read and how: monday description / Notes column / update text / linked doc
  (name it) — plus the monday item link and, if a linked doc exists, its link.
- If a linked doc could NOT be read (no access, 401, unsupported format), say so explicitly here
  and note what to do about it (e.g. "share it with the connected Google account to enable a
  direct read") — never silently fall back without flagging it.
```

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

### Blue Dot Agency Task Docs
Pulls everything available on a monday.com task and turns it into a documented outline of what
the task is and how to complete it.

1. **Default to the "Randy's Tasks" board** (`5029840882`) unless the user names a different
   board. "The first To Do task" means the first item (by position) in the `topics` (To Do)
   group.
2. **Gather everything** on the task before writing anything:
   - `get_board_items_page` with `itemIds: [<id>]`, `includeColumns: true`,
     `includeItemDescription: true` — gets column values (Notes, Priority, Category, Status,
     Due Date) and the item's description body.
   - `get_updates` with `objectId: <id>`, `objectType: "Item"`, `includeAssets: true`,
     `includeReplies: true` — **always call this, on every task, no exceptions.** Comments are
     frequently where the actual spec, a doc link, or a specific instruction lives — sometimes
     the *only* place it lives, with the item description/Notes left empty (this has happened:
     a task with nothing else on it had the real instruction buried in a comment).
   - Scan the Notes column, description, and update text for URLs. If a monday update has file
     assets attached, note their asset IDs.
   - **Read every update/comment and reply in full, line by line — don't skim for a
     topic-level match and move on.** A comment can be a long, multi-topic dump where most of
     it is unrelated noise (a shared running list, a brain-dump touching several projects) but
     one line in the middle is the actual relevant instruction for *this* task. Judge relevance
     line by line, not comment by comment — a comment being mostly irrelevant is not grounds to
     treat it as entirely irrelevant. If you do find genuinely irrelevant content, say so and
     explain briefly why (e.g. "covers other projects, no mention of X"), don't just silently
     drop it.
3. **Resolve every doc link found** using the tools listed in Setup — Google Drive for Google
   links, `get_assets` + fetch for monday attachments, `WebFetch` for anything else. Always
   attempt the direct read even if the full text also appears pasted somewhere on the task —
   the doc is the primary source; monday text is a fallback, not a substitute.
   - If the read fails (401, not found, unsupported format, not shared with the connected
     account), don't silently fall back — try any pasted text on the task as a secondary source
     if it's there, and **always** state in the entry's Source section that the direct read
     failed and why, so Randy knows the summary is one step removed from the actual doc.
4. **Write one Task Docs entry** (see schema above) — check first whether one already exists for
   this task (query by `Monday Task` URL) and update it in place rather than duplicating if so.
   Keep **Task summary** and **Document summary** genuinely distinct — the task summary is what
   monday says the task is, the document summary is what the linked doc actually contains. Then
   **Notes: how to complete this task** turns that into action — don't just restate the doc's
   own section headings, synthesize what someone would actually need to do next.
5. Report back what you did in the chat too: name the task, link the Notion entry, and give a
   one-line summary — don't make the user go open Notion to find out what happened.

## Guardrails

- **Never write to monday.com from this skill.** This skill has read-only access to
  monday.com — it may call `get_board_items_page`, `get_board_info`, `board_insights`,
  `get_updates`, and `get_assets` (which only resolves a temporary download URL, it doesn't
  modify anything) to pull task details and attached docs for documentation purposes, and
  nothing else. Never call `create_item`, `change_item_column_values`, `all_api_write` (write
  mode), `create_update`, `move_object`, `create_automation`, `manage_automations`, or any other
  monday write tool from this skill — not even if the user says "mark it done" while asking for
  a log or task doc. Updating monday itself is **monday-skill's** job; if the user wants the
  board changed, tell them so and hand off rather than doing it here.
- `Monday Status`/`Priority`/`Category` on a Task Docs entry are a **point-in-time snapshot**,
  not a live sync — if the task changes on monday later, the Notion entry doesn't update itself.
  Say so if the user seems to be treating it as current when it might be stale (re-run the doc
  capability to refresh it).
- Never fabricate page IDs, property values, catalog/log/tool contents, or "accomplishments" —
  every claim must trace back to a tool call made in this invocation or something the user
  explicitly told you.
- **Always pull and actually read task comments/updates for Task Docs and Work Log task
  references — never skip `get_updates` and never skim it.** Read line by line; a long or
  multi-topic comment can still contain one relevant instruction worth surfacing even if the
  rest of it is noise. Missing something because a comment "looked" irrelevant at a glance is
  the failure mode to actively guard against.
- Don't change database schemas (add/remove/rename properties) without the user asking — if a
  write fails on a missing property, report it and ask before running `notion-update-data-source`.
- Keep Work Log and Tools content genuinely concise — short bullets, not paragraphs. This is a
  personal reference log, not a report; optimize for "scan it in 10 seconds," not completeness.
