---
title: OCaml Multicore - February 2022
description: Monthly update from the OCaml Multicore team.
date: "2022-02-01"
tags: [multicore]
---

Welcome to the February 2022 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! As with [previous updates](https://discuss.ocaml.org/tag/multicore-monthly), these have been compiled by me, @ctk21, @kayceesrk and @shakthimaan.

Progress towards a stable OCaml 5.0.0 release have been moving forward at full steam, with most of the multicore OCaml work now happening directly within the main ocaml/ocaml repository. As a number of [deprecations](https://github.com/ocaml/ocaml/blob/trunk/Changes) have happened in OCaml 5.0+trunk, it can be a little tricky in the immediate term to get a working development environment.  You may find these resources helpful:
- There is a [multicore monorepo](https://discuss.ocaml.org/t/awesome-multicore-ocaml-and-multicore-monorepo/9515) which is a 'fast clone and dune build' with a number of ecosystem libraries. (thanks @patricoferris)
- There is an [alpha-opam-repository](https://github.com/kit-ty-kate/opam-alpha-repository/tree/master/packages) which contains work-in-progress packages.  If a package you maintain is in there, now would be a good time to start releasing it to the mainline opam-repository.  Remember that while we can propose changes, only the community maintainers of the relevant projects can do the actual release, so **your help with making OCaml 5.0-compatible releases of your projects would be very much appreciated**. (thanks @kit-ty-kate)


For mainline development, the [compiler development newsletter](https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-5-november-2021-to-february-2022/9459) has an overview of what's been happening in the compiler.  From a multicore perspective:
- the [ARM64 PR](https://github.com/ocaml/ocaml/pulls/10972) has been merged, so your shiny Mac M1s will now work
- we continue to work on the post-Multicore merge tasks for an upcoming 5.0.0+trunk release. The documentation efforts on the OCaml memory model, runtime system, and STW synchronization have also started.
- The [eio project](https://github.com/ocaml-multicore/eio) is actively being developed which now includes UDP support with Eio's networking interface.  There has been [robust discussion](https://discuss.ocaml.org/tag/effects) on several aspects of eio which is all influencing the next iteration of its design (thank you to everyone!). For those of you who do not wish to participate in public discussion, feel free to get in touch with me or @kayceesrk for a private discussion, particularly if you have a large OCaml codebase and opinions on concurrency. We'll summarise all these discussions as best we can over the coming months.
-  `Sandmark-nightly` and `Sandmark` have a custom variant support feature to build trunk, developer branches, or a specific commit to assess any performance regressions. The backend tooling with UI enhancements continue to drive the `current-bench` project forward.

As always, the Multicore OCaml updates are listed first, which are then followed by the ecosystem tooling updates. Finally, the sandmark, sandmark-nightly and current-bench project tasks are mentioned for your reference.

## Multicore OCaml

### Open

#### Discussion

* [ocaml-multicore/ocaml-multicore#750](https://github.com/ocaml-multicore/ocaml-multicore/issues/750)
  Discussing the design of Lazy under Multicore
  
  A continuing design discussion of Lazy under Multicore OCaml that
  involves sequential Lazy, concurrency problems, duplicated
  computations, and memory safety.

* [ocaml/ocaml#10960](https://github.com/ocaml/ocaml/issues/10960)
  Audit `stdlib` for mutable state
  
  An issue tracker to audit stdlib for mutable state, as the OCaml
  5.00 stdlib implementation should be both memory and thread-safe.

* [ocaml/ocaml#11013](https://github.com/ocaml/ocaml/issues/11013)
  Meta-issue for OCaml 5.0 release goals

  An issue tracker that contains a checklist for branching OCaml 5.0.

* [ocaml/ocaml#11073](https://github.com/ocaml/ocaml/issues/11073)
  Code comprehension: why don't STW sections keep `all_domains_lock` the whole time?

  A discussion on the mutual-exclusion mechanism in STW sections where
  race conditions on new domains are checked using a condition
  variable `all_domains_cond`.

#### Build

* [ocaml/ocaml#10940](https://github.com/ocaml/ocaml/issues/10940)
  configure: C11 atomic support required for 5.00.0

  The `_Atomic` keyword was introduced in GCC 4.9 and hense RHEL 7 and
  its derivatives cannot build OCaml 5.0.0. RHEL 7 does not reach EOL
  until 2024. This issue tracks the changes required to add support
  for C11 `_Atomic`.

* [ocaml/ocaml#10989](https://github.com/ocaml/ocaml/pull/10989)
  Download GNU parallel directly from git

  The `tools/ci/appveyor/appveyor_build.sh` has been updated to
  download GNU parallel with Git.

* [ocaml/ocaml#10991](https://github.com/ocaml/ocaml/pull/10991)
  Use `zstd` for CI artifacts upload and download

  The upload and download time of CI artifacts are improved with the
  use of `zstd` compression.

* [ocaml/ocaml#11007](https://github.com/ocaml/ocaml/pull/11007)
  Ship and install META files

  A PR to keep up-to-date META files for the compiler libraries
  (`stdlib`, `compiler-libs`, `threads`, `unix`, `str,` and `dynlink`)
  and to install them alongside the compiler.

#### Bug

* [ocaml/ocaml#10773](https://github.com/ocaml/ocaml/issues/10773)
  `[4.14] Type [> Cycle ]` is not compatible with `type [> Cycle ]`

  A `Type [> ``Cycle ]` not compatible error reported when compiling
  `capnp-rpc.1.2.1` with the 4.14 branch.

* [ocaml/ocaml#10868](https://github.com/ocaml/ocaml/pull/10868)
  Fix off-by-1 bug when initializing frame hashtables

  A PR for `runtime/frame_descriptors.c` that fixes on off-by-1 bug
  when initializing frame hashtables.

* [ocaml/ocaml#11040](https://github.com/ocaml/ocaml/issues/11040)
  `ThreadSanitizer` issues

  An issue tracker that contains list of `ThreadSanitizer` runs from
  `tests/parallel` execution for troubleshooting race conditions.

* [ocaml/ocaml#11061](https://github.com/ocaml/ocaml/issues/11061)
  `dumpobj` tool crashes

  A segmentation fault from `tools/dumpobj` on a bytecode program has
  been reported.

#### Enhancement

* [ocaml/ocaml#10925](https://github.com/ocaml/ocaml/pull/10925)
  Rename symbol for `Caml_state` to `caml_state`
  
  The `Caml_state` macro will be renamed to `caml_state` to avoid a
  name collision, but the change will not be backported to 4.14.

* [ocaml/ocaml#10967](https://github.com/ocaml/ocaml/pull/10967)
  Add temp_dir function to create a temporary directory

  The addition of `Filename.temp_dir` in `stdlib` is required by the
  Tezos project to allow importing HTTP tar snapshots.

* [ocaml/ocaml#10971](https://github.com/ocaml/ocaml/issues/10971)
  Means of limiting how much memory is being reserved by the runtime,
  so that Valgrind and AFL can be used
  
  The suggestion is to set `max_domains` from `OCAMLRUNPARAM` to
  provide a good balance between usability and complexity in the
  implementation.

* [ocaml/ocaml#11054](https://github.com/ocaml/ocaml/pull/11054)
  Respect user provided maximum stack space value, and fix debug run of `tmp/stack_space.ml` test

  A PR that honors `OCAMLRUNPARAM=1` for the initial stack size, and
  ensures that `tmc/stack_space.ml` applies stack restriction during
  the running stage.

* [ocaml/ocaml#11057](https://github.com/ocaml/ocaml/pull/11057)
  Implement quality treatment for asynchronous actions in multicore

  The `caml_process_pending` behaviour has been reimplemented, and
  there are code improvements to the asynchronous actions in the
  Multicore runtime.

#### Documentation

* [ocaml/ocaml#10992](https://github.com/ocaml/ocaml/issues/10992)
  OCaml multicore memory model and C (runtime, FFI, VM)

  A draft documentation on the OCaml Multicore memory model and the
  use of the `Field` macro.

* [ocaml/ocaml#11058](https://github.com/ocaml/ocaml/pull/11058)
  `runtime/HACKING.adoc`: tips on debugging the runtime

  The `HACKING.adoc` has been updated with information on the runtime
  system, and a new `runtime/HACKING.adoc` file has been created on
  how to troubleshoot the same.

* [ocaml/ocaml#11072](https://github.com/ocaml/ocaml/pull/11072)
  domain.c: document the STW synchronization code

  A draft documentation on the STW synchronization code in `domain.c`.

#### Testing

* [ocaml/ocaml#10953](https://github.com/ocaml/ocaml/issues/10953)
  `ocamltest/summarize.awk` not properly reporting abort failures on testsuite runs
  
  The serializer needs to be thoroughly tested using `ocamltest`. The
  recommendation now is to use the strict minimum of code from the
  standard library and the OCaml runtime to implement ocamltest.

* [ocaml/ocaml#10980](https://github.com/ocaml/ocaml/issues/10980)
  GitHub Actions / ocamltest / testsuite / OCaml 5

  An issue tracker that contains a list of action items related to
  ocamltest and OCaml 5.

* [ocaml/ocaml#11016](https://github.com/ocaml/ocaml/issues/11016)
  `lib-dynlink-private/test.ml` failing on the debug runtime

  An assertion failure from `lib-dynlink-private/test.ml` has been
  found in the `test_cow_repeated` segment during the tests.

* [ocaml/ocaml#11055](https://github.com/ocaml/ocaml/pull/11055)
  runtime: introduce `Debug_uninit_tmc` in `misc.h`

  An assertion check in `runtime/memory.c` with the introduction of
  `Debug_uninit_tmc` in `misc.h`.

* [ocaml/ocaml#11065](https://github.com/ocaml/ocaml/pull/11065)
  Restore basic functionality to the bytecode debugger

  A draft PR to handle backtraces in the presence of fibers to restore
  the basic functionality in the bytecode debugger.

#### Performance

* [ocaml/ocaml#10964](https://github.com/ocaml/ocaml/pull/10964)
  Ring-buffer based runtime tracing (`eventring`)
  
  Eventring is a runtime tracing system designed for continuous
  monitoring of OCaml applications. There is not much difference with
  this PR when running Sandmark's sequential benchmarks as illustrated
  below:

![OCaml-PR-10964-time|690x355](upload://bniT5DvOLQajrl4HUgsLKMfnU2U.png)

* [ocaml/ocaml#11062](https://github.com/ocaml/ocaml/issues/11062)
  Bytecode compiler emits too many calls to `caml_ensure_stack_capacity`, causing a slowdown

  The bytecode compiler emits calls to `caml_ensure_stack_capacity`
  that causes a performance regression in Sandmark benchmarks. The
  following illustration compares the byte code results between 4.13.1
  and 5.0.0 (February 24, 2022).

![OCaml-Issue-11062|690x376](upload://6g5Qsc9oK4lJt0OGc2s8afubegw.png)

### Closed

#### Build

* [ocaml/ocaml#10760](https://github.com/ocaml/ocaml/pull/10760)
  Use GNU parallel for the CI testsuite runs

  Use `make parallel` in `tools/ci/actions/runner.sh` to speed-up CI
  test runs.

* [ocaml/ocaml#10875](https://github.com/ocaml/ocaml/pull/10875)
  Use mmap(MAP_STACK|...) for fibre stacks on OpenBSD

  An option to allocate stacks with `mmap(MAP_STACK)` instead of
  `malloc`. This is available using a configure
  `--enable-mmap-map-stack` option. There is not much difference
  between trunk or with mmap on/off on Linux as shown below:
  
![OCaml-PR-10875|690x301](upload://qtgz77rfJltNJx9GCDiKX46tLCj.png)

* [ocaml/ocaml#10893](https://github.com/ocaml/ocaml/pull/10893)
  Remove configuration options `--disable-force-safe-string` and `DEFAULT_STRING=unsafe`

  A PR that removes the deprecated `--disable-force-safe-string` and
  `DEFAULT_STRING=unsafe` compiler options.

* [ocaml/ocaml#10962](https://github.com/ocaml/ocaml/pull/10962)
  Ignore compatible `--disable` options in configure

  The definitions of `NO_NAKED_POINTERS` in `m.h` and
  `NAKED_POINTERS=false` in `Makefile.config.in` are retained for
  compatibility, and the error for the `--disable` option in the
  configure script is ignored.

* [ocaml/ocaml#11037](https://github.com/ocaml/ocaml/pull/11037)
  Assorted fixes found while restarting the Jenkins CI

  The PR contains configure tweaks, updates to Jenkins scripts, test
  suite fixes, and updates to the runtime system based on observations
  in the Jenkins CI.

* [ocaml/ocaml#11049](https://github.com/ocaml/ocaml/pull/11049)
  Normalize the version number of the compiler

  The compiler version number is now `5.0.0`.

* [ocaml/ocaml#11063](https://github.com/ocaml/ocaml/pull/11063)
  Fix the opam file after #11049

  The `ocaml-variants.opam` file has been updated to use version
  `5.0.0+trunk`.

#### Fix

* [ocaml/ocaml#10973](https://github.com/ocaml/ocaml/pull/10973)
  Remove unused `gc_regs_slot` in domain_state

  The `gc_regs_slot` is superseded by `gc_regs_bucket`, and the same
  is thus removed.

* [ocaml/ocaml#10994](https://github.com/ocaml/ocaml/pull/10994)
  [minor] fix multicore merge error in `minor_gc.c:reallloc_generic_table`

  The `realloc_generic_table` in `runtime/minor_gc.c` has been
  restored with the correct parameters.

* [ocaml/ocaml#11002](https://github.com/ocaml/ocaml/pull/11002)
  Do not use `Begin_roots` / `End_roots` in runtime

  The `Begin_roots` and `End_roots` are not to be used in the runtime,
  and a deprecation warning has been added to these macros.

* [ocaml/ocaml#11014](https://github.com/ocaml/ocaml/pull/11014)
  Cut polling of pending signals vector in bytecode interpreter

  The polling using `caml_check_pending_signals` is removed in the
  bytecode interpreter. Also, `caml_check_pending_interrupt` is
  removed in favour of `caml_check_gc_interrupt`.

* [ocaml/ocaml#11039](https://github.com/ocaml/ocaml/pull/11039)
  Reintroduce `caml_final_do_calls_exn`

  The `runtime/finalise.c` code has been updated based on the review
  of asynchronous action handling in Multicore, and
  `caml_final_do_calls_exn` has been reintroduced.

* [ocaml/ocaml#11046](https://github.com/ocaml/ocaml/pull/11046)
  minor bugfix in caml_reallocate_minor_heap

  A fix in the "decommit" logic of `caml_reallocate_minor_heap`, and
  the current minor heap layout has been documented.

* [ocaml/ocaml#11051](https://github.com/ocaml/ocaml/pull/11051)
  Fix leftover TODO in `runtime/startup_byt.c`

  The `Fatal error during unlock: Operation not permitted` error is
  now fixed in `runtime/startup_byt.c`.

* [ocaml/ocaml#11053](https://github.com/ocaml/ocaml/pull/11053)
  Make `Hd_val` a relaxed atomic load

  The PR provides a fix for ThreadSanitizer issues. `Hd_val` is no
  longer an lvalue, and is moved to a relaxed atomic.

#### Documentation

* [ocaml/ocaml#11008](https://github.com/ocaml/ocaml/pull/11008)
  Document and refactor the gc-stats code

  The GC module provides two kinds of runtime statistics, `Heap Stats`
  and `Allocation Stats`, and the same has been documented in
  `runtime/caml/gc_stats.h`.
  
* [ocaml/ocaml#11038](https://github.com/ocaml/ocaml/pull/11038)
  Atomic: update documentation and add institution

  The `CamlInternalAtomic` is removed since atomics are now primitive,
  and documentation has been updated.

* [ocaml/ocaml#11059](https://github.com/ocaml/ocaml/pull/11059)
  Documentation improvements for native stack switching functions

  Additional comments have been added in `fiber.h` for the native code
  specification of `ocaml_runstack`, `caml_perform`, `caml_reperform`,
  and `caml_resume`. The data structures, `struct stack_info` and
  `struct stack_handler`, have also been documented.

#### Testing

* [ocaml/ocaml#10930](https://github.com/ocaml/ocaml/issues/10930)
  Downstream patch changes for removed `Stream` and `Pervasives` library PR#10896
  
  The recommended patch changes for Sandmark dependencies that are
  used to run parallel benchmarks for 5.00.0+trunk have been updated.

* [ocaml/ocaml#11004](https://github.com/ocaml/ocaml/pull/11004)
  Memory model tests

  A new `testsuite/tests/memory-model` sub-directory has been created
  for testing the memory model.

* [ocaml/ocaml#11033](https://github.com/ocaml/ocaml/pull/11033)
  Fix test `callback/test_signalhandler.ml`

  The `.mli` files in `testsuite/tests/callback` have been cleaned up,
  and `unix_kill` now checks for signals. A `mykill` function that
  does not allocate has been added to the test.

#### Enhancement

* [ocaml/ocaml#10462](https://github.com/ocaml/ocaml/pull/10462)
  Add [@poll error] attribute

  The PR proposes an attribute to accompany the safepoints PR, which
  will help developers of libraries having atomic sections to do so in
  a less error prone way.

* [ocaml/ocaml#10950](https://github.com/ocaml/ocaml/pull/10950)
  Allocate domain state using `malloc` instead of `mmap`

  The `mmap` calls are replaced by `malloc` to simplify `Caml_state`
  management.

* [ocaml/ocaml#10965](https://github.com/ocaml/ocaml/pull/10965)
  Thread safety for all runtime hooks

  The thread-safety of hooks and the restoration of the GC timing
  hooks in Multicore have been merged.

* [ocaml/ocaml#10966](https://github.com/ocaml/ocaml/pull/10966)
  Simplifications/cleanups/clarifications for Multicore review
  
  `caml_modify` has been documented, the APIs for signals/actions have
  been simplified, and dead code has been removed.

* [ocaml/ocaml#10974](https://github.com/ocaml/ocaml/pull/10974)
  `domain.c`: Use an atomic counter for domain unique IDs
  
  The use of a fixed `Max_domains` setting is removed to dynamically
  configure the same during program execution.
  
* [ocaml/ocaml#10977](https://github.com/ocaml/ocaml/pull/10977)
  Make `<caml/sync.h>` more abstract and refactor implementation of sync.c

  The POSIX implementation of mutexes and condition variables in
  `<caml/sync.h>` have been moved to `sync_posix.h`. The
  `<caml/sync.h>` declares only the high-level, platform-agnostic
  mutex and condition variable operations.

* [ocaml/ocaml#10988](https://github.com/ocaml/ocaml/pull/10988)
  Provide a default definition of `cpu_relax`

  A default definition of `cpu_relax` has been added to
  `runtime/caml/platform.h`.

* [ocaml/ocaml#11003](https://github.com/ocaml/ocaml/pull/11003)
  Adjust `mmap` alignment of minor heap space

  The alignment for `mmap` in the minor heap space has been adjusted
  to use `caml_sys_pagesize`.

* [ocaml/ocaml#11010](https://github.com/ocaml/ocaml/pull/11010)
  Alternative approach to using `strerror_r` for reentrant error string conversion

  The `strerror_r` is used for reentrant error string
  conversion. Also, a `caml_plat_fatal_error` error reporting function
  has been added to `runtime/platform.c`.

* [ocaml/ocaml#11023](https://github.com/ocaml/ocaml/pull/11023)
  Careful minor heap clear in DEBUG

  The `Debug_free_minor` is used to clear the minor heap at the end of
  a minor collection, and the transition from `Debug_free_minor` to
  `Debug_uninit_minor` is checked when using `Alloc_small`.

* [ocaml/ocaml#11031](https://github.com/ocaml/ocaml/pull/11031)
  With frame-pointers, exception handlers should restore RBP

  On AMD64, the exception handlers should restore the `rbp` register
  when using frame-pointers.

* [ocaml/ocaml#11056](https://github.com/ocaml/ocaml/pull/11056)
  Minor improvements to "named values" handling

  The result of `caml_named_value("Unix.Unix_error")` is cached, and
  the "djb2" hash function is used for the table of named
  values. Also, locking has been added to `caml_iterate_named_values`.

#### Cleanup

* [ocaml/ocaml#10966](https://github.com/ocaml/ocaml/pull/10966)
  Simplifications/cleanups/clarifications from multicore review

  The `caml_modify` is now documented, and a few public API have been
  made private. The APIs for signals have been simplified, and dead
  code has been removed.

* [ocaml/ocaml#11001](https://github.com/ocaml/ocaml/pull/11001)
  Header cleanup: `mlvalues.h` include `domain_state.h` once & minimise cross-header includes

  The `domain_state.h` now includes `mlvalues.h` once, and the PR
  minimises cross-inclusion between headers.

* [ocaml/ocaml#11019](https://github.com/ocaml/ocaml/pull/11019)
  Remove unncessary `Current_thread` restore in `caml_thread_enter_blocking_section`

  The `caml_thread_enter_blocking_section` function in
  `otherlibs/systhreads/st_stubs.c` has been updated to remove the
  unnecessary use of `Current_thread`.

* [ocaml/ocaml#11041](https://github.com/ocaml/ocaml/pull/11041)
  Minor cleanups in effect.ml

  The PR remove code duplication in `Effect.Shallow`. It also removes
  `Obj.magic` and includes optimization to `Shallow.fiber`.

#### Performance

* [ocaml/ocaml#10930](https://github.com/ocaml/ocaml/issues/10930)
  Downstream patch changes for removed `Stream` and `Pervasives` library PR#10896

  The removal of `Stream` and `Pervasives` library required patch
  updates to Sandmark dependency packages.

* [ocaml/ocaml#10949](https://github.com/ocaml/ocaml/pull/10949)
  Atomic operations on arrays

  A new `Atomic.Array` module contains the atomic operations on
  arrays, namely, atomic read, write, exchange, compare and set, and
  fetch and add. A program that spawns four threads and performs
  10,000 fetch-and-adds in an atomic array of integers was
  benchmarked. The performance of random write accesses is illustrated
  in the following figure:
  
  ![OCaml-PR-10949](images/OCaml-PR-10949.svg)
   
* [ocaml/ocaml#11000](https://github.com/ocaml/ocaml/pull/11000)
  Fix a minor regression from #10462

  The `check_local_inline` is added to `lambda/translattribute.ml` to
  fix a minor regression related to safepoints.

* [ocaml/ocaml#11047](https://github.com/ocaml/ocaml/pull/11047)
  gc stats: properly orphan allocation stats

  The `orphan stats` are stored in a global `structure alloc_stats` in
  `gc_stats.c`, which is protected by a lock. On domain termination,
  the stats of the current domain are added to `orphan stats`.

#### ARM64

* [ocaml/ocaml#10943](https://github.com/ocaml/ocaml/pull/10943)
  Introduce atomic loads in Cmm and Mach IRs
  
  The `Patomic_load` primitive is now enhanced to ease support for
  other architectures. This is required for the ARM64 support.

* [ocaml/ocaml#10972](https://github.com/ocaml/ocaml/pull/10972)
  ARM64 multicore support

  The PR for ARM64 Multicore OCaml has been merged. The `arm64.S` file
  has been updated, and the coverage tests for
  `testsuite/tests/effects` and `testsuite/tests/callback` run fine.

## Ecosystem

### Eio

#### Open

* [ocaml-multicore/eio#190](https://github.com/ocaml-multicore/eio/pull/190)
  Update to `cmdliner.1.1.0`
  
  A draft PR to update to `cmdline.1.1.0` with changes to
  `lib_eio_linux/tests/eurcp.ml`.

* [ocaml-multicore/eio#196](https://github.com/ocaml-multicore/eio/issues/196)
  Consider renaming `Fibre.fork`

  The `Fibre.fork` name is not related to `Unix.fork`, and it does not
  copy the calling environment. It needs to be renamed. Suggestions
  include `create`, `start`, or `spawn`.

* [ocaml-multicore/eio#205](https://github.com/ocaml-multicore/eio/pull/205)
  Prepare release

  The sources now depend on `uring.0.3` and `CHANGES.md` file has been
  updated to prepare for a release.

#### Completed

##### Build

* [ocaml-multicore/eio#167](https://github.com/ocaml-multicore/eio/pull/167)
  Remove pin-depends on uring

  The `pin-depends` section in `eio_linux.opam` file has been removed.

* [ocaml-multicore/eio#182](https://github.com/ocaml-multicore/eio/pull/182)
  Add a dependency on OCaml

  An explicit dependency mentioning `ocaml (>= 4.12.0)` has been added
  to the `dune-project` and `eio.opam` files.

##### Fix

* [ocaml-multicore/eio#173](https://github.com/ocaml-multicore/eio/pull/173)
  `Buf_read.seq` now checks the stream hasn't moved on

  The error detection for using a sequence twice, or when performing
  other parsing operations first has been added.

* [ocaml-multicore/eio#174](https://github.com/ocaml-multicore/eio/pull/174)
  Remove "broken" state from promises

  A promise is now simply unresolved or resolved. `Promise.await` does
  not raise exceptions, and `Promise.break`, `Promise.broken`, and
  `await_result` have been removed.

* [ocaml-multicore/eio#176](https://github.com/ocaml-multicore/eio/pull/176)
  Prevent Switch and Cancel from being mutated from other domains

  A cancellation context across domains is not permitted, and
  cancellation functions are allowed to assume that they are running
  in their own domain.

* [ocaml-multicore/eio#187](https://github.com/ocaml-multicore/eio/issues/187)
  WSL: Unix.Unix_error on "Hello, World" example

  A `Unix.Unix_error` reported by @leviroth (Levi Roth) when running a
  "Hello, World" example on Windows 11. The
  [PR#203](https://github.com/ocaml-multicore/eio/pull/203) provides a
  fix for the same.

* [ocaml-multicore/eio#195](https://github.com/ocaml-multicore/eio/pull/195)
  Rename Fibre to Fiber

  The upstream naming of `Fiber` is used in the sources, and the old
  name is marked as deprecated.

* [ocaml-multicore/eio#201](https://github.com/ocaml-multicore/eio/pull/201)
  `Effect.eff` is now `Effect.t` in trunk

  The upstream change in trunk from `Effect.eff` to `Effect.t` has
  been incorporated into Eio with compatibility for 4.12+domains.

* [ocaml-multicore/eio#203](https://github.com/ocaml-multicore/eio/pull/203)
  Switch to `luv` backend if uring can't be used

  A `fallback` argument has been added to check if `io_uring` is
  available on the system. Otherwise, the `luv` backend is used.

##### Enhancement

* [ocaml-multicore/eio#155](https://github.com/ocaml-multicore/eio/issues/155)
  Add `Eio_unix.FD`
  
  The `FD` module has been added to `lib_eio/unix/eio_unix.ml` to be
  used with the `Luv.0.5.11` asynchronous I/O library.

* [ocaml-multicore/eio#165](https://github.com/ocaml-multicore/eio/pull/165)
  Add `secure_random` device to stdenv

  A Random module has been added to `lib_eio_luv/eio_luv.ml`, and
  `lib_eio/eio.ml` includes a `secure_random` device to stdenv.

* [ocaml-multicore/eio#166](https://github.com/ocaml-multicore/eio/pull/166)
  Simplify Flow interface

  The `read` and `write` classes have been removed, and we instead use
  `source` and `sink` for everything. Also, `Flow.read_into src buf`
  has been renamed to `Flow.read src buf`.

* [ocaml-multicore/eio#168](https://github.com/ocaml-multicore/eio/pull/168)
  Move low-level backend functions to submodules

  The Eio abstraction provides top-level functions, and hence the
  low-level backend functions have been moved to submodules.

* [ocaml-multicore/eio#169](https://github.com/ocaml-multicore/eio/pull/169)
  Make `Eio.Std` just provide aliases to Eio

  The PR allows you to directly refer to `Eio.Promise.t`, and`Eio.Std`
  provides aliases to Eio.

* [ocaml-multicore/eio#171](https://github.com/ocaml-multicore/eio/pull/171)
  UDP interface

  An initial implementation of `UDP` support to Eio's networking
  interface. A `tests/test_network.md` file has also been added to
  test working with UDP and endpoints.

* [ocaml-multicore/eio#175](https://github.com/ocaml-multicore/eio/pull/175)
  Add `Buf_read.parse_exn`

  The `lib_eio/buf_read.ml` file now includes a `parse_exn` function
  that converts parser errors into friendly message.

* [ocaml-multicore/eio#177](https://github.com/ocaml-multicore/eio/pull/177)
  Replace `Ipaddr.classify` with `Ipaddr.fold`
  
  The `Ipaddr.fold` is used instead of `Ipaddr.classify` to match the
  style of `stdlib`.

* [ocaml-multicore/eio#178](https://github.com/ocaml-multicore/eio/pull/178)
  Rename `Sink.write` to `Sink.copy`

  The `Sink.write` function has been renamed to `Sink.copy` to match
  the actual functionality.

* [ocaml-multicore/eio#181](https://github.com/ocaml-multicore/eio/pull/181)
  Move ctf to eio

  The `Ctf` module has been moved inside Eio as its API could change
  quite often.

* [ocaml-multicore/eio#188](https://github.com/ocaml-multicore/eio/pull/188)
  Add `Eio_unix.sleep`
  
  A `Eio_unix.sleep` function has been added as a replacement for
  `Lwt_unix.sleep` to not treat time as a capability.

* [ocaml-multicore/eio#192](https://github.com/ocaml-multicore/eio/pull/192)
  Tidy up forking API

  The `Cancel.cancel` has been optimised, and `fork_promise` reports
  the result against the promise.

* [ocaml-multicore/eio#198](https://github.com/ocaml-multicore/eio/pull/198)
  Add `Eio_unix.FD.as_socket`

  We now wrap a Unix FD as an Eio socket, which is useful for working
  with existing libraries that provide a `Unix.file_descr` or when
  receiving FDs from socket activation.

* [ocaml-multicore/eio#199](https://github.com/ocaml-multicore/eio/pull/199)
  Update to new uring API to get FD passing

  The `lib_eio_linux/eio_linux.ml` file has been updated to use the
  new `uring API`, and a FD passing test has been added.

* [ocaml-multicore/eio#200](https://github.com/ocaml-multicore/eio/pull/200)
  Eio_linux: cope with lack of fixed chunks

  A failure request to allocate a fixed buffer now logs a warning. The
  `with_chunk` function takes an `n_blocks` argument, and `free` is
  now called `free_fixed`.

##### Documentation

* [ocaml-multicore/eio#170](https://github.com/ocaml-multicore/eio/pull/170)
  Document how to implement Eio objects yourself

  A `Provider Interfaces` section has been added to the `README.md`
  file that documents how to define your own resources.

* [ocaml-multicore/eio#172](https://github.com/ocaml-multicore/eio/pull/172)
  Clean up Eio odoc

  The `Hook` is inlined with `Switch`, and most modules now have
  documentation with an example.

* [ocaml-multicore/eio#179](https://github.com/ocaml-multicore/eio/pull/179)
  Update odoc for `eio_main`, `eio_luv` and `eio_linux`

  The odoc documentation has been updated for `eio_main`, `eio_luv`,
  and `eio_linux` files.

* [ocaml-multicore/eio#180](https://github.com/ocaml-multicore/eio/pull/180)
  Update README

  Additional notes on `Object Capabilities` have been added in the
  `README.md` file along with the current status of the Eio project.

* [ocaml-multicore/eio#183](https://github.com/ocaml-multicore/eio/pull/183)
  Publish odoc on release

  The `dune-project` file has been updated with the link to the odoc
  documentation web page for Eio.

* [ocaml-multicore/eio#185](https://github.com/ocaml-multicore/eio/pull/185)
  Link to generated odoc from README

  The links to the generated odoc from the `README.md` file have been
  explicitly linked for quick reference.

* [ocaml-multicore/eio#186](https://github.com/ocaml-multicore/eio/pull/186)
  Minor documentation fixes

  The `README.md` and `lib_eio/eio.mli` documentation have been
  updated with minor fixes.

* [ocaml-multicore/eio#194](https://github.com/ocaml-multicore/eio/pull/194)
  Remove confusing use of the word "object"

  The word `object` has been removed from the `Capabilities` section
  in the README.md file in order to avoid any confusion with OCaml
  objects (polymorphic records).

* [ocaml-multicore/eio#197](https://github.com/ocaml-multicore/eio/pull/197)
  Add more documentation

  The documentation on `Cancellation` has been updated with more
  low-level details.

##### Testing

* [ocaml-multicore/eio#184](https://github.com/ocaml-multicore/eio/pull/184)
  Tests: use local directory for test socket

  `opam-repo-ci` uses a read-only `/tmp` directory, and hence we
  switch to using a local directory for testing socket.

* [ocaml-multicore/eio#189](https://github.com/ocaml-multicore/eio/pull/189)
  Add an example `Eio_null` backend

  A skeleton Eio backend with no actual effects has been added as an
  example. It is inefficient and not thread-safe, but, exists for
  demonstration purpose only.

* [ocaml-multicore/eio#191](https://github.com/ocaml-multicore/eio/pull/191)
  Suppress cmdliner deprecation warning

  A `-deprecated` flag is added to `lib_eio_linux/tests/eurcp.ml` to
  suppress cmdliner warnings when testing.

* [ocaml-multicore/eio#202](https://github.com/ocaml-multicore/eio/pull/202)
  Fix typo in tests

  The `lib_eio/eio_linux/tests/fd_passing.md` file has been updated to
  run uring tests with `EIO_BACKEND=luv`.

* [ocaml-multicore/eio#204](https://github.com/ocaml-multicore/eio/pull/204)
  Disable Linux mdx test on non-linux platforms

  Using the `enabled_if` construct from `dune.2.9` the Linux MDX tests
  are now run only when the system is for `linux`.

### Tezos

#### Open

* [ocaml-multicore/tezos#25](https://github.com/ocaml-multicore/tezos/pull/25)
  Merge updates -- disable failing tests temporarily

  The temporary disabling of failing tests, and a merge update for
  upstream changes.

* [ocaml-multicore/tezos#27](https://github.com/ocaml-multicore/tezos/issues/27)
  Status of build on 5.0.0+trunk

  An issue tracker for the list of failing builds required to build
  Tezos on 5.0.0+trunk.

#### Closed

* [ocaml-multicore/tezos-opam-repository#9](https://github.com/ocaml-multicore/tezos-opam-repository/pull/9)
  sync

  A merge that updates the repository with upstream changes up to
  January 24, 2022 for the `4.12.0+domains` branch.

* [ocaml-multicore/tezos#26](https://github.com/ocaml-multicore/tezos/pull/26)
  Sync

  A synchronization of upstream changes to `4.12.0+domains` branch.

### domainslib

#### Open

* [ocaml-multicore/domainslib#65](https://github.com/ocaml-multicore/domainslib/pull/65)
  Fix build on trunk

  A patch in Domainslib for the renaming of `Effect.eff -> Effect.t`
  change has been provided. The CI has now been updated to build for
  `5.0.0+trunk` as well.

* [ocaml-multicore/domainslib#66](https://github.com/ocaml-multicore/domainslib/issues/66)
  `Domainslib.0.4.1` build failure with `OCaml 5.0.0+trunk`

  An `Unbound type constructer eff` error occurs when building
  `Domainslib.0.4.1` in Sandmark for OCaml 5.0.0+trunk.

#### Completed

* [ocaml-multicore/domainslib#64](https://github.com/ocaml-multicore/domainslib/pull/64)
  Changes from opam-repository

  The `domainslib.opam` file has been updated to use `OCaml (>= "5.0")`,
  and `dune (>= "1.8")`.

### ocaml-uring

#### Closed

##### Updates

* [ocaml-multicore/ocaml-uring#46](https://github.com/ocaml-multicore/ocaml-uring/pull/46)
  Update to `liburing 2.1`
  
  The sources have been updated to use `liburing.2.1`, and
  `lib/uring/uring_stubs.c` now invokes `io_uring_submit(ring)`.

* [ocaml-multicore/ocaml-uring#49](https://github.com/ocaml-multicore/ocaml-uring/pull/49)
  Add `sendmsg` and `recvmsg`

  The PR adds `sendmsg(2)` and `recvmsg(2)` calls to the uring
  library, and defines a module `Msghdr`.

* [ocaml-multicore/ocaml-uring#50](https://github.com/ocaml-multicore/ocaml-uring/pull/50)
  `Cmdliner.1.1.0`

  The `Cmdliner` version has been updated to 1.1.0 and to use the
  latest API for the tests.

* [ocaml-multicore/ocaml-uring#52](https://github.com/ocaml-multicore/ocaml-uring/pull/52)
  Allow sending and receiving FDs using SCM_RIGHTS

  The target address in `send_msg` is optional, and we can now send
  and receive FDs with SCM_RIGHTS.

* [ocaml-multicore/ocaml-uring#53](https://github.com/ocaml-multicore/ocaml-uring/pull/53)
  Don't allocate a fixed buffer by default

  The user needs to use `set_fixed_buffer` to allocate a fixed size
  buffer to avoid hitting a resource limit and locking memory.

##### Documentation

* [ocaml-multicore/ocaml-uring#47](https://github.com/ocaml-multicore/ocaml-uring/pull/47)
  Prepare release

  The `CHANGES.md` file has been updated with new features and changes
  for a release.

* [ocaml-multicore/ocaml-uring#48](https://github.com/ocaml-multicore/ocaml-uring/pull/48)
  Link to API docs

  The `README.md` has been updated with link to the [API
  documentation](https://ocaml-multicore.github.io/ocaml-uring/uring/index.html).

* [ocaml-multicore/ocaml-uring#54](https://github.com/ocaml-multicore/ocaml-uring/pull/54)
  Prepare release

  The `CHANGES.md` file has been updated with new and breaking changes
  to prepare for a release.

### retro-httpaf-bench

#### Open

* [ocaml-multicore/retro-httpaf-bench#19](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/19)
  cohttp-eio: add cohttp-eio based benchmark

  A `cohttp_eio` benchmark has been added with updates to the
  benchmarking scripts.

* [ocaml-multicore/retro-httpaf-bench#21](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/21)
  Simpler hyper server

  An implementation of a simple hyper server that uses Tokio's
  multi-threaded scheduler.

* [ocaml-multicore/retro-httpaf-bench#22](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/22)
  Add version bound for shuttle

  The `shuttle.0.3.1` version is explicitly specified in order to keep
  the benchmarks running, even if there are breaking changes in future
  shuttle releases.

#### Completed

* [ocaml-multicore/retro-httpaf-bench#20](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/20)
  Update to `Eio` 0.1

  The Dockerfile has been updated to use `Eio` 0.1.

### Sundries

#### Open

* [ocaml-multicore/eventlog-tools#6](https://github.com/ocaml-multicore/eventlog-tools/pull/6)
  Update `eventlog-tools` for Multicore

  A work-in-progress to update `eventlog-tools` for Multicore OCaml.

* [ocaml-multicore/tezos#24](https://github.com/ocaml-multicore/tezos/issues/24)
  Test suite failure
  
  An ongoing fix for the `Alcotest_engine__Core.Make(P) (M)` error
  when running the tests.

* [ocaml-multicore/effects-examples#26](https://github.com/ocaml-multicore/effects-examples/pull/26)
  Port to OCaml 5.00
  
  The [Rename
  Effect.{eff=>t}](https://github.com/ocaml/ocaml/pull/11044) PR is
  required to port the `Effects` examples to run with OCaml 5.0,
  without the dedicated effects syntax.

#### Closed

* [ocaml-multicore/eventlog-tools#5](https://github.com/ocaml-multicore/eventlog-tools/pull/5)
  Update `consts.ml` to work with OCaml 4.13

  The `force_minor/memprof` sources have been included in
  `lib/consts.ml` to build eventlog-tools for OCaml 4.13.1.

* [ocaml-multicore/lockfree#9](https://github.com/ocaml-multicore/lockfree/pull/9)
  Update `cpu_relax` to new location

  The `Domain.Sync.cpu_relax` has been updated with `cpu_relax` in
  `src/backoff.ml` to build with OCaml 5.0.0.

* [ocaml-multicore/lockfree#10](https://github.com/ocaml-multicore/lockfree/pull/10)
  Remove unused dependencies from opam file

  The `kcas` package is not a dependency of `lockfree`, and
  `ocamlfind` and `ocamlbuild` are not needed any more. These three
  dependencies have been removed from the `lockfree.opam` file.

* [ocaml-multicore/kcas#11](https://github.com/ocaml-multicore/kcas/pull/11)
  Update `cpu_relax` to new location

  The PR updates `Domain.Sync.cpu_relax` in `src/backoff.ml` so that
  it can compile with OCaml 5.0.0.

## Benchmarking

### Sandmark

#### Open

* [ocaml-bench/sandmark#274](https://github.com/ocaml-bench/sandmark/issues/274)
  Custom Variant Support
  
  The configuration to build developer branches in Sandmark for a
  specific branch, configure options, runtime parameters, a name for
  the variant, dependency package override, package removal list, and
  an expiry date until which the Sandmark nightly runs should occur is
  almost complete. The sample JSON configuration file is as follows:
  
  ```
   [ { "url" : "https://github.com/ocaml-multicore/ocaml-multicore/archive/parallel_minor_gc.tar.gz",
    "configure" : "-q",
    "runparams" : "v=0x400",
    "name": "5.00+trunk+kc+pr23423",
    "expiry": "YYYY-MM-DD"},
  ...]  
  ```

* [ocaml-bench/sandmark#279](https://github.com/ocaml-bench/sandmark/issues/279)
  Update notebooks/ To 5.00.0+trunk

  The Jupyter notebooks in the notebooks/ folder need to be updated to
  use the 5.0.0+trunk, by default.

* [ocaml-bench/sandmark#280](https://github.com/ocaml-bench/sandmark/issues/280)
  Upstream 5.00.0+trunk dependency packages

  A number of Sandmark dependency package patches have been upstreamed
  to the respective maintainers or to the OPAM repository. A few more
  patches remain to be submitted upstream.

* [ocaml-bench/sandmark#282](https://github.com/ocaml-bench/sandmark/issues/282)
  Analyse Bytecode Performance

  The Sandmark benchmarks produce native code, by default, and we
  would like to run the byte code version of the benchmarks to
  identify any regression between 4.13 or 4.14 with 5.0.0+trunk.

* [ocaml-bench/sandmark#285](https://github.com/ocaml-bench/sandmark/issues/285)
  Evaluate merging parallel run_config.json files

  A request to combine `multicore_parallel_run_config.json` and
  `multicore_parallel_navajo_run_config.json` into one JSON file, so
  that we add new benchmarks to one place instead of two (or more).

* [ocaml-bench/sandmark#286](https://github.com/ocaml-bench/sandmark/issues/286)
  Update `check_url` and validate URL in custom.json files

  The `check_url` target in the Makefile needs to check if a URL is
  present for each and every entry in the `custom.json` file, and that
  the URL actually exists.

#### Closed

##### Build

* [ocaml-bench/sandmark#270](https://github.com/ocaml-bench/sandmark/pull/270)
  Update to 5.00.0+domains
  
  The dependencies and benchmarks to run 5.00.0+domains variant have
  been updated to build in Sandmark.

* [ocaml-bench/sandmark#276](https://github.com/ocaml-bench/sandmark/pull/276)
  Re-add 5.00.0+trunk with CI failure:ignore option
  
  The .drone.yml CI is updated to ignore a failed build for
  5.00.0+trunk, so that we can continue to merge changes as long as
  5.00.0+stable Sandmark builds fine.

* [ocaml-bench/sandmark#278](https://github.com/ocaml-bench/sandmark/pull/278)
  Updated run_all scripts and 5.00.0+stable to February 3, 2022 commit

  The `run_all` scripts have been updated to use `SYS_DUNE_HACK`, and
  the 5.00.0+stable variant has been updated to the February 3, 2022
  `ocaml/ocaml` commit.

* [ocaml-bench/sandmark#295](https://github.com/ocaml-bench/sandmark/pull/295)
  Clean OCaml dependencies/packages fully after a build

  The `ocaml-base-compiler` and `ocaml` dependency packages folder
  need to be cleaned correctly, as they are used in subsequent
  sandmark-nightly runs.

##### Enhancement

* [ocaml-bench/sandmark#271](https://github.com/ocaml-bench/sandmark/pull/271)
  Parameterize ocaml-variants information as Docker environment variables
  
  The following variables have been parameterized in the Sandmark
  Makefile to be used as environment variables to support the `Custom
  Variant Support` feature request:
  
  ```
  SANDMARK_DUNE_VERSION
  SANDMARK_URL
  SANDMARK_REMOVE_PACKAGES
  SANDMARK_OVERRIDE_PACKAGES
  ```

* [ocaml-bench/sandmark#283](https://github.com/ocaml-bench/sandmark/pull/283)
  Add Custom Variant Support feature

  An initial support for the Custom Variant Support feature that
  allows you to specify `url`, `tag`, `config_json`, `name`, `expiry`,
  `environment`, `configure`, and `runparams` in a custom.json file
  has been merged to run with sandmark-nightly.

* [ocaml-bench/sandmark#284](https://github.com/ocaml-bench/sandmark/pull/284)
  Use specific name in .orun.summary.bench output

  The `name` specified in a custom.json file is now used in the
  `orun.summary.bench` results file.

* [ocaml-bench/sandmark#287](https://github.com/ocaml-bench/sandmark/pull/287)
  Use separate custom variant JSON files per server

  Two separate `custom_navajo.json` and `custom_turing.json` files
  have been created for sandmark-nightly execution runs.

* [ocaml-bench/sandmark#291](https://github.com/ocaml-bench/sandmark/pull/291)
  Custom script log output to results directory

  The build and execution logs are now stored along with the benchmark
  results for easy access in the UI.

* [ocaml-bench/sandmark#293](https://github.com/ocaml-bench/sandmark/pull/293)
  Allow raw GitHub JSON configuration input for custom variant

  You can now use a `CUSTOM_FILE` environment variable to pass a
  remote file as an input configuration to the Custom Support Variant
  feature request.

##### Documentation

* [ocaml-bench/sandmark#268](https://github.com/ocaml-bench/sandmark/pull/268)
   Update README CI Build status to main branch
   
   The CI `Build Status` for the `main` branch in Sandmark has been
   updated to point to the main branch.

* [ocaml-bench/sandmark#277](https://github.com/ocaml-bench/sandmark/pull/277)
  Sync and update README from master branch
  
  The README changes from the Sandmark master branch have been synced
  up with the main branch, as we will soon switch to using the main
  branch as the default branch in Sandmark.

##### Sundries

* [ocaml-bench/sandmark#281](https://github.com/ocaml-bench/sandmark/issues/281)
  Sandmark.ocamllabs.io shows error instead of parallel benchmarks

  The production server has been deployed with the latest nightly
  scripts, and the web application that fixes the display of the
  parallel benchmarks.

* [ocaml-bench/sandmark#289](https://github.com/ocaml-bench/sandmark/pull/289)
  Use CPU 5 in run_config.json for consistency

  The `orun` command now uses CPU 5 to be consistent with the other
  wrappers. This is not an issue with the CI runs.

* [ocaml-bench/sandmark#292](https://github.com/ocaml-bench/sandmark/pull/292)
  Use Task run in parallel benchmarks

  The `domainslib.0.4.1` package has been updated in Sandmark, and the
  `parallel_for` and `await` calls are now wrapped in `Task.run`.

* [ocaml-bench/sandmark#296](https://github.com/ocaml-bench/sandmark/pull/296)
  Use a single `Task.run` in parallel benchmarks

  A fix where the `Task.pool` inside the iter function was blocking
  indefinitely. Now the `LU_decomposition_multicore.exe` parallel
  benchmark runs correctly.

### Sandmark-nightly

#### Open

* [ocaml-bench/sandmark-nightly#21](https://github.com/ocaml-bench/sandmark-nightly/issues/21)
  Add 5.0 variants

  The sandmark-nightly scripts now run 5.0 variants, but, the
  pausetimes with `ocaml/ocaml` needs to be updated.

* [ocaml-bench/sandmark-nightly#42](https://github.com/ocaml-bench/sandmark-nightly/issues/42)
  Alert notification for Sandmark nightly runs

  A daily status summary of the nightly runs should be sent to a
  deployment of `ocaml-matrix` server.

* [ocaml-bench/sandmark-nightly#45](https://github.com/ocaml-bench/sandmark-nightly/issues/45)
  Refactor sandmark-nightly

  A list of changes that are required to clean up the sandmark-nightly
  repository, and move the scripts to Sandmark. Thus, sandmark-nightly
  will just store the data results, and sandmark will have the code.

* [ocaml-bench/sandmark-nightly#48](https://github.com/ocaml-bench/sandmark-nightly/issues/48)
  Numbered list is misaligned in the home page

  The list indentation is incorrect in the home page and it needs to
  be fixed.

* [ocaml-bench/sandmark-nightly#49](https://github.com/ocaml-bench/sandmark-nightly/pull/49)
  Add Sandmark info to sandmark-nightly

  A PR that shows the commit version and branch of Sandmark used in
  the sandmark-nightly in the UI.

### Closed

* [ocaml-bench/sandmark-nightly#27](https://github.com/ocaml-bench/sandmark-nightly/issues/27)
  Include the baseline variant information in the normalised graphs
  
  The normalised graph now includes the information of the baseline
  variant used for comparison.

* [ocaml-bench/sandmark-nightly#34](https://github.com/ocaml-bench/sandmark-nightly/issues/34)
  Parallel benchmarks should be run on `ocaml/ocaml#trunk`
  
  The CI parallel benchmarks execution runs have been switched to run
  for `ocaml/ocaml#trunk`.

* [ocaml-bench/sandmark-nightly#37](https://github.com/ocaml-bench/sandmark-nightly/issues/37)
  Sequential results comparison is broken

  The inclusion of the meta header first line is the .bench output is
  now handled in the UI.

* [ocaml-bench/sandmark-nightly#40](https://github.com/ocaml-bench/sandmark-nightly/issues/40)
  The information in the landing page is out of date
   
  The landing page now displays both `stable` and `trunk` variants
  correctly.

* [ocaml-bench/sandmark-nightly#50](https://github.com/ocaml-bench/sandmark-nightly/pull/50)
  Simple fix for index page to display text properly

  The trailing whitespaces and list indentation have been fixed.

### current-bench

#### Open

##### End Users

* [ocurrent/current-bench#306](https://github.com/ocurrent/current-bench/issues/306)
  WIP ocaml compiler benchmarks

  A high-level issue tracker for building `ocaml/ocaml` compiler
  benchmarks, and necessary tooling with current-bench.

* [ocurrent/current-bench#311](https://github.com/ocurrent/current-bench/issues/311)
  Raspberry Pi long term support

  The Raspberry Pi is now added to the `current-bench` cluster, and
  you can add an entry for the same to `environments/production.conf`
  as shown below:

  ```
  {
  "repositories": [
    {
      "name": "mirage/irmin",
      "worker": "rpi4b",
      "image": "ocaml/opam:debian-11-ocaml-4.12"
    }
  ```

  A way to handle the fan noise during intensive Irmin benchmarks on
  the Raspberry Pi is needed.

##### Enhancement

* [ocurrent/current-bench#312](https://github.com/ocurrent/current-bench/issues/312)
  Time scheduling
  
  A benchmark is run on a new commit, or on the default branch, or for
  a PR. We need to add support to schedule jobs on a timely basis.

* [ocurrent/current-bench#314](https://github.com/ocurrent/current-bench/issues/314)
  Retro-benchmark new repositories

  A feature request to be able to run benchmark results on older
  commits for a newer current-bench deployment.

##### Frontend

* [ocurrent/current-bench#313](https://github.com/ocurrent/current-bench/issues/313)
  Record commits messages

  The commit first-line description needs to be shown along with the
  commit hash in the UI.

* [ocurrent/current-bench#317](https://github.com/ocurrent/current-bench/issues/317)
  Frontend rewrite

  The frontend uses Rescript, and the current plotting library has its
  limitations. An open issue to discuss rewriting the frontend.

* [ocurrent/current-bench#322](https://github.com/ocurrent/current-bench/issues/322)
  Adjust units on comparison commit values tool
  
  The `adjust` function is now called on both the benchmark and the
  comparison values to show the same units.

* [ocurrent/current-bench#323](https://github.com/ocurrent/current-bench/pull/323)
  Allow clicking on the legend to show/hide plot lines and use more columns

  The legend now uses more columns when clicking on the show/hide plot
  in the UI as shown below:
  
  ![Current-bench-PR-323](images/Current-bench-PR-323.png)

* [ocurrent/current-bench#324](https://github.com/ocurrent/current-bench/issues/324)
  Disabled worker / docker image

  The frontend automatically selects the first "environment" (worker +
  Docker image) and the system may contain disabled ones. The
  environment list needs to be filtered for the active entries only.

* [ocurrent/current-bench#326](https://github.com/ocurrent/current-bench/pull/326)
  frontend: Fix bug with using same x-axis for all metrics

  The PR fixes the change to use the correct meta-data for all the
  commits, for every metric in the x-axis.

##### Testing

* [ocurrent/current-bench#316](https://github.com/ocurrent/current-bench/issues/316)
  Real-life testing

  current-bench requires both functional and integration tests for
  checking on failure conditions and to validate the backend pipeline.

* [ocurrent/current-bench#318](https://github.com/ocurrent/current-bench/issues/318)
  Cobench user library

  A validation test interface, when adding new benchmarks, is needed
  to check that the expected JSON output from the `make bench` output
  conforms to the latest schema.

##### Monitoring

* [ocurrent/current-bench#290](https://github.com/ocurrent/current-bench/issues/290)
  Add optional field to JSON

  A request to add an optional field in the JSON object whose values
  can be printed verbatim in the log.

* [ocurrent/current-bench#298](https://github.com/ocurrent/current-bench/issues/298)
  Production logs and warnings

  The filtering of the logs based on a component in the pipeline will
  be useful for troubleshooting and debugging production issues.
  
* [ocurrent/current-bench#319](https://github.com/ocurrent/current-bench/issues/319)
  Github bot messages

  Similar to code coverage reports, it will be nice to produce
  detailed performance regressions results on GitHub PRs.

#### Closed

##### Build

* [ocurrent/current-bench#282](https://github.com/ocurrent/current-bench/pull/282)
  Docker compose for stack deploy
  
  A `docker-compose.yaml` file can now build the backend pipeline and
  frontend stack for deployment.

* [ocurrent/current-bench#301](https://github.com/ocurrent/current-bench/pull/301)
  Worker support for raspberry ARM: add new argument to specify arch

  The architecture argument has been added to the `run_command`
  function to allow the use of Raspberry Pi ARM as a worker.
  
* [ocurrent/current-bench#305](https://github.com/ocurrent/current-bench/pull/305)
  Update `ocamlformat` version to `0.20.1`

  The `ocamlformat` version has been updated from `0.19.0` to `0.20.1`.

##### Enhancement

* [ocurrent/current-bench#289](https://github.com/ocurrent/current-bench/pull/289)
  Fix URL missing pull number

  The URL should contain the PR number when redirecting to add the
  worker or Docker image.

* [ocurrent/current-bench#292](https://github.com/ocurrent/current-bench/pull/292)
  Return better HTTP error codes for API requests

  The client requests now receive correct HTTP error codes for
  exception handling.

##### Frontend

* [ocurrent/current-bench#293](https://github.com/ocurrent/current-bench/pull/293)
  Make log links noticeable by removing log ID from link text

  A link to view the build and execution logs is now provided in the
  UI, instead of the log UUIDs.

  ![Current-bench-PR-293](images/Current-bench-PR-293.png)

* [ocurrent/current-bench#299](https://github.com/ocurrent/current-bench/pull/299)
  Fix GitHub status update: wait for benchmark to terminate

  The GitHub status of the application should show a green "pass"
  state only after the successful execution of the benchmarks.
    
* [ocurrent/current-bench#308](https://github.com/ocurrent/current-bench/pull/308)
  frontend: Fix incorrect GraphQL query for default benchmark 

  The default benchmark now has a name instead of NULL to satisfy
  PostgreSQL's UNIQUE constraint.

* [ocurrent/current-bench#309](https://github.com/ocurrent/current-bench/pull/309)
  Make it easier to go back to "home page" from error view

  A side bar has been added to the error view for easier navigation.

* [ocurrent/ocurrent#309](https://github.com/ocurrent/ocurrent/pull/309)
  Show line numbers and allow jumping to specific lines in job logs
  
  A URL like
  http://localhost:8080/job/2022-02-09/115753-docker-build-71c777#L11-L15
  would highlight lines 11 to 15 and scroll the page to line 11 as
  illustrated below:
  
  ![OCurrent-PR-309](images/OCurrent-PR-309.png)

* [ocurrent/current-bench#320](https://github.com/ocurrent/current-bench/pull/320)
  Show all commits for all metrics and highlight failed metrics

  The metrics that do not have a value for the latest commit are
  considered failed commits, but, all the metrics are shown in the
  UI. The graphs are also made full width and aligned vertically as
  shown below:

  ![Current-bench-PR-320](images/Current-bench-PR-320.png)

* [ocurrent/current-bench#325](https://github.com/ocurrent/current-bench/pull/325)
  Display old commit benchmarks warning irrespective of build status

  The UI now shows the old commit benchmarks warnings.

##### Testing

* [ocurrent/current-bench#294](https://github.com/ocurrent/current-bench/pull/294)
  Add unit tests

  A `pipeline/tests` folder has been created with unit tests, and you
  can run them from the `pipeline/` directory as follows:
  
  ```
  $ dune runtest
  $ dune exec tests/test.exe
  ```

* [ocurrent/current-bench#307](https://github.com/ocurrent/current-bench/pull/307)
  Add coverage using bisect_ppx

  The Makefile now includes a `coverage` target that uses
  `bisect_ppx`, and generates a HTML coverage report.

##### Sundries

* [ocurrent/current-bench#281](https://github.com/ocurrent/current-bench/pull/281)
  Document how to add workers
  
  The `HACKING.md` file has been updated with information on how to
  add new workers to the cluster, and configuration of remote workers
  to run the benchmarks.

* [ocurrent/current-bench#295](https://github.com/ocurrent/current-bench/pull/295)
  Fix benchmark name unique constraint

  PostgreSQL does not consider NULL values to be equal and hence the
  conflict on UNIQUE constraint for the benchmark name does not get
  triggered. This creates duplicate rows in the database, and this PR
  provides fixes at the application and the database level.
  
* [ocurrent/current-bench#296](https://github.com/ocurrent/current-bench/pull/296)
  Capture line numbers of where metrics appear in the logs

  The line numbers of the metrics from the logs are now captured in
  the database.
  
* [ocurrent/current-bench#303](https://github.com/ocurrent/current-bench/pull/303)
  Run DB migrations on pipeline start

  The database migrations are now run prior to starting the
  application, which were earlier defined in a `make` target.

* [ocurrent/current-bench#304](https://github.com/ocurrent/current-bench/pull/304)
  Update deprecated Term functions

  The `cmdliner.1.1.0` package has been updated along with changes to
  remove the use of the deprecated `Term` functions.

Our special thanks to all the OCaml users, developers and contributors
in the community for their valuable time and continued support to the
project.

## Acronyms

* AFL: American Fuzzy Lop
* AMD: Advanced Micro Devices
* API: Application Programming Interface
* ARM: Advanced RISC Machines
* AWK: Aho Weinberger Kernighan
* BSD: Berkeley Software Distribution
* CI: Continuous Integration
* CTF: Common Trace Format
* DB: Database
* EOL: End Of Life
* FD: File Descriptor
* FFI: Foreign Function Interface
* GC: Garbage Collector
* GNU: GNU's Not Unix
* HTTP: Hypertext Transfer Protocol
* IO: Input/Output
* IR: Intermediate Representation
* JSON: JavaScript Object Notation
* MD: Markdown
* OPAM: OCaml Package Manager
* POSIX: Portable Operating System Interface
* PR: Pull Request
* RHEL: Red Hat Enterprise Linux
* STW: Stop The World
* UDP: User Datagram Protocol
* UI: User Interface
* URL: Uniform Resource Locator
* UUID: Universally Unique Identifier
* VM: Virtual Machine
* WSL: Windows Subsystem for Linux
