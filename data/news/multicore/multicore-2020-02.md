---
title: OCaml Multicore - February 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-02-01"
tags: [multicore]
---

Welcome to the February 2020 news update from the Multicore OCaml team, spread across the UK, India, France and Switzerland! This follows on from [last month's](https://discuss.ocaml.org/t/multicore-ocaml-january-2020-update/5090) update, and has been put together by @shakthimaan and @kayceesrk. 

The [release of OCaml 4.10.0](https://discuss.ocaml.org/t/ocaml-4-10-released/5194) has successfully pushed out some prerequisite features into the upstream compiler.  Our work in February has focussed on getting the multicore OCaml branch "feature complete" with respect to the complete OCaml language, and doing extensive benchmarking and stress testing to test our two minor heap implementations.

To this end, a number of significant patches have been merged into the [Multicore OCaml trees](https://github.com/ocaml-multicore/ocaml-multicore) that essentially provide complete coverage of the language features. We encourage you to test the same for regressions and provide any improvements or report shortcomings to us. There are ongoing OCaml PRs and issues that are also under review, and we hope to complete those for the 4.11 release cycle. A new set of parallel benchmarks have been added to our [Sandmark benchmarking suite](https://github.com/ocaml-bench/sandmark) (live instance [here](https://github.com/ocaml-bench/sandmark), including enhancements to the build setup.

## Multicore OCaml

### Completed

The following PRs have been merged into Multicore OCaml:

* [ocaml-multicore/ocaml-multicore#281](https://github.com/ocaml-multicore/ocaml-multicore/pull/281)
  Introduce `Forcing_tag` to fix concurrency bug with lazy values

  A `Forcing_tag` is used to implement lazy values to handle a concurrency bug. It behaves like a locked bit, and any concurrent access by a mutator will raise an exception on that domain.

* [ocaml-multicore/ocaml-multicore#282](https://github.com/ocaml-multicore/ocaml-multicore/pull/282)
  Safepoints

  A preliminary version of safe points has been merged into the Multicore OCaml trees. [ocaml-multicore/ocaml-multicore#187](https://github.com/ocaml-multicore/ocaml-multicore/issues/187) also contains more discussion and background about how coverage can be improved in future PRs.
 
* [ocaml-multicore/ocaml-multicore#285](https://github.com/ocaml-multicore/ocaml-multicore/pull/285)
  Introduce an 'opportunistic' major collection slice

  An "opportunistic work credit" is implemented in this PR which forms a basis for doing mark and sweep work while waiting to synchronise with other domains.

* [ocaml-multicore/ocaml-multicore#286](https://github.com/ocaml-multicore/ocaml-multicore/pull/286)
  Do fflush and variable args in caml_gc_log

  The caml_gc_log() function has been updated to ensure that `fflush` is invoked only when GC logging is enabled.

* [ocaml-multicore/ocaml-multicore#287](https://github.com/ocaml-multicore/ocaml-multicore/pull/287)
  Increase EVENT_BUF_SIZE

  During debugging with event trace data it is useful to reduce the buffer flush times, and hence the `EVENT_BUF_SIZE` has now been increased.

* [ocaml-multicore/ocaml-multicore#288](https://github.com/ocaml-multicore/ocaml-multicore/pull/288)
  Write barrier optimization

  This PR closes the regression for the `chameneos_redux_lwt` benchmarking in Sandmark by using `intnat` to avoid sign extensions and cleans up `write_barrier` to improve overall performance.

* [ocaml-multicore/ocaml-multicore#290](https://github.com/ocaml-multicore/ocaml-multicore/pull/290)
  Unify sweep budget to be in word size

  The PR updates the sweep work units to all be in word size. This is to handle the differences between the budget for setup, sweep and for large allocations in blocks.

### Ongoing

* A lot of work is ongoing for the implementation of a synchronised minor garbage collector for Multicore OCaml, including benchmarking for the stop-the-world (stw) branch.  We will publish the results of this in a future update, as we are assembling a currently comprehensive evaluation of the runtime against the mainstream runtime.

## Benchmarking

[Sandmark](https://github.com/ocaml-bench/sandmark) now has support to run parallel benchmarks. We can also now about GC latency measurements for both stock OCaml and Multicore OCaml compiler.

* [ocaml-bench/sandmark#73](https://github.com/ocaml-bench/sandmark/pull/73)
  More parallel benchmarks

  A number of parallel benchmarks such as N-body, Quick Sort and matrix multiplication have now been added to Sandmark!

* [ocaml-bench/sandmark#76](https://github.com/ocaml-bench/sandmark/pull/76)
  Promote packages. Unbreak CI.

  The Continuous Integration build can now execute after updating and promoting packages in Sandmark.

* [ocaml-bench/sandmark#78](https://github.com/ocaml-bench/sandmark/pull/78)
  Add support for collecting information about GC pausetimes on trunk

  The PR now helps process the runtime log and produces a `.bench` file that captures the GC pause times. This works on both stock OCaml and in Multicore OCaml.

* [ocaml-bench/sandmark#86](https://github.com/ocaml-bench/sandmark/pull/86)
  Read and write Irmin benchmark

  A test for measuring Irmin's merge capabilities with Git as its filesystem is being tested with different read and write rates.

* A number of other parallel benchmarks like Merge sort, Floyd-Warshall matrix, prime number generation, parallel map, filter et. al. have been added to Sandmark.

## Documentation

* Examples using domainslib and modifying Domains are currently being worked upon for a chapter on Parallel Programming for Multicore OCaml. We will release an early draft to the community for your feedback.

## OCaml

One PR opened to OCaml this month, which fixes up the marshalling scheme to be multicore compatible. The complete set of [upstream multicore prerequisites](https://github.com/ocaml/ocaml/labels/multicore-prerequisite) are labelled in the compiler issue tracker.

* [ocaml/ocaml#9293](https://github.com/ocaml/ocaml/pull/9293) Use addrmap hash table for marshaling

  The hash table (addrmap) implementation from Multicore OCaml has been ported to upstream OCaml to avoid using GC mark bits to represent visitedness.

## Acronyms

* CTF: Common Trace Format
* CI: Continuous Integration
* GC: Garbage Collector
* PR: Pull Request

As always, many thanks to our fellow OCaml developers and users who have reviewed our code, reported bugs or otherwise assisted this month.
