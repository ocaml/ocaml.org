# syntax=docker/dockerfile:1
FROM ocaml/opam:alpine-3.20-ocaml-5.2 AS build
RUN sudo ln -sf /usr/bin/opam-2.3 /usr/bin/opam && opam init --reinit -ni

# Install system dependencies
RUN sudo apk add --no-cache \
    autoconf \
    curl-dev \
    gmp-dev \
    inotify-tools \
    libev-dev \
    oniguruma-dev \
    openssl-dev

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git fetch -q origin master && git reset --hard 11bdbee61114a1cfa080b764e71c72a5760a93f0 && opam update

WORKDIR /home/opam

# Install opam dependencies
COPY --chown=opam --link ocamlorg.opam .
RUN --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    opam install . --deps-only

# Build project
COPY --chown=opam . .
RUN opam exec -- dune build @install --profile=release

# Launch project in order to generate the package state cache
RUN cd ~/opam-repository && git checkout master && opam update
ENV OCAMLORG_REPO_PATH=opam-repository
ENV OCAMLORG_PKG_STATE_PATH=package.state
RUN touch package.state && ./init-cache package.state

FROM alpine:3.20 AS run

RUN apk add --no-cache \
    git \
    gmp \
    libev

COPY --from=build --link /home/opam/package.state /var/package.state
COPY --from=build --link /home/opam/opam-repository /var/opam-repository
COPY --from=build --link /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server

COPY --link playground/asset playground/asset

ADD --keep-git-dir --link https://github.com/ocaml-web/html-compiler-manuals /manual

RUN git config --global --add safe.directory /var/opam-repository

ENV OCAMLORG_REPO_PATH=/var/opam-repository/
ENV OCAMLORG_MANUAL_PATH=/manual
ENV OCAMLORG_PKG_STATE_PATH=/var/package.state
ENV DREAM_VERBOSITY=info
ENV OCAMLORG_HTTP_PORT=8080

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
