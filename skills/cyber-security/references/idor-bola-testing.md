# Workspace-specific IDOR/BOLA tests

Run this phase for application audits and authorization test requests. The deliverable
is an executable suite adapted to the current workspace, an operation inventory, and
results reconciled against that inventory. The bundled Python helper checks coverage;
it does not discover routes, send requests, or decide business permissions.

## Discover operations before generating tests

Use framework route registration/introspection when safely available, and reconcile it
with source routes, mounted prefixes, API versions, generated routes, and API specs.
Do not rely on OpenAPI, a crawler, or filename matching alone. Record discovery sources,
commit/dirty state, enabled route configuration, and unresolved discovery gaps.

Inventory each service + HTTP method + canonical route separately. Also enumerate
GraphQL queries/mutations/subscriptions and sensitive nested resolvers, RPC methods,
server actions, WebSocket messages, and direct client-accessible database/storage
operations when present. One `/graphql` row is not coverage of its operations. Include
list/search/export, create/update/delete, batch, download, and job-result operations;
an endpoint without an ID in its URL may still select private objects. Retain aliases
and alternate methods. Background consumers reached by these operations need tests
of propagated identity and authorization at execution where applicable.

For each operation record source location, object references, effective permission
rule and its evidence, and required cases. Inspect IDs in paths, query/body fields,
headers/cookies, GraphQL variables, parent-child references, and collections. Record
public/static/health operations as `not_applicable` only with a reason grounded in
intended behavior. Public access to private objects is still in scope. Missing setup,
unknown permissions, and unsupported transports are blockers, not exclusions.

## Build real fixtures and an expected-access matrix

Use the existing native test runner, application test client, and disposable test
database. Review startup/test hooks and service configuration first. Isolate network
egress or stub external clients so no production service, payment, message, migration,
or deployment can be reached. Localhost alone does not establish isolation. When safe
execution cannot be established, keep generating the inventory and tests, but report
the affected cases as blocked with the exact prerequisite to run them.

Create synthetic users A and B in one tenant, a user C in another tenant, anonymous
access, and privileged/restricted roles as the actual permission model requires.
Create known-existing objects for each principal and representative sharing/membership
states. No real credentials or customer records. Get authenticated sessions through
the real local auth path or established test fixtures; keep real authorization
middleware, policies, and tenant filters active. Mock external services, not the
authorization decision. Separate fixture-creation privileges from request credentials.

Before executing, derive expected outcomes from requirements, policies, and intended
sharing rules. Do not infer them from the current response or deny all non-owners:
shared/organization resources may legitimately be accessible. Record ambiguous rules
as blocked. Include these cases wherever relevant, explaining omissions per operation:

- Allowed read/write and legitimate sharing/admin access, with exact expected data or
  effect. This establishes that the route, credentials, and fixture are usable.
- Authenticated B substituting A's existing object; C attempting cross-tenant access;
  anonymous access to private objects. Test both directions where policies differ.
- Every object-reference input independently, including a valid parent with another
  parent's child, owner/tenant fields on create/update, and mixed own/foreign batch IDs.
- List/search/export filtering, pagination and counts; indirect downloads, signed-link
  issuance/redemption, queued work and its result retrieval; nested GraphQL data and
  subscriptions where present. Missing or alternate identifiers must not remove scope.
- Role restrictions and revoked membership/stale claims where applicable. Track these
  adjacent authorization checks without mislabeling all role issues as BOLA.

Reset fixtures between mutations; verify target existence before a denied test. Use
fresh valid request bodies, CSRF tokens, and versions so validation or stale state
does not mask authorization behavior. Avoid ID guessing or broad fuzzing: substitute
known fixture references. A single generic case per route is insufficient when several
independent object references or permission rules exist.

## Generate, execute, and assert

In review mode, place tests and sanitized artifacts under the report directory or a
temporary isolated copy; do not edit application code/config to enable a review.
When implementing tests or fixes, put reusable tests/fixtures in the workspace's normal
test locations. Reuse dependencies and runner conventions; adapt the transport instead
of assuming an HTTP-only app. A shared parameterized suite is fine if each inventory
case has its own result and operation-specific assertions.

For allowed cases assert successful behavior and exact expected object/state. For
denied cases assert the intended denial semantics, no foreign private fields, no
unauthorized persistent change, and no queued/external side effect. Read state using
an independent trusted fixture connection and inspect stub/queue calls after requests.
Use filtered success where the contract permits partial results; check exact permitted
IDs and batch atomicity/partial-success rules. GraphQL can return HTTP 200 with errors
and leaked partial data, so inspect both. A 401/403/404 alone is not sufficient; generic
404s, 5xx, timeouts, validation errors, and failed login/setup must not count as passes.

Generate the result JSON from executed test assertions and runner events, never by
hand-labeling a source review as passing. Preserve failures, skips, setup errors, and
expected-failure tests as non-passing; do not use retries to hide intermittent failures.
Capture runner version, sanitized command, exit status, and test IDs. When no native
JSON reporter exists, add a small workspace-specific reporter around the assertions.
Where practical, demonstrate the suite catches a deliberately removed ownership
check in a disposable copy; never weaken the user's working application for this.

## Coverage contract and command

Write `authorization-inventory.json` before running tests. This minimal example shows
one operation; expand cases and metadata for the actual workspace. `scope` identifies
the workspace revision/configuration, and `discovery` records evidence and limitations.
IDs are stable strings. Required checks are names of actual assertions, chosen for the
operation; denied cases must include checks for data, state, and side effects even if
the latter assert no calls/no changes for a read operation.

```json
{
  "schema_version": 1,
  "scope": "service, commit, dirty state, test configuration",
  "discovery": {"sources": ["router enumeration and source comparison"], "gaps": []},
  "operations": [
    {
      "id": "api GET /records/{id}",
      "source": "src/routes/records:20",
      "applicability": "applicable",
      "policy": "Only the owner may read a private record; policy source location",
      "cases": [
        {"id": "owner", "expectation": "allow", "checks": ["authorized_effect"]},
        {"id": "other-user", "expectation": "deny", "checks": ["denial", "no_foreign_data", "no_unauthorized_state", "no_unauthorized_side_effect"]}
      ]
    }
  ]
}
```

Use `applicability: "blocked"` with `reason` and any known cases when setup/policy is
unresolved. Use `not_applicable` with `reason` and `cases: []` for true exclusions.
Applicable operations require at least an allowed and a denied/filtered case. For
`filtered`, require `expected_filter`, `no_foreign_data`, `no_unauthorized_state`, and
`no_unauthorized_side_effect`. Add more assertion names as necessary.

Write `authorization-results.json` from the native runner using this structure:

```json
{
  "schema_version": 1,
  "inventory_sha256": "SHA-256 of the exact inventory file bytes at test start",
  "command": "sanitized native test command",
  "completed": true,
  "exit_code": 0,
  "cases": [
    {"operation": "api GET /records/{id}", "case": "owner", "status": "pass", "checks": ["authorized_effect"], "evidence": "test ID and sanitized assertion log location"},
    {"operation": "api GET /records/{id}", "case": "other-user", "status": "pass", "checks": ["denial", "no_foreign_data", "no_unauthorized_state", "no_unauthorized_side_effect"], "evidence": "test ID and sanitized assertion log location"}
  ]
}
```

Statuses are `pass`, `fail`, `skip`, `blocked`, or `error`. `checks` contains only
assertions that executed and passed. A case is `pass` only when every required check
passes. `completed` means the run finished, including runs with failing tests; a
crashed/aborted runner sets it false. Use a fresh output file per run and preserve the
runner's own exit status in `exit_code` (use a nonzero sentinel for a launch failure).
The helper treats any nonzero runner exit as a gap even if recorded cases passed.
Do not reuse an old result after a failed invocation.

Run with Python 3 from any workspace, resolving the helper from this skill's directory:

```text
python <skill-dir>/scripts/check_authorization_coverage.py <report-dir>/authorization-inventory.json <report-dir>/authorization-results.json
```

The helper emits a JSON summary. Exit 0 means supplied applicable cases passed with
no recorded discovery gaps or blockers; 1 means failed/incomplete coverage; 2 means
invalid input. If everything is excluded, it reports `not_applicable`, never a test
pass. Record the helper output alongside the native test results. If Python is absent,
report that coverage validation could not run and still execute available native tests.

Regenerate discovery on each invocation (and on each CI run if ongoing protection is
requested), compare it with the case matrix, and add new operations/cases before
checking results. Never shrink the inventory to make a run pass. The helper rejects
missing/duplicate/unknown results and a mismatched inventory hash, but cannot detect
routes omitted from discovery or invented assertion evidence. Review that evidence.
Do not claim all-workspace coverage for a change-scoped inventory or incomplete discovery.

Test design baseline: [OWASP API1:2023 BOLA](https://api-security.owasp.org/editions/2023/en/0xa1-broken-object-level-authorization/).
