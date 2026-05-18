# Location SEO Architecture & Rollout Plan

Status: DRAFT for approval. Nothing below is built yet except the Burbank
proof page (`phone-psychic-readings-burbank.html`, live for review).

---

## 1. Goal

Rank for geo-modified intent ("psychic reading Burbank", "tarot reading
Glendale", etc.) and win Google local + AI-assistant recommendations,
without tripping Google's scaled-content / helpful-content enforcement.

---

## 2. Architecture — 3-tier intersecting matrix

Two silos that cross. Service silo goes down; geo silo goes across.
Every city×category page sits at the intersection and links both ways.

```
TIER 1   Hub (GBP primary category)        psychic.html
             |
TIER 2   Category pages (GBP categories)   psychic-reading.html, phone-tarot-reading.html, ...
             |
TIER 3   City x Category pages             psychic-reading-burbank.html

         --- crossed by the geo axis ---

GEO HUB  locations.html  ->  City index (psychics-in-burbank.html)  ->  same TIER 3 pages
```

### Tier 1 — Hub (1 page)
- `psychic.html` stays the master. H1 = GBP **primary** category.
- Links DOWN to each Tier-2 category page only. No city links here.

### Tier 2 — Category pages (≈ one per GBP category)
Existing pages reused. Candidate GBP-category set:
- Psychic Reading — `psychic-reading.html`
- Phone Tarot Reading — `phone-tarot-reading.html`
- Astrology / Birth Chart — `birth-chart-reading.html`
- Love Psychic — `psychic-love-readings-by-phone.html`
- Clairvoyant — `clairvoyant-reading.html`
- (others as GBP secondary categories warrant)

Each category page gains:
- Up link to hub, lateral links to sibling categories
- A "Cities We Serve for [Category]" block linking down to Tier-3
- `Service` + `FAQPage` schema

### Tier 3 — City × Category pages
Pattern: `{category-slug}-{city}.html` (flat, matches build.sh).
Example/template: `psychic-reading-burbank.html` (Burbank proof, built).
Each page:
- Targets geo-modified head term (exact match in title/H1/first para)
- Unique local block: all zip codes, neighborhoods, landmarks, civic
  landmark directions, city info (the Burbank model)
- Links UP to parent category, ACROSS to ~5–8 sibling categories for
  the SAME city, and to that city's index page
- `LocalBusiness` (areaServed = city) + `BreadcrumbList` + `FAQPage` schema
- Breadcrumb nav: Home › [Category] › [City]

### Geo hub + city index (replaces /areas-serviced/)
- `locations.html` — States → cities directory. Repoint the
  `/areas-serviced/` and `/areas-serviced` redirects (currently → `/`)
  here.
- `psychics-in-{city}.html` — per-city index linking to every category
  for that city. This is the second silo axis; ranks for general
  "psychic [city]" and consolidates local relevance.

---

## 3. URL & build decisions

- Flat slugs `{category}-{city}.html` — keeps current `build.sh`
  (src/*.html → root) untouched. Nested folders signal hierarchy
  marginally better but would require reworking the build; not worth it.
  BreadcrumbList schema supplies the hierarchy signal instead.
- Self-canonical on every page. City page is NOT canonical to category
  (distinct intent — both index).
- Slug convention locked: `psychic-reading-burbank.html`,
  `phone-tarot-reading-burbank.html`, `psychics-in-burbank.html`.

---

## 4. Best-practice rules (the ones that matter most)

1. Unique-content floor: each city page must be ≥ ~40% unique vs
   template (real zips/neighborhoods/landmarks/local refs). This is the
   single biggest ranking + anti-penalty factor.
2. Phased rollout — do NOT publish thousands at once. Scaled
   programmatic location pages are Google's current #1 enforcement
   target. Prove a small batch ranks first.
3. "Near me" ownership: assign "psychic reading near me" to the
   existing `-near-me` pages, NOT every city page (avoid cannibalization).
4. Internal-link discipline: city page links parent + city index +
   5–8 relevant siblings — not all 30 services.
5. Segmented XML sitemaps (services vs locations) for separate
   indexation monitoring in Search Console.
6. Real local research per city before publishing — no fabricated
   landmarks. Quality block is templated in shape, unique in substance.
7. Decision pending: keep clean copy (recommended) vs the Writing
   Mission's "lots of typos" instruction (advised against — kills
   E-E-A-T and AI recommendation, contradicts the rest of the brief).

---

## 5. Rollout order

Phase 0 — Finalize Burbank template
- Add breadcrumbs, up/lateral link block, BreadcrumbList schema to
  `psychic-reading-burbank.html`. Lock the Tier-3 template.

Phase 1 — Scaffold (Burbank only, full matrix proof)
- `locations.html`, `psychics-in-burbank.html`, "Cities We Serve"
  block added to the Psychic Reading category page, redirects repointed.
- Result: one complete, fully-linked city proving the whole structure.

Phase 2 — Cities already on the original /areas-serviced/ page
- Enumerate the full original city list (LA County set includes
  Burbank, Beverly Hills, Glendale, Hollywood, Pasadena, Santa Monica,
  plus other counties/states on that page — to be extracted verbatim
  from the old page before build).
- Build the primary category (Psychic Reading) × each city first.

Phase 3 — Expand category coverage per city
- Add Tarot, Astrology, Love, etc. city pages for cities that show
  ranking traction in Phase 2.

Phase 4 — Nationwide expansion
- New cities by search volume, only after Phase 2–3 validate the model.

---

## 6. Build / infra changes required

- `_redirects` lines 67–68: `/areas-serviced/` and `/areas-serviced`
  → `/locations.html` (currently → `/`).
- New `src/` templates: city×category, city index, locations hub.
- `sitemap.xml`: split into services + locations sets.
- Header/footer: add "Locations" entry pointing to `locations.html`.
- CSS: likely reuse existing components; add `.breadcrumb` style.

---

## 7. Open decisions for sign-off

1. Approve the 3-tier matrix architecture above? (y/n)
2. Approve flat-slug URL convention? (y/n)
3. Clean copy vs. inject typos per Writing Mission? (recommend clean)
4. Phase 1 scope: full Burbank scaffold before any other city? (y/n)
5. Confirm GBP category list to use as the Tier-2 set (need your
   actual Google Business Profile primary + secondary categories).
