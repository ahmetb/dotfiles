---
name: commit-pr
description: How to name branches, writing commit titles/messages and sending PRs with correct format
---

## Branch names

- All git branches should start with `$USER/` (see `whoami` if $USER env var not set)

## Commit messages/titles

- Keep commit titles short if possible (like Linux kernel patches)

- Use conventionalcommits style when possible and pragmatic in commit titles
  (you can sometimes omit the component name)

- Do not be super specific in commit messages, don't mention stuff like method
  names, variable names etc. Focus on why we did this commit and what problem
  we are solving.

- If the repository remote has `linkedin` in it, and there's no JIRA ticket
  available in the context, use AskUserQuestion tool if there's a JIRA ticket
  we can attach to the end of the commit message, on a separate like, using syntax:

      BUG=FOO-1234[,BAR-1234,...]

## PR title/description

Try to preserve commit titles as PR titles as much as possible

Organize PR description as follows (keep h2 titles):

```
## Summary

<explain the changes, mostly the git commit message>

BUG=[...] (if available, otherwise omit)

## Testing Done

<explain how we'll validate this change, or mention if we've added tests,
keep it brief. if we're relying on existing test execution in the CI pipeline,
just mention that>
```

## PR stacks

If the PRs are stacked, make sure each PR has a section like this that marks
the current PR.

```
## PR Stack

1. <link to PR>
2. this PR
```

and if a PR is not ready to review, make sure a PR stays in Draft, and it has
a description that begins like the following until the PR is ready:

```
> [!WARNING]
> This PR is part of a stack, please review [previous PRs](link to previous pr) first.
```
