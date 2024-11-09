#!/usr/bin/env sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

docker run -p 8089:8089 -v "$SCRIPT_DIR":/mnt/locust locustio/locust -f /mnt/locust/locustfile.py
