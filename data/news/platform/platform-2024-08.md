---
title: "Platform Newsletter: June-August 2024"
description: Monthly update from the OCaml Platform team.
date: "2024-09-20"
tags: [platform]
---

Welcome to the twelfth edition of the OCaml Platform newsletter!

In this June-August 2024 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**



* **Dune package management soon in public beta:** [Developer Preview Program](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160) expands with 60+ interview sign-ups (16 conducted so far), NPS soaring from +9 to +28! Public beta coming soon with exciting features like automatic dependency locking and dev tool management. [See it in action](https://mas.to/deck/@leostera/112988841207690720)!
* **Opam 2.2 is out:** [Native Windows support is here](https://discuss.ocaml.org/t/ann-opam-2-2-0-is-out/14893)! Seamless setup with `opam init`, `opam-repository` compatible with Windows. OCaml on Windows is now a reality.
* **Odoc 3.0 gets close to a release:** New features like global sidebars and media support are ready in odoc. Integration with Dune and OCaml.org pipeline in progress - get ready to test the new documentation experience soon! [Check out the RFCs](https://github.com/ocaml/odoc/discussions/1097).
* **Project-wide references is live:** Merlin 5.1 and OCaml LSP 1.18.0 bring powerful code navigation to your editor. Built on years of compiler work, it's a game-changer for large codebases.
* **Starting to bridge the gap between Merlin and OCaml LSP:** New LSP queries for type enclosing, documentation, and more. We’re working towards consistent, feature-rich experience across all editors powered by OCaml LSP.

**Releases:**



* [opam 2.2.0~beta3](https://ocaml.org/changelog/2024-06-10-opam-2-2-0-beta3)
* [opam 2.2.0~rc1](https://ocaml.org/changelog/2024-06-21-opam-2-2-0-rc1)
* [opam 2.2.0](https://ocaml.org/changelog/2024-07-01-opam-2-2-0)
* [opam 2.2.1](https://ocaml.org/changelog/2024-08-22-opam-2-2-1)
* [Dune 3.16.0](https://ocaml.org/changelog/2024-06-17-dune.3.16.0)
* opam-publish 2.3.1
* [Merlin 5.1](https://ocaml.org/changelog/2024-06-24-merlin-5.1)
* [Merlin 4.16](https://ocaml.org/changelog/2024-06-12-merlin-4.16)
* [Merlin 4.15](https://ocaml.org/changelog/2024-06-03-merlin-54.15)
* [OCaml LSP 1.19.0](https://ocaml.org/changelog/2024-07-31-ocaml-lsp-1.19.0)
* [OCaml LSP 1.18.0](https://ocaml.org/changelog/2024-07-11-ocaml-lsp-1.18.0)
* [Ppxlib 0.33.0](https://ocaml.org/changelog/2024-07-25-ppxlib-0.33.0)


## **Dune Package Management ([W4](https://ocaml.org/docs/platform-roadmap#w4-build-a-project))**

**Contributed by:** @rgrinberg (Jane Street), @Leonidas (Tarides), @gridbugs (Tarides), @maiste (Tarides), @ElectreAAS (Tarides), @moyodiallo (Tarides), @Alizter

**Synopsis:** Integrating package management into Dune, making it the sole tool needed for OCaml development. This unification eliminates installation time (just download Dune's pre-built binary), automates external tool management (e.g., for `dune fmt` or `dune ocamllsp`), and significantly reduces build times through caching (packages and compiler are built only once across projects).

**Summary:**

Following our announcement of reaching the Minimal Viable Product (MVP) stage for Dune's package management in the [last newsletter](https://discuss.ocaml.org/t/ocaml-platform-newsletter-march-may-2024/14765), we've made substantial progress on our stated goals. As promised, we've shifted our focus from prototyping to user testing and refining the developer experience (DX).

The Developer Preview Program (see [latest update](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160)) has expanded significantly from its early stages. We've conducted approximately 16 developer interviews out of the 60 sign ups, representing a diverse cross-section of the OCaml community. The interviewees include both newcomers and experienced OCaml users. Notably, about 40% of participants have over 3 years of OCaml experience, while 35% are relative newcomers with less than a year of experience. The majority come from Linux and macOS environments, with participants representing various sectors including tech companies, research institutions, and independent developers.

These sessions have provided crucial feedback and driven improvements. This extensive user testing has paid off, with the Net Promoter Score jumping from +9 to an estimated +28 - a clear sign that the community is excited about the improvements we've made.

Key developments since the last update include:



* A nightly binary distribution of Dune with package management enabled, which will be made available publicly in the coming weeks.
* We started work on automated handling of developer tools (ocamlformat, ocamllsp, odoc) -- users will be able run `dune fmt`, or `dune ocamllsp`, and Dune will take care of installing OCamlFormat and OCaml LSP automatically if they are not available.
* Implementation of automatic dependency locking when project’s dependency changes -- you can now run Dune in watch mode and let it install your dependencies without any intervention after updating your dune-project
* We’ve enabled Dune cache by default, which works with your package dependencies. With this change, Dune will not recompile dependencies more than once when building new projects, including the compiler!

The team has moved beyond just testing with OCaml.org and Bonsai, now conducting broader compatibility tests across the opam repository. Initial results show about 50% of packages can be authored using Dune with package management, with ongoing efforts to increase the coverage (we expect resolution of a few issues on a select few foundational packages to significantly increase that percentage).

In line with the commitment to prepare for a first release, the team plans to launch a public beta in the coming weeks. This marks a significant step from our current private Developer Preview testing with selected beta testers, to a broader community release.

Stay tuned for the upcoming announcement, and in the meantime, have a look a the demos and some enthusiastic messages from beta testers:



* Demo on [Mastodon](https://mas.to/deck/@leostera/112988841207690720) or [X](https://x.com/leostera/status/1825519465527673238)
* “Just did the dune package management preview, it’s looking very sharp” -- [https://x.com/ckarmstrong/status/1830937156434747566](https://x.com/ckarmstrong/status/1830937156434747566)
* “Really looking forward to this! No more switches, no more opam, just dune behaving like a modern package manager. Having played around with it, it's just so so nice. The focus on DX really makes me hopeful about OCaml's future.” -- [https://x.com/synecdokey/status/1825533523283079474](https://x.com/synecdokey/status/1825533523283079474)

**Activities:**



* Implemented workaround to avoid unstable compilers -- [ocaml/dune#10668](https://github.com/ocaml/dune/pull/10668)
* Added support for multiple checksums ([ocaml/dune#10624](https://github.com/ocaml/dune/pull/10624), [ocaml/dune#10791](https://github.com/ocaml/dune/pull/10791))
* Began upstreaming the Dune toolchain feature ([ocaml/dune#10639](https://github.com/ocaml/dune/pull/10639), [ocaml/dune#10719](https://github.com/ocaml/dune/pull/10719))
* Added implicit relock when dependencies change -- [ocaml/dune#10641](https://github.com/ocaml/dune/pull/10641)
* Improved dependency solving and constraint handling ([ocaml/dune#10726](https://github.com/ocaml/dune/pull/10726))
* Added developer preview features and configuration options ([ocaml/dune#10627](https://github.com/ocaml/dune/pull/10627))
* Implemented progress indicators for package builds and lockfile generation ([ocaml/dune#10802](https://github.com/ocaml/dune/pull/10802), [ocaml/dune#10803](https://github.com/ocaml/dune/pull/10803))
* Improved error messages and logging ([ocaml/dune#10662](https://github.com/ocaml/dune/pull/10662))
* Created extensive test suite for new package management features ([ocaml/dune#10798](https://github.com/ocaml/dune/pull/10798))
* Resolved issues with building specific packages (e.g., seq, lwt) ([ocaml/dune#10788](https://github.com/ocaml/dune/issues/10788), [ocaml/dune#10839](https://github.com/ocaml/dune/issues/10839))
* Enable cache on fetch actions for faster builds ([ocaml/dune#10850](https://github.com/ocaml/dune/pull/10850))
* Improved handling of dev tools like ocamlformat ([ocaml/dune#10647](https://github.com/ocaml/dune/pull/10647))
* Developed tools for testing package compatibility coverage on opam-repository


## **Native Support for Windows in opam 2.2 ([W5](https://ocaml.org/docs/platform-roadmap#w5-manage-dependencies))**

**Contributed by:** @rjbou (OCamlPro), @kit-ty-kate (Ahrefs), @dra27 (Tarides), @AltGr (OCamlPro)

**Synopsis:** Releasing opam 2.2 with native Windows support to enhance OCaml's viability on Windows, making the official `opam-repository` usable on Windows and encouraging more Windows-friendly packages.

**Summary:**

The release of opam 2.2.0, [announced on Discuss](https://discuss.ocaml.org/t/ann-opam-2-2-0-is-out/14893) early July, marks a significant milestone for the OCaml ecosystem. This version brings native support for both the opam client and compiler packages in `opam-repository` on Windows, opening new possibilities for OCaml development on this platform.

opam 2.2.0 officially supports Cygwin and is compatible with MSYS2. Windows users can now run `opam init` in their preferred console for a guided setup, resulting in a fully functional OCaml environment. This release represents the culmination of a [multi-year effort](https://github.com/ocaml/opam/issues/246#issuecomment-2166133625) involving extensive contributions from the community.

The OCaml ecosystem is already adapting to this new capability. A [CI check for Windows compilation](https://github.com/ocaml/opam-repository/pull/26069) has been added to opam-repository, and the [GitHub Action ocaml/setup-ocaml](https://github.com/ocaml/setup-ocaml/releases/tag/v3.0.0) now uses opam 2.2.0, facilitating OCaml development on Windows in GitHub projects.

Community members are actively working to improve Windows compatibility across the ecosystem. Notable efforts include [Hugo Heuzard's](https://github.com/hhugo) work on [OCamlBuild](https://github.com/ocaml/opam-repository/pull/26164) and several other [Windows-related PRs](https://github.com/ocaml/opam-repository/pulls?q=is%3Apr+windows+created%3A%3E2023-06-01).

We encourage package authors to set up Windows CI for their projects and address Windows-related issues. This collective effort will be crucial in expanding OCaml's reach and usability on the Windows platform.

**Activities:**



* Opam binary:
    * Fixed issues with `opam init` on Windows -- [ocaml/opam#5991](https://github.com/ocaml/opam/pull/5991), [ocaml/opam#5992](https://github.com/ocaml/opam/pull/5992), [ocaml/opam#5993](https://github.com/ocaml/opam/pull/5993), [ocaml/opam#5994](https://github.com/ocaml/opam/pull/5994), [ocaml/opam#5995](https://github.com/ocaml/opam/pull/5995), [ocaml/opam#5996](https://github.com/ocaml/opam/pull/5996), [ocaml/opam#5997](https://github.com/ocaml/opam/pull/5997), [ocaml/opam#5998](https://github.com/ocaml/opam/pull/5998), [ocaml/opam#6000](https://github.com/ocaml/opam/pull/6000)
    * Improved status display during slow operations on Windows -- [ocaml/opam#5977](https://github.com/ocaml/opam/pull/5977)
    * Enabled opam to work with Windows usernames containing spaces -- [ocaml/opam#5457](https://github.com/ocaml/opam/pull/5457)
    * Fixed `opam init -yn` to handle menus in the release candidate -- [ocaml/opam#6033](https://github.com/ocaml/opam/pull/6033)
    * Updated PowerShell script for installing opam from GitHub releases: [ocaml/opam#5906](https://github.com/ocaml/opam/pull/5906)
    * Fixed hang issue with `setup-ocaml` and depexts -- [ocaml/opam#6046](https://github.com/ocaml/opam/pull/6046)
* Update opam-repository to be compatible with Windows:
    * Updated `opam-repository` Windows CI -- [ocaml/opam-repository#26081](https://github.com/ocaml/opam-repository/pull/26081), [ocaml/opam-repository#26073](https://github.com/ocaml/opam-repository/pull/26073), [ocaml/opam-repository#26080](https://github.com/ocaml/opam-repository/pull/26080)
    * Added backport of MSVC in OCaml-variants.5.2.0+msvc -- [ocaml/opam-repository#26082](https://github.com/ocaml/opam-repository/pull/26082)
    * Updated native Cygwin depexts -- [ocaml/opam-repository#26130](https://github.com/ocaml/opam-repository/pull/26130)
    * Updated opam-repository with Windows-specific package information:
        * Added Windows compiler packages ([ocaml/opam-repository#25861](https://github.com/ocaml/opam-repository/pull/25861))
        * Fixed issues with OCaml variants on Windows ([ocaml/opam-repository#26033](https://github.com/ocaml/opam-repository/pull/26033))
    * Updated and released mingw-w64-shims.0.2.0 to fix setup-ocaml issues ([ocaml/opam-repository#26123](https://github.com/ocaml/opam-repository/pull/26123))
* Released stable version of opam 2.2.0 with full Windows support 🎉 ([announcement](https://ocaml.org/changelog/2024-01-18-opam-2-2-0-beta1))


## **Upgrading OCaml Package Documentation with Odoc 3.0 ([W25](https://ocaml.org/docs/platform-roadmap#w25-generate-documentation))**

**Contributed by:** @jonludlam (Tarides), @julow (Tarides), @panglesd (Tarides), @EmileTrotignon (Tarides), Luke Maurer (Jane Street)

**Synopsis:** Upgrading OCaml package documentation experience with odoc 3, featuring improved navigation, cross-package referencing, media support, and more. This upgrade aims to improve the documentation experience both locally and on OCaml.org, encouraging higher-quality package documentation.

**Summary:**

Following the completion and community review of the RFCs for odoc 3.0, we've made significant strides in implementing the new design and features. Our progress over the past few months has brought us close to a complete implementation of the odoc 3.0 feature set. As we finalize development and approach the first release, our focus is shifting towards integration with the rest of the ecosystem.

Key Developments in the past months include:



* Adding new options to the `odoc` CLI to begin the implementation of the `odoc` 3 CLI
* Implementing new syntax such as path-references
* Developing the global sidebar with a TOC featuring standalone pages and package module hierarchy

As we near completion of the core odoc 3.0 feature set, our focus is shifting towards finalizing integration with Dune and the OCaml.org documentation pipeline. We're excited to get all of these improvements in your hands and get your feedback on the new documentation experience. Stay tuned for announcements regarding testing opportunities and the upcoming release of odoc 3.0!

**Activities:**



* Added `path-references` lookup functionality -- [ocaml/odoc#1150](https://github.com/ocaml/odoc/pull/1150)
* Added the `--current-package` option -- [ocaml/odoc#1151](https://github.com/ocaml/odoc/pull/1151)
* Fixed hierarchical pages being given wrong parent ID -- [ocaml/odoc#1148](https://github.com/ocaml/odoc/pull/1148)
* Parsing of `path-references` to pages and modules ([ocaml/odoc#1142](https://github.com/ocaml/odoc/pull/1142))
* Support for assets and media in documentation ([ocaml/odoc#1184](https://github.com/ocaml/odoc/pull/1184))
* Implemented "Global" sidebar feature ([ocaml/odoc#1145](https://github.com/ocaml/odoc/pull/1145))
* Added support for external pages and non-package documentation ([ocaml/odoc#1183](https://github.com/ocaml/odoc/pull/1183))
* Improved CSS for better visual presentation ([ocaml/odoc#1159](https://github.com/ocaml/odoc/pull/1159))
* Add a marshalled output for index generation ([ocaml/odoc#1084](https://github.com/ocaml/odoc/pull/1084))
* Implemented Voodoo/Dune driver for improved integration ([ocaml/odoc#1168](https://github.com/ocaml/odoc/pull/1168))
* Added frontmatter support to mld pages ([ocaml/odoc#1187](https://github.com/ocaml/odoc/pull/1187))
* Improved breadcrumbs to show packages and libraries ([ocaml/odoc#1190](https://github.com/ocaml/odoc/pull/1190))


## **Project-Wide References in OCaml Editors ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))**

**Contributed by:** @vds (Tarides)

**Synopsis:** Introducing project-wide reference features in Merlin and OCaml LSP to enhance code navigation and refactoring capabilities, bringing OCaml's editor experience in line with other modern programming languages.

**Summary:**

As [announced](https://discuss.ocaml.org/t/ann-project-wide-occurrences-in-merlin-and-lsp/14847) in June, Merlin project-wide references is now available in Merlin 5.1 and the preview of OCaml LSP 1.18.0. Users of LSP-powered editors (like VSCode with the OCaml Platform extension) and classic Emacs and Vim plugins can now query project-wide references of OCaml terms. This requires building the index with the new Dune alias `@ocaml-index`.

This release represents the culmination of a multiyear effort by the Merlin team, including extensive work on the compiler to provide the necessary information for implementing this feature in Merlin.

We're thrilled to share this feature with the community and look forward to your feedback.

While the feature should work well in most cases, we're aware of some limitations. Our next steps include adding support for interface files and module paths. Stay tuned!

**Activities:**



* Completed work on incremental occurrences indexation and related Dune rules -- [ocaml/dune#10422](https://github.com/ocaml/dune/pull/10422)
* Fixed issues with querying from interface files -- [ocaml/merlin#1779](https://github.com/ocaml/merlin/pull/1779), [ocaml/merlin#1781](https://github.com/ocaml/merlin/pull/1781)
* Improved behavior when cursor is on label/constructor declarations -- [ocaml/merlin#1785](https://github.com/ocaml/merlin/pull/1785)
* Released `Merlin.5.1-502`, `ocaml-index.1.0`, and a new preview of `ocaml-lsp-server` with project-wide occurrences support -- [ocaml/opam-repository#26114](https://github.com/ocaml/opam-repository/pull/26114)
* Announced the release on Discuss -- [Project-wide occurrences in Merlin and LSP](https://discuss.ocaml.org/t/ann-project-wide-occurrences-in-merlin-and-lsp/14847)
* Wrote a [wiki page](https://github.com/ocaml/merlin/wiki/Get-project%E2%80%90wide-occurrences) for project-wide occurrences
* Updated [the Merlin website](https://ocaml.github.io/merlin/editor/emacs/#search-for-an-identifiers-occurrences)
* Updated the [platform changelog](https://github.com/ocaml/ocaml.org/pull/2580)
* Improved handling of label and constructor declarations ([ocaml/merlin#1785](https://github.com/ocaml/merlin/pull/1785))
* Contributed compiler improvements:
* Implemented distinct unique identifiers for implementations and interfaces ([ocaml/ocaml#13286](https://github.com/ocaml/ocaml/pull/13286))
* Developed a system for linking unique identifiers of declarations ([ocaml/ocaml#13308](https://github.com/ocaml/ocaml/pull/13308))
* Contributed to improvements in longident locations ([ocaml/ocaml#13302](https://github.com/ocaml/ocaml/pull/13302))


## **Bridging the Gap Between Merlin and OCaml LSP ([W19](https://ocaml.org/docs/platform-roadmap#w19-navigate-code))**

**Contributed by:** @xvw (Tarides), @vds (Tarides)

**Synopsis:** Working towards feature parity between Merlin and OCaml LSP to provide a consistent, feature-rich development experience across all editors, making OCaml LSP the comprehensive backend for OCaml editor support.

**Summary:**

In June, we started work on bridging the gap between OCaml LSP and Merlin. We've started with exposing Merlin's type-enclosing request in OCaml LSP. The feature is now available as `ocamllsp/typeEnclosing` and we will work on editor integration next.

As a reminder, Merlin's `type-enclosing` feature allows users to get the type of the identifier under the cursor. It highlights the identifier and displays its type. Users can climb the typed-tree to display the type of larger expressions surrounding the cursor.

Since June, we’ve worked on a number of new LSP queries and code actions, including:



* A custom `ocamllsp/getDocumentation` query to request the `odoc` documentation
* A custom `ocamllsp/construct` query to browse and fill typed holes (`_`)
* A code-action for syntactic and semantic movement shortcuts based on Merlin's Jump command

**Activities**



* Added custom queries for type enclosing and documentation retrieval:
    * Type enclosing query ([ocaml/ocaml-lsp#1304](https://github.com/ocaml/ocaml-lsp/pull/1304))
    * Documentation query ([ocaml/ocaml-lsp#1336](https://github.com/ocaml/ocaml-lsp/pull/1336))
* Created a custom construct query ([ocaml/ocaml-lsp#1348](https://github.com/ocaml/ocaml-lsp/pull/1348))
* Implemented semantic and syntactic movement shortcuts ([ocaml/ocaml-lsp#1364](https://github.com/ocaml/ocaml-lsp/pull/1364))
* Backported and released Merlin 4.16 with necessary commands ([opam-repository PR](https://github.com/ocaml/opam-repository/pull/26052))
* Refactored usage of `Typedtree` from `ocaml-lsp` to `merlin-lib` ([ocaml/merlin#1811](https://github.com/ocaml/merlin/pull/1811), [ocaml/merlin#1812](https://github.com/ocaml/merlin/pull/1812))
