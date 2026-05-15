# Phone Psychic Readers

Static rebuild of phonepsychicreaders.com.

## Editing pages (IMPORTANT)

Pages are assembled from partials. **Edit `src/`, not the root `.html` files** —
the root files are generated and will be overwritten.

- `src/*.html` — page source. Each contains `<!--#include:header-->` and
  `<!--#include:footer-->` markers where the shared chrome goes.
- `partials/header.html` — global header + mega nav + skip-link (single source of truth).
- `partials/footer.html` — global footer + script tag.
- `build.sh` — assembles `src/*.html` + partials → root `*.html`.

### After any edit to a `src/` page or a partial:

```
bash build.sh
```

This regenerates the root `.html` files. Commit the regenerated root files
together with the `src/`/`partials/` changes.

Active-nav highlighting is set at runtime by `assets/js/main.js` (so the
header partial stays generic).

## Deployment

Netlify serves the repo as-is. Any push to `main` auto-deploys. `netlify.toml`
sets caching/security headers. No build runs on Netlify — `build.sh` is run
locally before committing, so the committed root HTML is fully static
(good for SEO, no flicker).

## Structure

```
src/              EDIT THESE — page sources with include markers
partials/         header.html, footer.html (global chrome)
build.sh          run after editing src/ or partials/
index.html …      GENERATED — do not edit directly
assets/css/       stylesheet
assets/js/        nav toggle, mega menu, active-nav
assets/img/       images
```
