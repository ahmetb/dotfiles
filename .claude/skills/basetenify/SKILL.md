---
name: "basetenify"
description: "Apply Baseten's brand (colors, type, layout, logo rules, voice) to any artifact or finished work product — HTML pages/artifacts, dashboards, charts, slides, docs, spreadsheets, one-pagers, diagrams. Trigger on \"Basetenify this\", \"make this on-brand\", \"apply Baseten branding/colors/style\", \"brand this for Baseten\", or whenever building an external-facing Baseten deliverable that should look like Baseten."
---

# Basetenify

Take any artifact (new or existing) and make it look, read, and feel like Baseten. Apply the system below, then run the QA checklist before handing back.

Sources this was distilled from (defer to them if anything conflicts): public brand page https://www.baseten.co/brand/ (colors, logo, media kit), internal Figma "Baseten — Brand Guidelines" (https://www.figma.com/design/kt0brKm98z7mTjFGTMAAzD/Baseten---Brand-Guidelines, owned by Brand Design: Aaron Relph, Kristyn Braden, Luke de Haas), the Notion "[External] Writing style and messaging guide" (Rachel Rapp), the Notion "Baseten Interface Guidelines" (WIP), and #brand-design in Slack.

## 1. Workflow

1. **Identify the artifact type and audience.** External (customers, prospects, public) gets the full treatment incl. voice edit and confidentiality footer. Internal gets visuals + light voice pass.
2. **Preserve content.** Basetenify restyles; it does not change facts, numbers, or meaning. Voice edits tighten wording only.
3. **Apply tokens** (section 2–4) using the format recipe in section 6.
4. **Apply voice rules** (section 5) to all copy, titles, labels, and chart titles.
5. **Run the QA checklist** (section 7) and fix anything that fails.
6. Tell the user in one or two lines what changed and anything you couldn't apply (e.g., brand font unavailable, real logo file not on hand).

## 2. Color

Canonical palette (from baseten.co/brand — current as of the 2026 rebrand):

| Token | Name | Hex | Role |
|---|---|---|---|
| `--bt-green` | Baseten green | `#19E76E` | Primary accent. The hero color. |
| `--bt-green-dark` | Dark green | `#00B86B` | Secondary green, hover/pressed, second series |
| `--bt-pink` | Baseten pink | `#FFA9FD` | Brand accent — announcements, brand moments, secondary series |
| `--bt-sage-dark` | Dark sage | `#A2AE9D` | Muted neutral: secondary text on light sage, competitor/baseline series, dividers |
| `--bt-sage` | Sage | `#CDDCC7` | Borders, hairlines, subtle fills |
| `--bt-sage-light` | Light sage | `#F1F7EF` | Panel / section backgrounds |
| `--bt-black` | Black | `#000000` | Body text, dark backgrounds |
| `--bt-white` | White | `#FFFFFF` | Page background, text on black |

Rules:
- **Neutrals carry the page; brights are accents.** Backgrounds are white, light sage, or black. Use green/pink for callouts, highlights, key numbers, the Baseten series in charts — not for large decorative fills on copy-heavy sections.
- **One bright accent per region.** If two things in the same section are green, one is wrong. Green is the default accent; pink is the occasional second.
- **Contrast:** `#19E76E` and `#00B86B` fail contrast as text on white. On light backgrounds, keep text black and use green as a fill, marker, underline, bar, badge background (with black text), or rule. Green *text* is fine on black.
- **Dark mode / dark slides:** black background, white text, green accent. This is very on-brand (terminal/phosphor feel).
- **Status colors** (dashboards only): green = live/healthy, amber = degraded, red = failed. Always pair a status color with a text label. Never use pink for status.
- **Don't use** the old palette that still appears in some internal docs: `#1BB572`, Canary Yellow `#FFDB3B`, Sky Blue `#4CA3FF`, Bubblegum Pink `#F279AC`. These are pre-rebrand. Also no gradients, drop shadows as decoration, or off-palette colors.

Chart extensions (from the team's Baseten chart style): mint soft `#83EFAF`, mint light `#C6EAD5` (bands/fills), lilac light `#E8CAF1`, gridlines `#C6C8C8`, reference lines `#828788`, secondary text `#1C1E1C`.

## 3. Typography

- **Brand typeface: Beausite Classic** (Regular is the default weight across the site; it's a licensed font — not on Google Fonts). Use it when it's installed or the user supplies the files.
- **Fallback sans** (when Beausite isn't available, e.g. artifacts, Google Docs, Word): `"Beausite Classic", "Helvetica Neue", Helvetica, Inter, Arial, sans-serif`. For web artifacts, Inter from Google Fonts is an acceptable stand-in.
- **Monospace:** Chivo Mono (available on Google Fonts) → fallback `"JetBrains Mono", ui-monospace, Menlo, monospace`. Use mono for code, IDs, model names in technical contexts, eyebrows/tags, and numbers people compare (latency, throughput, $/M tokens).
- **Weights:** Regular for body, Medium/Semibold for headers. Nothing heavier than semibold — Baseten type is light and confident, not shouty.
- **Sentence case** for all titles and headers ("Inference at global scale", not "Inference At Global Scale").
- **Numbers lead.** When a metric is the point, make the number large and the label small. Use `font-variant-numeric: tabular-nums` for any numeric column.
- Large display headlines: tight tracking (≈ -0.02em), line-height ~1.05–1.15.

## 4. Layout, shape, and imagery

- **Generous whitespace for marketing/external docs; dense for dashboards/tools.** Separate groups with space before reaching for borders.
- **Square corners.** The 2026 guidelines call for strictly square buttons and boxes (border-radius 0; at most 2px on tiny chips). No pill buttons, no rounded cards.
- **Borders are 1px hairlines** in `--bt-sage` (light) or `#1C1E1C`/`#333` (dark). No heavy frames, no shadows except on truly floating elements.
- **Fewer cards.** Prefer type, space, and a single hairline over boxed cards. Asymmetric layouts (one dominant region) beat equal-weight grids.
- **Eyebrows/tags:** small uppercase mono label above a headline, optionally in a green or pink filled square tag with black text.
- **Developer-native motifs are welcome:** subtle dotted/dashed grid backgrounds, mono labels, terminal-style code blocks (black bg, light text, restrained syntax color).
- **Logo:** the Baseten wordmark and "B" mark are custom-drawn — there is no logo font. Never fake the logo by typing "baseten" in a font or drawing an approximation. Use the official SVG/PNG (media kit: https://www.baseten.co/brand/ → "Download media kit"; or the Rebrand Collateral Drive folder). If the real file isn't available, use the plain text name "Baseten" in the body font as a byline and tell the user to drop in the official logo. Choose the logo variant with the best contrast (black on light, white on dark, green when appropriate). Don't put the logo on blog thumbnails (the site already brands them).
- **Customer/partner logos:** only approved, current logos, rendered in a single color (black on light, white on dark) for lockups.
- **External doc footer:** logo or "Baseten" + "Confidential — prepared for [Customer]" (or similar) + date, small, in dark sage.

## 5. Voice (apply to every word in the artifact)

- Confident, technical, backed by data. "Sub-300 ms P99 latency", "99.99% uptime" — never "lightning-fast", "dependable".
- Direct, active voice. Short sentences, short paragraphs. Precise technical terms (KV cache, speculative decoding, TTFT) — the audience is engineers.
- Sharp, occasionally dry/playful where stakes are low. Never hypey.
- Banned: best-in-class, world-class, industry-leading, cutting-edge, unparalleled, second-to-none, blazing-fast, game-changing, "intimate"; "not just X, it's Y"; "at the end of the day"; "it's worth noting"; summary paragraphs that restate everything; bold sprinkled mid-sentence.
- Mechanics: American English; sentence-case titles; no ampersands ("and"); em dashes with spaces on both sides ( — ); "vs." with a period; "open-source", "closed-weight" (not "closed-source" for models), "fine-tune"; "day 0"; "time to first token" (no hyphens).
- Product names capitalized: Baseten Inference Stack, Chains, Truss, Dedicated Inference, Model APIs, Training, Inference Runtime, Speculation Engine, Baseten Cloud / Self-hosted / Hybrid, Multi-cloud Capacity Management, Custom Servers.
- Messaging: highlight the Baseten Inference Stack; never position Baseten as a wrapper around NVIDIA tools (TensorRT-LLM, Dynamo are components of the stack); lead with the customer's problem and outcome, not a feature list.
- Socials: no bold text.

## 6. Format recipes

### HTML pages, artifacts, dashboards
Drop in these tokens and map existing colors onto them:

```css
:root{
  --bt-green:#19E76E; --bt-green-dark:#00B86B; --bt-pink:#FFA9FD;
  --bt-sage-dark:#A2AE9D; --bt-sage:#CDDCC7; --bt-sage-light:#F1F7EF;
  --bt-black:#000; --bt-white:#fff;
  --bg:var(--bt-white); --surface:var(--bt-sage-light); --text:var(--bt-black);
  --text-muted:#4A5247; --line:var(--bt-sage); --accent:var(--bt-green); --accent-2:var(--bt-pink);
  --font-sans:"Beausite Classic","Inter","Helvetica Neue",Helvetica,Arial,sans-serif;
  --font-mono:"Chivo Mono","JetBrains Mono",ui-monospace,Menlo,monospace;
  --radius:0;
}
@media (prefers-color-scheme: dark){
  :root:not([data-theme="light"]){ --bg:#000; --surface:#0E110E; --text:#fff; --text-muted:#A2AE9D; --line:#262B26; }
}
:root[data-theme="dark"]{ --bg:#000; --surface:#0E110E; --text:#fff; --text-muted:#A2AE9D; --line:#262B26; }
body{background:var(--bg);color:var(--text);font-family:var(--font-sans);font-weight:400;}
h1,h2,h3{font-weight:500;letter-spacing:-0.02em;}
code,pre,.mono,.eyebrow{font-family:var(--font-mono);}
.eyebrow{text-transform:uppercase;font-size:12px;letter-spacing:.06em;}
.num{font-variant-numeric:tabular-nums;}
button,.btn,.card,.tag,input{border-radius:var(--radius);}
.btn-primary{background:var(--accent);color:#000;border:0;}
```
Load Chivo Mono + Inter from Google Fonts when Beausite isn't available. Replace rounded corners, shadows, gradients, and off-palette colors. Primary button: green fill, black text, square. Only one primary per region.

### Charts (matplotlib, Recharts, Chart.js, Sheets charts)
- White (or black) background, no top/right spines, y-gridlines only at `#C6C8C8` 0.5pt, hairline axes.
- **Baseten series = `#19E76E`** (second Baseten series `#FFA9FD` or `#00B86B`). **Competitors/baselines = muted** (`#A2AE9D`, `#CDDCC7`, `#828788`) — never in bright brand colors.
- One green highlight per chart. Flat bar fills, no edges; 2pt rounded lines.
- Title states what's shown, black, sentence case, plus "(lower is better)" / "(higher is better)" where relevant. Legend frameless, below the plot.
- Start unbounded y-axes at 0; 0–1 scale for bounded metrics.
- matplotlib rcParams quickstart:
```python
plt.rcParams.update({"font.family":"sans-serif","font.sans-serif":["Beausite Classic","Helvetica Neue","Helvetica","Arial"],
 "axes.spines.top":False,"axes.spines.right":False,"axes.linewidth":0.5,"axes.edgecolor":"#C6C8C8",
 "axes.grid":True,"axes.grid.axis":"y","grid.color":"#C6C8C8","grid.linewidth":0.5,"grid.alpha":0.7,
 "axes.titleweight":"bold","axes.titlesize":12,"axes.labelcolor":"#1C1E1C","xtick.color":"#1C1E1C","ytick.color":"#1C1E1C",
 "lines.linewidth":2,"legend.frameon":False,"axes.prop_cycle":plt.cycler(color=["#19E76E","#FFA9FD","#A2AE9D","#E8CAF1","#00B86B"])})
```

### Slides (Claude Slides, .pptx, Google Slides)
- Title slides: black background, white sentence-case headline, a green or pink square tag/eyebrow, logo bottom-left or top-left.
- Content slides: white or light sage background, black text, one green accent element per slide (key number, highlight bar, or tag).
- Big-number slides: number huge in black (or green on black), label small in mono.
- Square shapes only; hairline dividers; no clip-art, no gradients, no drop shadows.
- Check the Rebrand Collateral Drive folder for official deck templates before building from scratch.

### Docs (Claude Docs, .docx, Google Docs, Notion, PDFs)
- Headings in black, sentence case, semibold; a thin green rule or green square marker can accent H1/H2. (Green as heading *text* only on dark backgrounds.)
- Body: fallback sans (Helvetica/Arial in Word/Google Docs — order forms and similar must stay Word/Google-friendly, no custom fonts).
- Tables: header row light sage `#F1F7EF` fill with black semibold text, 1px sage `#CDDCC7` borders, no zebra striping, numbers right-aligned.
- Callouts: light sage fill, optional 3–4px green left bar.
- External docs: confidentiality footer (section 4).
- Notion: use green callouts/emoji sparingly; Notion can't use custom hex — prefer "green" and "gray" colors and keep everything else default.

### Spreadsheets (.xlsx, Google Sheets, Claude Sheets)
- Header row: black fill + white text, or light sage fill + black bold text. Freeze it.
- Highlight key/total rows with light sage; flag the single most important cell with green fill + black text.
- Status/tier color-coding: green `#19E76E` / amber / red at ~35% tint with black text, always alongside a text label.
- Hairline sage borders, Arial/Helvetica, tabular number formats.

### Diagrams / whiteboards
Black or white canvas, square nodes with 1px borders, mono labels, green for the Baseten component/path being highlighted, pink sparingly for a second emphasis, sage for everything else. No 3D, gradients, or icons-everywhere. Brand Design notes AI-generated diagrams can still "look AI" — keep them minimal and typographic, and route anything going on the blog through Brand Design.

### Plain text (Slack, email)
No visual styling — apply section 5 voice rules only.

## 7. QA checklist (run before returning)

- [ ] Only palette colors; no `#1BB572`/yellow/blue/old pink; no gradients or decorative shadows
- [ ] At most one bright accent per region; green text never on white
- [ ] Baseten = green in comparisons; competitors muted
- [ ] Square corners; 1px hairlines; whitespace (or density for dashboards) applied
- [ ] Type: Beausite or fallback sans, mono for code/numbers, no weight above semibold, tabular numbers
- [ ] Sentence-case titles; no ampersands; spaced em dashes; American English
- [ ] No banned phrases or empty superlatives; claims backed by numbers
- [ ] Product names capitalized correctly
- [ ] Real logo file used (or plain "Baseten" text + note to user) — never a faked wordmark
- [ ] External: confidentiality footer, approved customer logos only
- [ ] Dark mode (for HTML) renders legibly
- [ ] Content and numbers unchanged from the source

## 8. Escalation
High-visibility public assets (ads, blog graphics, event/booth, swag, launch creative) should still go through Brand Design via a Linear ticket in the Brand Design team or #brand-design. Basetenify is for fast, on-brand internal and sales/GTM work product.

