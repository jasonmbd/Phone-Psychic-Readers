#!/usr/bin/env bash
# Fix: touching-city category pages were linking only a SUBSET of their
# services (rewire_touching_silos.sh only rewrote existing hrefs, it never
# added the missing ones), orphaning 26 service pages per city (130 total).
#
# This lifts each COMPLETE Burbank category service-grid into the matching
# touching-city category page, swapping burbank- -> {city}- in hrefs and
# "Burbank" -> "{City}" in the card text. Burbank's 4 grids collectively
# link all 45 services (0 orphans), so each city now does too.
#
# Idempotent: re-running reproduces the same complete grids. Edits src/;
# build.sh regenerates the root pages from src/.
set -euo pipefail
cd "$(dirname "$0")/.."
S=src

TOUCHING="glendale north-hollywood toluca-lake universal-city sun-valley"
CATS="psychic astrologer numerologist fortune-telling-services"

disp() {
  case "$1" in
    glendale) echo "Glendale" ;;
    north-hollywood) echo "North Hollywood" ;;
    toluca-lake) echo "Toluca Lake" ;;
    universal-city) echo "Universal City" ;;
    sun-valley) echo "Sun Valley" ;;
  esac
}

for CITY in $TOUCHING; do
  CITYNAME="$(disp "$CITY")"
  echo "--- $CITY ($CITYNAME) ---"
  for CAT in $CATS; do
    SRCB="$S/burbank-${CAT}.html"
    DSTF="$S/${CITY}-${CAT}.html"
    [ -f "$SRCB" ] || { echo "ERROR missing $SRCB"; exit 1; }
    [ -f "$DSTF" ] || { echo "ERROR missing $DSTF"; exit 1; }

    GF="/tmp/grid_${CITY}_${CAT}.html"
    # Extract Burbank grid inner <li> lines, localize hrefs + card text
    awk '/<ul class="service-grid">/{g=1;next} g&&/<\/ul>/{g=0} g{print}' "$SRCB" \
      | sed -e "s/href=\"burbank-/href=\"${CITY}-/g" -e "s/Burbank/${CITYNAME}/g" > "$GF"

    # Replace the city page's existing service-grid contents with the full grid
    awk -v gf="$GF" '
      /<ul class="service-grid">/{print; while((getline L<gf)>0) print L; close(gf); skip=1; next}
      skip && /<\/ul>/{print; skip=0; next}
      skip{next}
      {print}
    ' "$DSTF" > "$DSTF.tmp" && mv "$DSTF.tmp" "$DSTF"

    n=$(grep -oE "href=\"${CITY}-[a-z0-9-]+\.html\"" "$DSTF" | sort -u | wc -l)
    echo "  ${CITY}-${CAT}: $n unique city service links"
  done
done

echo
echo "Rebuilding..."
bash build.sh > /tmp/bldfix.log 2>&1
tail -1 /tmp/bldfix.log
