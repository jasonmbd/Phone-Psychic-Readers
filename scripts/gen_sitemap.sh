#!/usr/bin/env bash
# Yoast-SEO-style sitemap generator.
# Master:     sitemap_index.xml   (references each sub-sitemap with its
#                                  own lastmod = max of contained URLs)
# Sub-sitemaps (one per content type):
#   page-sitemap.xml          core static pages (home, about, contact,
#                             privacy, terms, locations, blog)
#   category-sitemap.xml      4 national GBP category hubs (psychic,
#                             astrologer, numerologist, fortune-telling-services)
#   service-sitemap.xml       national service hubs (love, tarot,
#                             clairvoyant, etc.)
#   location-sitemap.xml      city landings (*-phone-psychic.html)
#   burbank-sitemap.xml       Burbank category + service pages
#   city-services-sitemap.xml touching-city category + service pages
#                             (Glendale, NoHo, Toluca Lake, Universal
#                              City, Sun Valley)
#   tarot-sitemap.xml         tarot card meaning reference pages
#   post-sitemap.xml          blog articles (whos/what/how/why/when prefixes)
#
# 404.html is excluded (matches its own noindex meta).
# lastmod per URL = last git-commit date (stable across rebuilds), with
# file mtime as fallback for files never committed.
# robots.txt is rewritten to point at sitemap_index.xml.
# _redirects gets a 301 from /sitemap.xml to /sitemap_index.xml so
# anyone (or any historical GSC submission) hitting the old URL is
# routed to the new one.
set -euo pipefail
cd "$(dirname "$0")/.."

BASE="https://www.phonepsychicreaders.com"

# --- Bucket each *.html into exactly one content type ---
classify() {
  local f="$1" slug
  slug="${f%.html}"
  case "$slug" in
    404) echo skip ;;
    index|about|contact|privacy|terms|locations|blog) echo page ;;
    *-phone-psychic) echo location ;;
    burbank-*) echo burbank ;;
    glendale-*|north-hollywood-*|toluca-lake-*|universal-city-*|sun-valley-*) echo city-services ;;
    arcana-*|*-tarot-card-meaning|*-tarot-card-meaning-*) echo tarot ;;
    whos-*|what-*|how-*|why-*|when-*) echo post ;;
    psychic|astrologer|numerologist|fortune-telling-services) echo category ;;
    *) echo service ;;
  esac
}

priority_for() {
  local slug="$1" bucket="$2"
  case "$slug" in
    index) echo "1.0"; return ;;
    burbank-phone-psychic) echo "0.95"; return ;;
  esac
  case "$bucket" in
    page) case "$slug" in
            locations|blog) echo "0.7" ;;
            about) echo "0.6" ;;
            contact) echo "0.5" ;;
            privacy|terms) echo "0.3" ;;
            *) echo "0.6" ;;
          esac ;;
    category) echo "0.9" ;;
    service) echo "0.85" ;;
    location) echo "0.8" ;;
    burbank) case "$slug" in
               burbank-psychic|burbank-astrologer|burbank-numerologist|burbank-fortune-telling-services) echo "0.85" ;;
               *) echo "0.75" ;;
             esac ;;
    city-services) case "$slug" in
                     *-psychic|*-astrologer|*-numerologist|*-fortune-telling-services) echo "0.7" ;;
                     *) echo "0.6" ;;
                   esac ;;
    tarot) echo "0.5" ;;
    post) echo "0.6" ;;
    *) echo "0.5" ;;
  esac
}

changefreq_for() {
  local slug="$1" bucket="$2"
  case "$slug" in
    index|burbank-phone-psychic) echo "weekly"; return ;;
    locations|blog) echo "weekly"; return ;;
    privacy|terms) echo "yearly"; return ;;
  esac
  case "$bucket" in
    category|service) echo "weekly" ;;
    *) echo "monthly" ;;
  esac
}

lastmod_for() {
  local f="$1" d
  d=$(git log -1 --format=%cd --date=short -- "$f" 2>/dev/null || true)
  [ -z "$d" ] && d=$(date -r "$f" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)
  echo "$d"
}

write_url_entry() {
  local f="$1" out="$2" slug bucket loc lastmod priority changefreq
  slug="${f%.html}"
  bucket=$(classify "$f")
  if [ "$slug" = "index" ]; then loc="${BASE}/"; else loc="${BASE}/${f}"; fi
  lastmod=$(lastmod_for "$f")
  priority=$(priority_for "$slug" "$bucket")
  changefreq=$(changefreq_for "$slug" "$bucket")
  {
    echo "  <url>"
    echo "    <loc>${loc}</loc>"
    echo "    <lastmod>${lastmod}</lastmod>"
    echo "    <changefreq>${changefreq}</changefreq>"
    echo "    <priority>${priority}</priority>"
    echo "  </url>"
  } >> "$out"
}

# --- 1. Pass over all .html files, bucket them, write each sub-sitemap ---
declare -A BUCKET_FILE
BUCKET_FILE[page]="page-sitemap.xml"
BUCKET_FILE[category]="category-sitemap.xml"
BUCKET_FILE[service]="service-sitemap.xml"
BUCKET_FILE[location]="location-sitemap.xml"
BUCKET_FILE[burbank]="burbank-sitemap.xml"
BUCKET_FILE[city-services]="city-services-sitemap.xml"
BUCKET_FILE[tarot]="tarot-sitemap.xml"
BUCKET_FILE[post]="post-sitemap.xml"

# Initialize each sub-sitemap with the XML header
for b in "${!BUCKET_FILE[@]}"; do
  out="${BUCKET_FILE[$b]}"
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  } > "$out"
done

declare -A BUCKET_COUNT
declare -A BUCKET_LASTMOD

for f in *.html; do
  bucket=$(classify "$f")
  [ "$bucket" = "skip" ] && continue
  out="${BUCKET_FILE[$bucket]}"
  if [ -z "$out" ]; then
    echo "warn: no bucket file for $f (bucket=$bucket)" >&2
    continue
  fi
  write_url_entry "$f" "$out"
  BUCKET_COUNT[$bucket]=$(( ${BUCKET_COUNT[$bucket]:-0} + 1 ))
  # Track max lastmod per bucket
  lm=$(lastmod_for "$f")
  cur="${BUCKET_LASTMOD[$bucket]:-0000-00-00}"
  [[ "$lm" > "$cur" ]] && BUCKET_LASTMOD[$bucket]="$lm"
done

# Close each sub-sitemap
for b in "${!BUCKET_FILE[@]}"; do
  out="${BUCKET_FILE[$b]}"
  echo '</urlset>' >> "$out"
done

# --- 2. Master sitemap_index.xml referencing every sub-sitemap ---
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
} > sitemap_index.xml

# Order: pages -> categories -> services -> locations -> burbank -> city-services -> tarot -> posts
for b in page category service location burbank city-services tarot post; do
  out="${BUCKET_FILE[$b]}"
  count="${BUCKET_COUNT[$b]:-0}"
  [ "$count" -eq 0 ] && continue
  lastmod="${BUCKET_LASTMOD[$b]:-$(date +%Y-%m-%d)}"
  {
    echo "  <sitemap>"
    echo "    <loc>${BASE}/${out}</loc>"
    echo "    <lastmod>${lastmod}</lastmod>"
    echo "  </sitemap>"
  } >> sitemap_index.xml
done

echo '</sitemapindex>' >> sitemap_index.xml

# --- 3. Drop the old singular sitemap.xml; redirect to sitemap_index.xml ---
rm -f sitemap.xml

# --- 4. robots.txt advertises sitemap_index.xml ---
cat > robots.txt <<EOF
User-agent: *
Allow: /

Sitemap: ${BASE}/sitemap_index.xml
EOF

# --- 5. Add a 301 redirect from /sitemap.xml -> /sitemap_index.xml (idempotent) ---
if ! grep -q '^/sitemap\.xml ' _redirects 2>/dev/null; then
  printf '\n# --- Sitemap consolidation: old singular -> new Yoast-style index ---\n/sitemap.xml      /sitemap_index.xml      301\n' >> _redirects
fi

# --- Summary ---
echo "--- sitemap_index.xml + sub-sitemaps written ---"
total=0
for b in page category service location burbank city-services tarot post; do
  c="${BUCKET_COUNT[$b]:-0}"
  total=$((total + c))
  printf "  %-22s %4d URLs   lastmod=%s\n" "${BUCKET_FILE[$b]}" "$c" "${BUCKET_LASTMOD[$b]:-n/a}"
done
echo "  ---------------------------"
printf "  %-22s %4d URLs total across %d sub-sitemaps\n" "TOTAL" "$total" "${#BUCKET_FILE[@]}"
echo "  master: sitemap_index.xml -> ${BASE}/sitemap_index.xml"
echo "  robots: ${BASE}/robots.txt"
echo "  redirect: /sitemap.xml -> /sitemap_index.xml (301)"
