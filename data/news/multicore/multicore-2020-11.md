---
title: OCaml Multicore - November 2020
description: Monthly update from the OCaml Multicore team.
date: "2020-11-01"
tags: [multicore]
---

Welcome to the November 2020 Multicore OCaml report! This update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by @shakthimaan, @kayceesrk, and @avsm.

**Multicore OCaml:** Since the support for systhreads has been merged last month, many more ecosystem packages compile.  We have been doing bulk builds (using a specialised [opam-health-check instance](https://check.ci.ocaml.org/)) against the opam repository in order to chase down the last of the lingering build bugs. Most of the breakage is around packages using C stubs related to the garbage collector, although we did find a few actual multicore bugs (related to the thread machinery when using dynlink). The details are under "ecosystem" below. We also spent a lot of time on optimising the stack discipline in the multicore compiler, as part of writing a draft paper on the effect system (more details on that later).

**Upstream OCaml:** The [4.12.0alpha2 release](https://discuss.ocaml.org/t/ocaml-4-12-0-second-alpha-release/6887) is now out, featuring the dynamic naked pointer checker to help make your code only used external pointers that are boxed. Please do run your codebase on it to help prepare.  For OCaml 4.13 (currently the `trunk`) branch, we had a full OCaml developers meeting where we decided on the worklist for what we're going to submit upstream.  The major effort is on [GC safe points](https://github.com/ocaml/ocaml/pull/10039) and not caching the [minor heap pointer](https://github.com/ocaml/ocaml/pull/9876), after which the runtime domains support has all the necessary prerequisites upstream.  Both of those PRs are highly performance sensitive, so there is a lot of poring over graphs going on (notwithstanding the irrepressible @stedolan offering [a massive driveby optimisation](https://github.com/ocaml/ocaml/pull/10039#issuecomment-733912979)).

**Sandmark Benchmarking:** The lockfree and Graph500 benchmarks have been added and updated to Sandmark respectively, and we continue to work on the tooling aspects. Benchmarking tests are also being done on AMD, ARM and PowerPC hardware to study the performance of the compiler. With reference to stock OCaml, the safepoints PR has now landed for review.

As with previous updates, the Multicore OCaml tasks are listed first, which are then followed by the progress on the Sandmark benchmarking test suite. Finally, the upstream OCaml related work is mentioned for your reference.

## Multicore OCaml

### Ongoing

* [ocaml-multicore/ocaml-multicore#439](https://github.com/ocaml-multicore/ocaml-multicore/pull/439)
  Systhread lifecycle work
  
  An improvement to the initialization of systhreads for general
  resource handling, and freeing up of descriptors and stacks. There
  now exists a new hook on domain termination in the runtime.

* [ocaml-multicore/ocaml-multicore#440](https://github.com/ocaml-multicore/ocaml-multicore/issues/440)
  `ocamlfind ocamldep` hangs in no-effect-syntax branch

  The `nocrypto` package fails to build for Multicore OCaml
  no-effect-syntax branch, and ocamlfind loops continuously. A minimal
  test example has been created to reproduce the issue.

* [ocaml-multicore/ocaml-multicore#443](https://github.com/ocaml-multicore/ocaml-multicore/issues/443)
  Minor heap allocation startup cost
  
  An issue to keep track of the ongoing investigations on the impact
  of large minor heap size for OCaml Multicore programs. The
  sequential and parallel exeuction run results for various minor heap
  sizes are provided in the issue.

* [ocaml-multicore/ocaml-multicore#446](https://github.com/ocaml-multicore/ocaml-multicore/pull/446)
  Collect GC stats at the end of minor collection
  
  The objective is to remove the use of double buffering in the GC
  statistics collection by using the barrier present during minor
  collection in the parallel_minor_gc schema. There is not much
  slowdown for the benchmark runs, normalized against stock OCaml as
  seen in the illustration.
![PR 446 Graph Image](https://discuss.ocaml.org/uploads/short-url/i4js513ml6Qw6GvkZuQsiVuowYB.png)

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#426](https://github.com/ocaml-multicore/ocaml-multicore/pull/426)
  Replace global roots implementation

  This PR replaces the existing global roots implementation with that
  of OCaml's `globroots`, wherein the implementation places locks
  around the skip lists. In future, the `Caml_root` usage will be
  removed along with its usage in globroots.

* [ocaml-multicore/ocaml-multicore#427](https://github.com/ocaml-multicore/ocaml-multicore/pull/427)
  Garbage Collector colours change backport
  
  The [Garbage Collector colours
  change](https://github.com/ocaml/ocaml/pull/9756) PR from trunk for
  the major collector have now been backported to Multicore
  OCaml. This includes the optimization for `mark_stack_push`, the
  `mark_entry` does not include `end`, and `caml_shrink_mark_stack`
  has been adapted from trunk.

* [ocaml-multicore/ocaml-multicore#432](https://github.com/ocaml-multicore/ocaml-multicore/pull/432)
  Remove caml_context push/pop on stack switch
  
  The motivation to remove the use of `caml_context` push/pop on stack
  switches to make the implementation easier to understand, and to be
  closer to upstream OCaml.

#### Stack Improvements

* [Fix stack overflow on scan stack#431](https://github.com/ocaml-multicore/ocaml-multicore/pull/431)
  Fix issue 421: Stack overflow on scan stack
  
  The `caml_scan_stack` now uses a while loop to avoid a stack
  overflow corner case where there is a deep nesting of fibers.

* [ocaml-multicore/ocaml-multicore#434](https://github.com/ocaml-multicore/ocaml-multicore/pull/434)
  DWARF fixups for effect stack switching
  
  The PR provides fixes for `runtime/amd64.S` on issues found using a
  DWARF validator. The patch also cleans up dead commented out code,
  and updates the DWARF information when we do `caml_free_stack` in
  `caml_runstack`.

* [ocaml-multicore/ocaml-multicore#435](https://github.com/ocaml-multicore/ocaml-multicore/pull/435)
  Mark stack overflow backport
  
  The mark-stack overflow implementation has been updated to be closer
  to trunk OCaml. The pools are added to a skiplist first to avoid any
  duplicates, and the pools in `pools_to_rescan` are marked later
  during a major cycle. The result of the `finalise` benchmark time
  difference with mark stack overflow is shown below:
  
![PR 435 Graph Image](https://discuss.ocaml.org/uploads/short-url/xZoOkroQdawrkU6SaistBe7j0FG.png) 

* [ocaml-multicore/ocaml-multicore#437](https://github.com/ocaml-multicore/ocaml-multicore/pull/437)
  Avoid an allocating C call when switching stacks with continue
  
  The `caml_continuation_use` has been updated to use
  `caml_continuation_use_noexc` and it does not throw an
  exception. The allocating C `caml_c_call` is no longer required to
  call `caml_continuation_use_noexc`.

* [ocaml-multicore/ocaml-multicore#441](https://github.com/ocaml-multicore/ocaml-multicore/pull/441)
  Tidy up and more commenting of caml_runstack in amd64.S
  
  The PR adds comments on how stacks are switched, and removes
  unnecessary instructions in the x86 assembler.

* [ocaml-multicore/ocaml-multicore#442](https://github.com/ocaml-multicore/ocaml-multicore/pull/442)
  Fiber stack cache (v2)
  
  Addition of stack caching for fiber stacks, which also fixes up bugs
  in the test suite (DEBUG memset, order of initialization). We avoid
  indirection out of `struct stack_info` when managing the stack
  cache, and efficiently calculate the cache freelist bucket for a
  given stack size.

#### Ecosystem

* [ocaml-multicore/lockfree#5](https://github.com/ocaml-multicore/lockfree/pull/5)
  Remove Kcas dependency
  
  The `Kcas.Wl` module is now replaced with the Atomic module
  available in Multicore stdlib. The exponential backoff is
  implemented with `Domain.Sync.cpu_relax`.

* [ocaml-multicore/domainslib#21](https://github.com/ocaml-multicore/domainslib/pull/21)
  Point to the new repository URL
  
  Thanks to Sora Morimoto (@smorimoto) for providing a patch that
  updates the URL to the correct ocaml-multicore repository.

* [ocaml-multicore/multicore-opam#40](https://github.com/ocaml-multicore/multicore-opam/pull/40)
  Add multicore Merlin and dot-merlin-reader
  
  A patch to merlin and dot-merlin-reader to work with Multicore OCaml
  4.10.

* [ocaml-multicore/ocaml-multicore#403](https://github.com/ocaml-multicore/ocaml-multicore/issues/403)
  Segmentation fault when trying to build Tezos on Multicore
  
  The latest fixes on replacing the global roots implementation, and
  fixing the STW interrupt race to the no-effect-syntax branch has
  resolved the issue.

#### Compiler Fixes

* [ocaml-multicore/ocaml-multicore#438](https://github.com/ocaml-multicore/ocaml-multicore/pull/438)
  Allow C++ to use caml/camlatomic.h
  
  The inclusion of extern "C" headers to allow C++ to use
  caml/camlatomic.h for building ubpf.0.1.

* [ocaml-multicore/ocaml-multicore#447](https://github.com/ocaml-multicore/ocaml-multicore/pull/447)
  domain_state.h: Remove a warning when using -pedantic

  A fix that uses `CAML_STATIC_ASSERT` to check the size of
  `caml_domain_state` in domain_state.h, in order to remove the
  warning when using -pedantic.

* [ocaml-multicore/ocaml-multicore#449](https://github.com/ocaml-multicore/ocaml-multicore/pull/449)
  Fix stdatomic.h when used inside C++ for good
  
  Update to `caml/camlatomic.h` with extern C++ declaration to use it
  inside C++. This builds upbf.0.1 and libsvm.0.10.0 packages.

#### Sundries

* [ocaml-multicore/ocaml-multicore#422](https://github.com/ocaml-multicore/ocaml-multicore/pull/422)
  Simplify minor heaps configuration logic and masking

  A `Minor_heap_max` size is introduced to reserve the minor heaps
  area, and `Is_young` for relying on a boundary check. The
  `Minor_heap_max` parameter can be overridden using the OCAMLRUNPARAM
  environment variable. This implementation approach is geared towards
  using Domain local allocation buffers.

* [ocaml-multicore/ocaml-multicore#429](https://github.com/ocaml-multicore/ocaml-multicore/pull/429)
  Fix a STW interrupt race

  A fix for the STW interrupt race in
  `caml_try_run_on_all_domains_with_spin_work`. The
  `enter_spin_callback` and `enter_spin_data` fields of `stw_request`
  are now initialized after we interrupt other domains.

* [ocaml-multicore/ocaml-multicore#430](https://github.com/ocaml-multicore/ocaml-multicore/pull/430)
  Add a test to exercise stored continuations and the GC
  
  The PR adds test coverage for interactions between the GC with
  stored, cloned and dropped continuations to exercise the minor and
  major collectors.
  
* [ocaml-multicore/ocaml-multicore#444](https://github.com/ocaml-multicore/ocaml-multicore/pull/444)
  Merge branch 'parallel_minor_gc' into 'no-effect-syntax'
  
  The `parallel_minor_gc` branch has been merged into the
  `no-effect-syntax` branch, and we will try to keep the
  `no-effect-syntax` branch up-to-date with the latest changes.

## Benchmarking

### Ongoing

* [ocaml-bench/sandmark#196](https://github.com/ocaml-bench/sandmark/pull/196)
  Filter benchmarks based on tag

  An enhancement to move towards a generic implementation to filter
  the benchmarks based on tags, instead of relying on custom targets
  such as _macro.json or _ci.json.

* [ocaml-bench/sandmark#191](https://github.com/ocaml-bench/sandmark/pull/191)
  Make parallel.ipynb notebook interactive
  
  The parallel.ipynb notebook has been made interactive with drop-down
  menus to select the .bench files for analysis. The notebook README
  has been merged with the top-level README file. A sample
  4.10.0.orunchrt.bench along with the *pausetimes_multicore.bench
  files have been moved to the test artifacts/ folder for user
  testing.

* We are continuing to test the use of `opam-compiler` switch
  environment to execute the Sandmark benchmark test suite. We have
  been able to build the dependencies, `orun` and `rungen`, the
  `OCurrent` pipeline and its dependencies, and `ocaml-ci` for the
  ocaml-multicore:no-effect-syntax branch. We hope to converge to a
  2.0 implementation with the required OCaml tools and ecosystem.

### Completed

* [ocaml-bench/sandmark#179](https://github.com/ocaml-bench/sandmark/issues/179)
  [RFC] Classifying benchmarks based on running time
  
  The [Classification of
  benchmarks](https://github.com/ocaml-bench/sandmark/pull/188) PR has
  been resolved, which now classifies the benchmarks based on their
  running time:
  * `lt_1s`: Benchmarks that run for less than 1 second.
  * `lt_10s`: Benchmarks that run for at least 1 second, but, less than 10 seconds.
  * `10s_100s`: Benchmarks that run for at least 10 seconds, but, less than 100 seconds.
  * `gt_100s`: Benchmarks that run for at least 100 seconds.

* [ocaml-bench/sandmark#189](https://github.com/ocaml-bench/sandmark/pull/189)
  Add environment support for wrapper in JSON configuration file
  
  The OCAMLRUNPARAM arguments can now be passed as an environment
  variable when executing the benchmarks in runtime. The environment
  variables can be specified in the `run_config.json` file, as shown
  below:
  
  ```json
   {
      "name": "orun_2M",
      "environment": "OCAMLRUNPARAM='s=2M'",
      "command": "orun -o %{output} -- taskset --cpu-list 5 %{command}"
    }
  ```

* [ocaml-bench/sandmark#183](https://github.com/ocaml-bench/sandmark/pull/183)
  Use crout_decomposition name for numerical analysis benchmark

  The `numerical-analysis/lu_decomposition.ml` benchmark has now been
  renamed to `crout_decomposition.ml` to avoid naming confusion, as
  there are a couple of LU decomposition benchmarks in Sandmark.

* [ocaml-bench/sandmark#190](https://github.com/ocaml-bench/sandmark/pull/190)
  Bump trunk to 4.13.0
  
  The trunk version in Sandmark ocaml-versions/ has now been updated
  to use `4.13.0+trunk.json`.

* [ocaml-bench/sandmark#192](https://github.com/ocaml-bench/sandmark/pull/192)
  GraphSEQ corrected
  
  The minor fix for the Kronecker generator has been provided for the
  Graph500 benchmark.
  
* [ocaml-bench/sandmark#194](https://github.com/ocaml-bench/sandmark/pull/194)
  Lockfree benchmarks
  
  The lockfree benchmarks for both the serial and parallel
  implementation are now included in Sandmark, and it uses the
  `lockfree_bench` tag. The time and speedup illustrations are as follows:
  
![PR 194 Time Image](https://discuss.ocaml.org/uploads/short-url/bnMWcVZTMo1mahmtkawHOho3rA.png)
![PR 194 Speedup Image](https://discuss.ocaml.org/uploads/short-url/fIrArMCzcRLfO1hyyDH7dDIpFT0.png) 

## OCaml

### Ongoing

* [ocaml/ocaml#9876](https://github.com/ocaml/ocaml/pull/9876)
  Do not cache young_limit in a processor register

  The removal of `young_limit` caching in a register is being
  evaluated using Sandmark benchmark runs to test the impact change on
  for ARM64, PowerPC and RISC-V ports hardware.

* [ocaml/ocaml#9934](https://github.com/ocaml/ocaml/pull/9934)
  Prefetching optimisations for sweeping

  The PR includes an optimization of `sweep_slice` for the use of
  prefetching, and to reduce cache misses during GC. The normalized
  running time graph is as follows:

![PR 9934 Graph](https://discuss.ocaml.org/uploads/short-url/b1kXzk2cPuQFZyw0gGLhYzzTpUP.png) 

* [ocaml/ocaml#10039](https://github.com/ocaml/ocaml/pull/10039)
  Safepoints
  
  A draft Safepoints implementation for AMD64 for the 4.11 branch that
  are implemented by adding a new `Ipoll` operation to Mach. The
  benchmark results on an AMD Zen2 machine are given below:

![PR 10039 Benchmark](https://discuss.ocaml.org/uploads/short-url/f1LVGM7v68n8PXO2vkgspojINrr.png) 

Many thanks to all the OCaml users and developers for their continued support, and contribution to the project.

## Acronyms

* ARM: Advanced RISC Machine
* DWARF: Debugging With Attributed Record Formats
* GC: Garbage Collector
* JSON: JavaScript Object Notation
* OPAM: OCaml Package Manager
* PR: Pull Request
* PR: Pull Request
* RFC: Request For Comments
* RISC-V: Reduced Instruction Set Computing - V
* STW: Stop-The-World
* URL: Uniform Resource Locator
