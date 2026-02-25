---
title: OCaml Multicore - January 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-01-01"
tags: [multicore]
---

Welcome to a double helping of the multicore monthlies, with December 2020 and January 2021 bundled together (the team collectively collapsed into the end of year break for a well deserved rest). We encourage you to review all the [previous monthly ](https://discuss.ocaml.org/tag/multicore-monthly) updates for 2020 which have been compiled by @shakthimaan, @kayceesrk, and me.

Looking back over 2020, we achieved a number of major milestones towards upstreaming multicore OCaml. The major highlights include the implementation of the eventlog tracing system to make debugging complex parallelism practical, the enormous rebasing of from OCaml 4.06 to 4.11, a chapter on parallel programming, the publication of "Retrofitting Parallelism onto OCaml" at ICFP 2020, the production use of the Sandmark benchmark, and the implementation of system threading integration.  While all this was happening in the multicore code trees, the upstreaming efforts into mainline OCaml also went into full gear, with @xavierleroy leading the efforts from the core team to ensure that the right pieces went into various releases of OCaml with the same extensive code review as any other features get.

The end of 2020 saw  enhancements and updates to the ecosystem libraries, with more tooling becoming available. In particular, we would like to thank:

+ @mattpallissard for getting `merlin` and `dot-merlin-reader` working with Multicore OCaml 4.10.  This makes programming using OCaml Platform tools like the VSCode plugin much more pleasant.
+ @eduardorfs for testing the `no-effect-syntax` Multicore OCaml branch with a ReasonML project.

@kayceesrk also gave a couple of public talks online:

+ [Multicore OCaml - What's coming in 2021](https://www.youtube.com/watch?v=mel76DFerL0), hosted by Nomadic Labs.
+ [Effect handlers in Multicore OCaml](https://kcsrk.info/slides/nus_effects.pdf). NUS PLV Research Seminar.

We're really grateful to the OCaml core developers for giving this effort so much of their time and focus in 2020!  We're working on a broader plan for 2021's exciting multicore roadmap which will be included in the next monthly after a core OCaml developer's meeting ratifies it soon.  The broad strategy remains consistent: putting pieces of functionality steadily into each upcoming OCaml release so that each can be reviewed and tested in isolation, ahead of the OCaml 5.0 release which will include domains parallelism.

With [OCaml 4.12 out in beta](https://discuss.ocaml.org/t/ocaml-4-12-0-second-beta-release/7171), our January has mainly been spent tackling some of the big pieces needed for OCaml 4.13.  In particular, the [safe points PR](https://github.com/ocaml/ocaml/pull/10039) has seen a big update (and corresponding performance improvements), and we have been working on the design and implementation of Domain-Local Allocation Buffers (DLAB).  We've also started the process of figuring out how to merge the awesome sequential best-fit allocator with our multicore major GC, to get the best of both worlds in OCaml 5.0.  The multicore IO stack has also restarted development, with focus on Linux's new `io_uring` kernel interface before retrofitting the old stalwart `epoll` and `kqueue` interfaces.

Tooling-wise, the multicore Merlin support began in December is now merged, thanks to @mattpallissard and @eduardorfs. We continue to work on the enhancements for Sandmark 2.0 benchmarking suite for an upcoming alpha release -- @shakthimaan gave an online seminar about these improvements to the multicore team which has been recorded and will be available in the next monthly for anyone interested in contributing to our benchmarking efforts. 

As with previous reports, the Multicore OCaml updates are listed first for the month of December 2020 and then January 2021. The upstream OCaml ongoing work is finally mentioned for your reference after the multicore-tree specific pieces..

# December 2020

## Multicore OCaml

### Ongoing

#### Ecosystem

* [ocaml-multicore/lockfree#6](https://github.com/ocaml-multicore/lockfree/issues/6)
  Current status and potential improvements
  
  An RFC that lists the current status of the `lockfree` library, and
  possible performance improvements for the Kcas dependency, test
  suite and benchmarks.

* [ocaml-multicore/lockfree#7](https://github.com/ocaml-multicore/lockfree/issues/7)
  Setup travis CI build
  
  A .travis.yml file, similar to the one in
  https://github.com/ocaml-multicore/domainslib/ needs to be created
  for the CI build system.

* [ocaml-multicore/effects-examples#20](https://github.com/ocaml-multicore/effects-examples/issues/20)
  Add WebServer example
  
  An open task to add the `httpaf` based webserver implementation to
  the effects-examples repository.

* [ocaml-multicore/effects-examples#21](https://github.com/ocaml-multicore/effects-examples/issues/21)
  Investigate CI failure
  
  The CI build fails on MacOS with a time out, but, it runs fine on
  Linux. An on-going investigation is pending.

* [ocaml-multicore/multicore-opam#39](https://github.com/ocaml-multicore/multicore-opam/issues/39)
  Multicore Merlin
  
  Thanks to @mattpallissard (Matt Pallissard) and @eduardorfs
  (Eduardo Rafael) for testing `merlin` and `dot-merlin-reader`, and
  to get it working with Multicore OCaml 4.10! The same has been
  tested with VSCode and Atom, and a screenshot of the UI is shown
  below.
 ![PR 39 Multicore Merlin Screenshot|435x350](https://discuss.ocaml.org/uploads/short-url/hD5jZzwblFC4oq4UEk4agfu24W7.png) 

#### API

* [ocaml-multicore/ocaml-multicore#448](https://github.com/ocaml-multicore/ocaml-multicore/issues/448)
  Reintroduce caml_stat_accessors in the C API
  
  The `caml_stat_minor_words`, `caml_stat_promoted_words`,
  `caml_allocated_words` `caml_stat_minor_collections` fields are not
  exposed in Multicore OCaml. This is a discussion to address possible
  solutions for the same.

* [ocaml-multicore/ocaml-multicore#459](https://github.com/ocaml-multicore/ocaml-multicore/pull/459)
  Replace caml_root API with global roots
  
  A work-in-progress to convert variables of type `caml_root` to
  `value`, and to register them as global root or generational global
  root, in order to remove the caml_root API entirely.

#### Sundries

* [ocaml-multicore/ocaml-multicore#450](https://github.com/ocaml-multicore/ocaml-multicore/issues/450)
  "rogue" systhreads and domain termination
  
  An RFC to discuss on the semantics of domain termination for
  non-empty thread chaining. In Multicore OCaml, a domain termination
  does not mean the end of a program, and slot reuse adds complexity
  to the implementation.

* [ocaml-multicore/ocaml-multicore#451](https://github.com/ocaml-multicore/ocaml-multicore/issues/451)
  Note for OCaml 5.0: Get rid of compatibility.h
  
  OCaml Multicore removed `modify` and `initialize` from
  `compatibility.h`, and this is a tracking issue to remove
  compatibility.h for OCaml 5.0.

* [ocaml-multicore/ocaml-multicore#458](https://github.com/ocaml-multicore/ocaml-multicore/pull/458)
  no-effect-syntax: Remove effects from typedtree
  
  The PR removes the the effect syntax use from `typedtree.ml`, and
  enables external applications that use the AST to work with
  domains-only Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#461](https://github.com/ocaml-multicore/ocaml-multicore/pull/461)
  Remove stw/leader_collision events from eventlog
  
  A patch to make viewing and analyzing the logs better by removing
  the `stw/leader_collision` log messages.

### Completed

* [ocaml-multicore/effects-examples#23](https://github.com/ocaml-multicore/effects-examples/pull/23)
  Migrate to dune
  
  The build scripts were using OCamlbuild, and they have been ported
  to now use dune.

* [ocaml-multicore/ocaml-multicore#402](https://github.com/ocaml-multicore/ocaml-multicore/pull/402)
  Split handle_gc_interrupt into handling remote and polling sections
  
  The PR includes the addition of `caml_poll_gc_work` that contains
  the polling of GC work done in `caml_handle_gc_interrupt`. This
  facilitates handling of interrupts recursively without introducing
  new state.

* [ocaml-multicore/ocaml-multicore#439](https://github.com/ocaml-multicore/ocaml-multicore/pull/439)
  Systhread lifecycle work

  The improvement fixes a race condition in `caml_thread_scan_roots`
  when two domains are initializing, and rework has been done for
  improving general resource handling and freeing of descriptors and
  stacks.

* [ocaml-multicore/ocaml-multicore#446](https://github.com/ocaml-multicore/ocaml-multicore/pull/446)
  Collect GC stats at the end of minor collection

  The GC statistics is collected at the end of a minor collection, and
  the double buffering of GC sampled statistics has been removed. The
  change does not have an impact on the existing benchmark runs as
  observed against stock OCaml from the following illustration:

  ![PR 446 Graph Image|690x317](https://discuss.ocaml.org/uploads/short-url/i4js513ml6Qw6GvkZuQsiVuowYB.png) 

* [ocaml-multicore/ocaml-multicore#454](https://github.com/ocaml-multicore/ocaml-multicore/pull/454)
  Respect ASM_CFI_SUPPORTED flag in amd64
  
  The CFI directives in `amd64.S` are now guarded by
  `ASM_CFI_SUPPORTED`, and thus compilation with `--disable-cfi` will
  now provide a clean build.

* [ocaml-multicore/ocaml-multicore#455](https://github.com/ocaml-multicore/ocaml-multicore/pull/455)
  No blocking section on fork
  
  A patch to handle the case when a rogue thread attempts to take over
  the thread `masterlock` and to prevent a child thread from moving to
  an invalid state. Dune can now be used safely with Multicore OCaml.

## Benchmarking

### Ongoing

* [ocaml-bench/rungen#1](https://github.com/ocaml-bench/rungen/pull/1)
  Fix compiler warnings and errors for clean build
  
  The patch provides minor fixes for a clean build of `rungen` with dune
  to be used with Sandmark 2.0.

* [ocaml-bench/orun#2](https://github.com/ocaml-bench/orun/pull/2)
  Fix compiler warnings and errors for clean build

  The unused variables and functions have been removed to remove all
  the warnings and errors produced when building `orun` with dune.

* [ocaml-bench/sandmark#198](https://github.com/ocaml-bench/sandmark/issues/198)
  Noise in Sandmark
  
  An RFC to measure the noise between multiple execution runs of the
  benchmarks to better understand the performance with various
  hardware configuration settings, and with ASLR turned on and off.

* [ocaml-bench/sandmark#200](https://github.com/ocaml-bench/sandmark/pull/200)
  Global roots microbenchmark
  
  The patch includes `globroots_seq.ml`, `globroots_sp.ml`, and
  `globroots_mp.ml` that adds microbenchmarks to measure the
  efficiency of global root scanning.

* We are continuing to integrate the existing Sandmark benchmark test
  suite with a Sandmark 2.0 native dune build environment for use with
  opam compiler switch environment. The existing benchmarks have been
  ported to the same to use their respective dune files. The `orun`
  and `rungen` packages now live in separate GitHub repositories.

### Completed

* [ocaml-bench/sandmark#196](https://github.com/ocaml-bench/sandmark/pull/196)
  Filter benchmarks based on tag

  The benchmarks can now be filtered based on `tags` instead of custom
  target .json files. You can now build the benchmarks using the
  following commands:
  
  ```
  $ TAG='"run_in_ci"' make run_config_filtered.json 
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
  ```

* [ocaml-bench/sandmark#201](https://github.com/ocaml-bench/sandmark/pull/201)
  Fix compiler version in CI
  
  A minor update in .drone.yml to use
  `ocaml-versions/4.10.0+multicore.bench` in the CI for
  4.10.0+multicore+serial.

## OCaml

### Ongoing

* [ocaml/ocaml#9876](https://github.com/ocaml/ocaml/pull/9876)
  Do not cache young_limit in a processor register

  This PR for the removal of `young_limit` caching in a register for
  ARM64, PowerPC and RISC-V ports hardware is currently under review.

# January 2021

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#464](https://github.com/ocaml-multicore/ocaml-multicore/pull/464)
  Replace Field_imm with Field
  
  The patch replaces the Field immediate use with Field from the
  concurrent minor collector.

* [ocaml-multicore/ocaml-multicore#468](https://github.com/ocaml-multicore/ocaml-multicore/issues/468)
  Finalisers causing segfault with multiple domains
  
  An on-going test case where Finalisers cause segmentation faults
  with multiple domains.

* The design and implementation of Domain-Local Allocation Buffers
  (DLAB) is underway, and the relevant notes on the same are available
  in the following [DLAB
  Wiki](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers).

### Completed

#### Ecosystem

* [ocaml-bench/rungen#1](https://github.com/ocaml-bench/rungen/pull/1)
  Fix compiler warnings and errors for clean build
  
  Minor fixes for a clean build of `rungen` with dune to be used with
  Sandmark 2.0.

* [ocaml-bench/orun#2](https://github.com/ocaml-bench/orun/pull/2)
  Fix compiler warnings and errors for clean build

  A patch to remove unused variables and functions without any
  warnings and errors when building `orun` with dune.

* [ocaml-bench/rungen#2](https://github.com/ocaml-bench/rungen/pull/2)
  Added meta files for dune-release lint
  
  The `dune-release lint` checks for rungen now pass with the
  inclusion of CHANGES, LICENSE and updates to rungen.opam files.

* [ocaml-bench/orun#3](https://github.com/ocaml-bench/orun/pull/3)
  Add meta files for dune-release lint

  The CHANGES, LICENSE, README.md and orun.opam files have been added
  to prepare the sources for an opam.ocaml.org release.

* [ocaml-multicore/multicore-opam#39](https://github.com/ocaml-multicore/multicore-opam/issues/39)
  Multicore Merlin
  
  Thanks to @mattpallissard (Matt Pallissard) and @eduardorfs (Eduardo
  Rafael) for testing `merlin` and `dot-merlin-reader`, and to get it
  working with Multicore OCaml 4.10! The changes work fine with VSCode
  and Atom. The corresponding
  [PR#40](https://github.com/ocaml-multicore/multicore-opam/pull/40)
  is now merged.

* [ocaml-multicore/ocaml-multicore#45](https://github.com/ocaml-multicore/multicore-opam/pull/45)
  Merlin and OCaml-LSP installation instructions
  
  The README.md file has been updated to include installation
  instructions to use Merlin and OCaml LSP Server.

#### Sundries

* [ocaml-multicore/ocaml-multicore#458](https://github.com/ocaml-multicore/ocaml-multicore/pull/458)
  no-effect-syntax: Remove effects from typedtree
  
  The PR enables external applications that use the AST to work with
  domains-only Multicore OCaml, and removes the effect syntax use from
  `typedtree.ml`.

* [ocaml-multicore/ocaml-multicore#461](https://github.com/ocaml-multicore/ocaml-multicore/pull/461)
  Remove stw/leader_collision events from eventlog
  
  The `stw/leader_collision` log messages have been cleaned up to make
  it easier to view and analyze the logs.

* [ocaml-multicore/ocaml-multicore#462](https://github.com/ocaml-multicore/ocaml-multicore/pull/462)
  Move from Travis to GitHub Actions
  
  The continuous integration builds are now updated to use GitHub
  Actions instead of Travis CI, in order to be similar to that of
  upstream CI.

* [ocaml-multicore/ocaml-multicore#463](https://github.com/ocaml-multicore/ocaml-multicore/pull/463)
  Minor GC: Restrict global roots scanning to one domain
  
  The live domains scan all the global roots during a minor
  collection, and the patch restricts the global root scanning to just
  one domain. The sequential and parallel macro benchmark results are
  given below:
  
![PR 463 OCaml Multicore Sequential |690x318](https://discuss.ocaml.org/uploads/short-url/kNn97x2EouFqVZpSj82Pa6yt2wB.jpeg) 

![PR 463 OCaml Multicore Parallel |690x458](https://discuss.ocaml.org/uploads/short-url/7usja76xxxUEOTPTRFmRUQ1H6dL.jpeg) 

* [ocaml-multicore/ocaml-multicore#467](https://github.com/ocaml-multicore/ocaml-multicore/pull/467)
  Disable the pruning of the mark stack
  
  A PR to disable the mark stack overflow for a concurrency bug that
  occurs when remarking a pool in another domain when that domain also
  does allocations.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#202](https://github.com/ocaml-bench/sandmark/pull/202)
  Add bench clean target in the Makefile
  
  A `benchclean` target has been added to the Makefile to only remove
  `_build` and `_results`. The `_opam` folder is retained with the
  required packages and dependencies installed, so that the benchmarks
  can be quickly re-built and executed.

* [ocaml-bench/sandmark#203](https://github.com/ocaml-bench/sandmark/pull/203)
  Implement ITER support
  
  The use of ITER has been correctly implemented with multiple
  instances of the benchmarks being built, and to repeat the
  executions of the benchmarks. This helps to take averages from
  multiple runs for metrics. For example, using ITER=2 produces two
  `.summary.bench` files as shown below:
  
  ```
  $ ls _build/
    4.10.0+multicore_1  4.10.0+multicore_2  log

  $ ls _results/
    4.10.0+multicore_1.orun.summary.bench  4.10.0+multicore_2.orun.summary.bench
  ```

* [ocaml-bench/sandmark#204](https://github.com/ocaml-bench/sandmark/pull/204)
  Adding layers.ml as a benchmark to Sandmark
  
  Th inclusion of Irmin layers benchmark and its dependencies into
  Sandmark. This is a work-in-progress.

* We are continuing the enhancements for Sandmark 2.0 that uses a
  native dune to build and execute the benchmarks, and also port and
  test with the current Sandmark configuration files. The `orun` and
  `rungen` packages have been moved to their respective
  repositories. The use of a meta header entry to the .summary.bench
  file, ITER support, and package override features have been
  implemented.

### Completed

* [ocaml-bench/sandmark#200](https://github.com/ocaml-bench/sandmark/pull/200)
  Global roots microbenchmark
  
  The implementation of `globroots_seq.ml`, `globroots_sp.ml`, and
  `globroots_mp.ml` to measure the efficiency of global root scanning
  has been added to the microbenchmarks.

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints
  
  An update to the draft Safepoints implementation that uses the
  prologue eliding algorithm and is now rebased to trunk.The runtime
  benchmark results on sherwood (an AMD EPYC 7702) and thunderx (a
  Cavium ThunderX CN8890) are shown below:
  
  ![PR 10039 OCaml Sherwood |690x391](https://discuss.ocaml.org/uploads/short-url/p7YF1eKFPnXJjSrTQQ2AAiIPiUl.png) 
  ![PR 10039 OCaml ThunderX |690x389](https://discuss.ocaml.org/uploads/short-url/8o3nuJUhByBqJqVJEJK91hHsqNF.png) 

### Completed

* [ocaml/ocaml#9876](https://github.com/ocaml/ocaml/pull/9876)
  Do not cache young_limit in a processor register

  The PR removes the caching of `young_limit` in a register for ARM64,
  PowerPC and RISC-V ports hardware.

Our thanks to all the OCaml users and developers in the community for their continued support and contribution to the project, and we look forward to working with you in 2021!

## Acronyms

* API: Application Programming Interface
* ARM: Advanced RISC Machine
* ASLR: Address Space Layout Randomization
* AST: Abstract Syntax Tree
* CFI: Call Frame Information
* CI: Continuous Integration
* GC: Garbage Collector
* ICFP: International Conference on Functional Programming
* JSON: JavaScript Object Notation
* OPAM: OCaml Package Manager
* PR: Pull Request
* RFC: Request For Comments
* RISC-V: Reduced Instruction Set Computing - V
* UI: User Interface
