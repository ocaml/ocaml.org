---
title: OCaml Multicore - November 2021
description: Monthly update from the OCaml Multicore team.
date: "2021-11-01"
tags: [multicore]
---

Welcome to the November 2021 [Multicore OCaml](https://github.com/ocaml-multicore/ocaml-multicore) monthly report! This month's update along with the [previous updates](https://discuss.ocaml.org/tag/multicore-monthly) have been compiled by me, @ctk21, @kayceesrk, and @shakthimaan.

# Core Team Code Review
In late November, the entire OCaml development team convened for a week-long code review and decision taking session on the Multicore merge for OCaml 5.0. Due to the size of the patchset, we broke up the designs and presentations in five working groups. Here's a summary of how each conversation went. As always, these decisions are subject to change from the core team as we discover issues, so please do not take any crucial decisions for your downstream projects on these. Our goal for publicising these is to hear about any corrections you might feel that we need to take on the basis of additional data that you might have from your own codebases.

For the purposes of brevity, we do not include the full minutes of the developer meetings. Overall, the multicore patches were deemed to be broadly sound and suitable, and we recorded the important decisions and tasks:

* **Pre-MVP:** Tasks that need to be done before we make the PR to ocaml/ocaml in the coming month.
* **Post-MVP for 5.00:** Tasks that need to be done on ocaml/ocaml before 5.00 release. *These tasks will block the OCaml 5.00 release.*
* **Post-5.00:** Future looking tasks after 5.00 is released in early/mid-2022.

## WG1: Garbage Collector

The Multicore runtime alters the memory allocation and garbage collector to support multiple parallel threads of OCaml execution. It utilizes a stop-the-world parallel minor collector, a StreamFlow like multithreaded allocator and a mostly-concurrent major collector.

WG1 decided that compaction will not be in the 5.0 initial release, as our best fit allocator has shown that a good memalloc strategy obviates the need for expensive compaction. Of course, the multicore memory allocator is different from bestfit, so we are in need of community input to ensure our hypothesis involving not requiring compaction is sound. If you do see such a use case of your application heap becoming very fragmented when 5.0 is in beta, please get in touch.

### Pre-MVP 
* Remove any traces of no-naked-pointers checker as it is irrelevant in the pagetable-less multicore runtime.
* Running `make parallel` for the testsuite should work
* Move from `assert` to `CAMLassert`
* How to do safepoints from C: add documentation on `caml_process_pending_actions` and a testsuite case for long-running C bindings to multicore
* Adopt the ephemeron bucket interface and do the same thing as 4.x OCaml trunk
* Check and document that `NOT_MARKABLE` can be used for libraries like ancient that want out of heap objects
* Check that we document what type of GC stats we return (global vs domain local) for the various stats

### Post-MVP for 5.00
* Mark stack overflow fix, which shouldn't affect most runtime allocation profiles

### Post-5.00
* Statmemprof implementation
* Mark pre-fetching
* Investigate alternative minor heap implementations which maintain performance but cut virtual memory usage

## WG2: Domains

Each domain in Multicore can execute a thread of OCaml in parallel with other domains. Several additions are made to OCaml to spawn new domains, join domains that are terminating and provide domain local storage. There is a stdlib module `Domain` and the underlying runtime domain structures.  A significant simplification in recent months is that the standard Mutex/Channel/Semaphore modules can be used instead of lower-level synchronisation primitives that were formerly available in `Domain`.

The challenge for the runtime structures is to accurately maintain the set of domains that must take part in stop-the-world sections in the presence of domain termination and spawning, as well as ensuring that a domain services stop-the-world requests when the main mutator is in a blocking call; this is handled using a *backup thread* signaled from `caml_enter_blocking_section` / `caml_leave_blocking_section`.

The Multicore OCaml memory model was discussed, and the right scheme selected for arm64 (Table 5b from [the paper](https://anil.recoil.org/papers/2018-pldi-memorymodel.pdf)). The local data race freedom (LDRF) property was agreed to be a balanced and predictable approach for a memory model for OCaml 5.0. We do likely need to depend on >C11 compiler for relaxed atomics in OCaml 5.0, so this will mean dropping Windows MSVC support for the MVP (but mingw will work).

### Pre-MVP 

* Make domain id abstract and provide `string_of_id`
* Document that initializing writes are ok using the Field macro with respect to the memory model. Also highlight that all writes need to use `caml_modify` (even immediates)
* Check that the selectgen 'coeffect' is correct for DLS.get
* More comments needed for domain.c to help the reader:
  - around backup thread state machine and where things happen
  - domain spawn/join
* Comment/check why `install_backup_thread` is called in spawnee and spawner
* Check the reason why domain terminate is using a mutex for join (rather than a mutex, condvar pair)

### Post-5.00
* Provide a mechanism for the user to retrieve the number of processors available for use. This can be implemented by libraries as well.
* Add atomic mutable record fields
* Add arrays of atomic variables

## WG3: Runtime Multi-Domain Safety

Multicore OCaml supports systhreads in a backwards compatible fashion. The execution model remains the same, except transposed to domains rather than a single execution context.

Each domain will get its own threads chaining: this means that while only one systhread can execute at a time on a single domain (akin to trunk), many domains can still execute in parallel, with their systhreads chaining being independent. To achieve this, a thread table is employed to allow each domains to maintain their own independent chaining. Context switching now involves extra care to handle the backup thread. The backup thread takes care of GC duties when a thread is currently in a blocking section. Systhreads needs to be careful about when to signal it.

The tick thread, used to periodically force thread preemption, has been updated to not rely on signals (as the Multicore signaling model does not allow this to be done efficiently). Instead, we rely on the interrupt infrastructure of the Multicore runtime and trigger an “external” interrupt, that will call back into systhreads to force a yield.

The existing Dynlink API was designed decades ago for a web browser written in OCaml (called "[mmm](https://caml.inria.fr/pub/old_caml_site/~rouaix/mmm/)") and is stateful. We'll make it possible to call concurrently in the OCaml 5.0 MVP, but the WG3 decided to start redesigning the Dynlink API to be less stateful.

Code fragments are now stored in a lockfree skiplist to allow multiple threads to work on the codefrags structures concurrently in a thread-safe manner. Extra care is required on cleanup (i.e, freeing unused code fragments entries): this should only happen on one domain, and this is done at the end of a major cycle. For the interested, [ocaml-multicore#672](https://github.com/ocaml-multicore/ocaml-multicore/pull/672) is a recommended read to see the concurrent skiplist structure now used.

Signals in Multicore have the following behaviour, with the WG3 deciding to change their behaviour to allow coalescing multiple signals from the perspective of the mutator:

* A program with a single domain should have mostly the same signal behaviour as trunk. This includes the delivery of signals to systhreads on that domain.
* Programs with multiple domains treat signals in a global fashion. It is not possible to direct signals to individual domains or threads, other than the control through thread sigmask. A domain recording a signal may not be the one executing the OCaml signal handler.

Frame descriptors modifications are now locked behind a mutex to avoid races if different threads were to try to apply changes to the frame table at the same time. Freeing up old frame tables is done at the end of a major cycle (which is a STW section) in order to be sure that no thread will be using this old frame table anymore.

Multicore OCaml contains a version of eventlog that is safe for multiple domains. It achieves this by having a separate CTF file per domain but this is an interim solution. We hope to replace this implementation with an existing prototype based on per-domain ring buffers which can be consumed programmatically from both OCaml and C. This will be a generalisation of eventlog, and so we should be able to remove the existing interface if it's not widely adopted yet.

### Pre-MVP 

* Rewrite intern.c so that it doesn't do GC. This code is performance sensitive as the compiler reads the cmi files by unmarshaling them. 
    * Benchmark on `big.ml` (from @stedolan) and binary tree benchmark (from @xavierleroy).
* Ensure the `m->waiters` atomics in systhreads are correct and safe.
* Write down options for `Thread.exit` to be discussed during or after merge, and what to do if just one domain exits while others continue to run. Should not be a blocking issue. Changing semantics is ok from vanilla trunk.
* `m->busy` is not atomic anymore as of [ocaml-multicore/ocaml-multicore#740](https://github.com/ocaml-multicore/ocaml-multicore/pull/740), should be reviewed and merged.
* Restrict `Dynlink` to domain 0 as it is a mutable interface and difficult to use concurrently.
* Signals stack should move from counting to coalescing semantics.
* Try to delay signal processing at domain spawn so that `Caml_state` is valid.
* Remove `total_signals_pending` if possible.

### Post-MVP for 5.00

* Probe opam for eventlog usage (introduced in OCaml 4.13) to determine if removing it will break any applications.
* Eventring merge is OK, eventlog API can be changed if functionality remains equivalent.
* (could be post 5.00 as well) TLS for systhreads.

### Post-5.00

* Get more data on Dynlink usage and design a new API that is less stateful.
* @xavierleroy suggested redesigning marshalling in light of the new allocator.

## WG4: Stdlib Changes

The main guiding principle in porting the Stdlib to OCaml 5.00 is that

1. OCaml 5.00 does not provide thread-safety by default for mutable data structures and interfaces.
2. OCaml 5.00 does ensure memory-safety (no crashes) even when stdlib is used in parallel by multiple domains.
3. Observationally pure interfaces remain so in OCaml 5.00.

For OCaml libraries with specific mutable interfaces (e.g. Queue, Hashtbl, Stack, etc.) they will not be made domain-safe to avoid impacting sequential performance. Programs using parallelism will need to add their own lock safety around concurrent access to such modules. Modules with top-level mutable state (e.g. Filename, Random, Format, etc..) will be made domain-safe. Some, such as Random, are being extensively redesigned to use new approaches such as splittable prngs. The motivation for these choices and further discussion is found in the [Multicore OCaml wiki page](https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml).

The WG4 also noted that we would accept alternative versions of mutable stdlib modules that are concurrent-safe (e.g. have a `Concurrent.Hashtbl`), and also hopes to see more lockfree libraries developed independently by the OCaml community. Overall, WG4 recognised the importance of community involvement with the process of porting OCaml libraries to parallel safety. We aim to add ocamldoc tags to the language to mark modules/functions safety, and hope to get this in the new unified package db at [v3.ocaml.org](https://v3.ocaml.org/packages) ahead of OCaml 5.0.

#### Lazy

Lazy values in OCaml allow deferred computations to be run by *forcing* them. Once the lazy computation runs to completion, the lazy is updated such that further forcing fetches the result from the previous forcing. The minor GC also short-circuits forced lazy values avoiding a hop through the lazy object. The implementation of lazy uses [unsafe operations from the Obj module](https://github.com/ocaml/ocaml/blob/trunk/stdlib/camlinternalLazy.ml).

The implementation of Lazy has been made thread-safe in OCaml 5.00. For single-threaded use, the Lazy module preserves backwards compatibility. For multi-threaded use, the Lazy module adds synchronization such that on concurrent forcing of an unforced lazy value from multiple domains, one of the domains will get to run the deferred computation while the other will get a new exception `RacyLazy` .

#### Random

With [ocaml-multicore#582](https://github.com/ocaml-multicore/ocaml-multicore/pull/582), we have domain-local PRNGs following closely along the lines of stock OCaml. In particular, the behaviour remains the same for sequential OCaml programs. But the situation for parallel programs is not ideal. Without explicit initialisation, all the domains will draw the same initial sequence.

There is ongoing discussion on splittable PRNGs in [ocaml/RFCs#28](https://github.com/ocaml/RFCs/pull/28), and a re-implementation of Random using the Xoshiro256++ PRNG in [ocaml/ocaml#10701](https://github.com/ocaml/ocaml/pull/10701).

#### Format

The Format module has some hidden global state for implementing pretty-printing boxes. While the module has explicit API for passing the formatter state to the functions, there are predefined formatters for `stdout` , `stderr` and standard buffer, whose state is maintained by the module.

The Format module has been made thread-safe for predefined formatters. We use domain-local versions of formatter state for each domain, lazily switching to this version when the first-domain is spawned. This preserves the performance of single-threaded code, while being thread-safe for multi-threaded use case. See the discussion in [ocaml/ocaml#10453](https://github.com/ocaml/ocaml/issues/10453#issuecomment-868940501) for a summary.

#### Mutex, Condition, Semaphore

The Mutex, Condition and Semaphore modules are the same as systhreads in stock OCaml. They now reside in `stdlib` . When systhreads are linked, the same modules are used for synchronization between systhreads.

### Pre-MVP 

* Mark lazy as not thread safe.
    * Unify RacyLazy and Undefined
    * Remove domain-local unique token
    * Remove try_force
* Add the Bucket module for ephemerons with a default sequential implementation as seen in OCaml 4.13.

### Post-MVP for 5.00

* Introduce ocamldoc tags for different concurrency safety 
    * domain-safe
    * systhread-safe
    * fiber-safe
    * not-concurrency-safe (= !domain-safe || !systhread-safe || !fiber-safe) -- also used as a placeholder for libraries and functions not analysed for concurrency.
* Add documentation for memory model in the manual. Specifically, no values out of thin air – no need to precisely document the memory model aside from pointing to paper.
* For `Arg` module, deprecate current but not whole module
* remove ThreadUnix as a simple module that would no longer need Unix.
* Dynlink should have a mutex inside it to ensure it doesnt crash especially in bytecode.

### Post-5.00

* Atomic arrays
* Ephemerons reimplemented in terms of Bucket module. 
* Make disjoint the update of the lazy tag and marking by using byte-sized write and CAS.

## WG5: Fibers

Fibers are the runtime system mechanism that supports effect handlers. The design of effect handlers in OCaml has been written up in the [PLDI 2021 paper](https://arxiv.org/abs/2104.00250).The motivation for adding effect handlers and some more examples are found in [these slides](https://speakerdeck.com/kayceesrk/effect-handlers-in-multicore-ocaml ).

#### Programming with Effect Handlers

Effect handlers are made available to the OCaml programmer from `stdlib/effectHandlers.ml` (although this will likely be renamed `Effect` soon). The EffectHandlers module exposes two variants of effect handlers – deep and shallow. Deep handlers are like folds over the computation tree whereas shallow handlers are akin to [case splits](https://www.dhil.net/research/papers/generalised_continuations-jfp-draft.pdf). With deep handlers, the handler wraps around the continuation, whereas in shallow handlers it doesn’t.

Here is an example of a program that uses deep handlers to model something analogous to the `Reader` monad.

```ocaml
open EffectHandlers
open EffectHandlers.Deep

type _ eff += Ask : int eff

let main () =
  try_with (fun _ -> perform Ask + perform Ask) ()
  { effc = fun (type a) (e : a eff) ->
      match e with
      | Ask -> Some (fun (k : (a,_) continuation) -> continue k 1)
      | _ -> None }

let _ = assert (main () = 2)
```

Observe that when we resume the continuation `k` , the subsequent effects performed by the computation are also handled by the same handler. As opposed to this, for the shallow handler doesn’t. For shallow handlers, we use `continue_with` instead of continue.

```ocaml
open EffectHandlers
open EffectHandlers.Shallow

type _ eff += Ask : int eff

let main () =
  let rec loop (k: (int,_) continuation) (state : int) =
    continue_with k state
    { retc = (fun v -> v);
      exnc = (fun e -> raise e);
      effc = fun (type a) (e : a eff) ->
        match e with
        | Ask -> Some (fun (k : (a, _) continuation) -> loop k 1)
        | _ -> None }
  in
  let k = fiber (fun _ -> perform Ask + perform Ask) in
  loop k 1

let _ = assert (main () = 2)
```

Observe that with a shallow handler, the recursion is explicit. Shallow handlers makes it easier to encode cases where state needs to be threaded through. For example, here is a variant of the `State` handler that encodes a counter:

```ocaml
open EffectHandlers
open EffectHandlers.Shallow

type _ eff += Next : int eff

let main () =
  let rec loop (k: (int,_) continuation) (state : int) =
    continue_with k state
    { retc = (fun v -> v);
      exnc = (fun e -> raise e);
      effc = fun (type a) (e : a eff) ->
        match e with
        | Next -> Some (fun (k : (a, _) continuation) -> loop k (state + 1))
        | _ -> None }
  in
  let k = fiber (fun _ -> perform Next + perform Next) in
  loop k 0

let _ = assert (main () = 3)
```

While this encoding is possible with deep handlers (by the usual `State` monad trick of building up a computation using a closure), it feels more natural with shallow handlers. In general, one can easily encode deep handlers using shallow handlers, but going the other way is challenging. With the typed effects work currently in development, the default would be shallow handlers and deep handlers would be encoded using the shallow handlers.

As a bit of history, the current implementation is tuned for deep handlers and has gathered optimizations over several iterations. If shallow handlers becomes more widely in the coming years, it may be possible to put in some tweaks that removes a few allocations. That said, the semantics of the deep and shallow handlers in this future implementation will remain the same as what is currently in OCaml 5.00 branch.

### Post-MVP for 5.00

* Add ARM64 backend
* Documentation on the usage of effect handlers.
* Current stack size should be the sum of the stack sizes of the stack of fibers. Currently, it only captures the top fiber size.
  + This is not straight-forward as it seems. Resuming continuations attaches a stack. Should we do stack overflow checks there? I'd not, as this would make resuming continuations slower. One idea might be to only do the stack overflow check at stack realloc, which catches the common case. 

### Post-5.00

* Add support for compiling with frame pointers.

# The November Activities

That wraps up the mammoth code review summary, and significant decisions taken.  Overall, we are full steam ahead for generating an OCaml 5.0 PR, although we do have our work cut out for us in the coming months! Now we continue with our regular report on what else happened in November.The ecosystem is continuing to evolve, and there are significant updates to Eio, the Effects-based parallel IO for OCaml.

[Lwt.5.5.0](https://discuss.ocaml.org/t/ann-lwt-5-5-0-lwt-domain-0-1-0-lwt-react-1-1-5/8897) has been released that supports dispatching pure computations to multicore domains. The Sandmark benchmarking has now been updated to build for 5.00, and the current-bench tooling is being improved to better track the performance analysis and upstream merge changes.

As always, the Multicore OCaml updates are listed first, which contain the upstream efforts, documentation changes, and PR fixes. This is followed by the ecosystem updates to `Eio` and `Tezos`. The Sandmark, sandmark-nightly and current-bench tasks are finally listed for your kind reference.

## Multicore OCaml

### Ongoing

#### Upstream

* [ocaml-multicore/ocaml-multicore#669](https://github.com/ocaml-multicore/ocaml-multicore/pull/669)
  Set thread names for domains

  A patch that implements thread naming for Multicore OCaml. It
  provides an interface to name Domains and Threads differently. The
  changes have now been rebased with check-typo fixes.

* [ocaml-multicore/ocaml-multicore#733](https://github.com/ocaml-multicore/ocaml-multicore/issues/733)
  Improve the virtual memory consumption on Linux

  An ongoing design discussion on orchestrating the minor heap
  allocations of domains for virtual memory performance, domain spawn
  and termination, performance and safety of `Is_young` runtime usage,
  and change of minor heap size using `Gc` set.

* [ocaml-multicore/ocaml-multicore#735](https://github.com/ocaml-multicore/ocaml-multicore/pull/735)
  Add `caml_young_alloc_start` and `caml_young_alloc_end` in `minor_gc.c`

  `caml_young_alloc_start` and `caml_young_alloc_end` are not present
  in Multicore OCaml, and they should be the same as `young_start` and
  `young_end`.

* [ocaml-multicore/ocaml-multicore#736](https://github.com/ocaml-multicore/ocaml-multicore/issues/736)
  Decompress testsuite fails 5.0 because of missing pthread link flag

  An undefined reference to `pthread_sigmask` has been observed when
  `-lpthread` is not linked when testing the decompress testsuite.

* [ocaml-multicore/ocaml-multicore#737](https://github.com/ocaml-multicore/ocaml-multicore/issues/737)
  Port the new ephemeron API to 5.00

  An API for immutable ephemerons has been
  [merged](https://github.com/ocaml/ocaml/pull/10737) in trunk, and
  the respective changes need to be ported to 5.00.

* [ocaml-multicore/ocaml-multicore#740](https://github.com/ocaml-multicore/ocaml-multicore/pull/740)
  Systhread lifecycle

  The PR addresses the systhreads lifecycle in Multicore and provides
  fixes in `caml_thread_domain_stop_hook`, `Thread.exit` and
  `caml_c_thread_unregister`.

* [ocaml-multicore/ocaml-multicore#742](https://github.com/ocaml-multicore/ocaml-multicore/issues/742)
  Minor tasks from asynchronous review

  A list of minor tasks from the asynchronous review for OCaml 5.00
  release. The major tasks will have their own GitHub issues.

* [ocaml-multicore/ocaml-multicore#745](https://github.com/ocaml-multicore/ocaml-multicore/pull/745)
  Systhreads WG3 comments

  The commit names should be self-descriptive, use of non-atomic
  variables is preferred, and we should raise OOM when there is a
  failure to allocate thread descriptors.

* [ocaml-multicore/ocaml-multicore#748](https://github.com/ocaml-multicore/ocaml-multicore/pull/748)
  WG3 move `gen_sizeclasses`

  The PR moves `runtime/gen_sizeclasses.ml` to
  `tools/gen_sizeclasses.ml` and fixes check-typo issues.

* [ocaml-multicore/ocaml-multicore#750](https://github.com/ocaml-multicore/ocaml-multicore/issues/750)
  Discussing the design of Lazy under Multicore

  A ongoing discussion on the design of Lazy for Multicore OCaml that
  addresses sequential Lazy, concurrency problems, duplicated
  computations, and memory safety.

* [ocaml-multicore/ocaml-multicore#753](https://github.com/ocaml-multicore/ocaml-multicore/issues/753)
  C API to pin domain to C thread?

  A question on how to design an API that would allow creating a
  domain "pinned" to an existing C thread, from C.

* [ocaml-multicore/ocaml-multicore#754](https://github.com/ocaml-multicore/ocaml-multicore/issues/754)
  Improvements to `emit.mlp` organization

  The `preproc_fun` function should be moved to a target-independent
  module, and all the prologue code needs to be emitted in one place.

* [ocaml-multicore/ocaml-multicore#756](https://github.com/ocaml-multicore/ocaml-multicore/pull/756)
  RFC: Generalize the `Domain.DLS` interface to split PRNG state for child domains

  The PR demonstrates an implementation for a "proper" PRNG+Domains
  semantics where spawning a domain "splits" the PRNG state.

* [ocaml-multicore/ocaml-multicore#757](https://github.com/ocaml-multicore/ocaml-multicore/issues/757)
  Audit `stdlib` for mutable state

  An issue tracker for the status of auditing `stdlib` for mutable
  state. OCaml 5.00 stdlib will have to guarantee both memory and
  thread safety.

#### Documentation

* [ocaml-multicore/ocaml-multicore#741](https://github.com/ocaml-multicore/ocaml-multicore/issues/741)
  Ensure copyright headers are formatted properly

  The copyright headers in the source files must be neatly formatted
  using the new format. If the old format already exists, then the
  author, institution details must be added as shown below:

  ```
  /**************************************************************************/
  /*                                                                        */
  /*                                 OCaml                                  */
  /*                                                                        */
  /*          Xavier Leroy and Damien Doligez, INRIA Rocquencourt           */
  /*          <author's name>, <author's institution>                       */
  /*                                                                        */
  /*   Copyright 1996 Institut National de Recherche en Informatique et     */
  /*     en Automatique.                                                    */
  /*   Copyright <first year written>, <author OR author's institution>     */
  /*   Included in OCaml under the terms of a Contributor License Agreement */
  /*   granted to Institut National de Recherche en Informatique et en      */
  /*   Automatique.                                                         */
  /*                                                                        */
  /*   All rights reserved.  This file is distributed under the terms of    */
  /*   the GNU Lesser General Public License version 2.1, with the          */
  /*   special exception on linking described in the file LICENSE.          */
  /*                                                                        */
  /**************************************************************************/
  ```

* [ocaml-multicore/ocaml-multicore#743](https://github.com/ocaml-multicore/ocaml-multicore/issues/743)
  Unhandled exceptions should render better error message

  A request to output informative `Unhandled_effect <EFFECT_NAME>`
  error message instead of `Unhandled` in the compiler output.

* [ocaml-multicore/ocaml-multicore#752](https://github.com/ocaml-multicore/ocaml-multicore/pull/752)
  Document the current Multicore testsuite situation

  A documentation update on how to run the Multicore OCaml
  testsuite. The steps are as follows:

  ```
  $ make world.opt
  $ cd testsuite
  $ make all-enabled
  ```

* [ocaml-multicore/ocaml-multicore#759](https://github.com/ocaml-multicore/ocaml-multicore/pull/759)
  Rename type variables for clarity

  The type variables in `stdlib/fiber.ml` have been updated for
  consistency and clarity.

#### Sundries

* [ocaml-multicore/ocaml-multicore#725](https://github.com/ocaml-multicore/ocaml-multicore/pull/725)
  Blocked signal infinite loop fix

  A monotonic `recorded_signals_counter` has been introduced to fix
  the possible loop in `caml_enter_blocking_section` when no domain
  can handle a blocked signal. A `signals_block.ml` callback test has
  also been added.

* [ocaml-multicore/ocaml-multicore#730](https://github.com/ocaml-multicore/ocaml-multicore/issues/730)
  `ocamlopt` raise a stack-overflow compiling `aws-ec2.1.2` and `color-brewery.0.2`

  A "Stack overflow" exception raised while compiling `aws-ec2.1.2`
  with 4.14.0+domains+dev0.

* [ocaml-multicore/ocaml-multicore#734](https://github.com/ocaml-multicore/ocaml-multicore/issues/734)
  Possible segfault when a new domain is signalled before it can initialize the domain_state

  A potential segmentation fault caused when a domain created by
  `Domain.spawn` receives a signal before it can reach its main
  entrypoint and initialize thread local data.

* [ocaml-multicore/ocaml-multicore#738](https://github.com/ocaml-multicore/ocaml-multicore/issues/738)
  Assertion violation when an external function and the GC run concurrently

  An `Assertion Violation` error message is thrown when Z3 tries to
  free GC cleaned up objects in the `get_unsat_core` function.

* [ocaml-multicore/ocaml-multicore#749](https://github.com/ocaml-multicore/ocaml-multicore/issues/749)
  Potential bug on `Forward_tag` short-circuiting?

  A bug when short-circuiting `Forward_tag` on values of type
  `Obj.forcing_tag`. Short-circuiting is disabled on values of type
  `Forward_tag`, `Lazy_tag` and `Double_tag` in the minor GC.

### Completed

#### Upstream

* [ocaml-multicore/ocaml-multicore#637](https://github.com/ocaml-multicore/ocaml-multicore/issues/637)
  `caml_page_table_lookup` is not available in ocaml-multicore

  Multicore does not have a page table, and `ancient` will not build
  if it references `caml_page_table_lookup`. The [Remove the remanents
  of page table
  functionality](https://github.com/ocaml-multicore/ocaml-multicore/pull/642)
  PR fixes this issue.

* [ocaml-multicore/ocaml-multicore#727](https://github.com/ocaml-multicore/ocaml-multicore/pull/727)
  Update version number

  The `ocaml-variants.opam` file has been updated to use
  `ocaml-variants.4.14.0+domains`.

* [ocaml-multicore/ocaml-multicore#728](https://github.com/ocaml-multicore/ocaml-multicore/issues/728)
  Update `base-domains` package for 5.00 branch

  The `base-domains` package now includes `4.14.0+domains`. Otherwise,
  the pinning on a local opam switch fails on dependency resolution.

* [ocaml-multicore/ocaml-multicore#729](https://github.com/ocaml-multicore/ocaml-multicore/pull/729)
  Introduce `caml_process_pending_signals` which raises if exceptional

  The code matches `caml_process_pending_actions` /
  `caml_process_pending_actions_exn` from trunk and cleans up
  `caml_raise_if_exception(caml_process_pending_signals_exn())` calls.

#### Documentation

* [ocaml-multicore/ocaml-multicore/744](https://github.com/ocaml-multicore/ocaml-multicore/pull/744)
  Make cosmetic change to comments in `lf_skiplist`

  The comments in `runtime/lf_skiplist.c` have been updated with
  reference to the paper by Willam Pugh on "Skip Lists".

* [ocaml-multicore/ocaml-multicore#746](https://github.com/ocaml-multicore/ocaml-multicore/pull/746)
  Frame descriptors WG3 comments

  The copyright headers have been added to
  `runtime/frame_descriptors.c` and `runtime/frame_descriptors.h`.

* [ocaml-multicore/ocaml-multicore#747](https://github.com/ocaml-multicore/ocaml-multicore/pull/747)
  Fix check typo for sync files

  The check-typo errors for `sync.c` and `sync.h` have been fixed.

* [ocaml-multicore/ocaml-multicore#755](https://github.com/ocaml-multicore/ocaml-multicore/pull/755)
  More fixes for check-typo

  The check-typo fixes for `otherlibs/unix/fork.c`,
  `runtime/finalise.c`, `runtime/gc_ctrl.c`, `runtime/Makefile` and
  `runtime/caml/eventlog.h` have been merged.

#### Sundries

* [ocaml-multicore/ocaml-multicore#720](https://github.com/ocaml-multicore/ocaml-multicore/pull/720)
  Improve ephemerons compatibility with testsuite

  The PR fixes `weaktest.ml` and also imports upstream changes to make
  ephemerons work with infix objects.

* [ocaml-multicore/ocaml-multicore#731](https://github.com/ocaml-multicore/ocaml-multicore/pull/731)
  AFL: Segfault and lock resetting (Fixes [#497](https://github.com/ocaml-multicore/ocaml-multicore/issues/497))

  A fix to get AFL-instrumentation working again on Multicore
  OCaml. The PR also changes `caml_init_domains` to use
  `caml_fatal_error` consistently.

## Ecosystem

### Ongoing

* [ocaml-multicore/tezos#8](https://github.com/ocaml-multicore/tezos/issues/8)
  ci.Dockerfile throws warning

  The `numerics` library which enforced `c99` has been removed from
  Tezos, and hence this warning should not occur.

* [ocaml-multicore/domainslib#55](https://github.com/ocaml-multicore/domainslib/issues/55)
  `setup_pool`: option to exclude the current/first domain?

  The use case to not include the main thread as part of the pool is a
  valid request. The use of `async_push` can help with the same:

  ```ocaml
  (* main thread *)
  let pool = setup_pool ~num_additional_domains () in
  let promise = async_push pool initial_task in
  (* the workers are now executing the [initial_task] and
     its children. main thread is free to do its thing. *)
  ....
  (* when it is time to terminate, for cleanup, you may optionally do *)
  let res = await pool promise (* waits for the promise to resolve, if not already *)
  teardown_pool pool
  ```

* [ocaml-multicore/eio#91](https://github.com/ocaml-multicore/eio/issues/91)
  [Discussion] Object Capabilities / API

  An open discussion on using an open object as the first argument of
  every function, and to use full words and expressions instead
  `network`, `file_systems` etc.

### Completed

#### Eio

* [ocaml-multicore/eio#86](https://github.com/ocaml-multicore/eio/pull/86)
  Update README to mention `libuv` backend

  The README.md file has been updated to mention that the library
  provides a generic backend based on `libuv`, that works on most
  platforms, and has an optimised backend for Linux using `io-uring`.

* [ocaml-multicore/eio#89](https://github.com/ocaml-multicore/eio/pull/89)
  Marking `uring` as vendored breaks installation

  The use of `pin-depends` for `uring` to avoid any vendoring
  installation issues with OPAM.

* [ocaml-multicore/eio#90](https://github.com/ocaml-multicore/eio/pull/90)
  Implicit cancellation

  A `lib_eio/cancel.ml` has been added to `Eio` that has been split
  out of `Switch`. The awaiting promises use the cancellation context,
  and many operations no longer require a switch argument.

* [ocaml-multicore/eio#92](https://github.com/ocaml-multicore/eio/pull/92)
  Update trace diagram in README

  The trace diagram in the README file has been updated to show two
  counting threads as two horizontal lines, and white regions
  indicating when each thread is running.

  ![eio-pr-92-trace|690x157](https://discuss.ocaml.org/uploads/short-url/nG6djh8yYPqlPxlOzswCsvY5How.png)

* [ocaml-multicore/eio#93](https://github.com/ocaml-multicore/eio/pull/93)
  Add `Fibre.first`

  The `Fibre.first` returns the result of the first fibre to finish,
  cancelling the other one. A `tests/test_fibre.md` file has also been
  added with this PR.

* [ocaml-multicore/eio#94](https://github.com/ocaml-multicore/eio/pull/94)
  Add `Time.with_timeout`

  The module `Time` now includes both `with_timeout` and
  `with_timeout_extn` functions to `lib_eio/eio.ml`.

* [ocaml-multicore/eio#95](https://github.com/ocaml-multicore/eio/pull/95)
  Track whether cancellation came from parent context

  A `Cancelled` exception is raised if the parent context is asked to
  exit, so as to propagate the cancellation upwards. If the
  cancellation is inside, the original exception is raised.

* [ocaml-multicore/eio#96](https://github.com/ocaml-multicore/eio/pull/96)
  Add `Fibre.all`, `Fibre.pair`, `Fibre.any` and `Fibre.await_cancel`

  The `all`, `pair`, `any` and `await_cancel` functions have been
  added to the `Fibre` module in `libe_eio/eio.ml`.

* [ocaml-multicore/eio#97](https://github.com/ocaml-multicore/eio/pull/97)
  Fix MDX warning

  The `tests/test_fibre.md` file has been updated to fix MDX warnings.

* [ocaml-multicore/eio#98](https://github.com/ocaml-multicore/eio/pull/98)
  Keep an explicit tree of cancellation contexts

  A tree of cancellation contexts can now be dumped to the output, and
  this is useful for debugging.

* [ocaml-multicore/eio#99](https://github.com/ocaml-multicore/eio/pull/99)
  Make enqueue thread-safe

  Thread-safe promises, streams and semaphores have been added to
  Eio. The `make bench` target can test the same:

  ```
  dune exec -- ./bench/bench_promise.exe
  Reading a resolved promise: 4.684 ns
  use_domains,   n_iters, ns/iter, promoted/iter
        false,  1000000,   964.73,       26.0096
         true,   100000, 13833.80,       15.7142

  dune exec -- ./bench/bench_stream.exe
  use_domains,  n_iters, capacity, ns/iter, promoted/iter
        false, 10000000,        1,  150.95,        0.0090
        false, 10000000,       10,   76.55,        0.0041
        false, 10000000,      100,   52.67,        0.0112
        false, 10000000,     1000,   51.13,        0.0696
         true,  1000000,        1, 4256.24,        1.0048
         true,  1000000,       10,  993.72,        0.2526
         true,  1000000,      100,  280.33,        0.0094
         true,  1000000,     1000,  287.93,        0.0168

  dune exec -- ./bench/bench_semaphore.exe
  use_domains,  n_iters, ns/iter, promoted/iter
        false, 10000000,   43.36,        0.0001
         true, 10000000,  303.89,        0.0000
  ```

* [ocaml-multicore/eio#100](https://github.com/ocaml-multicore/eio/pull/100)
  Propogate backtraces in more places

  The `libe_eio/fibre.ml` and `lib_eio_linux/eio_linux.ml` have been
  updated to allow propagation of backtraces.

#### Tezos

* [ocaml-multicore/tezos#10](https://github.com/ocaml-multicore/tezos/pull/10)
  Fix `make build-deps`, fix NixOS support

  The patch fixes `make build-deps/build-dev-deps`, and `conf-perl`
  has been removed from the `tezos-opam-repository`.

* [ocaml-multicore/tezos#15](https://github.com/ocaml-multicore/tezos/pull/15)
  Fix `scripts/version.h`

  The CI build failure is now fixed with proper exporting of variables
  in `scripts/version.h` file.

* [ocaml-multicore/tezos#16](https://github.com/ocaml-multicore/tezos/pull/16)
  Fix `make build-deps` and `make build-dev-deps` to install correct OCaml switch

  The hardcoded OCaml switches have now been removed from the script
  file and the switch information from `script/version.h` is used with
  `make build-deps` and `make build-dev-deps` targets.

* [ocaml-multicore/tezos#17](https://github.com/ocaml-multicore/tezos/pull/17)
  Enable CI on pull request to `4.12.0+domains` branch

  CI has been enabled for pull requests for the 4.12.0+domains branch.

* [ocaml-multicore/tezos#20](https://github.com/ocaml-multicore/tezos/pull/20)
  Upstream updates

  A merge of the latest upstream build, code and documentation changes
  from Tezos repository.

#### Sundries

* [ocaml-multicore/tezos-opam-repository#6](https://github.com/ocaml-multicore/tezos-opam-repository/pull/6)
  Updates

  The dependency packages in the `tezos-opam-repository` have been
  updated, and `mtime.1.3.0` has been added as a dependency.

* [ocaml-multicore/ocaml-uring#40](https://github.com/ocaml-multicore/ocaml-uring/pull/40)
  Remove test dependencies on `Bos` and `Rresult`

  The `Bos` and `Rresult` dependencies have been removed from the
  project as we already depend on OCaml >= 4.12 which provides the
  required functions.

* [ocaml-multicore/ocaml-uring#42](https://github.com/ocaml-multicore/ocaml-uring/pull/42)
  Handle race in `test_cancel_late`

  A race condition from `test_cancel_late` in `tests/main.ml` has been
  fixed with this merged PR.

* [ocaml-multicore/domainslib#51](https://github.com/ocaml-multicore/domainslib/pull/51)
  Utilise effect handlers

  The tasks are now created using effect handlers, and a new
  `test_deadlock.ml` test has been added.

## Benchmarking

### Sandmark and Sandmark-nightly

#### Ongoing

* [ocaml-bench/sandmark-nightly#21](https://github.com/ocaml-bench/sandmark-nightly/issues/21)
  Add 5.00 variants

  Multicore OCaml now tracks OCaml trunk, and 4.12.0+domains+effects
  and 4.12+domains will only have bug fixes. The following variants
  are now required to be included in sandmark-nightly:

  * OCaml trunk, sequential, runtime (throughput)
  * OCaml 5.00, sequential, runtime
  * OCaml 5.00, parallel, runtime
  * OCaml trunk, sequential, pausetimes (latency)
  * OCaml 5.00, sequential, pausetimes
  * OCaml 5.00, parallel, pausetimes

* [ocaml-bench/sandmark#262](https://github.com/ocaml-bench/sandmark/issues/262)
  `ocaml-migrate-parsetree.2.2.0+stock` fails to compile with ocaml.5.00.0+trunk

  The `ocaml-migrate-parsetree` dependency does not work with OCaml
  5.00, and we need to wait for the 5.00 AST to be frozen in order to
  build the package with Sandmark.

* A `package_remove` feature is being added to the -main branch of
  Sandmark that allows to dynamically remove any dependency packages
  that are known to fail to build on recent development branches.

#### Completed

* [ocaml-bench/sandmark-nightly#22](https://github.com/ocaml-bench/sandmark-nightly/pull/22)
  Fix dataframe intersection order issue

  The `dataframe_intersection` function has been updated to properly
  filter out benchmarks that are not present for the variants that are
  being compared.

* [ocaml-bench/sandmark#248](https://github.com/ocaml-bench/sandmark/issues/248)
  Coq fails to build

  A new Coq tarball,
  [coq-multicore-2021-09-24](https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24),
  is now used to build with Sandmark for the various OCaml variants.

* [ocaml-bench/sandmark#257](https://github.com/ocaml-bench/sandmark/pull/257)
  Added latest Coq 2019-09 to Sandmark

  The Coq benchmarks in Sandmark now build fine for 4.14.0+domains and
  OCaml 5.00.

* [ocaml-bench/sandmark#260](https://github.com/ocaml-bench/sandmark/pull/260)
  Add 5.00 branch for sequential run. Fix notebook.

  Sandmark can now build the new 5.00 OCaml variant to build both
  sequential and parallel benchmarks in the CI.

* [ocaml-bench/sandmark#261](https://github.com/ocaml-bench/sandmark/pull/261)
  Update benchmark and domainslib to support OCaml 4.14.0+domains (OCaml 5.0)

  We now can build Sandmark benchmarks for OCaml 5.00, and the PR
  updates to use `domainslib.0.3.2`.

### current-bench

#### Ongoing

* [ocurrent/current-bench#219](https://github.com/ocurrent/current-bench/issues/219)
  Support overlay of graphs from different compiler variants

  At present, we are able to view the front-end graphs per OCaml
  version. We need to overlay graphs across compiler variants for
  better comparison and visualization.

* [ocurrent/current-bench#220](https://github.com/ocurrent/current-bench/issues/220)
  Setup current-bench and Sandmark for nightly runs

  On a tuned machine, we need to setup current-bench (backend and
  frontend) for Sandmark and schedule nightly runs.

* [ocurrent/current-bench#221](https://github.com/ocurrent/current-bench/issues/221)
  Support developer repository, branch and commits for Sandmark runs

  A request to run current-bench for developer branches on a nightly
  basis to visualize the performance benchmark results per commit.

#### Completed

* [ocurrent/curren-bench#106](https://github.com/ocurrent/current-bench/issues/106)
  Use `--privileged` with Docker run_args for Multicore OCaml

  The current-bench master (`3b3b31b...`) is able to run Multicore
  OCaml Sandmark benchmarks in Docker without requiring the
  `--privileged` option.

* [ocurrent/current-bench#146](https://github.com/ocurrent/current-bench/issues/146)
  Replicate `ocaml-bench-server` setup

  `current-bench` now supports the use of a custom `bench.Dockerfile`
  which allows you to override the TAG and OCaml variants to be used
  with Sandmark.

* [ocurrent/current-bench#190](https://github.com/ocurrent/current-bench/pull/190)
  Allow selected projects to run on more than one CPU

  A `OCAML_BENCH_MULTICORE_REPOSITORIES` environment variable has been
  added to build projects on more than one CPU core.

* [ocurrent/current-bench#195](https://github.com/ocurrent/current-bench/pull/195)
  Add instructions to start just frontend and DB containers

  The HACKING.md file has been updated with instructions to just start
  the frontend and database containers. This allows you to run
  benchmarks on any machine, and use an ETL script to dump the results
  to the database, and view them in the current-bench frontend.

We would like to thank all the OCaml users, developers and
contributors in the community for their continued support to the
project. Stay safe!

## Acronyms

* AFL: American Fuzzy Lop
* API: Application Programming Interface
* AST: Abstract Syntax Tree
* AWS: Amazon Web Services
* CI: Continuous Integration
* CPU: Central Processing Unit
* DB: Database
* DLS: Domain Local Storage
* ETL: Extract Transform Load
* GC: Garbage Collector
* IO: Input/Output
* MD: Markdown
* MLP: ML-File Preprocessed
* OOM: Out of Memory
* opam: OCaml Package Manager
* OS: Operating System
* PR: Pull Request
* PRNG Pseudo-Random Number Generator
* RFC: Request For Comments
* WG: Working Group
