# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
make switch        # Create local opam switch and install dependencies (first-time setup)
make deps          # Install dependencies in current switch (if using global switch)
make build         # Build the project
make start         # Build and run the server
make watch         # Run server with auto-reload on file changes
make test          # Run unit tests
make fmt           # Format code with ocamlformat
make clean         # Clean build artifacts
make doc           # Generate odoc documentation
make utop          # Run a REPL linked to project libraries
make playground    # Build the OCaml Playground
make docker        # Build docker container
```

## Architecture Overview

This is a Dream-based OCaml web application that serves ocaml.org. The architecture separates data (YAML/Markdown), code generation, and rendering.

### Data Flow

1. **Content** lives in `data/` as YAML and Markdown files (tutorials, books, jobs, events, etc.)
2. **Data packer** (`tool/data-packer/`) transforms data into OCaml modules at build time
3. **Generated modules** appear in `src/ocamlorg_data/data.ml` (e.g., `data/books/*.md` → book entries in `data.ml`)
4. **Frontend** (`src/ocamlorg_frontend/`) uses `.eml` templates (Dream's HTML templating) to render pages
5. **Web server** (`src/ocamlorg_web/`) handles routing and serves the site
6. **Data scraper** (`tool/data-scrape/`) fetches external content (planet feeds, videos, platform releases)

### Key Source Directories

- `src/ocamlorg_data/` - `data_intf.ml` defines data types (edit this); `data.ml` is generated (don't edit)
- `src/ocamlorg_frontend/pages/` - EML templates (OCaml + HTML) for all pages
- `src/ocamlorg_web/lib/` - Dream server, routing, handlers
- `src/ocamlorg_package/` - Package management and opam-repository integration
- `src/ocamlorg_static/` - Static file serving
- `tool/data-packer/` - Code generator that converts YAML/Markdown data into OCaml modules
- `tool/data-scrape/` - Scraper for external content (planet feeds, videos, platform releases)

### The EML Templating System

Pages use `.eml` files which are preprocessed by `dream_eml`. These mix OCaml code with HTML:
- OCaml expressions: `<%s variable %>` or `<% code %>`
- Templates are in `src/ocamlorg_frontend/pages/`

### Adding or Modifying Content

Most site content is in `data/`. After editing:
- Changes to `data/` files require a rebuild (`make build`) to regenerate `src/ocamlorg_data/data.ml`
- The data packer enforces structure via types in `src/ocamlorg_data/data_intf.ml`

### The `data/` Directory

The `data/` directory contains site content as YAML and Markdown files. Subdirectories include: academic_institutions, backstage, books, changelog, code_examples, conferences, cookbook, events, exercises, industrial_users, is_ocaml_yet, media, news, pages, planet, platform_releases, releases, success_stories, tool_pages, tutorials. Top-level YAML files include jobs.yml, governance.yml, papers.yml, tools.yml, etc.

Some content is scraped automatically (planet posts, videos, platform releases) — see CI Workflows below.

### Tailwind CSS

CSS uses Tailwind. The binary is downloaded by Dune during build. Run `dune install tailwind` to persist it in the local switch across `dune clean`.

## System Dependencies

Required: libev, oniguruma, openssl, gmp. See `Dockerfile` for exact packages.

## Dependency Pinning

The opam repository is pinned to a specific commit in the following files, which must be updated together:

- `Makefile`
- `Dockerfile`
- `.github/workflows/ci.yml`
- `.github/workflows/debug-ci.yml`
- `.github/workflows/release-scrapers.yml`

After updating the pin, run `opam repo set-url pin git+https://github.com/ocaml/opam-repository#<commit-hash>`, then `opam update && opam upgrade`. If OCamlFormat is upgraded, update `.ocamlformat` and `.github/workflows/ci.yml` accordingly.

## Environment Variables

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `OCAMLORG_HTTP_PORT` | `8080` | HTTP server port |
| `OCAMLORG_DOC_URL` | `https://sage.ci.dev/current/` | Package documentation server URL |
| `OCAMLORG_REPO_PATH` | `~/.cache/ocamlorg/opam-repository` | Path to local opam-repository clone |
| `OCAMLORG_PKG_STATE_PATH` | `~/.cache/ocamlorg/package.state` | Path to package state cache file |
| `OCAMLORG_PACKAGE_CACHES_TTL` | `3600` | Package cache time-to-live in seconds |
| `OCAMLORG_OPAM_POLLING` | `3600` | Opam repository polling interval in seconds |
| `OCAMLORG_MANUAL_PATH` | `html-compiler-manuals` | Path to OCaml compiler manual HTML files |
| `OCAMLORG_V2_PATH` | `data/v2` | Path to v2 data files |

## CI Workflows

- **ci.yml** — Build, test, and format check on push/PR to `main` (Ubuntu + macOS, OCaml 5.2.0)
- **markdown-lint.yml** — Lint changed Markdown files on push/PR (excludes `data/planet/` and `data/changelog/`)
- **scrape.yml** — Daily scrape of OCaml Planet feeds and videos, opens a PR with new content
- **scrape_platform_releases.yml** — Daily scrape of OCaml Platform releases, opens a PR with new content
- **release-scrapers.yml** — Builds and publishes the scraper binary on push to `main` (when `tool/`, `src/`, or build files change)

## Deployment

- `main` branch deploys to https://ocaml.org/
- `staging` branch deploys to https://staging.ocaml.org/
- Pipeline managed by [ocurrent-deployer](https://github.com/ocurrent/ocurrent-deployer), monitor at https://deploy.ci.ocaml.org/?repo=ocaml/ocaml.org

### Package Documentation

Package docs under `/p/<package>/<version>/doc/` are served from an external documentation server (`https://sage.ci.dev/current/`) built by [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci). Configurable via `OCAMLORG_DOC_URL`.
