---
name: notion-skill
description: Manages the "AI Skills" catalog database in Randy's Notion workspace — the live index of every AI skill in the agent-skills GitHub repo. Add a new skill entry, update a skill's status/description, look up what skills exist, or search the workspace. Always drives Notion live through the Notion MCP tools, never from memory. Use for requests like "add this skill to Notion", "mark X skill as active/deprecated", "what skills do I have", or "update the description for X".
---

# notion-skill

Manages the **AI Skills** database in Randy's Notion workspace. This database is the catalog
of record for every skill in the `agent-skills` GitHub repo — one row per skill, kept in sync
with the `SKILL.md` files that actually live in the repo. This skill always acts through the
Notion MCP tools — it never reports catalog contents from memory. Every invocation must make
at least one live MCP call before answering.

## Setup

The `mcp__claude_ai_Notion__*` tools are deferred. Before doing anything else, load the ones
this skill needs:

```
ToolSearch: select:mcp__claude_ai_Notion__notion-fetch,mcp__claude_ai_Notion__notion-create-pages,mcp__claude_ai_Notion__notion-update-page,mcp__claude_ai_Notion__notion-query-data-sources,mcp__claude_ai_Notion__notion-search,mcp__claude_ai_Notion__notion-update-data-source
```

## Database reference

| Item | ID |
|---|---|
| Database ("AI Skills") page | `e6d8bcacd6f84db1ab845b63c21eb88c` |
| Data source (use for queries/creates) | `collection://3a79fced-c090-4523-ae5a-1d877d47c8e1` |

Schema (confirm with `fetch` on the data source URL if a write ever reports an unknown
property — the table below may drift if someone edits the schema by hand):

| Property | Type | Notes |
|---|---|---|
| Skill name | title | Must match the `name:` field in the skill's `SKILL.md` frontmatter |
| Description | text | Should match (or summarize) the `description:` field in frontmatter |
| Status | select | `Idea`, `In Progress`, `Active`, `Deprecated` |
| Category | multi-select | `MCP Integration`, `Dev Workflow`, `Automation`, `Docs/Research` — add new options via `notion-update-data-source` if none fit |
| Repo Path | text | Relative path from repo root, e.g. `.claude/skills/notion-skill/SKILL.md` |
| Files | file | Notion-native attachment slot; not used by this workflow, leave alone |
| Created by / createdTime | system | Read-only, don't try to set |

## Capabilities

### Add a new skill entry
When a new skill is created in the `agent-skills` repo (a new `.claude/skills/<name>/SKILL.md`
file), add a matching row via `notion-create-pages` with `parent: {type: "data_source_id",
data_source_id: "3a79fced-c090-4523-ae5a-1d877d47c8e1"}`. Pull the `name` and `description`
straight from the skill's frontmatter so the catalog never drifts from the source file. Default
`Status` to `In Progress` unless the user says the skill is finished/tested, in which case use
`Active`. Always set `Repo Path`.

### Update a skill (status, description, category)
Look the row up first — by `notion-search` (query_type internal, restricted mentally to this
database) or by querying the data source — to get its page ID. Never guess a page ID. Then use
`notion-update-page` with `command: "update_properties"`. Only touch the properties the user
asked to change; leave the rest as-is.

### List / query skills
Use `notion-query-data-sources` in `sql` mode against
`collection://3a79fced-c090-4523-ae5a-1d877d47c8e1`. Examples:
- All active skills: `SELECT * FROM "collection://3a79fced-c090-4523-ae5a-1d877d47c8e1" WHERE Status = 'Active'`
- Everything, for a full inventory: `SELECT * FROM "collection://3a79fced-c090-4523-ae5a-1d877d47c8e1"`

Always base the answer on the query just run, not on earlier context in the conversation —
the catalog changes as skills are added or updated.

### Keep the repo and catalog in sync
If asked to reconcile the two: read the `SKILL.md` files under `.claude/skills/` in the repo
(name + description from frontmatter), query the full catalog, and diff them. Report skills
present in one place but not the other rather than silently fixing it, unless the user asked
for an automatic sync.

## Guardrails

- Never fabricate page IDs, property values, or catalog contents — every claim must trace back
  to a tool call made in this invocation.
- Don't change the database schema (add/remove/rename properties) without the user asking —
  that's structural, not catalog maintenance. If a write fails because a property is missing,
  report it and ask before running `notion-update-data-source`.
- This skill only manages the **AI Skills** database. Broader workspace changes (other pages,
  other databases) are out of scope unless explicitly requested.
