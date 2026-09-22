#!/usr/bin/env bash
# Assert robots.txt and the noindex tags agree. Exit 1 if they do not.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f robots.txt ] || { echo "FAIL robots.txt missing; the launch state is undeclared" >&2; exit 1; }
blocked=0; grep -q 'Disallow: /' robots.txt && blocked=1
n=0
for f in index.html explorer.html; do grep -q 'noindex' "$f" && n=$((n+1)); done
if [ "$blocked" -eq 1 ] && [ "$n" -ne 2 ]; then
  echo "FAIL robots.txt blocks crawlers but only $n of 2 pages carry noindex" >&2; exit 1
elif [ "$blocked" -eq 0 ] && [ "$n" -ne 0 ]; then
  echo "FAIL robots.txt allows crawling but $n page(s) still carry noindex" >&2; exit 1
elif [ "$blocked" -eq 1 ]; then
  echo "ok  PRE-LAUNCH: robots Disallow + noindex on both pages"
else
  echo "ok  LIVE: indexable, no noindex tags"
fi
