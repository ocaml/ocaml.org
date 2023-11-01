---
title: "Platform Newsletter: April 2023"
description: Monthly update from the OCaml Platform team.
date: "2023-05-19"
tags: [platform]
---

Welcome to the first issue of the OCaml Platform newsletter!

Following in the footsteps of the OCaml.org newsletter and inspired by the Multicore and Compiler newsletters, we're excited to bring you monthly updates on the progress we're making in improving the OCaml Developer Experience.

The [OCaml Platform](https://ocaml.org/docs/platform) is the recommended set of tools to work and be productive with OCaml. The Platform tools fill gaps in the OCaml developer experience and allow developers to perform specific workflows (e.g. building packages, formatting code, generating documentation, releasing packages, etc.).

At the end of the day, all the work we're doing on the OCaml Platform has one objective: improving the OCaml developer experience, so in this newsletter, we'll present the progress we're making on the different projects from the lens of these developer workflows. Based on the results of the OCaml surveys ([2020](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0) and [2022](https://ocaml-sf.org/docs/2022/ocaml-user-survey-2022.pdf)), discussions with industrial users, continuous community feedback on Discuss, and other sources of user input, here are the workflows we're currently working on:

- **Building Packages:** Our immediate goal for the build workflow is to remove the friction associated to using two different tools for package management and build system. To this end, we [plan on integrating opam capabilities directly into Dune](https://discuss.ocaml.org/t/explorations-on-package-management-in-dune/12101), establishing it as the singular tool needed to build OCaml projects. As a by-product of this integration, we aim to improve other workflows such as working on multiple projects, cross-compilation, and improving the overall experience to get started with OCaml.
- **Compiling to JavaScript:** We're continuously supporting tools to compile OCaml to JavaScript. Dune integrates well with Js_of_ocaml and we've been working on an integration of Dune and [Melange](https://github.com/melange-re/melange), a recent fork of [ReScript](https://github.com/rescript-lang/rescript-compiler) that aims to bring to integrate closely with the OCaml ecosystem.
- **Generating Documentation:** The state of the OCaml Packages documentation is reported as a major pain point in the OCaml surveys ([2020](https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0) and [2022](https://ocaml-sf.org/docs/2022/ocaml-user-survey-2022.pdf)). We're working towards empowering OCaml developers to create high-quality documentation for their packages. Now that the documentation of packages is [readily available on OCaml.org](https://ocaml.org/packages), we want to make writing documentation rewarding and straightforward. We're working towards making Odoc suitable to create manuals by adding new features, improving the navigation, and expanding the odoc markup syntax to support rich content such as tables, images and graphs.
- **Editing and Refactoring Code:** We aim to enrich the OCaml editor support with more workflows to improve code navigation and automate refactoring. Our main focus currently is on adding support for project-wide references to Merlin. Future work will include implementing a project-wide rename query and queries such as renaming arguments. We are also working towards bringing the editor support for OCaml to the web and third-party platforms such as OCaml Playground, ReplIt, and GitHub Codespaces.
- **Formatting Code:** Our goal for formatting code is focused on improving accuracy, particularly for the to comments. We also want to strike the right balance between providing a default profile that appeals to most users and not requiring configuration to format your OCaml projects, while still maintaining a fully configurable formatter. Additionally, we plan to enhance the backward compatibility of ocamlformat and better integrate Dune and ocamlformat.

I'll also take the opportunity to call for new contributors. Platform projects are always looking for new maintainers and contributors, so if you're interested in the future of OCaml's developer experience and would like to shape that future with us, please reach out to me or any Platform maintainers. If you're an industrial user looking for support on the OCaml Platform and would like to fund the maintainers and the developments on the Platform tools, also don't hesitate to [reach out to me](mailto:thibaut@tarides.com).

April has seen a flurry of activity, and we can't wait to share our progress with you. So let's get right to it!

In this inaugural issue, we'll be discussing progress on the following projects:

- [Releases](#releases)
- [Building Packages](#building-packages)
  - [**\[Dune\]** Exploring Package Management in Dune](#dune-exploring-package-management-in-dune)
  - [**\[opam\]** Native Support for Windows in opam 2.2](#opam-native-support-for-windows-in-opam-22)
  - [**\[Dune\]** Improving Dune's Documentation](#dune-improving-dunes-documentation)
  - [**\[Dune\]** Composing installed Coq theories](#dune-composing-installed-coq-theories)
  - [**\[Dune\]** Dune Terminal User Interface](#dune-dune-terminal-user-interface)
  - [**\[Dune\]** Running Actions Concurrently](#dune-running-actions-concurrently)
  - [**\[Dune\]** Benchmarking Dune on Large Code Bases](#dune-benchmarking-dune-on-large-code-bases)
- [Compiling to JavaScript](#compiling-to-javascript)
  - [**\[Dune\]** Compile to JavaScript with Melange in Dune](#dune-compile-to-javascript-with-melange-in-dune)
- [Generating Documentation](#generating-documentation)
  - [**\[Odoc\]** Add Search Capabilities to `odoc`](#odoc-add-search-capabilities-to-odoc)
  - [**\[Dune\]** User-Friendly Command to Generate Documentation](#dune-user-friendly-command-to-generate-documentation)
  - [**\[Odoc\]** Support for Tables in `odoc`](#odoc-support-for-tables-in-odoc)
- [Editing and Refactoring Code](#editing-and-refactoring-code)
  - [**\[Merlin\]** Support for Project-Wide References in Merlin](#merlin-support-for-project-wide-references-in-merlin)
  - [**\[Merlin\]** Improving Merlin's Performance](#merlin-improving-merlins-performance)
  - [**\[OCaml LSP\]** Using Dune RPC on Windows](#ocaml-lsp-using-dune-rpc-on-windows)
  - [**\[OCaml LSP\]** Upstreaming OCaml LSP's Fork of Merlin](#ocaml-lsp-upstreaming-ocaml-lsps-fork-of-merlin)
- [Formatting Code](#formatting-code)
  - [**\[OCamlFormat\]** Migrate OCamlFormat from an AST to a CST](#ocamlformat-migrate-ocamlformat-from-an-ast-to-a-cst)
  - [**\[OCamlFormat\]** Closing the Gap Between OCamlFormat and `ocp-indent`](#ocamlformat-closing-the-gap-between-ocamlformat-and-ocp-indent)

## Releases

Here are the new versions of Platform tools we released in April. Have a look at the [OCaml Changelog](https://ocaml.org/changelog) to read announcements and feature highlights!

- [UTop 2.12.0](https://github.com/ocaml-community/utop/releases/tag/2.12.0)
- [UTop 2.12.1](https://github.com/ocaml-community/utop/releases/tag/2.12.1)
- [MDX 2.3](https://github.com/realworldocaml/mdx/releases/tag/2.3.0)
- [Dune 3.7.1](https://github.com/ocaml/dune/releases/tag/3.7.1)

## Building Packages

### **[Dune]** Exploring Package Management in Dune

Contributors: @rgrinberg (Tarides), @Leonidas-from-XIV (Tarides), @gridbugs (Tarides), @kit-ty-kate (Tarides)

Earlier this month, we [announced](https://discuss.ocaml.org/t/explorations-on-package-management-in-dune/12101) that we've started exploring package management in Dune. You can read the Request for Comment (RFC) that details our work-in-progress plans for the feature [on GitHub](https://github.com/ocaml/dune/issues/7680).

We're currently focused on building prototypes for different parts of the Dune workflow: source fetching, building non-Dune opam packages, and generating a lock file.

In April, we merged a first version of [Source Fetching](https://github.com/ocaml/dune/pull/7179). We also started thinking about how Dune could build opam packages and [merged a PR](https://github.com/ocaml/dune/pull/7626) laying the foundation for the rules on building them in Dune.

**Activities**:
- Completed and merged a first version of [Source Fetching](https://github.com/ocaml/dune/pull/7179)
- Upstreamed a patch in opam to [remove preprocessing of backwards-compatibility code](https://github.com/ocaml/opam/pull/5508). This helped to reduce the number of dependencies to vendor in Dune when vendoring opam.
- We merged [a PR](https://github.com/ocaml/dune/pull/7626) that lays the foundation and provides a skeleton for the features related to building opam packages.
- Following work on [0install-solver](https://github.com/ocaml-opam/opam-0install-solver), which we'll use as a solver in Dune 4, we open a PR on `ocaml/opam-repository` to [remove constraints on package versions in conflicts](https://github.com/ocaml/opam-repository/pull/23736) and a [patch on opam](https://github.com/ocaml/opam/pull/5535) for the same conflict.

### **[opam]** Native Support for Windows in opam 2.2

Contributors: @rjbou (OCamlPro), @kit-ty-kate (Tarides), @dra27 (Tarides), @emillon (Tarides), @Leonidas-from-XIV (Tarides)

Bringing Tier-1 support for Windows has been a dream for some time and April has seen us get closer than ever before to the first alpha of opam 2.2, which we expect in May. This early alpha is a big step towards the release of opam 2.2 with native Windows support, and is the result of a humongous amount of effort bringing together the work of many people done over the years.

**Activities:**
- Configure: Ensure a complementary (32bit on 64bit platforms and 64bit on 32bit platforms) C compiler is installed on Windows [ocaml/opam#5522](https://github.com/ocaml/opam/pull/5522)
- Do not silently disable MCCS if a C++ compiler is not present [ocaml/opam#5527](https://github.com/ocaml/opam/pull/5527)
- Move the `.ocamlinit` script out of the root directory  [ocaml/opam#5526](https://github.com/ocaml/opam/pull/5526)
- MCCS on Windows does not respect avoid-version [ocaml/opam#5523](https://github.com/ocaml/opam/issues/5523)
- Setup benchmarking using current-bench [ocaml/opam#5525](https://github.com/ocaml/opam/pull/5525)
- Update to latest `msvs-detect` [ocaml/opam#5514](https://github.com/ocaml/opam/pull/5514)
- Fix the compilation of `camlheader` when BINDIR contains escaping characters [ocaml/opam#12214](https://github.com/ocaml/ocaml/pull/12214)
- doc: ? evaluates to true if defined [ocaml/opam#5512](https://github.com/ocaml/opam/pull/5512)
- Stop the configure script from downloading and vendoring dependencies [ocaml/opam#5511](https://github.com/ocaml/opam/pull/5511)
- Remove preprocessing of backwards-compatibility code [ocaml/opam#5508](https://github.com/ocaml/opam/pull/5508)
- Fix linting on `opam-crowbar.opam`  [ocaml/opam#5507](https://github.com/ocaml/opam/pull/5507)
- depexts: reword message [ocaml/opam#5499](https://github.com/ocaml/opam/pull/5499)
- Replace usage of CPPO [ocaml/opam#5498](https://github.com/ocaml/opam/pull/5498)
- Check for the presence of swhid_core in the configure script [ocaml/opam#5497](https://github.com/ocaml/opam/pull/5497)
- Add package stanza on all rules that depend on `opamMain.exe.exe`  [ocaml/opam#5496](https://github.com/ocaml/opam/pull/5496)

### **[Dune]** Improving Dune's Documentation

Contributors: @emillon (Tarides)

In March, we started restructuring the Dune documentation according to the [Diataxis framework](https://diataxis.fr/). We opened [a draft PR](https://github.com/ocaml/dune/pull/7325) to demonstrate the overall target structure. The new structure will improve the usability of the documentation, allowing users to find the information that they are looking for, as well as enable us to better identify gaps that need to be addressed.

In April we’ve continued this work, filling in some of those gaps as well as rewriting documents to better fit in the intended quadrant of the framework.

**Activities:**
- Turn "Automatic Formatting" into a how-to [ocaml/dune#7479](https://github.com/ocaml/dune/pull/7479)
- Move lexical conventions to reference [ocaml/dune#7499](https://github.com/ocaml/dune/pull/7499)
- Turn `opam.rst` into 3 guides [ocaml/dune#7515](https://github.com/ocaml/dune/pull/7515)
- Add some info about writing docs [ocaml/dune#7537](https://github.com/ocaml/dune/pull/7537)
- Merge `classical-ppx` into `preprocessing-spec` [ocaml/dune#7538](https://github.com/ocaml/dune/pull/7538)
- Merge reference info about findlib [ocaml/dune#7567](https://github.com/ocaml/dune/pull/7567)
- Add a lexer for opam files [ocaml/dune#7574](https://github.com/ocaml/dune/pull/7574)

### **[Dune]** Composing installed Coq theories

Contributors: @Alizter and @ejgallego (IRIF)

We've merged the PR that brings [support for composing Coq theories with Dune](https://github.com/ocaml/dune/pull/7047)!

This was a huge effort lead by Ali Caglayan and  Emilio Jesús Gallego Arias that started earlier this year. Starting in Dune 3.8, Coq users will be able to use Dune even if they depend on Coq projects that use other build systems (such as make).

**Activities**:
- Merged the PR that adds [support for composition with installed theories to the Coq rules](https://github.com/ocaml/dune/pull/7047)

### **[Dune]** Dune Terminal User Interface

Contributors: @Alizter, @rgrinberg (Tarides)

We're working on a new Terminal User Interface (TUI) mode for Dune. Our goal is to give Dune users an interactive GUI-like experience right from the terminal, making it easier to interact with build targets, observe processes, and more. The work is still very much in progress, but expect gradual improvements of `dune build --display tui` in the coming months.

![upload_83a40a9ebf9a1196579f609933b1ce14|690x487](upload://xYszYDy7WuicyWDTsRbnq4iy85G.png)

**Activities**:
- Introduced the [new `tui` mode](https://github.com/ocaml/dune/pull/6996) for Dune.
- Enabled Dune to [redisplay 24-bit color output](https://github.com/ocaml/dune/pull/7188).

### **[Dune]** Running Actions Concurrently

Contributors: @Alizter and @hhugo (Nomadic Labs)

In January, we began working on allowing Dune to execute actions and run inline tests concurrently. This month, we merged the two PRs and the feature will be available in the upcoming Dune 3.8. We're especially excited about the ability to run inline tests concurrently to speed up test cycles!

**Activities**:
- We've merged the PR that [implements a new concurrent action](https://github.com/ocaml/dune/pull/6933) in Dune, which allows you to execute actions concurrently.
- We also merged the PR that built on this feature to [enabled Dune to run inline tests concurrently](https://github.com/ocaml/dune/pull/7012).
- We've [patched `ppx_inline_test`](https://github.com/janestreet/ppx_inline_test/pull/40) to leverage the new feature.

### **[Dune]** Benchmarking Dune on Large Code Bases

Contributors: @gridbugs (Tarides), @Leonidas-from-XIV (Tarides)

In March we added [continous benchmarking](https://autumn.ocamllabs.io/ocaml/dune/branch/main?worker=fermat&image=bench%2Fmonorepo%2Fbench.Dockerfile) of Dune builds on a 48 core baremetal system. This is the result of a lot of work that included [building a big monorepo for opam packages](https://github.com/ocaml-dune/ocaml-monorepo-benchmark) allowing users to run Dune benchmarks on large code bases.

In April we added support for benchmarking builds in watch mode as well. This allows us to monitor for regressions as we move forward with major initiatives, such as package management.

**Activities:**
- Add [watch-mode benchmarks](https://github.com/ocaml/dune/pull/7552) of dune monorepo using Dune's streaming RPC interface

## Compiling to JavaScript

### **[Dune]** Compile to JavaScript with Melange in Dune

Contributors: @anmonteiro, @jchavarri (Ahrefs), @rgrinberg (Tarides)

You may have read that [Ahrefs migrated its codebase from ReScript to Melange](https://medium.com/ahrefs/ahrefs-is-now-built-with-melange-b14f5ec56df4), a new OCaml-to-JavaScript compiler based on ReScript.

The goal of Melange is to offer an alternative to ReScript that pairs well with the OCaml ecosystem. To that end, Antonio Nuno Monteiro and Javier Chávarri have been working on integrating Melange and Dune, allowing it to easily compile OCaml projects to JavaScript with Melange.

The feature will be available in the upcoming Dune 3.8. You can already [read the documentation](https://dune.readthedocs.io/en/latest/melange.html) in Dune's manual to get a glimpse of how the feature will work. You can also have a look at the [opam Melange template](https://github.com/melange-re/melange-opam-template) built by the Melange team.

**Activities**
- Write a [manual page](https://github.com/ocaml/dune/pull/7477) in Dune to compile to JavaScript using Melange.
- Make Melange [work on 4.13-5.1](https://github.com/melange-re/melange/pull/548) rather than just 4.14
- In addition to what we did in April, here are some noteworthy PRs that were worked on in previous months:
    - Added a [new field `melange.runtime_deps`](https://github.com/ocaml/dune/pull/7234) to libraries, so that Melange library authors can tell Dune which frontend assets (like CSS or image files, fonts etc) have to be installed with their library
    - [Speed up rule generation](https://github.com/ocaml/dune/pull/7187/) for librariess and executables. This was useful for Melange, but benefits every Dune project.
    - [Make reactjs-jsx-ppx a standalone ppx](https://github.com/melange-re/melange/pull/517)
    - [Implemented a `module_system` field](https://github.com/ocaml/dune/pull/7193) for the melange stanza (e.g. `(module_systems (es6 mjs) (commonjs js) (commonjs cjs))` which allows to output multiple module systems / js extensions at the same time to the melange output folder 

## Generating Documentation

### **[Odoc]** Add Search Capabilities to `odoc`

Contributors: @panglesd (Tarides), @EmileTrotignon (Tarides)

We're working on generating a search index and adding a search bar to `odoc`-generated documentation. We're still exploring the different approaches and we are working with the OCaml.org team to implement a search bar on the OCaml packages documentation.

![upload_4c851e860bc169f2919e1da3ca60c1b8|690x471](upload://uKoE9UjEXF3VnJvWonAsduRJxL0.png)

**Activities**:
- We started [prototyping](https://github.com/panglesd/odoc/tree/search-bar) the search index and search bar and we're discussing the design of it. In particular, we've used the compiler Shapes in the prototype and we'll explore using odoc's path resolver instead as a next step.

### **[Dune]** User-Friendly Command to Generate Documentation

Contributor: @EmileTrotignon (Tarides), @jonludlam (Tarides)

We're working towards making generating documentation in Dune more accessible, especially for newcomers. Currently, the `dune build @doc` command generates documentation in the `_build` directory, and users simply have to know that they need to `open _build/default/_doc/_html/index.html`. To work around this, we're working on a new `dune ocaml doc` command to generate documentation and open it in the browser directly.

**Activities**:
- We opened a PR that [implements the `dune ocaml doc`](https://github.com/ocaml/dune/pull/7262) command in March. This month, we tested the feature on macOS. We are now working towards completing the Windows tests.

### **[Odoc]** Support for Tables in `odoc`

Contributors: @gpetiot (Tarides), @panglesd (Tarides), @Julow (Tarides), @jonludlam (Tarides)

Currently, the only way to create tables with odoc is to inline HTML code in the documentation. Tis is not ideal as the HTML table syntax is not well-suited as documentation markup and the tables can only be rendered by the HTML renderer (so tables are not available in LaTex and manpages). We're working towards a new special syntax in odoc for creating tables that is easier to use and can be rendered by all renderers.

The syntax support has been [merged in odoc-parser](https://github.com/ocaml-doc/odoc-parser/pull/11). It provides a heavy-syntax, and a ligh-syntax inspired by Markdown:
```
{t
  a  | b | c | d
  ---|:--|--:|:-:
  a  | b | c | d
}
```

The [support for the feature in odoc](https://github.com/ocaml/odoc/pull/893) isn't merged yet, but should be available in the next odoc version!


**Activities**
- No new activity in March, but here are Pull Requests we have been working on until now:
  - Add a new syntax for tables in odoc-parser ([odoc-parser#11](https://github.com/ocaml-doc/odoc-parser/pull/11))
  - Fix light table parsing ([odoc-parser#14](https://github.com/ocaml-doc/odoc-parser/pull/14))
  - Add support for tables to odoc ([odoc#893](https://github.com/ocaml/odoc/pull/893))

## Editing and Refactoring Code

### **[Merlin]** Support for Project-Wide References in Merlin

Contributors: @voodoos (Tarides)

Our work on Merlin focuses on the [long-standing](https://discuss.ocaml.org/t/search-for-occurrences-of-a-symbol-in-a-project-file-using-merlin-ocaml-lsp/10756/7?u=tmattio) project to add project-wide occurrences support to Merlin. In April, we continued to work on the [compiler patches](https://github.com/ocaml/ocaml/pull/12142) that allow to generate the index from the compiler, and we updated the Merlin patches to work with the compiler patches, simplifying the Merlin logic that can now rely on the compiler.

The feature requires patches for the OCaml compiler, Dune, and Merlin that are still unreleased, but if you're courageous, you can give it a try by following the documentation on [`voodoos/merlin-occurrences-switch`](https://github.com/voodoos/merlin-occurrences-switch).

**Activities**
- We backported the compiler-side-indexation to 4.14. We performed benchmarks to evaluate the impact on build time and the size of the installed `cmt`s. We posted the results on the PR, for both the [build time](https://github.com/ocaml/ocaml/pull/12142#issuecomment-1504006093) and [cmts size](https://github.com/ocaml/ocaml/pull/12142#issuecomment-1505536484).
- We also reworked the iterator performing indexation and added most of the missing cases to the indexer. However, some elements remain unindexed due to constraints with the `Typedtree`.
- We updated the "indexing" external tool following partial indexation implementation in the compiler.
- We also ported new compiler changes to Merlin on the OCaml 5.1 preview, which will allow us to work on project-wide occurrences support.
- Finally, we started refactoring and simplifying the Merlin patches to query the index now that more work is done by the compiler.

### **[Merlin]** Improving Merlin's Performance

Contributed by: @pitag-ha (Tarides)

Following reports that Merlin performance scaled poorly in large code bases, we had been working on [Merl-an](https://github.com/pitag-ha/merl-an), a tool to measure the performance of different Merlin requests.

In March, we were able to use it to identify the major performance bottlenecks, the biggest one being the PPX phase. We implemented a [caching strategy for PPX](https://github.com/ocaml/merlin/pull/1584) and continued to work on it throughout April.

**Activities:**
- We worked on fixing the PPX cache and explored mechanisms to toggle the PPX phase cache. We ended up implementing a [flag-based approach](https://github.com/ocaml/merlin/pull/1584/commits/c54d10927f28f96372bdb1c5c50b5e839909a51e).
- We [added six tests](https://github.com/ocaml/merlin/pull/1584/commits/99bba403a1a946c3afe3d15c02128f4321904129) that cover default behavior, cache hits, cache invalidation of three kinds, and behavior in case of PPX dependencies.

### **[OCaml LSP]** Using Dune RPC on Windows

Contributors: @nojb (LexiFi)

In February, we released Dune 3.7.0 with [support for watch mode on Windows](https://github.com/ocaml/dune/pull/7010). Building on this work, this month we fixed a couple of issues in Dune and OCaml LSP to allow OCaml LSP to use Dune RPC. This allows VSCode users to leverage Dune RPC and get build statuses and more exhaustive build errors in the editor when Dune is running in watch mode. The fixes are not released yet, but they will be available on the upcoming releases of Dune and OCaml LSP.

**Activities**:
- We [made a patch](https://github.com/ocaml/dune/pull/7666) in Dune to use the RPC protocol on Windows.
- We [fixed a bug](https://github.com/ocaml/ocaml-lsp/pull/1079) in OCaml-LSP to enable the communication with Dune RPC on Windows.

### **[OCaml LSP]** Upstreaming OCaml LSP's Fork of Merlin

Contributors: @voodoos (Tarides), @3Rafal (Tarides)

We're at the finish line of our efforts to close the gap between Merlin and OCaml LSP by upstreaming OCaml LSP's fork of Merlin! This month, we continued on the Merlin PR that [adds a hook to OCaml LSP letting it run system commands](https://github.com/ocaml/merlin/pull/1585). We also opened [a PR on `ocaml-lsp`](https://github.com/ocaml/ocaml-lsp/pull/1070) to use the above patch and remove Merlin's fork entirely. We're expecting to release a version of OCaml LSP that uses Merlin as a library very soon.

**Activities:**
- We discussed and reviewed changes that let you configure the process spawn for PPXs when using Merlin as a library. This led us to implement ideas concerning the exposed hook for PPX process spawning. Subsequently, we [documented the complexities](https://github.com/ocaml/merlin/blob/master/src/utils/lib_config.mli#L22) of splitting a PPX command between program and arguments.
- We opened [a PR on `ocaml-lsp`](https://github.com/ocaml/ocaml-lsp/pull/1070) to remove Merlin's fork and use Merlin as a library.

## Formatting Code

### **[OCamlFormat]** Migrate OCamlFormat from an AST to a CST

Contributors: @gpetiot (Tarides), @EmileTrotignon (Tarides)

Back in 2022, @trefis built [a prototype of a new OCaml formatter](https://github.com/tarides/ocamlformat-ng) that uses a Conrete Syntax Tree (CST) instead of an Abstract Syntax Tree (AST). This mode retains more information and results in more accurate formatting in a lot of cases, most especially when formatting comments which is a big pain point with OCamlFormat.

Since then, we've worked on migrating OCamlFormat's syntax tree to this CST. We chose not to migrate everything at once to minimize the impact on users as much as possible, making sure that we make formatting changes only when they are bug fixes or clear improvements.

You can track our progress in [this PR](https://github.com/ocaml-ppx/ocamlformat/pull/2213), which shows a diff of the current syntax tree and the target CST.

**Activities:**
- We made progress on the work-in-progress PR to [preserve comments attached to labelled args](https://github.com/ocaml-ppx/ocamlformat/pull/2332), fixing more regressions.
- We implemented a change to [keep literal char value during parsing](https://github.com/ocaml-ppx/ocamlformat/pull/2343).
- We worked on [preserving the functor concrete syntax in the Parsetree](https://github.com/ocaml-ppx/ocamlformat/pull/2345).
- We [normalized functions in the parser](https://github.com/ocaml-ppx/ocamlformat/pull/2350).

### **[OCamlFormat]** Closing the Gap Between OCamlFormat and `ocp-indent`

Contributors: @gpetiot (Tarides), @EmileTrotignon (Tarides), @Julow (Tarides)

The OCamlFormat team has been working with the Jane Street teams to migrate Jane Street's code base from ocp-indent to OCamlFormat.
As a result, we've made tons of changes to the `janestreet` profile in recent months. Perhaps most notably, this work has allowed us to identify issues that were not specific to the `janestreet` profile, and consequently we've been fixing bugs and implementing formatting improvements across the board.

We're nearing the end of this project, but April has seen a lot of bug fixes and improvements that we detail below.

**Activities:**
- We adjusted the indentation for several language features, including [extensions](https://github.com/ocaml-ppx/ocamlformat/pull/2330), [class-expr function bodies](https://github.com/ocaml-ppx/ocamlformat/pull/2328), and [module-expr extensions](https://github.com/ocaml-ppx/ocamlformat/pull/2323).
- We fixed issues with [ocp-indent compatibility](https://github.com/ocaml-ppx/ocamlformat/pull/2321) and [Let vs LetIn detection after 'struct'](https://github.com/OCamlPro/ocp-indent/pull/324).
- We improved the [formatting of module arguments](https://github.com/ocaml-ppx/ocamlformat/pull/2322) and worked on [preserving comments attached to labelled args](https://github.com/ocaml-ppx/ocamlformat/pull/2332).
- We fixed issues causing changes to the AST due to strings in [code blocks](https://github.com/ocaml-ppx/ocamlformat/pull/2338) and [comments](https://github.com/ocaml-ppx/ocamlformat/pull/2344).
- We improved the [formatting of cinaps comments with strings](https://github.com/ocaml-ppx/ocamlformat/pull/2349) and worked on parsing and [normalizing cinaps comments](https://github.com/ocaml-ppx/ocamlformat/pull/2354).
- We made adjustments to the handling of certain language constructs, such as [protecting match after `fun _ : _ ->`](https://github.com/ocaml-ppx/ocamlformat/pull/2352) and [consistently wrapping ( :: )](https://github.com/ocaml-ppx/ocamlformat/pull/2347).
- We extended our test suite with [numstat and a single run of ocp-indent](https://github.com/ocaml-ppx/ocamlformat/pull/2355).
