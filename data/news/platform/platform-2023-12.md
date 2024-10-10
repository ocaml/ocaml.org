---
title: "Platform Newsletter: November and December 2023"
description: Monthly update from the OCaml Platform team.
date: "2024-01-24"
tags: [platform]
---

Welcome to the eighth edition of the OCaml Platform newsletter!

In this November and December edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
- The `odoc` team is starting work on improving `odoc` performances. After shipping important features, including a link to source code, syntax for tables, and recent support for search, they are turning their focus on consolidating the full documentation generation stack (including Dune rules and integration with OCaml.org package docs) and improving performances.
- [opam 2.2~alpha3 is out](https://ocaml.org/changelog/2023-11-15-opam-2-2-0-alpha3)! It is the last alpha release, and the opam team plans to start the beta release next cycle.
- Anticipating on the January update, the compiler PR necessary for Merlin project-wide references has been merged! This will be part of OCaml 5.2, meaning that starting with the next compiler version, OCaml developers will be able to query for project-wide references (and limited support for project-wide rename!) in their projects. Read more [here](https://discuss.ocaml.org/t/ann-preview-play-with-project-wide-occurrences-for-ocaml/13814) to know how you can test the feature.

**Releases:**
- [Odoc 2.4.0](https://ocaml.org/changelog/2023-12-14-odoc-2.4.0)
- [OCaml LSP 1.17.0](https://ocaml.org/changelog/2023-12-18-ocaml-lsp-1.17.0)
- [Merlin 4.13](https://ocaml.org/changelog/2023-12-06-merlin-4.13)
- [Dune 3.12.1](https://ocaml.org/changelog/2023-11-29-dune-3.12.1)
- [opam 2.2.0~alpha3
](https://ocaml.org/changelog/2023-11-15-opam-2-2-0-alpha3)

## **[Dune]** Exploring Package Management in Dune ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))

**Contributed by:** @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

**Why:** Unify OCaml tooling under a single command line for all development workflows. This addresses one of the most important pain points [reported by the community](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0).

**What:** Prototyping the integration of package management into Dune using opam as a library. We're introducing a `dune pkg lock` command to generate a lock file and enhancing `dune build` to handle dependencies in the lock file. More details in the [Dune RFC](https://github.com/ocaml/dune/issues/7680).

**Activities:**
- Introduced a locking mechanism to prevent conflicts in multiple repositories and fixed a bug in Dune's locking code. -- [ocaml/dune#9140](https://github.com/ocaml/dune/pull/9140)
- Enabled project locking without a network connection using locally cached `opam-repository`. -- [ocaml/dune#9202](https://github.com/ocaml/dune/pull/9202)
- Enhanced handling of `opam-repositories` with non-standard contents (non-file objects). -- [ocaml/dune#9352](https://github.com/ocaml/dune/pull/9352)
- Added a feature where users can set arbitrary variables which can be referred to by opam packages while solving a project's dependencies. This gives users more control over decisions made by the solver and which dependencies their project ends up having in its `lockdir`. -- [ocaml/dune#9325](https://github.com/ocaml/dune/pull/9325)
- Ensured `lockdir` contains all dependencies of local packages for consistency. This prevents Dune from presenting inconsistent information to users who have changed their project's dependencies after creating a `lockdir`. Instead, they'll be prompted to recompute their `lockdir`. -- [ocaml/dune#9156](https://github.com/ocaml/dune/pull/9156)
- Ability to detect which dependencies in the `lockdir` are only needed when building tests. This will be necessary to allow users to skip downloading and building packages that are only needed for testing unless they are running tests. -- [ocaml/dune#9095](https://github.com/ocaml/dune/pull/9095)
- Improved support for Windows, focusing on better Curl integration and opam library adjustments for Windows architectures. -- [ocaml/dune#9252](https://github.com/ocaml/dune/pull/9252), [ocaml/dune#9048](https://github.com/ocaml/dune/pull/9048)
- Refined context/lock file handling in Dune package management. -- [ocaml/dune#9343](https://github.com/ocaml/dune/pull/9343)
- Refined context/lock file handling. Before each context had an associated lock file so lock files were selected via context arguments. Now the context middlemen have been removed and the users selects lock files by specifying the lockfile itself. This applies to most pkg related commands. -- [ocaml/dune#9343](https://github.com/ocaml/dune/pull/9343)
- Added support for the `conflicts` field in opam files -- [ocaml/dune#9340](https://github.com/ocaml/dune/pull/9340)
- Looked into solutions to add support for deptops -- [ocaml/dune#9430](https://github.com/ocaml/dune/pull/9430)
- Writing the PID of process that created the lock file [ocaml/dune#9295](https://github.com/ocaml/dune/pull/9295) to be able to easily determine which process is holding the revision store lock
- Avoid Git translating its CLI [ocaml/dune#9390](https://github.com/ocaml/dune/pull/9390). Since we use the Git binary under the hood, users with different locales might get translated Git output. Since our Git output is not shown to the user, we disable translation.
- Remove `opam-repository-url` option [ocaml/dune#9373](https://github.com/ocaml/dune/pull/9373) Removes all CLI options that deal with repositories. All `opam-repositories` are now controlled in the `dune-workspace` file.
- Support for specifying particular branches/commits for repos [ocaml/dune#9241](https://github.com/ocaml/dune/pull/9241) adds support for specifying branches and commits as `opam-repository` sources, so the user can fix one particular state of `opam-repository`
- Enable checking out tags [ocaml/dune#9471](https://github.com/ocaml/dune/pull/9471) adds the same support as above but for tags. It does so by saving the tags in per-remote namespaces, thus it works very much like branches.
- Implement downloading sources via Git [ocaml/dune#9506](https://github.com/ocaml/dune/pull/9506) enables cloning source directories via the rev store, thus caching most commits when working with multiple projects from the same repo, etc.
- Read the main branch correctly even if tags exist [ocaml/dune#9549](https://github.com/ocaml/dune/pull/9549) fixes an issue where the code that determines the tracking branch got confused in the presence of namespaced tags.
- Dune will compute checksums for lock files of packages which don't already have checksums in their opam metadata. -- [ocaml/dune#9384](https://github.com/ocaml/dune/pull/9384)
- Package metadata for a Dune project can be read from `.opam` files rather than `dune-project` -- [ocaml/dune#9418](https://github.com/ocaml/dune/pull/9418)
- Support for conflict classes in opam files for the solver -- [ocaml/dune#9442](https://github.com/ocaml/dune/pull/9442)
- The ability to add additional constraints to feed the solver -- [ocaml/dune#9337](https://github.com/ocaml/dune/pull/9337)

## **[opam]** Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

**Why:** Enhance OCaml's viability on Windows by integrating native opam and `opam-repository` support, fostering a larger community and more Windows-friendly packages.

**What:** Releasing opam 2.2 with native Windows support, making the official `opam-repository` usable on Windows platforms.


**Activities:**
<!--FROM KATE-->
- We’ve released [opam 2.2.0~alpha3](https://github.com/ocaml/opam/releases/tag/2.2.0-alpha3), a culmination of the last 4 months of work. This release, amongst other fixes and improvements, adds in the opam file a way to specify path environment variable rewriting rules for `setenv:`and `envbuild:` field on Windows. -- [#5636](https://github.com/ocaml/opam/pull/5636)
- Generate a static binary for producing a Windows binary -- [#5680](https://github.com/ocaml/opam/pull/5680)
- Fix carriage return on `opam env`on cygwin -- [#5715](https://github.com/ocaml/opam/pull/5715)
- Handle which Git to use at opam init on Windows -- [#5718](https://github.com/ocaml/opam/pull/5718)
- We’ve also fixed a number of issues on Windows:
    - Fix issues in the C stubs for Windows - [#5714](https://github.com/ocaml/opam/pull/5714)
    - Fix incorrect error message in configure on Windows - [#5667](https://github.com/ocaml/opam/pull/5667)
    - Always resolve the fullpath to the `cygpath` executable - [#5716](https://github.com/ocaml/opam/pull/5716)

## **[`odoc`]** Add Search Capabilities to `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

**Why:** Improve usability and navigability in OCaml packages documentation, both locally and on OCaml.org, by offering advanced search options like type-based queries.

**What:** Implementing a search engine interface in `odoc`, complete with a UI and a search index. Additionally, we're developing a default client-side search engine based on Sherlodoc.

**Activities:**
<!--FROM EMILE-->
- After merging [the PR that added support for search to `odoc`](https://github.com/ocaml/odoc/pull/972) in October, we continued work on building an `odoc`-compatible search engine based on [Sherlodoc](https://doc.sherlocode.com/). This will give a search engine with type-based search for every package that uses `odoc`. The plan is to make Sherlodoc the search engine in Dune's documentation generation. You can try an early demo on [Varray's doc](https://art-w.github.io/varray/varray/Varray) -- [art-w/sherlodoc#4](https://github.com/art-w/sherlodoc/pull/4)
- Buiding on `odoc`'s support for search, we merged a PR that adds occurrences information to the search index. This will allows `odoc` search engines to improve the order of search results by using the number of occurences. -- [ocaml/odoc#976](https://github.com/ocaml/odoc/pull/976)

## **[`odoc`]** Syntax for Images and Assets in `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @jonludlam (Tarides), @dbuenzli, @gpetiot (Tarides)

**Why:** Empower package authors to create rich, engaging documentation by enabling the integration of multimedia elements directly into OCaml package documentation.

**What:** We're introducing new syntax and support for embedding media (images, audio, videos) and handling assets within the `odoc` environment.

**Activities:**
- Added assets in the environment to treat them similarly as other resolvable elements. This addressed the remaining feedback from reviews, and if no other blocker is found, the PR should be ready to merge. -- [ocaml/odoc#1002](https://github.com/ocaml/odoc/pull/1002)

## **[`odoc`]** Improving `odoc` Performance ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @gpetiot (Tarides)

**Why:** Address performance issues in `odoc`, particularly for large-scale documentation, to enhance efficiency and user experience, and unlock local documentation generation in large code bases.

**What:** Profiling `odoc` to identify the main performance bottlenecks, and optimising `odoc` with the findings.

**Activities:**
- Experimented with different data structures and algorithms for more efficient documentation generation on large files. --[ocaml/odoc#1033](https://github.com/ocaml/odoc/pull/1033),  [ocaml/odoc#1036](https://github.com/ocaml/odoc/pull/1036), [ocaml/odoc#1049](https://github.com/ocaml/odoc/pull/1049)
- Implemented item lookup improvements in signatures for faster processing. -- [ocaml/odoc#1049](https://github.com/ocaml/odoc/pull/1049)
- Developed a fix for memory issues caused by `module type of` expressions, with promising results from testing at Jane Street. -- [ocaml/odoc#1042](https://github.com/ocaml/odoc/pull/1042)

## **[Dune]** Generate Dependencies Documentation with Dune ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides)

**Why:** Enhance the usability of locally-generated documentation by providing direct access to dependencies' documentation.

**What:** Implementing new Dune rules for `odoc` to enable efficient documentation generation and access to documentation for all opam packages in your switch.

**Activities:**
- The new Dune rules have been merged and are available in the newest release of Dune 3.12.1. Try running `dune build @doc-new` to generate your documentation and tell us what you think! -- [ocaml/dune#8803](https://github.com/ocaml/dune/pull/8803)
- Shortly after the release, we noticed an issues with dependency handling. We're working on a fix that should be released -- [ocaml/dune#9461](https://github.com/ocaml/dune/pull/9461)

## **[Merlin]** Support for Project-Wide References in Merlin ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @voodoos (Tarides), @trefis (Tarides), @Ekdohibs (OCamlPro), @gasche (INRIA)

**Why:** Enhance code navigation and refactoring for developers by providing project-wide reference editor features, aligning OCaml with the editor experience found in other languages.

**What:** Introducing `merlin single occurrences` and LSP `textDocument/references` support, extending compiler's Shapes for global occurrences, and integrating these features in Dune, Merlin, and OCaml LSP.

**Activities:**
- The first iteration on project-wide occurrences is closing-in, and we made a custom [`opam-repository`](https://github.com/voodoos/opam-repository-index) to test the feature while the changes make their way into the upstream compiler. This gave us the opportunity to test the feature on more real projects, and after another round of bug-fixing and UI improvement we [opened it](https://discuss.ocaml.org/t/ann-preview-play-with-project-wide-occurrences-for-ocaml/13814) to the community for wider testing.
- Anticipating the January update, the [compiler PR](https://github.com/ocaml/ocaml/pull/12508) has been merged! :tada: The next steps are to revisit the patches on the other projects and to open PRs upstream. Dune is the next in line. -- [ocaml/ocaml#12508](https://github.com/ocaml/ocaml/pull/12508)

## **[Merlin]** Improving Merlin's Performance ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @pitag (Tarides), @Engil (Tarides), @3Rafal (Tarides)

**Why:** Some Merlin queries have been shown to scale poorly in large codebases, making the editor experience subpar, and users report that they sometimes must wait a few seconds to get the answer. This is obviously a major issue that hurts developer experience, so we're working on improving Merlin performance when it falls short.

**What:** Developing benchmarking tools and optimising Merlin's performance through targeted improvements based on profiling and analysis of benchmark results.

**Activities:**
- We've made the file cache lifetime configurable. Varying the lifetime will allow experimenting with Merlin's time/space trade-off. Before, it was constantly set to 5 min. -[#1698](https://github.com/ocaml/merlin/pull/1698)
  - Introduced a config that lets users set a file cache lifespan. When modified to a larger value it should improve performance for large repositories -- [ocaml/merlin#1698](https://github.com/ocaml/merlin/pull/1698)
  - Introduced the file cache lifespan flag to `ocaml-lsp`, so it can be used for all LSP clients -- [ocaml/ocaml-lsp#1210](https://github.com/ocaml/ocaml-lsp/pull/1210)
- We've enriched the telemetry that comes embedded in the `ocamlmerlin` responses:
  - We've added information about cache hits and misses of the various Merlin caches: `cmi-files` cache, `cmt-files` cache, typer phase cache, PPX phase cache, and reader phase cache. - [#1711](https://github.com/ocaml/merlin/pull/1711)
  - We've added information about the size of the major heap at the end of an `ocamlmerlin` query - [#1717](https://github.com/ocaml/merlin/pull/1717)
- We've finished up Merlin's new Fuzzy CI, a by-product of the performance work.
    - We've opened the PRs - [#1716](https://github.com/ocaml/merlin/pull/1716) (and [#1719](https://github.com/ocaml/merlin/pull/1719))
    -  We've written a GitHub wiki entry with a high-level description about it. - [Merlin Fuzzy CI](https://github.com/ocaml/merlin/wiki/Merlin-Fuzzy-CI)