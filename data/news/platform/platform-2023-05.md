---
title: "Platform Newsletter: May 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-06-19"
tags: [platform]
---

Welcome to the second issue of the OCaml Platform newsletter!

We're excited to share the work we've done in May on improving OCaml developer experience with the [OCaml Platform](https://ocaml.org/docs/platform). Similar to the [previous update](https://discuss.ocaml.org/t/ocaml-platform-newsletter-april-2023/12187), this issue is structured around the development workflow we're currently exploring or improving.

The highlight of this month is the publication of the [work-in-progress roadmap for the OCaml Platform](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238). We published it to start gathering community feedback on the Design Principles and Persona of the Platform. The feedback will be used to establish our plans for the next three years. We've received tons of very insightful and constructive feedback already, and in the coming weeks and months, we'll revise the roadmap based on that feedback. As a next step, we'll share the first version of the proposed developer workflows.

Another important milestone this month is the release of [Dune 3.8](https://github.com/ocaml/dune/releases/tag/3.8.0). The release comes with support for compiling OCaml projects to JavaScript using Melange, which has seen its [first stable release](https://discuss.ocaml.org/t/ann-melange-1-0-compile-ocaml-reasonml-to-javascript/12305) this month! It also contains several important features and improvements that have been in the work for some time, like the new `concurrent` action and the composition of Coq rules.

As a last highlight, the first alpha of opam 2.2 is getting very close. There were some unexpected issues while preparing the release this month, but the opam team is still aiming for a release in June.

There's a lot of other very exciting work to talk about, so let's delve into it!

- [Releases](#releases)
- [Building Packages](#building-packages)
  - [**\[Dune\]** Exploring Package Management in Dune](#dune-exploring-package-management-in-dune)
  - [**\[opam\]** Native Support for Windows in opam 2.2](#opam-native-support-for-windows-in-opam-22)
  - [**\[Dune\]** Improving Dune's Documentation](#dune-improving-dunes-documentation)
  - [**\[Dune\]** Composing installed Coq theories](#dune-composing-installed-coq-theories)
  - [**\[Dune\]** Running Actions Concurrently](#dune-running-actions-concurrently)
  - [**\[Dune\]** Benchmarking Dune on Large Code Bases](#dune-benchmarking-dune-on-large-code-bases)
- [Compiling to JavaScript](#compiling-to-javascript)
  - [**\[Dune\]** Compile to JavaScript with Melange in Dune](#dune-compile-to-javascript-with-melange-in-dune)
- [Generating Documentation](#generating-documentation)
  - [**\[Odoc\]** Add Search Capabilities to `odoc`](#odoc-add-search-capabilities-to-odoc)
  - [**\[Odoc\]** Support for Tables in `odoc`](#odoc-support-for-tables-in-odoc)
- [Editing and Refactoring Code](#editing-and-refactoring-code)
  - [**\[Merlin\]** Support for Project-Wide References in Merlin](#merlin-support-for-project-wide-references-in-merlin)
  - [**\[Merlin\]** Improving Merlin's Performance](#merlin-improving-merlins-performance)
  - [**\[OCaml LSP\]** Using Dune RPC on Windows](#ocaml-lsp-using-dune-rpc-on-windows)
  - [**\[OCaml LSP\]** Upstreaming OCaml LSP's Fork of Merlin](#ocaml-lsp-upstreaming-ocaml-lsps-fork-of-merlin)
- [Formatting Code](#formatting-code)
  - [**\[OCamlFormat\]** Closing the Gap Between OCamlFormat and `ocp-indent`](#ocamlformat-closing-the-gap-between-ocamlformat-and-ocp-indent)

## Releases

Here are the new versions of Platform tools we released in April. Have a look at the [OCaml Changelog](https://ocaml.org/changelog) to read announcements and feature highlights!

- [Dune 3.8.0](https://github.com/ocaml/dune/releases/tag/3.8.0)
- [opam 2.1.5](https://github.com/ocaml/opam/releases/tag/2.1.5)
- [Merlin 4.9](https://github.com/ocaml/merlin/releases/tag/v4.9-500)

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides)

Explorations continue on adding package management support to Dune. This month progress has been made on several fronts:

- The work on the solver has been started, including vendoring the opam-0install solver for solving dependencies when generating Dune lockfiles. A work-in-progress implementation of lockfile generation is available on the `main` branch.
- The source tree handling has undergone a refactor to eventually allow multiple context-specific lockfiles.
- The source fetching implementation has seen improvements, including checksum handling and a better Fetch API. This results in a cleaner interface for building opam packages.
- Work continues on prototyping the building of opam packages, which includes the addition of new `Patch` and `Substitute` actions. This has increased the subset of opam packages that can now be built.

**Activities:**
- Merged the PR that added the ability to build opam packages -- [ocaml/dune#7626](https://github.com/ocaml/dune/pull/7626).
- Added safety mechanisms in lock directory regeneration -- [ocaml/dune#7832](https://github.com/ocaml/dune/pull/7832).
- Introduced feature to set environment in build rules -- [ocaml/dune#7742](https://github.com/ocaml/dune/pull/7742).
- Merge the PR that added conservative lockfile generation -- [ocaml/dune#7732](https://github.com/ocaml/dune/pull/7732).
- Simplified entries in cookie -- [ocaml/dune#7701](https://github.com/ocaml/dune/pull/7701).
- Fixed location handling for source copies -- [ocaml/dune#7697](https://github.com/ocaml/dune/pull/7697).
- Improved checksum handling -- [ocaml/dune#7696](https://github.com/ocaml/dune/pull/7696).
- Tested install action -- [ocaml/dune#7695](https://github.com/ocaml/dune/pull/7695).
- Versioned lock directory format -- [ocaml/dune#7693](https://github.com/ocaml/dune/pull/7693).
- Created a better API for fetch -- [ocaml/dune#7675](https://github.com/ocaml/dune/pull/7675).
- Vendored opam-0install -- [ocaml/dune#7668](https://github.com/ocaml/dune/pull/7668).
- Open a PR adding a feature to return the retrieved checksums on failure for checksum verification -- [ocaml/dune#5552](https://github.com/ocaml/opam/pull/5552).
- Carried out a refactor to allow passing in a custom runner to `OpamStd.Sys` -- [ocaml/dune#5549](https://github.com/ocaml/opam/pull/5549).

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @emillon (Tarides), @Leonidas-from-XIV (Tarides)

Throughout May, the opam team has focused on reviewing and fixing remaining PRs for the 2.2 alpha release. This effort debugged and resolved issues found during testing, and the team is now working through the handful PRs pending review.

A new release, opam 2.1.5 point release, has also been rolled out, backporting several fixes from the upcoming 2.2 release, and an important security fix. You can read the announcement on the [OCaml Changelog](https://ocaml.org/changelog?t=opam).

**Activities:**

- Installed cygwin internally during init -- [ocaml/opam#5545](https://github.com/ocaml/opam/pull/5545).
- Added cygwin support to depexts -- [ocaml/opam#5542](https://github.com/ocaml/opam/pull/5542).
- Implemented fully revertible environment updates -- [ocaml/opam#5417](https://github.com/ocaml/opam/pull/5417).
- Some windows shell updates -- [ocaml/opam#5541](https://github.com/ocaml/opam/pull/5541).
- Better cygwin support in core -- [ocaml/opam#5543](https://github.com/ocaml/opam/pull/5543).
- init: detect local cygwin installation -- [ocaml/opam#5544](https://github.com/ocaml/opam/pull/5544).
- init: install cygwin internally - [ocaml/opam#5545](https://github.com/ocaml/opam/pull/5545).
- Used OCaml code to copy/move/remove directories instead of unix commands -- [ocaml/opam#4823](https://github.com/ocaml/opam/pull/4823).
- Fix performance regression in opam install/remove/upgrade/reinstall -- [ocaml/opam#5503](https://github.com/ocaml/opam/pull/5503).


### **[Dune]** Improving Dune's Documentation

Contributors: @emillon (Tarides)

Two Dune libraries now have a documentation page on OCaml.org: both [dune-build-info](https://ocaml.org/p/dune-build-info/latest/doc/index.html) and [dune-configurator](https://ocaml.org/p/dune-configurator/latest/doc/index.html) now have their API documentation directly on their package page, and for Dune itself, a link to its official documentation has been included.

A new `action:` directive has been added to the Dune Sphinx domain, allowing for improved cross-referencing. Finally, the old `.org` format Dune example docs have been converted to Markdown to standardize the documentation format further.

The improvements to the documentation have been published as part of the Dune 3.8 release. The new structure and many improvements can be viewed on [Dune documentation](https://dune.readthedocs.io/en/stable/).

**Activities:**
- Placed uncategorized pages under the most appropriate header -- [ocaml/dune#7683](https://github.com/ocaml/dune/pull/7683).
- Converted README.org in example to markdown -- [ocaml/dune#7738](https://github.com/ocaml/dune/pull/7738).
- Added API documentation for dune-build-info -- [ocaml/dune#7739](https://github.com/ocaml/dune/pull/7739).
- Directed readers to the official docs in odoc -- [ocaml/dune#7746](https://github.com/ocaml/dune/pull/7746).
- Added an odoc index for configurator -- [ocaml/dune#7749](https://github.com/ocaml/dune/pull/7749).
- Corrected the documentation for `(map_workspace_root)` -- [ocaml/dune#7775](https://github.com/ocaml/dune/pull/7775).
- Expanded actions documentation with a special directive -- [ocaml/dune#7804](https://github.com/ocaml/dune/pull/7804).

### **[Dune]** Composing installed Coq theories

Contributors: @Alizter and @ejgallego (IRIF)

Last month, the PR that brings [support for composing Coq theories with Dune](https://github.com/ocaml/dune/pull/7047) was merged.

This is now available in the release of Dune 3.8.0! From this point onwards, Coq users can utilize Dune to build Coq projects even if they depend on Coq projects that use other build systems!

### **[Dune]** Running Actions Concurrently

Contributors: @Alizter and @hhugo (Nomadic Labs)

Last month, a couple of PRs were merged into Dune to [add a new concurrent action](https://github.com/ocaml/dune/pull/6933) and it was utilized to [run inline tests concurrently](https://github.com/ocaml/dune/pull/7012).

These patches are part of Dune 3.8.0 release, starting now, you can use the new `concurrent` action in your Dune rules:

```
(rule
 (action
  (concurrent
   (run <prog> <args>)
   (run <prog> <args>))))
```

### **[Dune]** Benchmarking Dune on Large Code Bases

Contributors: @gridbugs (Tarides), @Leonidas-from-XIV (Tarides)

The quality of the dune benchmark results has been improved, averaging out the variance seen in short tests by running them multiple times. This enhancement aims to reduce the effect of the background noise inherent in the environment.

The dune benchmarks also exposed two broken packages: the hash of [ppx_rapper (3.1.0)](https://ocaml.org/p/ppx_rapper/3.1.0) artefact has been updated as it had changed in place, and [ocamlcodoc](https://ocaml.org/p/ocamlcodoc/latest) artefacts have been added to the [opam-source-archives](https://github.com/ocaml/opam-source-archives) as the original URL is no longer reachable.

Moreover, a stack overflow in `dune-rpc-lwt` exposed by the benchmarks has been fixed.

**Activities:**
- Ran short monorepo benchmarks multiple times -- [ocaml/dune#7798](https://github.com/ocaml/dune/pull/7798).
- Fixed issues in monorepo benchmarks -- [ocaml/dune#7786](https://github.com/ocaml/dune/pull/7786).
- [Added](https://github.com/ocaml/opam-source-archives/pull/21) ocamlcodoc to opam-source-archives and [updated](https://github.com/ocaml/opam-repository/pull/23801) opam-repository.
- Opened an [issue](https://github.com/roddyyaga/ppx_rapper/issues/34) about `ppx_rapper.3.1.0` package changing in place.

## Compiling to JavaScript

### **[Dune]** Compile to JavaScript with Melange in Dune

Contributors: @anmonteiro, @jchavarri (Ahrefs), @rgrinberg (Tarides)

We're thrilled to see the joint release of Dune 3.8.0 and [Melange 1.0](https://discuss.ocaml.org/t/ann-melange-1-0-compile-ocaml-reasonml-to-javascript/12305) this month!

[Melange](https://github.com/melange-re/melange) is a compiler from OCaml to JavaScript with the vision of maintaining compatibility with OCaml and providing the best OCaml experience within the modern JavaScript ecosystem.

Have a look at the [Dune documentation](https://dune.readthedocs.io/en/latest/melange.html) and [Melange documentation](https://melange.re/v1.0.0/) to learn how to get started using Melange to compile your OCaml projects to JavaScript.

You can also refer to the [template](https://github.com/melange-re/melange-opam-template) to get started.

## Generating Documentation

### **[Odoc]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @trefis (Tarides)

The odoc team is making steady progress on adding a search bar to odoc's generated documentation.

In May, an interface for interaction between odoc and search engines was designed. [Sherlodoc](https://doc.sherlocode.com/), which can now run in the browser, was updated to use the new interface exposed by odoc. Improvements were also made to `sherlodoc` itself to enable searching for constructors and record fields, as well as in docstrings. The larger database from all this extra indexing prompted work on profiling it and implementing optimizations.

Anticipating the June update, the [odoc PR](https://github.com/ocaml/odoc/pull/972) that was open a few days ago can be checked out.

In parallel, a [working prototype](https://github.com/panglesd/odoc/tree/occurrences-in-odoc) of counting occurrences in odoc was developed. The aim is to add usage statistics in the generated index, so that search engines can use it to sort search results. It will also allow for a "jump-to-documentation" feature in the [rendered source code](https://github.com/ocaml/odoc/pull/909) that was merged in March.

### **[Odoc]** Support for Tables in `odoc`

Contributors: @gpetiot (Tarides), @panglesd (Tarides), @Julow (Tarides), @jonludlam (Tarides), @trefis (Tarides)

The PRs adding support for a new syntax to create tables in Odoc have been merged!

As a reminder, this new feature will enable the creation of tables using a syntax similar to Markdown:
```
{t
  a  | b | c | d
  ---|:--|--:|:-:
  a  | b | c | d
}
```

Odoc will generate tables for different backends, including LaTex and HTML. This new syntax will be available in the upcoming release of Odoc 2.3.0. Stay tuned!

**Activities:**
- Merged the PR that adds a new syntax for tables in odoc-parser -- [ocaml-doc/odoc-parser#11](https://github.com/ocaml-doc/odoc-parser/pull/11)
- Merged the PR that adds support for tables to odoc -- [ocaml/odoc#893](https://github.com/ocaml/odoc/pull/893)

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides), @let-def (Tarides)

Not much progress was made on the support for project-wide occurrences in Merlin this month due to the Merlin team's focus on performance improvements, fixing user-reported bugs, compatibility with OCaml 5.1, and the release of Merlin 4.9

The remaining issues, such as module aliases traversal and index filtering, were discussed, with the implementation of identified solutions set to commence soon.

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag-ha (Tarides), @3Rafal (Tarides), @voodoos (Tarides), @let-def (Tarides)

The final stages of work on benchmarking Merlin are in progress, with the Merlin team focusing on integrating the developed benchmarking tooling into Merlin's CI using `current-bench`. The [PR](https://github.com/pitag-ha/merl-an/pull/2) on `merl-an` has been opened to add a new current-bench compatible backend and work has started on adding memory usage information to Merlin's telemetry.

On the performance optimisations front, the PPX phase cache in Merlin was completed and merged. Issues were opened upstream on how tools that use Merlin can benefit from the new PPX cache.

**Activities:**
- Implemented a sketch of `current-bench` backend in `merl-an` -- [pitag-ha/merl-an#2](https://github.com/pitag-ha/merl-an/pull/2).
- Started work on adding memory usage information to Merlin's telemetry.
- Completed and merged the PPX phase cache PR -- [ocaml/merlin#1584](https://github.com/ocaml/merlin/pull/1584).
- Opened issues at `dune` and `ocaml-lsp-server` to keep record of the necessities to enable the PPX phase cache
  - In Dune: `dune ocaml-merlin`: enable PPX phase cache -- [ocaml/dune#7731](https://github.com/ocaml/dune/issues/7731).
  - In OCaml LSP: Handle Merlin's PPX phase cache -- [ocaml/ocaml-lsp#1095](https://github.com/ocaml/ocaml-lsp/issues/1095).
- Identified and fixed a memory "leak" related to the `(F A).t` syntax, causing uncontrolled memoization table growth -- [ocaml/merlin#1609](https://github.com/ocaml/merlin/pull/1609).

### **[OCaml LSP]** Using Dune RPC on Windows

Contributors: @nojb (LexiFi)

In May, a couple of patches that build on the [support for watch mode on Windows](https://github.com/ocaml/dune/pull/7010) introduced in Dune 3.7.0 were merged in [Dune](https://github.com/ocaml/dune/pull/7666) and [OCaml LSP](https://github.com/ocaml/ocaml-lsp/pull/1079) to allow OCaml LSP to use Dune RPC. The aim is to enable Windows users to leverage Dune RPC and receive build statuses and more exhaustive build errors in the editor when Dune is running in watch mode.

Dune 3.8.0 was released with the above patches and a release of OCaml LSP will follow in the coming weeks.

### **[OCaml LSP]** Upstreaming OCaml LSP's Fork of Merlin

Contributors: @voodoos (Tarides), @3Rafal (Tarides)

The effort to upstream OCaml LSP's fork of merlin continued. Necessary patches in Merlin have been reviewed and merged. Work also continued on the PR to use Merlin as a library in OCaml LSP.

**Activities:**
- Reviewed and merged the PR enabling configurable Merlin PP/PPX spawning -- [ocaml/merlin#1585](https://github.com/ocaml/merlin/pull/1585).
- Continued working on the PR to use Merlin as a library in LSP -- [ocaml/ocaml-lsp#1070](https://github.com/ocaml/ocaml-lsp/pull/1070).

## Formatting Code

### **[OCamlFormat]** Closing the Gap Between OCamlFormat and `ocp-indent`

Contributors: @gpetiot (Tarides) and @EmileTrotignon (Tarides), @Julow (Tarides), @ceastlund (Jane Street)

The effort continued to tune the `janestreet` profile so that it aligns better with the output of `ocp-indent`. Despite encountering difficulties with formatting "cinaps" comments, considerable progress was made in May and work will continue throughout June.

**Activities:**
- Align pattern alias -- [ocaml-ppx/ocamlformat#2359](https://github.com/ocaml-ppx/ocamlformat/pull/2359)
- Dock `fun`/`function` only if it starts on the first line of the apply -- [ocaml-ppx/ocamlformat#2362](https://github.com/ocaml-ppx/ocamlformat/pull/2362)
- Align module arguments -- [ocaml-ppx/ocamlformat#2363](https://github.com/ocaml-ppx/ocamlformat/pull/2363)
- Remove extra newline in empty comments -- [ocaml-ppx/ocamlformat#2365](https://github.com/ocaml-ppx/ocamlformat/pull/2365)
