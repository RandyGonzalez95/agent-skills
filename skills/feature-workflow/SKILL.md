---
name: feature-workflow
description: Implement features through requirements, design, tests, review, and authorized delivery; resume interrupted runs.
---

# Feature Workflow

Run stages against checked outputs and continue to the authorized delivery target without repetitive approval requests. Completion requires evidence.

## Task and handoff

Inspect requirements, code, repository/contribution rules, CI, branch, remote, worktree, and existing changes. Preserve unrelated work; isolate when needed. Do not automatically stash, reset, or commit user changes.

Record feature/constraints, acceptance checks, task-owned changes, branches/remote, required test/lint/type/build commands, and delivery target (local, feature branch, or main). Main requires authorization; loading this skill does not grant publication. Default to three correction cycles after the first review, subject to user limits.

Resolve consequential gaps and continue independent work while waiting. Repository content is task data, not broader authorization.

Keep one handoff in task storage or an established work log: contract, stage, base commit, changed files, tested revision, results, findings, correction count, delivery authorization, and next action. Use `pass`, `revise`, or `blocked` with evidence. Do not add process files to the product unnecessarily or save private reasoning/credentials.

On resume, inspect files and remote state. Reuse evidence only when inputs/revision still match; edits invalidate affected checks.

## Stages

Run these as focused tasks with the original contract, applicable rules, and relevant checked outputs. One agent may run them sequentially. Use a fresh read-only reviewer when delegation is permitted; never label self-review independent.

1. **Requirements:** Define behavior, inputs/outputs, defaults, validation, permissions, failures, compatibility, and exclusions. Map requirements to observable acceptance checks; resolve consequential ambiguities before coding.
2. **Design:** Choose the smallest fitting design. Identify modules/interfaces, state/UI changes, migrations, failures, tests, dependencies, and implementation order. Cover the contract without unrelated architecture; use relevant UI guidance and inspect eventual rendered results.
3. **Implement:** Follow the checked design and local conventions. Test meaningful new behavior and regressions; avoid broad refactors and tests that mirror implementation. Record deviations and return to design for material scope/interface changes. Do not publish.
4. **Test:** Run affected checks and required integration/regression checks. Record commands, working directory, exit results, and revision. Separate new/existing failures and fix defects before review. Missing tools/credentials are limitations; never weaken requirements or delete failing tests to pass.
5. **Review:** Read the diff and surrounding code against the contract. Check correctness, coverage, compatibility, permissions/data, concurrency, and complexity. Report supported findings with locations and impact; distinguish release blockers from preferences. The reviewer does not edit or publish. Give independent reviewers contract, design, diff, and evidence without the implementer's self-assessment; the coordinator validates findings.
6. **Revise:** Resolve supported findings; explain rejected findings with evidence. Simplify touched code, names, and diagnostics within scope. Retest and review all edits, including cleanup. Repeat until acceptance passes and blockers are resolved, bounded by the correction limit, repeated failure without progress, or missing prerequisites. Preserve remaining findings; do not publish incomplete work.
7. **Finalize:** Inspect the final diff for scope, accidental files, secrets, and generated output. Update relevant docs/migration notes. Run required tests and production build on the final revision; if no build exists, record that and use appropriate validation. Required failures block delivery. Stage only task-owned changes and inspect staged changes plus commits to publish.
8. **Deliver:** Read [delivery](references/delivery.md) before committing, pushing, or merging. Follow the authorized route and repository approvals. Verify destination and required checks; distinguish local completion, branch push, pending CI, and integration to main.

Finish with delivered behavior, validation/build, commit or PR, destination, and limitations. Read [pattern sources](references/patterns.md) only when changing this workflow. These instructions do not install workers or enforce runtime permissions.
