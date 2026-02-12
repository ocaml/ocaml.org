---
title: OCaml Multicore - March 2022
description: Monthly update from the OCaml Multicore team.
date: "2022-03-01"
tags: [multicore]
---

Welcome to the March 2022 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by me, @ctk21, @kayceesrk and @shakthimaan.

We have continued steadily towards making a stable OCaml 5.0 release, as you can see from the long list of fixes later -- thank you for all your contributions! Platform configurations that were formerly supported in the 4.x branches for OpenBSD, FreeBSD, and NetBSD have now been re-enabled. ARM64 support (for macOS, Linux and the BSDs) is stable in trunk, and ARM CFI integration has been merged as a follow-up to facilitate debugging and profiling. Notably, this also includes [memory model tests for ARMv8 and Power ports](https://github.com/ocaml/ocaml/pull/11004). The Windows mingw64 port is also working again in trunk. 

An [effects tutorial](https://github.com/ocaml/ocaml/pull/11093) has also been contributed to the OCaml manual; feedback continues to be welcome even after it's merged in.  As you experiment with effects, please do continue to post to this forum with questions or comments about your learnings.

The Sandmark benchmark project has added bytecode analysis to address any performance regressions. We have also been working on obtaining measurements for the compilation data points. The current-bench pipeline production deployments has significant UI changes, and now has alert notifications for the benchmark runs.

As always, the Multicore OCaml open and completed tasks are listed first, which are then followed by the ecosystem tooling projects. The Sandmark, sandmark-nightly, and current-bench project updates are finally presented for your reference.

## Multicore OCaml

### Open

#### Discussion

* [ocaml/ocaml#10960](https://github.com/ocaml/ocaml/issues/10960)
  Audit `stdlib` for mutable state
  
  The mutable state for the Stdlib modules is actively being tracked
  in this issue, since the OCaml 5.0.0 implementation should be both
  memory and thread-safe.

* [ocaml/ocaml#11013](https://github.com/ocaml/ocaml/issues/11013)
  Meta-issue for OCaml 5.0 release goals

  An issue tracker that contains a checklist for branching OCaml 5.0.

* [ocaml/ocaml#11074](https://github.com/ocaml/ocaml/issues/11074)
  OCaml 5.0 & unhandled exceptions

  A question and discussion on how unhandled exceptions should be
  handled in OCaml 5.0.

#### Bug

* [ocaml/ocaml#10868](https://github.com/ocaml/ocaml/pull/10868)
  Fix off-by-1 bug when initializing frame hashtables

  The PR for `runtime/frame_descriptors.c` that fixes on off-by-1 bug
  when initializing frame hashtables is ready to be merged.

* [ocaml/ocaml#11040](https://github.com/ocaml/ocaml/issues/11040)
  `ThreadSanitizer` issues

  An issue tracker that contains list of `ThreadSanitizer` runs from
  `tests/parallel` execution for troubleshooting race conditions.

* [ocaml/ocaml#11144](https://github.com/ocaml/ocaml/pull/11144)
  Restore frame-pointers support for amd64

  A work-in-progress to re-introduce the lost frame-pointers support
  for AMD64 architecture, since the same was partially lost with the
  Multicore merge.

#### Build

* [ocaml/ocaml#10315](https://github.com/ocaml/ocaml/issues/10315)
  [Build] Support for composing the compiler in a dune build

  A request to use the Dune build system to build the OCaml
  compiler. This will be useful for Multicore OCaml ecosystem
  development as well.

* [ocaml/ocaml#10505](https://github.com/ocaml/ocaml/pull/10505)
  [RFC] Require 1003.1-2008 for libunix

  A draft PR that updates the build to be compliant with The Open
  Group Base Specification Issue 6 and 7, IEEE Std 1003.1-2008.

* [ocaml/ocaml#11096](https://github.com/ocaml/ocaml/pull/11096)
  Enable native code on FreeBSD/aarch64

  The `configure.ac` has been updated to build natively on
  FreeBSD/aarch64.

* [ocaml/ocaml#11097](https://github.com/ocaml/ocaml/pull/11097)
  Fix support for NetBSD and enable native code on NetBSD/aarch64

  The support for native builds on NetBSD/aarch64 has been enabled.

* [ocaml/ocaml#11143](https://github.com/ocaml/ocaml/pull/11143)
  Test 32-bit build in GitHub Actions

  An `i386` entry in `.github/workflows/build.yml` has been added to
  test 32-bit builds with GitHub Actions.

* [ocaml/ocaml#11149](https://github.com/ocaml/ocaml/pull/11149)
  Make the bootstrap process repeatable

  The PR enables the `make bootstrap` step to produce the exact same
  images in `boot/ocamlc` and `boot/ocamllex`, irrespective of the OS
  and architecture.

#### Enhancement

* [ocaml/ocaml#11057](https://github.com/ocaml/ocaml/pull/11057)
  Implement quality treatment for asynchronous actions in multicore

  A work-in-progress that reimplements the `caml_process_pending`
  behaviour, and provides code improvements to the asynchronous
  actions in the Multicore runtime.

* [ocaml/ocaml#11095](https://github.com/ocaml/ocaml/pull/11095)
  Implement quality treatment for asynchronous actions in multicore (1/N)

  A first set of commits as a follow-up to the [Implement quality
  treatment for asynchronous actions in
  Multicore](https://github.com/ocaml/ocaml/pull/11057)" PR.

* [ocaml/ocaml#11110](https://github.com/ocaml/ocaml/pull/11110)
  More ThreadSanitizer atomics and ignorelist

  An ignorelist has been added to ThreadSanitizer for `Field` and
  `Tag_val` race conditions. A `CAMLno_tsan`, with a justification for
  no race condition for specific functions, has been added along with
  relaxed atomics.

* [ocaml/ocaml#11137](https://github.com/ocaml/ocaml/pull/11137)
  Introduce `Store_tag_val(dst, val)` and use it in the runtime

  The runtime code does not depend on `Tag_val` as an lvalue, and
  hence `Store_tag_val(dst,val)` is introduced in `runtime/alloc.c`.

* [ocaml/ocaml#11138](https://github.com/ocaml/ocaml/pull/11138)
  Add C function `caml_thread_has_lock`

  Any C thread can now call the function `caml_thread_has_lock`, and
  it returns true if the thread belongs to a domain and also holds the
  lock for the same.

* [ocaml/ocaml#11142](https://github.com/ocaml/ocaml/pull/11142)
  `Gc.set` now changes the minor heap size of all domains

  A draft PR to adjust the semantics of `Gc.set` to set the minor
  heap size for all domains.

* [ocaml/ocaml#11154](https://github.com/ocaml/ocaml/issues/11154)
  Add `Domain.get_name`

  A feature request to include `get_name` in the `Domain` module,
  since the API already contains a `set_name`.

* [ocaml/ocaml#11156](https://github.com/ocaml/ocaml/issues/11156)
  Post-5.00 API for changing minor heap size

  The proposed suggestions for changing the minor heap size of all
  domains post-5.00 API.

#### Documentation

* [ocaml/ocaml#10992](https://github.com/ocaml/ocaml/issues/10992)
  OCaml multicore memory model and C (runtime, FFI, VM)

  The document on the OCaml Multicore memory model and the use of the
  `Field` macro is actively being revised and updated.

* [ocaml/ocaml#11058](https://github.com/ocaml/ocaml/pull/11058)
  `runtime/HACKING.adoc`: tips on debugging the runtime

  The `HACKING.adoc` document with information on the runtime system,
  and the `runtime/HACKING.adoc` file that explains troubleshooting is
  ready to be merged.

* [ocaml/ocaml#11093](https://github.com/ocaml/ocaml/pull/11093)
  Effects manual

  The PR adds an effect handlers tutorial to the manual. The rendered
  web page is at https://kcsrk.info/webman/manual/effects.html.

#### Testing

* [ocaml/ocaml#10980](https://github.com/ocaml/ocaml/issues/10980)
  GitHub Actions / ocamltest / testsuite / OCaml 5

  An issue tracker that contains a list of action items related to
  ocamltest and OCaml 5.

* [ocaml/ocaml#11065](https://github.com/ocaml/ocaml/pull/11065)
  Restore basic functionality to the bytecode debugger

  The PR to handle stack backtraces is working now, and a separate PR
  will be created to handle the `next` instruction.

* [ocaml/ocaml#11121](https://github.com/ocaml/ocaml/issues/11121)
  `weaklifetime_par.ml` gets killed by OS's OOM-reaper on Raspberry Pi 4

  A testsuite failure report on ARM64-backend on a Raspberry Pi 4 with
  2GB of memory.
  
#### Performance

* [ocaml/ocaml#10964](https://github.com/ocaml/ocaml/pull/10964)
  Ring-buffer based runtime tracing (`eventring`)
  
  The Eventring runtime tracing system designed for continuous
  monitoring of OCaml applications is actively being reviewed.
  
* [ocaml/ocaml#11090](https://github.com/ocaml/ocaml/issues/11090)
  Program name usability issue

  A usability regression issue with Multicore runtime where `top`
  reports OCaml programs as `Domain0`.

* [ocaml/ocaml#11125](https://github.com/ocaml/ocaml/issues/11125)
  Runtime events for minor heap reservation / allocation 

  The runtime events that log the allocated sizes and critical
  sections should be emitted for the minor heap reservation and
  allocation functions.

### Closed

#### Enhancement

* [ocaml/ocaml#10802](https://github.com/ocaml/ocaml/pull/10802)
  Use 4.12 value macros in C code

  The for loop style is used for list-walking, and `Val_int(0)` now
  means an integer of value 0.

* [ocaml/ocaml#10958](https://github.com/ocaml/ocaml/pull/10958)
  Only rebuild `flexlink.exe` when sources change

  The Makefile has been updated to only build `flexdll/flexlink.exe`
  when the sources have been modified.

* [ocaml/ocaml#10971](https://github.com/ocaml/ocaml/issues/10971)
  Means of limiting how much memory is being reserved by the runtime,
  so that Valgrind and AFL can be used
  
  The `max_domains` value can now be set from `OCAMLRUNPARAM` to limit
  the memory usage, and to provide a good balance between usability
  and complexity in the implementation.

* [ocaml/ocaml#10991](https://github.com/ocaml/ocaml/pull/10991)
  Use `zstd` for CI artifacts upload and download

  The upload and download time of CI artifacts are improved with the
  use of `zstd` compression.

* [ocaml/ocaml#11078](https://github.com/ocaml/ocaml/pull/11078)
  Relax `caml_initialize` assertion in the debug runtime

  The assertion checks in `caml_initialize` are relaxed to not impede
  the debug runtime throughput.

* [ocaml/ocaml#11082](https://github.com/ocaml/ocaml/pull/11082)
  Reserve only `caml_minor_heap_max_wsz` * `Max_domains` for the minor heap

  The initial minor heap size reservation is `s * Max_domains`, and
  domains can use `Gc.set` to increase their minor heap size beyond
  the reservation. The size of the reservation is always
  `caml_minor_heap_max_wsz` * `Max_domains`.

* [ocaml/ocaml#11123](https://github.com/ocaml/ocaml/pull/11123)
  Gc stats: major collections count

  The use of `Caml_state->stat_major_collections` is removed and
  `caml_major_cycles_completed` global value is used to report
  statistics, as mentioned in the documentation.

* [ocaml/ocaml#11158](https://github.com/ocaml/ocaml/pull/11158)
  Factor out reading `OCAMLTOP_INCLUDE_PATH` in `ocaml/ocamlnat`

  The identical code in `ocaml` and `ocamlnat` for parsing
  `OCAMLTOP_INCLUDE_PATH` has been refactored.

#### Fixes

* [ocaml/ocaml#11037](https://github.com/ocaml/ocaml/pull/11037)
  Assorted fixes found while restarting the Jenkins CI

  The PR includes a number of fixes such as update to the Jenkins CI
  "main" script to better handle bytecode-only builds, updates to the
  test suite, configuration tweaks and changes to the runtime system.

* [ocaml/ocaml#11054](https://github.com/ocaml/ocaml/pull/11054)
  Respect user provided maximum stack space value, and fix debug run of `tmp/stack_space.ml` test

  This PR honors `OCAMLRUNPARAM=1` for the initial stack size, and
  ensures that `tmc/stack_space.ml` applies stack restriction during
  the running stage.

* [ocaml/ocaml#11061](https://github.com/ocaml/ocaml/issues/11061)
  `dumpobj` tool crashes

  A fix for the segmentation fault from `tools/dumpobj` on a bytecode
  program has been merged in
  [PR#11077](https://github.com/ocaml/ocaml/pull/11077).

* [ocaml/ocaml#11076](https://github.com/ocaml/ocaml/pull/11076)
  Adjust stack parameters for bytecode to avoid generating too many calls to `caml_ensure_stack_capacity`

  The stack "safety margin" has been decreased to 6 and the stack
  threshold has been increased to 32. Most bytecode functions use no
  more than 32 - 6 stack slots, and this provides a quick fix for the
  byte code regressions.

* [ocaml/ocaml#11077](https://github.com/ocaml/ocaml/pull/11077)
  Fix `dumpobj` crash due to naked pointer comparison

  The use of `(==)` instead of `(=)` in `dumpobj` fixes the crash in
  the generic comparison function that supported naked pointers.

* [ocaml/ocaml#11094](https://github.com/ocaml/ocaml/issues/11094)
  Domainslib producing segfaults

  A patch for the segmentation fault in fiber management fixes the
  segmentation fault caused when using domainslib on parallel programs
  with Sandmark.

* [ocaml/ocaml#11105](https://github.com/ocaml/ocaml/pull/11105)
  Fix segfault in fiber management (issue #11094)

  An integer index into an array of lists is now maintained, instead
  of a pointer to the cache in fiber management. This fixes the
  segmentation fault reported when building parallel benchmarks with
  domainslib in Sandmark.

* [ocaml/ocaml#11141](https://github.com/ocaml/ocaml/pull/11141)
  Fix 32-bit build

  The `runtime/gc_ctrl.c` has been updated to use
  `ARCH_INTNAT_PRINTF_FORMAT` to build for 32-bit.

#### Testing

* [ocaml/ocaml#10953](https://github.com/ocaml/ocaml/issues/10953)
  `ocamltest/summarize.awk` not properly reporting abort failures on testsuite runs

  The [PR#11088](https://github.com/ocaml/ocaml/pull/11088) and
  [PR#11100](https://github.com/ocaml/ocaml/pull/11100) have been
  merged to handle the failing test runs with `summarize.awk`.

* [ocaml/ocaml#11084](https://github.com/ocaml/ocaml/pull/11084)
  Disable `test_cow_repeated` in the `lib-dynlink-private` testcase when running with the debug runtime

  The `testsuite/tests/lib-dynlink-private/test.ml` has been updated
  to disable `test_cow_repeated` with the debug runtime.

* [ocaml/ocaml#11004](https://github.com/ocaml/ocaml/pull/11004)
  Memory model tests

  A new sub-directory in `testsuite` containing the memory model tests
  has been merged. These are useful for the ARMv8 and Power ports.

* [ocaml/ocaml#11088](https://github.com/ocaml/ocaml/pull/11088)
  `summarize.awk`: should fail when ocamltest result is not understood

  The handling of unexpected results from an ocamltest run in
  `summarize.awk` have been fixed.

* [ocaml/ocaml#11099](https://github.com/ocaml/ocaml/pull/11099)
  ARM64 CFI support

  The unwind on ARM64 for the CFI commands now work, and
  `tests/unwind` pass on both MacOS x86_64 and ARM64.

* [ocaml/ocaml#11124](https://github.com/ocaml/ocaml/pull/11124)
  Fix `weaklifetime_par.ml`

  A series of fixes to fix the `weaklifetime_par.ml` implementation
  that causes test suite failures or Raspberry Pi 4.

#### Windows

* [ocaml/ocaml#10884](https://github.com/ocaml/ocaml/issues/10884)
  Fix closure marshalling from Dynlink-loaded code on Windows

  The registration of empty code fragments in natdynlink has been
  stopped, and `caml_skiplist_insert` updates the data pointer if the
  key is a duplicate.

* [ocaml/ocaml#10908](https://github.com/ocaml/ocaml/pull/10908)
  Fix possible race in `caml_mem_map` on Windows

  A race condition when trimming the memory block has been fixed, and
  printf debugging from the concurrent minor collector in `platform.c`
  has been cleaned up.

* [ocaml/ocaml#11115](https://github.com/ocaml/ocaml/pull/11115)
  Fix performance regression in systhreads on Windows

  The tick thread calls `caml_thread_yield` on the Windows version of
  `select` which was causing performance regressions. The `Sleep`
  function is used instead and the performance differences are
  noticeable as shown below:
  
  ```
  Test                            before/s     run1/s       run2/s
  lib-threads/sieve               5.36         3.18         2.47
  parallel/fib_threads            137.52       62.29        63.95
  parallel/multicore_systhreads   20.2         11.88        11.08
  ```

* [ocaml/ocaml#11116](https://github.com/ocaml/ocaml/pull/11116)
  Fix `tool-dumpobj` test on Windows

  The mingw-64 runs on Inria's CI are fixed with the update to
  `tool-dumpobj/test.run`.

#### Documentation

* [ocaml/ocaml#11008](https://github.com/ocaml/ocaml/pull/11008)
  Document and refactor the gc-stats code

  The `runtime/caml/gc_stats.h` and `runtime/gc_stat.c` code have been
  refactored and documented.

* [ocaml/ocaml#11072](https://github.com/ocaml/ocaml/pull/11072)
  domain.c: document the STW synchronization code

  The STW synchronization code has been documented in `domain.c`.

* [ocaml/ocaml#11073](https://github.com/ocaml/ocaml/issues/11073)
  Code comprehension: why don't STW sections keep `all_domains_lock` the whole time?

  The STW synchronization code has been documented in `domain.c` in
  [PR#11072](https://github.com/ocaml/ocaml/pull/11072).

* [ocaml/ocaml#11120](https://github.com/ocaml/ocaml/issues/11120)
  Man entries for warnings 69, 70, 71 and 72 are missing

  The manual entries are listed in the output of `man ocamlc`, and the
  warnings for 69, 70, 71 and 72 have been added.

* [ocaml/ocaml#11122](https://github.com/ocaml/ocaml/pull/11122) 
  Fix typo in Stdlib documentation comment

  A typo in `stdlib/stdlib.mli` has been fixed.

#### Sundries

* [ocaml/ocaml#11092](https://github.com/ocaml/ocaml/pull/11092)
  Enable native code on `aarch64-*-openbsd*`

  OCaml builds fine on `OpenBSD/aarch64`.

* [ocaml/ocaml#11112](https://github.com/ocaml/ocaml/pull/11112)
  Harden `-use-runtime` against spaces in paths

  The PR ensures that spaces in the paths specified with
  `-use-runtime` work as expected.

* [ocaml/ocaml#11047](https://github.com/ocaml/ocaml/pull/11047)
  GC stats: properly orphan allocation stats

  An orphaning process for allocation statistics has been implemented
  in this PR, where the "orphan stats" are stored in a global
  `structure alloc_stats` variable in `gc_stats.c`. On domain
  termination, the stats of the current domain are added to the
  "orphan stats".

* [ocaml/ocaml#10925](https://github.com/ocaml/ocaml/pull/10925)
  Rename symbol for `Caml_state` to `caml_state`
  
  The `Caml_state` macro has been renamed to `caml_state` to avoid a
  name collision.

* [ocaml/ocaml#10989](https://github.com/ocaml/ocaml/pull/10989)
  Download GNU parallel directly from git

  The `tools/ci/appveyor/appveyor_build.sh` has been updated to
  download GNU parallel with Git.

## Ecosystem

### Eio

#### Open

* [ocaml-multicore/eio#206](https://github.com/ocaml-multicore/eio/issues/206)
  API request: `readdir`

  A new API request to list the contents of the directory, since
  `Eio.Dir.t` already exists.

* [ocaml-multicore/eio#207](https://github.com/ocaml-multicore/eio/pull/207)
  Add readdir feature

  A draft PR that provides an implementation of `readdir` feature for
  Eio, and also to discuss its API.

* [ocaml-multicore/eio#208](https://github.com/ocaml-multicore/eio/pull/208)
  Update the README to use OCaml 5.0

  A suggestion to update the README to use OCaml 5.0.

#### Completed

* [ocaml-multicore/eio#205](https://github.com/ocaml-multicore/eio/pull/205)
  Prepare release

  The sources have been upgraded to depend on `uring.0.3`, and the
  `CHANGES.md` has been updated for a release.

### domainslib

#### Open

* [ocaml-multicore/domainslib#68](https://github.com/ocaml-multicore/domainslib/issues/68)
  Scope of domainslib

  A feature request to have `mpsc queues`, `concurrent hashmap` and
  more concurrency building blocks in domainslib.

* [ocaml-multicore/domainslib#69](https://github.com/ocaml-multicore/domainslib/pull/69)
  Make `Chan.t` and `Task.promise` injective

  The injectivity annotations with type constructors can be usable as
  indexes of GADTs, in particular `Effect.t`.

#### Completed

* [ocaml-multicore/domainslib#65](https://github.com/ocaml-multicore/domainslib/pull/65)
  Fix build on trunk

  The `Effect.eff -> Effect.t` change has been updated to build for
  trunk, and the CI builds for `5.0.0+trunk`.

* [ocaml-multicore/domainslib#66](https://github.com/ocaml-multicore/domainslib/issues/66)
  `Domainslib.0.4.1` build failure with `OCaml 5.0.0+trunk`

  A newer release of `domainslib.0.4.2` has been updated to build with
  OCaml 5.0.0+trunk.

* [ocaml-multicore/domainslib#67](https://github.com/ocaml-multicore/domainslib/pull/67)
  Fix `Task.parallel_for_reduce` on empty loop

  A corner-case for an empty loop is now correctly handled for
  `Task.parallel_for_reduce` in `lib/task.ml`.

### Sundries

#### Open

* [ocaml-multicore/effects-examples#27](https://github.com/ocaml-multicore/effects-examples/pull/27)
  Add GitHub workflow for testing

  A `.github/workflows/ci.yml` has been added for CI testing.

* [ocaml-multicore/ocaml-uring#55](https://github.com/ocaml-multicore/ocaml-uring/issues/55)
  FD passing `sendmsg` fails on WSL2

  An `EINVAL` is returned on the latest WSL kernel when the FD passing
  `sendmsg` examples fail.

#### Closed

* [ocaml-multicore/kcas#12](https://github.com/ocaml-multicore/kcas/pull/12)
  Clean up dependencies

  The dependencies have been removed from `kcas.opam`, except for
  dune. The Makefile has been updated, and the old ocamlbuild
  .mllib-file has been removed.

* [ocaml-multicore/retro-httpaf-bench#19](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/19)
  cohttp-eio: add cohttp-eio based benchmark

  A `cohttp_eio` benchmark has been added with updates to the
  benchmarking scripts.

* [ocaml-multicore/retro-httpaf-bench#23](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/23)
  Update to Eio 0.2

  The `retro-httpaf-bench` Dockerfile has been updated to use Eio 0.2.

* [ocaml-multicore/effects-examples#26](https://github.com/ocaml-multicore/effects-examples/pull/26)
  Port to OCaml 5.00

  The `effects-examples` have now been ported to run on OCaml
  5.0.0+trunk, without the dedicated effects syntax.

## Benchmarking

### Sandmark

#### Open

##### Benchmarks

* [ocaml-bench/sandmark#119](https://github.com/ocaml-bench/sandmark/issues/119)
  Additional benchmarks - hamming and soli

  A draft version of the `hamming.ml` and `soli.ml` benchmarks have
  been added to Sandmark.

* [ocaml-bench/sandmark#299](https://github.com/ocaml-bench/sandmark/issues/299)
  Irmin 3 benchmarks

  A request to update the Sandmark Irmin benchmark which replays the
  access patterns for Tezos.

* [ocaml-bench/sandmark#319](https://github.com/ocaml-bench/sandmark/pull/319)
  Added two serial benchmarks namely: hamming and soli with their respectively
  
  The PR adds the Hamming and Soli sequential benchmarks to Sandmark.

##### CI

* [ocaml-bench/sandmark#275](https://github.com/ocaml-bench/sandmark/issues/275)
  Move from drone CI to GitHub actions

  The CI jobs from .drone.yml need to be migrated to run with GitHub
  Actions workflow.

* [ocaml-bench/sandmark#316](https://github.com/ocaml-bench/sandmark/pull/316)
  main.yml

  A new `.github/workflows/main.yml` GitHub Actions file has been
  added to run in the CI.

##### Dependencies

* [ocaml-bench/sandmark#18](https://github.com/ocaml-bench/sandmark/issues/18)
  `js_of_ocaml` fails to run on multicore

  A draft PR to build `js_of_ocaml` in Sandmark for Multicore OCaml
  has been created.

* [ocaml-bench/sandmark#262](https://github.com/ocaml-bench/sandmark/issues/262)
  ocaml-migrate-parsetree.2.2.0+stock fails to compile with ocaml.5.00.0+trunk

  `ocaml-migrate-parsetree` is no longer required for trunk with
  [ppxlib.0.25.0~5.00preview](https://ocaml.org/p/ppxlib/0.25.0~5.00preview).

* [ocaml-bench/sandmark#310](https://github.com/ocaml-bench/sandmark/pull/310)
  Remove `js_of_ocaml`
  
  A work-in-progress to build `js_of_caml-compiler` with
  `5.0.0+trunk`, as `frama-c` is not compatible with ocaml/ocaml.

##### Sundries

* [ocaml-bench/sandmark#272](https://github.com/ocaml-bench/sandmark/issues/272)
  Delay benchmark runs if the machine is active

  A load average check for threshold 0.6 needs to be verified before
  running the benchmarks.

* [ocaml-bench/sandmark#302](https://github.com/ocaml-bench/sandmark/issues/302)
  Renaming suggestions for `*run_config.json` files

  The current `*run_config.json` files need to be renamed as follows:
  
  * `run_config.json` -> `sequential.json`
  * `multicore_parallel_run_config.json` -> `parallel_turing.json`
  * `multicore_parallel_navajo_run_config.json` -> `parallel_navajo.json`
  * `micro_multicore.json` -> `micro.json`

* [ocaml-bench/sandmark#309](https://github.com/ocaml-bench/sandmark/issues/309)
  Outreachy Applicants:  set-up and how-to

  Sandmark is participating in the Outreachy program, and the
  necessary setup and how-to instructions to get started on the
  project have been provided.

* [ocaml-bench/sandmark#315](https://github.com/ocaml-bench/sandmark/pull/315)
  Rename Json Files

  A PR to rename the current `*run_config.json` files to be more
  meaningful for their intended purpose.

* [ocaml-bench/sandmark#317](https://github.com/ocaml-bench/sandmark/pull/317)
  Add checks for `loadavg`

  An ongoing PR to add a `loadavg` check to ensure that the server is
  not busy before actually running the benchmarks.

#### Closed

##### Bytecode

* [ocaml-bench/sandmark#282](https://github.com/ocaml-bench/sandmark/issues/282)
  Analyse Bytecode Performance

  The `run_config_byte.json` file now allows you to run byte code
  version of the Sandmark benchmarks.

* [ocaml-bench/sandmark#298](https://github.com/ocaml-bench/sandmark/pull/298)
  Support to build and run benchmarks in byte mode

  A `run_config_byte.json` file has been added to build and run the
  benchmarks in byte mode. You can test the same using:
  
  ```
  $ USE_SYS_DUNE_HACK=1 SANDMARK_CUSTOM_NAME=5.00.0 BUILD_BENCH_TARGET=bytebench \
      RUN_CONFIG_JSON=run_config_byte.json make ocaml-versions/5.00.0+trunk.bench 
  ```

##### Notebooks

* [ocaml-bench/sandmark#279](https://github.com/ocaml-bench/sandmark/issues/279)
  Update notebooks/ To 5.00.0+trunk

  The Jupyter notebooks in the notebooks/ folder have been updated to
  use 5.0.0+trunk.

* [ocaml-bench/sandmark#301](https://github.com/ocaml-bench/sandmark/pull/301)
  Port sandmark nightly UI to sandmark notebooks

  The Sandmark-nightly UI changes have been ported to the Sandmark
  notebooks/ and work with `5.0.0+trunk` OCaml variant.

* [ocaml-bench/sandmark#305](https://github.com/ocaml-bench/sandmark/pull/305)
  re-enable disabled benchmarks

  The filter check that disabled `alt-ergo`, `frama-c` and
  `js_of_ocaml` benchmarks have been enabled in the Jupyter notebooks.

##### Enhancement

* [ocaml-bench/sandmark#274](https://github.com/ocaml-bench/sandmark/issues/274)
  Custom Variant Support

  The feature request to specify developer branches, configure
  options, runtime parameters, a name for the OCaml variant,
  dependency package overrides, package removal list, and an expiry
  date until which the Sandmark nightly runs should occur has been
  merged to Sandmark.

* [ocaml-bench/sandmark#286](https://github.com/ocaml-bench/sandmark/issues/286)
  Update `check_url` and validate URL in custom.json files

  The `check_url` target in the Makefile checks if a URL is present
  for each and every entry in the `custom.json` file, and also if the
  URL contains a downloadable file.

* [ocaml-bench/sandmark#297](https://github.com/ocaml-bench/sandmark/pull/297)
  Added dynamic package override and removal for Custom Support Variant

  The ability to override and remove dependency packages dynamically
  is now supported with the Custom Support Variant feature.

* [ocaml-bench/sandmark#306](https://github.com/ocaml-bench/sandmark/pull/306)
  Update `check_url` and added `check_jq`
  
  A `check_jq` functionality has been added in the Makefile to verify
  that the config.json files can be parsed by jq. The `check_url` now
  verifies that the provided URL is downloadable with wget.

* [ocaml-bench/sandmark#307](https://github.com/ocaml-bench/sandmark/pull/307)
  Use pristine sandmark clone for each build

  A fresh clone of Sandmark is used now before each and every
  sandmark-nightly run, instead of relying on `make clean`.

##### Sundries

* [ocaml-bench/sandmark#300](https://github.com/ocaml-bench/sandmark/pull/300)
  Use 5.0.0+trunk name and version

  Sandmark OCaml variants have been updated to use the `5.0.0+trunk`
  name and version number.

* [ocaml-bench/sandmark#304](https://github.com/ocaml-bench/sandmark/issues/304)
  Parallel benchmarks get killed with `SEGV` with `trunk` and `domainslib.0.4.2`

  The [PR#11105](https://github.com/ocaml/ocaml/pull/11105) fix in the
  fiber management resolves the segmentation fault caused in parallel
  benchmarks with trunk and `domainslib.0.4.2`.

* [ocaml-bench/sandmark#308](https://github.com/ocaml-bench/sandmark/pull/308)
  Move nightly scripts to Sandmark

  The nightly cron run scripts from `sandmark-nightly` have been moved
  to `sandmark`.

* [ocaml-bench/sandmark#312](https://github.com/ocaml-bench/sandmark/pull/312)
  Removed failure:ignore

  The `failure:ignore` option has been removed from `.drone.yml` CI as
  `5.0.0+trunk` builds are stable now.

### Sandmark-nightly

#### Closed

* [ocaml-bench/sandmark-nightly#5](https://github.com/ocaml-bench/sandmark-nightly/issues/5)
  Status of disabled benchmarks

  The Jupyter notebooks in Sandmark have been ported with the changes
  from sandmark-nightly, and the benchmarks have been enabled.

* [ocaml-bench/sandmark-nightly#41](https://github.com/ocaml-bench/sandmark-nightly/issues/41)
  Show Sandmark branch and version in the UI

  The UI now shows the Sandmark branch and version number in building
  and running the benchmarks.

* [ocaml-bench/sandmark-nightly#48](https://github.com/ocaml-bench/sandmark-nightly/issues/48)
  Numbered list is misaligned in the home page

  The list indentation has been fixed in the home page.

* [ocaml-bench/sandmark-nightly#49](https://github.com/ocaml-bench/sandmark-nightly/pull/49)
  Add Sandmark info to sandmark-nightly

  The commit version and branch of Sandmark used in the
  sandmark-nightly runs are displayed in the UI.

* [ocaml-bench/sandmark-nightly#52](https://github.com/ocaml-bench/sandmark-nightly/issues/52)
  Resize UI to show the full OCaml variant name

  The OCaml variant name width has been enlarged to show the full name
  in the UI.

* [ocaml-bench/sandmark-nightly#53](https://github.com/ocaml-bench/sandmark-nightly/pull/53)
  Show benchmarks in a table to read the tooltip

  The selected benchmarks are displayed as a table and tooltip support
  has been added.

![Sandmark-nightly-PR-53-tooltip|690x113](upload://wZfG5XZk1huIdWQklOmSKLrj4y5.png)

* [ocaml-bench/sandmark-nightly#54](https://github.com/ocaml-bench/sandmark-nightly/pull/54)
  Hide instrumented runtime pages

  The instrumented runtime is currently not used, and hence the
  respective pages are hidden from the user.

### current-bench

#### Open

* [ocurrent/current-bench#306](https://github.com/ocurrent/current-bench/issues/306)
  WIP ocaml compiler benchmarks

  A work-in-progress, high-level issue tracker for building
  `ocaml/ocaml` compiler benchmarks, and necessary tooling with the
  current-bench project.

* [ocurrent/current-bench#318](https://github.com/ocurrent/current-bench/issues/318)
  Cobench user library

  A request for a library to ease the process of creating and using
  benchmarks with the current-bench project.

* [ocurrent/current-bench#329](https://github.com/ocurrent/current-bench/issues/329)
  Use a standard record instead of a `Js.object` for metric data in `BenchmarkData.res`

  A refactoring task for the metric data to use a standard record
  instead of a `Js.object`.

* [ocurrent/current-bench#330](https://github.com/ocurrent/current-bench/issues/330)
  Looking at the past

  A list of UI changes to better view the past benchmark results for
  the dune team.

* [ocurrent/current-bench#332](https://github.com/ocurrent/current-bench/issues/332)
  Consider using time as the x-axis

  A wishlist entry to visualize the graphs with time on the x-axis.

* [ocurrent/current-bench#333](https://github.com/ocurrent/current-bench/issues/333)
  Docker build arguments

  The use of `--build-args` for Docker in the OCluster pipeline is
  required for custom Dockerfile runs with Sandmark nightly.

* [ocurrent/current-bench#344](https://github.com/ocurrent/current-bench/issues/344)
  Show the same sub-metric in the same color across different metric graphs

  A UI enhancement to show the same colour for a sub-metric across all
  the graphs.

#### Closed

##### Fixes

* [ocurrent/current-bench#326](https://github.com/ocurrent/current-bench/pull/326)
  Frontend: Fix bug with using same x-axis for all metrics

  The respective meta-data for all the commits, and for every metric
  in the x-axis is now correctly displayed in the UI.

* [ocurrent/current-bench#334](https://github.com/ocurrent/current-bench/pull/334)
  Fix CI

  A minor fix in `pipeline/libl/current_bench_json.ml` to correctly
  match and resolve the benchmark name.

* [ocurrent/current-bench#337](https://github.com/ocurrent/current-bench/pull/337)
  Fix missing value frontend crash

  A couple of fixes for `Js.Obj.assign` and the front-end when an
  overlaid metric is added to a branch.

* [ocurrent/current-bench#340](https://github.com/ocurrent/current-bench/pull/340)
  Missing metric indicator fixes
  
  The `BenchmarkTest.res` and `LineGraph.res` have been fixed to
  handle missing metric indicator.

* [ocurrent/current-bench#341](https://github.com/ocurrent/current-bench/pull/341)
  frontend: Fix broken line numbers when filling in missing commits

  A fix in `frontend/src/AppHelpers.res` to handle broken line numbers
  when filling missing commits.

* [ocurrent/current-bench#343](https://github.com/ocurrent/current-bench/pull/343)
  Fix colors changing on hiding some lines and change color palette

  An aesthetic UI change on the color palette, and fix for color
  changes when hiding lines.

* [ocurrent/current-bench#345](https://github.com/ocurrent/current-bench/pull/345)
  Correctly handle carriage returns when counting line numbers

  A proper way to handle `\r`, `\r\n`, and `\n` in the browser when
  showing the line numbers in the UI.

##### Frontend

* [ocurrent/current-bench#323](https://github.com/ocurrent/current-bench/pull/323)
  Allow clicking on the legend to show/hide plot lines and use more columns

  The legend now uses more columns when clicking on the show/hide plot
  in the UI.
  
* [ocurrent/current-bench#324](https://github.com/ocurrent/current-bench/issues/324)
  Disabled worker / docker image

  The frontend automatically selects the first "environment" (worker +
  Docker image) and the system may contain disabled ones. The
  environment list now filters and shows only the active entries.

* [ocurrent/current-bench#331](https://github.com/ocurrent/current-bench/pull/331)
  Show only workers with valid runs in workers dropdown

  The workers for a specific `repo_id` and `pull_number` alone are now
  shown in the dropdown menu.

* [ocurrent/current-bench#339](https://github.com/ocurrent/current-bench/pull/339)
  frontend: Filter out values less than 0.5% of maximum

  The values less than 0.5% of the maximum are now filtered out so
  that `Array.getExn` does not crash the frontend.

* [ocurrent/current-bench#342](https://github.com/ocurrent/current-bench/pull/342)
  Frontend: hide table comparison rows `NA/NA`

  The `NA/NA` is used in the frontend when there are no branch forks
  to compare in the graphs.

##### Sundries

* [ocurrent/current-bench#327](https://github.com/ocurrent/current-bench/pull/327)
  Slack

  The debug logs from benchmark runs can now be sent to Slack for
  alert notification.

![Current-bench-PR-327-alert|690x301](upload://em06U7qmXrsBszFbpcdOmJISXpm.png)

* [ocurrent/current-bench#328](https://github.com/ocurrent/current-bench/pull/328)
  Add a Cobench client library for pushing results with the HTTP API

  The Irmin benchmark monthly results need to be uploaded to
  current-bench, and hence a Cobench client library has been created
  to be used with the HTTP API.

* [ocurrent/current-bench#336](https://github.com/ocurrent/current-bench/pull/336)
  Docker build arguments

  The `environment/*.conf` file now supports an optional `build_args`
  setting that can be used to pass environment variables to `make
  bench`. This is useful for sandmark-nightly as well for cron-like
  scheduling of fast and slow benchmarks.
  
  ```
  {
  "repositories": [
    {
      "name": "local/local",
      "worker": "autumn",
      "build_args": ["FOO=42"]
    },
  ```

* [ocurrent/current-bench#338](https://github.com/ocurrent/current-bench/pull/338)
  Use latest OCurrent for logs line number links

  The `ocurrent-bench.opam` and `pipeline/pipeline.opam` files have
  been updated to use the latest OCurrent version.

We would like to thank all the OCaml users, developers and
contributors in the community for their continued support to the
project.

## Acronyms

* AFL: American Fuzzy Lop
* AMD: Advanced Micro Devices
* API: Application Programming Interface
* ARM: Advanced RISC Machines
* AWK: Aho Weinberger Kernighan
* BSD: Berkeley Software Distribution
* CFI: Call Frame Information
* CI: Continuous Integration
* FD: File Descriptor
* FFI: Foreign Function Interface
* GADT: Generalized Algebraic Data Type
* GC: Garbage Collector
* GNU: GNU's Not Unix
* HTTP: Hypertext Transfer Protocol
* IEEE: Institute of Electrical and Electronics Engineers
* JSON: JavaScript Object Notation
* MD: Markdown
* OOM: Out Of Memory
* OPAM: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* RFC: Request For Comments
* STW: Stop The World
* UI: User Interface
* URL: Uniform Resource Locator
* VM: Virtual Machine
* WSL: Windows Subsystem for Linux
