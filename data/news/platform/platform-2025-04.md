---
title: "Platform Newsletter: February - April 2025"
description: Update from the OCaml Platform.
date: "2025-05-12"
tags: [platform]
---

Welcome to the fourteenth edition of the OCaml Platform newsletter!

In this February to April 2025 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

**Highlights:**
- **Dune Package Management is now Compatible with Large Parts of the Ecosystem**: The majority of Dune-based packages in opam-repository now build successfully with Dune package management. Continuous monitoring is available at [dune.check.ci.dev](https://dune.check.ci.dev). Technical barriers are being systematically addressed while maintaining compatibility with both opam and Dune workflows to ensure teams can transition at their own pace.
- **Odoc 3.0 Release**: A major upgrade, introducing powerful features like type-based search through Sherlodoc, global sidebar navigation, integrated source code display, multimedia support, hierarchical documentation pages, and cross-package linking that creates truly connected documentation.
- **New minor Emacs Mode:** OCaml-eglot replaces the venerable "merlin-mode", providing modern editor features through `ocaml-lsp-server`.
- **First alpha of opam 2.4.0**: Significant improvements including removal of GNU patch/diff dependencies, better Nix integration, improved pinned repository visibility, UI enhancements for deprecated packages, and new version comparison tools and lock file management features.

**Announcements:**
* ["opam 2.4.0 alpha1 release" on the Opam Blog](https://opam.ocaml.org/blog/opam-2-4-0-alpha1/)
* [OCaml Infrastructure: FreeBSD 14.2 Upgrade](https://ocaml.org/changelog/2025-03-26-freebsd-14.2)
* [OCaml Infrastructure: OCaml-version 4.0.0 released](https://ocaml.org/changelog/2025-03-24-recent-ocaml-versions)

**Calls for Feedback:**
* [Dune Developer Preview Adoption Survey](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160/57?u=sabine)
* [OCaml Editor Plugins Survey](https://discuss.ocaml.org/t/ocaml-editors-plugins-survey/16216)
* [Asking For Community Feedback on the OCaml Platform Communications](https://discuss.ocaml.org/t/asking-for-community-feedback-on-the-ocaml-platform-communications/16142)

**Releases:**

* [opam 2.4.0~alpha1](https://discuss.ocaml.org/t/ann-opam-2-4-0-alpha1/16520)
* [Dune 3.18.2](https://ocaml.org/changelog/2025-04-30-dune.3.18.2)
* [Dune 3.18.1](https://ocaml.org/changelog/2025-04-17-dune.3.18.1)
* [Dune 3.18.0](https://ocaml.org/changelog/2025-04-03-dune.3.18.0)
* [Odoc 3.0](https://ocaml.org/changelog/2025-03-20-odoc-3.0.0)
* [dune-release 2.1.0](https://ocaml.org/changelog/2025-02-03-dune-release-2.1.0)
* [Ppxlib 0.36.0](https://ocaml.org/changelog/2025-03-05-ppxlib-0.36.0)
* [Ppxlib 0.35.0](https://ocaml.org/changelog/2025-02-04-ppxlib-0.35.0)
* [ocaml-eglot 1.2.0](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-2-0/16515)
* [ocaml-eglot 1.1.0](https://github.com/tarides/ocaml-eglot/releases/tag/1.1.0)

## **Dune**

**Roadmap:** [Develop / (W4) Build a Project](https://ocaml.org/docs/platform-roadmap#w4-build-a-project)

Dune 3.18 brings various quality-of-life improvements, bug fixes, and new features. It introduces support for the new `x-maintenance-intent` field in opam packages, allowing maintainers to better communicate project status. The release also includes the new `(format-dune-file ...)` stanza, formalizing the dune format-dune-file command as an inside rule, and adds support for the `not` operator in package dependencies constraints. Several improvements to cache handling of file permissions have been implemented, and users can now utilize the `--prefix` flag when configuring dune with `ocaml configure.ml`, providing greater installation flexibility.

From 3.18.0, Dune now uses shorter paths for inline-test artifacts, allows dash characters in project names created with `dune init`, and displays negative error codes on Windows in hexadecimal format — the customary way to display `NTSTATUS` codes. The release also enhances stability with improved retry mechanisms for file delete operations on Windows under heavy load and provides better warning behavior when failing to discover the project root due to read failures, replacing the previous abort behavior.

Shortly after, Dune 3.18.1 was released with a hotfix that corrects an issue where `pkg-config` would fail to find certain libraries in specific contexts, while Dune 3.18.2 provides support for the upcoming OCaml 5.4 release.

**Activities:**
* [Release of Dune 3.18.2](https://ocaml.org/changelog/2025-04-30-dune.3.18.2)
* [Release of Dune 3.18.1](https://ocaml.org/changelog/2025-04-17-dune.3.18.1)
* [Release of Dune 3.18.0](https://ocaml.org/changelog/2025-04-03-dune.3.18.0)

**Maintained by:** Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter), Etienne Millon (@emillon, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Etienne Marais (@maiste)

### **Dune Package Management**

As of May 9, a large part of Dune-based packages on `opam-repository` now build successfully with Dune package management. At [dune.check.ci.dev](https://dune.check.ci.dev), we provide continuous monitoring of build success across the ecosystem, giving visibility into compatibility before migration.

The effort of making Dune package management compatible with the wider OCaml ecosystem is ongoing and aims to assess when Dune package management is ready for adoption in production settings. We are committed to maintain compatibility with both opam and Dune workflows, ensuring teams can transition at their own pace with minimal disruption to existing projects

Technical barriers have been and are being systematically addressed, e.g. improved handling of ZIP archives, better dependency conflict resolution, and enhanced support for pinned packages that don't use Dune's build system.

**Activities:**
* ["Expanding Dune Package Management to the Rest of the Ecosystem" on the Tarides Blog](https://tarides.com/blog/2025-04-11-expanding-dune-package-management-to-the-rest-of-the-ecosystem/)

### **Dune Developer Preview**

[Dune Developer Preview](https://preview.dune.build/) is an experimental channel that introduces cutting-edge features to streamline OCaml development workflows. Building upon Dune's foundation as OCaml's official build system, this initiative allows us to iterate quickly on ideas and experiment with improving the developer experience and with experimental features. For example, one feature that came out of Dune Developer Preview and made it into the upstream codebase is package management: by enabling Dune to deal with project dependencies, we eliminate the need to juggle multiple tools.

The tooling includes built-in LSP support, formatting capabilities, and a shared cache that dramatically improves build performance. Early adopters are encouraged to [provide feedback](https://docs.google.com/forms/u/2/d/e/1FAIpQLSda-mOTHIdATTt_e9dFmNgUCy-fD55Qzr3bGGsxpfY_Ecfyxw/viewform?usp=send_form) as these experimental features mature toward stable releases.

We are in the process of adopting Dune Developer Preview for the OCaml Platform Tools and other projects. This is to ensure that (1) Dune Developer Preview keeps providing a good developer experience on production codebases and (2) to catch bugs and issues as early as we can. At the moment, we are making a concerted effort to fix issues and add necessary features that block adoption of Dune Developer Preview on the OCaml Platform Tools projects.

We're always interested in and addressing community feedback and bug reports, as well. In March, we conducted a [public survey to better understand the reach, adoption, and experience of/with Dune Developer Preview](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160/57) in the OCaml community.

**Activities:**
* [Dune Developer Preview Adoption Survey](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160/57?u=sabine)

## **Editor Tools**

**Roadmap:** [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code), [Edit / (W20) Refactor Code](https://ocaml.org/tools/platform-roadmap#w20-refactor-code)

To better understand how the OCaml community uses the different editor plugins available for OCaml, and to get an idea which features are most anticipated, we ran a [survey on the OCaml Editors Plugins](https://discuss.ocaml.org/t/ocaml-editors-plugins-survey/16216).

**Notable Activity**
* [OCaml Editor Plugins Survey](https://discuss.ocaml.org/t/ocaml-editors-plugins-survey/16216)
* [April 2025 Editors Dev Meeting](https://github.com/ocaml/merlin/wiki/Public-dev%E2%80%90meetings#-ulysse-voodoos--xavier-xvw--pizzie-piziedust--sonja-pitag-ha--florian-angeletti-octachron--darius-foo-dariusf--andrey-popp-andreypopp--nicolas-ojeda-b%C3%A4r-nojb)  
  Focus: Project-wide occurrences demo
* [February 2025 Editors Dev Meeting](https://github.com/ocaml/merlin/wiki/Public-dev%E2%80%90meetings#-pixie-dust--x-gerard-vemeulen--x-jack-joergensen--x-jean-marc-eber--x-arthur-wendling--x-xavier-van-de-woestyne--x-nicolas-ojeda-bar--x-ulysee-gerard--x-joy-odinaka)  
  Focus: Introduction of ocaml-eglot Emacs mode

**OCaml LSP Server maintained by:** Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by:** Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides)

### Merlin and OCaml LSP Server

Project-wide occurrences are available in both Merlin and OCaml-LSP, allowing developers to find all instances of a symbol across their codebase by running `dune build @build-index -w`. The feature has basic editor support via `merlin-project-occurrences` in Emacs and `:MerlinOccurrencesProjectWide` in Vim. Additionally, users of OCaml 5.3 and LSP-based plugins can experiment with the first iteration on project-wide *renaming*.

### Visual Studio Code plugin

Behind the scenes, some work is happening on improving the developer experience for the OCaml VSCode editor plugin: When `ocaml-lsp-server` is not found in the opam switch, the plugin will prompt the user to offer installing it, and we are working on making the editor plugin work seamlessly with the recent dune package management features.

**Notable Activity**

- WIP on opam: Automatically installing/updating ocaml-lsp-server https://github.com/ocamllabs/vscode-ocaml-platform/pull/1725
- WIP on Dune: Automatically configuring dune package management: https://github.com/ocamllabs/vscode-ocaml-platform/pull/1791


### Emacs support

On January 17, [OCaml-eglot version 1.0.0 was released](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-0-0/15978/14), providing a new
minor emacs mode to enable the editor features provided by **ocaml-lsp-server**.
This replaces the venerable “merlin-mode”, after many years of loyal service.

Subsequent releases [`1.1.0`](https://github.com/tarides/ocaml-eglot/releases/tag/1.1.0) and [`1.2.0`](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-2-0/16515) enable support for
`flycheck` as a configurable alternative to `flymake` (`1.0.0` release),
Emacs `30.1` support, better user experience and error handling, as
well as support for new features.

All these features have enabled OCaml-eglot to support client commands, making it possible to extend OCaml-eglot more easily and to integrate features much more rapidly. Since version `1.2.0`, OCaml-eglot has all the functions of Merlin mode (and more)!

We encourage you to try `ocaml-eglot` (refer to the updated [documentation on editor setup on OCaml.org](https://ocaml.org/docs/set-up-editor#emacs)) and to [give feedback / report bugs by raising an issue on the ocaml-eglot repository](https://github.com/tarides/ocaml-eglot/issues)!

Besides this, we have updated the documentation on Editor Setup on OCaml.org to reflect the new situation for Emacs!

**Notable Activity**
- [Updated Tutorial on Setting Up Emacs Support on OCaml.org](https://ocaml.org/docs/set-up-editor#emacs)
- [Release of ocaml-eglot 1.1.0](https://github.com/tarides/ocaml-eglot/releases/tag/1.1.0)
- [Release of ocaml-eglot 1.2.0](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-2-0/16515)

## **Documentation Tools**

**Roadmap:** [Share / (W25) Generate Documentation](https://ocaml.org/tools/platform-roadmap#w25-generate-documentation)

### Odoc

Odoc 3.0 has arrived after more than a year of development since the previous 2.4 release, bringing significant enhancements to OCaml's documentation tooling. The update introduces powerful new features including type-based search functionality through [Sherlodoc](https://github.com/ocaml/odoc/tree/master/sherlodoc), a global sidebar for improved navigation across documentation pages, and integrated source code display that allows developers to jump directly from documentation to rendered source regardless of module system complexity. Additional highlights include support for multimedia content (images, video, and audio), hierarchical documentation pages for better structure, and cross-package linking capabilities that create truly connected documentation, as well as support for incremental documentation builds.

It's worth noting that Dune does not yet support Odoc 3 as its rules need rewriting to accommodate the new CLI and incremental build capabilities. In the interim, developers can use the standalone `odoc_driver` command to generate documentation for their packages as shown in the ["Remapping dependencies" documentation](https://ocaml.github.io/odoc/odoc-driver/index.html#remapping-dependencies).

The Odoc team encourages all OCaml developers to test their documentation with the new release before publishing packages, which can help avoid post-release fixes like [this example](https://github.com/ocaml/odoc/pull/1333). For a practical introduction to the new features, developers can install the package via `opam install odoc-driver` and explore the comprehensive documentation available for the [Odoc toolchain](https://ocaml.github.io/odoc/).

**Notable Activity**
- [Release of odoc 3.0.0](https://ocaml.org/changelog/2025-03-20-odoc-3.0.0)
- ["Odoc 3: So what?" on Jon Ludlam's blog](https://jon.recoil.org/blog/2025/04/odoc-3.html) - blog post that touches on how odoc 3's cross-package linking capabilities enable writing better manuals

**Maintained by:** Jon Ludlam (@jonludlam, Tarides), Daniel Bünzli (@dbuenzli), Jules Aguillon (@julow, Tarides), Paul-Elliot Anglès d'Auriac (@panglesd, Tarides), Emile Trotignon (@EmileTrotignon, Tarides, then Ahrefs) 

## **Package Management**

### Opam

The [first alpha of opam 2.4.0 has been released](https://opam.ocaml.org/blog/opam-2-4-0-alpha1/), bringing significant improvements. 

The removal of GNU `patch` and `diff` as runtime dependencies reduces cross-platform inconsistencies, as the manager now uses the native OCaml `patch` library instead. Nix users will appreciate Nix support for external dependencies, facilitating more consistent environments across development and production systems.

Notable for daily development work: pinned VCS repositories now display their current revision for better traceability, and several UI improvements provide clearer visibility into deprecated packages. The enhanced command set includes version comparison tools and better lock file management with `opam lock --keep-local`, particularly useful for maintaining consistent dependency states across team environments.

Teams running NixOS will benefit from fixed sandboxing support, while the new `OPAMSOLVERTOLERANCE` environment variable helps resolve persistent solver timeouts that previously was unsolvable by MCCS.

Early testing and feedback from development teams is encouraged to ensure a stable final release. Please [report any issues to the bug-tracker](https://github.com/ocaml/opam/issues).

**Notable Activity**
- ["opam 2.4.0 alpha1 release" on the Opam Blog](https://opam.ocaml.org/blog/opam-2-4-0-alpha1/)
- `opam upgrade` fixes [#6373](https://github.com/ocaml/opam/pull/6373)
- Use `patch` OCaml library instead of the `patch` command [#5892](https://github.com/ocaml/opam/pull/5892)
- Add some lints [#6317](https://github.com/ocaml/opam/pull/6317), [#6438](https://github.com/ocaml/opam/pull/6438)
- Pinning system fixes [#5471](https://github.com/ocaml/opam/pull/5471), [#6343](https://github.com/ocaml/opam/pull/6343), [#6309](https://github.com/ocaml/opam/pull/6309), [#6375](https://github.com/ocaml/opam/pull/6375), [#6256](https://github.com/ocaml/opam/pull/6256), [#5471](https://github.com/ocaml/opam/pull/5471)
- Add `opam admin migrate-extrafiles` command [#5960](https://github.com/ocaml/opam/pull/5960), change opam admin check options [#6335](https://github.com/ocaml/opam/pull/6335)
- Depext system: better performance [#6324](https://github.com/ocaml/opam/pull/6324), enhance OpenBSD [#6362](https://github.com/ocaml/opam/pull/6362)
- Some UI improvments [#6376](https://github.com/ocaml/opam/pull/6376), [#6401](https://github.com/ocaml/opam/pull/6401), [#6358](https://github.com/ocaml/opam/pull/6358), [#6273](https://github.com/ocaml/opam/pull/6273)
- UX improvments: remove `ocaml-system` from default compiler at init [#6307](https://github.com/ocaml/opam/pull/6307)
- Provide a way to avoid solver timeouts [#5510](https://github.com/ocaml/opam/pull/5510)
- Add `opam lock <pkg> --keep-local` [#6411](https://github.com/ocaml/opam/pull/6411)

**Maintained by:** Raja Boujbel (@rjbou - OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Tarides)

### Dune-release

**Roadmap:** [Share / (W26) Package Publication](https://ocaml.org/tools/platform-roadmap#w26-package-publication)

Dune-release 2.1.0, has been released, providing a new command `dune-release delegate-info version`, which makes it easier to identify the current version of a package as inferred by the tool. Additionally, the release introduces more flexibility with the `--dev-repo` flag for `dune-release` and `dune-release publish` commands, allowing users to override the `dev-repo` field specified in the `.opam` file during the release process.

Dune-release no longer publishes documentation to GitHub Pages by default. This decision reflects the OCaml ecosystem's consolidation around centralized documentation, as package documentation is now automatically built and served by [ocaml.org/packages](https://ocaml.org/packages) following publication to the opam repository.

The update also improves compatibility and resolves several issues, including a fix for decoding GitHub URLs and ensuring dune-release works with the experimental package management feature from Dune. The tool now handles the presence of `~/.dune/bin/dune` without failing, making it more robust for developers exploring Dune's newer features.

**Notable Activity**
* [Release of dune-release 2.1.0](https://ocaml.org/changelog/2025-02-03-dune-release-2.1.0)

**Maintained by:** Thomas Gazagnaire (@samoht, Tarides), Etienne Millon (@emillon, Tarides), Marek Kubica (@Leonidas-from-XIV, Tarides)

## Ppxlib

The ppxlib team has released versions 0.35.0 and 0.36.0!

Ppxlib 0.35.0, released in February 2025, brings significant improvements for OCaml 5.3 compatibility by allowing ppx rewriters to operate on files containing the new effect syntax. While ppx extensions and effect syntax can coexist, developers should note that rewriters might encounter errors when processing effect syntax nodes in extension payloads or generated code. The release introduces a new `--use-compiler-pp` driver flag, useful for preserving effect syntax when outputting source code instead of marshalled AST. This update also removes support for compilers older than 4.08.

The latest ppxlib 0.36.0, released in March 2025, updates the internal AST to target OCaml 5.2, enabling ppx authors to leverage features from this version while maintaining compatibility with OCaml 4.08.0 and newer. This release includes notable changes to the representation of functions. Thus, package authors are strongly encouraged to consult [the upgrade guide](https://github.com/ocaml-ppx/ppxlib/wiki/Upgrading-to-ppxlib-0.36.0) as many ppxes may break.

Other improvements include fixing a bug in `loc_of_attribute`, adding support for the `[@@@expand_inline]` transformation and floating attribute context-free transformations, and introducing a `-raise-embedded-errors` flag to the driver.

**Notable Activity**
* [Release of ppxlib 0.36.0](https://ocaml.org/changelog/2025-03-05-ppxlib-0.36.0)
* [Release of ppxlib 0.35.0](https://ocaml.org/changelog/2025-02-04-ppxlib-0.35.0)
* [Upgrade guide for the OCaml 5.3 release of ppxlib](https://github.com/ocaml-ppx/ppxlib/wiki/Upgrading-to-ppxlib-0.36.0)

**Maintained by:** Patrick Ferris ([@patricoferris](https://github.com/patricoferris))

## OCaml Infrastructure

The OCaml infrastructure team has upgraded their OBuilder workers for FreeBSD from version 14.1 to 14.2, which directly impacts two key continuous integration services:

1. **OCaml-CI** ([ocaml.ci.dev](https://ocaml.ci.dev)) - This service automatically tests OCaml projects hosted on GitHub, and will now test against FreeBSD 14.2 instead of 14.1. Projects using this CI service will automatically be tested against the newer FreeBSD version.
2. **opam-repo-CI** ([opam.ci.ocaml.org](https://opam.ci.ocaml.org)) - This service tests pull requests to the opam package repository, and will also now test against FreeBSD 14.2 rather than 14.1.

With the release of `ocaml-version` 4.0.0, the OCaml version considered "recent" has been raised from 4.02 to 4.08. This change affects multiple services that use this definition to determine which OCaml versions to test against:

1. **OCaml-CI** - Will adjust which OCaml compiler versions are tested by default for projects
2. **opam-repo-CI** - Will modify its testing matrix for packages in the opam repository
3. **Docker base image builder** - Will only build images for OCaml 4.08 and newer

As these services update, testing on older OCaml releases (versions 4.02 through 4.07) will be gradually removed. Package maintainers should consider upgrading projects still using pre-4.08 OCaml versions to OCaml 4.08 or higher.

Apart from this, at the end of April 2025, registry.ci.dev, opam-repo-ci, OCaml-CI and get.dune.build were moved from Equinix Hosting to hosting at the Cambridge University Computer Lab, because of the [sunset of the Equinix Metal platform](https://deploy.equinix.com/blog/sunsetting-equinix-metal/).

**Notable Activity**
* ["Moving OCaml-CI" on tunbury.org](https://www.tunbury.org/ocaml-ci/)
* ["Equinix Moves" on tunbury.org](https://www.tunbury.org/equinix-moves/)
* [OCaml Infrastructure: FreeBSD 14.2 Upgrade](https://ocaml.org/changelog/2025-03-26-freebsd-14.2)
* [OCaml Infrastructure: OCaml-version 4.0.0 released](https://ocaml.org/changelog/2025-03-24-recent-ocaml-versions)

### WIP: Odoc 3 on OCaml-Docs-CI

The OCaml documentation pages provided through the [OCaml.org package area](https://ocaml.org/packages) are scheduled to receive significant updates with the release of odoc 3. To enable odoc 3 and all of its new features on OCaml.org, we are overhauling the docs-ci pipeline that powers documentation on ocaml.org. The improved pipeline addresses dependency complexities by using a new tool (https://github.com/jonludlam/opamh) that archives and restores opam packages, eliminating redundant builds of packages like dune that previously occurred thousands of times. The underlying infrastructure is also being upgraded, with plans to migrate docs-ci to a new blade server.

**Notable Activity**
* ["OCaml-Docs-CI and Odoc 3" on Jon Ludlam's blog](https://jon.recoil.org/blog/2025/04/ocaml-docs-ci-and-odoc-3.html) 
