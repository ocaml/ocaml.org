---
title: OCaml Multicore - June 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-06-01"
tags: [multicore]
---

Welcome to the June 2020 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) report! As with [previous updates](https://discuss.ocaml.org/tag/multicore-monthly), many thanks to @shakthimaan and @kayceesrk for collating the updates for the month of June 2020. *This is an incremental update; new readers may find it helpful to flick through the previous posts first.*

This month has seen a tremendous surge of activity on the upstream OCaml project to prepare for multicore integration, as @xavierleroy and the core team have driven a number of initiatives to prepare the OCaml project for the full multicore featureset.  To reflect this, from next month we will have a status page on the ocaml-multicore wiki with the current status of both our multicore branch and the upstream OCaml project itself.

Why not from this month? Well, there's good news and bad news.  [Last month](https://discuss.ocaml.org/t/multicore-ocaml-may-2020-update/5898), I observed that we are a PR away from most of the opam ecosystem working with the multicore branch.  The good news is that we are still a single PR away from it working, but it's a different one :-) The retrofitting of the `Threads` library has brought up [some design complexities](https://github.com/ocaml-multicore/ocaml-multicore/pull/342), and so rather than putting in a "bandaid" fix, we are integrating a comprehensive solution that will work with system threads, domains and (eventually) fibres. That work has taken some time to get right, and I hope to be able to update you all on an opam-friendly OCaml 4.10.0+multicore in a few weeks.

Aside from this, there have been a number of other improvements going into the multicore branches: [mingw Windows support](https://github.com/ocaml-multicore/ocaml-multicore/pull/351), [callstack improvements](https://github.com/ocaml-multicore/ocaml-multicore/pull/363), [fixing the Unix module](https://github.com/ocaml-multicore/ocaml-multicore/pull/346) and so on. The full list is in the detailed report later in this update.

## Sandmark benchmarks

A major milestone in this month has been the upgrade to the latest dune.2.6.0 to build Multicore OCaml 4.10.0 for the Sandmark benchmarking project. A number of new OPAM packages have been added, and the existing packages have been upgraded to their latest versions. The Multicore OCaml code base has seen continuous performance improvements and enhancements which can be observed from the various PRs mentioned in the report.

We would like to thank:

* @xavierleroy for working on a number of multicore-prequisite PRs to
  make stock OCaml ready for Multicore OCaml.
* @camlspotter has reviewed and accepted the camlimages changes
  and made a release of camlimages.5.0.3 required for Sandmark.
* @dinosaure for updating the decompress test benchmarks for Sandmark
  to build and run with dune.2.6.0 for Multicore OCaml 4.10.0.

A chapter on Parallel Programming in Multicore OCaml with topics on task pool, channels section, profiling with code examples is being written. We shall provide an early draft version of the document to the community for your valuable feedback.

## Papers

Our "Retrofitting Parallism onto OCaml" paper has been officially accepted at [ICFP 2020](https://icfp20.sigplan.org/track/icfp-2020-papers#event-overview) which will be held virtually between August 23-28, 2020. A [preprint](https://arxiv.org/abs/2004.11663) of the paper was made available earlier, and will be updated in a few days with the camera-ready version for ICFP.  Please do feel free to send on comments and queries even after the paper is published, of course.

Excitingly, another multicore-related paper on [Cosmo: A Concurrent Separation Logic for Multicore OCaml](http://gallium.inria.fr/~fpottier/publis/mevel-jourdan-pottier-cosmo-2020.pdf) will also be presented at the same conference.

The Multicore OCaml updates are first listed in our report, which are followed by improvements to the Sandmark benchmarking project. Finally, the changes made to upstream OCaml which include both the ongoing and completed tasks are mentioned for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#339](https://github.com/ocaml-multicore/ocaml-multicore/issues/339)
  Proposal for domain-local storage

  An RFC proposal to implement a domain-local storage in Multicore
  OCaml. Kindly review the idea and share your feedback!

* [ocaml-multicore/ocaml-multicore#342](https://github.com/ocaml-multicore/ocaml-multicore/pull/342)
  Implementing the threads library with Domains

  An effort to rebase @jhwoodyatt's implementation of the Thread
  library for Domains.

* [ocaml-multicore/ocaml-multicore#357](https://github.com/ocaml-multicore/ocaml-multicore/issues/357)
  Implementation of systhreads with pthreads

  Exploring the possibilty of implementing systhreads with pthreads,
  while still maintaining compatibility with the existing solution.

* [ocaml/dune#3548](https://github.com/ocaml/dune/issues/3548)
  Dune fails to pick up secondary compiler

  The `ocaml-secondary-compiler` fails to install with dune.2.6.0. This
  is required as Multicore OCaml cannot build the latest dune without
  systhreads support.

### Completed

* [ocaml-multicore/multicore-opam#22](https://github.com/ocaml-multicore/multicore-opam/pull/22)
  Update dune to 2.6.0

  The dune version in the Multicore OPAM repository is now updated to
  use the latest 2.6.0.

* [ocaml-multicore/ocaml-multicore#338](https://github.com/ocaml-multicore/ocaml-multicore/pull/338)
  Introduce Lazy.try_force and Lazy.try_force_val

  An implementation of `Lazy.try_force` and `Lazy.try_force_val`
  functions to implement concurrent lazy abstractions.

* [ocaml-multicore/ocaml-multicore#340](https://github.com/ocaml-multicore/ocaml-multicore/pull/340)
  Fix Atomic.exchange in concurrent_minor_gc

  A patch that introduces `Atomic.exchange` through `Atomic.get` that
  provides the appropriate read barrier for correct exchange
  semantics for `caml_atomic_exchange` in `memory.c`.
  
* [ocaml-multicore/ocaml-multicore#343](https://github.com/ocaml-multicore/ocaml-multicore/pull/343)
  Fix extcall noalloc DWARF

  The DWARF information emitted for `extcall noalloc` had broken
  backtraces and this PR fixes the same.

* [ocaml-multicore/ocaml-multicore#345](https://github.com/ocaml-multicore/ocaml-multicore/pull/345)
  Absolute exception stack

  The representation of the exception stack is changed from relative
  addressing to absolute addressing and the results are promising. The
  Sandmark serial benchmark results after the change is illustrated in
  the following graph:

![Absolute addressing improvements |690x218](https://discuss.ocaml.org/uploads/short-url/pC6XsKYqKRDr9zy7RQmp8D6XIDE.png)

* [ocaml-multicore/ocaml-multicore#347](https://github.com/ocaml-multicore/ocaml-multicore/pull/347)
  Turn on -Werror by default

  Adds a `--enable-warn-error` option to `configure` to treat C
  compiler warnings as errors.

* [ocaml-multicore/ocaml-multicore#353](https://github.com/ocaml-multicore/ocaml-multicore/pull/353)
  Poll for interrupts in cpu_relax without locking

  Use `Caml_check_gc_interrupt` first to poll for interrupts without
  locking, and then proceeding to handle the interrupt with the lock.

* [ocaml-multicore/ocaml-multicore#354](https://github.com/ocaml-multicore/ocaml-multicore/pull/354)
  Add Caml_state_field to domain_state.h

  The `Caml_state_field` macro definition in domain_state.h is
  required for base-v0.14.0 to build for Multicore OCaml 4.10.0 with
  dune.2.6.0.

* [ocaml-multicore/ocaml-multicore#355](https://github.com/ocaml-multicore/ocaml-multicore/pull/355)
  One more location to poll for interrupts without lock

  Another use of `Caml_check_gc_interrupt` first to poll for
  interrupts without lock, similar to
  [ocaml-multicore/ocaml-multicore#353](https://github.com/ocaml-multicore/ocaml-multicore/pull/353).

* [ocaml-multicore/ocaml-multicore#356](https://github.com/ocaml-multicore/ocaml-multicore/pull/356)
  Backup threads for domain

  Introduces `backup threads` to perform GC and handle service
  interrupts when the domain is blocked in the kernel.

* [ocaml-multicore/ocaml-multicore#358](https://github.com/ocaml-multicore/ocaml-multicore/pull/358)
  Fix up bad CFI information in amd64.S

  Add missing `CFI_ADJUST` directives in `runtime/amd64.S` for
  `caml_call_poll` and `caml_allocN`.

* [ocaml-multicore/ocaml-multicore#359](https://github.com/ocaml-multicore/ocaml-multicore/pull/359)
  Inline caml_domain_alone

  The PR makes `caml_domain_alone` an inline function to improve
  performance for `caml_atomic_cas_field` and other atomics in
  `memory.c`.

* [ocaml-multicore/ocaml-multicore#360](https://github.com/ocaml-multicore/ocaml-multicore/pull/360)
  Parallel minor GC inline mask rework

  The inline mask rework for the promotion path to the
  `parallel_minor_gc` branch gives a 3-5% performance improvement for
  `test_decompress` sandmark benchmark, and a decrease in the executed
  instructions for all other benchmarks.

* [ocaml-multicore/ocaml-multicore#361](https://github.com/ocaml-multicore/ocaml-multicore/pull/361)
  Mark stack push work credit

  The PR improves the Multicore mark work accounting to be in line
  with stock OCaml.

* [ocaml-multicore/ocaml-multicore#362](https://github.com/ocaml-multicore/ocaml-multicore/pull/362)
  Iloadmut does not clobber rax and rdx when we do not have a read barrier
    
  A code clean-up to free the registers `rax` and `rdx` for OCaml code
  when `Iloadmut` is used.
	
## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#8](https://github.com/ocaml-bench/sandmark/issues/8)
  Ability to run compiler variants in Sandmark

  A feature to specify configure options when building compiler
  variants such as `flambda` is useful for development and
  testing. This feature is being worked upon.

* [ocaml-bench/sandmark#107](https://github.com/ocaml-bench/sandmark/issues/107)
  Add Coq benchmarks

  We are continuing to add more benchmarks to Sandmark for Multicore
  OCaml and investigating adding the [Coq](https://coq.inria.fr/)
  benchmarks to our repertoire!

* [ocaml-bench/sandmark#124](https://github.com/ocaml-bench/sandmark/pull/124)
  User configurable paramwrapper added to Makefile

  A `PARAMWRAPPER` environment variable can be passed as an argument
  by specifying the `--cpu-list` to be used for parallel benchmark
  runs.

* [ocaml-bench/sandmark#131](https://github.com/ocaml-bench/sandmark/pull/131)
  Update decompress benchmarks

  Thanks to @dinosaure for updating the decompress benchmarks in order
  to run them with dune.2.6.0 for Multicore OCaml 4.10.0.

* [ocaml-bench/sandmark#132](https://github.com/ocaml-bench/sandmark/pull/132)
  Update dependency packages to use dune.2.6.0 and Multicore OCaml 4.10.0

  Sandmark has been running with dune.1.11.4, and we need to move to
  the latest dune.2.6.0 for using Multicore OCaml 4.10.0 and beyond,
  as mentioned in [Promote dune to >
  2.0](https://github.com/ocaml-bench/sandmark/issues/106). The PR
  updates over 30 dependency packages and successfully builds both
  serial and parallel benchmarks!

### Completed

* [camlspotter/camlimages#1](https://gitlab.com/camlspotter/camlimages/-/merge_requests/1)
  Use dune-configurator instead of configurator for camlimages

  A new release of `camlimages.5.0.3` was made by @camlspotter after
  accepting the changes to camlimages.opam in order to build with
  dune.2.6.0.
  
* [ocaml-bench/sandmark#115](https://github.com/ocaml-bench/sandmark/pull/115)
  Task API Port: LU-Decomposition, Floyd Warshall, Mandelbrot, Nbody

  The changes to use the `Domainslib.Task` API for the listed benchmarks
  have been merged.

* [ocaml-bench/sandmark#121](https://github.com/ocaml-bench/sandmark/pull/121)
  Mention sudo access for run_all_parallel.sh script

  The README.md file has been updated with the necessary `sudo`
  configuration steps to execute the `run_all_parallel.sh` script for
  nightly builds.

* [ocaml-bench/sandmark#125](https://github.com/ocaml-bench/sandmark/pull/125)
  Add cubicle benchmarks

  The `German PFS` and `Szymanski's mutual exclusion algorithm` cubicle
  benchmarks have been included in Sandmark.

* [ocaml-bench/sandmark#126](https://github.com/ocaml-bench/sandmark/pull/126)
  Update ocaml-versions README to reflect 4.10.0+multicore

  The README has now been updated to reflect the latest 4.10.0
  Multicore OCaml compiler and its variants.

* [ocaml-bench/sandmark#129](https://github.com/ocaml-bench/sandmark/pull/129)
  Add target to run parallel benchmarks in the CI

  The .drone.yml file used by the CI has been updated to run both the
  serial and parallel benchmarks.

* [ocaml-bench/sandmark#130](https://github.com/ocaml-bench/sandmark/pull/130)
  Add missing dependencies in multicore-numerical

  The `domainslib` library has been added to the dune file for the
  multicore-numerical benchmark.

## OCaml

### Ongoing

* [ocaml/ocaml#9541](https://github.com/ocaml/ocaml/pull/9541)
  Add manual page for the instrumented runtime

  The [instrumented runtime](https://github.com/ocaml/ocaml/pull/9082)
  has been merged to OCaml 4.11.0. A manual for the same has been
  created and is under review.


### Completed

* [ocaml/ocaml#9619](https://github.com/ocaml/ocaml/pull/9619)
  A self-describing representation for function closures

  The PR provides a way to record the position of the environment for
  each entry point for function closures.

* [ocaml/ocaml#9649](https://github.com/ocaml/ocaml/pull/9649)
  Marshaling for the new closure representation

  The `output_value` marshaler has been updated to use the new closure
  representation. There is no change required for the `input_value`
  unmarshaler.

* [ocaml/ocaml#9655](https://github.com/ocaml/ocaml/pull/9655)
  Introduce type Obj.raw_data and functions Obj.raw_field,
  Obj.set_raw_field to manipulate out-of-heap pointers

  The PR introduces a type `Obj.bits`, and functions `Obj.field_bits`
  and `Obj.set_field_bits` to read and write bit representation of
  block fields to support the no-naked-pointer operation.

* [ocaml/ocaml#9678](https://github.com/ocaml/ocaml/pull/9678)
  Reimplement Obj.reachable_word using a hash table to detect sharing

  The `caml_obj_reachable_words` now uses a hash table instead of
  modifying the mark bits of block headers to detect sharing. This is
  required for compatibility with Multicore OCaml.

* [ocaml/ocaml#9680](https://github.com/ocaml/ocaml/pull/9680)
  Naked pointers and the bytecode interpreter

  The bytecode interpreter implementation is updated to support the
  no-naked-pointers mode operation as required by Multicore OCaml.

* [ocaml/ocaml#9682](https://github.com/ocaml/ocaml/pull/9682)
  Signal handling in native code without the page table

  The patch uses the code fragment table instead of a page table
  lookup for signal handlers to know whether the signal came from
  ocamlopt-generated code.

* [ocaml/ocaml#9683](https://github.com/ocaml/ocaml/pull/9683)
  globroots.c: adapt to no-naked-pointers mode

  The patch considers out-of-heap pointers as major-heap pointers in
  no-naked-pointers mode for global roots management.

* [ocaml/ocaml#9689](https://github.com/ocaml/ocaml/pull/9689)
  Generic hashing for the new closure representation

  The hashing functions have been updated to use the latest closure
  representation from
  [ocaml/ocaml#9619](https://github.com/ocaml/ocaml/pull/9619) for the
  no-naked-pointers mode.

* [ocaml/ocaml#9698](https://github.com/ocaml/ocaml/pull/9698)
  The end of the page table is near

  The PR eliminates some of the use of the page tables in the runtime
  system when built with no-naked-pointers mode.

Our thanks to all the OCaml developers and users in the community for
their continued support and contribution to the project. Stay safe!

## Acronyms

* API: Application Programming Interface
* CFI: Call Frame Information
* CI: Continuous Integration
* DWARF: Debugging With Attributed Record Formats
* GC: Garbage Collector
* ICFP: International Conference on Functional Programming
* OPAM: OCaml Package Manager
* PR: Pull Request
* RFC: Request for Comments
