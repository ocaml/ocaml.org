FROM ocaml/opam:debian-ocaml-4.14

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git checkout -b freeze c1fcfbe8369cb5a7cb8d7be63db59856dbd85d19 && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.24.1 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


