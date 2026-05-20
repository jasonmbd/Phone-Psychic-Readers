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
GTM_HEAD="partials/gtm-head.html"
GTM_BODY="partials/gtm-body.html"

if [[ ! -f "$HEADER" || ! -f "$FOOTER" || ! -f "$GTM_HEAD" || ! -f "$GTM_BODY" ]]; then
  echo "Missing one of: partials/header.html, footer.html, gtm-head.html, gtm-body.html" >&2
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
  awk -v hdr="$HEADER" -v ftr="$FOOTER" -v gtm="$GTM_HEAD" -v gtmb="$GTM_BODY" '
    /<!--#include:header-->/ {
      print "<!-- GENERATED from src/ + partials/ - edit those, then run build.sh -->";
      while ((getline line < hdr) > 0) print line; close(hdr); next
    }
    /<!--#include:footer-->/ {
      while ((getline line < ftr) > 0) print line; close(ftr); next
    }
    {
      # Click-to-call: linkify the displayed phone number in body text only.
      # Skip <head>, <script>/JSON-LD, and lines already containing a tel: link.
      if ($0 ~ /<head>/) inhead=1
      if ($0 ~ /<script/) inscript=1
      if (!inhead && !inscript && $0 !~ /tel:\+18889206662/) {
        gsub(/\(888\) 920-6662/, "<a href=\"tel:+18889206662\">(888) 920-6662</a>")
      }
      print
      # Inject GTM head snippet immediately after the opening <head> tag,
      # but only once per file and only if GTM is not already present.
      if (!gtm_done && $0 ~ /<head>/) {
        while ((getline gline < gtm) > 0) print gline; close(gtm)
        gtm_done=1
      }
      # Inject GTM noscript snippet immediately after the opening <body> tag,
      # but only once per file. Per Google docs this is required for users
      # with JavaScript disabled.
      if (!gtmbody_done && $0 ~ /<body>/) {
        while ((getline bline < gtmb) > 0) print bline; close(gtmb)
        gtmbody_done=1
      }
      if ($0 ~ /<\/head>/) inhead=0
      if ($0 ~ /<\/script>/) inscript=0
    }
  ' "$src" \
  | sed -e "s#assets/css/styles\.css\(?v=[0-9a-f]*\)\?#assets/css/styles.css?v=${CSS_V}#g" \
        -e "s#assets/js/main\.js\(?v=[0-9a-f]*\)\?#assets/js/main.js?v=${JS_V}#g" \
  | awk -f scripts/inject_og.awk \
  > "$out"
  echo "built $out"
  count=$((count+1))
done

echo "Done. $count page(s) built."

# --- Auto-regenerate sitemap.xml + robots.txt ---
if [ -f scripts/gen_sitemap.sh ]; then
  bash scripts/gen_sitemap.sh
fi
