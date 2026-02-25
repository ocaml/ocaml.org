---
title: OCaml Multicore - April 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-04-01"
tags: [multicore]
---

Welcome to the April 2020 update from the Multicore OCaml team, across the UK, India, France and Switzerland! Although most of us are in lockdown, we continue to march forward.  As with [previous updates](https://discuss.ocaml.org/tag/multicore-monthly), thanks to @shakthimaan and @kayceesrk for help assembling it all.  

### Preprint: Retrofitting Parallelism onto OCaml

We've put up a preprint of a paper titled ["Retrofitting Parallelism onto OCaml" ](https://arxiv.org/abs/2004.11663) for which we would be grateful to receive feedback.  The paper lays out the problem space for the multicore extension of OCaml  and presents the design choices, implementation and evaluation of the  concurrent garbage collector (GC).

Note that this is *not a final paper* as it is currently under peer review, so any feedback given now can still be incorporated.  Please use the e-mail contact details in the [pdf paper](https://arxiv.org/pdf/2004.11663.pdf) for @kayceesrk and myself so we can aggregate (and acknowledge!) any such comments.

### Rebasing Progress

The Multicore OCaml rebase from 4.06.1 has gained momentum.  We have successfully rebased the parallel-minor-GC all the way onto the [4.09 OCaml trees](https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc_4_09).  We will publish updated opam packages when we get to the recently branched 4.11 in the next couple of weeks.

Rebasing complex features like this is a "slow and steady" process due to the number of intermediate conflicts and bootstrapping, so we will not be publishing opam packages for every intermediate version -- instead, the 4.11 trees will form the new "stable base" for any PRs.

### Higher-level Domainslib API

A thread from [last month's update](https://discuss.ocaml.org/t/multicore-ocaml-march-2020-update/5406/8) on building a parallel raytracer led to some useful advancements in the [domainslib](https://github.com/ocaml-multicore/domainslib) library to provide async/await-style task support. See the updates below for more details.

There is also an interesting discussion on [ocaml-multicore/ocaml-multicore#324](https://github.com/ocaml-multicore/ocaml-multicore/issues/324) about how to go about profiling and optimising your own small programs.  More experiments with parallel algorithms with different scheduling properties would be most useful at this time.


### Upstreamed features in 4.11

The [4.11 release has recently branched](https://discuss.ocaml.org/t/ocaml-4-11-release-plan/5600) and has the following multicore-relevant changes in it:

- A concurrency-safe marshalling implementation (originally in [ocaml#9293](https://github.com/ocaml/ocaml/pull/9293), then implemented again in [ocaml#9353](https://github.com/ocaml/ocaml/pull/9353)). This will have a slight speed hit to marshalling-heavy programs, so feedback on trying this in your projects with 4.11 will be appreciated to the upstream OCaml issue tracker.

- A runtime eventlog tracing system using the CTF format is on the verge of being merged in 4.11 over in [ocaml#9082](https://github.com/ocaml/ocaml/pull/9082).  This will also be of interest to those who need sequential program profiling, and is a generalisation of the infrastructure that was essential to our development of the multicore GC.  If anyone is interested in helping with hacking on the OCaml side of CTF support to build clients, please get in touch with me or @kayceesrk.

In addition to the above highlights, we have also been making continuous improvements and additions to the Sandmark benchmarking test infrastructure. The various ongoing and completed tasks are provided below for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore](https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc_4_09)
  Promote Multicore OCaml to trunk

  The rebasing of Multicore OCaml from 4.06 to 4.10 is being worked, and we are now at 4.09! In a few weeks, we expect to complete the rebase to the latest trunk release.

* [ocaml-multicore/eventlog-tools](https://github.com/ocaml-multicore/eventlog-tools):
  OCaml Eventlog Tools

  A project that provides a set of tools for runtime tracing for OCaml 4.11.0 and higher has been created. This includes a simple OCaml decoder for eventlog's trace and a built-in chrome converter tool.

* [ocaml-multicore/domainslib#5](https://github.com/ocaml-multicore/domainslib/pull/5)
  Add parallel_scan to domainslib

  A [parallel_scan](https://en.wikipedia.org/wiki/Prefix_sum#Shared_memory:_Two-level_algorithm)  implementation that uses the Task API with prefix_sum and summed_area_table has now been added to the Domain-level Parallel Programming library for Multicore OCaml (domainslib) library.

### Completed

The following PRs have been merged into Multicore OCaml and its ecosystem projects:

* [ocaml-multicore/ocaml-multicore#328](https://github.com/ocaml-multicore/ocaml-multicore/pull/328)
  Multicore compiler with Flambda

  Support for Flambda has been merged into the Multicore OCaml project repository. The translation is now performed at cmmgen instead of lambda for clambda conversion.

* [ocaml-multicore/ocaml-multicore#324](https://github.com/ocaml-multicore/ocaml-multicore/issues/324)
  Optimizing a Multicore program

  The following [documentation](https://github.com/ocaml-multicore/ocaml-multicore/issues/324#issuecomment-610183856) provides a detailed example on how to do performance debugging for a Multicore program to improve the runtime performance.

* [ocaml-multicore/ocaml-multicore#325](https://github.com/ocaml-multicore/ocaml-multicore/pull/325)
  Added eventlog_to_latencies.py script

  A script to generate a latency report from an eventlog has now been  included in the ocaml-multicore repository.

* [ocaml-multicore/domainslib#4](https://github.com/ocaml-multicore/domainslib/pull/4)
  Add support for task_pools

  The domainslib library now has support for work-stealing task pools with async/await parallelism. You are encouraged to try the [examples](https://github.com/ocaml-multicore/domainslib/tree/task_pool/test).

## Benchmarking

A number of new benchmarks are being ported to the [Sandmark](https://github.com/ocaml-bench/sandmark) performance benchmarking test suite.

* [ocaml-bench/sandmark#104](https://github.com/ocaml-bench/sandmark/pull/104)
  Added python pip3 dependency

  A check_dependency function has now been defined in the Makefile along with a list of dependencies and pip packages for Ubuntu. You can now run `make depend` prior to building the benchmark suite to ensure that you have the required software. The `python3-pip` package has been added to the list of dependencies.

* [ocaml-bench/sandmark#96](https://github.com/ocaml-bench/sandmark/issues/96)
  Sandmark Analyze notebooks

  The setup, builds and execution scripts for developer branches on bench2.ocamllabs.io have been migrated to winter.ocamllabs.io.

  A UI and automated script driven notebooks for analyzing sequential bench results is being worked upon.

* [ocaml-bench/sandmark#108](https://github.com/ocaml-bench/sandmark/pull/108) 
  Porting mergesort and matrix multiplication using Task Pool API library

  This is an on-going PR to implement merge sort and matrix_multiplication using `parallel_for`.

* [cubicle](https://github.com/Sudha247/cubicle/tree/add-multicore)

  `Cubicle` is a model checker and an automatic SMT theorem prover. At present, it is being ported to Multicore OCaml, and this is a work in progress.

* [raytracers](https://github.com/athas/raytracers/pull/6)

  Raytracers is a repository that contains ray tracer implementation for different parallel functional programming languages. The OCaml implementation has now been updated to use the new `Domainslib.Task` API.

  Also, a few [experiments](https://github.com/kayceesrk/raytracers/blob/flambda/ocaml/myocamlbuild.ml) were performed on flambda parameters for the Multicore raytracer which gives around 25% speedup, but it does not yet remove the boxing of floats. The experiments are to be repeated with a merge against the wip flambda2 trees on 4.11, that removes float boxing.

## OCaml

### Ongoing

* [ocaml/ocaml#9082](https://github.com/ocaml/ocaml/pull/9082)
  Eventlog tracing system

  A substantial number of commits have gone into this PR based on reviews and feedback. These include updates to the configure script, handling warnings and exceptions, adding build support for Windows, removing unused code and coding style changes. This patch will be cherry-picked for the 4.11 release.

### Completed

* [ocaml/ocaml#9353](https://github.com/ocaml/ocaml/pull/9353)
  Reimplement `output_value` using a hash table to detect sharing

  This PR which implements a hash table and bit vector as required for Multicore OCaml has been merged to 4.11.

Our thanks as always go to all the OCaml developers and users in the community for their continued support, and contribution to the project!

## Acronyms

* API: Application Programming Interface
* GC: Garbage Collector
* PIP: Pip Installs Python
* PR: Pull Request
* SMT: Satisfiability Modulo Theories
* UI: User Interface
