# AI writing tropes to avoid

The full list (mirrors the user's `frelsea-ai-writing-tropes` memory, distilled from the user's uploaded `tropes.md` / tropes.fyi). These patterns read as AI slop and undercut the seasoned-professional voice. Used once in isolation some are tolerable; the damage comes from piling them up or repeating one. After drafting, scan for each and cut it. Write varied, specific, human.

## Sentence-level patterns

- **Negative parallelism (the worst offender; aim for zero).** The two-part contrastive reframe: "It's not X, it's Y", "The question isn't X, it's Y", "X, not Y", and "X rather than Y" (this last one counts even though it reads neutral). Recast positively — state what it is. A plain factual negative is fine ("the price is not fixed", "this does not forecast returns"); the banned form is the contrastive reframe.
- **"Not X. Not Y. Just Z." countdown** pattern.
- **Self-posed rhetorical question then answer:** "The result? Devastating." / "Why does this matter? Because ..."
- **Anaphora abuse** (several sentences opening with the same word) and **tricolon stacking** (rule-of-three clauses back to back).
- **Short punchy one-sentence fragment paragraphs** for manufactured emphasis.
- **Trailing "-ing" pseudo-analysis:** "highlighting its importance", "reflecting broader trends", "underscoring the shift".
- **False ranges:** "from X to Y" where X and Y are not points on a real scale.

## Word and phrase choices

- **Magic adverbs:** "quietly", "deeply", "fundamentally", "remarkably", "arguably".
- **Banned vocabulary:** "delve", "leverage" (as a verb — the noun meaning bargaining power is fine), "utilize", "robust", "streamline", "harness", "tapestry", "landscape", "ecosystem", "paradigm".
- **"serves as / stands as / represents"** where plain "is" works.
- **Filler transitions:** "It's worth noting", "Importantly", "Notably", "Interestingly".
- **Tone tics:** "Here's the kicker/thing", "Think of it as", "Imagine a world where", "Let's break this down/unpack", false vulnerability, "the truth is simple", grandiose stakes inflation.
- **Vague attributions:** "experts argue", "industry reports suggest", with no named source. Name the source.
- **Invented concept labels:** coining a tidy phrase for the article's idea ("the supervision paradox", "the acceleration trap"). Describe the thing plainly instead.

## Formatting

- Em-dash addiction (em dashes are banned outright; use en dash or hyphen).
- Bold-first bullets, unicode arrows, smart/curly quotes (use straight quotes).

## Composition

- Fractal summaries (restating the same point at every level).
- A dead metaphor repeated five to ten times.
- Historical-analogy stacking.
- One-point dilution (stretching a single idea across many paragraphs).
- Signposted conclusions: "In conclusion", "To sum up", and the "Despite its challenges, ..." formula.

## Scan before finishing

In addition to the four greps in `writing-and-seo.md` (em dashes, negative parallelism, second person, curly quotes), spot-check for the items above. A quick pass:

```
P=_posts/YYYY-MM-DD-<slug>.md
grep -niE "\bdelve|\butili[sz]e|\brobust|\bstreamline|\bharness|tapestry|landscape|ecosystem|paradigm" "$P"
grep -niE "leverage[ds]|leveraging" "$P"                          # verb forms only; noun is fine
grep -niE "it'?s worth noting|importantly|notably|interestingly" "$P"
grep -niE "serves as|stands as|represents" "$P"
grep -niE "in conclusion|to sum up|despite its|here'?s the (kicker|thing)|think of it as" "$P"
grep -niE "\bquietly|\bdeeply|\bfundamentally|\bremarkably|\barguably" "$P"
```

These greps are aids, not judges — read the prose and cut anything that reads as a tell, including patterns no grep catches (anaphora, tricolons, fragment paragraphs, fractal summaries).
