---
title: OCaml Multicore - January 2022
description: Monthly update from the OCaml Multicore team.
date: "2022-01-01"
tags: [multicore]
---

Welcome to the January 2022 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly update! This update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) has been compiled by @avsm, @ctk21, @kayceesrk and @shakthimaan.

@xavierleroy clicked "merge" on the [upstream Multicore OCaml PR#10831](https://github.com/ocaml/ocaml/pull/10831#issuecomment-1008935795) to upstream OCaml, which simultaneously made for a great start to the new year and prepared us for the hard work ahead to get to a stable release of OCaml 5.00.0! Since the merge, we have continued to work on the release via bug fixes, code improvements, and tooling support directly in the main ocaml repository. Notably, a new draft PR for [ARM64 backend support](https://github.com/ocaml/ocaml/pull/10972) has already been proposed.

OCaml 5.0 trunk also [removes a number of deprecated modules](https://github.com/ocaml/ocaml/blob/3e622e41aca318df0d8ccfeb5c65272a0d2acfa3/Changes#L47-L66), and renames `EffectHandlers` to `Effect` for consistency with the rest of the standard library. In the ecosystem, several of the key support libraries like `uring`, `multicore-opam`, and `domainslib` have had updates to work with 5.0.0+trunk. The Eio effects-based direct-style parallel IO for OCaml has had significant enhancements, and now also builds with OCaml 5.00.0+trunk. The Sandmark benchmarking suite now provides a `5.00.0+stable` and `5.00.0+trunk` OCaml variants to build the benchmarks for trunk.

# OCaml 5.00 Release Planning

The core development team is currently pinning down exactly what will constitute the OCaml 5.00 release in terms of supported features. Anything that will be part of OCaml 5.00 but not currently supported must be in this list so that we can plan for its implementation.  If you spot something that isn't below but should be, please get in touch or post a reply.  This list is, as always, subject to change as the core development team plans and implements the release.

## Runtime

* Mark stack overflow
  + Currently the mark-stack is allowed to grow to an unbounded size. There is a multicore implementation of mark stack overflow in [mc#466](https://github.com/ocaml-multicore/ocaml-multicore/issues/466) .
This design is complex and concurrently touches the major GC logic for determining when marking is complete. There is a feeling that a better design is to handle mark stack overflow with a stop-the-world section, but this has not yet been tried. 
* Statmemprof
* Make the runtime memory model safe
  + Ensure that the implementation of `caml_modify` is correct.
  + Fix warnings reported by Thread Sanitizer on the testsuite.
* Mark pre-fetching optimisation
* Minor heap design that reduces virtual memory consumption
  + [#10955](https://github.com/ocaml/ocaml/pull/10955) proposes deciding size of the minor area at program startup rather than fixed 256GB reservation now. Fixes Valgrind and AFL (with default limited virtual memory).
  + Designs exploring alternative organisation of minor heap (DLAB, BiBoP) is 
    1. Too risky to undertake now due to code change
    2. Benefits unclear. See experiments in [mc#508](https://github.com/ocaml-multicore/ocaml-multicore/pull/508).
* Make runtime safe for async callbacks
  + See the meta issue on asynchronous callback handling in [#10915](https://github.com/ocaml/ocaml/issues/10915)
  + Potentially requires changes to both the stop-the-world mechanism and major GC logic
  + Currently no proposed plan or implementation. Implementation will require significant testing and benchmarking
  + May make sense to complete as part of statmemprof work as both will potentially encounter similar implementation issues
* Eventring runtime tracing eventlog replacement
  + Monitoring and optimising GC in multicore programs is difficult, current multicore eventlog was a temporary fix
  + PR that adds eventring support to trunk in [#10964](https://github.com/ocaml/ocaml/pull/10964)
* Runtime is capable of running bytecode-only for 32-bit platforms?
  + sequential or multiple domains?
* Remove the use of mmap for `Caml_state`  (see [mc#796](https://github.com/ocaml-multicore/ocaml-multicore/issues/796))

## Stdlib

* Finish the Stdlib audit ([#10960](https://github.com/ocaml/ocaml/issues/10960))
* Domains, Mutex, Semaphore, Condition in 4.14
  + Support systhread based implementation of Domains and related modules. Mutex, Semaphore and Condition work as is. 
  + 4.14 is pretty much frozen already; so an emulation of Domains can be provided by a separate compatibility library.
* API Docs
  + Write API docs for effect handlers and domains
* Manual chapters
  + New manual chapters for effect handlers, domains and memory model
* OCamldoc thread-safety annotations
  + Introduce an OCamldoc tag for thread-safety ([#10983](https://github.com/ocaml/ocaml/pull/10983)).
  + Partial order between `domain-safe`, `systhread-safe`, `fiber-safe`. `not-concurrency-safe` as default placeholder for those API functions, modules not audited for thread-safety.
* Atomic arrays 
* Atomic mutable record fields
* Concurrency-safe lazy
  + Lazy that is safe for domains, systhreads and fibers


## Backend / middle-end

* Flambda support
* Arm64 support
  + Currently being worked on in trunk.
  + Targets are Mac M1 and AWS Graviton
* 32-bit support (
  + Sequential-only native backend is achievable on x86.  32-bit ARM can probably support multiple domains.  Time to drop x86-32 to bytecode only?
  + Wasm is 32-bit only now.
* RISC-V, Power, ...
* OpenBSD, FreeBSD merged.
  + [#10875](https://github.com/ocaml/ocaml/pull/10875) adds OpenBSD support
* MSVC support on Windows.
* Framepointer support
  + Useful for `perf` based performance benchmarking.
  + x86 and/or arm64?

## Tooling

* Revive `ocamldebug`

# January 2021 updates

As always, the Multicore OCaml updates are listed first, which are then followed by the ecosystem tooling updates. Finally, the Sandmark benchmarking tasks are listed for your reference.

## Multicore OCaml

### Ongoing

#### Discussion

* [ocaml-multicore/ocaml-multicore#750](https://github.com/ocaml-multicore/ocaml-multicore/issues/750)
  Discussing the design of Lazy under Multicore
  
  A design discussion of Lazy under Multicore OCaml that involves
  sequential Lazy, concurrency problems, duplicated computations, and
  memory safety.

* [ocaml-multicore/ocaml-multicore#795](https://github.com/ocaml-multicore/ocaml-multicore/issues/795)
  Make `Minor_heap_max` and `Max_domains` as `OCAMLRUNPARAM` options
  
  The `Minor_heap_max` is defined as 2GB and `Max_domains` as 128 in
  `runtime/caml/config.h`, and there is an OOM issue on Multicore
  OCaml when running tools like AFL and Valgrind. The `OCAMLRUNPARAM`
  option can be used to pass these parameters as arguments. An
  upstream discussion has been initiated for the same at
  [ocaml/ocaml#10971](https://github.com/ocaml/ocaml/issues/10971).

* [ocaml-multicore/ocaml-multicore#806](https://github.com/ocaml-multicore/ocaml-multicore/issues/806)
  Unify GC interrupt and signal triggering mechanisms
  
  The interaction between signal and GC interrupts need to be
  reworked, as they exist as two independent mechanisms. There has
  been progress on asynchronous actions in trunk in parallel with the
  Multicore implementation.

* [ocaml/ocaml#10861](https://github.com/ocaml/ocaml/issues/10861)
  Outstanding comments in the OCaml Multicore PR
  
  A tracker issue to record and document outstanding comments in the
  Multicore PR for the 5.00 milestone.

* [ocaml/ocaml#10915](https://github.com/ocaml/ocaml/issues/10915)
  Meta-issue on asynchronous action handling in Multicore
  
  A discussion on unifying GC interrupt and signal triggering
  mechanisms and review comments from Multicore OCaml PR#10831.

* [ocaml/ocaml#10930](https://github.com/ocaml/ocaml/issues/10930)
  Downstream patch changes for removed `Stream` and `Pervasives` library PR#10896
  
  A review of the recommended patch changes for Sandmark dependencies
  used to run parallel benchmarks for 5.00.0+trunk.

* [ocaml/ocaml#10960](https://github.com/ocaml/ocaml/issues/10960)
  Audit `stdlib` for mutable state
  
  The OCaml 5.00 stdlib implementation should be both memory and
  thread-safe, and this issue tracker has been created to audit stdlib
  for mutable state.

#### Upstream

* [ocaml/ocaml#10876](https://github.com/ocaml/ocaml/issues/10876)
  Make Format buffer more efficient to Multicore
  
  The Format buffer implementation needs to be made more efficient. In
  particular, when a second domain is spawned, Format switches to a
  buffered implementation for stdout/stderr where the writes only
  happen on flushes.

* [ocaml/ocaml#10953](https://github.com/ocaml/ocaml/issues/10953)
  `ocamltest/summarize.awk` not properly reporting abort failures on testsuite runs
  
  The `summarize.awk` and `ocamltest` can skip reporting failures if
  the log is improperly formatted, and this needs to be addressed.

* [ocaml/ocaml#10971](https://github.com/ocaml/ocaml/issues/10971)
  Means of limiting how much memory is being reserved by the runtime,
  so that Valgrind and AFL can be used
  
  The amount of virtual memory to be reserved in the OCaml runtime can
  be limited and this needs to be made a runtime parameter.

* [ocaml/ocaml#10974](https://github.com/ocaml/ocaml/pull/10974)
  `domain.c`: Use an atomic counter for domain unique IDs
  
  The dependency on a fixed `Max_domains` setting needs to be removed
  to dynamically configure the same during program execution.

#### Improvements

* [ocaml-multicore/ocaml-multicore#796](https://github.com/ocaml-multicore/ocaml-multicore/issues/796)
  `Caml_state` for domains should not use mmap
  
  The `Caml_state` is no longer located adjacent to the minor heap
  area whose allocation is done using mmap. A PR for the same is
  actively being worked upon.

* [ocaml/ocaml#10908](https://github.com/ocaml/ocaml/pull/10908)
  Fix possible race in `caml_mem_map` on Windows
  
  The `runtime/platform.c` has been updated to fix a possible race
  condition in `caml_mem_map`, and debugging printf statements have
  been removed.

* [ocaml/ocaml#10925](https://github.com/ocaml/ocaml/issues/10925)
  Rename symbol for `Caml_state` to `caml_state`
  
  `Caml_state` is a macro in Mac OS, and hence the same has been
  renamed to `caml_state` to avoid a name collision.

* [ocaml/ocaml#10950](https://github.com/ocaml/ocaml/pull/10950)
  Allocate domain state using `malloc` instead of `mmap`
  
  The PR replaces the unnecessary use of `mmap` with `malloc` to
  simplify `Caml_state` management.

* [ocaml/ocaml#10965](https://github.com/ocaml/ocaml/pull/10965)
  Thread safety for all runtime hooks
  
  The PR implements the thread-safety of hooks and restores the GC
  timing hooks in Multicore.

* [ocaml/ocaml#10966](https://github.com/ocaml/ocaml/pull/10966)
  Simplifications/cleanups/clarifications for Multicore review
  
  The APIs for signals/actions have been simplified, `caml_modify` has
  been documented, and dead code has been removed.

* [ocaml/ocaml#10969](https://github.com/ocaml/ocaml/pull/10969)
  Switch to `strerror_t` for reentrant error string conversion
  
  The PR uses `strerror_t` for string conversion as `strerror` in the
  runtime is not reentrant in the presence of multiple threads.

#### ARM64

* [ocaml/ocaml#10943](https://github.com/ocaml/ocaml/pull/10943)
  Introduce atomic loads in Cmm and Mach IRs
  
  The `Patomic_load` primitive needs to be enhanced to ease support
  for other architectures. This is required for the ARM64 support.

* [ocaml/ocaml#10972](https://github.com/ocaml/ocaml/pull/10972)
  ARM64 Multicore Support
  
  A draft PR that implements the assembler, proc and emit changes
  needed to get ARM64 working has been proposed. The changes have been
  tested on MacOS/M1 and a Linux/Graviton2.

#### Metrics

* [ocaml/ocaml#10961](https://github.com/ocaml/ocaml/issues/10961)
  Handle orphaning of GC statistics
  
  The allocation of `domain_state` to use `malloc` in Multicore
  implementation prevents freeing `Caml_state` at domain termination,
  and this issue needs to be addressed.

* [ocaml/ocaml#10964](https://github.com/ocaml/ocaml/pull/10964)
  Ring-buffer based runtime tracing (`eventring`)
  
  Eventring is a runtime tracing system designed for continuous
  monitoring of OCaml applications. The following illustration shows
  how eventring can be used to log the runtime data using Chrome's
  trace viewer.

![OCaml-PR-10964-graph |690x149](upload://RykCGqsYr4FjqCEod45QdKNwV9.png)

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#822](https://github.com/ocaml-multicore/ocaml-multicore/pull/822)
  Revert `array.c` to trunk. Introduce word-size `memmove`.
  
  The word sized `memmove` is used only when there is more than one
  domain running, and `array.c` has been updated to be closer to the
  trunk implementation.

* [ocaml-multicore/ocaml-multicore/826](https://github.com/ocaml-multicore/ocaml-multicore/pull/826)
  Address `ocaml/ocaml#10831` unnecessary diff review comments
  
  The PR updates the differences between Multicore OCaml and trunk
  based on the review of `ocaml/ocaml#10831`.

* [ocaml-multicore/ocaml-multicore#827](https://github.com/ocaml-multicore/ocaml-multicore/pull/827)
  Re-introduce sigpending change from trunk
  
  The `otherlibs/unix/signals.c` file has been updated to introduce
  the `sigpending` code from trunk.

* [ocaml-multicore/ocaml-multicore#833](https://github.com/ocaml-multicore/ocaml-multicore/pull/833)
  Address `ocaml/ocaml#10831` review comments
  
  The `runtime/` code has been to updated to address the code review
  comments and suggestions from `ocaml/ocaml#10831`.

* [ocaml-multicore/ocaml-multicore#834](https://github.com/ocaml-multicore/ocaml-multicore/pull/834)
  More changes addressing review comments on ocaml-10831
  
  The additionoal feedback from `ocaml/ocaml#10831` have been
  incorporated in this PR.

* [ocaml/ocaml#10831](https://github.com/ocaml/ocaml/pull/10831)
  Multicore OCaml

  The PR to merge Multicore OCaml to `ocaml/ocaml` with
  support for shared-memory parallelism through domains, and
  concurrency through effect handlers has been merged! 

* [ocaml/ocaml#10872](https://github.com/ocaml/ocaml/pull/10872)
  Change domain thread name setting to be more portable and best-effort_all
  
  The `caml_thread_setname` has been changed to best-effort, and cases
  to handle BSD permutations of functions have been added.

* [ocaml/ocaml#10879](https://github.com/ocaml/ocaml/pull/10879)
  Rename `EffectHandlers` module to `Effect`
  
  The `EffectHandlers` module has been renamed to `Effect` to be
  consistent with the rest of `stdlib`.

* [ocaml/ocaml#10975](https://github.com/ocaml/ocaml/pull/10975)
  Add missing changes from #10136 that may have been lost during a rebase
  
  The `runtime/io.c` code has been updated with changes from the
  PR#10831 review.

#### Improvements

* [ocaml-multicore/ocaml-multicore#830](https://github.com/ocaml-multicore/ocaml-multicore/pull/830)
  Remove `Int/Long/Bool_field` macros
  
  The `Long_val(Field())` usage alone is now sufficient as the `Int`,
  `Long` and `Bool_field` macros are no longer needed.

* [ocaml-multicore/ocaml-multicore#831](https://github.com/ocaml-multicore/ocaml-multicore/pull/831)
  Revert changes to `ocaml_floatarray_blit`
  
  The `ocaml_floatarray_blit` changes in `runtime/array.c` are
  retained to not break 32-bit compilation.

* [ocaml-multicore/ocaml-multicore#836](https://github.com/ocaml-multicore/ocaml-multicore/pull/836)
  Move bytecode only startup code into `startup_byt.c`
  
  The `startup_byt.c` file has been updated to contain the bytecode
  only startup code from `startup_aux.c`.

* [ocaml-multicore/ocaml-multicore#837](https://github.com/ocaml-multicore/ocaml-multicore/pull/837)
  `mingw-w64` backport to 4.12
  
  A `mingw-w64` backport of
  [ocaml-multicore/ocaml-multicore#351](https://github.com/ocaml-multicore/ocaml-multicore/pull/351)
  with changes rebased to 4.12+domains+effects.

* [ocaml/ocaml#10742](https://github.com/ocaml/ocaml/pull/10742)
  Reimplementation of Random using an `LXM` pseudo-random number generator
  
  The new PRNG implementation using the `L64X128` variant of the LXM
  family has been implemented to test the merged Multicore OCaml
  PR. The performance improvements on 64-bit, and not so nice
  degradation on 32-bit platform is shown below (time in seconds):
  
  ```
   x86 64 bits

   4.13  LXM

   0.30  0.21  bit
   0.28  0.20  bits
   0.42  0.31  int 0xFFEE
   0.71  0.40  int32 0xFFEEDD
   0.97  0.32  int64 0xFFEEDDCCAA
   0.72  0.31  float 1.0
  11.35  0.02  full_init 3 (/100)

   ARMv7 32 bits

   4.13  LXM

   1.75  4.84  bit
   1.53  2.78  bits
   4.63  6.16  int 0xFFEE
   5.12  6.89  int32 0xFFEEDD
  30.92 20.51  int64 0xFFEEDDCCAA
   3.36  8.30  float 1.0
  47.40  0.13  full_init 3 (/100)
  ```

* [ocaml/ocaml#10880](https://github.com/ocaml/ocaml/pull/10880)
  Use a bit-vector to record pending signals
  
  The PR uses an array of bits instead of an array of `NSIG` atomic
  0-or-1 integers to store the presence of pending signals. The
  testsuite performance with current trunk is as follows:
  
```
  real	14m8.349s
  user	20m52.485s
  sys	0m46.666s

  Event count (approx.): 5024892760014
  Overhead  Command          Shared Object                       Symbol
    16.43%  Domain0          ocamlrun                            [.] caml_check_for_pending_signals
    14.16%  Domain0          ocamlrun                            [.] caml_interprete
     6.67%  Domain1          ocamlrun                            [.] caml_check_for_pending_signals
...
```

  The testsuite output with this PR is given below:
```
  real	8m32.072s
  user	10m16.386s
  sys	0m45.736s

  Event count (approx.): 2483613262503
  Overhead  Command          Shared Object                       Symbol
    22.67%  Domain0          ocamlrun                            [.] caml_interprete
     4.21%  Domain1          ocamlrun                            [.] caml_interprete
     3.20%  Domain3          ocamlrun                            [.] caml_interprete
```

* [ocaml/ocaml#10887](https://github.com/ocaml/ocaml/pull/10887)
  Generalize the `Domain.DLS` interface to split PRNG state for child domains
  
  The PR implements a "proper" PRNG+Domains semantics for the case
  when spawning a domain splits the PRNG state.

* [ocaml/ocaml#10890](https://github.com/ocaml/ocaml/pull/10890)
  Removing unused OCAMLRUNPARAM parameters from the code and manual
  
  After the audit of OCAMLRUNPARAM options, the unused parameters have
  now been removed from the code and the manual.
  
  ```
  backtrace_enabled: in use
  cleanup_on_exit: in use
  eventlog_enabled: in use
  init_fiber_wsz: in use
  init_heap_wsz: UNUSED
  init_heap_chunk_sz: UNUSED
  init_max_stack_wsz: in use
  init_custom_major_ratio: in use
  init_custom_minor_ratio: in use
  init_custom_minor_max_bsz: in use
  init_percent_free: in use
  init_max_percent_free: UNUSED
  parser_trace: in use
  init_minor_heap_wsz: in use
  trace_level: in use
  verb_gc: in use
  verify_heap: in use
  caml_runtime_warnings: in use
  ```

* [ocaml/ocaml#10935](https://github.com/ocaml/ocaml/pull/10935)
  Reimplement `Thread.exit` using an exception
  
  The PR reimplements `Thread.exit` by simply raising a dedicated
  `Thread.Exit` exception for better resource management, instead of
  stopping the current thread.

#### Fixes

* [ocaml-multicore/ocaml-multicore#823](https://github.com/ocaml-multicore/ocaml-multicore/pull/823)
  Minor fixes
  
  Additional fixes in `runtime/`, `middle_end` and `otherlibs` code to
  be more aligned with trunk.

* [ocaml-multicore/ocaml-multicore#828](https://github.com/ocaml-multicore/ocaml-multicore/pull/828)
  Initialise `extern_flags` to 0 on extern stat init
  
  The `extern_flags` need to be initialised to zero. Otherwise, its
  subsequent use in `reachable_words` returns junk values resulting in
  memory corruption.

* [ocaml-multicore/ocaml-multicore#829](https://github.com/ocaml-multicore/ocaml-multicore/pull/829)
  Fix pthread name setting on FreeBSD/OpenBSD/NetBSD
  
  The portability changes for `pthread` naming in order to build for
  FreeBSD, OpenBSD and NetBSD.

* [ocaml/ocaml#10853](https://github.com/ocaml/ocaml/pull/10853)
  Fix a crash in `Obj.reachable_words`
  
  A segmentation fault in `Obj.reachable_words` has been fixed in this
  PR. A marshaling operation can leave the `extern_flags` with the
  `NO_SHARING` bit set, and hence the same is now initialized before
  calling `extern_init_position_table`.

* [ocaml/ocaml#10873](https://github.com/ocaml/ocaml/pull/10873)
  Fixup `Filename.check_suffix`; remove duplicate `,` fix for OCAMLRUNPARAM
  
  The PR includes the `caml_parse_ocamlrunparam` duplicate fix for
  empty `,` in OCAMLRUNPARAM, and an update to `Filename.check_suffix`
  from the review of Multicore OCaml PR#10831.

* [ocaml/ocaml#10881](https://github.com/ocaml/ocaml/pull/10881)
  Fix build for `mingw-w64` on Jenkins
  
  The `winpthread-1.dll` file is required as it sets the desired PATH
  for the builds.

* [ocaml-multicore/ocaml-multicore#832](https://github.com/ocaml-multicore/ocaml-multicore/pull/832)
  Fix reachable words, part deux
  
  The `Obj.reachable_words` has been updated to not cause a
  segmentation fault. Also, the changes have been synchronised with
  the 4.14 branch.

#### Testing

* [ocaml/ocaml#10888](https://github.com/ocaml/ocaml/pull/10888)
  Re-enable `afl-instrumentation` test, run without a virtual memory limit
  
  The `afl-fuzz` test program, run as a child process, requires more
  than 50MB of virtual memory for multicore. Hence, a fix is provided
  to remove the memory limit, and the `afl-instrumentation` tests for
  OCaml 5.00.0+trunk have been enabled.

* [ocaml/ocaml#10918](https://github.com/ocaml/ocaml/pull/10918)
  Add an explicit afl-fuzz test
  
  An `afl-fuzz` test without an timeout, and based on the
  readline-example in the manual has been added.

#### Cleanup

* [ocaml-multicore/ocaml-multicore#835](https://github.com/ocaml-multicore/ocaml-multicore/pull/835)
  Remove `get_bucket`, `get_credit` and `huge_fallback_count`
  
  The `get_bucket`, `get_credit` and `huge_fallback_count` functions
  have been removed from `stdlib`.

* [ocaml/ocaml#10863](https://github.com/ocaml/ocaml/pull/10863)
  Get rid of `<caml/compatibility.h>`

  As a follow-up to the merged Multicore OCaml PR#10831, the
  `caml/compatibility.h` header file has been removed.

* [ocaml/ocaml#10973](https://github.com/ocaml/ocaml/pull/10973)
  Remove unused `gc_regs_slot` in `domain_state`
  
  The `gc_regs_slot` is unused and is not required in the domain state
  structure. The same has been removed from the
  `otherlibs/systhreads/st_stubs.c` file.

#### Sundries

* [ocaml-multicore/ocaml-multicore#793](https://github.com/ocaml-multicore/ocaml-multicore/pull/793)
  Ring buffer-based runtime tracing (`eventring`)
  
  `Eventring` is a low-overhead runtime tracing system for continuous
  monitoring of OCaml applications. The issue has been closed to create a PR on `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#810](https://github.com/ocaml-multicore/ocaml-multicore/issues/810)
  Getting segfault/undefined behavior using Multicore with custom blocks

  The segmentation fault was being caused in C code and not OCaml, and
  hence the issue has been closed.

* [ocaml-multicore/ocaml-multicore#816](https://github.com/ocaml-multicore/ocaml-multicore/issues/816)
  Filter-tree to normalise email address from commiters
  
  The inconsistent names and email addresses among committers in
  Multicore OCaml has been fixed and merged using filter-tree.

## Ecosystem

### Ongoing

#### Eio

* [ocaml-multicore/eio#124](https://github.com/ocaml-multicore/eio/issues/124)
  Decide how to represent pathnames
  
  The paths in Eio are strings, but, we need to think on how to
  provide support for Windows paths.

* [ocaml-multicore/eio#125](https://github.com/ocaml-multicore/eio/issues/125)
  Test on Windows
  
  Eio needs to be supported on Windows, and a CI must be setup for
  this environment.

* [ocaml-multicore/eio#126](https://github.com/ocaml-multicore/eio/issues/126)
  API for spawning sub-processes
  
  A mechanism to create and manage sub-processes, similar to
  `Lwt_process` is required in `Eio`. This must work using multiple
  domains, allow passing pipes, check or report the process's exit
  status etc.

* [ocaml-multicore/eio#138](https://github.com/ocaml-multicore/eio/issues/138)
  Integrate Eio's CTF tracing with OCaml's tracing
  
  The proposed `eventring` to replace the OCaml CTF-based `eventlog`
  system can allow users to add custom events that need to be stored.

* [ocaml-multicore/eio#140](https://github.com/ocaml-multicore/eio/issues/140)
  Decide on `cstruct` vs `bytes`
  
  The IO operations with the kernel require that the GC does not move
  the address of a buffer, which can be implemented using
  `Cstruct.t`. If OCaml 5.00 guarantees that regular strings are not
  moved, then using `bytes` can be an option. Performance measurements
  to compare `cstruct` and `bytes` need to be performed.

* [ocaml-multicore/eio#146](https://github.com/ocaml-multicore/eio/issues/146)
  `lib_eio`: Add `take_all` function
  
  The `take_all` function has been added to `lib_eio/stream.ml`.

* [ocaml-multicore/eio#155](https://github.com/ocaml-multicore/eio/issues/155)
  Add `Eio_unix.FD`
  
  An `FD` module has been added to `lib_eio/unix/eio_unix.ml` to be
  used with the `Luv.0.5.11` asynchronous I/O library.

#### Sundries

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#13](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/issues/13)
  Setup CI
  
  A weekly CI build using GitHub Actions will be useful to detect any
  build failures.

* [ocaml-multicore/tezos#13](https://github.com/ocaml-multicore/tezos/pull/23)
  Merge upstream updates
  
  An issue tracker to merge the January 24, 2022 updates to the
  `4.12.0+domains` branch.

* [ocaml-multicore/tezos#24](https://github.com/ocaml-multicore/tezos/issues/24)
  Test suite failure
  
  An `Alcotest_engine__Core.Make(P) (M)` error has been reported when
  running the test suite.

* [ocaml-multicore/effects-examples#26](https://github.com/ocaml-multicore/effects-examples/pull/26)
  Port to OCaml 5.00
  
  A work-in-progress to port all the Effects examples to run with
  OCaml 5.00, without the dedicated effects syntax.

### Completed

#### Eio

##### Added

* [ocaml-multicore/eio#120](https://github.com/ocaml-multicore/eio/pull/120)
  Add `Fibre.fork_on_accept` and `Net.accept`
  
  This PR that updates `fork_on_accept` to use an accept function in a
  new switch, and passes the successful result to a handler function
  in a new fibre has been merged.

* [ocaml-multicore/eio#130](https://github.com/ocaml-multicore/eio/pull/130)
  Add Luv polling functions
  
  The Luv polling functions wrapped in Eio have been added to
  `lib_eio_luv/eio_luv.ml` for Lwt integration.

* [ocaml-multicore/eio#133](https://github.com/ocaml-multicore/eio/pull/133)
  Add `Switch.dump` and `Cancel.dump` for debugging
  
  The `Switch.dump` and `Cancel.dump` functions have been added for
  debugging purpose. A sample output is shown below:
  
  ```
  Switch 6 (1 extra fibres):
    on [4]
      cancelling(Failure("Background switch turned off")) []
        cancelling(Failure("Background switch turned off")) []
        on (protected) [7]
  ```

* [ocaml-multicore/eio#135](https://github.com/ocaml-multicore/eio/pull/135)
  Add `~close_unix` flag to `FD.of_unix`
  
  The user can now handle closing of the FD using the `close_unix`
  flag for better integration with APIs.

* [ocaml-multicore/eio#139](https://github.com/ocaml-multicore/eio/pull/139)
  Add `eio.unix` module for Unix integration
  
  A new `eio.unix` module provides both `await_readable` and
  `await_writable` functions, and allows `Lwt_eio` to work with either
  backends. Eio needs to work on browsers and unikernels, and hence it
  must not depend directly on `Unix`.

* [ocaml-multicore/eio#141](https://github.com/ocaml-multicore/eio/pull/141)
  `lib_eio`: implement `Stream.is_empty`
  
  A `length` and `is_empty` function have been implemented in
  `lib_eio/stream.ml` sources.

* [ocaml-multicore/eio#159](https://github.com/ocaml-multicore/eio/pull/159)
  Add `Eio.Buf_read`
  
  The addition of `Buf_read` in Eio provides a low-level API to view
  the internal buffer and to mark bytes as consumed. Also, it now has
  a high-level API to read characters, strings, and multi-line text.

* [ocaml-multicore/eio#161](https://github.com/ocaml-multicore/eio/pull/161)
  Add more functions to `Buf_read`
  
  The functions `peek_char`, `skip`, `pair`, `map`, `bind`, `*>` and
  `<*` have been added to `lib_eio/buf_read.ml` to match the Angstrom
  API. Additional fuzz testing with crowbar have also been included.

* [ocaml-multicore/eio#163](https://github.com/ocaml-multicore/eio/pull/163)
  Add `Buf_read.{seq,lines}` and `Dir.{load,save}` convenience functions
  
  A `at_end_of_input` function has been added, and `eof` has been
  renamed to `end_of_input` to match Angstrom API. The
  `Buf.read.{seq,lines}` and `Dir.{load.save}` convenience functions
  have been added to make it easy to load and save files, and to read
  a file line by line.

##### Build

* [ocaml-multicore/eio#128](https://github.com/ocaml-multicore/eio/pull/128)
  Depend on `base-domains`
  
  The opam repository now provides a `base-domains` package, which
  will be used instead of hard-coding an explicit dependency on
  `ocaml.4.12.0+domains`.

* [ocaml-multicore/eio#137](https://github.com/ocaml-multicore/eio/pull/137)
  Rename `eunix` to `eio.utils`
  
  The collection of utility modules for building `Eio` backends have
  been renamed from `enix` to `eio.utils`, as a separate OPAM package
  is not required.

* [ocaml-multicore/eio#147](https://github.com/ocaml-multicore/eio/pull/147)
  Remove unused `bigstringaf` dependency
  
  The `bigstringaf` dependency is no longer required and the same has
  been removed.

* [ocaml-multicore/eio#149](https://github.com/ocaml-multicore/eio/pull/149)
  Remove dependency on ppxlib
  
  The `lib_ctf/ctf.ml` file was using ppxlib, and the relevant code
  has been inlined. Hence, the dependency on `ppxlib` has been removed
  to build for 5.00.0.

* [ocaml-multicore/eio#151](https://github.com/ocaml-multicore/eio/pull/151)
  Add support for OCaml 5.00+trunk
  
  The PR updates `eio` to build for OCaml 5.00.0+trunk and keeps
  compatibility with 4.12+domains.

* [ocaml-multicore/eio#157](https://github.com/ocaml-multicore/eio/pull/157)
  Remove `Unix` dependency from Eio
  
  The dependency on Unix is removed from Eio in order to use it in a
  unikernel or a browser. The `Eio.Unix_perm.t` replaces
  `Unix.file_perm`, and `Eio.Net.Ipaddr.t` replaces `Unix.inet_addr`.

##### Improvements

* [ocaml-multicore/eio#156](https://github.com/ocaml-multicore/eio/pull/156)
  [eio_linux] Allow running uring in polling mode
  
  A `polling_timeout` option has been added to run uring in polling
  mode. This is faster because Linux can start handling requests
  without waiting for us to submit them.

* [ocaml-multicore/eio#158](https://github.com/ocaml-multicore/eio/pull/158)
  Split `eio.ml` out into separate modules
  
  A code refactor to split the `lib_eio/eio.ml` into separate modules.

##### Fixes

* [ocaml-multicore/eio#134](https://github.com/ocaml-multicore/eio/pull/134)
  Simplify and improve error reporting
  
  An error raised and lost when cancelling an operation is now
  fixed. The cancellation contexts are now handled by the switches.

* [ocaml-multicore/eio#160](https://github.com/ocaml-multicore/eio/pull/160)
  Fix `Buf_read.take_all`
  
  A fix in `lib_eio/buf_read.ml` to read everything in the stream and
  not just what is present in the buffer.

##### Testing

* [ocaml-multicore/eio#153](https://github.com/ocaml-multicore/eio/pull/153)
  Allow reading absolute paths with `Stdenv.fs`
  
  `Stdenv.fs` can be used to access absolute paths. A test case has
  also been added to the PR.

* [ocaml-multicore/eio#154](https://github.com/ocaml-multicore/eio/pull/154)
  [eio_linux] Avoid copy in `read_into`
  
  The `readv` implementation can now be used to read directly into the
  user's buffer to avoid the copy with `read_into`.

##### Documentation

* [ocaml-multicore/eio#123](https://github.com/ocaml-multicore/eio/pull/123)
  Add missing word in README.md
  
  The README.md documentation has been updated to provide the context
  of a `Switch.run`.

* [ocaml-multicore/eio#136](https://github.com/ocaml-multicore/eio/pull/136)
  Add README example of a cache using promises
  
  A concurrent cache example has been included in the README that
  demonstrates the use of Promise.

* [ocaml-multicore/eio#144](https://github.com/ocaml-multicore/eio/pull/144)
  Minor updates to README
  
  The README has been updated with information on `Lwt_eio` with minor
  changes to clarify the `Switch` behaviour.

* [ocaml-multicore/eio#145](https://github.com/ocaml-multicore/eio/pull/145)
  Add Multicore Guide explaining the new memory model
  
  A new `doc/multicore.md` file has been added that explains the
  memory model with the following topics:
  
  ```
  1. Introduction
  2. Problems with Multicore Programming
     a. Optimisation 1: Caching
     b. Optimisation 2: Out-of-Order Execution
     c. Optimisation 3: Compiler Optimisations
     d. Optimisation 4: Multiple COres
  3. The OCaml Memory Model.
  4. Guidelines
  5. Further reading
  ```

* [ocaml-multicore/eio#152](https://github.com/ocaml-multicore/eio/pull/152)
  Fix minor documentation errors
  
  The `dune build @doc` warnings have been fixed for
  `doc/rationale.md`, `lib_ctf/unix/ctf_unix.mli`,
  `lib_eio_linux/eio_linux.mli` and `lib_eio_luv/eio_luv.mli` files.

* [ocaml-multicore/eio#162](https://github.com/ocaml-multicore/eio/pull/162)
  Use MDX to test Multicore guide
  
  The dune file has been updated to test the `multicore.md`
  documentation using MDX.

* [ocaml-multicore/eio#164](https://github.com/ocaml-multicore/eio/pull/164)
  Document the new load and save functions
  
  The README.md file has been updated with documentation on
  `Dir.save`, `Dir.open_out`, `Dir.open_in`, and `Dir.with_lines`.
  
#### Parallel Programming in Multicore

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#11](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/issues/11)
  Unhandled exception when executing programs that use the `parallel_for` primitive
  
  An exception reported by @H-N41K (Hemendra M. Naik) for the
  `parallel_for` primitive has been fixed with an update to the
  domainslib.0.4.0 package.

* [ocaml-multicore/parallel-programming-in-multicore-ocaml#12](https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/12)
  Update to domainslib.0.4.0
  
  The breaking changes introduced by domainslib.0.4.0 have been fixed,
  and the README.md has been updated for OCaml 5.00.

#### OCaml Uring

* [ocaml-multicore/ocaml-uring#43](https://github.com/ocaml-multicore/ocaml-uring/pull/43)
  Remove `bigstringaf` dependency
  
  The `bigstringaf` dependency has been removed, and we now use the
  same functions provided by `cstruct`.

* [ocaml-multicore/ocaml-uring#44](https://github.com/ocaml-multicore/ocaml-uring/pull/44)
  Allow running in polling mode
  
  The `lib/uring/uring.ml` has been updated to now run in polling mode
  with a `polling_timeout` argument.

* [ocaml-multicore/ocaml-uring#45](https://github.com/ocaml-multicore/ocaml-uring/pull/45)
  `Cmdliner` is only needed for tests
  
  The `cmdliner` dependency is only required for testing, and the same
  has been updated in both `dune-project` and `uring.opam` files.

#### Domainslib

* [ocaml-multicore/domainslib#61](https://github.com/ocaml-multicore/domainslib/pull/61)
  Use new name of EffectHandlers (Effect)
  
  The `lib/task.ml` code has been updated to use `Effect` since
  upstream
  [ocaml/ocaml#10879](https://github.com/ocaml/ocaml/pull/10879) has
  renamed the `EffectHandlers` module to `Effect`.

* [ocaml-multicore/domainslib#63](https://github.com/ocaml-multicore/domainslib/pull/63)
  Run CI with trunk OCaml
  
  The GitHub Actions CI build has been updated to build with
  `ocaml/ocaml` trunk.

#### Multicore OPAM

* [ocaml-multicore/retro-httpaf-bench#18](https://github.com/ocaml-multicore/retro-httpaf-bench/pull/18)
  Switch Eio benchmark to use faster polling mode
  
  The retro-httpaf benchmark now uses the latest Eio that adds support
  for polling mode, and makes it the fastest performing benchmark.
  
![Retro-httpaf-bench-PR-18-graph|411x264](upload://ppDkpAwib27jttlrMr0OsKYyQ0d.png)

* [ocaml-multicore/multicore-opam#61](https://github.com/ocaml-multicore/multicore-opam/pull/61)
  Remove `omake`
  
  The PR removes omake, which is required only for +effects, and also
  removes `caml_modify_field` which does not exist in trunk.

* [ocaml-multicore/multicore-opam#62](https://github.com/ocaml-multicore/multicore-opam/pull/62)
  Remove `domainslib`

  `Domainslib.0.3.0` has been removed from this repository as it has
  been upstream to opam-repository.

* [ocaml-multicore/multicore-opam#63](https://github.com/ocaml-multicore/multicore-opam/pull/63)
  `base-domains` has been upstreamed in `opam-repository` long ago
  
  The `base-domains` dependency has been removed from `multicore-opam`
  as it has been upstreamed to the opam repository.

## Benchmarking

### Sandmark

#### Ongoing

* [ocaml-bench/sandmark#272](https://github.com/ocaml-bench/sandmark/issues/272)
  Delay benchmark runs if the machine is active
  
  A load average check needs to done to ensure that no active
  benchmarking jobs are being executed on a machine, before triggering
  a new set of benchmark runs.

* [ocaml-bench/sandmark#273](https://github.com/ocaml-bench/sandmark/issues/273)
  Use just 5.00+trunk for OCaml variant builds
  
  The OCaml variants in Sandmark need to be updated to have only the
  5.00.0+trunk builds.

* [ocaml-bench/sandmark#274](https://github.com/ocaml-bench/sandmark/issues/274)
  Custom Variant Support
  
  A requirement to allow Sandmark benchmark runs for compiler
  developer branches. The configuration should allow a URL to a
  specific branch, with configure options, runtime parameters, name of
  the variant, and an expiry date until which the Sandmark nightly
  runs should occur. For example:
  
  ```
   [ { "url" : "https://github.com/ocaml-multicore/ocaml-multicore/archive/parallel_minor_gc.tar.gz",
    "configure" : "-q",
    "runparams" : "v=0x400",
    "name": "5.00+trunk+kc+pr23423",
    "expiry": "YYYY-MM-DD"},
  ...]  
  ```

* [ocaml-bench/sandmark#275](https://github.com/ocaml-bench/sandmark/issues/275)
  Move from drone CI to GitHub actions
  
  The present .drone.yml CI needs to be replaced with builds using
  GitHub Actions.

#### Completed

* [ocaml-bench/sandmark#268](https://github.com/ocaml-bench/sandmark/pull/268)
   Update README CI Build status to main branch
   
   The CI `Build Status` for the `main` branch in Sandmark has been
   updated to point to the main branch.

* [ocaml-bench/sandmark#270](https://github.com/ocaml-bench/sandmark/pull/270)
  Update to 5.00.0+domains
  
  The dependencies and benchmarks to run 5.00.0+domains variant have
  been updated to build in the Sandmark master branch.

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

* [ocaml-bench/sandmark#276](https://github.com/ocaml-bench/sandmark/pull/276)
  Re-add 5.00.0+trunk with CI failure:ignore option
  
  The .drone.yml CI is updated to ignore a failed build for
  5.00.0+trunk, so that we can continue to merge changes as long as
  5.00.0+stable Sandmark builds fine.

* [ocaml-bench/sandmark#277](https://github.com/ocaml-bench/sandmark/pull/277)
  Sync and update README from master branch
  
  The README changes from the Sandmark master branch have been synced
  up with the main branch, as we will soon switch to using the main
  branch as the default branch in Sandmark.

### Sandmark-nightly

#### Ongoing

* [ocaml-bench/sandmark-nightly#26](https://github.com/ocaml-bench/sandmark-nightly/pull/26)
  Update the nightly scripts
  
  The PR updates the scripts in the `nightly/` folder to run the
  5.00.0 variants on both the Turing and Navajo servers.

* [ocaml-bench/sandmark-nightly#27](https://github.com/ocaml-bench/sandmark-nightly/issues/27)
  Include the baseline variant information in the normalised graphs
  
  The normalised graph must include the information of the baseline
  variant used for comparison.

![Sandmark-nightly-issue-27-graph|690x278](upload://peZnx14SIBcXgUnIiHX8aEEEBn5.png)

* [ocaml-bench/sandmark-nightly#32](https://github.com/ocaml-bench/sandmark-nightly/issues/32)
  Support custom variants from private GitHub repo
  
  The Sandmark nightly runs should allow building custom developer
  branch variants from a GitHub repository.

* [ocaml-bench/sandmark-nightly#33](https://github.com/ocaml-bench/sandmark-nightly/issues/33)
  Permalink to graphs
  
  A permalink in the dashboard UI on selected options and graphs will
  be useful to share among users.

* [ocaml-bench/sandmark-nightly#34](https://github.com/ocaml-bench/sandmark-nightly/issues/34)
  Parallel benchmarks should be run on ocaml/ocaml#trunk
  
  The parallel benchmark runs should also be run on
  `ocaml/ocaml#trunk`, now that Multicore OCaml PR has been merged.

* [ocaml-bench/sandmark-nightly#36](https://github.com/ocaml-bench/sandmark-nightly/issues/36)
  Add a custom run to Sandmark nightly
  
  A custom variant run with configure options `--enable-mmap-stack`
  and `--disable-mmap-stack` needs to be added to Sandmark nightly.

* [ocaml-bench/sandmark-nightly#37](https://github.com/ocaml-bench/sandmark-nightly/issues/37)
  Sequential results comparison is broken
  
  A TypeError is shown when selecting sequential results comparison in
  the UI, and this needs to be fixed.

* [ocaml-bench/sandmark-nightly#38](https://github.com/ocaml-bench/sandmark-nightly/issues/38)
  Baseline for normalised graphs are missing entries
  
  All the variants with their commits need to be shown in the drop
  down menu for the normalized graphs.
 
* [ocaml-bench/sandmark-nightly#40](https://github.com/ocaml-bench/sandmark-nightly/issues/40)
  The information in the landing page is out of date
   
  The information on the list of variants in the Sandmark nightly
  landing page needs to be synced with the latest results.

### Completed

* [ocaml-bench/sandmark-nightly#24](https://github.com/ocaml-bench/sandmark-nightly/pull/24)
  Use git clone from ocurrent-deployer
  
  The Dockerfile has been updated to use git clone from
  `ocurrent-deployer`, instead of `ocaml-bench/sandmark-nightly`.

* [ocaml-bench/sandmark-nightly#28](https://github.com/ocaml-bench/sandmark-nightly/issues/28)
  Make number of default variants to be 1 in parallel benchmarks
  
  The number of default variants for the parallel benchmarks has been
  switched from two to one.

* [ocaml-bench/sandmark-nightly#30](https://github.com/ocaml-bench/sandmark-nightly/pull/30)
  Add a landing page to Sandmark Nightly
  
  An `index.py` landing page has been created for Sandmark Nightly
  with information on how the benchmarks are executed along with
  machine details.

* [ocaml-bench/sandmark-nightly#31](https://github.com/ocaml-bench/sandmark-nightly/pull/31)
  Add archive message for instrumented benchmarks
  
  A message to inform the end user that the instrumented pausetimes
  benchmarks are not updated for the latest 5.00.0 OCaml variants.

* [ocaml-bench/sandmark-nightly#35](https://github.com/ocaml-bench/sandmark-nightly/pull/35)
  Update icon and title
  
  The title and favicon defaults to the Streamlit logo, and the same
  have now been updated to `Sandmark Nightly`.
  
* [ocaml-bench/sandmark-nightly#39](https://github.com/ocaml-bench/sandmark-nightly/issues/39)
  Parallel results can't be seen on sandmark.ocamllabs.io
  
  The hotfix in the UI to show multiple variants mapped to a single
  commit correctly displays the parallel benchmarks in the UI.

### current-bench

#### Ongoing

* [ocurrent/current-bench#282](https://github.com/ocurrent/current-bench/pull/282)
  Docker compose for stack deploy
  
  A `docker-compose.yaml` file has been added to deploy the backend
  pipeline and frontend stack.

* [ocurrent/current-bench#292](https://github.com/ocurrent/current-bench/pull/292)
  Return better HTTP error codes for API requests
  
  The PR adds exceptions to return correct HTTP error codes for client
  API requests.

* [ocurrent/current-bench#293](https://github.com/ocurrent/current-bench/pull/293)
  Make log links noticeable by removing log ID from link text
  
  The log UUIDs from the execution logs are now replaced with a link
  for better clarity.

#### Completed

##### Fixes

* [ocurrent/current-bench#272](https://github.com/ocurrent/current-bench/pull/272)
  Ignore NaNs when computing the mean
  
  The NaN entries should not be included when computing the mean, and
  the same have been updated in `LineGraph.res`.
  
* [ocurrent/current-bench#276](https://github.com/ocurrent/current-bench/pull/276)
  Production fix: validate-env for graphql URLs
  
  The `scripts/validate-env.sh` script has been updated to validate
  the path `/_hasura/v1/graphql`.

* [ocurrent/current-bench#278](https://github.com/ocurrent/current-bench/pull/278)
  Fix for production
  
  Use port `8082` instead of port 80 for the frontend Nginx running
  inside Docker.

* [ocurrent/current-bench#284](https://github.com/ocurrent/current-bench/pull/284)
  Couple of fixes with handling multiple benchmarks data
  
  A list of named benchmarks are now supported when handling data for
  multiple benchmarks. The benchmarks menu is now hidden only for
  unnamed benchmarks.

* [ocurrent/current-bench#289](https://github.com/ocurrent/current-bench/pull/289)
  Fix URL missing pull number
  
  The PR number is lost when a redirect to add a worker or Docker
  image is issued, and the same has been fixed.

##### Frontend

* [ocurrent/current-bench#268](https://github.com/ocurrent/current-bench/pull/268)
  Fix frontend: Add worker and Docker image to URL
  
  The worker and Docker image were not reflected in the URL, and the
  same have now been included.

* [ocurrent/current-bench#273](https://github.com/ocurrent/current-bench/pull/273)
  Support overlaying graphs using metric names to specify hierarchy
  
  The frontend now supports overlay of graphs for better comparisons
  as illustrated below:
  
![Current-bench-PR-273-graph|690x232](upload://d6rz6iGMz1ARzrZhEZa7bpB2Wyd.png)

* [ocurrent/current-bench#275](https://github.com/ocurrent/current-bench/pull/275)
  Frontend fix: Display warning and old metrics rather than an empty page
  
  An orange display and previous benchmark metric results are now
  shown if the latest execution is still running, or has failed to
  complete, or got cancelled.

* [ocurrent/current-bench#277](https://github.com/ocurrent/current-bench/pull/277)
  Display last values with a colourful legend for overlay graphs

  The most recent values for the overlay graphs are now displayed with
  a colourful legend as shown below:

![Current-bench-PR-277-graph|690x150](upload://tKJjt8H74JZnmM0d0kXUq11SI5U.png)

* [ocurrent/current-bench#288](https://github.com/ocurrent/current-bench/pull/288)
  Nginx frontend: Fix for URLs containing slashes
  
  A fix in the production deployment where the `/` was causing a 404
  not found error.

##### Monitoring

* [ocurrent/current-bench#270](https://github.com/ocurrent/current-bench/pull/270)
  Basic Prometheus and Alertmanager config
  
  A Prometheus integration setup and configuration to use with
  current-bench deployments has been created.

* [ocurrent/current-bench#271](https://github.com/ocurrent/current-bench/pull/271)
  Add Prometheus alert when host is out of disk space
  
  An alert to be triggered for the current-bench host machine when it
  reaches 90% disk capacity has been added.

* [ocurrent/current-bench#274](https://github.com/ocurrent/current-bench/pull/274)
  Fix alertmanager alert URLs
  
  The alertmanager URLs have now been updated to point to
  autumn.ocamllabs.io.

* [ocurrent/current-bench#283](https://github.com/ocurrent/current-bench/pull/283)
  Scrape metrics from the pipeline server
  
  The Prometheus configuration is updated to obtain OCaml GC metrics,
  GitHub webhook and cache statistics.
  
##### Sundries

* [ocurrent/current-bench#281](https://github.com/ocurrent/current-bench/pull/281)
  Document how to add new workers
  
  The `HACKING.md` has been updated with documentation on adding new
  workers to the cluster.

* [ocurrent/current-bench#287](https://github.com/ocurrent/current-bench/pull/287)
  HTTP API end-point for capturing benchmark results
  
  The benchmark results can be added to the database using a new HTTP
  API end-point, without actually requiring the `current-bench`
  frontend. For example:
  
  ```
  curl -X POST -H 'Authorization: Bearer <token>' <scheme>://<host>/benchmarks/metrics --data-raw '
  {
    "repo_owner": "ocurrent",
    "repo_name": "current-bench",
    "commit": "c66a02ea54430d99b3fefbeba4941921501796ef",
    "pull_number": 286,
    "run_at": "2022-01-28 12:42:02+05:30",
    "duration": "12.45",
    "benchmarks": [
      {
        "name": "benchmark-1",
        "results": [
          {
            "name": "test-1",
            "metrics": [
              {
                "name": "time", "value": 18, "units": "sec"
              }
            ]
          }
        ]
      },
      {
        "name": "benchmark-2",
        "results": [
          {
            "name": "test-1",
            "metrics": [
              {
                "name": "space", "value": 18, "units": "mb"
              }
            ]
          }
        ]
      }
    ]
  }
  '
  ```

We would like to thank all the OCaml users, developers and
contributors in the community for their continued support to the
project. Stay safe!

## Acronyms

* AFL: American Fuzzy Lop
* API: Application Programming Interface
* ARM: Advanced RISC Machines
* AWK: Aho Weinberger Kernighan
* BSD: Berkeley Software Distribution
* CI: Continuous Integration
* CTF: Common Trace Format
* DLS: Domain Local Storage
* FD: File Descriptor
* GB: Gigabyte
* GC: Garbage Collector
* HTTP: Hypertext Transfer Protocol
* IO: Input/Output
* IR: Intermediate Representation
* MD: Markdown
* OOM: Out of Memory
* OPAM: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* PRNG Pseudo-Random Number Generator
* UI: User Interface
* URL: Uniform Resource Locator
