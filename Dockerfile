FROM ocaml/opam:alpine-3.24-ocaml-5.2 AS build

# Install system dependencies
RUN sudo apk -U upgrade --no-cache && sudo apk add --no-cache \
    autoconf \
    curl-dev \
    gmp-dev \
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

# Build the package state, from the opam-repository clone brought up to date.
# The builder exits with a non-zero status if it fails, which fails the build.
RUN cd ~/opam-repository && git checkout master && git pull origin master && opam update
RUN OCAMLORG_REPO_PATH=opam-repository \
    ./_build/default/src/ocamlorg_package/builder/main.exe package.state

FROM alpine:3.24

RUN apk -U upgrade --no-cache && apk add --no-cache \
    git \
    gmp \
    libev

# The server runs as an unprivileged user. The package-state builder it runs at
# every poll (see Ocamlorg_package.init) only writes to the package state and to
# the opam-repository clone it pulls from, so only those belong to that user;
# everything else stays owned by root. The state is replaced by renaming a new
# file over it, so the directory holding it belongs to that user too.
RUN adduser -D -u 1000 -h /home/ocamlorg -s /sbin/nologin ocamlorg \
    && install -d -o ocamlorg -g ocamlorg /var/lib/ocamlorg

COPY --from=build --chown=ocamlorg:ocamlorg /home/opam/package.state /var/lib/ocamlorg/package.state
COPY --from=build --chown=ocamlorg:ocamlorg /home/opam/opam-repository /var/opam-repository
# Without --chown, COPY --from keeps the build stage's owner (opam, uid 1000),
# which is also the uid given to ocamlorg above.
COPY --from=build --chown=root:root /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server
COPY --from=build --chown=root:root /home/opam/_build/default/src/ocamlorg_package/builder/main.exe /bin/ocamlorg-package-builder

COPY playground/asset playground/asset

RUN git clone https://github.com/ocaml-web/html-compiler-manuals /manual
ADD data/v2 /v2

ENV DREAM_VERBOSITY=info \
    OCAMLORG_HTTP_PORT=8080 \
    OCAMLORG_MANUAL_PATH=/manual \
    OCAMLORG_MCP_ENABLED=true \
    OCAMLORG_PKG_STATE_PATH=/var/lib/ocamlorg/package.state \
    OCAMLORG_REPO_PATH=/var/opam-repository/ \
    OCAMLORG_V2_PATH=/v2

EXPOSE 8080

USER ocamlorg
ENTRYPOINT ["/bin/server"]
