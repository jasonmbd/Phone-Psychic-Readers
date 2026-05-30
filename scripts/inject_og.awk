# Open Graph + Twitter Card normalizer
# Run as a build-time post-processor on each built HTML page.
#
# Two jobs:
# 1. Rewrite any relative og:image content (e.g. "assets/img/foo.jpg") to
#    its absolute URL ("https://www.phonepsychicreaders.com/assets/img/foo.jpg").
#    Facebook, LinkedIn, Slack, iMessage, Discord all require absolute
#    URLs for OG images - relative paths produce no preview thumbnail.
# 2. Inject the social-meta tags that aren't authored per-page:
#      og:url           (mirrors <link rel="canonical">)
#      og:site_name     ("Phone Psychic Readers")
#      og:image:alt     (mirrors the page <title>)
#      twitter:card     ("summary_large_image")
#      twitter:site     (placeholder; can be populated later)
#      twitter:title    (mirrors og:title)
#      twitter:description (mirrors og:description)
#      twitter:image    (mirrors absolute og:image)
# Each tag is injected only if missing - the awk tracks "has_*" flags so
# it never duplicates a tag the author already wrote.
#
# Idempotent: re-running on already-normalized HTML is a no-op.

function extract_attr(line, attr,    pat, s) {
  pat = attr "=\"[^\"]*\""
  if (match(line, pat)) {
    s = substr(line, RSTART, RLENGTH)
    sub("^" attr "=\"", "", s)
    sub("\"$", "", s)
    return s
  }
  return ""
}

BEGIN {
  BASE = "https://www.phonepsychicreaders.com"
  SITE_NAME = "Phone Psychic Readers"
  og_title = ""; og_desc = ""; og_image_abs = ""; canonical = ""
  page_title = ""
  has_og_url = 0; has_og_site = 0; has_og_image_alt = 0
  has_tw_card = 0; has_tw_title = 0; has_tw_desc = 0; has_tw_image = 0
  injected = 0
}

# Capture metadata as it streams past
/<title>/ {
  if (match($0, /<title>[^<]*<\/title>/)) {
    s = substr($0, RSTART, RLENGTH)
    sub(/^<title>/, "", s); sub(/<\/title>$/, "", s)
    page_title = s
  }
}

/<meta property="og:title"/ {
  og_title = extract_attr($0, "content")
}

/<meta property="og:description"/ {
  og_desc = extract_attr($0, "content")
}

# Rewrite relative og:image -> absolute as it passes through
/<meta property="og:image"/ {
  v = extract_attr($0, "content")
  if (v != "" && v !~ /^https?:\/\//) {
    og_image_abs = BASE "/" v
    sub(/content="[^"]*"/, "content=\"" og_image_abs "\"")
  } else {
    og_image_abs = v
  }
}

/<meta property="og:url"/        { has_og_url = 1 }
/<meta property="og:site_name"/  { has_og_site = 1 }
/<meta property="og:image:alt"/  { has_og_image_alt = 1 }
/<meta name="twitter:card"/      { has_tw_card = 1 }
/<meta name="twitter:title"/     { has_tw_title = 1 }
/<meta name="twitter:description"/ { has_tw_desc = 1 }
/<meta name="twitter:image"/     { has_tw_image = 1 }
/<link rel="canonical"/          { canonical = extract_attr($0, "href") }

# Inject missing tags right before </head>
/<\/head>/ {
  if (!injected) {
    if (!has_og_url && canonical != "") {
      print "<meta property=\"og:url\" content=\"" canonical "\">"
    }
    if (!has_og_site) {
      print "<meta property=\"og:site_name\" content=\"" SITE_NAME "\">"
    }
    if (!has_og_image_alt && page_title != "" && og_image_abs != "") {
      print "<meta property=\"og:image:alt\" content=\"" page_title "\">"
    }
    if (!has_tw_card) {
      print "<meta name=\"twitter:card\" content=\"summary_large_image\">"
    }
    if (!has_tw_title) {
      tw_t = (og_title != "") ? og_title : page_title
      if (tw_t != "") print "<meta name=\"twitter:title\" content=\"" tw_t "\">"
    }
    if (!has_tw_desc && og_desc != "") {
      print "<meta name=\"twitter:description\" content=\"" og_desc "\">"
    }
    if (!has_tw_image && og_image_abs != "") {
      print "<meta name=\"twitter:image\" content=\"" og_image_abs "\">"
    }
    # Preload the hero (= og:image) so it starts downloading before the
    # body parses - directly improves Largest Contentful Paint. Prefer
    # the .webp variant since img_optimize.awk wraps the <img> tag with
    # a <picture> that serves WebP to 96%+ of in-use browsers.
    if (og_image_abs != "") {
      hero_webp = og_image_abs
      sub(/\.jpg$/, ".webp", hero_webp)
      if (hero_webp != og_image_abs) {
        print "<link rel=\"preload\" as=\"image\" href=\"" hero_webp "\" type=\"image/webp\" fetchpriority=\"high\">"
      } else {
        print "<link rel=\"preload\" as=\"image\" href=\"" og_image_abs "\" fetchpriority=\"high\">"
      }
    }
    injected = 1
  }
}

{ print }
