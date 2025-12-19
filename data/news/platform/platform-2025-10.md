---
title: "Platform Newsletter: September to October 2025"
description: "OCaml Platform Sept-Oct 2025: OCaml 5.4.0 release with labelled tuples & immutable arrays, new Security Response Team, OCaml-LSP 1.24.0 updates & more"
date: "2025-11-06"
tags: [platform]
---

Welcome to the sixteenth edition of the OCaml Platform newsletter!

In this September to October 2025 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [comment on this newsletter on the OCaml Discuss Forums](https://discuss.ocaml.org/t/ocaml-platform-newsletter-september-to-october-2025/17462)!

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**Highlights:**
- **OCaml 5.4.0 Released**: Major stable release featuring labelled tuples, immutable arrays, unified array literal syntax, atomic record fields, and four new standard library modules
- **Security Response Team Established**: New team formed to handle security vulnerabilities in the OCaml ecosystem
- **Enhanced Editor Support**: OCaml-LSP 1.24.0 and Merlin 5.6 bring improved project navigation and performance optimizations
- **OCaml.org Reorganization**: Clear separation between news about production-ready features and releases (OCaml Changelog) and ongoing work and experimental features (Backstage OCaml)
- **Experimental Tools Progress**: Gospel ecosystem tools ready for testing, new ocaml.nvim plugin for Neovim users, and experimental Merlin branch using domains and effects

**OCaml Changelog:**
- [OCaml.org: Introducing Backstage OCaml - Separate Feeds for Stable and Experimental Features](https://ocaml.org/changelog/2025-10-08-introducing-backstage-ocaml) (Oct 8, 2025)
- [OCaml Security Response Team Established](https://ocaml.org/changelog/2025-10-03-security-team) (Oct 3, 2025)

**Backstage OCaml:**
- [Gospel Ecosystem: Tools Ready to Try, Language Evolving](https://ocaml.org/backstage/2025-10-15-gospel-language-evolving) (Oct 15, 2025)
- [Backstage OCaml: ocaml.nvim - A Neovim Plugin for OCaml](https://ocaml.org/backstage/2025-10-14-ocaml-nvim-a-neovim-plugin-for-ocaml) (Oct 14, 2025)
- [Backstage OCaml: You Can Try the Experimental Branch of Merlin That Uses Domains and Effects](https://ocaml.org/backstage/2025-10-08-merlin-domains) (Oct 8, 2025)

**Stable Releases:**
- [Release of OCaml 5.4.0](https://ocaml.org/changelog/2025-10-09-ocaml-540) (Oct 9, 2025)
- [opam-publish 2.7.0](https://ocaml.org/changelog/2025-10-07-opam-publish-2-7-0) (Oct 7, 2025)
- [OCaml-LSP 1.24.0](https://ocaml.org/changelog/2025-10-04-ocaml-lsp-1240) (Oct 4, 2025)
- [Merlin 5.6-503 and 5.6-504](https://ocaml.org/changelog/2025-10-04-merlin-v56-503-and-504) (Oct 4, 2025)
- [OCaml-LSP 1.23.1](https://ocaml.org/changelog/2025-10-03-ocaml-lsp-1231) (Oct 3, 2025)
- [Ppxlib 0.36.2](https://ocaml.org/changelog/2025-10-01-ppxlib-0362) (Oct 1, 2025)
- [ocp-indent 1.9.0](https://ocaml.org/changelog/2025-10-01-ocp-indent-190) (Oct 1, 2025)
- [opam-publish 2.6.0](https://ocaml.org/changelog/2025-09-19-opam-publish-2-6-0) (Sep 19, 2025)
- [Dune 3.20.2](https://ocaml.org/changelog/2025-09-10-dune3202) (Sep 10, 2025)

**Unstable Releases:**
- [First release candidate for OCaml 5.4.0](https://ocaml.org/backstage/2025-09-29-ocaml-540-rc1) (Sep 29, 2025)
- [Second beta release of OCaml 5.4.0](https://ocaml.org/backstage/2025-09-09-ocaml-540-beta2) (Sep 9, 2025)

## OCaml Compiler

### OCaml 5.4.0 Stable Release

The [October 9, 2025 release of OCaml 5.4.0](https://ocaml.org/changelog/2025-10-09-ocaml-540) represents a major milestone with significant language enhancements. After two beta releases and a release candidate in September, the stable version delivers:

**Language Features:**
- **Labelled tuples**: Enable better documentation and type safety with labels on tuple fields
  ```ocaml
  let ( * ) (x,~dx) (y,~dx:dy) = x*.y, ~dx:(x *. dy +. y *. dx)
  ```
- **Immutable arrays** (`'a iarray`): Covariant arrays for safer concurrent programming
- **Unified array literal syntax**: `[| ... |]` now works for `'a array`, `'a iarray`, and `floatarray`
- **Atomic record fields**: New `[@atomic]` attribute with `Atomic.Loc` submodule for lock-free concurrent access

**Standard Library Additions:**
- `Pair`: Utility functions for pairs
- `Pqueue`: Priority queue implementation
- `Repr`: Explicit functions for physical equality and comparison
- `Iarray`: Operations on immutable arrays

**Runtime Improvements:**
- Frame pointers support for ARM64 (Linux and macOS)
- Performance fix for Apple Silicon (using `stlr` instead of `dmb ishld; str`)
- Software prefetching for ARM64, s390x, PPC64, and RISC-V
- Restored "memory cleanup upon exit" mode

The [September beta releases](https://ocaml.org/backstage/2025-09-09-ocaml-540-beta2) and [release candidate](https://ocaml.org/backstage/2025-09-29-ocaml-540-rc1) demonstrated the maturity of the release, with only minor TSAN and metadata fixes needed.

### WIP: Relocatable OCaml

Work on **Relocatable OCaml** is progressing toward inclusion in OCaml 5.5, with implementation PRs opened by David Allsopp in September. The changes are undergoing review from Samuel Hym, Jonah Beckford, and others.

**What Relocatable OCaml Enables:**
This feature allows the OCaml compiler and its associated tools to be moved to different filesystem locations after installation without breaking functionality. Key benefits include:
- Binary distributions that work regardless of installation path
- Improved flexibility for package managers organizing OCaml installations
- Bundling of specific OCaml versions by developer tools without path conflicts
- Simplified cross-platform distribution

**Current Status:**
The implementation is in active review with ongoing responses to feedback. The core development team is likely to review the changes at an upcoming meeting, targeting inclusion in OCaml 5.5.

For technical details about the implementation approach and its implications for the ecosystem, see David Allsopp's [blog post on Relocatable OCaml](https://www.dra27.uk/blog/platform/2025/09/15/relocatable-ocaml.html) and the associated [Discuss thread](https://discuss.ocaml.org/t/relocatable-ocaml/17253).

## Build System

### Dune

[Dune 3.20.2](https://ocaml.org/changelog/2025-09-10-dune3202) (September 10, 2025) provides bug fixes and stability improvements for the 3.20 series.

#### Experimental: Dune Package Management

We keep exploring:
- **Portable External Dependencies**: An approach for storing system package dependencies in a platform-agnostic format, allowing projects to maintain a single specification that resolves correctly across Linux, macOS, and Windows environments, ensuring consistent builds regardless of platform-specific package naming and versioning differences.
- **Portable Lock Directories**: Lock directories that work consistently across different operating systems and architectures, addressing the current limitation where platform-specific dependency resolutions prevent teams from sharing lock files through version control in heterogeneous development environments.
- **Lock Directories as Build Targets**: Currently, the solver that comes up with a set of compatible dependencies needs to be run by the user explicitely (using `dune pkg lock`), but in the future we intend to create build plans implicitly via Dune build rules. This should make make package management simpler to use as it requires fewer user actions and does not require putting verbose lock directories into the project source directories. This change also paves the way for automatic relocking when dependencies change, including in watch mode.


These features remain under active development and should not be relied on in production. However, we encourage cautious adoption of Dune Package Management itself for users comfortable with bleeding-edge tools that may still change. Dune package management is available in the stable release of Dune, as an experimental feature.

**Dune Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter, Tarides), Etienne Millon (@emillon), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Etienne Marais (@maiste)

## Package Management

### opam-publish

We celebrate two releases of opam-publish: [**opam-publish 2.6.0**](https://ocaml.org/changelog/2025-09-19-opam-publish-2-6-0) (September 19, 2025) and [**opam-publish 2.7.0**](https://ocaml.org/changelog/2025-10-07-opam-publish-2-7-0) (October 7, 2025).

These releases make it easier to automate package publishing, particularly benefiting projects with continuous deployment pipelines.

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)

## Editor Tools

*Roadmap: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code)*

### OCaml-LSP Server and Merlin

September and October saw significant updates to editor support:

#### Stable Releases

- [**OCaml-LSP 1.24.0**](https://ocaml.org/changelog/2025-10-04-ocaml-lsp-1240) (October 4, 2025): Major release with improved project navigation and performance optimizations
- [**OCaml-LSP 1.23.1**](https://ocaml.org/changelog/2025-10-03-ocaml-lsp-1231) (October 3, 2025): Bug fix release
- [**Merlin 5.6-503 and 5.6-504**](https://ocaml.org/changelog/2025-10-04-merlin-v56-503-and-504) (October 4, 2025): Support for OCaml 5.3 and 5.4 with performance improvements

#### Experimental: Merlin with Domains and Effects

The [experimental Merlin branch using domains and effects](https://ocaml.org/backstage/2025-10-08-merlin-domains) offers potential performance improvements through parallelization. This experimental version is available for testing but not recommended for production use.

### ocp-indent

[**ocp-indent 1.9.0**](https://ocaml.org/changelog/2025-10-01-ocp-indent-190) (October 1, 2025): Updates for OCaml 5.4.0 compatibility and improved formatting rules.

### Experimental: ocaml.nvim

[Tarides announced ocaml.nvim](https://ocaml.org/backstage/2025-10-14-ocaml-nvim-a-neovim-plugin-for-ocaml), a new Neovim plugin for OCaml development. This experimental plugin serves as the Neovim counterpart to ocaml-eglot, leveraging LSP for modern editor features.

**OCaml LSP Server maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Muluh Godson (@PizieDust, Tarides),

## Documentation and PPX Tools

### Ppxlib

[**Ppxlib 0.36.2**](https://ocaml.org/changelog/2025-10-01-ppxlib-0362) (October 1, 2025): Compatibility updates for OCaml 5.4.0 and fixes for AST handling.

**Maintained by**: Nathan Rebours (@NathanReb)

## Gospel Ecosystem (Experimental)

The Gospel formal specification ecosystem now offers tools for experimental specification-driven testing, as detailed in ["Gospel Ecosystem: Tools Ready to Try, Language Evolving"](https://ocaml.org/backstage/2025-10-15-gospel-language-evolving).

**Available Tools:**
- **Ortac/QCheck-STM** generates property-based tests from Gospel specifications written in `.mli` files. The tool won the TACAS 2025 Best Tool Paper award and can automatically produce comprehensive test suites from formal specifications. While the underlying Gospel language syntax may still change, the testing workflow is stable enough for experimental use in development environments.

**Current Status:**
The tools work well for isolated modules where you can write specifications and generate tests, but the Gospel language itself remains under active development with potential breaking changes ahead. Teams using these tools should be prepared to update specifications as the language evolves. This makes the ecosystem suitable for greenfield projects, experimental codebases, or well-isolated components where specification changes won't cascade through large systems.

## Platform Infrastructure

### OCaml Security Response Team

The [establishment of the OCaml Security Response Team](https://ocaml.org/changelog/2025-10-03-security-team) (October 3, 2025) marks an important step in ecosystem maturity. The team will handle security vulnerabilities following established disclosure practices.


### OCaml.org Reorganization

The [newly introduced separation of OCaml Changelog and Backstage OCaml](https://ocaml.org/changelog/2025-10-08-introducing-backstage-ocaml) provides clearer communication:
- **OCaml Changelog**: Official stable releases and production-ready updates
- **Backstage OCaml**: Experimental releases, work-in-progress, and development opportunities

This helps readers distinguish more easily between what's ready for production use and what's still experimental.

## Community Events

### FUN OCaml 2025
The FUN OCaml conference took place on **September 15-16, 2025** in Warsaw, Poland, featuring talks on practical OCaml development, industry applications, and community projects. The [FUN OCaml 2025 program and speaker lineup](https://fun-ocaml.com/2025/) showcases the diverse ecosystem of OCaml in production. Video recordings of all presentations will be available soon for those who couldn't attend in person.

### OCaml Workshop 2025
The OCaml Users and Developers Workshop was held on **October 17, 2025** in Singapore, co-located with ICFP/SPLASH, bringing together researchers and practitioners. You can find the list of presentations and a link to the video recordings on [the OCaml Workshop 2025 page on OCaml.org](https://ocaml.org/conferences/ocaml-workshop-2025)!

---

We're pleased to see the successful release of OCaml 5.4.0, marking a significant milestone with labelled tuples, immutable arrays, and atomic fields. The establishment of the Security Response Team and the reorganization of OCaml.org demonstrate the ecosystem's growing maturity. 

The clear separation between stable releases and experimental work helps the community make informed decisions about tool adoption. While experimental features in the Dune Developer Preview, ocaml.nvim, and Gospel ecosystem show promising directions, they remain in testing and should not be used in production.

As always, we encourage feedback and contributions from the community as we continue to improve the OCaml Platform ecosystem.
