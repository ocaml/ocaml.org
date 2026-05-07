---
title: "Platform Newsletter: February to April 2026"
description: "OCaml Platform Feb-Apr 2026: OCaml 5.5.0~beta1 with relocatable compiler and modular explicits, Dune 3.22 series with sandboxed tests, OCaml-LSP 1.26.0 + Merlin 5.7.0-504, OCamlFormat 0.29.0, opam 2.5.1 security release, opam-publish 3.0.0, dune-release 2.2.1, ppxlib 0.38.0, utop 2.17.0, MDX 2.5.2"
date: "2026-05-07"
tags: [platform]
---

Welcome to the eighteenth edition of the OCaml Platform newsletter!

In this February to April 2026 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**If you only read three things**: OCaml 5.5.0~beta1 with a relocatable compiler; the OCaml 5.4.1 / 4.14.3 security patches (Marshal hardening); the OCamlFormat 0.29.0 upgrade caveat (CI diff churn).

**Highlights:**

- **OCaml 5.5.0 reaches beta** (Apr 20). The relocatable compiler — movable between directories without breaking — is the headline deployment-side change, simplifying packaging and binary distribution. New language features land too: modular explicits, polymorphic function parameters, generalised local bindings. Final release targeted for May; tools are in preview now.
- **Security: OCaml 5.4.1 / 4.14.3** (Feb 17) patch OSEC-2026-01 by hardening Marshal (`intern.c`) against malicious inputs. Anyone deserialising untrusted data should upgrade. opam 2.5.1 (Apr 16) ships OSEC-2026-03 (`.install` paths escaping their scope) — distribution maintainers should upgrade or backport.
- **Dune 3.22.0** (Mar 19): tests `(test)`/`(tests)` are now sandboxed by default — may surface latent flakiness on upgrade. Long-requested `dune runtest <file>` runs individual tests. New `DUNE_JOBS` env var; cache layout migrates to `$DUNE_CACHE_ROOT/db`. 3.22.1 / 3.22.2 follow with regression fixes.
- **Editor tools dual release** (Apr 10) — OCaml-LSP 1.26.0 + Merlin 5.7.0-504. New: `refactor-extract-region` (extract to let-binding), `locate_types` (jump to types inside a hovered type), `textDocument/rangeFormatting`. Preview builds for OCaml 5.5 also shipped.
- **OCamlFormat 0.29.0** (Mar 17): OCaml 5.5 syntax support, Odoc parser to 3.0, default `ocaml-version=5.4`. **Heads-up**: four `*`-marked formatting changes will produce diff churn on first run — teams gating CI on `ocamlformat --check` should plan a deliberate upgrade.
- **opam-publish 3.0.0** (Feb 20): major release with breaking changes — cmdliner 2.0 ends prefix-matching, `--split` is removed. Quality-of-life: default-branch and fork-name auto-detection (release scripts targeting forks renamed to `main` now work).
- **Other releases**: ppxlib 0.38.0 (PPX support for OCaml 5.5 + 5.4 labeled tuples and bivariant type parameters), utop 2.17.0 (OCaml 5.5 + `utop.el` decoupled from `tuareg-mode`), MDX 2.5.2 (OCaml 5.5 compatibility), dune-release 2.2.1 (`--prerelease` flag).

**Stable Releases:**

- [Dune 3.21.1](https://ocaml.org/changelog/2026-02-11-dune-3211) (Feb 11, 2026)
- [OCaml 5.4.1 and 4.14.3](https://ocaml.org/changelog/2026-02-17-ocaml-541-and-4143) (Feb 17, 2026)
- [opam-publish 3.0.0](https://ocaml.org/changelog/2026-02-20-opam-publish-300) (Feb 20, 2026)
- [OCamlFormat 0.29.0](https://ocaml.org/changelog/2026-03-17-ocamlformat-0290) (Mar 17, 2026)
- [Dune 3.22.0](https://ocaml.org/changelog/2026-03-19-dune3220) (Mar 19, 2026)
- [ppxlib 0.38.0](https://ocaml.org/changelog/2026-03-20-ppxlib-0380) (Mar 20, 2026)
- [MDX 2.5.2](https://ocaml.org/changelog/2026-03-23-mdx-252) (Mar 23, 2026)
- [dune-release 2.2.1](https://ocaml.org/changelog/2026-03-26-dune-release-221) (Mar 26, 2026)
- [utop 2.17.0](https://ocaml.org/changelog/2026-03-26-utop-2170) (Mar 26, 2026)
- [Dune 3.22.1](https://ocaml.org/changelog/2026-04-06-dune3221) (Apr 6, 2026)
- [OCaml-LSP 1.26.0 & Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10, 2026)
- [Dune 3.22.2](https://ocaml.org/changelog/2026-04-14-dune3222) (Apr 14, 2026)
- [opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-2-5-1) (Apr 16, 2026)
- [Merlin 5.7.1-504](https://ocaml.org/changelog/2026-04-30-merlin-v571-504) (Apr 30, 2026)

**Unstable Releases:**

- [OCaml 5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27, 2026)
- [Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505preview) (Feb 27, 2026)
- [OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55preview) (Mar 19, 2026)
- [OCaml 5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26, 2026)
- [OCaml 5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20, 2026)

(OCaml 5.5.0~alpha2 was tagged but never officially released, due to an interaction between the relocatable compiler and bootstrapping.)

## OCaml Compiler

### Maintenance Releases: 5.4.1 and 4.14.3

[OCaml 5.4.1 and 4.14.3](https://ocaml.org/changelog/2026-02-17-ocaml-541-and-4143) (February 17, 2026) are maintenance releases of the 5.4 and 4.14 stable branches. The headline is [OSEC-2026-01](https://github.com/ocaml/security-advisories/): the `intern.c` Marshal implementation has been hardened against malicious inputs — anyone deserialising untrusted data should upgrade. The releases also ship several correctness fixes, including a long-standing miscompilation of unsafe int32/int64/nativeint array accesses present since 4.04 (4.14.3 #13448), a `Lazy.force` race fix (#13430), a demarshal-exception memory-corruption fix (#14007), and TSan-related fixes for OCaml 5 users (5.4.1 #14065/#14213/#14255). See the release notes for the full list.

### OCaml 5.5.0 Progresses to Beta

The OCaml 5.5.0 release cycle moved through three alphas and into a first beta during this period. **5.5.0 is the first OCaml release in a while to ship multiple notable language extensions**, and the first to ship a relocatable compiler.

**Headline features in 5.5.0:**

- **Relocatable compiler** (deployment-side): the compiler and its associated tools can be moved/copied between directories after installation without breaking functionality. Significant for opam, Docker, sandboxed installs, and binary distribution. (See [the relocatable-OCaml announcement](https://discuss.ocaml.org/t/relocatable-ocaml/17253) referenced in the previous newsletter.)
- **Modular explicits** (language): function arguments can now carry a module signature dependency (`(module M : S) -> t[M]`), enabling module-dependent function arguments without full functor syntax.
- **Polymorphic function parameters** (language): functions can now take arguments with explicit polymorphic types (e.g. `(getter : 'a. 'a t -> 'a)`), enabling clean ST-monad-style and rank-2 patterns previously requiring records.
- **Generalised local bindings** (language): `let module`, `let exception`, `let open`, and `let type` are now supported in expressions in more contexts.
- **Standard library expansions**: notably `String.split_*`, `String.replace_*`, `String.includes`, `Option.product`, `List.split_map`, `Lazy.Mutexed`.

**Release timeline:**

- [5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27) — first alpha, opening the bug-hunting window.
- 5.5.0~alpha2 — tagged but unreleased: an unforeseen interaction between the relocatable compiler and bootstrapping was discovered before the release was finalised.
- [5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26) — fixes the bootstrap issue. Notable items beyond the count: a type-soundness restoration (#14434, #14652), a register-allocator miscompilation fix (#14583), and an s390x heap-corruption fix (#13693, #14514).
- [5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20) — most developer tools are now available (at least in preview form). Compared to the last alpha, beta1 fixes two runtime bugs (ephemerons; the bytecode interpreter), two type-system bugs (classes; module-dependent functions), and three warning/error-message bugs. The release announcement explicitly invites users to test their libraries and programs against 5.5.0 in preparation for the final release, expected in May.

The [release readiness meta-issue](https://github.com/ocaml/opam-repository/issues/29463) tracks ongoing work on the surrounding ecosystem.

## Build System

### Dune

Four Dune releases shipped during this period: a 3.21 patch and the 3.22.x series.

**[Dune 3.21.1](https://ocaml.org/changelog/2026-02-11-dune-3211) (Feb 11)** — small patch:

- Melange `-p <PKG>` package mask fix ([#13522](https://github.com/ocaml/dune/pull/13522)) — affects Melange users running scoped builds, a common release/CI workflow.
- `dune promote` no longer starts the RPC server ([#13428](https://github.com/ocaml/dune/pull/13428)) — small but observable behavior change for tooling that relied on RPC being available after `promote`.

**[Dune 3.22.0](https://ocaml.org/changelog/2026-03-19-dune3220) (Mar 19)** — main release of the cycle. Highlights:

- **Tests sandboxed by default**: `(test)` and `(tests)` stanzas are now sandboxed by default ([#13510](https://github.com/ocaml/dune/pull/13510), [#13617](https://github.com/ocaml/dune/pull/13617)), with similar changes for Melange ([#13619](https://github.com/ocaml/dune/pull/13619)), `mdx` (default 0.5, [#13504](https://github.com/ocaml/dune/pull/13504)), and `ocamllex`/`ocamlyacc` ([#13098](https://github.com/ocaml/dune/pull/13098)). This affects nearly every project and may surface latent test flakiness or path assumptions on upgrade.
- **`dune runtest <file>` runs individual tests** ([#13064](https://github.com/ocaml/dune/pull/13064), fixes the 6-year-old #870) — `runtest` is no longer all-or-nothing for `(tests)` and `(library (inline_tests))`.
- **`DUNE_JOBS` env var; `INSIDE_DUNE` no longer controls concurrency** ([#12800](https://github.com/ocaml/dune/pull/12800)) — clean way to cap parallelism in CI/containers; minor breaking change for anyone relying on `INSIDE_DUNE` to control parallelism.
- **`$DUNE_CACHE_ROOT` layout migration** ([#11612](https://github.com/ocaml/dune/pull/11612), fixes #11584) — cache moves to `$DUNE_CACHE_ROOT/db`. Users with the variable set must manually move contents to avoid a full cache invalidation.
- **C stubs rebuild correctness fix** ([#13652](https://github.com/ocaml/dune/pull/13652), fixes #13651) — stale C stubs could cause segfaults; silent correctness bug worth flagging for anyone shipping bindings.
- Plus: Windows cache handling fix ([#13713](https://github.com/ocaml/dune/pull/13713)), the `dune-action-trace` library, OxCaml parameterised library support, and new tracing functionality.

**[Dune 3.22.1](https://ocaml.org/changelog/2026-04-06-dune3221) (Apr 6)** — fixes a `dune test` crash regression introduced in 3.22.0 in workspaces without a context named "default" ([#13930](https://github.com/ocaml/dune/pull/13930)).

**[Dune 3.22.2](https://ocaml.org/changelog/2026-04-14-dune3222) (Apr 14)** — reverts a 3.22.0 `--diff-command` regression: non-existent files are again passed to the diff command instead of being replaced with `/dev/null` ([#14098](https://github.com/ocaml/dune/pull/14098), fixes #13891). Affects `dune promote` / `dune runtest` diff display and any user-configured diff tool.

**Dune Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Sudha Parimala (@Sudha247, Tarides), Ambre Suhamy (@ElectreAAS, Tarides), Puneeth Chaganti (@punchagan, Tarides)

## Package Management

### opam

[opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-2-5-1) (April 16, 2026) is primarily a security release.

- **Security fix (OSEC-2026-03)**: invalidate `.install` fields containing destination filepaths that try to escape their scope ([#6897](https://github.com/ocaml/opam/pull/6897), reported by @andrew). Distribution maintainers are advised to upgrade or backport.
- Fix a string injection from the `depexts` field to `nix-build` when `os-family=nixos` ([#6894](https://github.com/ocaml/opam/pull/6894), thanks to @RyanGibb).
- Restore distribution detection on Gentoo, and add support for single-quoted values in `/etc/os-release` ([#6886](https://github.com/ocaml/opam/pull/6886), fixes [#6887](https://github.com/ocaml/opam/issues/6887)).
- Fix rare potential GC corruptions ([#6880](https://github.com/ocaml/opam/pull/6880), [#6882](https://github.com/ocaml/opam/pull/6882), thanks to @avsm).

**opam Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Jane Street)

### opam-publish

[opam-publish 3.0.0](https://ocaml.org/changelog/2026-02-20-opam-publish-300) (February 20, 2026) is a major release with breaking changes and quality-of-life improvements:

- **Breaking**: the deprecated `--split` option has been removed ([#194](https://github.com/ocaml-opam/opam-publish/pull/194)).
- **Breaking**: following the upgrade to cmdliner 2.0, option names can no longer be abbreviated to an unambiguous prefix — for example, `--dry` is no longer accepted as an alias of `--dry-run` ([#202](https://github.com/ocaml-opam/opam-publish/pull/202)).
- The `github-unix` dependency has been dropped ([#196](https://github.com/ocaml-opam/opam-publish/pull/196)).
- **Default branch auto-detection** ([#201](https://github.com/ocaml-opam/opam-publish/pull/201)) — opam-publish no longer hardcodes `master`; it queries upstream for the default branch. Important for release scripts and CI: silently fixes failures against opam-repository forks that have migrated to `main`.
- **Fork-name auto-detection** ([#199](https://github.com/ocaml-opam/opam-publish/pull/199)) — supports users whose fork of opam-repository isn't named `opam-repository`.
- Fix an infinite loop on repeated invalid token entry ([#186](https://github.com/ocaml-opam/opam-publish/pull/186)).

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)

### dune-release

[dune-release 2.2.1](https://ocaml.org/changelog/2026-03-26-dune-release-221) (March 26, 2026) adds a CLI flag to mark a GitHub release as a prerelease, exposing capability that already existed in the GitHub REST API to the `dune-release` command line ([#517](https://github.com/tarides/dune-release/pull/517)).

**Maintained by**: Tarides

## Editor Tools

*Roadmap: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code)*

### Merlin and OCaml-LSP

This is the cycle in which Merlin and OCaml-LSP graduate from "navigate and complete" to "navigate, complete, and refactor" — the April 10 dual release lands first-class refactor-extract, type-aware navigation, and range formatting, all available to any LSP client. Two OCaml 5.5 preview builds and a 5.4-series patch round out the period.

A coordinated [dual release of OCaml-LSP 1.26.0 and Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) shipped on April 10, 2026, together with two preview releases for the OCaml 5.5 series.

**[Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505preview) (Feb 27)** — preview release for the OCaml 5.5 series. Highlights:

- An `Other` variant in `locate-types` so editors can render types like `'a t -> 'a` with their type variables preserved ([#2025](https://github.com/ocaml/merlin/pull/2025)).
- The `option` wrapper is stripped from optional parameters in `locate-types` ([#2027](https://github.com/ocaml/merlin/pull/2027)).
- Fix for a record field autocompletion regression caused by incomplete cache fingerprinting ([#2028](https://github.com/ocaml/merlin/pull/2028)).
- Signature help no longer loops back to the first parameter once all arguments have been written ([#2023](https://github.com/ocaml/merlin/pull/2023)).

**[OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55preview) (Mar 19)** — preview release for the OCaml 5.5 series. Notable changes:

- A new `destruct` custom request ([#1583](https://github.com/ocaml/ocaml-lsp/pull/1583)), intended to let clients such as `ocaml-eglot` trigger the command directly rather than through a code action.
- Configurable Merlin via build systems other than dune, through the `OCAMLLSP_PROJECT_BUILD_SYSTEM` and `OCAMLLSP_PROJECT_ROOT` environment variables ([#1581](https://github.com/ocaml/ocaml-lsp/pull/1581)).
- Long signatures returned by `signature-help` are now formatted with `ocamlformat` for improved readability ([#1580](https://github.com/ocaml/ocaml-lsp/pull/1580)).

**[Merlin 5.7.0-504 + OCaml-LSP 1.26.0](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10)** — paired stable releases. New user-visible capabilities:

- **Refactor: extract region** — a new `refactor-extract-region` command in Merlin ([#1948](https://github.com/ocaml/merlin/pull/1948)) and a corresponding `ocamllsp/refactorExtract` custom request in OCaml-LSP ([#1545](https://github.com/ocaml/ocaml-lsp/pull/1545)) for extracting a region into a fresh let-binding (experimental).
- **Type-aware navigation**: a new `locate_types` custom request in OCaml-LSP ([#1584](https://github.com/ocaml/ocaml-lsp/pull/1584)), backed by Merlin's `Other` variant ([#2025](https://github.com/ocaml/merlin/pull/2025)) and option-stripping ([#2027](https://github.com/ocaml/merlin/pull/2027)), lets editors jump to definitions of types appearing inside a hovered type.
- **Range formatting**: OCaml-LSP now supports `textDocument/rangeFormatting` ([#1591](https://github.com/ocaml/ocaml-lsp/pull/1591)) — format-selection in any LSP client.
- Improvements to type-enclosing behaviour on class- and object-related items, plus a cluster of signature-help fixes: no looping after the last parameter ([#2023](https://github.com/ocaml/merlin/pull/2023)), labelled/optional-arg bug fixes ([#2032](https://github.com/ocaml/merlin/pull/2032)), and triggering before `in` is typed ([#2036](https://github.com/ocaml/merlin/pull/2036)).

**[Merlin 5.7.1-504](https://ocaml.org/changelog/2026-04-30-merlin-v571-504) (Apr 30)** — patch release for the OCaml 5.4 series:

- Fix for a typer cache invalidation bug ([#2062](https://github.com/ocaml/merlin/pull/2062)) where Merlin would not pick up newly created `.cmi` files appearing in the build path, for instance when Dune built a new module.
- Index format change ([#2051](https://github.com/ocaml/merlin/pull/2051)) — merged indexes can now point to existing index files, resulting in significantly smaller index files and fewer write operations.

**OCaml-LSP Server maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Muluh Godson (@PizieDust, Tarides)

## Code Quality and Documentation

### OCamlFormat

[OCamlFormat 0.29.0](https://ocaml.org/changelog/2026-03-17-ocamlformat-0290) (March 17, 2026) is a substantial release. Highlights:

- Support for OCaml 5.5 syntax ([#2772](https://github.com/ocaml-ppx/ocamlformat/pull/2772), [#2774](https://github.com/ocaml-ppx/ocamlformat/pull/2774), [#2775](https://github.com/ocaml-ppx/ocamlformat/pull/2775), [#2777](https://github.com/ocaml-ppx/ocamlformat/pull/2777), [#2780](https://github.com/ocaml-ppx/ocamlformat/pull/2780), [#2781](https://github.com/ocaml-ppx/ocamlformat/pull/2781), [#2782](https://github.com/ocaml-ppx/ocamlformat/pull/2782), [#2783](https://github.com/ocaml-ppx/ocamlformat/pull/2783)). The update brings several tiny formatting changes, listed in the changelog.
- The vendored Odoc parser is updated to 3.0 ([#2757](https://github.com/ocaml-ppx/ocamlformat/pull/2757)): the indentation of OCaml code-blocks is reduced by two to avoid changing the generated documentation, and indentation within code-blocks is now significant in Odoc.
- The default `ocaml-version` is now 5.4 ([#2750](https://github.com/ocaml-ppx/ocamlformat/pull/2750)), so the `effect` keyword is recognized without extra configuration. **Caveat**: codebases that use `effect` as an identifier must now opt back to `ocaml-version=5.2`, or builds will break.
- A new `letop-punning` option (`preserve` by default) controls whether bindings like `let+ x = x in ...` are punned to `let+ x in ...` ([#2746](https://github.com/ocaml-ppx/ocamlformat/pull/2746), [#2747](https://github.com/ocaml-ppx/ocamlformat/pull/2747)).

**Heads-up: expect formatting churn on first run.** Beyond the headlines, four `*`-marked items in the changelog change default formatting and will produce diffs when re-running `ocamlformat` over an existing codebase: `cases-matching-exp-indent=compact` no longer impacts `begin end` blocks without a match inside, `end`-keyword indentation in match-cases is now consistently at least 2, shortcut `begin end` is used in `match` cases and `if then else` bodies, plus several indentation tweaks under the OCaml 5.5 syntax work (`let module`, `let open`, etc.). Teams gating CI on `ocamlformat --check` should review the diffs carefully before merging.

### MDX

[MDX 2.5.2](https://ocaml.org/changelog/2026-03-23-mdx-252) (March 23, 2026) is a small compatibility release that adjusts MDX's toplevel support to work with OCaml 5.5, where the `Env_functor_arg` constructor in compiler-libs was renamed to `Env_not_aliasable` ([#475](https://github.com/realworldocaml/mdx/pull/475)).

### ppxlib

[ppxlib 0.38.0](https://ocaml.org/changelog/2026-03-20-ppxlib-0380) (March 20, 2026) adds OCaml 5.5 support ([#622](https://github.com/ocaml-ppx/ppxlib/pull/622)) and rounds out OCaml 5.4 PPX coverage with labeled tuples ([#607](https://github.com/ocaml-ppx/ppxlib/pull/607)) and bivariant type parameters ([#629](https://github.com/ocaml-ppx/ppxlib/pull/629)). **PPX maintainers**: a behavior change ([#613](https://github.com/ocaml-ppx/ppxlib/pull/613)) raises on duplicate attributes instead of looping silently, which could surface latent bugs in user code; new floating-attribute APIs ([#631](https://github.com/ocaml-ppx/ppxlib/pull/631)) and effect-pattern helpers ([#624](https://github.com/ocaml-ppx/ppxlib/pull/624)) are also worth a look.

### utop

[utop 2.17.0](https://ocaml.org/changelog/2026-03-26-utop-2170) (March 26, 2026) brings:

- Support for OCaml 5.5 ([#510](https://github.com/ocaml-community/utop/pull/510)).
- Decoupling of `utop.el` from `tuareg-mode` ([#511](https://github.com/ocaml-community/utop/pull/511)): `tuareg` is now loaded lazily, and other OCaml major modes for Emacs (such as [neocaml](https://github.com/bbatsov/neocaml)) can integrate with utop via the new `utop-mode-compat-alist`. Existing tuareg, caml, typerex, and reason users are unaffected.

---

As always, we encourage feedback and contributions from the community as we continue to improve the OCaml Platform ecosystem.
