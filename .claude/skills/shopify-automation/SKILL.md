---
name: shopify-automation
description: Turn Shopify smart-tag rules into Flow builder prompts or webhook and Admin API implementation plans. Use for customer/order tagging automations with explicit triggers, conditions, and tag lifecycle behavior.
---

# Shopify Automation

Accept a list or JSON definitions with tag, entity, method, trigger, condition, action, and notes. Infer missing structure from the supplied intent, but resolve ambiguity about which record is tagged and when the rule applies.

## Select and verify the route

Respect an explicit Flow or custom route. Verify current Flow triggers, available fields, actions, builder capabilities, and store entitlements before claiming feasibility. Do not inherit a static list of unsupported events or fields from older notes. If the requested route cannot express the rule, explain the specific missing capability and propose an alternative.

For Flow, produce one copyable natural-language instruction per workflow: when the verified event occurs, check the condition, then perform the exact tag actions. Include removals and related entity changes when requested. Keep caveats outside the prompt. Provide manual UI steps when requested or when the chosen builder route is unavailable.

For custom implementation, specify the verified webhook topic, needed payload fields or follow-up reads, target record identity, API version/scopes, and mutation behavior. Prefer a supported additive tag operation; if an update replaces a tag collection, explicitly preserve existing unrelated tags and handle concurrent updates rather than overwriting them blindly.

## Reliability

Define addition, removal, and re-entry conditions. Consider delayed events, changed customer state, missing data, and historical backfill. For webhooks, validate authenticity, deduplicate event IDs, bound retries, and avoid feedback loops caused by the tag update itself. Respect API rate limits and inspect errors before retrying.

Test an eligible record, ineligible record, duplicate delivery, existing tags, and reversal where applicable. Keep credentials out of plans and source files.

Deliver the prompts or implementation plan, verification sources, caveats, and test cases. A generated prompt is not an installed or activated workflow. Live activation and customer communications need the corresponding scope in the user's request.
