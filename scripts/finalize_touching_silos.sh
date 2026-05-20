#!/usr/bin/env bash
# Phase B-3: final pass to fully city-localize the touching-city silos.
# Two remaining gaps:
#  (a) Landing pages "Most-requested in {City}" line still points to
#      national hubs (psychic-love-readings-by-phone, phone-tarot-reading,
#      psychic-reading) because those slugs don't have Burbank bodies and
#      so weren't auto-rewired.
#  (b) Two stray national-only hub hrefs in category pages
#      (psychic-love-readings-by-phone, psychic-reading) for the same
#      reason.
# Substitution map (national-hub -> closest existing city service):
#   psychic-love-readings-by-phone -> {city}-love-tarot-reading
#   psychic-reading                -> {city}-clairvoyant-reading
#   phone-tarot-reading            -> {city}-phone-tarot-reading (file
#                                      already exists per city)
set -euo pipefail
cd "$(dirname "$0")/.."

TOUCHING=(glendale north-hollywood toluca-lake universal-city sun-valley)

# Pretty service labels per city (for the Most-requested line)
NEW_MOST_REQUESTED_TPL='<p>Most-requested in @@CITY@@: <a href="@@CITY_SLUG@@-love-tarot-reading.html">Love Tarot Reading</a> &middot; <a href="@@CITY_SLUG@@-phone-tarot-reading.html">Phone Tarot Reading</a> &middot; <a href="@@CITY_SLUG@@-clairvoyant-reading.html">Clairvoyant Psychic Reading</a></p>'

# City -> display-name map (proper capitalization)
declare -A CITY_NAME=(
  [glendale]="Glendale"
  [north-hollywood]="North Hollywood"
  [toluca-lake]="Toluca Lake"
  [universal-city]="Universal City"
  [sun-valley]="Sun Valley"
)

for CITY_SLUG in "${TOUCHING[@]}"; do
  CITY="${CITY_NAME[$CITY_SLUG]}"
  echo "--- $CITY_SLUG / $CITY ---"

  # --- (a) Rewrite Most-requested line in src/landing ---
  LANDING="src/${CITY_SLUG}-phone-psychic.html"
  if [ -f "$LANDING" ]; then
    NEW_LINE="${NEW_MOST_REQUESTED_TPL//@@CITY@@/$CITY}"
    NEW_LINE="${NEW_LINE//@@CITY_SLUG@@/$CITY_SLUG}"
    INDENTED="          $NEW_LINE"
    # awk-replace any line containing "Most-requested in" with the new line
    awk -v repl="$INDENTED" '/Most-requested in/{print repl; next} {print}' "$LANDING" > "$LANDING.tmp" && mv "$LANDING.tmp" "$LANDING"
    if grep -q "${CITY_SLUG}-love-tarot-reading\.html\"" "$LANDING"; then
      echo "  rewrote Most-requested line in $LANDING"
    else
      echo "  WARNING: Most-requested rewrite did not land in $LANDING"
    fi
  fi

  # --- (b) Rewrite 2 stray national-only hrefs in category + landing ---
  for F in "src/${CITY_SLUG}-psychic.html" "src/${CITY_SLUG}-astrologer.html" "src/${CITY_SLUG}-numerologist.html" "src/${CITY_SLUG}-fortune-telling-services.html" "$LANDING"; do
    [ -f "$F" ] || continue
    BEFORE=$( { grep -oE 'href="(psychic-love-readings-by-phone|psychic-reading)\.html"' "$F" 2>/dev/null || true; } | wc -l)
    sed -i \
      -e "s|href=\"psychic-love-readings-by-phone\.html\"|href=\"${CITY_SLUG}-love-tarot-reading.html\"|g" \
      -e "s|href=\"psychic-reading\.html\"|href=\"${CITY_SLUG}-clairvoyant-reading.html\"|g" \
      "$F"
    AFTER=$( { grep -oE 'href="(psychic-love-readings-by-phone|psychic-reading)\.html"' "$F" 2>/dev/null || true; } | wc -l)
    echo "  $F: substituted $((BEFORE - AFTER)) national-hub href(s)"
  done
done

# --- Build ---
bash build.sh > /tmp/bldfinal.log 2>&1
tail -1 /tmp/bldfinal.log

# --- Verify ---
echo "--- verify Most-requested line is now city-specific ---"
for c in "${TOUCHING[@]}"; do
  echo "  $c: $(grep -o 'Most-requested in [^<]*' "${c}-phone-psychic.html" | head -1)"
done
echo "--- verify zero stray national-only refs in touching-city category pages ---"
for c in "${TOUCHING[@]}"; do
  for cat in psychic astrologer numerologist fortune-telling-services; do
    F="${c}-${cat}.html"
    STRAY=$(grep -cE 'href="(psychic-love-readings-by-phone|psychic-reading)\.html"' "$F" 2>/dev/null || echo 0)
    [ "$STRAY" != "0" ] && echo "  STRAY in $F: $STRAY"
  done
done
echo "  (no STRAY lines above = clean)"

# --- Commit + push ---
git add -A
git commit -q -m "Phase B-3: finalize touching-city silos - city-specific Most-requested

Two final gaps closed for each of the 5 touching cities:
1. Landing page Most-requested in {City} line now links to that city's
   own love-tarot-reading, phone-tarot-reading, and clairvoyant-reading
   service pages (previously pointed to the national hubs because the
   slugs psychic-love-readings-by-phone and psychic-reading don't have
   Burbank body files and so were skipped by the auto-rewire).
2. The 2 stray national-only category-page hrefs
   (psychic-love-readings-by-phone, psychic-reading) are now substituted
   with the closest existing city service: love-tarot-reading and
   clairvoyant-reading respectively. Per city.

Net effect: every internal link in a touching-city silo (landing ->
categories -> services) now stays inside that city. Same self-contained
hierarchy Burbank already uses. Global nav links in the header stay
national by design (header is a shared partial)."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
