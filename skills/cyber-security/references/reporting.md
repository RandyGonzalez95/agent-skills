# Evidence and reporting

Write for a site owner who may not know security terminology. Explain the concrete
consequence before the technical label. Findings must be useful to a developer too:
include the enforcement point, reproduction/trace, and exact remediation target.

## Evidence states

- **Confirmed:** a complete source/configuration trace, focused local reproduction,
  or exact-version authoritative advisory establishes the stated issue. Identify
  which kind of evidence supports it. Static confirmation is not runtime testing.
- **Needs validation:** a plausible candidate depends on an unobserved deployment
  setting, missing module, ambiguous business rule, version, or unavailable runtime.
  State the missing evidence and a specific way to obtain it.
- **Hardening:** a useful additional defense or operational improvement without an
  established exploitable weakness. Do not inflate it into a confirmed vulnerability.

Track remediation separately: **open**, **changed, verification pending**, or
**verified locally**. Use **verified deployed** only when actual deployment evidence
and authorized verification support that claim.

For an advisory, "confirmed affected dependency" does not mean "confirmed remotely
exploitable application". For a secret, a realistic credential in source does not
prove it remains active. Preserve these distinctions in the finding wording.

## Severity

Judge impact and plausible prerequisites in this application, separately from
confidence. Use critical/high/medium/low only with a short rationale. Do not invent
CVSS scores or copy a scanner rating without checking context.

- **Critical:** broad application/system takeover or similarly catastrophic impact
  with realistic low-barrier exploitation.
- **High:** substantial unauthorized data access/modification, account/tenant
  compromise, privileged execution, or financial abuse with plausible prerequisites.
- **Medium:** meaningful but constrained exposure/abuse, or exploitation requiring
  significant conditions or interaction.
- **Low:** limited impact or narrow conditions. Optional hardening remains separately
  labeled even when it deserves operational attention.

State conditional severity for unresolved candidates. Rank work by consequence,
exposure, confidence, and urgency; effort can inform sequencing but not reduce severity.

## Report structure

Scale detail to the workspace while retaining these elements:

1. **Summary:** most important outcomes, whether app code exists, and immediate actions.
2. **Scope:** date, root, commit/dirty state, requested mode, services/flows reviewed,
   assumptions, and excluded or inaccessible areas.
3. **Coverage:** component/control, files or flows inspected, method, result, gaps.
   Use "reviewed", "tested", "not reviewed", or "not applicable" precisely.
4. **Prioritized findings:** confirmed findings first; separate validation candidates
   and hardening items. Use stable IDs such as `CS-001` for follow-up work.
5. **Verification log:** tools/versions, sanitized commands, completion status, test
   outcomes, advisory freshness, and important manual trace evidence.
6. **Remediation plan:** concrete immediate, next, and recurring actions tied to finding
   IDs; identify code changes versus hosting/account changes.
7. **Limits and follow-up:** unresolved questions and exactly what evidence or access
   would resolve them. Do not imply scans cover business logic automatically.

For each finding include:

```text
CS-001 - Concrete problem and affected behavior
Severity / rationale:
Evidence state / confidence:
Location: relative/path.ext:line (include shared enforcement and affected callers)
Affected flow and realistic attacker prerequisites:
Impact in plain language:
Evidence: source trace or sanitized local reproduction, with observed result
Recommended fix: specific boundary, configuration, or dependency change
Verification: denied case plus preserved legitimate behavior where applicable
Remediation status and remaining uncertainty:
Source/advisory: authoritative URL when relevant
```

Do not include real credentials, personal records, private response bodies, or an
unnecessary ready-to-run attack against a live service. Use synthetic IDs and masked
values. File/line evidence is preferred over copying large code blocks. Keep shared
root causes together and enumerate affected paths without duplicate findings.

If there are no confirmed findings, say so for the reviewed scope, then report actual
coverage and limitations. If a scanner did not run or only part of a monorepo was
reviewed, make that visible in the summary. Do not produce a numeric "security score"
or claim compliance without a defined, completed assessment supporting it.
