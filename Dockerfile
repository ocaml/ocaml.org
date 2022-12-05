FROM ocaml/opam:alpine-3.17-ocaml-4.14 as build

# Install system dependencies
RUN sudo apk update && sudo apk add --update libev-dev openssl-dev gmp-dev oniguruma-dev

# Set opam repo at: f72694d Merge pull request #22599 from dbuenzli/b0-publish-ptime.1.1.0
RUN cd ~/opam-repository && git pull origin f72694dcd7c7cd6c6438f3f988c4742f0758737a && opam update

WORKDIR /home/opam

# Install Opam dependencies
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

# Build project
COPY --chown=opam:opam . .
RUN opam exec -- dune build @install --profile=release

FROM alpine:3.17 as run

RUN apk update && apk add --update libev gmp git

RUN chmod -R 755 /var

COPY --from=build /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server

RUN git clone https://github.com/ocaml/opam-repository /var/opam-repository

ENV OCAMLORG_REPO_PATH /var/opam-repository/
ENV OCAMLORG_PKG_STATE_PATH /var/package.state
ENV DREAM_VERBOSITY info
ENV OCAMLORG_HTTP_PORT 8080

EXPOSE 8080

ENTRYPOINT /bin/server
