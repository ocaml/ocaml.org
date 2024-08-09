FROM ocaml/opam:debian-ocaml-5.2

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git checkout -b freeze c45f5bab71d3589f41f9603daca5acad14df0ab0 && opam update

# Dev tools
RUN opam install -y dune-release merlin ocamlformat=0.26.2 utop ocaml-lsp-server

# Deps
RUN sudo apt update && sudo apt install -y pkg-config libev-dev libgmp-dev libonig-dev libssl-dev

RUN opam install -y --deps-only --with-test --with-doc .


