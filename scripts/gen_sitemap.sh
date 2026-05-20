#!/usr/bin/env bash
# Generate sitemap.xml from every *.html in the repo root.
# - Excludes 404.html (error pages shouldn't be indexed)
# - Excludes any .html that is a directory artifact (none expected)
# - Computes per-page priority and changefreq from the URL pattern
# - lastmod = file mtime in ISO 8601 (YYYY-MM-DD)
# - Writes sitemap.xml at repo root so it's served at the conventional
#   /sitemap.xml URL and Netlify uploads it on deploy.
# Also writes/updates robots.txt to advertise the sitemap.
set -euo pipefail
cd "$(dirname "$0")/.."

BASE="https://www.phonepsychicreaders.com"
OUT="sitemap.xml"
ROBOTS="robots.txt"

priority_for() {
  local slug="$1"
  case "$slug" in
    index)                                            echo "1.0" ;;
    burbank-phone-psychic)                            echo "0.95" ;;
    psychic|astrologer|numerologist|fortune-telling-services) echo "0.9" ;;
    psychic-reading|psychic-love-readings-by-phone|phone-tarot-reading|horoscope-astrology-psychic-readings-by-phone|clairvoyant-reading) echo "0.9" ;;
    burbank-psychic|burbank-astrologer|burbank-numerologist|burbank-fortune-telling-services) echo "0.85" ;;
    burbank-*)                                        echo "0.75" ;;
    *-phone-psychic)                                  echo "0.8" ;;
    glendale-psychic|glendale-astrologer|glendale-numerologist|glendale-fortune-telling-services|\
    north-hollywood-psychic|north-hollywood-astrologer|north-hollywood-numerologist|north-hollywood-fortune-telling-services|\
    toluca-lake-psychic|toluca-lake-astrologer|toluca-lake-numerologist|toluca-lake-fortune-telling-services|\
    universal-city-psychic|universal-city-astrologer|universal-city-numerologist|universal-city-fortune-telling-services|\
    sun-valley-psychic|sun-valley-astrologer|sun-valley-numerologist|sun-valley-fortune-telling-services) echo "0.7" ;;
    glendale-*|north-hollywood-*|toluca-lake-*|universal-city-*|sun-valley-*) echo "0.6" ;;
    locations|about|blog)                             echo "0.6" ;;
    contact|privacy|terms)                            echo "0.3" ;;
    *)                                                echo "0.5" ;;
  esac
}

changefreq_for() {
  local slug="$1"
  case "$slug" in
    index)                                            echo "weekly" ;;
    burbank-phone-psychic|psychic|astrologer|numerologist|fortune-telling-services) echo "weekly" ;;
    burbank-*|*-phone-psychic)                        echo "monthly" ;;
    locations|blog)                                   echo "weekly" ;;
    privacy|terms)                                    echo "yearly" ;;
    *)                                                echo "monthly" ;;
  esac
}

# --- Header ---
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
} > "$OUT"

count=0
for f in *.html; do
  # skip the 404
  [ "$f" = "404.html" ] && continue
  slug="${f%.html}"

  # lastmod: ISO date of file mtime
  # Use git log to get the file's last commit date for stability (mtime
  # changes every rebuild). Fall back to file mtime if not yet committed.
  lastmod=$(git log -1 --format=%cd --date=short -- "$f" 2>/dev/null || true)
  [ -z "$lastmod" ] && lastmod=$(date -r "$f" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)

  # loc: homepage is bare /, all others are /slug.html
  if [ "$slug" = "index" ]; then
    loc="${BASE}/"
  else
    loc="${BASE}/${f}"
  fi

  priority=$(priority_for "$slug")
  changefreq=$(changefreq_for "$slug")

  {
    echo "  <url>"
    echo "    <loc>${loc}</loc>"
    echo "    <lastmod>${lastmod}</lastmod>"
    echo "    <changefreq>${changefreq}</changefreq>"
    echo "    <priority>${priority}</priority>"
    echo "  </url>"
  } >> "$OUT"

  count=$((count+1))
done

echo '</urlset>' >> "$OUT"

echo "wrote $OUT with $count URLs"

# --- robots.txt: write/update with sitemap line ---
cat > "$ROBOTS" <<EOF
User-agent: *
Allow: /

Sitemap: ${BASE}/sitemap.xml
EOF
echo "wrote $ROBOTS"
