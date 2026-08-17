# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

Run `make help` to list the available targets. First-time setup is `make switch` (creates a local opam switch bound to the pinned opam-repository, then installs dependencies); `make watch` runs the server with auto-reload.

## Before Submitting a PR

Formatting and linting failures are the #1 cause of CI failures. Always run these before pushing:

```bash
make fmt                        # Format OCaml code (auto-promotes changes)
npx markdownlint-cli2 '**/*.md' # Lint Markdown files (config: .markdownlint-cli2.jsonc)
```

CI checks both on every push/PR. `make fmt` auto-promotes changes in place; commit any files it touches.

**OCamlFormat is pinned to 0.26.2** (in `.ocamlformat`, `Makefile`, and `.github/workflows/ci.yml`). With any other version installed, `make fmt` does *not* reformat — OCamlFormat's default version check aborts with a `version mismatch` error and exits non-zero. Install the pinned binary via `make deps` (or `opam install ocamlformat=0.26.2`).

Markdown lint rules live in `.markdownlint-cli2.jsonc`; CI lints only changed files and skips `data/planet/` and `data/changelog/`.

## Architecture Overview

This is a Dream-based OCaml web application that serves ocaml.org. The architecture separates data (YAML/Markdown), code generation, and rendering.

### Data Flow

1. **Content** lives in `data/` as YAML and Markdown files (tutorials, books, jobs, events, etc.)
2. **Data packer** (`tool/data-packer/`) packs the YAML/Markdown into a binary blob, `data.bin`, at build time
3. The blob is embedded in the binary via an `.incbin` assembly directive; `src/ocamlorg_data/data.ml` deserializes it lazily (`bin_prot`) and exposes hand-written accessor modules (`Book`, `Changelog`, …)
4. **Frontend** (`src/ocamlorg_frontend/`) uses `.eml` templates (Dream's HTML templating) to render pages
5. **Web server** (`src/ocamlorg_web/`) handles routing and serves the site
6. **Data scraper** (`tool/data-scrape/`) fetches external content (planet feeds, videos, platform releases)

### Key Source Directories

- `src/ocamlorg_data/` - `data_intf.ml` defines the data types; `data.ml` is the hand-written accessor layer over the deserialized blob. The build artifact `data.bin` is generated from `data/` (never committed)
- `src/ocamlorg_frontend/pages/` - EML templates (OCaml + HTML) for all pages
- `src/ocamlorg_web/lib/` - Dream server, routing, handlers
- `src/ocamlorg_package/` - Package management and opam-repository integration
- `src/ocamlorg_static/` - Static file serving
- `src/global/` - Project-wide definitions (URL helpers, ppx import)
- `tool/data-packer/` - Packs YAML/Markdown data into the `data.bin` blob
- `tool/data-scrape/` - Scraper for external content (planet feeds, videos, platform releases)

### The EML Templating System

Pages use `.eml` files which are preprocessed by `dream_eml`. These mix OCaml code with HTML:
- OCaml expressions: `<%s variable %>` or `<% code %>`
- Templates are in `src/ocamlorg_frontend/pages/`

### Working with `data/`

Site content lives in `data/` as YAML and Markdown — one subdirectory per content type (`books/`, `tutorials/`, …) plus top-level `.yml` files (`jobs.yml`, `governance.yml`, …). The data packer enforces structure via the types in `src/ocamlorg_data/data_intf.ml`, so a malformed file fails the build. After editing, `make build` repacks the `data.bin` blob.

**Don't hand-edit scraped content.** `data/planet/`, `data/video-watch.yml`, `data/video-youtube.yml`, and `data/platform_releases/` are machine-managed — the scrape workflows open PRs against them and manual edits get overwritten (see CI Workflows).

**When you rename or remove `data/` content, update `asset/llms.txt` too.** It hardcodes `ocaml.org` links whose slugs derive from each page's `title:`/`id:` (not its filename), and CI never checks them, so stale links break silently.

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

After updating the pin, run `opam repo set-url pin git+https://github.com/ocaml/opam-repository#<commit-hash>`, then `opam update && opam upgrade`. If OCamlFormat is upgraded in the process, update its version in `.ocamlformat`, `Makefile`, and `.github/workflows/ci.yml` together.

## Environment Variables

Defined in `src/ocamlorg_web/lib/config.ml` and `src/ocamlorg_package/lib/config.ml`. The ones you typically override when running locally:

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `OCAMLORG_HTTP_PORT` | `8080` | HTTP server port |
| `OCAMLORG_DOC_URL` | `https://sage.ci.dev/current/` | External package-documentation server (see below) |
| `OCAMLORG_REPO_PATH` | `~/.cache/ocamlorg/opam-repository` | Local opam-repository clone |
| `OCAMLORG_PKG_STATE_PATH` | `~/.cache/ocamlorg/package.state` | Package state cache file |

The remaining variables (`OCAMLORG_PACKAGE_CACHES_TTL`, `OCAMLORG_OPAM_POLLING`, `OCAMLORG_MANUAL_PATH`, `OCAMLORG_V2_PATH`) are tuning/path overrides rarely changed in development.

## CI Workflows

Two gate every PR: **ci.yml** (build + test + `make fmt` check; Ubuntu + macOS, OCaml 5.2.0) and **markdown-lint.yml** (lints changed `*.md`, skipping `data/planet/` and `data/changelog/`).

The rest are automation: **scrape.yml** and **scrape_platform_releases.yml** run daily and open PRs with newly scraped content; **release-scrapers.yml** rebuilds the scraper binary when `tool/`, `src/`, or build files land on `main`.

## Deployment

- `main` branch deploys to <https://ocaml.org/>
- `staging` branch deploys to <https://staging.ocaml.org/>
- Pipeline managed by [ocurrent-deployer](https://github.com/ocurrent/ocurrent-deployer), monitor at <https://deploy.ci.ocaml.org/?repo=ocaml/ocaml.org>

### Package Documentation

Package docs under `/p/<package>/<version>/doc/` are served from an external documentation server (`https://sage.ci.dev/current/`) built by [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci). Configurable via `OCAMLORG_DOC_URL`.
