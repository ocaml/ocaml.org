---
title: "Platform Newsletter: July 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-08-21"
tags: [platform]
---

Welcome to the fourth installment of the OCaml Platform newsletter!

This edition brings the latest improvements made in July to improve the OCaml developer experience with the [OCaml Platform](https://ocaml.org/docs/platform). As in the [previous updates](https://discuss.ocaml.org/tag/platform-newsletter), the newsletter features the development workflows currently being explored or enhanced.

This issue ended up a bit shorter than the previous ones, as we're entering summertime in Europe. Still, this month saw some great progress on support for package management in Dune, with only a few [remaining blockers](https://github.com/ocaml/dune/issues/8096) to build simple opam packages. We also saw the release of the second alpha of the most anticipated opam 2.2, which comes with an automated installation of Cygwin on Windows, allowing users to install a complete development environment using opam's installation script alone!

- [Releases](#releases)
- [Building Packages](#building-packages)
  - [**\[Dune\]** Exploring Package Management in Dune](#dune-exploring-package-management-in-dune)
  - [**\[opam\]** Native Support for Windows in opam 2.2](#opam-native-support-for-windows-in-opam-22)
  - [**\[Dune\]** `dune monitor`: Connect to a Running Dune build](#dune-dune-monitor-connect-to-a-running-dune-build)
- [Generating Documentation](#generating-documentation)
  - [**\[odoc\]** Add Search Capabilities to `odoc`](#odoc-add-search-capabilities-to-odoc)
  - [**\[odoc\]** Syntax for Images and Assets in `odoc`](#odoc-syntax-for-images-and-assets-in-odoc)
- [Editing and Refactoring Code](#editing-and-refactoring-code)
  - [**\[Merlin\]** Support for Project-Wide References in Merlin](#merlin-support-for-project-wide-references-in-merlin)
  - [**\[Merlin\]** Improving Merlin's Performance](#merlin-improving-merlins-performance)

## Releases

Here are all the new versions of Platform tools that were released this month. Have a look at the [OCaml Changelog](https://ocaml.org/changelog) to read release announcements!

- [UTop 2.13.0](https://ocaml.org/changelog/2023-07-04-utop-2.13.0)
- [UTop 2.13.1](https://ocaml.org/changelog/2023-07-11-utop-2.13.1)
- [Dune 3.9.1](https://ocaml.org/changelog/2023-07-06-dune-3.9.1)
- [Dune 3.9.2](https://ocaml.org/changelog/2023-07-25-dune-3.9.2)
- [opam 2.2.0~alpha2](https://ocaml.org/changelog/2023-07-26-opam-2-2-0-alpha2)
- [OCamlFormat 0.26.0](https://ocaml.org/changelog/2023-07-20-ocamlformat-0.26.0)

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides)

In July, the Dune Package Management team worked on automatically downloading the `opam-repository` to ensure it is readily available for locking when no other source of `opam-repository` is specified.

The Dune version of opam `substs` support was implemented, and the variable environment was enhanced when expanding opam package filters in the solver.

Support for system variables was also added, which can be read from the workspace file or inferred from the current system. Notably, unset system variables are now treated as wildcards by the solver, allowing the generation of a single `lockdir` suitable for a range of systems. This change eliminates the need for different `lockdirs` for various systems, such as macOS and Linux.

**Activities:**
- Add field to indicate OCaml package -- [ocaml/dune#8079](https://github.com/ocaml/dune/pull/8079)
- Created issues to track remaining work building opam packages in Dune, along with a [meta issue](https://github.com/ocaml/dune/issues/8096)
  - Patch files in `lockdir` -- [ocaml/dune#8093](https://github.com/ocaml/dune/issues/8093)
  - Opam variable interpolation while building packages with Dune -- [ocaml/dune#8094](https://github.com/ocaml/dune/issues/8094)
  - Per-package files from `opam-repository` in `lockdir` -- [ocaml/dune#8095](https://github.com/ocaml/dune/issues/8095)
  - Opam `build` and `install` commands in Dune `lockdir` -- [ocaml/dune#8154](https://github.com/ocaml/dune/issues/8154)
- Conditional dependencies in `lockdir` -- [ocaml/dune#8050](https://github.com/ocaml/dune/pull/8050)
  - Chain of commits ready to go into new PRs once this is merged, which will extend this to allow users to place constraints on system `env vars` in build contexts and to solve for a range of systems at once. For example, this can be used to generate a `lockdir `that works on both macOS and Linux or generate a `lockdir` for macOS while running on a Linux machine.
- Solver can solve for multiple environments in single `lockdir` -- [ocaml/dune#8188](https://github.com/ocaml/dune/pull/8188)
  - This will allow users to use a single `lockdir` across multiple different environments (e.g., different operating systems).
- Implement automatic download of `opam-repository` with the option to use an existing folder or customising the default URL (defaulting to the `opam-repository` tarball), thus removing the need to piggyback on the `opam-repository` of a switch and removing support for it, somewhat simplifying the way the `0install` solver is run -- [ocaml/dune#8105](https://github.com/ocaml/dune/pull/8105)
- Work on implementing the substitution support from opam as part of Dune by hooking up the functions from the opam API with the Dune rules -- [ocaml/dune#8225](https://github.com/ocaml/dune/pull/8225)
- Creation of files from `.in` templates to match the opam `substs` field/feature -- [ocaml/dune#8225](https://github.com/ocaml/dune/pull/8225)
- Progress on creating a variable environment for package solving:
  - Set the `opam-version` variable during solving -- [ocaml/dune#8267](https://github.com/ocaml/dune/pull/8267)
  - Don't warn on undefined opam variables when solving -- [ocaml/dune#8275](https://github.com/ocaml/dune/pull/8275)

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

The first alpha of the highly-anticipated opam 2.2 was released last month. The second alpha of opam 2.2 was released this month.

While the first alpha introduced native Windows compatibility, the second alpha offers simpler initialisation for Windows, eliminating the dependency on a preexisting Cygwin UNIX-like environment. Instead, opam now offers an embedded, fully-managed Cygwin install during initialisation.

Have a look at the [release announcement](https://ocaml.org/changelog/2023-07-26-opam-2-2-0-alpha2) for more details, and join the discussion to share your feedback on [Discuss](https://discuss.ocaml.org/t/ann-opam-2-2-0-alpha2-release/12699).

**Activities:**
- Make `opam init` internally install Cygwin automatically by default instead of asking the user to install it manually -- [opam#5545](https://github.com/ocaml/opam/pull/5545)

### **[Dune]** `dune monitor`: Connect to a Running Dune build

Contributors: @Alizter

This month, @Alizter started working on a new `dune monitor` command that connects to a Dune build that's running in watch mode (via Dune RPC) and behaves as if you executed `dune build -w`.

In the future, the plan is to merge `dune monitor` into the `dune build` command, so running a build will spawn an RPC server by default and any subsequent build will connect to the RPC server to display the build information.

This is especially exciting in the context of Dune package management. Editors will be able to connect to a running Dune RPC server (directly or through OCaml LSP) to provide the relevant editors' features. With `dune monitor`, there will not be limitations in the number of editors you can open for the same project!

With recent work on [Dune Terminal UI](https://discuss.ocaml.org/t/ocaml-platform-newsletter-april-2023/12187#dune-dune-terminal-user-interface-7), expect the experience of running multiple build commands to improve quite a lot in the near future!

## Generating Documentation

### **[odoc]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @trefis (Tarides)

The `odoc` team continued to make progress on generating a search index from odoc and adding search capabilities to the HTML backend.

Some issues have been found during testing and have been addressed, and [Sherlodoc](https://github.com/art-w/sherlodoc/tree/jsoo) was updated to be compatible with the latest version of `odoc`, which now provides [basic support for assets](https://github.com/ocaml/odoc/pull/975) used to select the search JavaScript script file.

**Activities:**
- Support for search in `odoc` -- [ocaml/odoc#972](https://github.com/ocaml/odoc/pull/972)
- Collect occurrences information -- [ocaml/odoc#976](https://github.com/ocaml/odoc/pull/976)

### **[odoc]** Syntax for Images and Assets in `odoc`

Contributors: @panglesd (Tarides)

As part of the work to make `odoc` suitable to create rich manuals, the `odoc` team started working on adding special support for images and assets! This initiative will bring image support to OCaml.org's central package documentation.

In the upcoming weeks, the syntax and design will be discussed in [the RFC](https://github.com/ocaml/odoc/issues/985) that was open in July, with implementation set to begin as soon as there is a consensus on the design.

**Activities:**
- Implemented asset references (using the `asset-*` qualification in references), as well as their resolving (see [branch](https://github.com/panglesd/odoc/tree/asset-referencing)).
- Opened an issue to discuss the syntax for images, with an initial proposal. -- [ocaml/odoc#985](https://github.com/ocaml/odoc/issues/985)

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides), @let-def (Tarides)

This month, work on project-wide references focused on improving alias handling, fixing issues related to UID, and enhancing the behavior with modules and constructors.

Every Merlin test is now passing (:tada:!), so the team intends to focus on getting the compiler patches upstreamed, which will in turn unlock the upstreaming of the rest of the stack (i.e., Merlin, Dune, and OCaml LSP).

**Activities:**
- Compiler support for project-wide occurrences -- [voodoos/ocaml#1](https://github.com/voodoos/ocaml/pull/1)
- Use new compile information in CMT files to build and aggregate indexes -- [voodoos/ocaml-uideps#5](https://github.com/voodoos/ocaml-uideps/pull/5)
- Dune orchestrates index generation -- [voodoos/dune#1](https://github.com/voodoos/dune/pull/1)
- Use new CMT info to provide buffer occurrences and indexes for project-wide occurrences -- [voodoos/merlin#7](https://github.com/voodoos/merlin/pull/7)
- Support project-wide occurrences in `ocaml-lsp` -- [voodoos/ocaml-lsp#1](https://github.com/voodoos/ocaml-lsp/pull/1)

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag-ha (Tarides), @3Rafal (Tarides), @voodoos (Tarides), @let-def (Tarides)

Last month, we reported that the PR to [continuously benchmark Merlin](https://github.com/ocaml/merlin/pull/1640) was merged. The next stage involved implementing a fuzzy-testing PR to monitor behavior regression. In July, [an RFC](https://github.com/ocaml/merlin/pull/1657) of this behaviour regression CI, accompanied by an initial implementation, was introduced to discuss the design's trade-offs.

Upon merging, the foundational work on Merlin's CI system will be complete, and the Merlin team intends to shift their focus to performance optimisations.

**Activities:**
- Opened an RFC for the Behavior CIs -- [ocaml/merlin#1657](https://github.com/ocaml/merlin/pull/1657)
- Improved error discovery in `merl-an` -- [pitag-ha/merl-an#33](https://github.com/pitag-ha/merl-an/pull/33)
- Improved `merl-an` for the Behavior CIs
  - Add `-index 0` to type-enclosing cmd -- [pitag-ha/merl-an#30](https://github.com/pitag-ha/merl-an/pull/30)
  - Remove `-index 0` from locate cmd --[pitag-ha/merl-an#31](https://github.com/pitag-ha/merl-an/pull/31)
  - Improve the [behavior] cmd -- [pitag-ha/merl-an#34](https://github.com/pitag-ha/merl-an/pull/34)
  - Behavior cmd cat data -- [pitag-ha/merl-an#37](https://github.com/pitag-ha/merl-an/pull/37)
  - Allow only one Merlin version -- [pitag-ha/merl-an#40](https://github.com/pitag-ha/merl-an/pull/40)
  - Improve perf -- [pitag-ha/merl-an#41](https://github.com/pitag-ha/merl-an/pull/41)
