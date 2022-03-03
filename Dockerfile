FROM ocaml/opam:alpine-3.13-ocaml-4.13 as build

# Install system dependencies
RUN sudo apk update && sudo apk add --update libev-dev openssl-dev gmp-dev nodejs npm

RUN cd ~/opam-repository && git pull origin master && git reset --hard a20d83154c86b62f43034d38cfec41a9cc7cd2c4 && opam update

WORKDIR /home/opam

# Install Opam dependencies
ADD ocamlorg-data.opam ocamlorg-data.opam
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

# Install NPM dependencies
ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm ci

# Build project
COPY --chown=opam:opam . .
RUN opam exec -- dune build @install @toplevel --profile=release --ignore-promoted-rules

FROM alpine:3.12 as run

RUN apk update && apk add --update libev gmp git

RUN chmod -R 755 /var

COPY --from=build /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server
COPY --from=build /home/opam/_build/default/src/ocamlorg_toplevel/bin/js/ /var/toplevels/

RUN git clone https://github.com/ocaml/opam-repository /var/opam-repository

ENV OCAMLORG_REPO_PATH /var/opam-repository/
ENV OCAMLORG_PKG_STATE_PATH /var/package.state
ENV OCAMLORG_TOPLEVELS_PATH /var/toplevels/
ENV DREAM_VERBOSITY info
ENV OCAMLORG_HOSTNAME v3.ocaml.org
ENV OCAMLORG_HTTP_PORT 8080

EXPOSE 8080

ENTRYPOINT /bin/server
