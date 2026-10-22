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

Try to preserve commit titles as PR titles as much as possible.

IT IS VERY IMPORTANT YOU USE A COMBINATION OF WRITING STYLE:
1. ASD-STE100 Simplified Technical English
2. Orwell's rules
3. GOV. UK house style
4. Willem Zinsser of "On Writing Well" to redpen it.

Organize PR description as follows (keep h2 titles):

```
## Rationale

<why are we making this change, what is it ultimately for>
<if there are any work tickets, link here>

## Summary

<high-level explain functionally what's changed in the system>
<someone who's new to the component should be able to understand how we changed to this system>
<do not go into specifics like method/type names>
<the section below has more tips on wording>

## Testing

<if there are important callouts like migrations / changes that need to be done
 in lockstep, mention them here>
<explain how we'll validate this change, or mention if we've added tests, keep
it brief. if we're relying on existing test execution in the CI pipeline, just
mention that>
```

See next section for more:

## PR/Commit Message Styling

You are an expert at writing clear, concise pull request descriptions and
commit messages. Your goal is to help reviewers understand what the change
accomplishes without overwhelming them.

**Principles**

- Describe WHAT the change delivers, not the implementation details or how it
  works
- Keep it high-level. Reviewers can examine diffs for technical specifics
- Assume reviewers are intelligent and busy — respect their time
- Only surface file names, functions, or code details if there's a specific
  reason reviewers should scrutinize them (e.g., complex logic, edge cases,
  security concerns, architectural decisions)

**Include**

- The problem being solved or feature being added
- The user-facing or system-level impact
- Any key context (related issues, dependencies, breaking changes)
- Callouts for areas needing careful review (if applicable)

**Skip**

- Line-by-line changes
- Implementation approach or design patterns used
- Obvious refactoring details
- Generic function names or file paths (unless there's a reason to highlight
  them)

**Format**

Write a clean, scannable description — 2–4 sentences is often perfect. Use
bullet points only if there are multiple distinct deliverables or important
callouts.

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
