#!/bin/bash
# Setup script for a claude.ai/code cloud environment: paste this file into the
# environment's "Setup script" field (see HACKING.md, "Devcontainer and Cloud
# Sessions"). It pre-pulls the development image so that the environment cache
# keeps it; .devcontainer/cloud-session-start.sh then only pulls what changed.
# It must exit 0, or sessions fail to start.

if ! docker info >/dev/null 2>&1; then
  setsid dockerd >/tmp/dockerd.log 2>&1 < /dev/null &
  for _ in $(seq 60); do
    docker info >/dev/null 2>&1 && break
    sleep 1
  done
fi
docker pull -q ghcr.io/ocaml/ocaml.org-dev:main || true
exit 0
