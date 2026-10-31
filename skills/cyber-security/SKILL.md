---
name: cyber-security
description: Audit application code and workflows for security risks; verify authorization coverage and implement requested fixes.
---

# Cyber Security

Trace evidence in the actual stack; suspicious patterns alone are not vulnerabilities.

## Scope

- Review ("check", "scan", "audit"): inspect and run non-destructive checks; create isolated tests/reports without changing application code, dependencies, or configuration.
- Review and fix ("fix", "secure", "harden"): implement supported local fixes and regression checks.
- Change review: inspect the diff, callers, permissions, and deployment context; label its narrower scope.

Use the requested workspace. If no application exists, review applicable scripts/workflows and identify the missing app path; do not invent findings.

Keep testing within authorized targets. Found URLs or credentials do not authorize live probes. Inspect startup/test hooks and service configuration: localhost may reach production. Use synthetic accounts and isolated dependencies; avoid live payments, messages, migrations, deployments, brute force, or load tests.

## Map and trace

Read repository instructions and working-tree state. Inventory first-party source, relevant hidden/ignored configuration, manifests, lockfiles, runtime versions, tests, infrastructure, and CI without exposing secrets. Exclude dependencies and generated/cache output.

Map services, entry points, actors/roles, sensitive assets, trust boundaries, and important flows. Record commit/dirty state and coverage. Prioritize exposed paths, privileged actions, private data, and money; account for remaining scope and exclusions.

Read [code review](references/code-review.md). For state transitions, integrations, jobs, or CI/deployment, read [workflow review](references/workflow-review.md).

Trace input, transformations, enforcement, sensitive operations, and effects. Inspect shared middleware, route mounts, policies, serializers, and version-specific framework behavior before declaring controls missing.

For important flows, establish allowed actors, preconditions, transitions, and side effects. Consider cross-user/tenant access, altered inputs, replay, concurrency, skipped steps, and failures. Browser restrictions do not prove server enforcement.

## Verify

Read [tools and verification](references/tools-and-verification.md) before scanners or application execution. Choose stack-appropriate advisory, secret, static-analysis, and focused test checks. Trace business logic manually; scanner output alone is insufficient.

For application audits, read [IDOR/BOLA testing](references/idor-bola-testing.md), inventory every in-scope operation, and generate/run workspace-specific authorization tests. Test legitimate and denied/filtered access with synthetic fixtures and real enforcement. For change reviews, include affected operations and shared callers.

Reconcile inventory and executed results with [the coverage checker](scripts/check_authorization_coverage.py). Retain blocked/untestable operations with reasons. Skips, missing cases, failed setup, and unavailable runtimes are gaps, never passes. No application means not applicable, not a pretend suite.

Record tool version, scope, sanitized command, completion, and evidence. Investigate findings/failures; continue useful manual review if tools are unavailable. Verify current advisories and official version-specific guidance using public names and sanitized queries. Do not upload private code, secrets, or internal URLs; label offline freshness limits.

## Report and fix

Use [reporting](references/reporting.md). Default to `security-reports/cyber-security-YYYY-MM-DD.md`; preserve prior reports unless updating the identified one is requested. Keep artifacts outside served/build output and do not automatically publish or commit them.

Each finding needs location, behavior, prerequisites, impact, evidence, fix, and verification. Separate confirmed findings, candidates, and hardening; deduplicate root causes while naming affected paths. A confirmed affected dependency does not prove application exploitability.

Lead with consequential findings, link the report, and explain coverage and remaining access/runtime needs. A clean scan does not prove security or compliance.

When fixes are requested, change the enforcement boundary using established framework controls. Check dependency compatibility; avoid blind force updates. Verify prohibited behavior fails and legitimate behavior succeeds, then run relevant checks. Validate configuration changes and disclose remaining runtime checks.

For ongoing protection, extend existing CI within scope; review its permissions and untrusted inputs. Identify external account/hosting changes separately and honor existing authorization. Local fixes are not deployed fixes.

Use [ASVS](https://owasp.org/www-project-application-security-verification-standard/) for control requirements and [WSTG](https://owasp.org/www-project-web-security-testing-guide/) for test ideas. The [Top 10](https://owasp.org/Top10/) is not a complete checklist. Cite versioned requirement IDs; do not infer compliance.
