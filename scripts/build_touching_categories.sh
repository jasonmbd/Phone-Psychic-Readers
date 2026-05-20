#!/usr/bin/env bash
# Phase A: generate per-city GBP category pages (4 per city) for the cities
# that physically touch Burbank's border. Mirrors Burbank's category-page
# pattern (e.g., burbank-psychic.html) but for service-area cities, so no
# street address, no email, no Burbank business map. Map embed is of THAT
# city. Service grid for now links to national service hubs; will be
# updated to city-localized services in Phase B.
set -euo pipefail
cd "$(dirname "$0")/.."

TOUCHING="glendale north-hollywood toluca-lake universal-city sun-valley"
S=src

# --- Extract city data from gen_city_pages.sh DATA block ---
awk '/^DATA$/{f=!f;next} f' scripts/gen_city_pages.sh > /tmp/city_data.txt

get_field() {
  # Data field 2 is the full slug e.g. "sun-valley-phone-psychic";
  # our $1 here is the short city slug e.g. "sun-valley".
  awk -F'|' -v slug="$1-phone-psychic" -v f="$2" '$2==slug{print $f; exit}' /tmp/city_data.txt
}

# --- Service grids per GBP category (links to national hubs for now) ---
cat > /tmp/grid_psychic.html <<'EOF'
        <li class="svc"><h3><a href="psychic-reading.html">Psychic Reading</a></h3><p>Clear, honest answers to whatever is weighing on you. First call $1/min.</p><a class="svc-more" href="psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-love-readings-by-phone.html">Love Psychic Reading</a></h3><p>Find out where your love life is really headed.</p><a class="svc-more" href="psychic-love-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="relationship-psychic-reading.html">Relationship Psychic Reading</a></h3><p>Honest insight into your relationship and where it's going.</p><a class="svc-more" href="relationship-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="career-psychic-reading.html">Career Psychic Reading</a></h3><p>Feeling stuck at work? See your next move clearly.</p><a class="svc-more" href="career-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="intuitive-psychic-reading.html">Intuitive Psychic Reading</a></h3><p>Deep intuition tuned to your energy for real, personal answers.</p><a class="svc-more" href="intuitive-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="clairvoyant-reading.html">Clairvoyant Reading</a></h3><p>See beyond the surface with a clairvoyant reading.</p><a class="svc-more" href="clairvoyant-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="aura-reading.html">Aura Reading</a></h3><p>Uncover your energetic patterns and what's blocking you.</p><a class="svc-more" href="aura-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="past-life-psychic-readings-by-phone.html">Past Life Reading</a></h3><p>Explore the lives shaping who you are today.</p><a class="svc-more" href="past-life-psychic-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="phone-tarot-reading.html">Tarot Card Reading</a></h3><p>Insightful tarot that reveals what the cards say about your path.</p><a class="svc-more" href="phone-tarot-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="dream-interpretation-psychic-readings-phone.html">Dream Interpretation</a></h3><p>Your dreams carry deeper meaning - find out what they mean.</p><a class="svc-more" href="dream-interpretation-psychic-readings-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="energy-healing.html">Energy Healing</a></h3><p>Restore balance and release what's holding you back.</p><a class="svc-more" href="energy-healing.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="daily-horoscope-reading.html">Daily Horoscope</a></h3><p>Start your day with personalized horoscope guidance.</p><a class="svc-more" href="daily-horoscope-reading.html">Learn more &rarr;</a></li>
EOF

cat > /tmp/grid_astrologer.html <<'EOF'
        <li class="svc"><h3><a href="horoscope-astrology-psychic-readings-by-phone.html">Astrology Reading</a></h3><p>Deep insight into your life's patterns through astrology.</p><a class="svc-more" href="horoscope-astrology-psychic-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="birth-chart-reading.html">Birth Chart Reading</a></h3><p>Your birth chart is a map of your potential.</p><a class="svc-more" href="birth-chart-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="birth-chart-reading.html">Natal Chart Interpretation</a></h3><p>Understand your strengths, challenges, and life purpose.</p><a class="svc-more" href="birth-chart-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="love-astrology-reading.html">Love Astrology Reading</a></h3><p>Find out what the stars reveal about your love life.</p><a class="svc-more" href="love-astrology-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="astrology-compatibility-reading.html">Relationship Astrology Compatibility</a></h3><p>Are you and your partner written in the stars?</p><a class="svc-more" href="astrology-compatibility-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="career-astrology-reading.html">Career Astrology Reading</a></h3><p>Let the planets guide your professional path.</p><a class="svc-more" href="career-astrology-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="horoscope-astrology-psychic-readings-by-phone.html">Astrology Consultation</a></h3><p>A focused consultation with answers tailored to your life.</p><a class="svc-more" href="horoscope-astrology-psychic-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-love-readings-by-phone.html">Marriage Astrology Reading</a></h3><p>Thinking about the next step? Meaningful marriage insight.</p><a class="svc-more" href="psychic-love-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="astrology-reading-near-me.html">Astrology Reading Near Me</a></h3><p>Expert astrology readings by phone, wherever you are.</p><a class="svc-more" href="astrology-reading-near-me.html">Learn more &rarr;</a></li>
EOF

cat > /tmp/grid_numerologist.html <<'EOF'
        <li class="svc"><h3><a href="numerologist.html">Numerology Reading</a></h3><p>Numbers reveal more than you think about your life.</p><a class="svc-more" href="numerologist.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="numerologist.html">Life Path Number Reading</a></h3><p>Your life path number holds the key to your purpose.</p><a class="svc-more" href="numerologist.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-love-readings-by-phone.html">Love Numerology Reading</a></h3><p>What the numbers say about your love life.</p><a class="svc-more" href="psychic-love-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="money-prosperity-psychic-readings.html">Career Numerology Reading</a></h3><p>Reveal your best professional timing through numerology.</p><a class="svc-more" href="money-prosperity-psychic-readings.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="numerologist.html">Personal Numerology Chart</a></h3><p>A personalized numerology chart created just for you.</p><a class="svc-more" href="numerologist.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="numerologist.html">Numerology Consultation</a></h3><p>A focused consultation - walk away with real clarity.</p><a class="svc-more" href="numerologist.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="numerologist.html">Numerology Guidance Session</a></h3><p>Actionable, number-based guidance for any area of life.</p><a class="svc-more" href="numerologist.html">Learn more &rarr;</a></li>
EOF

cat > /tmp/grid_fortune-telling-services.html <<'EOF'
        <li class="svc"><h3><a href="psychic-love-readings-by-phone.html">Love Psychic Reading</a></h3><p>Wondering where your love life is heading? Honest answers.</p><a class="svc-more" href="psychic-love-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="relationship-psychic-reading.html">Relationship Psychic Reading</a></h3><p>Real perspective on your relationship.</p><a class="svc-more" href="relationship-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="soulmate-reading.html">Soulmate Reading</a></h3><p>Is the right person already in your life?</p><a class="svc-more" href="soulmate-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="twin-flame-reading.html">Twin Flame Reading</a></h3><p>Explore your twin flame connection.</p><a class="svc-more" href="twin-flame-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="spiritual-guidance-reading.html">Life Path Psychic Reading</a></h3><p>Understand your purpose and direction.</p><a class="svc-more" href="spiritual-guidance-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="career-psychic-reading.html">Career Psychic Reading</a></h3><p>Feeling lost professionally? Guidance for your next step.</p><a class="svc-more" href="career-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="spiritual-guidance-reading.html">Spiritual Guidance Reading</a></h3><p>Find peace and purpose with spiritual guidance.</p><a class="svc-more" href="spiritual-guidance-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="clairvoyant-reading.html">Clairvoyant Reading</a></h3><p>Taps into unseen energy to reveal what's unfolding.</p><a class="svc-more" href="clairvoyant-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="intuitive-psychic-reading.html">Intuitive Psychic Reading</a></h3><p>Deep intuition connected to your energy for personal answers.</p><a class="svc-more" href="intuitive-psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="aura-reading.html">Aura Reading</a></h3><p>Your aura reveals your energetic state and blocks.</p><a class="svc-more" href="aura-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="energy-healing.html">Energy Healing Session</a></h3><p>Identify what's holding you back and release it.</p><a class="svc-more" href="energy-healing.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="past-life-psychic-readings-by-phone.html">Past Life Reading</a></h3><p>Discover past experiences still influencing your present.</p><a class="svc-more" href="past-life-psychic-readings-by-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="dream-interpretation-psychic-readings-phone.html">Dream Interpretation Reading</a></h3><p>Your dreams are trying to tell you something.</p><a class="svc-more" href="dream-interpretation-psychic-readings-phone.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-reading.html">Private Psychic Consultation</a></h3><p>Your reading stays completely confidential.</p><a class="svc-more" href="psychic-reading.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-reading-near-me.html">Psychic Reading Near Me</a></h3><p>A trusted phone psychic close to home, wherever you are.</p><a class="svc-more" href="psychic-reading-near-me.html">Learn more &rarr;</a></li>
        <li class="svc"><h3><a href="psychic-reading.html">Accurate Psychic Reading</a></h3><p>Clear, grounded answers with an accurate reading.</p><a class="svc-more" href="psychic-reading.html">Learn more &rarr;</a></li>
EOF

# --- Category page template ---
cat > scripts/city_category.tpl <<'TPL'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{CAT}} Services in {{CITY}}, {{STATE}} | Phone Readings 24/7 from $1/Min</title>
<meta name="description" content="Every {{CAT_L}} service by phone for {{CITY}}, {{STATE}} - hand-vetted readers 24/7 from anywhere in {{REGION}}. First call $1/min, 15 minutes for $10, hang up anytime.">
<meta name="keywords" content="{{CAT_L}} {{CITY_L}}, {{CAT_L}} services {{CITY_L}}, phone {{CAT_L}} {{CITY_L}}, psychic {{CITY_L}}">
<meta name="robots" content="index, follow">
<meta property="og:title" content="{{CAT}} Services in {{CITY}}, {{STATE}} | Phone Readings 24/7">
<meta property="og:description" content="Every phone {{CAT_L}} service for {{CITY}}, from $1/min.">
<meta property="og:type" content="website">
<meta property="og:image" content="assets/img/phone-psychic-readers-logo.png">
<link rel="canonical" href="https://www.phonepsychicreaders.com/{{CITY_SLUG}}-{{CAT_SLUG}}.html">
<link rel="icon" type="image/png" href="assets/img/phone-psychic-readers-icon.png">
<link rel="stylesheet" href="assets/css/styles.css">
<script type="application/ld+json">
{ "@context": "https://schema.org", "@type": "Service", "serviceType": "{{CAT}} by Phone", "name": "{{CAT}} Services in {{CITY}}, {{STATE}}", "url": "https://www.phonepsychicreaders.com/{{CITY_SLUG}}-{{CAT_SLUG}}.html", "image": "https://www.phonepsychicreaders.com/assets/img/phone-psychic-readers-logo.png", "description": "Live phone {{CAT_L}} services for {{CITY}}, {{STATE}}, 24/7 from $1 per minute. Delivered by phone from the Burbank, CA office; no in-person visits in {{CITY}}.", "provider": { "@type": "LocalBusiness", "@id": "https://www.phonepsychicreaders.com/#business", "name": "Phone Psychic Readers", "url": "https://www.phonepsychicreaders.com/", "telephone": "+1-888-920-6662" }, "areaServed": { "@type": "City", "name": "{{CITY}}", "containedInPlace": { "@type": "AdministrativeArea", "name": "{{COUNTY}}" } }, "offers": { "@type": "Offer", "price": "1.00", "priceCurrency": "USD", "description": "Introductory rate $1 per minute for first-time callers" }, "availableChannel": { "@type": "ServiceChannel", "servicePhone": "+1-888-920-6662", "availableLanguage": "English" } }
</script>
<script type="application/ld+json">
{ "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
  { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://www.phonepsychicreaders.com/" },
  { "@type": "ListItem", "position": 2, "name": "Locations", "item": "https://www.phonepsychicreaders.com/locations.html" },
  { "@type": "ListItem", "position": 3, "name": "{{CITY}}, {{STATE}}", "item": "https://www.phonepsychicreaders.com/{{CITY_SLUG}}-phone-psychic.html" },
  { "@type": "ListItem", "position": 4, "name": "{{CAT}}", "item": "https://www.phonepsychicreaders.com/{{CITY_SLUG}}-{{CAT_SLUG}}.html" }
] }
</script>
</head>
<body>


<!--#include:header-->

<main id="main">

  <nav class="breadcrumb" aria-label="Breadcrumb">
    <div class="container">
      <a href="index.html">Home</a> &rsaquo; <a href="locations.html">Locations</a> &rsaquo; <a href="{{CITY_SLUG}}-phone-psychic.html">{{CITY}}, {{STATE}}</a> &rsaquo; <span>{{CAT}}</span>
    </div>
  </nav>

  <section class="hero hero-plain">
    <div class="container hero-grid">
      <div class="hero-copy">
        <p class="eyebrow"><span class="stars" aria-hidden="true">&#9733;</span> Trusted by callers across {{CITY}} &amp; {{REGION}}</p>
        <h1>{{CITY}} {{CAT}} - Live by Phone From $1/Min</h1>
        <p class="lede">A <strong>{{CAT_L}} in {{CITY}}</strong> by phone - hand-vetted readers, 24/7, no drive, no appointment. Connect in under 60 seconds, {{HOOK}}. Your first minute is $1 and you can hang up anytime.</p>
        <div class="hero-cta">
          <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
          <a class="btn btn-ghost btn-lg" href="tel:+18889206662">Get 15 min for $10</a>
        </div>
        <ul class="hero-trust">
          <li>Hand-vetted readers</li>
          <li>Available 24/7</li>
          <li>Hang up anytime</li>
        </ul>
      </div>
    </div>
  </section>

  <section class="offer-card section-soft" aria-label="Your First {{CITY}} Call offer" style="padding-top:1.5rem; padding-bottom:1.5rem;">
    <div class="container" style="max-width: 860px; text-align: center;">
      <p style="font-size:0.85rem; letter-spacing:0.08em; text-transform:uppercase; margin:0 0 0.5rem; color:var(--ink-soft);">Your First {{CITY}} Call</p>
      <p style="font-size:1.05rem; margin:0 0 0.5rem;"><strong>1 minute $1</strong> &middot; <strong>15 minutes $10</strong> &middot; Hang up anytime &middot; 100% satisfaction promise</p>
      <p style="margin:0 0 1rem; font-size:0.95rem;"><span aria-hidden="true" style="color:#1aab4a;">&#9679;</span> Hand-vetted readers available right now. Typical connection in under 60 seconds.</p>
      <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
    </div>
  </section>

  <section>
    <div class="container">
      <h2>All {{CAT}} Services for {{CITY}}</h2>
      <p>Tell our team your question and we'll match you with the right reader for {{CITY}}. Tap any service to learn more, then call to begin.</p>
      <ul class="service-grid">
{{SERVICES_GRID}}
      </ul>
    </div>
  </section>

  <section class="section-soft">
    <div class="container" style="max-width: 860px;">
      <h2>{{CAT}} Readings From Anywhere in {{CITY}}</h2>
      <p>We take {{CAT_L}} calls from every {{CITY}} neighborhood - {{HOODS}}. Every {{CITY}} zip code is covered: {{ZIPS}}. For the full {{CITY}} rundown, see the <a href="{{CITY_SLUG}}-phone-psychic.html">{{CITY}} phone psychic readings</a> page.</p>
    </div>
  </section>

  <aside class="trust">
    <div class="container trust-inner">
      <div><strong>Vetted</strong><span>Hand-picked readers</span></div>
      <div><strong>24/7</strong><span>Live, {{CITY}}-wide</span></div>
      <div><strong>$1/min</strong><span>First-call rate</span></div>
      <div><strong>100%</strong><span>Satisfaction promise</span></div>
    </div>
  </aside>

  <section class="cta-band">
    <div class="container">
      <h2>Not Sure Which {{CAT}} Reading You Need, {{CITY}}?</h2>
      <p>You don't have to know. Tell our team what's on your mind and we'll connect you with the right hand-vetted reader in under 60 seconds. $1/min first call &middot; 15 minutes for $10 &middot; hang up anytime &middot; 100% satisfaction promise.</p>
      <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
      <span class="stars" aria-hidden="true" style="display:block; margin-top:1rem; font-size:1.3rem;">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
    </div>
  </section>

  <section class="section-soft">
    <div class="container" style="max-width: 860px;">
      <h2>The {{CITY}} Area We Serve by Phone</h2>
      <p>Phone service - no in-person visits in {{CITY}}. Here is the {{CITY}} area we cover, 24/7.</p>
      <div class="map-embed">
        <iframe src="https://maps.google.com/maps?q={{CITY_URL}},+{{STATE}}&amp;z=12&amp;output=embed" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="Map of {{CITY}}, {{STATE}}"></iframe>
      </div>
    </div>
  </section>

</main>

<!--#include:footer-->

</body>
</html>
TPL

# --- Generate 20 category pages ---
TPL_CONTENT="$(cat scripts/city_category.tpl)"
count=0
for SLUG in $TOUCHING; do
  CITY=$(get_field $SLUG 1)
  STATE=$(get_field $SLUG 3)
  COUNTY=$(get_field $SLUG 4)
  REGION=$(get_field $SLUG 5)
  HOOK=$(get_field $SLUG 6)
  HOODS=$(get_field $SLUG 8)
  ZIPS=$(get_field $SLUG 9)
  CITY_L="$(echo "$CITY" | tr '[:upper:]' '[:lower:]')"
  CITY_URL="$(echo "$CITY" | sed 's/ /+/g; s/ñ/n/g; s/Ñ/N/g')"
  for KV in "psychic|Psychic" "astrologer|Astrologer" "numerologist|Numerologist" "fortune-telling-services|Fortune Telling Services"; do
    CAT_SLUG="${KV%%|*}"
    CAT="${KV#*|}"
    CAT_L="$(echo "$CAT" | tr '[:upper:]' '[:lower:]')"
    OUT="$S/${SLUG}-${CAT_SLUG}.html"
    page="$TPL_CONTENT"
    page="${page//\{\{CITY_SLUG\}\}/$SLUG}"
    page="${page//\{\{CITY_URL\}\}/$CITY_URL}"
    page="${page//\{\{CITY_L\}\}/$CITY_L}"
    page="${page//\{\{CITY\}\}/$CITY}"
    page="${page//\{\{STATE\}\}/$STATE}"
    page="${page//\{\{COUNTY\}\}/$COUNTY}"
    page="${page//\{\{REGION\}\}/$REGION}"
    page="${page//\{\{HOOK\}\}/$HOOK}"
    page="${page//\{\{HOODS\}\}/$HOODS}"
    page="${page//\{\{ZIPS\}\}/$ZIPS}"
    page="${page//\{\{CAT_SLUG\}\}/$CAT_SLUG}"
    page="${page//\{\{CAT_L\}\}/$CAT_L}"
    page="${page//\{\{CAT\}\}/$CAT}"
    # Inject services grid via awk
    awk -v grid="/tmp/grid_${CAT_SLUG}.html" '
      /\{\{SERVICES_GRID\}\}/ { while((getline L<grid)>0) print L; close(grid); next }
      { print }
    ' <<< "$page" > "$OUT"
    # Restore @amp@ sentinels just in case (data uses @AMP@)
    sed -i 's/@AMP@/\&amp;/g' "$OUT"
    echo "wrote $OUT"
    count=$((count+1))
  done
done
echo "generated $count category pages"

# --- Update touching-city landing src files to localize category links ---
for SLUG in $TOUCHING; do
  LANDING="$S/${SLUG}-phone-psychic.html"
  if [ -f "$LANDING" ]; then
    sed -i \
      -e "s|href=\"psychic\.html\"|href=\"${SLUG}-psychic.html\"|g" \
      -e "s|href=\"astrologer\.html\"|href=\"${SLUG}-astrologer.html\"|g" \
      -e "s|href=\"numerologist\.html\"|href=\"${SLUG}-numerologist.html\"|g" \
      -e "s|href=\"fortune-telling-services\.html\"|href=\"${SLUG}-fortune-telling-services.html\"|g" \
      "$LANDING"
    echo "relinked categories on $LANDING"
  fi
done

# --- Build site ---
bash build.sh > /tmp/bldtc.log 2>&1
tail -1 /tmp/bldtc.log

# --- Verify ---
echo "--- new category pages ---"
COUNT_NEW=0
for SLUG in $TOUCHING; do
  for CAT_SLUG in psychic astrologer numerologist fortune-telling-services; do
    if [ -f "${SLUG}-${CAT_SLUG}.html" ]; then
      COUNT_NEW=$((COUNT_NEW+1))
    else
      echo "  MISSING: ${SLUG}-${CAT_SLUG}.html"
    fi
  done
done
echo "category pages built: $COUNT_NEW / 20"
echo "landings updated with localized cat links (sample glendale): $(grep -c 'glendale-psychic.html' glendale-phone-psychic.html)"

# --- Commit + push ---
git add -A
git commit -q -m "Phase A: per-city GBP category pages for cities touching Burbank

Cities touching Burbank's border (5): Glendale (east), North Hollywood
(south), Toluca Lake (south), Universal City (south via Cahuenga
Pass), Sun Valley (north).

Generated 20 new category pages (4 GBP categories x 5 cities):
  glendale-psychic.html, glendale-astrologer.html, glendale-numerologist.html, glendale-fortune-telling-services.html
  north-hollywood-{psychic,astrologer,numerologist,fortune-telling-services}.html
  toluca-lake-{psychic,astrologer,numerologist,fortune-telling-services}.html
  universal-city-{psychic,astrologer,numerologist,fortune-telling-services}.html
  sun-valley-{psychic,astrologer,numerologist,fortune-telling-services}.html

Each page: Service schema with provider linked back to Burbank
LocalBusiness via @id, areaServed=that city, no street address, no
email, no business map. City-modified H1 ({City} {Category}), offer
block, full GBP service grid (links to national service hubs for
now; Phase B will replace with city-localized service pages),
city geo content (neighborhoods, ZIPs), and a map embed of THAT city.

Also relinked the 5 touching-city landings (e.g.,
glendale-phone-psychic.html) so the category H2 anchors now point
to the new localized category pages instead of the national hubs.

Phase B (next major batch): per-city service pages with unique
localized body content. ~47 services x 5 cities = ~235 unique
service bodies to author, batched across multiple turns."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
