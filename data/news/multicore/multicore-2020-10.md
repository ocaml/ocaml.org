---
title: OCaml Multicore - October 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-10-01"
tags: [multicore]
---

Welcome to the October 2020 multicore OCaml report, compiled by @shakthimaan, @kayceesrk and of course myself. The [previous monthly (https://discuss.ocaml.org/tag/multicore-monthly) updates are also available for your perusal.

**OCaml 4.12.0-dev:** The upstream OCaml tree has been branched for the 4.12 release, and the [OCaml readiness team](https://github.com/ocaml/opam-repository/issues/17530) is busy stabilising it with the ecosystem. The 4.12.0 development stream has significant progress towards multicore support, especially with the runtime handling of naked pointers. The release will ship with a dynamic checker for naked pointers that you can use to verify that your own codebase is clean of them, as this will be a prerequisite for OCaml 5.0 and multicore compatibility. This is activated via the `--enable-naked-pointers-checker` configure option.

**Convergence with upstream and multicore trees:** The multicore OCaml trees have seen significant robustness improvements as we've converged our trees with upstream OCaml (possible now that the upstream architectural changes are synched with the requirements of multicore). In particular, the handling of global C roots is much better in multicore now as it uses the upstream OCaml scheme, and the GC colour scheme also exactly matches upstream OCaml's.  This means that community libraries from `opam` work increasingly well when built with multicore OCaml (using the `no-effects-syntax` branch).

**Features:** Multicore OCaml is also using domain local allocation buffers now to simplify its internals.  We are also now working on benchmarking the IO subsystem, and support for CPU parallelism for the Lwt concurrency library has been added, as well as refreshing the new Asynchronous Effect-based IO ([aeio](https://github.com/kayceesrk/ocaml-aeio)) with Multicore OCaml, Lwt, and httpaf in an [http-effects](https://github.com/sadiqj/http-effects) library.

**Benchmarking:** The Sandmark benchmarking test suite has additional configuration options, and there are new proposals in that project to leverage as much of the OCaml tools and ecosystem as much as possible.

As with previous updates, the Multicore OCaml ongoing, and completed tasks are listed first, which are followed by improvements to the Sandmark benchmarking test suite. Finally, the upstream OCaml related work is mentioned for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#422](https://github.com/ocaml-multicore/ocaml-multicore/pull/422)
  Simplify minor heaps configuration logic and masking
  
  The PR is a step towards using Domain local allocation buffers. A
  `Minor_heap_max` size is used to reserve the minor heaps area, and
  `Is_young` for relying on a boundary check. The `Minor_heap_max` can
  be overridden using OCAMLRUNPARAM environment variable.

* [ocaml-multicore/ocaml-multicore#426](https://github.com/ocaml-multicore/ocaml-multicore/pull/426)
  Replace global roots implementation

  An effort to replace the existing global roots implementation to be
  in line with OCaml's `globroots`. The objective is to also have a
  per-domain skip list, and a global orphans when a domain is
  terminated.

* [ocaml-multicore/ocaml-multiore#427](https://github.com/ocaml-multicore/ocaml-multicore/pull/427)
  Garbage Collector colours change backport

  The [Garbage Collector colour scheme
  changes](https://github.com/ocaml/ocaml/pull/9756) in the major
  collector have now been backported to Multicore OCaml. The
  `mark_entry` does not include `end`, `mark_stack_push` resembles
  closer to trunk, and `caml_shrink_mark_stack` has been adapted from
  trunk.

* [ocaml-multicore/ocaml-multicore#429](https://github.com/ocaml-multicore/ocaml-multicore/pull/429)
  Fix a STW interrupt race

  The STW interrupt race in
  `caml_try_run_on_all_domains_with_spin_work` is fixed in this PR,
  where the `enter_spin_callback` and `enter_spin_data` fields of
  `stw_request` are initialized after we interrupt other domains.

### Completed

#### Systhreads support

* [ocaml-multicore/ocaml-multicore#381](https://github.com/ocaml-multicore/ocaml-multicore/pull/381)
  Reimplementing Systhreads with pthreads (Domain execution contexts)

  The re-implementation of Systhreads with pthreads has been completed
  for Multicore OCaml. The Domain Execution Context (DEC) is
  introduced which allows multiple threads to run atop a domain.

* [ocaml-multicore/ocaml-multicore#410](https://github.com/ocaml-multicore/ocaml-multicore/pull/410)
  systhreads: `caml_c_thread_register` and `caml_c_thread_unregister`
  
  The `caml_c_thread_register` and `caml_c_thread_unregister`
  functions have been reimported to systhreads. In Multicore OCaml,
  threads created by C code will be registered to domain 0 threads
  chaining.

#### Domain Local Storage

* [ocaml-multicore/ocaml-multicore#404](https://github.com/ocaml-multicore/ocaml-multicore/pull/404)
  Domain.DLS.new_key takes an initialiser
  
  The `Domain.DLS.new_key` now accepts an initialiser argument to
  assign an associated value to a key, if not initialised
  already. Also, `Domain.DLS.get` no longer returns an option value.

* [ocaml-multicore/ocaml-multicore#405](https://github.com/ocaml-multicore/ocaml-multicore/pull/405)
  Rework Domain.DLS.get search function such that it no longer allocates
  
  The `Domain.DLS.get` has been updated to remove any memory
  allocation, if the key already exists in the domain local
  storage. The PR also changes the `search` function to accept all
  inputs as variables, instead of a closure from the environment.

#### Lwt

* [ocaml-multicore/multicore-opam#33](https://github.com/ocaml-multicore/multicore-opam/pull/33)
  Add lwt.5.3.0+multicore
  
  The Lwt.5.3.0 concurrency library has been added to support CPU
  parallelism with Multicore OCaml. A [blog
  post](https://sudha247.github.io/2020/10/01/lwt-multicore/)
  introducing its installation and usage has been written by Sudha
  Parimala.

* The [Asynchronous Effect-based IO](https://github.com/kayceesrk/ocaml-aeio) builds with a recent
  Lwt, and the HTTP effects demo has been updated to work with
  Multicore OCaml, Lwt, and httpaf. The demo source code is available
  at the [http-effects](https://github.com/sadiqj/http-effects) repo.

#### Sundries

* [ocaml-multicore/ocaml-multicore#406](https://github.com/ocaml-multicore/ocaml-multicore/pull/406)
  Remove ephemeron usage of RPC
  
  The inter-domain mechanism is not required with the stop-the-world
  minor GC, and hence the same has been removed in the ephemeron
  implementation. The PR also does clean up and simplifies the
  ephemeron data structure and code.

* [ocaml-multicore/ocaml-multicore#411](https://github.com/ocaml-multicore/ocaml-multicore/pull/411)
  Fix typo for presume and presume_arg in `internal_variable_names`
  
  A minor typo bug fix to rename `Presume` and `Presume_arg` in
  `internal_variables_names.ml`.

* [ocaml-multicore/ocaml-multicore#414](https://github.com/ocaml-multicore/ocaml-multicore/pull/414)
  Fix up `Ppoll` `semantics_of_primitives` entry
  
  The `semantics_of_primitives` entry for `Ppoll` has been fixed which
  was causing flambda builds to remove poll points.

* [ocaml-multicore/ocaml-multicore#416](https://github.com/ocaml-multicore/ocaml-multicore/pull/416)
  Fix callback effect bug

  The PR fixes a bug when the C-to-OCaml callback prevents effects
  crossing a C callback boundary. The stack parent is cleared before a
  callback, and restored afterwards. It also makes the stack parent a
  local root, so that the GC can see it inside the callback.

## Benchmarking

### Ongoing

#### Configuration

* [ocaml-bench/ocaml-bench-scripts#12](https://github.com/ocaml-bench/ocaml_bench_scripts/pull/12)
  Add support for parallel multibench targets and JSON input
  
  The `RUN_CONFIG_JSON` and `BUILD_BENCH_TARGET` variables are now
  added and passed during run-time for the execution of parallel
  benchmarks. Default values are specified so that the serial
  benchmarks can still run without explicitly requiring the same.

* [ocaml-bench/sandmark#180](https://github.com/ocaml-bench/sandmark/issues/180)
  Notebook Refactoring and User changes
  
  A refactoring effort is underway to make the parallel benchmark
  interactive. The user accounts on The Littlest JupyterHub
  installation have direct access to the benchmark results produced
  from `ocaml-bench-scripts` on the system.

* [ocaml-bench/sandmark#189](https://github.com/ocaml-bench/sandmark/pull/189)
  Add environment support for wrapper in JSON configuration file
  
  The OCAMLRUNPARAM is now passed as an environment variable to the
  benchmarks during runtime, so that, different parameter values can
  be used to obtain multiple results for comparison. The use case and
  the discussion are available at [Running benchmarks with varying
  OCAMLRUNPARAM](https://github.com/ocaml-bench/sandmark/issues/184)
  issue. The environment variables can be specified in the
  `run_config.json` file, as shown below:
  
  ```json
   {
      "name": "orun_2M",
      "environment": "OCAMLRUNPARAM='s=2M'",
      "command": "orun -o %{output} -- taskset --cpu-list 5 %{command}"
    }
  ```

#### Proposals

* [ocaml-bench/sandmark#159](https://github.com/ocaml-bench/sandmark/issues/159)
  Implement a better way to describe tasklet cpulist

  The discussion to implement a better way to obtain the taskset list
  of cores for a benchmark run is still in progress. This is required
  to be able to specify hyper-threaded cores, NUMA zones, and the
  specific cores to use for the parallel benchmarks.

* [ocaml-bench/sandmark#179](https://github.com/ocaml-bench/sandmark/issues/179)
  [RFC] Classifying benchmarks based on running time
  
  A proposal to categorize the benchmarks based on their running time
  has been provided. The following classification types have been
  suggested:
  * `lt_1s`: Benchmarks that run for less than 1 second.
  * `lt_10s`: Benchmarks that run for at least 1 second, but, less than 10 seconds.
  * `10s_100s`: Benchmarks that run for at least 10 seconds, but, less than 100 seconds.
  * `gt_100s`: Benchmarks that run for at least 100 seconds.
  
  The PR for the same is available at [Classification of
  benchmarks](https://github.com/ocaml-bench/sandmark/pull/188).

* We are exploring the use of `opam-compiler` switch environment to
  build the Sandmark benchmark test suite. The merge of [systhreads
  compatibility
  support](https://github.com/ocaml-multicore/ocaml-multicore/pull/407)
  now enables us to install dune natively inside the switch
  environment, along with the other benchmarks. With this approach, we
  hope to modularize our benchmarking test suite, and converge to
  fully using the OCaml tools and ecosystem.

#### Sundries

* [ocaml-bench/sandmark#181](https://github.com/ocaml-bench/sandmark/pull/181)
  Lock-free map bench

  An implementation of a concurrent hash-array mapped trie that is
  lock-free, and is based on Prokopec, A. et. al. (2011). This
  cache-aware implementation benchmark is currently under review.

* [ocaml-bench/sandmark#183](https://github.com/ocaml-bench/sandmark/pull/183)
  Use crout_decomposition name for numerical analysis benchmark
  
  A couple of LU decomposition benchmarks exist in the Sandmark
  repository, and this PR renames the
  `numerical-analysis/lu_decomposition.ml` benchmark to
  `crout_decomposition.ml`. This is to address [Rename
  lu_decomposition benchmark in
  numerical-analysis](https://github.com/ocaml-bench/sandmark/issues/182)
  any naming confusion between the two benchmarks, as their
  implementations are different.

### Completed

* [ocaml-bench/sandmark#177](https://github.com/ocaml-bench/sandmark/pull/177)
  Display raw baseline numbers in normalized graphs

  The raw baseline numbers are now included in the normalized graphs
  in the sequential notebook output. The graph for `maxrsskb`, for
  example, is shown below:
  
![PR 177 Image |690x258](https://discuss.ocaml.org/uploads/short-url/1gub2PiCejOQBoMqPvuhDoxHpJo.png) 

* [ocaml-bench/sandmark#178](https://github.com/ocaml-bench/sandmark/pull/178)
  Change to new Domain.DLS API with Initializer
  
  The `multicore-minilight` and `multicore-numerical` benchmarks have
  now been updated to use the new Domain.DLS API with initializer.

* [ocaml-bench/sandmark#185](https://github.com/ocaml-bench/sandmark/pull/185)
  Clean up existing effect benchmarks
 
  The PR ensures that the code compiles without any warnings, and adds
  a `multicore_effects_run_config.json` configuration file, and a
  `run_all_effect.sh` script to execute the same.

* [ocaml-bench/sandmark#186](https://github.com/ocaml-bench/sandmark/pull/186)
  Very simple effect microbenchmarks to cover code paths
  
  A set of four microbenchmarks to test the throughput of our effects
  system have now been added to the Sandmark test suite. These include
  `effect_throughput_clone`, `effect_throughput_val`,
  `effect_throughput_perform`, and `effect_throughput_perform_drop`.

* [ocaml-bench/sandmark#187](https://github.com/ocaml-bench/sandmark/pull/187)
  Implementation of 'recursion' benchmarks for effects
  
  A collection of recursion benchmarks to measure the overhead of
  effects are now included to Sandmark. This is inspired by the
  (Manticore
  benchmarks)[https://github.com/ManticoreProject/benchmark/].

## OCaml

### Ongoing

* [ocaml/ocaml#9876](https://github.com/ocaml/ocaml/pull/9876)
  Do not cache young_limit in a processor register

  The PR removes the caching of `young_limit` in a register for ARM64,
  PowerPC and RISC-V ports. The Sandmark benchmarks are presently
  being tested on the respective hardware.

* [ocaml/ocaml#9934](https://github.com/ocaml/ocaml/pull/9934)
  Prefetching optimisations for sweeping
  
  The Sandmark benchmarking tests were performed for analysing a
  couple of patches that optimise `sweep_slice`, and for the use of
  prefetching. The objective is to reduce cache misses during GC.

### Completed

* [ocaml/ocaml#9947](https://github.com/ocaml/ocaml/pull/9947)
  Add a naked pointers dynamic checker
  
  The check for "naked pointers" (dangerous out-of-heap pointers) is
  now done in run-time, and tests for the three modes: naked pointers,
  naked pointers and dynamic checker, and no naked pointers have been
  added in the PR.

* [ocaml/ocaml#9951](https://github.com/ocaml/ocaml/pull/9951/)
  Ensure that the mark stack push optimisation handles naked pointers
  
  The PR adds a precise check on whether to push an object into the
  mark stack, to handle naked pointers.

We would like to thank all the OCaml users and developers in the community for their continued support, reviews and contribution to the project.

## Acronyms

* AEIO: Asynchronous Effect-based IO
* API: Application Programming Interface
* ARM: Advanced RISC Machine
* CPU: Central Processing Unit
* DEC: Domain Execution Context
* DLS: Domain Local Storage
* GC: Garbage Collector
* HTTP: Hypertext Transfer Protocol
* JSON: JavaScript Object Notation
* NUMA: Non-Uniform Memory Access
* OPAM: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* RISC-V: Reduced Instruction Set Computing - V
* RPC: Remote Procedure Call
* STW: Stop-The-World
