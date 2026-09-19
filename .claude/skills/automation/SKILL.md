---
name: automation
description: Plan, implement, and troubleshoot CRM and cross-app workflows, including GoHighLevel, with clear triggers, ownership, duplicate handling, and measurable outcomes. Use for automation builds and adoption plans rather than routine task or note edits.
---

# Automation

Start with the recurring task and desired outcome. Inspect the current systems, account scope, existing workflows, and actual tool access. A historic stack list is not a live account inventory. Use existing suitable tools before recommending additional subscriptions.

## Define the workflow

Capture outcome, owner, account/location, trigger, eligibility, authoritative record, stable identifier, required fields, actions, success condition, and failure destination. For a build or handoff, use [workflow brief](references/workflow-brief.md).

Choose one source of truth per record type. Link other systems to it; avoid unnecessary bidirectional synchronization. Use deterministic logic for matching, routing, and state changes, with AI only for interpretation or drafting that benefits from it.

For GoHighLevel, distinguish its workflow, conversational, voice, and agent products using current documentation and actual account entitlements. Verify the available connector schema instead of assuming an app visible in one host is available in another. Apply the same discipline to other platforms.

## Build and test

Reuse appropriate fields and workflows. Begin with a draft/inactive configuration and synthetic or authorized test records where supported. Specify re-entry rules, stable event keys, duplicate prevention, bounded retries, and loop prevention. Inspect delivery logs before retrying an ambiguous send.

Exercise the normal path, duplicate event, missing input, failed downstream action, and ineligible/opted-out contact where messaging applies. Check saved configuration and actual execution evidence.

Separate planning from sending, publishing, granting access, and spending. Honor the user's existing authorization, but do not infer permission to contact customers from a request to design an automation.

## Adoption and handoff

Measure completed runs, missed or duplicate actions, review/rework, maintenance, and incremental cost. Do not equate automated activity with conversion gains. Recommend keep, improve, or stop based on evidence.

Report verified state precisely: designed, configured, tested, active, or monitored. Provide relevant workflow/record links, test results, and a disable/rollback route. If access prevents implementation, finish the usable specification and label it unimplemented.
