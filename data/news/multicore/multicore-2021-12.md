---
title: OCaml Multicore - December 2021 and the Big PR
description: Monthly update from the OCaml Multicore team.
date: "2021-12-01"
tags: [multicore]
---

Welcome to the December 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! The [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) along with this update have been compiled by myself, @ctk21, @kayceesrk and @shakthimaan.

Well, it's finally here! @kayceesrk opened the [Multicore OCaml PR#10831](https://github.com/ocaml/ocaml/pull/10831) to the main OCaml development repository that represents the "minimum viable" implementation of multicore OCaml that we decided on in [November's core team review](https://discuss.ocaml.org/t/multicore-ocaml-november-2021-with-results-of-code-review/8934#core-team-code-review-1).  The branch pushes the limits of GitHub's rendering capability, with around 4000 commits.

Once the PR was opened just before Christmas, the remaining effort has been for a number of developers to pore over [the diff](http://github.com/ocaml/ocaml/pull/10831.diff) and look for any unexpected changes that crept in during multicore development. A large number of code changes, improvements and fixes have been merged into the ocaml-multicore trees since the PR was opened to facilitate this upstreaming process. We're expecting to have the PR merged during January, and then will continue onto the "post-MVP" tasks described last month, but working directly from ocaml/ocaml from now on.  We therefore remain on track to release OCaml 5.00 in 2022.

In the multicore ecosystem, progress also continued:
- `Eio` continues to improve as the recommended effects-based direct-style IO library to
use with Multicore OCaml.
- A newer `domainslib.0.4.0` has been released that includes bug fixes and API changes.
- The continuous benchmarking pipeline with further integration enhancements between Sandmark and current-bench is making progress.

We would like to acknowledge the following external contributors as well::

* Danny Willems (@dannywillems) for an OCaml implementation of the Pippenger benchmark and reporting an undefined behaviour.
* Matt Pallissard (@mattpallissard) reported an installation issue with `Eio` with vendored uring.
* Edwin Torok (@edwintorok) for contributing a PR to `domainslib` to allow use of a per-channel key.

As always, the Multicore OCaml updates are listed first, which contain the upstream efforts, improvements, fixes, test suite, and documentation changes. This is followed by the ecosystem updates to `Eio`, `Tezos`, and `Domainslib`. The Sandmark, sandmark-nightly and current-bench tasks are finally listed for your reference.

## Multicore OCaml

### Ongoing

#### Upstream

* [ocaml-multicore/ocaml-multicore#742](https://github.com/ocaml-multicore/ocaml-multicore/issues/742)
  Minor tasks from asynchronous review
  
  A list of minor tasks from the asynchronous review is provided for
  the OCaml 5.00 release. The major tasks will have their respective
  GitHub issues.

* [ocaml-multicore/ocaml-multicore#750](https://github.com/ocaml-multicore/ocaml-multicore/issues/750)
  Discussing the design of Lazy under Multicore
  
  An ongoing discussion on the design of Lazy under Multicore OCaml
  that involves sequential Lazy, concurrency problems, duplicated
  computations, and memory safety.

* [ocaml-multicore/ocaml-multicore#756](https://github.com/ocaml-multicore/ocaml-multicore/pull/756)
  RFC: Generalize the `Domain.DLS` interface to split PRNG state for child domains
  
  The implementation for a "proper" PRNG+Domains semantics where
  spawning a domain "splits" the PRNG state is under review.

* [ocaml-multicore/ocaml-multicore#791](https://github.com/ocaml-multicore/ocaml-multicore/issues/791)
  `caml_process_pending_actions_exn` is missing
  
  The `caml_process_pending_actions_exn` returns exceptions as an
  OCaml value instead of raising them, and the C API call is missing
  on Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#795](https://github.com/ocaml-multicore/ocaml-multicore/issues/795)
  Make `Minor_heap_max` and `Max_domains` as `OCAMLRUNPARAM` options
  
  The `Minor_heap_max` is defined as 2GB and `Max_domains` as 128 in
  `runtime/caml/config.h`, and there is an out of memory issue on
  Multicore OCaml when running tools like AFL and Valgrind. The
  suggestion is to make these parameters as `OCAMLRUNPARAM` options.

* [ocaml-multicore/ocaml-multicore#799](https://github.com/ocaml-multicore/ocaml-multicore/issues/799)
  Bring `runner.sh` in the CI in line with trunk
  
  The `runner.sh` script in `ocaml-multicore/ocaml-multicore` has
  changed and diverged from trunk. It needs to be updated to be in
  sync with `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#806](https://github.com/ocaml-multicore/ocaml-multicore/issues/806)
  Unify GC interrupt and signal triggering mechanisms
  
  The interaction between signal and GC interrupts need to be
  reworked, as they exist as two independent mechanisms.

* [ocaml-multicore/ocaml-multicore#811](https://github.com/ocaml-multicore/ocaml-multicore/issues/811)
  Double check rebase through `ocaml/ocaml`
  
  An ongoing review of the porting of Multicore OCaml signal handling
  changes for x86, ARM, PPC and s390x architectures.

* A new
  [ocaml-multicore/ocaml](https://github.com/ocaml-multicore/ocaml)
  project repository has been created from `ocaml/ocaml` to keep it in
  sync with trunk.

#### Improvements

* [ocaml-multicore/ocaml-multicore#765](https://github.com/ocaml-multicore/ocaml-multicore/issues/765)
  `tools/gdb_ocamlrun.py` needs an update
  
  The `tools/gdb_ocamlrun.py` has hardcoded values, and both
  `Forcing_tag` and `Cont_tag` need to be updated.

* [ocaml-multicore/ocaml-multicore#772](https://github.com/ocaml-multicore/ocaml-multicore/issues/772)
  Not all registers need to be saved for `caml_call_realloc_stack`
  
  The C callee saved registers are saved by `caml_try_realloc_stack`
  and they do not invoke the GC. There is no need to save all the
  registers in `caml_call_realloc_stack`.

* [ocaml-multicore/ocaml-multicore#775](https://github.com/ocaml-multicore/ocaml-multicore/issues/775)
  Use explicit next pointer in `gc_regs_bucket`
  
  In `amd64.S`, the last word of a `gc_regs_bucket` contains either a
  saved value of `rax` or a pointer to a previous structure. The
  suggestion is to use distinct members for these two entities.

* [ocaml-multicore/ocaml-multicore#793](https://github.com/ocaml-multicore/ocaml-multicore/pull/793)
  Ring buffer-based runtime tracing (`eventring`)
  
  `Eventring` is a low-overhead runtime tracing system for continuous
  monitoring of OCaml applications. It is a replacement for the
  existing eventlog system present in the runtime, and uses per-domain
  memory-mapped ring buffers. The JSON output of
  `OCAML_EVENTRING_START=1 _build/default/src/traceevents_lib.exe` on
  Chrome's tracing viewer is shown below:

  ![OCaml-Multicore-PR-793-Chrome|690x149](https://discuss.ocaml.org/uploads/short-url/RykCGqsYr4FjqCEod45QdKNwV9.png)

* [ocaml-multicore/ocaml-multicore#794](https://github.com/ocaml-multicore/ocaml-multicore/issues/794)
  Audit `OCAMLRUNPARAM` options
  
  A number of `OCAMLRUNPARAM` options, such as `init_heap_wsz` and
  `init_heap_chunk_sz`, can be removed as they are not used.

* [ocaml-multicore/ocaml-multicore#796](https://github.com/ocaml-multicore/ocaml-multicore/issues/796)
  `Caml_state` for domains should not use mmap
  
  The `Caml_state` is no longer located adjacent to the minor heap
  area, whose allocation is done using mmap. At present, a dedicated
  register (`r14` on amd64) is used to point to `Caml_state`. The use
  of `malloc` at the domain creation time is sufficient to simplify
  and manage `Caml_state`.

* [ocaml-multicore/ocaml-multicore#805](https://github.com/ocaml-multicore/ocaml-multicore/issues/805)
  Improve `stack_size_bucket`/`alloc_stack_noexc`
  
  The current stack cache scheme will not use caching when
  `stack_size_bucket`/`alloc_stack_noexc` is not a power of two. The
  new stacks begin at `caml_fiber_wsz` and increase by a factor of
  two. There is room for refactoring and improving this code.

#### Sundries

* [ocaml-multicore/ocaml-multicore#797](https://github.com/ocaml-multicore/ocaml-multicore/issues/797)
  Atomic access on `bigarray`
  
  A feature request to implement atomic access for `bigarray`.

* [ocaml-multicore/ocaml-multicore#801](https://github.com/ocaml-multicore/ocaml-multicore/issues/801)
  Call to `fork` in `Sys.command`
  
  A query on whether to guard a `fork` call when used with
  `Sys.command`.

* [ocaml-multicore/ocaml-multicore#810](https://github.com/ocaml-multicore/ocaml-multicore/issues/810)
  Getting segfault/undefined behavior using Multicore with custom blocks

  A segmentation fault and undefined behaviour reported by
  @dannywillems (Danny Willems) for a Pippenger benchmark
  implementation in OCaml.

* [ocaml-multicore/ocaml-multicore#816](https://github.com/ocaml-multicore/ocaml-multicore/issues/816)
  Filter-tree to normalise email address from commiters
  
  The inconsistent names and email addresses among committers in
  Multicore OCaml needs to be fixed and merged using filter-tree.

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#669](https://github.com/ocaml-multicore/ocaml-multicore/pull/669)
  Set thread names for domains
  
  The patch that implements thread naming for Multicore OCaml, and
  also provides an interface to name Domains and Threads differently
  is now merged.

* [ocaml-multicore/ocaml-multicore#701](https://github.com/ocaml-multicore/ocaml-multicore/pull/701)
  Cherry pick: Merge pull request #701 from `ocaml-multicore/really_flush`
  
  The PR updates `stlib/format.ml` to flush the output when
  pre-defined formatters are used in parallel.

* [ocaml-multicore/ocaml-multicore#735](https://github.com/ocaml-multicore/ocaml-multicore/pull/735)
  Add `caml_young_alloc_start` and `caml_young_alloc_end` in `minor_gc.c`
  
  `caml_young_alloc_start` and `caml_young_alloc_end` are not present
  in Multicore OCaml, and they have now been included as a
  compatibility macro.

* [ocaml-multicore/ocaml-multicore#737](https://github.com/ocaml-multicore/ocaml-multicore/issues/737)
  Port the new ephemeron API to 5.00
  
  An API for immutable ephemerons has been
  [merged](https://github.com/ocaml/ocaml/pull/10737) in trunk, and
  the respective changes have been ported to 5.00.

* [ocaml-multicore/ocaml-multicore#740](https://github.com/ocaml-multicore/ocaml-multicore/pull/740)
  Systhread lifecycle
  
  The fixes in `caml_thread_domain_stop_hook`, `Thread.exit` and
  `caml_c_thread_unregister` have been merged. The PR also addresses
  the systhreads lifecycle in Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#745](https://github.com/ocaml-multicore/ocaml-multicore/pull/745)
  Systhreads WG3 comments
  
  The PR updates the commit names to be self-descriptive, uses
  non-atomic variables, and raises OOM when there is a failure to
  allocate thread descriptors.

* [ocaml-multicore/ocaml-multicore#748](https://github.com/ocaml-multicore/ocaml-multicore/pull/748)
  WG3 move `gen_sizeclasses`
  
  The `runtime/gen_sizeclasses.ml` have been moved to
  `tools/gen_sizeclasses.ml`, and the check-typo issues have been
  fixed and merged.

* [ocaml-multicore/ocaml-multicore#762](https://github.com/ocaml-multicore/ocaml-multicore/pull/762)
  Remove naked pointer checker
  
  The PR removes the naked pointer checker as it is not supported in
  Multicore OCaml.

* [ocaml-multicore/ocaml-multicore#763](https://github.com/ocaml-multicore/ocaml-multicore/pull/763)
  Move `Assert` -> `CAMLassert`
  
  The `Assert` has been replaced with `CAMLassert`, and check-typo
  changes to fix license files and line lengths have been merged.

* [ocaml-multicore/ocaml-multicore#764](https://github.com/ocaml-multicore/ocaml-multicore/pull/764)
  Address `shared_heap.c` review (WG1)
  
  The `runtime/shared_heap.c` code has been updated to initialize
  variables with NULL instead of 0.

* [ocaml-multicore/ocaml-multicore#766](https://github.com/ocaml-multicore/ocaml-multicore/pull/766)
  Signals changes from sync review and WG3
  
  The signals are blocked before spawning a domain, and unblocked
  afterwards when it is safe to do so. `total_signals_pending` has
  been removed, and we now coalesce signals by signal number.

* [ocaml-multicore/ocaml-multicore#767](https://github.com/ocaml-multicore/ocaml-multicore/pull/767)
  `relaxed` -> `acquire` in `minor_gc` header read
  
  The `memory_order_relaxed` is now replaced with
  `memory_order_acquire` in `runtime/minor_gc.c` for 5.00.

* [ocaml-multicore/ocaml-multicore#768](https://github.com/ocaml-multicore/ocaml-multicore/pull/768)
  Make `intern` not invoke the GC
  
  The PR brings the implementation of intern closer to trunk OCaml,
  and intern no longer triggers GC. The performance result on a simple
  binary-tree benchmark is tabulated below:
  
  ```
  N    OCaml trunk 	 This PR    Slowdown
  2    1.20E-07      1.20E-07   0.00%
  4    3.10E-07      3.20E-07   3.23%
  8    9.10E-06      1.40E-05   53.85%
  16   2.60E-03      3.90E-03   50.00%
  20   4.60E-02      6.40E-02   39.13%
  22   2.20E-01      2.70E-01   22.73%
  24   1.10E+00      1.20E+00   9.09%
  25   1.90E+00      2.10E+00   10.53%
  ```

* [ocaml-multicore/ocaml-multicore#770](https://github.com/ocaml-multicore/ocaml-multicore/pull/770)
  Backport of PR770
  
  The `otherlibs/systhreads/st_stubs.c` file has been formatted to
  clear hygiene checks, and changes to `backtrace_last_exn` have been
  made to be closer to trunk.

* [ocaml-multicore/ocaml-multicore#771](https://github.com/ocaml-multicore/ocaml-multicore/pull/771)
  Bring root management of `backtrace_last_exn` in systhreads closer to trunk
  
  The `backtrace_last_exn` root management in systhreads has been
  updated to be closer to `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#773](https://github.com/ocaml-multicore/ocaml-multicore/pull/773)
  Improvements based on asynchronous reviews
  
  The allocation for the extern state is now done before its use, and
  improvements to `amd64.S` have been implemented.

* [ocaml-multicore/ocaml-multicore#781](https://github.com/ocaml-multicore/ocaml-multicore/pull/781)
  PR771 for 4.12 domains

  This is a backport of
  [PR#771](https://github.com/ocaml-multicore/ocaml-multicore/pull/771)
  for `4.12+domains` branch.

* [ocaml-multicore/ocaml-multicore#789](https://github.com/ocaml-multicore/ocaml-multicore/pull/789)
  Review improvements
  
  The trunk's text section naming style has been updated to
  `runtime/amd64.S` with improvements to `runtime/fiber.c`. Also, the
  unnecessary reset in `runtime/interp.c` has been removed.

* [ocaml-multicore/ocaml-multicore#790](https://github.com/ocaml-multicore/ocaml-multicore/pull/790)
  Add `ocaml_check_pending_actions`, `caml_process_pending_actions`
  
  The `caml_check_pending_actions` and `caml_process_pending_actions`
  that are part of the C API have been added to OCaml Multicore.

* [ocaml-multicore/ocaml-multicore#813](https://github.com/ocaml-multicore/ocaml-multicore/pull/813)
  Revert arm64 changes and ocaml-variant.opam file
  
  The `asmcomp/arm64/*` files and `ocaml-variants.opam` file have been
  updated to be closer to trunk.

* [ocaml-multicore/ocaml-multicore#815](https://github.com/ocaml-multicore/ocaml-multicore/pull/815)
  Various tweaks
  
  The PR reduces the diff noise in `major_gc.h`, `sys.h`, `ui.h`,
  `weak.h`, `gc_ctrl.c`, `gc.mli`, and `runtime/Makefile`. It also
  removes unnecessary includes from `ocamldoc` and `ocamltest` builds.

* [ocaml-multicore/ocaml-multicore#818](https://github.com/ocaml-multicore/ocaml-multicore/pull/818)
  Minor fixes from review

  The PR updates comments in `otherlibs/systhreads/st_stubs.c`, uses
  `memcpy` instead of `memmove` in `runtime/caml/sync.h`, and minor
  fixes in the `asmcomp` sources.

* [ocaml-multicore/ocaml-multicore#819](https://github.com/ocaml-multicore/ocaml-multicore/pull/819)
  Do not initialise in `caml_alloc_shr`
  
  The `array.c` sources have been updated to use non-initialising
  allocation to match trunk.

* [ocaml/ocaml#10831](https://github.com/ocaml/ocaml/pull/10831)
  Multicore OCaml
  
  This is the PR to merge Multicore OCaml to `ocaml/ocaml` with
  support for shared-memory parallelism through domains, and
  concurrency through effect handlers. It is backward compatible with
  respect to language features, C API and performance of
  single-threaded code. The scalability results on parallel benchmarks
  from [Sandmark](https://github.com/ocaml-bench/sandmark) on a two
  processor, AMD EPYC 7551 server with 64 cores is shown below:

  ![OCaml-PR-10831-Speedup|674x500](https://discuss.ocaml.org/uploads/short-url/qlsUnoibozBfJJxEnFKEE2Xynkp.png)

#### Improvements

* [ocaml-multicore/ocaml-multicore#779](https://github.com/ocaml-multicore/ocaml-multicore/pull/779)
  Rename/hide some global variables
  
  The use of extern `global`, `pool_freelist` and `atoms` have been
  replaced with extern `caml_heap_global_state`, static
  `static_pool_freelist`, and static `atoms` respectively.

* [ocaml-multicore/ocaml-multicore#785](https://github.com/ocaml-multicore/ocaml-multicore/pull/785)
  Unexport some unprefixed global names
  
  The global variables that are not prefixed with `caml_` are now made
  static. The output, prior and after the changes, is shown below:
  
  Before
  ```
  $ readelf -s ./runtime/libcamlrun_shared.so  | grep GLOBAL | egrep -v ' UND | caml_'
   198: 00000000000562a0    40 OBJECT  GLOBAL DEFAULT   26 signal_install_mutex
   549: 0000000000000038     8 TLS     GLOBAL DEFAULT   18 Caml_state
   559: 0000000000056680     8 OBJECT  GLOBAL DEFAULT   26 marshal_flags
   622: 000000000001bf10   178 FUNC    GLOBAL DEFAULT   12 ephe_sweep
   642: 00000000000707e0     8 OBJECT  GLOBAL DEFAULT   26 garbage_head
   665: 000000000001bb80   729 FUNC    GLOBAL DEFAULT   12 ephe_mark
   783: 000000000001dfe0   229 FUNC    GLOBAL DEFAULT   12 reset_minor_tables
  1003: 0000000000052b20    24 OBJECT  GLOBAL DEFAULT   26 ephe_cycle_info
  1025: 00000000000165d0    19 FUNC    GLOBAL DEFAULT   12 main
  1042: 00000000000383e0    87 FUNC    GLOBAL DEFAULT   12 verify_push
   323: 0000000000051000     0 OBJECT  LOCAL  DEFAULT   24 _GLOBAL_OFFSET_TABLE_
   454: 0000000000052b20    24 OBJECT  GLOBAL DEFAULT   26 ephe_cycle_info
   564: 00000000000383e0    87 FUNC    GLOBAL DEFAULT   12 verify_push
   577: 00000000000562a0    40 OBJECT  GLOBAL DEFAULT   26 signal_install_mutex
   637: 00000000000707e0     8 OBJECT  GLOBAL DEFAULT   26 garbage_head
   831: 0000000000000038     8 TLS     GLOBAL DEFAULT   18 Caml_state
   910: 0000000000056680     8 OBJECT  GLOBAL DEFAULT   26 marshal_flags
  1092: 00000000000165d0    19 FUNC    GLOBAL DEFAULT   12 main
  1338: 000000000001bf10   178 FUNC    GLOBAL DEFAULT   12 ephe_sweep
  1424: 000000000001bb80   729 FUNC    GLOBAL DEFAULT   12 ephe_mark
  1437: 000000000001dfe0   229 FUNC    GLOBAL DEFAULT   12 reset_minor_tables
  ```
  
  After
  ```
  $ readelf -s ./runtime/libcamlrun_shared.so  | grep GLOBAL | egrep -v ' UND | caml_'
   548: 0000000000000038     8 TLS     GLOBAL DEFAULT   18 Caml_state
  1018: 00000000000165a0    19 FUNC    GLOBAL DEFAULT   12 main
   329: 0000000000051000     0 OBJECT  LOCAL  DEFAULT   24 _GLOBAL_OFFSET_TABLE_
   833: 0000000000000038     8 TLS     GLOBAL DEFAULT   18 Caml_state
  1093: 00000000000165a0    19 FUNC    GLOBAL DEFAULT   12 main
  ```

* [ocaml-multicore/ocaml-multicore#792](https://github.com/ocaml-multicore/ocaml-multicore/pull/792)
  Stdlib: simplify `is_main_domain`
  
  The `is_main_domain` implementation is made simpler in
  `stdlib/domain.ml`, and the PR also removes the
  `caml_ml_domain_is_main_domain` primitive.

* [ocaml-multicore/ocaml-multicore#803](https://github.com/ocaml-multicore/ocaml-multicore/pull/803)
  Remove difference in stack resize with debug runtime
  
  The difference in the stack resizing between the standard and debug
  runtimes has been removed, in order to help reproduce any bug
  experienced in the standard runtime with the same stack resize in
  the debug runtime.

* [ocaml-multicore/ocaml-multicore#804](https://github.com/ocaml-multicore/ocaml-multicore/pull/804)
  Remove redundant opens
  
  The redundant `open` calls in
  `testsuite/tests/weak-ephe-final/ephetest_par.ml` have been removed.
  
* [ocaml-multicore/ocaml-multicore#820](https://github.com/ocaml-multicore/ocaml-multicore/pull/820)
  Minor improvements
  
  The use of `memmove` in `runtime/sys.c` has been replaced with
  `memcpy`, and the code has been cleaned up in both
  `runtime/callback.c` and `runtime/caml/callback.h`.

#### Fixes

* [ocaml-multicore/ocaml-multicore#725](https://github.com/ocaml-multicore/ocaml-multicore/pull/725)
  Blocked signal infinite loop fix

  A monotonic `recorded_signals_counter` was added to fix the possible
  loop in `caml_enter_blocking_section` when no domain can handle a
  blocked signal. The consensus now is to move from counting signals
  to coalescing them, and hence this requires a code rewrite.

* [ocaml-multicore/ocaml-multicore#749](https://github.com/ocaml-multicore/ocaml-multicore/issues/749)
  Potential bug on `Forward_tag` short-circuiting?
  
  Short-circuiting is disabled on values of type `Forward_tag`,
  `Lazy_tag` and `Double_tag` in the minor GC, and the bug that occurs
  when short-circuiting `Forward_tag` on values of type
  `Obj.forcing_tag` has been fixed.

* [ocaml-multicore/ocaml-multicore#760](https://github.com/ocaml-multicore/ocaml-multicore/pull/760)
  Simplify lazy semantics
  
  The `RacyLazy` exception has been removed. Both `domain-local` id
  and `try_force` have also been removed. Any concurrent use of lazy
  value may raise an undefined exception.

* [ocaml-multicore/ocaml-multicore#761](https://github.com/ocaml-multicore/ocaml-multicore/pull/761)
  Bug fix in `amd64.S` and general cleanup
  
  The `jl` (jump if signed less) in `runtime/amd64.S` has been changed
  to `jb` (jump if unsigned less) and the code in
  `asmcomp/amd64/emit.mlp` has been cleaned up.

* [ocaml-multicore/ocaml-multicore#769](https://github.com/ocaml-multicore/ocaml-multicore/pull/769)
  Move frame descriptors header and fix typos
  
  The frame descriptors headers from `runtime` have been moved to
  `runtime/caml` and ifdefs with `CAML_INTERNALS`. An additional check
  for NULL has been added if code is compiled without `-g`.

* [ocaml-multicore/ocaml-multicore#788](https://github.com/ocaml-multicore/ocaml-multicore/pull/788)
  Fix selectgen `effects_of` for `Cdls_Get`
  
  The PR moves the `effects_of` for `Cdls_get` to `EC.coeffect_only
  Coffect.Read_mutable` in `asmcomp/selectgen.ml`.

* [ocaml-multicore/ocaml-multicore#809](https://github.com/ocaml-multicore/ocaml-multicore/pull/809)
  Finish off `tools/check-typo` on the repo
  
  The `Callback_link` in `runtime/caml/stack.h` has been removed, and
  the PR cleans up the fixes reported by `tools/check-typo`.

#### Tests

* [ocaml-multicore/ocaml-multicore#774](https://github.com/ocaml-multicore/ocaml-multicore/pull/774)
  Skip unsupported and incompatible tests
  
  The `skip` built-in action of `ocamltest` works for skipping
  unsupported and incompatible tests.

* [ocaml-multicore/ocaml-multicore#784](https://github.com/ocaml-multicore/ocaml-multicore/pull/784)
  Revert `testsuite/summarize.awk`
  
  The `testsuite/summarize.awk` has been updated to be closer to its
  `ocaml/ocaml` version.

* [ocaml-multicore/ocaml-multicore#786](https://github.com/ocaml-multicore/ocaml-multicore/pull/786)
  Reimplement `caml_alloc_small` like in OCaml 4.x
  
  The OCaml 4.x implementation of `caml_alloc_small` has been
  re-introduced with this PR, since it makes an assertion when `sz` is
  larger than `Max_young_wosize`.

* [ocaml-multicore/ocaml-multicore#798](https://github.com/ocaml-multicore/ocaml-multicore/pull/798)
  Revert `asmgen` testsuite and ocamltest to trunk
  
  The `asmgen` and `ocamltest` tests have been updated to build fine
  with `ocaml/ocaml`.

* [ocaml-multicore/ocaml-multicore#808](https://github.com/ocaml-multicore/ocaml-multicore/pull/808)
  `signal_alloc` testcase fix
  
  The `signal_alloc` test case has been added back to the test suite.

* [ocaml-multicore/ocaml-multicore#814](https://github.com/ocaml-multicore/ocaml-multicore/pull/814)
  Minor improvements
  
  An unused function in `asmcomp/reg.ml` has been removed, with the
  re-inclusion of few disabled tests. The `compare_programs` in the
  test suite now matches trunk.

#### Documentation

* [ocaml-multicore/ocaml-multicore#752](https://github.com/ocaml-multicore/ocaml-multicore/pull/752)
  Document the current Multicore testsuite situation

  The Multicore test suite now runs in the same way as `ocaml/ocaml`
  and hence this issue is closed.

* [ocaml-multicore/ocaml-multicore#759](https://github.com/ocaml-multicore/ocaml-multicore/pull/759)
  Rename type variables for clarity
  
  The PR to update the type variables for consistency and clarity in
  `stdlib/fiber.ml` has been merged.

* [ocaml-multicore/ocaml-multicore#778](https://github.com/ocaml-multicore/ocaml-multicore/pull/778)
  Comment on `caml_domain_spawn` also calling in `install_backup_thread`
  
  A comment that mentions when domain 0 first spawns a domain, and
  when the backup thread is not active, and is subsequently started.

* [ocaml-multicore/ocaml-multicore#787](https://github.com/ocaml-multicore/ocaml-multicore/pull/787)
  Address feedback on GC from async review
  
  A comment has been added to `runtime/finalise.c` for
  `coaml_final_merge_finalisable` on why the young of the source are
  added to the old of the target. The cap computed work limit is set
  to 0.3, as you cannot do more than 1/3 of a GC cycle in one slice.

* [ocaml-multicore/ocaml-multicore#800](https://github.com/ocaml-multicore/ocaml-multicore/pull/800)
  Document which GC stats are global and which are per-domain
  
  The comments in `stdlib/gc.mli` and `runtime/caml/domain_state.tbl`
  have been updated to provide information on the GC stats that are
  global, and those that are per-domain.

* [ocaml-multicore/ocaml-multicore#802](https://github.com/ocaml-multicore/ocaml-multicore/pull/802)
  More comments for domain
  
  The PR adds comments in `domain.c` and `domain.ml` with a high-level
  design of stop-the-world sections, state machine for the backup
  thread, signal handling with a mutex for `Domain.join`, and locking
  mechanism for the stop-the-world participant set.

#### Sundries

* [ocaml-multicore/ocaml-multicore#776](https://github.com/ocaml-multicore/ocaml-multicore/pull/776)
  Allow Dynlink only on Domain 0
  
  Dynlink is only allowed on the main domain, and entrypoints to
  public functions need to check the same.

* [ocaml-multicore/ocaml-multicore#807](https://github.com/ocaml-multicore/ocaml-multicore/pull/807)
  Make sure variables that are not explicitly initialized during `create_domain` are initialized
  
  The PR adds initialization to variables in `runtime/domain.c` during
  `create_domain` or for any utilized sub-function.

* [ocaml-multicore/ocaml-multicore#817](https://github.com/ocaml-multicore/ocaml-multicore/pull/817)
  Synchronise the opam file to use the `ocaml-options` packages
  
  The `ocaml-variants.opam` file has been updated to use the
  `ocaml-options` packages to synchronise with the opam-repository's
  variants and the scheme in the current Multicore repository.

## Ecosystem

### Ongoing

* [ocaml-multicore/multicore-opam#61](https://github.com/ocaml-multicore/multicore-opam/pull/61)
  Remove `omake`
  
  `caml_modify_field` does not exist in trunk. The PR removes omake as
  it is only required for +effects.

* [ocaml-multicore/multicore-opam#62](https://github.com/ocaml-multicore/multicore-opam/pull/62)
  Remove `domainslib`

  `Domainslib.0.3.0` has been upstreamed to opam-repository and hence
  has been removed from this repository.

* [ocaml-multicore/eio#116](https://github.com/ocaml-multicore/eio/pull/116)
  Benchmark various copying systems
  
  An open discussion on benchmarking and optimisation for copying data
  into buffer for three techniques: `fixed-buffer`, `new-cstruct`, and
  `chunk-as-cstruct`. The results from copying a 1GB file are shown in
  the illustration:

  ![Eio-PR-116-Copy-screenshot|357x499](https://discuss.ocaml.org/uploads/short-url/vWmMqD2TpWcYr9iepTziQU0C8h1.png)

* [ocaml-multicore/eio#120](https://github.com/ocaml-multicore/eio/pull/120)
  Add `Fibre.fork_on_accept` and `Net.accept`
  
  The PR where `fork_on_accept` now uses an accept function in a new
  switch, and passes the successful result to a handler function in a
  new fibre. The `Net.accept` function handles the case where a single
  connection can be accepted.

### Completed

#### Eio

* [ocaml-multicore/eio#87](https://github.com/ocaml-multicore/eio/issues/87)
  Eio fails to install due to vendor conflicts
  
  The [Marking uring as vendored breaks
  installation](https://github.com/ocaml-multicore/eio/pull/89) fix
  resolves this issue. This was reported by Matt Pallissard
  (@mattpallissard).

* [ocaml-multicore/eio#91](https://github.com/ocaml-multicore/eio/issues/91)
  [Discussion] Object Capabilities / API
  
  The discussion on using an open object as the first argument of
  every function, and to use full words and expressions instead of
  `network`, `file_systems` etc. is closed now with updates to
  [eio#90](https://github.com/ocaml-multicore/eio/pull/90).

* [ocaml-multicore/eio#101](https://github.com/ocaml-multicore/eio/issues/101)
  Make luv backend thread-safe
  
  An update to `lib_eio_luv/eio_luv.ml` that makes the luv backend
  thread-safe, and prevents a deadlock in the execution of benchmarks.

* [ocaml-multicore/eio#102](https://github.com/ocaml-multicore/eio/issues/102)
  Use a lock-free run queue for luv backend
  
  The PR removes the need for a mutex around the queue, and there is a
  trivial improvement in the single-domain benchmark:
  
  Before:
  ```
  $ make bench EIO_BACKEND=luv
  dune exec -- ./bench/bench_yield.exe
  n_fibers, ns/iter, promoted/iter
         1,   95.00,        0.0026
         2,  151.19,       12.8926
         3,  151.80,       12.8930
         4,  147.99,       12.8934
         5,  148.09,       12.8938
        10,  147.75,       12.8960
        20,  149.30,       12.9003
        30,  151.43,       12.9047
        40,  153.97,       12.9088
        50,  155.53,       12.9131
       100,  158.35,       12.9344
       500,  173.89,       13.0800
      1000,  182.50,       13.1779
     10000,  168.52,       13.7133
  ```

  After:
  ```
  $ make bench EIO_BACKEND=luv
  dune exec -- ./bench/bench_yield.exe
  n_fibers, ns/iter, promoted/iter
         1,   93.94,        4.9996
         2,   93.13,        5.0021
         3,   92.17,        5.0046
         4,   92.21,        5.0071
         5,   91.45,        5.0090
        10,  114.29,        5.0194
        20,   96.17,        5.0468
        30,   97.83,        5.0677
        40,   98.82,        5.0959
        50,   99.70,        5.1197
       100,  107.31,        5.2409
       500,  132.94,        6.1383
      1000,  142.85,        6.6771
     10000,  114.80,        5.9410
  ```

* [ocaml-multicore/eio#103](https://github.com/ocaml-multicore/eio/issues/103)
  Add `Domain_manager.run` to start a domain with an event loop
  
  The `lib_eio/eio.ml` code has added `Domain_manager.run` and
  `Domain_manager.run_raw` functions. The `Domain_manager.run`
  function must only access thread-safe values from the calling
  domain.

* [ocaml-multicore/eio#104](https://github.com/ocaml-multicore/eio/issues/104)
  Split out `Ctf_unix` module
  
  The dependency on `Unix` has been removed from the `Eio` module, and
  the `Ctf_unix.with_tracing` function has been added for convenience.

* [ocaml-multicore/eio#106](https://github.com/ocaml-multicore/eio/issues/106)
  Avoid `Fun.protect` in `Eio_linux.run`
  
  The use of `Fun.protect` is removed from
  `lib_eio_linux/eio_linux.ml` as it throws an exception, which is not
  useful when the scheduler crashes.

* [ocaml-multicore/eio#107](https://github.com/ocaml-multicore/eio/issues/107)
  Make cancellation thread-safe
  
  A cancellation context now has a list of fibres, and when a fibre is
  forked, it gets added to a list. As soon as the fibre finishes, it
  is removed from the list. The list is only accessible from the
  fibre's own domain, and each fibre holds a single, optionally atomic
  cancellation function.

* [ocaml-multicore/eio#108](https://github.com/ocaml-multicore/eio/issues/108)
  Clean up Waiters API
  
  The result type was not required by many users and has thus been
  removed. The relevant documentation has been updated as well.

* [ocaml-multicore/eio#109](https://github.com/ocaml-multicore/eio/issues/109)
  Use lock-free run queue in `eio_linux` tools
  
  The `lib_eio_linux/eio_linux.ml` file has been updated to use a
  lock-free run queue. The results on a single core benchmark are
  shown below:
  
  ```
  $ dune exec -- ./bench/bench_yield.exe`
  ```

  ![Eio-PR-109-Before-After|690x429](https://discuss.ocaml.org/uploads/short-url/sm3ND4YQkuYHmc1F2LCDDyeDCLT.png)

* [ocaml-multicore/eio#110](https://github.com/ocaml-multicore/eio/issues/110)
  Make `Waiters.wake_one` safe with cancellation
  
  As `wake_one` was being called after a cancelled waiter, we could
  not wake anything when using multiple domains. This PR fixes the
  same in `lib_eio/waiters.ml` along with a stress test.

* [ocaml-multicore/eio#111](https://github.com/ocaml-multicore/eio/issues/111)
  Restore domains test
  
  The `tests/tests_domains.md` file has now been enabled, since a fix
  to Multicore OCaml was backported to 4.12+domains. The tests also
  now run in the CI.

* [ocaml-multicore/eio#112](https://github.com/ocaml-multicore/eio/issues/112)
  Add `Stream.take_nonblocking`
  
  The `lib_eio/stream.ml` file has been updated to include a
  `Stream.take_nonblocking` function along with a couple of tests.

* [ocaml-multicore/eio#113](https://github.com/ocaml-multicore/eio/issues/113)
  Explain about `Promises` and `Streams` in the README
  
  The README has been updated with a section each on `Promises` and
  `Streams`, and the `Fibre.fork` code and tests have been simplified.

* [ocaml-multicore/eio#114](https://github.com/ocaml-multicore/eio/issues/114)
  Allow `Domain_mgr.run` to be cancelled
  
  The run() function in `lib_eio/eio.ml` has been updated to inject a
  cancel exception into the spawned domain. The tests for cancelling
  another domain, and spawning when already cancelled have been added
  to `tests/test_domains.md`.

* [ocaml-multicore/eio#115](https://github.com/ocaml-multicore/eio/issues/115)
  Create fibre context before forking
  
  A fibre is created without being started immediately, which allows
  more flexibility in scheduling and reduces the number of contexts.

* [ocaml-multicore/eio#117](https://github.com/ocaml-multicore/eio/issues/117)
  Allow to set `SO_REUSEPORT` option
  
  The PR adds support to set the `SO_REUSEPORT` socket setting for the
  `linux_uring` backend.

* [ocaml-multicore/eio#118](https://github.com/ocaml-multicore/eio/issues/118)
  Improve scheduling of forks
  
  The old `Fork` effect has been implemented similar to `Fork_ignore`,
  and `Fork_ignore` has been renamed to `Fork`. The old `Fiber.fork`
  is now `Fibre.fork_promise`. When forking, the caller is scheduled
  at the head of the run-queue, as this new scheduling order is more
  natural, flexible and better for caching.

* [ocaml-multicore/eio#119](https://github.com/ocaml-multicore/eio/issues/119)
  Improve cancellation
  
  The `Fibre.check` function has been added to check whether the
  current context has been cancelled, and documentation on
  cancellation has been updated.

* [ocaml-multicore/eio#121](https://github.com/ocaml-multicore/eio/issues/121)
  Add rationales for end-of-life and dynamic dispatch
  
  A documentation update on `Indicating End-of-File` and `Dynamic
  Dispatch` in `doc/rationale.md`.

#### Tezos

* [ocaml-multicore/tezos-opam-repository#7](https://github.com/ocaml-multicore/tezos-opam-repository/pull/7)
  Updates
  
  A merge from upstream that includes updates to the dependency
  packages and addition of new packages to the repository.

* [ocaml-multicore/tezos-opam-repository#8](https://github.com/ocaml-multicore/tezos-opam-repository/pull/8)
  Add `domainslib.0.4.0` & `lwt_domain.0.1.0`
  
  The addition of `domainslib.0.4.0` and `lwt_domain.0.1.0` to the
  tezos-opam-repository.

* [ocaml-multicore/tezos#21](https://github.com/ocaml-multicore/tezos/pull/21)
  Upstream updates

  The latest upstream build, code and documentation changes have been
  pulled from the Tezos repository.

#### Domainslib

* [ocaml-multicore/domainslib#50](https://github.com/ocaml-multicore/domainslib/pull/50)
  Multi_channel: allow more than one instance per program with different configurations
  
  A shared global state in `Multi_channel` exists in the form of
  `dls_new_key` that results in out-of-bounds array indexing. This PR,
  contributed by Edwin Torok (@edwintorok), removes the global key,
  and uses a per-channel key.

* [ocaml-multicore/domainslib#60](https://github.com/ocaml-multicore/domainslib/pull/60)
  Bug fix in `parallel_scan`
  
  The final entry in the array result was incorrect for
  `~num_additional_domains:1`, and for the case of rejecting an input
  array size less than the pool size.
  
* A new
  [domainslib.0.4.0](https://github.com/ocaml-multicore/domainslib/releases/tag/0.4.0)
  has been released that includes a breaking change. We now need to
  use effect handlers for task creation, and all computations need to
  be enclosed in a `Task.run` function.

## Benchmarking

### Sandmark and Sandmark-nightly

#### Ongoing

* [ocaml-bench/sandmark-nightly#23](https://github.com/ocaml-bench/sandmark-nightly/issues/23)
  Sandmark nightly issues
  
  A list of issues observed for the `sandmark.ocamllabs.io` service on
  results returned from Navajo and Turing machines.

* [ocaml-bench/sandmark-nightly#24](https://github.com/ocaml-bench/sandmark-nightly/pull/24)
  Use git clone from ocurrent-deployer
  
  An update to the Dockerfile to use git clone from `ocurrent-deployer`,
  instead of `ocaml-bench/sandmark-nightly`.

* [ocaml-bench/sandmark#266](https://github.com/ocaml-bench/sandmark/issues/266)
  Instrumented pausetimes for OCaml 5.00.0+trun and 4.14.0+domains

  The pausetimes variants in Sandmark need to be updated after trunk
  is frozen, in order to add the instrumented pausetimes for
  `5.00.0+trunk` and `4.14.0+domains`.

* [ocaml-bench/sandmark#268](https://github.com/ocaml-bench/sandmark/pull/268)
   Update README CI Build status to main branch
   
   The CI `Build Status` for the `main` branch in Sandmark needs to
   point to the main branch instead of the master branch.

#### Completed

* [ocaml-bench/sandmark#264](https://github.com/ocaml-bench/sandmark/pull/264)
  Cleanup for 4.12
  
  The `4.12.*` variants have been removed from Sandmark, and the
  scripts and documentation have been updated to reflect the same.

* [ocaml-bench/sandmark#265](https://github.com/ocaml-bench/sandmark/pull/265)
   Added package remove feature and builds for 5.00
   
   The `main` branch now supports a `package remove` option for the
   OCaml variants, where you can dynamically de-select the dependency
   package that you do not wish to build. For example, in
   `ocaml-versions/5.00.0+trunk.json`, you can specify the following:
   
   ```json
   {
      "url" : "https://github.com/ocaml/ocaml/archive/trunk.tar.gz",
      "package_remove": [
        "index",
        "integers",
        "irmin",
        "irmin-layers",
        "irmin-pack",
        "js_of_ocaml-compiler",
        "ppx_derivers",
        "ppx_deriving",
        "ppx_deriving_yojson",
        "ppx_irmin",
        "ppx_repr",
        "stdio"
      ]
   }
   ```
   
   The PR also pulls in the latest changes from the Sandmark master
   branch, and successfully builds 5.00.0+trunk for .drone.yml CI.

* [ocaml-bench/sandmark#267](https://github.com/ocaml-bench/sandmark/pull/267)
  Added support for bench.Dockerfile
  
  A `bench.Dockerfile` has been included in Sandmark to build and run
  the benchmarks with the `current-bench` project.

### current-bench

#### Ongoing

* [ocaml-multicore-ci#15](https://github.com/ocurrent/ocaml-multicore-ci/pull/15)
  Add dependency installation steps in README
  
  The following commands are required to be executed prior to
  installing and running `ocaml-multicore-ci` for a local repository:
  
  ```
  $ opam update
  $ opam install -t .
  ```

* [ocurrent/ocluster#151](https://github.com/ocurrent/ocluster/pull/151)
  Public `Ocluster_worker` library
  
  The PR exposes the internal library `Ocluster_worker` for
  current-bench and Sandmark, as we need a specific worker with custom
  settings to ensure that the benchmarks are stable.

* [ocurrent/ocluster#154](https://github.com/ocurrent/ocluster/pull/154)
  Use `opam update`, remove `--verbose`, and `--connect` options
  
  A README documentation update with the latest instructions and
  options available to use ocluster.

* [ocurrent/current-bench#226](https://github.com/ocurrent/current-bench/issues/226)
  Only build benchmarks whose dependencies build fine in CI
  
  The CI/CB pipeline can be integrated and extended to allow building
  of those dependencies in the benchmarks that are known to build
  cleanly in the CI for various OCaml variants.

* [ocurrent/ocaml-ci#399](https://github.com/ocurrent/ocaml-ci/pull/399/)
  Add dependency installation steps to README
  
  The `ocaml-ci` project can be run for a local project directory, and
  the `opam` commands to update and install the required dependencies
  have been added to the README.

#### Completed

* [ocurrent/current-bench#216](https://github.com/ocurrent/current-bench/pull/216)
  Add a custom OCluster worker build-and-run-benchmarks
  
  The PR provides a OCluster worker that enables us to build and run
  the benchmarks from the main pipeline, and fixes the Multicore
  repository settings.
  
* [ocurrent/current-bench#241](https://github.com/ocurrent/current-bench/pull/241)
  Display min and max values when displaying multi-value datapoints
  
  The minimum and maximum values for multi-value data points are now
  displayed for a range of commits in the graph.

  ![Current-bench-241-Min-Max|690x388](https://discuss.ocaml.org/uploads/short-url/8YoOBKutYLRMDliEnuDrk6daQC9.png)

* [ocurrent/current-bench#242](https://github.com/ocurrent/current-bench/pull/242)
  Workers: run one benchmark per CPU
  
  You can now run multiple benchmarks in parallel, each using its own
  CPU with the following setting in the `.env` file:
  
  ```
  OCAML_BENCH_DOCKER_CPU=4,5,6
  ```

* [ocurrent/current-bench#252](https://github.com/ocurrent/current-bench/pull/252)
  Make the Debian version more explicit
  
  The `pipeline/Dockerfile` and `pipeline/Dockerfile.env` files have
  been updated to be explicit on the Debian image
  `ocaml/opam:debian-11-ocaml-4.13` to be used.

* [ocurrent/current-bench#254](https://github.com/ocurrent/current-bench/pull/254)
  Allow setting a description for the metrics
  
  The current-bench frontend can now display a description for the
  metrics as shown in the following illustration:

  ![Current-bench-254-Metrics-Description|690x216](https://discuss.ocaml.org/uploads/short-url/eZ4kBExiMVCqSEwaBtdIKJEbN0c.png)

* [ocurrent/current-bench#257](https://github.com/ocurrent/current-bench/pull/257)
  Config repositories to run with specific workers and OCaml versions
  
  A static configuration can be provided to current-bench that
  specifies which workers and OCaml versions to use with the
  benchmarks. This is useful to obtain deterministic results for
  Sandmark workers that are Multicore enabled. For example:
  
  ```json
  [
    {
      "name": "author/repo",
      "worker": "autumn",
      "image": "ocaml/opam"
    },
    {
      "name": "local/local",
      "image": "ocaml/opam:debian-ocaml-4.11"
    }
  ]
  ```

Our special thanks to all the OCaml users, developers and contributors in the community for their valuable time and continued support to the project. Stay safe and happy new year!

## Acronyms

* AFL: American Fuzzy Lop
* AMD: Advanced Micro Devices
* API: Application Programming Interface
* ARM: Advanced RISC Machines
* CI: Continuous Integration
* CPU: Central Processing Unit
* DLS: Domain Local Storage
* EPYC: Extreme Performance Yield Computing
* GC: Garbage Collector
* GDB: GNU Project Debugger
* IO: Input/Output
* JSON: JavaScript Object Notation
* MD: Markdown
* MLP: ML-File Preprocessed
* OOM: Out of Memory
* OPAM: OCaml Package Manager
* PPC: Performance Optimization with Enhanced RISC - Performance Computing (PowerPC)
* PR: Pull Request
* PRNG Pseudo-Random Number Generator
* RFC: Request For Comments
* STW: Stop The World
* WG: Working Group
