---
name: cyber-security
description: Review a local application workspace for security vulnerabilities in code, dependencies, configuration, user flows, and build/deployment workflows. Use for a security audit, vulnerability check, application hardening, or security-focused change review; provide evidence, prioritized fixes, and verification. Supports implementing fixes when requested.
---

# Cyber Security

Help the user understand what could go wrong in their application, verify which risks
are supported by evidence, and make protection concrete. Adapt to the actual stack;
do not assume a JavaScript app or mistake every suspicious pattern for a vulnerability.

## Scope and working mode

- **Review** is the default for "check", "scan", or "audit": inspect the workspace,
  run appropriate non-destructive checks, and write a report. Do not change application
  code, dependencies, or deployment configuration just to perform a review.
- **Review and fix** applies when the user asks to fix, secure, or harden the app:
  implement supported local fixes and relevant regression checks, then update the
  report with what was verified and what remains. Existing authorization persists.
- **Change review** applies when the user scopes the task to a diff or PR: inspect
  the changed behavior plus its callers, permissions, and deployment context. State
  that this is not a full application review.

Use the current workspace unless the user supplies another location. Start with
available evidence; ask only for missing information that changes a consequential
decision. If this is a documentation/skills repository with no application, say so,
review any applicable scripts/workflows, and request the application path for the
application-specific work. Do not invent login, database, or deployment findings.

Keep testing within the authorized target. A URL, credential, or cloud project found
in code is not permission to probe that service. Prefer isolated local tests with fake
accounts and stubbed email, payments, and network services. Check test/startup scripts
and configuration before executing them: localhost can still use a production database.
Do not trigger live payments, messages, deployment, migrations, brute-force attempts,
or load tests as a side effect of a workspace review.

## 1. Map the workspace and its trust boundaries

Read applicable `AGENTS.md` instructions and check the working tree before making
changes. Use `rg --files --hidden` with explicit exclusions for `.git`, installed
dependencies, virtual environments, caches, and generated output. Do not exclude
first-party source or infrastructure merely because it is hidden or gitignored;
enumerate relevant ignored configuration separately without dumping secret values.

Identify:

- Applications/services in a monorepo; languages, frameworks, manifests, lockfiles,
  runtime versions, existing security tools, tests, and package scripts.
- Entry points: pages, APIs, server actions, background jobs, GraphQL/WebSockets,
  uploads, webhook handlers, admin routes, and scheduled tasks actually present.
- Assets and actors: private data, credentials, money, user roles, organizations or
  tenants, anonymous visitors, and privileged service identities.
- Enforcement boundaries: browser to server, server to database/storage, external
  event to handler, tenant to tenant, and pull request to privileged build/deploy job.
- Configuration: migrations, database/storage policies, containers, infrastructure
  code, CI/CD, hosting configuration, and configuration examples.

Record the commit if available and whether uncommitted changes were included. Create
a compact coverage map of components and important flows. Prioritize exposed paths,
privileged operations, private data, and financial actions; continue through the
remaining applicable surfaces. Explicitly name any unreviewed areas in a large repo.

## 2. Inspect code and application workflows

Read [references/code-review.md](references/code-review.md) for application controls.
Read [references/workflow-review.md](references/workflow-review.md) when the app has
user state transitions, integrations, background jobs, or build/deployment workflows.

For each candidate, trace **input -> transformations -> enforcement -> sensitive
operation -> observable effect**. Inspect shared middleware, route mounting, database
policies, serializers, and provider behavior before concluding a control is missing.
Use framework documentation for the actual version where defaults matter.

For important user flows, establish the allowed actor, preconditions, state change,
and side effect. Consider another user/tenant, missing or altered inputs, replay,
concurrency, skipped steps, and dependency failure. Browser-only restrictions do not
establish server-side protection. Include both an allowed case and a denied/abuse case
when testing a security boundary.

## 3. Add tools and focused verification

Read [references/tools-and-verification.md](references/tools-and-verification.md)
before invoking scanners or running the application. Select checks for the detected
stack: dependency advisories, secret detection, static analysis, relevant existing
tests, and targeted local regression checks. A tool is supporting evidence, not the
entire review. Business logic and ownership checks require tracing the application.

For each tool record its version, scope, command with secrets removed, completion
status, and relevant output. Investigate findings and failed runs. Missing tools,
unsupported languages, absent lockfiles, network failures, and excluded files are
coverage gaps, never clean results. Continue useful manual review when a tool is absent.

Check current official advisories and vendor/framework documentation for claims about
affected versions or recommended security settings. Use public package names and
sanitized descriptions in lookups; do not submit private code, secrets, or internal
URLs to search or external scanning services. If offline, label advisory freshness
and version-specific conclusions as unverified.

## 4. Triage and deliver an actionable report

Use [references/reporting.md](references/reporting.md) for evidence, severity, and
the report structure. Write to the user's requested path or, by default,
`security-reports/cyber-security-YYYY-MM-DD.md`. Preserve previous reports with a
suffix or update the identified report when the user requests a follow-up. Keep
reports and scanner artifacts out of served/public/build output; do not commit,
publish, or upload them automatically.

Each finding needs a concrete location, affected behavior, realistic prerequisites,
impact, evidence, a specific fix, and a verification method. Separate confirmed
findings, candidates needing validation, and optional hardening. Deduplicate shared
root causes while listing affected paths. An advisory affecting an exact dependency
version can be confirmed even when application exploitability is still unknown;
state that distinction.

Lead the user-facing response with the most consequential findings in plain language,
then link the report and give the next practical steps. Explain what was checked and
what needs a deployed environment or account access. Never call the app "secure",
"certified", or "free of vulnerabilities" from a clean scan. Say "No confirmed
findings in the reviewed scope" when that is the supported result.

## 5. Fix and prevent recurrence when requested

Make the smallest coherent fix at the enforcement boundary; preserve legitimate
behavior and existing user work. Reuse established framework controls instead of
inventing authentication or cryptography. Review dependency updates for compatibility
and affected transitive packages; do not blindly run force-update commands.

For each security fix, verify the prohibited behavior fails and the allowed behavior
still succeeds. Prefer a focused regression test for authorization, validation,
signature checking, replay, or other meaningful behavior. Run the relevant existing
checks. For configuration-only changes, validate the configuration with an appropriate
parser/tool and describe runtime checks still required. A code change is not a
verified deployed fix.

When ongoing protection is requested, extend the existing CI with appropriate
dependency, secret, and code checks rather than creating duplicate pipelines. Review
permissions and untrusted-input handling in the new workflow too. Identify any
hosting/account controls that need external configuration, such as MFA, alerts,
rate limits, backups, or credential rotation. Prepare concrete changes and use the
session's existing authorization; request only any additional external action that
actually needs it. Do not represent local changes as live infrastructure changes.

## Baselines

Use [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
for control requirements and the
[Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
for test ideas. The [OWASP Top 10](https://owasp.org/Top10/) is an awareness baseline,
not a complete checklist. Link versioned requirements when citing specific IDs;
do not claim ASVS compliance from this review.
