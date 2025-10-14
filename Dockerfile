FROM alpine:3.21 AS build

# Install system dependencies
RUN apk -U upgrade --no-cache && apk add --no-cache \
    # to download and install Dune Developer Preview with alpine:3.21
    build-base patch tar ca-certificates git \
       libx11-dev coreutils xz curl bash \
    autoconf \
    curl-dev \
    gmp-dev \
    inotify-tools \
    libev-dev \
    oniguruma-dev \
    openssl-dev

RUN curl -4fsSL https://github.com/ocaml-dune/dune-bin-install/releases/download/v3/install.sh | sh -s 3.20.1 --install-root /usr --no-update-shell-config
RUN dune --version

# Build project
WORKDIR "/root/ocaml.org"
COPY --chown=root . .
RUN ls

RUN dune pkg lock
RUN dune build @install --profile=release

# Launch project in order to generate the package state cache
ENV OCAMLORG_PKG_STATE_PATH=package.state \
    OCAMLORG_REPO_PATH=opam-repository
RUN touch package.state && ./init-cache package.state

FROM alpine:3.21

RUN apk -U upgrade --no-cache && apk add --no-cache \
    git \
    gmp \
    libev

COPY --from=build "/root/ocaml.org/package.state" /var/package.state
COPY --from=build "/root/ocaml.org/opam-repository" /var/opam-repository
COPY --from=build "/root/ocaml.org/_build/default/src/ocamlorg_web/bin/main.exe" /bin/server

COPY playground/asset playground/asset

RUN git clone https://github.com/ocaml-web/html-compiler-manuals /manual
ADD data/v2 /v2

RUN git config --global --add safe.directory /var/opam-repository

ENV DREAM_VERBOSITY=info \
    OCAMLORG_HTTP_PORT=8080 \
    OCAMLORG_MANUAL_PATH=/manual \
    OCAMLORG_PKG_STATE_PATH=/var/package.state \
    OCAMLORG_REPO_PATH=/var/opam-repository/ \
    OCAMLORG_V2_PATH=/v2

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
