#!/usr/bin/env bash
# Core 30 Burbank service tier generator (generic) + inline PAA supporting content.
# Row: OUTSLUG|Service Name|SOURCE national slug|Category label|category slug
set -euo pipefail
cd "$(dirname "$0")/.."
S=src

read -r -d '' ROWS <<'DATA' || true
burbank-psychic-reading|Psychic Reading|psychic-reading|Psychic|burbank-psychic
burbank-psychic-love-readings-by-phone|Love Psychic Reading|psychic-love-readings-by-phone|Psychic|burbank-psychic
burbank-relationship-psychic-reading|Relationship Psychic Reading|relationship-psychic-reading|Psychic|burbank-psychic
burbank-career-psychic-reading|Career Psychic Reading|career-psychic-reading|Psychic|burbank-psychic
burbank-intuitive-psychic-reading|Intuitive Psychic Reading|intuitive-psychic-reading|Psychic|burbank-psychic
burbank-clairvoyant-reading|Clairvoyant Psychic Reading|clairvoyant-reading|Psychic|burbank-psychic
burbank-aura-reading|Aura Reading|aura-reading|Psychic|burbank-psychic
burbank-past-life-psychic-readings-by-phone|Past Life Psychic Reading|past-life-psychic-readings-by-phone|Psychic|burbank-psychic
burbank-phone-tarot-reading|Tarot Card Reading|phone-tarot-reading|Psychic|burbank-psychic
burbank-dream-interpretation-psychic-readings-phone|Dream Interpretation|dream-interpretation-psychic-readings-phone|Psychic|burbank-psychic
burbank-energy-healing|Energy Healing|energy-healing|Psychic|burbank-psychic
burbank-daily-horoscope-reading|Daily Horoscope|daily-horoscope-reading|Psychic|burbank-psychic
burbank-tarot-reading-near-me|Tarot Reading Near Me|tarot-reading-near-me|Psychic|burbank-psychic
burbank-love-tarot-reading|Love Tarot Reading|love-tarot-reading|Psychic|burbank-psychic
burbank-career-tarot-reading|Career Tarot Reading|career-tarot-reading|Psychic|burbank-psychic
burbank-relationship-tarot-reading|Relationship Tarot Reading|relationship-tarot-reading|Psychic|burbank-psychic
burbank-future-tarot-reading|Future Tarot Reading|future-tarot-reading|Psychic|burbank-psychic
burbank-psychic-tarot-reading|Psychic Tarot Reading|phone-tarot-reading|Psychic|burbank-psychic
burbank-annual-horoscope-reading|Annual Horoscope|annual-horoscope-reading|Psychic|burbank-psychic
burbank-astrology-advice|Astrology Advice|astrology-advice|Psychic|burbank-psychic
burbank-life-coaching|Life Coaching|life-coaching|Psychic|burbank-psychic
burbank-astrology-report|Astrology Report|horoscope-astrology-psychic-readings-by-phone|Psychic|burbank-psychic
burbank-astrology-horoscope-readings|Astrology Horoscope Readings|horoscope-astrology-psychic-readings-by-phone|Psychic|burbank-psychic
burbank-phone-psychic-service|Phone Psychic|phone-psychic|Psychic|burbank-psychic
burbank-psychic-readings-tarot-card|Psychic Readings and Tarot Card|phone-tarot-reading|Psychic|burbank-psychic
burbank-astrology-reading|Astrology Reading|horoscope-astrology-psychic-readings-by-phone|Astrologer|burbank-astrologer
burbank-birth-chart-reading|Birth Chart Reading|birth-chart-reading|Astrologer|burbank-astrologer
burbank-natal-chart-interpretation|Natal Chart Interpretation|birth-chart-reading|Astrologer|burbank-astrologer
burbank-love-astrology-reading|Love Astrology Reading|love-astrology-reading|Astrologer|burbank-astrologer
burbank-relationship-astrology-compatibility|Relationship Astrology Compatibility|astrology-compatibility-reading|Astrologer|burbank-astrologer
burbank-career-astrology-reading|Career Astrology Reading|career-astrology-reading|Astrologer|burbank-astrologer
burbank-astrology-consultation|Astrology Consultation|horoscope-astrology-psychic-readings-by-phone|Astrologer|burbank-astrologer
burbank-marriage-astrology-reading|Marriage Astrology Reading|love-astrology-reading|Astrologer|burbank-astrologer
burbank-astrology-reading-near-me|Astrology Reading Near Me|astrology-reading-near-me|Astrologer|burbank-astrologer
burbank-numerology-reading|Numerology Reading|numerologist|Numerologist|burbank-numerologist
burbank-life-path-number-reading|Life Path Number Reading|numerologist|Numerologist|burbank-numerologist
burbank-love-numerology-reading|Love Numerology Reading|psychic-love-readings-by-phone|Numerologist|burbank-numerologist
burbank-career-numerology-reading|Career Numerology Reading|money-prosperity-psychic-readings|Numerologist|burbank-numerologist
burbank-personal-numerology-chart|Personal Numerology Chart|numerologist|Numerologist|burbank-numerologist
burbank-numerology-consultation|Numerology Consultation|numerologist|Numerologist|burbank-numerologist
burbank-numerology-guidance-session|Numerology Guidance Session|numerologist|Numerologist|burbank-numerologist
burbank-soulmate-reading|Soulmate Reading|soulmate-reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-twin-flame-reading|Twin Flame Reading|twin-flame-reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-life-path-psychic-reading|Life Path Psychic Reading|spiritual-guidance-reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-spiritual-guidance-reading|Spiritual Guidance Reading|spiritual-guidance-reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-private-psychic-consultation|Private Psychic Consultation|psychic-reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-psychic-reading-near-me|Psychic Reading Near Me|psychic-reading-near-me|Fortune Telling Services|burbank-fortune-telling-services
DATA

cat > /tmp/bk_localblock.html <<'EOF'
  <!-- BURBANK-ONLY local block (above global footer; swap per GBP city) -->
  <section class="section-soft">
    <div class="container" style="max-width: 860px;">
      <h2>Find Phone Psychic Readers in Burbank</h2>
      <p>Our Burbank Google Business Profile and verified reviews are tied to this location. Readings are delivered by phone — here's the listing so you know exactly who you're calling.</p>
      <address class="nap-block">
        <strong>Phone Psychic Readers</strong><br>
        365 W Alameda Ave, Burbank, CA 91506<br>
        <a href="tel:+18889206662">(888) 920-6662</a> &middot;
        <a href="mailto:phonepsychicreaders@gmail.com">phonepsychicreaders@gmail.com</a><br>
        Open 24 hours &middot; 7 days a week &middot; <strong>4.4&#9733;</strong> from 7 Google reviews
      </address>
      <div class="map-embed">
        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3301.254311816029!2d-118.310033!3d34.1654151!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x808ffb83ce468f01%3A0x2aed45fb738f28e6!2sPhone%20Psychic%20Readers%20-%20tarot%20card%20readings%20%7C%20horoscope%20astrology%20love%20%26%20more!5e0!3m2!1sen!2sus!4v1779170493480!5m2!1sen!2sus" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="Phone Psychic Readers — Burbank, CA"></iframe>
      </div>
    </div>
  </section>
EOF

count=0
while IFS='|' read -r OUT SVC SRC CAT CATSLUG; do
  [ -z "${OUT:-}" ] && continue
  [ -f "$S/$SRC.html" ] || { echo "MISSING SOURCE $SRC.html — skipped $OUT"; continue; }

  cat > /tmp/bk_crumb.html <<EOF
  <nav class="breadcrumb" aria-label="Breadcrumb">
    <div class="container">
      <a href="index.html">Home</a> &rsaquo; <a href="locations.html">Locations</a> &rsaquo; <a href="burbank-phone-psychic.html">Burbank, CA</a> &rsaquo; <a href="$CATSLUG.html">$CAT</a> &rsaquo; <span>$SVC</span>
    </div>
  </nav>
EOF

  cat > /tmp/bk_bcjson.html <<EOF
<script type="application/ld+json">
{ "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
  { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://www.phonepsychicreaders.com/" },
  { "@type": "ListItem", "position": 2, "name": "Locations", "item": "https://www.phonepsychicreaders.com/locations.html" },
  { "@type": "ListItem", "position": 3, "name": "Burbank, CA", "item": "https://www.phonepsychicreaders.com/burbank-phone-psychic.html" },
  { "@type": "ListItem", "position": 4, "name": "$CAT", "item": "https://www.phonepsychicreaders.com/$CATSLUG.html" },
  { "@type": "ListItem", "position": 5, "name": "$SVC", "item": "https://www.phonepsychicreaders.com/$OUT.html" }
] }
</script>
EOF

  # Inline "People Also Ask — Burbank" supporting content (unique per service+city)
  cat > /tmp/bk_paa.html <<EOF
  <section class="section-soft faq">
    <div class="container" style="max-width: 860px;">
      <h2>People Also Ask — $SVC in Burbank</h2>
      <details><summary>How much does a $SVC in Burbank cost?</summary><p>First-time Burbank callers pay \$1 per minute, or 15 minutes for \$10. There's no minimum, you can hang up anytime, and a 100% satisfaction promise stands behind every call.</p></details>
      <details><summary>Can I get a $SVC in Burbank tonight?</summary><p>Yes. The line is open 24 hours a day, every day, including holidays. Call from any Burbank zip code — Magnolia Park to the Rancho — and you're connected to a hand-vetted reader in under 60 seconds.</p></details>
      <details><summary>Do I have to drive anywhere in Burbank for a $SVC?</summary><p>No. It's a phone service. You stay home in Burbank and call — no traffic on Olive, no parking at the Town Center, no appointment.</p></details>
      <details><summary>Is a $SVC accurate over the phone?</summary><p>Yes. A phone reading is often clearer — no visual distractions, so the reader focuses entirely on your voice and energy. You get the patterns at work and the likely direction, not a fixed fate.</p></details>
      <details><summary>How do I start a $SVC in Burbank?</summary><p>Call (888) 920-6662, tell our team what's on your mind, and we match you with the right hand-vetted reader for your question. First minute is \$1.</p></details>
    </div>
  </section>
EOF

  awk -v out="$OUT" -v svc="$SVC" \
      -v crumb="/tmp/bk_crumb.html" -v bc="/tmp/bk_bcjson.html" \
      -v paa="/tmp/bk_paa.html" -v lb="/tmp/bk_localblock.html" '
    /<title>/ && !td { print "<title>" svc " in Burbank, CA | Live by Phone 24/7 from $1/Min</title>"; td=1; next }
    /rel="canonical"/ && !cn { print "<link rel=\"canonical\" href=\"https://www.phonepsychicreaders.com/" out ".html\">"; cn=1; next }
    /<\/head>/ && !bd { while ((getline L < bc) > 0) print L; close(bc); print; bd=1; next }
    /<h1>/ && !hd { print "<h1>" svc " in Burbank, CA — Live, 24/7, From $1/Min</h1>"; hd=1; next }
    /<main id="main">/ && !md { print; while ((getline L < crumb) > 0) print L; close(crumb); md=1; next }
    /<!--#include:footer-->/ && !fd { while ((getline L < paa) > 0) print L; close(paa); print ""; while ((getline L < lb) > 0) print L; close(lb); print ""; print; fd=1; next }
    { print }
  ' "$S/$SRC.html" > "$S/$OUT.html"
  echo "wrote $OUT.html (from $SRC)"
  count=$((count+1))
done <<< "$ROWS"
echo "done $count service pages"
