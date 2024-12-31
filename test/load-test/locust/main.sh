#!/usr/bin/env sh

# Ignore posix compliance errors in shellcheck
#shellcheck disable=SC3000-SC3061

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# see https://docs.locust.io/en/stable/running-distributed.html#distributed-load-generation
n_procs="$1"

docker run -p 8089:8089 -v "$SCRIPT_DIR":/mnt/locust locustio/locust \
    --locustfile /mnt/locust/locustfile.py \
    ${n_procs:+"--processes=${n_procs}"} # Build the --processes flag if n_procs is not nil
