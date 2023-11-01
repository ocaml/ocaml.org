---
title: "Platform Newsletter: June 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-07-18"
tags: [platform]
---

Welcome to the third instalment of the OCaml Platform newsletter!

This edition brings the latest improvements made in June to enhance the OCaml developer experience with the [OCaml Platform](https://ocaml.org/docs/platform). As in the [previous updates](https://discuss.ocaml.org/tag/platform-newsletter), the newsletter features the development workflow currently being explored or enhanced.

The month's standout highlight is undoubtedly the [first alpha release of opam 2.2](https://ocaml.org/changelog/2023-07-04-opam-2-2-0-alpha)! Years in the making (opam 2.1 was released almost two years ago), the significance of the hard work put in by the opam team can't be overstated. Much appreciation goes out to the opam team (Raja Boujbel, David Allsopp, Kate Deplaix, Louis Gesbert, in a united OCamlPro/Tarides collaboration), and especially to Raja Boujbel for diligently pushing the work to completion in order to achieve this alpha. [The announcement](https://ocaml.org/changelog/2023-07-04-opam-2-2-0-alpha) holds more details, and we encourage you to provide feedback on the [Discuss post](https://discuss.ocaml.org/t/ann-opam-2-2-0-alpha-release/12536).

- Releases
- Building Packages
  - [Dune] Exploring Package Management in Dune
  - [opam] Native Support for Windows in opam 2.2
  - [Dune] Improving Dune’s Documentation
  - [Dune] New `dune show` command
- Generating Documentation
  - [odoc] Add Search Capabilities to `odoc`
- Editing and Refactoring Code
  - [Merlin] Support for Project-Wide References in Merlin
  - [Merlin] Improving Merlin’s Performance
  - [OCaml LSP] Upstreaming OCaml LSP’s Fork of Merlin
  - [OCaml LSP] Extract code actions
  - [OCaml LSP] Support for Inlay Hints
- Formatting Code
  - [OCamlFormat] Closing the Gap Between OCamlFormat and ocp-indent

## Releases

June was a bustling month with a total of nine releases! This included three patch releases and one minor release of Dune, the release of the first alpha of opam 2.2, two minor releases of OCaml LSP, a minor release of Ppxlib, and a major release of `dune-release`. To learn about the features and improvements included in all of these, visit the [OCaml Changelog](https://ocaml.org/changelog).

- [Dune 3.8.1](https://ocaml.org/changelog/2023-06-06-dune-3.8.1)
- [Dune 3.8.2](https://ocaml.org/changelog/2023-06-19-dune-3.8.2)
- [Dune 3.8.3](https://ocaml.org/changelog/2023-06-28-dune-3.8.3)
- [Dune 3.9.0](https://ocaml.org/changelog/2023-06-30-dune-3.9.0)
- [opam 2.2.0~alpha](https://ocaml.org/changelog/2023-07-04-opam-2-2-0-alpha)
- [OCaml LSP 1.16.1](https://ocaml.org/changelog/2023-06-21-ocaml-lsp-1.16.1)
- [OCaml LSP 1.16.2](https://ocaml.org/changelog/2023-06-23-ocaml-lsp-1.16.2)
- [Ppxlib 0.30.0](https://ocaml.org/changelog/2023-06-20-ppxlib-0.30.0)
- [Dune-release 2.0.0](https://ocaml.org/changelog/2023-06-24-dune-release-2.0.0)

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides)

There was notable progress on Dune lockdirs this month, the team is nearing the ability to lock and build simple opam packages.

The improvements include:
- The solver's understanding of opam flags (`with-test` and `with-doc`)
- Separate lockdirs per build context, allowing users to configure the policy for choosing package versions.
- Configuration of lockdirs in the `dune-workspace` file per context.
- Improved fetching to work with VCS repos and single files
- System variable values now determined in line with opam's approach

Blockers to implement the end-to-end workflow are currently being discussed, and next month's focus will be on increasing the coverage of opam features.

**Activities:**
- Lock file configuration in workspace -- [#7835](https://github.com/ocaml/dune/pull/7835)
- Use Dyn.variant constructor for Op -- [#7936](https://github.com/ocaml/dune/pull/7936)
- Lockdir package files have .pkg extension -- [#8014](https://github.com/ocaml/dune/pull/8014)
- Fix: Downloading local repo doesn't work -- [#8060](https://github.com/ocaml/dune/pull/8060)
- Test errors for invalid opam repositories -- [#7830](https://github.com/ocaml/dune/pull/7830)
- Lock directory regeneration safety -- [#7832](https://github.com/ocaml/dune/pull/7832)
- Generate lockdir from current switch -- [#7863](https://github.com/ocaml/dune/pull/7863)
- Implementation of `OpamSysPoll` in Dune-terms -- [#7868](https://github.com/ocaml/dune/pull/7868)
- Lockdir encode/decode roundtrip tests -- [#7914](https://github.com/ocaml/dune/pull/7914)
- Document why local opam repo path is a Filename.t -- [#7971](https://github.com/ocaml/dune/pull/7971)
- Lockdir generation using opam switch prefers oldest -- [#7980](https://github.com/ocaml/dune/pull/7980)
- Arguments to specify contexts to `dune pkg lock` -- [#7970](https://github.com/ocaml/dune/pull/7970)
- Lockdirs are data-only -- [#7979](https://github.com/ocaml/dune/pull/7979)
- Prefer newest packages by default -- [#8030](https://github.com/ocaml/dune/pull/8030)
- Don't take global lock in `dune pkg lock` -- [#8016](https://github.com/ocaml/dune/pull/8016)
- Conditional dependencies in lockdir -- [#8050](https://github.com/ocaml/dune/pull/8050)
- Removal of lock_dir field from Lock_dir.Pkg.t -- [#7965](https://github.com/ocaml/dune/pull/7965)
- Feature(pkg): extra sources -- [#8015](https://github.com/ocaml/dune/pull/8015)

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @emillon (Tarides), @Leonidas (Tarides), @3Rafal (Tarides), @christinerose (Tarides), @sabine (Tarides)

The first alpha of opam 2.2 was just released!

The most anticipated feature is native Windows compatibility: opam can now be launched in any Windows terminal! It currently requires a preexisting Cygwin installation, a limitation that is set to be lifted for `alpha2`.

As stated in the announcement, it should be noted that `opam-repository` isn't compatible with Windows just yet. It requires the upstreaming of patches from [`ocaml-opam/opam-repository-mingw`](https://github.com/ocaml-opam/opam-repository-mingw) and [`dra27/opam-repository`](https://github.com/dra27/opam-repository). This is set to occur before the final release of opam 2.2, so `opam init` can work with the upstream `opam-repository` on Windows.

Windows support isn't the only exciting feature in the release. To learn about other significant features included in opam 2.2, please read [the announcement](https://ocaml.org/changelog/2023-07-04-opam-2-2-0-alpha) and don't hesitate to share your feedback on the [Discuss post](https://discuss.ocaml.org/t/ann-opam-2-2-0-alpha-release/12536).

**Activities:**
- Windows support
  - Improved local cygwin installation detection -- [#5544](https://github.com/ocaml/opam/pull/5544)
  - Introduced some updates to Windows shell -- [#5541](https://github.com/ocaml/opam/pull/5541)
  - Fixed detection issue when C++ compiler is prefixed -- [#5556](https://github.com/ocaml/opam/pull/5556)
- Other improvements
  - Fix performance regression in opam install/remove/upgrade/reinstall -- [#5503](https://github.com/ocaml/opam/pull/5503)
  - Adjusted to open the release files for reading -- [#5568](https://github.com/ocaml/opam/pull/5568)
  - Fixed OpenSSL missing message -- [#5557](https://github.com/ocaml/opam/pull/5557)
  - Enhanced error reporting to print version when failing to parse it -- [#5566](https://github.com/ocaml/opam/pull/5566)
- Release management
  - Finalise release: Untie test from opam version -- [#5578](https://github.com/ocaml/opam/pull/5578)
  - Prepared for the 2.2.0~alpha release with essential updates -- [#5580](https://github.com/ocaml/opam/pull/5580)
  - Included 2.2.0-alpha binaries in install.sh -- [#5588](https://github.com/ocaml/opam/pull/5588)
- Post-alpha PRs
  - Readme updates -- [#5589](https://github.com/ocaml/opam/pull/5589)
  - Documentation: update documentation to be embed in ocaml.org -- [#5593](https://github.com/ocaml/opam/pull/5593) [#5594](https://github.com/ocaml/opam/pull/5594)
  - Add some tests -- [#5385](https://github.com/ocaml/opam/pull/5385)
  - Improved output cleanliness when stdout is not a TTY -- [#5595](https://github.com/ocaml/opam/pull/5595)
  - Update lint for conflicts field's filter that does not support package variables -- [#5535](https://github.com/ocaml/opam/pull/5535)
  - Applied autoupdate to silence autogen warnings -- [#5555](https://github.com/ocaml/opam/pull/5555)
- Security audit
  - Fixed opam installing packages without checking their checksum when the local cache is corrupted -- [#5538](https://github.com/ocaml/opam/pull/5538)
  - Reftests: add tests to check url handling behaviours -- [#5560](https://github.com/ocaml/opam/pull/5560)
  - lint: add some lint & fix for url checks -- [#5561](https://github.com/ocaml/opam/pull/5561)
  - opamfile: parse error on escapable paths -- [#5562](https://github.com/ocaml/opam/pull/5562)
  - source: add --no-checksums & --require-checksums flags -- [#5563](https://github.com/ocaml/opam/pull/5563)
  - No more populate opam file with extra-files -- [#5564](https://github.com/ocaml/opam/pull/5564)

### **[Dune]** Improving Dune's Documentation

Contributors: @emillon (Tarides)

The effort to enhance Dune documentation continues. Past efforts focused on the high-level organisation of the documentation, and the new structure was [published](https://dune.readthedocs.io/en/stable/) as part of Dune 3.8 release. This month, various improvements were made to the content of the documentation itself.

**Activities:**
- Add XREFs to actions -- [ocaml/dune#7842](https://github.com/ocaml/dune/pull/7842)
- `.opam.template` files can be generated -- [ocaml/dune#7911](https://github.com/ocaml/dune/pull/7911)
- Filling in gaps in the reference documentation and adding further docs to ocaml.org (dune-glob, xdg).
    - Add reference info about aliases -- [ocaml/dune#7945](https://github.com/ocaml/dune/pull/7945)
    - Improve API docs for XDG -- [ocaml/dune#7958](https://github.com/ocaml/dune/pull/7958)
    - Add index.mld for `dune-glob` -- [ocaml/dune#7989](https://github.com/ocaml/dune/pull/7989)

### **[Dune]** New `dune show` command

Contributors: @Alizter, @rgrinberg (Tarides), @snowleopard (Jane Street)

A new `dune show` command group has been added as an alias to the existing `dune describe` command.

The new command group comes with two new commands, `dune show targets` and `dune show aliases`, to enhance the introspection of Dune projects and discoverability of available Dune commands.

- `dune show targets [OPTION]… [DIR]…` is inspired by `ls` and prints the targets available in a given directory.
- `dune show aliases [OPTION]… [DIR]…` prints the aliases available in a given directory.

Feedback on these new commands is welcome and can be shared on [Dune's issue tracker](https://github.com/ocaml/dune/issues).

**Activities:**
- Create `dune show` command group -- [ocaml/dune#7946](https://github.com/ocaml/dune/pull/7946)
- `dune show targets` and `dune show aliases` commands -- [ocaml/dune#7946](https://github.com/ocaml/dune/pull/7946)

## Generating Documentation

### **[`odoc`]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides), @trefis (Tarides)

The profiling and optimising work that began last month on [sherlodoc](https://github.com/art-w/sherlodoc/) has shown results: the database size was reduced significantly, and the indexing time has also been greatly reduced.

In addition, a complete overhaul of the search feature UI was conducted, with advice from the OCaml.org team.

Attention then turned to testing (and debugging) the indexing/search more extensively.

Additionally, progress was made on outputting usage statistics on the search index. Specifically, support for occurrences was untangled from source code rendering, and support was added for counting occurrences of values, modules, types, module types, class types, and constructors.

The different pull requests are approaching merge-readiness. The next step will be to adapt the Dune and OCaml.org drivers to make the feature available to users of `odoc`.

**Activities:**
- Support for search in `odoc` -- [ocaml/odoc#972](https://github.com/ocaml/odoc/pull/972)
- Collect occurrences information -- [ocaml/odoc#976](https://github.com/ocaml/odoc/pull/976)
- Add labels to basic text block (such as paragraphs and code blocks) -- [ocaml/odoc#974](https://github.com/ocaml/odoc/pull/974)

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @vds (Tarides), @let-def (Tarides)

The entire stack of pull requests required for project-wide references, including the compiler patches, `ocaml-uideps`, Dune, Merlin, and `ocaml-lsp`, has been rebased to include the latest compiler changes.

This allowed for the discovery of some issues with first-class modules and aliases. Alias tracking was also added to the shapes, which is required for occurrences to distinguish between different aliases of the same module.

**Activities:**
- Compiler support for project-wide occurrences -- [voodoos/ocaml#1](https://github.com/voodoos/ocaml/pull/1)
- Use new compile information in CMT files to out build and aggregate indexes -- [voodoos/ocaml-uideps#5](https://github.com/voodoos/ocaml-uideps/pull/5)
- Dune orchestrates index generation -- [voodoos/dune#1](https://github.com/voodoos/dune/pull/1)
- Use new CMT info to provide buffer occurrences and indexes for project-wide occurrences -- [voodoos/merlin#7](https://github.com/voodoos/merlin/pull/7)
- Support project-wide occurrences in `ocaml-lsp` -- [voodoos/ocaml-lsp#1](https://github.com/voodoos/ocaml-lsp/pull/1)

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag (Tarides), @3Rafal (Tarides), @vds (Tarides), @let-def (Tarides)

Efforts to improve Merlin's performance included ongoing work on Merlin benchmarking and error regression CI pipelines. Several issues in `merl-an` were fixed to stabilise the benchmarking CI and the proof of concept (POC) of the error regression CI that was opened in Merlin.

The benchmarking CI was merged at the beginning of July, so Merlin is now being continuously benchmarked for performance regressions.

Next month, experiments will continue on the best approach for the error regression CI before refocusing on concrete performance improvements.

**Activities:**
- Merlin benchmarking CI -- [ocaml/merlin#1640](https://github.com/ocaml/merlin/pull/1640)
- Error regression backend to `merl-an` -- [pitag-ha/merl-an#14](https://github.com/pitag-ha/merl-an/pull/14)
- Merlin behaviour regression CI -- [ocaml/merlin#1642](https://github.com/ocaml/merlin/pull/1642)

### **[OCaml LSP]** Upstreaming OCaml LSP's Fork of Merlin

Contributors: @voodoos (Tarides), @3Rafal (Tarides)

The PR that removes OCaml LSP's fork of Merlin has been merged!

Following the merge, patches were added for compatibility with OCaml 5.1, and OCaml LSP 1.16.1 was released.

**Activities:**
- Use Merlin as a libray -- [ocaml-lsp#1070](https://github.com/ocaml/ocaml-lsp/pull/1070)
- Compatibility with OCaml 5.1 -- [ocaml-lsp#1150](https://github.com/ocaml/ocaml-lsp/pull/1150)

### **[OCaml LSP]** Extract code actions

Contributors: @jfeser, @rgrinberg (Tarides)

OCaml LSP 1.16.1 introduces two new code action kinds to LSP: `Extract local` and `Extract function`.

- The `Extract local` refactoring action takes an expression and introduces it as a new local let-binding in the enclosing function.

```ocaml
let f x =  $x+1$ + 2 (* $..$ is the selected code *)
(* Becomes: *)
let f x = 
  let new_var = x + 1 in 
  new_var + 2
```

- The `Extract function` refactoring action takes an expression and introduces it as a new function in the enclosing module.

```ocaml
let f x =  $x+1$ + 2 (* $..$ is the selected code *)
(* Becomes: *)
let new_fun x = x + 1
let f x = new_fun x + 2
```

**Activities:**
- Add extract code actions -- [ocaml-lsp#870](https://github.com/ocaml/ocaml-lsp/pull/870)

### **[OCaml LSP]** Support for Inlay Hints

Contributors: @jfeser, @rgrinberg (Tarides), @vds (Tarides)

The [LSP 3.17 Spec](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/) introduced the feature of Inlay Hints, an enhancement that allows editors to integrate annotations in line with the text, in order to display parameters names, type hints, and so on.

This month witnessed the commencement of Inlay Hints' implementation in the OCaml LSP server. Currently, the [pull request](https://github.com/ocaml/ocaml-lsp/pull/1159) is undergoing review, with plans to integrate it into the subsequent minor release, OCaml LSP 1.17.0.

![image|383x500](upload://uC1cIXY1ZVcoEbbzv5z2DCaRYv4.png)

**Activities:**
- Preliminary inlay hint support -- [ocaml-lsp#1159](https://github.com/ocaml/ocaml-lsp/pull/1159)

## Formatting Code

### **[OCamlFormat]** Closing the Gap Between OCamlFormat and `ocp-indent`

Contributors: @gpetiot (Tarides) and @EmileTrotignon (Tarides), @Julow (Tarides), @ceastlund (Jane Street)

The pursuit of aligning OCamlFormat's `janestreet` profile more closely with the output of `ocp-indent`, initiated a few months back, continued this month. A significant proportion of the changes this month revolved around the treatment of comments.

The OCamlFormat team is also preparing the release of OCamlFormat 0.26.0, which will include all of the bug fixes and improvements implemented in the past months. If you'd like to get a glimpse of the formatting changes this entails, have a look at some of the preview PRs:

- [Dune](https://github.com/ocaml/dune/pull/8064)
- [Ppxlib](https://github.com/ocaml-ppx/ppxlib/pull/439)
- [Js_of_ocaml](https://github.com/ocsigen/js_of_ocaml/pull/1479)
- [Irmin](https://github.com/mirage/irmin/pull/2262)
- [OCaml LSP](https://github.com/ocaml/ocaml-lsp/pull/1157)
- [`odoc`](https://github.com/ocaml/odoc/pull/979)

**Activities:**
- Refactor handling of comments -- [ocaml-ppx/ocamlformat#2371](https://github.com/ocaml-ppx/ocamlformat/pull/2371)
- Don't mix comments and docstrings -- [ocaml-ppx/ocamlformat#2372](https://github.com/ocaml-ppx/ocamlformat/pull/2372)
- Disable the deprecated alert in code blocks  -- [ocaml-ppx/ocamlformat#2373](https://github.com/ocaml-ppx/ocamlformat/pull/2373)
- Don't escape balanced brackets in code spans -- [ocaml-ppx/ocamlformat#2376](https://github.com/ocaml-ppx/ocamlformat/pull/2376)
- Don't escape @ in the middle of a word -- [ocaml-ppx/ocamlformat#2377](https://github.com/ocaml-ppx/ocamlformat/pull/2377)
- Unwanted break before a unwrapped code span -- [ocaml-ppx/ocamlformat#2378](https://github.com/ocaml-ppx/ocamlformat/pull/2378)
- Preserve blank lines in docstrings -- [ocaml-ppx/ocamlformat#2379](https://github.com/ocaml-ppx/ocamlformat/pull/2379)
