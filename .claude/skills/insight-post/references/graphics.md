# Graphics: the .fr-viz figure system, SVG conventions, grounding, and the cover

Mirrors the graphics conventions in `frelsea-deep-insight-posts` memory.

## Grounding (read first)

A graphic is one of exactly two kinds:

1. **Real-data chart** — every plotted value is traceable to the source. State the source in the `__sub` line and/or the `__note`. If you draw a relationship line through a few documented points (rather than a full dataset you don't have), say so explicitly in the note ("the marked points are reported figures; the line shows the documented relationship").
2. **Model schematic with no numbers** — illustrates a mechanism or relationship with no scale. Label it in the note as "a schematic, with no scale". This is preferred when data would obsolesce or the source is conceptual.

Never mix the two by implying precision you don't have. Never invent a number.

## The .fr-viz figure-card structure

The base card styling (border, shadow, padding, title, sub, note, divider) is centralised in `assets/css/style.css`. Includes must NOT redefine the base `.fr-viz`, `.fr-viz__head`, `.fr-viz__title`, `.fr-viz__sub`, `.fr-viz__note`, or `.fr-viz__chart` rules — only add chart-specific CSS scoped under the include's `#id`. There is NO eyebrow / "Data" / "Model" chip (it was removed).

Template for an include (`_includes/<slug>-<name>.html`):

```html
<div class="fr-viz" id="fr-<slug>-<name>">
  <div class="fr-viz__head">
    <div class="fr-viz__title">A descriptive figure title</div>
    <div class="fr-viz__sub">One-line context. Source: Author (year), from <dataset>.</div>
  </div>

  <div class="fr-viz__chart">
    <svg viewBox="0 0 760 430" preserveAspectRatio="xMidYMid meet" role="img"
         aria-label="Plain-language description of what the chart shows">
      <!-- chart elements, using the scoped classes below -->
    </svg>
  </div>

  <div class="fr-viz__note">What the chart shows, what is real vs schematic, and the source.</div>
</div>

<style>
#fr-<slug>-<name> .fr-x-line{stroke:#cfcfd6;stroke-width:1;}
/* ...only chart-specific, all scoped under the #id... */
</style>
```

The `__sub` line is optional (use it for real-data charts to carry the source; schematics can omit it).

## SVG conventions

- `viewBox="0 0 760 430"` is the house size; the CSS makes it responsive (`width:100%`).
- Palette: accent `#66ccff` (darker text-on-light variant `#3aa6e0`), body text `#60606e`, muted `#999999`, gridlines `#ececf0`, light fills `#f1f1f4` / `#eaf6fd`, dark slate `#404051`.
- Fonts: Montserrat (weight 700) for titles/labels that should read as headings; Open Sans for muted annotations. Set via `font-family` in the scoped classes.
- Axis-title style: small, uppercase, letter-spaced, Montserrat 700, fill `#999`.
- Use dashed strokes (`stroke-dasharray`) for schematic/relationship lines and gridlines; solid accent for the primary series.
- For arrowheads, define a `<marker>` in `<defs>` with a unique id per include.

## Always verify a graphic before embedding

Label collisions and overflow are common and invisible in code. Render each include standalone and look at it:

```bash
SP=/tmp   # scratch
INC=_includes/<slug>-<name>.html
cat > $SP/view.html <<EOF
<!doctype html><html><head><meta charset="utf-8">
<style>body{background:#fff;margin:0;padding:24px;width:820px;}</style></head><body>
$(cat "$INC")
</body></html>
EOF
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu \
  --hide-scrollbars --force-device-scale-factor=2 --window-size=860,560 \
  --screenshot=$SP/shot.png "file://$SP/view.html"
```

Then read `$SP/shot.png` and fix any overlapping labels (nudge x/y, change `text-anchor`, shorten text). Note: standalone renders may drop the site web-fonts and the centralised card border (the base CSS isn't linked) — that's expected; you're checking the SVG content, not the card chrome. To check the card chrome too, view the post on a local `jekyll serve`.

## Worked examples in the repo

- `_includes/order-book-returns-chart.html` — a real-data relationship chart (documented anchor points + a relationship line, with the source and the real/illustrative split stated in the note).
- `_includes/shipping-cycle-loop.html` — a model schematic with no numbers (a labelled feedback loop).
- `_includes/secondhand-premium-chart.html` and `_includes/ship-finance-contraction-chart.html` — a schematic and a real-data bar chart respectively.

Read whichever is closest to what you're building and follow its structure.

## The cover

Run the bundled generator:

```
scripts/make_cover.sh "Post Title" assets/img/covers/insight-<slug>-cover.png
```

It substitutes the title into `assets/cover-template.html` and screenshots it with Chrome headless at 1200x675. The frame is brand-matched to the official weekly cover generator (`~/Documents/Claude/Projects/Frelsea/generate_cover_image.py`): background `#404051`, a 6px `#66ccff` top bar, an 84px `#66ccff` footer with white "FRELSEA" / "MARITIME ADVISORY" (Montserrat 700, 36px, letter-spacing 0.06em), and the real Frelsea F-logo watermark (faint white F polygon + blue dot, 560px, offset off the right edge and vertically centred). Insight covers differ from the weekly ones only in the body: title-only, mixed case, white Montserrat 700 ~72px, with a 72x4 blue accent rule above it (no year / WEEK NN / sub line). For a two-line title, include `<br>` in the title string at the break point. Read the output PNG to confirm the title fits and looks right; if a long title overflows, shorten it or add a `<br>`. If the brand frame ever needs re-checking, the official generator is the source of truth for colours, sizes, and the F geometry.

Do NOT split the title into keywords or add eyebrow/subtitle lines — the user found that messy. Title only.
