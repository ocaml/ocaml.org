FROM ocaml/opam:debian-ocaml-5.2

# Pin the opam-repository. This commit is at/below the opam-repo tip bundled in
# the ocaml/opam base image, so `git checkout` finds it locally with no network
# fetch. A commit newer than the base image tip would need `git fetch origin
# <sha>` before the checkout.
RUN cd ~/opam-repository && git checkout -b freeze b3b872a94fa79b28ee160b900b3713b3f8ba4dbb && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.26.2 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


