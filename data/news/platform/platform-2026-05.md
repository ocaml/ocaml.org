---
title: "Platform Newsletter: February to May 2026"
description: "OCaml Platform Feb-May 2026: OCaml 5.5.0~beta1 with relocatable compiler and modular explicits, Dune 3.22 and 3.23 series with sandboxed tests, OCaml-LSP 1.26.0 + Merlin 5.7.0-504, OCamlFormat 0.29.0, Odoc 3.2.0, opam 2.5.1 security release, opam-publish 3.0.0, dune-release 2.2.1, ppxlib 0.38.0, utop 2.17.0, MDX 2.5.2"
date: "2026-06-10"
tags: [platform]
---

Welcome to the eighteenth edition of the OCaml Platform newsletter!

In this February to May 2026 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**The throughline this quarter is OCaml 5.5.** Its first alphas and a beta arrived between February and April, bringing a relocatable compiler and a notable batch of language features — and the rest of the Platform moved in lockstep to be ready for it. OCamlFormat, ppxlib, utop, MDX, Odoc, and the Merlin / OCaml-LSP previews all shipped 5.5-compatible releases this period, so that by the time the compiler lands, the tools are already there. The urgent exception to the "5.5 readiness" story is security: two advisories (OCaml 5.4.1 / 4.14.3 and opam 2.5.1) warrant attention regardless of which compiler you run.

**If you only read three things**: OCaml 5.5.0~beta1 with a relocatable compiler; the OCaml 5.4.1 / 4.14.3 security patches (Marshal hardening); the OCamlFormat 0.29.0 upgrade caveat (CI diff churn).

**Highlights:**

- **OCaml 5.5.0 reaches beta** (Apr 20): a relocatable compiler plus modular explicits, polymorphic function parameters, generalised local bindings, and garbage-collector improvements; final release expected soon.
- **Security**: OCaml 5.4.1 / 4.14.3 (Feb 17) harden Marshal against malicious input (OSEC-2026-01) and opam 2.5.1 (Apr 16) blocks `.install` path escapes (OSEC-2026-03) — review your code and upgrade if you deserialise untrusted data, or upgrade if you maintain a distribution. These are the most prominent of several advisories published this period; [check the published security issues](https://osv.dev/list?q=&ecosystem=opam) and upgrade if you use an affected package, and you can [subscribe to security announcements](https://ocaml.org/security#mailing-list-for-security-announcements).
- **Dune 3.22–3.23**: sandboxing is now on by default for tests, user rules, and inline runners (watch for latent flakiness); 3.22 adds build tracing and OxCaml parameterised-library support; 3.23 stops auto-promoting generated opam files (run `dune promote`).
- **Editor tools** (Apr 10): OCaml-LSP 1.26.0 + Merlin 5.7.0-504 add a code-extraction refactoring, type-aware navigation, and range formatting.
- **OCamlFormat 0.29.0** (Mar 17): OCaml 5.5 syntax and a new default `ocaml-version=5.4`.
- **opam-publish 3.0.0** (Feb 20): a breaking cmdliner 2.0 upgrade (no more prefix-matching), plus default-branch and fork-name auto-detection.
- **Other releases**: Odoc 3.2.0 / 3.2.1, ppxlib 0.38.0, utop 2.17.0, and MDX 2.5.2 all shipped OCaml 5.5 support; dune-release 2.2.1 adds a `--prerelease` flag.

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
- [OCaml-LSP 1.26.0](https://ocaml.org/changelog/2026-04-10-ocaml-lsp-1260) & [Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10, 2026)
- [Dune 3.22.2](https://ocaml.org/changelog/2026-04-14-dune3222) (Apr 14, 2026)
- [opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-2-5-1) (Apr 16, 2026)
- [Merlin 5.7.1-504](https://ocaml.org/changelog/2026-04-30-merlin-v571-504) (Apr 30, 2026)
- [Odoc 3.2.0](https://ocaml.org/changelog/2026-05-01-odoc-320) (May 1, 2026)
- [Dune 3.23.0](https://ocaml.org/changelog/2026-05-05-dune3230) (May 5, 2026)
- [Odoc 3.2.1](https://ocaml.org/changelog/2026-05-12-odoc-321) (May 12, 2026)
- [Dune 3.23.1](https://ocaml.org/changelog/2026-05-19-dune3231) (May 19, 2026)

**Unstable Releases:**

- [OCaml 5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27, 2026)
- [Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505preview) (Feb 27, 2026)
- [OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55preview) (Mar 19, 2026)
- [OCaml 5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26, 2026)
- [OCaml 5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20, 2026)

(OCaml 5.5.0~alpha2 was tagged but never officially released, due to an interaction between the relocatable compiler and bootstrapping.)

## OCaml Compiler

### Maintenance Releases: 5.4.1 and 4.14.3

[OCaml 5.4.1 and 4.14.3](https://ocaml.org/changelog/2026-02-17-ocaml-541-and-4143) (February 17, 2026) are maintenance releases of the 5.4 and 4.14 stable branches. The headline is [OSEC-2026-01](https://osv.dev/vulnerability/OSEC-2026-01): the `intern.c` Marshal implementation has been hardened against malicious inputs — anyone deserialising untrusted data should review their code and upgrade. The releases also ship several correctness fixes, including a long-standing miscompilation of unsafe int32/int64/nativeint array accesses present since 4.04, a `Lazy.force` race fix, a demarshal-exception memory-corruption fix, and TSan-related fixes for OCaml 5 users. See the release notes for the full list.

### OCaml 5.5.0 Progresses to Beta

The OCaml 5.5.0 release cycle moved through three alphas and into a first beta during this period. **5.5.0 ships a particularly notable batch of language extensions**, and is the first to ship a relocatable compiler.

**Headline features in 5.5.0:**

- **Relocatable compiler** (deployment-side): the compiler and its associated tools can be moved/copied between directories after installation without breaking functionality. Significant for opam, Docker, sandboxed installs, and binary distribution. (See [the relocatable-OCaml announcement](https://discuss.ocaml.org/t/relocatable-ocaml/17253) referenced in the previous newsletter.)
- **Modular explicits** (language): function arguments can now carry a module signature dependency (`(module M : S) -> t[M]`), enabling module-dependent function arguments without full functor syntax.
- **Polymorphic function parameters** (language): functions can now take arguments with explicit polymorphic types (e.g. `(getter : 'a. 'a t -> 'a)`), enabling clean ST-monad-style and rank-2 patterns previously requiring records.
- **Generalised local bindings** (language): `let module`, `let exception`, `let open`, and `let type` are now supported in expressions in more contexts.
- **Garbage-collector improvements** (runtime): a batch of work from an ongoing GC-pacing overhaul has landed in 5.5.0 — improving how the major collector accounts for and schedules its work — with the broader effort tracked in [#14324](https://github.com/ocaml/ocaml/issues/14324) and continuing toward 5.6.
- **Standard library expansions**: notably `String.split_*`, `String.replace_*`, `String.includes`, `Option.product`, `List.split_map`, `Lazy.Mutexed`.

**Feature spotlight: modular explicits.** Modular explicits are the most significant of the new language features. A function can now take a module as an explicit argument and let its later parameter and return types depend on it. Before 5.5 you could already express this, but you had to take the module as a first-class-module argument and thread its element type through a locally abstract type by hand. Here is how the list-sorting example — sort using whichever `Set` implementation is passed in — looked on 4.14:

```ocaml
let sort (type a) (module MSet : Set.S with type elt = a) li =
  MSet.elements (List.fold_right MSet.add li MSet.empty)
(* val sort : (module Set.S with type elt = 'a) -> 'a list -> 'a list *)
```

Note the explicit `(type a)` and `with type elt = a`, binding the module's element type so the return type can refer to it. It is manageable here, but becomes tedious once several type parameters need binding. With modular explicits in 5.5, that boilerplate disappears:

```ocaml
let sort (module MSet : Set.S) li =
  MSet.elements (List.fold_right MSet.add li MSet.empty)
(* val sort : (module MSet : Set.S) -> MSet.elt list -> MSet.elt list *)

module IntSet = Set.Make (Int)
let sorted = sort (module IntSet) [3; 1; 2]   (* [1; 2; 3] *)
```

The `MSet.elt` in the inferred type refers back to the module argument, so the return type depends on the module passed in. Application is more restricted than for ordinary first-class-module functions — the argument must be a literal module expression like `(module IntSet)`, not a value computed at runtime — which is what keeps the typing sound. The manual documents the feature ([#14048](https://github.com/ocaml/ocaml/pull/14048)). The related polymorphic function parameters feature (`let f (g : 'a. 'a t -> 'a) = ...`) lands in the same release.

**Release timeline:**

- [5.5.0~alpha1](https://ocaml.org/backstage/2026-02-27-ocaml-550-alpha1) (Feb 27) — first alpha, opening the bug-hunting window.
- 5.5.0~alpha2 — tagged but unreleased: an unforeseen interaction between the relocatable compiler and bootstrapping was discovered before the release was finalised.
- [5.5.0~alpha3](https://ocaml.org/backstage/2026-03-26-ocaml-550-alpha3) (Mar 26) — fixes the bootstrap issue, alongside a type-soundness restoration, a register-allocator miscompilation fix, and an s390x heap-corruption fix.
- [5.5.0~beta1](https://ocaml.org/backstage/2026-04-20-ocaml-550-beta1) (Apr 20) — most developer tools are now available (at least in preview form). Compared to the last alpha, beta1 fixes two runtime bugs (ephemerons; the bytecode interpreter), two type-system bugs (classes; module-dependent functions), and three warning/error-message bugs. The release announcement explicitly invites users to test their libraries and programs against 5.5.0 in preparation for the final release, expected soon.

The [release readiness meta-issue](https://github.com/ocaml/opam-repository/issues/29463) tracks ongoing work on the surrounding ecosystem.

## Build System

### Dune

Six Dune releases shipped during this period: a 3.21 patch, the 3.22.x series, and the 3.23.x series.

**[Dune 3.21.1](https://ocaml.org/changelog/2026-02-11-dune-3211) (Feb 11)** — a small patch: a Melange `-p <PKG>` package-mask fix (relevant to scoped release/CI builds), and `dune promote` no longer starts the RPC server.

**[Dune 3.22.0](https://ocaml.org/changelog/2026-03-19-dune3220) (Mar 19)** — a bigger release. Highlights:

- **Build tracing**: new functionality to inspect and diagnose the build process, plus a public `dune-action-trace` library so custom actions can emit trace events and a `dune trace cat` subcommand to read the output.
- **odoc documentation in Markdown**: a new `@doc-markdown` build alias generates odoc output as Markdown.
- **OxCaml parameterised libraries**: full support for OxCaml's parameterised libraries.
- **Tests sandboxed by default**: `(test)` and `(tests)` stanzas — along with Melange rules, `mdx`, and `ocamllex`/`ocamlyacc` — are now sandboxed by default. This affects nearly every project and may surface latent test flakiness or path assumptions on upgrade.
- **`dune runtest <file>` runs individual tests** ([#13064](https://github.com/ocaml/dune/pull/13064)), closing a request open since 2018: `runtest` is no longer all-or-nothing for `(tests)` and inline tests.

**[Dune 3.22.1](https://ocaml.org/changelog/2026-04-06-dune3221) (Apr 6)** and **[3.22.2](https://ocaml.org/changelog/2026-04-14-dune3222) (Apr 14)** are regression fixes: a `dune test` crash in workspaces without a context named "default", and a `--diff-command` change that again passes non-existent files to the diff command rather than `/dev/null`.

**[Dune 3.23.0](https://ocaml.org/changelog/2026-05-05-dune3230) (May 5)** — a feature release. Highlights:

- **Generated opam files are no longer auto-promoted** ([#14108](https://github.com/ocaml/dune/pull/14108)) — a breaking change: Dune no longer writes generated `.opam` files back into the source tree on build; you now update them explicitly with `dune promote`. Worth flagging for release scripts and any CI that checks committed opam files are in sync.
- **`c_library_flags` in `foreign_stubs`** ([#13484](https://github.com/ocaml/dune/pull/13484)): `foreign_stubs` now accepts `c_library_flags`, for finer control over how C stubs are linked.
- **Sandboxing extended**: user rules and inline test runners are now sandboxed by default, continuing the sandboxing-by-default work begun in 3.22.
- **Promotion and diffing improvements**: numerous refinements, including sandboxed diff promotions and directory-level diffing.
- **Minimum OCaml to build Dune is now 4.14**: this concerns only building Dune itself from source on older compilers, not projects that use Dune.

**[Dune 3.23.1](https://ocaml.org/changelog/2026-05-19-dune3231) (May 19)** — a patch release that narrows two of 3.23.0's opam-file-generation changes (a `menhir` lower bound is now added only to a dependency the user already declared, and version-bound de-duplication is gated on `(lang dune 3.23)`), restores the secondary-compiler fallback for packages capped below OCaml 4.14, and fixes the NetBSD bootstrap.

**Dune Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Sudha Parimala (@Sudha247, Tarides), Ambre Suhamy (@ElectreAAS, Tarides), Puneeth Chaganti (@punchagan, Tarides)

## Package Management

### opam

[opam 2.5.1](https://ocaml.org/changelog/2026-04-16-opam-2-5-1) (April 16, 2026) is primarily a security release.

- **Security fix ([OSEC-2026-03](https://osv.dev/vulnerability/OSEC-2026-03))**: `.install` fields containing destination paths that try to escape their scope are now rejected (reported by @andrew). Distribution maintainers are advised to upgrade or backport.
- A `depexts`-to-`nix-build` string-injection fix on `os-family=nixos` (thanks to @RyanGibb).
- Restored distribution detection on Gentoo, with support for single-quoted values in `/etc/os-release`.
- A fix for rare potential GC corruptions (thanks to @avsm).

**opam Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Jane Street)

### opam-publish

[opam-publish 3.0.0](https://ocaml.org/changelog/2026-02-20-opam-publish-300) (February 20, 2026) is a major release with breaking changes and quality-of-life improvements:

- **Breaking**: the deprecated `--split` option has been removed, and — following the upgrade to cmdliner 2.0 — option names can no longer be abbreviated to an unambiguous prefix (for example, `--dry` is no longer accepted for `--dry-run`). The `github-unix` dependency has also been dropped.
- **Default-branch auto-detection**: opam-publish no longer hardcodes `master`; it queries upstream for the default branch. This silently fixes failures against opam-repository forks that have migrated to `main` — relevant to release scripts and CI.
- **Fork-name auto-detection**: supports users whose fork of opam-repository isn't named `opam-repository`.

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)

### dune-release

[dune-release 2.2.1](https://ocaml.org/changelog/2026-03-26-dune-release-221) (March 26, 2026) adds a CLI flag to mark a GitHub release as a prerelease, exposing a GitHub REST API capability on the `dune-release` command line.

**Maintained by**: Tarides

## Editor Tools

*Roadmap: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code)*

### Merlin and OCaml-LSP

The headline this cycle is a new code-extraction refactoring for Merlin and OCaml-LSP, joined by type-aware navigation and range formatting. A coordinated dual release of [OCaml-LSP 1.26.0](https://ocaml.org/changelog/2026-04-10-ocaml-lsp-1260) and [Merlin 5.7.0-504](https://ocaml.org/changelog/2026-04-10-merlin-570-504) was announced on April 10, 2026, preceded by two OCaml 5.5 preview builds and followed by a 5.4-series patch.

**Two OCaml 5.5 preview builds** came first: [Merlin 5.7-505~preview](https://ocaml.org/backstage/2026-02-27-merlin-v57-505preview) (Feb 27) and [OCaml-LSP 1.26.0-5.5~preview](https://ocaml.org/backstage/2026-03-19-ocaml-lsp-1260-55preview) (Mar 19). Between them they carry the `locate-types` groundwork for type-aware navigation, a new `destruct` custom request, configuration of Merlin via build systems other than dune (through the `OCAMLLSP_PROJECT_BUILD_SYSTEM` and `OCAMLLSP_PROJECT_ROOT` environment variables), `ocamlformat`-formatted signature help, and several signature-help and autocompletion fixes.

**[Merlin 5.7.0-504 + OCaml-LSP 1.26.0](https://ocaml.org/changelog/2026-04-10-merlin-570-504) (Apr 10)** — the paired stable release, with three new user-visible capabilities available to any LSP client:

- **Refactor: extract region** — a new [`refactor-extract-region`](https://github.com/ocaml/merlin/pull/1948) command (with a matching `ocamllsp/refactorExtract` request) extracts a selected region into a fresh let-binding (experimental) — a new region-extraction refactoring alongside the existing rename, type-annotation, and destruct support.
- **Type-aware navigation** — a new `locate_types` request lets editors jump to the definitions of types appearing inside a hovered type.
- **Range formatting** — OCaml-LSP now supports `textDocument/rangeFormatting`, i.e. format-selection.

The release also improves type-enclosing on class- and object-related items and fixes a cluster of signature-help bugs. The Backstage post [Improved Signature Help in Merlin](https://ocaml.org/backstage/2026-04-15-improved-signature-help-in-merlin) walks through the signature-help changes from a user's perspective.

**[Merlin 5.7.1-504](https://ocaml.org/changelog/2026-04-30-merlin-v571-504) (Apr 30)** — a 5.4-series patch that fixes a typer cache-invalidation bug (Merlin now picks up newly created `.cmi` files, for instance when Dune builds a new module) and shrinks on-disk index files.

**OCaml-LSP Server maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Muluh Godson (@PizieDust, Tarides)

## Code Quality and Documentation

### OCamlFormat

[OCamlFormat 0.29.0](https://ocaml.org/changelog/2026-03-17-ocamlformat-0290) (March 17, 2026) is a substantial release. Highlights:

- Support for OCaml 5.5 syntax.
- The vendored Odoc parser is updated to 3.0: the indentation of OCaml code-blocks is reduced by two (to avoid changing generated documentation), and indentation within code-blocks is now significant in Odoc.
- The default `ocaml-version` is now 5.4, so the `effect` keyword is recognised without extra configuration. **Caveat**: codebases that use `effect` as an identifier must now set `ocaml-version=5.2`.
- A new `letop-punning` option (`preserve` by default) controls whether bindings like `let+ x = x in ...` are punned to `let+ x in ...`.

**Tip:** Ignore formatting commits in `git blame`:

Put all the formatting changes in a single dedicated commit and add the full commit hash into a file named `.git-blame-ignore-revs`.

Then, use it like this: `git blame --ignore-revs-file=.git-blame-ignore-revs ..` or add it to the local configuration: `git config blame.ignoreRevsFile .git-blame-ignore-revs`. GitHub does this automatically in its web UI.

If you do this in a GitHub Pull Request, make sure not to use "Squash and merge" or "Rebase and merge" as these will change the commit hash in the main branch. See the [documentation](https://docs.github.com/en/repositories/working-with-files/using-files/viewing-and-understanding-files#ignore-commits-in-the-blame-view) from GitHub.

### Odoc

[Odoc 3.2.0](https://ocaml.org/changelog/2026-05-01-odoc-320) (May 1, 2026) adds OCaml 5.5.0 and OxCaml support. It also brings persistent LaTeX macros in the HTML/KaTeX backend — a macro defined with `\gdef` in one math block can be reused in later ones — and lets `markdown-generate` accept multiple `.odocl` files in a single invocation.

[Odoc 3.2.1](https://ocaml.org/changelog/2026-05-12-odoc-321) (May 12, 2026) is a patch release fixing documentation-build regressions under OCaml 5.5.0 — including broken docs for packages depending on `base` and `merlin-lib` — plus a regression introduced in 3.2.0.

### MDX

[MDX 2.5.2](https://ocaml.org/changelog/2026-03-23-mdx-252) (March 23, 2026) is a small compatibility release that adjusts MDX's toplevel support to work with OCaml 5.5, where the `Env_functor_arg` constructor in compiler-libs was renamed to `Env_not_aliasable`.

### ppxlib

[ppxlib 0.38.0](https://ocaml.org/changelog/2026-03-20-ppxlib-0380) (March 20, 2026) adds OCaml 5.5 support — and changes the approach to getting there. It is the first ppxlib release to use the team's [new strategy for supporting future compilers](https://discuss.ocaml.org/t/ann-ppxlib-support-for-future-compilers/17430): instead of bumping ppxlib's internal AST (the change behind the ecosystem breakage around the 5.2 bump and ppxlib 0.36.0), support for every compiler `>= 5.3` now encodes new language constructs into the existing AST. The payoff is that adding a new compiler no longer forces a breaking ppxlib release across the PPX ecosystem. New `Ast_builder` and `Ast_pattern` helpers let PPX authors produce and match the encoded constructs — labeled tuples, bivariant type parameters, and effect patterns — documented in a [new compatibility manual section](https://ocaml-ppx.github.io/ppxlib/ppxlib/compatibility.html#future_compilers). One behaviour change to note: duplicate attributes now raise instead of looping silently, which may surface latent bugs in existing PPXs.

### utop

[utop 2.17.0](https://ocaml.org/changelog/2026-03-26-utop-2170) (March 26, 2026) brings:

- Support for OCaml 5.5.
- Decoupling of `utop.el` from `tuareg-mode`: `tuareg` is now loaded lazily, and other OCaml major modes for Emacs (such as [neocaml](https://github.com/bbatsov/neocaml)) can integrate with utop via the new `utop-mode-compat-alist`. Existing tuareg, caml, typerex, and reason users are unaffected.

## WebAssembly

A new [Backstage OCaml](https://ocaml.org/backstage) post, [Wasm_of_ocaml: What Changed Since 6.1](https://ocaml.org/backstage/2026-04-16-wasm-of-ocaml-what-changed-since-6-1) (Apr 16), surveys the WebAssembly backend across js_of_ocaml 6.1–6.3. `wasm_of_ocaml` compiles OCaml bytecode to WebAssembly, targeting [WasmGC](https://github.com/WebAssembly/gc) so that OCaml values are managed by the host garbage collector. Highlights since 6.1:

- The compiler now writes `.wasm` binary modules directly, instead of emitting WAT and converting it via Binaryen (still a required system dependency); WAT output remains available for debugging.
- Improved Wasm code generation across 6.1–6.3.
- Three larger features tracked since the post: dynlink/toplevel support and native effects (via stack switching) have since landed, with WASI support still in progress.

---

As always, we encourage feedback and contributions from the community as we continue to improve the OCaml Platform ecosystem.
