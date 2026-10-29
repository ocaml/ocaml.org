FROM ocaml/opam:alpine-3.24-ocaml-5.2 AS build

# Install system dependencies
RUN sudo apk -U upgrade --no-cache && sudo apk add --no-cache \
    autoconf \
    curl-dev \
    gmp-dev \
    inotify-tools \
    libev-dev \
    oniguruma-dev \
    openssl-dev

# Use Opam 2.2 and enable the backup mirror if primary sources of packages are unavailable
RUN sudo mv /usr/bin/opam-2.2 /usr/bin/opam && opam update
RUN opam option --global 'archive-mirrors+="https://opam.ocaml.org/cache"'

# Pin the opam-repository. This commit is the tip already bundled in the
# ocaml/opam base image, so `git reset --hard` finds it locally and needs no
# network fetch. Keep the pin at or below the base image's opam-repo tip; a
# newer commit would require adding `git fetch origin <sha>` before the reset.
RUN cd ~/opam-repository && git reset --hard 8cdfa3296d9bc7d93273f46eb2438757e4fd5cf0 && opam update

WORKDIR /home/opam

# Install opam dependencies.
# OPAMSOLVERTIMEOUT is raised from the 60s default: this base image's bundled
# solver needs ~55s on ocaml.org's large dependency graph, which regressed to a
# timeout once the fixed river git pin was replaced by a "river" {>= "0.6"}
# constraint. GitHub Actions (setup-ocaml) solves the same request well within
# 60s; only this Docker solver is close to the limit, so give it headroom.
COPY --chown=opam ocamlorg.opam .
RUN OPAMSOLVERTIMEOUT=300 opam install . --deps-only

# Build project
COPY --chown=opam . .
RUN opam exec -- dune build @install --profile=release

# Launch project in order to generate the package state cache
RUN cd ~/opam-repository && git checkout master && git pull origin master && opam update
ENV OCAMLORG_PKG_STATE_PATH=package.state \
    OCAMLORG_REPO_PATH=opam-repository
RUN touch package.state && ./init-cache package.state

FROM alpine:3.24

RUN apk -U upgrade --no-cache && apk add --no-cache \
    git \
    gmp \
    libev

COPY --from=build /home/opam/package.state /var/package.state
COPY --from=build /home/opam/opam-repository /var/opam-repository
COPY --from=build /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server

COPY playground/asset playground/asset

RUN git clone https://github.com/ocaml-web/html-compiler-manuals /manual
ADD data/v2 /v2

RUN git config --global --add safe.directory /var/opam-repository

ENV DREAM_VERBOSITY=info \
    OCAMLORG_HTTP_PORT=8080 \
    OCAMLORG_MANUAL_PATH=/manual \
    OCAMLORG_MCP_ENABLED=true \
    OCAMLORG_PKG_STATE_PATH=/var/package.state \
    OCAMLORG_REPO_PATH=/var/opam-repository/ \
    OCAMLORG_V2_PATH=/v2

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
