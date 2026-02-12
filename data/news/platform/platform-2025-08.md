---
title: "Platform Newsletter: May to August 2025"
description: Update from the OCaml Platform.
date: "2025-09-04"
tags: [platform]
---

Welcome to the fifteenth edition of the OCaml Platform newsletter!

In this May to August 2025 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [comment on this newsletter on the OCaml Discuss Forums](https://discuss.ocaml.org/t/ocaml-platform-newsletter-may-to-august-2025/17208)!

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**Highlights:**
- **Enhanced Editor Integration**: OCaml-LSP 1.23.0 and Merlin 5.5 provide improved project navigation and error reporting. New ocaml-eglot brings modern LSP support to Emacs users. Continued work on project-wide features brings OCaml's development experience closer to modern IDEs.
- **Enhanced Package Management**: opam 2.4.0 stable release eliminates GNU patch/diff dependencies, improves newcomer experience by avoiding problematic system compilers by default, and provides better handling of deprecated packages. This addresses common setup issues that previously complicated OCaml adoption.
- **Improved Testing Workflows**: Dune 3.20 introduces concurrent watch mode operations, named test aliases for running specific tests (`@runtest-testname`), and timeout support for cram tests.
- **Documentation and Tooling Maturity**: Odoc 3.1.0 refines cross-package linking capabilities.
- **OCaml 5.4.0-beta1:** you can help test upcoming compiler improvements!

**Announcements:**
- [Emacs Integration for OCaml LSP Server: Introducing ocaml-eglot](https://ocaml.org/changelog/2025-08-26-ocaml-eglot-brings-lsp-support-to-emacs) (August 26, 2025)
- [Dune Developer Preview: Portable External Dependencies for Dune Package Management](https://ocaml.org/changelog/2025-06-05-portable-external-dependencies-for-dune-package-management) (June 5, 2025)
- [Dune Developer Preview: Portable Lock Directories for Dune Package Management](https://ocaml.org/changelog/2025-05-19-portable-lock-directories-for-dune-package-management) (May 19, 2025)

**Stable Releases:**
- [Dune 3.20.1](https://ocaml.org/changelog/2025-08-26-dune3201) (August 26, 2025)
- [Dune 3.20.0](https://ocaml.org/changelog/2025-08-21-dune-3200) (August 21, 2025)
- [Utop 2.16.0](https://ocaml.org/changelog/2025-07-25-utop-2160) (July 25, 2025)
- [opam 2.4.1](http://ocaml.org/changelog/2025-07-23-opam-2-4-1) (July 23, 2025)
- [opam 2.4.0](https://ocaml.org/changelog/2025-07-18-opam-2-4-0) (July 18, 2025)
- [Odoc 3.1.0](https://ocaml.org/changelog/2025-07-15-odoc-310) (July 15, 2025)
- [Ppxlib 0.36.1](https://ocaml.org/changelog/2025-07-10-ppxlib-0361) (July 10, 2025)
- [OCaml-LSP 1.23.0](https://ocaml.org/changelog/2025-06-24-ocaml-lsp-1230) (June 24, 2025)
- [Merlin 5.5-503](https://ocaml.org/changelog/2025-06-24-merlin-v55-503) (June 24, 2025)
- [OCaml-LSP 1.21.0-4.14 for OCaml 4.14](https://ocaml.org/changelog/2025-06-23-ocaml-lsp-1210-414) (June 23, 2025)
- [Merlin 4.19-414](https://ocaml.org/changelog/2025-06-23-merlin-v419-414) (June 23, 2025)
- [Dune 3.19.1](https://ocaml.org/changelog/2025-06-11-dune.3.19.1) (June 11, 2025)
- [Dune 3.19.0](https://ocaml.org/changelog/2025-05-23-dune.3.19.0) (May 23, 2025)

**Unstable Releases:**
- [Dune 3.20.0~alpha4](https://ocaml.org/changelog/2025-08-12-dune-3200alpha4) (August 12, 2025)
- [Dune 3.20.0~alpha3](https://ocaml.org/changelog/2025-08-06-dune-3200alpha3) (August 6, 2025)
- [Dune 3.20.0~alpha2](https://ocaml.org/changelog/2025-08-05-dune-3200alpha2) (August 5, 2025)
- [Dune 3.20.0~alpha1](https://ocaml.org/changelog/2025-07-30-dune-3200alpha1) (July 30, 2025)
- [Dune 3.20.0~alpha0](https://ocaml.org/changelog/2025-07-28-dune-3200alpha0) (July 28, 2025)
- [OCaml 5.4.0-beta1](https://ocaml.org/changelog/2025-07-22-ocaml-540-beta1) (July 22, 2025)
- [opam 2.4.0~rc1](https://ocaml.org/changelog/2025-07-04-opam-240-rc1) (July 4, 2025)
- [opam 2.4.0~beta1](https://ocaml.org/changelog/2025-06-19-opam-240-beta1) (June 19, 2025)
- [OCaml 5.4.0-alpha1](https://ocaml.org/changelog/2025-05-22-ocaml-540-alpha1) (May 22, 2025)
- [Dune 3.19.0~alpha0](https://ocaml.org/changelog/2025-05-20-dune-3190alpha0) (May 20, 2025)
- [opam 2.4.0~alpha2](https://ocaml.org/changelog/2025-05-05-opam-240-alpha2) (May 5, 2025)

---

## Dune

**Roadmap**: [Develop / (W4) Build a Project](https://ocaml.org/docs/platform-roadmap#w4-build-a-project)

The release introduces the `dune describe location` command for printing the path to executables.

`dune runtest` now understands absolute paths and can run tests in specific build contexts. Improvements to cram test handling fix issues where tests attached to multiple aliases would run multiple times.

### Testing Workflow Improvements

Dune 3.20 significantly improves testing workflows with named test aliases. Tests declared with `(test (name a))` can now be run individually using `dune build @runtest-a`. Inline test libraries produce aliases like `@runtest-name_of_lib`, allowing targeted execution of specific test suites without running the entire test battery.

The new `(timeout <float>)` field for cram tests prevents runaway tests from blocking CI pipelines. Combined with the ability to run `dune promote` while watch mode is active, these features remove common friction points in test-driven development workflows.

### Performance and Watch Mode Enhancements

Dune's watch mode now supports concurrent `dune exec` operations and file promotion without requiring restarts, maintaining development flow during iterative changes.

The introduction of the 'empty' alias containing no targets provides more flexible build target management. New `--alias` and `--alias-rec` flags offer alternatives to the `@@` and `@` command-line syntax.

Dune 3.20 switches from MD5 to BLAKE3 for digesting targets and rules, providing both performance improvements and better cryptographic properties.

**Activities:**
- Enhanced implicit transitive dependency handling for OCaml 5.2+ compatibility ([#11866](https://github.com/ocaml/dune/pull/11866))
- Improved alias system with new 'empty' alias support ([#11556](https://github.com/ocaml/dune/issues/11556), [#11952](https://github.com/ocaml/dune/pull/11952), [#11955](https://github.com/ocaml/dune/pull/11955), [#11956](https://github.com/ocaml/dune/pull/11956))
- Better integration between promotion workflows and watch mode ([#12010](https://github.com/ocaml/dune/pull/12010))
- Fixed cram test duplicate execution issues ([#11547](https://github.com/ocaml/dune/pull/11547))
- Added timeout support for cram tests ([#12041](https://github.com/ocaml/dune/pull/12041))
- Added `dune describe location` command ([#11905](https://github.com/ocaml/dune/pull/11905))
- Named test aliases for targeted test execution ([#11558](https://github.com/ocaml/dune/pull/11558), [#11109](https://github.com/ocaml/dune/pull/11109))
- BLAKE3 migration for improved performance ([#11735](https://github.com/ocaml/dune/pull/11735))

**Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter), Etienne Millon (@emillon), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Etienne Marais (@maiste, Tarides)

### Dune Package Management

Portable lock directories appear as an experimental feature. This is a major prospective enhancement for teams working across different platforms. Lockfile naming in the experimental feature now includes version numbers (e.g., `ocaml-compiler.5.3.0.pkg` instead of `ocaml-compiler.pkg`) to handle cases where different platforms require different package versions in the same project.

The portable external dependencies feature extends this capability to system-level dependencies, ensuring consistent build environments across development, testing, and production systems. Combined with the existing binary cache system, this could reduce the complexity of managing OCaml projects in diverse environments.

Note however, that the outcome of these experiments, and whether they mature into features on the stable version of Dune is still open. If you would like to help test and give feedback: run `dune pkg lock` and, if you encounter issues, please report them!

At [dune.check.ci.dev](https://dune.check.ci.dev), continuous monitoring shows ecosystem compatibility progress, with a large part of Dune-based packages in opam-repository now building successfully with Dune package management.

**Activities:**
- Enhanced ecosystem compatibility testing and monitoring at [dune.check.ci.dev](https://dune.check.ci.dev)
- ["Opam Health Check: or How we Got to 90+% of Packages Building with Dune Package Management"](https://tarides.com/blog/2025-06-05-opam-health-check-or-how-we-got-to-90-of-packages-building-with-dune-package-management) - detailed analysis of ecosystem compatibility progress

### Dune Developer Preview

[Dune Developer Preview](https://preview.dune.build?utm_source=ocaml.org&utm_medium=referral&utm_campaign=news) continues to serve as an experimental channel for cutting-edge OCaml development features. The tooling includes built-in LSP support, formatting capabilities, and a shared cache that improves build performance.

The team has expanded testing beyond initial projects to include broader ecosystem validation. The binary repository provides static Linux binaries (built with musl) that work across distributions, along with native binaries for macOS on both x86_64 and aarch64 architectures.

**Activities:**
- Enhanced LSP integration through automated tool management
- Expanded ecosystem compatibility testing as documented in the [Opam Health Check blog post](https://tarides.com/blog/2025-06-05-opam-health-check-or-how-we-got-to-90-of-packages-building-with-dune-package-management)

---

## Package Management

### Opam

The stable release of opam 2.4.0 represents a significant improvement in cross-platform reliability and user experience. The elimination of GNU `patch` and `diff` as runtime dependencies removes a major source of configuration issues that previously complicated deployment and CI/CD pipelines. The package manager now uses the native OCaml `patch` library instead.

The default compiler selection during `opam init` no longer uses `ocaml-system`, which was a common source of setup problems across different development environments. This change provides a more consistent onboarding experience for newcomers to OCaml.

Package lifecycle management receives clearer visibility through enhanced handling of deprecated packages. The `opam show` command displays deprecated packages in gray, while `opam upgrade` removes confusing "not up-to-date" messages for packages being phased out.

Development workflows benefit from the new `OPAMSOLVERTOLERANCE` environment variable, which addresses persistent solver timeout issues. The enhanced pinning system now displays current revisions of pinned repositories, providing better transparency in development workflows that rely on unreleased versions.

For Windows users, the prebuilt binaries now include Cygwin's setup executable as a fallback when cygwin.com is inaccessible, improving reliability in restricted network environments.

**Notable Activity:**
- [opam 2.4.0 stable release](https://opam.ocaml.org/blog/opam-2-4-0/) with comprehensive improvements
- Use `patch` OCaml library instead of the `patch` command ([#5892](https://github.com/ocaml/opam/pull/5892))
- UX improvements: remove `ocaml-system` from default compiler at init ([#6307](https://github.com/ocaml/opam/pull/6307))
- Provide a way to avoid solver timeouts ([#5510](https://github.com/ocaml/opam/pull/5510))
- Add `opam lock <pkg> --keep-local` ([#6411](https://github.com/ocaml/opam/pull/6411))

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Tarides)

---

## Editor Tools

**Roadmap**: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code), [Edit / (W20) Refactor Code](https://ocaml.org/tools/platform-roadmap#w20-refactor-code)

### OCaml LSP Server and Merlin

The release of OCaml-LSP 1.23.0 and Merlin 5.5 brings enhanced project navigation and error reporting capabilities. The release addresses several long-standing issues with jump-to-definition, occurrences reporting, and inlay hints while adding new utilities for working with typed holes.

Project-wide features continue to evolve, with cross-project symbol search and refactoring capabilities bringing OCaml's editor support in line with other modern programming languages. The features work by building an index with `dune build @build-index -w` and provide comprehensive symbol searching across entire codebases.

By the way: we are currently working on a refactor feature that enables automatically extracting and inlining function parameters!

Support for OCaml 4.14 continues with dedicated releases (OCaml-LSP 1.21.0-4.14 and Merlin 4.19-414).

**Activities:**
- Enhanced project navigation and symbol search capabilities
- Better integration with Dune package management workflows
- ["Internship Report: Refactoring Tools Coming to Merlin"](https://tarides.com/blog/2025-08-20-internship-report-refactoring-tools-coming-to-merlin) - new extract command for refactoring

**Notable Activity:**
- Release of [OCaml-LSP 1.23.0](https://ocaml.org/changelog/2025-06-24-ocaml-lsp-1230)
- Release of [Merlin 5.5-503](https://ocaml.org/changelog/2025-06-24-merlin-v55-503)
- OCaml 4.14 support with [OCaml-LSP 1.21.0-4.14](https://ocaml.org/changelog/2025-06-23-ocaml-lsp-1210-414) and [Merlin 4.19-414](https://ocaml.org/changelog/2025-06-23-merlin-v419-414)

**OCaml LSP Server maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides)

### Emacs Integration

The introduction of ocaml-eglot provides Emacs users with modern LSP-based OCaml support as an alternative to the traditional merlin.el. This package leverages Emacs 29's built-in eglot LSP client, offering simplified configuration and access to project-wide features previously unavailable in Emacs.

ocaml-eglot provides feature parity with other editors through ocaml-lsp-server, including project-wide search and rename capabilities. For users migrating from merlin.el, existing keybindings work immediately. The package is actively maintained, while merlin.el enters maintenance-only mode.

The integration works with any OCaml major mode (tuareg, caml-mode, or neocaml) and provides error navigation, type information display, code generation through the "destruct" feature, and enhanced navigation between language constructs.

**Notable Activity:**
- [ocaml-eglot 1.0.0 release](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-0-0/15978/14) bringing LSP to Emacs
- Subsequent releases 1.1.0 and 1.2.0 adding flycheck support and Emacs 30.1 compatibility
- Active development replacing maintenance-only merlin.el

### Visual Studio Code Plugin

We're happy to announce that the Visual Studio Code editor plugin now integrates seamlessly with Dune package management! This is an important milestone for [Dune package management](https://dune.readthedocs.io/en/stable/tutorials/dune-package-management/setup.html), and if you haven't tried it, or have been waiting for it to mature, now is a great time to get started!

Development continues on improving the OCaml VSCode editor plugin experience. For example, when using opam to manage your project's dependencies and `ocaml-lsp-server` is not found in the opam switch, the plugin will now prompt users to install it.

**Notable Activity:**
- Automatically installing/updating ocaml-lsp-server ([#1725](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1725))
- Automatically configuring dune package management ([#1791](https://github.com/ocamllabs/vscode-ocaml-platform/pull/1791))

---

## Documentation Tools

**Roadmap**: [Share / (W25) Generate Documentation](https://ocaml.org/tools/platform-roadmap#w25-generate-documentation)

### Odoc

Odoc 3.1.0 continues to refine the modern documentation experience introduced with Odoc 3.0. The cross-package linking system and multimedia support capabilities help teams create comprehensive and discoverable documentation for complex systems.

The improved documentation tooling addresses ecosystem discoverability and maintainability. The ability to generate interconnected documentation across multiple packages makes large OCaml codebases more accessible for new team members and external collaborators.

Work continues on integrating Odoc 3.x with the OCaml.org documentation pipeline to provide a unified documentation experience across the ecosystem. As of July 2025, Odoc 3 is now live on OCaml.org, bringing the new features to the entire package ecosystem. The improved pipeline addresses dependency complexities by using new tooling that archives and restores opam packages, eliminating redundant builds that previously occurred thousands of times.

**Notable Activity:**
- [Release of Odoc 3.1.0](https://ocaml.org/changelog/2025-07-15-odoc-310)
- ["Odoc 3 is now live on OCaml.org!"](https://jon.recoil.org/blog/2025/07/odoc-3-live-on-ocaml-org.html) - Jon Ludlam's blog post about the deployment of Odoc 3 to ocaml.org
- ["Odoc 3: So what?"](https://jon.recoil.org/blog/2025/04/odoc-3.html) - in-depth explanation of Odoc 3's manual-focused features
- Continued work on OCaml.org documentation pipeline integration through new package archiving tools

**Maintained by**: Jon Ludlam (@jonludlam, Tarides), Daniel Bünzli (@dbuenzli), Jules Aguillon (@julow, Tarides), Paul-Elliot Anglès d'Auriac (@panglesd, Tarides), Emile Trotignon (@EmileTrotignon, Tarides, then Ahrefs)

---

## Ppxlib

Ppxlib 0.36.1 refines the improvements introduced in version 0.36.0, which updated the internal AST to target OCaml 5.2. This enables ppx authors to leverage features from OCaml 5.2 while maintaining compatibility with OCaml 4.08.0 and newer.

The update includes changes to the representation of functions, and package authors are encouraged to consult [the upgrade guide](https://github.com/ocaml-ppx/ppxlib/wiki/Upgrading-to-ppxlib-0.36.0) as some ppxes may require updates.

**Notable Activity:**
- [Release of Ppxlib 0.36.1](https://ocaml.org/changelog/2025-07-10-ppxlib-0361)
- Enhanced support for OCaml 5.2 AST features and compatibility improvements

**Maintained by**: Patrick Ferris ([@patricoferris](https://github.com/patricoferris))

---

## OCaml 5.4.0

OCaml 5.4.0-beta1 provides early access to upcoming compiler improvements and serves as a validation point for the ecosystem. The beta release allows forward-looking projects to begin testing compatibility with the new version while the broader ecosystem prepares for the eventual stable release.

The continued parallel maintenance of OCaml 4.14 LTS ensures that projects with longer upgrade cycles maintain access to critical updates without forced compiler upgrades. This dual-track approach provides flexibility for organizations with different risk tolerance levels.

**Notable Activity:**
- [OCaml 5.4.0-beta1 release](https://ocaml.org/changelog/2025-07-22-ocaml-540-beta1) for early testing
- [OCaml 5.4.0-alpha1](https://ocaml.org/changelog/2025-05-22-ocaml-540-alpha1) provided initial preview
- Continued LTS support for OCaml 4.14 users

---

## Utop

Utop 2.16.0 adds OCaml 5.4 support, restores backtrace functionality, improves preprocessor and Emacs integration, and relocates configuration files to a dedicated utop subdirectory.

**Notable Activity:**
- [Release of Utop 2.16.0](https://ocaml.org/changelog/2025-07-25-utop-2160)

---

We are seeing continued progress toward making OCaml development more accessible and productive. The maturation of Dune package management, stability improvements in opam 2.4.0, and enhanced editor support provide a solid foundation for teams adopting OCaml or expanding their existing OCaml usage.
