#!/bin/sh
# Tests of scrape.sh and policy.sh against a mock documentation backend
# (mock_backend.py). Needs curl, jq and python3, like the workflow.
#
#   tool/doc-modules/test/scrape_test.sh [COMPILE.exe]
#
# With the path of compile.exe, also checks that it accepts every output.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
TOOL=$(dirname "$HERE")
COMPILE=${1:-}
T=$(mktemp -d)
SERVER=
cleanup() {
  if [ -n "$SERVER" ]; then kill "$SERVER" 2>/dev/null || true; fi
  rm -rf "$T"
}
trap cleanup EXIT
trap 'exit 1' INT TERM HUP

python3 "$HERE/mock_backend.py" "$T/backend" "$T/port" &
SERVER=$!
mkdir -p "$T/backend/p" "$T/repo/packages"
i=0
while [ ! -s "$T/port" ]; do
  i=$((i + 1))
  [ "$i" -lt 100 ] || { echo "mock backend did not start" >&2; exit 1; }
  sleep 0.1
done
export OCAMLORG_DOC_URL="http://127.0.0.1:$(cat "$T/port")/"
export SCRAPE_RATE=1000/s SCRAPE_MAX_TIME=5 SCRAPE_DAY=0

PASS=0
FAIL=0
check() { # check NAME COMMAND...
  name=$1
  shift
  if "$@" >/dev/null 2>&1; then
    PASS=$((PASS + 1))
  else
    FAIL=$((FAIL + 1))
    echo "FAIL: $name" >&2
  fi
}
eq() { [ "$1" = "$2" ] || { echo "  expected <$2>, got <$1>" >&2; return 1; }; }

# Repository: package NAME VERSION...
package() {
  p=$1
  shift
  for v; do mkdir -p "$T/repo/packages/$p/$p.$v"; done
}
# Backend: sidebar NAME VERSION JSON, with Last-Modified at $LASTMOD.
LASTMOD="2026-01-01 00:00:00"
sidebar() {
  d="$T/backend/p/$1/$2/doc"
  mkdir -p "$d"
  printf '%s\n' "$3" >"$d/sidebar.json"
  touch -d "$LASTMOD UTC" "$d/sidebar.json"
}
# A sidebar of one library holding the given top-level modules.
modules() {
  printf '[{"node":{"kind":"library","content":"lib"},"children":['
  sep=
  for m; do
    printf '%s{"node":{"kind":"module","content":"%s"},"children":[]}' "$sep" "$m"
    sep=,
  done
  printf ']}]'
}

run() { # run: scrape into $T/state, $T/out.jsonl; stats in $T/stats.jsonl
  SCRAPE_STATS=$T/stats.jsonl "$TOOL/scrape.sh" "$T/repo" "$T/state" \
    "$T/out.jsonl" >"$T/run.log" 2>&1
}
fails() { ! "$@"; }
line() { grep "\"name\":\"$1\"" "$T/out.jsonl"; }
last() { tail -1 "$T/stats.jsonl" | jq -e -r "$1"; }
compiles() { [ -z "$COMPILE" ] || "$COMPILE" "$T/out.jsonl" "$T/out.idx"; }

# 1. First run.
package alpha 1.0 2.0
package beta 0.1 0.2 # docs only for the older version
package gamma 1.0    # no docs at all
package delta 1.0    # a sidebar without modules
package eps 1.0      # a node without children
sidebar alpha 2.0 "$(modules Alpha Alpha_sub)"
sidebar alpha 1.0 "$(modules Old)"
sidebar beta 0.1 "$(modules Beta)"
sidebar delta 1.0 '[{"node":{"kind":"page","content":"index"},"children":[]}]'
sidebar eps 1.0 '[{"node":{"kind":"module","content":"Eps"}}]'
check "first run succeeds" run
check "header line" sh -c "head -1 '$T/out.jsonl' | grep -q '\"format\":\"ocamlorg-doc-modules\"'"
check "latest version with docs" eq "$(line alpha)" \
  '{"name":"alpha","version":"2.0","modules":["Alpha","Alpha_sub"]}'
check "fallback to an older version" eq "$(line beta)" \
  '{"name":"beta","version":"0.1","modules":["Beta"]}'
check "node without children" eq "$(line eps)" \
  '{"name":"eps","version":"1.0","modules":["Eps"]}'
check "no docs: absent" eq "$(line gamma || true)" ""
check "no modules: absent" eq "$(line delta || true)" ""
check "packages sorted" eq "$(tail -n +2 "$T/out.jsonl" | jq -r .name | tr '\n' ' ')" \
  "alpha beta eps "
check "stats: scraped" eq "$(last .status)" scraped
check "stats: fetched" eq "$(last .fetched)" 3
check "stats: changed" eq "$(last '.changed_packages | join(" ")')" \
  "alpha beta eps"
check "stats: last modified" eq "$(last '.last_modified[0]')" \
  "$(date -u -d "$LASTMOD UTC" +%s)"
check "compile accepts the output" compiles
cp "$T/out.jsonl" "$T/first.jsonl"

# 2. Nothing changed: revalidation only, same data.
check "second run succeeds" run
check "same data" eq "$(tail -n +2 "$T/out.jsonl")" \
  "$(tail -n +2 "$T/first.jsonl")"
check "stats: nothing fetched" eq "$(last .fetched)" 0
check "stats: revalidated" eq "$(last .unchanged)" 3
check "stats: nothing changed" eq "$(last .changed)" 0

# 3. One package's docs change.
LASTMOD="2026-01-03 00:00:00"
sidebar alpha 2.0 "$(modules Alpha Alpha_new)"
check "run after a change" run
check "changed package refetched" eq "$(line alpha)" \
  '{"name":"alpha","version":"2.0","modules":["Alpha","Alpha_new"]}'
check "stats: one changed" eq "$(last '.changed_packages | join(" ")')" alpha

# 4. A failing package keeps its previous data (error threshold raised: with
# so few packages, one error is above the default 10%).
echo 500 >"$T/backend/p/beta/0.1/doc/sidebar.json.status"
export SCRAPE_MAX_ERRORS=100
check "run with one error" run
unset SCRAPE_MAX_ERRORS
check "failing package kept" eq "$(line beta)" \
  '{"name":"beta","version":"0.1","modules":["Beta"]}'
check "stats: one error" eq "$(last .errors)" 1
rm "$T/backend/p/beta/0.1/doc/sidebar.json.status"

# 5. The backend fails everything: abort, nothing changed but the stats.
cp "$T/out.jsonl" "$T/before.jsonl"
cp -R "$T/state" "$T/state.before"
echo 503 >"$T/backend/status"
check "all errors: aborts" fails run
check "all errors: output unchanged" cmp "$T/out.jsonl" "$T/before.jsonl"
check "all errors: state unchanged" diff -r "$T/state" "$T/state.before"
check "all errors: stats aborted" eq "$(last .status)" aborted

# 6. The backend loses every doc: abort.
echo 404 >"$T/backend/status"
check "all lost: aborts" fails run
check "all lost: reason" last '.reason | test("have none any more")'
check "all lost: output unchanged" cmp "$T/out.jsonl" "$T/before.jsonl"
rm "$T/backend/status"

# 7. A package removed from the repository disappears.
rm -rf "$T/repo/packages/eps"
check "run after a removal" run
check "removed package gone" eq "$(line eps || true)" ""
check "compile accepts the output after changes" compiles

# 8. Polling policy.
P=$TOOL/policy.sh
check "policy: no stats, due" eq "$("$P" "$T/none.jsonl" | head -1)" due=true
now=$(date -u +%s)
echo "{\"started\":$((now - 600)),\"status\":\"scraped\",\"last_modified\":[]}" \
  >"$T/recent.jsonl"
check "policy: recent run, not due" eq "$(NOW=$now "$P" "$T/recent.jsonl" | head -1)" \
  due=false
check "policy: forced" eq "$(NOW=$now FORCE=1 "$P" "$T/recent.jsonl" | head -1)" \
  due=true
echo "{\"started\":$((now - 600)),\"status\":\"aborted\"}" >"$T/aborted.jsonl"
check "policy: recent abort, not due" eq \
  "$(NOW=$now "$P" "$T/aborted.jsonl" | head -1)" due=false
# Batches every 2 days: polls every 12 hours.
d=172800
echo "{\"started\":$((now - 13 * 3600)),\"status\":\"scraped\",\"last_modified\":[$((now - 3 * d)),$((now - 2 * d)),$((now - d))]}" \
  >"$T/batches.jsonl"
check "policy: interval from batches" eq \
  "$(NOW=$now "$P" "$T/batches.jsonl" | sed -n 2,3p | tr '\n' ' ')" \
  "interval=43200 batches=3 "
check "policy: due after the interval" eq \
  "$(NOW=$now "$P" "$T/batches.jsonl" | head -1)" due=true

echo "$PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
