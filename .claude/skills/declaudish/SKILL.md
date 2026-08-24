---
name: declaudish
description: |
  Translate text written in "Claudish" — the characteristic prose style of Claude
  and Claude Code — into plain, direct, idiomatic English. Use when asked to
  rewrite, simplify, or de-AIify Claudish text. Collapses redundant restatements,
  removes rhetorical framing and structural metaphors, lowers abstraction level,
  and preserves every substantive fact exactly.
license: MIT
metadata:
  version: "1.0.0"
  source: https://github.com/programasweights/claudish/blob/main/specs/claudish-to-english.md
---

# Declaudish: Translate Claudish into Plain English

Translate the input from **"Claudish"** into plain, direct, idiomatic English.

"Claudish" is the characteristic prose style of Claude and Claude Code:
rhetorically polished, contrast-heavy, structurally metaphorical,
process-oriented, and prone to expressing one simple proposition through several
abstractions, contrasts, and restatements.

The output must be a genuine paraphrase of the input, **not a response to it**.

## Core Rules

1. **Preserve substance exactly** - Keep every fact, instruction, condition,
   permission, comparison, degree of certainty, and implication. Do not add new
   facts, explanations, recommendations, causal claims, exclusivity rules, or
   conclusions.
2. **Prefer semantic compression** - Recover the smallest set of ordinary
   propositions that captures the input's meaning. Do not preserve wording,
   sentence count, clause count, rhetorical structure, or emphasis merely
   because they appear in the input.
3. **Output only the rewritten text** - No preamble, no commentary, no notes.

## Collapse Restatements

Claudish often states the same idea several times using different abstractions
or rhetorical frames. If multiple clauses or sentences:

- restate the same proposition;
- emphasize it without adding information;
- attach a metaphorical label to it;
- dramatize it;
- contrast it with an artificial alternative;
- summarize a conclusion already stated;
- or redescribe the same relationship at a higher level of abstraction;

collapse them into the shortest natural statement that preserves the meaning.
A multi-sentence passage may legitimately become one short sentence. Do not
produce one output sentence per input sentence.

If deleting a clause changes no fact, condition, permission, uncertainty, or
implication, delete it.

## Lower the Abstraction Level

Prefer ordinary verbs and direct relationships over rhetorical framing,
technical-sounding abstractions, nominalizations, and metaphorical system
language. Recover what the sentence actually says.

| Prefer | Over |
| --- | --- |
| "Only owners can merge." | "Merge authority is restricted to the owner role." |
| "Do not launch until the tests pass." | "Passing tests is a mandatory launch requirement." |
| "The timestamp shows that the cache is stale." | "The timestamp provides verified evidence of cache staleness." |

Use the simplest phrasing that remains accurate.

## Remove Rhetorical Structure

When it adds no meaning, remove rather than paraphrase:

- contrastive framing: "not X but Y," "X, not Y," "less X than Y," rejected
  framing followed by a preferred one;
- staged emphasis: "the key distinction," "the deeper point," "the honest take,"
  "the cleanest way to see this," "the load-bearing constraint," "the verdict
  here," "the smoking gun";
- redundant orientation: "in one sentence," "put differently," "in other words,"
  repeated summaries;
- aphoristic endings: "that distinction matters," "that is the boundary," "that
  is the actual constraint," similar closing fragments;
- validation/candor framing: "you're absolutely right," "fair hit," "one honest
  caveat," "the honest answer" — unless the interpersonal meaning itself
  matters;
- rhetorical restatements that repeat an already-stated claim in different
  vocabulary.

Do not replace these with simpler filler. Omit them entirely when they carry no
additional meaning.

## Decode Structural Metaphors

Replace metaphorical abstractions with the concrete relationship they express:

| Claudish | Plain English |
| --- | --- |
| X-gated / gated on X | X is required, restricted, or must happen first |
| owner-gated | only owners may do it |
| approval-gated | approval is required |
| hard gate / hard boundary / hard stop | strict requirement, restriction, or blocker |
| load-bearing | essential, necessary, central |
| surface | the object, interface, area, or issue being discussed |
| path | the action, option, or process |
| layer | the component or part |
| handoff | transfer or transition |
| spine | main structure or central component |
| landed | merged / completed / deployed / arrived / finished, per context |
| surfaced | appeared, was found, was shown, was reported |
| stale | outdated, no longer current |
| verified / audited | tested, checked, confirmed |
| canonical | authoritative, official, preferred |
| blocker | something preventing progress |
| drift | change or divergence over time |

Choose the simplest contextually correct interpretation; do not mechanically
replace words from a fixed dictionary.

## Preserve Logical Scope Exactly

Be especially careful decoding restrictions, prerequisites, triggers, and
dependencies. Never make a statement stronger or broader than the input:

- "Do X if Y happens" does **not** mean Y is the only situation in which X may
  happen.
- "X requires Y" does not mean X is defined by Y.
- "Only owners may publish" implies nothing about what non-owners may do unless
  stated.
- A prerequisite does not become a causal explanation.
- A trigger does not become an exclusivity rule.
- A preferred source does not become the source that created the data.
- "Has not started" must not become "is in progress."
- "Not tested" must not become "incorrect."
- "Required" must not become "sufficient."

When metaphor is ambiguous, use the narrowest interpretation supported by the
surrounding text.

## Decompress Technical Compounds

Rewrite dense noun stacks and hyphenated abstractions (**X-gated**, **X-backed**,
**X-side**, **X-level**, **X-first**, **X-safe**, **X-matched**, **X-layer**,
**X-surface**, **X-path**, **X-boundary**) as ordinary clauses that recover the
actual relationship between X and the statement. Prefer verbs over invented
conceptual nouns.

- "approval-gated release path" → "release requires approval"
- "a fact-preservation pass" → "the rewrite must preserve every fact"

## Simplify Over-formal Research Language

Simplify words like **frontier, horizon, floor, surface, exchange rate, regime,
trajectory, slice, cell, matched, frozen, headline, confirmatory, protocol,
claim gate, lower bound, clears, survives, implicates** when used rhetorically
rather than technically. Keep them when they are genuine technical terms whose
precision matters.

## Keep Legitimate Terminology

Claudish-associated words are not forbidden. Keep **provenance, lineage,
calibration, routing, boundary, gate, surface, protocol, verified, canonical,
drift** when genuinely the clearest technical description. Remove Claudish
vocabulary only when it functions as unnecessary abstraction, metaphor,
ornamentation, or rhetorical emphasis.

## Make It a Visible Rewrite

Do not merely swap a few words while retaining the original structure. When
applicable: reduce sentence count, collapse redundant clauses, lower the
abstraction level, turn nominalizations into verbs, remove artificial contrasts,
replace metaphors with literal relationships, drop emphasis carrying no new
information, and simplify cadence and syntax. The output should read as though
a person simply stated what the input means.

Substantially shorter output is acceptable and often preferable.

## Fixed Content

Preserve names, quotations, commands, code, and technical terminology whose
wording must remain fixed verbatim.
