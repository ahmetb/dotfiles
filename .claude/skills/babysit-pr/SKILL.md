---
name: babysit-pr
description: Babysit a pull request until it merges — enable squash auto-merge, watch CI in a loop, rebase onto origin/master (or origin/main) on conflicts, and rerun flaky CI checks. Halt and report when a failure is plausibly caused by the PR's own changes. Use whenever the user asks to babysit a PR, watch its CI, merge it when green, unblock it after conflicts, or "get it merged" — even if they just paste a PR URL and say nothing else.
---

# Babysit PR

Take ownership of one pull request and drive it to a squash merge without
bothering the user, except when judgment is genuinely required.

## Setup

1. Resolve the PR: an argument like `owner/repo#123` or a plain URL. If the
   user gave neither, use the current branch (`gh pr view`) and confirm the PR
   you found is the one they mean.
2. Learn the shape before acting:
   ```bash
   gh pr view <PR> --json number,title,state,isDraft,reviewDecision,baseRefName,headRefName,mergeable,mergeStateStatus,statusCheckRollup
   ```
   Note the base branch (`master` vs `main`) — it decides the rebase target
   later.
3. Read the diff scope once (`gh pr diff <PR> --name-only`) and keep the file
   list in mind. You need it later to judge whether a CI failure could have
   been caused by the PR. Re-read it if the PR gains new commits.
4. If the PR is a draft or unapproved, say so and stop — auto-merge on an
   unapproved PR just waits forever, and the user should know a human is
   missing, not a check.

## Enable squash auto-merge

```bash
gh pr merge <PR> --squash --auto
```

If this fails because the PR is not approved or the merge queue is closed,
report the actual reason and stop. Never use `--admin` and never try to bypass
branch protection: the point of babysitting is that the guardrails stay on.

## The watch loop

Poll, do not busy-loop:

```bash
gh pr view <PR> --json mergeStateStatus,mergeable,statusCheckRollup,reviewDecision \
  --jq '{state: .mergeStateStatus, mergeable, review: .reviewDecision,
         failing: [.statusCheckRollup[] | select(.conclusion != "SUCCESS" and .conclusion != "SKIPPED" and .conclusion != null) | {name, status, conclusion}]}'
```

- Sleep 60–120 seconds between polls. Checks on a fresh push need time to even
  register; a poll that finds zero in-progress checks right after a push is
  usually too early, not a pass.
- A `conclusion: null` with `status: IN_PROGRESS` or `QUEUED` is a pending
  check, not a failure. Only completed non-success conclusions count as
  failures.
- The loop ends in exactly one of three ways: **merged** (report the merge
  commit and stop), **halted** (see below), or **user interrupted**.

## Failure classification — the core judgment

For each failing check, classify it before acting. The rule that keeps this
safe: **a rerun must never be a way to avoid reading the failure.**

### Rerun (flaky / infrastructural)

Rerun the failed jobs only when the failure cannot plausibly be caused by the
PR's changes. Signals that justify a rerun:

- The failing code area is untouched by the diff (an unrelated test suite, a
  different service, an infra workflow).
- Transient symptoms in the log: network timeouts, DNS errors, HTTP 429/5xx,
  "lost connection", runner died / OOM / disk full, image pull backoff,
  rate limiting, flaky external dependency.
- The same check passed for the same code earlier in the PR's life, and no new
  commits landed since it last passed.
- Known-flaky checks the user has flagged to you in conversation.

Rerun only the failed jobs, not whole workflows, unless the workflow cannot do
partial reruns:

```bash
gh run rerun <run-id> --failed
```

Keep a rerun count per check. If a check fails again after a rerun — and
certainly after two reruns — stop treating it as flaky and halt.

### Halt (plausibly caused by the PR)

Stop and report, without rerunning, when the failure could be real:

- The failure is in code, tests, lint, types, or build paths the diff touches.
- The failure is about the PR's own metadata: PR title/description validation,
  commit message checks, DCO, size limits. These never heal by rerunning.
- The log shows an assertion failure, compile error, or new failure mode that
  the diff could plausibly explain.
- You cannot read the logs (`gh run view <run-id> --log-failed`) and the
  check name alone is not enough to judge. Unknown means halt, not rerun.

When halting, give the user: the failing check name, a one-line excerpt of the
real error from the logs, your judgment on whether it looks PR-caused or
flaky, and what you would do next. They decide; do not keep the loop running
while waiting.

## Merge conflicts

If `mergeStateStatus` is `DIRTY` (or rebase attempts fail), the PR has
conflicts with the base:

1. Work in a checkout of the PR's head branch. If the PR is from the same
   repository, fetch it; if it is from a fork, note that rebasing someone
   else's branch needs push access — if you cannot push to it, halt and ask.
2. Rebase onto the base branch — `origin/master` for repos whose trunk is
   master, `origin/main` for main. Fetch first; do not rebase onto a stale
   ref.
3. Resolve conflicts conservatively: preserve the base branch's newer intent
   and the PR's own changes, never silently drop either side. If a conflict
   needs semantic judgment (two features genuinely overlap, a rename the PR
   half-followed, generated files that must be re-rendered), halt and ask
   instead of guessing.
4. Run whatever cheap validation exists for the affected files (build, render,
   the repo's quick check) before pushing — a rebase that fixes conflicts but
   breaks the build just trades a merge conflict for a CI failure.
5. Push with `git push --force-with-lease`, never bare `--force`. Auto-merge
   survives the push; if it was somehow removed, re-enable it.

## Halt conditions — full list

Stop and write a short status report when any of these happens:

- A failure you classified as PR-caused (do not rerun it away).
- The same check failed twice after reruns.
- A conflict you cannot resolve without semantic judgment.
- The PR lost its approval or a review change was requested.
- The head branch moved in a way you did not cause (someone else is pushing to
  it — coordinate with the user before force-pushing over their work).
- Any state you cannot explain.

A halt is a service, not a failure. One tight report — what happened, what you
verified, what needs a human — is better than a long unattended retry loop
that papers over a real problem.

## Reporting

On merge or halt, report tersely: PR number and title, final state, actions
you took (rebases, reruns, with check names and counts), and anything left for
the user. Never claim a merge happened without seeing it in `gh pr view`.
