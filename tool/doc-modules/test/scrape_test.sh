#!/bin/sh
# Tests of scrape.sh and policy.sh against a mock documentation backend
# (mock_backend.ml), of sidebar-modules.jq, and of release-assets.sh against a
# fake gh (fake_gh.sh). Needs curl and jq, like the workflow.
#
#   tool/doc-modules/test/scrape_test.sh MOCK_BACKEND.exe [COMPILE.exe]
#
# Both built by `dune build ./tool/doc-modules/test/mock_backend.exe
# ./tool/doc-modules/compile.exe`. With the path of compile.exe, also checks
# that it accepts every output.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
TOOL=$(dirname "$HERE")
MOCK=${1:?usage: scrape_test.sh MOCK_BACKEND.exe [COMPILE.exe]}
COMPILE=${2:-}
T=$(mktemp -d)
SERVER=
cleanup() {
  if [ -n "$SERVER" ]; then kill "$SERVER" 2>/dev/null || true; fi
  rm -rf "$T"
}
trap cleanup EXIT
trap 'exit 1' INT TERM HUP

mkdir -p "$T/backend"
"$MOCK" "$T/backend" "$T/port" &
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

# 7. A package removed from the repository is a loss: one of three packages
# with docs is above the limit; a higher limit accepts it, and it disappears.
rm -rf "$T/repo/packages/eps"
check "removal above the loss limit: aborts" fails run
check "removal above the loss limit: reason" last '.reason | test("or are gone")'
check "removal above the loss limit: output unchanged" \
  cmp "$T/out.jsonl" "$T/before.jsonl"
export SCRAPE_MAX_LOSSES=100
check "run after a removal" run
unset SCRAPE_MAX_LOSSES
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

echo 'not json' >"$T/garbage.jsonl"
check "policy: malformed stats, fails" fails "$P" "$T/garbage.jsonl"
check "policy: malformed stats, no leftovers" \
  test ! -e "$T/garbage.jsonl.out" -a ! -e "$T/garbage.jsonl.err"

# 9. An empty package listing (a broken clone) aborts instead of publishing
# nothing; compile.exe refuses an input without packages too.
cp "$T/out.jsonl" "$T/before.jsonl"
mv "$T/repo/packages" "$T/repo/packages.saved"
mkdir "$T/repo/packages"
check "no packages: aborts" fails run
check "no packages: reason" last '.reason | test("no package in")'
check "no packages: output unchanged" cmp "$T/out.jsonl" "$T/before.jsonl"
rm -rf "$T/repo/packages"
check "no packages directory: aborts" fails run
mv "$T/repo/packages.saved" "$T/repo/packages"
head -1 "$T/out.jsonl" >"$T/header-only.jsonl"
if [ -n "$COMPILE" ]; then
  check "compile refuses no packages" \
    fails "$COMPILE" "$T/header-only.jsonl" "$T/empty.idx"
  check "compile refuses no packages: no output" test ! -e "$T/empty.idx"
fi

# 10. Packages without docs (gamma, delta) are asked once every
# SCRAPE_RETRY_DAYS, on a day of their own, and at once when their candidate
# versions change.
asked() { grep -c "^/p/$1/" "$T/backend/requests.log" || true; }
gamma_days=0
gamma_day=
delta_days=0
skipped=0
for d in 0 1 2 3 4 5 6; do
  : >"$T/backend/requests.log"
  export SCRAPE_DAY=$d
  check "re-probe: run on day $d" run
  if [ "$(asked gamma)" != 0 ]; then
    gamma_days=$((gamma_days + 1))
    gamma_day=$d
  fi
  [ "$(asked delta)" = 0 ] || delta_days=$((delta_days + 1))
  skipped=$((skipped + $(last .skipped)))
done
check "re-probe: gamma asked on one day of seven" eq "$gamma_days" 1
check "re-probe: delta asked on one day of seven" eq "$delta_days" 1
check "re-probe: each skipped the six other days" eq "$skipped" 12
quiet_day=$(((gamma_day + 1) % 7))
export SCRAPE_DAY=$quiet_day
: >"$T/backend/requests.log"
check "re-probe: run on a quiet day" run
check "re-probe: not asked on a quiet day" eq "$(asked gamma)" 0
package gamma 2.0
: >"$T/backend/requests.log"
check "re-probe: run after a new version" run
check "re-probe: asked after a new version, both candidates" eq "$(asked gamma)" 2
export SCRAPE_RETRY_DAYS=1
: >"$T/backend/requests.log"
check "re-probe: every day with SCRAPE_RETRY_DAYS=1" run
check "re-probe: nothing skipped" eq "$(last .skipped)" 0
unset SCRAPE_RETRY_DAYS
export SCRAPE_DAY=0

# 11. Transfer failures: a timeout, a truncated body and a garbled body are
# errors, and the package keeps its data.
cp "$T/out.jsonl" "$T/before.jsonl"
export SCRAPE_MAX_ERRORS=100 SCRAPE_MAX_TIME=1
for mode in slow truncated garbled; do
  echo "$mode" >"$T/backend/p/alpha/2.0/doc/sidebar.json.mode"
  check "$mode: run" run
  check "$mode: one error" eq "$(last .errors)" 1
  check "$mode: data kept" eq "$(line alpha)" "$(grep '"name":"alpha"' "$T/before.jsonl")"
  rm "$T/backend/p/alpha/2.0/doc/sidebar.json.mode"
done
unset SCRAPE_MAX_ERRORS
export SCRAPE_MAX_TIME=5
check "after transfer failures: run" run
check "after transfer failures: no error" eq "$(last .errors)" 0

# 12. The sidebar filter: nesting, module types, pages and libraries (no
# segment), source trees (skipped), invalid names, and the caps.
filter() {
  jq -e -r --argjson max_depth 3 --argjson max_paths "${2:-500}" \
    -f "$TOOL/sidebar-modules.jq" "$1"
}
cat >"$T/sidebar.json" <<'EOF'
[{"node":{"kind":"library","content":"lib"},"children":[
  {"node":{"kind":"page","content":"index"},"children":[
    {"node":{"kind":"module","content":"Paged"},"children":[]}]},
  {"node":{"kind":"module","content":"A"},"children":[
    {"node":{"kind":"module","content":"B"},"children":[
      {"node":{"kind":"module","content":"C"},"children":[
        {"node":{"kind":"module","content":"D"},"children":[]}]}]},
    {"node":{"kind":"module-type","content":"S"},"children":[]}]},
  {"node":{"kind":"module","content":"Bad\n"},"children":[]},
  {"node":{"kind":"module","content":"lower"},"children":[]},
  {"node":{"kind":"module","content":"X"},"children":[
    {"node":{"kind":"module","content":"Y\n"},"children":[]}]}]},
 {"node":{"kind":"source","content":"src"},"children":[
   {"node":{"kind":"module","content":"Src"},"children":[]}]}]
EOF
check "filter: paths, shallowest first" eq "$(filter "$T/sidebar.json")" \
  "A Paged X A.B A.S A.B.C"
check "filter: path cap" eq "$(filter "$T/sidebar.json" 4)" "A Paged X A.B"
jq -n -c '[range(600) | {node: {kind: "module", content: "M\(1000 + .)"},
  children: [{node: {kind: "module", content: "N"}}]}]' >"$T/many.json"
check "filter: at most 500 paths, the top-level ones" \
  eq "$(filter "$T/many.json" | tr ' ' '\n' | grep -vc '\.')" 500
check "filter: not a sidebar" fails filter "$T/header-only.jsonl"
echo '[]' >"$T/empty-sidebar.json"
check "filter: an empty array is not a sidebar" fails filter "$T/empty-sidebar.json"
# end to end: an invalid name does not break the one-line state
package nl 1.0
sidebar nl 1.0 '[{"node":{"kind":"module","content":"Good"}},{"node":{"kind":"module","content":"Bad\n"}}]'
check "newline in a name: run" run
check "newline in a name: dropped" eq "$(line nl)" \
  '{"name":"nl","version":"1.0","modules":["Good"]}'
check "newline in a name: compiles" compiles

# 13. release-assets.sh, against a fake gh: no failure loses an asset.
mkdir -p "$T/bin" "$T/gh"
ln -s "$HERE/fake_gh.sh" "$T/bin/gh"
ra() { PATH="$T/bin:$PATH" GH_FAKE="$T/gh" "$TOOL/release-assets.sh" "$@"; }
asset() { # asset NAME: its content, or nothing
  id=$(awk -v n="$1" '$2 == n { print $1 }' "$T/gh/names")
  if [ -n "$id" ]; then cat "$T/gh/assets/$id"; fi
}
names() { awk '{ print $2 }' "$T/gh/names" | sort | tr '\n' ' '; }
version() { echo "$1" >"$T/stats.jsonl"; }
check "assets: no release, first run" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: no release, empty stats" test -f "$T/pub/stats.jsonl" -a ! -s "$T/pub/stats.jsonl"
mkdir "$T/gh/release"
check "assets: release without stats, fails" \
  fails ra download TAG "$T/pub2" stats.jsonl x.idx
version s1
check "assets: first replace" ra replace TAG "$T/stats.jsonl"
check "assets: first replace, content" eq "$(asset stats.jsonl)" s1
version s2
check "assets: replace" ra replace TAG "$T/stats.jsonl"
check "assets: replace, content" eq "$(asset stats.jsonl)" s2
check "assets: replace, nothing left over" eq "$(names)" "stats.jsonl "
echo upload >"$T/gh/fail"
version s3
check "assets: failed upload, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed upload, old kept" eq "$(asset stats.jsonl)" s2
echo rename >"$T/gh/fail"
check "assets: failed rename, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed rename, only the new one" eq "$(names)" "stats.jsonl.new "
rm -rf "$T/pub"
check "assets: download after a failed rename" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: recovered" eq "$(cat "$T/pub/stats.jsonl")" s3
check "assets: recovered, unfinished" eq "$(cat "$T/pub/unfinished")" stats.jsonl
version s4
check "assets: replace after a failed rename" ra replace TAG "$T/stats.jsonl"
check "assets: finished" eq "$(names)" "stats.jsonl "
check "assets: finished, content" eq "$(asset stats.jsonl)" s4
echo delete >"$T/gh/fail"
version s5
check "assets: failed delete, fails" fails ra replace TAG "$T/stats.jsonl"
check "assets: failed delete, both" eq "$(names)" "stats.jsonl stats.jsonl.new "
rm -rf "$T/pub"
check "assets: download after a failed delete" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: the newer one" eq "$(cat "$T/pub/stats.jsonl")" s5
version s6
check "assets: replace after a failed delete" ra replace TAG "$T/stats.jsonl"
check "assets: finished again" eq "$(names)" "stats.jsonl "
echo gz >"$T/x.jsonl.gz"
echo rename >"$T/gh/fail"
check "assets: other asset, failed rename" fails ra replace TAG "$T/x.jsonl.gz"
rm -rf "$T/pub"
check "assets: download" ra download TAG "$T/pub" stats.jsonl x.idx
check "assets: an asset not downloaded is unfinished too" \
  eq "$(cat "$T/pub/unfinished")" x.jsonl.gz
echo list >"$T/gh/fail"
check "assets: other failures fail" fails ra download TAG "$T/pub" stats.jsonl

echo "$PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
