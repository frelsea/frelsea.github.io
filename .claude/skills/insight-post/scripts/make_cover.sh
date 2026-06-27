#!/usr/bin/env bash
# Generate a Frelsea insight-post cover (title-only, branded frame) as a 1200x630 PNG.
#
# Usage:
#   scripts/make_cover.sh "Post Title" assets/img/covers/insight-<slug>-cover.png
#
# For a two-line title, include <br> at the break point:
#   scripts/make_cover.sh "What the Order Book<br>Signals for Returns" <out.png>
set -euo pipefail

TITLE="${1:?usage: make_cover.sh \"Title\" /path/to/output.png}"
OUT="${2:?output PNG path required}"

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$SKILL_DIR/assets/cover-template.html"
[ -f "$TEMPLATE" ] || { echo "template not found: $TEMPLATE" >&2; exit 1; }

TMP="$(mktemp -t frelsea-cover-XXXX).html"
trap 'rm -f "$TMP"' EXIT

# Safe substitution of {{TITLE}} (handles & / \ etc. via Python).
python3 - "$TEMPLATE" "$TITLE" > "$TMP" <<'PY'
import sys
tpl = open(sys.argv[1], encoding="utf-8").read()
sys.stdout.write(tpl.replace("{{TITLE}}", sys.argv[2]))
PY

# Locate Chrome (macOS default; allow override via CHROME_BIN).
CHROME="${CHROME_BIN:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
[ -x "$CHROME" ] || { echo "Chrome not found at: $CHROME (set CHROME_BIN)" >&2; exit 1; }

mkdir -p "$(dirname "$OUT")"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars \
  --force-device-scale-factor=1 --window-size=1200,675 \
  --virtual-time-budget=2000 \
  --screenshot="$OUT" "file://$TMP" >/dev/null 2>&1

[ -f "$OUT" ] || { echo "cover render failed" >&2; exit 1; }
echo "cover -> $OUT"
