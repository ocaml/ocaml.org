---
title: "Platform Newsletter: September 2024 - January 2025"
description: Update from the OCaml Platform.
date: "2025-03-04"
tags: [platform]
---

Welcome to the thirteenth edition of the OCaml Platform newsletter!

In this September 2024 - January 2025 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
* **Dune Enables Cache By Default, Adds WebAssembly Support**
The latest Dune releases mark significant progress in build performance and language support. Version 3.17.0 enables the Dune cache by default for known-safe operations, improving build times for common tasks. The addition of Wasm_of_ocaml support opens new possibilities for OCaml projects targeting the web or other WebAssembly runtimes. In addition, Dune now supports adding Codeberg and GitLab repositories via the `(source)` stanza.
* **opam 2.3.0**
As announced with opam 2.2, opam releases are now time-based with a cadence of 6 months. Opam 2.3 has been released last November. It contains a major breaking change regarding extra-files handling: extra-files are now ignored when they are not present in the opam file. Previously they were silently added. This release adds also some new commands like `opam list --latest-only` or `opam install foo --verbose-on bar`, among other fixes and enhancements.
* **Improved Editor Workflows with OCaml-LSP and Merlin**
A major milestone for project-wide features has been reached with the release of OCaml 5.3: LSP's renaming feature now [_renames symbols in the entire project_](https://discuss.ocaml.org/t/ann-merlin-and-ocaml-lsp-support-experimental-project-wide-renaming/16008) if the index is built. Additionally,all of the classic merlin-server commands are now available as LSP custom requests: this enabled the addition of [many new features to the Visual Studio Code plugin](https://tarides.com/blog/2025-02-28-full-blown-productivity-in-vscode-with-ocaml/). Finally a brand new Emacs mode, based on LSP and the new custom queries is [now available on Melpa](https://melpa.org/#/ocaml-eglot).
* **Performance and Security Enhancements**
Recent updates across the platform focus on performance and reliability. Dune optimized its handling of .cmxs files, while opam implemented stricter git submodule error checking. OCaml-LSP resolved file descriptor leaks, contributing to a more stable development environment.

**Feature Guides & Announcements:**

* [[ANN] Odoc 3 Beta Release](https://discuss.ocaml.org/t/ann-odoc-3-beta-release/16043)
* [[ANN] Merlin and OCaml-LSP support experimental project-wide renaming](https://discuss.ocaml.org/t/ann-merlin-and-ocaml-lsp-support-experimental-project-wide-renaming/16008)
* [[ANN] Release of ocaml-eglot 1.0.0](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-0-0/15978)
* [[ANN] ppxlib.034.0](https://discuss.ocaml.org/t/ann-ppxlib-034-0/15952)
* [Installing Developer Tools with Dune](https://ocaml.org/changelog/2024-11-15-installing-developer-tools-with-dune)
* [Shell Completions in Dune Developer Preview](https://ocaml.org/changelog/2024-10-29-shell-completions-in-dune-developer-preview)
* [OCaml Infrastructure: Enhancing Platform Support and User Experience](https://ocaml.org/changelog/2024-10-02-updates)
* [Call for Feedback](https://ocaml.org/changelog/2024-09-25-call-for-feedback)

**Releases:**

* [Dune 3.17.2](https://ocaml.org/changelog/2025-01-23-dune.3.17.2)
* [Release of OCaml 5.3.0](https://ocaml.org/changelog/2025-01-08-ocaml-5.3.0)
* [OCaml-LSP 1.20.1](https://ocaml.org/changelog/2024-12-23-ocaml-lsp-1.20.1)
* [opam-publish 2.5.0](https://github.com/ocaml-opam/opam-publish/releases/tag/2.5.0)
* [Merlin 5.3-502 for OCaml 5.2 and 4.18-414 for OCaml 4.14](https://ocaml.org/changelog/2024-12-23-merlin-5.3.502-and-4.18.414)
* [Dune 3.17.1](https://ocaml.org/changelog/2024-12-18-dune.3.17.1)
* [OCamlformat 0.27.0](https://ocaml.org/changelog/2024-12-02-ocamlformat-0.27.0)
* [Dune 3.17.0](https://ocaml.org/changelog/2024-11-27-dune.3.17.0)
* [opam 2.3.0](https://ocaml.org/changelog/2024-11-13-opam-2-3-0)
* [Dune 3.16.1](https://ocaml.org/changelog/2024-10-30-dune.3.16.1)
* [Merlin 5.2.1-502 for OCaml 5.2 and 4.17.1 for OCaml 5.1 and 4.14](https://ocaml.org/changelog/2024-09-27-merlin-5.2.1)

## **Dune**

**Roadmap:** [Develop / (W4) Build a Project](https://ocaml.org/docs/platform-roadmap#w4-build-a-project)

[Dune 3.17 was released](https://discuss.ocaml.org/t/ann-dune-3-17/15770) with significant improvements to package management. Key features include binary distribution support, better error messages for missing packages, and Windows support without requiring OPAM.

The [Dune Developer Preview website](https://preview.dune.build?utm_source=ocaml.org&utm_medium=referral&utm_campaign=news) now provides editor setup instructions and package management tutorials.

Dune's package management features [were tested across hundreds of packages](https://dune.check.ci.dev/) in the opam repository, and a coverage tool was developed to track build success rates. For local development, Dune added support for building dependencies via `@pkg-install`, caching for package builds, and automated binary builds of development tools. The system supports both monorepo and polyrepo workflows, with options for installing individual dependencies or complete development environments.

The addition of [Wasm_of_ocaml support in Dune](https://github.com/ocaml/dune/pull/11093) opens new possibilities for OCaml projects targeting the web or other WebAssembly runtimes. 

**Activities:**
- Updated preview website with editor setup instructions at https://preview.dune.build and published binary installer providing prebuilt Dune binaries
- [Enable dune cache by default](https://github.com/ocaml/dune/pull/10710)
- [Added wasm_of_ocaml support](https://github.com/ocaml/dune/pull/11093)
- Added support for [Codeberg](https://github.com/ocaml/dune/pull/10904) and [GitLab organizations](https://github.com/ocaml/dune/pull/10766) in the `(source)` stanza
- [Added support for `-H` compiler flag](https://github.com/ocaml/dune/pull/10644) enabling better semantics for `(implicit_transitive_deps false)`

**Maintained by:** Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Etienne Millon (@emillon, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Étienne Marais (@maiste, Tarides)

## **Editor Tools**

**Roadmap:** [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code), [Edit / (W20) Refactor Code](https://ocaml.org/tools/platform-roadmap#w20-refactor-code)

Developer tooling received substantial upgrades during the end of last year and the beginning 2025. A major milestone for project-wide features has been reached with the release of OCaml 5.3: LSP's renaming feature now [_renames symbols in the entire project_](https://discuss.ocaml.org/t/ann-merlin-and-ocaml-lsp-support-experimental-project-wide-renaming/16008) if the index is built. Additionally, all of the classic merlin-server commands are now available as LSP custom requests: this enabled the addition of [many new features to the Visual Studio Code plugin](https://tarides.com/blog/2025-02-28-full-blown-productivity-in-vscode-with-ocaml/) and the creation of a brand new Emacs mode, based on LSP, [now available on Melpa](https://melpa.org/#/ocaml-eglot).

These features bring OCaml editor support closer to modern IDE capabilities, with implementations available across multiple editors.

### Merlin and OCaml LSP Server

Support for project wide renaming, search-by-type, and ocaml-lsp-server now exposes all Merlin features via LSP custom queries.

**Notable Activity**
- OCaml 5.3 support ([merlin#1850](https://github.com/ocaml/merlin/pull/1850))
- Project-wide renaming is now available. ([ocaml-lsp#1431](https://github.com/ocaml/ocaml-lsp/pull/1431) and [merlin#1877](https://github.com/ocaml/merlin/pull/1877))
- A new option to mute hover responses has been added for better integration with alternative hover providers ([ocaml-lsp#1416](https://github.com/ocaml/ocaml-lsp/pull/1416))
- New type-based search support similar to Hoogle ([ocaml-lsp#1369](https://github.com/ocaml/ocaml-lsp/pull/1369) and [merlin#1828](https://github.com/ocaml/merlin/pull/1828))

**Bug Fixes**
- Fixed completion range issues with polymorphic variants ([ocaml-lsp#1427](https://github.com/ocaml/ocaml-lsp/issues/1427))
- Fixed various issues with jump code actions and added customization options ([ocaml-lsp#1376](https://github.com/ocaml/ocaml-lsp/pull/1376))
- Various fixes and improvements have been made to signature help and inlay hints

### Visual Studio Code plugin

Added support for most of the Merlin features historically availbale to Emacs and Vim users, via the new LSP custom requests. 

**Notable Activity**

- Improved typed-of-selection feature, with ability to grow or shrink the selection and increase verbosity ([#1675](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1675)).
- Improved jump navigation ([#1654](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1654)), search-by-type ([#1626](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1626))
- Improved typed holes navigation ([#1666](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1666)).
- New search-by-type command ([#1626](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1626)).

**OCaml LSP Server maintained by:** Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by:** Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides)

### Emacs support

A brand new Emacs plugin based on the Eglot LSP client is now ready for daily usage: https://github.com/tarides/ocaml-eglot.

## **Documentation Tools**

**Roadmap:** [Share / (W25) Generate Documentation](https://ocaml.org/tools/platform-roadmap#w25-generate-documentation)

### Odoc

**Maintained by:** Jon Ludlam (@jonludlam, Tarides), Daniel Bünzli (@dbuenzli), Jules Aguillon (@julow, Tarides), Paul-Elliot Anglès d'Auriac (@panglesd, Tarides), Emile Trotignon (@EmileTrotignon, Tarides, then Ahrefs) 

There is now a [beta release for odoc 3](https://discuss.ocaml.org/t/ann-odoc-3-beta-release/16043) that you can try out and give feedback on!

During the quarter, odoc has been making steady progress toward its 3.0 release with several notable improvements:
- **Enhanced Navigation**: The sidebar and breadcrumbs navigation has been unified and improved ([#1251](https://github.com/ocaml/odoc/pull/1251)), making the documentation hierarchy more consistent and flexible. This allows better organization of modules, pages, and source files in the documentation.
- **Documentation Features**: New features have been added to Odoc 3 ([#1264](https://github.com/ocaml/odoc/pull/1264)), including:
  - Support for images with embedded assets
  - Cross-package linking (linking to modules from external libraries)
- **Search Integration**: Sherlodoc, the search functionality, has been merged into the main odoc codebase ([#1263](https://github.com/ocaml/odoc/pull/1263)), ensuring better maintenance and synchronized releases.

**Notable Activity**
- [[ANN] Odoc 3 Beta Release](https://discuss.ocaml.org/t/ann-odoc-3-beta-release/16043)

### Mdx upgraded to OCaml 5.3

**Maintained by:** Marek Kubica (@Leonidas-from-XIV, Tarides), Thomas Gazagnaire (@samoht, Tarides)

With OCaml 5.3, some compiler error messages changed, so MDX was updated to use a more expressive tag system to choose which version of the compiler can run which code block. This effort uncovered a bug in the current handling of skipped blocks for `mli` files, which was fixed.

**Notable Activity**
  - OCaml 5.3 support ([#457](https://github.com/realworldocaml/mdx/pull/457)), ensuring the tool remains compatible with the latest OCaml releases.
  - Fixed error handling for skipped blocks in `mli` files ([#462](https://github.com/realworldocaml/mdx/pull/462))
  - Improved syntax highlighting ([#461](https://github.com/realworldocaml/mdx/pull/461))
  - Added support for multiple version labels ([#458](https://github.com/realworldocaml/mdx/pull/458)), improving the ability to test code across different OCaml versions.

## **Package Management**

### Opam

[Opam 2.3.0 was released in November](https://ocaml.org/changelog/2024-11-13-opam-2-3-0). We are now working towards the 2.4 release, with some new sub commands (`admin`, `source`, `switch`, etc.), fixes (pinning, switch, software heritage fallback, UI) and enhancements.

**Notable Activity**
- Add several checksum, `extra-files` and `extra-source` lints - [#5561](https://github.com/ocaml/opam/issues/5561)
- Add options `opam source --require-checksums` and `--no-checksums` to harmonise with `opam install` - [#5563](https://github.com/ocaml/opam/issues/5563)
- Add the current VCS revision information to `opam pin list` - [#6274](https://github.com/ocaml/opam/issues/6274) - fix [#5533](https://github.com/ocaml/opam/issues/5533)
- Make opamfile parsing more robust for future changes - [#6199](https://github.com/ocaml/opam/issues/6199) - fix [#6188](https://github.com/ocaml/opam/issues/6188)
- Fix `opam switch remove <dir>` failure when it is a linked switch - [#6276](https://github.com/ocaml/opam/issues/6276) - fix [#6275](https://github.com/ocaml/opam/issues/6275)
- Fix `opam switch list-available` when given several arguments - [#6318](https://github.com/ocaml/opam/issues/6318)
- Correctly handle `pkg.version` pattern in `opam switch list-available` - [#6186](https://github.com/ocaml/opam/issues/6186) - fix [#6152](https://github.com/ocaml/opam/issues/6152)
- Fix sandbox for NixOS [#6333](https://github.com/ocaml/opam/issues/6333), and `DUNE_CACHE_ROOT` environment variabale usage - [#6326](https://github.com/ocaml/opam/issues/6326)
- Add `opam admin compare-versions` to ease version comparison for sanity checks [#6197](https://github.com/ocaml/opam/issues/6197) and fix `opam admin check` in the presence of some undefined variables - [#6331](https://github.com/ocaml/opam/issues/6331) - fix [#6329](https://github.com/ocaml/opam/issues/6329)
- When loading a repository, don’t automatically populate `extra-files:` field with found files in `files/` - [#5564](https://github.com/ocaml/opam/issues/5564)
- Update and fix Software Heritage fallback - [#6036](https://github.com/ocaml/opam/issues/6036) - fix [#5721](https://github.com/ocaml/opam/issues/5721)
- Warn if a repository to remove doesn’t exist - [#5014](https://github.com/ocaml/opam/issues/5014) - fix [#5012](https://github.com/ocaml/opam/issues/5012)
- Silently mark packages requiring an unsupported version of opam as unavailable - [#5665](https://github.com/ocaml/opam/issues/5665) - fix [#5631](https://github.com/ocaml/opam/issues/5631)
- Display switch invariant with the same syntax that it is written in file (no pretty printing) - [#5619](https://github.com/ocaml/opam/issues/5619) - fix [#5491](https://github.com/ocaml/opam/issues/5491)
- Fix output display regarding terminal size [#6244](https://github.com/ocaml/opam/issues/6244) - fix [#6243](https://github.com/ocaml/opam/issues/6243)
- Change default answer display - [#6289](https://github.com/ocaml/opam/issues/6289) - fix [#6288](https://github.com/ocaml/opam/issues/6288)
- Add a warning when setting a variable with `opam var` if an option is shadowed - [#4904](https://github.com/ocaml/opam/issues/4904) - fix [#4730](https://github.com/ocaml/opam/issues/4730)
- Improve the error message when a directory is not available while fetching using rsync - [#6027](https://github.com/ocaml/opam/issues/6027)
- Fix `install.exe` search path on Windows - [#6190](https://github.com/ocaml/opam/issues/6190)
- Add `ALTLinux` support for external dependencies - [#6207](https://github.com/ocaml/opam/issues/6207)
- Make `uname` information more robust accros ditributions - [#6127](https://github.com/ocaml/opam/issues/6127)

**Maintained by:** Raja Boujbel (@rjbou - OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Tarides)

### Dune-release

**Roadmap:** [Share / (W26) Package Publication](https://ocaml.org/tools/platform-roadmap#w26-package-publication)

Dune-release has been improved to better handle publishing packages from custom repositories and private Git repositories.

**Notable Activity**
- Support for overwriting the dev-repo field when creating GitHub tags/releases ([#494](https://github.com/tarides/dune-release/pull/494)), which a useful for private projects

**Maintained by:** Thomas Gazagnaire (@samoht, Tarides), Etienne Millon (@emillon, Tarides), Marek Kubica (@Leonidas-from-XIV, Tarides)

### Opam-publish

**Notable Activity**
- Integration of Opam CI Lint functionality into `opam-publish` ([#166](https://github.com/ocaml-opam/opam-publish/pull/166), [#165](https://github.com/ocaml-opam/opam-publish/issues/165)) to validate packages before submission
- A new `--pre-release` argument added to handle pre-release packages correctly ([#164](https://github.com/ocaml-opam/opam-publish/pull/164))

**Maintained by:** Raja Boujbel (@rjbou - OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)
