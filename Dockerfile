FROM ocaml/opam:alpine-3.13-ocaml-4.14 as build

# Install system dependencies
RUN sudo apk update && sudo apk add --update libev-dev openssl-dev gmp-dev oniguruma-dev

RUN cd ~/opam-repository && git pull origin master && git reset --hard 589783b06b2ae581b9393ec4d1bf83b28cdf6d71 && opam update

WORKDIR /home/opam

# Install Opam dependencies
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

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
