---
title: "Platform Newsletter: October 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-11-28"
tags: [platform]
---

Welcome to the seventh edition of the OCaml Platform newsletter!

In this October edition, we bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
- The three-year roadmap for the OCaml Platform has been officially adopted! We're thrilled to have a community-driven roadmap for the improvement of OCaml developer experience, and we're very grateful for all the excellent feedback we received from the community. Have a look at the [announcement](https://discuss.ocaml.org/t/the-ocaml-platform-roadmap-is-adopted/13459).
- After [giving space for feedback](https://discuss.ocaml.org/t/deprecating-ocaml-migrate-parsetree-in-favor-of-ppxlib-also-as-a-platform-tool/13240) and objections by the community, we have [deprecated ocaml-migrate-parsetree](https://ocaml.org/changelog/2023-10-23-omp-deprecation) (aka OMP). It is superseded by [Ppxlib](https://github.com/ocaml-ppx/ppxlib).
- We're introducing a new format for our newsletter. Let us know your thoughts and how we can make it even better for you!

**Releases:**
- [`opam-publish` 2.3.0](https://ocaml.org/changelog/2023-10-30-opam-publish-2.3.0)
- [`Ppxlib` 0.31.0](https://ocaml.org/changelog/2023-10-05-ppxlib-0.31.0)
- [`odoc` 2.3.1](https://ocaml.org/changelog/2023-10-30-odoc-2.3.1)
- [Dune 3.11.0](https://ocaml.org/changelog/2023-10-04-dune-3.11.0)
- [Dune 3.11.1](https://ocaml.org/changelog/2023-10-12-dune-3.11.1)

## **[Dune]** Exploring Package Management in Dune ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))

**Contributed by:** @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides), @Alizter

**Why:** Unify OCaml tooling under a single command line for all development workflows. This addresses one of the most important pain points [reported by the community](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0).

**What:** Prototyping the integration of package management into Dune by using opam as a library. We're adding a new `dune pkg lock` command to generate a lock file and extend `dune build` to support downloading and building dependencies specified in the lock file. Read the [Dune RFC](https://github.com/ocaml/dune/issues/7680) for more details.

**Activities:**
- We reworked the storage for opam repositories. We now have support for multiple repositories, which we store and update in an efficient manner. -- [ocaml/dune#8950](https://github.com/ocaml/dune/pull/8950)
- We introduced the `$ dune pkg outdated` command to view all the outdated packages in a lock directory. -- [ocaml/dune#8773](https://github.com/ocaml/dune/pull/8773)
- We introduced `$ dune describe pkg lock` to print lock directories. This gives users a nice overview of what’s available in the lock directory's build plan. -- [ocaml/dune#8841](https://github.com/ocaml/dune/pull/8841)
- We added support for solver variables in `lockdir` to make sure opam variables are also available at build and install time -- [ocaml/dune#8973](https://github.com/ocaml/dune/pull/8973)
- We managed to successfully generate a lock file for `cmdliner` on Windows! :windows: Next, we're working on making build work on Windows as well. -- [ocaml/dune#9048](https://github.com/ocaml/dune/pull/9048)
- And as usual, we fixed a bunch of bugs that prevented your regular packages from building:
  - Require copying sandbox for build rules -- [ocaml/dune#8923](https://github.com/ocaml/dune/pull/8923)
  - Respect [flags] field in opam packages -- [ocaml/dune#9047](https://github.com/ocaml/dune/pull/9047)
  - Improve invalid substitute error -- [ocaml/dune#8922](https://github.com/ocaml/dune/pull/8922)
  - Correctly verify tarball checksums -- [ocaml/dune#8876](https://github.com/ocaml/dune/pull/8876)
  - Improve locations of conversion errors -- [ocaml/dune#8828](https://github.com/ocaml/dune/pull/8828)
  - Remove post deps -- [ocaml/dune#8834](https://github.com/ocaml/dune/pull/8834)
  - Move solver env printing to own command -- [ocaml/dune#8819](https://github.com/ocaml/dune/pull/8819)
  - Record installed directories in `dune-package` -- [ocaml/dune#8953](https://github.com/ocaml/dune/pull/8953)

## **[opam]** Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @AltGr (OCamlPro)

**Why:** Opam and `opam-repository` currently don't support Windows natively. This effectively makes OCaml a very niche candidate on Windows, as users either have to (1) not use a package manager or (2) use a fork of opam and the `opam-repository`. Making opam and the `opam-repository` compatible with Windows will make OCaml a better choice for Windows users and help us grow the community. More Windows users able to use opam leads to more contributors, more testing, more Windows friendly packages, and more packages in the end.

**What:** Releasing opam 2.2 with native support for Windows and making the official `opam-repository` usable on Windows.

**Activities:**
- Essentially focused on `setenv` & `build-env` environment variables update handling on Windows - [ocaml/opam#5636](https://github.com/ocaml/opam/pull/5636)

## **[`odoc`]** Add Search Capabilities to `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @EmileTrotignon (Tarides), @julow (Tarides), @jonludlam (Tarides)

**Why:** The in-package search added in OCaml.org's central package documentation has been very well received by the community and improves how users navigate and discover OCaml documentation. We're upstreaming it to `odoc` to bring it into the local documentation as well and provide more advanced features, like searching by type.

**What:** We're adding support in `odoc` for pluging in a search engine! `odoc` provides the UI (a search bar) and will generate a search index (that can also be used to be integrated into other search engine like Elasticsearch). We're also building a default client-side search engine based on Sherlodoc.

**Activities:**
- We've merged the PR adding [new search capabilities](https://github.com/ocaml/odoc/pull/972)! :tada: This will ship in the upcoming version of `odoc` 2.4.0.
- We are currently experimenting with building an `odoc` search engine based on [Sherlodoc](https://github.com/art-w/sherlodoc) --[art-w/sherlodoc#4](https://github.com/art-w/sherlodoc/pull/4).

## **[`odoc`]** Syntax for Images and Assets in `odoc` ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @panglesd (Tarides), @jonludlam (Tarides), @dbuenzli, @gpetiot (Tarides)

**Why:** Allow package authors to write rich documentation, making it more useful and improving OCaml developer experience by providing an ecosystem of high-quality documentation for OCaml packages.

**What:** We're adding support for assets and new syntax to embed medias (images, audio, and videos).

**Activities:**
- We've decided to rework the asset support design a little to bring it more in line with how other elements are handled, such as modules, types, and values. The intent is to ensure the code is straightforward to maintain in the long term. -- [ocaml/odoc#1002](https://github.com/ocaml/odoc/pull/1002)
- We continued reviewing the PR, adding syntactic support for media. There were some good discussions relating to missing assets, and it's ready to go in once the assets PR is merged. -- [ocaml/odoc#1005](https://github.com/ocaml/odoc/pull/1005)

## **[Dune]** Generate Dependencies Documentation with Dune ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides)

**Why:** Make locally-generated documentation more useful by allowing users to navigate to their dependencies' documentation from their package docs. Currently users can use `odig`, which provides a similar workflow. We're adding support for this in Dune directly.

**What:** We're writing new Dune rules for `odoc` that (1) use the new `odoc` CLI to enable performance improvement and caching opportunities and (2) generate the documentation of every opam packages in your switch, allowing users to navigate to their dependencies' documentation from their local docs.

**Activities:**
- The new Dune rules have been reworked a little following feedback from @alizter and @rgrinberg, improving the following areas: better support for multiple `findlib` directories; better support for system switches; and a more robust method for translating from `findlib` paths to local paths. -- [ocaml/dune#8803](https://github.com/ocaml/dune/pull/8803)

## **[Merlin]** Support for Project-Wide References in Merlin ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @voodoos (Tarides), @trefis (Tarides), @Ekdohibs (OCamlPro), @gasche (INRIA)

**Why:** Project-wide reference as an editor feature is a great way for developers to navigate their codebase and understand it better. It's also a feature that users expect to have coming from other ecosystems, so having support for it in Merlin and OCaml LSP will both improve OCaml editor experience and make it on par with other languages.

**What:** We're adding a new `merlin single occurrences` command and support for the LSP `textDocument/references` request. To do that, we're extending the compiler's Shapes to support global occurrences, building a tool that generates an index of identifiers in a codebase and adding support for it in Dune, Merlin, and OCaml LSP.

**Activities:**
- We continued working on the compiler PR for project-wide occurrences, notably adding support for inline records' labels. The PR is now ready for the next round of reviews. -- [ocaml/ocaml#12508](https://github.com/ocaml/ocaml/pull/12508)
- Concurrently, we continued working on the tools involved in providing occurrences. We are still on track for releasing an experimental 4.14-based variant of the compiler to gather feedback on the feature before the end of the year. Our current aim is to provide official project-wide occurrences support in OCaml 5.2. -- [voodoos/merlin#8](https://github.com/voodoos/merlin/pull/8), [voodoos/ocaml-lsp#2](https://github.com/voodoos/ocaml-lsp/pull/2), [voodoos/dune#2](https://github.com/voodoos/dune/pull/2), [ocaml-index#5](https://github.com/voodoos/ocaml-index/pull/5)

## **[Merlin]** Improving Merlin's Performance ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @pitag (Tarides), @Engil (Tarides), @3Rafal (Tarides)

**Why:** Some Merlin queries have been shown to scale poorly in large codebases, making the editor experience subpar, with users reporting that they sometime must wait for a few seconds to get the answer for Merlin. This is obviously a major issue that hurts developer experience, so we're working on improving Merlin performance when it falls short.

**What:** We're building benchmarking and fuzzy-testing CIs to continuously benchmark and test Merlin. We're addressing the performance bottlenecks identified from profiling Merlin and analysing benchmarking results.

**Activities:**
- We've continued our work on a fuzzy-testing CI for Merlin. Our first approach was to persist the testing data in sync with the Merlin commit history. However, that implied dealing with all kinds of data races when comparing the data between a PR and its base branch, when generating and persisting new data, and when approving changes. To avoid that, in October we experimented with a simpler approach that regenerates the data for every CI run - without compromising on CI run time. The new approach seems promising.
- We've also come back to work on Merlin performance improvements. We plan to [optimise Merlin's space-time trade-off](https://github.com/ocaml/merlin/issues/1636) by experimenting (on an opt-in basis) with different lifetimes for the `cmi-cache` and `cmt-cache`. For that, we're [adding information about Merlin's memory usage to its telemetry](https://github.com/ocaml/merlin/issues/1680). Furthermore, we've looked into refining the typer cache granularity and [have analysed its challenges](https://github.com/ocaml/merlin/issues/1637#issuecomment-1781232379).
