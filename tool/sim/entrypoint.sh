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

# Experimental (`sim run --state-builder NICE`): a separate builder process
# pulls, rebuilds and rewrites the package state, and the server only loads each
# new version (OCAMLORG_PKG_STATE_MODE=builder and =reload, which the server
# does not support on main yet). The state moves to a directory both can write:
# the image's /var is root-owned, and replacing the file by renaming needs a
# writable directory. The builder runs without runtime events, so that the only
# ring is the server's, 1.events, and logs to the container's output, where the
# sim reads the update cycle as usual.
if [ -n "${SIM_STATE_BUILDER:-}" ]; then
  mkdir -p /tmp/pkgstate
  cp /var/package.state /tmp/pkgstate/package.state
  export OCAMLORG_PKG_STATE_PATH=/tmp/pkgstate/package.state
  env -u OCAML_RUNTIME_EVENTS_START OCAMLORG_PKG_STATE_MODE=builder \
    nice -n "$SIM_STATE_BUILDER" /bin/server &
  export OCAMLORG_PKG_STATE_MODE=reload
fi

exec /bin/server
