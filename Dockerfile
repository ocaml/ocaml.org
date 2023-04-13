FROM ocaml/opam:alpine-3.17-ocaml-4.14 as build

# Install system dependencies
RUN sudo apk update && sudo apk add --update git-lfs libev-dev openssl-dev gmp-dev oniguruma-dev inotify-tools

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd opam-repository && git checkout -b freeze b457e9f3d6 && opam update

# Setup project folder
WORKDIR /home/opam
COPY --chown=opam:opam . .
RUN git lfs install && git lfs pull

# Install Opam dependencies
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

# Build project
RUN opam exec -- dune build @install --profile=release

# Launch project in order to generate the package state cache
RUN cd opam-repository && git checkout master && git pull origin master && opam update
ENV OCAMLORG_REPO_PATH opam-repository
ENV OCAMLORG_PKG_STATE_PATH package.state
RUN touch package.state && ./init-cache package.state

FROM alpine:3.17 as run

RUN apk update && apk add --update libev gmp git

RUN chmod -R 755 /var

COPY --from=build /home/opam/package.state /var/package.state
COPY --from=build /home/opam/opam-repository /var/opam-repository
COPY --from=build /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/ocamlorg
COPY --from=build /home/opam/playground/asset playground/asset

RUN git config --global --add safe.directory /var/opam-repository

ENV OCAMLORG_REPO_PATH /var/opam-repository/
ENV OCAMLORG_PKG_STATE_PATH /var/package.state
ENV DREAM_VERBOSITY info
ENV OCAMLORG_HTTP_PORT 8080

EXPOSE 8080

ENTRYPOINT /bin/ocamlorg
