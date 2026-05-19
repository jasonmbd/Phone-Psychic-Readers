#!/usr/bin/env bash
# Localized Burbank service pages: consistent localized SHELL (loc_shell.tpl)
# + UNIQUE per-service body authored in scripts/bodies/<slug>.html.
# A slug is only (re)generated if its body file exists — fill bodies in
# batches; pages without a body file are left untouched.
# Row: SLUG|Service|service-lowercase|Category|category-slug
set -euo pipefail
cd "$(dirname "$0")/.."
S=src
TPL=scripts/loc_shell.tpl
BD=scripts/bodies

read -r -d '' ROWS <<'DATA' || true
burbank-relationship-psychic-reading|Relationship Psychic Reading|relationship psychic reading|Psychic|burbank-psychic
burbank-career-psychic-reading|Career Psychic Reading|career psychic reading|Psychic|burbank-psychic
burbank-intuitive-psychic-reading|Intuitive Psychic Reading|intuitive psychic reading|Psychic|burbank-psychic
burbank-clairvoyant-reading|Clairvoyant Psychic Reading|clairvoyant reading|Psychic|burbank-psychic
burbank-aura-reading|Aura Reading|aura reading|Psychic|burbank-psychic
burbank-past-life-psychic-readings-by-phone|Past Life Psychic Reading|past life reading|Psychic|burbank-psychic
burbank-phone-tarot-reading|Tarot Card Reading|tarot card reading|Psychic|burbank-psychic
burbank-dream-interpretation-psychic-readings-phone|Dream Interpretation|dream interpretation reading|Psychic|burbank-psychic
burbank-energy-healing|Energy Healing|energy healing session|Psychic|burbank-psychic
burbank-daily-horoscope-reading|Daily Horoscope|daily horoscope reading|Psychic|burbank-psychic
burbank-tarot-reading-near-me|Tarot Reading Near Me|tarot reading|Psychic|burbank-psychic
burbank-love-tarot-reading|Love Tarot Reading|love tarot reading|Psychic|burbank-psychic
burbank-career-tarot-reading|Career Tarot Reading|career tarot reading|Psychic|burbank-psychic
burbank-relationship-tarot-reading|Relationship Tarot Reading|relationship tarot reading|Psychic|burbank-psychic
burbank-future-tarot-reading|Future Tarot Reading|future tarot reading|Psychic|burbank-psychic
burbank-psychic-tarot-reading|Psychic Tarot Reading|psychic tarot reading|Psychic|burbank-psychic
burbank-annual-horoscope-reading|Annual Horoscope|annual horoscope reading|Psychic|burbank-psychic
burbank-astrology-advice|Astrology Advice|astrology advice|Psychic|burbank-psychic
burbank-life-coaching|Life Coaching|life coaching session|Psychic|burbank-psychic
burbank-astrology-report|Astrology Report|astrology report|Psychic|burbank-psychic
burbank-astrology-horoscope-readings|Astrology Horoscope Readings|astrology horoscope reading|Psychic|burbank-psychic
burbank-phone-psychic-service|Phone Psychic|phone psychic reading|Psychic|burbank-psychic
burbank-psychic-readings-tarot-card|Psychic Readings and Tarot Card|psychic and tarot reading|Psychic|burbank-psychic
burbank-astrology-reading|Astrology Reading|astrology reading|Astrologer|burbank-astrologer
burbank-birth-chart-reading|Birth Chart Reading|birth chart reading|Astrologer|burbank-astrologer
burbank-natal-chart-interpretation|Natal Chart Interpretation|natal chart interpretation|Astrologer|burbank-astrologer
burbank-love-astrology-reading|Love Astrology Reading|love astrology reading|Astrologer|burbank-astrologer
burbank-relationship-astrology-compatibility|Relationship Astrology Compatibility|astrology compatibility reading|Astrologer|burbank-astrologer
burbank-career-astrology-reading|Career Astrology Reading|career astrology reading|Astrologer|burbank-astrologer
burbank-astrology-consultation|Astrology Consultation|astrology consultation|Astrologer|burbank-astrologer
burbank-marriage-astrology-reading|Marriage Astrology Reading|marriage astrology reading|Astrologer|burbank-astrologer
burbank-astrology-reading-near-me|Astrology Reading Near Me|astrology reading|Astrologer|burbank-astrologer
burbank-numerology-reading|Numerology Reading|numerology reading|Numerologist|burbank-numerologist
burbank-life-path-number-reading|Life Path Number Reading|life path number reading|Numerologist|burbank-numerologist
burbank-love-numerology-reading|Love Numerology Reading|love numerology reading|Numerologist|burbank-numerologist
burbank-career-numerology-reading|Career Numerology Reading|career numerology reading|Numerologist|burbank-numerologist
burbank-personal-numerology-chart|Personal Numerology Chart|personal numerology chart|Numerologist|burbank-numerologist
burbank-numerology-consultation|Numerology Consultation|numerology consultation|Numerologist|burbank-numerologist
burbank-numerology-guidance-session|Numerology Guidance Session|numerology guidance session|Numerologist|burbank-numerologist
burbank-soulmate-reading|Soulmate Reading|soulmate reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-twin-flame-reading|Twin Flame Reading|twin flame reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-life-path-psychic-reading|Life Path Psychic Reading|life path psychic reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-spiritual-guidance-reading|Spiritual Guidance Reading|spiritual guidance reading|Fortune Telling Services|burbank-fortune-telling-services
burbank-private-psychic-consultation|Private Psychic Consultation|private psychic consultation|Fortune Telling Services|burbank-fortune-telling-services
burbank-psychic-reading-near-me|Psychic Reading Near Me|psychic reading|Fortune Telling Services|burbank-fortune-telling-services
DATA

count=0; skipped=0
while IFS='|' read -r SLUG SVC SVCL CAT CATSLUG; do
  [ -z "${SLUG:-}" ] && continue
  if [ ! -f "$BD/$SLUG.html" ]; then skipped=$((skipped+1)); continue; fi
  TITLE="$SVC in Burbank, CA | Live by Phone 24/7 from \$1/Min"
  DESC="A $SVCL in Burbank, CA by phone — hand-vetted readers answer 24/7 from Magnolia Park to the Rancho. First minute \$1, 15 minutes for \$10, hang up anytime."
  KW="$SVCL burbank, $SVCL burbank ca, phone $SVCL burbank, psychic burbank"
  LEDE="A <strong>$SVCL in Burbank</strong> by phone — hand-vetted readers, 24/7, from Magnolia Park to the Rancho. Connect in under 60 seconds. Your first minute is \$1 and you can hang up anytime."
  awk -v slug="$SLUG" -v svc="$SVC" -v svcl="$SVCL" -v cat="$CAT" -v catslug="$CATSLUG" \
      -v title="$TITLE" -v desc="$DESC" -v kw="$KW" -v lede="$LEDE" -v body="$BD/$SLUG.html" '
    { line=$0
      if (line ~ /@@BODY@@/) { while ((getline b < body) > 0) print b; close(body); next }
      gsub(/@@SLUG@@/, slug, line); gsub(/@@SVCL@@/, svcl, line); gsub(/@@SVC@@/, svc, line)
      gsub(/@@CATSLUG@@/, catslug, line); gsub(/@@CAT@@/, cat, line)
      gsub(/@@TITLE@@/, title, line); gsub(/@@DESC@@/, desc, line)
      gsub(/@@KEYWORDS@@/, kw, line); gsub(/@@LEDE@@/, lede, line)
      print line }
  ' "$TPL" > "$S/$SLUG.html"
  echo "localized $SLUG.html"
  count=$((count+1))
done <<< "$ROWS"
echo "done: $count generated, $skipped awaiting body files"
