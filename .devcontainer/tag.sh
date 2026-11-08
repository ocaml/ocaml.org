#!/bin/sh
# Print the tag of the ghcr.io/ocaml/ocaml.org-dev image matching this checkout.
#
# The tag is a hash of the two files that determine the image's contents:
#   .devcontainer/Dockerfile: base image, compiler, opam-repository pin,
#                             system packages, dev tools
#   ocamlorg.opam:            dependencies, constraints, pin-depends commits
# The publishing workflow (.github/workflows/devcontainer.yml) and cloud
# sessions (.devcontainer/cloud-session-start.sh) both use it, so a given pair
# of files always maps to the same image.
set -eu
cd "$(dirname "$0")/.."
sha256sum .devcontainer/Dockerfile ocamlorg.opam | sha256sum | cut -c1-16
