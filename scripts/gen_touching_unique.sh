#!/usr/bin/env bash
# Uniqueness pass for touching-city service pages.
# Replaces the sed-localized (near-duplicate) bodies with genuinely unique,
# per-city authored content + a per-service FAQ. JSON-LD FAQPage is derived
# from the visible FAQ so the two never drift.
#
# Inputs per (city,svc):
#   scripts/bodies/touching/{city}-{suffix}.html   <- authored body sections
#   scripts/faq/touching/{city}-{suffix}.html      <- authored <details> Q/A, one per line
# If either file is missing for a (city,svc), that page is left untouched.
#
# Usage: bash scripts/gen_touching_unique.sh <city-slug> [suffix ...]
#        (no suffixes = every service that has an authored body file)
set -euo pipefail
cd "$(dirname "$0")/.."
S=src
SHELL_TPL=scripts/loc_shell_sa_v2.tpl
BODYDIR=scripts/bodies/touching
FAQDIR=scripts/faq/touching

CITY_SLUG="${1:?usage: gen_touching_unique.sh <city-slug> [suffix ...]}"; shift || true

# --- per-city data: CITY|STATE|COUNTY|HOODS|ZIPS ---
case "$CITY_SLUG" in
  glendale)        CITY="Glendale"; STATE="CA"; COUNTY="Los Angeles County, California";
    HOODS="Adams Hill, Glenoaks Canyon, Verdugo Woodlands, Sparr Heights, Northwest Glendale, and the Galleria area";
    ZIPS="91201, 91202, 91203, 91204, 91205, 91206, 91207, 91208, 91214" ;;
  north-hollywood) CITY="North Hollywood"; STATE="CA"; COUNTY="Los Angeles, California";
    HOODS="the NoHo Arts District, Toluca Woods, the Valley Village edge, Studio Village, and the Lankershim corridor";
    ZIPS="91601, 91602, 91605, 91606" ;;
  toluca-lake)     CITY="Toluca Lake"; STATE="CA"; COUNTY="Los Angeles, California";
    HOODS="the lake area, Toluca Woods, and the Riverside Drive corridor";
    ZIPS="91602" ;;
  universal-city)  CITY="Universal City"; STATE="CA"; COUNTY="Los Angeles County, California";
    HOODS="the studios district and the Cahuenga Pass approach";
    ZIPS="91608" ;;
  sun-valley)      CITY="Sun Valley"; STATE="CA"; COUNTY="Los Angeles, California";
    HOODS="Stonehurst, the Pendleton Park area, the Sunland edge, and the Burbank Boulevard corridor";
    ZIPS="91352" ;;
  *) echo "unknown city: $CITY_SLUG"; exit 1 ;;
esac
CITY_URL="$(echo "$CITY" | sed 's/ /+/g')"
CITY_L="$(echo "$CITY" | tr '[:upper:]' '[:lower:]')"

# --- service metadata from the Burbank DATA block: suffix -> SVC|SVCL|CAT|CATSLUG ---
awk "/<<'DATA'/{f=1;next} /^DATA\$/{f=0} f" scripts/gen_burbank_localized.sh > /tmp/svc_meta.txt
svc_field() { # $1=suffix $2=field(2 SVC,3 SVCL,4 CAT)
  awk -F'|' -v s="burbank-$1" -v f="$2" '$1==s{print $f; exit}' /tmp/svc_meta.txt
}
svc_catslug() { # suffix of category, e.g. astrologer
  awk -F'|' -v s="burbank-$1" '$1==s{c=$5; sub(/^burbank-/,"",c); print c; exit}' /tmp/svc_meta.txt
}

# --- which services to process ---
if [ "$#" -gt 0 ]; then
  SUFFIXES="$*"
else
  SUFFIXES="$(ls "$BODYDIR"/${CITY_SLUG}-*.html 2>/dev/null | sed -E "s#.*/${CITY_SLUG}-##; s#\.html##" | tr '\n' ' ')"
fi

count=0
for SUF in $SUFFIXES; do
  BODYF="$BODYDIR/${CITY_SLUG}-${SUF}.html"
  FAQF="$FAQDIR/${CITY_SLUG}-${SUF}.html"
  if [ ! -f "$BODYF" ] || [ ! -f "$FAQF" ]; then
    echo "  skip ${CITY_SLUG}-${SUF} (need $BODYF + $FAQF)"; continue
  fi
  SVC="$(svc_field "$SUF" 2)"; SVCL="$(svc_field "$SUF" 3)"
  CAT="$(svc_field "$SUF" 4)"; CAT_SLUG="$(svc_catslug "$SUF")"
  [ -z "$SVC" ] && { echo "  skip ${CITY_SLUG}-${SUF} (no service metadata)"; continue; }
  SLUG="${CITY_SLUG}-${SUF}"
  TITLE="${SVC} in ${CITY}, ${STATE} | Live by Phone 24/7 from \$1/Min"
  DESC="A ${SVCL} in ${CITY}, ${STATE} by phone - hand-vetted readers 24/7 across ${CITY}. First minute \$1, 15 minutes for \$10, hang up anytime."
  KW="${SVCL} ${CITY_L}, phone ${SVCL} ${CITY_L}, psychic ${CITY_L}"
  LEDE="A <strong>${SVCL} in ${CITY}</strong> by phone - hand-vetted readers, 24/7. Connect in under 60 seconds. Your first minute is \$1 and you can hang up anytime."

  # Build FAQ JSON-LD from the authored visible FAQ (one <details> per line)
  awk '
    BEGIN{print "{ \"@context\": \"https://schema.org\", \"@type\": \"FAQPage\", \"mainEntity\": ["}
    /<summary>/{
      q=$0; a=$0;
      sub(/.*<summary>/,"",q); sub(/<\/summary>.*/,"",q);
      sub(/.*<p>/,"",a);       sub(/<\/p>.*/,"",a);
      gsub(/"/,"\\\"",q); gsub(/"/,"\\\"",a);
      if(n++) printf(",\n");
      printf("  { \"@type\": \"Question\", \"name\": \"%s\", \"acceptedAnswer\": { \"@type\": \"Answer\", \"text\": \"%s\" } }", q, a);
    }
    END{print "\n] }"}
  ' "$FAQF" > /tmp/faq_jsonld.txt

  # Token substitution (scalars)
  page="$(cat "$SHELL_TPL")"
  page="${page//@@SLUG@@/$SLUG}"
  page="${page//@@CITY_SLUG@@/$CITY_SLUG}"
  page="${page//@@CITY_URL@@/$CITY_URL}"
  page="${page//@@CITY@@/$CITY}"
  page="${page//@@STATE@@/$STATE}"
  page="${page//@@COUNTY@@/$COUNTY}"
  page="${page//@@CAT_SLUG@@/$CAT_SLUG}"
  page="${page//@@CAT@@/$CAT}"
  page="${page//@@SVCL@@/$SVCL}"
  page="${page//@@SVC@@/$SVC}"
  page="${page//@@TITLE@@/$TITLE}"
  page="${page//@@DESC@@/$DESC}"
  page="${page//@@KEYWORDS@@/$KW}"
  page="${page//@@LEDE@@/$LEDE}"
  page="${page//@@HOODS@@/$HOODS}"
  page="${page//@@ZIPS@@/$ZIPS}"

  # Inject multiline blocks at @@BODY@@, @@FAQ@@, @@FAQ_JSONLD@@
  awk -v bf="$BODYF" -v ff="$FAQF" -v jf=/tmp/faq_jsonld.txt '
    /@@FAQ_JSONLD@@/{while((getline L<jf)>0)print L; close(jf); next}
    /@@BODY@@/{while((getline L<bf)>0)print L; close(bf); next}
    /@@FAQ@@/{while((getline L<ff)>0)print L; close(ff); next}
    {print}
  ' <<< "$page" > "$S/$SLUG.html"
  echo "  wrote $S/$SLUG.html ($SVC)"
  count=$((count+1))
done
echo "composed $count unique service page(s) for $CITY_SLUG"
