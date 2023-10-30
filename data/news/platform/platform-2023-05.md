---
title: "Platform Newsletter: May 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-06-19"
tags: [platform]
---

Welcome to the second issue of the OCaml Platform newsletter!

We're excited to share the work we've done in May on improving OCaml developer experience with the [OCaml Platform](https://ocaml.org/docs/platform). Similar to the [previous update](https://discuss.ocaml.org/t/ocaml-platform-newsletter-april-2023/12187), this issue is structured around the development workflow we're currently exploring or improving.

The highlight of this month is the publication of the [work-in-progress roadmap for the OCaml Platform](https://discuss.ocaml.org/t/a-roadmap-for-the-ocaml-platform-seeking-your-feedback/12238). We published it to start gathering community feedback on the Design Principles and Persona of the Platform, which will be used to inform our plans for the next three years. We've received tons of very insightful and constructive feedback, and in the coming weeks and months, we'll revise the roadmap based on the feedback received. As a next step, we'll share a first version of the proposed developer workflows for feedback.

Another important milestone this month is the release of [Dune 3.8](https://github.com/ocaml/dune/releases/tag/3.8.0). The release comes with support for compiling OCaml project to JavaScript using Melange, which has seen its [first stable release](https://discuss.ocaml.org/t/ann-melange-1-0-compile-ocaml-reasonml-to-javascript/12305) this month! It also contains several important features and improvements that have been in the work for some time, like the new `concurrent` action and the composition of Coq rules.

As a last highlight, we're getting very close to the first alpha release of opam 2.2. As things go, we encountered some unexpected issues while preparing the release this month, but we're aiming for a release in June.

There's a lot of other very exciting work to talk about, so let's delve into it!

[toc]

## Releases

Here are the new versions of Platform tools we released in April. Have a look at the [OCaml Changelog](https://ocaml.org/changelog) to read announcements and feature highlights!

- [Dune 3.8.0](https://github.com/ocaml/dune/releases/tag/3.8.0)
- [opam 2.1.5](https://github.com/ocaml/opam/releases/tag/2.1.5)
- [Merlin 4.9](https://github.com/ocaml/merlin/releases/tag/v4.9-500)

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides)

We continue our explorations on adding the package management support to Dune. This month we made progress on several fronts:

- We've started the work on the solver, including vendoring the `opam-0install` solver for solving dependencies when generating Dune lock files, and we now have a WIP implementation of lock file generation.
- The source tree handling has been refactored to allow us to have multiple context-specific lock files eventually.
- We've improved the source fetching implementation, including checksum handling and a better Fetch API, allowing for a cleaner interface to building opam packages.
- We've continued the work on prototyping building opam packages, including adding new `Patch` and `Substitute` actions, increasing the subset of opam packages we can now build.

**Activities:**
- Merged the PR that added the ability to build opam packages -- [ocaml/dune#7626](https://github.com/ocaml/dune/pull/7626).
- Added safety mechanisms in lock directory regeneration -- [ocaml/dune#7832](https://github.com/ocaml/dune/pull/7832).
- Introduced feature to set environment in build rules -- [ocaml/dune#7742](https://github.com/ocaml/dune/pull/7742).
- Merge the PR that added conservative lock file generation -- [ocaml/dune#7732](https://github.com/ocaml/dune/pull/7732).
- Simplified entries in cookie -- [ocaml/dune#7701](https://github.com/ocaml/dune/pull/7701).
- Fixed location handling for source copies -- [ocaml/dune#7697](https://github.com/ocaml/dune/pull/7697).
- Improved checksum handling -- [ocaml/dune#7696](https://github.com/ocaml/dune/pull/7696).
- Tested install action -- [ocaml/dune#7695](https://github.com/ocaml/dune/pull/7695).
- Versioned lock directory format -- [ocaml/dune#7693](https://github.com/ocaml/dune/pull/7693).
- Created a better API for fetch -- [ocaml/dune#7675](https://github.com/ocaml/dune/pull/7675).
- Vendored `opam-0install` -- [ocaml/dune#7668](https://github.com/ocaml/dune/pull/7668).
- Open a PR adding a feature to return the retrieved checksums on failure for checksum verification -- [ocaml/dune#5552](https://github.com/ocaml/opam/pull/5552).
- Carried out a refactor to allow passing in a custom runner to `OpamStd.Sys` -- [ocaml/dune#5549](https://github.com/ocaml/opam/pull/5549).

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @emillon (Tarides), @Leonidas-from-XIV (Tarides)

Throughout May the opam team has been reviewing and fixing the remaining PRs for the 2.2 alpha release. These debugged and solves some issues we found while testing and we are now working through the handful PRs pending review.

We've also released opam 2.1.5 point release, backporting several fixes from the upcoming 2.2 release.

**Activities:**
- Prevented unnecessary computation of depexts when sets are empty -- [ocaml/opam#5548](https://github.com/ocaml/opam/pull/5548).
- Installed Cygwin internally during init -- [ocaml/opam#5545](https://github.com/ocaml/opam/pull/5545).
- Added Cygwin support to depexts -- [ocaml/opam#5542](https://github.com/ocaml/opam/pull/5542).
- Fixed `opam init` menu default -- [ocaml/opam#5540](https://github.com/ocaml/opam/pull/5540).
- Added missing configure vendored deps flag on cache scripts in GHA -- [ocaml/opam#5539](https://github.com/ocaml/opam/pull/5539).
- Fixed opam installing packages without checking their checksum when the local cache is corrupted -- [ocaml/opam#5538](https://github.com/ocaml/opam/pull/5538).
- Ensured all make targets are run serially -- [ocaml/opam#5532](https://github.com/ocaml/opam/pull/5532).
- Prohibited silent disabling of MCCS if a C++ compiler is not present -- [ocaml/opam#5527](https://github.com/ocaml/opam/pull/5527).
- Moved the `.ocamlinit` script out of the root directory -- [ocaml/opam#5526](https://github.com/ocaml/opam/pull/5526).
- Documented that `?` evaluates to true if defined -- [ocaml/opam#5512](https://github.com/ocaml/opam/pull/5512).
- Changed shell setup default to true in init -- [ocaml/opam#5456](https://github.com/ocaml/opam/pull/5456).
- Stopped using MV and switched to Robocopy on Windows -- [ocaml/opam#5438](https://github.com/ocaml/opam/pull/5438).
- Implemented fully revertible environment updates -- [ocaml/opam#5417](https://github.com/ocaml/opam/pull/5417).
- Used OCaml code to copy/move/remove directories instead of Unix commands -- [ocaml/opam#4823](https://github.com/ocaml/opam/pull/4823).
- [Released opam 2.1.5](https://discuss.ocaml.org/t/ann-opam-2-1-5-release/12290) with backported fixes from opam 2.2.

### **[Dune]** Improving Dune's Documentation

Contributors: @emillon (Tarides)

This month, we've dedicated some time to improving our documentation integration on OCaml.org. Both [`dune-build-info`](https://ocaml.org/p/dune-build-info/latest/doc/index.html) and [`dune-configurator`](https://ocaml.org/p/dune-configurator/latest/doc/index.html) now have their API documentation directly on their package page, and for Dune, we have included a link to its official documentation. We've added a new `action:` directive to the Dune Sphinx domain, which will allow for improved cross-referencing. Finally, we have converted the old `.org` format Dune example docs to Markdown to standardise the documentation format further.

The improvements on the documentation have been published as part of the Dune 3.8 release, you can check out the new structure and the many improvements at https://dune.readthedocs.io/en/stable/.

**Activities:**
- Placed uncategorised pages under the most appropriate header -- [ocaml/dune#7683](https://github.com/ocaml/dune/pull/7683).
- Converted README.org in example to Markdown -- [ocaml/dune#7738](https://github.com/ocaml/dune/pull/7738).
- Added API documentation for `dune-build-info` -- [ocaml/dune#7739](https://github.com/ocaml/dune/pull/7739).
- Directed readers to the official docs in `odoc` -- [ocaml/dune#7746](https://github.com/ocaml/dune/pull/7746).
- Added an `odoc` index for configurator -- [ocaml/dune#7749](https://github.com/ocaml/dune/pull/7749).
- Corrected the documentation for `(map_workspace_root)` -- [ocaml/dune#7775](https://github.com/ocaml/dune/pull/7775).
- Expanded actions documentation with a special directive -- [ocaml/dune#7804](https://github.com/ocaml/dune/pull/7804).


### **[Dune]** Composing installed Coq theories

Contributors: @Alizter and @ejgallego (IRIF)

Last month, we merged the PR that brings [support for composing Coq theories with Dune](https://github.com/ocaml/dune/pull/7047).

This is now available in the release of Dune 3.8.0! Starting now, Coq users can use Dune to build Coq projects even if they depend on Coq projects that use other build systems!


### **[Dune]** Running Actions Concurrently

Contributors: @Alizter and @hhugo (Nomadic Labs)

Last month, we merged a couple of PR in Dune to [add a new `(concurrent )` action](https://github.com/ocaml/dune/pull/6933) and used it to [run inline tests concurrently](https://github.com/ocaml/dune/pull/7012).

These patches are part of Dune 3.8.0 release, starting now, you can use the new `(concurrent )` action in your Dune rules:

```
(rule
 (action
  (concurrent
   (run <prog> <args>)
   (run <prog> <args>))))
```

### **[Dune]** Benchmarking Dune on Large Code Bases

Contributors: @gridbugs (Tarides), @Leonidas-from-XIV (Tarides)

We've improved the quality of the Dune benchmark results, averaging out the variance seen in short tests by running them multiple times. This should reduce the effect of the background noise inherent in the environment.

The Dune benchmarks also exposed two broken packages: We've updated the hash of the [`ppx_rapper` (3.1.0)](https://ocaml.org/p/ppx_rapper/3.1.0) artifact that had changed in place, and [`ocamlcodoc`](https://ocaml.org/p/ocamlcodoc/latest) artifacts have been added to the `opam-source-archives`, as the original URL is no longer reachable.

The benchmarks also exposed a stack overflow in `dune-rpc-lwt` which has now been fixed.

**Activities:**
- Ran short `monorepo` benchmarks multiple times -- [ocaml/dune#7798](https://github.com/ocaml/dune/pull/7798).
- Fixed issues in `monorepo` benchmarks -- [ocaml/dune#7786](https://github.com/ocaml/dune/pull/7786).
- [Added](https://github.com/ocaml/opam-source-archives/pull/21) `ocamlcodoc` to `opam-source-archives` and [updated](https://github.com/ocaml/opam-repository/pull/23801) `opam-repository`.
- Opened an [issue](https://github.com/roddyyaga/ppx_rapper/issues/34) about the `ppx_rapper.3.1.0` package changing in place.

## Compiling to JavaScript

### **[Dune]** Compile to JavaScript with Melange in Dune

Contributors: @anmonteiro, @jchavarri (Ahrefs), @rgrinberg (Tarides)

We're thrilled to see the the joint release of Dune 3.8.0 and [Melange 1.0](https://discuss.ocaml.org/t/ann-melange-1-0-compile-ocaml-reasonml-to-javascript/12305) this month!

[Melange](https://github.com/melange-re/melange) is a compiler from OCaml to JavaScript with the vision of maintaining compatibility with OCaml and providing the best OCaml experience within the modern JavaScript ecosystem.

Have a look at the [Dune documentation](https://dune.readthedocs.io/en/latest/melange.html) and [Melange documentation](https://melange.re/v1.0.0/) to learn how to get started using Melange to compile your OCaml projects to JavaScript.

You can also refer to the [template](https://github.com/melange-re/melange-opam-template) to get started.

## Generating Documentation

### **[`odoc`]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @trefis (Tarides)

We continued our work to add a search bar to `odoc`'s generated documentation.

In May, we designed an interface for interaction between `odoc` and search engines. We updated [Sherlodoc](https://doc.sherlocode.com/), which can now run in the browser, to use the new interface exposed by `odoc`. We also made improvements to Sherlodoc itself to enable searching for constructors and record fields, as well as in docstrings. With all this extra indexing its database got quite a lot bigger, which prompted us to work profiling it and implementing optimisations.

Anticipating on the June update, you can have a look at the [`odoc` PR](https://github.com/ocaml/odoc/pull/972) that was open a few days ago.

Concurrently, we have a [working prototype](https://github.com/panglesd/odoc/tree/occurrences-in-odoc) of counting occurences in `odoc`. The objective is to add usage statistics in the generated index, so search engines can use it to sort search results. It will also allow us to implement a "jump-to-documentation" in the [rendered source code](https://github.com/ocaml/odoc/pull/909) that was merged in March.

### **[`odoc`]** Support for Tables in `odoc`

Contributors: @gpetiot (Tarides), @panglesd (Tarides), @Julow (Tarides), @jonludlam (Tarides), @trefis (Tarides)

We've merged the PRs that add support for a new syntax to create tables in `odoc`!

As a reminder, this will allow you to create tables using a syntax similar to Markdown:

```
{t
  a  | b | c | d
  ---|:--|--:|:-:
  a  | b | c | d
}
```

And `odoc` will generate tables for the different backends, including LaTex and HTML. The new syntax will be available in the upcoming release of `odoc` 2.3.0. Stay tuned!

**Activities:**
- Merged the PR that adds a new syntax for tables in `odoc-parser` -- [ocaml-doc/odoc-parser#11](https://github.com/ocaml-doc/odoc-parser/pull/11)
- Merged the PR that adds support for tables to `odoc` -- [ocaml/odoc#893](https://github.com/ocaml/odoc/pull/893)

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides), @let-def (Tarides)

Not much progress on the support for project-wide occurences in Merlin this month, as the Merlin team focussed on performance improvements, fixing user-reported bugs, compatibility with OCaml 5.1, and the release of Merlin 4.9

We still discussed the remaining issues that need to be addressed, namely module aliases traversal and index filtering, and we'll work on implementing the solutions we identified next.

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag-ha (Tarides), @3Rafal (Tarides), @voodoos (Tarides), @let-def (Tarides)

We're at the finish line of the work on benchmarking Merlin, and we focussed on integrating the benchmarking tooling we developed into Merlin's CI using `current-bench`. We opened the PR on `merl-an` to add a new `current-bench` compatible backend and started work on adding memory usage information to Merlin's telemetry.

On the performance optimisations front, we completed and merged the PPX phase cache in Merlin and opened issues upstream on how tools that use Merlin can benefit from the new PPX cache.

**Activities:**
- Implemented a sketch of `current-bench` backend in `merl-an` -- [pitag-ha/merl-an#2](https://github.com/pitag-ha/merl-an/pull/2).
- Started work on adding memory usage information to Merlin's telemetry.
- Completed and merged the PPX phase cache PR -- [ocaml/merlin#1584](https://github.com/ocaml/merlin/pull/1584).
- Opened issues at `dune` and `ocaml-lsp-server` to keep record of the necessities to enable the PPX phase cache
  - In Dune: `dune ocaml-merlin`: enable PPX phase cache -- [ocaml/dune#7731](https://github.com/ocaml/dune/issues/7731).
  - In OCaml LSP: Handle Merlin's PPX phase cache -- [ocaml/ocaml-lsp#1095](https://github.com/ocaml/ocaml-lsp/issues/1095).
- Identified and fixed a memory "leak" related to the `(F A).t` syntax, causing uncontrolled memoisation table growth -- [ocaml/merlin#1609](https://github.com/ocaml/merlin/pull/1609).

### **[OCaml LSP]** Using Dune RPC on Windows

Contributors: @nojb (LexiFi)

In May, we built on the [support for watch mode on Windows](https://github.com/ocaml/dune/pull/7010) introduced in Dune 3.7.0 and implemented patches in [Dune](https://github.com/ocaml/dune/pull/7666) and [OCaml LSP](https://github.com/ocaml/ocaml-lsp/pull/1079) to allow OCaml LSP to use Dune RPC. The goal is to allow Windows users to leverage Dune RPC and get build statuses and more exhaustive build errors in the editor when Dune is running in watch mode.

Dune 3.8.0 was released with the patches above and a release of OCaml LSP will follow in the coming weeks.

### **[OCaml LSP]** Upstreaming OCaml LSP's Fork of Merlin

Contributors: @voodoos (Tarides), @3Rafal (Tarides)

We continued to work on upstreaming OCaml LSP's fork of Merlin. We finalised the reviews and merged the necessary patches in Merlin. We also continued to work on the PR to use Merlin as a library in OCaml LSP.

**Activities:**
- Reviewed and merged the PR enabling configurable Merlin PP/PPX spawning -- [ocaml/merlin#1585](https://github.com/ocaml/merlin/pull/1585).
- Continued working on the PR to use Merlin as a library in LSP -- [ocaml/ocaml-lsp#1070](https://github.com/ocaml/ocaml-lsp/pull/1070).

## Formatting Code

### **[OCamlFormat]** Closing the Gap Between OCamlFormat and `ocp-indent`

Contributors: @gpetiot (Tarides) and @EmileTrotignon (Tarides), @Julow (Tarides), @ceastlund (Jane Street)

We continued our work to tune the `janestreet` profile so that it better lines up with the output of `ocp-indent`. We made a lot of progress this month, although we encountered some difficulties formatting "cinaps" comments that we'll continue to work on in June.

**Activities:**
- Align pattern alias -- [ocaml-ppx/ocamlformat#2359](https://github.com/ocaml-ppx/ocamlformat/pull/2359)
- Dock `fun`/`function` only if it starts on the first line of the apply -- [ocaml-ppx/ocamlformat#2362](https://github.com/ocaml-ppx/ocamlformat/pull/2362)
- Align module arguments -- [ocaml-ppx/ocamlformat#2363](https://github.com/ocaml-ppx/ocamlformat/pull/2363)
- Remove extra newline in empty comments -- [ocaml-ppx/ocamlformat#2365](https://github.com/ocaml-ppx/ocamlformat/pull/2365)
