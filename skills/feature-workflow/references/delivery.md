# Delivery

Read before committing, pushing, or merging. Target the repository and branch in the task record. Do not assume that every repository uses `origin` or `main`.

## Prepare the candidate

1. Confirm the actual repository, remote destination, target branch, current branch, and task-owned files. Fetch the target branch. Inspect local commits ahead of the remote as well as staged and unstaged changes. Do not publish unrelated commits.
2. Integrate current target changes in an isolated branch or worktree when needed. Resolve conflicts without discarding either side's intended behavior. Retest and review the integrated result; prior evidence does not cover changed code.
3. Run the repository's required checks and build against the candidate. Record its tree or commit ID. Inspect the staged diff, then commit only task-owned changes. If hooks change files, inspect them and repeat affected checks before using the commit.
4. Check branch protection, required CI, and merge rules through available GitHub tools or documented repository policy. If the rules cannot be read, do not infer that direct updates are allowed. Prefer the repository's normal PR route.

## Main delivery

Use direct delivery only when authorized and allowed by repository policy. Verify the fetched target is an ancestor of the checked candidate, then push that explicit candidate to the explicit target ref using a normal, non-force push. Never force-push, delete main, bypass hooks, weaken protection, or use administrator overrides to complete this workflow.

For a PR route, push the feature branch and open or update the scoped PR. Wait for required checks and actual required reviews on the current PR revision. An agent review is not a substitute for a required repository approval. Use the permitted merge method when main delivery is authorized. If another approval is required, leave the reviewable PR and report exactly what is pending.

If the remote advances, fetch, integrate, and rerun affected validation before retrying. Bound publication retries to two reconciliation attempts unless the user supplies a different limit. An unresolved conflict or repeated rejection stops delivery with the candidate preserved.

## Verify the result

Read the remote branch after push or merge and confirm that it contains the intended change. For a merge or squash, record the resulting main commit instead of assuming the feature commit ID is unchanged. Check required CI for that resulting revision when applicable.

A successful push is not a successful build or deployment. Report pending or failed CI honestly. Do not claim a merge based on an open PR, or completion based on a queued auto-merge. If a failure appears after publication, preserve evidence and fix within the authorized scope; do not rewrite main or silently revert other work.

If a network error leaves the push result uncertain, inspect the remote before retrying. A later main commit does not mean the previous push failed; check ancestry or the merged PR record. Commit only once for the same candidate.

## Authorization and handoff

An explicit request to implement and push to main, or `delivery=main`, authorizes that final step for the named feature and repository. Reuse earlier authorization in the session. If this skill was selected implicitly and delivery was not requested, finish the local work before asking about publication. Honor local-only and branch-only requests.

If checks, access, or policy block delivery, report the prepared commit or PR, the exact blocker, and the next action. Pushing code does not additionally authorize deploying infrastructure, changing CRM records, contacting customers, or publishing other artifacts.
