#!/usr/bin/env bash
# Flip this site between pre-launch and live. Run from the repository root.
#
#   bash tools/set_launch_state.sh          pre-launch: robots Disallow + noindex
#   bash tools/set_launch_state.sh --live   live: indexable, writes a sitemap
#
# robots.txt asks well-behaved crawlers not to fetch; the noindex tag tells the
# ones that fetch anyway not to list. Neither alone is enough, so both move
# together and this script is the only thing that moves them. Half a guard reads
# as blocked to a crawler and as launched to a person skimming the file.
set -euo pipefail
cd "$(dirname "$0")/.."

LIVE=0
[ "${1:-}" = "--live" ] && LIVE=1
TAG='<meta name="robots" content="noindex,nofollow">'

for f in index.html explorer.html; do
  [ -f "$f" ] || { echo "missing $f; run this from the repository root" >&2; exit 1; }
done

if [ "$LIVE" -eq 1 ]; then
  printf 'User-agent: *\nAllow: /\nSitemap: https://cmfdi.netzeropolicylab.com/sitemap.xml\n' > robots.txt
  cat > sitemap.xml <<XML
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://cmfdi.netzeropolicylab.com/</loc><priority>1.0</priority></url>
  <url><loc>https://cmfdi.netzeropolicylab.com/explorer.html</loc><priority>0.9</priority></url>
</urlset>
XML
  for f in index.html explorer.html; do
    /usr/bin/python3 - "$f" "$TAG" <<'PY'
import io, re, sys
p, tag = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read()
s = s.replace(tag + "\n", "").replace(tag, "")
# Match any wording of the guard comment. An earlier version removed only its
# own phrasing, so a comment written by a different script survived every flip
# and the file grew one stale line per round trip.
s = re.sub(r"[ \t]*<!--\s*PRE-LAUNCH GUARD:.*?-->\n?", "", s, flags=re.S)
io.open(p, "w", encoding="utf-8").write(s)
PY
  done
  echo "LIVE. robots.txt allows crawling, noindex removed, sitemap written."
else
  printf 'User-agent: *\nDisallow: /\n' > robots.txt
  rm -f sitemap.xml
  for f in index.html explorer.html; do
    /usr/bin/python3 - "$f" "$TAG" <<'PY'
import io, sys
p, tag = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read()
if tag not in s:
    s = s.replace("</head>", tag + "\n<!-- PRE-LAUNCH GUARD: removed by tools/set_launch_state.sh --live -->\n</head>", 1)
    io.open(p, "w", encoding="utf-8").write(s)
PY
  done
  echo "PRE-LAUNCH. robots.txt disallows crawling, noindex on both pages."
fi

bash tools/check_launch_state.sh
