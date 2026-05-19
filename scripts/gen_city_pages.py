# -*- coding: utf-8 -*-
# One-off generator for Phase-1 city home pages (city-localized clone of index.html).
import os

OUT = os.path.join(os.path.dirname(__file__), "..", "src")

# Real local data per city. county, zips, neighborhoods, landmarks, civic landmark
# (a public civic reference point, NOT a competitor), region tagline, intro hook.
CITIES = [
    {
        "slug": "corona-del-mar-phone-psychic", "city": "Corona del Mar", "state": "CA",
        "county": "Orange County, California", "region": "Newport Beach & the Orange Coast",
        "zips": ["92625", "92614"],
        "hoods": ["the Village", "Shore Cliffs", "Cameo Shores", "Irvine Terrace", "Newport Coast", "Pelican Hill"],
        "landmarks": ["Corona del Mar State Beach", "Little Corona", "the Sherman Library & Gardens", "Pacific Coast Highway", "Fashion Island nearby", "Big Corona"],
        "civic": "the Corona del Mar branch library on Marigold Avenue",
        "hook": "between the bluffs on PCH or up in Newport Coast",
    },
    {
        "slug": "dana-point-phone-psychic", "city": "Dana Point", "state": "CA",
        "county": "Orange County, California", "region": "the South Orange Coast",
        "zips": ["92629", "92624"],
        "hoods": ["the Lantern District", "Monarch Beach", "Capistrano Beach", "the Headlands", "Niguel Shores"],
        "landmarks": ["Dana Point Harbor", "Doheny State Beach", "Salt Creek Beach", "the Ocean Institute", "Pacific Coast Highway"],
        "civic": "the Dana Point Community Center on Golden Lantern",
        "hook": "down in the Lantern District or up by Monarch Beach",
    },
    {
        "slug": "vacaville-phone-psychic", "city": "Vacaville", "state": "CA",
        "county": "Solano County, California", "region": "Solano County, between Sacramento and the Bay",
        "zips": ["95687", "95688", "95696"],
        "hoods": ["Browns Valley", "North Village", "Alamo", "Cheyenne", "Padan", "the Creekside area"],
        "landmarks": ["the Vacaville Premium Outlets", "Lagoon Valley Park", "Andrews Park", "the old Nut Tree", "Travis Air Force Base nearby"],
        "civic": "the Vacaville Public Library on Town Square Place",
        "hook": "out in Browns Valley or off Alamo Drive",
    },
    {
        "slug": "pismo-beach-phone-psychic", "city": "Pismo Beach", "state": "CA",
        "county": "San Luis Obispo County, California", "region": "the Five Cities on the Central Coast",
        "zips": ["93449"],
        "hoods": ["Shell Beach", "Sunset Palisades", "the Pier area", "Pismo Heights", "the Mesa"],
        "landmarks": ["the Pismo Pier", "the Monarch Butterfly Grove", "Dinosaur Caves Park", "the Pismo Beach Premium Outlets", "the Oceano Dunes"],
        "civic": "the Pismo Beach City Hall on Pomeroy Avenue",
        "hook": "up in Shell Beach or down by the pier",
    },
    {
        "slug": "interlaken-phone-psychic", "city": "Interlaken", "state": "CA",
        "county": "Santa Cruz County, California", "region": "the Pajaro Valley near Watsonville",
        "zips": ["95076"],
        "hoods": ["the Pinto Lake area", "Wheelock", "Amesti", "Green Valley", "Buena Vista"],
        "landmarks": ["Pinto Lake", "the Pajaro Valley farmland", "the Watsonville Slough", "Highway 152", "Mount Madonna nearby"],
        "civic": "the Pinto Lake County Park entrance on Green Valley Road",
        "hook": "out by Pinto Lake or along Green Valley Road",
    },
    {
        "slug": "lakeport-phone-psychic", "city": "Lakeport", "state": "CA",
        "county": "Lake County, California", "region": "the Clear Lake basin",
        "zips": ["95453"],
        "hoods": ["downtown Lakeport", "the lakefront", "Lakeside Heights", "Scotts Valley", "Finley"],
        "landmarks": ["Clear Lake", "Library Park", "the Lake County Courthouse Museum", "Mount Konocti views", "Clear Lake State Park nearby"],
        "civic": "the Lake County Courthouse on Main Street",
        "hook": "along the lakefront or up in Lakeside Heights",
    },
    {
        "slug": "rowland-heights-phone-psychic", "city": "Rowland Heights", "state": "CA",
        "county": "Los Angeles County, California", "region": "the eastern San Gabriel Valley",
        "zips": ["91748", "91745"],
        "hoods": ["Pathfinder", "Nogales", "the Colima corridor", "Powder Canyon", "Vantage Pointe"],
        "landmarks": ["Schabarum Regional Park", "the Puente Hills", "the Pomona (60) Freeway", "Powder Canyon trails", "the Colima Road shops"],
        "civic": "the Rowland Heights Community Center on Nogales Street",
        "hook": "up by Powder Canyon or along Colima Road",
    },
    {
        "slug": "palmdale-phone-psychic", "city": "Palmdale", "state": "CA",
        "county": "Los Angeles County, California", "region": "the Antelope Valley",
        "zips": ["93550", "93551", "93552", "93591"],
        "hoods": ["Rancho Vista", "Anaverde", "Quartz Hill side", "the Courson area", "Desert View Highlands"],
        "landmarks": ["the Antelope Valley poppy fields", "the Palmdale Amphitheater", "DryTown Water Park", "Marie Kerr Park", "the Antelope Valley (14) Freeway"],
        "civic": "Palmdale City Hall on East Avenue Q",
        "hook": "out in Rancho Vista or up toward Anaverde",
    },
    {
        "slug": "solvang-phone-psychic", "city": "Solvang", "state": "CA",
        "county": "Santa Barbara County, California", "region": "the Santa Ynez Valley",
        "zips": ["93463"],
        "hoods": ["the Danish village center", "Alisal", "Skytt Mesa", "the Atterdag area"],
        "landmarks": ["the Old Mission Santa Inés", "the Solvang windmills", "Hans Christian Andersen Park", "Santa Ynez Valley wine country", "Highway 246"],
        "civic": "Solvang City Hall on First Street",
        "hook": "near the mission or out toward the Alisal",
    },
    {
        "slug": "placerville-phone-psychic", "city": "Placerville", "state": "CA",
        "county": "El Dorado County, California", "region": "the Sierra foothills Gold Country",
        "zips": ["95667"],
        "hoods": ["historic Main Street", "the Hangtown area", "Smith Flat", "Gold Hill side", "Cedar Ravine"],
        "landmarks": ["historic Main Street", "Gold Bug Park & Mine", "Apple Hill nearby", "the Highway 50 corridor toward Tahoe", "the El Dorado County fairgrounds"],
        "civic": "the El Dorado County Historical Museum on Placerville Drive",
        "hook": "up Cedar Ravine or out toward Smith Flat",
    },
    {
        "slug": "koreatown-phone-psychic", "city": "Koreatown", "state": "CA",
        "county": "Los Angeles, California", "region": "central Los Angeles",
        "zips": ["90004", "90005", "90006", "90010", "90020"],
        "hoods": ["Wilshire Center", "the Wiltern area", "Country Club Park", "Harvard Heights edge", "the Vermont corridor"],
        "landmarks": ["the Wiltern Theatre", "Lafayette Park", "the Wilshire/Western Metro station", "Wilshire Boulevard", "the Robert F. Kennedy Community Schools"],
        "civic": "the Pio Pico Koreatown branch library on Grand View Street",
        "hook": "off Wilshire or near the Wiltern",
    },
    {
        "slug": "healdsburg-phone-psychic", "city": "Healdsburg", "state": "CA",
        "county": "Sonoma County, California", "region": "Sonoma wine country",
        "zips": ["95448"],
        "hoods": ["the Plaza", "Fitch Mountain", "the Dry Creek side", "Alexander Valley edge", "Parkland Farms"],
        "landmarks": ["the Healdsburg Plaza", "the Russian River", "Dry Creek Valley vineyards", "Fitch Mountain", "Alexander Valley"],
        "civic": "Healdsburg City Hall on Grant Street",
        "hook": "near the Plaza or out toward Dry Creek",
    },
    {
        "slug": "ukiah-phone-psychic", "city": "Ukiah", "state": "CA",
        "county": "Mendocino County, California", "region": "inland Mendocino County",
        "zips": ["95482"],
        "hoods": ["downtown Ukiah", "Westside", "Yokayo", "the Vichy Springs area", "Deerwood"],
        "landmarks": ["the Grace Hudson Museum", "Lake Mendocino", "Low Gap Park", "the Mendocino County Courthouse", "the Highway 101 corridor"],
        "civic": "the Mendocino County Courthouse on West Perkins Street",
        "hook": "on the Westside or out by Vichy Springs",
    },
    {
        "slug": "cerritos-phone-psychic", "city": "Cerritos", "state": "CA",
        "county": "Los Angeles County, California", "region": "the Gateway Cities",
        "zips": ["90703"],
        "hoods": ["Cerritos Towne Center", "the College Park area", "Sunny Cove", "the Bloomfield corridor"],
        "landmarks": ["the Cerritos Center for the Performing Arts", "Los Cerritos Center", "Cerritos Regional Park", "the 605 and 91 freeways", "Cerritos Sculpture Garden"],
        "civic": "Cerritos City Hall on Bloomfield Avenue",
        "hook": "near the Towne Center or off Bloomfield",
    },
    {
        "slug": "cambria-phone-psychic", "city": "Cambria", "state": "CA",
        "county": "San Luis Obispo County, California", "region": "the Central Coast near San Simeon",
        "zips": ["93428"],
        "hoods": ["the East Village", "the West Village", "Marine Terrace", "Lodge Hill", "Park Hill"],
        "landmarks": ["Moonstone Beach", "the Fiscalini Ranch Preserve", "Hearst Castle near San Simeon", "Highway 1", "the Piedras Blancas elephant seals"],
        "civic": "the Cambria Veterans Memorial Building on Main Street",
        "hook": "up on Lodge Hill or down by Moonstone Beach",
    },
    {
        "slug": "rancho-cordova-phone-psychic", "city": "Rancho Cordova", "state": "CA",
        "county": "Sacramento County, California", "region": "greater Sacramento",
        "zips": ["95670", "95742", "95741"],
        "hoods": ["Mills", "Anatolia", "Sunrise Douglas", "the Old Town", "Rancho Murieta side"],
        "landmarks": ["the American River", "Hagan Community Park", "the Highway 50 corridor", "Mather Airport", "Folsom Lake nearby"],
        "civic": "Rancho Cordova City Hall on Civic Center Drive",
        "hook": "out in Anatolia or near Old Town",
    },
]

TPL = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Phone Psychic Readings {city}, {state} | Live 24/7 from $1/Min</title>
<meta name="description" content="Phone psychic readings in {city}, {state} - talk to a hand-vetted psychic 24/7 from anywhere in {region}. First call $1/min, 15 minutes for $10, hang up anytime.">
<meta name="keywords" content="phone psychic {city_l}, psychic reading {city_l}, psychic {city_l} {state_l}, tarot reading {city_l}, love psychic {city_l}">
<meta name="robots" content="index, follow">
<meta property="og:title" content="Phone Psychic Readings {city}, {state} | Live 24/7">
<meta property="og:description" content="Talk to a hand-vetted psychic by phone from anywhere in {city}. First call $1/min.">
<meta property="og:type" content="website">
<meta property="og:image" content="assets/img/phone-psychic-readings.jpg">
<link rel="canonical" href="https://www.phonepsychicreaders.com/{slug}.html">
<link rel="icon" type="image/png" href="assets/img/phone-psychic-readers-icon.png">
<link rel="stylesheet" href="assets/css/styles.css">
<script type="application/ld+json">
{{ "@context": "https://schema.org", "@type": "LocalBusiness", "@id": "https://www.phonepsychicreaders.com/{slug}.html#business", "name": "Phone Psychic Readers - {city}", "image": "https://www.phonepsychicreaders.com/assets/img/phone-psychic-readers-logo.png", "telephone": "+1-888-920-6662", "email": "phonepsychicreaders@gmail.com", "url": "https://www.phonepsychicreaders.com/{slug}.html", "priceRange": "$", "description": "Live phone psychics serving {city}, {state} 24/7 - psychic, tarot, astrology, and numerology readings from $1 per minute.", "areaServed": {{ "@type": "City", "name": "{city}", "containedInPlace": {{ "@type": "AdministrativeArea", "name": "{county}" }} }}, "address": {{ "@type": "PostalAddress", "addressLocality": "{city}", "addressRegion": "{state}", "addressCountry": "US" }}, "openingHoursSpecification": {{ "@type": "OpeningHoursSpecification", "dayOfWeek": ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"], "opens": "00:00", "closes": "23:59" }}, "contactPoint": {{ "@type": "ContactPoint", "telephone": "+1-888-920-6662", "contactType": "customer service", "availableLanguage": "English" }} }}
</script>
<script type="application/ld+json">
{{ "@context": "https://schema.org", "@type": "BreadcrumbList", "itemListElement": [
  {{ "@type": "ListItem", "position": 1, "name": "Home", "item": "https://www.phonepsychicreaders.com/" }},
  {{ "@type": "ListItem", "position": 2, "name": "Locations", "item": "https://www.phonepsychicreaders.com/locations.html" }},
  {{ "@type": "ListItem", "position": 3, "name": "{city}, {state}", "item": "https://www.phonepsychicreaders.com/{slug}.html" }}
] }}
</script>
<script type="application/ld+json">
{{ "@context": "https://schema.org", "@type": "FAQPage", "mainEntity": [
  {{ "@type": "Question", "name": "Who's the best psychic near me in {city}?", "acceptedAnswer": {{ "@type": "Answer", "text": "The best psychic for you in {city} is the one matched to your question. Call (888) 920-6662 and our team connects you with a hand-vetted reader in under 60 seconds, 24/7, from anywhere in {city}." }} }},
  {{ "@type": "Question", "name": "Can I get a psychic reading in {city} tonight?", "acceptedAnswer": {{ "@type": "Answer", "text": "Yes. The phone line is open 24 hours a day, every day, including holidays. You can get a reading at any hour from any {city} zip code. Your first minute is $1." }} }},
  {{ "@type": "Question", "name": "How much does a psychic reading in {city} cost?", "acceptedAnswer": {{ "@type": "Answer", "text": "First-time callers pay $1 per minute, or 15 minutes for $10. There is no minimum and you can hang up anytime. A 100% satisfaction promise stands behind every call." }} }},
  {{ "@type": "Question", "name": "Do I have to drive anywhere for a reading in {city}?", "acceptedAnswer": {{ "@type": "Answer", "text": "No. This is a phone service. You stay home in {city} and call. No drive, no parking, no appointment." }} }}
] }}
</script>
</head>
<body>


<!--#include:header-->

<main id="main">

  <nav class="breadcrumb" aria-label="Breadcrumb">
    <div class="container">
      <a href="index.html">Home</a> › <a href="locations.html">Locations</a> › <span>{city}, {state}</span>
    </div>
  </nav>

  <section class="hero">
    <div class="container hero-grid">
      <div class="hero-copy">
        <p class="eyebrow"><span class="stars" aria-hidden="true">★</span> Trusted by callers across {city} &amp; {region}</p>
        <h1>Phone Psychic Readings in {city}, {state} - Live, 24/7, From $1/Min</h1>
        <p class="lede">Get a <strong>phone psychic reading in {city}</strong> without leaving home. Every psychic on our line is hand-vetted by our master psychics. Connect in under 60 seconds, {hook}. Your first minute is $1 and you can hang up anytime.</p>
        <div class="hero-cta">
          <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
          <a class="btn btn-ghost btn-lg" href="tel:+18889206662">Get 15 min for $10</a>
        </div>
        <ul class="hero-trust">
          <li>100% Satisfaction Promise</li>
          <li>Hand-vetted Master Psychics</li>
          <li>Hang up anytime</li>
        </ul>
      </div>
      <div class="hero-img">
        <img src="assets/img/phone-psychic-readings.jpg" alt="Phone psychic readings in {city}, {state} - live psychic available 24 hours a day" width="520" height="390">
      </div>
    </div>
  </section>

  <section>
    <div class="container">
      <h2>Accurate Phone Psychics for {city}, {state}</h2>
      <div class="intro-grid">
        <div>
          <p>A <strong>phone psychic reading in {city}</strong> is the fastest way to get real answers - no drive, no waiting room, no appointment. First-time callers get an introductory rate of <strong>$1 per minute</strong>, or grab the <strong>15 minutes for $10</strong> bundle. Talk to a live phone psychic about love, money, career, and the questions you can't shake.</p>
          <p>We serve every part of {city} and {region} by phone. The line is open 24/7, so the reader is awake when you are - late at night, early morning, weekends, holidays.</p>
          <p><a class="btn btn-primary" href="tel:+18889206662">Call (888) 920-6662 now</a></p>
        </div>
        <img src="assets/img/live-phone-psychic.jpg" alt="Live phone psychic taking a 24/7 call from a {city} caller" width="480" height="360">
      </div>
    </div>
  </section>

  <aside class="trust">
    <div class="container trust-inner">
      <div><strong>Vetted</strong><span>Hand-picked phone psychics</span></div>
      <div><strong>24/7</strong><span>Live, {city}-wide</span></div>
      <div><strong>$1/min</strong><span>First-call rate</span></div>
      <div><strong>100%</strong><span>Satisfaction promise</span></div>
    </div>
  </aside>

  <section>
    <div class="container">

      <div class="category">
        <div>
          <h2><a href="psychic.html">Psychic</a></h2>
          <p>Looking for clarity in love, career, or life's next chapter in {city}? Our experienced phone psychics help you see the situation straight - a full range of phone-based psychic services, connecting you with a trusted reader from anywhere in {city}, anytime.</p>
          <ul class="service-tags">
            <li>Psychic Readings</li><li>Tarot Card Readings</li><li>Love Psychic Readings</li><li>Relationship Readings</li><li>Career Psychic Readings</li><li>Dream Interpretation</li><li>Aura Readings</li><li>Past Life Readings</li>
          </ul>
          <a class="cat-all-link" href="psychic.html">See all Psychic services →</a>
        </div>
        <div class="category-media"><img src="assets/img/phone-psychic-reading.jpg" alt="Phone psychic giving a live reading to a {city} caller" width="480" height="360"></div>
      </div>

      <div class="category">
        <div>
          <h2><a href="astrologer.html">Astrologer</a></h2>
          <p>For {city} callers who want real answers, not generic horoscopes. Personal astrology readings - birth chart and natal chart interpretations - based on your exact date, time, and place of birth, to understand relationship patterns, career timing, and big life shifts. Available by phone for anyone in {city}.</p>
          <ul class="service-tags">
            <li>Personal Astrology Reading</li><li>Birth Chart Reading</li><li>Natal Chart Reading</li><li>Love Compatibility</li><li>Career Timing</li><li>Future Trends</li>
          </ul>
          <a class="cat-all-link" href="astrologer.html">See all Astrologer services →</a>
        </div>
        <div class="category-media"><img src="assets/img/astrology-phone-reading.jpg" alt="Astrologer reviewing a birth chart for a {city} phone reading" width="480" height="360"></div>
      </div>

      <div class="category">
        <div>
          <h2><a href="numerologist.html">Numerologist</a></h2>
          <p>Our numerology readings break down the meaning behind your numbers and how they shape your life in {city} - life-path, destiny, name, and compatibility numerology, explained in plain terms. Helpful for personal strengths, relationships, and career alignment. Available by phone across {city}.</p>
          <ul class="service-tags">
            <li>Life Path Number</li><li>Destiny Number</li><li>Name Numerology</li><li>Compatibility Numerology</li>
          </ul>
          <a class="cat-all-link" href="numerologist.html">See all Numerologist services →</a>
        </div>
        <div class="category-media"><img src="assets/img/numerology-phone-reading.jpg" alt="Numerologist calculating a life path number for a {city} phone reading" width="480" height="360"></div>
      </div>

      <div class="category">
        <div>
          <h2><a href="fortune-telling-services.html">Fortune Telling Services</a></h2>
          <p>For {city} folks who want direct insight into the future without the fluff. These phone sessions focus on love, relationships, career, and personal direction - intuitive insight and psychic interpretation so you feel grounded instead of overwhelmed.</p>
          <ul class="service-tags">
            <li>Love &amp; Romance</li><li>Relationships</li><li>Career &amp; Work</li><li>Personal Direction</li>
          </ul>
          <a class="cat-all-link" href="fortune-telling-services.html">See all Fortune Telling Services →</a>
        </div>
        <div class="category-media"><img src="assets/img/fortune-telling-phone.jpg" alt="Fortune teller giving a phone reading to a {city} caller" width="480" height="360"></div>
      </div>

    </div>
  </section>

  <section class="section-soft">
    <div class="container" style="max-width: 860px;">
      <h2>Serving Every {city} Neighborhood</h2>
      <p>We take calls from every part of {city} and {region}. You don't need to live near anything - the phone reaches all of it: {hoods}. Whatever corner you're in, it's the same number, the same hand-vetted readers, the same $1 first minute.</p>

      <h2>Every {city} Zip Code</h2>
      <p>It does not matter which zip you are in. We cover all of them by phone: {zips}. Same number, same readers, same introductory rate.</p>

      <h2>{city} Locals Know the Area</h2>
      <p>You know {city}. So do we - {landmarks}. Our readers get that the question behind your question is usually a real one: rent, a job, a relationship, a move. We keep it straight with you, no fear tactics, no pressure.</p>

      <h2>How to Reach Us From Anywhere in {city}</h2>
      <p>There is nothing to drive to - it is a phone call. People ask where we are "based" relative to town, so here is the easy way to picture it. Start at {civic}. From there you would normally drive and wait to see someone. With us you skip all of that. From that spot, or anywhere else in {city}, the route is the same: pick up your phone and dial (888) 920-6662. You are connected in under a minute.</p>

      <h2>What Do I Do If I Need a Reading Right Now in {city}?</h2>
      <p>Call. That's it. The line is open 24/7, including holidays and the middle of the night. You will reach a real, hand-vetted reader, not a recording. First minute is $1. Hang up the second you have what you need.</p>
    </div>
  </section>

  <section class="section-soft" id="offer">
    <div class="container" style="text-align: center;">
      <h2>Speak With a Live Phone Psychic in {city} Right Now</h2>
      <p>Try us out at our introductory rate - get comfortable with your phone psychic before you commit to more time.</p>
      <div class="pricing-card">
        <span class="stars" aria-hidden="true">★★★★★</span>
        <span class="price">$1<small>/min</small></span>
        <p style="margin: 0.5rem 0 0;">First-time callers</p>
        <span class="bundle">Or get <strong>15 minutes for $10</strong></span>
        <p style="margin: 1.25rem 0 0;">
          <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
        </p>
      </div>
    </div>
  </section>

  <section>
    <div class="container">
      <h2>What {city} Callers Are Saying</h2>
      <div class="quote-grid">
        <blockquote>
          <span class="stars" aria-hidden="true">★★★★★</span>
          <p>"I called from {city} unsure and a little skeptical. Within a few minutes she described something she couldn't have known. I hung up with a clear plan instead of the knot I'd carried for weeks."</p>
          <footer class="quote-author">
            <img src="assets/img/proof-01.jpg" alt="Verified caller from {city} {state}" width="48" height="48" loading="lazy">
            <cite>Danielle, {city} {state}</cite>
          </footer>
        </blockquote>
        <blockquote>
          <span class="stars" aria-hidden="true">★★★★★</span>
          <p>"$1 a minute to try it and hang up whenever - no reason not to. Honest and kind at the same time, and it's the reason I finally made the decision I'd been avoiding."</p>
          <footer class="quote-author">
            <img src="assets/img/proof-02.jpg" alt="Verified caller from {city} {state}" width="48" height="48" loading="lazy">
            <cite>Marcus, {city} {state}</cite>
          </footer>
        </blockquote>
      </div>
    </div>
  </section>

  <section class="section-soft faq">
    <div class="container">
      <h2>{city} Phone Psychic Readings - Frequently Asked Questions</h2>
      <details><summary>Who's the best psychic near me in {city}?</summary><p>The best one is the one matched to your question. Call (888) 920-6662 and our team connects you with a hand-vetted reader in under 60 seconds, from any {city} neighborhood.</p></details>
      <details><summary>Can I get a psychic reading in {city} tonight?</summary><p>Yes. The line is open 24 hours a day, every day, including holidays. Any {city} zip code, any hour. First minute is $1.</p></details>
      <details><summary>How much does a reading cost?</summary><p>First-time callers pay $1/min, or 15 minutes for $10. No minimum, and you can hang up anytime.</p></details>
      <details><summary>Do I have to drive anywhere?</summary><p>No. It's a phone service. You stay home in {city} and call - no drive, no parking, no appointment.</p></details>
      <details><summary>Is my call private?</summary><p>Yes. You call from wherever you are, the reading is confidential, and there's a 100% satisfaction promise.</p></details>
    </div>
  </section>

  <section class="cta-band">
    <div class="container">
      <h2>Get Accurate Answers From a Live Phone Psychic, {city}</h2>
      <p>Looking for answers about love? Stuck on one of life's hardest questions? A hand-vetted reader is ready right now, anywhere in {city}. $1/min first call · 15 minutes for $10 · hang up anytime · 100% satisfaction promise.</p>
      <a class="btn btn-primary btn-lg" href="tel:+18889206662">Call (888) 920-6662</a>
      <span class="stars" aria-hidden="true" style="display:block; margin-top:1rem; font-size:1.3rem;">★★★★★</span>
    </div>
  </section>

</main>

<!--#include:footer-->

</body>
</html>
"""


def human_list(items):
    if len(items) == 1:
        return items[0]
    return ", ".join(items[:-1]) + ", and " + items[-1]


for c in CITIES:
    html = TPL.format(
        slug=c["slug"], city=c["city"], state=c["state"],
        city_l=c["city"].lower(), state_l=c["state"].lower(),
        county=c["county"], region=c["region"], hook=c["hook"],
        civic=c["civic"],
        hoods=human_list(c["hoods"]),
        zips=", ".join(c["zips"]),
        landmarks=human_list(c["landmarks"]),
    )
    path = os.path.join(OUT, c["slug"] + ".html")
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(html)
    print("wrote", c["slug"] + ".html")

print("done", len(CITIES), "pages")
