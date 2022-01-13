---
title: OCaml Multicore - March 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-03-01"
tags: [multicore]
---

Welcome to the March 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! The following update and the [previous ones](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by me, @kayceesrk and @shakthimaan.  We remain broadly on track to integrate the last of the multicore prerequisites into the next (4.13) release, and to propose domains-only parallelism for OCaml 5.0.

### Upstream OCaml 4.13 development

The complex safe points PR ([#10039](https://github.com/ocaml/ocaml/pull/10039)) is continuing to make progress, with more refinement towards reducing the binary size increase that results from the introduction of more polling points. Special thanks to @damiendoligez for leaping in with a [PR-to-the-PR](https://github.com/sadiqj/ocaml/pull/3) to home in on a workable algorithm!

### Multicore OCaml trees

If there's one thing we're not going to miss, it's git rebasing. The multicore journey began many moons ago with OCaml [4.02](https://github.com/ocaml-multicore/ocaml-multicore/commits/master-4.02.2), and then [4.04](https://github.com/ocaml-multicore/ocaml-multicore/tree/4.04.2+multicore), [4.06](https://github.com/ocaml-multicore/ocaml-multicore/tree/4.06.1+multicore), and the current [4.10](https://github.com/ocaml-multicore/ocaml-multicore/commits/parallel_minor_gc).  We're pleased to announce the hopefully-last rebase of the multicore OCaml trees to OCaml 4.12.0 are now available.  There is now a simpler naming scheme as well to reflect our upstreaming strategy more closely:

- OCaml 4.12.0+domains is the domains-only parallelism that will be submitted for OCaml 5.0
- OCaml 4.12.0+domains+effects is the version with domains parallelism and effects-based concurrency.

You can find opam installation instructions for these over at [the multicore-opam](https://github.com/ocaml-multicore/multicore-opam) repository. There is even an ocaml-lsp-server available, so that your favourite IDE should just work!

#### Domains-only parallelism trees

The bulk of effort this month has been around the integration and debugging of Domain Local Allocation Buffers (DLABs), and also chasing down corner-case failures from stress testing and opam bulk builds. For details, see the long list of PRs in the next section.

We're also cleaning up historical vestiges in order to reduce the diff to OCaml trunk, in order to clear the path to a clean diff for generating OCaml 5.0 PRs for upstream integration.

#### Concurrency and Effects trees

**The camera-ready paper for PLDI 2021 on [Retrofitting Effect handlers onto OCaml](https://arxiv.org/abs/2104.00250) is now available on arXiv.** The code described in the paper can be used via the `4.12.0+domains+effects` opam switches. Please feel free to keep any comments coming to @kayceesrk and myself.

We've also been hacking on the multicore IO stack and just beginning to combine concurrency (via effects) and parallelism (via domains) into Linux io_uring, macOS' Grand Central Dispatch and Windows iocp. We'll have more to report on this over the next few months, but early benchmarking numbers on Linux are promising.

### CI and Benchmarking

We are continuing to expand the testing for different CI configurations for the project. With respect to Sandmark benchmarking, we are in the process of adding the Irmin layers.ml benchmark. There is also an end-to-end pipeline of using the OCurrent [current-bench](https://github.com/ocurrent/current-bench) framework to give us benchmarking results from PRs that can be compared to previous runs.

As always, we begin with the Multicore OCaml updates, which are then followed by the ongoing and completed tasks for the Sandmark benchmarking project. Finally, the upstream OCaml work is listed for your reference.

# Detailed Updates

## Multicore OCaml

### Ongoing

#### DLAB

* [ocaml-multicore/ocaml-multicore#484](https://github.com/ocaml-multicore/ocaml-multicore/pull/484)
  Thread allocation buffers
  
  The PR provides an implementation for thread local allocation
  buffers or `Domain Local Allocation Buffers`. Code review and
  testing of the changes is in progress.
  
* [ocaml-multicore/ocaml-multicore#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508)
  Domain Local Allocation Buffers
  
  This is an extension to the `Thread allocation buffers` PR with
  initialization, lazy resizing of the global minor heap size, and
  rebase to 4.12 branch.

#### Testing

* [ocaml-multicore/ocaml-multicore#522](https://github.com/ocaml-multicore/ocaml-multicore/issues/522)
  Building the runtime with -O0 rather than -O2 causes testsuite to fail
  
  The runtime tests fail when using `-O0` instead of `-O2` and this
  needs to be investigated further.
  
* [ocaml-multicore/ocaml-multicore#526](https://github.com/ocaml-multicore/ocaml-multicore/issues/526)
  weak-ephe-final issue468 can fail with really small minor heaps
  
  The `weak-ephe-final` tests with a small minor heap (4096 words) cause
  the issue468 test to fail.

* [ocaml-multicore/ocaml-multicore#528](https://github.com/ocaml-multicore/ocaml-multicore/pull/528)
  Expand CI runs
  
  A list of requirements to expand the scope and execution of our
  existing CI runs for comprehensive testing.

#### Sundries

* [ocaml-multicore/ocaml-multicore#514](https://github.com/ocaml-multicore/ocaml-multicore/pull/514)
  Update instructions in ocaml-variants.opam
  
  The `ocaml-variants.opam` and `configure.ac` files have been updated
  to use the Multicore OCaml repository, and to use a local switch
  instead of a global one. The current Multicore OCaml is at the 4.12
  branch.

* [ocaml-multicore/ocaml-multicore#523](https://github.com/ocaml-multicore/ocaml-multicore/pull/523)
  Systhreads Mutex raises Sys_error
  
  The error checking for Systhreads Mutex should be inline with trunk,
  instead of the fatal errors reported by Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#527](https://github.com/ocaml-multicore/ocaml-multicore/pull/527)
  Port eventlog to CTF
  
  The `eventlog` implementation has to be ported to the Common Trace
  Format. The log output should be consistent with the
  parallel_minor_gc output, and stress testing need to be performed.

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#490](https://github.com/ocaml-multicore/ocaml-multicore/pull/490)
  Remove getmutablefield from bytecode
  
  The bytecode compiler and interpreter have been updated by removing
  the `getmutablefield` opcodes.

* [ocaml-multicore/ocaml-multicore#496](https://github.com/ocaml-multicore/ocaml-multicore/pull/496)
  Replace caml_initialize_field with caml_initialize
  
  A patch to replace `caml_initialize_field`, which was earlier used
  with the concurrent minor collector, is now replaced with
  `caml_initialize`.

* [ocaml-multicore/ocaml-multicore#503](https://github.com/ocaml-multicore/ocaml-multicore/pull/503)
  Re-enable lib-obj and asmcomp/is_static tests
  
  The `lib-obj` and `asmcomp/is_static` tests have been re-enabled and
  the configure settings have been updated for Multicore
  NO_NAKED_POINTERS.

* [ocaml-multicore/ocaml-multicore#506](https://github.com/ocaml-multicore/ocaml-multicore/pull/506)
  Replace `Op_val` with `Field`
  
  The use of `Op_val (x)[i]` has been replaced with `Field (x, i)` to
  be consistent with trunk implementation.

* [ocaml-multicore/ocaml-multicore#507](https://github.com/ocaml-multicore/ocaml-multicore/pull/507)
  Change interpreter to use naked code pointers

  The changes have been made to identify naked pointers in the
  interpreter stack to be compatible with trunk.

* [ocaml-multicore/ocaml-multicore#516](https://github.com/ocaml-multicore/ocaml-multicore/pull/516)
  Remove caml_root API
  
  The `caml_root` variables have been changed to `value` type and are
  managed as generational global roots. Hence, the `caml_root` API is
  now removed.

#### DLAB
  
* [ocaml-multicore/ocaml-multicore#511](https://github.com/ocaml-multicore/ocaml-multicore/pull/511)
  Allocate unique root token on the major heap instead of the minor
  
  The unique root token allocation is now done on the major heap
  allocation that does not raise any exception, and exits cleanly when
  a domain creation fails.

* [ocaml-multicore/ocaml-multicore#513](https://github.com/ocaml-multicore/ocaml-multicore/pull/513)
  Clear the minor heap at the end of a collection in debug runtime
  
  A debug value is written to every element of the minor heap for
  debugging failures. We now clear the minor heap at the end of a
  minor collection.

* [ocaml-multicore/ocaml-multicore#519](https://github.com/ocaml-multicore/ocaml-multicore/pull/519)
  Make timing test more robust
  
  The `timing.ml` test has been updated to be more resilient for
  testing with DLABs.

#### Enhancements

* [ocaml-multicore/ocaml-multicore#477](https://github.com/ocaml-multicore/ocaml-multicore/pull/477)
  Move TLS areas to a dedicated memory space

  In order to support Domain Local Allocation Buffer, we now move the
  TLS areas to its own memory alloted space thereby changing the way
  we allocate an individual domain's TLS.

* [ocaml-multicore/ocaml-multicore#480](https://github.com/ocaml-multicore/ocaml-multicore/pull/480)
  Remove leave_when_done and friends from STW API

  The barriers from `caml_try_run_on_all_domains*` and `stw_request`
  are removed by cleaning up the `stw_request.leave_when_done`
  implementation.

* [ocaml-multicore/ocaml-multicore#481](https://github.com/ocaml-multicore/ocaml-multicore/pull/481)
  Don't share array amongst domains in gc-roots tests
  
  Every domain should have its own array, and the parallel global
  roots tests have been updated with this change.

* [ocaml-multicore/ocaml-multicore#494](https://github.com/ocaml-multicore/ocaml-multicore/pull/494)
  Stronger invariants on unix_fork
  
  We now enforce stronger invariants such that no other domain can run
  alongside domain 0 (`caml_domain_alone`) for `unix_fork`.

* [ocaml-multicore/ocaml-multicore#515](https://github.com/ocaml-multicore/ocaml-multicore/pull/515)
  Add memprof stubs to build and stdlib
  
  The required `memprof` functions have been added to build `stdlib`,
  and also to build memprof for the runtime.

#### Lazy Updates

* [ocaml-multicore/ocaml-multicore#501](https://github.com/ocaml-multicore/ocaml-multicore/pull/501)
  Safepoints lazy fix
  
  The lazy implementation need to be aware of safe points, and we need
  to differentiate between recursive forcing of lazy values from
  parallel forcing. These fixes are from
  [ocaml-multicore#492](https://github.com/ocaml-multicore/ocaml-multicore/pull/492)
  and
  [ocaml-multicore#493](https://github.com/ocaml-multicore/ocaml-multicore/pull/493).

* [ocaml-multicore/ocaml-multicore#505](https://github.com/ocaml-multicore/ocaml-multicore/pull/505)
  Add a unique domain token to distinguish lazy forcing failure
  
  A `caml_ml_domain_unique_token` has been added to handle racy access
  by multiple mutators. This fixes the [using domain id
  (int)](https://github.com/ocaml-multicore/ocaml-multicore/issues/504)
  to identify forcing domain of lazy block issue.

#### Fixes

* [ocaml-multicore/ocaml-multicore#487](https://github.com/ocaml-multicore/ocaml-multicore/pull/487)
  systhreads: set gc_regs_buckets and friends to NULL at thread startup
  
  Pointers have been initialized to NULL in `systhreads/st_stubs.c`
  which solves the [segmentation
  fault](https://github.com/ocaml-multicore/ocaml-multicore/issues/485)
  observed when running the Layers benchmark.

* [ocaml-multicore/ocaml-multicore#491](https://github.com/ocaml-multicore/ocaml-multicore/pull/491)
  Reinitialize child locks after fork
  
  The runtime needs to operate correctly after a `fork`, and this
  patch fixes it with proper resetting of domain lock.

* [ocaml-multicore/ocaml-multicore#495](https://github.com/ocaml-multicore/ocaml-multicore/pull/495)
  Fix problems with finaliser orphaning

  A fix for how we merge finalization tables for orphaned finaliser
  work. A test case has also been added to the PR.

* [ocaml-multicore/ocaml-multicore#499](https://github.com/ocaml-multicore/ocaml-multicore/pull/499)
  Fix backtrace unwind
  
  The unwinding of stacks over callbacks was not happening correctly
  and the discrepancy in `caml_next_frame_descriptior` is now resolved.

* [ocaml-multicore/ocaml-multicore#509](https://github.com/ocaml-multicore/ocaml-multicore/pull/509)
  Fix for bad setup of Continuation_already_taken exception in bytecode
  
  A patch to fix the `Continuation_already_taken` exception which was
  not set up as needed in the bytecode execution.

* [ocaml-multicore/ocaml-multicore#510](https://github.com/ocaml-multicore/ocaml-multicore/pull/510)
  Update a testcase in principality-and-gadts.ml
  
  A change in `principality-and-gadts.ml` to log the correct output as
  compared to 4.12 branch in ocaml/ocaml.

#### Ecosystem

* [ocaml-multicore/multicore-opam#46](https://github.com/ocaml-multicore/multicore-opam/pull/46)
  Multicore compatible ocaml-migrate-parsetree.2.1.0
  
  The `ocaml-migrate-parsetree` package uses the effect syntax and now
  builds with Multicore OCaml `parallel_minor_gc` branch.

* [ocaml-multicore/multicore-opam#47](https://github.com/ocaml-multicore/multicore-opam/pull/47)
  Multicore compatible ppxlib
  
  The effect syntax has been added to `ppxlib` and is also now
  compatible with Multicore OCaml.

* [ocaml-multicore/multicore-opam#49](https://github.com/ocaml-multicore/multicore-opam/pull/49)
  4.12 Multicore configs
  
  Added configurations to install `4.12.0+domains+effects` and
  `4.12.0+domains` OCaml variants.

* [ocaml-multicore/ocaml-multicore#473](https://github.com/ocaml-multicore/ocaml-multicore/issues/473)
  Building on musl requires dynamically linked execinfo

  The opam files to allow installation on musl-based environments for
  Multicore OCaml have been added to the repository.

* [ocaml-multicore/ocaml-multicore#482](https://github.com/ocaml-multicore/ocaml-multicore/pull/482)
  Check for -lexecinfo in order to build on musl/alpine
  
  A `configure` script has been added which checks for `-lexecinfo` in
  order to support building Multicore OCaml on musl/alpine.

#### Documentation

* [ocaml-multicore/ocaml-multicore#502](https://github.com/ocaml-multicore/ocaml-multicore/pull/502)
  Update README to introduce 4.12+domains+effects and 4.12+domains

  We have updated the README file with the current list of active
  branches, and the names of the historic variants.

* [ocaml-multicore/ocaml-multicore#520](https://github.com/ocaml-multicore/ocaml-multicore/pull/520)
  Clarify comment on RacyLazy
  
  A documentation update in `stdlib/lazy.mli` that clarifies when
  `RacyLazy` and `Undefined` are raised.
  
#### Sundries

* [ocaml-multicore/ocaml-multicore#486](https://github.com/ocaml-multicore/ocaml-multicore/pull/486)
  Sync no-effects-syntax to parallel_minor_gc branch
  
  The `ocaml-multicore:no-effects-syntax` branch is now up to date
  with the `parallel_minor_gc` branch changes.

* [ocaml-multicore/ocaml-multicore#489](https://github.com/ocaml-multicore/ocaml-multicore/pull/489)
  Remove promote_to
  
  The `promote_to` function was used in the concurrent minor GC. It is
  not required any more and hence has been removed.

* [ocaml-multicore/ocaml-multicore#500](https://github.com/ocaml-multicore/ocaml-multicore/pull/500)
  Replace caml_modify_field with caml_modify
  
  The `caml_modify_field` is no longer necessary and has been replaced
  with `caml_modify`.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#204](https://github.com/ocaml-bench/sandmark/pull/204)
  Adding layers.ml as a benchmark to Sandmark

  The inclusion of Irmin layers.ml benchmark with updates to all its
  dependency requirements.

* [ocaml-bench/sandmark#209](https://github.com/ocaml-bench/sandmark/pull/209)
  Use rule target kronecker.txt and remove from macro_bench

  A review of the graph500seq `kernel1.ml` implementation has been
  done, and code changes have been proposed. The `macro_bench` tag
  will be retained for the `graph500` benchmarks.

* [ocaml-bench/sandmark#212](https://github.com/ocaml-bench/sandmark/pull/212)
  Increasing the major heap allocation on some benchmarks
  
  A work in progress to add more longer running benchmarks that
  involve major heap allocation. Some of the parameters have been
  updated with higher values, and more loops have been added as well.

* We now have integrated the build of Sandmark 2.0 with
  [current-bench](https://github.com/ocurrent/current-bench) for
  CI. The results of the benchmark runs are now pushed to a PostgreSQL
  database as shown below:
  
  ```
  docker=# select * from benchmarks;
  -[ RECORD 1 ]--+-------------------------------------------------------
  run_at         | 2021-03-26 11:21:20.64
  repo_id        | local/local
  commit         | 55c6fb6416548737b715d6d8fde6c0f690526e42
  branch         | 2.0.0-alpha+001
  pull_number    | 
  benchmark_name | 
  test_name      | coq.BasicSyntax.v
  metrics        | {"maxrss_kB": 678096, "time_secs": 101.99969387054443}
  duration       | 00:37:52.776357
  -[ RECORD 2 ]--+-------------------------------------------------------
  run_at         | 2021-03-26 11:21:20.64
  repo_id        | local/local
  commit         | 55c6fb6416548737b715d6d8fde6c0f690526e42
  branch         | 2.0.0-alpha+001
  pull_number    | 
  benchmark_name | 
  test_name      | thread_ring_lwt_mvar.20_000
  metrics        | {"maxrss_kB": 8096, "time_secs": 2.6146790981292725}
  duration       | 00:37:52.776357
  ...
  ```

  We will continue to work on adding more workflows and features to
  `current-bench` to support Sandmark builds.

### Completed

* [ocaml-bench/sandmark#202](https://github.com/ocaml-bench/sandmark/pull/202)
  Added bench clean target in the Makefile
  
  A `benchclean` target to remove the generated benchmarks and its
  results while still retaining the `_opam` folder has been added to
  the Makefile.

* [ocaml-bench/sandmark#203](https://github.com/ocaml-bench/sandmark/pull/203)
  Implement ITER support
  
  The use of ITER variable is now supported in Sandmark, and you can
  run multiple iterations of the benchmarks. For example, with
  `ITER=2`, a couple of summary .bench files are created with the
  benchmark results as shown below:

  ```
  $ TAG='"run_in_ci"' make run_config_filtered.json
  $ ITER=2 RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench 

  $ ls _results/
  4.10.0+multicore_1.orun.summary.bench  4.10.0+multicore_2.orun.summary.bench
  ```

* [ocaml-bench/sandmark#208](https://github.com/ocaml-bench/sandmark/pull/208)
  Fix params for simple-tests/capi
  
  A minor fix in `run_config.json` to correctly pass the arguments to
  the `simple-tests/capi` benchmark execution. You can verify the same
  using the following commands:
  
  ```
  $ TAG='"lt_1s"' make run_config_filtered.json
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
  ```

* [ocaml-bench/sandmark#210](https://github.com/ocaml-bench/sandmark/pull/210)
  Don't share array in global roots parallel benchmarks
  
  A patch to not share array in global roots implementation for
  parallel benchmarks.

* [ocaml-bench/sandmark#213](https://github.com/ocaml-bench/sandmark/pull/213)
  Resolve dependencies for 4.12.1+trunk, 4.12.0+domains and 4.12.0+domains+effects

  The `dependencies/packages` have now been updated to be able to
  build `4.12.1+trunk`, `4.12.0+domains` and `4.12.0+domains+effects`
  branches with Sandmark.

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints

  The review of the Safepoints PR is in progress. Special thanks to
  Damien Doligez for his [code
  suggestions](https://github.com/sadiqj/ocaml/pull/3) on safepoints
  and inserting polls. There is still work to be done on
  optimizations.
  
Many thanks to all the OCaml users, developers and contributors in the
community for their support to the project. Stay safe!

## Acronyms

* API: Application Programming Interface
* CI: Continuous Integration
* CTF: Common Trace Format
* DLAB: Domain Local Allocation Buffer
* GC: Garbage Collector
* OPAM: OCaml Package Manager
* PR: Pull Request
* STW: Stop The World
* TLS: Thread Local Storage