# Hacking on OCaml.org

## Setup and Development

### Setting Up the Project

Before starting to hack, you need a properly configured development environment. Linux and macOS are supported and used daily by the core team. System dependencies include:

* Libev: <http://software.schmorp.de/pkg/libev.html>
* Oniguruma: <https://github.com/kkos/oniguruma>
* OpenSSL: <https://www.openssl.org/>
* GNU Multiple Precision: <https://gmplib.org/>

The project [`Dockerfile`](./Dockerfile) contains up-to-date system configuration instructions, as used to ship into production. It is written for the Alpine Linux distribution, but it is meant to be adapted to other environments such as Ubuntu, macOS+Homebrew, or others. The GitHub workflow file [`.github/workflows/ci.yml`](.github/workflows/ci.yml) also contains useful commands for Ubuntu and macOS. Since OCaml.org is mostly written in OCaml, a properly configured OCaml development environment is also required, but is not detailed here. Although Docker is used to ship, it is not a requirement to begin hacking. It is possible to run workflow files in `.github/workflows` using the [`nektos/act`](https://github.com/nektos/act) tool. For instance, the following command runs the CI checks through GitHub on each pull request (where `ghghgh` is replace by an _ad-hoc_ GitHub token, see: <https://github.com/nektos/act#github_token>)

```bash
act -s GITHUB_TOKEN=ghghgh .github/workflows/ci.yml -j build
```

The Makefile contains many commands that can get you up and running. A typical workflow is to clone the repository after forking it.

```bash
git clone https://github.com/<username>/OCaml.org.git
cd OCaml.org
```

Ensure you have `opam` installed. Opam will manage the OCaml compiler along with all of the OCaml packages needed to build and run the project. By this point, we should all be using some Unix-like system (Linux, macOS, WSL2), so you should [run the opam install script](https://opam.OCaml.org/doc/Install.html#Binary-distribution). There are also manual instructions for people that don't want to run a script from the internet. We assume you are using `opam.2.1.0` or later, which provides a cleaner, friendlier experience when installing system dependencies.

With opam installed, you can now initialise opam with `opam init`. Note that in containers or WSL2, you will have to run `opam init --disable-sandboxing`. Opam might complain about some missing system dependencies like `unzip`, `cc` (a C compiler like `gcc`), etc. Make sure to install these before `opam init`.

Finally from the root of your project, you can setup a [local opam switch](https://opam.OCaml.org/doc/Manual.html#Switches) and install the dependencies. There is a single `make` target to do just that.

```bash
make switch
```

If you don't want a local opam switch and are happy to install everything globally (in the opam sense), then you can just install the dependencies directly.

```bash
make deps
```

Opam will likely ask questions about installing system dependencies. For the project to work, you will have to answer yes to installing these.

Run `make help` to list the other common `make` targets.

### Devcontainer and Cloud Sessions

[`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) describes a ready-to-use development environment: Debian 13 with OCaml 5.2, the pinned opam-repository, the system libraries, every dependency of `ocamlorg.opam`, and the dev tools (OCamlFormat 0.26.2, `ocaml-lsp-server`, Merlin, `utop`). The [`devcontainer.yml`](.github/workflows/devcontainer.yml) workflow publishes it as `ghcr.io/ocaml/ocaml.org-dev`. Each image is tagged by [`.devcontainer/tag.sh`](.devcontainer/tag.sh), a hash of `.devcontainer/Dockerfile` and `ocamlorg.opam`, and the latest build from `main` is also tagged `main`.

Tools that support devcontainers (VS Code, GitHub Codespaces, DevPod, and others) build it from `.devcontainer/devcontainer.json`, reusing the published layers, and add Node.js and the GitHub CLI. It asks for 4 CPUs, 16 GB of memory, and 32 GB of storage. The base image is pinned by digest, so the published layers stay reusable; Dependabot proposes digest updates monthly.

[Claude Code cloud sessions](https://code.claude.com/docs/en/claude-code-on-the-web) (claude.ai/code) use the same image. The cloud VM runs Ubuntu without OCaml, so a `SessionStart` hook in [`.claude/settings.json`](.claude/settings.json) starts the image as a container named `ocamlorg-dev`, with the repository mounted at the same path. Build, test, and format commands run inside it through [`.devcontainer/run`](.devcontainer/run):

```bash
.devcontainer/run make build
.devcontainer/run make test
.devcontainer/run make fmt
```

The hook does nothing outside cloud sessions. Markdown lint (`npx markdownlint-cli2`) runs directly on the VM, which has Node.js. To work on OCaml.org from claude.ai/code, each person sets up the following once:

1. Connect GitHub to claude.ai/code, so that sessions can clone `ocaml/ocaml.org` and push branches.
2. Create a cloud environment with the default **Trusted** network access, which already allows `ghcr.io`.
3. Paste [`.devcontainer/cloud-setup.sh`](.devcontainer/cloud-setup.sh) as the environment's setup script. It pulls the image once, and the environment cache keeps it for later sessions.

The hook also gives the server a clone of the image's opam-repository, at its default `OCAMLORG_REPO_PATH`, because cloud sessions can't clone it from GitHub. Package pages therefore show opam-repository as of the pin.

`.devcontainer/run` gives commands no terminal and no standard input, and doesn't pass the host's environment variables: set them with `env`, e.g. `.devcontainer/run env OCAMLORG_MCP_ENABLED=true make watch`.

A branch that changes `ocamlorg.opam` or `.devcontainer/Dockerfile` has a new tag. Branches of `ocaml/ocaml.org` get their own image, built from the branch head, as soon as their pull request is open (Dependabot's excepted). Until then, the hook falls back to the `main` image and says so. When a resumed session's tag has changed, for instance after editing `ocamlorg.opam` or merging `main`, the hook replaces the container, which stops anything running in it, such as a server. Note that cloud sessions can't fetch source archives from GitHub repositories other than `ocaml/ocaml.org`, and the GitHub CLI's `gh pr` and `gh issue` commands don't work there (open pull requests from the web interface, or use `gh api`).

### Running the Server

After building the project, you can run the server with:

```bash
make start
```

To start the server in watch mode, you can run:

```bash
make watch
```

This will restart the server on filesystem changes.

### Before Submitting a PR

Formatting and linting failures are the most common cause of CI failures. Before pushing, always run:

```bash
make fmt
```

This formats OCaml code with ocamlformat and auto-promotes the changes. Commit any files it modifies. OCamlFormat is pinned to 0.26.2 (in `.ocamlformat`, `Makefile`, and `.github/workflows/ci.yml`); with any other version installed, `make fmt` aborts with a version-mismatch error instead of reformatting, so run `make deps` to install the pinned version.

If your PR touches Markdown files, also lint them:

```bash
npx markdownlint-cli2 '**/*.md'
```

Markdown lint rules are configured in [`.markdownlint-cli2.jsonc`](./.markdownlint-cli2.jsonc). The CI excludes `data/planet/` and `data/changelog/` from Markdown lint.

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

To regenerate the playground, you need to install the playground's dependencies first:

```bash
make deps -C playground
```

After the dependencies have been installed, simply build the project to regenerate the JavaScript assets:

```bash
make playground
```

Once the compilation is complete and successful, commit the newly-generated assets in OCaml.org's Git repo and merge the pull request.

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

To watch how a build behaves over many opam-repository updates, with realistic traffic and memory, CPU, GC, and latency recorded, see the server simulation in [`tool/sim/`](tool/sim/README.md).

The Docker images automatically build from the `live` and `staging` branches. They are then pushed to Docker Hub: <https://hub.docker.com/r/ocurrent/v3.OCaml.org-server>.

### Environment Variables

The following environment variables configure the server. They are defined in [`src/ocamlorg_web/lib/config.ml`](src/ocamlorg_web/lib/config.ml) and [`src/ocamlorg_package/lib/config.ml`](src/ocamlorg_package/lib/config.ml), where comments explain the reasoning behind each default.

The ones you typically override when running locally:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `OCAMLORG_HTTP_PORT` | `8080` | HTTP server port |
| `OCAMLORG_DOC_URL` | `https://dill.caelum.ci.dev/profiles/full/docs/` | Package documentation server URL (see [External Services](#external-services)) |
| `OCAMLORG_DOC_STATUS_URL` | `https://dill.caelum.ci.dev/profiles/full/` | Documentation build status server URL (see [External Services](#external-services)) |
| `OCAMLORG_REPO_PATH` | `~/.cache/ocamlorg/opam-repository` | Path to local opam-repository clone |
| `OCAMLORG_PKG_STATE_PATH` | `~/.cache/ocamlorg/package.state` | Path to package state cache file |
| `OCAMLORG_MANUAL_PATH` | `html-compiler-manuals` | Path to the OCaml compiler manual HTML files, a clone of [`ocaml-web/html-compiler-manuals`](https://github.com/ocaml-web/html-compiler-manuals) (relative to the working directory) |
| `OCAMLORG_MCP_ENABLED` | `false` | Enable the `/mcp` endpoint (the hosted MCP server) |

Tuning knobs, rarely changed in development:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `OCAMLORG_V2_PATH` | `data/v2` | Path to v2 data files |
| `OCAMLORG_OPAM_POLLING` | `3600` | Opam repository polling interval in seconds |
| `OCAMLORG_PACKAGE_CACHES_TTL` | `3600` | Package cache time-to-live in seconds |
| `OCAMLORG_DOC_CACHE_MAX` | `1000` | Maximum entries in each documentation cache |
| `OCAMLORG_DOC_CACHE_MAX_BYTES` | `134217728` (128 MB) | Byte budget for each documentation cache |
| `OCAMLORG_DOC_NEGATIVE_TTL` | `60` | Time-to-live in seconds of cached "documentation missing" outcomes |
| `OCAMLORG_LATEST_DOC_VERSION_DEPTH` | `25` | How many versions to probe, newest first, when looking for the latest documented one |
| `OCAMLORG_MAX_DOC_FETCH_BYTES` | `52428800` (50 MB) | Maximum size of a single response from the documentation server |
| `OCAMLORG_DOC_FETCH_TIMEOUT` | `30` | Timeout in seconds of a single fetch from the documentation server |
| `OCAMLORG_MCP_RATE_LIMIT` | `300` | Per-IP request limit on `/mcp`, per window |
| `OCAMLORG_MCP_RATE_WINDOW` | `60` | Length in seconds of the `/mcp` rate-limit window |
| `OCAMLORG_MCP_TRUST_XFF` | `false` | Key the `/mcp` rate limit on `X-Forwarded-For`; enable only behind a proxy that sets it |
| `OCAMLORG_MCP_CACHE_TTL` | `300` | Time-to-live in seconds of cached `/mcp` responses |
| `OCAMLORG_MCP_CACHE_MAX` | `1024` | Maximum entries in the `/mcp` response cache |
| `OCAMLORG_MCP_CACHE_MAX_BYTES` | `33554432` (32 MB) | Byte budget of the `/mcp` response cache |
| `OCAMLORG_MCP_MAX_BODY` | `1048576` (1 MB) | Maximum `/mcp` request body size in bytes |

### Package Metadata and State

The server does not build an opam switch for the packages it displays, and it never runs `opam install` or compiles any package. All package information comes from a local git clone of [opam-repository](https://github.com/ocaml/opam-repository) at `OCAMLORG_REPO_PATH`, kept current by a periodic `git pull` (interval `OCAMLORG_OPAM_POLLING`).

At startup the server parses the opam files in that clone and computes the derived metadata — synopsis, authors, licence, dependencies, reverse dependencies, publication dates — entirely in memory. Reverse dependencies, for instance, come from inverting the parsed dependency graph, not from querying opam.

Parsing and computing this for the whole repository is expensive, so the result is serialised to the cache file at `OCAMLORG_PKG_STATE_PATH` (`package.state`). On the next start the server loads that cache instead of re-parsing. The cache is stamped with an internal version number and is rebuilt automatically whenever the opam-repository clone advances past the commit it was built from, or when that version number changes.

The only package artefacts that come from elsewhere are the rendered documentation pages, which are fetched from an external server — see [External Services](#external-services) below.

### External Services

#### Package Documentation

The package documentation pages displayed under `/p/<package>/<version>/doc/` are not generated by the OCaml.org server itself. Instead, they are fetched from an external documentation server.

This documentation is generated by [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci), an OCurrent pipeline that builds documentation for all opam packages using [odoc](https://github.com/ocaml/odoc). The pipeline runs on a server called "dill" and the generated documentation is served at `https://dill.caelum.ci.dev/profiles/full/docs/`.

The same server also reports the documentation build status of each package version at `https://dill.caelum.ci.dev/profiles/full/`. The OCaml.org server links to these status pages when documentation is missing or failed to build.

Both URLs can be configured via the `OCAMLORG_DOC_URL` and `OCAMLORG_DOC_STATUS_URL` environment variables if you need to point to a different documentation server (e.g., for testing or staging).

### Staging Pull Requests

We [aim to keep the `staging` branch as close as possible to the `main`
branch](doc/FOR_MAINTAINERS.md#how-we-maintain-the-staging-branch), with only a few PRs added on top of it.

The maintainers will add your pull request to `staging` if it is worthwhile
to do so. For example, documentation PRs or new features where we need testing
and feedback from the community will generally be live on `staging` for a while
before they get merged.

### Managing Dependencies

OCaml.org is using an opam switch that is local and bound to a pinned commit in `opam-repository`. This is intended to protect the build from upstream regressions. The opam repository commit is specified in the following files:

```text
Makefile
Dockerfile
.devcontainer/Dockerfile
dune-workspace
.github/workflows/ci.yml
.github/workflows/debug-ci.yml
.github/workflows/release-scraper.yml
.github/workflows/sync-attribution.yml
```

When bringing up OCaml.org to a newer pin, the commit hash found in those files must be changed all at once.

#### Choosing the Pin Commit

`Dockerfile` and `.devcontainer/Dockerfile` both derive from an `ocaml/opam` base image (see their `FROM` lines), which bundles a full clone of opam-repository frozen at some tip. They select the pin with `git reset --hard <sha>` **without** a `git fetch`, so the commit must already be present in that bundled clone:

* **At or below the base image's tip**, the commit is in local history, and the reset works without any network fetch. This is the fast path, and it matters because these images are rebuilt frequently.
* **Beyond the base image's tip**, the reset fails with `Could not parse object`. This only surfaces in the `deployability` check, not in GitHub Actions, where `setup-ocaml` fetches the commit directly. Recovering requires prepending `git fetch origin <sha> &&` to the reset, which costs a full opam-repository download on every build.

So the default is to pin to the base image's current opam-repository tip. Find it with the following commands, substituting the images named in the two `FROM` lines (`.devcontainer/Dockerfile` pins its base image by digest, so a digest update must also keep the pin at or below the new image's tip):

```bash
docker run --rm ocaml/opam:alpine-3.24-ocaml-5.2 sh -c 'cd ~/opam-repository && git rev-parse HEAD'  # Dockerfile
docker run --rm ocaml/opam:debian-13-ocaml-5.2 sh -c 'cd ~/opam-repository && git rev-parse HEAD'    # .devcontainer/Dockerfile
```

The two base images can sit at different tips: pick a commit at or below the **older** of the two. Only pin beyond the tip (and add the `git fetch`) if you need a package version newer than the base image snapshot.

#### Updating the Local Switch

Once the opam repo pin is updated, the local switch must be updated using the following command:

```sh
opam repo set-url pin git+https://github.com/ocaml/opam-repository#<commit-hash>
```

Where `<commit-hash>` is the pinned hash specified in the files mentioned above.

Once this is done, you can run `opam update` and `opam upgrade`. OCamlFormat is pinned independently: if you upgrade it, update its version together in `.ocamlformat`, `Makefile`, and `.github/workflows/ci.yml`.

### Handling the Tailwind CSS

The site uses the Tailwind CSS framework. The Tailwind binary is pulled from its GitHub [repo](https://github.com/tailwindlabs/tailwindcss). Download is performed by Dune during the build. When working on a local switch for hacking, you don't want `dune clean` to delete this binary. Just do `dune install tailwind` to have it installed in the local switch.

## Architecture

OCaml.org is a [Dream](https://github.com/camlworks/dream) web application. It separates data (YAML and Markdown), code generation, and rendering. The stack is based on Lwt, since Dream only supports Lwt: please don't introduce Eio dependencies.

### Data Flow

1. **Content** lives in `data/` as YAML and Markdown files (tutorials, books, jobs, events, etc.).
2. **The data packer** (`tool/data-packer/`) packs the YAML and Markdown into a binary blob, `data.bin`, at build time. Its design is described in [`tool/data-packer/DESIGN.md`](tool/data-packer/DESIGN.md).
3. The blob is embedded in the server executable with an `.incbin` assembly directive. [`src/ocamlorg_data/data.ml`](src/ocamlorg_data/data.ml) deserialises it lazily (with `bin_prot`) and exposes hand-written accessor modules (`Book`, `Changelog`, …). The types are defined in [`src/ocamlorg_data/data_intf.ml`](src/ocamlorg_data/data_intf.ml).
4. **The frontend** (`src/ocamlorg_frontend/`) renders pages from `.eml` templates.
5. **The web server** (`src/ocamlorg_web/`) handles routing and serves the site.
6. **The data scraper** (`tool/data-scrape/`) fetches external content: OCaml Planet feeds, videos, platform releases, and opam build results.

### EML Templates

Pages are written as `.eml` files in `src/ocamlorg_frontend/pages/`, preprocessed by Dream's [templating preprocessor](https://camlworks.github.io/dream/#templates). They mix OCaml and HTML: `<%s expr %>` inserts an escaped string, and `<% code %>` embeds OCaml code.

### Working With `data/`

The data packer enforces the structure of `data/` through the types in `src/ocamlorg_data/data_intf.ml`, so a malformed file fails the build. After editing, `make build` repacks `data.bin`. In addition:

* **Files in `data/` must be UTF-8 without a byte-order mark.** The packer fails the build otherwise, and the scrapers replace invalid UTF-8 in remote text with U+FFFD before writing.
* **Don't hand-edit scraped content.** `data/planet/` (except `data/planet/-individual_external_links/`), `data/video-watch.yml`, `data/video-youtube.yml`, `data/platform_releases/`, and `data/opam_health.yml` are machine-managed: the scrape workflows open pull requests against them, and manual edits get overwritten.
* **Don't touch `data/attribution.jsonl` in pull requests.** It is updated after merging, see [`tool/attribution`](tool/attribution/README.md).
* **When you rename or remove content, update [`asset/llms.txt`](asset/llms.txt) too.** It hardcodes `ocaml.org` links whose slugs derive from each page's `title:` or `id:` (not its filename), and CI doesn't check them.

### CI Workflows

Two workflows gate every pull request:

* [`ci.yml`](.github/workflows/ci.yml) builds and tests the project on Ubuntu and macOS, and checks `make fmt`.
* [`markdown-lint.yml`](.github/workflows/markdown-lint.yml) lints the changed Markdown files.

The others are automation. `scrape-planet.yml`, `scrape-platform-releases.yml`, and `scrape-opam-health.yml` (build results from check.ci.ocaml.org) run daily, and `sync-attribution.yml` runs after each merge that touches a tutorial or tool page. Each keeps a single rolling pull request open on a `bot/<area>` branch (`bot/planet`, `bot/platform`, `bot/opam-health`, `bot/attribution`). Its commit subject, which is also the pull request title, reads `<area>: <what changed>`, for instance `planet: 4 posts (effects, eio, …), 2 videos`. `release-scraper.yml` rebuilds the scraper binary when `tool/`, `src/`, or build files change on `main`. `devcontainer.yml` publishes the [development image](#devcontainer-and-cloud-sessions) when `.devcontainer/` or `ocamlorg.opam` change.

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
│   │   Accessor layer over the packed `data/` blob (`data.bin`); types defined in `data_intf.ml`.
│   │
│   ├── ocamlorg_frontend
│   │   All of the front-end code primarily using .eml files (OCaml + HTML).
│   │
│   ├── ocamlorg_package
│   │   Reads the local opam-repository clone and computes package metadata (stats, dependencies, rev deps), cached to `package.state`. No packages are built or installed.
│   │
│   ├── ocamlorg_static
│   │   Static file serving.
│   │
│   └── ocamlorg_web
│       The main entry-point of the server.
│
├── test/
│   Load tests.
│
├── tool/
│   ├── attribution
│   │   Maintains the "Authors and history" records of tutorials and tool pages.
│   │
│   ├── data-packer
│   │   Packs YAML/Markdown data from `data/` into the `data.bin` binary blob.
│   │
│   ├── data-scrape
│   │   Scraper for external content (planet feeds, videos, platform releases,
│   │   opam build results from check.ci.ocaml.org).
│   │
│   ├── sim
│   │   Accelerated, instrumented simulation of the server: replays opam-repository
│   │   history and traffic into the Docker image (see `tool/sim/README.md`).
│   │
│   ├── static-file-digest
│   │   Static file digest utility.
│   │
│   ├── tailwind
│   │   Tailwind CSS binary download and integration.
│   │
│   └── voodoo_serialize
│       Serialization tool for package documentation.
│
├── dune
├── dune-project
│   Dune file used to mark the root of the project and define project-wide parameters.
│   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project.
│
├── ocamlorg.opam
├── ocamlorg.opam.template
│   opam package definitions.
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
├── HACKING.md
│
├── doc/
│   Maintainer documentation.
│
└── tailwind.config.js
    Configuration used by TailwindCSS to generate the CSS file for the site.
```
