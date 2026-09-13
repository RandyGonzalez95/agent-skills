# Application code and configuration review

Use only the sections relevant to the discovered application. Search results are
entry points: trace surrounding code and effective controls before reporting a flaw.
Record absent features as not applicable, not missing protections.

## Access control and data isolation

- Map permissions at every sensitive server route, action, job, and storage access.
  Verify identity comes from a validated session/token, not a submitted user ID.
- Trace object ownership and tenant boundaries through list/search/export endpoints,
  nested resources, file downloads, bulk operations, and indirect references.
- Check database row-level security and storage policies where used, including policy
  migrations, default privileges, and paths using elevated/service credentials.
  Determine whether these credentials bypass otherwise sound policies.
- Look for unauthorized fields in update/create payloads: role, tenant, owner, price,
  approval status, or internal flags. Check explicit writable-field allowlists.
- Follow middleware mounting and bypass paths, not just its existence. UI visibility,
  opaque IDs, CORS, and a successful login are not object-level authorization.
- Verify denied access and internal failures do not fall back to privileged access.

## Authentication, recovery, and sessions

- Inspect registration, invitation acceptance, login, password reset, email changes,
  MFA changes, logout, token refresh, and account disabling as connected flows.
- Check single-use expiring recovery tokens, account binding, session rotation,
  invalidation/revocation, and reauthentication for sensitive account changes.
- If passwords are stored locally, verify established password hashing with suitable
  current parameters; plain hashes, reversible encryption, and plaintext are not
  password-storage substitutes. Prefer the stack's maintained authentication system.
- Trace token signature validation, allowed algorithms, issuer/audience/expiry checks,
  and OAuth/OIDC state, nonce, redirect, and PKCE handling where applicable.
- Review cookie Secure, HttpOnly, SameSite, scope, and lifetime in deployment context.
  Do not prescribe cookie flags for a design that does not use session cookies.
- Review login/reset rate limits, enumeration behavior, and whether MFA is enforced
  on privileged access, including alternate login or recovery paths.

## Input, output, injection, and browser controls

- Trace user-controlled values reaching SQL/NoSQL queries, shell commands, templates,
  eval, deserialization, LDAP/XML parsers, or interpreter-like APIs. Check parameter
  binding and structural validation; an ORM can still expose unsafe raw-query paths.
- Trace stored, reflected, and DOM-based XSS through HTML insertion, markdown/rich
  text, URL attributes, uploaded HTML/SVG, and template escape bypasses. Check the
  actual rendering context and sanitizer configuration. Default text escaping is
  evidence against a finding; input validation alone is not an XSS defense.
- For cookie/ambient-credential authentication, review CSRF protection on state
  changes, accepted content types, origin checks, and framework middleware. A bearer
  token explicitly attached by code has a different CSRF model. Do not label every
  endpoint without a CSRF token vulnerable.
- Review CORS against intended credentialed origins; distinguish public read APIs
  from private data. Assess CSP and anti-framing controls in context. Missing a
  defense-in-depth header alone does not prove an exploitable high-severity issue.
- Check URL redirects against intended destinations and whether they expose tokens
  or enable account-flow abuse.

## Files, URLs, and external input

- Uploads: validate actual type and size, constrain names/paths, generate safe storage
  names, prevent code execution, isolate untrusted active content, and enforce read
  permissions. Check archive traversal, decompression limits, and image/PDF processors.
- File operations: resolve/normalize paths against the allowed root and consider
  symlinks. A substring check or naive string-prefix check is not path containment.
- Server URL fetching: trace SSRF through previews, imports, image proxies, callbacks,
  and webhooks. Review scheme/host restrictions, DNS resolution, redirects, internal
  and metadata addresses, and network egress controls. Do not contact metadata or
  private services to prove a finding; mock or inspect the boundary locally.
- Parser and resource limits: request body size, pagination, regex complexity,
  GraphQL depth/cost, decompression, timeouts, and expensive unauthenticated operations.

## Secrets, privacy, and cryptography

- Review tracked and relevant ignored configuration, client bundles, build-time
  environment exposure, logs, error handlers, sample files, and container build inputs.
  Start secret searches with filenames/redacted scanner output, not raw value dumps.
- Distinguish deliberately public client identifiers from privileged credentials.
  A browser-visible key is not automatically a secret; inspect its privilege and the
  backend policies. Do not use discovered credentials to test their validity.
- If a likely real secret is found, record the location and credential type with the
  value redacted. Advise revocation/rotation and exposure review. Removing the value
  from the current file does not revoke it or erase repository history.
- Check excessive data in API responses, debug traces, analytics, cached pages,
  shared/CDN caches, log events, and exports. Include cross-user cache keys and
  framework data-fetching defaults when relevant.
- Review HTTPS enforcement, encryption configuration, secure random token creation,
  key handling, and retention/deletion behavior where code or config establishes them.
  State when actual TLS, key storage, or data encryption needs runtime confirmation.

## Deployment and operational configuration

- Inspect production debug modes, default accounts, public storage, database exposure,
  proxy trust, admin interfaces, error pages, and unnecessary services.
- Review database/queue/service permissions and container or infrastructure settings
  against what the application actually needs. Distinguish local development examples
  from deployment configuration and identify where each is selected.
- Look for safe failure handling, bounded retries, transaction rollback, cleanup,
  and permission checks that remain enforced when dependencies fail.
- Review security event logging and alert paths for privileged changes, failed access,
  webhook rejection, and abuse. Logs must not contain credentials or unnecessary
  personal data. Missing provider-side alerts or backups are unverified when they
  cannot be observed in the workspace; request evidence, not an invented finding.

## Conditional AI features

If the application uses an LLM with tools or retrieval, trace untrusted text into
prompts and tool execution. Review server-enforced tool permissions, per-user/tenant
retrieval filters, output handling, and spending limits. Prompt wording cannot enforce
authorization. Only include this surface when AI features actually exist.

## Authoritative follow-ups

- [Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [SQL injection prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [XSS prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [CSRF prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [File uploads](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [SSRF prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
- [Secrets management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
