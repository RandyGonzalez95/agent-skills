---
name: automation
description: Build and troubleshoot CRM and cross-app automations, including GoHighLevel, with reliable triggers and handoffs.
---

# Automation

Identify the recurring task, outcome, owner, account scope, existing workflows, and available tools. Prefer suitable existing systems over new subscriptions; verify live access and entitlements.

## Define and build

Use the [workflow brief](references/workflow-brief.md) for builds and handoffs. Specify trigger, eligibility, authoritative record, stable identifier, fields, actions, success, and failure destination. Choose one source of truth per record type; avoid unnecessary bidirectional sync. Use deterministic logic for matching and state changes, and AI where interpretation or drafting helps.

Verify current connector schemas and product capabilities. For GoHighLevel, distinguish workflow, conversational, voice, and agent products.

Reuse existing fields and workflows. Start inactive with synthetic or authorized test records where supported. Define re-entry, event deduplication, bounded retries, and loop prevention. Inspect delivery logs before retrying an uncertain send.

## Verify and hand off

Test normal, duplicate, missing-input, downstream-failure, and ineligible/opted-out cases where applicable. Inspect saved configuration and execution evidence. A design request alone does not authorize customer contact, activation, access grants, or spending; honor existing session authorization.

Measure successful runs, missed/duplicate actions, rework, maintenance, and incremental cost. Activity alone does not prove conversion gains.

Report the verified state: designed, configured, tested, active, or monitored. Include workflow links, results, and rollback/disable instructions. If implementation is blocked, deliver a usable specification labeled unimplemented.
