# Worked example — health/medical-supply store

## Input tag definitions

```json
[
  {
    "tag": "first-purchase",
    "entity": "customer",
    "method": "flow",
    "trigger": "Order created",
    "condition": "Customer's order count equals 1",
    "action": "Add customer tag 'first-purchase'",
    "notes": ""
  },
  {
    "tag": "repeat-customer",
    "entity": "customer",
    "method": "flow",
    "trigger": "Order created",
    "condition": "Customer's order count is greater than 1",
    "action": "Add customer tag 'repeat-customer'; optionally remove 'first-purchase'",
    "notes": ""
  },
  {
    "tag": "cart-abandoned",
    "entity": "customer",
    "method": "flow",
    "trigger": "Checkout abandoned",
    "condition": "",
    "action": "Add customer tag 'cart-abandoned'",
    "notes": "Flow has no 'checkout started' trigger — abandonment is the earliest signal it can act on."
  },
  {
    "tag": "marketing-subscribed",
    "entity": "customer",
    "method": "flow",
    "trigger": "Customer created or Customer updated",
    "condition": "Customer accepts marketing is true",
    "action": "Add customer tag 'marketing-subscribed'",
    "notes": ""
  },
  {
    "tag": "sms-opt-in",
    "entity": "customer",
    "method": "flow",
    "trigger": "Customer created or Customer updated",
    "condition": "Customer SMS marketing consent state is subscribed",
    "action": "Add customer tag 'sms-opt-in'",
    "notes": ""
  },
  {
    "tag": "bulk-order",
    "entity": "order",
    "method": "flow",
    "trigger": "Order created",
    "condition": "Order total quantity is greater than or equal to 2",
    "action": "Add order tag 'bulk-order'; also add customer tag 'bulk-buyer'",
    "notes": "Signals a clinic/facility buyer rather than an individual patient."
  },
  {
    "tag": "single-unit",
    "entity": "order",
    "method": "flow",
    "trigger": "Order created",
    "condition": "Order total quantity equals 1",
    "action": "Add order tag 'single-unit'",
    "notes": ""
  },
  {
    "tag": "hsa-fsa-payment",
    "entity": "order",
    "method": "flow",
    "trigger": "Order paid",
    "condition": "Payment gateway name contains the HSA/FSA processor name (e.g. Truemed, Flex)",
    "action": "Add order tag 'hsa-fsa-payment'",
    "notes": "Only works if an HSA/FSA-specific payment gateway is installed; standard card gateways don't expose this."
  },
  {
    "tag": "source-google",
    "entity": "order",
    "method": "custom",
    "trigger": "orders/create webhook",
    "condition": "Parsed landing_site/referring_site indicates Google as source",
    "action": "Call orderUpdate mutation to add order tag 'source-google'",
    "notes": "Flow can't read UTM/referring-site fields natively; requires a webhook handler."
  },
  {
    "tag": "source-referral",
    "entity": "order",
    "method": "custom",
    "trigger": "orders/create webhook",
    "condition": "Parsed referring_site indicates a referral domain (non-search, non-direct)",
    "action": "Call orderUpdate mutation to add order tag 'source-referral'",
    "notes": "Same webhook handler as source-google/source-organic, branching on parsed source."
  },
  {
    "tag": "source-organic",
    "entity": "order",
    "method": "custom",
    "trigger": "orders/create webhook",
    "condition": "Parsed landing_site/referring_site indicates organic/direct traffic",
    "action": "Call orderUpdate mutation to add order tag 'source-organic'",
    "notes": "Same webhook handler as source-google/source-referral, branching on parsed source."
  },
  {
    "tag": "individual-buyer",
    "entity": "customer",
    "method": "custom",
    "trigger": "orders/create webhook or checkout extension field",
    "condition": "No company name present at checkout; personal email domain",
    "action": "Call customerUpdate mutation to add customer tag 'individual-buyer'",
    "notes": "No structured 'buying for' field exists by default — needs a checkout extension or inference logic."
  },
  {
    "tag": "caregiver-buyer",
    "entity": "customer",
    "method": "custom",
    "trigger": "orders/create webhook or checkout extension field",
    "condition": "Checkout 'buying for' field indicates caregiver purchase (requires custom checkout field)",
    "action": "Call customerUpdate mutation to add customer tag 'caregiver-buyer'",
    "notes": "Requires adding a checkout UI extension to capture this field; can't be inferred reliably otherwise."
  },
  {
    "tag": "clinic-buyer",
    "entity": "customer",
    "method": "custom",
    "trigger": "orders/create webhook",
    "condition": "Company name field present and/or non-personal email domain",
    "action": "Call customerUpdate mutation to add customer tag 'clinic-buyer'",
    "notes": "Inference-based; accuracy improves with a checkout company-name field."
  },
  {
    "tag": "home-health-agency",
    "entity": "customer",
    "method": "custom",
    "trigger": "orders/create webhook",
    "condition": "Company name matches known home health agency patterns, or bulk-order + company name present",
    "action": "Call customerUpdate mutation to add customer tag 'home-health-agency'",
    "notes": "Weakest inference of the set; consider manual review/enrichment instead of full automation."
  }
]
```

## Generated Flow AI prompts (8 tags)

**first-purchase**
```
When an order is created, check if the customer's order count equals 1. If true, add the tag "first-purchase" to the customer.
```

**repeat-customer**
```
When an order is created, check if the customer's order count is greater than 1. If true, add the tag "repeat-customer" to the customer and remove the tag "first-purchase" from the customer.
```

**cart-abandoned**
```
When a checkout is abandoned, add the tag "cart-abandoned" to the customer.
```
Caveat: Flow has no "checkout started" trigger — abandonment is the earliest signal it can act on.

**marketing-subscribed**
```
When a customer is created or updated, check if the customer accepts marketing. If true, add the tag "marketing-subscribed" to the customer.
```

**sms-opt-in**
```
When a customer is created or updated, check if the customer's SMS marketing consent state is subscribed. If true, add the tag "sms-opt-in" to the customer.
```

**bulk-order**
```
When an order is created, check if the order's total quantity of items is greater than or equal to 2. If true, add the tag "bulk-order" to the order and add the tag "bulk-buyer" to the customer.
```
Caveat: signals a clinic/facility buyer rather than an individual patient.

**single-unit**
```
When an order is created, check if the order's total quantity of items equals 1. If true, add the tag "single-unit" to the order.
```

**hsa-fsa-payment**
```
When an order is paid, check if the payment gateway name contains "<HSA/FSA processor name, e.g. Truemed or Flex>". If true, add the tag "hsa-fsa-payment" to the order.
```
Caveat: only works if an HSA/FSA-specific gateway is installed; standard card gateways don't
expose this. Replace the bracketed placeholder with the actual installed gateway name before
submitting.

## Not expressible as a Flow AI prompt (7 tags)

`source-google`, `source-referral`, `source-organic`, `individual-buyer`, `caregiver-buyer`,
`clinic-buyer`, `home-health-agency` all depend on data (UTM/referring-site, checkout company
name, custom "buying for" fields) that Flow's trigger/condition library doesn't expose — no
phrasing of a Flow AI prompt can generate these. Each needs a webhook + Admin API mutation
instead:

- **source-google / source-referral / source-organic** — one shared `orders/create` webhook
  handler, branching on parsed `landing_site`/`referring_site`, calling `orderUpdate` to append
  the matching `source-*` tag to `tags`.
- **individual-buyer / caregiver-buyer / clinic-buyer / home-health-agency** — an `orders/create`
  webhook (plus, ideally, a checkout UI extension capturing company name / "buying for"), calling
  `customerUpdate` to append the inferred tag to `tags`. `caregiver-buyer` specifically requires
  the checkout extension since it can't be inferred from order data alone; `home-health-agency`
  is the weakest inference of the set and may warrant manual review instead of full automation.
