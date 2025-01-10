#!/usr/bin/env sh

# Ignore posix compliance errors in shellcheck
#shellcheck disable=SC3000-SC3061

set -eu
set -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

RESULTS_DIR=_results
USER_ID=$(id -u) # ensure we can write to the mounted dir
TIME=$(date +%FT%T)
RESULTS="${RESULTS_DIR}/${TIME}-results.gz"
GRAPH="${RESULTS_DIR}/${TIME}-report.html"


mkdir -p "$RESULTS_DIR"

docker run --rm \
    -u "$USER_ID" \
    -v "$SCRIPT_DIR":/home/k6 grafana/k6 \
    --out json="$RESULTS" \
    "$@"

k6parser "$RESULTS" --output "$GRAPH"

xdg-open "$GRAPH"
