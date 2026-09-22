#!/usr/bin/env bash
# Post-deploy verification. Run after Pages is on and DNS has propagated.
#
# A static host returns 200 for paths that do not exist, so a status code alone
# proves nothing. Every check below reads the content type, and each runs twice
# with a fresh cache-buster because a CDN can serve one good response and one
# stale one.
set -euo pipefail
BASE="${1:-https://cmfdi.netzeropolicylab.com}"
fail=0

check () {  # path  expected-content-type-substring (never pass "": it matches everything)
  for i in 1 2; do
    out=$(curl -s -o /dev/null -w '%{http_code} %{content_type}' "$BASE$1?cb=$RANDOM$i")
    code=${out%% *}; ctype=${out#* }
    if [ "$code" != "200" ] || [[ "$ctype" != *"$2"* ]]; then
      echo "  FAIL $1 -> $code $ctype (wanted 200 + $2)"; fail=1; return
    fi
  done
  echo "  ok   $1 -> $ctype"
}

echo "Verifying $BASE"
check /                            text/html
check /explorer.html               text/html
check /data/cm-fdi-projects.csv    csv
check /vendor/d3.v7.9.0.min.js     javascript
check /vendor/world-atlas-110m.json json
# GitHub Pages serves an extensionless file as application/octet-stream, so
# this asserts the byte length instead of a content type.
for i in 1 2; do
  n=$(curl -s "$BASE/LICENSE?cb=$RANDOM$i" | wc -c | tr -d " ")
  if [ "${n:-0}" -lt 10000 ]; then echo "  FAIL /LICENSE -> $n bytes (wanted the CC BY 4.0 text)"; fail=1; break; fi
done
[ "$fail" -eq 0 ] && echo "  ok   /LICENSE -> $n bytes"

echo "  robots.txt says: $(curl -s "$BASE/robots.txt?cb=$RANDOM" | tr '\n' ' ')"
if curl -s "$BASE/?cb=$RANDOM" | grep -q noindex; then
  echo "  WARN the live page still carries a noindex tag"; fail=1
fi

[ "$fail" -eq 0 ] && echo "All checks passed. Now open the explorer and click one export button." \
                  || { echo "Some checks failed."; exit 1; }
