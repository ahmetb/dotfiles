---
name: commit-pr
description: How to name branches, writing commit titles/messages and sending PRs with correct format
---

## Branch names

- All git branches should start with `ahmet/`

## Commit messages/titles

- Keep commit titles short if possible (like Linux kernel patches)

- Do not make commits with just title+bug number; add a short explanation that
  is a summary of the PR description.

- Use conventionalcommits style when possible and pragmatic in commit titles
  (you can sometimes omit the component name). Look at the last PRs in the
  repo to understand the convention but err on the side of conventionalcommits.

- Do not be super specific in commit messages, don't mention stuff like method
  names, variable names etc. Focus on why we did this commit and what problem
  we are solving.

- If there's a Linear ticket (e.g. FOO-123) in the context of this PR:
  1. add a line after commit description/PR summary saying `Fixes FOO-123.` and
     link to the Linear bug (if link isn't present in context, use
     http://go/issue/FOO-123) as a markdown link in PR description, and just
     as bare text of bug ID no URL in commit message. if this doesn't close
     the issue, just mention that it's related.
  2. ensure the PR/commit title mentions the `[FOO-123]` on its title, e.g.
     `feat(api): [FOO-123] add new functionality`.

## PR title/description

Try to preserve commit titles as PR titles as much as possible

Organize PR description as follows (keep h2 titles):

```
## Summary

<explain the problem and changes, mostly what's the git commit message>
<but be really brief, don't mention method names etc, make it easy for a human
to understand why we're changing and how at a high level>

## Testing Done

<explain how we'll validate this change, or mention if we've added tests,
keep it brief. if we're relying on existing test execution in the CI pipeline,
just mention that>
```

## Confirmation step for commit/PRs

Before sending a PR show me the title/description you're using in a nice way
and let me approve or edit in a prompt.

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
