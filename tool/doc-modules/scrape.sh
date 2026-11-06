#!/bin/sh
# Refresh data/doc_modules.txt: the module paths of every package's
# documentation, which package search will use to answer "which package
# provides module X" (#3981).
#
#   tool/doc-modules/scrape.sh OPAM_REPOSITORY STATE_DIR [DATA_FILE]
#
# For each package in OPAM_REPOSITORY/packages, fetch doc/sidebar.json from the
# documentation backend for the latest version that has docs (the latest, then
# up to three older ones), and extract its module paths (sidebar-modules.jq).
#
# State. STATE_DIR is self-contained: per package, its candidate versions, the
# version its docs come from, the extracted module line and the ETag it was
# fetched with. DATA_FILE is regenerated from it, never read back, so its
# content does not depend on whether earlier bot PRs were merged. Neither
# STATE_DIR nor DATA_FILE is touched unless the run succeeds. STATE_DIR can be
# lost (it lives in a CI cache): the next run refetches everything and
# produces the same data.
#
# Outcomes per package:
# - 200 with a sidebar: new module line; 304: unchanged;
# - 404 on every candidate version, or a sidebar without modules: no docs;
# - anything else (5xx, 429, redirects, timeouts, truncated, empty or garbled
#   bodies): an error, and the package keeps its previous state.
# The run aborts, changing nothing, if more than SCRAPE_MAX_ERRORS percent
# (default 10) of the attempted requests fail, or if more than
# SCRAPE_MAX_LOSSES percent (default 10) of the packages that had docs now
# have none: both mean the backend, not the packages, changed.
#
# Load on the backend. Each round of requests is one curl process, so requests
# share one kept-alive connection; they are sequential and capped at
# SCRAPE_RATE (default 8/s; curl ignores --rate with --parallel), so a run is a
# steady trickle rather than a burst: ~3.6k requests, ~8 min daily; ~5.3k,
# ~15 min after a backend rebuild. Unchanged files cost a bodyless 304
# (If-None-Match); responses are gzip-encoded. Packages without docs are asked
# again when their candidate versions change, and otherwise once every
# SCRAPE_RETRY_DAYS (default 7), a different seventh of them each day. A
# package whose docs come from an older version tries its latest version
# first, every run; one whose known docs version stops answering tries its
# other candidates.
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
MAX_TIME=${SCRAPE_MAX_TIME:-20}      # seconds per request
MAX_ERRORS=${SCRAPE_MAX_ERRORS:-10}  # percent of attempted requests
MAX_LOSSES=${SCRAPE_MAX_LOSSES:-10}  # percent of packages that had docs
RETRY_DAYS=${SCRAPE_RETRY_DAYS:-7}
DAY=${SCRAPE_DAY:-$(($(date +%s) / 86400))} # overridable for tests
LIMIT=${SCRAPE_LIMIT:-0}             # 0 = all packages; for testing only
JQ_PROGRAM=$(dirname "$0")/sidebar-modules.jq
MAX_DEPTH=3
MAX_PATHS=500

# Header of a new data file; keep it in sync with Doc_modules_parser.header.
HEADER="# Module paths of each package's documentation, from the per-package
# sidebar.json of the documentation backend (ocaml-docs-ci). Package search
# uses them to answer \"which package provides module X\". Machine-managed:
# written by tool/doc-modules/scrape.sh and refreshed by the
# scrape-doc-modules.yml workflow. Do not edit by hand.
#
# One line per package: <name> <version> <module path>...
# Paths are capped per package (depth and count), shallowest first."

W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
trap 'exit 1' INT TERM HUP
mkdir -p "$W/fetch" "$W/old/etags" "$W/new/etags"
# A copy of the previous state, empty on a first run or after a cache
# eviction; STATE_DIR itself is only replaced at the very end.
if [ -d "$STATE" ]; then cp -R "$STATE/." "$W/old/"; fi
touch "$W/old/manifest.tsv" "$W/old/lines.txt"
OLD=$W/old

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
#   docs known: revalidate the docs version, but try the latest first if it
#     is newer; then the other candidates, in case the docs version stopped
#     answering;
#   no docs, and either changed candidates or its re-probe day: every
#     candidate;
#   no docs otherwise: not asked;
#   unknown package: every candidate.
# The manifest is "pkg  latest  docs-version|-  ok|missing  candidates".
awk -v m="$OLD/manifest.tsv" -v day="$DAY" -v every="$RETRY_DAYS" \
  -v sk="$W/skipped" '
  BEGIN { for (i = 32; i < 127; i++) ord[sprintf("%c", i)] = i }
  function due(p,   h, i) {
    h = 0
    for (i = 1; i <= length(p); i++) h = (h * 31 + ord[substr(p, i, 1)]) % 9973
    return (h + day) % every == 0
  }
  FILENAME == m { split($0, f, "\t"); doc[f[1]] = f[3]; st[f[1]] = f[4]
                  cands[f[1]] = f[5]; next }
  {
    p = $1; c = $2
    for (i = 3; i <= NF; i++) c = c "," $i
    if (st[p] == "ok") {
      line = p
      if (doc[p] != $2) line = line " " $2 ":0"
      line = line " " doc[p] ":1"
      for (i = 2; i <= NF; i++) if ($i != $2 && $i != doc[p]) line = line " " $i ":0"
      print line
    } else if (st[p] == "missing" && cands[p] == c && !due(p)) print p > sk
    else {
      line = p
      for (i = 2; i <= NF; i++) line = line " " $i ":0"
      print line
    }
  }' "$OLD/manifest.tsv" "$W/versions" >"$W/plan"
touch "$W/skipped"

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
      if [ "$cond" = 1 ]; then echo "etag-compare = \"$OLD/etags/$pkg\""; fi
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
: >"$W/unanswered"
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
        if paths=$(jq -e -r --argjson max_depth $MAX_DEPTH \
          --argjson max_paths $MAX_PATHS -f "$JQ_PROGRAM" "$W/fetch/$pkg.json" \
          2>/dev/null); then
          if [ -n "$paths" ]; then
            echo "$pkg $v $paths" >>"$W/new/lines.new"
            mv "$W/fetch/$pkg.etag" "$W/new/etags/$pkg"
            echo "$pkg $v ok200" >>"$W/outcome"
          else
            echo "$pkg $v missing" >>"$W/outcome" # a sidebar without modules
          fi
        else
          echo "$pkg $v error" >>"$W/outcome" # empty, garbled, not a sidebar
        fi
        ;;
      304) echo "$pkg $v ok304" >>"$W/outcome" ;;
      404) echo "$pkg" >>"$W/retry" ;;
      *) echo "$pkg $v error" >>"$W/outcome" ;;
      esac
    fi
    rm -f "$W/fetch/$pkg.json" "$W/fetch/$pkg.etag"
  done <"$W/round"
  # Requests that produced no result line at all (curl failed before or
  # during them).
  awk -v r="$W/round" 'FILENAME == r { seen[$1] = 1; next }
    !($1 in seen) { print $1, $2, "error" }' "$W/round" "$W/todo" |
    tee -a "$W/unanswered" >>"$W/outcome"
  # Next attempt of the packages that got a 404; none left: no docs.
  round=$((round + 1))
  awk -v r="$W/retry" -v k="$round" -v o="$W/outcome" '
    FILENAME == r { retry[$1] = 1; next }
    $1 in retry { if (NF > k) { split($(k + 1), a, ":"); print $1, a[1], a[2] }
                  else print $1, "-", "missing" >> o }' \
    "$W/retry" "$W/plan" >"$W/todo"
done

abort() {
  echo "Aborting: $1; state and data unchanged." >&2
  awk -v s="$2" '$3 == s' "$W/outcome" | head -20 >&2
  if [ -s "$W/curl.err" ]; then sort -u "$W/curl.err" | head -5 >&2; fi
  exit 1
}
requests=$(wc -l <"$W/log")
attempts=$((requests + $(wc -l <"$W/unanswered")))
errors=$(awk '$3 == "error"' "$W/outcome" | wc -l)
if [ $((errors * 100)) -gt $((attempts * MAX_ERRORS)) ]; then
  abort "$errors of $attempts attempted requests failed" error
fi
had_docs=$(awk -F'\t' '$4 == "ok"' "$OLD/manifest.tsv" | wc -l)
lost=$(awk -v m="$OLD/manifest.tsv" 'FILENAME == m { split($0, f, "\t")
    if (f[4] == "ok") ok[f[1]] = 1; next }
  $3 == "missing" && ($1 in ok)' "$OLD/manifest.tsv" "$W/outcome" | wc -l)
if [ $((lost * 100)) -gt $((had_docs * MAX_LOSSES)) ]; then
  abort "$lost of the $had_docs packages with docs have none any more" missing
fi

# New state. Per package: this run's outcome; skipped packages and errors keep
# their previous manifest row, line and ETag. Packages gone from the
# repository disappear, ETag included.
awk -v sk="$W/skipped" -v oc="$W/outcome" -v ol="$OLD/lines.txt" \
  -v nl="$W/new/lines.new" -v om="$OLD/manifest.tsv" \
  -v mf="$W/new/manifest.tsv" -v lf="$W/new/lines.txt" -v ok="$W/keep-etag" '
  FILENAME == sk { keep[$1] = 1; next }
  FILENAME == oc { v[$1] = $2; o[$1] = $3; next }
  FILENAME == ol { old[$1] = $0; next }
  FILENAME == nl { new[$1] = $0; next }
  FILENAME == om { split($0, f, "\t"); row[f[1]] = $0; st[f[1]] = f[4]; next }
  {
    p = $1; latest = $2; c = $2
    for (i = 3; i <= NF; i++) c = c "," $i
    if (p in keep || o[p] == "error" || !(p in o)) {
      if (p in row) print row[p] > mf
      if (p in old) print old[p] > lf
      if (st[p] == "ok") print p > ok
    } else if (o[p] == "ok200") {
      printf "%s\t%s\t%s\tok\t%s\n", p, latest, v[p], c > mf
      print new[p] > lf; print p > ok
    } else if (o[p] == "ok304" && (p in old)) {
      printf "%s\t%s\t%s\tok\t%s\n", p, latest, v[p], c > mf
      print old[p] > lf; print p > ok
    } else if (o[p] == "ok304") {
      # an ETag without its line (an older or damaged state): forget the
      # package, so that the next run fetches it unconditionally
    } else {
      printf "%s\t%s\t-\tmissing\t%s\n", p, latest, c > mf
    }
  }' "$W/skipped" "$W/outcome" "$OLD/lines.txt" "$W/new/lines.new" \
  "$OLD/manifest.tsv" "$W/versions"
touch "$W/new/manifest.tsv" "$W/new/lines.txt" "$W/keep-etag"
# ETags: the ones fetched in this run, then the previous ones of the packages
# that keep their docs; nothing else.
for f in "$OLD"/etags/*; do
  [ -f "$f" ] || continue
  p=$(basename "$f")
  if [ ! -f "$W/new/etags/$p" ] && grep -qxF "$p" "$W/keep-etag"; then
    cp "$f" "$W/new/etags/$p"
  fi
done
for f in "$W"/new/etags/*; do
  [ -f "$f" ] || continue
  grep -qxF "$(basename "$f")" "$W/keep-etag" || rm -f "$f"
done
rm "$W/new/lines.new"

# Data file: the existing header (or the standard one), then the module
# lines, sorted.
{
  if [ -f "$DATA" ] && head -1 "$DATA" | grep -q '^#'; then
    sed -n '/^#/!q; p' "$DATA"
  else
    printf '%s\n' "$HEADER"
  fi
  LC_ALL=C sort -k1,1 "$W/new/lines.txt"
} >"$W/data"

# The format the data packer decodes, checked before anything is written, so
# that a bad scrape fails this run instead of the build that packs the file.
if ! LC_ALL=C awk -v q="'" -f "$(dirname "$0")/check-data.awk" "$W/data"; then
  echo "Aborting: the data file would not decode; state and data unchanged." >&2
  exit 1
fi

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
  echo "| not asked (no docs, same candidates) | $(wc -l <"$W/skipped") |"
  echo "| errors, previous state kept | $errors |"
  echo
  echo "Requests: $requests, $(awk '{ s += $4 } END { print s + 0 }' "$W/log") bytes (gzip)."
} >"$W/new/report.md"
{
  echo "doc-modules: $changed packages changed"
  echo
  cat "$W/new/report.md"
} >"$W/new/commit.md"

# Commit: the data file, then the state, each replaced by a rename.
mv "$W/data" "$DATA.tmp" && mv "$DATA.tmp" "$DATA"
rm -rf "$STATE.old"
if [ -d "$STATE" ]; then mv "$STATE" "$STATE.old"; fi
mv "$W/new" "$STATE"
rm -rf "$STATE.old"
cat "$STATE/report.md"
