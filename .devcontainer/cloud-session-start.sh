#!/bin/bash
# SessionStart hook (see .claude/settings.json) for Claude Code cloud sessions.
# Starts a container from ghcr.io/ocaml/ocaml.org-dev with this checkout
# mounted at the same path, so that .devcontainer/run can build and test inside
# it. It does nothing outside cloud sessions, and it never fails the session:
# problems are reported on stdout, which Claude Code shows to Claude.

[ "${CLAUDE_CODE_REMOTE:-}" = true ] || exit 0

image=ghcr.io/ocaml/ocaml.org-dev
container=ocamlorg-dev
repo=${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}

say() { echo "[ocamlorg-dev] $*"; }

# The cloud VM has Docker installed, but the daemon may not be running.
if ! docker info >/dev/null 2>&1; then
  setsid dockerd >/tmp/dockerd.log 2>&1 < /dev/null &
  for _ in $(seq 60); do
    docker info >/dev/null 2>&1 && break
    sleep 1
  done
fi
if ! docker info >/dev/null 2>&1; then
  say "Docker daemon unavailable (see /tmp/dockerd.log); OCaml builds won't work."
  exit 0
fi

tag=$("$repo/.devcontainer/tag.sh")
if docker pull -q "$image:$tag" >/dev/null 2>&1 \
  || docker image inspect "$image:$tag" >/dev/null 2>&1; then
  ref=$image:$tag
elif docker pull -q "$image:main" >/dev/null 2>&1 \
  || docker image inspect "$image:main" >/dev/null 2>&1; then
  ref=$image:main
  say "No image for this checkout's .devcontainer/Dockerfile and ocamlorg.opam (tag $tag); using $ref."
  say "Its dependencies may lag this branch: install the missing ones with"
  say "  .devcontainer/run opam install --deps-only --with-test --with-doc ."
  say "(git pin-depends from other GitHub repositories can't be fetched in cloud sessions)."
else
  say "Could not pull $image; OCaml builds won't work."
  exit 0
fi

# Keep a running container that already uses the right image (resumed session).
# Otherwise (first start, or the tag changed since), replace it: whatever ran
# in the old container, such as a server, is stopped.
want=$(docker image inspect -f '{{.Id}}' "$ref")
have=$(docker inspect -f '{{if .State.Running}}{{.Image}}{{end}}' "$container" 2>/dev/null)
if [ "$have" != "$want" ]; then
  docker rm -f "$container" >/dev/null 2>&1
  if ! docker run -d --name "$container" --network host \
       -e OPAMROOT=/home/opam/.opam \
       -v "$repo:$repo" -w "$repo" \
       "$ref" sleep infinity >/dev/null; then
    say "Could not start container $container from $ref."
    exit 0
  fi
fi

# The server reads packages from a clone of opam-repository, by default
# ~/.cache/ocamlorg/opam-repository, which it would clone from GitHub; cloud
# sessions can't. Clone the image's bundled copy instead (hard links, so it's
# quick). Its origin is that local copy, so the server's periodic `git pull`
# succeeds without network, and never moves the repository opam itself uses.
# Package data is as of the opam-repository pin. Cloning to a temporary name
# then renaming means an interrupted clone is redone at the next session.
# HOME is /home/opam in the container, for root too.
docker exec -u opam "$container" sh -c '
  dest=$HOME/.cache/ocamlorg/opam-repository
  [ -d "$dest/.git" ] || {
    rm -rf "$dest" "$dest.tmp" && mkdir -p "${dest%/*}" &&
    git clone -q --local "$HOME/opam-repository" "$dest.tmp" && mv "$dest.tmp" "$dest"
  }' \
  || say "Could not clone opam-repository for the server; package pages won't work."

say "Container $container ($ref) is running with $repo mounted."
say "Run OCaml, opam, dune, and make commands through .devcontainer/run, e.g. '.devcontainer/run make build'."
exit 0
