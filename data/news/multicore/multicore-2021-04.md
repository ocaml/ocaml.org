---
title: OCaml Multicore - April 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-04-01"
tags: [multicore]
---

# Multicore OCaml: April 2021

Welcome to the April 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! My friends and colleagues on the project in India are going through a terrible second wave of the Covid pandemic, but continue to work to deliver all the updates from the Multicore OCaml project. This month's update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by myself, @kayceesrk and @shakthimaan.

## Upstream OCaml 4.13 development

GC safepoints continues to be the focus of the OCaml 4.13 release development for multicore. While it might seem quiet with only [one PR](https://github.com/ocaml/ocaml/pull/10039) being worked on, you can also look at [the compiler fork](https://github.com/sadiqj/ocaml/pull/3) where an intrepid team of adventurous compiler backend hackers have been refining the design.  You can also find more details of ongoing upstream work in the first [core compiler development newsletter](https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-1-before-may-2021/7831).   To quote @xavierleroy from there, "*it’s a nontrivial change involving a new static analysis and a number of tweaks in every code emitter, but things are starting to look good here.*".

## Multicore OCaml trees

The switch to using OCaml 4.12 has now completed, and all of the development PRs are now working against that version.  We've put a lot of focus into establishing whether or not Domain Local Allocation Buffers ([ocaml-multicore#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508)) should go into the initial 5.0 patches or not.

What are DLABs?  When testing multicore on larger core counts (up to 128), we observed that there was a lot of early promotion of values from the minor GCs (which are per-domain). DLABs were introduced in order to encourage domains to have more values that remained heap-local, and this *should* have increased our scalability.  But computers being computers, we noticed the opposite effect -- although the number of early promotions dropped with DLABs active, the overall performance was either flat or even lower!  We're still working on profiling to figure out the root cause -- modern architectures have complex non-uniform and hierarchical memory and cache topologies that interact in unexpected ways.  Stay tuned to next month's monthly about the decision, or follow [ocaml-multicore#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508) directly!

## The multicore ecosystem 

Aside from this, the test suite coverage for the Multicore OCaml project has had significant improvement, and we continue to add more and more tests to the project.  Please do continue with your contribution of parallel benchmarks. With respect to benchmarking, we have been able to build the Sandmark-2.0 benchmarks with the [current-bench](https://github.com/ocurrent/current-bench) continuous benchmarking framework, which provides a GitHub frontend and PostgreSQL database to store the results.  Some other projects such as Dune have also started also using current-bench, which is nice to see -- it would be great to establish it on the core OCaml project once it is a bit more mature.

We are also rolling out a [multicore-specific CI](https://github.com/ocurrent/ocaml-multicore-ci) that can do differential testing against opam packages (for example, to help isolate if something is a multicore-specific failure or a general compilation error on upstream OCaml).  We're [pushing this live](https://multicore.ci.ocamllabs.io:8100/?org=ocaml-multicore) at the moment, and it means that we are in a position to begin accepting projects that might benefit from multicore.  **If you do have a project on opam that would benefit from being tested with multicore OCaml, and if it compiles on 4.12, then please do get in touch**.  We're initially folding in codebases we're familiar with, but we need a diversity of sources to get good coverage.  The only thing we'll need is a responsive contact within the project that can work with us on the integration.  We'll start reporting on project statuses if we get a good response to this call.

As always, we begin with the Multicore OCaml ongoing and completed tasks. This is followed by the Sandmark benchmarking project updates and the relevant Multicore OCaml feature requests in the current-bench project. Finally, upstream OCaml work is mentioned for your reference.

## Multicore OCaml

### Ongoing

#### Testing

* [ocaml-multicore/domainslib#23](https://github.com/ocaml-multicore/domainslib/issues/23)
  Running tests: moving to `dune runtest` from manual commands in `run_test` target
  
  At present, the tests are executed with explicit exec commands in
  the Makefile, and the objective is to move to using the `dune
  runtest` command.

* [ocaml-multicore/ocaml-multicore#522](https://github.com/ocaml-multicore/ocaml-multicore/issues/522)
  Building the runtime with -O0 rather than -O2 causes testsuite to fail
  
  The use of `-O0` optimization fails the runtime tests, while `-O2`
  optimization succeeds. This needs to be investigated further.
  
* [ocaml-multicore/ocaml-multicore#526](https://github.com/ocaml-multicore/ocaml-multicore/issues/526)
  weak-ephe-final issue468 can fail with really small minor heaps
  
  The failure of issue468 test is currently being looked into for the
  `weak-ephe-final` tests with a small minor heap (4096 words).

* [ocaml-multicore/ocaml-multicore#528](https://github.com/ocaml-multicore/ocaml-multicore/pull/528)
  Expand CI runs
  
  The PR implements parallel "callback" "gc-roots" "effects"
  "lib-threads" "lib-systhreads" tests, with `taskset -c 0` option,
  and using a small minor heap. The CI coverage needs to be enhanced
  to add more variants and optimization flags.
  
* [ocaml-multicore/ocaml-multicore#542](https://github.com/ocaml-multicore/ocaml-multicore/pull/542)
  Add ephemeron lazy test
  
  Addition of tests to cover ephemerons, lazy values and domain
  lifecycle with GC.
  
* [ocaml-multicore/ocaml-multicore#545](https://github.com/ocaml-multicore/ocaml-multicore/issues/545)
  ephetest6 fails with more number of domains
  
  The test `ephetest6.ml` fails when more number of domains are
  spawned, and also deadlocks at times.
  
* [ocaml-multicore/ocaml-multicore#547](https://github.com/ocaml-multicore/ocaml-multicore/issues/547)
  Investigate weaktest.ml failure
  
  The `weaktest.ml` is disabled in the test suite and it is
  failing. This needs to be investigated further.
  
* [ocaml-multicore/ocaml-multicore#549](https://github.com/ocaml-multicore/ocaml-multicore/issues/549)
  zmq-lwt test failure
  
  An opam-ci bug that has reported a failure in the `zmq-lwt` test. It
  is throwing a Zmq.ZMQ_exception with a `Context was terminated`
  error message.
  
#### Sundries

* [ocaml-multicore/ocaml-multicore#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508)
  Domain Local Allocation Buffers

  The code review and the respective changes for the Domain Local
  Allocation Buffer implementation is actively being worked upon.

* [ocaml-multicore/ocaml-multicore#514](https://github.com/ocaml-multicore/ocaml-multicore/pull/514)
  Update instructions in ocaml-variants.opam
  
  The `ocaml-variants.opam` and `configure.ac` have been updated to
  now use the Multicore OCaml repository. We want different version
  strings for `+domains` and `+domains+effects` for the branches.

* [ocaml-multicore/ocaml-multicore#527](https://github.com/ocaml-multicore/ocaml-multicore/pull/527)
  Port eventlog to CTF

  The code review on the porting of the `eventlog` implementation to
  the Common Trace Format is in progress. The relevant code changes
  have been made and the tests pass.

* [ocaml-multicore/ocaml-multicore#529](https://github.com/ocaml-multicore/ocaml-multicore/issues/529)
  Fiber size control and statistics
  
  A feature request to set the maximum stack size for fibers, and to
  obtain memory statistics for the same.

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#533](https://github.com/ocaml-multicore/ocaml-multicore/pull/533)
  Systhreads synchronization use pthread functions
  
  The `pthread_*` functions are now used directly instead of
  `caml_plat_*` functions to be in-line with OCaml trunk. The
  `Sys_error` is raised now instead of `Fatal error`.

* [ocaml-multicore/ocaml-multicore#535](https://github.com/ocaml-multicore/ocaml-multicore/pull/535)
  Remove Multicore stats collection
  
  The configurable stats collection functionality is now removed from
  Multicore OCaml. This greatly reduces the diff with trunk and makes
  it easy for upstreaming.

* [ocaml-multicore/ocaml-multicore#536](https://github.com/ocaml-multicore/ocaml-multicore/pull/536)
  Remove emit_block_header_for_closure

  The `emit_block_header_for_closure` is no longer used and hence
  removed from asmcomp sources.

* [ocaml-multicore/ocaml-multicore#537](https://github.com/ocaml-multicore/ocaml-multicore/pull/537)
  Port @stedolan "Micro-optimise allocations on amd64 to save a register"

  The upstream micro-optimise allocations on amd64 to save a register
  have now been ported to Multicore OCaml. This greatly brings down
  the diff on amd64's emit.mlp.
  
#### Enhancements

* [ocaml-multicore/ocaml-multicore#531](https://github.com/ocaml-multicore/ocaml-multicore/pull/531)
  Make native stack size limit configurable (and fix Gc.set)
  
  The stack size limit for fibers in native made is now made
  configurable through the `Gc.set` interface.

* [ocaml-multicore/ocaml-multicore#534](https://github.com/ocaml-multicore/ocaml-multicore/pull/534)
  Move allocation size information to frame descriptors
  
  The allocation size information is now propagated using the frame
  descriptors so that they can be tracked by statmemprof.

* [ocaml-multicore/ocaml-multicore#548](https://github.com/ocaml-multicore/ocaml-multicore/pull/548)
  Multicore implementation of Mutex, Condition and Semaphore
  
  The `Mutex`, `Condition` and `Semaphore` modules are now fully
  compatible with stdlib features and can be used with `Domain`.

### Testing

* [ocaml-multicore/ocaml-multicore#532](https://github.com/ocaml-multicore/ocaml-multicore/pull/532)
  Addition of test for finaliser callback with major cycle
  
  Update to `test_finaliser_gc.ml` code that adds a test wherein a
  finaliser is run with a root in a register.

* [ocaml-multicore/ocaml-multicore#541](https://github.com/ocaml-multicore/ocaml-multicore/pull/541)
  Addition of a parallel tak testcase
  
  Parallel test cases to stress the minor heap and also enter the
  minor GC organically without calling a `Gc` function or a domain
  termination have now been added to the repository.

* [ocaml-multicore/ocaml-multicore#543](https://github.com/ocaml-multicore/ocaml-multicore/pull/543)
  Parallel version of weaklifetime test
  
  The parallel implementation of the `weaklifetime.ml` test has now
  been added to the test suite, where the Weak structures are accessed
  by multiple domains.

* [ocaml-multicore/ocaml-multicore#546](https://github.com/ocaml-multicore/ocaml-multicore/pull/546)
  Coverage of domain life-cycle in domain_dls and ephetest_par tests
  
  Improvement to `domain_dls.ml` and `ephetest_par.ml` for better
  coverage for domain lifecycle testing.

#### Fixes

* [ocaml-multicore/ocaml-multicore#530](https://github.com/ocaml-multicore/ocaml-multicore/pull/530)
  Fix off-by-1 with gc_regs buckets
  
  An off-by-1 bug is now fixed when scanning the stack for the
  location of the previous `gc_regs` bucket.

* [ocaml-multicore/ocaml-multicore#540](https://github.com/ocaml-multicore/ocaml-multicore/pull/540)
  Fix small alloc retry
  
  The `Alloc_small` macro was not handling the case when the GC
  function does not return a minor heap with enough size, and this PR
  fixes the same along with code clean-ups.

#### Ecosystem

* [ocaml-multicore/retro-httpaf-bench#3](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/3)
  Add cohttp-lwt-unix to the benchmark
  
  A `cohttp-lwt-unix` benchmark is now added to the
  `retro-httpaf-bench` package along with the update to the
  Dockerfile.

* [ocaml-multicore/domainslib#22](https://github.com/ocaml-multicore/domainslib/pull/22)
  Move the CI to 4.12 Multicore and Github Actions
  
  The CI has been switched to using GitHub Actions instead of
  Travis. The version of Multicore OCaml used in the CI is now
  4.12+domains+effects.

* [ocaml-multicore/mulicore-opam#51](https://github.com/ocaml-multicore/multicore-opam/pull/51)
  Update merlin and ocaml-lsp installation instructions for 4.12 variants
  
  The README.md has been updated with instructions to use merlin and
  ocaml-lisp for `4.12+domains` and `4.12+domains+effects` branches.

* [dwarf_validator](https://github.com/ocaml-multicore/dwarf_validator)
  DWARF validation tool

  The DWARF validation tool in `eh_frame_check.py` is now made
  available in a public repository. It single steps through the binary
  as it executes, and unwinds the stack using the DWARF directives.

#### Sundries

* [ocaml-multicore/ocaml-multicore#523](https://github.com/ocaml-multicore/ocaml-multicore/pull/523)
  Systhreads Mutex raises Sys_error

  The Systhreads Mutex error checks are now inline with OCaml, as
  mentioned in [Use "error checking" mutexes in the threads
  library](https://github.com/ocaml/ocaml/pull/9846).

* [ocaml-multicore/ocaml-multicore#525](https://github.com/ocaml-multicore/ocaml-multicore/pull/525)
  Add issue URL for disabled signal handling test
  
  Updated `testsuite/disabled` with the issue URL
  [ocaml-multicore#517](https://github.com/ocaml-multicore/ocaml-multicore/issues/517)
  for future tracking.

* [ocaml-multicore/ocaml-multicore#539](https://github.com/ocaml-multicore/ocaml-multicore/pull/539)
  Forcing_tag invalid argument to Gc.finalise
  
  Addition of `Forcing_tag` for tag lazy values when the computation
  is being forced. This is included so that `Gc.finalise` can raise an
  invalid argument exception when a block with `Forcing_tag` is given
  as an argument.

## Benchmarking

### Ongoing

#### Sandmark

* We now have the frontend showing the graph results for Sandmark 2.0 builds
  with [current-bench](https://github.com/ocurrent/current-bench) for
  CI. A raw output of the graph is shown below:

![current-bench Sandmark-2.0 frontend |312x499](https://discuss.ocaml.org/uploads/short-url/6KOMezRFdkjjNtsfxLx1en2muu3.png)

  The Sandmark 2.0 benchmarking is moving to use the `current-bench`
  tooling. You can now create necessary issues and PRs for the
  Multicore OCaml project in the `current-bench` project using the
  `multicore` label.

* [ocaml-bench/sandmark#209](https://github.com/ocaml-bench/sandmark/pull/209)
  Use rule target kronecker.txt and remove from macro_bench

  A rewrite of the graph500seq `kernel1.ml` implementation based on
  the code review suggestions is currently being worked upon.
  
* [ocaml-bench/sandmark#215](https://github.com/ocaml-bench/sandmark/pull/215)
  Remove Gc.promote_to from treiber_stack.ml
  
  We are updating Sandmark to run with 4.12+domains and
  4.12+domains+effects, and this patch removes Gc.promote_to from the
  runtime.

#### current-bench

* [ocurrent/current-bench#87](https://github.com/ocurrent/current-bench/issues/87)
  Run benchmarks for old commits
  
  We would like to be able to re-run the benchmarks for older commits
  in a project for analysis and comparison.

* [ocurrent/current-bench#103](https://github.com/ocurrent/current-bench/issues/103)
  Ability to set scale on UI to start at 0
  
  The raw results plotted in the graph need to start from `[0, y_max+delta]` for the y-axis for better comparison. A  [PR](https://github.com/ocurrent/current-bench/pull/74) is available  for the same, and the fixed output is shown in the following graph:

![current-bench frontend fix 0 baseline](https://discuss.ocaml.org/uploads/short-url/7O9maG73iBof7WgJtXGm80OtbfA.jpeg)

* [ocurrent/current-bench#105](https://github.com/ocurrent/current-bench/issues/105)
  Abstract out Docker image name from `pipeline/lib/pipeline.ml`
  
  The Multicore OCaml uses `ocaml/opam:ubuntu-20.10-ocaml-4.10` image
  while the `pipeline/lib/pipeline.ml` uses `ocaml/opam`, and it will
  be useful to use an environment variable for the same.

* [ocurrent/current-bench#106](https://github.com/ocurrent/current-bench/issues/106)
  Use `--privileged` with Docker run_args for Multicore OCaml
  
  The Sandmark environment uses `bwrap` for Multicore OCaml benchmark
  builds, and hence we need to run the Docker container with
  `--privileged` option. Otherwise, the build exits with an `Operation
  not permitted` error.

* [ocurrent/current-bench#107](https://github.com/ocurrent/current-bench/issues/107)
  Ability to start and run only PostgreSQL and frontend
  
  For Multicore OCaml, we provision the hardware with different
  configuration settings for various experiments, and using an ETL
  tool to just load the results to the PostgreSQL database and
  visualize the same in the frontend will be useful.

* [ocurrent/current-bench#108](https://github.com/ocurrent/current-bench/issues/108)
  Support for native builds for bare metals
  
  In order to avoid any overhead with Docker, we need a way to run the
  Multicore OCaml benchmarks on bare metal machines.

### Completed

#### Documentation

* [ocurrent/current-bench#75](https://github.com/ocurrent/current-bench/pull/75)
  Fix production deployment; add instructions
  
  The HACKING.md is now updated with documentation for doing a
  production deployment of current-bench.

* [ocurrent/current-bench#90](https://github.com/ocurrent/current-bench/pull/90)
  Add some solutions to errors that users might run into
  
  Based on our testing of current-bench with Sandmark-2.0, we now have
  updated the FAQ in the HACKING.md file.

#### Sundries

* [ocurrent/current-bench#96](https://github.com/ocurrent/current-bench/pull/96)
  Remove hardcoded URL for the frontend
  
  The frontend URL is now abstracted out from the code, so that we can
  deploy a current-bench instance on any new pristine server.

* [ocaml-bench/sandmark#204](https://github.com/ocaml-bench/sandmark/pull/204)
  Adding layers.ml as a benchmark to Sandmark

  The Irmin layers.ml benchmark is now added to Sandmark along with
  its dependencies. This is tagged with `gt_100s`.

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints

  This PR is a work-in-progress. Thanks to Mark Shinwell and Damien
  Doligez and Xavier Leroy for their valuable feedback and code suggestions.
  
Special thanks to all the OCaml users and developers from the community for their continued support and contribution to the project. Stay safe!

## Acronyms

* AMD: Advanced Micro Devices
* CI: Continuous Integration
* CTF: Common Trace Format
* DLAB: Domain Local Allocation Buffer
* DWARF: Debugging With Attributed Record Formats
* ETL: Extract Transform Load
* GC: Garbage Collector
* OPAM: OCaml Package Manager
* PR: Pull Request
* UI: User Interface
* URL: Uniform Resource Locator
* ZMQ: ZeroMQ
