#!/usr/bin/env bash
# Bring every service-area city page to Burbank-landing parity:
#  - Offer block right after hero ("Your First {City} Call ...")
#  - Critical-service line in intro
#  - Geo-modified GBP category H2s ({City} Psychic, etc.)
#  - Map embed of the city itself (no business NAP, no street address)
# Updates scripts/city.tpl + scripts/gen_city_pages.sh and regenerates all
# 32 city pages.
set -euo pipefail
cd "$(dirname "$0")/.."

# --- 1. Offer block snippet (uses {{CITY}} which is substituted at gen-time) ---
cat > /tmp/cityoffer.html <<'EOF'

  <section class="offer-card section-soft" aria-label="Your First {{CITY}} Call offer" style="padding-top:1.5rem; padding-bottom:1.5rem;">
    <div class="container" style="max-width: 860px; text-align: center;">
      <p style="font-size:0.85rem; letter-spacing:0.08em; text-transform:uppercase; margin:0 0 0.5rem; color:var(--ink-soft);">Your First {{CITY}} Call</p>
      <p style="font-size:1.05rem; margin:0 0 0.5rem;"><strong>1 minute $1</strong> &middot; <strong>15 minutes $10</strong> &middot; Hang up anytime &middot; 100% satisfaction promise</p>
      <p style="margin:0 0 1rem; font-size:0.95rem;"><span aria-hidden="true" style="color:#1aab4a;">&#9679;</span> Hand-vetted readers available right now. Typical connection in under 60 seconds.</p>
      <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
    </div>
  </section>
EOF

# --- 2. City-map snippet (no NAP, just an iframe map of the city) ---
cat > /tmp/citymap.html <<'EOF'

  <section class="section-soft">
    <div class="container" style="max-width: 860px;">
      <h2>The {{CITY}} Area We Serve by Phone</h2>
      <p>This is a phone service - no in-person visits in {{CITY}}. Here is the {{CITY}} area we cover, 24/7, from anywhere a phone has signal.</p>
      <div class="map-embed">
        <iframe src="https://maps.google.com/maps?q={{CITY_URL}},+{{STATE}}&amp;z=12&amp;output=embed" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="Map of {{CITY}}, {{STATE}}"></iframe>
      </div>
    </div>
  </section>
EOF

# --- 3. Insert offer block right after hero close ---
awk -v off=/tmp/cityoffer.html '
  /<section class="hero/{inhero=1}
  {print}
  inhero && /<\/section>/ && !done {while((getline L<off)>0) print L; close(off); done=1; inhero=0}
' scripts/city.tpl > /tmp/t && mv /tmp/t scripts/city.tpl

# --- 4. Geo-modify the four GBP category H2 anchors ---
sed -i \
  -e 's|<h2><a href="psychic.html">Psychic</a></h2>|<h2><a href="psychic.html">{{CITY}} Psychic</a></h2>|' \
  -e 's|<h2><a href="astrologer.html">Astrologer</a></h2>|<h2><a href="astrologer.html">{{CITY}} Astrologer</a></h2>|' \
  -e 's|<h2><a href="numerologist.html">Numerologist</a></h2>|<h2><a href="numerologist.html">{{CITY}} Numerologist</a></h2>|' \
  -e 's|<h2><a href="fortune-telling-services.html">Fortune Telling Services</a></h2>|<h2><a href="fortune-telling-services.html">{{CITY}} Fortune Telling Services</a></h2>|' \
  scripts/city.tpl

# --- 5. Add a "Most-requested in {City}" line into the intro paragraph block
#     (inserted before the existing intro CTA button line) ---
awk '
  /<p><a class="btn btn-primary" href="tel:\+18889206662">Call \(888\) 920-6662 now<\/a><\/p>/ && !done {
    print "          <p>Most-requested in {{CITY}}: <a href=\"psychic-love-readings-by-phone.html\">Love Psychic Reading</a> &middot; <a href=\"phone-tarot-reading.html\">Tarot Card Reading</a> &middot; <a href=\"psychic-reading.html\">Psychic Reading</a></p>"
    done=1
  }
  {print}
' scripts/city.tpl > /tmp/t && mv /tmp/t scripts/city.tpl

# --- 6. Insert city-map section right before the final cta-band ---
awk -v mp=/tmp/citymap.html '
  /<section class="cta-band">/ && !done {while((getline L<mp)>0) print L; close(mp); done=1}
  {print}
' scripts/city.tpl > /tmp/t && mv /tmp/t scripts/city.tpl

# --- 7. Add CITY_URL computation + substitution to gen_city_pages.sh ---
# Add CITY_URL computation right after STATE_L line:
if ! grep -q 'CITY_URL=' scripts/gen_city_pages.sh; then
  sed -i '/STATE_L="$(echo "$STATE"/a\  CITY_URL="$(echo "$CITY" | sed '"'"'s/ /+/g; s/ñ/n/g; s/Ñ/N/g'"'"')"' scripts/gen_city_pages.sh
fi
# Add substitution line for {{CITY_URL}} after the {{STATE_L}} substitution:
if ! grep -q '\\{\\{CITY_URL\\}\\}' scripts/gen_city_pages.sh; then
  sed -i '/page="${page\/\/\\{\\{STATE_L\\}\\}\/\$STATE_L}"/a\  page="${page//\\{\\{CITY_URL\\}\\}/$CITY_URL}"' scripts/gen_city_pages.sh
fi

echo "--- generator now defines CITY_URL: $(grep -c 'CITY_URL=' scripts/gen_city_pages.sh) ---"
echo "--- generator subs {{CITY_URL}}: $(grep -c 'CITY_URL\\}' scripts/gen_city_pages.sh) ---"

# --- 8. Regenerate all city pages ---
bash scripts/gen_city_pages.sh 2>&1 | tail -2

# --- 9. Build site ---
bash build.sh > /tmp/bldcityup.log 2>&1
tail -1 /tmp/bldcityup.log

# --- 10. Verify ---
NEW=$(ls *-phone-psychic.html | grep -v '^burbank-')
COUNT=$(echo "$NEW" | wc -l)
echo "--- city pages (non-Burbank): $COUNT ---"
echo "with offer block: $(echo "$NEW" | xargs grep -l 'Your First.*Call offer' 2>/dev/null | wc -l)"
echo "with city map embed: $(echo "$NEW" | xargs grep -l 'maps.google.com/maps?q=' 2>/dev/null | wc -l)"
echo "with critical services line: $(echo "$NEW" | xargs grep -l 'Most-requested in' 2>/dev/null | wc -l)"
echo "sample geo-modified H2 (Glendale Psychic): $(grep -c 'Glendale Psychic</a></h2>' glendale-phone-psychic.html)"
echo "sample geo-modified H2 (Hollywood Astrologer): $(grep -c 'Hollywood Astrologer</a></h2>' hollywood-phone-psychic.html)"
echo "no Burbank street (want 0): $(echo "$NEW" | xargs grep -l '365 W Alameda' 2>/dev/null | wc -l)"
echo "no gmail (want 0): $(echo "$NEW" | xargs grep -l 'phonepsychicreaders@gmail' 2>/dev/null | wc -l)"

# --- 11. Commit + push ---
git add -A
git commit -q -m "Upgrade all 32 service-area city pages to Burbank-landing parity

Each non-Burbank city page now has:
- Offer block: Your First {City} Call (1 min \$1, 15 min \$10, hang
  up anytime, 100% satisfaction promise) + green-dot live-availability
- Most-requested in {City} critical-service callout in the intro
- Geo-modified GBP category H2s: {City} Psychic, {City} Astrologer,
  {City} Numerologist, {City} Fortune Telling Services (links still
  to national hubs - per-city category/service silos are a later
  phase per scope)
- Map embed of the city itself near the end of the page (Google Maps
  no-API-key embed keyed to city + state)

No street address, no email, no Burbank business map - GBP NAP is
Burbank only. Schema stays Service with provider linked back to
the Burbank LocalBusiness via @id. Affects all 32 cities (16 Phase-1
recovery + 16 Burbank neighbors)."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
