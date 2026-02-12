---
title: OCaml Multicore - May 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-05-01"
tags: [multicore]
---

Welcome to the May 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This month's update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by @avsm, @ctk21, @kayceesrk and @shakthimaan.

Firstly, all of our upstream activity on the OCaml compiler is now reported as part of the shiny new [compiler development newsletter #2](https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-2-may-2021/7965) that @gasche has started. This represents a small but important shift -- domains-only multicore is firmly locked in on the upstream roadmap for OCaml 5.0 and the whole OCaml compiler team has been helping and contributing to it, with the [GC safe points](https://github.com/ocaml/ocaml/pull/10039) feature being one of the last major multicore-prerequisites (and due to be in OCaml 4.13 soon).

This multicore newsletter will now focus on getting our ecosystem ready for domains-only multicore in OCaml 5.0, and on how the (not-yet-official) effect system and multicore IO stack is progressing.  It's a long one this month, so settle in with your favourite beverage and let's begin :-)

## OCaml Multicore: 4.12.0+domains

The multicore compiler now supports CTF runtime traces of its garbage collector and there are [tools to display chrome tracing visualisations](https://github.com/ocaml-multicore/eventlog-tools/tree/multicore_wip) of the garbage collector events. A number of performance improvements (see speedup graphs later on) that highlight some ways to make best use of multicore were made to the existing benchmarks in Sandmark.  There has also been work on scaling up to 128 cores/domains for task-based parallelism in domainslib using [work stealing deques](https://github.com/ocaml-multicore/domainslib/pull/29), bringing us closer to Cilk-style task-parallel performance.

As important as new features are what we have decided _not_ to do. We've been working on and evaluating Domain Local Allocation Buffers (DLABs) for some time, with the intention of reducing the cost of minor GCs. We've found that the resulting performance didn't match our expectations (_vs_ the complexity of the change), and so we've decided not to proceed with this for OCaml 5.0.  You can find the [DLAB summary](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers-Addendum) page summarises our experiences. We'll come back to this post-OCaml 5.0 when there are fewer moving parts.

## Ecosystem changes to prepare for 5.0.0 domains-only

As we are preparing 5.0 branches with the multicore branches over the coming months, we are stepping up preparations to ensure the OCaml ecosystem is ready.

### Making the multicore compilers available by default in opam-repo

Over the next few week, we will be merging the multicore 4.12.0+domains and associated packages from their opam remote over in [ocaml-multicore/multicore-opam](https://github.com/ocaml-multicore/multicore-opam) into the mainline opam-repository. This is to make it more convenient to use the variant compilers to start testing your own packages with `Domain`s.

As part of this change, there are two new base packages that will be available in opam-repository:

- `base-domains`: This package indicates that the current compiler has the `Domain` module.
- `base-effects`: This package indicates the current compiler has the experimental effect system.

By adding a dependency on these packages, the only valid solutions will be `4.12.0+domains` (until OCaml 5.0 which will have this module) or `4.12.0+effects`.

The goal of this is to let community packages more easily release versions of their code using Domains-only parallelism ahead of OCaml 5.0, so that we can start migration and thread-safety early.  We do not encourage anyone to take a dependency on base-effects currently, as it is very much a moving target.

This opam-repository change isn't in yet, but I'll comment on this post when it is merged.

### Adapting the Stdlib for thread-safety

One of the first things we have to do before porting third-party libraries is to get the Stdlib ready for thread-safety. This isn't quite as simple as it might appear at first glance: if we adopt the naïve approach of simply putting a mutex around every bit of global state, our sequential performance will slow down. Therefore we are performing a more fine-grained analysis and fixes, which can be seen [on the multicore stdlib page](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml). 

For anyone wishing to contribute: hunt through the Stdlib for global state, and categorise it appropriately, and then create a test case exercising that module with multiple Domains running, and submit a PR to [ocaml-multicore](https://github.com/ocaml-multicore/ocaml-multicore).  In general, if you see any build failures or runtime failures now, we'd really appreciate an issue being filed there too. You can see some good examples of such issues [here](https://github.com/ocaml-multicore/ocaml-multicore/issues/574) (for mirage-crypto) and [here](https://github.com/ocaml-multicore/ocaml-multicore/issues/568) (for Coqt).

### Porting third-party libraries to Domains

As I mentioned last month, we put a call out for libraries and maintainers who wanted to port their code over. We're starting with the following libraries and applications this month:

- **Lwt**: the famous lightweight-threads library now has a PR to add [Lwt_domains](https://github.com/ocsigen/lwt/pull/860). This is the first simple(ish) step to using multicore cores with Lwt: it lets you run a pure (non-Lwt) function in another Domain via `detach : ('a -> 'b) -> 'a -> 'b Lwt.t`.

- **Mirage-Crypto**: the next library we are adapting is the cryptography library, since it is also low-hanging fruit that should be easy to parallelise (since crypto functions do not have much global state). The port is still ongoing, as there are some minor build failures and also Stdlib functions in Format that aren't yet thread-safe that are [causing failures](https://github.com/ocaml-multicore/ocaml-multicore/issues/563).

- **Tezos-Node**: the bigger application we are applying some of the previous dependencies too is Tezos-Node, which makes use of the dependency chain here via Lwt, mirage-crypto, Irmin, Cohttp and many other libraries. We've got this [compiling under 4.12.0+domains](https://gitlab.com/tezos/tezos/-/merge_requests/2671) now and mostly passing the test suite, but will only report significant results once the dependencies and Stdlib are passing.

- **Owl**: OCaml's favourite machine learning library works surprisingly well out-of-the-box with 4.12.0+domains. An experiment for a significant machine-learning codebase written using it saw about a 2-4x speedup before some false-sharing bottlenecks kicked in. This is pretty good going given that we made no changes to the codebase itself, but stay tuned for more improvements over the coming months as we analyse the bottleneck.

This is hopefully a signal to all of you to start "having a go" with 4.12.0+domains on your own applications, and particularly with respect to seeing how wrapping it in Domains works out and identifying global state. You can read our handy [tutorial on parallel programming with Multicore OCaml](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml). 

We are developing some tools to help find global state, but we're going to all need to work together to identify some of these cases and begin migration.  Crucially, we need some diversity in our dependency chains -- if you have interesting applications using (e.g.) Async or the vanilla `Thread` module and have some cycles to work with us, please get in touch with me or @kayceesrk .

## 4.12.0+effects

The effects-based [eio library](https://github.com/ocaml-multicore/eio) is coming together nicely, and the interface and design rationales are all up-to-date in the README of the repository.  The primary IO backend is [ocaml-uring](https://github.com/ocaml-multicore/ocaml-uring), which we are preparing for a separate release to opam-repository now as it also works fine on the sequential runtime for Linux (as long as you have a fairly recent kernel. Otherwise the kernel crashes).  We also have a [Grand Central Dispatch effect backend](https://github.com/ocaml-multicore/eio/pull/26) to give us a totally different execution model to exercise our effect handler abstractions.

While we won't publish the performance numbers for the effect-based IO this month, you can get a sense of the sorts of tests we are running by looking at the [retro-httpaf-bench](https://github.com/ocaml-multicore/retro-httpaf-bench) repository, which now has various permutations of effects-based, uring-based and select-based webservers. We've submitted a talk to the upcoming OCaml Workshop later this summer, which, if accepted, will give you a deepdive into our effect-based IO.

As always, we begin with the Multicore OCaml ongoing and completed tasks.  The ecosystem improvements are then listed followed by the updates to the Sandmark benchmarking project. Finally, the upstream OCaml work is mentioned for your reference.  For those of you that have read this far and can think of nothing more fun than hacking on multicore programming runtimes, we are hiring in the UK, France and India -- please find the job postings at the end!

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#552](https://github.com/ocaml-multicore/ocaml-multicore/pull/552)
  Add a force_instrumented_runtime option to configure

  A new `--enable-force-instrumented-runtime` option is introduced to
  facilitate use of the instrumented runtime on linker invocations to
  obtain event logs.

* [ocaml-multicore/ocaml-multicore#553](https://github.com/ocaml-multicore/ocaml-multicore/issues/553)
  Testsuite failures with flambda enabled

  A list of tests are failing on `b23a416` with flambda enabled, and
  they need to be investigated further.

* [ocaml-multicore/ocaml-multicore#555](https://github.com/ocaml-multicore/ocaml-multicore/pull/555)
  runtime: CAML_TRACE_VERSION is now set to a Multicore specific value

  Define a `CAML_TRACE_VERSION` to distinguish between Multicore OCaml
  and trunk for the runtime.

* [ocaml-multicore/ocaml-multicore#558](https://github.com/ocaml-multicore/ocaml-multicore/pull/558)
  Refactor Domain.{spawn/join} to use no critical sections

  The PR removes the use of `Domain.wait` and critical sections in
  `Domain.{spawn/join}`.

* [ocaml-multicore/ocaml-multicore#559](https://github.com/ocaml-multicore/ocaml-multicore/pull/559)
  Improve the Multicore GC Stats

  A draft PR to include more Multicore GC statistics when using
  `OCAMLRUNPARAM=v=0x400`.

### Completed

* [ocaml-multicore/ocaml-multicore#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508)
  Domain Local Allocation Buffers

  The Domain Local Allocation Buffer implementation for OCaml Multicore has been dropped for now. A discussion is on the PR itself and there is a wiki
  page [here](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers-Addendum).

* [ocaml-multicore/ocaml-multicore#527](https://github.com/ocaml-multicore/ocaml-multicore/pull/527)
  Port eventlog to CTF

  The porting of the `eventlog` implementation to the Common Trace
  Format is now complete.

  For an introduction to producing Chrome trace visualizations of the
  runtime events see [eventlog-tools](https://github.com/ocaml-multicore/eventlog-tools/tree/multicore_wip). This postprocessing tool turns the CTF
  trace into the Chrome tracing format that allows interactive visualizations
  like this:

![OCaml-Multicore-PR-527-Illustration|690x475](https://discuss.ocaml.org/uploads/short-url/hkZ1MA5sA6IdEwV9nIBm57YdmvZ.jpeg)


* [ocaml-multicore/ocaml-multicore#543](https://github.com/ocaml-multicore/ocaml-multicore/pull/543)
  Parallel version of weaklifetime test

  A parallel version of the `weaklifetime.ml` test is now added to the
  test suite.

* [ocaml-multicore/ocaml-multicore#546](https://github.com/ocaml-multicore/ocaml-multicore/pull/546)
  Coverage of domain life-cycle in domain_dls and ephetest_par tests

  Additional tests to increase test coverage for domain life-cycle for
  `domain_dls.ml` and `ephetest_par.ml`.

* [ocaml-multicore/ocaml-multicore$#550](https://github.com/ocaml-multicore/ocaml-multicore/pull/550)
  Lazy effects test

  Inclusion of a test to address effects with Lazy computations for a
  number of different use cases.

* [ocaml-multicore/ocaml-multicore#557](https://github.com/ocaml-multicore/ocaml-multicore/pull/557)
  Remove unused domain functions

  A clean-up to remove unused functions in `domain.c` and `domain.h`.

## Ecosystem

### Ongoing

* [ocaml-multicore/eventlog-tools#2](https://github.com/ocaml-multicore/eventlog-tools/pull/2)
  Add a pausetimes tool

  The `eventlog_pausetimes` tool takes a directory of eventlog files
  and computes the mean, max pause times, as well as the distribution
  up to the 99.9th percentiles. For example:

  ```json
  ocaml-eventlog-pausetimes /home/engil/dev/ocaml-multicore/trace3/caml-426094-* name
  {
    "name": "name",
    "mean_latency": 718617,
    "max_latency": 33839379,
    "distr_latency": [191,250,707,16886,55829,105386,249272,552640,1325621,13312993,26227671]
  }
  ```

* [domainslib#29](https://github.com/ocaml-multicore/domainslib/pull/29)
  Task stealing with CL deques

  This ongoing work to use task-stealing Chase Lev deques for scheduling
  tasks across domains is looking very promising. Particularly for machines
  with 128 cores.

* [ocaml-multicore/retro-httpaf-bench#10](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/10)
  Add Eio benchmark

  The addition of an Eio benchmark for retro-httpaf-bench. This is a
  work-in-progress.

* [ocaml-multicore/eio#26](https://github.com/ocaml-multicore/eio/pull/26)
  Grand Central Dispatch Backend

  An early draft PR that implements the Grand Central Dispatch (GCD)
  backend for Eio.

* [ocsigen/lwt#860](https://github.com/ocsigen/lwt/pull/860)
  Lwt_domain: An interfacet to Multicore parallelism

  An on-going effort to introduce `Lwt_domain` for performing
  computations to CPU cores using Multicore OCaml's Domains.

### Completed

#### retro-httpaf-bench

The `retro-httpaf-bench` repository contains scripts for running HTTP
server benchmarks.

* [ocaml-multicore/retro-httpaf-bench#6](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/6)
  Move OCaml to 4.12

  The build scripts have been updated to use 4.12.0.

* [ocaml-multicore/retro-httpaf-bench#8](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/8)
  Adds a Rust benchmark using hyper

  The inclusion of the Hyper benchmark limited to a single core to
  match the other existing benchmarks.

* [ocaml-multicore/retro-httpaf-bench#9](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/9)
  Release builds for dune, stretch request volumes, rust fixes and remove mimalloc

  The Dockerfile, README, build_benchmarks.sh and run_benchmarks.sh
  files have been updated.

* [ocaml-multicore/retro-httpaf-bench#15](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/5)
  Make benchmark more realistic

  The PR enhances the implementation to correctly simulate a
  hypothetical database request, and the effects code has been updated
  accordingly.

#### eio

The `eio` library provides an effects-based parallel IO stack for
Multicore OCaml.

* [ocaml-multicore/eio#18](https://github.com/ocaml-multicore/eio/pull/18)
  Add fibreslib library

  The `promise` library has been renamed to `fibreslib` to avoid
  naming conflict with the existing package in opam, and the API
  (waiters and effects) has been split into its own respective
  modules.

* [ocaml-multicore/eio#19](https://github.com/ocaml-multicore/eio/pull/19)
  Update to latest ocaml-uring

  The code and configuration files have been updated to use the latest
  `ocaml-uring`.

* [ocaml-multicore/eio#20](https://github.com/ocaml-multicore/eio/pull/20)
  Add Fibreslib.Semaphore

  Implemented the `Fibreslib.Semaphone` module that is useful for
  rate-limiting, and based on OCaml's `Semaphore.Counting`.

* [ocaml-multicore/eio#21](https://github.com/ocaml-multicore/eio/pull/21)
  Add high-level Eio API

  A new Eio library with interfaces for sources and sinks. The README
  documentation has been updated with motivation and usage.

* [ocaml-multicore/eio#22](https://github.com/ocaml-multicore/eio/pull/22)
  Add switches for structured concurrency

  Implementation of structured concurrency with documentation examples
  for tracing and testing with mocks.

* [ocaml-multicore/eio#23](https://github.com/ocaml-multicore/eio/pull/23)
  Rename repository to eio

  The Effects based parallel IO for OCaml repository has now been
  renamed from `eioio` to `eio`.

* [ocaml-multicore/eio#24](https://github.com/ocaml-multicore/eio/pull/24)
  Rename lib_eioio to lib_eunix

  The names have been updated to match the dune file.

* [ocaml-multicore/eio#25](https://github.com/ocaml-multicore/eio/pull/25)
  Detect deadlocks

  An exception is now raised to detect deadlocks if the scheduler
  finishes while the main thread continues to run.

* [ocaml-multicore/eio#27](https://github.com/ocaml-multicore/eio/pull/27)
  Convert expect tests to MDX

  The expected tests have been updated to use the MDX format, and this
  avoids the need for ppx libraries.

* [ocaml-multicore/eio#28](https://github.com/ocaml-multicore/eio/pull/28)
  Use splice to copy if possible

  The effect Splice has been implemented along with the update to
  ocaml-uring, and necessary documentation.

* [ocaml-multicore/eio#29](https://github.com/ocaml-multicore/eio/pull/29)
  Improve exception handling in switches

  Additional exception checks to handle when multiple threads fail,
  and for `Switch.check` and `Fibre.fork_ignore`.

* [ocaml-multicore/eio#30](https://github.com/ocaml-multicore/eio/pull/30)
  Add eio_main library to select backend automatically

  Use `eio_main` to select the appropriate backend (`eunix`, for
  example) based on the platform.

* [ocaml-multicore/eio#31](https://github.com/ocaml-multicore/eio/pull/31)
  Add Eio.Flow API

  Implemented a Flow module that allows combinations such as
  bidirectional flows and closable flows.

* [ocaml-multicore/eio#32](https://github.com/ocaml-multicore/eio/pull/32)
  Initial support for networks

  Eio provides a high-level API for networking, and the `Network`
  module has been added.

* [ocaml-multicore/eio#33](https://github.com/ocaml-multicore/eio/pull/33)
  Add some design rationale notes to the README

  The README has been updated with design notes, and reference to
  further reading on the principles of Object-capability model.

* [ocaml-multicore/eio#34](https://github.com/ocaml-multicore/eio/pull/34)
  Add shutdown, allow closing listening sockets, add cstruct_source

  Added cstruct_source, `shutdown` method along with source, sink and
  file descriptor types.

* [ocaml-multicore/eio#35](https://github.com/ocaml-multicore/eio/pull/35)
  Add Switch.on_release to auto-close FDs

  We can now attach resources such as file descriptors to switches,
  and these are freed when the the switch is finished.

#### Sundries

* [ocaml-multicore/domainslib#23](https://github.com/ocaml-multicore/domainslib/issues/23)
  Running tests: moving to `dune runtest` from manual commands in
  `run_test` target

  The `dune runtest` command is now used to execute the tests.

* [ocaml-multicore/domainslib#24](https://github.com/ocaml-multicore/domainslib/pull/24)
  Move to Mutex & Condition from Domain.Sync.{notify/wait}

  The channel implementation using `Mutex` and `Condition` is now
  complete. The performance results are shown in the following graph:

![Domainslib-PR-24|465x500](https://discuss.ocaml.org/uploads/short-url/rRTArEtLWG8BMCq9uhtokOX2ZfD.png)

* [ocaml-multicore/multicore-opam#53](https://github.com/ocaml-multicore/multicore-opam/pull/53)
  Add base-domains and base-effects packages

  The `base-domains` and `base-effects` opam files have now been added
  to multicore-opam.

* [ocaml-multicore/multicore-opam#54](https://github.com/ocaml-multicore/multicore-opam/pull/54)
  Shift all multicore packages to unique versions and base-domains dependencies

  The naming convention is to now use `base-effects` and
  `base-domains` everywhere.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#230](https://github.com/ocaml-bench/sandmark/pull/230)
  Build for 4.13.0+trunk with dune.2.8.1

  A work-in-progress to upgrade Sandmark to use dune.2.8.1 to build
  4.13.0+trunk and generate the benchmarks. You can test the same
  using:

  ```
  TAG='"macro_bench"' make run_config_filtered.json
  RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.13.0+trunk.bench
  ```

### Completed

#### Sandmark

##### Performance

* [ocaml-bench/sandmark#221](https://github.com/ocaml-bench/sandmark/pull/221)
  Fix up decompress iterations of work

  The use of `parallel_for`, simplification of `data_to_compress` to
  use `String.init`, and fix to correctly count the amount of work
  configured and done produces the following speed improvements:

![PR-221-Time |690x184](https://discuss.ocaml.org/uploads/short-url/avtHyFpuulDQcFH70cY97b5HVDK.png)
![PR-221-Speedup |690x184](https://discuss.ocaml.org/uploads/short-url/awpN69M44aG0mjB524DKoiaNWnk.png)

* [ocaml-bench/sandmark#223](https://github.com/ocaml-bench/sandmark/pull/223)
  A better floyd warshall

  An improvement to the Floyd Warshall implementation that fixes the
  random seed so that it is repeatable, and improves the pattern
  matching.

![Sandmark-PR-223-Time|690x184](https://discuss.ocaml.org/uploads/short-url/aDnAjB3JQ4s27CnpOY1srPNKi4P.png)
![Sandmark-PR-223-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/rbNANIAeqUwZIHi7DTmrRRS1IUo.png)
![Sandmark-PR-223-Minor-Collections|690x185](https://discuss.ocaml.org/uploads/short-url/t4F2AeZDvTIQo0NRuBBHAEJdTAR.png)

* [ocaml-bench/sandmark#224](https://github.com/ocaml-bench/sandmark/pull/224)
  Some improvements for matrix multiplication

  The `matrix_multiplication` and `matrix_multiplication_multicore`
  code have been updated for easier maintenance, and results are
  written only after summing the values.

![Sandmark-PR-224-Time|690x184](https://discuss.ocaml.org/uploads/short-url/oysje2XiEEF6MfC7k9iAotAYiXY.png)
![Sandmark-PR-224-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/bf8cqFB61vMuwkI2L0QnlB9xKvD.png)

* [ocaml-bench/sandmark#225](https://github.com/ocaml-bench/sandmark/pull/225)
  Better Multicore EA Benchmark

  The Evolutionary Algorithm now inserts a poll point into `fittest`
  to improve the benchmark results.

![Sandmark-PR-225-Time|690x184](https://discuss.ocaml.org/uploads/short-url/dS7Mgz9ByLS0wIAoM60akHsxV2v.png)
![Sandmark-PR-225-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/phFOvw59SaV1btTkQVFAdPBUCK0.png)

* [ocaml-bench/sandmark#226](https://github.com/ocaml-bench/sandmark/pull/226)
  Better scaling for mandelbrot6_multicore

  The `mandelbrot6_multicore` scales well now with the use of
  `parallel_for` as observed in the following graphs:

![Sandmark-PR-226-Time|690x184](https://discuss.ocaml.org/uploads/short-url/8oZid38MSYvuU8TqIcZr6RIDXyy.png)
![Sandmark-PR-226-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/qeu6IP61DFrUCJuTrY88n8QoxJ8.png)
![Sandmark-PR-226-Minor-Collections|690x184](https://discuss.ocaml.org/uploads/short-url/59yQ3fHgz3RV2elebkMLg1nUJ1h.png)

* [ocaml-bench/sandmark#227](https://github.com/ocaml-bench/sandmark/pull/227)
  Improve nbody_multicore benchmark with high core counts

  The `energy` function is now parallelised with `parallel_for_reduce`
  for larger core counts.

![Sandmark-PR-227-Time|690x184](https://discuss.ocaml.org/uploads/short-url/uuKGoQOxTXSWI3664AOD2LIdPdO.png)
![Sandmark-PR-227-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/raK1diCYlKtAOolyXtDKc8eMGGj.png)

* [ocaml-bench/sandmark#229](https://github.com/ocaml-bench/sandmark/pull/229)
  Improve game_of_life benchmarks

  The hot functions are now inlined to improve the `game_of_life`
  benchmarks, and we avoid initialising the temporary matrix with
  random numbers.

![Sandmark-PR-229-Time|690x184](https://discuss.ocaml.org/uploads/short-url/bwpeImbVr37QKJ5OiVcNh1SkkOx.png)
![Sandmark-PR-229-Speedup|690x184](https://discuss.ocaml.org/uploads/short-url/xBaIx2geunZuzlebBY2NMGJt0uA.png)

##### Sundries

* [ocaml-bench/sandmark#215](https://github.com/ocaml-bench/sandmark/pull/215)
  Remove Gc.promote_to from treiber_stack.ml

  The 4.12+domains and 4.12+domains+effects branches have
  `Gc.promote_to` removed from the runtime.

* [ocaml-bench/sandmark#216](https://github.com/ocaml-bench/sandmark/pull/216)
   Add configs for 4.12.0+stock, 4.12.0+domains, 4.12.0+domains+effects

   The ocaml-version configuration files for 4.12.0+stock,
   4.12.0+domains, and 4.12.0+domains+effects have now been included
   to Sandmark.

* [ocaml-bench/sandmark#220](https://github.com/ocaml-bench/sandmark/pull/220)
  Attempt to improve the OCAMLRUNPARAM documentation

  The README has been updated with more documentation on the use of
  OCAMLRUNPARAM configuration when running the benchmarks.

* [ocaml-bench/sandmark#222](https://github.com/ocaml-bench/sandmark/pull/222)
  Deprecate 4.06.1 and 4.10.0 and upgrade to 4.12.0

  The 4.06.1, 4.10.0 ocaml-versions have been removed and the CI
  has been updated to use 4.12.0 as the default version.

#### current-bench

* [ocurrent/current-bench#103](https://github.com/ocurrent/current-bench/issues/103)
  Ability to set scale on UI to start at 0

  The graph origins now start from `[0, y_max+delta]` for the y-axis
  for better comparison.

  ![current-bench frontend fix 0 baseline](images/Current-bench-PR-74.png)

* [ocurrent/current-bench#121](https://github.com/ocurrent/current-bench/pull/121)
  Use string representation for docker cpu setting.

  The `OCAML_BENCH_DOCKER_CPU` setting now switches from Integer to
  String to support a range of CPUs for parallel execution.

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints

  The Sandmark benchmark runs to obtain the performance numbers for
  the Safepoints PR for 4.13.0+trunk have been published. The PR is
  ready to be merged.

## Job Advertisements

* [Multicore OCaml Runtime Systems Engineer](https://discuss.ocaml.org/t/runtime-systems-engineer-ocaml-labs-uk-tarides-fr-segfault-systems-in-remote/7959)
  OCaml Labs (UK), Tarides (France) and Segfault Systems (India)

* [Benchmark Tooling Engineer](https://tarides.com/jobs)
  Tarides

Our thanks to all the OCaml users, developers, and contributors in the
community for their continued support to the project. Stay safe!

## Acronyms

* AMD: Advanced Micro Devices
* API: Application Programming Interface
* CI: Continuous Integration
* CPU: Central Processing Unit
* CTF: Common Trace Format
* DLAB: Domain Local Allocation Buffer
* EA: Evolutionary Algorithm
* GC: Garbage Collector
* GCD: Grand Central Dispatch
* HTTP: Hypertext Transfer Protocol
* OPAM: OCaml Package Manager
* MVP: Minimal Viable Product
* PR: Pull Request
* TPS: Transactions Per Second
* UI: User Interface
