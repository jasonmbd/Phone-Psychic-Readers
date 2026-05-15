#!/usr/bin/env bash
# Static include build: assembles src/*.html into root *.html by
# injecting partials/header.html and partials/footer.html.
# Run from repo root:  bash build.sh
set -euo pipefail

cd "$(dirname "$0")"

HEADER="partials/header.html"
FOOTER="partials/footer.html"

if [[ ! -f "$HEADER" || ! -f "$FOOTER" ]]; then
  echo "Missing partials/header.html or partials/footer.html" >&2
  exit 1
fi

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
  ' "$src" > "$out"
  echo "built $out"
  count=$((count+1))
done

echo "Done. $count page(s) built."
