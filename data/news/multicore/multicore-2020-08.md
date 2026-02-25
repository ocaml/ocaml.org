---
title: OCaml Multicore - August 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-08-01"
tags: [multicore]
---

Welcome to the August 2020 Multicore OCaml report (a few weeks late due to August slowdown). This update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by @shakthimaan, @kayceesrk and myself.

There are some talks related to multicore OCaml which are now freely available online:

- At the OCaml Workshop, @sadiq presented ["How to parallelise your code with Multicore OCaml"](https://www.youtube.com/watch?v=Z7YZR1q8wzI&list=PLKO_ZowsIOu5fHjRj0ua7_QWE_L789K_f&index=6&t=0s)
- At ICFP, @kayceesrk presented ["Retrofitting Parallelism onto OCaml"](https://www.youtube.com/watch?v=i9wgeX7e-nc&t=6180s), which was also awarded a Distinguished Paper award.
- At ICFP, Glenn Mével presented ["Cosmo: A Concurrent Separation Logic for Multicore OCaml"](https://www.youtube.com/watch?v=aNLOi-1ixwM&t=2610s).
- At the WebAssembly Community Group meeting,  @kayceesrk gave a talk on [Effect Handlers in Multicore OCaml](https://kcsrk.info/slides/WASM_CG_4Aug20.pdf).  This is related to our longer term efforts to ensure that OCaml has an efficient compilation strategy to WebAssembly.

The Multicore OCaml project has had a number of optimisations and performance improvements in the month of August 2020:
- The PR on the [implementation of systhreads with pthreads](https://github.com/ocaml-multicore/ocaml-multicore/pull/381) continues to undergo review and improvement. When merged, this opens up the possibility of installing dune and other packages with Multicore OCaml.
- Implementations of mutex and condition variables is also now [under review](https://github.com/ocaml-multicore/ocaml-multicore/pull/390) for the `Domain` module.
- Work has begun on implementing [GC safe points](https://github.com/ocaml-multicore/ocaml-multicore/pull/394) to ensure reliable, low-latency garbage collection can occur.

We would like to particularly thank these external contributors:
* Albin Coquereau and Guillaume Bury for their comments and recommendations on building Alt-Ergo.2.3.2 with dune.2.6.0 and Multicore OCaml 4.10.0 in a sandbox environment.
* @Leonidas for testing the code size metric implementation with `Core` and `Async`, and for code review changes.

Contributions such as the above towards adapting your projects with our benchmarking suites are always most welcome.  As with previous updates, we begin with the Multicore OCaml updates, which are then followed by the enchancements and bug fixes to the Sandmark benchmarking project. The upstream OCaml ongoing and completed tasks are finally mentioned for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#381](https://github.com/ocaml-multicore/ocaml-multicore/pull/381)
  Reimplementating systhreads with pthreads

  This PR has made tremendous progress with additions to domain API,
  changes in interaction with the backup thread, and bug fixes. We are
  now able to build `dune.2.6.1` and `utop` with this PR for Multicore
  OCaml, and it is ready for review!

* [ocaml-multicore/ocaml-multicore#384](https://github.com/ocaml-multicore/ocaml-multicore/pull/384)
  Add a primitive to insert nop instruction

  The `nop` primitive is introduced to identify the start and end of
  an instruction sequence to aid in debugging low-level code.

* [ocaml-multicore/ocaml-multicore#390](https://github.com/ocaml-multicore/ocaml-multicore/pull/390)
  Initial implementation of Mutexes and Condition Variables

  A draft proposal that adds support for Mutex variables and Condition
  operations for the Multicore runtime.

### Completed

#### Optimisations

* [ocaml-multicore/domainslib#16](https://github.com/ocaml-multicore/domainslib/pull/16)
  Improvement of parallel_for implementation

  A divide-and-conquer scheme is introduced to distribute work in
  `parallel_for`, and the `chunk_size` is made a parameter to improve
  scaling with more than 8-16 cores. The blue line in the following
  illustration shows the improvement for few benchmarks in Sandmark
  using the default `chunk_size` along with this PR:
 ![OCaml-Domainslib-16-Illustration|465x500](https://discuss.ocaml.org/uploads/short-url/u4M9bCyA5fu77JZRyJZv4KxMjj3.png) 

* [ocaml-multicore/multicore-opam](https://github.com/ocaml-multicore/multicore-opam/pull/28)
  Use `-j%{jobs}%` for multicore variant builds

  The use of `-j%{jobs}%` in the build step for multicore variants
  will speed up opam installs.

* [ocaml-multicore/ocaml-multicore#374](https://github.com/ocaml-multicore/ocaml-multicore/pull/374)
  Force major slice on minor collection

  A minor collection will need to schedule a major collection, if a
  blocked thread may not progress the major GC when servicing the
  minor collector through `handle_interrupt`.

* [ocaml-multicore/ocaml-multicore#378](https://github.com/ocaml-multicore/ocaml-multicore/pull/378)
  Hold onto empty pools if swept while allocating

  An optimization to improve pause times and reduce the number of
  locks by using a `release_to_global_pool` flag in `pool_sweep`
  function that continues to hold onto the empty pools.

* [ocaml-multicore/ocaml-multicore#379](https://github.com/ocaml-multicore/ocaml-multicore/pull/379)
  Interruptible mark and sweep

  The mark and sweep work is now made interruptible so that domains
  can enter the stop-the-world minor collections even if one domain is
  performing a large task. For example, for the binary tree benchmark
  with four domains, major work (pink) in domain three stalls progress
  for other domains as observed in the eventlog.
  ![OCaml-Multicore-PR-379-Illustration-Before|539x500](https://discuss.ocaml.org/uploads/short-url/y7YfHHD2CGLLjUFw6rdwuBBq0zm.png)
 
  With this patch, we can observe that the major work in domains two
  and four make progress in the following illustration:
![OCaml-Multicore-PR-379-Illustration-After|655x500](https://discuss.ocaml.org/uploads/short-url/3UPxEjemdhgAAEnnqsv7iV17PK3.png) 

* [ocaml-multicore/ocaml-multicore#380](https://github.com/ocaml-multicore/ocaml-multicore/pull/380)
  Make DLS call to `caml_domain_dls_get` `@@noalloc`

  The `caml_dls_get` is tagged with `@@noalloc` to reduce the C call
  overhead.

* [ocaml-multicore/ocaml-multicore#382](https://github.com/ocaml-multicore/ocaml-multicore/pull/382)
  Optimise `caml_continuation_use_function`

  A couple of optimisations that yield 25% performance improvements
  for the generator example by using `caml_domain_alone`, and using
  `caml_gc_log` under `DEBUG` mode.

* [ocaml-multicore/ocaml-multicore#389](https://github.com/ocaml-multicore/ocaml-multicore/pull/389)
  Avoid holding domain_lock when using backup thread

  The wait time for the main OCaml thread is reduced by altering the
  backup thread logic without holding the `domain_lock` for the
  `BT_IN_BLOCKING_SECTION`.

#### Sundries

* [ocaml-multicore/ocaml-multicore#391](https://github.com/ocaml-multicore/ocaml-multicore/pull/391)
  Use `Word_val` for pointers with `Patomic_load`

  A bug fix to correctly handle `Patomic_load` for loaded pointers.

* [ocaml-multicore/ocaml-multicore#392](https://github.com/ocaml-multicore/ocaml-multicore/pull/392)
  Include Ipoll in leaf function test

  The `Ipoll` operation is now added to `asmcomp/amd64/emit.mlp` as an external call.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#122](https://github.com/ocaml-bench/sandmark/issues/122)
  Measurements of code size

  The code size of a benchmark is one measurement that is required for
  `flambda` branch. A
  [PR](https://github.com/ocaml-bench/sandmark/pull/165) has been
  created that now emits a count of the CAML symbols in the output of
  a bench result as shown below:

  ```json
  {"name":"knucleotide.", ... ,"codesize":276859.0, ...}
  ```

* [ocaml-bench/sandmark#169](https://github.com/ocaml-bench/sandmark/pull/169)
  Add check_url for .json and pkg-config, m4 in Makefile

  A `check_url` target in the Makefile has been defined to ensure that
  the `ocaml-versions/*.json` files have a URL parameter. The patch
  also adds `pkg-config` and `m4` to Ubuntu dependencies.

### Completed

#### Benchmarks

* [ocaml-bench/sandmark#107](https://github.com/ocaml-bench/sandmark/issues/107)
  Add Coq benchmarks

  The `fraplib` library from the [Formal Reasoning About
  Programs](https://github.com/achlipala/frap) has been dunified and
  included in Sandmark for Coq benchmarks.

* [ocaml-bench/sandmark#151](https://github.com/ocaml-bench/sandmark/pull/151)
  Evolutionary algorithm parallel benchmark

  The evolutionary algorithm parallel benchmark is now added to Sandmark.

* [ocaml-bench/sandmark#152](https://github.com/ocaml-bench/sandmark/pull/152)
  LU decomposition: random numbers initialisation in parallel

  The random number initialisation for the LU decomposition benchmark
  now has parallelism that uses `Domain.DLS` and `Random.State`.

* [ocaml-bench/sandmark#153](https://github.com/ocaml-bench/sandmark/pull/153)
  Add computationally intensive Coq benchmarks

  The `BasicSyntax` and `AbstractInterpretation` Coq files perform a
  lot of minor GCs and allocations, and have been added as benchmarks
  to Sandmark.

* [ocaml-bench/sandmark#155](https://github.com/ocaml-bench/sandmark/pull/155)
  Sequential version of Evolutionary Algorithm

  The sequential version of algorithms are used for comparison with
  their respective parallel implementations. A sequential
  implementation for the `Evolutionary Algorithm` has now been included
  in Sandmark.

* [ocaml-bench/sandmark#157](https://github.com/ocaml-bench/sandmark/pull/157)
  Minilight Multicore: Port to Task API and DLS for Random States

  The Minilight benchmark has been ported to use the Task API along
  with the use of Domain Local Storage for the Random States. The
  speedup is shown in the following illustration:

  ![PR 157 Image](images/OCaml-Sandmark-PR-157-Speedup.png)

* [ocaml-bench/sandmark#164](https://github.com/ocaml-bench/sandmark/pull/164)
  Tweaks to multicore-numerical/game_of_life

  The `board_size` for the Game of Life numerical benchmark is now
  configurable, and can be supplied as an argument.

#### Bug Fixes

* [ocaml-bench/sandmark#156](https://github.com/ocaml-bench/sandmark/pull/156)
  Fix calculation of Nbody Multicore

  Minor fixes in the calculation of interactions of the bodies in the
  `Nbody` implementation, and use of local ref vars to reduce writes and
  cache traffic.

* [ocaml-bench/sandmark#158](https://github.com/ocaml-bench/sandmark/pull/158)
  Fix key error for Grammatrix for Jupyter notebook

  The `Key Error` issue with `notebooks/parallel/parallel.ipynb` is
  now resolved by passing a value to params in the
  `multicore_parallel_run_config.json` file.

#### Sundries

* [ocaml-bench/sandmark#154](https://github.com/ocaml-bench/sandmark/pull/154)
  Revert PARAMWRAPPER changes

  Undo the `PARAMWRAPPER` configuration for parallel benchmark runs in
  the Makefile, as they are not required for sequential execution.

* [ocaml-bench/sandmark#160](https://github.com/ocaml-bench/sandmark/pull/160)
  Specify prefix,libdir for alt-ergo sandbox builds

  The `alt-ergo` library and parser require the `prefix` and `libdir`
  to be specified with `configure` in order to build in a sandbox
  environment. The initial discussion is available at
  [OCamlPro/alt-ergo#351](https://github.com/OCamlPro/alt-ergo/issues/351).

* [ocaml-bench/sandmark#162](https://github.com/ocaml-bench/sandmark/pull/162)
  Avoid installing packages which are unused for Multicore runs

  The `PACKAGES` variable in the Makefile has been simplified to
  include only those dependency packages that are required to build
  Sandmark.

* [ocaml-bench/sandmark#163](https://github.com/ocaml-bench/sandmark/pull/163)
  Update to domainslib 0.2.2 and use default chunk_size

  The `domainslib` dependency package has been updated to use the
  0.2.2 released version, and `chunk_size` for various benchmarks uses
  `num_tasks/num_domains` as default.

## OCaml

### Ongoing

* [ocaml/ocaml#9756](https://github.com/ocaml/ocaml/pull/9756)
  Garbage collectors colour change

  The PR is needed for use with the Multicore OCaml major collector by
  removing the need of gray colour in the garbage collector (GC)
  colour scheme.

### Completed

* [ocaml/ocaml#9722](https://github.com/ocaml/ocaml/pull/9722)
  EINTR-based signals, again

  The patch provides a new implementation to solve a collection of
  locking, signal-handling and error checking issues.

Our thanks to all the OCaml developers and users in the community for their support and contribution to the project. Stay safe!

## Acronyms

* API: Application Programming Interface
* DLS: Domain Local Storage
* GC: Garbage Collector
* OPAM: OCaml Package Manager
* LU: Lower Upper (decomposition)
* PR: Pull Request
