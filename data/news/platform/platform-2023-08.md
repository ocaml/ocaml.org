---
title: "Platform Newsletter: August 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-09-22"
tags: [platform]
---

Welcome to the fifth edition of the OCaml Platform newsletter!

Dive into the latest updates from August and discover how the [OCaml Platform](https://ocaml.org/docs/platform) is evolving. Just like our [previous newsletters](https://discuss.ocaml.org/tag/platform-newsletter), we'll spotlight the recent developments and enhancements to the OCaml development workflows.

In August, we unveiled the [initial draft of the OCaml Platform roadmap](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238/30), following the recently adopted [Guiding Principles](https://ocaml.org/docs/platform-principles) and [User Personas](https://ocaml.org/docs/platform-users). The thread has seen a lot of activity, and we're thrilled to see so much engagement to discuss the direction of OCaml developer tooling. A warm thank you for actively joining the conversation and sharing your feedback! This has prompted numerous discussions with the Platform maintainers, and we're considering all your feedback as we're working on revisions to the roadmap.

Another headline from August was initiating the integration of `wasm_of_ocaml` into Dune in order to compile OCaml programs to WebAssembly (Wasm). This follows the recent [announcement of the `ocaml-wasm` organisation](https://discuss.ocaml.org/t/announcing-the-ocaml-wasm-organisation/12676). This is an exciting time! Compiling OCaml programs to WebAssembly is becoming a reality!

But more on that below. Let's delve into all the progress that happened last month.

- [Releases](#releases)
- [Building Packages](#building-packages)
  - [**\[Dune\]** Exploring Package Management in Dune](#dune-exploring-package-management-in-dune)
  - [**\[opam\]** Native Support for Windows in opam 2.2](#opam-native-support-for-windows-in-opam-22)
  - [**\[Dune\]** Compile to WebAssembly with `wasm_of_ocaml`](#dune-compile-to-webassembly-with-wasm_of_ocaml)
  - [**\[Dune\]** `dune monitor`: Connect to a Running Dune build](#dune-dune-monitor-connect-to-a-running-dune-build)
  - [**\[Dune\]** Dune Terminal User Interface](#dune-dune-terminal-user-interface)
- [Generating Documentation](#generating-documentation)
  - [**\[odoc\]** Add Search Capabilities to `odoc`](#odoc-add-search-capabilities-to-odoc)
  - [**\[`odoc`\]** Syntax for Images and Assets in `odoc`](#odoc-syntax-for-images-and-assets-in-odoc)
- [Editing and Refactoring Code](#editing-and-refactoring-code)
  - [**\[Merlin\]** Support for Project-Wide References in Merlin](#merlin-support-for-project-wide-references-in-merlin)

## Releases

Here are all the new versions of Platform tools that were released this month:

- [Dune 3.10.0](https://ocaml.org/changelog/2023-07-31-dune-3.10.0)
- [`odoc` 2.2.1](https://ocaml.org/changelog/2023-08-08-odoc-2.2.1)
- [Merlin 4.10](https://ocaml.org/changelog/2023-08-29-merlin-4.10)

For detailed release notes and announcements, explore the [OCaml Changelog](https://ocaml.org/changelog).


## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

This month saw good progress on supporting lock directory generation for more opam packages by adding support for various opam features. Notably, the team implemented a new [`when` action](https://github.com/ocaml/dune/pull/8443) to support opam's conditional build steps and the accompanying PR to [convert opam filters to `when` actions](https://github.com/ocaml/dune/pull/8502).

Work also started on [initialising Dune's context from the lock file](https://github.com/ocaml/dune/issues/7707). This is the last missing piece that ties all the implemented features together (source fetching, opam-repository management, lock directory generation, etc.). This makes it possible to run `dune build` to build a project that has opam dependencies.

The work on the above -- extending coverage of opam packages when generating the lock directory and initialisation of Dune's context from the lock directory -- should continue next month. The team also started tracking missing features in Dune's backlog more thoroughly. You can have a look at the [list of issues on GitHub](https://github.com/ocaml/dune/issues?q=is%3Aissue+is%3Aopen+label%3A%22package+management%22).

**Activities:**
- Macros can take multiple arguments [ocaml/dune#8353](https://github.com/ocaml/dune/pull/8353)
- Use `%{pkg:...}` macro for package vars -- [ocaml/dune#8372](https://github.com/ocaml/dune/pull/8372)
- Start copying commands from opam files -- [ocaml/dune#8336](https://github.com/ocaml/dune/pull/8336)
- Test that the `0install` solver can resolve `|` dependencies correctly -- [ocaml/dune#8363](https://github.com/ocaml/dune/pull/8363)
- Variable interpolations in opam commands -- [ocaml/dune#8391](https://github.com/ocaml/dune/pull/8391)
- Concise pkg macro -- [ocaml/dune#8399](https://github.com/ocaml/dune/pull/8399)
- Write identifier of repository into metadata -- [ocaml/dune#8414](https://github.com/ocaml/dune/pull/8414)
- Add `when` action available in lock files -- [ocaml/dune#8443](https://github.com/ocaml/dune/pull/8443)
- Add `run-with-conditional-terms` action -- [ocaml/dune#8486](https://github.com/ocaml/dune/pull/8486)
- Convert opam command filters to Dune blangs -- [ocaml/dune#8502](https://github.com/ocaml/dune/pull/8502)
- Upstreaming to opam
  - `OpamFilter` file substitutions with source & destination -- [ocaml/opam](https://github.com/ocaml/opam/pull/5629)
  - Expose string_interp_regex [ocaml/opam#5633](https://github.com/ocaml/opam/pull/5633)

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

Following the release of the [second alpha of opam 2.2](https://ocaml.org/changelog/2023-07-26-opam-2-2-0-alpha2) last month, the opam team started working on the third alpha and merged [numerous bug fixes and improvements](https://github.com/ocaml/opam/milestone/53?closed=1).

They also started working on [generating static binaries for Windows](https://github.com/ocaml/opam/issues/5647).

The next step, in anticipation to the first beta release of opam 2.2, is to make the `opam-repository` compatible with Windows by upstreaming patches from [ocaml-opam/opam-repository-mingw](https://github.com/ocaml-opam/opam-repository-mingw) and [dra27/opam-repository](https://github.com/dra27/opam-repository).

The work on this will continue next month, but in the meantime, don't hesitate to [install opam 2.2~alpha2](https://ocaml.org/changelog/2023-07-26-opam-2-2-0-alpha2#try-it) and report any issue you have!

### **[Dune]** Compile to WebAssembly with `wasm_of_ocaml`

Contributors: @vouillon (Tarides), @hhugo

Following the recent [announcement of the ocaml-wasm organisation](https://discuss.ocaml.org/t/announcing-the-ocaml-wasm-organisation/12676), the [`wasm_of_ocaml`](https://github.com/ocaml-wasm/wasm_of_ocaml) team landed a [PR on Dune](https://github.com/ocaml/dune/pull/8278) that brings support for compiling OCaml programs to WebAssembly (Wasm)!

The target user experience will be similar to the JavaScript compilation on Dune; that is, you'll be able to add `wasm` as a mode to Dune executables:

```
(executable (name foo) (modes wasm))
```

And running `dune build` will produce a Wasm binary.

The PR is in the early stage and is in active review, but given the impressive progress of the `wasm_of_ocaml` team on the [runtime implementation](https://github.com/ocaml-wasm/wasm_of_ocaml/issues/5), do stay tuned for more updates on this in the coming weeks and months.

**Activities:**
- `wasm_of_ocaml` support -- [ocaml/dune#8278](https://github.com/ocaml/dune/pull/8278)

### **[Dune]** `dune monitor`: Connect to a Running Dune build

Contributors: @Alizter

In July, @Alizter started work on a new `dune monitor` command to connect to a running Dune build.

This work continued this month, and as part it, lots of improvements were made to Dune RPC, including [reports of failed jobs](https://github.com/ocaml/dune/pull/8212) and [better error messages](https://github.com/ocaml/dune/pull/8191).

[The PR](https://github.com/ocaml/dune/pull/8152) has been merged and the new command will be available in the upcoming Dune 3.11, scheduled for September.

**Activities:**
- Dune monitor -- [ocaml/dune#8152](https://github.com/ocaml/dune/pull/8152)

### **[Dune]** Dune Terminal User Interface

Contributors: @Alizter, @rgrinberg (Tarides)

[Back in April](https://discuss.ocaml.org/t/ocaml-platform-newsletter-april-2023/12187#dune-dune-terminal-user-interface-7), Dune introduced a new `tui` display mode, contributed by @Alizter, which was a meant as a foundation to bring a GUI-like experience to Dune.

The saga continued in August, and @Alizter ported the TUI to [Nottui](https://github.com/let-def/lwd), a terminal-based user interface library, to add more interactivity to the `tui` mode. In particular, the error messages are now scrollable, and they can be expanded/minimised. 

<video width="100%" height="100%" controls="">
  <source src="https://user-images.githubusercontent.com/8614547/262112028-a367f7ca-023f-4470-a02a-a19617aa35f6.webm">
  <a href="https://user-images.githubusercontent.com/8614547/262112028-a367f7ca-023f-4470-a02a-a19617aa35f6.webm" rel="nofollow noopener">https://user-images.githubusercontent.com/8614547/262112028-a367f7ca-023f-4470-a02a-a19617aa35f6.webm</a>
</video>

These features will be available in the upcoming Dune 3.11. Do try the new TUI and let the Dune team know if you have any feedback!

**Activities**:
- Interactive TUI -- [ocaml/dune#8429](https://github.com/ocaml/dune/pull/8429)

## Generating Documentation

### **[odoc]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

After fixing some of the issues identified last month, the `odoc` team started actively reviewing the Pull Request to [add a search bar to `odoc`'s HTML output](https://github.com/ocaml/odoc/pull/972).

As a result of the reviews, a few related issues were identified and have been addressed as a prerequisite to move forward on the search feature. Notably, improvements were needed on the stability of [link to source code](https://github.com/ocaml/odoc/pull/909) by [implementing semantic anchors](https://github.com/ocaml/odoc/pull/993).

Next month, the odoc team plans to continue reviewing the different Pull Requests, with the aim to cut a major release of odoc with support for search the following weeks.

**Activities:**
- Support for search in `odoc` -- [ocaml/odoc#972](https://github.com/ocaml/odoc/pull/972)
- Collect occurrences information -- [ocaml/odoc#976](https://github.com/ocaml/odoc/pull/976)
- Stable anchors in links to implementation -- [ocaml/odoc#993](https://github.com/ocaml/odoc/pull/993)

### **[`odoc`]** Syntax for Images and Assets in `odoc`

Contributors: @panglesd (Tarides)

Following the discussion started in July, the `odoc` team started the implementation work to add support for images and assets in `odoc`.

Work is ongoing to implement a syntax to reference arbitrary assets, as a requirement to both the search feature and the support for images.

We're getting closer and closer to having images on OCaml.org's centralised package documentation!

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides), @trefis (Tarides), @Ekdohibs (OcamlPro)

As announced last month, the focus in August was on upstreaming the necessary changes to the compiler. A [PR on the compiler](https://github.com/ocaml/ocaml/pull/12508) was opened and is currently under active review. The Merlin team is hopeful that it will be merged in time for the next release of OCaml 5.2.

The team is also considering backporting the patches on previous versions of the compiler and making them available on opam. This would allow people to start testing the feature early, without having to wait for the release of OCaml 5.2.

**Activities:**
- Add support for project-wide occurrences -- [ocaml/ocaml#12508](https://github.com/ocaml/ocaml/pull/12508)
- Use new compile information in CMT files to build and aggregate indexes -- [voodoos/ocaml-uideps#5](https://github.com/voodoos/ocaml-uideps/pull/5)
- Dune orchestrates index generation -- [voodoos/dune#1](https://github.com/voodoos/dune/pull/1)
- Use new CMT info to provide buffer occurrences and indexes for project-wide occurrences -- [voodoos/merlin#7](https://github.com/voodoos/merlin/pull/7)
- Support project-wide occurrences in `ocaml-lsp` -- [voodoos/ocaml-lsp#1](https://github.com/voodoos/ocaml-lsp/pull/1)
