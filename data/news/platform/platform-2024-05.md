---
title: "Platform Newsletter: March-May 2024"
description: Monthly update from the OCaml Platform team.
date: "2024-06-10"
tags: [platform]
---

Welcome to the eleventh edition of the OCaml Platform newsletter!

In this March-May 2024 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**

- Explorations on Dune package management have reached a Minimal-Viable-Product (MVP) stage: a version of Dune that can build non-trivial projects like [OCaml.org](https://github.com/ocaml/ocaml.org) and [Bonsai](https://github.com/janestreet/bonsai). With a working MVP, the team is shifting their focus to putting Dune package management in the hands of the community. To that end, we have started the Dune Developer Preview Program, where we will test Dune package management with users and refine the user experience in preparation for a final release.
- The opam team released a second beta of [opam 2.2](https://discuss.ocaml.org/t/ann-opam-2-2-0-beta2/14461), and with it, opened the [final PR](https://github.com/ocaml/opam-repository/pull/25861) to add support for Windows OCaml to the opam-repository. Once the PR is merged, opam 2.2 will be usable with the upstream opam-repository on Windows, paving the way for a third beta very soon, and a Release Candidate next.
- The odoc team has finalized the initial design for Odoc 3.0 and opened several [RFCs](https://github.com/ocaml/odoc/discussions) to gather community input. We've implemented a new [Odoc driver](https://github.com/ocaml/odoc/pull/1121) that follows the Odoc 3.0 design and have already started prototyping key parts of the design.
- Merlin's project-wide references query is getting very close to release. The necessary [compiler PR](https://github.com/ocaml/ocaml/pull/13001) has been merged and included in OCaml 5.2, and the [Dune rules PR](https://github.com/ocaml/dune/pull/10422) has been merged and included in Dune 3.16. The next steps are to merge the [PR in Merlin](https://github.com/ocaml/merlin/pull/1766) itself and the small patch in OCaml LSP.
- The set of standard derivers shipped with `ppx_deriving.std` (i.e. `[@@deriving show, make, ord, eq, ...]`) as well as `ppx_deriving_yojson` are now directly written against Ppxlib's API. That impacts developers in two ways. First, it allows you to enjoy reliable editor features in projects with those derivers (Ppxlib preserves Merlin's location invariants). Second, you can avoid a hard dependency on those derivers by using Ppxlib's `deriving_inline` feature on them. Thanks a lot to @sim642 for all your work and very kind patience, @NathanReb for reviewing and release managing, and everyone else involved!

**Releases:**
- [Ppxlib 0.32.1](https://github.com/ocaml/opam-repository/pull/25713)
- [Merlin 5.0](https://ocaml.org/changelog/2024-05-22-merlin-5.0)
- [Dune 3.14.2](https://ocaml.org/changelog/2024-03-13-dune.3.14.2)
- [Dune 3.15.0](https://ocaml.org/changelog/2024-04-03-dune.3.15.0)
- [Dune 3.15.2](https://ocaml.org/changelog/2024-04-23-dune.3.15.2)
- [Dune 3.15.3](https://ocaml.org/changelog/2024-05-26-dune.3.15.3)
- [Odoc 2.4.2](https://ocaml.org/changelog/2024-04-30-odoc-2.4.2)
- [opam 2.1.6](https://ocaml.org/changelog/2024-05-22-opam-2-1-6)
- [opam 2.2.0~beta2](https://ocaml.org/changelog/2024-04-09-opam-2.2.0-beta2)
- [ocamlformat 0.26.2](https://ocaml.org/changelog/2024-04-23-ocamlformat-0.26.2)

## **[Dune]** Exploring Package Management in Dune ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))

**Contributed by:** @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @Alizter

**Why:** Unify OCaml tooling under a single command line for all development workflows. This addresses one of the most important pain points [reported by the community](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0).

**What:** Prototyping the integration of package management into Dune using opam as a library. We're introducing a `dune pkg lock` command to generate a lock file and enhancing `dune build` to handle dependencies in the lock file. More details in the [Dune RFC](https://github.com/ocaml/dune/issues/7680).

**Summary:** 

Over the past three months, significant progress has been made in adding Dune's support for package management. We are thrilled to report that our prototypes have reached a Minimal Viable Product (MVP) stage: an experimental version of Dune package management that can be used to build non-trivial projects, including OCaml.org and Bonsai, which we are using in our tests.

There is still a long way to go, but with this milestone reached, we are now shifting our focus from prototyping to putting the feature in the hands of the community. We are moving to testing the new Dune feature with users, and in particular, now that we have a good understanding of the technical blockers and their workarounds, we will be focusing on validating and refining the developer experience (DX) of Dune package management in preparation for a first release.

To that end, the Dune team has started a Dune Developer Preview Program. We're currently testing the Developer Preview of package management with selected beta testers, and once the biggest issues have been addressed, we'll be opening it to the broader community.

**Activities:**
- Continued addressing remaining issues with ocamlfind and zarith.
  - Added repro PRs for ocamlfind and zarith issues – [ocaml/dune#10233](https://github.com/ocaml/dune/pull/10233), [ocaml/dune#10235](https://github.com/ocaml/dune/pull/10235).
  - Iterated on a solution for relocatable ocamlfind – [ocaml/ocamlfind#72](https://github.com/ocaml/ocamlfind/pull/72).
  - Removed `.mml` references in ocamlfind – [ocaml/ocamlfind#75](https://github.com/ocaml/ocamlfind/pull/75).
  - Set OCAMLFIND_DESTDIR for install actions to fix ocamlfind installation issues – [ocaml/dune#10267](https://github.com/ocaml/dune/pull/10267).
- Added a test reproducing error when locking when a pin stanza contains a relative path outside the workspace – [ocaml/dune#10255](https://github.com/ocaml/dune/pull/10255).
- Fixed package creation issues with directories on different filesystems – [ocaml/dune#10214](https://github.com/ocaml/dune/pull/10214).
- Opened PRs to address user errors, improve error messages, and enhance environment handling for pkg rules – [ocaml/dune#10385](https://github.com/ocaml/dune/pull/10385), [ocaml/ocamlbuild#327](https://github.com/ocaml/ocamlbuild/pull/327), [ocaml/dune#10403](https://github.com/ocaml/dune/pull/10403), [ocaml/dune#10407](https://github.com/ocaml/dune/pull/10407), [ocaml/dune#10455](https://github.com/ocaml/dune/pull/10455).
- Addressed several issues related to `withenv` actions, `dune pkg lock`, and unexpected behavior with variable updates – [ocaml/dune#10404](https://github.com/ocaml/dune/issues/10404), [ocaml/dune#10408](https://github.com/ocaml/dune/issues/10408), [ocaml/dune#10417](https://github.com/ocaml/dune/issues/10417), [ocaml/dune#10440](https://github.com/ocaml/dune/issues/10440), [ocaml/opam#5925](https://github.com/ocaml/opam/issues/5925), [ocaml/opam#5926](https://github.com/ocaml/opam/issues/5926).
- Approved relocatable releases of ocamlfind and ocamlbuild – [ocaml-dune/opam-overlays#1](https://github.com/ocaml-dune/opam-overlays/pull/1), [ocaml-dune/opam-overlays#2](https://github.com/ocaml-dune/opam-overlays/pull/2).
- Cleaned up and sought feedback on the relocatable ocamlfind PR – [ocaml/ocamlfind#72](https://github.com/ocaml/ocamlfind/pull/72).
- To work around the fact that the compiler is not relocatable (yet!), we worked on adding support to Dune to manage compiler and developer tools, an experimental feature we call Dune Toolchain. – [ocaml/dune#10470](https://github.com/ocaml/dune/pull/10470), [ocaml/dune#10474](https://github.com/ocaml/dune/pull/10474), [ocaml/dune#10475](https://github.com/ocaml/dune/pull/10475), [ocaml/dune#10476](https://github.com/ocaml/dune/pull/10476), [ocaml/dune#10477](https://github.com/ocaml/dune/pull/10477), [ocaml/dune#10478](https://github.com/ocaml/dune/pull/10478).
- Addressed various issues related to pkg lock, environment updates, and package management – [ocaml/dune#10512](https://github.com/ocaml/dune/pull/10512), [ocaml/dune#10499](https://github.com/ocaml/dune/pull/10499), [ocaml/dune#10498](https://github.com/ocaml/dune/pull/10498), [ocaml/dune#10531](https://github.com/ocaml/dune/pull/10531), [ocaml/dune#10521](https://github.com/ocaml/dune/pull/10521), [ocaml/dune#10539](https://github.com/ocaml/dune/pull/10539), [ocaml/dune#10540](https://github.com/ocaml/dune/pull/10540), [ocaml/dune#10543](https://github.com/ocaml/dune/pull/10543), [ocaml/dune#10544](https://github.com/ocaml/dune/pull/10544), [ocaml/dune#10545](https://github.com/ocaml/dune/pull/10545), [ocaml/dune#10538](https://github.com/ocaml/dune/issues/10538), [ocaml/dune#10542](https://github.com/ocaml/dune/issues/10542), [ocaml/dune#10595](https://github.com/ocaml/dune/pull/10595), [ocaml/dune#10596](https://github.com/ocaml/dune/pull/10596), [ocaml/dune#10592](https://github.com/ocaml/dune/issues/10592), [ocaml/dune#10593](https://github.com/ocaml/dune/issues/10593).
- Merged PRs to use unpack code for rsync URLs and disable hg/darcs fetch code – [ocaml/dune#10556](https://github.com/ocaml/dune/pull/10556), [ocaml/dune#10561](https://github.com/ocaml/dune/pull/10561).

## **[opam]** Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Ahrefs), @dra27 (Tarides), @AltGr (OCamlPro)

**Why:** Enhance OCaml's viability on Windows by integrating native opam and `opam-repository` support, fostering a larger community, and more Windows-friendly packages.

**What:** Releasing opam 2.2 with native Windows support, making the official `opam-repository` usable on Windows platforms.

**Summary:**

The opam team is getting closer to a final release of opam 2.2 with support for Windows. In the past months, we have released a second beta of opam 2.2, addressing a number of issues reported by users on previous releases, including Windows issues.

Excitingly, we also opened the [final PR](https://github.com/ocaml/opam-repository/pull/25861) adding support for Windows OCaml to opam-repository. With the PR merged, the opam team is expecting to be able to move to a Release Candidate in June.

Stay tuned for more exciting news and releases in the coming weeks and months!

**Activities:**

- Packaging the compiler in opam-repository
  - We cleared WIP items in the [windows-initial](https://github.com/dra27/opam-repository/commits/windows-initial) branch, creating the [mingw-w64-shims](https://github.com/dra27/mingw-w64-shims) repository for the C stub program and generation script needed for the mingw-w64-shims opam package.
  - Various fixes for msvs-detect were upstreamed and the opam packaging PR finalized – [metastack/msvs-tools#17](https://github.com/metastack/msvs-tools/pull/17), [metastack/msvs-tools#18](https://github.com/metastack/msvs-tools/pull/18).
  - Initial upstreaming PRs were opened for Visual Studio configuration – [ocaml/opam-repository#25440](https://github.com/ocaml/opam-repository/pull/25440), reorganization of conf-zstd – [ocaml/opam-repository#25441](https://github.com/ocaml/opam-repository/pull/25441), and native Windows depexts – [ocaml/opam-repository#25442](https://github.com/ocaml/opam-repository/pull/25442).
  - Fixed mccs package dependencies upstream – [ocaml-opam/ocaml-mccs#52](https://github.com/ocaml-opam/ocaml-mccs/pull/52), [ocaml/opam-repository#25482](https://github.com/ocaml/opam-repository/pull/25482).
  - Upstreamed support for source-packaging of flexdll – [ocaml/flexdll#135](https://github.com/ocaml/flexdll/pull/135).
  - Worked on packaging scripts for winpthreads for OCaml 5.3.0 – [ocaml/winpthreads#1](https://github.com/ocaml/winpthreads/pull/1).
  - Further upstreaming PRs were opened for mingw-w64-shims – [ocaml/opam-repository#25454](https://github.com/ocaml/opam-repository/pull/25454), and flexdll and winpthreads sources packages – [ocaml/opam-repository#25512](https://github.com/ocaml/opam-repository/pull/25512).
  - Reviewed and tested changes related to the 4.14.2 release for the sunset branch of opam-repository-mingw – [ocaml-opam/opam-repository-mingw#20](https://github.com/ocaml-opam/opam-repository-mingw/pull/20), [ocaml-opam/opam-repository-mingw#21](https://github.com/ocaml-opam/opam-repository-mingw/pull/21).
  - Updated the [windows-initial](https://github.com/dra27/opam-repository/commits/windows-initial) branch to support MSYS2, including creating [msys2-opam](https://github.com/dra27/msys2-opam) to complement [mingw-w64-shims](https://github.com/dra27/mingw-w64-shims).
  - Upstreamed issues with the ocaml-variants.5.1.1+effect-syntax package – [ocaml/opam-repository#25645](https://github.com/ocaml/opam-repository/pull/25645).
  - Investigated BER MetaOCaml, determining that 4.14.1+BER does not work on Windows and disabled it in opam-repository – [ocaml/opam-repository#25648](https://github.com/ocaml/opam-repository/pull/25648).
  - Worked further on the draft PR, addressing the issue of invalid maintainer email addresses for packages – [ocaml/opam-repository#25826](https://github.com/ocaml/opam-repository/pull/25826).
  - Opened the main PR for Windows compiler support – [ocaml/opam-repository#25861](https://github.com/ocaml/opam-repository/pull/25861), with a parallel draft PR for updating the compiler's opam file – [ocaml/ocaml#13160](https://github.com/ocaml/ocaml/pull/13160).
  - Backported [ocaml/ocaml#13100](https://github.com/ocaml/ocaml/pull/13100) to 5.1.x ocaml-variants – [ocaml/opam-repository#25828](https://github.com/ocaml/opam-repository/pull/25828), awaiting opam 2.2.0~beta3 release.
- Release opam 2.2
  - Completed work on various patches and PRs, including fixes for accented characters in Dune – [ocaml/opam#5861](https://github.com/ocaml/opam/issues/5861), [ocaml/opam#5871](https://github.com/ocaml/opam/pull/5871), [janestreet/spawn#58](https://github.com/janestreet/spawn/pull/58), [ocaml/opam#5862](https://github.com/ocaml/opam/pull/5862).
  - Worked on performance improvements for Windows, including adding job statuses and a proof-of-concept for a spinner on slow-running build jobs – [ocaml/opam#5883](https://github.com/ocaml/opam/pull/5883).
  - Finalizing fix on Cygwin PATH handling for opam 2.2.0 beta2 – [ocaml/opam#5832](https://github.com/ocaml/opam/pull/5832).
  - Mark the internal cygwin installation as recommended - [ocaml/opam#5903](https://github.com/ocaml/opam/pull/5903)
  - Hijack the `%{?val_if_true:val_if_false}%` syntax to support extending the variables of packages with + in their name - [ocaml/opam#5840](https://github.com/ocaml/opam/pull/5840)
  - Fixed issues with downloading URLs with invalid characters and opam's internal state – [ocaml/opam#5921](https://github.com/ocaml/opam/pull/5921), [ocaml/opam#5922](https://github.com/ocaml/opam/pull/5922).
  - Assembled test harnesses for `opam init` and addressed issues with `opam lint` warnings – [dra27/opam-testing](https://github.com/dra27/opam-testing), [ocaml/opam#5927](https://github.com/ocaml/opam/pull/5927), [ocaml/opam#5928](https://github.com/ocaml/opam/pull/5928).
  - Fixed reversal of environment updates and minor issues in GitHub Actions – [ocaml/opam#5935](https://github.com/ocaml/opam/pull/5935), [ocaml/opam#5938](https://github.com/ocaml/opam/pull/5938).
  - [Released opam 2.2~beta2](https://discuss.ocaml.org/t/ann-opam-2-2-0-beta2/14461).
  - Fixed issues related to environment variable handling – [ocaml/opam#5935](https://github.com/ocaml/opam/pull/5935).
  - Finalized fixes for Git for Windows menu – [ocaml/opam#5963](https://github.com/ocaml/opam/pull/5963).
  - Minor fixes to `--cygwin-extra-packages` – [ocaml/opam#5964](https://github.com/ocaml/opam/pull/5964).
  - Refactored `opam init` for a more logical experience – [ocaml/opam#5963](https://github.com/ocaml/opam/pull/5963).
  - Updated lint warning 41 PR – [ocaml/opam#5927](https://github.com/ocaml/opam/pull/5927).
  - Responded to issues found by testers of Windows compiler packages – [ocaml/flexdll#138](https://github.com/ocaml/flexdll/issues/138), [ocaml/flexdll#139](https://github.com/ocaml/flexdll/issues/139).
  - Completely reworked `opam init` to detect Cygwin and MSYS2 installations.
  - Fixed issues with the `?` operator and MSYS2's native curl implementation – [ocaml/opam#5983](https://github.com/ocaml/opam/pull/5983), [ocaml/opam#5984](https://github.com/ocaml/opam/pull/5984).

## **[`odoc`]** Odoc 3.0: Unify OCaml.org and Local Package Documentation ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @panglesd (Tarides), Luke Maurer (Jane Street)

**Why:** Improving local documentation generation workflow will help package authors write better documentation for their packages, and consolidating the different `odoc` documentation generators will help make continuous improvements to `odoc` available to a larger audience.

**What:** We will create conventions that drivers must follow to ensure that their output will be functional. Once established, we will update the Dune rules to follow these rules, access new `odoc` features (e.g., source rendering), and provide similar functionalities to docs.ocaml.org (a navigational sidebar, for instance). This will effectively make Dune usable to generate OCaml.org package documentation.

**Summary:**

The Odoc team has made significant progress on the upcoming Odoc 3.0. We held productive in-person meetings in Paris to discuss crucial design aspects such as the CLI, source code rendering, and references. These discussions led to the publications of RFCs for the various components of the design specification.

We also started implementing a new Odoc driver that adheres to the new design for testing purposes, and began prototyping several of the new features.

While discussions on the RFCs and specific features are still ongoing, we are very excited to have a solid set of design specifications under community review and to have begun implementing key parts of the new design.

**Activities:**

- Investigated package name/library name mismatches and module name clashes – [jonludlam/2997e905a468bfa0e625bf98b24868e5](https://gist.github.com/jonludlam/2997e905a468bfa0e625bf98b24868e5), [jonludlam/0a5f1391ccbb2d3040318b154da8593a](https://gist.github.com/jonludlam/0a5f1391ccbb2d3040318b154da8593a).
- Continued work on odoc 3.0 design, including meetings and discussions, culminating in the publication of the RFC – [ocaml/odoc/discussions/1097](https://github.com/ocaml/odoc/discussions/1097).
- Worked on the navigation PR, added functionalities, fixed bugs, and completed the rebase – [ocaml/odoc#1088](https://github.com/ocaml/odoc/pull/1088).
- Met in Paris to discuss the odoc 3.0 design, covering topics such as CLI, rendering source code, and references.
- Opened a PR with basic support for markdown in standalone pages – [ocaml/odoc#1110](https://github.com/ocaml/odoc/pull/1110).
- Published the current proposal for assets as a discussion – [ocaml/odoc#1113](https://github.com/ocaml/odoc/discussions/1113).
- Continued discussions on Markdown rendering and asset references - [ocaml/odoc#1110](https://github.com/ocaml/odoc/pull/1110).
- Implemented a new driver for testing the odoc 3.0 implementation – [ocaml/odoc#1121](https://github.com/ocaml/odoc/pull/1121), [ocaml/odoc#1128](https://github.com/ocaml/odoc/pull/1128).
- Worked on implementing the --parent-id flag part of the Odoc 3.0 spec – [ocaml/odoc#1126](https://github.com/ocaml/odoc/pull/1126).
- Worked on implementing the `-L` and `-P` flags [ocaml/odoc#1132](https://github.com/ocaml/odoc/pull/1132)

## **[Merlin]** Support for Project-Wide References in Merlin ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))

**Contributed by:** @vds  (Tarides), @Ekdohibs (OCamlPro), @Octachron (INRIA), @gasche (INRIA), @emillon (Tarides), @rgrinberg (Jane Street), @Julow (Tarides)

**Why:** Enhance code navigation and refactoring for developers by providing project-wide reference editor features, aligning OCaml with the editor experience found in other languages.

**What:** Introducing `ocamlmerlin server occurrences` and LSP `textDocument/references` support, extending compiler's Shapes for global occurrences and integrating these features in Dune, Merlin, and OCaml LSP.

**Summary:**

The past few months have seen fantastic progress on releasing Merlin's project-wide reference query: The compiler PR got merged and included in the now released OCaml 5.2; The Dune rules PR got merged, and with it significant performance improvements have been made on the indexing tool. The [final PR](https://github.com/ocaml/merlin/pull/1766) in Merlin is open and under review. That PR as well as the small LSP patch to support the feature are about to be merged.

The PR on Merlin also adds support for the feature in the Merlin server plug-in for Emacs. Support for the Merlin server plug-in for Vim has been added separately. All editor plug-ins based on LSP will support the new feature automatically.

**Activities:**

- We followed up on our compiler PR to improve performance for shape aliases weak reduction. It got merged, and made it into OCaml 5.2.0. – [ocaml/ocaml#13001](https://github.com/ocaml/ocaml/pull/13001)
- We improved the Dune rules that drive the indexer: Simplified the rules, added benchmarks, discussed and improved performance. The PR got merged, and made it into Dune 3.16. - [ocaml/dune#10422](https://github.com/ocaml/dune/pull/10422)
- We polished the indexer `ocaml-index`: Profiled it and improved its speed by a factor ~2, and improved its CLI.
- We added a `:MerlinOccurrencesProjectWide` command to the Vim plug-in based on the Merlin server - [ocaml/merlin#1767](https://github.com/ocaml/merlin/pull/1767)
