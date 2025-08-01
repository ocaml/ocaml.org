# Hacking on OCaml.org

## Setup and Development

### Setting Up the Project

Before starting to hack, you need a properly configured development environment. Linux and macOS are supported and used daily by the core team. System dependencies include:

* Libev: <http://software.schmorp.de/pkg/libev.html>
* Oniguruma: <https://github.com/kkos/oniguruma>
* OpenSSL: <https://www.openssl.org/>
* GNU Multiple Precision: <https://gmplib.org/>

The project [`Dockerfile`](./Dockerfile) contains up-to-date system configuration instructions, as used to ship into production. It is written for the Alpine Linux distribution, but it is meant to be adapted to other environments such as Ubuntu, macOS+Homebrew, or others. The GitHub workflow file [`.github/workflows/ci.yml`](.github/workflows/ci.yml) also contains useful commands for Ubuntu and macOS. Since OCaml.org is mostly written in OCaml, a properly configured OCaml development environment is also required, but is not detailed here. Although Docker is used to ship, it is not a requirement to begin hacking. Currently, OCaml.org doesn't yet compile using OCaml 5; version 4.14 of the language is used. It is possible to run workflow files in `.github/workflows` using the [`nektos/act`](https://github.com/nektos/act) tool. For instance, the following command runs the CI checks through GitHub on each pull request (where `ghghgh` is replace by an _ad-hoc_ GitHub token, see: <https://github.com/nektos/act#github_token>)

```bash
act -s GITHUB_TOKEN=ghghgh .github/workflows/ci.yml -j build
```

The Makefile contains many commands that can get you up and running. A typical workflow is to clone the repository after forking it.

```bash
git clone https://github.com/<username>/OCaml.org.git
cd OCaml.org
```

Ensure you have [Dune Binary](https://github.com/ocaml-dune/dune-bin-install) installed. Dune will manage the OCaml compiler along with all of the OCaml packages needed to build and run the project. By this point, we should all be using some Unix-like system (Linux, macOS, WSL2). We assume you are using the most recent version of Dune.

If you would like to build using Dune installed via `opam`, make sure to remove the `dune.lock/` directories and use the same build commands present in the Makefile, skipping `dune pkg lock`.

### Running the Server

From the root of your project, you can just build and run the project with

```bash
make start
```

Dune will install the OCaml compiler, as well as all the dependencies needed by the project.

To start the server in watch mode, you can run:

```bash
make watch
```

This will restart the server on filesystem changes.

### Running Tests

#### Unit tests

You can run the unit test suite with:

```bash
make test
```

#### Load tests

See the readme's for running load tests via [k6](./test/load-test/k6/README.md)
or [locust](./test/load-test/locust/README.md).

### Building the Playground

The OCaml Playground is compiled separately from the rest of the server. The generated assets can be found in
[`playground/asset/`](./playground/asset/).

You can build the playground from the root of the project. There is no need to move to the `./playground/` directory for the following commands.

Simply build the project to regenerate the JavaScript assets:

```bash
make playground
```

Once the compilation is complete and successuful, commit the newly-generated assets in OCaml.org's Git repo and merge the pull request.

### Deploying

Commits added on some branches are automatically deployed:

* `main` on <https://OCaml.org/>
* `staging` on <https://staging.OCaml.org/>

The deployment pipeline is managed in <https://github.com/ocurrent/ocurrent-deployer>, which listens to the `main` and `staging` branches and builds the site using the `Dockerfile` at the project's root. You can monitor the state of each deployment on [`deploy.ci.OCaml.org`](https://deploy.ci.OCaml.org/?repo=ocaml/OCaml.org).

To test the deployment locally, run the following commands:

```bash
docker build -t ocamlorg .
docker run -p 8080:8080  ocamlorg
```

This will build the Docker image and run a Docker container with the port `8080` mapped to the HTTP server.

With the Docker container running, visit the site at <http://localhost:8080/>.

The Docker images automatically build from the `live` and `staging` branches. They are then pushed to Docker Hub: <https://hub.docker.com/r/ocurrent/v3.OCaml.org-server>.

### Staging Pull Requests

We [aim to keep the `staging` branch as close as possible to the `main`
branch](doc/FOR_MAINTAINERS.md#how-we-maintain-the-staging-branch), with only a few PRs added on top of it.

The maintainers will add your pull request to `staging` if it is worthwhile
to do so. For example, documentation PRs or new features where we need testing
and feedback from the community will generally be live on `staging` for a while
before they get merged.

### Managing Dependencies

OCaml.org is using an pinned version of `opam-repository`. This is intended to protect the build from upstream regressions. The opam repository is specified in one place:

```bash
dune-workspace
```

### Handling the Tailwind CSS CLI

The Tailwind CSS framework. The tailwind binary pulled from its GitHub [repo](https://github.com/tailwindlabs/tailwindcss). Download is performed by Dune during the build. When working on a local switch for hacking, you don't want `dune clean` to delete this binary. Just do `dune install tailwind` to have it installed in the local switch.

## Repository Structure

The following snippet describes the repository structure:

```text
.
├── asset/
|   The static assets served by the site.
│
├── data/
|   Data used by OCaml.org in Yaml and Markdown format.
│
├── playground/
│   The source and generated assets for the OCaml Playground
│
├── src
│   ├── global
│   │   Project wide definitions
│   │
│   ├── ocamlorg_data
│   │   The result of compiling all of the information in `/data` into OCaml modules.
│   │
│   ├── ocamlorg_frontend
│   │   All of the front-end code primarily using .eml files (OCaml + HTML).
│   │
│   ├── ocamlorg_package
│   │   The library for constructing opam-repository statistics and information (e.g. rev deps).
│   │
│   └── ocamlorg_web
│       The main entry-point of the server.
│
├── tool/
│   Sources for development tools such as the `ocamlorg_data` code generator.
│
├── dune
├── dune-project
│   Dune file used to mark the root of the project and define project-wide parameters.
│   For the documentation of the syntax, see https://dune.readthedocs.io/en/latest/reference/dune-project/index.html.
├── dune-workspace
│   Dune file used to define the repositories used for dependencies by Dune package management
│   For the documentation of the syntax, see https://dune.readthedocs.io/en/latest/reference/dune-workspace/index.html.
│
├── CONTRIBUTING.md
│
├── Dockerfile
│   Dockerfile used to build and deploy the site in production.
│
├── LICENSE
├── LICENSE-3RD-PARTY
│   Licenses of the source code, data and vendored third-party projects.
│
├── Makefile
│   `Makefile` containing common development commands.
│
├── README.md
│
└── tailwind.config.js
    Configuration used by TailwindCSS to generate the CSS file for the site.
```
