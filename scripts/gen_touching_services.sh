#!/usr/bin/env bash
# Phase B-1: generate per-city service pages for cities touching Burbank.
# Reuses each Burbank service body (scripts/bodies/burbank-*.html), applies
# a per-city sed substitution map (Burbank -> City, plus city-specific
# landmarks/streets), wraps in the service-area shell (loc_shell_sa.tpl).
# Schema = Service with provider linked to the Burbank LocalBusiness; no
# street address; map embed is of the target city.
set -euo pipefail
cd "$(dirname "$0")/.."

S=src
TPL_FILE=scripts/loc_shell_sa.tpl
BD=scripts/bodies

# Burbank service data lives in gen_burbank_localized.sh heredoc
awk "/<<'DATA'/{f=1;next} /^DATA\$/{f=0} f" scripts/gen_burbank_localized.sh > /tmp/svc_data.txt
echo "service rows: $(wc -l < /tmp/svc_data.txt)"

build_city_services() {
  local CITY_SLUG="$1" CITY="$2" STATE="$3" COUNTY="$4"
  local HOODS="$5" ZIPS="$6"
  local HOOD="$7" ALT_HOOD="$8" STREET="$9" LANDMARK_HUB="${10}"
  local STUDIO_REF="${11}" HILLS_REF="${12}"
  local CITY_URL; CITY_URL="$(echo "$CITY" | sed 's/ /+/g; s/ñ/n/g')"
  local CITY_L; CITY_L="$(echo "$CITY" | tr '[:upper:]' '[:lower:]')"

  local count=0
  while IFS='|' read -r B_SLUG SVC SVCL CAT B_CATSLUG; do
    [ -z "${B_SLUG:-}" ] && continue
    local SUFFIX="${B_SLUG#burbank-}"
    local OUT_SLUG="${CITY_SLUG}-${SUFFIX}"
    local CAT_SUFFIX="${B_CATSLUG#burbank-}"
    local BODY_FILE="$BD/$B_SLUG.html"
    if [ ! -f "$BODY_FILE" ]; then
      echo "  skip $OUT_SLUG (no body: $BODY_FILE)"
      continue
    fi

    # Localize body via sed substitutions
    sed \
      -e "s/Burbank/$CITY/g" \
      -e "s/Magnolia Park/$HOOD/g" \
      -e "s/the Rancho Equestrian District/$ALT_HOOD/g" \
      -e "s/the Rancho/$ALT_HOOD/g" \
      -e "s/Olive Avenue/$STREET/g" \
      -e "s|the Burbank Town Center|$LANDMARK_HUB|g" \
      -e "s|the Town Center|$LANDMARK_HUB|g" \
      -e "s|the Media District by Warner Bros\\. and Disney|$STUDIO_REF|g" \
      -e "s|Warner Bros\\. and Disney|$STUDIO_REF|g" \
      -e "s/DeBell Golf Club/$HILLS_REF/g" \
      "$BODY_FILE" > /tmp/locbody.html

    # Compose tokens
    local TITLE="${SVC} in ${CITY}, ${STATE} | Live by Phone 24/7 from \$1/Min"
    local DESC="A ${SVCL} in ${CITY}, ${STATE} by phone - hand-vetted readers 24/7 across ${CITY}. First minute \$1, 15 minutes for \$10, hang up anytime."
    local KW="${SVCL} ${CITY_L}, phone ${SVCL} ${CITY_L}, psychic ${CITY_L}"
    local LEDE="A <strong>${SVCL} in ${CITY}</strong> by phone - hand-vetted readers, 24/7. Connect in under 60 seconds. Your first minute is \$1 and you can hang up anytime."

    # Substitute tokens into the shell template
    local page; page="$(cat "$TPL_FILE")"
    page="${page//@@SLUG@@/$OUT_SLUG}"
    page="${page//@@CITY_SLUG@@/$CITY_SLUG}"
    page="${page//@@CITY_URL@@/$CITY_URL}"
    page="${page//@@CITY_L@@/$CITY_L}"
    page="${page//@@CITY@@/$CITY}"
    page="${page//@@STATE@@/$STATE}"
    page="${page//@@COUNTY@@/$COUNTY}"
    page="${page//@@CAT_SLUG@@/$CAT_SUFFIX}"
    page="${page//@@CAT@@/$CAT}"
    page="${page//@@SVCL@@/$SVCL}"
    page="${page//@@SVC@@/$SVC}"
    page="${page//@@TITLE@@/$TITLE}"
    page="${page//@@DESC@@/$DESC}"
    page="${page//@@KEYWORDS@@/$KW}"
    page="${page//@@LEDE@@/$LEDE}"
    page="${page//@@HOODS@@/$HOODS}"
    page="${page//@@ZIPS@@/$ZIPS}"

    # Inject localized body at @@BODY@@
    awk -v bf=/tmp/locbody.html '/@@BODY@@/{while((getline L<bf)>0)print L; close(bf); next}{print}' <<< "$page" > "$S/$OUT_SLUG.html"
    count=$((count+1))
  done < /tmp/svc_data.txt
  echo "  -> $CITY_SLUG: $count service pages"
}

# --- Per-city builds (data + sed substitution map) ---

build_city_services glendale "Glendale" "CA" "Los Angeles County, California" \
  "Adams Hill, Glenoaks Canyon, Verdugo Woodlands, Sparr Heights, Northwest Glendale, and the Galleria area" \
  "91201, 91202, 91203, 91204, 91205, 91206, 91207, 91208, 91214" \
  "Adams Hill" "Verdugo Woodlands" "Brand Boulevard" "the Glendale Galleria" \
  "the studios nearby" "the Verdugo Mountains"

build_city_services north-hollywood "North Hollywood" "CA" "Los Angeles, California" \
  "the NoHo Arts District, Toluca Woods, the Valley Village edge, Studio Village, and the Lankershim corridor" \
  "91601, 91602, 91605, 91606" \
  "the NoHo Arts District" "Toluca Woods" "Lankershim Boulevard" "the NoHo Arts District" \
  "Universal Studios next door" "the Hollywood Hills"

build_city_services toluca-lake "Toluca Lake" "CA" "Los Angeles, California" \
  "the lake area, Toluca Woods, and the Riverside Drive corridor" \
  "91602" \
  "the lake area" "Toluca Woods" "Riverside Drive" "the village" \
  "Warner Bros. and Disney next door" "the Cahuenga Pass"

build_city_services universal-city "Universal City" "CA" "Los Angeles County, California" \
  "the studios district and the Cahuenga Pass approach" \
  "91608" \
  "the studios side" "the CityWalk area" "Lankershim Boulevard" "CityWalk" \
  "Universal Studios next door" "the Cahuenga Pass"

build_city_services sun-valley "Sun Valley" "CA" "Los Angeles, California" \
  "Stonehurst, the Pendleton Park area, the Sunland edge, and the Burbank Boulevard corridor" \
  "91352" \
  "Stonehurst" "the Pendleton Park area" "Sunland Boulevard" "the Vineland corridor" \
  "the studios next door" "Hansen Dam Recreation Area"

# --- Build site ---
bash build.sh > /tmp/bldtsvc.log 2>&1
tail -1 /tmp/bldtsvc.log

# --- Verify ---
echo "--- spot check ---"
for SLUG in glendale-clairvoyant-reading north-hollywood-love-tarot-reading toluca-lake-aura-reading universal-city-numerology-reading sun-valley-soulmate-reading; do
  if [ -f "$SLUG.html" ]; then
    echo "  ok: $SLUG.html (title: $(grep -m1 -oE '<title>[^<]*</title>' $SLUG.html))"
  else
    echo "  MISSING $SLUG.html"
  fi
done
echo "no Burbank street (want 0): $(grep -l '365 W Alameda' glendale-* north-hollywood-* toluca-lake-* universal-city-* sun-valley-* 2>/dev/null | grep -v 'phone-psychic\.html$' | wc -l)"
echo "city map embeds on glendale services (want >0): $(grep -lc 'maps.google.com/maps?q=Glendale' glendale-clairvoyant-reading.html glendale-aura-reading.html glendale-love-tarot-reading.html | awk -F: '{s+=$2}END{print s}')"

# --- Commit + push ---
git add -A
git commit -q -m "Phase B-1: per-city service pages for cities touching Burbank

5 touching cities x ~45 services = ~225 new city-localized service
pages. Each: Service schema with provider linked to Burbank
LocalBusiness via @id (no street address, no Burbank business map),
city-localized hero/lede/title/breadcrumb, offer block, geo content
keyed to that city (neighborhoods, ZIPs), city map embed, and body
content adapted from the matching Burbank body file via sed
substitution (Burbank->City, plus city-specific landmarks, streets,
and neighborhood references).

Service slugs: {city-slug}-{service-suffix}.html e.g.
glendale-clairvoyant-reading.html, north-hollywood-love-tarot-reading.html.

Phase B-2 (next): update each touching city's 4 GBP category page
service grids to link these new localized service pages instead of
the national hubs. Also: city-localized body for the standalone
psychic-reading service (currently no Burbank body file exists for
the hand-written exemplar, so it was skipped this batch)."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
