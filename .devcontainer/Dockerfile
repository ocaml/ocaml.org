# Development image for OCaml.org: an opam switch with every dependency of
# ocamlorg.opam installed, plus the dev tools. Used by the devcontainer and,
# published as ghcr.io/ocaml/ocaml.org-dev, by Claude Code cloud sessions (see
# HACKING.md, "Devcontainer and Cloud Sessions"). Build it from the repository
# root: docker build -f .devcontainer/Dockerfile .
FROM ocaml/opam:debian-13-ocaml-5.2

LABEL org.opencontainers.image.source="https://github.com/ocaml/ocaml.org"
LABEL org.opencontainers.image.description="OCaml.org development environment"

# Cloud sessions run commands as root against a root-owned bind mount; let opam
# accept that without complaint.
ENV OPAMROOTISOK=1

# System dependencies (keep in sync with the "Install system dependencies"
# step of .github/workflows/ci.yml)
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libev-dev \
    libgmp-dev \
    libonig-dev \
    libssl-dev \
    pkg-config \
 && sudo rm -rf /var/lib/apt/lists/*

# Tailwind CSS (the version tool/tailwind/dune downloads). With it on the PATH,
# the build doesn't download it from GitHub, which cloud sessions can't reach.
RUN sudo curl -fsSL --retry 5 --retry-all-errors -o /usr/local/bin/tailwindcss \
      https://github.com/tailwindlabs/tailwindcss/releases/download/v3.3.6/tailwindcss-linux-x64 \
 && echo "8b47e368541bcd72f60c837943ffb51918564d1a1a6b8b469c30afe829780612  /usr/local/bin/tailwindcss" | sha256sum -c - \
 && sudo chmod +x /usr/local/bin/tailwindcss

# Use a recent opam and enable the backup mirror if primary sources of
# packages are unavailable
RUN sudo ln -sf /usr/bin/opam-2.5 /usr/bin/opam && opam init --reinit -ni \
 && opam option --global 'archive-mirrors+="https://opam.ocaml.org/cache"'

# Pin the opam-repository. This commit is at/below the opam-repo tip bundled in
# the ocaml/opam base image, so `git reset --hard` finds it locally with no
# network fetch. A commit newer than the base image tip would need `git fetch
# origin <sha>` before the reset.
RUN cd ~/opam-repository && git reset --hard 8cdfa3296d9bc7d93273f46eb2438757e4fd5cf0 && opam update

# Dev tools. OCamlFormat is pinned (see .ocamlformat) so that installing the
# project dependencies can't upgrade it along with cmdliner.
RUN opam pin add -yn ocamlformat 0.26.2 && opam pin add -yn ocamlformat-lib 0.26.2 \
 && opam install -y merlin ocamlformat ocaml-lsp-server utop

# Project dependencies
COPY --chown=opam ocamlorg.opam /home/opam/deps/
RUN opam install -y --deps-only --with-test --with-doc /home/opam/deps/ \
 && opam clean -a -c -s --logs
