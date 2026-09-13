# Tools and verification

## Choose tools from workspace evidence

Inspect installed tools, existing scripts, scanner configuration, and lockfiles first.
Check executable versions and local help before choosing flags. Do not introduce a
new package manager or regenerate a lockfile merely to make an audit command work.

| Evidence | Suitable checks | Interpretation |
| --- | --- | --- |
| Node manifests and lockfiles | Existing package manager's audit; lockfile-capable advisory scanner | Use resolved versions; include build/dev exposure as well as runtime dependencies |
| Python dependency files | Existing pip-audit or a compatible lockfile advisory scanner; applicable static analysis | Requirement ranges without resolution do not establish exact installed versions |
| Go, Rust, JVM, .NET, PHP, Ruby | Ecosystem/vendor-supported advisory tooling already available | Account for transitive packages, runtime versions, and supported file formats |
| Application source | Existing Semgrep, CodeQL, language analyzers, or framework checks | Match languages and rules; trace each important hit in the application |
| Credentials/configuration | Local secret scanner such as Gitleaks with full redaction | Check working tree and relevant ignored files; distinguish history coverage |
| Containers/infrastructure | Existing image/IaC scanner and configuration validation | A source Dockerfile is not proof of which image/configuration is deployed |
| Testable local app | Focused security regression tests; existing integration/browser tests | Verify both rejected misuse and preserved legitimate behavior |

Use a small complementary set appropriate to the stack, not every tool in the table.
If no scanner is installed, continue code/configuration review and name the missing
automated coverage. Installing a tool is an implementation choice within existing
authorization, but first assess its source, install hooks, network behavior, and
whether it changes the project or user environment. Prefer an isolated environment
when installation is necessary; do not run a downloaded installer blindly.

## Keep inspection from creating exposure

- Prefer local scanning. Do not upload source, raw findings, logs, environment files,
  or secrets to hosted scanners unless that disclosure is authorized. Inspect tool
  telemetry, registry selection, repository config, and upload settings before use.
- Dependency audits may send package names/versions or dependency metadata to a
  registry/advisory service. Use the project's configured trusted services within
  existing authorization. If private metadata would go to a new recipient, use an
  offline/local database or request that specific disclosure while continuing review.
- Some scanners invoke package managers, resolve dependencies, or run build hooks.
  Prefer existing lockfile/static modes that avoid executing project code. Check
  actual tool behavior; a command with "audit" in its name is not necessarily inert.
- Secret search results must be redacted before terminal output, artifacts, or chat.
  Do not dump `.env`, credential files, shell environment, or full secret-matching
  lines. If the tool cannot redact, process results locally and emit only locations,
  rule IDs, and masked context. Inspect scanner errors for accidental disclosures too.
- Do not validate discovered credentials by using them. Do not change global scanner
  settings, sign in to new services, or disable controls simply to get a clean result.
- Keep scratch artifacts outside public/served directories. Do not add raw scanner
  output to Git. Inspect proposed execution and imports before running repository
  tests; test hooks may deploy, migrate data, contact services, or load real secrets.

For npm, `npm audit --json` is a read-oriented starting point when the existing npm
project has a compatible lockfile and registry disclosure is appropriate. The command
sends dependency metadata to the registry. `npm audit fix` changes dependencies and
is not a review command; `--force` can introduce breaking changes. Adapt commands to
the installed version and workspace layout rather than copying this example blindly.

## Interpret results accurately

- Capture command, working directory, tool/ruleset version when available, scan date,
  input scope, excludes, exit status, and whether the scan finished.
- A nonzero exit may mean findings or a tool failure. Read the result, not just the
  exit code. Empty output, timed-out execution, unsupported files, and failed network
  access do not establish absence of vulnerabilities.
- Review scanner configs and baselines for suppressed/excluded findings. Do not remove
  exclusions blindly; explain material blind spots and investigate relevant paths.
- Confirm package ecosystem/name and resolved version against an authoritative
  advisory. Record advisory ID/link, affected/fixed versions, dependency path, and
  runtime/build/dev context. Do not label a package vulnerable merely for being old.
- Confirm vulnerable package presence separately from reachability and exploitability.
  Record unknowns; dev dependencies can affect builds and deployment credentials.
  Deduplicate multiple tool reports of the same advisory/root cause.
- Static patterns need context: parameterized SQL, framework escaping, verified
  middleware, and effective database policies can invalidate a scanner candidate.

## Local verification

Prefer existing tests and narrow additional checks over broad fuzzing or exploitation.
Use synthetic records for two users/tenants plus a privileged actor where relevant.
Do not reuse real customer data. Mock external services and assert calls, not live
side effects. Check that the test environment cannot reach production resources.

Useful verification pairs:

- The owner reads/updates a record; a different user or tenant is denied, with no
  private fields returned and no state changed.
- Normal input succeeds; an attempted injection remains data or is rejected without
  changing command/query structure.
- A valid provider event has its intended effect; an invalid signature is rejected;
  replaying a valid event does not duplicate a one-time effect.
- An allowed state transition succeeds; a skipped step, stale permission, changed
  amount, or repeated one-time action cannot bypass the invariant.
- A dependency/permission service fails; the application returns a controlled error
  and performs no unauthorized side effect.

For a fix, run the regression against the pre-fix behavior in an isolated copy when
practical, then against the fix. Do not overwrite user changes to establish a baseline.
Record exactly what ran, expected versus observed behavior, and what could not be
verified. Do not invent commands, outputs, exploits, or passing tests.

A browser/proxy scanner can supplement a scoped review when a safe running target is
available. Even a crawler or "passive" scan may issue requests that log out accounts
or trigger application actions. Check scope and side effects first; do not launch a
scan against a discovered production URL by default.

## Current documentation

- [npm audit](https://docs.npmjs.com/cli/commands/npm-audit)
- [Semgrep rule execution](https://docs.semgrep.dev/running-rules)
- [Gitleaks usage and redaction](https://github.com/gitleaks/gitleaks)

Use official documentation for other selected tools. Verify syntax, telemetry,
supported inputs, and advisory dates at use time rather than assuming they stay fixed.
