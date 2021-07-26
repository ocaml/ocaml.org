FROM ocaml/opam:alpine as build

# Install system dependencies
RUN sudo apk add --update libev-dev openssl-dev nodejs npm

WORKDIR /home/opam

# Install Opam dependencies
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

# Install NPM dependencies
ADD package.json package.json
RUN npm install

# Download site static files
COPY --from=patricoferris/ocamlorg:latest /data asset/site/

# Build project
COPY --chown=opam:opam . .
RUN opam exec -- dune build

FROM alpine:3.12 as run

RUN apk add --update libev git

COPY --from=build /home/opam/_build/default/bin/main.exe /bin/server
COPY var/occurent-output/ /var/occurent-output/

ENV OCAMLORG_DOC_PATH /var/occurent-output/
ENV OCAMLORG_REPO_PATH /var/opam-repository/
ENV OCAMLORG_DEBUG false

RUN chmod -R 755 /var

EXPOSE 8080

ENTRYPOINT /bin/server
