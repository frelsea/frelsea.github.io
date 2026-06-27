---
name: insight-post
description: >-
  Turn a journal paper, working paper, or industry article into a Frelsea deep-insight blog post
  (an "analysis" post for the Frelsea maritime-advisory site, distinct from the weekly market reports).
  Use this whenever the user supplies a paper or article (PDF path, DOI, or URL) and wants an insight
  post, deep-dive, or analysis piece, or says things like "make an insight post from this paper",
  "turn this study into a deep-dive", "write a Frelsea analysis of this", or hands over a paper to
  base a post on. It runs the whole pipeline: extracting the source's real figures, building a grounded
  SVG graphic and a themed cover, writing the post in the house voice with SEO front matter and the
  `analysis` tag, and verifying with a local Jekyll build. Always use this for Frelsea deep-insight /
  analysis posts. Do NOT use it for the weekly S&P / demolition / newbuilding market reports — those
  have their own separate pipeline (the weekly-broker-pipeline skill).
---

# Frelsea insight-post builder

Turns one source (a journal paper, working paper, or substantive industry article) into one publishable Frelsea deep-insight post: a markdown file, one or two original graphics, and a themed cover, left as a `published: false` draft for the user to review.

This skill operationalizes the user's standing conventions. If these memory files are loaded they are the source of truth and this skill just sequences them: `frelsea-blog-writing-style`, `frelsea-ai-writing-tropes`, `frelsea-deep-insight-posts`. The reference files bundled here restate the essentials so the skill works even when memory is absent.

The repo lives at the project root (a Jekyll site). Paths below are relative to it.

## What "good" looks like

A Frelsea reader is an institutional shipowner or principal allocating significant capital. The post reads as sober, research-grounded analysis from a maritime advisor, not a blog. The single most important rule: **every number shown is real and attributable, or the graphic carries no numbers at all.** A fabricated data point destroys the credibility the whole exercise is meant to build. When in doubt, use a labelled model schematic with no scale rather than inventing values.

## The pipeline

Work through these in order. Read the two reference files before writing anything.

- `references/writing-and-seo.md` — the house voice and the exact front-matter / SEO / tag spec. Read it fully; the voice rules are strict and easy to violate.
- `references/ai-tropes.md` — the complete AI-writing-trope blacklist (negative parallelism, magic adverbs, banned vocabulary, filler transitions, signposted conclusions, and more). Read it fully and scan the finished draft against it. This is the user's standing list and the most common source of revisions; treat it as required, not optional.
- `references/graphics.md` — the `.fr-viz` figure-card system, the SVG conventions, the grounding rules, and the cover generator. Read it before building any graphic.

### 1. Ingest the source and pull the real figures

The graphic and the post must be grounded in what the source actually says, so extraction comes first.

- **Local PDF:** `pdftotext -layout <file.pdf> <out.txt>`, then read the text and grep for the figures, tables, sample period, dataset, and the key quantitative claims (correlations, coefficients, peak/trough values with dates, magnitudes). Note exact numbers verbatim.
- **URL / web article:** fetch it and extract the same.
- **Paywalled paper (ScienceDirect, QJE, Elsevier, etc.):** the publisher page will 403. Get the verifiable metadata and abstract from the Semantic Scholar API instead:
  `curl -s "https://api.semanticscholar.org/graph/v1/paper/search?query=<title+words>&fields=title,abstract,authors,year,venue,openAccessPdf"`
  Confirm authors, year, venue, and DOI. If the abstract is elided, rely on the abstract/figures you can verify elsewhere and do not invent specifics.
- Record a clean citation: Author(s) (year), "Title", Venue, with DOI/link.

Keep a short list of the real numbers you will use. If you cannot verify a number, it does not go in a chart.

### 2. Choose the angle and the graphic(s)

Pick one clear thesis the source supports — the practical takeaway for a shipowner, not a literature summary. Then decide the graphic(s):

- **Real-data chart** when the source gives chartable figures (a relationship, a time series with documented anchor points, a breakdown). Mark only the real values; if you draw a relationship line through documented points, say so in the note.
- **Model schematic, no numbers** when the source is conceptual or the data would obsolesce. This is often the better, more durable choice (the user prefers it). Label it clearly as schematic with no scale.

One or two graphics is right. A flagship piece often pairs one real-data chart with one model schematic. See `references/graphics.md`.

### 3. Build the graphic include(s)

Author each as `_includes/<slug>-<name>.html` following the `.fr-viz` structure in `references/graphics.md`. Do not redefine the base `.fr-viz` card styles (they live in `assets/css/style.css`); only add chart-specific CSS scoped under the include's `#id`. No "Data"/"Model" eyebrow chip.

**Verify each graphic visually before embedding it.** Wrap the include in a minimal HTML page and screenshot it with Chrome headless (see `references/graphics.md`), then read the screenshot and fix any label collisions or overflow. Charts that look fine in code routinely have overlapping labels.

### 4. Generate the cover

Run the bundled script:

```
scripts/make_cover.sh "Post Title" assets/img/covers/insight-<slug>-cover.png
```

Title-only, mixed case, on the branded frame. For a two-line title, pass the break as `<br>` inside the title string. Read the output PNG to confirm it looks right. Details and the template are in `references/graphics.md`.

### 5. Write the post

Create `_posts/YYYY-MM-DD-<slug>.md`. Follow `references/writing-and-seo.md` exactly for front matter and voice. The essentials:

- `published: false` always (the user reviews before publishing).
- `tags:` must begin with `analysis`, then relevant segment tags (`dry-bulk`, `tankers`, `demolition`, `newbuilding`) and topic tags (`s-and-p`, `market-cycles`, `ship-finance`, ...). **Never** add `market-report` to an insight post.
- `description` 150-160 chars, keyword-rich. `image` points to the cover. `key_points`: 3-5 plain, self-contained sentences.
- Attribute the source inline by name and year, and reference the chart's source in its note. The body is institutional third person: no em dashes, no negative parallelism in any form, no rhetorical-question openers or announcement hooks, no second person, no punchy one-line fragments, straight quotes only.
- Insert the graphic(s) with `{% include <slug>-<name>.html %}` at the point each is discussed.
- Length is whatever the topic needs (roughly 900-1400 words is typical); depth over filler.

### 6. Verify the build

```
RBENV_VERSION=3.3.5 jekyll build --quiet --destination _site_test
```

The post is `published: false`, so it will not appear in the build. To confirm it renders (includes load, key_points box, JSON-LD), temporarily copy it to a test file with `published: true`, build with `--future`, screenshot the page from a local `jekyll serve`, then delete the test copy. Also run the quick text checks in `references/writing-and-seo.md` (no em dashes, no negative-parallelism patterns, description length, straight quotes). Remove `_site_test` when done.

### 7. Hand back

Report: the post path, the include(s), the cover, the citation used, which numbers are real vs which graphic is a schematic, and the verification result. Leave it as a draft. Mention that the user may want to set a backdated/staggered `date:` for publishing cadence rather than today's date (the site presents a sustained posting history). Do not commit or push unless asked.

## Grounding rules (non-negotiable)

- Real numbers must be traceable to the source. No invented data points, ever.
- A graphic is either grounded in cited real figures (state the source in the note) or a schematic with no numbers (label it as such). Nothing in between.
- If the source is paywalled and a figure cannot be verified, describe the mechanism qualitatively or use a schematic; do not reconstruct numbers from memory.
- Be honest in the hand-back about what is real and what is illustrative.
