---
title: "Platform Newsletter: February 2024"
description: Monthly update from the OCaml Platform team.
date: "2024-03-26"
tags: [platform]
---

Welcome to the tenth edition of the OCaml Platform newsletter!

In this February 2024 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
- The OCaml Platform tools have added support for OCaml 5.2. It's available in the temporary releases
    - [`Merlin 4.14-502~preview`](https://ocaml.org/p/merlin/4.14-502~preview) (@voodoos (Tarides))
    - [`Ocaml-lsp-server 1.18.0~5.2preview`](https://ocaml.org/p/ocaml-lsp-server/1.18.0~5.2preview) (@voodoos (Tarides))
    - [`Ppxlib 0.32.1~5.2preview`](https://ocaml.org/p/ppxlib/0.32.1~5.2preview) (@NathanReb (partly funded by the OCaml Software Foundation)).

**Releases:**
- [UTop 2.14.0](https://ocaml.org/changelog/2024-02-27-utop-2.14.0)
- [Merlin 4.14](https://ocaml.org/changelog/2024-02-26-merlin-4.14)
- [Dune 3.14.0](https://ocaml.org/changelog/2024-02-12-dune.3.14.0)
- [Ppxlib 0.31.2](https://ocaml.org/changelog/2024-02-07-ppxlib-0.32.0)
- [Dune 3.13.1](https://ocaml.org/changelog/2024-02-05-dune-3.13.1)

## **[Dune]** Exploring Package Management in Dune ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))

**Contributed by:** @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

**Why:** Unify OCaml tooling under a single command line for all development workflows. This addresses one of the most important pain points [reported by the community](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0).

**What:** Prototyping the integration of package management into Dune using opam as a library. We're introducing a `dune pkg lock` command to generate a lock file and enhancing `dune build` to handle dependencies in the lock file. More details in the [Dune RFC](https://github.com/ocaml/dune/issues/7680).

**Activities:**
- One of the main remaining blockers to make Dune package management usable in real world project is to make some of the low level dependencies, notably OCamlFind and the OCaml compiler, relocatable. -- [ocaml/ocamlfind#72](https://github.com/ocaml/ocamlfind/pull/72)
- We experimented with a Coq-platform patch to make OCamlFind relocatable, but we faced issues with packages using `topkg` due to `ocamlbuild` build failures. This led to identifying an error with directory symlink handling in Dune [ocaml/dune#9873](https://github.com/ocaml/dune/issues/9873), [ocaml/dune#9937](https://github.com/ocaml/dune/pull/9937)
- To track the buildability of opam packages with Dune package management, we worked on a GitHub action that effectively provides us with a dashboard of opam packages coverage on a select set of packages. The repository is available at [gridbugs/dune-pkg-dashboard](https://github.com/gridbugs/dune-pkg-dashboard).
- Based on the findings from the above, several issues were opened on the Dune issue tracker. All the known issues are now tracked in the [Package Management MVP](https://github.com/ocaml/dune/issues?q=is%3Aopen+is%3Aissue+milestone%3A%22Package+Management+MVP%22) milestone on Dune's issue tracker.
- We also focused on improving features that were previously implemented. Noteworthy changes include the addition of [workspace package pins](https://github.com/ocaml/dune/pull/10072) and enhancements for correct path handling in packages -- [ocaml/dune#9940](https://github.com/ocaml/dune/pull/9940)
- Work included updates and refactorings to improve source fetching, particularly the removal of a rudimentary Git config parser in favor of using `git config` directly ([ocaml/dune#9905](https://github.com/ocaml/dune/pull/9905)), and enhancements to how Dune handles Git repositories, such as the checking out of Git repos via `rev_store` ([ocaml/dune#10060](https://github.com/ocaml/dune/pull/10060)).
- Contributions also focused on refining and testing Dune's package handling, including a fix to ensure that opam's untar code is not used ([ocaml/dune#10085](https://github.com/ocaml/dune/pull/10085)), and improvements to Dune's handling of recursive submodules in Git repos ([ocaml/dune#10130](https://github.com/ocaml/dune/pull/10130)).

## **[opam]** Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

**Why:** Enhance OCaml's viability on Windows by integrating native opam and `opam-repository` support, fostering a larger community, and more Windows-friendly packages.

**What:** Releasing opam 2.2 with native Windows support, making the official `opam-repository` usable on Windows platforms.

**Activities:**
- Addressed the issue where the Windows loader would display blocking dialogue boxes upon failing to find DLLs, adhering to best practices by suppressing these dialogs, and opting for exit codes instead. This enhancement eliminates disruptive interruptions, ensuring a more seamless operation for automated tasks and CI environments. -- [#5828](https://github.com/ocaml/opam/pull/5828)
- Fixed shell detection issues when opam is invoked via Cygwin's `/usr/bin/env`, enhancing compatibility and user experience for those utilising Cygwin alongside `cmd` or PowerShell. -- [#5797](https://github.com/ocaml/opam/pull/5797)
- Recommend Developer Mode on Windows. To optimise storage and align with best practices, Developer Mode is recommended for enabling symlink support. -- [#5831](https://github.com/ocaml/opam/pull/5831)
- Resolved issues related to environment variable handling, specifically fixing bugs where updates or additions to environment variables would incorrectly remove or alter them. -- [#5837](https://github.com/ocaml/opam/pull/5837)
- Addressed early loading of git location information, particularly benefiting Windows users by ensuring correct retrieval and application of git-related configurations. -- [#5842](https://github.com/ocaml/opam/pull/5842)
- Disabled ACL in Cygwin. By setting `noacl` in `/etc/fstab` for `/cygdrive` mount, this change avoids permission mismatch errors, enhancing reliability and usability for Cygwin users. -- [#5796](https://github.com/ocaml/opam/pull/5796)
- Introduced the ability to define the package manager path at initialisation, improving customisation and integration capabilities for Windows users. -- [#5847](https://github.com/ocaml/opam/pull/5847)
- Added `winsymlinks:native` to the Cygwin environment variable, improving compatibility within the Cygwin ecosystem. -- [#5793](https://github.com/ocaml/opam/pull/5793)
- Fixed script generation issues related to path quoting, ensuring smoother initialisation and setup processes, especially in mixed-environment scenarios like Cygwin. -- [#5841](https://github.com/ocaml/opam/pull/5841)
- Corrected the precedence and handling of `git-location` configurations during initialisation, streamlining Git integration and providing clearer control over Git settings. -- [#5848](https://github.com/ocaml/opam/pull/5848)
- Extended the use of eval-variables to internal Cygwin installations and adjusted the setup to better accommodate Windows-specific requirements, enhancing flexibility and system compiler integration. -- [#5829](https://github.com/ocaml/opam/pull/5829)

## **[`odoc`]** Unify OCaml.org and Local Package Documentation  ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @panglesd (Tarides), Luke Maurer (Jane Street)

**Why:** Improving local documentation generation workflow will help package authors write better documentation for their packages, and consolidating the different `odoc` documentation generators will help make continuous improvements to `odoc` available to a larger audience.

**What:** We will write conventions that drivers must follow to ensure that their output will be functional. Once established, we will update the Dune rules to follow these rules, access new `odoc` features (e.g., source rendering), and provide similar functionalities to docs.ocaml.org (a navigational sidebar, for instance). This will effectively make Dune usable to generate OCaml.org package documentation.

**Activities:**
- Work continued on the design for the new `odoc` drivers conventions shared by Dune and OCaml.org, and we plan to publish the RFC in March.
- We also started comparing and prototyping various approaches to add sidebar support to `odoc`. Several prototypes have been developed and discussed with the team, and we will resume work on the sidebar implementation once the driver conventions have been adopted.

## **[`odoc`]** Add Search Capabilities to `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

**Why:** Improve usability and navigability in OCaml packages documentation, both locally and on OCaml.org, by offering advanced search options like type-based queries.

**What:** Implementing a search engine interface in `odoc`, complete with a UI and a search index. Additionally, we're developing a default client-side search engine based on Sherlodoc.

**Activities:**
- The implementation and refinement of sherlodoc's integration with odoc were our major focuses, this included making sherlodoc pass opam CI on different architectures and adjusting the dune rules for better usability -- [ocaml/dune#9956](https://github.com/ocaml/dune/pull/9956)
- After the big sherlodoc PR was merged and sherlodoc released last month, work continued on refining the dune rules for sherlodoc and on adjusting the search bar's scope based on discussions with the team.
- We implemented keyboard navigation in the search bar to improve its usability -- [ocaml/odoc#1088](https://github.com/ocaml/odoc/pull/1088)

## **[`odoc`]** Improving `odoc` Performance ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @gpetiot (Tarides)

**Why:** Address performance issues in `odoc`, particularly for large-scale documentation, to enhance efficiency and user experience and unlock local documentation generation in large code bases.

**What:** Profiling `odoc` to identify the main performance bottlenecks and optimising `odoc` with the findings.

**Activities:**
- Performance improvements were achieved by addressing issues with source location lookups for non-existent identifiers, significantly improving link time for large codebases.
- Several PRs from the module-type-of work were opened, including fixes and tests aimed at enhancing `odoc`'s handling of transitive library dependencies, shape lookup, and module-type-of expansions --  [ocaml/odoc#1078](https://github.com/ocaml/odoc/pull/1078), [ocaml/odoc#1081](https://github.com/ocaml/odoc/pull/1081)
- Improve the efficiency of finding `odoc` files in accessible paths, cutting the time to generate documentation by two in some of our tests -- [ocaml/odoc#1075](https://github.com/ocaml/odoc/pull/1075)

## **[Merlin]** Support for Project-Wide References in Merlin ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @voodoos (Tarides)

**Why:** Enhance code navigation and refactoring for developers by providing project-wide reference editor features, aligning OCaml with the editor experience found in other languages.

**What:** Introducing `ocamlmerlin server occurrences` and LSP `textDocument/references` support, extending compiler's Shapes for global occurrences and integrating these features in Dune, Merlin, and OCaml LSP.

**Activities:**
- Continued investigations and improvements on Dune rules to address configuration issues
- After adding support for OCaml 5.2 to `merlin-lib`, we've rebased the project-wide occurrences work over it.
- We also started work with the Jane Stree team to test project wide references at scale in their monorepo. Following our initial integration, we focused on refining Merlin's indexing and occurrence query capabilities, including addressing bottlenecks and regressions in shape reductions -- [ocaml/ocaml#13001](https://github.com/ocaml/ocaml/pull/13001)

## **[Merlin]** Improving Merlin's Performance ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @pitag (Tarides), @Engil (Tarides)

**Why:** Some Merlin queries have been shown to scale poorly in large codebases, making the editor experience subpar. Users report that they sometimes must wait a few seconds to get the answer. This is obviously a major issue that hurts developer experience, so we're working on improving Merlin performance when it falls short.

**What:** Developing benchmarking tools and optimising Merlin's performance through targeted improvements based on profiling and analysis of benchmark results.

**Activities:**
- In `merlin-lib`, we've continued the work on a prototype to process the buffer in parallel with the query computation. Parallelism refers to OCaml 5 parallelism (domains).
