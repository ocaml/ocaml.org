---
title: OCaml Multicore - June 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-06-01"
tags: [multicore]
---

Welcome to the June 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This month's update along with the [previous update's](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by @avsm, @ctk21, @kayceesrk and @shakthimaan.

Our overall goal remains on track for generating a preview tree for OCaml 5.0 multicore domains-only parallelism over the summer.

## Ecosystem compatibility for 4.12.0+domains

In [May's update](https://discuss.ocaml.org/t/multicore-ocaml-may-2021/7990#ecosystem-changes-to-prepare-for-500-domains-only-2), I noted that our focus was now on adapting the ecosystem to work well with multicore, and I'm pleased to report that this is progressing very well.

- The 4.12.0+domains multicore compiler variant has been [merged into mainline opam-repo](https://github.com/ocaml/opam-repository/pull/18960), so you can now `opam switch 4.12.0+domains` directly. The `base-domains` package is also available to mark your opam project as _requiring_ the `Domains` module, so you can even publish your early multicore-capable libraries to the mainline opam repository now.

- The OCaml standard library was made safe for parallel use by multiple domains ([wiki](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml), [issue](https://github.com/ocaml/ocaml/issues/10453), [fixes](https://github.com/ocaml-multicore/ocaml-multicore/issues?q=is%3Aissue+label%3A%22stdlib+safety%22+is%3Aclosed)); and in particularly the `Format` and `Random` modules. These modules were the main sources of incompatibilities we found when running existing OCaml code with multiple domains.

* The `Domain` module has had its interface slimmed with the removal of `critical_section`, `wait`, `notify` which has allowed significant runtime simplification. The GC C-API interface is now implemented and this means that Jane Street's `Base`, `Core`, and `Async` now compile on `4.12+domains` without modifications; for example `opam install patdiff` works out of the box on a `4.12+domains` switch!

*  [Domainslib 0.3.0](https://github.com/ocaml-multicore/domainslib/releases/tag/0.3.0) has been released which incorporates multiple improvements including the work-stealing deques for task distribution. The performance of reading domain local variables has also been improved with a primitive and a O(1) lookup.  The chapter on [`Parallel Programming in
Multicore OCaml`](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml) has been updated to reflect the latest developments with Domainslib.

This means that big application stacks should now compile pretty well with 4.12.0+domains (applications like the Tezos node and patdiff exercise a lot of the dependency trees in opam). If you do find incompatibilities, please do report them on the [repository](https://github.com/ocaml-multicore/ocaml-multicore/issues).

## 4.12.0+domains+effects

Most of our focus has been on getting the domains-only trees (for OCaml 5.0) up to speed, but we have been progressing the direct-style effects-based IO stack as well.

- The `uring` bindings to Linux Io_uring are now available on opam-repository, so you can try it out on sequential OCaml too. A good mini-project would be to add a uring backend to the existing Async or Lwt engines, if anyone wants to try a substantial contribution.
- The [`eio` library](https://github.com/ocaml-multicore/eio) is fairly usable now, for both filesystem and networking. We've submitted a talk to the OCaml workshop to dive into the innards of it in more detail, so stay tuned for that in the coming months if accepted.  The main changes here have been performance improvements, and the HTTP stack is fairy competitive with (e.g.) `rust-hyper`.

We will soon also have a variant of this tree that removes the custom effect syntax and implements the fibres (the runtime piece) as `Obj` functions.  This will further improve ecosystem compatibility and allow us to build direct-style OCaml libraries that use fibres internally to provide concurrency, but without exposing any use of effects in their interfaces.

## Benchmarking and performance

We are always keen to get more benchmarks that exercise multicore features; if you want to try multicore out and help write benchmarks there are some suggestions on the [wiki](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Multicore-benchmarking-projects). We've got a private server which runs a Sandmark nightly benchmark pipeline with Jupyter notebooks, which we can give access to anyone who submits benchmarks. We continue to test integration of Sandmark with [current-bench](https://github.com/ocurrent/current-bench) for better integration with GitHub PRs.

As always, the Multicore OCaml ongoing and completed tasks are listed first, which are then followed by updates from the ecosystem and their associated libraries. The Sandmark benchmarking and nightly build efforts are then mentioned. Finally, the status of the upstream OCaml Safepoints PR is provided for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#573](https://github.com/ocaml-multicore/ocaml-multicore/pull/573)
  Backport trunk safepoints PR to multicore

  A work-in-progress to backport the Safepoints PR from ocaml/ocaml to
  Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#584](https://github.com/ocaml-multicore/ocaml-multicore/pull/584)
  Modernise signal handling

  A patch to bring the Multicore OCaml signals implementation closer
  to upstream OCaml.

* [ocaml-multicore/ocaml-multicore#598](https://github.com/ocaml-multicore/ocaml-multicore/pull/598)
  Do not deliver signals to threads that have blocked them

  A draft PR to not deliver signals to threads that are in a blocked
  state. The without-systhreads case needs to be handled.

* [ocaml-multicore/ocaml-multicore#600](https://github.com/ocaml-multicore/ocaml-multicore/pull/600)
  Expose a few more GC variables in headers

  The `caml_young_start`, `caml_young_limit` and `caml_minor_heap_wsz`
  variables have been defined in the runtime.

* [ocaml-multicore/ocaml-multicore#601](https://github.com/ocaml-multicore/ocaml-multicore/pull/601)
  Domain better participants

  The iterations `0(Max_domains)` from STW signalling and
  `0(n_running_domains)` from domain creation have now been removed.

* [ocaml-multicore/ocaml-multicore#603](https://github.com/ocaml-multicore/ocaml-multicore/pull/603)
  Systhreads tick thread

  An initial draft PR for porting the tick thread to Multicore OCaml.

### Completed

#### Enhancements

* [ocaml-multicore/ocaml-multicore#552](https://github.com/ocaml-multicore/ocaml-multicore/pull/552)
  Add a `force_instrumented_runtime` option to configure

  The `configure` script now accepts a new
  `--enable-force-instrumented-runtime` option to facilitate use of
  the instrumented runtime on linker invocations to obtain event logs.

* [ocaml-multicore/ocaml-multicore#558](https://github.com/ocaml-multicore/ocaml-multicore/pull/558)
  Refactor `Domain.{spawn/join}` to use no critical sections

  The critical sections in `Domain.{spawn/join}` and the use of
  `Domain.wait` have been removed.

* [ocaml-multicore/ocaml-multicore#561](https://github.com/ocaml-multicore/ocaml-multicore/pull/561)
  Slim down `Domain.Sync`: remove `wait`, `notify`, `critical_section`

  A breaking change in `Domain.Sync` that removes `critical_section`,
  `notify`, `wait`, `wait_for`, and `wait_until`. This is to remove
  the need for domain-to-domain messaging in the runtime.

* [ocaml-multicore/ocaml-multicore#576](https://github.com/ocaml-multicore/ocaml-multicore/pull/576)
  Including Git hash in runtime

  A Git hash is now printed in the runtime as shown below:

  ```
  $ ./boot/ocamlrun -version
  The OCaml runtime, version 4.12.0+multicore
  Built with git hash 'ae3fb4bb6' on branch 'runtime_version' with tag '<tag unavailable>'
  ```

* [ocaml-multicore/ocaml-multicore#579](https://github.com/ocaml-multicore/ocaml-multicore/pull/579)
  Primitive for fetching DLS root

  A new primitive has been implemented for fetching DLS, and is now a
  single `mov` instruction on `amd64`.

#### Upstream

* [ocaml-multicore/ocaml-multicore#555](https://github.com/ocaml-multicore/ocaml-multicore/pull/555)
  runtime: `CAML_TRACE_VERSION` is now set to a Multicore specific value

  A `CAML_TRACE_VERSION` is defined to distinguish between Multicore
  OCaml and trunk for the runtime.

* [ocaml-multicore/ocaml-multicore#581](https://github.com/ocaml-multicore/ocaml-multicore/pull/581)
  Move our usage of inline to `Caml_inline`

  We now use `Caml_inline` for all the C inlining in the runtime to
  align with upstream OCaml.

* [ocaml-multicore/ocaml-multicore#589](https://github.com/ocaml-multicore/ocaml-multicore/pull/589)
  Reintroduce `adjust_gc_speed`

  The `caml_adjust_gc_speed` function from trunk has been reintroduced
  to the Multicore OCaml runtime.

* [ocaml-multicore/ocaml-multicore#590](https://github.com/ocaml-multicore/ocaml-multicore/pull/590)
  runtime: stub `caml_stat_*` interfaces in gc_ctrl

  The creation of `caml_stat_*` stub functions in gc_ctrl.h to
  introduce a compatibility layer for GC stat utilities that are
  available in trunk.

#### Fixes

* [ocaml-multicore/ocaml-multicore#562](https://github.com/ocaml-multicore/ocaml-multicore/pull/562)
  Import fixes to the minor heap allocation code from DLABs

  The multiplication factor of two used for minor heap allocation has
  been removed, and the `Minor_heap_max` limit from config.h is no
  longer converted to a byte size for Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#593](https://github.com/ocaml-multicore/ocaml-multicore/pull/593)
  Fix two issues with ephemerons

  A patch to simplify ephemeron handover during termination.

* [ocaml-multicore/ocaml-multicore#594](https://github.com/ocaml-multicore/ocaml-multicore/pull/594)
  Fix finaliser handover issue

  The `caml_finish_major_cycle` is used leading to the major GC phase
  `Phase_sweep_and_mark_main` for the correct handoff of finalisers.

* [ocaml-multicore/ocaml-multicore#596](https://github.com/ocaml-multicore/ocaml-multicore/pull/596)
  systhreads: do `st_thread_id` after initializing the thread descriptor

  The thread ID was set even before initializing the thread
  descriptor, and this PR fixes the order.

* [ocaml-multicore/ocaml-multicore#604](https://github.com/ocaml-multicore/ocaml-multicore/pull/604)
  Fix unguarded `caml_skiplist_empty` in `caml_scan_global_young_roots`

  The PR introduces a `caml_iterate_global_roots` function and fixes a
  locking bug with global roots.

#### Cleanups

* [ocaml-multicore/ocaml-multicore#567](https://github.com/ocaml-multicore/ocaml-multicore/pull/567)
  Simplify some of the minor_gc code

  The `not_alone` variable has been cleaned up with a simplification
  to the minor_gc.c code.

* [ocaml-multicore/ocaml-multicore#580](https://github.com/ocaml-multicore/ocaml-multicore/pull/580)
  Remove struct domain

  The `caml_domain_state` is now the single source of domain
  information with the removal of `struct domain`. `struct
  dom_internal` is no longer leaking across the runtime.

* [ocaml-multicore/ocaml-multicore#583](https://github.com/ocaml-multicore/ocaml-multicore/pull/583)
  Removing interrupt queues

  The locking of `struct_interruptor` when receiving interrupts and
  the use of `struct interrupt` have been removed, simplifying the
  implementation of domains.

#### Sundries

* [ocaml-multicore/ocaml-multicore#582](https://github.com/ocaml-multicore/ocaml-multicore/pull/582)
  Make global state domain-local in Random, Hashtbl and Filename

  The Domain-Local is now set as the default state in `Random`,
  `Hashtbl` and `Filename`.

* [ocaml-multicore/ocaml-multicore#586](https://github.com/ocaml-multicore/ocaml-multicore/pull/586)
  Make the state in Format domain-local

  The default state in `Format` is now set to Domain-Local.

* [ocaml-multicore/ocaml-multicore#595](https://github.com/ocaml-multicore/ocaml-multicore/pull/595)
  Implement `caml_alloc_dependent_memory` and `caml_free_dependent_memory`

  Dependent memory are the blocks of heap memory that depend on the GC
  (and finalizers) for deallocation. The `caml_alloc_dependent_memory`
  and `caml_free_dependent_memory` have been added to
  runtime/memory.c.

## Ecosystem

### Ongoing

* [ocaml-multicore/eventlog-tools#3](https://github.com/ocaml-multicore/eventlog-tools/pull/3)
  Use ocaml/setup-ocaml@v2

  An update to `.github/workflows/main.yml` to build for
  ocaml/setup-ocaml@v2.

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#7](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/7)
  Add a section on Domain-Local Storage

  The README.md file now includes a section on Domain-Local Storage.

* [ocaml-multicore/eio#26](https://github.com/ocaml-multicore/eio/pull/26)
  Grand Central Dispatch Backend

  The implemention of the Grand Central Dispatch (GCD) backend for Eio
  is a work-in-progress.

* [ocaml-multicore/domainslib#34](https://github.com/ocaml-multicore/domainslib/pull/34)
  Fix initial value accounting in `parallel_for_reduce`

  A patch to fix the initial value in `parallel_for_reduce` as it was
  being accounted for multiple times.

* [ocaml-multicore/domainslib#36](https://github.com/ocaml-multicore/domainslib/pull/36)
  Switch to default `Random` module

  The library has been updated to use the default `Random` module as
  it stores its state in Domain-Local Storage which can be called from
  multiple domains. The Sandmark results are given below:

![Domainslib-PR-36-Results|690x383](https://discuss.ocaml.org/uploads/short-url/m1XhWfU6igtUJdkIZPRn6LdJlJK.png)

* [ocaml-multicore/multicore-opam#56](https://github.com/ocaml-multicore/multicore-opam/issues/56)
  Base-effects depends strictly on 4.12

  A query on the use of strict 4.12.0 lower bound for OCaml in
  `base-effects.base/opam`.

* [ocsigen/lwt#860](https://github.com/ocsigen/lwt/pull/860)
  Lwt_domain: An interfacet to Multicore parallelism

  The `Lwt_domain` module has been ported to domainslib Task pool for
  performing computations to CPU cores using Multicore OCaml's
  Domains. A few benchmark results obtained on an Intel Xeon Gold 5120
  processor with 24 isolated cores is shown below:

  ![Lwt-PR-860-Speedup|429x371](https://discuss.ocaml.org/uploads/short-url/4iWKqRUh3abAAa1t8cgML8bzYrc.png)

### Completed

#### Ocaml-Uring

The `ocaml-uring` repository contains bindings to `io_uring` for
OCaml.

* [ocaml-multicore/ocaml-uring#21](https://github.com/ocaml-multicore/ocaml-uring/pull/21)
  Add accept call

  The `accept` call has been added to uring along with the inclusion
  of the `unix` library as a dependency.

* [ocaml-multicore/ocaml-uring#22](https://github.com/ocaml-multicore/ocaml-uring/pull/22)
  Add support for cancellation

  A `cancel` method is added to request jobs for cancellation. The
  queuing operations and tests have also been updated.

* [ocaml-multicore/ocaml-uring#24](https://github.com/ocaml-multicore/ocaml-uring/pull/24)
  Sort out cast

  The `Int_val` has been changed to `Long_val` to remove the need for
  sign extension instruction on 64-bit platforms.

* [ocaml-multicore/ocaml-uring#25](https://github.com/ocaml-multicore/ocaml-uring/pull/25)
  Fix test_cancel

  A `with_uring` function is added with a `queue_depth` argument to
  handle tests for cancellation.

* [ocaml-multicore/ocaml-uring#26](https://github.com/ocaml-multicore/ocaml-uring/pull/26)
  Add `openat2`

  The `openat2` method has been added giving access to all the Linux
  open and resolve flags.

* [ocaml-multicore/ocaml-uring#27](https://github.com/ocaml-multicore/ocaml-uring/pull/27)
  Fine-tune C flags for better performance

  The CFLAGS have been updated for performance improvements. The
  following results are observed for the noop benchmark:

  ```
  Before: noop   10000  │        1174227.1170 ns/run│
  After:  noop   10000  │         920622.5802 ns/run│

  ```

* [ocaml-multicore/ocaml-uring#28](https://github.com/ocaml-multicore/ocaml-uring/pull/28)
  Don't allow freeing the ring while it is in use

  The ring is added to a global set on creation and is cleaned up on
  exit. Also, invalid cancellation requests are checked before
  allocating a slot.

* [ocaml-multicore/ocaml-uring#29](https://github.com/ocaml-multicore/ocaml-uring/pull/29)
  Replace iovec with cstruct and clean up the C stubs

  The `readv` and `writev` now accept a list of Cstructs which allow
  access to sub-ranges of bigarrays, and to work with multiple
  buffers. The handling of OOM errors has also been improved.

* [ocaml-multicore/ocaml-uring#30](https://github.com/ocaml-multicore/ocaml-uring/pull/30)
  Fix remaining TODOs in API

  The `read` and `write` methods have been renamed to `read_fixed` and
  `write_fixed` respectively. The `Region.to_cstruct` has been added
  as an alternative to creating a sub-bigarray. An exception is now
  raised if the user requests for a larger size chunk.

* [ocaml-multicore/ocaml-uring#31](https://github.com/ocaml-multicore/ocaml-uring/pull/31)
  Use `caml_enter_blocking_section` when waiting

  The `caml_enter_blocking_section` and `caml_leave_blocking_section`
  are used when waiting, which allows other threads to execute and the
  GC can run in the case of Multicore OCaml.

* [ocaml-multicore/ocaml-uring#32](https://github.com/ocaml-multicore/ocaml-uring/pull/32)
  Compile `uring` using the C flags from OCaml

  Use the OCaml C flags when building uring, and remove the unused
  dune file.

* [ocaml-multicore/ocaml-uring#33](https://github.com/ocaml-multicore/ocaml-uring/pull/33)
  Prepare release

  The CHANGES.md, README.md, dune-project and uring.opam files have
  been updated to prepare for a release.

* [ocaml-multicore/ocaml-uring#34](https://github.com/ocaml-multicore/ocaml-uring/pull/34)
  Convert `liburing` to subtree

  We now use a subtree instead of a submodule so that the ocaml-uring
  can be submitted to the opam-repository.

#### Parallel Programming in Multicore OCaml

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#5](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/5)
  `num_domains` to `num_additional_domains`

  The documentation and code examples have been updated to now use
  `num_additional_domains` instead of `num_domains`.

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#6](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/6)
  Update latest information about compiler versions

  The compiler versions in the README.md have been updated to use 4.12
  and its variants.

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#8](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/8)
  Nudge people to the default chunk_size setting

  The recommendation is to use the default `chunk_size` when using
  `parallel_for`, especially when the number of domains gets larger.

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#9](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/9)
  Eventlog section updates

  The `eventlog-tools` library can now be used for parsing trace files
  since Multicore OCaml includes CTF tracing support from trunk. The
  relevant information has been updated in the README.md file.

#### Eio

The `eio` library provides an effects-based parallel IO stack for
Multicore OCaml.

##### Additions

* [ocaml-multicore/eio#41](https://github.com/ocaml-multicore/eio/pull/41)
  Add eio.mli file

  A `lib_eio/eio.mli` file containing modules for `Generic`, `Flow`,
  `Network`, and `Stdenv` have been added to the repository.

* [ocaml-multicore/eio#45](https://github.com/ocaml-multicore/eio/pull/45)
  Add basic domain manager

  The PR allows you to run a CPU-intensive task on another domain, and
  adds a mutex to `traceln` to avoid overlapping output.

* [ocaml-multicore/eio#46](https://github.com/ocaml-multicore/eio/pull/46)
  Add Eio.Time and allow cancelling sleeps

  Use `psq` instead of `bheap` library to allow cancellations. The
  `Eio.Time` module has been added to `lib_eio/eio.ml`.

* [ocaml-multicore/eio#53](https://github.com/ocaml-multicore/eio/pull/53)
  Add `Switch.sub_opt`

  A new `Switch.sub_opt` implementation has been added to allow
  running a function with a new switch. Also, `Switch.sub` has been
  modified so that it is not a named argument.

* [ocaml-multicore/eio#54](https://github.com/ocaml-multicore/eio/pull/54)
  Initial FS abstraction

  A module `Dir` has been added to allow file system abstraction along
  with the ability to create files and directories. On Linux, it uses
  `openat2` and `RESOLVE_BENEATH`.

* [ocaml-multicore/eio#56](https://github.com/ocaml-multicore/eio/pull/56)
  Add `with_open_in`, `with_open_out` and `with_open_dir` helpers

  The `Eio.Dir` module now contains a `with_open_in`, `with_open_out`
  and `with_open_dir` helper functions.

* [ocaml-multicore/eio#58](https://github.com/ocaml-multicore/eio/pull/58)
  Add `Eio_linux.{readv, writev}`

  The `Eio_linux.{readv, writev}` functions have been added to
  `lib_eio_linux/eio_linux.ml` which uses the new OCaml-Uring API.

* [ocaml-multicore/eio#59](https://github.com/ocaml-multicore/eio/pull/59)
  Add `Eio_linux.noop` and a simple benchmark

  A `Eio_linux.noop` implementation has been added for benchmarking
  Uring dispatch.

* [ocaml-multicore/eio#61](https://github.com/ocaml-multicore/eio/pull/61)
  Add generic Enter effect to simplify scheduler

  A `Enter` effect has been introduced to simplify the scheduler
  operations, and this does not have much effect on the noop
  benchmark as illustrated below:

![Eio-PR-61-Benchmark|690x387](https://discuss.ocaml.org/uploads/short-url/8zISyoEDKIIZMORMCi3skMIPlGR.png)

##### Improvements

* [ocaml-multicore/eio#38](https://github.com/ocaml-multicore/eio/pull/38)
  Rename Flow.write to Flow.copy

  The code and documentation have been updated to rename `Flow.write`
  to `Flow.copy` for better clarity.

* [ocaml-multicore/eio#36](https://github.com/ocaml-multicore/eio/pull/36)
  Use uring for accept

  The `enqueue_accept` function now uses `Uring.accept` along with the
  `effect Accept`.

* [ocaml-multicore/eio#37](https://github.com/ocaml-multicore/eio/pull/37)
  Performance improvements

  Optimisation for `Eunix.free` and process completed events with
  `Uring.peek` for better performance results.

* [ocaml-multicore/eio#48](https://github.com/ocaml-multicore/eio/pull/48)
  Simplify `Suspend` operation

  The `Suspend` effect has been simplified by replacing the older
  `Await` and `Yield` effects with the code from Eio.

* [ocaml-multicore/eio#52](https://github.com/ocaml-multicore/eio/pull/52)
  Split Linux support out to `eio_linux` library

  `eunix` now has common code that is shared by different backends,
  and `eio_linux` provides a Linux io-uring backend. The tests and the
  documentation have been updated to reflect the change.

* [ocaml-multicore/eio#57](https://github.com/ocaml-multicore/eio/pull/57)
  Reraise exceptions with backtraces

  Added support to store a reference to a backtrace when a switch
  catches an exception. This is useful when you want to reraise the
  exception later.

* [ocaml-multicore/eio#60](https://github.com/ocaml-multicore/eio/pull/60)
  Simplify handling of completions

  The PR adds `Job` and `Job_no_cancel` in `type io_job` along with
  additional `Log.debug` messages.

##### Cleanups

* [ocaml-multicore/eio#42](https://github.com/ocaml-multicore/eio/pull/42)
  Merge fibreslib into eio

  The `Fibreslib` code is now merged with `eio`. You will now need to
  open `Eio.Std` instead of opening `Fibreslib`.

* [ocaml-multicore/eio#47](https://github.com/ocaml-multicore/eio/pull/47)
  Clean up the network API

  The network APIs have been updated with few changes such as renaming
  `bind` to `listen`, replacing `Unix.shutdown_command` with our own
  type in Eio API, and replacing `Unix.sockaddr` with a custom type.

* [ocaml-multicore/eio#49](https://github.com/ocaml-multicore/eio/pull/49)
  Remove `Eio.Private.Waiters` and `Eio.Private.Switch`

  The `Eio.Private.Waiters` and `Eio.Private.Switch` modules have been
  removed, and waiting is now handled using the Eio library.

* [ocaml-multicore/eio#55](https://github.com/ocaml-multicore/eio/pull/55)
  Some API and README cleanups

  The PR has multiple cleanups and documentation changes. The
  README.md has been modified to use `Eio.Flow.shutdown` instead of
  `Eio.Flow.close`, and a Time section has been added. The
  `Eio.Network` module has been changed to `Eio.Net`. The `Time.now`
  and `Time.sleep_until` methods have been added to `lib_eio/eio.ml`.

##### Documentation

* [ocaml-multicore/eio#43](https://github.com/ocaml-multicore/eio/pull/43)
  Add design note about determinism

  The README.md documentation has been updated with few design notes
  on Determinism.

* [ocaml-multicore/eio#50](https://github.com/ocaml-multicore/eio/pull/50)
  README improvements

  Updated README.md and added `doc/prelude.ml` for use with MDX.

#### Handling Cancellation

* [ocaml-multicore/eio#39](https://github.com/ocaml-multicore/eio/pull/39)
  Allow cancelling accept operations

  The PR now supports cancelling the server accept and read
  operations.

* [ocaml-multicore/eio#40](https://github.com/ocaml-multicore/eio/pull/40)
  Support cancelling the remaining Uring operations

  The cancellation request of `connect`, `wait_readable` and
  `await_writable` Uring operations is now supported.

* [ocaml-multicore/eio#44](https://github.com/ocaml-multicore/eio/pull/44)
  Fix read-cancel test

  The `ENOENT` value has been correctly fixed to use -2, and the
  documentation for cancelling the read request has been updated.

* [ocaml-multicore/eio#51](https://github.com/ocaml-multicore/eio/pull/51)
  Getting `EALREADY` from cancel is not an error

  Handle `EALREADY` case in `lib_eunix/eunix.ml` where an operation
  got cancelled while in progress.

#### Sundries

* [ocaml-multicore/eventlog-tools#2](https://github.com/ocaml-multicore/eventlog-tools/pull/2)
  Add a pausetimes tool

  A `eventlog_pausetimes` tool has been added to `eventlog-tools` that
  takes a directory of eventlog files and computes the mean, max pause
  times, as well as the distribution up to the 99.9th percentiles. For
  example:

  ```json
  ocaml-eventlog-pausetimes /home/engil/dev/ocaml-multicore/trace3/caml-426094-* name
  {
    "name": "name",
    "mean_latency": 718617,
    "max_latency": 33839379,
    "distr_latency": [191,250,707,16886,55829,105386,249272,552640,1325621,13312993,26227671]
  }
  ```

* [ocaml-multicore/kcas#9](https://github.com/ocaml-multicore/kcas/pull/9)
  Backoff with `cpu_relax`

  The `Domain.Sync.{critical_section, wait_for}` have now been
  replaced with `Domain.Sync.cpu_relax`, which matches the
  implementation with lockfree.

* [ocaml-multicore/retro-httpaf-bench#10](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/10)
  Add Eio benchmark

  The Eio benchmark has now been added to the retro-httpaf-bench
  GitHub repository.

* [ocaml-multicore/retro-httpaf-bench#11](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/11)
  Do a recursive checkout in the CI build

  The `build_image.yml` workflow has been updated to perform a
  recursive checkout of the submodules for the CI build.

* [domainslib#29](https://github.com/ocaml-multicore/domainslib/pull/29)
  Task stealing with Chase Lev deques

  The task-stealing Chase Lev deques for scheduling tasks across
  domains is now merged, and shows promising results on machines with
  128 CPU cores.

* [ocaml-multicore/multicore-opam#55](https://github.com/ocaml-multicore/multicore-opam/pull/55)
  Add 0.3.0 release of domainslib

  The opam file for `domainslib.0.3.0` has been added to the
  multicore-opam repository.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark-nightly#1](https://github.com/ocaml-bench/sandmark-nightly/issues/1)
  Cannot alter comparison input values

  The `Timestamp` and `Variant` fields in the dropdown option in the
  `parallel_nightly.ipynb` notebook get reset when recomputing the
  whole workbook.

![Sandmark-Nightly-1-Issue|690x139](https://discuss.ocaml.org/uploads/short-url/vZ2JBVqK8HiyPPMtqByaY1Jhip9.png)

* [ocaml-bench/sandmark#230](https://github.com/ocaml-bench/sandmark/pull/230)
  Build for 4.13.0+trunk with dune.2.8.1

  The `ocaml-migrate-parsetree.2.2.0` and `ppxlib.0.22.2` packages are
  now available for 4.13.0+trunk, and we are currently porting the
  Irmin Layers benchmark in Sandmark from using Irmin 2.4 to 2.6.

* [ocaml-bench/sandmark#231](https://github.com/ocaml-bench/sandmark/issues/231)
  View results for a set of benchmarks in the nightly notebooks

  A feature request to filter the list of benchmarks when using the
  Sandmark Jupyter notebooks.

* [ocaml-bench/sandmark#233](https://github.com/ocaml-bench/sandmark/pull/233)
  Update pausetimes_multicore to fit with the latest Multicore changes

  The pausetimes are now updated for both the 4.12.0 upstream and
  4.12.0 Multicore branches to use the new Common Trace Format
  (CTF). The generated graphs for both the sequential and parallel
  pausetime results are illustrated below:

![Sandmark-PR-233-Serial-Pausetimes|690x229](https://discuss.ocaml.org/uploads/short-url/m41amKGFNBx8T5zrassBWsdJlk9.png)
![Sandmark-PR-233-Parallel-Pausetimes|690x355](https://discuss.ocaml.org/uploads/short-url/t8BuHiEO8g6bs8fvv7stdBp0Q7z.png)

* [ocaml-bench/sandmark#235](https://github.com/ocaml-bench/sandmark/issues/235)
  Update selected benchmarks as a set for baseline benchmark

  The baseline benchmark for comparison should only be one from the
  user selected benchmarks in the Jupyter notebooks.

![Sandmark-Issue-235|383x82](https://discuss.ocaml.org/uploads/short-url/zUiPdeScykJgbHhx4HrLIBegOIr.png)

* [ocaml-bench/sandmark#236](https://github.com/ocaml-bench/sandmark/issues/236)
  Implement pausetimes support in sandmark_nightly

  The sequential and parallel pausetimes graph results need to be
  implemented in the Sandmark nightly Jupyter notebooks. The results
  are similar to the Figures 10 and 12 produced in the [Retrofitting
  Parallelism ont OCaml, ICFP 2020
  paper](https://arxiv.org/pdf/2004.11663.pdf).

* [ocaml-bench/sandmark#237](https://github.com/ocaml-bench/sandmark/issues/237)
  Run sandmark_nightly on a larger machine

  The testing of Sandmark nightly sequential and parallel benchmark
  runs have been done on a 24-core machine, and we would like to
  deploy the same on a 64+ core machine to benefit from the recent
  improvements to Domainslib.

* [ocaml-bench/sandmark#241](https://github.com/ocaml-bench/sandmark/pull/241)
  Switch to default Random module

  An on-going discussion on whether to switch to using `Random.State`
  for the sequential Minilight, global roots micro-benchmarks and
  Evolutionary Algorithm.

### Completed

* [ocaml-bench/sandmark#232](https://github.com/ocaml-bench/sandmark/pull/232)
  `num_domains` -> `num_additional_domains`

  The benchmarks have been updated to now use
  `num_additional_domains`, to be consistent with the naming in
  Domainslib.

* [ocaml-bench/sandmark#239](https://github.com/ocaml-bench/sandmark/pull/239)
  Port grammatrix to Task pool

  The Multicore Grammatrix benchmark has now been ported to use
  Domainslib Task pool. The time and speedup graphs are given below:

![Sandmark-PR-239-Time|690x357](https://discuss.ocaml.org/uploads/short-url/tWJKlXjW8kbfE4omjfKlsDNpFv8.png)
![Sandmark-PR-239-Speedup|690x297](https://discuss.ocaml.org/uploads/short-url/aMwCaRugQjIHdEzP35mCmVJyITJ.png)

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints

  The PR is currently being testing and evaluated for both ARM64 and
  PowerPC architectures, in particular, the branch relaxations applied
  to `Ipoll` instructions.

Our thanks to all the OCaml users, developers and contributors in the community for their continued support to the project. Stay safe!
