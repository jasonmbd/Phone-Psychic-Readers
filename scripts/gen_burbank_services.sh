#!/usr/bin/env bash
# Core 30 service tier (Burbank / Psychic category).
# Clones national service pages, localizes title/H1/canonical, injects
# breadcrumb nav + BreadcrumbList JSON-LD + Burbank NAP block, and links
# back up to burbank-psychic.html -> burbank-phone-psychic.html.
set -euo pipefail
cd "$(dirname "$0")/.."
S=src

# nationalslug|Service Name|CATEGORY label|category slug
read -r -d '' ROWS <<'DATA' || true
psychic-love-readings-by-phone|Love Psychic Reading|Psychic|burbank-psychic
relationship-psychic-reading|Relationship Psychic Reading|Psychic|burbank-psychic
career-psychic-reading|Career Psychic Reading|Psychic|burbank-psychic
intuitive-psychic-reading|Intuitive Psychic Reading|Psychic|burbank-psychic
clairvoyant-reading|Clairvoyant Reading|Psychic|burbank-psychic
aura-reading|Aura Reading|Psychic|burbank-psychic
past-life-psychic-readings-by-phone|Past Life Reading|Psychic|burbank-psychic
phone-tarot-reading|Tarot Card Reading|Psychic|burbank-psychic
dream-interpretation-psychic-readings-phone|Dream Interpretation|Psychic|burbank-psychic
energy-healing|Energy Healing|Psychic|burbank-psychic
daily-horoscope-reading|Daily Horoscope|Psychic|burbank-psychic
DATA

# Static Burbank local block (no '&' to keep sed/awk safe; iframe uses %26)
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
while IFS='|' read -r NAT SVC CAT CATSLUG; do
  [ -z "${NAT:-}" ] && continue
  OUT="$S/burbank-$NAT.html"

  # per-service breadcrumb nav
  cat > /tmp/bk_crumb.html <<EOF
  <nav class="breadcrumb" aria-label="Breadcrumb">
    <div class="container">
      <a href="index.html">Home</a> &rsaquo; <a href="locations.html">Locations</a> &rsaquo; <a href="burbank-phone-psychic.html">Burbank, CA</a> &rsaquo; <a href="$CATSLUG.html">$CAT</a> &rsaquo; <span>$SVC</span>
    </div>
  </nav>
EOF

  # per-service BreadcrumbList JSON-LD
  cat > /tmp/bk_bcjson.html <<EOF
<script type="application/ld+json">
{ "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
  { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://www.phonepsychicreaders.com/" },
  { "@type": "ListItem", "position": 2, "name": "Locations", "item": "https://www.phonepsychicreaders.com/locations.html" },
  { "@type": "ListItem", "position": 3, "name": "Burbank, CA", "item": "https://www.phonepsychicreaders.com/burbank-phone-psychic.html" },
  { "@type": "ListItem", "position": 4, "name": "$CAT", "item": "https://www.phonepsychicreaders.com/$CATSLUG.html" },
  { "@type": "ListItem", "position": 5, "name": "$SVC", "item": "https://www.phonepsychicreaders.com/burbank-$NAT.html" }
] }
</script>
EOF

  awk -v nat="$NAT" -v svc="$SVC" \
      -v crumb="/tmp/bk_crumb.html" -v bc="/tmp/bk_bcjson.html" -v lb="/tmp/bk_localblock.html" '
    /<title>/ && !td { print "<title>" svc " in Burbank, CA | Live by Phone 24/7 from $1/Min</title>"; td=1; next }
    /rel="canonical"/ && !cd { print "<link rel=\"canonical\" href=\"https://www.phonepsychicreaders.com/burbank-" nat ".html\">"; cd=1; next }
    /<\/head>/ && !bd { while ((getline L < bc) > 0) print L; close(bc); print; bd=1; next }
    /<h1>/ && !hd { print "<h1>" svc " in Burbank, CA — Live, 24/7, From $1/Min</h1>"; hd=1; next }
    /<main id="main">/ && !md { print; while ((getline L < crumb) > 0) print L; close(crumb); md=1; next }
    /<!--#include:footer-->/ && !fd { while ((getline L < lb) > 0) print L; close(lb); print ""; print; fd=1; next }
    { print }
  ' "$S/$NAT.html" > "$OUT"
  echo "wrote burbank-$NAT.html"
  count=$((count+1))
done <<< "$ROWS"
echo "done $count service pages"
