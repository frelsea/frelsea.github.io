# Writing voice, AI-trope blacklist, and SEO front matter

Mirrors the user's `frelsea-blog-writing-style`, `frelsea-ai-writing-tropes`, and `frelsea-deep-insight-posts` memory. Apply all of it.

## Voice

The reader is an institutional shipowner or principal. Ship sale and purchase is a significant capital-allocation decision, so the register is cold, professional, and analytical. Write as a maritime advisor presenting research-grounded analysis.

- Plain and direct. Paragraphs used liberally. No flowery or salesy language. No calls to action.
- Third person and impersonal throughout. No second-person address ("you", "if you want to"), no retail framing ("anyone who has bought a ship knows", "everyone knows").
- Use scientific papers as inspiration, but write a standalone article, not a literature review.

## AI-trope blacklist

These are the tells that make writing read as AI-generated. Scan the draft for each and remove it.

- **Negative parallelism in any form.** This is the most common and most important. Avoid "not X but Y", "X, not Y", and "X rather than Y" reframes. State things positively and directly. Example to avoid: "The price is not a single number, it is a range." Write the positive claim instead.
- **No rhetorical-question openers and no announcement hooks.** Avoid "X is not a single number", "Here is the thing", "The result? ...". Open with a plain declarative sentence.
- **No punchy one-line fragments for emphasis**, no blockquotes for drama, no contrarian framing, no preachy closing line.
- **No em dashes anywhere.** En dash and hyphen are fine. (After drafting, grep for `—` and `–` and remove them.)
- **Straight quotes only** (`"` and `'`), never curly quotes.
- No fabricated data, no broker names, no internal/benchmark figures.

After drafting, run these checks (from the repo root):

```
P=_posts/YYYY-MM-DD-<slug>.md
grep -nE "—|–" "$P"                                          # em/en dashes -> should be empty
grep -niE "not [a-z]+ but |, not |rather than|instead of" "$P"   # negative parallelism
grep -niE "\byou\b|\byour\b" "$P"                            # second person
grep -nE "[“”‘’]" "$P"                                       # curly quotes
```

All four should return nothing.

## Front matter (every insight post)

```
---
layout: post
title: "Title in Mixed Case"
date: YYYY-MM-DD
published: false
description: "Keyword-rich meta description, 150 to 160 characters."
tags: [analysis, <segment(s)>, <topic(s)>]
image: /assets/img/covers/insight-<slug>-cover.png
key_points:
  - "Plain, self-contained sentence, roughly 12 to 22 words."
  - "..."
---
```

- `published: false` always. The user reviews and publishes.
- `tags` MUST begin with `analysis` (the content-type tag that separates deep-insight posts from the weekly `market-report` posts; the site has `/tags/analysis/` and a "Browse" sidebar). Then add the relevant segment tags (`dry-bulk`, `tankers`, `demolition`, `newbuilding`) and topic tags (`s-and-p`, `market-cycles`, `ship-finance`, `recycling`, etc.). NEVER add `market-report` to an insight post.
- `description`: 150-160 characters, keyword-rich; it is the meta description. Verify length.
- `image`: the cover PNG produced in step 4.
- `date`: default to today, but tell the user they may prefer a backdated/staggered date so the posting history reads as a sustained operation rather than a burst.

## key_points

3 to 5 plain, self-contained sentences, fact-first and scannable, roughly 12 to 22 words each. The layout renders them as a "Key points" box at the top, and they help AI answer-engines extract the post. Lead with the fact or finding. Vary the openings (do not start every line the same way). Real figures only. YAML: one line per item, double-quoted, no inner double quotes.

## SEO is already wired in the layout

`_layouts/post.html` auto-generates, for every post: canonical tag, `<html lang>`, article meta (published/modified, tags), Open Graph / Twitter cards, and JSON-LD for BlogPosting + BreadcrumbList. Do NOT add FAQ sections, a `faq` front-matter block, or FAQPage schema — the user had these removed because templated Q&A reads as obvious SEO scaffolding. Keep H2s descriptive and sentences self-contained; that is what serves both search and AI extraction.

## Citations

Attribute the source inline by author and year (e.g. "Greenwood and Hanson, in a 2015 study in the Quarterly Journal of Economics, ..."). Put the data source in each chart's note line. A formal footer reference block is optional and is the user's call; default to clean inline attribution unless asked for a reference list.
