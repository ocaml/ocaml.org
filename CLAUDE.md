# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository. The human-facing documentation is the source of truth; read it rather than relying on this summary:

- [`HACKING.md`](HACKING.md): setup, running the server, tests, environment variables, dependency pinning, architecture, `data/` rules, CI workflows, and repository structure.
- [`CONTRIBUTING.md`](CONTRIBUTING.md): how each kind of content in `data/` is contributed.
- [`DOCUMENTATION_WRITING.md`](DOCUMENTATION_WRITING.md): writing guidelines for tutorials.
- [`doc/FOR_MAINTAINERS.md`](doc/FOR_MAINTAINERS.md): the `staging` branch and pushing to contributors' forks.
- [`tool/attribution/README.md`](tool/attribution/README.md), [`tool/data-packer/DESIGN.md`](tool/data-packer/DESIGN.md): tool-specific documentation.

## Rules That Are Easy to Miss

- **Before pushing**, run `make fmt` (commit what it changes) and `npx markdownlint-cli2 '**/*.md'`. These are the most common CI failures. OCamlFormat is pinned to 0.26.2; with any other version, `make fmt` aborts with `version mismatch` instead of formatting. See [Before Submitting a PR](HACKING.md#before-submitting-a-pr).
- **Cloud sessions** (`CLAUDE_CODE_REMOTE=true`): OCaml isn't installed on the VM; run `make`, `opam`, and `dune` commands through `.devcontainer/run` (e.g. `.devcontainer/run make build`). See [Devcontainer and Cloud Sessions](HACKING.md#devcontainer-and-cloud-sessions).
- **Lwt only**: Dream is Lwt-based, so don't introduce Eio dependencies.
- **`data/` rules** (UTF-8 without BOM, no hand-editing of scraped files, never touch `data/attribution.jsonl` in a PR, update `asset/llms.txt` on renames/removals): see [Working With `data/`](HACKING.md#working-with-data).
- **Bumping the opam-repository pin**: all pin sites change together, and the commit must be at or below the base images' bundled opam-repository tip. See [Managing Dependencies](HACKING.md#managing-dependencies).
- **Package docs** under `/p/<package>/<version>/doc/` come from an external server, not from this code base. See [External Services](HACKING.md#external-services).
