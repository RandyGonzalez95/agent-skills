# Application and delivery workflows

"Workflow" includes how people and services use the application, as well as how code
is built and deployed. Review both when present. Scanners rarely establish the
business rules required for this analysis.

## Map an application flow

For each consequential flow, record:

| Element | What to establish |
| --- | --- |
| Actor | Anonymous user, authenticated user, tenant member, admin, or external service |
| Starting state | Required ownership, permissions, verification, balance, or prior step |
| Input | Which identifiers, amounts, statuses, and destinations the actor controls |
| Enforcement | Where the server validates the actor, inputs, and current state |
| Transition | What persistent state changes and whether the operation is atomic |
| Side effect | Payment, email, export, account privilege, resource creation, or external request |
| Repetition/failure | Replay, concurrency, partial failure, retry, or rollback behavior |

Trace the entry point through the service and data layers. Read product requirements,
tests, schemas, and call sites to infer rules; distinguish inferred rules from explicit
ones. If a rule is genuinely ambiguous, report the conditional risk and ask a focused
question instead of labeling intended behavior a confirmed vulnerability.

## Abuse cases to select from

- **Accounts and invitations:** reuse an invite, accept it as the wrong identity or
  tenant, change role during acceptance, skip email verification, reuse recovery
  tokens, or retain access after account/member removal.
- **Ownership and roles:** request another user's/tenant's record; alter owner, role,
  or tenant fields; try bulk/export/background paths; use stale role claims after
  privilege removal. Test an allowed member as well as a prohibited actor.
- **Checkout, billing, and credits:** manipulate submitted prices/currency/quantity,
  discount eligibility, account IDs, plan entitlements, refunds, or balances. Verify
  authoritative server calculations and payment-provider status. Do not fulfill an
  order solely because the browser reached a success URL.
- **Webhooks and external events:** inspect signature verification against the exact
  provider payload requirements, secret handling, event/account binding, timestamp
  checks where specified, duplicate delivery, and out-of-order events. Signature
  validity alone does not provide idempotency or correct order ownership.
- **One-time actions:** coupon use, credit redemption, password reset, invite acceptance,
  and stock reservation need enforcement that remains correct under concurrent
  requests. Inspect transaction boundaries, unique constraints, and atomic updates;
  do not infer a race merely because the handler has more than one database call.
- **Jobs and retries:** verify queue producer access, payload validation, tenant context,
  permissions at execution where needed, bounded retries, deduplication, and failure
  recovery. Inspect whether retries duplicate charges, emails, or privileged effects.
- **Uploads, exports, and imports:** check access both when creating the job and when
  obtaining its result, link lifetime, tenant binding, quotas, and spreadsheet formula
  injection when untrusted content is exported into spreadsheet-compatible formats.
- **Abuse and costs:** identify public or cheap-to-create accounts that can consume
  unbounded storage, paid APIs, AI tokens, emails/SMS, searches, or background work.
  Review per-user/tenant limits and infrastructure controls; unknown provider limits
  are a deployment verification item. Do not run load tests to establish this.
- **Failure paths:** inspect what happens when permission lookup, payment confirmation,
  or signature validation raises an error or times out. Sensitive operations must not
  continue as successful merely because verification failed.

## Build, release, and deployment workflows

Inspect `.github/workflows`, other CI definitions, deployment scripts, containers,
infrastructure configuration, dependency updater configuration, and package hooks
actually used by this workspace.

- Identify triggers and the trust level of checkout refs, event fields, artifacts,
  caches, generated files, and script arguments. Follow untrusted data into shell
  interpolation or execution.
- Review privileged pull-request/event workflows and downstream workflow triggers.
  Determine whether they execute untrusted contributor code while holding secrets,
  write tokens, signing privileges, or access to trusted runners.
- Trace effective token permissions, credential persistence, third-party actions,
  dependency sources, action/image pinning, and changes to reusable workflows.
- Review deployment branch/environment protections where observable, and OIDC trust
  constraints for repository, ref, audience, and environment. Local YAML alone may
  not establish the provider-side trust policy or approval settings.
- Check whether build inputs or PR-produced artifacts can replace trusted release
  output. Inspect shared caches and artifact provenance when they cross trust levels.
- Look for secrets in command arguments, logs, artifacts, image layers, and frontend
  build variables. Redaction settings do not guarantee transformed secrets are hidden.
- Inspect dependency install/build hooks and unpinned download-and-execute commands.
  Determine actual execution context before assigning severity.
- Check whether security jobs cover the deployed packages, relevant branches, and
  configuration; inspect suppressions, baselines, scan exclusions, and ignored exits.
  An absent scanner is a hardening opportunity, not proof of an exploitable flaw.

Do not execute a suspicious CI file to investigate it. Trace the trigger, attacker
control, privileges, and command path statically; use isolated benign substitutes if
a local demonstration materially improves confidence.

## Sources

- [OWASP business logic security](https://cheatsheetseries.owasp.org/cheatsheets/Business_Logic_Security_Cheat_Sheet.html)
- [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use)

For other CI/payment/authentication providers, check their official documentation
for the version and integration in use before recommending a provider-specific fix.
