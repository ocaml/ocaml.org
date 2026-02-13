---
title: OCaml Multicore - July 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-07-01"
tags: [multicore]
---

Welcome to the July 2020 Multicore OCaml report! This update, along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly), has been compiled by @shakthimaan, @kayceesrk and myself.  There are a number of advances both in upstream OCaml as well as our multicore trees.

## Multicore OCaml

### Thread compatibility via Domain Execution Contexts

_TL;DR: once [#381](https://github.com/ocaml-multicore/ocaml-multicore/pull/381) is merged, dune will work with multicore OCaml._

As I [noted](https://discuss.ocaml.org/t/multicore-ocaml-june-2020/6047) last month, not having a Thread module that is backwards compatible with traditional OCaml's is a big blocker for ecosystem compatibility.  This can be a little confusing at first glance -- why does Multicore OCaml need non-parallel threading support?  The answer lies in the relationship between [concurrency and parallelism in multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Concurrency-and-parallelism-design-notes).  _Concurrency_ is how we partition multiple computations such that they run in overlapping time periods, and _parallelism_ is how we run them on separate cores simultaneously to gain greater performance.  A number of packages (most notably, Dune) currently use the Thread module to conveniently gain concurrency while writing straight-line code without using monadic abstractions.  These uses do not require parallelism, but are very difficult to rewrite to not use thread-based concurrency.

Therefore, multicore OCaml also needs a way to provide a reasonably performant version of Thread.  The first solution we attempted (started by @jhw and continued by @engil in [#342](https://github.com/ocaml-multicore/ocaml-multicore/pull/342#issuecomment-643119638)) mapped a Thread to a multicore Domain, but scaled poorly for a larger number of threads since we may have a far greater number of concurrency contexts (Thread instances) than we have CPUs available (Domain instances). This lead to a bit of brainstorming ([#357](https://github.com/ocaml-multicore/ocaml-multicore/issues/357)) to figure out a solution that would work for applications like Dune or the [XenServer stack](https://github.com/xapi-project/xen-api) that are heavy Thread users.

Our solution introduces a concept that we have dubbed [Domain Execution Contexts in #381](https://github.com/ocaml-multicore/ocaml-multicore/pull/381), which allows us to map multiple system threads to OCaml domains.  Once that PR is reviewed and merged into the multicore OCaml branches, it will unlock many more ecosystem packages, as the Dune build system will compile unmodified.  The last "big" remaining blocker for wider opam testing after this is then ocaml-migrate-parsetree, which requires a small patch to support the `effect` keyword syntax that is present in the multicore OCaml trees.

### Domain Local Storage 

Domain Local Storage (DLS) ([#372](https://github.com/ocaml-multicore/ocaml-multicore/pull/372)) is a simple way to attach OCaml values privately to a domain.  A good example of speedup when using DLS is shown in a PR to the [LU decomposition benchmark](https://github.com/ocaml-bench/sandmark/pull/152). In this case, the benchmark needs a lot of random numbers, and initialising them in parallel locally to the domain is a win.

Another example is the parallel implementation of an evolutionary algorithm (originally suggested by @per_kristian_lehre in [#336](https://github.com/ocaml-multicore/ocaml-multicore/issues/336)) which speeds up nicely in [#151](https://github.com/ocaml-bench/sandmark/pull/151) (for those who want to check the baseline, there is a sequential version in [#155](https://github.com/ocaml-bench/sandmark/pull/155) that you can look up in the Sandmark web interface).

### Parallel Programming with Multicore OCaml (document)

A tutorial on [Parallel Programming with Multicore OCaml](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml) has been made available. It provides an introduction to Multicore OCaml and explains the concepts of `Domains`, `Domainslib`, and `Channels`. Profiling of OCaml code using `perf` and `Eventlog` are also illustrated with examples.

This draft was shared on  [Reddit](https://www.reddit.com/r/ocaml/comments/hluzmy/parallel_programming_in_multicore_ocaml_a_tutorial/) as well as on [HackerNews](https://news.ycombinator.com/item?id=23740869), so you'll find more chatter about it there.

### Coq benchmarks

The Sandmark benchmarking suite for OCaml has been successfully updated to use dune.2.6.0 and builds for Multicore OCaml 4.10.0. With this major upgrade, we have also been able to include Coq and its
dependencies. We are working on adding more regression Coq benchmarks to the test suite.

## Upstream OCaml

The upstream OCaml trees have seen a flurry of activity in the 4.12.0dev trees with changes to prepare for multicore OCaml.  The biggest one is the (to quote @xavierleroy) fabled page-less compactor in [ocaml/ocaml#9728](https://github.com/ocaml/ocaml/pull/9728).  This followed on from last month's work ([#9698](https://github.com/ocaml/ocaml/pull/9698)) to eliminate the use of the page table when the compiler is built with the "no-naked-pointers" option, and clears the path for the parallel multicore OCaml runtime to be integrated in a future release of OCaml.

One of the other changes we hope to get into OCaml 4.12 is the alignment of the use of garbage collector colours when marking and sweeping. The [#9756](https://github.com/ocaml/ocaml/pull/9756) changes make the upstream runtime use the same scheme we described in the [Retrofitting Parallelism onto OCaml](https://arxiv.org/abs/2004.11663) ICFP paper, with a few extra improvements that you can read about in the PR review comments.

If you are curious about the full set of changes, you can see all the [multicore prerequisite](https://github.com/ocaml/ocaml/issues?q=label%3Amulticore-prerequisite+is%3Aclosed) issues that have been closed to date upstream.

# Detailed Updates

As with the previous updates, the Multicore OCaml updates are first listed, which are then followed by the enhancements to the Sandmark benchmarking project. The upstream OCaml ongoing and completed updates are finally mentioned for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#342](https://github.com/ocaml-multicore/ocaml-multicore/pull/342)
  Implementing the threads library with Domains

  This is an on-going effort to rebase @jhwoodyatt's implementation of the Thread
  library for Domains.

* [ocaml-multicore/ocaml-multicore#357](https://github.com/ocaml-multicore/ocaml-multicore/issues/357)
  Implementation of systhreads with pthreads

  A Domain Execution Context (DEC) is being introduced in this
  implementation as a concurrency abstraction for implementing
  systhreads with pthreads.

* [ocaml-multicore/ocaml-multicore#374](https://github.com/ocaml-multicore/ocaml-multicore/pull/374)
  Force major slice on minor collection

  A blocked thread in a domain may not progress the major GC when
  servicing the minor collector through `handle_interrupt`, and hence
  we need to have a minor collection to schedule a major collection
  slice.

### Completed

#### Domain-Local State

* [Sudha247/ocaml-multicore#1](https://github.com/Sudha247/ocaml-multicore/pull/1)
  `dls_root` should be deleted before terminal GC
  
  The deletion of the global root pushes an object on the mark stack,
  and hence a final GC needs to be performed before the terminal GC.

* [ocaml-multicore/ocaml-multicore#372](https://github.com/ocaml-multicore/ocaml-multicore/pull/372)
  Domain-local Storage
  
  The RFC proposal [ocaml-multicore#339](https://github.com/ocaml-multicore/ocaml-multicore/issues/339) to implement 
  Domain-Local Storage has been completed and merged to
  Multicore OCaml.

#### Removal of vestiges in Concurrent Minor GC

* [ocaml-multicore/ocaml-multicore#370](https://github.com/ocaml-multicore/ocaml-multicore/pull/370)
  Remove Cloadmut and lloadmut
  
  The `Cloadmut` and `Iloadmut` implementation and usage have been
  cleaned up with this patch. This simplifies the code and brings it
  closer to stock OCaml.

* [ocaml-multicore/ocaml-multicore#371](https://github.com/ocaml-multicore/ocaml-multicore/pull/371)
  Domain interrupt cleanup

  In `runtime/domain.c` the `struct interruptor* sender` has been
  removed. The domain RPC functions have been grouped together in
  `domain.h`, and consistent naming of definitions have been applied.

#### Code Cleanup

* [ocaml-multicore/ocaml-multicore#367](https://github.com/ocaml-multicore/ocaml-multicore/pull/367)
  Remove some unused RPC consumers
  
  The domain RPC mechanisms are no longer in use, and have been
  removed.

* [ocaml-multicore/ocaml-multicore#368](https://github.com/ocaml-multicore/ocaml-multicore/pull/368)
  Removal of dead bits of read_barrier and caml_promote
  
  This PR removes `caml_promote`, the assembly for read faults on ARM
  and AMD, and the global for the read fault.

#### Sundries

* [ocaml-multicore/ocaml-multicore#366](https://github.com/ocaml-multicore/ocaml-multicore/pull/366)
  Add event to record idle domains

  The `domain/idle_wait` and `domain/send_interrupt` events are added
  to track domains that are idling. An eventlog screenshot with this
  effect is shown below:

![PR 366 Image |690x298](https://discuss.ocaml.org/uploads/short-url/nPr6W8aUgyYDU1ZhO5XOAFKMiam.png) 

* [ocaml-multicore/ocaml-multicore#369](https://github.com/ocaml-multicore/ocaml-multicore/pull/369)
  Split caml_urge_major_slice into caml_request_minor_gc and
  caml_request_major_slice
  
  The `caml_urge_major_slices` is split into `caml_request_minor_gc`
  and `caml_request_major_slice`. This reduces the total number of
  minor garbage collections as observed in the following illustration:

![PR 369 Image |690x203](https://discuss.ocaml.org/uploads/short-url/eCdqNjb7AtmLGmL0TpUKZG3lpeT.png) 

* [ocaml-multicore/ocaml-multicore#373](https://github.com/ocaml-multicore/ocaml-multicore/pull/373)
  Fix the opam pin command in case the current directory name has spaces
  
  Use the `-k path` command-line argument with `opam pin` to handle
  directory names that have whitespaces.

* [ocaml-multicore/ocaml-multicore#375](https://github.com/ocaml-multicore/ocaml-multicore/pull/375)
  Only lock the global freelist to adopt pools if needed
  
  The lock acquire and release on allocation is removed when there are
  no global pools requiring adoption.

* [ocaml-multicore/ocaml-multicore#377](https://github.com/ocaml-multicore/ocaml-multicore/pull/377)
  Group env vars for run in travis CI
  
  The `OCAMLRUNPARAM` parameter is defined as part of the environment
  variable with the `USE_RUNTIME=d` command.

* [ocaml/dune#3608](https://github.com/ocaml/dune/pull/3608)
  Upstream Multicore dune bootstrap patch
  
  The patch is used to build dune using the secondary compiler
  approach for
  [ocaml/dune#3548](https://github.com/ocaml/dune/issues/3548).

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#107](https://github.com/ocaml-bench/sandmark/issues/107)
  Add Coq benchmarks
  
  The upgrade of Sandmark to use dune.2.6.0 for Multicore OCaml 4.10.0
  has allowed us to install Coq and its dependencies. We are currently
  working on adding more Coq regression benchmarks to Sandmark.

* [ocaml-bench/sandmark#122](https://github.com/ocaml-bench/sandmark/issues/122)
  Measurements of code size
  
  The code size of a benchmark is one measurement that is required for
  `flambda` branch, and we are exploring adding the same to the
  Sandmark bench runs.

* [ocaml-bench/sandmark#142](https://github.com/ocaml-bench/sandmark/issues/142)
  [RFC] How should a user configure a sandmark run?
  
  We are gathering user feedback and suggestions on how you would like
  to configure benchmarking for Sandmark. Please share your thoughts
  and comments in this discussion.

* [ocaml-bench/sandmark#150](https://github.com/ocaml-bench/sandmark/pull/150)
  Coq files that work
  
  Addition of more Coq files for benchmarking in Sandmark.

### Completed

#### Dune 2.6.0 Upgrade

* [ocaml-bench/sandmark#131](https://github.com/ocaml-bench/sandmark/pull/131)
  Update decompress benchmarks

  The decompress benchmarks were updated by @dinosaure to use the
  latest decompress.1.1.0 for dune.2.6.0.

* [ocaml-bench/sandmark#132](https://github.com/ocaml-bench/sandmark/pull/132)
  Update dependency packages to use dune.2.6.0 and Multicore OCaml 4.10.0

  Sandmark has now been updated to use dune.2.6.0 and Multicore OCaml
  4.10.0 with an upgrade of over 30 dependency packages. You can test
  the same using:
  
  ```
  $ opam install dune.2.6.0
  $ make ocaml-versions/4.10.0+multicore.bench
  ```

#### Coq Benchmarks

* [ocaml-bench/sandmark#140](https://github.com/ocaml-bench/sandmark/pull/140)
  coqc compiling with Sandmark

  The Coq compiler is added as a dependency package to Sandmark, which
  now allows us to build and run Coq benchmarks.

* [ocaml-bench/sandmark#143](https://github.com/ocaml-bench/sandmark/pull/143)
  Added Coq library fraplib and a benchmark that depends on it
  
  The [Formal Reasoning About
  Programs](https://github.com/achlipala/frap) book's `fraplib`
  library benchmarks have now been included in Sandmark.

* [ocaml-bench/sandmark#144](https://github.com/ocaml-bench/sandmark/pull/144)
  Add frap as a Coq benchmark

  The `CompilerCorrectness.v` Coq file is added as a test benchmark
  for Coq in Sandmark.

#### Continuous Integration

* [ocaml-bench/sandmark#136](https://github.com/ocaml-bench/sandmark/pull/136)
  Use BUILD_ONLY in .drone.yml
  
  The .drone.yml file has been updated to use a BUILD_ONLY environment
  variable to just install the dependencies and not execute the
  benchmarks for the CI.

* [ocaml-bench/sandmark#147](https://github.com/ocaml-bench/sandmark/pull/147)
  Add support to associate tags with benchmarks
  
  The `macro_bench` and `run_in_ci` tags have been introduced to
  associate with the benchmarks. The benchmarks tagged as `run_in_ci`
  will be executed as part of the Sandmark CI.

#### Sundries

* [ocaml-bench/sandmark#124](https://github.com/ocaml-bench/sandmark/pull/124)
  User configurable paramwrapper added to Makefile

  The `--cpu-list` can now be specified as a `PARAMWRAPPER`
  environment variable for running the parallel benchmarks.

* [ocaml-bench/sandmark#134](https://github.com/ocaml-bench/sandmark/pull/134)
  Include more info on README

  The README has been updated to include documentation to reflect the
  latest changes in Sandmark.

* [ocaml-bench/sandmark#141](https://github.com/ocaml-bench/sandmark/pull/141)
  Enrich the variants with additional options

  The `ocaml-versions/*` files now use a JSON file format which allow
  you to specify the ocaml-base-compiler source URL, `configure`
  options and `OCAMLRUNPARAMS`. An example is provided below:

  ```json
  {
	"url" : "https://github.com/ocaml-multicore/ocaml-multicore/archive/parallel_minor_gc.tar.gz",
	"configure" : "-q",
	"runparams" : "v=0x400"
  }
  ```

* [ocaml-bench/sandmark#146](https://github.com/ocaml-bench/sandmark/pull/146)
  Update trunk from 4.11.0 to 4.12.0
  
  Sandmark now uses the latest stock OCaml 4.12.0 as trunk in
  ocaml-versions/.

* [ocaml-bench/sandmark#148](https://github.com/ocaml-bench/sandmark/pull/148)
  Install python3-pip and intervaltree for clean CI build
  
  The .drone.yml file has been updated to install `python3-pip` and
  `intervaltree` software packages to avoid errors when the Makefile
  is invoked.

## OCaml

### Ongoing

* [ocaml/ocaml#9722](https://github.com/ocaml/ocaml/pull/9722)
  EINTR-based signals, again
  
  The patch provides a new implementation to solve locking and
  signal-handling issues.

* [ocaml/ocaml#9756](https://github.com/ocaml/ocaml/pull/9756)
  Garbage collector colours change
  
  The PR removes the gray colour in the garbage collector (GC) colour
  scheme in order to use it with the Multicore OCaml major collector.

### Completed

* [ocaml/dune#3576](https://github.com/ocaml/dune/pull/3576)
  In OCaml 4.12.0, empty archives no longer generate .a files
  
  A native archive will never be generated for an empty library, and
  this fixes the compatibility with OCaml 4.12.0 when dealing with
  empty archives.

* [ocaml/ocaml#9541](https://github.com/ocaml/ocaml/pull/9541)
  Add manual page for the instrumented runtime

  The `manual/manual/cmds/instrumented-runtime.etex` document has been
  updated based on review comments and has been merged to stock OCaml.

* [ocaml/ocaml#9728](https://github.com/ocaml/ocaml/pull/9728)
  Simplified compaction without page table
  
  A self-describing closure representation is used to simplify the
  compactor, and to get rid of the page table.

We would like to thank all the OCaml developers and users in the community for their continued support, code reviews, documentation and contributions to the multicore OCaml project.

## Acronyms

* CI: Continuous Integration
* DEC: Domain Execution Context
* GC: Garbage Collector
* OPAM: OCaml Package Manager
* PR: Pull Request
* RFC: Request for Comments
* RPC: Remote Procedure Call
