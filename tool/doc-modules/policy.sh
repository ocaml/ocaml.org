#!/bin/sh
# Decide whether a doc-modules scrape is due, from the history of past runs.
#
#   tool/doc-modules/policy.sh STATS.jsonl [SUMMARY.md]
#
# The workflow wakes up every hour, but the documentation backend regenerates
# docs in batches, much less often. STATS.jsonl holds one record per scrape
# (written by scrape.sh through SCRAPE_STATS), including the backend's
# Last-Modified time of every sidebar fetched. This groups those times into
# batches (a gap of more than BATCH_GAP seconds, default 2 hours, starts a new
# one) and polls at a quarter of the median gap between batch starts, between
# MIN_INTERVAL (1 hour) and MAX_INTERVAL (24 hours); with fewer than
# MIN_BATCHES (3) batches seen, it polls every MAX_INTERVAL. A run is due when
# the last scrape attempt (aborted ones included) started at least that long
# ago, give or take the 5 minutes by which GitHub's cron drifts.
#
# Prints "due=true|false", "interval=SECONDS" and "batches=N" (for
# $GITHUB_OUTPUT), and appends a Markdown summary of the history to SUMMARY.md
# if given. FORCE=1 makes the run due (manual runs); NOW overrides the current
# time (tests). A missing or empty STATS.jsonl means a first run: due.
set -eu
STATS=$1
SUMMARY=${2:-/dev/null}
NOW=${NOW:-$(date -u +%s)}
FORCE=${FORCE:-0}
BATCH_GAP=${BATCH_GAP:-7200}
MIN_INTERVAL=${MIN_INTERVAL:-3600}
MAX_INTERVAL=${MAX_INTERVAL:-86400}
MIN_BATCHES=${MIN_BATCHES:-3}
[ -f "$STATS" ] || : >"$STATS.empty"
[ -f "$STATS" ] || STATS=$STATS.empty

jq -s -r \
  --argjson now "$NOW" --argjson force "$FORCE" --argjson gap "$BATCH_GAP" \
  --argjson min "$MIN_INTERVAL" --argjson max "$MAX_INTERVAL" \
  --argjson min_batches "$MIN_BATCHES" '
  def median: sort | if length == 0 then null
    elif length % 2 == 1 then .[length / 2 | floor]
    else (.[length / 2 - 1] + .[length / 2]) / 2 end;
  def hours: . / 3600 * 10 | round / 10;
  . as $runs
  | ([$runs[] | select(.status == "scraped") | .last_modified[]] | unique)
    as $times
  # batch starts: the first time, and every time after a gap > $gap
  | ([range(0; $times | length) as $i
      | select($i == 0 or $times[$i] - $times[$i - 1] > $gap)
      | $times[$i]]) as $batches
  | ([range(1; $batches | length) as $i
      | $batches[$i] - $batches[$i - 1]]) as $gaps
  | ($gaps | median) as $median
  | (if ($batches | length) < $min_batches then $max
     else [[($median / 4 | floor), $min] | max, $max] | min end) as $interval
  | ([$runs[] | .started] | max) as $last
  | ($force == 1 or $last == null or $now - $last >= $interval - 300) as $due
  | "due=\($due)", "interval=\($interval)", "batches=\($batches | length)",
    "--summary--",
    "### Polling policy",
    "",
    "| | |", "| --- | --- |",
    "| runs recorded | \($runs | length) (\([$runs[] | select(.status == "aborted")] | length) aborted) |",
    "| backend batches seen | \($batches | length) |",
    "| median gap between batches | \(if $median == null then "n/a" else "\($median | hours) h" end) |",
    "| polling interval | \($interval | hours) h |",
    "| last attempt | \(if $last == null then "never" else "\(($now - $last) | hours) h ago" end) |",
    "| this run | \(if $force == 1 then "due (manual)" elif $due then "due" else "not due" end) |",
    "",
    (if ($batches | length) > 0 then
       "Last batches: " + ([$batches[-5:][] | todate] | join(", "))
     else "No batch seen yet." end)
  ' "$STATS" >"$STATS.out" 2>"$STATS.err" || {
  cat "$STATS.err" >&2
  rm -f "$STATS.out" "$STATS.err" "${STATS%.empty}.empty"
  exit 1
}
sed '/^--summary--$/,$d' "$STATS.out"
sed '1,/^--summary--$/d' "$STATS.out" >>"$SUMMARY"
rm -f "$STATS.out" "$STATS.err"
case $STATS in *.empty) rm -f "$STATS" ;; esac
