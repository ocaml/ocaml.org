---
title: "Platform Newsletter: November 2025 to January 2026"
description: "OCaml Platform Nov 2025-Jan 2026: Relocatable OCaml merged, opam 2.5.0 with significant speedup, OCaml-LSP 1.25.0 with .mlx support, Dune 3.21.0, Merlin 5.6.1-504, and dune-release 2.2.0"
date: "2026-02-19"
tags: [platform]
---

Welcome to the seventeenth edition of the OCaml Platform newsletter!

In this November 2025 to January 2026 edition, we are excited to bring you the latest on the OCaml Platform, continuing our tradition of highlighting recent developments as seen in [previous editions](https://discuss.ocaml.org/tag/platform-newsletter). To understand the direction we're headed, especially regarding development workflows and user experience improvements, check out our [roadmap](https://ocaml.org/docs/platform-roadmap).

You can [comment on this newsletter on the OCaml Discuss Forums](https://discuss.ocaml.org/t/ocaml-platform-newsletter-november-2025-to-january-2026/)!

You can [subscribe to this newsletter on LinkedIn](https://www.linkedin.com/newsletters/ocaml-platform-newsletter-7305270694567661568/)!

**Highlights:**
- **opam 2.5.0 Released**: Major release featuring incremental opam file loading for up to 70% faster `opam update`, improved shell integration, and better macOS sandbox support
- **Relocatable OCaml Merged**: The final piece of the relocatable OCaml puzzle was merged in December, enabling opam to clone switches instead of recompiling them. This will be available in the first alpha release of OCaml 5.5
- **Dune 3.21.0**: Large release with dozens of fixes, improvements, and new features including OxCaml compiler support and copy-on-write file operations
- **Enhanced Editor Support**: OCaml-LSP 1.25.0 adds `.mlx` file support with formatting, diagnostics, and code actions, plus new custom requests
- **Merlin 5.6.1-504**: Performance optimizations, smarter signature help, and fixed completion for inlined record labels
- **opam-publish 2.7.1**: Fixes for GitHub API token permissions
- **dune-release 2.2.0**: Full compatibility with cmdliner 2.0.0
- **opam-repository Archival**: January 1, 2026 archival run removed 3,264 package versions to maintain repository sustainability

**Backstage OCaml:**
- [OCaml Infrastructure: How the opam-repository Works](https://ocaml.org/backstage/2025-11-05-how-the-opam-repository-works) (Nov 5, 2025)

**Stable Releases:**
- [opam-publish 2.7.1](https://ocaml.org/changelog/2025-11-18-opam-publish-2.7.1) (Nov 18, 2025)
- [opam 2.5.0](https://ocaml.org/changelog/2025-11-27-opam-2.5.0) (Nov 27, 2025)
- [Merlin 5.6.1-504](https://ocaml.org/changelog/2025-12-20-merlin-v5-6-1-504) (Dec 20, 2025)
- [OCaml-LSP 1.25.0](https://ocaml.org/changelog/2025-12-20-ocaml-lsp-1-25-0) (Dec 20, 2025)
- [Dune 3.21.0](https://ocaml.org/changelog/2026-01-16-dune-3-21-0) (Jan 16, 2026)
- [dune-release 2.2.0](https://ocaml.org/changelog/dune-release/2026-01-29-dune-release-2.2.0) (Jan 29, 2026)

**Unstable Releases:**
- [opam 2.5.0~rc1](https://ocaml.org/changelog/2025-11-20-opam-2-5-0-rc1) (Nov 20, 2025)
- [opam 2.5.0~beta1](https://ocaml.org/changelog/2025-11-10-opam-2-5-0-beta1) (Nov 10, 2025)

## OCaml Compiler

### Relocatable OCaml Merged

In December 2025, the final piece of the [Relocatable OCaml](https://www.dra27.uk/blog/platform/2025/12/17/its-merged.html) puzzle was merged, enabling opam to clone switches instead of recompiling them. This feature will be available in the first alpha release of OCaml 5.5.

**What Relocatable OCaml Enables:**
This feature allows the OCaml compiler and its associated tools to be moved to different filesystem locations after installation without breaking functionality. Key benefits include:
- Binary distributions that work regardless of installation path
- Improved flexibility for package managers organizing OCaml installations
- Bundling of specific OCaml versions by developer tools without path conflicts
- Simplified cross-platform distribution

The implementation is the culmination of work by David Allsopp, with review from Samuel Hym, Jonah Beckford, and others. See the [announcement on Discuss](https://discuss.ocaml.org/t/relocatable-ocaml/17253) and the [merged PRs](https://github.com/ocaml/ocaml/pull/14243) ([#14244](https://github.com/ocaml/ocaml/pull/14244), [#14245](https://github.com/ocaml/ocaml/pull/14245), [#14246](https://github.com/ocaml/ocaml/pull/14246), [#14247](https://github.com/ocaml/ocaml/pull/14247)) for technical details.

## Build System

### Dune

[Dune 3.21.0](https://ocaml.org/changelog/2026-01-16-dune-3-21-0) (January 16, 2026) is a large release including dozens of fixes, improvements, and additions from many contributors.

**Notable Additions:**
- (Experimental): `library_parameter` stanza for the OxCaml compiler
- Copy-on-write (COW) when copying files on supporting filesystems (Btrfs, ZFS, XFS) under Linux
- Support for Tangled ATproto-based code repositories
- New `(dir ..)` field on packages to filter stanzas with `--only-packages`
- `dune promotion show` command to preview corrected files
- New `(lang rocq)` build mode for Rocq 9.0 and later
- Support for instantiating OxCaml parameterised libraries
- `dune describe tests` to list tests in the workspace
- Horizontal scrolling in TUI
- Support for expanding variables in `(promote (into ..))`

**Notable Fixes:**
- Fixed `include_subdirs qualified` picking the furthest module instead of the closest
- Improved error messages for invalid version formats with non-ASCII characters
- Fixed crash when running `dune build @check` on libraries with virtual modules
- Allow `$ dune init` to work on absolute paths
- Stop hiding the `root_module` from the include path

For the complete list of changes, see the [full release on GitHub](https://github.com/ocaml/dune/releases/tag/3.21.0).

**Dune Maintained by**: Rudi Grinberg (@rgrinberg, Jane Street), Nicolás Ojeda Bär (@nojb, LexiFi), Marek Kubica (@Leonidas-from-XIV, Tarides), Ali Caglayan (@Alizter, Tarides), Stephen Sherratt (@gridbugs, Tarides), Antonio Nuno Monteiro (@anmonteiro), Sudha Parimala (@Sudha247, Tarides), Ambre Suhamy (@ElectreAAS, Tarides), Puneeth Chaganti (@punchagan, Tarides)

## Package Management

### opam

[opam 2.5.0](https://ocaml.org/changelog/2025-11-27-opam-2.5.0) (November 27, 2025) is a major release with significant performance and usability improvements.

**Key Features:**
- **Massive speedup for `opam update`**: Thanks to @arozovyk, opam update now loads opam files incrementally, only parsing files that have changed since the last update. For typical small diffs, this means operations that took seconds now complete in milliseconds
- **Improved shell integration**: Fixed issues where parts of a previous environment were kept in the current environment, causing various problems
- **Changed default shell integration file**: Now writes to `.bashrc` instead of `.profile` when bash is detected, preventing infinite loop issues
- **AppArmor profile**: The install script now installs an appropriate apparmor profile on systems configured with apparmor (enabled by default on Ubuntu)
- **macOS sandbox improvements**: Allow writing to `/var/folders/` and `/var/db/mds/` directories as required by some macOS core tools

**Build Changes:**
- **Ecosystem cmdliner 2.0.0 compatibility**: opam no longer depends on `cmdliner`, removing a key blocker that prevented cmdliner 1.x and 2.0.0 from being co-installable. This change enables ecosystem-wide migration to cmdliner 2.0.0
- OCaml 5.5 (trunk) support when using dune's dev profile
- The release archive (`opam-full-*.tar.gz`) is now reproducible
- OpenBSD binary is now a full static binary

For more details, see the [official opam 2.5.0 announcement blog](https://opam.ocaml.org/blog/opam-2-5-0/) and [full release notes on GitHub](https://github.com/ocaml/opam/releases/tag/2.5.0).

**opam Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs), David Allsopp (@dra27, Tarides)

### opam-publish

[opam-publish 2.7.1](https://ocaml.org/changelog/2025-11-18-opam-publish-2.7.1) (November 18, 2025) fixes bugs related to the GitHub API token permissions introduced in version 2.7.0.

**Changes:**
- Advertise the need, and check, for the `workflow` scope for GitHub personal access tokens
- Enforce the git remote used to push branches to users' fork to be used instead of the SSH method
- Avoid potential previously used tokens with wrong permissions to be used instead of the new one
- Add support for the opam 2.5 API

**Maintained by**: Raja Boujbel (@rjbou, OCamlPro), Kate Deplaix (@kit-ty-kate, Ahrefs)

### opam-repository Archival: January 1, 2026

On January 1, 2026, the opam-repository completed its scheduled archival run, removing **3,264 package versions** (881 unique packages) marked with `x-maintenance-intent: archival`. This ongoing maintenance process helps keep the repository manageable by removing unmaintained or obsolete package versions.

**What This Means:**
- Archived packages are no longer available in the default opam repository
- CI systems and lock files may need updates if they depend on archived versions
- The archival is based on metadata explicitly set by package maintainers

**Background:**
The archival process was announced by Hannes Mehnert in December 2025 (see the [Discuss announcement](https://discuss.ocaml.org/t/opam-repository-archival-next-run-scheduled-2026-01-01/17587)), giving package maintainers and users time to prepare. Packages can be restored from archival by maintainers upon request.

This maintenance practice ensures the opam repository remains sustainable and focused on actively maintained packages.

### dune-release

[dune-release 2.2.0](https://ocaml.org/changelog/dune-release/2026-01-29-dune-release-2.2.0) (January 29, 2026) brings full compatibility with cmdliner 2.0.0, continuing the ecosystem-wide migration that began with opam 2.5.0's removal of the cmdliner dependency.

**Why This Matters:**
cmdliner 2.0.0 introduced stricter requirements that improve CLI reliability but prevent co-installability with cmdliner 1.x. Following opam 2.5.0's lead in removing this conflict, dune-release 2.2.0 updates to use cmdliner 2.0.0 exclusively. This coordinated effort across the platform tools enables users to upgrade without encountering dependency conflicts.

**Important Changes:**
- **Breaking**: Following cmdliner 2.0's stricter requirements, prefix-matching for command options is no longer supported
- Users must now provide the full wording for all flags (for example, `--skip-tests` instead of `--skip-test`)
- This change ensures compatibility with cmdliner 2.0.0 and aligns with modern CLI best practices
- If you have automation scripts using shortened flags, update them before upgrading

For technical details, see the [cmdliner 2.0.0 documentation](https://erratique.ch/software/cmdliner/doc/Cmdliner) and the [dune-release PR #512](https://github.com/tarides/dune-release/pull/512).

**Maintained by**: Tarides

## Editor Tools

*Roadmap: [Edit / (W19) Navigate Code](https://ocaml.org/tools/platform-roadmap#w19-navigate-code)*

### OCaml-LSP Server

[OCaml-LSP 1.25.0](https://ocaml.org/changelog/2025-12-20-ocaml-lsp-1-25-0) (December 20, 2025) introduces support for `.mlx` files and new custom requests.

**Features:**
- **`.mlx` Support**: Added support for `.mlx` files, including diagnostics, code actions, hover, and formatting via `ocamlformat-mlx`
- **New Custom Requests**: Added `typeExpression`, `locate`, and `phrase` requests to the server
- **Code-Lens Configuration**: Code-lens for nested `let` bindings is now configurable

**Fixes:**
- The server now falls back to `.merlin` configuration if a `dune-project` file is missing, provided [dot-merlin-reader](https://github.com/ocaml/merlin) is installed
- Improved precision of timestamps for collected metrics

**Related Tools:**
- [ocamlformat-mlx](https://github.com/ocaml-mlx/ocamlformat-mlx) - Formatter for `.mlx` files
- [dot-merlin-reader](https://github.com/ocaml/merlin) - Tool for reading `.merlin` configuration (part of Merlin)

### Merlin

[Merlin 5.6.1-504](https://ocaml.org/changelog/2025-12-20-merlin-v5-6-1-504) (December 20, 2025) brings performance optimizations and improved stability.

**Key Improvements:**
- **Smarter Signature Help**: Now triggers correctly on unfinished `let ... in` bindings and no longer appears redundantly on function names
- **More Reliable Completion**: Fixed issues with completion for inlined record labels
- **Improved Performance**: Optimized buffer indexing and path calculations
- **Bug Fixes**: Resolved a bug where the `document` command concatenated labels and variants incorrectly

**OCaml LSP Server maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Rudi Grinberg (@rgrinberg, Jane Street)

**Merlin maintained by**: Ulysse Gérard (@voodoos, Tarides), Xavier Van de Woestyne (@xvw, Tarides), Muluh Godson (@PizieDust, Tarides)

### OCaml-eglot

We have drastically modified the `xref` backend (allowing navigation from definition to definition) to make it more suitable for OCaml.

In addition, we added the ability to annotate the type of an enclosing active_ (used with the `ocaml-eglot-type-enclosing` command) or simply to type the selection.

These updates have been merged into `main`, making them available via a MELPA update.

**ocaml-eglot maintained by**: Xavier Van de Woestyne (@xvw, Tarides)

## Platform Infrastructure

### OCaml Infrastructure: How the opam-repository Works

The [November 5, 2025 article on the opam-repository](https://ocaml.org/changelog/2025-11-05-how-the-opam-repository-works) provides an in-depth look at this critical piece of OCaml infrastructure. The opam repository serves as the central package registry for the OCaml ecosystem, hosting over 4,500 packages. It relies on dedicated volunteer maintainers who review every submission.

---

As always, we encourage feedback and contributions from the community as we continue to improve the OCaml Platform ecosystem.
