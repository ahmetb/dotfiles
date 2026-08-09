---
name: sweep-comments
description: |
  Hold code comments and docstrings to a strict quality bar. Use whenever writing or editing comments — adding a comment to new code, being asked to "document this", "add comments", or "make this reviewer-ready" — and as a dedicated staleness sweep before opening or updating a pull request. Symptoms that this skill applies: comments that restate the adjacent code, docstring boilerplate on small internal helpers, derivation walkthroughs, war-story narration, or comments describing behavior a design pivot has since deleted.
---

# Sweep comments

Every comment must state a constraint the code itself cannot show, in
one short sentence. If deleting the comment loses nothing a maintainer
needs, delete it. Thoroughness is accuracy, not volume: an accurate,
lean file is stronger in review than one padded with restatements.

## The reader

Write for the reader you actually have: a professional who is
competent at reading code and willing to learn the context on their
own. They can read a call signature, follow a loop, and look up a
library. Comments exist to hand them the facts they cannot get that
way — not to tutor them through the language, the stdlib, or the
control flow. Assuming an incompetent reader is what produces
restatement comments; assuming this reader is what keeps them out.

## The bar

A comment earns its place only if it says something you cannot get by
reading the statement below it. Hold every comment — new or existing —
to this test.

Keep (these say what the code cannot):

- Behavioral constraints of external tools and systems, e.g. a flag
  chosen because of a filesystem cache pathology, a layout-engine
  quirk, a protocol quirk.
- The why behind magic values: weights, thresholds, limits, ports.
- Schema documentation on data tables and wire formats.
- Source-of-truth pointers ("the registry in X is authoritative").
- A deliberate absence ("no retry here on purpose; rsync --partial
  handles resumption").

Delete (these repeat what the code already shows):

- Restatements of the next line ("Build the command", "Loop over the
  files in sorted order", "Get the service id from the environment").
- Literal readings of a call — describing what `os.environ.get`
  or a four-line function does in prose.
- Process narration and war stories: how the fix was found, what the
  code used to do, why this change is correct. That is PR-description
  material, not a comment.
- Derivation walkthroughs. State the constraint or invariant in one
  sentence; do not teach the algebra line by line.

## Examples that do not survive

Each of these was found in a real pre-PR sweep (identifiers
genericized). The pattern, not the wording, is what to recognize:

- `# Defaults to "primary" but honors SERVICE_ID from the environment`
  above an `os.environ.get("SERVICE_ID", "primary")` — a literal
  reading of the call. What survived instead: the one fact the code
  could not show (which config layer wins when both are set).
- A four-line comment above a four-line classification function,
  paraphrasing its branches almost word for word. Deleted outright.
- `# Entries stack above their group's anchor row` on a list literal
  whose ordering already shows exactly that. The list is the
  statement; the comment is an echo.
- A comment justifying a layout mechanism "because auxiliary edges do
  not constrain placement" — auxiliary edges had been deleted a dozen
  iterations earlier. Stale rationale from a design pivot; rewritten
  to the mechanism's actual current purpose.
- A four-line header on an enum-to-role table re-describing enum
  names that are self-descriptive. Shrunk to the single surviving
  fact: the one non-obvious classification decision.
- "After several failed attempts we discovered that the renderer
  ignores these edges during coordinate assignment" — the constraint
  (renderer ignores them) survives in one sentence; the journey does
  not.

## Writing new comments

- One short sentence per constraint. If a comment needs a second
  sentence, check whether it is carrying a second (or zero-th) fact.
- Never mix a restatement with a real fact to justify the comment.
  Split off the fact and delete the restatement half.
- Match docstring weight to audience: a public API earns parameter
  docs; a ten-line internal helper earns one line stating purpose,
  not an Args/Returns block.
- Name specifics, not categories ("the vessel_command edge", not
  "the relevant edge").
- When a comment enumerates parallel facts — several name mappings,
  per-case rationales, a set of invariants — format it as a bullet
  list, one fact per bullet, rather than packing the enumeration into
  prose. Readers scan lists; they re-read packed sentences. The
  one-short-sentence rule then applies per bullet.
- Do not pad a file with comments to appease an "under-documented"
  complaint — reviewers are protected by every comment being true and
  non-obvious, not by comment count.
- Never invent a rationale for a value whose reason you do not know.
  A wrong why-comment is worse than none.

## The pre-PR sweep

Design pivots during a working session are the main source of lying
comments: a comment written for iteration 3 still sitting on the code
of iteration 12. Before opening or updating a PR:

**Do the sweep yourself, in one context. Do not partition it across
subagents.** A comment's value is holistic: whether it earns its place
depends on what the neighboring code, the other comments, the module
docstring, and the session's design pivots already say — context that
no per-file or per-package delegate has. Splitting the reading and
keeping the "judgment" is the same violation through a keyhole: the
judgment is only as good as the reading it is built on. If the diff is
large, sweep it in one pass anyway; reading the whole diff is what the
sweep *is*.

1. List every comment and docstring in the touched files.
2. Check each against the current design, not the design it was
   written for. A comment referring to anything deleted or renamed —
   a removed retry loop, a dropped edge category, a dead config band —
   is rewritten to the truth or deleted.
3. Apply the bar above to what remains; compress prose to its
   irreducible content.
4. Check the commit message and module docstring the same way — they
   go stale on the same pivots.
5. Verify the sweep was purely editorial: tests still pass, and any
   generated output (code generation, DOT/SVG, fixtures) is
   byte-identical before and after.

## Rationalizations

| Excuse | Reality |
|---|---|
| "The team lead wants thorough documentation" | Thorough means every comment is true and non-obvious, not that every line has one. |
| "The derivation helps reviewers check the math" | Put derivations in the PR description or a design doc. In code, one sentence stating the invariant suffices. |
| "It's half restatement, but the other half is real" | Keep the real clause, delete the restatement half. |
| "Args/Returns blocks look professional" | Boilerplate on internal helpers buries the one comment that matters. |
| "I'll leave the old comment as historical context" | Git history is the historical context. A stale comment is a lie with authority. |
| "No time to sweep before the PR" | A sweep of touched files takes minutes; a reviewer misled by a stale comment costs a review round. |
| "The diff is huge — I'll fan the reading out to subagents and keep the judgment" | Judgment built on delegated reading is delegated judgment. The sweep's value is one reader seeing the whole change. |
| "The reader might not know this API" | The reader is a competent professional who will look it up. Document your constraint, not their library. |

## Red flags — stop and re-check

- A comment beginning with what the next line literally does.
- A docstring longer than the function it documents.
- "Previously", "used to", "we changed this to" in a comment.
- A comment you are keeping because deleting it feels like losing work.
- A sweep plan that contains the word "delegate", "fan out", or
  "per-file subagent".
