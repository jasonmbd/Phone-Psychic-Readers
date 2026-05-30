#!/usr/bin/env bash
# Resize oversized source JPGs/PNGs to a sane max width before re-running
# gen_webp.sh. Lighthouse flagged ~600 KiB of image savings on desktop:
# many source images are 1400-1920px wide but displayed at 480-520px CSS
# pixels (so 1040px max even at DPR 2.x). Anything wider than $MAX_W is
# downscaled in place (preserving aspect ratio); originals overwritten
# but recoverable from git.
set -euo pipefail
cd "$(dirname "$0")/.."

# Bounding box 1280x960 (~1.2 megapixels). Anything bigger on EITHER
# axis gets shrunk to fit. Catches both oversized landscape images and
# tall portrait images that are way bigger than their displayed area.
MAX_W=1280
MAX_H=960
resized=0
skipped=0
for img in assets/img/*.jpg assets/img/*.png; do
  [ -f "$img" ] || continue
  # Skip favicon-like tiny pngs
  case "$img" in
    *brand-icon*|*icon*) skipped=$((skipped+1)); continue ;;
  esac
  dims=$(magick identify -format "%w %h" "$img" 2>/dev/null || echo "0 0")
  w=$(echo $dims | awk '{print $1}')
  h=$(echo $dims | awk '{print $2}')
  if [ "$w" -gt "$MAX_W" ] || [ "$h" -gt "$MAX_H" ]; then
    magick "$img" -resize "${MAX_W}x${MAX_H}>" -strip -quality 85 "$img"
    new_dims=$(magick identify -format "%wx%h" "$img")
    new_kb=$(du -k "$img" | cut -f1)
    printf "  resized %-50s %dx%d -> %s, now %d KB\n" "$img" "$w" "$h" "$new_dims" "$new_kb"
    webp="${img%.*}.webp"
    [ -f "$webp" ] && rm -f "$webp"
    resized=$((resized+1))
  else
    skipped=$((skipped+1))
  fi
done

echo "resize_images: resized $resized, skipped $skipped (already <=${MAX_W}x${MAX_H})"
