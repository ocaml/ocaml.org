---
title: OCaml Multicore - May 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-05-01"
tags: [multicore]
---

# Multicore OCaml: May 2020

Welcome to the May 2020 update from the Multicore OCaml team! As with [previous updates](https://discuss.ocaml.org/tag/multicore-monthly), many thanks to @shakthimaan and @kayceesrk for help assembling this month's roundup.  

A major milestone in May 2020 has been the completion of rebasing of Multicore OCaml all the way from 4.06 to 4.10! The Parallel Minor GC variant that performs stop-the-world parallel minor collection is the [default branch](https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc) for the compiler, which means that compatibility with C bindings is now much simpler than with the older minor GC design.

I've received many questions asking if this means that multicore OCaml will "just work" with the opam ecosystem now.  Not quite yet: we estimate that we are now one PR away from this working, which requires that the existing `Threads` module is backported to multicore OCaml to support the older (non-parallel-in-the-runtime but concurrent) uses of threading that existing OCaml supports.  This effort was begun a year ago by @jhw in [#240](https://github.com/ocaml-multicore/ocaml-multicore/pull/240) and now rebased and being reviewed by @engil in [#342](https://github.com/ocaml-multicore/ocaml-multicore/pull/342). Once that is merged and tested by us on a bunch of packages and bulk builds, we should be good to start using Multicore OCaml with opam. Stay tuned for more on that next month!

The ongoing and completed tasks for the Multicore OCaml are listed first, which are then followed by improvements to the Sandmark benchmarking project. Finally, the status of the contributions to upstream OCaml are mentioned for your reference.  This month has also seen a meeting of the core OCaml runtime developers to assign post-rebasing tasks (such as also porting statmemprof, how to handle non-x86 architectures, Windows support, etc) to ensure a more complete view of the upstreaming tasks ahead.  The task list is long, but steadily decreasing in length.

As to how to contribute currently, there is an incredibly exciting seam of work that has now started on the appropriate programming abstractions to support parallel algorithms in OCaml. See [this thread](https://discuss.ocaml.org/t/language-abstractions-and-scheduling-techniques-for-efficient-execution-of-parallel-algorithms-on-multicore-hardware/5822/19) for more on that, and also on the [Domainslib](https://github.com/ocaml-multicore/domainslib) repository for more low-level examples of traditional parallel algorithms.  In a month or so, we expect that the multicore switch will also be more suitable for use with opam, but don't let that stop you from porting your favourite parallel benchmark to Domainslib today.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#339](https://github.com/ocaml-multicore/ocaml-multicore/issues/339)
  Proposal for domain-local storage

  A new proposal for implementing a domain-local storage in Multicore
  OCaml has been created.

* [ocaml-multicore/domainslib#8](https://github.com/ocaml-multicore/domainslib/issues/8)
  Task library slowdown if the number of domains is greater than 8
  
  This is an ongoing investigation on why there is a slowdown with
  `domainslib` version 0.2 for the Game of Life benchmark when the
  number of domains is greater than eight.

* [ocaml-multicore/ocaml-multicore#340](https://github.com/ocaml-multicore/ocaml-multicore/pull/340)
  Fix Atomic.exchange in concurrent_minor_gc

  An implementation is provided for `Atomic.exchange` using
  `Atomic.get` and `Atomic.compare_and_set` to obtain the correct
  semantics to handle assertion failure in interp.c.

* [ocaml-multicore/ocaml-multicore#338](https://github.com/ocaml-multicore/ocaml-multicore/pull/338)
  Introduce Lazy.try_force and Lazy.try_force_val
  
  The `Lazy.try_force` and `Lazy.try_force_val` functions are
  implemented for concurrent lazy abstractions to handle the RacyLazy
  exception.

* [ocaml-multicore/ocaml-multicore#333](https://github.com/ocaml-multicore/ocaml-multicore/issues/333)
  Random module functions slowdown on multiple cores
  
  There is an observed slowdown for the `Random` module on multiple
  cores, and the issue is being analysed in detail.

  ![perf Random](https://discuss.ocaml.org/uploads/short-url/z1ggYyLuFZyEYlAIGjOFin3Dv8X.png)

* [ocaml-multicore/ocaml-multicore#343](https://github.com/ocaml-multicore/ocaml-multicore/pull/343)
  Fix extcall noalloc DWARF
  
  The patch provides a fix for the emitted DWARF information for
  `extcall noalloc`. This PR is currently under review.
  
### Completed

* [ocaml-multicore/ocaml-multicore#337](https://github.com/ocaml-multicore/ocaml-multicore/pull/337/)
  Update opam file to 4.10.0+multicore

  The rebasing of Multicore OCaml to 4.11 branch
  (`parallel_minor_gc_4_11`) point is now complete!  The
  [opam](https://github.com/ocaml-multicore/multicore-opam/pull/18/)
  file for 4.10.0+multicore has been made the default in the
  multicore-opam repository.
  
* [ocaml-multicore/ocaml-multicore#335](https://github.com/ocaml-multicore/ocaml-multicore/pull/335)
  Add byte_domain_state.tbl to install files
  
  A patch to install `byte_domain_state.tbl` and `caml/*.h` files has
  now been included in the runtime/Makefile which is required for
  parallel_minor_gc_4_10 branch.

* The Multicore OCaml major GC implementation verification using the
  SPIN model checker is available at the following GitHub repository
  [ocaml-multicore/multicore-ocaml-verify](https://github.com/kayceesrk/multicore-ocaml-verify).

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#115](https://github.com/ocaml-bench/sandmark/pull/115)
  Task API Port: LU-Decomposition, Floyd Warshall, Mandelbrot, N-body
  
  Porting of the following programs - LU-Decomposition, Floyd
  Warshall, Mandelbrot and N-body to use the Task API.

* [ocaml-bench/sandmark#37](https://github.com/ocaml-bench/sandmark/issues/37)
  Make benchmark wrapper user configurable
  
  The ability to dynamically specify the input commands and their
  respective arguments to the benchmark scripts is currently being
  evaluated.

* [ocaml-bench/sandmark#106](https://github.com/ocaml-bench/sandmark/issues/106)
  Promote dune > 2.0
  
  Sandmark works with dune 1.11.4 and we need to support dune greater
  than 2.0 moving forward. The upgrade path with the necessary package
  builds is being tested.

### Completed

* [ocaml-bench/sandmark#109](https://github.com/ocaml-bench/sandmark/pull/109)
  Added sequential-interactive.ipynb
  
  An interactive notebook to run and analyse sequential benchmarks has
  been included. Given an artifacts directory with the benchmark
  files, the notebook prompts you in the GUI to select different
  commit and compiler variants for analysis. A sample screenshot of
  the UI is shown below:

  ![Sequentials select comparison](https://discuss.ocaml.org/uploads/short-url/guDEKu51Mz8QwUwvVXA0FAqaWsf.png)

  The PR adds error handling, user input validation and the project
  README has also been updated.

* [ocaml-bench/sandmark#111](https://github.com/ocaml-bench/sandmark/pull/111)
  Add parallel initialisation and parallel copy to LU decomposition benchmark
  
  The parallel initialisation is now added to LU decomposition
  numerical benchmark
  (benchmarks/multicore-numerical/LU_decomposition_multicore.ml).

* [ocaml-bench/sandmark#113](https://github.com/ocaml-bench/sandmark/pull/113)
  Use --format=columns with pip3 list in Makefile
  
  A fix for the "DEPRECATION: The default format will switch to
  columns in the future" warning when using `pip3 list` has now been
  added to the Makefile with the use of the `--format=columns` option.

* [ocaml-bench/sandmark#116](https://github.com/ocaml-bench/sandmark/pull/116)
  Use sudo for parallel benchmark builds
  
  The Makefile has been updated with the right combination of `sudo`
  and OPAM environment variables so that we can now run parallel
  benchmarks in Sandmark. The sudo command is required exclusively for
  using the `chrt` command. We can now perform nightly builds for both
  serial and parallel benchmarks!

* [ocaml-bench/sandmark#118](https://github.com/ocaml-bench/sandmark/pull/118)
  Refactored README and added JupyterHub info
  
  The Sandmark README file has now been updated to include information
  on configuration, usage of JupyterHub, benchmarking and a quick
  start guide!

## OCaml

### Ongoing

* [ocaml/ocaml#9541](https://github.com/ocaml/ocaml/pull/9541)
  Add manual page for the instrumented runtime

  A draft manual for the instrumented runtime eventlog tracing has
  been created. Please feel free to review the document and share your
  valuable feedback.
  
* [ocaml/dune#3500](https://github.com/ocaml/dune/issues/3500) 
  Support building executables against OCaml 4.11 instrumented runtime
  
  OCaml 4.11.0 has built-in support for the instrumented runtime, and
  it will be useful to have dune generate instrumented targets.

### Completed

* [ocaml/ocaml#9082](https://github.com/ocaml/ocaml/pull/9082)
  Eventlog tracing system

  The Eventlog tracing proposal for the OCaml runtime that uses the
  Binary Trace Format (CTF) is now merged with upstream OCaml
  (4.11.0).

* [ocaml/ocaml#9534](https://github.com/ocaml/ocaml/pull/9534)
  [RFC] Dynamic check for naked pointers

  An RFC for adding the ability to dynamically identify naked pointers
  in the 4.10.0 compiler.

* [ocaml/ocaml#9573](https://github.com/ocaml/ocaml/pull/9573)
  Reimplement Unix.create_process and related functions without Unix.fork

  The use of process creation functions in the Unix module is not
  suitable for Multicore OCaml, for both behaviour and efficiency. The
  patch provides an implementation that uses `posix_spawn`.

* [ocaml/ocaml#9564](https://github.com/ocaml/ocaml/pull/9564)
  Add a macro for out-of-heap block header

  This PR adds a macro definition to construct a out-of-heap block
  header in runtime/caml/mlvalues.h. The objective is to use the
  header for out of heap objects.

As always, we would like to thank all the OCaml developers and users for their continued support and contribution to the project. Stay safe out there.

## Acronyms

* API: Application Programming Interface
* CTF: Common Trace Format
* DWARF: Debugging With Attributed Record Formats
* GC: Garbage Collector
* GUI: Graphical User Interface
* LU: Lower-Upper
* OPAM: OCaml Package Manager
* PIP: Pip Installs Python
* PR: Pull Request
* RFC: Request for Comments
* UI: User Interface
