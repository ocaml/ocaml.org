# Upstream Dependencies

This file lists what OCaml.org pins to a fixed commit, fork, or version, and the upstream issues and pull requests that hold a pin or a workaround in place. Each entry says what has to happen upstream before the pin or workaround can go, and what to change here when it does.

Keep it current: when you add a pin or a workaround for an upstream bug, add a row; when you remove one, delete its row. How to move the opam-repository pin is in [Managing Dependencies](HACKING.md#managing-dependencies).

## Forks and Unreleased Commits

These are pins to code that is not in any opam release. They are the ones to retire first.

| What | Pinned to | Where | Why | Blocked on | When unblocked |
| --- | --- | --- | --- | --- | --- |
| `gluten`, `gluten-lwt`, `gluten-lwt-unix` 0.5.2 | [`mtelvers/gluten@8cbce6d`](https://github.com/mtelvers/gluten/commit/8cbce6d903b3e779b1fc3f505ae8702d858ad3a2), branch `fix/io-loop-close-on-exn-0.5.2` (Mark Elvers's fix, cherry-picked onto 0.5.2) | `pin-depends` in [`ocamlorg.opam.template`](ocamlorg.opam.template) | Released `gluten-lwt-unix` leaks one file descriptor per client that resets its connection mid-request; this exhausted the fd limit and took the site down on 2026-10-03. The `dream {>= "1.0.0~alpha8"}` bound exists so Dream takes gluten from opam (and so from this pin) instead of vendoring it. | [anmonteiro/gluten#90](https://github.com/anmonteiro/gluten/pull/90) (open), then a gluten release in opam-repository | Bump the opam-repository pin past the release, delete the three `gluten` lines and their comment from `ocamlorg.opam.template`, and run `dune build` to regenerate `ocamlorg.opam`. |
| `hilite` 0.6.0 | [`patricoferris/hilite@f536855`](https://github.com/patricoferris/hilite/commit/f5368558f765ff6c884fda68acf4d4e9256970b4) (17 commits past `v0.5.0`, untagged) | `pin-depends` in [`ocamlorg.opam.template`](ocamlorg.opam.template) | `tool/data-packer` uses the `hilite.markdown` library, which no release contains. Building from a Git pin makes Ubuntu CI fail intermittently with `Library "hilite.markdown" not found`. | A hilite 0.6.0 release in opam-repository; no upstream request filed yet. Tracked by [#3759](https://github.com/ocaml/ocaml.org/issues/3759). | Bump the opam-repository pin past the release, delete the `hilite` line from `ocamlorg.opam.template`, keep `hilite {>= "0.6.0"}`, and close #3759. |
| `merlin-js` | Git submodule [`voodoos/merlin-js@a736719`](https://github.com/voodoos/merlin-js/commit/a7367198d332f153ed27de2136d3c6a4af8e206f) at `playground/vendor/merlin-js` | [`.gitmodules`](.gitmodules), [`playground/vendor/dune`](playground/vendor/dune), `UPSTREAM` comment in [`playground/dune-project`](playground/dune-project) | The `merlin-js` package is compiled against a copy of `code-mirror` that it vendors and does not install, so it cannot be linked with the `code-mirror` package. | [patricoferris/jsoo-code-mirror#23](https://github.com/patricoferris/jsoo-code-mirror/pull/23) (open: upstreams the LSP client that merlin-js vendors), then a merlin-js change to depend on `code-mirror` instead of vendoring it (not filed yet). Neither `merlin-js` nor `code-mirror` is in opam-repository, so dropping the submodule also needs either opam releases of both or Git pins. | Delete the submodule and `playground/vendor/`, and restore the `merlin-js` and `code-mirror` dependencies in `playground/dune-project`. Until both are released on opam, pin them in a new `playground/ocamlorg-playground.opam.template` and list them in the first table. |

## Workarounds for Upstream Bugs

These are not pins, but code here that exists only because of an upstream bug.

| Workaround | Where | Upstream cause | Blocked on | When unblocked |
| --- | --- | --- | --- | --- |
| `make toplevel-client` reinstalls `js_of_ocaml-toplevel` when its `worker_lwt_client` library is missing | [`playground/Makefile`](playground/Makefile), a step in [`.github/workflows/playground.yml`](.github/workflows/playground.yml) | `js_of_ocaml-toplevel` does not declare `js_of_ocaml-ppx` as an optional dependency, so opam can build it first and dune silently skips the library. | A `depopts` fix in [ocsigen/js_of_ocaml](https://github.com/ocsigen/js_of_ocaml) and in the released `js_of_ocaml-toplevel` metadata in opam-repository (not filed yet) | Bump the opam-repository pin past the metadata fix, then delete the target and the CI step. |
| The `sim642` planet feed is never scraped | [#4000](https://github.com/ocaml/ocaml.org/issues/4000) | Syndic 1.8.0 raises `Not_found` on an empty Atom text construct (`<subtitle></subtitle>`), which is valid Atom. OCaml.org reaches Syndic through [river](https://github.com/tarides/river) (`River.fetch` in `tool/data-scrape`), whose `~repair` option cannot work around it: river retries with repairs only when Syndic raises `Syndic.*.Error.Error`, and `Not_found` escapes that. | [Cumulus/Syndic#93](https://github.com/Cumulus/Syndic/issues/93) (open), then a Syndic release. Alternatively, a river release whose `~repair` strips empty text constructs before parsing (not filed yet). | Bump the opam-repository pin past whichever release lands first (if it is river, also set `repair: true` on the `sim642` source), check that the next `scrape-planet.yml` run scrapes the feed, then close #4000. |

## Related Upstream Issues

These do not hold a pin, but affect OCaml.org.

| Issue | Relevance |
| --- | --- |
| [camlworks/dream#347](https://github.com/camlworks/dream/issues/347) (open) | Dream leaks sockets on macOS; the same failure class as the gluten fd leak above. |
| [ocurrent/ocaml-docs-ci#197](https://github.com/ocurrent/ocaml-docs-ci/issues/197) (open) | JSON snapshot list and build statuses from the documentation server, to see how fresh package documentation is without scraping HTML. |
| [ocaml-web/html-compiler-manuals#14](https://github.com/ocaml-web/html-compiler-manuals/issues/14) (open) | CI-built odoc and sherlodoc artifacts for the compiler; prerequisite of the RFC [#3909](https://github.com/ocaml/ocaml.org/issues/3909) to serve the compiler and standard library documentation natively. |

## Pinned Versions

These pin released artefacts, to keep builds reproducible. They move by deliberate bumps, not because of an upstream bug.

| What | Pinned to | Where | How it moves |
| --- | --- | --- | --- |
| opam-repository | [`ca403de`](https://github.com/ocaml/opam-repository/commit/ca403de684b07caee6f246b36a2f3a1787d780ac) | [`Makefile`](Makefile), [`playground/Makefile`](playground/Makefile), [`Dockerfile`](Dockerfile), [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile), [`dune-workspace`](dune-workspace), and the `setup-ocaml` steps of `ci.yml`, `debug-ci.yml`, `playground.yml`, `release-playground.yml` (twice), `release-scraper.yml`, and `sync-attribution.yml` | By hand, all sites together, at or below the base images' bundled opam-repository tip. See [Managing Dependencies](HACKING.md#managing-dependencies). |
| ocaml-dune/opam-overlays | [`2a95432`](https://github.com/ocaml-dune/opam-overlays/commit/2a9543286ff0e0656058fee5c0da7abc16b8717d) | [`dune-workspace`](dune-workspace) | By hand. Only used by dune package management (`dune pkg lock`), which needs the dune developers' patched forks of some low-level packages; no build or CI uses it. |
| Production base images | `ocaml/opam:debian-13-ocaml-5.5` (build), `debian:trixie-slim` (runtime), by tag | [`Dockerfile`](Dockerfile) | Follows the upstream tags; the tag's bundled opam-repository must contain the pinned commit. |
| Devcontainer base image | `ocaml/opam:debian-13-ocaml-5.5`, by digest | [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) | Dependabot proposes digest updates monthly ([`.github/dependabot.yml`](.github/dependabot.yml)). |
| OCaml compiler | 5.5.2 | [`Makefile`](Makefile), `COMPILER` in [`playground/Makefile`](playground/Makefile) | By hand. For the playground, see [Bumping the Playground Compiler](HACKING.md#bumping-the-playground-compiler); a new compiler usually waits for a `merlin-lib` release. |
| OCamlFormat | 0.29.0 | `.ocamlformat`, [`Makefile`](Makefile), [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile), `ci.yml`, `debug-ci.yml` | By hand, all sites together, independently of the opam-repository pin. |
| Tailwind CSS binary | v3.3.6 | [`tool/tailwind/dune`](tool/tailwind/dune), [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) (with its SHA-256) | By hand. |
| Playground smoke-test driver | `puppeteer-core` 25.16.0, exact, with its `package-lock.json`; it drives the runner's installed Chrome (`/usr/bin/google-chrome`, or `CHROME`), which is not pinned | [`playground/test/package.json`](playground/test/package.json), [`playground/test/package-lock.json`](playground/test/package-lock.json) | By hand: Dependabot does not watch npm. Each puppeteer-core release is tested against one Chrome version, while the runner's Chrome moves on its own. |
| Playground assets | The release named in [`playground/release`](playground/release), with its SHA-256 | [`playground/release`](playground/release) | A bot pull request opened by `release-playground.yml` after each playground change on `main`. |
| GitHub Actions | Major versions (`actions/checkout@v7`, `ocaml/setup-ocaml@v3`, …) | `.github/workflows/*.yml` | Dependabot, weekly. |
