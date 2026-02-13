---
title: OCaml Multicore - July 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-07-01"
tags: [multicore]
---

Welcome to the July 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This month's update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) has been compiled by me, @ctk21, @kayceesrk and @shakthimaan. As August is usually a period of downtime in Europe, the next update may be merged with the September one in a couple of months (but given our geographically diverse nature now, if enough progress happens in August I'll do an update).

The overall status of the multicore efforts are right on track: our contributions to the next OCaml release have been [incorporated in 4.13.0~alpha2](https://discuss.ocaml.org/t/ocaml-4-13-0-second-alpha-release/8164), and our focus remains on crushing incompatibilities and bugs to generate domains-only parallelism patches suitable for upstream review and release.  As a lower priority activity, we continue to develop the experimental "effects-based" IO stack, which will feature in the upcoming virtual OCaml Workshop at ICFP in August 2021.

The `4.12.0+domains` trees continue to see a tail of bugs being steadily fixed. After last month's call, we saw a number of external contributors step up to submit fixes in addition to the multicore and core OCaml teams. We would like to acknowledge and thank them!

* @emillon (Etienne Millon) for running the Jane Street `core` v0.14 test suite with 4.12.0+domains and sharing the test results (and finding a [multicore GC edge case bug](https://github.com/ocaml-multicore/ocaml-multicore/issues/624) while at it).
* @Termina1 (Vyacheslav Shebanov) for testing the compilation of `batteries` 3.30 with Multicore OCaml 4.12.0+domains.
* @nbecker (Nils Becker) for reporting on `parallel_map` and `parallel_scan` for domainslib.
* Filip Koprivec for identifying a memory leak when using `flush_all` with `ocamlc` with 4.12.0+domains.

All of these fixes, combined with some big-ticket compatibility changes (listed below) are getting me pretty close to using 4.12.0+domains as my daily OCaml opam switch of choice. I encourage you to also give it a try and report (good or bad) results on [the multicore OCaml tracker](https://github.com/ocaml-multicore/ocaml-multicore/issues).  If these sorts of problems grab your attention, then [Segfault Systems is hiring in India](https://segfault.systems/careers.html) to work with @kayceesrk and the team there on multicore OCaml.

For benchmarking, the Jupyter notebooks for the Sandmark nightly benchmark runs have  been updated, and we continue to test the Sandmark builds for the  4.12+ variants and 4.14.0+trunk. Progress has been made to integrate  `current-bench` OCurrent pipeline with the Sandmark 2.0 -alpha branch  changes to reproduce the current Sandmark functionality, which will allow GitHub PRs to be benchmarked systematically before being merged.

As always, the Multicore OCaml ongoing and completed tasks are listed first, which are then followed by the updates from the Ecosystem libraries. The Sandmark nightly build efforts, benchmarking updates and relevant current-bench tasks are then mentioned. Finally, the update on the upstream OCaml Safepoints PR is provided for your reference.

## Multicore OCaml

### Ongoing

#### CI Compatibility

* [ocaml-multicore/ocaml-multicore#602](https://github.com/ocaml-multicore/ocaml-multicore/issues/602)
  Inclusion of most of OCaml headers results in requiring pthread
  
  The inclusion of multiple nested header files requires `pthread` and
  the `decompress` testsuite fails.

* [ocaml-multicore/ocaml-multicore#607](https://github.com/ocaml-multicore/ocaml-multicore/issues/607)
  `caml_young_end` is not a `value *` anymore

  An inconsistency observed in the CI where `caml_young_end` is now a
  `char *` instead of `value *`.

#### Crashes

* [ocaml-multicore/ocaml-multicore#608](https://github.com/ocaml-multicore/ocaml-multicore/issues/608)
  Parmap testsuite crash
  
  `Parmap` is causing a segfault when its testsuite is run against
  Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#611](https://github.com/ocaml-multicore/ocaml-multicore/issues/611)
  Crash running Multicore binary under AFL
  
  The `bun` package crashes with Multicore OCaml 4.12+domains, but,
  builds fine on 4.12.

#### Package Builds
  
* [ocaml-multicore/ocaml-multicore#609](https://github.com/ocaml-multicore/ocaml-multicore/issues/609)
  lablgtk's example segfaults
  
  An ongoing effort to compile lablgtk with OCaml and Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#624](https://github.com/ocaml-multicore/ocaml-multicore/issues/624)
  core v0.14: test triggers a segfault in the GC
  
  A segfault caused by running `core.v0.14` test suite with Multicore
  OCaml 4.12.0+domains as reported by @emillon.

* [ocaml-multicore/ocaml-multicore#625](https://github.com/ocaml-multicore/ocaml-multicore/issues/625)
  Cannot compile batteries on OCaml Multicore 4.12.0+domains
  
  An effort by Vyacheslav Shebanov (@Termina1) to compile
  `batteries.3.30` with Multicore OCaml 4.12.0+domains variant.

#### Upstream

* [ocaml-multicore/ocaml-multicore#573](https://github.com/ocaml-multicore/ocaml-multicore/pull/573)
  Backport trunk safepoints PR to multicore

  The Safepoints implementation is being backported to Multicore
  OCaml. The initial test results of running Sandmark on a large Xen2
  box are shown below:

![OCaml-Multicore-PR-573-Time|458x500](https://discuss.ocaml.org/uploads/short-url/irThoi4RbupKLP9YOqiDuCHehA1.png)
![OCaml-Multicore-PR-573-Speedup|458x500](https://discuss.ocaml.org/uploads/short-url/bJSpY5klM9MvO4sUrPJ3YD6463I.png)

* [ocaml-multicore/ocaml-multicore#617](https://github.com/ocaml-multicore/ocaml-multicore/issues/617)
  Some of the compatibility macros are not placed in the same headers as in upstream OCaml
  
  The introduction of a compatibility layer for GC statistics need to
  be consistent with trunk.

* [ocaml-multicore/ocaml-multicore#618](https://github.com/ocaml-multicore/ocaml-multicore/issues/618)
  Review io.c for thread-safety and add parallel tests
  
  The thread-safety fixes in io.c requires a review and additional
  tests need to be added for the same.

* [ocaml-multicore/ocaml-multicore#623](https://github.com/ocaml-multicore/ocaml-multicore/pull/623)
  Exposing `caml_channel_mutex_*` hooks

  A draft PR to support `caml_channel_mutex_*` interfaces from trunk
  to Multicore OCaml.

#### Sundries

* [ocaml-multicore/ocaml-multicore#610](https://github.com/ocaml-multicore/ocaml-multicore/pull/610)
  Add std gnu11 common cflags
  
  The configure.ac file has been updated to use `-std=gnu11` in
  `common_cflags` for both GCC and Clang.

* [ocaml-multicore/ocaml-multicore#614](https://github.com/ocaml-multicore/ocaml-multicore/issues/614)
  Destroy channel mutexes after fork
  
  A discussion on resetting and reinitializing mutexes after fork in
  the runtime.
  
* [ocaml-multicore/ocaml-multicore#616](https://github.com/ocaml-multicore/ocaml-multicore/pull/616)
  Expose functions to program with effects
  
  A draft PR to enable programmers to write programs that use effects
  without explicitly using the effect syntax.
  
* [ocaml-multicore/ocaml-multicore#619](https://github.com/ocaml-multicore/ocaml-multicore/issues/619)
  Set resource Limit
  
  A query to use `setrlimit` in Multicore OCaml, similiar, to
  `Core.Unix.RLimit.set` from Jane Street's core library.

### Completed

#### Enhancements

* [ocaml-multicore/ocaml-multicore#601](https://github.com/ocaml-multicore/ocaml-multicore/pull/601)
  Domain better participants

  The `0(n_running_domains)` from domain creation and the iterations
  `0(Max_domains)` from STW signalling have been removed.

* [ocaml-multicore/ocaml-multicore#605](https://github.com/ocaml-multicore/ocaml-multicore/pull/605)
  Eventog event for condition wait

  A new event has been added to indicate when a domain is blocked at
  `Condition.wait`. This is useful for debugging any imbalance in task
  distribution in domainslib.

![OCaml-Multicore-PR-605-Illustration|536x500](https://discuss.ocaml.org/uploads/short-url/7CXMmjUbwuXqGtffNyfeo5B5Gd8.png)

* [ocaml-multicore/ocaml-multicore#615](https://github.com/ocaml-multicore/ocaml-multicore/pull/615)
  make depend
  
  Updated `stdlib/.depend` to cover the recent developments in stdlib.

* [ocaml-multicore/ocaml-multicore#626](https://github.com/ocaml-multicore/ocaml-multicore/pull/626)
  Add Obj.drop_continuation
  
  Added a `caml_drop_continuation` primitive to `runtime/fiber.c` to
  prevent leaks with leftover continuations.

#### Upstream

* [ocaml-multicore/ocaml-multicore#584](https://github.com/ocaml-multicore/ocaml-multicore/pull/584)
  Modernise signal handling

  The Multicore OCaml signals implementation is now closer to that of
  upstream OCaml.

* [ocaml-multicore/ocaml-multicore#600](https://github.com/ocaml-multicore/ocaml-multicore/pull/600)
  Expose a few more GC variables in headers

  The `caml_young_start`, `caml_young_limit` and `caml_minor_heap_wsz`
  variables have now been defined in the runtime.

* [ocaml-multicore/ocaml-multicore#612](https://github.com/ocaml-multicore/ocaml-multicore/pull/612)
  Make intern and extern work with Multicore

  The upstream changes to intern and extern have now been incorporated
  to work with the Multicore OCaml runtime.

#### Fixes

* [ocaml-multicore/ocaml-multicore$604](https://github.com/ocaml-multicore/ocaml-multicore/pull/604)
  Fix unguarded `caml_skiplist_empty` in `caml_scan_global_young_roots`
  
  A patch that fixes a locking bug with global roots observed on a Mac
  OS CI with `parallel/join.ml`.

* [ocaml-multicore/ocaml-multicore#621](https://github.com/ocaml-multicore/ocaml-multicore/pull/621)
  otherlibs: `encode_terminal_status` does not set all fields

  A minor fix for the error caused when moved from using
  `caml_initialize_field` to `caml_initialize` in otherlibs.

* [ocaml-multicore/ocaml-multicore#628](https://github.com/ocaml-multicore/ocaml-multicore/pull/628)
  In link_channel, channel->prev should be set to NULL
  
  A PR to fix the memory leak when using `flush_all` with `ocamlc` as
  reported by Filip Koprivec.

* [ocaml-multicore/ocaml-multicore#629](https://github.com/ocaml-multicore/ocaml-multicore/pull/629)
  Backtrace last exn is val unit
  
  A fix for the crash reported on running core's test suite by
  clearing `backtrace_last_exn` to `Val_unit` in
  `runtime/backtrace.c`.

## Ecosystem

### Ongoing

* [ocaml-multicore/ocaml-uring#36](https://github.com/ocaml-multicore/ocaml-uring/pull/36)
  Update to cstruct 6.0.1
  
  ocaml-uring is now updated to use `Cstruct.shiftv` with the upgrade
  to cstruct.6.0.1.

* [ocaml-multicore/domainslib#37](https://github.com/ocaml-multicore/domainslib/issues/37)
  parallel_map
  
  A request by @nbecker to provide a `parallel_map` function over
  arrays having the following signature:
  
  ```ocaml
  val parallel_map : Domainslib.Task.pool -> ('a -> 'b) -> 'a array -> 'b array
  ```

* [ocaml-multicore/domainslib#38](https://github.com/ocaml-multicore/domainslib/issues/38)
  parallel_scan rejects arrays not larger than pool size
  
  An "index out of bounds" exception is thrown for
  `Task.parallel_scan` with arrays not larger than the pool size as
  reported by @nbecker.

### Completed

* [ocaml-multicore/eventlog-tools#4](https://github.com/ocaml-multicore/eventlog-tools/pull/4)
  Add `domain/condition_wait` event
  
  The `lib/consts.ml` file in eventlog-tools now includes the
  `domain/condition_wait` event.

* [ocaml-multicore/domainslib#34](https://github.com/ocaml-multicore/domainslib/pull/34)
  Fix initial value accounting in `parallel_for_reduce`

  The initial value of `parallel_for_reduce` has been fixed so as to
  not be accounted multiple times.

#### Eio

The `eio` library provides an effects-based parallel IO stack for
Multicore OCaml.

##### Ongoing

* [ocaml-multicore/eio#68](https://github.com/ocaml-multicore/eio/pull/68)
  WIP: Add eio_luv backend
  
  A work-in-progress to use `luv` that provides OCaml/Reason bindings
  to libuv for a cross-platform backend for eio.

##### Completed

* [ocaml-multicore/eio#62](https://github.com/ocaml-multicore/eio/pull/62)
  Update to latest MDX to fix exception reporting
  
  Dune has been updated to 2.9 along with necessary changes for
  exception reporting with MDX.
  
* [ocaml-multicore/eio#63](https://github.com/ocaml-multicore/eio/pull/63)
  Update README
  
  A documentation update specifying the following steps required to
  manually pin the effects version of `ppxlib` and
  `ocaml-migrate-parsetree`.
  
  ```
  opam switch create 4.12.0+domains+effects --repositories=multicore=git+https://github.com/ocaml-multicore/multicore-opam.git,default
  opam pin add -yn ppxlib 0.22.0+effect-syntax
  opam pin add -yn ocaml-migrate-parsetree 2.1.0+effect-syntax
  ```

* [ocaml-multicore/eio#64](https://github.com/ocaml-multicore/eio/pull/64)
  Improvements to traceln
  
  Enhancements to `traceln` to make it an Effect along with changes to
  trace output and addition of tests.

* [ocaml-multicore/eio#65](https://github.com/ocaml-multicore/eio/pull/65)
  Add Flow.read_methods for optimised reading
  
  The addition of `read_methods` in the `Flow` module as a faster
  alternative to reading into a buffer.

* [ocaml-multicore/eio#66](https://github.com/ocaml-multicore/eio/pull/66)
  Allow cancelling waiting for a semaphore
  
  Update to `lib_eio/semaphore.ml` to allow cancel waiting for a
  semaphore.

* [ocaml-multicore/eio#67](https://github.com/ocaml-multicore/eio/pull/67)
  Add more generic exceptions
  
  The inclusion of generic exceptions to avoid depending on
  backend-specific exceptions. The tests have also been updated.

## Benchmarking

### Sandmark Nightly

#### Ongoing

* [ocaml-bench/sandmark-nightly#4](https://github.com/ocaml-bench/sandmark-nightly/issues/4)
  Parallel notebook pausetimes graphing for navajo results throws an error
  
  The parallel Jupyter notebook for pausetimes throws a ValueError
  that needs to be investigated.
  
* [ocaml-bench/sandmark-nightly#5](https://github.com/ocaml-bench/sandmark-nightly/issues/5)
  Status of disabled benchmarks
  
  The `alt-ergo`, `frama-c`, and `js_of_ocaml` benchmark results that
  were disabled from the Jupyter notebooks have to be tested with
  recent versions of Multicore OCaml.

* [ocaml-bench/sandmark-nightly#6](https://github.com/ocaml-bench/sandmark-nightly/issues/6)
  Parallel scalability number on navajo look odd
  
  The parallel performance numbers on the navajo build server for
  scalability will need to be reviewed and the experiments repeated
  and validated.

* [ocaml-bench/sandmark-nightly#7](https://github.com/ocaml-bench/sandmark-nightly/issues/7)
  Use `col_wrap` as 3 instead of 5 in the normalised results in parallel notebook
  
  For better readability, it is recommended to use col_wrap as 3 in
  the normalised results in the parallel notebook.

* [ocaml-bench/sandmark-nightly#8](https://github.com/ocaml-bench/sandmark-nightly/issues/8)
  View results for a set of benchmarks in the nightly notebooks

  A feature request to filter benchmarks by name or by tags when used
  with Jupyter notebooks.

* [ocaml-bench/sandmark-nightly#9](https://github.com/ocaml-bench/sandmark-nightly/issues/9)
  Static HTML pages for the recent results

  The benchmark results from the most recent build runs should be used
  to generate static HTML reports for review and analysis.

#### Completed

* [ocaml-bench/sandmark-nightly#2](https://github.com/ocaml-bench/sandmark-nightly/issues/2)
  Timestamps are not sorted in the parallel_nightly notebook
  
  The listing of timestamps in the drop-down option is now sorted.
  
![Sandmark-nightly-PR-2-Fix|307x313](https://discuss.ocaml.org/uploads/short-url/yH1GqDjGUKpHol6fVERCUgNsUfh.png)

### Sandmark

#### Ongoing

* [ocaml-bench/sandmark#243](https://github.com/ocaml-bench/sandmark/issues/243)
  Add irmin tree benchmark
  
  A request to add the Irmin tree.ml benchmark to Sandmark, including
  necessary dependencies and data files.

* [ocaml-bench/sandmark#245](https://github.com/ocaml-bench/sandmark/pull/245)
  Add dune.2.9.0

  An update to dune.2.9.0 in order to build coq with Multicore OCaml
  on Sandmark.

* [ocaml-bench/sandmark#247](https://github.com/ocaml-bench/sandmark/issues/247)
  Sandmark breaks on OCaml 4.14.0+trunk
  
  The Sandmark build for OCaml 4.14.0+trunk needs to be resolved as we
  begin upstreaming more Multicore OCaml changes.
  
* [ocaml-bench/sandmark#248](https://github.com/ocaml-bench/sandmark/issues/248)
  coq fails to build

  The `coq` package is failing to build with 4.12.0+domains+effects
  with Sandmark on navajo server.

#### Completed

* [ocaml-bench/sandmark#233](https://github.com/ocaml-bench/sandmark/pull/233)
  Update pausetimes_multicore to fit with the latest Multicore changes

  The Multicore pausetimes have now been updated for the 4.12.0
  upstream and 4.12.0 branches which now use the new Common Trace
  Format (CTF).

* [ocaml-bench/sandmark#235](https://github.com/ocaml-bench/sandmark/issues/235)
  Update selected benchmarks as a set for baseline benchmark

  You now have the option to only filter from the user selected
  variants in the Jupyter notebooks.

![Sandmark-PR-235-Fix|690x77](https://discuss.ocaml.org/uploads/short-url/gTg6GrPpJCJsMO4H6tmpqljtvD4.png)

* [ocaml-bench/sandmark#237](https://github.com/ocaml-bench/sandmark/issues/237)
  Run sandmark_nightly on a larger machine

  The Sandmark nightly builds now run on a 64+ core machine to benefit
  from the improvements to Domainslib.

* [ocaml-bench/sandmark#240](https://github.com/ocaml-bench/sandmark/pull/240)
  Add navajo specific parallel config.json file
  
  A navajo server-specific run_config.json file has been added to
  Sandmark to run Multicore parallel benchmarks.

* [ocaml-bench/sandmark#242](https://github.com/ocaml-bench/sandmark/pull/242)
  Add commentary on grammatrix
  
  A documentation update for the grammatrix benchmark on customised
  task distribution via channels and the use of `parallel_for`.

* [ocaml-bench/sandmark#244](https://github.com/ocaml-bench/sandmark/pull/244)
  Add chrt to pausetimes_multicore wrapper
  
  The use of `chrt -r 1` in paramwrapper is required with
  `pausetimes_multicore` to use the taskset arguments.

* [ocaml-bench/sandmark#246](https://github.com/ocaml-bench/sandmark/pull/246)
  Add trunk build to CI
  
  The .drone.yml file has now been updated to include 4.14.0+stock
  trunk build for the CI.

### current-bench

#### Ongoing

* [ocurrent/current-bench#117](https://github.com/ocurrent/current-bench/issues/117)
  Read stderr from the docker container
  
  We are able to run Sandmark-2.0 -alpha branch with current-bench
  now, and it is useful to view the error output when running with
  Docker containers.
  
* [ocurrent/current-bench#146](https://github.com/ocurrent/current-bench/issues/146)
  Replicate ocaml-bench-server setup
  
  A request to dynamically pass the Sandmark benchmark target commands
  to current-bench in order to create pipelines.

## OCaml

### Completed

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints

  The PR has been cherry-picked on 4.13 and finally merged with
  upstream OCaml.

We would like to thank all the OCaml users, developers and contributors in the community for their valuable time and support to the project. Stay safe and have a great summer if you are northern hemispherically based!

## Acronyms

* AFL: American Fuzzy Lop
* CI: Continuous Integration
* CTF: Common Trace Format
* GC: Garbage Collector
* GCC: GNU Compiler Collection
* GTK: GIMP ToolKit
* HTML: HyperText Markup Language
* IO: Input/Output
* OPAM: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* STW: Stop The World
