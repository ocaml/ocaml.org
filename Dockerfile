FROM ocaml/opam:debian-13-ocaml-5.2 AS build

# Install system dependencies
RUN sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y --no-install-recommends \
    autoconf \
    inotify-tools \
    libcurl4-openssl-dev \
    libev-dev \
    libgmp-dev \
    libonig-dev \
    libssl-dev \
    pkg-config \
    && sudo rm -rf /var/lib/apt/lists/*

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

FROM debian:trixie-slim

# ca-certificates is only recommended by git on Debian, but the server pulls
# opam-repository over HTTPS.
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    libev4t64 \
    libgmp10 \
    && rm -rf /var/lib/apt/lists/*

# The server runs as an unprivileged user. It only writes to the package state
# and to the opam-repository clone it pulls from (see Ocamlorg_package.init), so
# only those belong to it; everything else stays owned by root.
RUN useradd -u 1000 -m -d /home/ocamlorg -s /usr/sbin/nologin ocamlorg

COPY --from=build --chown=ocamlorg:ocamlorg /home/opam/package.state /var/package.state
COPY --from=build --chown=ocamlorg:ocamlorg /home/opam/opam-repository /var/opam-repository
# Without --chown, COPY --from keeps the build stage's owner (opam, uid 1000),
# which is also the uid given to ocamlorg above.
COPY --from=build --chown=root:root /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server

COPY playground/asset playground/asset

RUN git clone https://github.com/ocaml-web/html-compiler-manuals /manual
ADD data/v2 /v2

ENV DREAM_VERBOSITY=info \
    OCAMLORG_HTTP_PORT=8080 \
    OCAMLORG_MANUAL_PATH=/manual \
    OCAMLORG_MCP_ENABLED=true \
    OCAMLORG_PKG_STATE_PATH=/var/package.state \
    OCAMLORG_REPO_PATH=/var/opam-repository/ \
    OCAMLORG_V2_PATH=/v2

EXPOSE 8080

USER ocamlorg
ENTRYPOINT ["/bin/server"]
