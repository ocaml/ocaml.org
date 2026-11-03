#!/bin/sh
# Entrypoint of the simulated server (see tool/sim/README.md).
#
# Points the image's opam-repository clone at a local, bare upstream that
# shares its objects, rewinds both to $SIM_START, then runs the unmodified
# server. The sim's feeder later moves the upstream's master forward along the
# real history, and the server's own polling pulls it.
set -eu

clone=/var/opam-repository
upstream=/tmp/upstream.git

# Commits past $SIM_START stay reachable through the reflog, but make sure no
# automatic gc runs during the simulation anyway.
git -C "$clone" config gc.auto 0
rm -rf "$upstream"
git clone --quiet --bare --shared "$clone" "$upstream"
git -C "$upstream" config gc.auto 0
git -C "$upstream" update-ref refs/heads/master "$SIM_START"
git -C "$clone" remote set-url origin "$upstream"
git -C "$clone" checkout --quiet master
git -C "$clone" reset --quiet --hard "$SIM_START"

exec /bin/server
