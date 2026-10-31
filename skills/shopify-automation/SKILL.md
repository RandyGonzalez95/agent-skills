---
name: shopify-automation
description: Translate Shopify customer/order tagging rules into Flow prompts or webhook and Admin API plans.
---

# Shopify Automation

Accept lists or JSON rules with tag, entity, method, trigger, condition, action, and notes. Infer structure where clear; resolve which record is tagged and when.

## Choose the route

Honor Flow or custom implementation requests. Verify current triggers, fields, actions, builder capabilities, and store entitlements. If a route cannot express a rule, identify the missing capability and propose an alternative.

For Flow, give one copyable instruction per workflow: event, conditions, exact tag additions/removals, and related record changes. Keep caveats outside prompts. Provide manual steps when requested or needed.

For custom routes, specify webhook topic, payload/follow-up reads, target identity, API version/scopes, and mutation behavior. Prefer additive tag operations. If replacing a collection, preserve unrelated tags and handle concurrent updates.

## Reliability and delivery

Define removal, re-entry, delayed-event, changed-state, missing-data, and backfill behavior. Verify webhook authenticity, deduplicate event IDs, bound retries, prevent update loops, and respect rate limits. Inspect errors before retrying.

Test eligible, ineligible, duplicate, existing-tag, and reversal cases. Keep credentials out of plans/source.

Deliver prompts or implementation plans with verification sources, caveats, and tests. Distinguish generated instructions from installed/active workflows; activation and customer communications require corresponding authorization.
