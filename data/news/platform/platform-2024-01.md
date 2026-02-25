---
title: "Platform Newsletter: January 2024"
description: Monthly update from the OCaml Platform team.
date: "2024-02-27"
tags: [platform]
---

Welcome to the ninth edition of the OCaml Platform newsletter!

In this January 2024 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
- A preview version of the long-awaited Merlin project-wide references is available. Read more on [the announcement](https://discuss.ocaml.org/t/ann-preview-play-with-project-wide-occurrences-for-ocaml/13814).
- A first beta of opam 2.2 is [available](https://ocaml.org/changelog/2024-01-18-opam-2-2-0-beta1)! Try it, and let the opam team know if you encounter any issues using opam on Windows.
- The `odoc` team started an effort to unify the OCaml.org package documentation with the local workflow provided by Dune. This is very exciting, as the result should be a much improved local documentation with Dune and faster releases of `odoc` features on OCaml.org. They are at the very beginning of the project, but stay tuned for exciting news in the coming months!

**Releases:**
- [Dune 3.13.0](https://ocaml.org/changelog/2024-01-16-dune-3.13.0)
- [Dune 3.12.2](https://ocaml.org/changelog/2024-01-05-dune-3.12.2)
- [opam 2.2.0~beta1](https://ocaml.org/changelog/2024-01-18-opam-2-2-0-beta1)
- [`odoc` 2.4.1](https://ocaml.org/changelog/2024-01-24-odoc-2.4.1)

## **[Dune]** Exploring Package Management in Dune ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))

**Contributed by:** @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

**Why:** Unify OCaml tooling under a single command line for all development workflows. This addresses one of the most important pain points [reported by the community](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0).

**What:** Prototyping the integration of package management into Dune using opam as a library. We're introducing a `dune pkg lock` command to generate a lock file and enhancing `dune build` to handle dependencies in the lock file. More details in the [Dune RFC](https://github.com/ocaml/dune/issues/7680).

**Activities:**
- Support opam’s pin-depends field -- https://github.com/ocaml/dune/pull/9685
- Set %{pkg:dev} correctly for packages that use dev sources -- https://github.com/ocaml/dune/pull/9605
- Remove Repository_id refactor, which instead now uses Git URLs to specify revisions -- https://github.com/ocaml/dune/pull/9614
- Remove `--skip-update` and automatically infer offline mode when possible -- https://github.com/ocaml/dune/pull/9683
- Support submodules in repos -- https://github.com/ocaml/dune/pull/9798
- Don't download the same package source archive multiple times during a build. Many OCaml packages are in Git repos (and source archives) with several other related packages, and it's common for a project to depend on several packages from the same repo. Without this change, the source archive for a repo would be downloaded once for each package from that repo appearing in a project's dependencies -- https://github.com/ocaml/dune/pull/9771
- Add a cond statement for choosing lockdirs. This allows the lockdir to be chosen based on properties of the current system (e.g., OS, architecture) which will simplify working on projects with system-specific dependencies. -- https://github.com/ocaml/dune/pull/9750

## **[opam]** Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

**Why:** Enhance OCaml's viability on Windows by integrating native opam and `opam-repository` support, fostering a larger community and more Windows-friendly packages.

**What:** Releasing opam 2.2 with native Windows support, making the official `opam-repository` usable on Windows platforms.

**Activities:**
- Add `rsync` package to internal Cygwin packages list (enables local pinning and is used by the VCS backends -- [ocaml/opam#5808](https://github.com/ocaml/opam/pull/5808)
- Check and advertise to use Git for Windows -- [ocaml/opam#5718](https://github.com/ocaml/opam/pull/5718)
- Released [opam 2.2~beta1](https://ocaml.org/changelog/2024-01-18-opam-2-2-0-beta1)

## **[`odoc`]** Unify OCaml.org and Local Package Documentation  ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @panglesd (Tarides)

**Why:** Improving local documentation generation workflow will help package authors write better documentation for their packages, and consolidating the different `odoc` documentation generators will help make continuous improvements to `odoc` available to a larger audience.

**What:** We will write conventions that drivers must follow to ensure that their output will be functional. Once established, we will update the dune rules to follow these rules, access new `odoc` features (e.g., source rendering) and provide similar functionalities to docs.ocaml.org (a navigational sidebar for instance). This will effectively make Dune usable to generate OCaml.org package documentation.

**Activities:**
- We started by comparing the various drivers, their needs and constraints, and to flesh out what the conventions could look like. We will publish an RFC before starting the implementation work to ensure that we indeed understood the needs of everyone.

## **[`odoc`]** Add Search Capabilities to `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

**Why:** Improve usability and navigability in OCaml packages documentation, both locally and on OCaml.org, by offering advanced search options like type-based queries.

**What:** Implementing a search engine interface in `odoc`, complete with a UI and a search index. Additionally, we're developing a default client-side search engine based on Sherlodoc.

**Activities:**
- We kept working on Sherlodoc in Januray, and a [new version was released](https://discuss.ocaml.org/t/ann-sherlodoc-a-search-engine-for-ocaml-documentation/14011) a few weeks ago, which can now be embedded on `odoc`-built doc sites.
- We also finished updating the Dune rules which drive `odoc`, to enable the new search feature on locally built docs. These changes were released as part of Dune 3.14.0. -- [ocaml/dune#9772](https://github.com/ocaml/dune/pull/9772)

## **[`odoc`]** Syntax for Images and Assets in `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @jonludlam (Tarides), @dbuenzli, @gpetiot (Tarides)

**Why:** Empower package authors to create rich, engaging documentation by enabling the integration of multimedia elements directly into OCaml package documentation.

**What:** We're introducing new syntax and support for embedding media (images, audio, videos) and handling assets within the `odoc` environment.

**Activities:**
- The PR is still under active review and we're addressing the last minor concerns. -- [ocaml/odoc#1002](https://github.com/ocaml/odoc/pull/1002)

## **[`odoc`]** Improving `odoc` Performance ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @gpetiot (Tarides)

**Why:** Address performance issues in `odoc`, particularly for large-scale documentation, to enhance efficiency and user experience and unlock local documentation generation in large code bases.

**What:** Profiling `odoc` to identify the main performance bottlenecks and optimising `odoc` with the findings.

**Activities:**
- We investigated a couple of issues brought forth by the `module type of` fix that was mentioned last month. This eventually resulted in a series of PRs: [ocaml/odoc#1078](https://github.com/ocaml/odoc/pull/1078), [ocaml/odoc#1079](https://github.com/ocaml/odoc/pull/1079) and [ocaml/odoc#1081](https://github.com/ocaml/odoc/pull/1081)
- We also noticed that `odoc`'s handling of the load path was quadratic, so we changed that in [ocaml/odoc#1075](https://github.com/ocaml/odoc/pull/1075).

## **[Merlin]** Support for Project-Wide References in Merlin ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @voodoos (Tarides), @trefis (Tarides), @Ekdohibs (OCamlPro), @gasche (INRIA), @Octachron (INRIA)

**Why:** Enhance code navigation and refactoring for developers by providing project-wide reference editor features, aligning OCaml with the editor experience found in other languages.

**What:** Introducing `merlin single occurrences` and LSP `textDocument/references` support, extending compiler's Shapes for global occurrences and integrating these features in Dune, Merlin, and OCaml LSP.

**Activities:**
- Released a preview version of project-wide references and announced it on Discuss, asking for feedback - [[ANN][PREVIEW] Play with project-wide occurrences for OCaml!](https://discuss.ocaml.org/t/ann-preview-play-with-project-wide-occurrences-for-ocaml/13814)
- Merged the compiler PR - [ocaml/ocaml#12506](https://github.com/ocaml/ocaml/pull/12508)
- As a teaser for future work that will build on project-wide references, we started prototyping the project-wide `rename` feature - [voodoos/ocaml-lsp#index-preview](https://github.com/voodoos/ocaml-lsp/tree/index-preview)

## **[Merlin]** Improving Merlin's Performance ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @pitag (Tarides), @Engil (Tarides)

**Why:** Some Merlin queries have been shown to scale poorly in large codebases, making the editor experience subpar. Users report that they sometimes must wait a few seconds to get the answer. This is obviously a major issue that hurts developer experience, so we're working on improving Merlin performance when it falls short.

**What:** Developing benchmarking tools and optimising Merlin's performance through targeted improvements based on profiling and analysis of benchmark results.

**Activities:**
- We merged the Fuzzy testing CI. As a reminder, this CI tests Merlin PRs for behaviour regressions. This will help us make sure that we don't inadvertently break Merlin queries by testing them on a broad range of use cases - [ocaml/merlin#1716](https://github.com/ocaml/merlin/pull/1716)
- In `merlin-lib`, we started writing a prototype to process the buffer in parallel with the query computation. Parallelism refers to OCaml 5 parallelism (domains).
