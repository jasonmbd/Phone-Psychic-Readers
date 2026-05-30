#!/usr/bin/env bash
# Convert every assets/img/*.jpg to a sibling .webp at quality 80.
# Skips if .webp exists and is newer than the .jpg (idempotent on rebuild).
# WebP is ~50-70% smaller than equivalent-quality JPEG and supported in
# 96%+ of in-use browsers (Chrome/Edge 32+, Firefox 65+, Safari 14+).
set -euo pipefail
cd "$(dirname "$0")/.."

count=0; skipped=0
for jpg in assets/img/*.jpg; do
  [ -f "$jpg" ] || continue
  webp="${jpg%.jpg}.webp"
  if [ -f "$webp" ] && [ "$webp" -nt "$jpg" ]; then
    skipped=$((skipped+1))
    continue
  fi
  # -strip drops EXIF/color profiles; quality 75 + method 6 is the
  # mobile-perf sweet spot - hard to distinguish from 80 visually but
  # ~15-20% smaller files.
  magick "$jpg" -strip -quality 75 -define webp:method=6 "$webp" 2>/dev/null
  count=$((count+1))
done

if [ "$count" -gt 0 ]; then
  jpgs=$(du -ch assets/img/*.jpg 2>/dev/null | tail -1 | awk '{print $1}')
  webps=$(du -ch assets/img/*.webp 2>/dev/null | tail -1 | awk '{print $1}')
  echo "gen_webp: built $count, skipped $skipped (up-to-date). JPG total=$jpgs, WebP total=$webps"
else
  echo "gen_webp: all $skipped WebP up-to-date"
fi
