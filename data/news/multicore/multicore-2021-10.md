---
title: OCaml Multicore - October 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-10-01"
tags: [multicore]
---

Welcome to the October 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! The [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) along with
this update have been compiled by me, @ctk21, @kayceesrk and @shakthimaan.

As @octachron announced last month, the core team has [committed to an OCaml 5.0 release](https://discuss.ocaml.org/t/the-road-to-ocaml-5-0/8584) next year with multicore and the effects runtime.  This month has seen tremendous activity in our multicore trees to prepare an upstream-friendly version, with a number of changes made to make the code ready for `ocaml/ocaml` and reduce the size of the diff. Recall that we have been feeding in multicore-related changes steadily since way [back in OCaml 4.09](https://discuss.ocaml.org/t/multicore-prerequisite-patches-appearing-in-released-ocaml-compilers-now/4408), and so we are now down to the really big pieces.  Therefore the mainline OCaml trunk code is now being continuously being merged into our 5.00 staging branch, and test coverage has increased accordingly.

In the standard library, we continue to work and improve on thread safety by default. Since effect handlers are confirmed to go into 5.0 as well, they now have their own module in the stdlib as well. The multicore library ecosystem is also evolving with the changes to support OCaml 5.00, and in particular, Domainslib has had significant updates and improvements as more usecases build up. The integration of the Sandmark performance harness with current-bench is also actively being worked upon.

We would like to acknowledge the following people for their contribution:
* Török Edwin was able to reproduce the bug in `Task.pool` management
  [Domainslib#43](https://github.com/ocaml-multicore/domainslib/issues/43), and has also provided a PR to fix the same.
* Sid Kshatriya has created
  [PR#83](https://github.com/ocaml-multicore/eio/pull/83) for `Eio` to use the Effect Handlers module.

Our focus in November is going to continue to be on relentlessly making a 5.0 staging tree, and we are preparing for a series of working groups with the core OCaml teams (taking up an entire week) to conduct preliminary code review on the full patchset. Stay tuned for how that has gone by the start of December!

As always, the Multicore OCaml updates are listed first, which contain the upstream efforts, merges with trunk, updates to test cases, bug fixes, and documentation improvements. This is followed by the ecosystem updates on Domainslib, `Tezos`, and `Eio`. The Sandmark and current-bench tasks are finally listed for your reference.

## Multicore OCaml

### Ongoing

#### Upstream

* [ocaml-multicore/ocaml-multicore#637](https://github.com/ocaml-multicore/ocaml-multicore/issues/637)
  `caml_page_table_lookup` is not available in ocaml-multicore
  
  The [Remove the remanents of page table
  functionality](https://github.com/ocaml-multicore/ocaml-multicore/pull/642)
  PR should now fix this issue.
  
* [ocaml-multicore/ocaml-multicore#707](https://github.com/ocaml-multicore/ocaml-multicore/pull/707)
  Move `Domain.DLS` to a ThreadLocal module and make it work under systhreads
  
  The `Domain.DLS` implementation is to be moved to the `ThreadLocal`
  module, and the use of thread-local-storage to systhreads should
  also be enabled.
  
* [ocaml-multicore/ocaml-multicore#719](https://github.com/ocaml-multicore/ocaml-multicore/issues/719)
  Optimize `minor_gc` ephemeron handling
  
  An optimization request for a single domain to use the trunk
  algorithm to collect the ephemerons in the minor GC, and not use a
  barrier when there are no ephemerons in the multi-domain context.

* [ocaml-multicore/ocaml-multicore#727](https://github.com/ocaml-multicore/ocaml-multicore/pull/727)
  Update version number
  
  The `ocaml-variants.opam` file needs to be updated to use
  `ocaml-variants.4.14.0+domains`.

* [ocaml-multicore/ocaml-multicore#728](https://github.com/ocaml-multicore/ocaml-multicore/issues/728)
  Update `base-domains` package for 5.00 branch
  
  The `base-domains` package needs to include `4.14.0+domains`, as
  pinning on a local opam switch fails on dependency resolution.

#### Testsuite

* [ocaml-multicore/ocaml-multicore#656](https://github.com/ocaml-multicore/ocaml-multicore/pull/656)
  `Core` testsuite workflow
  
  A draft PR to implement a workflow to run the Core's testsuite once
  a day.

* [ocaml-multicore/ocaml-multicore#720](https://github.com/ocaml-multicore/ocaml-multicore/pull/720)
  Improve ephemerons compatibility with testsuite
  
  The PR imports upstream fixes to make ephemerons work with infix
  objects, and provides a fix for `weaktest.ml`.

* [ocaml-multicore/ocaml-multicore#722](https://github.com/ocaml-multicore/ocaml-multicore/pull/722)
  Testsuite: Re-enable `signals_alloc` testcase
  
  The `signals_alloc` testcase has been enabled, and the PR also
  attempts to ensure the bytecode interpreter polls for signals.

* [ocaml-multicore/ocaml-multicore#723](https://github.com/ocaml-multicore/ocaml-multicore/issues/723)
  `beat.ml` failure on GitHub Action MacOS runners
  
  An investigation on the `beat.ml` test failure in the testsuite for
  the CI execution runs.

#### Sundries

* [ocaml-multicore/ocaml-multicore#669](https://github.com/ocaml-multicore/ocaml-multicore/pull/669)
  Set thread names for domains
  
  A patch that implements thread naming for Multicore OCaml. It
  provides an interface to name Domains and Threads differently.

* [ocaml-multicore/ocaml-multicore#698](https://github.com/ocaml-multicore/ocaml-multicore/issues/698)
  Return free pools to the OS
  
  The `pool_release` is in the shared_heap and does not return memory
  to the OS. An ongoing discussion on how much memory to hold, and to
  reclaim with space overhead setting.

* [ocaml-multicore/ocaml-multicore#703](https://github.com/ocaml-multicore/ocaml-multicore/issues/703)
  Possible loop in `caml_enter_blocking_section` when no domain can handle a blocked signal
  
  A scenario that can be triggered when a domain that blocks a
  specific set of signals exists where no other domain can process the
  signal, and can be caused by a loop in
  `caml_enter_blocking_section`.

* [ocaml-multicore/ocaml-multicore#725](https://github.com/ocaml-multicore/ocaml-multicore/pull/725)
  Blocked signal infinite loop fix
  
  A monotonic `recorded_signals_counter` has been introduced to fix
  the possible loop in `caml_enter_blocking_section` when no domain
  can handle a blocked signal.

* [ocaml-multicore/ocaml-multicore#726](https://github.com/ocaml-multicore/ocaml-multicore/issues/726)
  Marshalling of concurrently-modified objects is unsafe
  
  The marshalling of objects being mutated on a different domain must
  be handled correctly and should be safe. It should not cause a
  segmentation fault or crash.

### Completed

#### Upstream

##### Build

* [ocaml-multicore/ocaml-multicore#662](https://github.com/ocaml-multicore/ocaml-multicore/pull/662)
  Disable changes check on 5.0
  
  The `.github/workflows/hygiene.yml` has been updated to disable
  check on 5.00 to avoid noise on the change entries.

* [ocaml-multicore/ocaml-multicore#676](https://github.com/ocaml-multicore/ocaml-multicore/pull/676)
  Fix 5.00 install
  
  The `caml/byte_domain_state.tbl` has been removed, and `README.adoc`
  has been renamed to `README.stock.adoc` in order to build cleanly
  with OCaml 5.00 branch.

##### Change

* [ocaml-multicore/ocaml-multicore#675](https://github.com/ocaml-multicore/ocaml-multicore/pull/675)
  Align `Bytes.unsafe_of_string / Bytes.unsafe_to_string` to OCaml trunk
  
  The `Pbytes_to_string / Pbytes_of_string` use in
  `bytecomp/bytegen.ml` are now aligned with upstream OCaml.

* [ocaml-multicore/ocaml-multicore#677](https://github.com/ocaml-multicore/ocaml-multicore/pull/677)
  Remove debugging nop
  
  The debugging nop primitive is not required for upstreaming and has
  been cleaned up. The PR also fixes check-typo whitespace in
  `emit.mlp` to match that trunk.

* [ocaml-multicore/ocaml-multicore#679](https://github.com/ocaml-multicore/ocaml-multicore/pull/679)
  Remove `caml_read_field`
  
  The use of `caml_read_field` has been removed as the existing
  `Field` provides all the necessary information making it closer to
  upstream OCaml.

* [ocaml-multicore/ocaml-multicore#681](https://github.com/ocaml-multicore/ocaml-multicore/pull/681)
  Revert to ocaml/trunk version of otherlibs/unix
  
  `unixsupport.c`, `cstringv.c` and files in `otherlibs/unix` have
  been updated to be similar to `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#684](https://github.com/ocaml-multicore/ocaml-multicore/pull/684)
  Remove historical `for_handler` and `Reperform_noloc` in `lambda/matching`
  
  The `for_handler` function and `Reperform_noloc` in
  `lambda/matching.ml{,i}` are not required to be upstreamed and hence
  have been removed.

* [ocaml-multicore/ocaml-multicore#685](https://github.com/ocaml-multicore/ocaml-multicore/pull/685)
  Remove `Init_field` from interp.c
  
  The `interp.c` file has been updated to be closer to
  `ocaml/ocaml`. The check-typo errors have been fixed, and the
  `Init_field` macro has been cleaned up.

* [ocaml-multicore/ocaml-multicore#704](https://github.com/ocaml-multicore/ocaml-multicore/pull/704)
  Remove Sync.poll and nanoseconds from Domain
  
  The Domain module has been updated to include only the changes
  required for upstreaming. `Domain.Sync.poll`, and
  `Domain.nanosecond` have been removed. `Domain.Sync.cpu_relax` has
  been renamed to `Domain.cpu_relax`. `platform.h` has been updated
  with fixes for check-typo.

* [ocaml-multicore/ocaml-multicore#706](https://github.com/ocaml-multicore/ocaml-multicore/pull/706)
  Revert `otherlibs/win32unix` to ocaml/trunk
  
  The `otherlibs/win32unix/*` files have been updated to be closer to
  `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#708](https://github.com/ocaml-multicore/ocaml-multicore/pull/708)
  Remove maybe stats
  
  The `caml_maybe_print_stats` primitive to output statistics and the
  `s` option to `OCAMLRUNPARAM` have now been removed.

* [ocaml-multicore/ocaml-multicore#724](https://github.com/ocaml-multicore/ocaml-multicore/pull/724)
  Runtime: Remove unused fields from `io.h`
  
  Remove `revealed` and `old_revealed` from `runtime/caml/io.h` as
  they have also been removed from `ocaml/ocaml`.

##### Diff

* [ocaml-multicore/ocaml-multicore#663](https://github.com/ocaml-multicore/ocaml-multicore/pull/663)
  Remove noise from diff with upstream on `typing/`
  
  The PR squishes unnecessary diffs with upstream OCaml for `typing/`.

* [ocaml-multicore/ocaml-multicore#664](https://github.com/ocaml-multicore/ocaml-multicore/pull/664)
  Remove unncessary diffs with upstream in `parsing/`
  
  The PR removes unnecessary white space diffs with upstream OCaml in
  `parsing/`.

* [ocaml-multicore/ocaml-multicore#694](https://github.com/ocaml-multicore/ocaml-multicore/pull/694)
  First pass to improve the diff to startup code
  
  The PR attempts to improve the diff in the startup code for trunk
  and Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#695](https://github.com/ocaml-multicore/ocaml-multicore/pull/695)
  Improve systhread's diff with trunk
  
  The systhread's diff with trunk is improved with this merged PR.

##### Merge

* [ocaml-multicore/ocaml#2](https://github.com/ocaml-multicore/ocaml/pull/2)
  Update trunk to the latest upstream trunk
  
  The PR is an attempt to help with the OCaml 5.0 difference
  output. With the changes, you can successfully do `make && make
  tests`. The summary of the results is provided below:
  
  ```
  Summary:
  2918 tests passed
   40 tests skipped
    0 tests failed
  105 tests not started (parent test skipped or failed)
    0 unexpected errors
  3063 tests considered

  ```

* [ocaml-multicore/ocaml#3](https://github.com/ocaml-multicore/ocaml/pull/3)
  Latest 5.00 Commits
  
  The recent commits from trunk have now been merged to the
  ocaml-multicore 5.00 branch.

* [ocaml-multicore/ocaml-multicore#718](https://github.com/ocaml-multicore/ocaml-multicore/pull/718)
  Deprecate Sync and `timer_ticks` from Domain
  
  The patch synchronizes the changes to `4.12.0+domains+effects` with
  the mainline 5.00 branch.

#### Thread Safe

* [ocaml-multicore/ocaml-multicore#632](https://github.com/ocaml-multicore/ocaml-multicore/issues/632)
  `Str` module multi domain safety
  
  The
  [PR#635](https://github.com/ocaml-multicore/ocaml-multicore/pull/635)
  makes `lib-str` domain safe to work concurrently with Multicore
  OCaml.

* [ocaml-multicore/ocaml-multicore#672](https://github.com/ocaml-multicore/ocaml-multicore/pull/672)
  Codefrag thread safety
  
  The PR introduces a lock-free skiplist to make codefrag thread
  safe. The code fragments cannot be freed as soon as they are
  removed, but, they are added to a list and cleaned up during a later
  stop-the-world pause.

#### Fixes

* [ocaml-multicore/ocaml-multicore#655](https://github.com/ocaml-multicore/ocaml-multicore/pull/655)
  Systhreads: Initialize `thread_next_id` to 0
  
  The `thread_next_id` was not initialized and was causing an issue
  with Core's testsuite. It has now been initialized to zero.

* [ocaml-multicore/ocaml-multicore#657](https://github.com/ocaml-multicore/ocaml-multicore/pull/657)
  Libstr: Use a domain local value to store `last_search_result_key`
  
  The `last_search_result_key` is now stored in a domain local storage
  which fixes a recent CI failure.

* [ocaml-multicore/ocaml-multicore#673](https://github.com/ocaml-multicore/ocaml-multicore/pull/673)
  Fix C++ namespace pollution reported in #671
  
  The patch fixes the C++ namespace pollution and check-typo issues.

* [ocaml-multicore/ocaml-multicore#702](https://github.com/ocaml-multicore/ocaml-multicore/pull/702)
  Otherlibs: Add PR10478 fix back to systhreads
  
  The `st_thread_set_id` invocation has been added to
  `otherlibs/systhreads/st_stubs.c` that reinstates the fix from
  [ocaml/ocaml#10478](https://github.com/ocaml/ocaml/pull/10478) in
  systhreads.

* [ocaml-multicore/ocaml-multicore#721](https://github.com/ocaml-multicore/ocaml-multicore/pull/721)
  Fix `make install`
  
  The `caml/byte_domain_state.tbl: No such file or directory` bug from
  running `make install` has been fixed with this PR.

#### Testsuite

* [ocaml-multicore/ocaml-multicore#654](https://github.com/ocaml-multicore/ocaml-multicore/pull/654)
  Enable effects tests
  
  The effect handler tests have now been re-added since the syntax
  support has been added to Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#658](https://github.com/ocaml-multicore/ocaml-multicore/pull/658)
  Enable last dynlink test
  
  The `lib-dynlink-private` test has now been enabled to run in the CI.

* [ocaml-multicore/ocaml-multicore#659](https://github.com/ocaml-multicore/ocaml-multicore/pull/659)
  Reimport the threadsigmask test and remove systhread-todo test directory
  
  The `lib-systhreads-todo` test on signal handling and tick thread
  missing from systhreads has been reactivated in the the CI.

* [ocaml-multicore/ocaml-multicore#660](https://github.com/ocaml-multicore/ocaml-multicore/pull/660)
  Fixups and housekeeping for `testsuite/disabled` file
  
  The `check-typo` problems for 80 character line, and unnecessary
  `test/promotion` in `testsuite/disabled` have been fixed.

* [ocaml-multicore/ocaml-multicore#661](https://github.com/ocaml-multicore/ocaml-multicore/pull/661)
  Testsuite: Re-enable pr9971
  
  The `pr9971` test has been re-enabled to run in the CI.

* [ocaml-multicore/ocaml-multicore#688](https://github.com/ocaml-multicore/ocaml-multicore/pull/688)
  Better signal handling in systhreads
  
  Improvements to the signal handling in systhreads that fixes the
  `threadsigmask` testcase failure in the CI.

* [ocaml-multicore/ocaml-multicore#712](https://github.com/ocaml-multicore/ocaml-multicore/pull/712)
  Otherlibs: Unix.kill should check for pending signals
  
  The `unix_kill` test case has been re-enabled to ensure that
  `Unix.kill` checks for pending signals on return.

#### Documentation

* [ocaml-multicore/ocaml-multicore#672](https://github.com/ocaml-multicore/ocaml-multicore/pull/672)
  Check-typo fixes for `major_gc`, so the changes in #672 don't get clobbered
  
  A patch that fixes check-typo issues in `runtime/major_gc.c`.

* [ocaml-multicore/ocaml-multicore#696](https://github.com/ocaml-multicore/ocaml-multicore/pull/696)
  Stdlib: Fix typos in `effectHandlers.mli`
  
  A few typos in `stdlib/effectHandlers.mli` have been fixed.

* [ocaml-multicore/ocaml-multicore#697](https://github.com/ocaml-multicore/ocaml-multicore/pull/697)
  Remove dead code and clear up comments in the minor gc
  
  A non-functional change that clears up the comments in the minor and
  major GC files.

* [ocaml-multicore/ocaml-multicore#699](https://github.com/ocaml-multicore/ocaml-multicore/pull/699)
  Cleanup fiber implementation and add documentation
  
  The unused code in `amd64.S` has been removed and formatting has
  been fixed. The addition of 24 bytes at the top of the stack for an
  external call is no longer needed and has been removed.

* [ocaml-multicore/ocaml-multicore#713](https://github.com/ocaml-multicore/ocaml-multicore/pull/713)
  Clarify documentation of Lazy wrt. RacyLazy and Undefined exceptions.
  
  The documentation in `stdlib/lazy.mli` has been updated to clarify
  on the behaviour of `try_force` and thread safety.

* [ocaml-multicore/ocaml-multicore#717](https://github.com/ocaml-multicore/ocaml-multicore/pull/717)
  Tighten code comments in `minor_gc.c`
  
  The PR explains promotion of ephemeron keys to avoid introducing a
  barrier, and uses `/* ... */` style comments.

* [ocaml-multicore#docs](https://github.com/ocaml-multicore/docs)
  Docs
  
  A documentation repository for OCaml 5.00 that contains the design
  and proposed upstreaming plan.

#### Effect Handlers

* [ocaml-multicore/ocaml-multicore#653](https://github.com/ocaml-multicore/ocaml-multicore/pull/653)
  Drop `drop_continuation`
  
  This PR has been superseded by the [Add
  EffectHandlers](https://github.com/ocaml-multicore/ocaml-multicore/pull/689)
  module PR for 4.12.0+domains+effects.

* [ocaml-multicore/ocaml-multicore#682](https://github.com/ocaml-multicore/ocaml-multicore/pull/682)
  Move effect handlers to its own module in Stdlib
  
  The `EffectHandlers` functionality from `Obj` has now been moved to
  its own module in Stdlib.

* [ocaml-multicore/ocaml-multicore#687](https://github.com/ocaml-multicore/ocaml-multicore/pull/687)
  Move effect handlers to its own module in Stdlib
  
  This is a backport of
  [PR#682](https://github.com/ocaml-multicore/ocaml-multicore/pull/682)
  for `4.12+domains`.

* [ocaml-multicore/ocaml-multicore#689](https://github.com/ocaml-multicore/ocaml-multicore/pull/689)
  Add EffectHandlers module
  
  The PR adds effect handler functions to `4.12.0+domains+effects`,
  and allows `domainslib` with effect handler functions to work with
  the `4.12.0+domains+effects` switch.

#### Sundries

* [ocaml-multicore/ocaml-multicore#678](https://github.com/ocaml-multicore/ocaml-multicore/pull/678)
  Make domain state the same in bytecode and native mode
  
  The `struct domain_state` structure is now made identical in both
  bytecode and native code.

* [ocaml-multicore/ocaml-multicore#691](https://github.com/ocaml-multicore/ocaml-multicore/pull/691)
  Add ability to discontinue with backtrace
  
  The backtrace is useful for modeling async/wait, especially when the
  awaited task raises an exception, the backtrace includes frames from
  both the awaited and awaiting task.

* [ocaml-multicore/ocaml-multicore#693](https://github.com/ocaml-multicore/ocaml-multicore/pull/693)
  Add ability to discontinue with backtrace
  
  The backport of
  [ocaml-multicore/ocaml-multicore#691](https://github.com/ocaml-multicore/ocaml-multicore/pull/691)
  to `4.12.0+domains+effects`.

* [ocaml-multicore/ocaml-multicore#701](https://github.com/ocaml-multicore/ocaml-multicore/pull/701)
  Really flush output when pre-defined formatters are used in parallel
  
  The flush used to happen only at the termination of a domain, but,
  with this PR the output is immediately flushed.

* [ocaml-multicore/ocaml-multicore#705](https://github.com/ocaml-multicore/ocaml-multicore/pull/705)
  Otherlibs: Remove `caml_channel_mutex_io` hooks from systhreads
  
  `caml_channel_mutex_io` hooks in systhreads have now been removed.

* [ocaml-multicore/ocaml-multicore#716](https://github.com/ocaml-multicore/ocaml-multicore/pull/716)
  runtime: `extern_free_position_table` should return on `extern_flags & NO_SHARING`
  
  `extern_free_position_table` should return immediately if
  `extern_flags & NO_SHARING`, by symmetry with
  `extern_alloc_position_table`.

## Ecosystem

##### Ongoing

###### Domainslib

* [ocaml-multicore/domainslib#43](https://github.com/ocaml-multicore/domainslib/issues/43)
  Possible bug in `Task.pool` management

  Török Edwin has reproduced the segmentation fault using
  4.12.0+domains with domainslib 0.3.1 on AMD Ryzen 3900X CPU, and has
  also provided a draft PR with a fix!

* [ocaml-multicore/domainslib#46](https://github.com/ocaml-multicore/domainslib/issues/46)
  Provide a way to iterate over all the pools
  
  A requirement to be able to iterate over all the pools created in
  domainslib. A use case is to tear down all the pools. A weak hash
  set can be used to store a weak pointer to the pools.

* [ocaml-multicore/domainslib#47](https://github.com/ocaml-multicore/domainslib/issues/47)
  `Task.await` deadlock (task finished but await never returns)
  
  A query on nesting `Task.await` inside `Task.async`, and
  `Task.async` inside `Task.async`. A sample code snippet, stack trace
  and platform information have also been provided to reproduce a
  deadlock scenario.

* [ocaml-multicore/domainslib#48](https://github.com/ocaml-multicore/domainslib/issues/48)
  Move `ws_deque` to lockfree
  
  A request to move the work-stealing deque in domainslib to
  `ocaml-multicore/lockfree`, and make `domainslib` depend on this new
  `lockfree` implementation.

* [ocaml-multicore/domainslib#49](https://github.com/ocaml-multicore/domainslib/issues/49)
  Should we expose multi-channel from the library?
  
  A query on whether Multicore OCaml users will find Non-FIFO
  multi-channel implementation useful. Domainslib already provides
  FIFO channels.

* [ocaml-multicore/domainslib#50](https://github.com/ocaml-multicore/domainslib/pull/50)
  Multi_channel: Allow more than one instance per program with different configurations
  
  A draft PR contributed by Török Edwin in `lib/multi_channel.ml` and
  `lib/task.ml` to remove use of a global key with a per-channel key.

* [ocaml-multicore/domainslib#51](https://github.com/ocaml-multicore/domainslib/pull/51)
  Utilise effect handlers
  
  The tasks are now created using effect handlers, and a new
  `test_deadlock.ml` tests the same. The change will work only with
  `4.12+domains` and `5.00`. The performance results from the Turing
  machine (Intel Xeon Gold 5120 CPU @ 2.20 GHz, 28 isolated cores) is
  shown below:
  
  ![Domainslib-PR-51-performance](images/Domainslib-PR-51-performance.png)

###### Sundries

* [ocaml-multicore/tezos#8](https://github.com/ocaml-multicore/tezos/issues/8)
  ci.Dockerfile throws warning
  
  The `ci.Dockerfile` on Ubuntu 20.10 throws C99 warnings on `_Atomic`
  with GCC 10.3.0.

* [ocaml-multicore/tezos#10](https://github.com/ocaml-multicore/tezos/pull/10)
  Fix make build-deps, fix NixOS support
  
  `conf-perl` is no longer required upstream and has been removed from
  the `tezos-opam-repository`. The patch also fixes `make
  build-deps/build-dev-deps`.

* [ocaml-multicore/ocaml-uring#39](https://github.com/ocaml-multicore/ocaml-uring/issues/39)
  Test failures on NixOS
  
  The `ocaml-uring` master branch is showing test failures with `dune
  runtest` on NixOS.

* [ocaml-multicore/eio#85](https://github.com/ocaml-multicore/eio/issues/85)
  Any plans on supporting `js_of_ocaml`?

  A query by Konstantin A. Olkhovskiy (`Lupus`) on whether EIO can
  compile to JavaScript backend, assuming that `js_of_ocaml` gets
  support for effects.

##### Completed

###### Domainslib

* [ocaml-multicore/domainslib#45](https://github.com/ocaml-multicore/domainslib/pull/45)
  Add named pools
  
  An optional argument is now added to name a pool during setup. This
  name can be used to retrieve the pool later.

* [ocaml-multicore/domainslib#52](https://github.com/ocaml-multicore/domainslib/pull/52)
  Use a random number as the cache prefix to disable cache in CI
  
  The `cache-prefix` now uses a random number in
  `.github/workflows/main.yml` to disable cache in the CI.

* [ocaml-multicore/domainslib#53](https://github.com/ocaml-multicore/domainslib/pull/53)
  Make domainslib build/run with OCaml 5.00 after PR#704
  
  The CI has been updated to now build and run with OCaml 5.00 branch.

* [ocaml-multicore/domainslib#54](https://github.com/ocaml-multicore/domainslib/pull/54)
  Use last 4.12+domains+effects hash as the cache-key
  
  The cache-key now uses the last commit hash from OCaml Multicore in
  order to invalidate the cache in the CI.

###### Sundries

* [ocaml-multicore/tezos-opam-repository#3](https://github.com/ocaml-multicore/tezos-opam-repository/pull/3)
  Add domainslib
  
  The `domainslib.0.3.1` version has now been included in the Tezos
  OPAM repository as a package.

* [ocaml-multicore/tezos-opam-repository#5](https://github.com/ocaml-multicore/tezos-opam-repository/pull/5)
  Upstream updates
  
  The `Tezos OPAM repository` has been updated with upstream changes
  using
  [PR#1](https://github.com/ocaml-multicore/tezos-opam-repository/pull/1)
  and
  [PR#5](https://github.com/ocaml-multicore/tezos-opam-repository/pull/5).

* [ocaml-multicore/retro-httpaf-bench#17](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/17)
  Improve graphs
  
  Markers have now been added to the graphs generated from the Jupyter
  notebook to easily distinguish the colour lines.
  
  ![retro-httpaf-bench-17-graph|690x409](https://discuss.ocaml.org/uploads/short-url/qKGZJ5anPXMCKp8EDcY2F5TMRbk.jpeg)

* [ocaml-multicore/multicore-opam#59](https://github.com/ocaml-multicore/multicore-opam/pull/59)
  Fix batteries after ocaml-multicore/ocaml-multicore#514
  
  The `batteries.3.3.0+multicore` opam file for `batteries-included`
  has been updated with the correct src URL.

* [ocaml-multicore/eio#82](https://github.com/ocaml-multicore/eio/pull/82)
  Migrate to 4.12.0+domains effects implementation (syntax-free effects version)
  
  The PR updates `eio` to support the effects implementation for OCaml
  5.0 release.

* [ocaml-multicore/eio#83](https://github.com/ocaml-multicore/eio/pull/83)
  Effect handlers have their own module now
  
  Sid Kshatriya has contributed a patch to rename
  `Obj.Effect_handlers` to `EffectHandlers` since effect handlers have
  their own module in Stdlib.

* [ocaml-multicore/core](https://github.com/ocaml-multicore/core)

  Jane Street's standard library overlay `core` has now been
  added to `ocaml-multicore` GitHub project repositories.

## Benchmarking

### Sandmark

#### Ongoing

* [ocaml-bench/sandmark#248](https://github.com/ocaml-bench/sandmark/issues/248)
  Coq fails to build
  
  A new Coq tarball,
  [coq-multicore-2021-09-24](https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24),
  builds with Multicore OCaml 4.12.0+domains, but, `stdio.v0.14.0`
  fails to build cleanly with 4.14.0+trunk because of a [dune
  issue](https://github.com/ocaml/dune/issues/5028) that has been
  reported.
  
* [ocaml-bench/sandmark#260](https://github.com/ocaml-bench/sandmark/pull/260)
  Add 5.00 branch for sequential run. Fix notebook.
    
  A new 5.00 OCaml variant branch has been added to Sandmark to
  track sequential benchmark runs in the CI.
    
#### Completed

* [ocaml-bench/sandmark#256](https://github.com/ocaml-bench/sandmark/pull/256)
  Remove old variants
  
  The older variants, `4.05.*`, `4.06.*`, `4.07.*`, `4.08.*`,
  `4.10.0.*` have now been removed from Sandmark.
  
* [ocaml-bench/sandmark#258](https://github.com/ocaml-bench/sandmark/pull/258)  
  Document Makefile variables in README

  The README now contains documentation on the various Makefile
  variables that are used during building and execution of the
  benchmarks in Sandmark.

### current-bench

#### Ongoing

* [ocurrent/current-bench#117](https://github.com/ocurrent/current-bench/issues/117)
  Read stderr from the Docker container
  
  We would like to see any build failures from the benchmark execution
  inside the Docker container for debugging purposes.

* [ocurrent/current-bench#146](https://github.com/ocurrent/current-bench/issues/146)
  Replicate ocaml-bench-server setup
  
  The TAG and OCaml variants need to be abstracted from the Sandmark
  Makefile to current-bench in order to be able to run the benchmarks
  for different compiler versions and developer branches.

#### Completed

* [ocurrent/current-bench#105](https://github.com/ocurrent/current-bench/issues/105)
  Abstract out Docker image name from `pipeline/lib/pipeline.ml` to environments
  
  Custom Dockerfiles are now supported and hence you can pull in any
  opam image in the Dockerfile.

* [ocurrent/current-bench#119](https://github.com/ocurrent/current-bench/issues/119)
  `OCAML_BENCH_DOCKER_CPU` does not support range of CPUs for parallel execution
  
  The Docker CPU setting now uses a string representation instead of
  an integer to specify the list of CPUs for parallel execution.

* [ocurrent/current-bench#151](https://github.com/ocurrent/current-bench/issues/151)
  Docker versus native performance
  
  The Docker with current-bench, and native sequential and parallel
  benchmark runs do not show significant difference with
  hyper-threading disabled. The Gödel server configuration and the
  Sandmark-nightly notebook graph results are provided below for
  reference:
  
  - CPU: Intel(R) Xeon® Gold 5120 CPU @ 2.20 GHz
  - OS: Ubuntu 20.04.3 LTS (Focal Fossa)
  - Sandmark 2.0-beta branch: https://github.com/ocaml-bench/sandmark/tree/2.0-beta
  - Disabled hyper-threading:
    ```
    $ cat /sys/devices/system/cpu/smt/active
    0
    ```
  - Memory (62 GB), disk (1.8 TB).
  - OCaml variant: 4.12.0+domains
  - Sandmark-nightly notebooks: https://github.com/ocaml-bench/sandmark-nightly/tree/main/notebooks
  - Average of five iterations for each benchmark
    - `run_in_ci` for sequential
    - `macro_bench` for parallel


  Time
  ![Current-bench-151-Time|690x236](https://discuss.ocaml.org/uploads/short-url/gjR8Yte7F23hEVr0162yOuWCp2r.png)
  Normalised
  ![Current-bench-151-Time-Normalised|690x315](https://discuss.ocaml.org/uploads/short-url/wtc2aSo61cDXTtdJQLcrOvjJwmD.png)
  Top heap words 
 ![Current-bench-151-Top-heap-words|690x236](https://discuss.ocaml.org/uploads/short-url/xxyblnCJr3GPkEEfM3ZnmAJ4LMe.png)
  Normalised
 ![Current-bench-151-Top-heap-words-Normalised|690x323](https://discuss.ocaml.org/uploads/short-url/4JXHsIHH4b5DDeAtn0kwN8bnC0n.png)

  MaxRSS (KB)
  ![Current-bench-151-MaxRSS|690x237](https://discuss.ocaml.org/uploads/short-url/jys3rIAZFb5mkb3q2ZMD3uPGiQA.png)
  Normalised
  ![Current-bench-151-MaxRSS-Normalised|690x325](https://discuss.ocaml.org/uploads/short-url/ue1TiDvFK8EXA6Wi11gOHiHMXNU.png)

  Major Collections
  ![Current-bench-151-Major-collections|690x236](https://discuss.ocaml.org/uploads/short-url/dm1cGbEjtV8I5UZpfxdfgt2lIaf.png)
  Normalised
  ![Current-bench-151-Minor-collections-Normalised|690x320](https://discuss.ocaml.org/uploads/short-url/sdHyKFyoDSDdok3QDvKNbyNAq0Z.png)

  Parallel Benchmarks
  ![Current-bench-151-Parallel-benchmarks-I|486x500](https://discuss.ocaml.org/uploads/short-url/8BQzGtrqwFPZ0Di4WeUcsUxkQcq.png)
  ![Current-bench-151-Parallel-benchmarks-II|237x500](https://discuss.ocaml.org/uploads/short-url/rIYQcXtBJwgIlniuhcCyz3WY2Q7.png)

(see the PR full for the full set of graphs, including major words and time taken)

Our special thanks to all the OCaml users, developers and contributors in the community for their valuable time and continued support to the project. Stay safe!

## Acronyms

* AMD: Advanced Micro Devices
* CI: Continuous Integration
* CPU: Central Processing Unit
* DLS: Domain Local Storage
* FIFO: First In, First Out
* GB: Gigabyte
* GC: Garbage Collector
* GCC: GNU Compiler Collection
* IO: Input/Output
* OPAM: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* TB: Terabyte
* URL: Uniform Resource Locator
