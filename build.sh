#!/usr/bin/env bash
# Static include build: assembles src/*.html into root *.html by
# injecting partials/header.html and partials/footer.html, and
# cache-busts the CSS/JS references (assets are cached immutable for
# 1 year by netlify.toml, so the URL must change when they change).
# Run from repo root:  bash build.sh
set -euo pipefail

cd "$(dirname "$0")"

HEADER="partials/header.html"
FOOTER="partials/footer.html"

if [[ ! -f "$HEADER" || ! -f "$FOOTER" ]]; then
  echo "Missing partials/header.html or partials/footer.html" >&2
  exit 1
fi

# Content-hash versions: change only when the asset changes
CSS_V=$(md5sum assets/css/styles.css | cut -c1-10)
JS_V=$(md5sum assets/js/main.js | cut -c1-10)
echo "css v=$CSS_V  js v=$JS_V"

shopt -s nullglob
count=0
for src in src/*.html; do
  out="./$(basename "$src")"
  awk -v hdr="$HEADER" -v ftr="$FOOTER" '
    /<!--#include:header-->/ {
      print "<!-- GENERATED from src/ + partials/ — edit those, then run build.sh -->";
      while ((getline line < hdr) > 0) print line; close(hdr); next
    }
    /<!--#include:footer-->/ {
      while ((getline line < ftr) > 0) print line; close(ftr); next
    }
    { print }
  ' "$src" \
  | sed -e "s#assets/css/styles\.css\(?v=[0-9a-f]*\)\?#assets/css/styles.css?v=${CSS_V}#g" \
        -e "s#assets/js/main\.js\(?v=[0-9a-f]*\)\?#assets/js/main.js?v=${JS_V}#g" \
  > "$out"
  echo "built $out"
  count=$((count+1))
done

echo "Done. $count page(s) built."
