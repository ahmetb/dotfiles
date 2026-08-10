---
name: report-styling
description: Design system for single-file HTML engineering reports and deep dives — two-column sticky-TOC layout, green-accented semantic color coding, timeline step lists, code-anchored prose. Use when writing an HTML report, deep dive, or technical writeup.
---

# Report styling — engineering deep-dive format

Produce a single self-contained HTML file (all CSS/JS inline, no external
requests). Reference example: the "How Routing Works in alyx-lb" report.

## Layout

- Two-column grid: `288px` sticky sidebar + main column, max-width `1480px`.
  Main content padding ~`0 64px 120px`. Collapses to one column under
  `1080px` via media query.
- Page background is a very light sage-tinted gray (`#f4f9f3`); content
  surfaces (sidebar, cards, pills) are white with `1px` hairline borders.
- Sidebar: `position: sticky; top: 0; height: 100vh; overflow-y: auto`, with
  a hairline right border.

## Typography

- Sans: `"Inter", -apple-system, "Helvetica Neue", sans-serif` for everything.
- Mono: `"IBM Plex Mono", ui-monospace, Monaco, monospace` for kickers, tags,
  captions, code chips.
- Body: `15px/1.6`. Lede: `17px/1.62`, max-width `76ch`.
- Headings are weight **500** (never 700) with tight letter-spacing
  (−.01 to −.025em). H1 ~`38px/1.14`, H2 ~`26px` with a green section
  number, H3 `19px/1.3` numbered like `2.1 ·`.
- Kickers/tags/group labels: `11–11.5px` mono, uppercase, letter-spacing
  `1–1.5px`.

## Color system (semantic, not decorative)

- Accent green `#12ad52` (green-600): section numbers, active TOC edge,
  step badges, brand mark, key-note borders.
- Every color means one thing document-wide and is used consistently in the
  H1 highlights, inline keyword spans, and callout borders:
  - blue `#2176ff` = one core concept (e.g. load/utilization)
  - orange `#e56123` = the opposing concept (e.g. cache/stickiness)
  - green = good / keep / takeaway
  - red `#dd403a` = shed / warning
- Tinted fills come from the 50-shade of each hue (`green-50 #e5fcef`,
  `orange-50 #fdf5f1`, `red-50 #fcefee`).

## Sidebar (brand + abstract + grouped TOC)

- Top: small green SVG logo mark + short report title (500 weight, 15px).
- Below it: a 3–5 line plain-prose abstract of the whole document.
- TOC links grouped under uppercase mono micro-headers naming the arc
  (e.g. "FOUNDATIONS", "THE DECISION", "STATE & INTERFACES"); hairline
  separators between links; H3 links indented and smaller.
- Scrollspy (inline JS, IntersectionObserver): active link becomes a rounded
  gray chip with a green left edge.
- Every H2/H3 gets an appended `#` anchor link that copies the section URL.

## Hero

- Uppercase widely-letter-spaced mono kicker: `CATEGORY · SUBJECT · CONTEXT`
  separated by middle dots.
- H1 is a full thesis sentence, not a label, with 1–2 phrases color-coded to
  the semantic mapping (e.g. blue for the load phrase, orange for the cache
  phrase).
- Lede paragraph with bold-studded key terms, ending with a map of the
  sections ("…the inputs it reads (§1), the lifecycle (§2)…").
- Row of small bordered white metadata pills: `Mode:`, `Lang:`, `Path:` etc.,
  with inline code chips inside where apt.
- Immediately after the hero: a green-bordered, green-tinted "THE
  ONE-PARAGRAPH MODEL" card that compresses the entire system into one
  paragraph before any sections begin.

## Content elements

- **Numbered narrative arc**: H2s prefixed with a green tabular number
  (or §); the doc reads as a story (overview → mechanism → lifecycle →
  state → inputs → outputs), not a reference dump.
- **Timeline step lists**: `ol.steps` with list-style none; each `li` gets a
  28px solid-green circular counter badge (white number) and a faint
  vertical connector line between badges. Each step opens with a bold action
  phrase, an em-dash, then the exact function name as a code chip.
- **Inline code chips**: light-gray rounded-background mono spans, used
  densely to cite exact identifiers — function names, config keys, Redis
  keys, metric names, sentinel values, HTTP codes — so prose stays
  source-anchored.
- **Semantic callout cards** (`.note`): rounded, hairline border, soft
  shadow, uppercase mono tag as first line. Variants: `key` (green left
  border + green-50 fill) for takeaways; `warm` (orange border + tint) for
  tensions/tradeoffs (e.g. "WHY STICKINESS MATTERS HERE"); `warn` (red) for
  gotchas; plain white for context.
- **Code as cited figures**: dark-background syntax-highlighted `<pre>`
  wrapped in `<figure class="code">` with a mono figcaption naming what it
  is and the exact source path
  (`pseudocode · GET /deep/health pipeline — worker_utilization.py`).
- **Reference tables**: compact `13px` bordered tables for input/output/
  metric catalogs; muted gray header row.

## Behavior

- `scroll-behavior: smooth`, `scroll-margin-top` on headings.
- `::selection` tinted with the accent (green-100).
- Inline scripts only: scrollspy + heading anchor-copy. No frameworks, no
  CDN fetches.