FROM ocaml/opam:debian-10-ocaml-4.12 AS build

USER root

# Install system dependencies
RUN apt-get update && apt-get install curl gnupg2 libev-dev libssl-dev pkg-config libsqlite3-dev libgmp-dev graphviz libffi-dev -y --no-install-recommends

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install nodejs -y --no-install-recommends

WORKDIR /home/opam

# Install Opam dependencies
ADD ocamlorg.opam ocamlorg.opam
RUN opam install . --deps-only

# Install NPM dependencies
ADD package.json package.json
RUN npm install

# Build project
COPY --chown=opam:opam . .
RUN opam exec -- dune build

FROM debian:10

USER root

# Install system dependencies
RUN apt-get update && apt-get install libev4 openssh-client curl gnupg2 dumb-init git graphviz libsqlite3-dev ca-certificates netbase -y --no-install-recommends

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' >> /etc/apt/sources.list
RUN apt-get update && apt-get install docker-ce -y --no-install-recommends

# Copy binary and fixtures
COPY --from=build /home/opam/_build/default/bin/main.exe /bin/server
COPY var/occurent-output/ /var/occurent-output/

# Set environment variables
ENV OCAMLORG_DOC_PATH /var/occurent-output/
ENV OCAMLORG_REPO_PATH /var/opam-repository/
ENV OCAMLORG_DEBUG false
ENV DREAM_VERBOSITY debug

# Allow write access to the var directory
RUN chmod -R 755 /var

EXPOSE 8080

ENTRYPOINT ["dumb-init", "/bin/server"]
