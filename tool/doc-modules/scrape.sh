#!/bin/sh
# Refresh data/doc_modules.txt: the module paths of every package's
# documentation, which package search uses to answer "which package provides
# module X" (see Ocamlorg_package.search, ~module_providers).
#
#   tool/doc-modules/scrape.sh OPAM_REPOSITORY STATE_DIR [DATA_FILE]
#
# For each package in OPAM_REPOSITORY/packages, fetch doc/sidebar.json from the
# documentation backend for the latest version that has docs (the latest, then
# up to three older ones), and extract its module paths: the chain of module
# and module type names from the root of the sidebar tree.
#
# The documentation backend serves ~4,000 sidebars; this keeps the daily load
# to one connection and mostly bodyless replies:
# - each round of requests is one curl process, so requests share one
#   kept-alive HTTP/2 connection, SCRAPE_PARALLEL (default 8) at a time;
# - files fetched before are revalidated with If-None-Match (ETags kept in
#   STATE_DIR), so an unchanged file costs a 304;
# - a package without docs is not asked again until a new version appears;
# - responses are gzip-encoded.
# STATE_DIR can be lost (it lives in a CI cache): the next run refetches
# everything (~9 MB) and produces the same data.
#
# Per package, paths deeper than 3 and beyond the first 500 (shallowest first)
# are dropped: a few packages define hundreds of thousands of modules
# (awso, the AWS SDK, one per service and operation), and module lookups are
# for the top levels.
#
# Writes DATA_FILE (default data/doc_modules.txt), STATE_DIR/report.md and
# STATE_DIR/commit.md (a commit message whose first line is the PR title).
set -eu
REPO=$1
STATE=$2
DATA=${3:-data/doc_modules.txt}
DOC_URL=${OCAMLORG_DOC_URL:-https://dill.caelum.ci.dev/profiles/full/docs/}
PARALLEL=${SCRAPE_PARALLEL:-8}
LIMIT=${SCRAPE_LIMIT:-0} # 0 = all packages; for testing
MAX_DEPTH=3
MAX_PATHS=500
mkdir -p "$STATE/etags"
touch "$STATE/manifest.tsv"
W=$(mktemp -d)
trap 'rm -rf "$W"' EXIT
mkdir -p "$W/fetch" "$W/modules"

# Module paths, shallowest first, capped; only valid OCaml module paths (the
# same rule as the decoder in tool/data-packer). Source trees are skipped.
JQ='def paths($p): .[] |
      (if .node.kind == "module" or .node.kind == "module-type"
       then $p + [.node.content] else $p end) as $q
      | (if $q != $p then $q else empty end),
        (if .node.kind != "source" then (.children | paths($q)) else empty end);
    [paths([])]
    | map(select(length <= '$MAX_DEPTH'
                 and all(.[]; test("^[A-Z][A-Za-z0-9_\u0027]*$"))))
    | map(join(".")) | unique as $u
    | $u | sort_by(split(".") | length) | .[:'$MAX_PATHS'] | join(" ")'

# Previous data, to keep the module lists of unchanged packages.
if [ -f "$DATA" ]; then grep -v '^#' "$DATA" | grep . >"$W/previous" || true; fi
touch "$W/previous"
LC_ALL=C sort "$W/previous" >"$W/previous.sorted"

# Candidate versions per package, newest first: "pkg v1 [v2 v3 v4]".
n=0
for dir in "$REPO"/packages/*/; do
  pkg=$(basename "$dir")
  n=$((n + 1))
  [ "$LIMIT" -gt 0 ] && [ "$n" -gt "$LIMIT" ] && break
  printf '%s %s\n' "$pkg" \
    "$(ls "$dir" | sed "s/^$pkg\.//" | sort -V -r | head -4 | tr '\n' ' ')"
done >"$W/versions"

# Round 0 work list, "pkg version conditional":
# - same latest version as last run, docs known: revalidate that version;
# - same latest version as last run, no docs: skip;
# - otherwise: try the latest version.
awk -v m="$STATE/manifest.tsv" 'FILENAME == m { latest[$1] = $2; doc[$1] = $3; st[$1] = $4; next }
     { if (latest[$1] == $2 && doc[$1] != "" && doc[$1] != "-") print $1, doc[$1], 1
       else if (latest[$1] == $2 && (st[$1] == "missing" || st[$1] == "skipped"))
         print $1 > "/dev/stderr"
       else print $1, $2, 0 }' \
  FS='\t' "$STATE/manifest.tsv" FS=' ' "$W/versions" >"$W/todo" 2>"$W/skipped"

# The candidate version after $2 for package $1, if any.
next_version() {
  awk -v p="$1" -v v="$2" '$1 == p {
      for (i = 2; i < NF; i++) if ($i == v) { print $(i + 1); exit } }' \
    "$W/versions"
}

fetch_round() {
  : >"$W/config"
  first=1
  while read -r pkg v cond; do
    {
      # options do not carry over "next": repeat them in every entry
      [ "$first" = 1 ] || echo "next"
      echo "compressed"
      echo "max-time = 120"
      echo "url = \"${DOC_URL}p/$pkg/$v/doc/sidebar.json\""
      echo "output = \"$W/fetch/$pkg.json\""
      echo "etag-save = \"$W/fetch/$pkg.etag\""
      if [ "$cond" = 1 ]; then echo "etag-compare = \"$STATE/etags/$pkg\""; fi
      # printf, not echo: dash's echo would turn \n into a newline
      printf '%s\n' 'write-out = "%{url_effective} %{http_code} %{size_download}\n"'
    } >>"$W/config"
    first=0
  done <"$W/todo"
  : >"$W/results"
  [ -s "$W/config" ] || return 0
  curl -sS --parallel --parallel-max "$PARALLEL" --config "$W/config" \
    >"$W/results" 2>>"$W/curl.err" || true
}

: >"$W/done"
: >"$W/log"
round=0
while [ -s "$W/todo" ] && [ "$round" -lt 4 ]; do
  fetch_round
  : >"$W/next"
  sed -E "s|^${DOC_URL}p/([^/]+)/([^/]+)/doc/sidebar.json |\1 \2 |" \
    "$W/results" >"$W/round"
  cat "$W/round" >>"$W/log"
  while read -r pkg v code _; do
    case $code in
    200)
      if paths=$(jq -r "$JQ" "$W/fetch/$pkg.json" 2>/dev/null) && [ -n "$paths" ]; then
        echo "$pkg $v $paths" >"$W/modules/$pkg"
        mv "$W/fetch/$pkg.etag" "$STATE/etags/$pkg"
        echo "$pkg $v 200" >>"$W/done"
      else
        # docs without any module (a tool, or pages only)
        echo "$pkg - missing" >>"$W/done"
      fi
      ;;
    304) echo "$pkg $v 304" >>"$W/done" ;;
    000) echo "$pkg $v error" >>"$W/done" ;;
    *)
      nextv=$(next_version "$pkg" "$v")
      if [ -n "$nextv" ]; then echo "$pkg $nextv 0" >>"$W/next"
      else echo "$pkg - missing" >>"$W/done"; fi
      ;;
    esac
    rm -f "$W/fetch/$pkg.json" "$W/fetch/$pkg.etag"
  done <"$W/round"
  # requests that produced no result line at all: keep previous state
  awk -v r="$W/round" 'FILENAME == r { seen[$1] = 1; next }
    !($1 in seen) { print $1, $2, "error" }' "$W/round" "$W/todo" >>"$W/done"
  mv "$W/next" "$W/todo"
  round=$((round + 1))
done
while read -r pkg _ _; do echo "$pkg - missing" >>"$W/done"; done <"$W/todo"

# New manifest and data, in one pass. A package's line comes from this run
# (200), from the previous data (304, or no answer), or is dropped (no docs).
for f in "$W"/modules/*; do if [ -f "$f" ]; then cat "$f"; fi; done >"$W/new"
awk -v sk="$W/skipped" -v dn="$W/done" -v nw="$W/new" -v pv="$W/previous" \
  -v om="$STATE/manifest.tsv" -v mf="$W/manifest" -v dt="$W/data" \
  -v ms="$W/missing" '
  FILENAME == sk { skipped[$1] = 1; next }
  FILENAME == dn { docv[$1] = $2; st[$1] = $3; next }
  FILENAME == nw { new[$1] = $0; next }
  FILENAME == pv { prev[$1] = $0; next }
  FILENAME == om { split($0, f, "\t"); olddoc[f[1]] = f[3]; next }
  {
    p = $1; latest = $2
    if (p in skipped) { printf "%s\t%s\t-\tskipped\n", p, latest > mf; next }
    s = (p in st) ? st[p] : "error"; v = docv[p]
    if (s == "200") print new[p] > dt
    else if (s == "304") { if (p in prev) print prev[p] > dt }
    else if (s == "error") { if (p in prev) print prev[p] > dt; v = olddoc[p] }
    else print p > ms
    printf "%s\t%s\t%s\t%s\n", p, latest, (v == "" ? "-" : v), s > mf
  }' "$W/skipped" "$W/done" "$W/new" "$W/previous" "$STATE/manifest.tsv" \
  "$W/versions"
touch "$W/data" "$W/missing"
touch "$W/manifest"
while read -r pkg; do rm -f "$STATE/etags/$pkg"; done <"$W/missing"
mv "$W/manifest" "$STATE/manifest.tsv"

{
  sed -n '1,/^[^#]/p' "$DATA" 2>/dev/null | grep '^#' || true
  LC_ALL=C sort -k1,1 "$W/data"
} >"$W/out"
mv "$W/out" "$DATA"

# Packages whose line was added, removed or changed, for the commit title.
grep -v '^#' "$DATA" | LC_ALL=C sort >"$W/new.sorted" || true
changed=$(LC_ALL=C comm -3 "$W/new.sorted" "$W/previous.sorted" |
  sed 's/^\t//' | cut -d' ' -f1 | sort -u | grep -c . || true)

count() { awk -F'\t' -v s="$1" '$4 == s' "$STATE/manifest.tsv" | wc -l; }
{
  echo "Packages: $(wc -l <"$W/versions"), $(grep -vc '^#' "$DATA") with module paths in $(basename "$DATA")."
  echo
  echo "| result | packages |"
  echo "| --- | --- |"
  echo "| fetched (200) | $(count 200) |"
  echo "| unchanged (304) | $(count 304) |"
  echo "| no docs | $(count missing) |"
  echo "| skipped (no docs, no new version) | $(count skipped) |"
  echo "| no answer, previous data kept | $(count error) |"
  echo
  echo "Requests: $(wc -l <"$W/log"), $(awk '{ s += $4 } END { print s + 0 }' "$W/log") bytes (gzip)."
  if [ -s "$W/curl.err" ]; then
    echo
    echo "curl errors: $(sort -u "$W/curl.err" | head -5 | tr '\n' ' ')"
  fi
} >"$STATE/report.md"
{
  echo "doc-modules: $changed packages changed"
  echo
  cat "$STATE/report.md"
} >"$STATE/commit.md"
cat "$STATE/report.md"
