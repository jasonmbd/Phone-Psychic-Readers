#!/usr/bin/env bash
# One-off: add 8 Burbank-neighbor service-area city pages.
set -euo pipefail
cd "$(dirname "$0")/.."

# --- 1. New city data rows (city|slug|state|county|region|hook|civic|HOODS|ZIPS|LANDMARKS) ---
cat > /tmp/newcities.txt <<'DATA'
Glendale|glendale-phone-psychic|CA|Los Angeles County, California|the foot of the Verdugo Mountains|down Brand Boulevard or up Glenoaks|Glendale City Hall on East Broadway|Adams Hill, Glenoaks Canyon, Verdugo Woodlands, Sparr Heights, Riverside Rancho, Northwest Glendale, and the Glendale Galleria area|91201, 91202, 91203, 91204, 91205, 91206, 91207, 91208, 91214|the Glendale Galleria, the Americana at Brand, Forest Lawn Memorial-Park, Brand Park, Verdugo Park, and the 134 and 2 freeways
Pasadena|pasadena-phone-psychic|CA|Los Angeles County, California|the San Gabriel Valley foothills|in Old Pasadena or up by the Rose Bowl|Pasadena City Hall on East Walnut Street|Old Pasadena, Bungalow Heaven, Madison Heights, South Lake, Linda Vista, San Rafael, and Hastings Ranch|91101, 91103, 91104, 91105, 91106, 91107, 91108|the Rose Bowl, Old Pasadena, the Norton Simon Museum, Caltech, Colorado Boulevard, and the 210 and 134 freeways
North Hollywood|north-hollywood-phone-psychic|CA|Los Angeles, California|the southeast San Fernando Valley|in the NoHo Arts District or along Lankershim|the North Hollywood Library on Tujunga Avenue|the NoHo Arts District, Toluca Woods, the Valley Village edge, Studio Village, and Magnolia Woods|91601, 91602, 91605, 91606|the NoHo Arts District, Universal Studios nearby, Lankershim Boulevard, the Red Line at NoHo station, and the 170 and 134 freeways
Studio City|studio-city-phone-psychic|CA|Los Angeles, California|the southern San Fernando Valley|along Ventura Boulevard or up Laurel Canyon|the Studio City Branch Library on Vineland Avenue|Colfax Meadows, the Silver Triangle, Carpenter, Laurel Terrace, and the Ventura Boulevard corridor|91604|CBS Studio Center, the Ventura Boulevard restaurants, Fryman Canyon, Laurel Canyon, and the 101 and 134 freeways
Toluca Lake|toluca-lake-phone-psychic|CA|Los Angeles, California|the south edge of Burbank|by the lake or along Riverside Drive|the Toluca Lake Community Center|the lake area, Toluca Woods, and the Riverside Drive corridor|91602|Toluca Lake itself, Lakeside Golf Club, Riverside Drive, the Warner Bros. backlot edge, and the 134 freeway
Sherman Oaks|sherman-oaks-phone-psychic|CA|Los Angeles, California|the south-central San Fernando Valley|off Ventura or up in Royal Oaks|the Sherman Oaks Branch Library on Moorpark Street|Chandler Estates, Royal Oaks, the Ventura corridor, and Longridge Estates|91403, 91413, 91423|the Sherman Oaks Galleria, Ventura Boulevard, Sepulveda Boulevard, the 101 and 405 freeways, and Lake Balboa nearby
La Cañada Flintridge|la-canada-flintridge-phone-psychic|CA|Los Angeles County, California|the foothills above Pasadena|along Foothill or up near Descanso|La Cañada Flintridge City Hall on Foothill Boulevard|La Cañada, Flintridge, the Foothill Boulevard corridor, and Sagebrush|91011, 91012|Descanso Gardens, the Jet Propulsion Laboratory nearby, the 210 Foothill Freeway, and the Crescenta Valley
Sun Valley|sun-valley-phone-psychic|CA|Los Angeles, California|the northeast San Fernando Valley|out near Hansen Dam or along Sunland Boulevard|the Sun Valley Branch Library on Vineland Avenue|Stonehurst, the Pendleton Park area, the Sunland edge, and the Burbank Boulevard corridor|91352|Hansen Dam Recreation Area, Stonehurst Park, the 5 and 170 freeways, Hollywood Burbank Airport nearby, and Sun Valley Park
DATA

# --- 2. Insert new rows into gen_city_pages.sh DATA block (before terminator) ---
awk '/^DATA$/ && !done { while((getline L<"/tmp/newcities.txt")>0) print L; close("/tmp/newcities.txt"); done=1 } { print }' scripts/gen_city_pages.sh > /tmp/gen.t && mv /tmp/gen.t scripts/gen_city_pages.sh
echo "generator data lines: $(awk '/^DATA$/{f=!f;next} f' scripts/gen_city_pages.sh | wc -l)"

# --- 3. New li items for locations.html ---
cat > /tmp/newlocs.html <<'LH'
        <li class="svc"><h3><a href="glendale-phone-psychic.html">Glendale</a></h3><p>Phone psychic readings for Glendale and the Verdugo foothills.</p><a class="svc-more" href="glendale-phone-psychic.html">Glendale &rarr;</a></li>
        <li class="svc"><h3><a href="pasadena-phone-psychic.html">Pasadena</a></h3><p>Readings by phone for Pasadena and the San Gabriel foothills.</p><a class="svc-more" href="pasadena-phone-psychic.html">Pasadena &rarr;</a></li>
        <li class="svc"><h3><a href="north-hollywood-phone-psychic.html">North Hollywood</a></h3><p>Phone psychics across NoHo and the southeast Valley.</p><a class="svc-more" href="north-hollywood-phone-psychic.html">North Hollywood &rarr;</a></li>
        <li class="svc"><h3><a href="studio-city-phone-psychic.html">Studio City</a></h3><p>Readings by phone along the Ventura Boulevard corridor.</p><a class="svc-more" href="studio-city-phone-psychic.html">Studio City &rarr;</a></li>
        <li class="svc"><h3><a href="toluca-lake-phone-psychic.html">Toluca Lake</a></h3><p>Phone psychics for Toluca Lake, on Burbank south edge.</p><a class="svc-more" href="toluca-lake-phone-psychic.html">Toluca Lake &rarr;</a></li>
        <li class="svc"><h3><a href="sherman-oaks-phone-psychic.html">Sherman Oaks</a></h3><p>Readings by phone across Sherman Oaks and the south Valley.</p><a class="svc-more" href="sherman-oaks-phone-psychic.html">Sherman Oaks &rarr;</a></li>
        <li class="svc"><h3><a href="la-canada-flintridge-phone-psychic.html">La Ca&ntilde;ada Flintridge</a></h3><p>Phone psychics for La Ca&ntilde;ada Flintridge and the foothills.</p><a class="svc-more" href="la-canada-flintridge-phone-psychic.html">La Ca&ntilde;ada Flintridge &rarr;</a></li>
        <li class="svc"><h3><a href="sun-valley-phone-psychic.html">Sun Valley</a></h3><p>Readings by phone for Sun Valley and the northeast Valley.</p><a class="svc-more" href="sun-valley-phone-psychic.html">Sun Valley &rarr;</a></li>
LH

# --- 4. Insert into src/locations.html after Rancho Cordova ---
awk '/rancho-cordova-phone-psychic\.html">Rancho Cordova/{print; while((getline L<"/tmp/newlocs.html")>0) print L; close("/tmp/newlocs.html"); next}{print}' src/locations.html > /tmp/loc.t && mv /tmp/loc.t src/locations.html
echo "locations grid svc items: $(grep -c '<li class=.svc.' src/locations.html)"

# --- 5. Add 8 redirect pairs (only if not already present) ---
if ! grep -q '^/glendale-phone-psychic/' _redirects; then
cat >> _redirects <<'RD'
/glendale-phone-psychic/                             /glendale-phone-psychic.html                             301
/glendale-phone-psychic                              /glendale-phone-psychic.html                             301
/pasadena-phone-psychic/                             /pasadena-phone-psychic.html                             301
/pasadena-phone-psychic                              /pasadena-phone-psychic.html                             301
/north-hollywood-phone-psychic/                      /north-hollywood-phone-psychic.html                      301
/north-hollywood-phone-psychic                       /north-hollywood-phone-psychic.html                      301
/studio-city-phone-psychic/                          /studio-city-phone-psychic.html                          301
/studio-city-phone-psychic                           /studio-city-phone-psychic.html                          301
/toluca-lake-phone-psychic/                          /toluca-lake-phone-psychic.html                          301
/toluca-lake-phone-psychic                           /toluca-lake-phone-psychic.html                          301
/sherman-oaks-phone-psychic/                         /sherman-oaks-phone-psychic.html                         301
/sherman-oaks-phone-psychic                          /sherman-oaks-phone-psychic.html                         301
/la-canada-flintridge-phone-psychic/                 /la-canada-flintridge-phone-psychic.html                 301
/la-canada-flintridge-phone-psychic                  /la-canada-flintridge-phone-psychic.html                 301
/sun-valley-phone-psychic/                           /sun-valley-phone-psychic.html                           301
/sun-valley-phone-psychic                            /sun-valley-phone-psychic.html                           301
RD
fi

# --- 6. Regenerate all city pages from updated data + schema ---
bash scripts/gen_city_pages.sh 2>&1 | tail -2

# --- 7. Build site ---
bash build.sh > /tmp/bldcity.log 2>&1
tail -1 /tmp/bldcity.log

# --- 8. Verify ---
echo "--- new city pages built ---"
for c in glendale pasadena north-hollywood studio-city toluca-lake sherman-oaks la-canada-flintridge sun-valley; do
  if [ -f "$c-phone-psychic.html" ]; then echo "  ok: $c-phone-psychic.html"; else echo "  MISSING: $c-phone-psychic.html"; fi
done
NEW="glendale-phone-psychic.html pasadena-phone-psychic.html north-hollywood-phone-psychic.html studio-city-phone-psychic.html toluca-lake-phone-psychic.html sherman-oaks-phone-psychic.html la-canada-flintridge-phone-psychic.html sun-valley-phone-psychic.html"
echo "no streetAddress (want 0): $(grep -l streetAddress $NEW 2>/dev/null | wc -l)"
echo "no gmail (want 0): $(grep -l phonepsychicreaders@gmail $NEW 2>/dev/null | wc -l)"
echo "no map embed (want 0): $(grep -l 'maps/embed' $NEW 2>/dev/null | wc -l)"

# --- 9. Commit + push ---
git add -A
git commit -q -m "Add 8 neighbor-city pages around Burbank (service-area, no NAP/map)

Cities (each gets a full localized landing): Glendale, Pasadena,
North Hollywood, Studio City, Toluca Lake, Sherman Oaks,
La Canada Flintridge, Sun Valley.

Schema reworked for service-area cities: Service (serviceType
Phone Psychic Reading) with provider linking back to the Burbank
LocalBusiness via @id, areaServed=that city, offers, available
channel by phone, 24/7 hours. No streetAddress, no email, no map
embed (honest: GBP is in Burbank only).

Also updates the existing 16 Phase-1 city pages to the same cleaner
Service-with-provider schema (city.tpl change), so all 24 service-
area pages now have consistent, honest local-business signals
without claiming a physical presence they do not have.

locations.html grid updated to list the 8 new cities; _redirects
adds the 8 old WP {city}-phone-psychic/ pairs for equity recovery.

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>"
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
