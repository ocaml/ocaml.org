---
title: "Platform Newsletter: February to April 2026"
description: "OCaml Platform Feb-Apr 2026: OCaml 5.5.0~beta1, Dune 3.22 series, OCaml-LSP 1.26.0 + Merlin 5.7.0-504, OCamlFormat 0.29.0, opam 2.5.1, opam-publish 3.0.0, dune-release 2.2.1, ppxlib 0.38.0, utop 2.17.0, MDX 2.5.2"
date: "2026-05-07"
tags: [platform]
---

Welcome to the eighteenth edition of the OCaml Platform newsletter!

In this February to April 2026 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**Highlights:**

- **OCaml 5.5.0 reaches beta**: After three alpha releases — the second alpha was unreleased due to a bootstrapping issue with the relocatable compiler — OCaml 5.5.0~beta1 lands on April 20, 2026, with most associated tools available in preview form.
- **OCaml 5.4.1 and 4.14.3**: Maintenance releases of the stable branches on February 17.
- **Dune 3.22 series**: 3.22.0 brings Windows cache fixes, OxCaml parameterised library support, and new tracing functionality, followed by 3.22.1 and 3.22.2 as patch releases.
- **Editor tools sync up for OCaml 5.5**: A dual release of OCaml-LSP 1.26.0 and Merlin 5.7.0-504 in April, plus 5.5-targeted preview releases (`merlin v5.7-505~preview`, `ocaml-lsp 1.26.0-5.5~preview`) and a Merlin 5.7.1-504 patch.
- **OCamlFormat 0.29.0**: OCaml 5.5 syntax support, the vendored Odoc parser updated to 3.0, a new `letop-punning` option, and the default `ocaml-version` raised to 5.4.
- **opam 2.5.1**: Security fix (OSEC-2026-03) for `.install` field destinations escaping their scope, plus several other bug fixes.
- **opam-publish 3.0.0**: Major release with breaking changes — cmdliner 2.0 prefix-matching is gone, the deprecated `--split` option has been removed, and the `github-unix` dependency has been dropped.
- **dune-release 2.2.1**: Adds a CLI flag to mark a GitHub release as a prerelease.
- **ppxlib 0.38.0**: OCaml 5.5 support.
- **utop 2.17.0**: OCaml 5.5 support and `utop.el` decoupled from `tuareg-mode` so other Emacs major modes (e.g. `neocaml`) can integrate via a new compatibility alist.
- **MDX 2.5.2**: Toplevel-support compatibility fix for OCaml 5.5.

**Stable Releases:**

- [Dune 3.21.1](https://ocaml.org/changelog/2026-02-11-dune-3211) (Feb 11, 2026)
- [OCaml 5.4.1 and 4.14.3](https://ocaml.org/changelog/2026-02-17-ocaml-541-and-4143) (Feb 17, 2026)
- [opam-publish 3.0.0](https://ocaml.org/changelog/2026-02-20-opam-publish-300) (Feb 20, 2026)
- [OCamlFormat 0.29.0](https://ocaml.org/changelog/2026-03-17-ocamlformat-0290) (Mar 17, 2026)
- [Dune 3.22.0](https://ocaml.org/changelog/2026-03-19-dune-3220) (Mar 19, 2026)
- [ppxlib 0.38.0](https://ocaml.org/changelog/2026-03-20-ppxlib-0380) (Mar 20, 2026)
- [MDX 2.5.2](https://ocaml.org/changelog/2026-03-23-mdx-252) (Mar 23, 2026)
- [dune-release 2.2.1](https://ocaml.org/changelog/2026-03-26-dune-release-221) (Mar 26, 2026)
- [utop 2.17.0](https://ocaml.org/changelog/2026-03-26-utop-2170) (Mar 26, 2026)
- [Dune 3.22.1](https://ocaml.org/changelog/2026-04-06-dune-3221) (Apr 6, 2026)
- [OCaml-LSP 1.26.0 & Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10, 2026)
- [Dune 3.22.2](https://ocaml.org/changelog/2026-04-14-dune-3222) (Apr 14, 2026)
- [opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-251) (Apr 16, 2026)
- [Merlin 5.7.1-504](https://ocaml.org/changelog/2026-04-30-merlin-v571-504) (Apr 30, 2026)

**Unstable Releases:**

- [OCaml 5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27, 2026)
- [Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505-preview) (Feb 27, 2026)
- [OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55-preview) (Mar 19, 2026)
- [OCaml 5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26, 2026)
- [OCaml 5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20, 2026)

(OCaml 5.5.0~alpha2 was tagged but never officially released, due to an interaction between the relocatable compiler and bootstrapping.)

## OCaml Compiler

### Maintenance Releases: 5.4.1 and 4.14.3

[OCaml 5.4.1 and 4.14.3](https://ocaml.org/changelog/2026-02-17-ocaml-541-and-4143) (February 17, 2026) are maintenance releases of the 5.4 and 4.14 stable branches, bringing security and reliability fixes from upstream backports.

### OCaml 5.5.0 Progresses to Beta

The OCaml 5.5.0 release cycle moved through three alphas and into a first beta during this period:

- [5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27) — first alpha, opening the bug-hunting window for the new release.
- 5.5.0~alpha2 — tagged but unreleased: an unforeseen interaction between the relocatable compiler and bootstrapping was discovered before the release was finalised.
- [5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26) — fixes the bootstrap issue, plus two code-generation fixes, three type-system fixes, and a standard-library fix compared to alpha1.
- [5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20) — most developer tools are now available (at least in preview form). Compared to the last alpha, beta1 fixes two runtime bugs (ephemerons; the bytecode interpreter), two type-system bugs (classes; module-dependent functions), and three warning/error-message bugs.

The [release readiness meta-issue](https://github.com/ocaml/opam-repository/issues/29463) tracks ongoing work on the surrounding ecosystem.

## Build System

### Dune

Four Dune releases shipped during this period: a 3.21 patch and the 3.22.x series.

- [Dune 3.21.1](https://ocaml.org/changelog/2026-02-11-dune-3211) (Feb 11) — patch on the 3.21 line.
- [Dune 3.22.0](https://ocaml.org/changelog/2026-03-19-dune-3220) (Mar 19) — main release of the cycle. Highlights include fixes to the dune cache on Windows, new tracing functionality, the `dune-action-trace` library, markdown documentation generation, and OxCaml parameterised library support.
- [Dune 3.22.1](https://ocaml.org/changelog/2026-04-06-dune-3221) (Apr 6) and [Dune 3.22.2](https://ocaml.org/changelog/2026-04-14-dune-3222) (Apr 14) — patch follow-ups to 3.22.0.

For the full list of changes, see the [3.22.0 release notes on GitHub](https://github.com/ocaml/dune/releases/tag/3.22.0).

**Dune Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Sudha Parimala (@Sudha247, Tarides), Ambre Suhamy (@ElectreAAS, Tarides), Puneeth Chaganti (@punchagan, Tarides)

## Package Management

### opam

[opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-251) (April 16, 2026) is primarily a security release.

- **Security fix (OSEC-2026-03)**: invalidate `.install` fields containing destination filepaths that try to escape their scope ([#6897](https://github.com/ocaml/opam/pull/6897), reported by @andrew). Distribution maintainers are advised to upgrade or backport.
- Fix a string injection from the `depexts` field to `nix-build` when `os-family=nixos` ([#6894](https://github.com/ocaml/opam/pull/6894), thanks to @RyanGibb).
- Restore distribution detection on Gentoo, and add support for single-quoted values in `/etc/os-release` ([#6887](https://github.com/ocaml/opam/issues/6887)).
- Fix rare potential GC corruptions ([#6882](https://github.com/ocaml/opam/pull/6882), thanks to @avsm).

**opam Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Tarides)

### opam-publish

[opam-publish 3.0.0](https://ocaml.org/changelog/2026-02-20-opam-publish-300) (February 20, 2026) is a major release with several breaking changes:

- **Breaking**: the deprecated `--split` option has been removed ([#194](https://github.com/ocaml-opam/opam-publish/pull/194)).
- **Breaking**: following the upgrade to cmdliner 2.0, option names can no longer be abbreviated to an unambiguous prefix — for example, `--dry` is no longer accepted as an alias of `--dry-run` ([#202](https://github.com/ocaml-opam/opam-publish/pull/202)).
- The `github-unix` dependency has been dropped ([#196](https://github.com/ocaml-opam/opam-publish/pull/196)).

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)

### dune-release

[dune-release 2.2.1](https://ocaml.org/changelog/2026-03-26-dune-release-221) (March 26, 2026) adds a CLI flag to mark a GitHub release as a prerelease, exposing capability that already existed in the GitHub REST API to the `dune-release` command line ([#517](https://github.com/tarides/dune-release/pull/517)).

**Maintained by**: Tarides

## Editor Tools

*Roadmap: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code)*

### Merlin and OCaml-LSP

A coordinated [dual release of OCaml-LSP 1.26.0 and Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) shipped on April 10, 2026, together with two preview releases for the OCaml 5.5 series.

**[Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505-preview) (Feb 27)** — preview release for the OCaml 5.5 series. Highlights:

- An `Other` variant in `locate-types` so editors can render types like `'a t -> 'a` with their type variables preserved ([#2025](https://github.com/ocaml/merlin/pull/2025)).
- The `option` wrapper is stripped from optional parameters in `locate-types` ([#2027](https://github.com/ocaml/merlin/pull/2027)).
- Fix for a record field autocompletion regression caused by incomplete cache fingerprinting ([#2028](https://github.com/ocaml/merlin/pull/2028)).
- Signature help no longer loops back to the first parameter once all arguments have been written ([#2023](https://github.com/ocaml/merlin/pull/2023)).

**[OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55-preview) (Mar 19)** — preview release for the OCaml 5.5 series. Notable changes:

- A new `destruct` custom request ([#1583](https://github.com/ocaml/ocaml-lsp/pull/1583)), intended to let clients such as `ocaml-eglot` trigger the command directly rather than through a code action.
- Configurable Merlin via build systems other than dune, through the `OCAMLLSP_PROJECT_BUILD_SYSTEM` and `OCAMLLSP_PROJECT_ROOT` environment variables ([#1581](https://github.com/ocaml/ocaml-lsp/pull/1581)).
- Long signatures returned by `signature-help` are now formatted with `ocamlformat` for improved readability ([#1580](https://github.com/ocaml/ocaml-lsp/pull/1580)).

**[Merlin 5.7.0-504 + OCaml-LSP 1.26.0](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10)** — paired stable releases bringing improvements to type-enclosing behaviour on class- and object-related items, signature-help improvements, and several bug fixes.

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
- The default `ocaml-version` is now 5.4 ([#2750](https://github.com/ocaml-ppx/ocamlformat/pull/2750)), so the `effect` keyword is recognized without extra configuration (code that uses `effect` as an identifier must set `ocaml-version=5.2`).
- A new `letop-punning` option (`preserve` by default) controls whether bindings like `let+ x = x in ...` are punned to `let+ x in ...` ([#2746](https://github.com/ocaml-ppx/ocamlformat/pull/2746), [#2747](https://github.com/ocaml-ppx/ocamlformat/pull/2747)).

### MDX

[MDX 2.5.2](https://ocaml.org/changelog/2026-03-23-mdx-252) (March 23, 2026) is a small compatibility release that adjusts MDX's toplevel support to work with OCaml 5.5, where the `Env_functor_arg` constructor in compiler-libs was renamed to `Env_not_aliasable` ([#475](https://github.com/realworldocaml/mdx/pull/475)).

### ppxlib

[ppxlib 0.38.0](https://ocaml.org/changelog/2026-03-20-ppxlib-0380) (March 20, 2026) adds OCaml 5.5 support ([#622](https://github.com/ocaml-ppx/ppxlib/pull/622)).

### utop

[utop 2.17.0](https://ocaml.org/changelog/2026-03-26-utop-2170) (March 26, 2026) brings:

- Support for OCaml 5.5 ([#510](https://github.com/ocaml-community/utop/pull/510)).
- Decoupling of `utop.el` from `tuareg-mode` ([#511](https://github.com/ocaml-community/utop/pull/511)): `tuareg` is now loaded lazily, and other OCaml major modes for Emacs (such as [neocaml](https://github.com/bbatsov/neocaml)) can integrate with utop via the new `utop-mode-compat-alist`. Existing tuareg, caml, typerex, and reason users are unaffected.

---

As always, we encourage feedback and contributions from the community as we continue to improve the OCaml Platform ecosystem.
