---
title: OCaml Multicore - February 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-02-01"
tags: [multicore]
---

Welcome to the February 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report. This update along with the [previous update's](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by me, @kayceesrk and @shakthimaan. February has seen us focus heavily on stability in the multicore trees, as unlocking the ecosystem builds and running bulk CI has given us a wealth of issues to help chase down corner case issues.  The work on upstreaming the next hunk of changes to OCaml 4.13 is also making great progress.

Overall, we remain on track to have a parallel-capable multicore runtime (versioned 5.0) after the next release of OCaml (4.13.0), although the exact release details have yet to be ratified in a core OCaml developers meeting.  Excitingly, we have also made significant progress on concurrency, and there are details below of a new paper on that topic.

## 4.12.0: released with multicore-relevant changes

[OCaml 4.12.0 has been released]() with a large number of internal changes [required for multicore OCaml](https://github.com/ocaml/ocaml/issues?q=is%3Aclosed+label%3Amulticore-prerequisite+) such as GC colours handling, the removal of the page table and modifications to the heap representations.

From a developer perspective, there is now a new configure option called the `nnpchecker` which dynamically instruments the runtime to help you spot the use of unboxed C pointers in your bindings. This was described here [earlier against 4.10](https://discuss.ocaml.org/t/ann-a-dynamic-checker-for-detecting-naked-pointers/5805), but it is now also live on the [opam repository CI](https://github.com/ocurrent/opam-repo-ci/pull/79).  From now on, **new opam package submissions will alert you with a failing test if naked pointers are detected** in your opam package test suite.  Please do try to include tests in your opam package to gain the benefits of this! 

The screenshot below shows this working on the LLVM package (which is known to have naked pointers at present).

![image|690x458, 75%](https://discuss.ocaml.org/uploads/short-url/cJM9PwGOvVdDz8eGxkZMK7DOKra.jpeg) 

## 4.13~dev: upstreaming progress

Our PR queue for the 4.13 release is largely centred around the integration of "safe points", which provide stronger guarantees that the OCaml mutator will poll the garbage collector regularly even when the application logic isn't allocating regularly.  This work began almost [three years ago](https://github.com/ocaml-multicore/ocaml-multicore/issues/187) in the multicore OCaml trees, and is now under [code review in upstream OCaml](https://github.com/ocaml/ocaml/pull/10039) -- please do chip in with any performance or code size tests on that PR.

Aside from this, the team is working various other pre-requisites such as a multicore-safe Lazy, implementing the memory model (explained in this [PLDI 18 paper](https://dl.acm.org/doi/10.1145/3192366.3192421 - [403 Forbidden])) and adapting the ephemeron API to be more parallel-friendly.  It is not yet clear which of these will get into 4.13, and which will be put straight into the 5.0 trees yet.

## post OCaml 5.0: concurrency and fibres

We are very happy to share a new preprint on ["Retrofitting Effect Handlers onto OCaml"](https://kcsrk.info/papers/drafts/retro-concurrency.pdf), which continues our "retrofitting" series to cover the elements of _concurrency_ necessary to express interleavings in OCaml code.  This has been conditionally accepted to appear (virtually) at PLDI 2021, and we are currently working on the camera ready version. Any feedback would be most welcome to @kayceesrk or myself.  The abstract is below:

> Effect handlers have been gathering momentum as a mechanism for modular programming with user-defined effects. Effect handlers allow for non-local control flow mechanisms such as generators, async/await, lightweight threads and coroutines to be composably expressed. We present a design and evaluate a full-fledged efficient implementation of effect handlers for OCaml, an industrial-strength multi-paradigm programming language. Our implementation strives to maintain the backwards compatibility and performance profile of existing OCaml code. Retrofitting effect handlers onto OCaml is challenging since OCaml does not currently have any non-local control flow mechanisms other than exceptions. Our implementation of effect handlers for OCaml: (i) imposes negligible overhead on code that does not use effect handlers; (ii) remains compatible with program analysis tools that inspect the stack; and (iii) is efficient for new code that makes use of effect handlers.

We have a strong focus on making sure that the existing nice properties of OCaml's native code implementation (and in particular, debugging and backtraces) are maintained in our proposed concurrency extensions. As with any such major change to OCaml, the contents of this paper should be considered research-grade until they have been ratified at a future core OCaml developers meeting.  But by all means, please do experiment with fibres and effects and get us feedback!  We're currently working on a high performance [direct-style IO stack](http://github.com/ocaml-multicore/eioio) that has very promising early performance numbers.

If you want to learn more about effects, @kayceesrk gave a talk on `Effective
Programming` at Lambda Days 2021 ([presentation slides](https://speakerdeck.com/kayceesrk/effective-programming-in-ocaml-at-lambda-days-2021)).

## Performance Measurements with Sandmark

@shakthimaan presented the upcoming features of Sandmark 2.0 and its future roadmap in a community talk. The [slide deck](http://shakthimaan.com/downloads/Sandmark-2.0.pdf) is published online, and please do send him any feedback to questions you might have about performance benchmarking. A complete regression testing for various targets and build tags for the Sandmark 2.0 -alpha branch was completed, and we continue to work on the new features for a 2.0 release.
Onto the details then! The Multicore OCaml updates are listed first, which are then followed by the various ongoing and completed tasks for the Sandmark benchmarking project. Finally, the ongoing upstream OCaml work is listed for your reference.

## Multicore OCaml

### Ongoing

#### Ecosystem

* [ocaml-multicore/multicore-opam#46](https://github.com/ocaml-multicore/multicore-opam/pull/46)
  Multicore compatible ocaml-migrate-parsetree.2.1.0
  
  A patch to make the `ocaml-migrate-parsetree` sources use the effect
  syntax. This now builds fine with Multicore OCaml `parallel_minor_gc`.

* [ocaml-multicore/multicore-opam#47](https://github.com/ocaml-multicore/multicore-opam/pull/47)
  Multicore compatible ppxlib
  
  The effect syntax has now been added to `ppxlib`, and this is now
  compatible with Multicore OCaml.

#### Improvements

* [ocaml-multicore/ocaml-multicore#474](https://github.com/ocaml-multicore/ocaml-multicore/pull/474)
  Fixing remarking to be safe with parallel domains

  A draft proposal to fix the problem of remarking pools owned by
  another domain. The solution aims to move the remarking a pool to
  the domain that owns the pool.

* [ocaml-multicore/ocaml-multicore#477](https://github.com/ocaml-multicore/ocaml-multicore/pull/477)
  Move TLS areas to a dedicated memory space
  
  The PR changes the way we allocate an individual domain's TLS. The
  present implementation is not optimal for Domain Local Allocation
  Buffer, and hence the patch moves the TLS areas to its own memory
  alloted space.

* [ocaml-multicore/ocaml-multicore#480](https://github.com/ocaml-multicore/ocaml-multicore/pull/480)
  Remove leave_when_done and friends from STW API
  
  The `stw_request.leave_when_done` is cleaned up by removing the
  barriers from `caml_try_run_on_all_domains*` and `stw_request`.

#### Sundries

* [ocaml-multicore/ocaml-multicore#466](https://github.com/ocaml-multicore/ocaml-multicore/issues/466)
  Fix corruption when remarking a pool in another domain and that
  domain allocates
  
  An on-going investigation for the bytecode test failure for
  `parallel/domain_parallel_spawn_burn`. The recommendation is to have
  a remark queue per domain, and a global remark queue to hold work
  for any orphaned pools or work which could not be enqueued onto a
  domain.

* [ocaml-multicore/ocaml-multicore#468](https://github.com/ocaml-multicore/ocaml-multicore/issues/468)
  Finalisers causing segfault with multiple domains
  
  A test case has been submitted where Finalisers cause segmentation
  faults with multiple domains.

* [ocaml-multicore/ocaml-multicore#471](https://github.com/ocaml-multicore/ocaml-multicore/issues/471)
  Unix.fork fails with "unlock: Operation not permitted"
  
  The no blocking section on fork implementation is causing a fatal
  error during unlock with an "operation not permitted" message. This
  has been reported by opam-ci.
  
* [ocaml-multicore/ocaml-multicore#473](https://github.com/ocaml-multicore/ocaml-multicore/issues/473)
  Building an musl requires dynamically linked execinfo

  An attempt by Haz to build Multicore OCaml with musl. It failed
  because of requiring to link with external libexecinfo.

* [ocaml-multicore/ocaml-multicore#475](https://github.com/ocaml-multicore/ocaml-multicore/issues/475)
  Don't reuse opcode of bytecode instructions

  An issue raised by Hugo Heuzard on extending existing opcodes and
  appending instructions, instead of reusing opcodes and shifting them
  in Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#479](https://github.com/ocaml-multicore/ocaml-multicore/issues/479)
  Continuation_already_taken crashes toplevel

  A continuation already taken segmentation fault crash reported for
  the iterator-to-generator exercise for 4.10.0+multicore on x86-64.

### Completed

#### Global roots

* [ocaml-multicore/ocaml-multicore#472](https://github.com/ocaml-multicore/ocaml-multicore/pull/472)
  Major GC: Scan global roots from one domain
  
  As a first step towards parallelizing global roots scanning, a patch
  is provided that scans the global roots from only one domain in a
  major cycle. The parallel benchmark results with the patch is shown
  in the illustration below:

![PR 472 Parallel Benchmarks|690x464](https://discuss.ocaml.org/uploads/short-url/9wDWXWe106w049s4WuxTcxe48mV.jpeg) 


* [ocaml-multicore/ocaml-multicore#476](https://github.com/ocaml-multicore/ocaml-multicore/pull/476)
  Global roots parallel tests
  
  The `globroots_parallel_single.ml` and
  `globroots_parallel_multiple.ml` tests are now added to keep a check
  on global roots interaction with domain lifecycle.

#### CI

* [ocaml-multicore/ocaml-multicore#478](https://github.com/ocaml-multicore/ocaml-multicore/pull/478)
  Remove .travis.yml
  
  We have now removed the use of Travis for CI, as we now use GitHub
  actions.

* We now have introduced labels that you can use when filing bugs for
  Multicore OCaml. The current set of labels are listed at
  https://github.com/ocaml-multicore/ocaml-multicore/labels.

#### Sundries

* [ocaml-multicore/ocaml-multicore#464](https://github.com/ocaml-multicore/ocaml-multicore/pull/464)
  Replace Field_imm with Field
  
  The Field_imm have been replaced with Field from the concurrent
  minor collector.

* [ocaml-multicore/ocaml-multicore#470](https://github.com/ocaml-multicore/ocaml-multicore/pull/470)
  Systhreads: Current_thread->next value should be saved
  
  A fix to handle the segmentation fault caused when the backup thread
  reuses the `Current_thread` slot.

## Benchmarking

### Ongoing

#### Fixes

* [ocaml-bench/sandmark#208](https://github.com/ocaml-bench/sandmark/pull/208)
  Fix params for simple-tests/capi
  
  The arguments to the `simple-tests/capi` benchmarks are now passed
  correctly, and they build and execute fine. The same can be verified
  using the following commands:
  
  ```
  $ TAG='"lt_1s"' make run_config_filtered.json
  $ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
  ```

* [ocaml-bench/sandmark#209](https://github.com/ocaml-bench/sandmark/pull/209)
  Use rule target kronecker.txt and remove from macro_bench
  
  The graph500seq benchmarks have been updated to use a target rule to
  build kronecker.txt prior to running `kernel2` and `kernel3`. These
  set of benchmarks have been removed from the `macro_bench` tag.

#### Sundries

* [ocaml-bench/sandmark#205](https://github.com/ocaml-bench/sandmark/issues/205) 
  [RFC] Categorize and group by benchmarks
  
  A draft proposal to categorize the Sandmark benchmarks into a family
  of algorithms based on their use and application. A suggested list
  includes `library`, `formal`, `numerical`, `graph` etc.

* [ocaml/opam-repository#18203](https://github.com/ocaml/opam-repository/pull/18203)
  [new release] orun (0.0.1)
  
  A work-in-progress to publish the `orun` package in
  opam.ocaml.org. A new `conf-libdw` package has also been created to
  handle the dependencies.

* The Sandmark 2.0 -alpha branch now includes all the bench targets
  from the present Sandmark master branch, and we have been performing
  regression builds for the various tags. The required dependency
  packages have also been added to the respective target benchmarks.

### Completed

* [ocaml/opam-repository#18176](https://github.com/ocaml/opam-repository/pull/18176)
  [new release] rungen (0.0.1)
  
  The `rungen` package has been removed from Sandmark 2.0, and is now
  available in opam.ocaml.org.

## OCaml

### Ongoing

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints
  
  The Safepoints PR implements the prologue eliding algorithm and is
  now rebased to trunk. The effect of eliding optimisation and leaf
  function optimisations reduces the number of polls as illustrated
  below:
  
![PR 10039 Polls from Leaf Functions |690x326](https://discuss.ocaml.org/uploads/short-url/i71oOOzpkK1ZtE54mzKaNngm3qM.png) 

Our thanks to all the OCaml users and developers in the community for their contribution and support to the project!


## Acronyms

* API: Application Programming Interface
* CI: Continuous Integration
* DLAB: Domain Local Allocation Buffer
* GC: Garbage Collector
* OPAM: OCaml Package Manager
* PLDI: Programming Language Design and Implementation
* PR: Pull Request
* RFC: Request For Comments
* STW: Stop The World
* TLS: Thread Local Storage