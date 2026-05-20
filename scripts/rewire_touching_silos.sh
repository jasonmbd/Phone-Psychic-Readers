#!/usr/bin/env bash
# Phase B-2: rewire each touching city's internal silo so it mirrors Burbank.
# For each of the 5 touching cities, every category page service grid + each
# landing page "Most-requested in {City}" line is rewritten so links that
# previously pointed to a national hub (e.g. clairvoyant-reading.html) now
# point to the city-specific version (glendale-clairvoyant-reading.html) -
# but ONLY when that city-prefixed file actually exists. Global pages
# (about.html, contact.html, index.html, locations.html, privacy.html,
# terms.html, blog.html) and the city's own landing/category pages are
# left alone.
set -euo pipefail
cd "$(dirname "$0")/.."

TOUCHING=(glendale north-hollywood toluca-lake universal-city sun-valley)

rewire_one_file() {
  local CITY="$1" FILE="$2"
  # Find every href="X.html" in the file, where X is a plain slug (no "/", no http)
  # If a file ${CITY}-${X}.html exists in src/ AND X does not already start with ${CITY}-
  # AND X is not a global/system page, rewrite href="X.html" -> href="${CITY}-X.html"
  local hrefs
  hrefs=$(grep -oE 'href="[a-z0-9-]+\.html"' "$FILE" | sort -u || true)
  local changed=0
  while IFS= read -r h; do
    [ -z "$h" ] && continue
    local slug="${h#href=\"}"; slug="${slug%.html\"}"
    # skip global/system pages
    case "$slug" in
      about|blog|contact|index|locations|privacy|terms|404|sitemap) continue ;;
    esac
    # skip if already city-prefixed
    case "$slug" in
      ${CITY}-*) continue ;;
    esac
    # only rewire if the city-prefixed file exists in src/
    if [ -f "src/${CITY}-${slug}.html" ]; then
      sed -i "s|href=\"${slug}\.html\"|href=\"${CITY}-${slug}.html\"|g" "$FILE"
      changed=$((changed+1))
    fi
  done <<< "$hrefs"
  echo "  $FILE: rewired $changed link(s)"
}

for CITY in "${TOUCHING[@]}"; do
  echo "--- $CITY ---"
  # 4 category pages + 1 landing, all in src/
  for CAT in psychic astrologer numerologist fortune-telling-services; do
    F="src/${CITY}-${CAT}.html"
    [ -f "$F" ] && rewire_one_file "$CITY" "$F"
  done
  LF="src/${CITY}-phone-psychic.html"
  [ -f "$LF" ] && rewire_one_file "$CITY" "$LF"
done

# --- Build + verify ---
bash build.sh > /tmp/bldrewire.log 2>&1
tail -1 /tmp/bldrewire.log

echo "--- verify glendale-psychic.html ---"
echo "  glendale-prefixed hrefs (want many): $(grep -oE 'href="glendale-[a-z-]+\.html"' glendale-psychic.html | sort -u | wc -l)"
echo "  remaining national-hub hrefs in service grid (want low): $(grep -oE 'href="(clairvoyant-reading|aura-reading|career-psychic-reading|daily-horoscope-reading|energy-healing|intuitive-psychic-reading|past-life-psychic-readings-by-phone|phone-tarot-reading|relationship-psychic-reading)\.html"' glendale-psychic.html | wc -l)"
echo "--- verify glendale landing Most-requested line ---"
grep -i 'Most-requested in Glendale' glendale-phone-psychic.html | head -1

echo "--- verify all 5 cities' category pages now link city-prefixed ---"
for CITY in "${TOUCHING[@]}"; do
  for CAT in psychic astrologer numerologist fortune-telling-services; do
    F="${CITY}-${CAT}.html"
    if [ -f "$F" ]; then
      PREFIXED=$(grep -oE "href=\"${CITY}-[a-z-]+\.html\"" "$F" | sort -u | wc -l)
      echo "  $F: $PREFIXED ${CITY}-prefixed hrefs"
    fi
  done
done

# --- Commit + push ---
git add -A
git commit -q -m "Phase B-2: rewire touching cities' internal silos to mirror Burbank

For each of the 5 cities touching Burbank (Glendale, North Hollywood,
Toluca Lake, Universal City, Sun Valley): every category page service
grid + landing page Most-requested line now links to that city's own
service pages (e.g. glendale-clairvoyant-reading.html) instead of the
national hubs (clairvoyant-reading.html). Same pattern Burbank already
uses internally - each touching city now has a self-contained Core 30
silo where landing -> categories -> services all stay city-specific.

Rewire is idempotent and only swaps links where the city-prefixed file
actually exists. Global pages (about, contact, index, locations,
privacy, terms, blog) and already-city-prefixed links are skipped.
Non-touching cities (the other 27) are intentionally untouched - per
prior scope, only cities physically bordering Burbank get the deep
silo treatment."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
