---
name: here-now-publish
description: >-
  Upload and share files on here.now (https://here-now.chimera-logarithm.ts.net),
  Baseten's internal artifact-sharing service. Use when the user wants to publish
  or share an HTML page, a Markdown doc, or a code gist and get a shareable link.
  Requires Baseten VPN/Tailscale access.
---

# Publishing to here.now

`here.now` (`https://here-now.chimera-logarithm.ts.net`) is Baseten's internal
artifact-sharing service. You publish a file (or a set of files) and get back a
short, link-shareable URL. Anyone on the VPN with the link can view it.

The full API is documented at: https://here-now.chimera-logarithm.ts.net/s/sapphire-gulch-xtnh

There is a publish endpoint — `POST /api/publish` — with **two modes**, and the
artifact **type is inferred from the file**, not from a parameter (passing
`type`/`kind`/`render` in the body is ignored):

| You want…                                  | Mode                        | Resulting type |
| ------------------------------------------ | --------------------------- | -------------- |
| A **rendered** HTML page                   | multipart file, `.html`     | `html`         |
| A **rendered** Markdown doc (prose, mermaid) | multipart file, `.md`     | `markdown`     |
| A **syntax-highlighted code gist**         | JSON `files[]`              | `gist`         |

> ⚠️ The `/new` web form and the JSON `files[]` API **always create a gist**
> (files shown as highlighted source code). To get a *rendered* HTML/Markdown
> document, you must use the **multipart file upload** below.

## Mode 1 — Rendered HTML / Markdown doc (multipart upload)

Upload the file as a multipart form field named `file`. The extension/content
determines whether it renders as a live HTML page or as a Markdown document.

```bash
# Rendered HTML page
curl -s -X POST https://here-now.chimera-logarithm.ts.net/api/publish \
  -F 'file=@page.html;type=text/html' \
  -F 'title=My Page' \
  -F 'summary=Optional one-line description'

# Rendered Markdown doc
curl -s -X POST https://here-now.chimera-logarithm.ts.net/api/publish \
  -F 'file=@report.md;type=text/markdown' \
  -F 'title=My Report'
```

Form fields:
- `file` — **required**. The file to publish; use `@path` so curl sends its
  contents. The filename's extension drives the type (`.html` → html,
  `.md` → markdown).
- `title` — optional. Defaults to the filename. For Markdown, if omitted it is
  derived from the first `# H1` heading.
- `summary` — optional one-line description shown in the listing.

## Mode 2 — Code gist (JSON)

Send a JSON body with a `files` array (up to 20 files). Each file is displayed
as syntax-highlighted source. This is what the `/new` page uses.

```bash
curl -s -X POST https://here-now.chimera-logarithm.ts.net/api/publish \
  -H 'Content-Type: application/json' \
  -d '{
    "title": "My snippet",
    "summary": "Optional",
    "files": [
      {"filename": "main.py", "content": "print(\"hello\")\n"},
      {"filename": "utils.py", "content": "def f(): ...\n"}
    ]
  }'
```

- `files` — **required**. Array of `{filename, content}`. A single-file gist is
  fine; it is still a gist (highlighted code), not a rendered doc.
- `title`, `summary` — optional. Title defaults to the first filename.
- A `content` string (with optional `filename`) is also accepted in place of
  `files` for a single-file gist.

## Response

Both modes return JSON:

```json
{
  "slug": "mighty-hill-2j7h",
  "version": 1,
  "url": "https://here-now.chimera-logarithm.ts.net/s/mighty-hill-2j7h",
  "version_url": "https://here-now.chimera-logarithm.ts.net/s/mighty-hill-2j7h/v/1"
}
```

Give the user the `url` — that's the shareable link. `version_url` pins the
specific version.

## Notes

- **Access:** requires the Baseten VPN / Tailscale (the `*.ts.net` host is only
  reachable there). Uploads are attributed to the authenticated user's email.
- **Choosing the mode:** if the user says "share this HTML page" or "publish
  this doc/report" → Mode 1 (rendered). If they say "share this code / a gist /
  these files" → Mode 2.
- To publish content you generated, write it to a temp file first, then upload
  that file with Mode 1.
- Browse existing artifacts and filter by type at the site root; `?` / the
  "Mine" filter shows your own uploads. Each entry has copy-link and delete.
