---
title: "Platform Newsletter: September 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-10-26"
tags: [platform]
---

Welcome to the sixth edition of the OCaml Platform newsletter!

Dive into the latest updates from September and discover how the [OCaml Platform](https://ocaml.org/docs/platform) is evolving. Just like in [previous newsletters](https://discuss.ocaml.org/tag/platform-newsletter), it spotlights the recent developments and enhancements to the OCaml development workflows.

In addition to the updates on the Platform team's progress highlighted below, don't hesitate to [share your feedback](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238) on the upcoming Platform roadmap. We've just updated it based on the most recent feedback and are aiming to adopt it in the coming weeks, barring new concerns from the community.

Happy reading!

- [Releases](#releases)
- [Building Packages](#building-packages)
  - [**\[Dune\]** Exploring Package Management in Dune](#dune-exploring-package-management-in-dune)
  - [**\[opam\]** Native Support for Windows in opam 2.2](#opam-native-support-for-windows-in-opam-22)
  - [**\[Dune\]** Dune Terminal User Interface](#dune-dune-terminal-user-interface)
  - [**\[Dune\]** Support on Niche Platforms](#dune-support-on-niche-platforms)
- [Generating Documentation](#generating-documentation)
  - [**\[`odoc`\]** Add Search Capabilities to `odoc`](#odoc-add-search-capabilities-to-odoc)
  - [**\[`odoc`\]** Syntax for Images and Assets in `odoc`](#odoc-syntax-for-images-and-assets-in-odoc)
  - [**\[Dune\]** Generate Dependencies Documentation with Dune](#dune-generate-dependencies-documentation-with-dune)
- [Editing and Refactoring Code](#editing-and-refactoring-code)
  - [**\[Merlin\]** Support for Project-Wide References in Merlin](#merlin-support-for-project-wide-references-in-merlin)
  - [**\[Merlin\]** Improving Merlin's Performance](#merlin-improving-merlins-performance)

## Releases

Here are all the new versions of Platform tools that were released this month:

- [Merlin 4.11](https://ocaml.org/changelog/2023-09-22-merlin-4.11)
- [Merlin 4.12](https://ocaml.org/changelog/2023-09-26-merlin-4.12)
- [OCamlFormat 0.26.1](https://ocaml.org/changelog/2023-09-19-ocamlformat-0.26.1)
- [MDX 2.3.1](https://ocaml.org/changelog/2023-09-27-mdx-2.3.1)

For detailed release notes and announcements, explore the [OCaml Changelog](https://ocaml.org/changelog).

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

The biggest highlight from September is that the work to expose the compiler and libraries from packages installed by Dune to the rest of the project is now complete! This means that there is now a prototype of Dune package management that can be used to build projects that depend on (simple) opam packages! This is still an early prototype that's not ready to be tested outside of the core team, but still a significant milestone: :tada:!

In addition to this, work in September focussed on three areas:
- Increasing coverage of opam features to support more opam packages from the `opam-repository`. This month, the Dune team added support for new fields, including `build-env`, `setenv`, and `subst`, and they also added support for patching.
- Designing and implementing a string manipulation DSL for Dune configurations. This will allow users to express the same amount of dynamism found in opam filters in Dune package lockfiles, which is necessary for converting opam `build` and `install` commands into Dune expressions.
- Started working on support for custom opam repositories by making the `opam-repository` configurable in `dune-workspace`. The next step is to experiment on how opam repositories are stored and accessed. One idea is that all opam repositories would be stored in one revision storage that would supply all the data. This has the advantage that incremental updates are small, which work like pulling via Git. The repo doesn't need to be uncompressed, thus less storage and inodes used.

**Activities:**
- Move packages to private context -- [ocaml/dune#8467](https://github.com/ocaml/dune/pull/8467)
- Translate `build-env` from opam file into lock dir -- [ocaml/dune#8701](https://github.com/ocaml/dune/pull/8701)
- Translate `setenv` from opam file into Dune lock dir -- [ocaml/dune#8708](https://github.com/ocaml/dune/pull/8708)
- Translate `substs` field of opam file into build action -- [ocaml/dune#8669](https://github.com/ocaml/dune/pull/8669)
- Add patching support to Dune pkg -- [ocaml/dune#8654](https://github.com/ocaml/dune/pull/8654)
- Copy files from opam repository to lock dir -- [ocaml/dune#8648](https://github.com/ocaml/dune/pull/8648)
- `dune.lock` is ignored in `--release` -- [ocaml/dune#8761](https://github.com/ocaml/dune/pull/8761)
- Opam repositories from `dune-workspace` -- [ocaml/dune#8633](https://github.com/ocaml/dune/pull/8633)
- Add `dune pkg outdated` command for showing outdated packages -- [ocaml/dune#8773](https://github.com/ocaml/dune/pull/8773)
- Experimental string list language -- [ocaml/dune#8596](https://github.com/ocaml/dune/pull/8596)

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

In preparation for the upcoming release of opam 2.2~alpha3, the work has focussed on better handling of path rewriting for the `setenv` and `build-env` opam fields.

The [proposed change](https://github.com/ocaml/opam/pull/5636) will allow users to specify, in the opam file, the path separator and format they want for each environment variable in `setenv`/`build-env`. This ensures the environment variables are correctly set and usable on Windows.

The PR is in review and not quite ready to be merged, but this is the last issue scoped for opam 2.2~alpha3.

**Activities:**
- Path rewriting for `setenv:` and `build-env:` - [ocaml/opam#5636](https://github.com/ocaml/opam/pull/5636)

### **[Dune]** Dune Terminal User Interface

Contributors: @Alizter, @rgrinberg (Tarides)

Following the merge of the PR to port Dune TUI to [Nottui](https://github.com/let-def/lwd) in August, and the addition of a few features, @Alizter continued the work on building a full-on Terminal User Interface for Dune with two pull requests, namely the addition of a [Jobs tab in `tui` mode](https://github.com/ocaml/dune/pull/8601), and support for [multiline status lines](https://github.com/ocaml/dune/pull/8619).

**Activities:**
- Add Jobs tab in `tui` mode -- [ocaml/dune#8601](https://github.com/ocaml/dune/pull/8601)
- Multiline status support -- [ocaml/dune#8619](https://github.com/ocaml/dune/pull/8619)

### **[Dune]** Support on Niche Platforms

Contributors: @Alizter

Dune now builds on both [Haiku](https://www.haiku-os.org/) and Android (using Termux)! This means it is now possible to build and install both OCaml and Dune on these platforms, which should pave the way for more native OCaml development.

For reference, here is a table of Dune's platform support (with `?` indicating that further testing is needed):

| Platform         | Support | Watch | TUI | Cache | Sandboxing |
|------------------|---------|-------|-----|-------|------------|
| Linux            | Full    | Yes   | Yes | Yes   | Yes        |
| MacOS            | Full    | Yes   | Yes | Yes   | Yes        |
| Windows (DKML)   | Full    | Yes   | No* | Yes   | Copy only  |
| Windows (MinGW)  | Limited | Yes   | Yes | Yes   | Yes        |
| Windows (Cygwin) | Limited | Yes   | Yes | Yes   | Yes        |
| Linux (Android)  | Limited | Yes   | Yes | ?     | ?          |
| FreeBSD          | Limited | Yes   | Yes | ?     | ?          |
| NetBSD           | Limited | Yes   | Yes | ?     | ?          |
| OpenBSD          | Limited | ?     | ?   | ?     | ?          |
| Haiku            | Limited | Yes   | Yes | ?     | ?          |

If you're working on one of these platforms, don't hesitate to open issues on [Dune's bug tracker](https://github.com/ocaml/dune/issues) if you encounter any problem!

**Activities:**
- Add Haiku support -- [ocaml/dune#8795](https://github.com/ocaml/dune/pull/8795)

## Generating Documentation

### **[`odoc`]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

Work continues on adding search capabilities to `odoc` in order to improve the documentation browsing experience.

In September, the `odoc` team continued reviewing the different pull requests started in August. Peer-reviews suggested several improvements to to the CLI and the library API.

They also worked on client-side performance improvements by loading the search script only when the user clicks on the search bar, and they made quite a lot of progress on the UI overall.

**Activities:**
- Support for search in `odoc` -- [ocaml/odoc#972](https://github.com/ocaml/odoc/pull/972)
- Collect occurrences information -- [ocaml/odoc#976](https://github.com/ocaml/odoc/pull/976)

### **[`odoc`]** Syntax for Images and Assets in `odoc`

Contributors: @panglesd (Tarides)

The effort to add support for images and assets to `odoc` and bring images to the OCaml.org package documentation continues!

This month, @panglesd opened a PR with an [implementation for asset references](https://github.com/ocaml/odoc/pull/1002).

The exact syntax for medias went through several designs, in particular whether a media is a block, a nestable block, or an inline element. At the end of the month, @panglesd created a [PR](https://github.com/ocaml/odoc/pull/1005) that builds on the asset references PR in order to add support for medias.

For some time, there has been no official convention on how documentation for opam-installed packages should be built. With the added complexity of having assets, it was a good time to solve this. A [documentation PR](https://github.com/ocaml/odoc/pull/1011) was opened for this. Warm thank you to @dbuenzli for the thourough review and participating in establishing these conventions!

**Activities:**
- Asset References -- [ocaml/odoc#1002](https://github.com/ocaml/odoc/pull/1002)      
- Medias in `odoc` -- [ocaml/odoc#1005](https://github.com/ocaml/odoc/pull/1005)
- Document parent-child convention for installed packages -- [ocaml/odoc#1011](https://github.com/ocaml/odoc/pull/1011)

### **[Dune]** Generate Dependencies Documentation with Dune

Contributors: @jonludlam (Tarides)

Currently, Dune only knows how to build the documentation for the packages in your Dune workspace, meaning that you can only read the documentation of your dependencies from the [OCaml.org package site](https://ocaml.org/packages). Alternative `odoc` drivers, like [`odig`](https://erratique.ch/software/odig), build documentation for all the packages in your switch and have been the recommended solution for users who prefer to read the dependencies' documentation locally.

In an effort to improve the documentation generation experience with Dune, @jonludlam worked on a new version of Dune rules to generate the documentation. With these rules, Dune will gain the additional ability to build the combination of the two: a coherent set of docs that cover both switch-installed libraries and local libraries.

The [PR](https://github.com/ocaml/dune/pull/8803) is in review and is set to be merged in the coming weeks.

Future plans for the new rules include better integration with the rest of the platform, improvements in capabilities to cover the use cases that `dune build @doc` covers, integration of source rendering, and integration of search (once it lands in `odoc`!).

**Activities:**
- New `odoc` rule -- [ocaml/dune#8803](https://github.com/ocaml/dune/pull/8803)

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides), @trefis (Tarides), @Ekdohibs (OCamlPro), @gasche (INRIA)

In August, the Merlin team opened the PR on the compiler that adds the necessary information in the Shapes to implement project-wide references.

The [PR](https://github.com/ocaml/ocaml/pull/12508) received reviews, so the team worked on taking the feedback into account while also continuing work on the rest of the stack (build system rules, the indexer and new locate, and occurrences backends for Merlin).

They also consolidated a release plan and timeline. The plan is to first release an experimental 4.14-based variant of the compiler in order to gather feedback on this eagerly awaited feature before the end of the year. The current aim is to provide official project-wide occurrences support in OCaml 5.2.

**Activities:**
- Add support for project-wide occurrences to the compiler -- [ocaml/ocaml#12508](https://github.com/ocaml/ocaml/pull/12508)
- Use new compile information in CMT files to build and aggregate indexes -- [voodoos/ocaml-uideps#5](https://github.com/voodoos/ocaml-uideps/pull/5)
- Dune orchestrates index generation -- [voodoos/dune#1](https://github.com/voodoos/dune/pull/1)
- Use new CMT info to provide buffer occurrences and indexes for project-wide occurrences -- [voodoos/merlin#7](https://github.com/voodoos/merlin/pull/7)
- Support project-wide occurrences in `ocaml-lsp` -- [voodoos/ocaml-lsp#1](https://github.com/voodoos/ocaml-lsp/pull/1)

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag-ha (Tarides), @3Rafal (Tarides), @voodoos (Tarides), @let-def (Tarides)

The Merlin team continues work on improving Merlin performance.

Before diving into specific performance optimisation, they worked on a benchmarking CI to catch performance regressions and measure improvements. While at it, they've also worked on a fuzzy testing CI to catch behaviour regressions.

In September, following the Proof of Concept (PoC) of the fuzzy-testing CI (from the work in July), the team continued their work on addressing the limitations of the current CI implementation that would prevent it from being merged in Merlin. Specifically, they focussed on finding a solution to store the fuzzy testing results in a way that wouldn't bloat the Merlin repository. The current approach is to store the data in a separate Git repository and pull it when running the fuzzy-testing CI. They've created a GitHub action workflow that implements this behaviour.

Next, the plan is to complete the work on the Merlin CI before gradually shifting focus to performance optimisations.

**Activities:**
- PoC for the Behavior CI – [ocaml/merlin#1657](https://github.com/ocaml/merlin/pull/1657)
