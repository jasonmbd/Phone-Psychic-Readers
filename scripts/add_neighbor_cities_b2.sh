#!/usr/bin/env bash
# One-off: second batch of Burbank-neighbor service-area city pages
# (Hollywood, West Hollywood, Universal City, Valley Village, Van Nuys,
#  Encino, Silver Lake, Los Feliz).
set -euo pipefail
cd "$(dirname "$0")/.."

# --- 1. New city data rows (city|slug|state|county|region|hook|civic|HOODS|ZIPS|LANDMARKS) ---
cat > /tmp/newcities2.txt <<'DATA'
Hollywood|hollywood-phone-psychic|CA|Los Angeles, California|central Los Angeles|off the Hollywood Walk of Fame or up in the Hills|the Hollywood and Highland complex on Hollywood Boulevard|the Hollywood Hills, Franklin Village, Beachwood Canyon, Thai Town, and Little Armenia|90028, 90038, 90068|the Hollywood Sign, the Hollywood Walk of Fame, the TCL Chinese Theatre, Hollywood Boulevard, Sunset Boulevard, and Griffith Observatory nearby
West Hollywood|west-hollywood-phone-psychic|CA|Los Angeles County, California|the LA Westside fringe|on the Sunset Strip or off Santa Monica|West Hollywood City Hall on North San Vicente Boulevard|the Sunset Strip, Boys Town, the Norma Triangle, and the Eastside|90046, 90048, 90069|the Sunset Strip, the Whisky a Go Go, the Pacific Design Center, Melrose Avenue, and Santa Monica Boulevard
Universal City|universal-city-phone-psychic|CA|Los Angeles County, California|the south edge of Burbank by Universal Studios|by CityWalk or up on the lot|the Universal CityWalk main entrance|the studios district and the Cahuenga Pass approach|91608|Universal Studios Hollywood, CityWalk, the 101 Hollywood Freeway, and Lankershim Boulevard
Valley Village|valley-village-phone-psychic|CA|Los Angeles, California|the south-central San Fernando Valley|off Magnolia or by Valley Village Park|the Valley Village Park on Whitsett Avenue|the Magnolia Park area, Laurel Plaza, and the Colfax Meadows edge|91607|Magnolia Boulevard, Laurel Hall, the 170 Hollywood Freeway, and Burbank Boulevard
Van Nuys|van-nuys-phone-psychic|CA|Los Angeles, California|the central San Fernando Valley|along Van Nuys Boulevard or near the airport|Van Nuys City Hall on Sylvan Street|the Van Nuys Boulevard corridor, Tobias-Cedros, the Lake Balboa edge, and Kester Ridge|91401, 91405, 91406, 91411|Van Nuys Boulevard, Van Nuys Airport, Sherman Way, the 405 San Diego Freeway, and the Sepulveda Basin
Encino|encino-phone-psychic|CA|Los Angeles, California|the south-central San Fernando Valley|off Ventura or up in the hills|the Encino Branch Library on Ventura Boulevard|Royal Hills, the Vista de Oro area, the Encino Hills, and Encino Village|91316, 91436|Ventura Boulevard, the Encino Reservoir, Encino Park, and the Sepulveda Basin Recreation Area
Silver Lake|silver-lake-phone-psychic|CA|Los Angeles, California|the LA eastside|by the Reservoir or up at Sunset Junction|the Silver Lake Branch Library on Glendale Boulevard|Sunset Junction, the Reservoir district, Ivanhoe, and Moreno Highlands|90026, 90039|the Silver Lake Reservoir, Sunset Junction, Sunset Boulevard, and Echo Park Lake nearby
Los Feliz|los-feliz-phone-psychic|CA|Los Angeles, California|the LA eastside foothills|along Vermont or up by Griffith Park|the John C. Fremont Branch Library on Hollywood Boulevard|Franklin Hills, Los Feliz Heights, the Vermont corridor, and the Hillhurst Avenue area|90027, 90039|Griffith Park, the Griffith Observatory, the Greek Theatre, Vermont Avenue, and Hollywood Boulevard
DATA

# --- 2. Insert new rows into gen_city_pages.sh DATA block ---
awk '/^DATA$/ && !done { while((getline L<"/tmp/newcities2.txt")>0) print L; close("/tmp/newcities2.txt"); done=1 } { print }' scripts/gen_city_pages.sh > /tmp/gen.t && mv /tmp/gen.t scripts/gen_city_pages.sh
echo "generator data lines: $(awk '/^DATA$/{f=!f;next} f' scripts/gen_city_pages.sh | wc -l)"

# --- 3. New li items for locations.html ---
cat > /tmp/newlocs2.html <<'LH'
        <li class="svc"><h3><a href="hollywood-phone-psychic.html">Hollywood</a></h3><p>Phone psychic readings for Hollywood and the Hills.</p><a class="svc-more" href="hollywood-phone-psychic.html">Hollywood &rarr;</a></li>
        <li class="svc"><h3><a href="west-hollywood-phone-psychic.html">West Hollywood</a></h3><p>Readings by phone for West Hollywood and the Strip.</p><a class="svc-more" href="west-hollywood-phone-psychic.html">West Hollywood &rarr;</a></li>
        <li class="svc"><h3><a href="universal-city-phone-psychic.html">Universal City</a></h3><p>Phone psychics for Universal City and the CityWalk area.</p><a class="svc-more" href="universal-city-phone-psychic.html">Universal City &rarr;</a></li>
        <li class="svc"><h3><a href="valley-village-phone-psychic.html">Valley Village</a></h3><p>Readings by phone across Valley Village and Magnolia Park.</p><a class="svc-more" href="valley-village-phone-psychic.html">Valley Village &rarr;</a></li>
        <li class="svc"><h3><a href="van-nuys-phone-psychic.html">Van Nuys</a></h3><p>Phone psychics for Van Nuys and the central Valley.</p><a class="svc-more" href="van-nuys-phone-psychic.html">Van Nuys &rarr;</a></li>
        <li class="svc"><h3><a href="encino-phone-psychic.html">Encino</a></h3><p>Readings by phone for Encino and the Ventura corridor.</p><a class="svc-more" href="encino-phone-psychic.html">Encino &rarr;</a></li>
        <li class="svc"><h3><a href="silver-lake-phone-psychic.html">Silver Lake</a></h3><p>Phone psychics for Silver Lake and Sunset Junction.</p><a class="svc-more" href="silver-lake-phone-psychic.html">Silver Lake &rarr;</a></li>
        <li class="svc"><h3><a href="los-feliz-phone-psychic.html">Los Feliz</a></h3><p>Readings by phone for Los Feliz and the Griffith Park foothills.</p><a class="svc-more" href="los-feliz-phone-psychic.html">Los Feliz &rarr;</a></li>
LH

# --- 4. Insert into src/locations.html after Sun Valley (last batch-1 city) ---
awk '/sun-valley-phone-psychic\.html">Sun Valley/{print; while((getline L<"/tmp/newlocs2.html")>0) print L; close("/tmp/newlocs2.html"); next}{print}' src/locations.html > /tmp/loc.t && mv /tmp/loc.t src/locations.html
echo "locations grid svc items: $(grep -c '<li class=.svc.' src/locations.html)"

# --- 5. Add 8 redirect pairs ---
if ! grep -q '^/hollywood-phone-psychic/' _redirects; then
cat >> _redirects <<'RD'
/hollywood-phone-psychic/                            /hollywood-phone-psychic.html                            301
/hollywood-phone-psychic                             /hollywood-phone-psychic.html                            301
/west-hollywood-phone-psychic/                       /west-hollywood-phone-psychic.html                       301
/west-hollywood-phone-psychic                        /west-hollywood-phone-psychic.html                       301
/universal-city-phone-psychic/                       /universal-city-phone-psychic.html                       301
/universal-city-phone-psychic                        /universal-city-phone-psychic.html                       301
/valley-village-phone-psychic/                       /valley-village-phone-psychic.html                       301
/valley-village-phone-psychic                        /valley-village-phone-psychic.html                       301
/van-nuys-phone-psychic/                             /van-nuys-phone-psychic.html                             301
/van-nuys-phone-psychic                              /van-nuys-phone-psychic.html                             301
/encino-phone-psychic/                               /encino-phone-psychic.html                               301
/encino-phone-psychic                                /encino-phone-psychic.html                               301
/silver-lake-phone-psychic/                          /silver-lake-phone-psychic.html                          301
/silver-lake-phone-psychic                           /silver-lake-phone-psychic.html                          301
/los-feliz-phone-psychic/                            /los-feliz-phone-psychic.html                            301
/los-feliz-phone-psychic                             /los-feliz-phone-psychic.html                            301
RD
fi

# --- 6. Regenerate all city pages from updated data ---
bash scripts/gen_city_pages.sh 2>&1 | tail -2

# --- 7. Build site ---
bash build.sh > /tmp/bldcity2.log 2>&1
tail -1 /tmp/bldcity2.log

# --- 8. Verify ---
echo "--- new city pages built ---"
for c in hollywood west-hollywood universal-city valley-village van-nuys encino silver-lake los-feliz; do
  if [ -f "$c-phone-psychic.html" ]; then echo "  ok: $c-phone-psychic.html"; else echo "  MISSING: $c-phone-psychic.html"; fi
done
NEW="hollywood-phone-psychic.html west-hollywood-phone-psychic.html universal-city-phone-psychic.html valley-village-phone-psychic.html van-nuys-phone-psychic.html encino-phone-psychic.html silver-lake-phone-psychic.html los-feliz-phone-psychic.html"
echo "no streetAddress (want 0): $(grep -l streetAddress $NEW 2>/dev/null | wc -l)"
echo "no gmail (want 0): $(grep -l phonepsychicreaders@gmail $NEW 2>/dev/null | wc -l)"
echo "no map embed (want 0): $(grep -l 'maps/embed' $NEW 2>/dev/null | wc -l)"
echo "Service schema (want 8): $(grep -l '\"@type\": \"Service\"' $NEW 2>/dev/null | wc -l)"

# --- 9. Commit + push ---
git add -A
git commit -q -m "Add 8 more LA-area neighbor-city pages (batch 2)

Cities: Hollywood, West Hollywood, Universal City, Valley Village,
Van Nuys, Encino, Silver Lake, Los Feliz. Same service-area pattern
as batch 1: Service schema with provider linked back to the Burbank
LocalBusiness via @id, no streetAddress, no email, no map embed.
Real neighborhoods, ZIP codes, and landmarks per city. 32 service-
area city pages total now; locations.html updated; 8 redirect pairs
added for old WP URL recovery."
git push -q
echo "PUSHED $(git rev-parse --short HEAD)"
