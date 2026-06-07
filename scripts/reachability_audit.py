#!/usr/bin/env python3
"""Audit internal-link reachability from the homepage over the built *.html files."""
import os, re, glob
from collections import deque

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOST = "phonepsychicreaders.com"

def slug_of(filename):
    base = os.path.basename(filename)
    if base.endswith(".html"):
        base = base[:-5]
    return "index" if base == "index" else base

# All real pages (exclude 404 from the "should be reachable" set)
all_files = [f for f in glob.glob(os.path.join(ROOT, "*.html"))]
all_slugs = {slug_of(f) for f in all_files}
pages = all_slugs - {"404"}

href_re = re.compile(r'href\s*=\s*["\']([^"\']+)["\']', re.IGNORECASE)

def normalize(href):
    h = href.strip()
    # drop fragments / queries
    h = h.split("#", 1)[0].split("?", 1)[0]
    if not h:
        return None
    # skip non-page protocols
    if h.startswith(("tel:", "mailto:", "javascript:", "data:")):
        return None
    # strip protocol + host (any of the variants)
    h = re.sub(r'^https?://(www\.)?' + re.escape(HOST), '', h, flags=re.IGNORECASE)
    # external link to a different host -> ignore
    if h.startswith("http://") or h.startswith("https://"):
        return None
    h = h.strip("/")
    if h == "":
        return "index"
    if h.endswith(".html"):
        h = h[:-5]
    return h

# Build adjacency
graph = {}
for f in all_files:
    s = slug_of(f)
    try:
        html = open(f, encoding="utf-8", errors="ignore").read()
    except Exception:
        html = ""
    targets = set()
    for m in href_re.findall(html):
        t = normalize(m)
        if t and t in all_slugs:
            targets.add(t)
    graph[s] = targets

# BFS from index
seen = {"index"}
q = deque(["index"])
while q:
    cur = q.popleft()
    for nxt in graph.get(cur, ()):
        if nxt not in seen:
            seen.add(nxt)
            q.append(nxt)

reachable = seen & pages
unreachable = sorted(pages - seen)

print(f"Total pages (excl. 404): {len(pages)}")
print(f"Reachable from homepage: {len(reachable)}")
print(f"UNREACHABLE: {len(unreachable)}")

# Categorize unreachable
def cat(s):
    if s.endswith("-tarot-card-meaning") or s.endswith("-tarot-card-meanings"): return "tarot-card"
    if s.endswith("-phone-psychic"): return "city-landing"
    for c in ("burbank","glendale","north-hollywood","toluca-lake","universal-city","sun-valley"):
        if s.startswith(c+"-"): return f"silo:{c}"
    return "other"

from collections import Counter
buckets = Counter(cat(s) for s in unreachable)
print("\n-- unreachable by category --")
for k,v in sorted(buckets.items(), key=lambda x:-x[1]):
    print(f"{v:4d}  {k}")

print("\n-- sample unreachable (first 40) --")
for s in unreachable[:40]:
    print("  ", s)
