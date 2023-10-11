---
title: OCaml Multicore - September 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-09-01"
tags: [multicore]
---

Welcome to the September 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This month's update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by me, @ctk21, @kayceesrk and @shakthimaan. The team has been working over the past few months to finish the [last few features](https://github.com/ocaml-multicore/ocaml-multicore/projects/4) necessary to reach feature parity with stock OCaml. We also worked closely with the core OCaml team to develop the timeline for upstreaming Multicore OCaml to stock OCaml, and have now agreed that:

**OCaml 5.0 will support shared-memory parallelism through domains _and_ direct-style concurrency through effect handlers (without syntactic support)**. 

- The [Domain mechanism](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml) permits OCaml programmers to speed up OCaml code by taking advantage of parallel processing via multiple cores available on modern processors. 
- Effect handlers allow OCaml programmers to write [high-performance concurrent programs in direct-style](https://github.com/ocaml-multicore/eio), without the use of monadic concurrency as is the case today with the Lwt and Async libraries. Effect handlers also serve as a useful abstraction to build other non-local control-flow abstractions such as [generators](https://github.com/ocaml-multicore/effects-examples/blob/master/generator.ml), [lightweight threads](https://github.com/ocaml-multicore/effects-examples/blob/master/sched.ml), etc. OCaml will be one of [the first industrial-strength languages to support effect handlers](https://arxiv.org/abs/2104.00250). 

The new code will have to go through the usual rigorous review process of contributions to upstream OCaml, but we expect to advance the review process over the next few months. 

## Recap: what are effect handlers?

Below is an excerpt from ["Retrofitting Effect Handlers onto OCaml"](https://arxiv.org/pdf/2104.00250.pdf):

> Effect handlers provide a modular foundation for user-defined effects. The key idea is to separate the definition of the effectful operations from their interpretations, which are given by handlers of the effects. For example:
>
> ```ocaml
> effect In_line : in_channel -> string
> ```
>
> declares an effect `In_line`, which is parameterised with an input channel of type `in_channel`, which when performed returns a `string` value. A computation can perform the `In_line` effect without knowing how the `In_line` effect is implemented. This computation may be enclosed by different handlers that handle `In_line` differently. For example, `In_line` may be implemented by performing a blocking read on the input channel or performing the read asynchronously by offloading it to an event loop such as libuv, without changing the computation.
>
> Thanks to the separation of effectful operations from their implementation, effect handlers enable new approaches to modular programming. Effect handlers are a generalisation of exception handlers, where, in addition to the effect being handled, the handler is provided with the delimited continuation of the perform site. This continuation may be used to resume the suspended computation later. This enables non-local control-flow mechanisms such as resumable exceptions, lightweight threads, coroutines, generators and asynchronous I/O to be composably expressed.

The implementation of effect handlers in OCaml are *single-shot* -- that is, a continuation can be resumed only once, and must be explicitly discontinued if not used. This restriction makes for easier reasoning about control flow in the presence of mutable data structures, and also allows for a high performance implementation. 

You can read more about effect handlers in OCaml in the [full paper](https://arxiv.org/pdf/2104.00250.pdf).

## Why is there no syntactic support for effect handlers in OCaml 5.0?

Effect handlers currently in Multicore OCaml do not ensure [*effect safety*](https://arxiv.org/abs/2104.00250). That is, the compiler will not ensure that all the effects performed by the program are handled. Instead, unhandled effects lead to exceptions at runtime. Since we plan to extend OCaml with support for an [effect system](https://github.com/ocaml/subsystem-meetings/tree/main/effect_system/2021-09-30) in the future, OCaml 5.0 will not feature the syntactic support for programming with effect handlers. Instead, we expose the same features through functions from the standard library, reserving the syntax decisions for when the effect system  lands. The function based effect handlers is just as expressive as the current syntaxful version in Multicore OCaml. As an example, the syntax-free version of:

```ocaml
effect E : string 

let comp () =
  print_string "0 ";
  print_string (perform E);
  print_string "3 "
     
let main () = 
  try 
    comp () 
  with effect E k -> 
    print_string "1 "; 
    continue k "2 ";  
    print_string “4 " 
```

will be:


```ocaml
type _ eff += E : string eff
     
let comp () = 
  print_string "0 "; 
  print_string (perform E); 
  print_string "3 "
     
let main () =
  try_with comp () 
  { effc = fun e -> 
      match e with 
      | E -> Some (fun k ->  
          print_string "1 ";
          continue k "2 "; 
          print_string “4 “)
      | e -> None }
```

One can imagine writing a ppx extension that enable programmers to write code that is close to the earlier version.

## Which opam switch should I use today?

The `4.12+domains` opam switch has _all_ the features that will go into OCaml 5.0, including the effect-handlers-as-functions. The exact module under which the functions go will likely change by 5.0, but the basic form should remain the same.

The `4.12+domains+effects` opam switch will be preserved, but the syntax will not be upstreamed. This switch is mainly useful to try out the examples of OCaml effect handlers in the academic literature.

To learn more about programming using this effect system, see the [eio](https://github.com/ocaml-multicore/eio) library and [this recent talk](https://watch.ocaml.org/videos/watch/74ece0a8-380f-4e2a-bef5-c6bb9092be89). In the next few weeks, the `eio` library will be ported to `4.12+domains` to use the function based effect handlers so that it is ready for OCaml 5.0.

## Onto the September 21 update

A number of enhancements have been merged to improve the thread safety of the stdlib, improve the test suite coverage, along with the usual bug fixes. The documentation for the ecosystem projects has been updated for readabilty, grammar and consistency. The sandmark-nightly web service is currently being Dockerized to be deployed for visualising and analysing benchmark results. The Sandmark 2.0-beta branch is also released with the 2.0 features, and is available for testing and feedback.

We would like to acknowledge the following people for their contribution:
* @lingmar (Linnea Ingmar) for reporting a segmentation fault in 4.12.0+domains at `caml_shared_try_alloc`.
* @dhil (Daniel Hillerström) provided a patch to remove `drop_continuation` in the compiler sources.
* @nilsbecker (Nils Becker) reported a crash with 14 cores when using Task.pool management.
* @cjen1 (Chris Jensen) observed and used ulimit to fix a `Unix.ENOMEM` error when trying out the Eio README example.
* @anuragsoni (Anurag Soni) has contributed an async HTTP benchmark for `retro-httpaf-bench`.

As always, the Multicore OCaml updates are listed first, which are then followed by the updates from the ecosystem tools and libraries. The Sandmark-nightly work-in-progress and the Sandmark benchmarking tasks are finally listed for your reference.

## Multicore OCaml

### Ongoing

#### Thread Safe

* [ocaml-multicore/ocaml-multicore#632](https://github.com/ocaml-multicore/ocaml-multicore/issues/632)
  `Str` module multi domain safety
  
  The
  [PR#635](https://github.com/ocaml-multicore/ocaml-multicore/pull/635)
  makes `lib-str` domain safe to work concurrently with Multicore
  OCaml.

* [ocaml-multicore/ocaml-multicore#636](https://github.com/ocaml-multicore/ocaml-multicore/issues/636)
  Library building locks for thread-safe mutability
  
  An open discussion on the possibility of creating two modules for
  simple, mutable-state libraries that are thread-safe.

#### Segmentation Fault

* [ocaml-multicore/ocaml-multicore#639](https://github.com/ocaml-multicore/ocaml-multicore/issues/639)
  Segfaults in GC
  
  An ongoing investigation on the segmentation fault caused at
  `caml_shared_try_alloc` in 4.12.0+domains as reported by @lingmar
  (Linnea Ingmar) .

* [ocaml-multicore/ocaml-multicore#646](https://github.com/ocaml-multicore/ocaml-multicore/issues/646)
  Coq segfaults during build
  
  The Coq proof assistant results in a segmentation fault when run
  with Multicore OCaml, and a new tarball has been provided for
  testing.

#### Test Suite

* [ocaml-multicore/ocaml-multicore#640](https://github.com/ocaml-multicore/ocaml-multicore/pull/640)
  GitHub Actions for Windows
  
  The GitHub Actions have been updated to run the Multicore OCaml test
  suite on Windows.

* [ocaml-multicore/ocaml-multicore#641](https://github.com/ocaml-multicore/ocaml-multicore/issues/641)
  Get the multicore testsuite runner to parity with stock OCaml
  
  The Multicore disabled tests need to be reviewed to see if they can
  be re-enabled, and also run them in parallel, similar to trunk.

#### Sundries

* [ocaml-multicore/ocaml-multicore#637](https://github.com/ocaml-multicore/ocaml-multicore/issues/637)
  `caml_page_table_lookup` is not available in ocaml-multicore
  
  The `ancien` package uses `Is_in_heap_or_young` macro which
  internally uses `caml_page_table_lookup` that is not implemented yet
  in Multicore OCaml.
  
* [ocaml-multicore/ocaml-multicore#653](https://github.com/ocaml-multicore/ocaml-multicore/pull/653)
  Drop `drop_continuation`
  
  A PR contributed by @dhil (Daniel Hillerström) to remove
  `drop_continuation` since `clone_continuation` has also been
  removed.

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#631](https://github.com/ocaml-multicore/ocaml-multicore/pull/631)
  Don't raise asynchronous exceptions from signals in `caml_alloc` C functions
  
  A PR that prevents asynchronous exceptions being raised from signal
  handlers, and avoids polling for pending signals from `caml_alloc_*`
  calls from C.

* [ocaml-multicore/ocaml-multicore#638](https://github.com/ocaml-multicore/ocaml-multicore/pull/638)
  Add some injectivity annotations to the standard library
  
  The injectivity annotations have been backported to `stdlib` from
  4.12.0 in order to compile `stdcompat` with Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#642](https://github.com/ocaml-multicore/ocaml-multicore/issues/642)
  Remove the remanents of page table functionality
  
  Page tables are not used in Multicore OCaml, and the respective
  macro and function definitions have been removed.

* [ocaml-multicore/ocaml-multicore#643](https://github.com/ocaml-multicore/ocaml-multicore/issues/643)
  `Core_kernel` minor words report are off
  
  The report of allocated words are skewed because the `young_ptr` and
  `young_end` are defined as `char *`. The PR to change them to `value
  *` has now been merged.

* [ocaml-multicore/ocaml-multicore#652](https://github.com/ocaml-multicore/ocaml-multicore/pull/652)
  Make `young_start/end/ptr` pointers to value
  
  The `young_start`, `young_end`, and `young_ptr` use in Multicore
  OCaml has been updated to `value *` instead of `char *` to align
  with trunk.

#### Backports

* [ocaml-multicore/ocaml-multicore#573](https://github.com/ocaml-multicore/ocaml-multicore/pull/573)
  Backport trunk safepoints PR to multicore

  The Safepoints implementation has now been backported to Multicore
  OCaml.

* [ocaml-multicore/ocaml-multicore#644](https://github.com/ocaml-multicore/ocaml-multicore/pull/644)
  Minor fixes
  
  A patch that replaces the deprecated macro `Modify` with
  `caml_modify`, and adds reference to `caml_alloc_float_array` in
  `runtime/caml/alloc.h`.

* [ocaml-multicore/ocaml-multicore#649](https://github.com/ocaml-multicore/ocaml-multicore/pull/649)
  Integrate all of trunk's EINTR fixes
  
  The fixes for EINTR-based signals from
  [ocaml/ocaml#9722](https://github.com/ocaml/ocaml/pull/9722) have
  been incorporated into Multicore OCaml.

#### Thread Safe

* [ocaml-multicore/ocaml-multicore#630](https://github.com/ocaml-multicore/ocaml-multicore/pull/630)
  Make signals safe for Multicore
  
  The signals implementation has been overhauled in Multicore OCaml
  with clear and correct semantics.

* [ocaml-multicore/ocaml-multicore#635](https://github.com/ocaml-multicore/ocaml-multicore/pull/635)
  Make `lib-str` domain safe
  
  The PR moves the use of global variables in `str` to thread local
  storage. A test case that does `str` computations in parallel has
  also been added.

#### Effect Handlers

* [ocaml-multicore/ocaml-multicore#650](https://github.com/ocaml-multicore/ocaml-multicore/pull/650)
  Add primitives necessary for exposing effect handlers as functions
  
  The inclusion of primitives to facilitate updates to `4.12+domains`
  to continue to work with changes from `4.12+domains+effects`.

* [ocaml-multicore/ocaml-multicore#651](https://github.com/ocaml-multicore/ocaml-multicore/pull/651)
  Expose deep and shallow handlers as functions
  
  The PR exposes deep and shallow handlers as functions in the Obj
  module. It also removes the ability to clone continuations.

#### Sundries

* [ocaml-multicore/ocaml-multicore#633](https://github.com/ocaml-multicore/ocaml-multicore/issues/633)
  Error building 4.12.0+domains with `no-flat-float-arrays`

  The linker error has been fixed in
  [PR#644](https://github.com/ocaml-multicore/ocaml-multicore/pull/644).

* [ocaml-multicore/ocaml-multicore#647](https://github.com/ocaml-multicore/ocaml-multicore/pull/647)
  Improving Multicore's issue template
  
  The Multicore OCaml bug report template has been improved with
  sections for `Describe the issue`, `To reproduce`, `Multicore OCaml
  build version`, `Did you try running it with the debug runtime and
  heap verificiation ON?`, and `Backtrace`.

## Ecosystem

##### Ongoing

* [ocaml-multicore/domainslib#43](https://github.com/ocaml-multicore/domainslib/issues/43)
  Possible bug in `Task.pool` management
  
  A segmentation fault on Task.pool management when using 14 cores as
  reported by @nilsbecker (Nils Becker).

* [ocaml-multicore/multicore-opam#59](https://github.com/ocaml-multicore/multicore-opam/pull/59)
  Fix batteries after ocaml-multicore/ocaml-multicore#514
  
  Update the `batteries.3.3.0+multicore` opam file for
  `batteries-included` with the correct src URL.

* [ocaml-multicore/multicore-opam#60](https://github.com/ocaml-multicore/multicore-opam/issues/60)
  Multicore domains+effects language server does not work with VS Code
  
  A `Request textDocument/hover failed` error shows up with VS Code
  when using Multicore domains+effects language server.

* [ocaml-multicore/eio#81](https://github.com/ocaml-multicore/eio/issues/81)
  Is IO prioritisation possible?
  
  A query on IO prioritisation and on scheduling of fibres for
  consensus systems.

##### Completed

###### Build

* [ocaml-multicore/eventlog-tools](https://github.com/ocaml-multicore/eventlog-tools/pull/3)
  Use ocaml/setup-ocaml@v2
  
  The GitHub workflows have now been updated to use 4.12.x
  ocaml-compiler and `ocaml/setup-ocaml@v2` in
  `.github/workflows/main.yml` file.

* [ocaml-multicore/tezos#3](https://github.com/ocaml-multicore/tezos/pull/3)
  Add cron job and run tests
  
  The CI Dockerfile and GitHub workflows have been changed to run the
  tests periodically for Tezos on Multicore OCaml.

* [ocaml-multicore/tezos#4](https://github.com/ocaml-multicore/tezos/pull/4)
  Run cronjob daily
  
  The GitHub cronjob is now scheduled to run daily for the Tezos
  builds from scratch.

* [ocaml-multicore/retro-httpaf-bench#12](https://github.com/ocaml-multicore/retro-httpaf-bench/issues/12)
  Dockerfile fails to build
  
  The issue no longer exists, and the Dockerfile now builds fine in
  the CI as well.

* [ocaml-multicore/eio#80](https://github.com/ocaml-multicore/eio/issues/80)
  ENOMEM with README example
  
  @cjen1 (Chris Jensen) reported a `Unix.ENOMEM` error that prevented
  the following README example code snippet from execution. Using
  `ulimit` with the a smaller memory size fixes the same.
  
  ```ocaml
  #require "eio_main";;
  open Eio.Std;;

  let main ~stdout = Eio.Flow.copy_string "hello World" stdout
  Eio_main.run @@ fun env -> main ~stdout:(Eio.Stdenv.stdout env)
  ;;
  ```
  
###### Documentation

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#10](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/10)
  Edited for flow/syntax/consistency
  
  The Parallel Programming in Multicore OCaml chapter has been
  reviewed and updated for consistency, syntax flow and readability.

* [ocaml-multicore/eio#79](https://github.com/ocaml-multicore/eio/pull/79)
  Initial edits for consistency, formatting and clarity
  
  The README in the Eio project has been updated for consistency,
  formatting and readability.

* The [ocaml2020-workshop-parallel](https://github.com/ocaml-multicore/multicore-talks/tree/master/ocaml2020-workshop-parallel)
  README has been updated with reference links to books, videos,
  project repository, and the OCaml Multicore wiki.
   
###### Benchmarks

* [ocaml-multicore/retro-httpaf-bench#15](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/15)
  Optimise Go code

  The `nethttp-go/httpserv.go` Go benchmark now uses `Write` instead
  of `fmt.Fprintf` with removal of yield() for optimization.

* [ocaml-multicore/retro-httpaf-bench](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/16)
  Add an async HTTP benchmark
  
  @anuragsoni (Anurag Soni) has contributed an async HTTP benchmark
  that was run inside Docker on a 4-core i7-8559 CPU at 2.70 GHz with
  1000 connections and 60 second runs.

   ![retro-httpaf-bench-16-performance|690x460](https://discuss.ocaml.org/uploads/short-url/8VMquoc8s1vHUZQWbmHDiFQuiCI.jpeg)

## Benchmarking

### Sandmark-nightly

#### Ongoing

* [ocaml-bench/sandmark-nightly#10](https://github.com/ocaml-bench/sandmark-nightly/issues/10)
  Dockerize sandmark-nightly
  
  The sandmark-nightly service needs to be dockerized to be able to
  run on multiple machines.
  
* [ocaml-bench/sandmark-nightly#11](https://github.com/ocaml-bench/sandmark-nightly/issues/11)
  Refactor the sandmark-nightly notebooks
  
  The code in the sandmark-nightly notebooks need to be refactored and
  modularized so that they can be reused as a library.

* [ocaml-bench/sandmark-nightly#12](https://github.com/ocaml-bench/sandmark-nightly/issues/12)
  Normalization graphs (with greater than two benchmarks) needs to be fixed
  
  The normalization graphs only produce one coloured bar group even if
  there are more than two benchmarks. It needs to show more than one
  coloured graph when compared with the baseline.

* [ocaml-bench/sandmark-nightly#13](https://github.com/ocaml-bench/sandmark-nightly/issues/13)
  Store the logs from the nightly runs along with the results
  
  The nightly run logs can be stored as they are useful for debugging
  any failures.

* [ocaml-bench/sandmark-nightly#14](https://github.com/ocaml-bench/sandmark-nightly/issues/14)
  Add `best-fit` variant to sequential benchmarks
  
  The sandmark-nightly runs should include the best-fit allocator as
  it is better than the next-fit allocator. The best-fit allocator can
  be enabled using the following command:
  
  ```
  $ OCAMLRUNPARAM="a=2" ./a.out
  ```

* [ocaml-bench/sandmark-nightly#16](https://github.com/ocaml-bench/sandmark-nightly/issues/16)
  Cubicle and Coq benchmarks are missing from the latest navajo nightly runs
  
  The UI for the sequential benchmarks fail to load normalized graphs
  because of missing Cubicle and Coq benchmark .bench files.

* [ocaml-bench/sandmark-nightly#17](https://github.com/ocaml-bench/sandmark-nightly/issues/17)
  Navajo runs are on stale Sandmark
  
  The Sandmark deployed on navajo needs to be updated to the latest
  Sandmark, and the `git pull` is failing due to uncommitted changes
  to the Makefile.

### Sandmark

#### Ongoing

* [ocaml-bench/sandmark#248](https://github.com/ocaml-bench/sandmark/issues/248)
  Coq fails to build
  
  A new Coq tarball to build with Multicore OCaml is now available for
  testing at
  [coq-multicore-2021-09-24](https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24).
  
* Sandmark `2.0-beta`

  The Sandmark
  [2.0-beta](https://github.com/ocaml-bench/sandmark/tree/2.0-beta)
  branch is now available for testing. It includes new features such
  as package override option, adding meta-information to the benchmark
  results, running multiple iterations, classification of benchmarks,
  user configuration, and simplifies package dependency
  management. You can test the branch for the following OCaml compiler
  variants:
  
  - 4.12.0+domains
  - 4.12.0+stock
  - 4.14.0+trunk
  
  ```
  $ git clone https://github.com/ocaml-bench/sandmark.github
  $ cd sandmark
  $ git checkout 2.0-beta
  
  $ make clean; TAG='"run_in_ci"' make run_config_filtered.json
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.12.0+domains.bench

  $ make clean; TAG='"run_in_ci"' make run_config_filtered.json
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.12.0+stock.bench

  $ make clean; TAG='"run_in_ci"' make run_config_filtered.json
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.14.0+trunk.bench

  $ make clean; TAG='"macro_bench"' make multicore_parallel_run_config_filtered.json
  $ RUN_BENCH_TARGET=run_orunchrt BUILD_BENCH_TARGET=multibench_parallel RUN_CONFIG_JSON=multicore_parallel_run_config_filtered.json make ocaml-versions/4.12.0+domains.bench
  ```
  
  Please report any issues that you face in our [GitHub
  project](https://github.com/ocaml-bench/sandmark/issues) page.
  
#### Completed

* [ocaml-bench/sandmark#251](https://github.com/ocaml-bench/sandmark/pull/251)
  Update dependencies to work with `4.14.0+trunk`

  The Sandmark master branch dependencies have now been updated to
  build with 4.14.0+trunk.

* [ocaml-bench/sandmark#253](https://github.com/ocaml-bench/sandmark/pull/253)
  Remove `Domain.Sync.poll()` from parallel benchmarks
  
  The Domain.Sync.poll() function call is now deprecated and the same
  has been removed from the parallel benchmarks in Sandmark.

* [ocaml-bench/sandmark#254](https://github.com/ocaml-bench/sandmark/pull/254)
  Disable sandboxing
  
  The `--disable-sandboxing` option is now passed as default to opam
  when setting up the local `_opam` directory for Sandmark builds.

We would like to thank all the OCaml users, developers and contributors in the community for their continued support to the project. Stay safe!

## Acronyms

* CI: Continuous Integration
* CPU: Central Processing Unit
* GC: Garbage Collector
* HTTP: Hypertext Transfer Protocol
* IO: Input/Output
* OPAM: OCaml Package Manager
* PR: Pull Request
* UI: User Interface
* URL: Uniform Resource Locator
* VS: Visual Studio
