---
name: shopify-workflow
description: Generates Shopify automation specs from a smart-tag definition list — a ready-to-paste natural-language prompt for Shopify Flow's AI workflow builder for `"method": "flow"` tags, or a webhook + Admin API mutation plan for `"method": "custom"` tags that Flow can't handle natively. Use for requests like "generate Shopify workflows for these tags", "turn this tag list into Flow prompts", "what's the webhook plan for tag X", or "/shopify-workflow".
---

# shopify-workflow

Turns a JSON list of smart-tag definitions into ready-to-use Shopify automations: one
Flow-AI-builder prompt per `"method": "flow"` tag, and a webhook/Admin-API implementation plan
per `"method": "custom"` tag.

## Input format

Each tag definition is an object:

```json
{
  "tag": "first-purchase",
  "entity": "customer",       // "customer" or "order" — the record the tag is applied to
  "method": "flow",           // "flow" or "custom"
  "trigger": "Order created",
  "condition": "Customer's order count equals 1",
  "action": "Add customer tag 'first-purchase'",
  "notes": ""                 // caveat/dependency to surface, or "" if none
}
```

If the user gives a tag list without this exact shape, infer the fields from whatever they
provide (tag name, what record it tags, and the rule that triggers it) before generating output.

## Output rules

### `"method": "flow"`
Output a single natural-language prompt meant to be pasted directly into Shopify Flow's AI
workflow builder (Admin → Apps → Flow → Create workflow → describe with AI). Do not output manual
"trigger/condition/action" UI steps unless the user explicitly asks for the manual
build-it-yourself version instead of the AI-prompt version.

- Phrase it as one imperative instruction: "When X, check if Y. If true, do Z."
- Match the trigger to Flow's real built-in trigger library only (Order created, Order paid,
  Customer created, Customer updated, Checkout abandoned, etc.) — never invent a trigger that
  doesn't exist in Flow (e.g. there is no "checkout started" trigger — abandonment is the
  earliest signal Flow can act on).
- Fold multiple actions into the same prompt (e.g. add one tag + remove another, or tag both an
  order and its customer).
- If `notes` is non-empty, append it as a one-line caveat below the prompt block — not inside the
  prompt text itself, since Flow's AI builder should only see the instruction.
- Wrap each prompt in its own fenced code block so it can be copy-pasted cleanly.

### `"method": "custom"`
These need a webhook-driven custom app/backend, not Flow — say so explicitly rather than forcing
a Flow prompt. Output:
- **Webhook topic** to subscribe to (e.g. `orders/create`, `orders/paid`, `customers/create`)
- **Field(s) to parse** from the payload (e.g. `landing_site`, `referring_site`, a company name
  captured via checkout extension)
- **Admin API mutation** needed (`customerUpdate` or `orderUpdate` with the `tags` field)
- The `notes` caveat, verbatim or lightly tightened

Never try to force a `"custom"` tag into a Flow AI prompt — Flow's trigger/condition library
can't read UTM params, referring-site, or arbitrary checkout-extension fields, so no phrasing of
a prompt will make it work. Say plainly that it isn't expressible in Flow.

## Applying tags

Tags are free-text strings on the `entity` record (customer or order) — there's no separate
tag-creation step in Shopify. "Add tag" always means appending to that record's existing `tags`
array (via `customerUpdate`/`orderUpdate` for the custom path, or Flow's built-in "Add tag"
action for the flow path).

## Example

A full 15-tag worked example (health/medical-supply store use case) — input JSON, generated Flow
AI prompts, and the custom webhook plan — is in `example.md` for reference.
