#!/bin/sh
# Mine a search-bench query set from Plausible analytics (aggregate, no raw logs).
#
# The results page fires an aggregate Plausible custom event "Search" with the
# query as a property (see src/ocamlorg_frontend/pages/packages_search.eml). This
# stays within ocaml.org's privacy policy ("aggregate only", no raw per-request
# storage) and reuses the already-disclosed self-hosted Plausible.
#
# This script turns a Plausible breakdown of that property into queries.csv rows
# (already frequency-ranked by Plausible). The output has no expected-package /
# split columns — add those by hand (known items, train/holdout) after review.
#
# Two ways to get the breakdown:
#
# 1. Dashboard export: on plausible.ci.dev/ocaml.org, filter to the "Search"
#    goal, open the "query" property breakdown, and export it to CSV. Then:
#
#       tool/search-bench/mine_queries.sh search-breakdown.csv > queries.mined.csv
#
#    The CSV is assumed to have a header row and the query in the first column.
#
# 2. Stats API (no raw logs either — returns aggregates). Needs an API key:
#
#       curl -s -G https://plausible.ci.dev/api/v1/stats/breakdown \
#         -H "Authorization: Bearer $PLAUSIBLE_TOKEN" \
#         -d site_id=ocaml.org -d period=6mo -d limit=1000 \
#         -d property=event:props:query \
#         --data-urlencode 'filters=event:name==Search' \
#       | jq -r '.results[].query' > queries.mined.csv
#
# Use (1) with this script, or (2) directly. Either way the data is aggregate
# visitor counts per query — never individual requests.

set -eu

csv="${1:?usage: mine_queries.sh plausible-breakdown.csv  (see header for the export steps)}"

echo "# mined from Plausible breakdown $csv; add expected/split columns by hand"

# Skip the header row, take the first column (the query property value),
# tolerate quoting, and drop blanks. Plausible already orders by visitors desc.
tail -n +2 "$csv" \
  | sed -e 's/^"//' -e 's/",.*$//' -e 's/,.*$//' \
  | sed '/^[[:space:]]*$/d'
