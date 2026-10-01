FROM ocaml/opam:debian-ocaml-5.4

# Pin the opam-repository. This commit is at/below the opam-repo tip bundled in
# the ocaml/opam base image, so `git checkout` finds it locally with no network
# fetch. A commit newer than the base image tip would need `git fetch origin
# <sha>` before the checkout.
RUN cd ~/opam-repository && git checkout -b freeze 3055f69ae0c4f58f770177f94e39328a2b5887e7 && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.29.0 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


