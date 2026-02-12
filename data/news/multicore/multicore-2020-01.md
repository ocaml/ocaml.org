---
title: OCaml Multicore - January 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-01-01"
tags: [multicore]
---

Welcome to the January 2020 news update from the Multicore OCaml team! We're going to summarise our activites monthly to highlight what we're working on throughout this year. This update has kindly been assembled by @shakthimaan and @kayceesrk.

The most common question we get is how to contribute to the overall multicore effort. As I [noted last year](https://discuss.ocaml.org/t/multicore-prerequisite-patches-appearing-in-released-ocaml-compilers-now/4408), we are now in the process of steadily upstreaming our efforts to mainline OCaml. Therefore, the best way by far to contribute is to test for regressions or opportunities for improvements in the patches that are outstanding in the main OCaml repository.

A secondary benefit would be to review the PRs in the [multicore repository](https://github.com/ocaml-multicore/ocaml-multicore/pulls), but those tend to be more difficult to evaluate externally as they are being spotted as a result of stress testing at the moment.  A negative contribution would be to raise discussion of orthogonal features or new project management mechanisms -- this takes time and effort to reply to, and the team has a very full plate already now that the upstreaming has begun. We don't want to prevent those discussions from happening of course, but would appreciate if they were directed to the general OCaml bugtracker or another thread on this forum.

We'll first go over the OCaml PRs and issues, then cover the multicore repository and our Sandmark benchmarking infrastructure.  A new initiative to implement and test new parallel algorithms for Multicore OCaml is also underway.

## OCaml

### Ongoing

* [ocaml/ocaml#9082](https://github.com/ocaml/ocaml/pull/9082) Eventlog tracing system
  
  Eventlog is a proposal for a new tracing facility for OCaml runtime that provides metrics and counters, and uses the Binary Trace Format (CTF). The next step to get this merged is to incubate the tracing features in separate runtime variant, so it can be selected at application link time.

* [ocaml/ocaml#8984](https://github.com/ocaml/ocaml/pull/8984) Towards a new closure representation

  A new layout for closures has been proposed for traversal by the  garbage collector without the use of a page table. This is very much useful for Multicore OCaml and for performance improvements. The PR is awaiting review from other developers, and can then be rebased against trunk for testing and merge.

* [ocaml-multicore/ocaml-multicore#187](https://github.com/ocaml-multicore/ocaml-multicore/issues/187) Better Safe Points

  A patch to regularly poll for inter-domain interrupts to provide better safe points is actively being reviewed. This is to ensure that any pending interrupts are notified by the runtime system.

* Work is underway on improving the marshaling (runtime/extern.c) in upstream OCaml to avoid using GC mark bits to represent visitedness, and to use a hash table (addrmap) implementation.

### Completed

The following PRs have been merged to upstream OCaml trunk:

  * [ocaml/ocaml#8713](https://github.com/ocaml/ocaml/pull/8713) Move C global variables to a dedicated structure
  
    This PR moves the C global variables to a "domain state" table. Every domain requires its own table of domain local variables, and hence this is required for Multicore runtime.

    This uncovered a number of [compatability issues](https://github.com/ocaml/ocaml/issues/9205) with the C header files, which were all included in the recent OCaml 4.10.0+beta2 release via the next item.

  * [ocaml/ocaml#9253](https://github.com/ocaml/ocaml/pull/9253) Move back `caml_*` to thematic headers
  
    The `caml_*` definitions from runtime/caml/compatibility.h have been moved to provide a compatible API for OCaml versions 4.04 to 4.10. This change is also useful for Multicore domains that have their own state.

## Multicore OCaml

The following PRs have been merged into the Multicore OCaml trees:

* [ocaml-multicore/ocaml-multicore#275](https://github.com/ocaml-multicore/ocaml-multicore/pull/275)
  Fix lazy behaviour for Multicore
  
  A `caml_obj_forward_lazy()` function is implemented to handle lazy values in Multicore Ocaml.

* [ocaml-multicore/ocaml-multicore#269](https://github.com/ocaml-multicore/ocaml-multicore/pull/269)
  Move from a global `pools_to_rescan` to a domain-local one

  During stress testing, a segmentation fault occurred when a pool was  being rescanned while a domain was allocating in to it. The rescan has now been moved to the domain local, and hence this situation will not occur again.

* [ocaml-multicore/ocaml-multicore#268](https://github.com/ocaml-multicore/ocaml-multicore/pull/268)
  Fix for a few space leaks

  The space leaks that occurred during domain spawning and termination when performing the stress tests have been fixed in this PR.

* [ocaml-multicore/ocaml-multicore#272](https://github.com/ocaml-multicore/ocaml-multicore/pull/272)
  Fix for DWARF CFI for non-allocating external calls
 
  The entry to `caml_classify_float_unboxed` caused a corrupted backtrace, and a fix that clearly specifies the boundary between OCaml and C has been provided.

* An effort to implement a synchronized minor garbage collector for Multicore OCaml is actively being researched and worked upon. Benchmarking for a work-sharing parallel stop-the-world branch against multicore trunk has been performed along with clearing technical debt, handling race conditions, and fixing segmentation faults. The C-API reversion changes have been tested and merged into the stop-the-world minor GC branch for Multicore OCaml.

## Benchmarking

* The [Sandmark](https://github.com/ocaml-bench/sandmark) performance benchmarking infrastructure has been improved for backfilling data, tracking branches and naming benchmarks.

* Numerical parallel benchmarks have been added to the Multicore compiler. 
  
* An [Irmin](https://irmin.org) macro benchmark has been included in Sandmark. A test for measuring Irmin's merge capabilities with Git as its filesystem is being tested with different read and write rates.

* Work is also underway to implement parallel algorithms for N-body, reverse-complement, k-nucleotide, binary-trees, fasta, fannkuch-redux, regex-redux, Game of Life, RayTracing, Barnes Hut, Count Graphs, SSSP and from the MultiMLton benchmarks to test on Multicore OCaml.

## Documentation

* A chapter on Parallel Programming in Multicore OCaml is being written and an early draft will be made available to the community for their feedback. It is based on Domains, with examples to implement array sums, Pi approximation, and trapezoidal rules for definite integrals.

## Acronyms

* API: Application Programming Interface
* CTF: Common Trace Format
* CFI: Call Frame Information
* DWARF: Debugging With Attributed Record Formats
* GC: Garbage Collector
* PR: Pull Request
* SSSP: Single Source Shortest Path
