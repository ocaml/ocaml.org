#!/bin/sh
# Refresh data/doc_modules.txt: the module paths of every package's
# documentation, which package search uses to answer "which package provides
# module X" (see Ocamlorg_package.search, ~module_providers).
#
#   tool/doc-modules/scrape.sh OPAM_REPOSITORY STATE_DIR [DATA_FILE]
#
# For each package in OPAM_REPOSITORY/packages, fetch doc/sidebar.json from the
# documentation backend for the latest version that has docs (the latest, then
# up to three older ones), and extract its module paths (sidebar-modules.jq).
#
# State. STATE_DIR is self-contained: per package, the version its docs come
# from, the extracted module line and the ETag it was fetched with. DATA_FILE
# is regenerated from it, never read back, so its content does not depend on
# whether earlier bot PRs were merged. Nothing is written (neither STATE_DIR
# nor DATA_FILE) unless the run succeeds; a failed run leaves both as they
# were. STATE_DIR can be lost (it lives in a CI cache): the next run refetches
# everything and produces the same data.
#
# Outcomes per package:
# - 200: new module line; 304: unchanged;
# - 404 on every candidate version, or docs without modules: no docs;
# - anything else (5xx, 429, redirects, timeouts, truncated bodies, invalid
#   JSON): an error, and the package keeps its previous state. If more than
#   SCRAPE_MAX_ERRORS percent (default 10) of the requests fail, the run aborts.
#
# Load on the backend. Each round of requests is one curl process, so requests
# share one kept-alive connection; they are sequential and capped at
# SCRAPE_RATE (default 8/s; curl ignores --rate with --parallel), so a run is a
# steady trickle rather than a burst: ~3.5k requests, ~7 min daily; ~5k,
# ~11 min after a backend rebuild. Unchanged files cost a bodyless 304
# (If-None-Match); responses are gzip-encoded. Packages without docs are asked
# again when a new version appears, and otherwise once every SCRAPE_RETRY_DAYS
# (default 7), a different seventh of them each day. A package whose docs come
# from an older version tries its latest version first, every run.
#
# Per package, paths deeper than 3 and beyond the first 500 (shallowest first)
# are dropped: a few packages define hundreds of thousands of modules (awso,
# the AWS SDK, one per service and operation), and lookups are for the top.
#
# Writes DATA_FILE (default data/doc_modules.txt), STATE_DIR/report.md and
# STATE_DIR/commit.md (a commit message whose first line is the PR title).
set -eu
REPO=$1
STATE=$2
DATA=${3:-data/doc_modules.txt}
DOC_URL=${OCAMLORG_DOC_URL:-https://dill.caelum.ci.dev/profiles/full/docs/}
RATE=${SCRAPE_RATE:-8/s}
MAX_TIME=${SCRAPE_MAX_TIME:-60}      # seconds per request
MAX_ERRORS=${SCRAPE_MAX_ERRORS:-10}  # percent of requests
RETRY_DAYS=${SCRAPE_RETRY_DAYS:-7}
DAY=${SCRAPE_DAY:-$(($(date +%s) / 86400))} # overridable for tests
LIMIT=${SCRAPE_LIMIT:-0}             # 0 = all packages; for testing only
JQ_PROGRAM=$(dirname "$0")/sidebar-modules.jq
MAX_DEPTH=3
MAX_PATHS=500

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
mkdir -p "$W/fetch" "$W/new/etags"
# Previous state; absent on a first run or after a cache eviction.
mkdir -p "$STATE/etags"
touch "$STATE/manifest.tsv" "$STATE/lines.txt"
cp -R "$STATE/etags/." "$W/new/etags/"

# Candidate versions per package, newest first: "pkg v1 [v2 v3 v4]".
n=0
for dir in "$REPO"/packages/*/; do
  pkg=$(basename "$dir")
  n=$((n + 1))
  [ "$LIMIT" -gt 0 ] && [ "$n" -gt "$LIMIT" ] && break
  printf '%s %s\n' "$pkg" \
    "$(ls "$dir" | sed "s/^$pkg\.//" | sort -V -r | head -4 | tr '\n' ' ')"
done >"$W/versions"

# Attempt plan, one line per package: "pkg version:conditional ...", tried in
# order until one answers 200 or 304. Packages not planned keep their state.
#   docs known, from the latest version: revalidate it;
#   docs known, from an older version: the latest first, then revalidate;
#   no docs, and either a new version or its re-probe day: every candidate;
#   no docs otherwise: skipped;
#   unknown package: every candidate.
awk -v m="$STATE/manifest.tsv" -v day="$DAY" -v every="$RETRY_DAYS" '
  BEGIN { for (i = 32; i < 127; i++) ord[sprintf("%c", i)] = i }
  function due(p,   h, i) {
    h = 0
    for (i = 1; i <= length(p); i++) h = (h * 31 + ord[substr(p, i, 1)]) % 9973
    return (h + day) % every == 0
  }
  FILENAME == m { split($0, f, "\t"); latest[f[1]] = f[2]; doc[f[1]] = f[3]
                  st[f[1]] = f[4]; next }
  {
    p = $1; all = ""
    for (i = 2; i <= NF; i++) all = all " " $i ":0"
    if (st[p] == "ok" && doc[p] == $2) print p, $2 ":1"
    else if (st[p] == "ok") print p, $2 ":0", doc[p] ":1"
    else if (st[p] == "missing" && latest[p] == $2 && !due(p))
      print p > "/dev/stderr"
    else print p all
  }' "$STATE/manifest.tsv" "$W/versions" >"$W/plan" 2>"$W/skipped"

# Round r requests the r-th attempt of every package still pending.
fetch_round() {
  : >"$W/config"
  first=1
  while read -r pkg v cond; do
    {
      # options do not carry over "next": repeat them in every entry
      [ "$first" = 1 ] || echo "next"
      echo "compressed"
      echo "max-time = $MAX_TIME"
      echo "url = \"${DOC_URL}p/$pkg/$v/doc/sidebar.json\""
      echo "output = \"$W/fetch/$pkg.json\""
      echo "etag-save = \"$W/fetch/$pkg.etag\""
      if [ "$cond" = 1 ]; then echo "etag-compare = \"$STATE/etags/$pkg\""; fi
      # printf, not echo: dash's echo would turn \n into a newline
      printf '%s\n' 'write-out = "%{url_effective} %{http_code} %{size_download} %{exitcode}\n"'
    } >>"$W/config"
    first=0
  done <"$W/todo"
  : >"$W/results"
  [ -s "$W/config" ] || return 0
  curl -sS --rate "$RATE" --config "$W/config" >"$W/results" 2>>"$W/curl.err" ||
    true
}

# $W/outcome: "pkg version outcome", outcome in ok200 ok304 missing error.
: >"$W/outcome"
: >"$W/log"
: >"$W/new/lines.new"
awk '{ split($2, a, ":"); print $1, a[1], a[2] }' "$W/plan" >"$W/todo"
round=1
while [ -s "$W/todo" ]; do
  fetch_round
  sed -E "s|^${DOC_URL}p/([^/]+)/([^/]+)/doc/sidebar.json |\1 \2 |" \
    "$W/results" >"$W/round"
  cat "$W/round" >>"$W/log"
  : >"$W/retry"
  while read -r pkg v code _ exitcode; do
    if [ "$exitcode" != 0 ]; then
      echo "$pkg $v error" >>"$W/outcome"
    else
      case $code in
      200)
        if paths=$(jq -r --argjson max_depth $MAX_DEPTH \
          --argjson max_paths $MAX_PATHS -f "$JQ_PROGRAM" "$W/fetch/$pkg.json" \
          2>/dev/null); then
          if [ -n "$paths" ]; then
            echo "$pkg $v $paths" >>"$W/new/lines.new"
            mv "$W/fetch/$pkg.etag" "$W/new/etags/$pkg"
            echo "$pkg $v ok200" >>"$W/outcome"
          else
            echo "$pkg $v missing" >>"$W/outcome" # docs without modules
          fi
        else
          echo "$pkg $v error" >>"$W/outcome" # invalid JSON
        fi
        ;;
      304) echo "$pkg $v ok304" >>"$W/outcome" ;;
      404) echo "$pkg" >>"$W/retry" ;;
      *) echo "$pkg $v error" >>"$W/outcome" ;;
      esac
    fi
    rm -f "$W/fetch/$pkg.json" "$W/fetch/$pkg.etag"
  done <"$W/round"
  # Requests that produced no result line at all.
  awk -v r="$W/round" 'FILENAME == r { seen[$1] = 1; next }
    !($1 in seen) { print $1, $2, "error" }' "$W/round" "$W/todo" >>"$W/outcome"
  # Next attempt of the packages that got a 404; none left: no docs.
  round=$((round + 1))
  awk -v r="$W/retry" -v k="$round" -v o="$W/outcome" '
    FILENAME == r { retry[$1] = 1; next }
    $1 in retry { if (NF > k) { split($(k + 1), a, ":"); print $1, a[1], a[2] }
                  else print $1, "-", "missing" >> o }' \
    "$W/retry" "$W/plan" >"$W/todo"
done

requests=$(wc -l <"$W/log")
errors=$(awk '$3 == "error"' "$W/outcome" | wc -l)
if [ "$requests" -gt 0 ] && [ $((errors * 100)) -gt $((requests * MAX_ERRORS)) ]; then
  echo "Aborting: $errors of $requests requests failed; state and data unchanged." >&2
  awk '$3 == "error"' "$W/outcome" | head -20 >&2
  [ -s "$W/curl.err" ] && sort -u "$W/curl.err" | head -5 >&2
  exit 1
fi

# New state. Per package: this run's outcome; skipped packages and errors keep
# their previous manifest row, line and ETag.
awk -v sk="$W/skipped" -v oc="$W/outcome" -v ol="$STATE/lines.txt" \
  -v nl="$W/new/lines.new" -v om="$STATE/manifest.tsv" \
  -v mf="$W/new/manifest.tsv" -v lf="$W/new/lines.txt" -v rm="$W/drop" '
  FILENAME == sk { keep[$1] = 1; next }
  FILENAME == oc { v[$1] = $2; o[$1] = $3; next }
  FILENAME == ol { old[$1] = $0; next }
  FILENAME == nl { new[$1] = $0; next }
  FILENAME == om { row[substr($0, 1, index($0, "\t") - 1)] = $0; next }
  {
    p = $1; latest = $2
    if (p in keep || o[p] == "error" || !(p in o)) {
      if (p in row) print row[p] > mf
      if (p in old) print old[p] > lf
    } else if (o[p] == "ok200") {
      printf "%s\t%s\t%s\tok\n", p, latest, v[p] > mf; print new[p] > lf
    } else if (o[p] == "ok304" && (p in old)) {
      printf "%s\t%s\t%s\tok\n", p, latest, v[p] > mf; print old[p] > lf
    } else if (o[p] == "ok304") {
      # an ETag without its line (an older or damaged state): forget the
      # package, so that the next run fetches it unconditionally
      print p > rm
    } else {
      printf "%s\t%s\t-\tmissing\n", p, latest > mf; print p > rm
    }
  }' "$W/skipped" "$W/outcome" "$STATE/lines.txt" "$W/new/lines.new" \
  "$STATE/manifest.tsv" "$W/versions"
touch "$W/new/manifest.tsv" "$W/new/lines.txt" "$W/drop"
while read -r pkg; do rm -f "$W/new/etags/$pkg"; done <"$W/drop"
rm "$W/new/lines.new"

# Data file: the existing header, then the module lines, sorted.
{
  if [ -f "$DATA" ]; then sed -n '/^#/!q; p' "$DATA"; fi
  LC_ALL=C sort -k1,1 "$W/new/lines.txt"
} >"$W/data"

# Packages whose line was added, removed or changed, for the commit title.
if [ -f "$DATA" ]; then grep -v '^#' "$DATA" | LC_ALL=C sort >"$W/before" || true
else : >"$W/before"; fi
grep -v '^#' "$W/data" | LC_ALL=C sort >"$W/after" || true
changed=$(LC_ALL=C comm -3 "$W/before" "$W/after" | sed 's/^\t//' |
  cut -d' ' -f1 | sort -u | grep -c . || true)

count() { awk -v s="$1" '$3 == s' "$W/outcome" | wc -l; }
{
  echo "Packages: $(wc -l <"$W/versions"), $(wc -l <"$W/new/lines.txt") with module paths."
  echo
  echo "| this run | packages |"
  echo "| --- | --- |"
  echo "| fetched (200) | $(count ok200) |"
  echo "| unchanged (304) | $(count ok304) |"
  echo "| no docs | $(count missing) |"
  echo "| not asked (no docs, no new version) | $(wc -l <"$W/skipped") |"
  echo "| errors, previous state kept | $errors |"
  echo
  echo "Requests: $requests, $(awk '{ s += $4 } END { print s + 0 }' "$W/log") bytes (gzip)."
} >"$W/new/report.md"
{
  echo "doc-modules: $changed packages changed"
  echo
  cat "$W/new/report.md"
} >"$W/new/commit.md"

# Commit: the data file, then the state, each replaced in one rename.
mv "$W/data" "$DATA.tmp" && mv "$DATA.tmp" "$DATA"
rm -rf "$STATE.old"
mv "$STATE" "$STATE.old"
mv "$W/new" "$STATE"
rm -rf "$STATE.old"
cat "$STATE/report.md"
