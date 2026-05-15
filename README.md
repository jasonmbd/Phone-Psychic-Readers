# Phone Psychic Readers

Static rebuild of phonepsychicreaders.com.

## Local development

Just open `index.html` in a browser, or run any static server from this folder:

```
npx serve
```

## Deployment

This repo is wired to Netlify. Any push to `main` triggers a deploy. `netlify.toml` sets caching headers and security headers; no build step required (plain HTML/CSS/JS).

## Structure

```
index.html        Home
readings.html     All reading types
about.html        About / approach / pricing
contact.html      Hours, email, phone
assets/css/       Stylesheet
assets/js/        Mobile nav toggle
assets/img/       (images go here)
```
