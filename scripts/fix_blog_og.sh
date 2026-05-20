#!/usr/bin/env bash
# Fix blog-post OG image: was pointing at the logo, should point at the
# post's own hero image (the assets/img/blog-*.jpg already used inline).
# Also bumps og:type from "website" to "article" for blog posts, which
# is the correct OG type for editorial content.
set -euo pipefail
cd "$(dirname "$0")/.."

# Pull canonical blog-post list from blog.html so this stays in sync
# with what the sitemap classifier uses.
POSTS=$(awk '
  /<li class="post-card"/{ p=1; next }
  p && /href="/ {
    if (match($0, /href="[a-z0-9-]+\.html"/)) {
      hr=substr($0, RSTART, RLENGTH)
      gsub(/href="|"/, "", hr)
      print hr
      p=0
    }
  }
' blog.html)

changed=0
for post in $POSTS; do
  src="src/$post"
  [ -f "$src" ] || { echo "  skip $post (no src)"; continue; }
  # The hero image is the first assets/img/blog-*.jpg referenced inline.
  hero=$(grep -oE 'assets/img/blog-[a-z0-9-]+\.(jpg|png)' "$src" | head -1 || true)
  if [ -z "$hero" ]; then
    echo "  skip $post (no blog-*.jpg in body)"
    continue
  fi
  # Only rewrite if og:image currently points at the logo (idempotent
  # for posts that have already been fixed).
  if ! grep -q 'og:image.*phone-psychic-readers-logo' "$src"; then
    echo "  $post: og:image already non-logo, leaving alone"
    continue
  fi
  # Swap og:image -> hero
  sed -i "s|<meta property=\"og:image\" content=\"assets/img/phone-psychic-readers-logo\.png\">|<meta property=\"og:image\" content=\"${hero}\">|" "$src"
  # Bump og:type to article (only if currently "website")
  sed -i 's|<meta property="og:type" content="website">|<meta property="og:type" content="article">|' "$src"
  changed=$((changed+1))
  echo "  $post -> $hero (og:type=article)"
done

echo "--- changed $changed blog post(s) ---"

# Rebuild so the change propagates and the og:image absolute-URL
# rewriter + twitter:image mirror pick up the new value.
bash build.sh > /tmp/bldogfix.log 2>&1
tail -3 /tmp/bldogfix.log

# Verify
echo "--- verify built blog posts now reference their own hero ==="
for post in $POSTS; do
  built="$post"
  [ -f "$built" ] || continue
  ogi=$(grep -oE 'og:image"[^>]+content="[^"]+"' "$built" | head -1 | sed -E 's/.*content="([^"]+)"/\1/')
  twi=$(grep -oE 'twitter:image"[^>]+content="[^"]+"' "$built" | head -1 | sed -E 's/.*content="([^"]+)"/\1/')
  printf "  %-70s og:image=%s\n" "$post" "${ogi#https://www.phonepsychicreaders.com/}"
done
