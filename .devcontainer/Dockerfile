FROM ocaml/opam:debian-ocaml-4.14

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git checkout -b freeze 8cc107f96e33a4601f7c39346eb19fbbe46486d3 && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.24.1 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


