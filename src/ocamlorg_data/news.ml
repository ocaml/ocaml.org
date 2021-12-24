
type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; body_html : string
  }
  
let all = 
[
  { title = {js|OCaml Weekly News - December 21, 2021|js}
  ; slug = {js|cwn-2021-12-21|js}
  ; description = {js|Summary of the messages sent to the OCaml forums and mailing list compiled by Alan Schmitt.|js}
  ; date = {js|2021-12-21|js}
  ; tags = 
 [{js|cwn|js}]
  ; body_html = {js|<div id="content">
<h1 class="title">OCaml Weekly News</h1>
<p>Hello</p>
<p>Here is the latest OCaml Weekly News, for the week of December 14 to 21, 2021.</p>
<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li>
<a href="#1">Are you teaching using the Learn-OCaml platform?</a>
</li>
<li>
<a href="#2">A SOCKS implementation for OCaml</a>
</li>
<li>
<a href="#org05b3f87">Old CWN</a>
</li>
</ul>
</div>
</div>
<div id="outline-container-1" class="outline-2">
<h2 id="1">Are you teaching using the Learn-OCaml platform?</h2>
<div class="outline-text-2" id="text-1">
<p>Archive: <a href="https://sympa.inria.fr/sympa/arc/caml-list/2021-12/msg00007.html">https://sympa.inria.fr/sympa/arc/caml-list/2021-12/msg00007.html</a></p>
</div>
<div id="outline-container-org3bd0e50" class="outline-3">
<h3 id="org3bd0e50">Erik Martin-Dorel announced</h3>
<div class="outline-text-3" id="text-org3bd0e50">
<p>
The OCaml Software Foundation is developing the teaching platform Learn-OCaml that provides auto-graded exercises for OCaml, and was initially authored by OCamlPro for the OCaml MOOC:
<a href="https://ocaml-sf.org/learn-ocaml/">https://ocaml-sf.org/learn-ocaml/</a>
</p>
<p>
The platform is free software and easy to deploy; this is great, but as a result we keep learning of users/deployments that we had no idea of. We would be interested in having a better view of our user-base. If you use Learn-OCaml as a teacher, could you answer this email (To:
e.mdorel@gmail.com) and let us know?
</p>
<p>Ideally we would like to know:</p>
<ul class="org-ul">
<li>Where are you using Learn-OCaml? → in which university (in a specific course?), or in which company, online community or … ?</li>
<li>How many students/learners use your deployment in a year?</li>
</ul>
<p>Also FYI:</p>
<ul class="org-ul">
<li>For an example of Learn-OCaml instance, see <a href="https://discuss.ocaml.org/t/interesting-ocaml-exercises-from-francois-pottier-available-online/7050">https://discuss.ocaml.org/t/interesting-ocaml-exercises-from-francois-pottier-available-online/7050</a></li>
<li>Last October we had a 0.13.0 release, full of new features: <a href="https://discuss.ocaml.org/t/ann-release-of-ocaml-sf-learn-ocaml-0-13-0/8577">https://discuss.ocaml.org/t/ann-release-of-ocaml-sf-learn-ocaml-0-13-0/8577</a></li>
<li>For any question related to Learn-OCaml, feel free to create a discussion topic on <a href="https://discuss.ocaml.org/">https://discuss.ocaml.org/</a> , category Community, tag <i>learn-ocaml</i>.</li>
<li>And if need be, opening an issue in <a href="https://github.com/ocaml-sf/learn-ocaml/issues">https://github.com/ocaml-sf/learn-ocaml/issues</a> if of course warmly welcome as well.</li>
</ul>
</div>
</div>
</div>
<div id="outline-container-2" class="outline-2">
<h2 id="2">A SOCKS implementation for OCaml</h2>
<div class="outline-text-2" id="text-2">
<p>Archive: <a href="https://discuss.ocaml.org/t/a-socks-implementation-for-ocaml/9041/1">https://discuss.ocaml.org/t/a-socks-implementation-for-ocaml/9041/1</a></p>
</div>
<div id="outline-container-orge1e605b" class="outline-3">
<h3 id="orge1e605b">Renato Alencar announced</h3>
<div class="outline-text-3" id="text-orge1e605b">
<p>I have been working on a SOCKS implementation for OCaml and specially for MirageOS. It's not really complete or stable yet (not even published), it only has a couple of proof of concepts on the examples directory and it doesn't integrate with the well known libraries of the ecosystem.</p>
<p>
I would like to ask for feedback, and some thoughts about how could we have that in Conduit and Cohttp for example, so It'd be just plugged in into those libraries without having to directly depending on it. I plan to implement that for those libraries and have it submitted upstream, but
not without some clear thoughts about how to make a clear interface for that.
</p>
<p>Besides being sloppy, I have a few issues described on GitHub, and it should be addressed on the next few days. Anyone is welcome to discuss those issues as some of them are still foggy for me, and having some other views on that would be great.</p>
<p>
<a href="https://github.com/renatoalencar/ocaml-socks-client">https://github.com/renatoalencar/ocaml-socks-client</a>
</p>
</div>
</div>
</div>
<div id="outline-container-org05b3f87" class="outline-2">
<h2 id="org05b3f87">Old CWN</h2>
<div class="outline-text-2" id="text-org05b3f87">
<p>
If you happen to miss a CWN, you can <a href="mailto:alan.schmitt@polytechnique.org">send me a message</a> and I'll mail it to you, or go take a look at <a href="https://alan.petitepomme.net/cwn/">the archive</a> or the
<a href="https://alan.petitepomme.net/cwn/cwn.rss">RSS feed of the archives</a>.
</p>
<p>If you also wish to receive it every week by mail, you may subscribe <a href="http://lists.idyll.org/listinfo/caml-news-weekly/">online</a>.</p>
<div class="authorname" id="org34b0aea">
<p>
<a href="https://alan.petitepomme.net/">Alan Schmitt</a>
</p>
</div>
</div>
</div>
</div>
|js}
  };
 
  { title = {js|opam 2.1.2 release|js}
  ; slug = {js|opam-2-1-2|js}
  ; description = {js|Release of opam 2.1.2|js}
  ; date = {js|2021-12-08|js}
  ; tags = 
 [{js|opam|js}; {js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.1.2">opam 2.1.2</a>.</p>
<p>This opam release consists of <a href="https://github.com/ocaml/opam/issues/4920">backported</a> fixes, including:</p>
<ul>
<li>Fallback on <code>dnf</code> if <code>yum</code> does not exist on RHEL-based systems (<a href="https://github.com/ocaml/opam/pull/4825">#4825</a>)
</li>
<li>Use <code>--no-depexts</code> in CLI 2.0 mode. This further improves the use of opam 2.1 as a drop-in replacement for opam 2.0 in CI, for example with setup-ocaml in GitHub Actions. (<a href="https://github.com/ocaml/opam/pull/4908">#4908</a>)
</li>
</ul>
<hr />
<p>Opam installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.2&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.2">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.2#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
|js}
  };
 
  { title = {js|OCaml Multicore - November 2021|js}
  ; slug = {js|multicore-2021-11|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-11-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the November 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by me, @ctk21, @kayceesrk and @shakthimaan.</p>
<h1>Core Team Code Review</h1>
<p>In late November, the entire OCaml development team convened for a week-long code review and decision taking session on the multicore merge for OCaml 5.0.  Due to the size of the patchset, we broke up the designs and presentations in five working groups.  Here's a summary of how each conversation went. As always, these decisions are subject to change from the core team as we discover issues, so please do not take any crucial decisions for your downstream projects on these. Our goal for publicising these is to hear about any corrections you might feel that we need to take on the basis of additional data that you might have from your own codebases.</p>
<p>For the purposes of brevity, we do not include the full minutes of the developer meetings. Overall, the multicore patches were deemed to be broadly sound and suitable, and we recorded the important decisions and tasks:</p>
<ul>
<li><strong>Pre-MVP:</strong> Tasks that need to be done before we make the PR to ocaml/ocaml in the coming month.
</li>
<li><strong>Post-MVP for 5.00:</strong> Tasks that need to be done on ocaml/ocaml before 5.00 release. <em>These tasks will block the OCaml 5.00 release.</em>
</li>
<li><strong>Post-5.00:</strong> Future looking tasks after 5.00 is released in early/mid-2022.
</li>
</ul>
<h2>WG1: Garbage Collector</h2>
<p>The multicore runtime alters the memory allocation and garbage collector to support multiple parallel threads of OCaml execution. It utilizes a stop-the-world parallel minor collector, a StreamFlow like multithreaded allocator and a mostly-concurrent major collector.</p>
<p>WG1 decided that compaction will not be in the 5.0 initial release, as our best fit allocator has shown that a good memalloc strategy obviates the need for expensive compaction. Of course, the multicore memory allocator is different from bestfit, so we are in need of community input to ensure our hypothesis involving not requiring compaction is sound. If you do see such a use case of your application heap becoming very fragmented when 5.0 is in beta, please get in touch.</p>
<h3>Pre-MVP</h3>
<ul>
<li>remove any traces of no-naked-pointers checker as it is irrelevant in the pagetable-less multicore runtime.
</li>
<li>running <code>make parallel</code> for the testsuite should work
</li>
<li>move from <code>assert</code> to <code>CAMLassert</code>
</li>
<li>How to do safepoints from C: add documentation on <code>caml_process_pending_actions</code> and a testsuite case for long-running C bindings to multicore
</li>
<li>adopt the ephemeron bucket interface and do the same thing as 4.x OCaml trunk
</li>
<li>check and document that <code>NOT_MARKABLE</code> can be used for libraries like ancient that want out of heap objects
</li>
<li>check that we document what type of GC stats we return (global vs domain local) for the various stats
</li>
</ul>
<h3>Post-MVP for 5.00</h3>
<ul>
<li>mark stack overflow fix, which shouldn't affect most runtime allocation profiles
</li>
</ul>
<h3>Post-5.00</h3>
<ul>
<li>statmemprof implementation
</li>
<li>mark pre-fetching
</li>
<li>investigate alternative minor heap implementations which maintain performance but cut virtual memory usage
</li>
</ul>
<h2>WG2: Domains</h2>
<p>Each domain in multicore can execute a thread of OCaml in parallel with other domains. Several additions are made to OCaml to spawn new domains, join domains that are terminating and provide domain local storage. There is a stdlib module <code>Domain</code> and the underlying runtime domain structures.  A significant simplification in recent months is that the standard Mutex/Channel/Semaphore modules can be used instead of lower-level synchronisation primitives that were formerly available in <code>Domain</code>.</p>
<p>The challenge for the runtime structures is to accurately maintain the set of domains that must take part in stop-the-world sections in the presence of domain termination and spawning, as well as ensuring that a domain services stop-the-world requests when the main mutator is in a blocking call; this is handled using a <em>backup thread</em> signaled from <code>caml_enter_blocking_section</code> / <code>caml_leave_blocking_section</code>.</p>
<p>The multicore OCaml memory model was discussed, and the right scheme selected for arm64 (Table 5b from <a href="https://anil.recoil.org/papers/2018-pldi-memorymodel.pdf">the paper</a>). The local data race freedom (LDRF) property was agreed to be a balanced and predictable approach for a memory model for OCaml 5.0. We do likely need to depend on &gt;C11 compiler for relaxed atomics in OCaml 5.0, so this will mean dropping Windows MSVC support for the MVP (but mingw will work).</p>
<h3>Pre-MVP</h3>
<ul>
<li>Make domain id abstract and provide <code>string_of_id</code>
</li>
<li>Document that initializing writes are ok using the Field macro with respect to the memory model. Also highlight that all writes need to use <code>caml_modify</code> (even immediates)
</li>
<li>check that the selectgen 'coeffect' is correct for DLS.get
</li>
<li>More comments needed for domain.c to help the reader:
<ul>
<li>around backup thread state machine and where things happen
</li>
<li>domain spawn/join
</li>
</ul>
</li>
<li>comment/check why <code>install_backup_thread</code> is called in spawnee and spawner
</li>
<li>check the reason why domain terminate is using a mutex for join (rather than a mutex, condvar pair)
</li>
</ul>
<h3>Post-5.00</h3>
<ul>
<li>Provide a mechanism for the user to retrieve the number of processors available for use. This can be implemented by libraries as well.
</li>
<li>add atomic mutable record fields
</li>
<li>add arrays of atomic variables
</li>
</ul>
<h2>WG3: Runtime multi-domain safety</h2>
<p>Multicore OCaml supports systhreads in a backwards compatible fashion. The execution model remains the same, except transposed to domains rather than a single execution context.</p>
<p>Each domain will get its own threads chaining: this means that while only one systhread can execute at a time on a single domain (akin to trunk), many domains can still execute in parallel, with their systhreads chaining being independent. To achieve this, a thread table is employed to allow each domains to maintain their own independent chaining. Context switching now involves extra care to handle the backup thread. The backup thread takes care of GC duties when a thread is currently in a blocking section. Systhreads needs to be careful about when to signal it.</p>
<p>The tick thread, used to periodically force thread preemption, has been updated to not rely on signals (as the multicore signaling model does not allow this to be done efficiently). Instead, we rely on the interrupt infrastructure of the multicore runtime and trigger an “external” interrupt, that will call back into systhreads to force a yield.</p>
<p>The existing Dynlink API was designed decades ago for a web browser written in OCaml (called &quot;<a href="https://caml.inria.fr/pub/old_caml_site/~rouaix/mmm/">mmm</a>&quot;) and is stateful. We'll make it possible to call concurrently in the OCaml 5.0 MVP, but the WG3 decided to start redesigning the Dynlink API to be less stateful.</p>
<p>Code fragments are now stored in a lockfree skiplist to allow multiple threads to work on the codefrags structures concurrently in a thread-safe manner. Extra care is required on cleanup (i.e, freeing unused code fragments entries): this should only happen on one domain, and this is done at the end of a major cycle. For the interested, <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/672">ocaml-multicore#672</a> is a recommended read to see the concurrent skiplist structure now used.</p>
<p>Signals in multicore have the following behaviour, with the WG3 deciding to change their behaviour to allow coalescing multiple signals from the perspective of the mutator:</p>
<ul>
<li>A program with a single domain should have mostly the same signal behaviour as trunk. This includes the delivery of signals to systhreads on that domain.
</li>
<li>Programs with multiple domains treat signals in a global fashion. It is not possible to direct signals to individual domains or threads, other than the control through thread sigmask. A domain recording a signal may not be the one executing the OCaml signal handler.
</li>
</ul>
<p>Frame descriptors modifications are now locked behind a mutex to avoid races if different threads were to try to apply changes to the frame table at the same time. Freeing up old frame tables is done at the end of a major cycle (which is a STW section) in order to be sure that no thread will be using this old frame table anymore.</p>
<p>Multicore OCaml contains a version of eventlog that is safe for multiple domains. It achieves this by having a separate CTF file per domain but this is an interim solution. We hope to replace this implementation with an existing prototype based on per-domain ring buffers which can be consumed programmatically from both OCaml and C. This will be a generalisation of eventlog, and so we should be able to remove the existing interface if it's not widely adopted yet.</p>
<h3>Pre-MVP</h3>
<ul>
<li>Rewrite intern.c so that it doesn't do GC. This code is performance sensitive as the compiler reads the cmi files by unmarshaling them.
<ul>
<li>Benchmark on <code>big.ml</code> (from @stedolan) and binary tree benchmark (from @xavierleroy).
</li>
</ul>
</li>
<li>Ensure the <code>m-&gt;waiters</code> atomics in systhreads are correct and safe.
</li>
<li>Write down options for <code>Thread.exit</code> to be discussed during or after merge, and what to do if just one domain exits while others continue to run. Should not be a blocking issue. Changing semantics is ok from vanilla trunk.
</li>
<li><code>m-&gt;busy</code> is not atomic anymore as of <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/740">ocaml-multicore/ocaml-multicore#740</a>, should be reviewed and merged.
</li>
<li>Restrict <code>Dynlink</code> to domain 0 as it is a mutable interface and difficult to use concurrently.
</li>
<li>Signals stack should move from counting to coalescing semantics.
</li>
<li>Try to delay signal processing at domain spawn so that <code>Caml_state</code> is valid.
</li>
<li>Remove <code>total_signals_pending</code> if possible.
</li>
</ul>
<h3>Post-MVP for 5.00</h3>
<ul>
<li>Probe opam for eventlog usage (introduced in OCaml 4.13) to determine if removing it will break any applications.
</li>
<li>Eventring merge is OK, eventlog API can be changed if functionality remains equivalent.
</li>
<li>(could be post 5.00 as well) TLS for systhreads.
</li>
</ul>
<h3>Post-5.00</h3>
<ul>
<li>Get more data on Dynlink usage and design a new API that is less stateful.
</li>
<li>@xavierleroy suggested redesigning marshalling in light of the new allocator.
</li>
</ul>
<h2>WG4: Stdlib changes</h2>
<p>The main guiding principle in porting the Stdlib to OCaml 5.00 is that</p>
<ol>
<li>OCaml 5.00 does not provide thread-safety by default for mutable data structures and interfaces.
</li>
<li>OCaml 5.00 does ensure memory-safety (no crashes) even when stdlib is used in parallel by multiple domains.
</li>
<li>Observationally pure interfaces remain so in OCaml 5.00.
</li>
</ol>
<p>For OCaml libraries with specific mutable interfaces (e.g. Queue, Hashtbl, Stack, etc.) they will not be made domain-safe to avoid impacting sequential performance. Programs using parallelism will need to add their own lock safety around concurrent access to such modules. Modules with top-level mutable state (e.g. Filename, Random, Format, etc..) will be made domain-safe. Some, such as Random, are being extensively redesigned to use new approaches such as splittable prngs. The motivation for these choices and further discussion is found in the <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml">Multicore OCaml wiki page</a>.</p>
<p>The WG4 also noted that we would accept alternative versions of mutable stdlib modules that are concurrent-safe (e.g. have a <code>Concurrent.Hashtbl</code>), and also hopes to see more lockfree libraries developed independently by the OCaml community. Overall, WG4 recognised the importance of community involvement with the process of porting OCaml libraries to parallel safety. We aim to add ocamldoc tags to the language to mark modules/functions safety, and hope to get this in the new unified package db at <a href="https://v3.ocaml.org/packages">v3.ocaml.org</a> ahead of OCaml 5.0.</p>
<h4>Lazy</h4>
<p>Lazy values in OCaml allow deferred computations to be run by <em>forcing</em> them. Once the lazy computation runs to completion, the lazy is updated such that further forcing fetches the result from the previous forcing. The minor GC also short-circuits forced lazy values avoiding a hop through the lazy object. The implementation of lazy uses <a href="https://github.com/ocaml/ocaml/blob/trunk/stdlib/camlinternalLazy.ml">unsafe operations from the Obj module</a>.</p>
<p>The implementation of Lazy has been made thread-safe in OCaml 5.00. For single-threaded use, the Lazy module preserves backwards compatibility. For multi-threaded use, the Lazy module adds synchronization such that on concurrent forcing of an unforced lazy value from multiple domains, one of the domains will get to run the deferred computation while the other will get a new exception <code>RacyLazy</code> .</p>
<h4>Random</h4>
<p>With <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/582">ocaml-multicore#582</a>, we have domain-local PRNGs following closely along the lines of stock OCaml. In particular, the behaviour remains the same for sequential OCaml programs. But the situation for parallel programs is not ideal. Without explicit initialisation, all the domains will draw the same initial sequence.</p>
<p>There is ongoing discussion on splittable PRNGs in <a href="https://github.com/ocaml/RFCs/pull/28">ocaml/RFCs#28</a>, and a re-implementation of Random using the Xoshiro256++ PRNG in <a href="https://github.com/ocaml/ocaml/pull/10701">ocaml/ocaml#10701</a>.</p>
<h4>Format</h4>
<p>The Format module has some hidden global state for implementing pretty-printing boxes. While the module has explicit API for passing the formatter state to the functions, there are predefined formatters for <code>stdout</code> , <code>stderr</code> and standard buffer, whose state is maintained by the module.</p>
<p>The Format module has been made thread-safe for predefined formatters. We use domain-local versions of formatter state for each domain, lazily switching to this version when the first-domain is spawned. This preserves the performance of single-threaded code, while being thread-safe for multi-threaded use case. See the discussion in <a href="https://github.com/ocaml/ocaml/issues/10453#issuecomment-868940501">ocaml/ocaml#10453</a> for a summary.</p>
<h4>Mutex, Condition, Semaphore</h4>
<p>The Mutex, Condition and Semaphore modules are the same as systhreads in stock OCaml. They now reside in <code>stdlib</code> . When systhreads are linked, the same modules are used for synchronization between systhreads.</p>
<h3>Pre-MVP</h3>
<ul>
<li>Mark lazy as not thread safe.
<ul>
<li>Unify RacyLazy and Undefined
</li>
<li>Remove domain-local unique token
</li>
<li>Remove try_force
</li>
</ul>
</li>
<li>Add the Bucket module for ephemerons with a default sequential implementation as seen in OCaml 4.13.
</li>
</ul>
<h3>Post-MVP for 5.00</h3>
<ul>
<li>Introduce ocamldoc tags for different concurrency safety
<ul>
<li>domain-safe
</li>
<li>systhread-safe
</li>
<li>fiber-safe
</li>
<li>not-concurrency-safe (= !domain-safe || !systhread-safe || !fiber-safe) -- also used as a placeholder for libraries and functions not analysed for concurrency.
</li>
</ul>
</li>
<li>Add documentation for memory model in the manual. Specifically, no values out of thin air – no need to precisely document the memory model aside from pointing to paper.
</li>
<li>For <code>Arg</code> module, deprecate current but not whole module
</li>
<li>remove ThreadUnix as a simple module that would no longer need Unix.
</li>
<li>Dynlink should have a mutex inside it to ensure it doesnt crash especially in bytecode.
</li>
</ul>
<h3>Post-5.00</h3>
<ul>
<li>Atomic arrays
</li>
<li>Ephemerons reimplemented in terms of Bucket module.
</li>
<li>Make disjoint the update of the lazy tag and marking by using byte-sized write and CAS.
</li>
</ul>
<h2>WG5: Fibers</h2>
<p>Fibers are the runtime system mechanism that supports effect handlers. The design of effect handlers in OCaml has been written up in the <a href="https://arxiv.org/abs/2104.00250">PLDI 2021 paper</a>.The motivation for adding effect handlers and some more examples are found in <a href="https://speakerdeck.com/kayceesrk/effect-handlers-in-multicore-ocaml">these slides</a>.</p>
<h4>Programming with effect handlers</h4>
<p>Effect handlers are made available to the OCaml programmer from <code>stdlib/effectHandlers.ml</code> (although this will likely be renamed <code>Effect</code> soon). The EffectHandlers module exposes two variants of effect handlers – deep and shallow. Deep handlers are like folds over the computation tree whereas shallow handlers are akin to <a href="https://www.dhil.net/research/papers/generalised_continuations-jfp-draft.pdf">case splits</a>. With deep handlers, the handler wraps around the continuation, whereas in shallow handlers it doesn’t.</p>
<p>Here is an example of a program that uses deep handlers to model something analogous to the <code>Reader</code> monad.</p>
<pre><code>open EffectHandlers
open EffectHandlers.Deep

type _ eff += Ask : int eff

let main () =
  try_with (fun _ -&gt; perform Ask + perform Ask) ()
  { effc = fun (type a) (e : a eff) -&gt;
      match e with
      | Ask -&gt; Some (fun (k : (a,_) continuation) -&gt; continue k 1)
      | _ -&gt; None }

let _ = assert (main () = 2)
</code></pre>
<p>Observe that when we resume the continuation <code>k</code> , the subsequent effects performed by the computation are also handled by the same handler. As opposed to this, for the shallow handler doesn’t. For shallow handlers, we use <code>continue_with</code> instead of continue.</p>
<pre><code>open EffectHandlers
open EffectHandlers.Shallow

type _ eff += Ask : int eff

let main () =
  let rec loop (k: (int,_) continuation) (state : int) =
    continue_with k state
    { retc = (fun v -&gt; v);
      exnc = (fun e -&gt; raise e);
      effc = fun (type a) (e : a eff) -&gt;
        match e with
        | Ask -&gt; Some (fun (k : (a, _) continuation) -&gt; loop k 1)
        | _ -&gt; None }
  in
  let k = fiber (fun _ -&gt; perform Ask + perform Ask) in
  loop k 1

let _ = assert (main () = 2)
</code></pre>
<p>Observe that with a shallow handler, the recursion is explicit. Shallow handlers makes it easier to encode cases where state needs to be threaded through. For example, here is a variant of the <code>State</code> handler that encodes a counter:</p>
<pre><code>open EffectHandlers
open EffectHandlers.Shallow

type _ eff += Next : int eff

let main () =
  let rec loop (k: (int,_) continuation) (state : int) =
    continue_with k state
    { retc = (fun v -&gt; v);
      exnc = (fun e -&gt; raise e);
      effc = fun (type a) (e : a eff) -&gt;
        match e with
        | Next -&gt; Some (fun (k : (a, _) continuation) -&gt; loop k (state + 1))
        | _ -&gt; None }
  in
  let k = fiber (fun _ -&gt; perform Next + perform Next) in
  loop k 0

let _ = assert (main () = 3)
</code></pre>
<p>While this encoding is possible with deep handlers (by the usual <code>State</code> monad trick of building up a computation using a closure), it feels more natural with shallow handlers. In general, one can easily encode deep handlers using shallow handlers, but going the other way is challenging. With the typed effects work currently in development, the default would be shallow handlers and deep handlers would be encoded using the shallow handlers.</p>
<p>As a bit of history, the current implementation is tuned for deep handlers and has gathered optimizations over several iterations. If shallow handlers becomes more widely in the coming years, it may be possible to put in some tweaks that removes a few allocations. That said, the semantics of the deep and shallow handlers in this future implementation will remain the same as what is currently in OCaml 5.00 branch.</p>
<h3>Post-MVP for 5.00</h3>
<ul>
<li>Add ARM64 backend
</li>
<li>Documentation on the usage of effect handlers.
</li>
<li>Current stack size should be the sum of the stack sizes of the stack of fibers. Currently, it only captures the top fiber size.
<ul>
<li>This is not straight-forward as it seems. Resuming continuations attaches a stack. Should we do stack overflow checks there? I'd not, as this would make resuming continuations slower. One idea might be to only do the stack overflow check at stack realloc, which catches the common case.
</li>
</ul>
</li>
</ul>
<h3>Post-5.00</h3>
<ul>
<li>Add support for compiling with frame pointers.
</li>
</ul>
<h1>The November activities</h1>
<p>That wraps up the mammoth code review summary, and significant decisions taken.  Overall, we are full steam ahead for generating an OCaml 5.0 PR, although we do have our work cut out for us in the coming months! Now we continue with our regular report on what else happened in November.The ecosystem is continuing to evolve, and there are significant updates to Eio, the Effects-based parallel IO for OCaml.</p>
<p><a href="https://discuss.ocaml.org/t/ann-lwt-5-5-0-lwt-domain-0-1-0-lwt-react-1-1-5/8897">Lwt.5.5.0</a> has been released that supports dispatching pure computations to multicore domains. The Sandmark benchmarking has now been updated to build for 5.00, and the current-bench tooling is being improved to better track the performance analysis and upstream merge changes.</p>
<p>As always, the Multicore OCaml updates are listed first, which contain the upstream efforts, documentation changes, and PR fixes. This is followed by the ecosystem updates to <code>Eio</code> and <code>Tezos</code>. The Sandmark, sandmark-nightly and current-bench tasks are finally listed for your kind reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/669">ocaml-multicore/ocaml-multicore#669</a>
Set thread names for domains</p>
<p>A patch that implements thread naming for Multicore OCaml. It
provides an interface to name Domains and Threads differently. The
changes have now been rebased with check-typo fixes.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/733">ocaml-multicore/ocaml-multicore#733</a>
Improve the virtual memory consumption on Linux</p>
<p>An ongoing design discussion on orchestrating the minor heap
allocations of domains for virtual memory performance, domain spawn
and termination, performance and safety of <code>Is_young</code> runtime usage,
and change of minor heap size using <code>Gc</code> set.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/735">ocaml-multicore/ocaml-multicore#735</a>
Add <code>caml_young_alloc_start</code> and <code>caml_young_alloc_end</code> in <code>minor_gc.c</code></p>
<p><code>caml_young_alloc_start</code> and <code>caml_young_alloc_end</code> are not present
in Multicore OCaml, and they should be the same as <code>young_start</code> and
<code>young_end</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/736">ocaml-multicore/ocaml-multicore#736</a>
Decompress testsuite fails 5.0 because of missing pthread link flag</p>
<p>An undefined reference to <code>pthread_sigmask</code> has been observed when
<code>-lpthread</code> is not linked when testing the decompress testsuite.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/737">ocaml-multicore/ocaml-multicore#737</a>
Port the new ephemeron API to 5.00</p>
<p>An API for immutable ephemerons has been
<a href="https://github.com/ocaml/ocaml/pull/10737">merged</a> in trunk, and
the respective changes need to be ported to 5.00.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/740">ocaml-multicore/ocaml-multicore#740</a>
Systhread lifecycle</p>
<p>The PR addresses the systhreads lifecycle in Multicore and provides
fixes in <code>caml_thread_domain_stop_hook</code>, <code>Thread.exit</code> and
<code>caml_c_thread_unregister</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/742">ocaml-multicore/ocaml-multicore#742</a>
Minor tasks from asynchronous review</p>
<p>A list of minor tasks from the asynchronous review for OCaml 5.00
release. The major tasks will have their own GitHub issues.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/745">ocaml-multicore/ocaml-multicore#745</a>
Systhreads WG3 comments</p>
<p>The commit names should be self-descriptive, use of non-atomic
variables is preferred, and we should raise OOM when there is a
failure to allocate thread descriptors.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/748">ocaml-multicore/ocaml-multicore#748</a>
WG3 move <code>gen_sizeclasses</code></p>
<p>The PR moves <code>runtime/gen_sizeclasses.ml</code> to
<code>tools/gen_sizeclasses.ml</code> and fixes check-typo issues.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/750">ocaml-multicore/ocaml-multicore#750</a>
Discussing the design of Lazy under Multicore</p>
<p>A ongoing discussion on the design of Lazy for Multicore OCaml that
addresses sequential Lazy, concurrency problems, duplicated
computations, and memory safety.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/753">ocaml-multicore/ocaml-multicore#753</a>
C API to pin domain to C thread?</p>
<p>A question on how to design an API that would allow creating a
domain &quot;pinned&quot; to an existing C thread, from C.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/754">ocaml-multicore/ocaml-multicore#754</a>
Improvements to <code>emit.mlp</code> organization</p>
<p>The <code>preproc_fun</code> function should be moved to a target-independent
module, and all the prologue code needs to be emitted in one place.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/756">ocaml-multicore/ocaml-multicore#756</a>
RFC: Generalize the <code>Domain.DLS</code> interface to split PRNG state for child domains</p>
<p>The PR demonstrates an implementation for a &quot;proper&quot; PRNG+Domains
semantics where spawning a domain &quot;splits&quot; the PRNG state.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/757">ocaml-multicore/ocaml-multicore#757</a>
Audit <code>stdlib</code> for mutable state</p>
<p>An issue tracker for the status of auditing <code>stdlib</code> for mutable
state. OCaml 5.00 stdlib will have to guarantee both memory and
thread safety.</p>
</li>
</ul>
<h4>Documentation</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/741">ocaml-multicore/ocaml-multicore#741</a>
Ensure copyright headers are formatted properly</p>
<p>The copyright headers in the source files must be neatly formatted
using the new format. If the old format already exists, then the
author, institution details must be added as shown below:</p>
<pre><code>/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*          Xavier Leroy and Damien Doligez, INRIA Rocquencourt           */
/*          &lt;author's name&gt;, &lt;author's institution&gt;                       */
/*                                                                        */
/*   Copyright 1996 Institut National de Recherche en Informatique et     */
/*     en Automatique.                                                    */
/*   Copyright &lt;first year written&gt;, &lt;author OR author's institution&gt;     */
/*   Included in OCaml under the terms of a Contributor License Agreement */
/*   granted to Institut National de Recherche en Informatique et en      */
/*   Automatique.                                                         */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/743">ocaml-multicore/ocaml-multicore#743</a>
Unhandled exceptions should render better error message</p>
<p>A request to output informative <code>Unhandled_effect &lt;EFFECT_NAME&gt;</code>
error message instead of <code>Unhandled</code> in the compiler output.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/752">ocaml-multicore/ocaml-multicore#752</a>
Document the current Multicore testsuite situation</p>
<p>A documentation update on how to run the Multicore OCaml
testsuite. The steps are as follows:</p>
<pre><code>$ make world.opt
$ cd testsuite
$ make all-enabled
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/759">ocaml-multicore/ocaml-multicore#759</a>
Rename type variables for clarity</p>
<p>The type variables in <code>stdlib/fiber.ml</code> have been updated for
consistency and clarity.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/725">ocaml-multicore/ocaml-multicore#725</a>
Blocked signal infinite loop fix</p>
<p>A monotonic <code>recorded_signals_counter</code> has been introduced to fix
the possible loop in <code>caml_enter_blocking_section</code> when no domain
can handle a blocked signal. A <code>signals_block.ml</code> callback test has
also been added.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/730">ocaml-multicore/ocaml-multicore#730</a>
<code>ocamlopt</code> raise a stack-overflow compiling <code>aws-ec2.1.2</code> and <code>color-brewery.0.2</code></p>
<p>A &quot;Stack overflow&quot; exception raised while compiling <code>aws-ec2.1.2</code>
with 4.14.0+domains+dev0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/734">ocaml-multicore/ocaml-multicore#734</a>
Possible segfault when a new domain is signalled before it can initialize the domain_state</p>
<p>A potential segmentation fault caused when a domain created by
<code>Domain.spawn</code> receives a signal before it can reach its main
entrypoint and initialize thread local data.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/738">ocaml-multicore/ocaml-multicore#738</a>
Assertion violation when an external function and the GC run concurrently</p>
<p>An <code>Assertion Violation</code> error message is thrown when Z3 tries to
free GC cleaned up objects in the <code>get_unsat_core</code> function.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/749">ocaml-multicore/ocaml-multicore#749</a>
Potential bug on <code>Forward_tag</code> short-circuiting?</p>
<p>A bug when short-circuiting <code>Forward_tag</code> on values of type
<code>Obj.forcing_tag</code>. Short-circuiting is disabled on values of type
<code>Forward_tag</code>, <code>Lazy_tag</code> and <code>Double_tag</code> in the minor GC.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/637">ocaml-multicore/ocaml-multicore#637</a>
<code>caml_page_table_lookup</code> is not available in ocaml-multicore</p>
<p>Multicore does not have a page table, and <code>ancient</code> will not build
if it references <code>caml_page_table_lookup</code>. The <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/642">Remove the remanents
of page table
functionality</a>
PR fixes this issue.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/727">ocaml-multicore/ocaml-multicore#727</a>
Update version number</p>
<p>The <code>ocaml-variants.opam</code> file has been updated to use
<code>ocaml-variants.4.14.0+domains</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/728">ocaml-multicore/ocaml-multicore#728</a>
Update <code>base-domains</code> package for 5.00 branch</p>
<p>The <code>base-domains</code> package now includes <code>4.14.0+domains</code>. Otherwise,
the pinning on a local opam switch fails on dependency resolution.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/729">ocaml-multicore/ocaml-multicore#729</a>
Introduce <code>caml_process_pending_signals</code> which raises if exceptional</p>
<p>The code matches <code>caml_process_pending_actions</code> /
<code>caml_process_pending_actions_exn</code> from trunk and cleans up
<code>caml_raise_if_exception(caml_process_pending_signals_exn())</code> calls.</p>
</li>
</ul>
<h4>Documentation</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/744">ocaml-multicore/ocaml-multicore/744</a>
Make cosmetic change to comments in <code>lf_skiplist</code></p>
<p>The comments in <code>runtime/lf_skiplist.c</code> have been updated with
reference to the paper by Willam Pugh on &quot;Skip Lists&quot;.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/746">ocaml-multicore/ocaml-multicore#746</a>
Frame descriptors WG3 comments</p>
<p>The copyright headers have been added to
<code>runtime/frame_descriptors.c</code> and <code>runtime/frame_descriptors.h</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/747">ocaml-multicore/ocaml-multicore#747</a>
Fix check typo for sync files</p>
<p>The check-typo errors for <code>sync.c</code> and <code>sync.h</code> have been fixed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/755">ocaml-multicore/ocaml-multicore#755</a>
More fixes for check-typo</p>
<p>The check-typo fixes for <code>otherlibs/unix/fork.c</code>,
<code>runtime/finalise.c</code>, <code>runtime/gc_ctrl.c</code>, <code>runtime/Makefile</code> and
<code>runtime/caml/eventlog.h</code> have been merged.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/720">ocaml-multicore/ocaml-multicore#720</a>
Improve ephemerons compatibility with testsuite</p>
<p>The PR fixes <code>weaktest.ml</code> and also imports upstream changes to make
ephemerons work with infix objects.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/731">ocaml-multicore/ocaml-multicore#731</a>
AFL: Segfault and lock resetting (Fixes <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/497">#497</a>)</p>
<p>A fix to get AFL-instrumentation working again on Multicore
OCaml. The PR also changes <code>caml_init_domains</code> to use
<code>caml_fatal_error</code> consistently.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/issues/8">ocaml-multicore/tezos#8</a>
ci.Dockerfile throws warning</p>
<p>The <code>numerics</code> library which enforced <code>c99</code> has been removed from
Tezos, and hence this warning should not occur.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/55">ocaml-multicore/domainslib#55</a>
<code>setup_pool</code>: option to exclude the current/first domain?</p>
<p>The use case to not include the main thread as part of the pool is a
valid request. The use of <code>async_push</code> can help with the same:</p>
<pre><code>(* main thread *)
let pool = setup_pool ~num_additional_domains () in
let promise = async_push pool initial_task in
(* the workers are now executing the [initial_task] and
   its children. main thread is free to do its thing. *)
....
(* when it is time to terminate, for cleanup, you may optionally do *)
let res = await pool promise (* waits for the promise to resolve, if not already *)
teardown_pool pool
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/issues/91">ocaml-multicore/eio#91</a>
[Discussion] Object Capabilities / API</p>
<p>An open discussion on using an open object as the first argument of
every function, and to use full words and expressions instead
<code>network</code>, <code>file_systems</code> etc.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Eio</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/86">ocaml-multicore/eio#86</a>
Update README to mention <code>libuv</code> backend</p>
<p>The README.md file has been updated to mention that the library
provides a generic backend based on <code>libuv</code>, that works on most
platforms, and has an optimised backend for Linux using <code>io-uring</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/89">ocaml-multicore/eio#89</a>
Marking <code>uring</code> as vendored breaks installation</p>
<p>The use of <code>pin-depends</code> for <code>uring</code> to avoid any vendoring
installation issues with OPAM.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/90">ocaml-multicore/eio#90</a>
Implicit cancellation</p>
<p>A <code>lib_eio/cancel.ml</code> has been added to <code>Eio</code> that has been split
out of <code>Switch</code>. The awaiting promises use the cancellation context,
and many operations no longer require a switch argument.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/92">ocaml-multicore/eio#92</a>
Update trace diagram in README</p>
<p>The trace diagram in the README file has been updated to show two
counting threads as two horizontal lines, and white regions
indicating when each thread is running.</p>
<p><img src="upload://nG6djh8yYPqlPxlOzswCsvY5How.png" alt="eio-pr-92-trace|690x157" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/93">ocaml-multicore/eio#93</a>
Add <code>Fibre.first</code></p>
<p>The <code>Fibre.first</code> returns the result of the first fibre to finish,
cancelling the other one. A <code>tests/test_fibre.md</code> file has also been
added with this PR.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/94">ocaml-multicore/eio#94</a>
Add <code>Time.with_timeout</code></p>
<p>The module <code>Time</code> now includes both <code>with_timeout</code> and
<code>with_timeout_extn</code> functions to <code>lib_eio/eio.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/95">ocaml-multicore/eio#95</a>
Track whether cancellation came from parent context</p>
<p>A <code>Cancelled</code> exception is raised if the parent context is asked to
exit, so as to propagate the cancellation upwards. If the
cancellation is inside, the original exception is raised.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/96">ocaml-multicore/eio#96</a>
Add <code>Fibre.all</code>, <code>Fibre.pair</code>, <code>Fibre.any</code> and <code>Fibre.await_cancel</code></p>
<p>The <code>all</code>, <code>pair</code>, <code>any</code> and <code>await_cancel</code> functions have been
added to the <code>Fibre</code> module in <code>libe_eio/eio.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/97">ocaml-multicore/eio#97</a>
Fix MDX warning</p>
<p>The <code>tests/test_fibre.md</code> file has been updated to fix MDX warnings.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/98">ocaml-multicore/eio#98</a>
Keep an explicit tree of cancellation contexts</p>
<p>A tree of cancellation contexts can now be dumped to the output, and
this is useful for debugging.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/99">ocaml-multicore/eio#99</a>
Make enqueue thread-safe</p>
<p>Thread-safe promises, streams and semaphores have been added to
Eio. The <code>make bench</code> target can test the same:</p>
<pre><code>dune exec -- ./bench/bench_promise.exe
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
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/100">ocaml-multicore/eio#100</a>
Propogate backtraces in more places</p>
<p>The <code>libe_eio/fibre.ml</code> and <code>lib_eio_linux/eio_linux.ml</code> have been
updated to allow propagation of backtraces.</p>
</li>
</ul>
<h4>Tezos</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/10">ocaml-multicore/tezos#10</a>
Fix <code>make build-deps</code>, fix NixOS support</p>
<p>The patch fixes <code>make build-deps/build-dev-deps</code>, and <code>conf-perl</code>
has been removed from the <code>tezos-opam-repository</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/15">ocaml-multicore/tezos#15</a>
Fix <code>scripts/version.h</code></p>
<p>The CI build failure is now fixed with proper exporting of variables
in <code>scripts/version.h</code> file.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/16">ocaml-multicore/tezos#16</a>
Fix <code>make build-deps</code> and <code>make build-dev-deps</code> to install correct OCaml switch</p>
<p>The hardcoded OCaml switches have now been removed from the script
file and the switch information from <code>script/version.h</code> is used with
<code>make build-deps</code> and <code>make build-dev-deps</code> targets.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/17">ocaml-multicore/tezos#17</a>
Enable CI on pull request to <code>4.12.0+domains</code> branch</p>
<p>CI has been enabled for pull requests for the 4.12.0+domains branch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/20">ocaml-multicore/tezos#20</a>
Upstream updates</p>
<p>A merge of the latest upstream build, code and documentation changes
from Tezos repository.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos-opam-repository/pull/6">ocaml-multicore/tezos-opam-repository#6</a>
Updates</p>
<p>The dependency packages in the <code>tezos-opam-repository</code> have been
updated, and <code>mtime.1.3.0</code> has been added as a dependency.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/40">ocaml-multicore/ocaml-uring#40</a>
Remove test dependencies on <code>Bos</code> and <code>Rresult</code></p>
<p>The <code>Bos</code> and <code>Rresult</code> dependencies have been removed from the
project as we already depend on OCaml &gt;= 4.12 which provides the
required functions.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/42">ocaml-multicore/ocaml-uring#42</a>
Handle race in <code>test_cancel_late</code></p>
<p>A race condition from <code>test_cancel_late</code> in <code>tests/main.ml</code> has been
fixed with this merged PR.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/51">ocaml-multicore/domainslib#51</a>
Utilise effect handlers</p>
<p>The tasks are now created using effect handlers, and a new
<code>test_deadlock.ml</code> test has been added.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Sandmark and Sandmark-nightly</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/21">ocaml-bench/sandmark-nightly#21</a>
Add 5.00 variants</p>
<p>Multicore OCaml now tracks OCaml trunk, and 4.12.0+domains+effects
and 4.12+domains will only have bug fixes. The following variants
are now required to be included in sandmark-nightly:</p>
<ul>
<li>OCaml trunk, sequential, runtime (throughput)
</li>
<li>OCaml 5.00, sequential, runtime
</li>
<li>OCaml 5.00, parallel, runtime
</li>
<li>OCaml trunk, sequential, pausetimes (latency)
</li>
<li>OCaml 5.00, sequential, pausetimes
</li>
<li>OCaml 5.00, parallel, pausetimes
</li>
</ul>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/262">ocaml-bench/sandmark#262</a>
<code>ocaml-migrate-parsetree.2.2.0+stock</code> fails to compile with ocaml.5.00.0+trunk</p>
<p>The <code>ocaml-migrate-parsetree</code> dependency does not work with OCaml
5.00, and we need to wait for the 5.00 AST to be frozen in order to
build the package with Sandmark.</p>
</li>
<li>
<p>A <code>package_remove</code> feature is being added to the -main branch of
Sandmark that allows to dynamically remove any dependency packages
that are known to fail to build on recent development branches.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/pull/22">ocaml-bench/sandmark-nightly#22</a>
Fix dataframe intersection order issue</p>
<p>The <code>dataframe_intersection</code> function has been updated to properly
filter out benchmarks that are not present for the variants that are
being compared.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/248">ocaml-bench/sandmark#248</a>
Coq fails to build</p>
<p>A new Coq tarball,
<a href="https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24">coq-multicore-2021-09-24</a>,
is now used to build with Sandmark for the various OCaml variants.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/257">ocaml-bench/sandmark#257</a>
Added latest Coq 2019-09 to Sandmark</p>
<p>The Coq benchmarks in Sandmark now build fine for 4.14.0+domains and
OCaml 5.00.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/260">ocaml-bench/sandmark#260</a>
Add 5.00 branch for sequential run. Fix notebook.</p>
<p>Sandmark can now build the new 5.00 OCaml variant to build both
sequential and parallel benchmarks in the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/261">ocaml-bench/sandmark#261</a>
Update benchmark and domainslib to support OCaml 4.14.0+domains (OCaml 5.0)</p>
<p>We now can build Sandmark benchmarks for OCaml 5.00, and the PR
updates to use <code>domainslib.0.3.2</code>.</p>
</li>
</ul>
<h3>current-bench</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/219">ocurrent/current-bench#219</a>
Support overlay of graphs from different compiler variants</p>
<p>At present, we are able to view the front-end graphs per OCaml
version. We need to overlay graphs across compiler variants for
better comparison and visualization.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/220">ocurrent/current-bench#220</a>
Setup current-bench and Sandmark for nightly runs</p>
<p>On a tuned machine, we need to setup current-bench (backend and
frontend) for Sandmark and schedule nightly runs.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/221">ocurrent/current-bench#221</a>
Support developer repository, branch and commits for Sandmark runs</p>
<p>A request to run current-bench for developer branches on a nightly
basis to visualize the performance benchmark results per commit.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/106">ocurrent/curren-bench#106</a>
Use <code>--privileged</code> with Docker run_args for Multicore OCaml</p>
<p>The current-bench master (<code>3b3b31b...</code>) is able to run Multicore
OCaml Sandmark benchmarks in Docker without requiring the
<code>--privileged</code> option.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/146">ocurrent/current-bench#146</a>
Replicate <code>ocaml-bench-server</code> setup</p>
<p><code>current-bench</code> now supports the use of a custom <code>bench.Dockerfile</code>
which allows you to override the TAG and OCaml variants to be used
with Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/190">ocurrent/current-bench#190</a>
Allow selected projects to run on more than one CPU</p>
<p>A <code>OCAML_BENCH_MULTICORE_REPOSITORIES</code> environment variable has been
added to build projects on more than one CPU core.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/195">ocurrent/current-bench#195</a>
Add instructions to start just frontend and DB containers</p>
<p>The HACKING.md file has been updated with instructions to just start
the frontend and database containers. This allows you to run
benchmarks on any machine, and use an ETL script to dump the results
to the database, and view them in the current-bench frontend.</p>
</li>
</ul>
<p>We would like to thank all the OCaml users, developers and
contributors in the community for their continued support to the
project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>AFL: American Fuzzy Lop
</li>
<li>API: Application Programming Interface
</li>
<li>AST: Abstract Syntax Tree
</li>
<li>AWS: Amazon Web Services
</li>
<li>CI: Continuous Integration
</li>
<li>CPU: Central Processing Unit
</li>
<li>DB: Database
</li>
<li>DLS: Domain Local Storage
</li>
<li>ETL: Extract Transform Load
</li>
<li>GC: Garbage Collector
</li>
<li>IO: Input/Output
</li>
<li>MD: Markdown
</li>
<li>MLP: ML-File Preprocessed
</li>
<li>OOM: Out of Memory
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>OS: Operating System
</li>
<li>PR: Pull Request
</li>
<li>PRNG Pseudo-Random Number Generator
</li>
<li>RFC: Request For Comments
</li>
<li>WG: Working Group
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Compiler - October 2021|js}
  ; slug = {js|ocaml-2021-10|js}
  ; description = {js|Monthly update from the OCaml Compiler team.|js}
  ; date = {js|2021-10-01|js}
  ; tags = 
 [{js|ocaml|js}]
  ; body_html = {js|<p>I’m happy to publish the fourth issue of the “OCaml compiler development newsletter”. (This is by no means exhaustive: many people didn’t end up having the time to write something, and it’s fine.)</p>
<p>Feel free of course to comment or ask questions!</p>
<p>If you have been working on the OCaml compiler and want to say something, please feel free to post in this thread! If you would like me to get in touch next time I prepare a newsletter issue (some random point in the future), please let me know by email at (gabriel.scherer at gmail).</p>
<p>Previous issues:</p>
<ul>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-3-june-september-2021/8598">OCaml compiler development newsletter, issue 3: June-September 2021</a>
</li>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-2-may-2021/7965">OCaml compiler development newsletter, issue 2: May 2021</a>
</li>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-1-before-may-2021/7831">OCaml compiler development newsletter, issue 1: before May 2021</a>
</li>
</ul>
<hr />
<p>October 2021 was a special month for some of us, as it was the last month before the <a href="https://discuss.ocaml.org/t/the-road-to-ocaml-5-0/8584#the-sequential-glaciation-3">Sequential Glaciation</a> -- a multi-months freeze on all features not related to Multicore, to facilitate Multicore integration.</p>
<h2>Xavier Leroy (@xavierleroy)</h2>
<p>Knowing that winter is coming, I tied some loose ends in preparation for release 4.14, including more deprecation warnings <a href="https://github.com/ocaml/ocaml/pull//10675">#10675</a>, proper termination of signal handling <a href="https://github.com/ocaml/ocaml/pull/10726">#10726</a>, and increasing the native stack size limit when the operating system allows <a href="https://github.com/ocaml/ocaml/pull/10736">#10736</a>. The latter should mitigate the problem of “Stack Overflow” crashing non-tail-recursive code for large inputs that hit operating-system restrictions.</p>
<p>I also worked on reimplementing the <code>Random</code> standard library module using more modern pseudo-random number generation (PRNG) algorithms.  In <a href="https://github.com/ocaml/RFCs/pull/28">RFC#28</a>, Gabriel Scherer proposed to change the random-number generation algorithm of the standard library <code>Random</code> module to be &quot;splittable&quot;, to offer better behavior in a Multicore world. (&quot;Splitting&quot; a random-number generator state gives two separate states that supposedly produce independent streams of random numbers; few RNG algorithms support splitting, and its theory is not well-understood.)</p>
<p>My first proposal was based on the Xoshiro256++ PRNG, which is fast and statistically strong: #<a href="https://github.com/ocaml/ocaml/pull/10701">10701</a>.  However, Xoshiro does not support full splitting, only a limited form called &quot;jumping&quot;, and the discussion showed that jumping was not enough.  Then a miracle happened: at exactly the same time (OOPSLA conference in october 2021), Steele and Vigna proposed LXM, a family of PRNGs that have all the nice properties of Xoshiro and support full splitting.  I promptly reimplemented the <code>Random</code> module using LXM #<a href="https://github.com/ocaml/ocaml/pull/10742">10742</a>, and I find the result very nice.  I hope this implementation will be selected to replace the existing <code>Random</code> module.</p>
<h2>Tail-recursion modulo constructors</h2>
<p>Gabriel Scherer (@gasche) finished working on the TMC (Tail modulo constructor) PR (#<a href="https://github.com/ocaml/ocaml/pull/9760">9760</a>) in time for the glaciation deadline, thanks to a well-placed full-day meeting with Pierre Chambart (@chambart), who had done the last review of the work. They managed to get something that we both liked, and the feature is now merged upstream.</p>
<p>Note that this is the continuation of the TRMC work started by Frédéric Bour (@let-def) in #<a href="https://github.com/ocaml/ocaml/pull/181">181</a> in May 2015 (also with major contributions from Basile Clément (@Elarnon)); this merge closed one of the longest-open development threads for the OCaml compiler.</p>
<p>One may now write:</p>
<pre><code class="language-ocaml">let[@tail_mod_cons] rec map f = function
| [] -&gt; []
| x::xs -&gt; f x :: (map[@tailcall]) f xs
</code></pre>
<p>and get an efficient tail-recursive definition of map.</p>
<p>A section of the manual is in progress to describe the feature: #<a href="https://github.com/ocaml/ocaml/pull/10740">10740</a>.</p>
<p>(On the other hand, there was no progress on the constructor-unboxing work, which will have to wait for 5.0.)</p>
<h2>Progress on native code emission and linking</h2>
<p>As part of <a href="https://github.com/ocaml/RFCs/pull/15">RFC#15: Fast native toplevel using JIT</a>, there was a batch of small changes on native-code emission and linking, and on the native toplevel proposed by @NathanRebours and David @dra27: #<a href="https://github.com/ocaml/ocaml/pull/10690">10690</a>, #<a href="https://github.com/ocaml/ocaml/pull/10714">10714</a>, #<a href="https://github.com/ocaml/ocaml/pull/10715">10715</a>.</p>
<h2>Module shapes for easier tooling</h2>
<p>Ulysse Gérard, Thomas Refis and Leo White proposed a new program analysis within the OCaml compiler, designed to help external tools understand the structure of implementation files (implementations of OCaml modules), in particular to implement the &quot;locate definition&quot; function -- which is non-trivial in presence of <code>include</code>, <code>open</code>, etc.</p>
<p>The result of their analysis is a &quot;shape&quot; describing the items (values, types, etc.) of a module in an easy-to-process yet richly-structured form.</p>
<p>Florian Angeletti (@Octachron) allowed to merge this PR thanks to his excellent review work, running against the Glaciation deadline.</p>
<p>(The authors of the PR initially wanted to add new kinds of compilation artifacts for OCaml compilation units to store shape information in <code>.cms</code> and <code>.cmsi</code> files, instead of the too-large <code>.cmt</code> files. People were grumpy about it, so this part was left out for now.)</p>
<h2>UTF decoding and validation support in the Stdlib</h2>
<p>In <a href="https://github.com/ocaml/ocaml/pull/10710">#10710</a> support for UTF decoding and validation was added by Daniel Bünzli (@dbuenzli), a long-standing missing feature of the standard library. The API was carefully designed to avoid allocations and exceptions while providing an easy-to-use decoding interface.</p>
<h2>Convenience functions for <code>Seq.t</code></h2>
<p>The type <code>Seq.t</code> of on-demand (but non-memoized) sequences of values was contributed by Simon Cruanes (@c-cube) in 2017, with only a minimal set of function, and increased slowly since. A large import of &gt;40 functions was completed just in time before the glacation by François Potter (@fpottier) and Simon, thanks to reviews by @gasche, @dbuenzli and many others. This is work that started in February 2020 thanks to issue #<a href="https://github.com/ocaml/ocaml/issues/9312">9312</a> from Yawar Amin.</p>
<p>Behold:</p>
<pre><code class="language-ocaml">val is_empty : 'a t -&gt; bool
val uncons : 'a t -&gt; ('a * 'a t) option
val length : 'a t -&gt; int
val iter : ('a -&gt; unit) -&gt; 'a t -&gt; unit
val fold_left : ('a -&gt; 'b -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'a
val iteri : (int -&gt; 'a -&gt; unit) -&gt; 'a t -&gt; unit
val fold_lefti : (int -&gt; 'b -&gt; 'a -&gt; 'b) -&gt; 'b -&gt; 'a t -&gt; 'b
val for_all : ('a -&gt; bool) -&gt; 'a t -&gt; bool
val exists : ('a -&gt; bool) -&gt; 'a t -&gt; bool
val find : ('a -&gt; bool) -&gt; 'a t -&gt; 'a option
val find_map : ('a -&gt; 'b option) -&gt; 'a t -&gt; 'b option
val iter2 : ('a -&gt; 'b -&gt; unit) -&gt; 'a t -&gt; 'b t -&gt; unit
val fold_left2 : ('a -&gt; 'b -&gt; 'c -&gt; 'a) -&gt; 'a -&gt; 'b t -&gt; 'c t -&gt; 'a
val for_all2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
val exists2 : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
val equal : ('a -&gt; 'b -&gt; bool) -&gt; 'a t -&gt; 'b t -&gt; bool
val compare : ('a -&gt; 'b -&gt; int) -&gt; 'a t -&gt; 'b t -&gt; int
val init : int -&gt; (int -&gt; 'a) -&gt; 'a t
val unfold : ('b -&gt; ('a * 'b) option) -&gt; 'b -&gt; 'a t
val repeat : 'a -&gt; 'a t
val forever : (unit -&gt; 'a) -&gt; 'a t
val cycle : 'a t -&gt; 'a t
val iterate : ('a -&gt; 'a) -&gt; 'a -&gt; 'a t
val mapi : (int -&gt; 'a -&gt; 'b) -&gt; 'a t -&gt; 'b t
val scan : ('b -&gt; 'a -&gt; 'b) -&gt; 'b -&gt; 'a t -&gt; 'b t
val take : int -&gt; 'a t -&gt; 'a t
val drop : int -&gt; 'a t -&gt; 'a t
val take_while : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
val drop_while : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t
val group : ('a -&gt; 'a -&gt; bool) -&gt; 'a t -&gt; 'a t t
val memoize : 'a t -&gt; 'a t
val once : 'a t -&gt; 'a t
val transpose : 'a t t -&gt; 'a t t
val append : 'a t -&gt; 'a t -&gt; 'a t
val zip : 'a t -&gt; 'b t -&gt; ('a * 'b) t
val map2 : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
val interleave : 'a t -&gt; 'a t -&gt; 'a t
val sorted_merge : ('a -&gt; 'a -&gt; int) -&gt; 'a t -&gt; 'a t -&gt; 'a t
val product : 'a t -&gt; 'b t -&gt; ('a * 'b) t
val map_product : ('a -&gt; 'b -&gt; 'c) -&gt; 'a t -&gt; 'b t -&gt; 'c t
val unzip : ('a * 'b) t -&gt; 'a t * 'b t
val split : ('a * 'b) t -&gt; 'a t * 'b t
val partition_map : ('a -&gt; ('b, 'c) Either.t) -&gt; 'a t -&gt; 'b t * 'c t
val partition : ('a -&gt; bool) -&gt; 'a t -&gt; 'a t * 'a t
val of_dispenser : (unit -&gt; 'a option) -&gt; 'a t
val to_dispenser : 'a t -&gt; (unit -&gt; 'a option)
val ints : int -&gt; int t
</code></pre>
<h2>A few of the nice contributions from new contributors we received</h2>
<p>Dong An (@kirisky) finished a left-open PR from Anukriti Kumar (#<a href="https://github.com/ocaml/ocaml/pull/9398">9398</a>, #<a href="https://github.com/ocaml/ocaml/pull/10666">10666</a>) to complete the documentation of the OCAMLRUNPARAM variable.</p>
<p>Dong An also improved the README description of which C compiler should be available on MacOS or Windows to build the compiler codebase: #<a href="https://github.com/ocaml/ocaml/pull/10685">10685</a>.</p>
<p>Thanks to Wiktor Kuchta, the ocaml toplevel now shows a tip at startup about the <code>#help</code> directive to get help: #<a href="https://github.com/ocaml/ocaml/pull/10527">10527</a>. (Wiktor is not really a &quot;new&quot; contributor anymore, with many <a href="https://github.com/ocaml/ocaml/commits?author=wiktorkuchta">nice contributions</a> over the last few months.)</p>
<p>While we are at it, a PR from @sonologico, proposed in May 2020, was merged just a few months ago (#<a href="https://github.com/ocaml/ocaml/pull/9621">9621</a>). It changes the internal build system for the <code>ocamldebug</code> debugger to avoid module-name clashes when linking user-defined printing code. Most of the delay came from maintainers arguing over which of the twelve name-conflict-avoidance hacks^Wfeatures should be used.</p>
|js}
  };
 
  { title = {js|OCaml Multicore - October 2021|js}
  ; slug = {js|multicore-2021-10|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-10-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the October 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! The <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> along with
this update have been compiled by me, @ctk21, @kayceesrk and @shakthimaan.</p>
<p>As @octachron announced last month, the core team has <a href="https://discuss.ocaml.org/t/the-road-to-ocaml-5-0/8584">committed to an OCaml 5.0 release</a> next year with multicore and the effects runtime.  This month has seen tremendous activity in our multicore trees to prepare an upstream-friendly version, with a number of changes made to make the code ready for <code>ocaml/ocaml</code> and reduce the size of the diff. Recall that we have been feeding in multicore-related changes steadily since way <a href="https://discuss.ocaml.org/t/multicore-prerequisite-patches-appearing-in-released-ocaml-compilers-now/4408">back in OCaml 4.09</a>, and so we are now down to the really big pieces.  Therefore the mainline OCaml trunk code is now being continuously being merged into our 5.00 staging branch, and test coverage has increased accordingly.</p>
<p>In the standard library, we continue to work and improve on thread safety by default. Since effect handlers are confirmed to go into 5.0 as well, they now have their own module in the stdlib as well. The multicore library ecosystem is also evolving with the changes to support OCaml 5.00, and in particular, Domainslib has had significant updates and improvements as more usecases build up. The integration of the Sandmark performance harness with current-bench is also actively being worked upon.</p>
<p>We would like to acknowledge the following people for their contribution:</p>
<ul>
<li>Török Edwin was able to reproduce the bug in <code>Task.pool</code> management
<a href="https://github.com/ocaml-multicore/domainslib/issues/43">Domainslib#43</a>, and has also provided a PR to fix the same.
</li>
<li>Sid Kshatriya has created
<a href="https://github.com/ocaml-multicore/eio/pull/83">PR#83</a> for <code>Eio</code> to use the Effect Handlers module.
</li>
</ul>
<p>Our focus in November is going to continue to be on relentlessly making a 5.0 staging tree, and we are preparing for a series of working groups with the core OCaml teams (taking up an entire week) to conduct preliminary code review on the full patchset. Stay tuned for how that has gone by the start of December!</p>
<p>As always, the Multicore OCaml updates are listed first, which contain the upstream efforts, merges with trunk, updates to test cases, bug fixes, and documentation improvements. This is followed by the ecosystem updates on Domainslib, <code>Tezos</code>, and <code>Eio</code>. The Sandmark and current-bench tasks are finally listed for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/637">ocaml-multicore/ocaml-multicore#637</a>
<code>caml_page_table_lookup</code> is not available in ocaml-multicore</p>
<p>The <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/642">Remove the remanents of page table
functionality</a>
PR should now fix this issue.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/707">ocaml-multicore/ocaml-multicore#707</a>
Move <code>Domain.DLS</code> to a ThreadLocal module and make it work under systhreads</p>
<p>The <code>Domain.DLS</code> implementation is to be moved to the <code>ThreadLocal</code>
module, and the use of thread-local-storage to systhreads should
also be enabled.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/719">ocaml-multicore/ocaml-multicore#719</a>
Optimize <code>minor_gc</code> ephemeron handling</p>
<p>An optimization request for a single domain to use the trunk
algorithm to collect the ephemerons in the minor GC, and not use a
barrier when there are no ephemerons in the multi-domain context.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/727">ocaml-multicore/ocaml-multicore#727</a>
Update version number</p>
<p>The <code>ocaml-variants.opam</code> file needs to be updated to use
<code>ocaml-variants.4.14.0+domains</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/728">ocaml-multicore/ocaml-multicore#728</a>
Update <code>base-domains</code> package for 5.00 branch</p>
<p>The <code>base-domains</code> package needs to include <code>4.14.0+domains</code>, as
pinning on a local opam switch fails on dependency resolution.</p>
</li>
</ul>
<h4>Testsuite</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/656">ocaml-multicore/ocaml-multicore#656</a>
<code>Core</code> testsuite workflow</p>
<p>A draft PR to implement a workflow to run the Core's testsuite once
a day.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/720">ocaml-multicore/ocaml-multicore#720</a>
Improve ephemerons compatibility with testsuite</p>
<p>The PR imports upstream fixes to make ephemerons work with infix
objects, and provides a fix for <code>weaktest.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/722">ocaml-multicore/ocaml-multicore#722</a>
Testsuite: Re-enable <code>signals_alloc</code> testcase</p>
<p>The <code>signals_alloc</code> testcase has been enabled, and the PR also
attempts to ensure the bytecode interpreter polls for signals.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/723">ocaml-multicore/ocaml-multicore#723</a>
<code>beat.ml</code> failure on GitHub Action MacOS runners</p>
<p>An investigation on the <code>beat.ml</code> test failure in the testsuite for
the CI execution runs.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/669">ocaml-multicore/ocaml-multicore#669</a>
Set thread names for domains</p>
<p>A patch that implements thread naming for Multicore OCaml. It
provides an interface to name Domains and Threads differently.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/698">ocaml-multicore/ocaml-multicore#698</a>
Return free pools to the OS</p>
<p>The <code>pool_release</code> is in the shared_heap and does not return memory
to the OS. An ongoing discussion on how much memory to hold, and to
reclaim with space overhead setting.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/703">ocaml-multicore/ocaml-multicore#703</a>
Possible loop in <code>caml_enter_blocking_section</code> when no domain can handle a blocked signal</p>
<p>A scenario that can be triggered when a domain that blocks a
specific set of signals exists where no other domain can process the
signal, and can be caused by a loop in
<code>caml_enter_blocking_section</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/725">ocaml-multicore/ocaml-multicore#725</a>
Blocked signal infinite loop fix</p>
<p>A monotonic <code>recorded_signals_counter</code> has been introduced to fix
the possible loop in <code>caml_enter_blocking_section</code> when no domain
can handle a blocked signal.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/726">ocaml-multicore/ocaml-multicore#726</a>
Marshalling of concurrently-modified objects is unsafe</p>
<p>The marshalling of objects being mutated on a different domain must
be handled correctly and should be safe. It should not cause a
segmentation fault or crash.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<h5>Build</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/662">ocaml-multicore/ocaml-multicore#662</a>
Disable changes check on 5.0</p>
<p>The <code>.github/workflows/hygiene.yml</code> has been updated to disable
check on 5.00 to avoid noise on the change entries.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/676">ocaml-multicore/ocaml-multicore#676</a>
Fix 5.00 install</p>
<p>The <code>caml/byte_domain_state.tbl</code> has been removed, and <code>README.adoc</code>
has been renamed to <code>README.stock.adoc</code> in order to build cleanly
with OCaml 5.00 branch.</p>
</li>
</ul>
<h5>Change</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/675">ocaml-multicore/ocaml-multicore#675</a>
Align <code>Bytes.unsafe_of_string / Bytes.unsafe_to_string</code> to OCaml trunk</p>
<p>The <code>Pbytes_to_string / Pbytes_of_string</code> use in
<code>bytecomp/bytegen.ml</code> are now aligned with upstream OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/677">ocaml-multicore/ocaml-multicore#677</a>
Remove debugging nop</p>
<p>The debugging nop primitive is not required for upstreaming and has
been cleaned up. The PR also fixes check-typo whitespace in
<code>emit.mlp</code> to match that trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/679">ocaml-multicore/ocaml-multicore#679</a>
Remove <code>caml_read_field</code></p>
<p>The use of <code>caml_read_field</code> has been removed as the existing
<code>Field</code> provides all the necessary information making it closer to
upstream OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/681">ocaml-multicore/ocaml-multicore#681</a>
Revert to ocaml/trunk version of otherlibs/unix</p>
<p><code>unixsupport.c</code>, <code>cstringv.c</code> and files in <code>otherlibs/unix</code> have
been updated to be similar to <code>ocaml/ocaml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/684">ocaml-multicore/ocaml-multicore#684</a>
Remove historical <code>for_handler</code> and <code>Reperform_noloc</code> in <code>lambda/matching</code></p>
<p>The <code>for_handler</code> function and <code>Reperform_noloc</code> in
<code>lambda/matching.ml{,i}</code> are not required to be upstreamed and hence
have been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/685">ocaml-multicore/ocaml-multicore#685</a>
Remove <code>Init_field</code> from interp.c</p>
<p>The <code>interp.c</code> file has been updated to be closer to
<code>ocaml/ocaml</code>. The check-typo errors have been fixed, and the
<code>Init_field</code> macro has been cleaned up.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/704">ocaml-multicore/ocaml-multicore#704</a>
Remove Sync.poll and nanoseconds from Domain</p>
<p>The Domain module has been updated to include only the changes
required for upstreaming. <code>Domain.Sync.poll</code>, and
<code>Domain.nanosecond</code> have been removed. <code>Domain.Sync.cpu_relax</code> has
been renamed to <code>Domain.cpu_relax</code>. <code>platform.h</code> has been updated
with fixes for check-typo.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/706">ocaml-multicore/ocaml-multicore#706</a>
Revert <code>otherlibs/win32unix</code> to ocaml/trunk</p>
<p>The <code>otherlibs/win32unix/*</code> files have been updated to be closer to
<code>ocaml/ocaml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/708">ocaml-multicore/ocaml-multicore#708</a>
Remove maybe stats</p>
<p>The <code>caml_maybe_print_stats</code> primitive to output statistics and the
<code>s</code> option to <code>OCAMLRUNPARAM</code> have now been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/724">ocaml-multicore/ocaml-multicore#724</a>
Runtime: Remove unused fields from <code>io.h</code></p>
<p>Remove <code>revealed</code> and <code>old_revealed</code> from <code>runtime/caml/io.h</code> as
they have also been removed from <code>ocaml/ocaml</code>.</p>
</li>
</ul>
<h5>Diff</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/663">ocaml-multicore/ocaml-multicore#663</a>
Remove noise from diff with upstream on <code>typing/</code></p>
<p>The PR squishes unnecessary diffs with upstream OCaml for <code>typing/</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/664">ocaml-multicore/ocaml-multicore#664</a>
Remove unncessary diffs with upstream in <code>parsing/</code></p>
<p>The PR removes unnecessary white space diffs with upstream OCaml in
<code>parsing/</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/694">ocaml-multicore/ocaml-multicore#694</a>
First pass to improve the diff to startup code</p>
<p>The PR attempts to improve the diff in the startup code for trunk
and Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/695">ocaml-multicore/ocaml-multicore#695</a>
Improve systhread's diff with trunk</p>
<p>The systhread's diff with trunk is improved with this merged PR.</p>
</li>
</ul>
<h5>Merge</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml/pull/2">ocaml-multicore/ocaml#2</a>
Update trunk to the latest upstream trunk</p>
<p>The PR is an attempt to help with the OCaml 5.0 difference
output. With the changes, you can successfully do <code>make &amp;&amp; make tests</code>. The summary of the results is provided below:</p>
<pre><code>Summary:
2918 tests passed
 40 tests skipped
  0 tests failed
105 tests not started (parent test skipped or failed)
  0 unexpected errors
3063 tests considered

</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml/pull/3">ocaml-multicore/ocaml#3</a>
Latest 5.00 Commits</p>
<p>The recent commits from trunk have now been merged to the
ocaml-multicore 5.00 branch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/718">ocaml-multicore/ocaml-multicore#718</a>
Deprecate Sync and <code>timer_ticks</code> from Domain</p>
<p>The patch synchronizes the changes to <code>4.12.0+domains+effects</code> with
the mainline 5.00 branch.</p>
</li>
</ul>
<h4>Thread Safe</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/632">ocaml-multicore/ocaml-multicore#632</a>
<code>Str</code> module multi domain safety</p>
<p>The
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/635">PR#635</a>
makes <code>lib-str</code> domain safe to work concurrently with Multicore
OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/672">ocaml-multicore/ocaml-multicore#672</a>
Codefrag thread safety</p>
<p>The PR introduces a lock-free skiplist to make codefrag thread
safe. The code fragments cannot be freed as soon as they are
removed, but, they are added to a list and cleaned up during a later
stop-the-world pause.</p>
</li>
</ul>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/655">ocaml-multicore/ocaml-multicore#655</a>
Systhreads: Initialize <code>thread_next_id</code> to 0</p>
<p>The <code>thread_next_id</code> was not initialized and was causing an issue
with Core's testsuite. It has now been initialized to zero.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/657">ocaml-multicore/ocaml-multicore#657</a>
Libstr: Use a domain local value to store <code>last_search_result_key</code></p>
<p>The <code>last_search_result_key</code> is now stored in a domain local storage
which fixes a recent CI failure.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/673">ocaml-multicore/ocaml-multicore#673</a>
Fix C++ namespace pollution reported in #671</p>
<p>The patch fixes the C++ namespace pollution and check-typo issues.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/702">ocaml-multicore/ocaml-multicore#702</a>
Otherlibs: Add PR10478 fix back to systhreads</p>
<p>The <code>st_thread_set_id</code> invocation has been added to
<code>otherlibs/systhreads/st_stubs.c</code> that reinstates the fix from
<a href="https://github.com/ocaml/ocaml/pull/10478">ocaml/ocaml#10478</a> in
systhreads.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/721">ocaml-multicore/ocaml-multicore#721</a>
Fix <code>make install</code></p>
<p>The <code>caml/byte_domain_state.tbl: No such file or directory</code> bug from
running <code>make install</code> has been fixed with this PR.</p>
</li>
</ul>
<h4>Testsuite</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/654">ocaml-multicore/ocaml-multicore#654</a>
Enable effects tests</p>
<p>The effect handler tests have now been re-added since the syntax
support has been added to Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/658">ocaml-multicore/ocaml-multicore#658</a>
Enable last dynlink test</p>
<p>The <code>lib-dynlink-private</code> test has now been enabled to run in the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/659">ocaml-multicore/ocaml-multicore#659</a>
Reimport the threadsigmask test and remove systhread-todo test directory</p>
<p>The <code>lib-systhreads-todo</code> test on signal handling and tick thread
missing from systhreads has been reactivated in the the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/660">ocaml-multicore/ocaml-multicore#660</a>
Fixups and housekeeping for <code>testsuite/disabled</code> file</p>
<p>The <code>check-typo</code> problems for 80 character line, and unnecessary
<code>test/promotion</code> in <code>testsuite/disabled</code> have been fixed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/661">ocaml-multicore/ocaml-multicore#661</a>
Testsuite: Re-enable pr9971</p>
<p>The <code>pr9971</code> test has been re-enabled to run in the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/688">ocaml-multicore/ocaml-multicore#688</a>
Better signal handling in systhreads</p>
<p>Improvements to the signal handling in systhreads that fixes the
<code>threadsigmask</code> testcase failure in the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/712">ocaml-multicore/ocaml-multicore#712</a>
Otherlibs: Unix.kill should check for pending signals</p>
<p>The <code>unix_kill</code> test case has been re-enabled to ensure that
<code>Unix.kill</code> checks for pending signals on return.</p>
</li>
</ul>
<h4>Documentation</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/672">ocaml-multicore/ocaml-multicore#672</a>
Check-typo fixes for <code>major_gc</code>, so the changes in #672 don't get clobbered</p>
<p>A patch that fixes check-typo issues in <code>runtime/major_gc.c</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/696">ocaml-multicore/ocaml-multicore#696</a>
Stdlib: Fix typos in <code>effectHandlers.mli</code></p>
<p>A few typos in <code>stdlib/effectHandlers.mli</code> have been fixed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/697">ocaml-multicore/ocaml-multicore#697</a>
Remove dead code and clear up comments in the minor gc</p>
<p>A non-functional change that clears up the comments in the minor and
major GC files.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/699">ocaml-multicore/ocaml-multicore#699</a>
Cleanup fiber implementation and add documentation</p>
<p>The unused code in <code>amd64.S</code> has been removed and formatting has
been fixed. The addition of 24 bytes at the top of the stack for an
external call is no longer needed and has been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/713">ocaml-multicore/ocaml-multicore#713</a>
Clarify documentation of Lazy wrt. RacyLazy and Undefined exceptions.</p>
<p>The documentation in <code>stdlib/lazy.mli</code> has been updated to clarify
on the behaviour of <code>try_force</code> and thread safety.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/717">ocaml-multicore/ocaml-multicore#717</a>
Tighten code comments in <code>minor_gc.c</code></p>
<p>The PR explains promotion of ephemeron keys to avoid introducing a
barrier, and uses <code>/* ... */</code> style comments.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/docs">ocaml-multicore#docs</a>
Docs</p>
<p>A documentation repository for OCaml 5.00 that contains the design
and proposed upstreaming plan.</p>
</li>
</ul>
<h4>Effect Handlers</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/653">ocaml-multicore/ocaml-multicore#653</a>
Drop <code>drop_continuation</code></p>
<p>This PR has been superseded by the <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/689">Add
EffectHandlers</a>
module PR for 4.12.0+domains+effects.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/682">ocaml-multicore/ocaml-multicore#682</a>
Move effect handlers to its own module in Stdlib</p>
<p>The <code>EffectHandlers</code> functionality from <code>Obj</code> has now been moved to
its own module in Stdlib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/687">ocaml-multicore/ocaml-multicore#687</a>
Move effect handlers to its own module in Stdlib</p>
<p>This is a backport of
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/682">PR#682</a>
for <code>4.12+domains</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/689">ocaml-multicore/ocaml-multicore#689</a>
Add EffectHandlers module</p>
<p>The PR adds effect handler functions to <code>4.12.0+domains+effects</code>,
and allows <code>domainslib</code> with effect handler functions to work with
the <code>4.12.0+domains+effects</code> switch.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/678">ocaml-multicore/ocaml-multicore#678</a>
Make domain state the same in bytecode and native mode</p>
<p>The <code>struct domain_state</code> structure is now made identical in both
bytecode and native code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/691">ocaml-multicore/ocaml-multicore#691</a>
Add ability to discontinue with backtrace</p>
<p>The backtrace is useful for modeling async/wait, especially when the
awaited task raises an exception, the backtrace includes frames from
both the awaited and awaiting task.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/693">ocaml-multicore/ocaml-multicore#693</a>
Add ability to discontinue with backtrace</p>
<p>The backport of
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/691">ocaml-multicore/ocaml-multicore#691</a>
to <code>4.12.0+domains+effects</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/701">ocaml-multicore/ocaml-multicore#701</a>
Really flush output when pre-defined formatters are used in parallel</p>
<p>The flush used to happen only at the termination of a domain, but,
with this PR the output is immediately flushed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/705">ocaml-multicore/ocaml-multicore#705</a>
Otherlibs: Remove <code>caml_channel_mutex_io</code> hooks from systhreads</p>
<p><code>caml_channel_mutex_io</code> hooks in systhreads have now been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/716">ocaml-multicore/ocaml-multicore#716</a>
runtime: <code>extern_free_position_table</code> should return on <code>extern_flags &amp; NO_SHARING</code></p>
<p><code>extern_free_position_table</code> should return immediately if
<code>extern_flags &amp; NO_SHARING</code>, by symmetry with
<code>extern_alloc_position_table</code>.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h5>Ongoing</h5>
<h6>Domainslib</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/43">ocaml-multicore/domainslib#43</a>
Possible bug in <code>Task.pool</code> management</p>
<p>Török Edwin has reproduced the segmentation fault using
4.12.0+domains with domainslib 0.3.1 on AMD Ryzen 3900X CPU, and has
also provided a draft PR with a fix!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/46">ocaml-multicore/domainslib#46</a>
Provide a way to iterate over all the pools</p>
<p>A requirement to be able to iterate over all the pools created in
domainslib. A use case is to tear down all the pools. A weak hash
set can be used to store a weak pointer to the pools.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/47">ocaml-multicore/domainslib#47</a>
<code>Task.await</code> deadlock (task finished but await never returns)</p>
<p>A query on nesting <code>Task.await</code> inside <code>Task.async</code>, and
<code>Task.async</code> inside <code>Task.async</code>. A sample code snippet, stack trace
and platform information have also been provided to reproduce a
deadlock scenario.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/48">ocaml-multicore/domainslib#48</a>
Move <code>ws_deque</code> to lockfree</p>
<p>A request to move the work-stealing deque in domainslib to
<code>ocaml-multicore/lockfree</code>, and make <code>domainslib</code> depend on this new
<code>lockfree</code> implementation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/49">ocaml-multicore/domainslib#49</a>
Should we expose multi-channel from the library?</p>
<p>A query on whether Multicore OCaml users will find Non-FIFO
multi-channel implementation useful. Domainslib already provides
FIFO channels.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/50">ocaml-multicore/domainslib#50</a>
Multi_channel: Allow more than one instance per program with different configurations</p>
<p>A draft PR contributed by Török Edwin in <code>lib/multi_channel.ml</code> and
<code>lib/task.ml</code> to remove use of a global key with a per-channel key.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/51">ocaml-multicore/domainslib#51</a>
Utilise effect handlers</p>
<p>The tasks are now created using effect handlers, and a new
<code>test_deadlock.ml</code> tests the same. The change will work only with
<code>4.12+domains</code> and <code>5.00</code>. The performance results from the Turing
machine (Intel Xeon Gold 5120 CPU @ 2.20 GHz, 28 isolated cores) is
shown below:</p>
<p><img src="images/Domainslib-PR-51-performance.png" alt="Domainslib-PR-51-performance" /></p>
</li>
</ul>
<h6>Sundries</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/issues/8">ocaml-multicore/tezos#8</a>
ci.Dockerfile throws warning</p>
<p>The <code>ci.Dockerfile</code> on Ubuntu 20.10 throws C99 warnings on <code>_Atomic</code>
with GCC 10.3.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/10">ocaml-multicore/tezos#10</a>
Fix make build-deps, fix NixOS support</p>
<p><code>conf-perl</code> is no longer required upstream and has been removed from
the <code>tezos-opam-repository</code>. The patch also fixes <code>make build-deps/build-dev-deps</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/issues/39">ocaml-multicore/ocaml-uring#39</a>
Test failures on NixOS</p>
<p>The <code>ocaml-uring</code> master branch is showing test failures with <code>dune runtest</code> on NixOS.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/issues/85">ocaml-multicore/eio#85</a>
Any plans on supporting <code>js_of_ocaml</code>?</p>
<p>A query by Konstantin A. Olkhovskiy (<code>Lupus</code>) on whether EIO can
compile to JavaScript backend, assuming that <code>js_of_ocaml</code> gets
support for effects.</p>
</li>
</ul>
<h5>Completed</h5>
<h6>Domainslib</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/45">ocaml-multicore/domainslib#45</a>
Add named pools</p>
<p>An optional argument is now added to name a pool during setup. This
name can be used to retrieve the pool later.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/52">ocaml-multicore/domainslib#52</a>
Use a random number as the cache prefix to disable cache in CI</p>
<p>The <code>cache-prefix</code> now uses a random number in
<code>.github/workflows/main.yml</code> to disable cache in the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/53">ocaml-multicore/domainslib#53</a>
Make domainslib build/run with OCaml 5.00 after PR#704</p>
<p>The CI has been updated to now build and run with OCaml 5.00 branch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/54">ocaml-multicore/domainslib#54</a>
Use last 4.12+domains+effects hash as the cache-key</p>
<p>The cache-key now uses the last commit hash from OCaml Multicore in
order to invalidate the cache in the CI.</p>
</li>
</ul>
<h6>Sundries</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos-opam-repository/pull/3">ocaml-multicore/tezos-opam-repository#3</a>
Add domainslib</p>
<p>The <code>domainslib.0.3.1</code> version has now been included in the Tezos
OPAM repository as a package.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos-opam-repository/pull/5">ocaml-multicore/tezos-opam-repository#5</a>
Upstream updates</p>
<p>The <code>Tezos OPAM repository</code> has been updated with upstream changes
using
<a href="https://github.com/ocaml-multicore/tezos-opam-repository/pull/1">PR#1</a>
and
<a href="https://github.com/ocaml-multicore/tezos-opam-repository/pull/5">PR#5</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/17">ocaml-multicore/retro-httpaf-bench#17</a>
Improve graphs</p>
<p>Markers have now been added to the graphs generated from the Jupyter
notebook to easily distinguish the colour lines.</p>
<p><img src="upload://qKGZJ5anPXMCKp8EDcY2F5TMRbk.jpeg" alt="retro-httpaf-bench-17-graph|690x409" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/59">ocaml-multicore/multicore-opam#59</a>
Fix batteries after ocaml-multicore/ocaml-multicore#514</p>
<p>The <code>batteries.3.3.0+multicore</code> opam file for <code>batteries-included</code>
has been updated with the correct src URL.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/82">ocaml-multicore/eio#82</a>
Migrate to 4.12.0+domains effects implementation (syntax-free effects version)</p>
<p>The PR updates <code>eio</code> to support the effects implementation for OCaml
5.0 release.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/83">ocaml-multicore/eio#83</a>
Effect handlers have their own module now</p>
<p>Sid Kshatriya has contributed a patch to rename
<code>Obj.Effect_handlers</code> to <code>EffectHandlers</code> since effect handlers have
their own module in Stdlib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/core">ocaml-multicore/core</a></p>
<p>Jane Street's standard library overlay <code>core</code> has now been
added to <code>ocaml-multicore</code> GitHub project repositories.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Sandmark</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/248">ocaml-bench/sandmark#248</a>
Coq fails to build</p>
<p>A new Coq tarball,
<a href="https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24">coq-multicore-2021-09-24</a>,
builds with Multicore OCaml 4.12.0+domains, but, <code>stdio.v0.14.0</code>
fails to build cleanly with 4.14.0+trunk because of a <a href="https://github.com/ocaml/dune/issues/5028">dune
issue</a> that has been
reported.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/260">ocaml-bench/sandmark#260</a>
Add 5.00 branch for sequential run. Fix notebook.</p>
<p>A new 5.00 OCaml variant branch has been added to Sandmark to
track sequential benchmark runs in the CI.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/256">ocaml-bench/sandmark#256</a>
Remove old variants</p>
<p>The older variants, <code>4.05.*</code>, <code>4.06.*</code>, <code>4.07.*</code>, <code>4.08.*</code>,
<code>4.10.0.*</code> have now been removed from Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/258">ocaml-bench/sandmark#258</a><br />
Document Makefile variables in README</p>
<p>The README now contains documentation on the various Makefile
variables that are used during building and execution of the
benchmarks in Sandmark.</p>
</li>
</ul>
<h3>current-bench</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/117">ocurrent/current-bench#117</a>
Read stderr from the Docker container</p>
<p>We would like to see any build failures from the benchmark execution
inside the Docker container for debugging purposes.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/146">ocurrent/current-bench#146</a>
Replicate ocaml-bench-server setup</p>
<p>The TAG and OCaml variants need to be abstracted from the Sandmark
Makefile to current-bench in order to be able to run the benchmarks
for different compiler versions and developer branches.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/105">ocurrent/current-bench#105</a>
Abstract out Docker image name from <code>pipeline/lib/pipeline.ml</code> to environments</p>
<p>Custom Dockerfiles are now supported and hence you can pull in any
opam image in the Dockerfile.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/119">ocurrent/current-bench#119</a>
<code>OCAML_BENCH_DOCKER_CPU</code> does not support range of CPUs for parallel execution</p>
<p>The Docker CPU setting now uses a string representation instead of
an integer to specify the list of CPUs for parallel execution.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/151">ocurrent/current-bench#151</a>
Docker versus native performance</p>
<p>The Docker with current-bench, and native sequential and parallel
benchmark runs do not show significant difference with
hyper-threading disabled. The Gödel server configuration and the
Sandmark-nightly notebook graph results are provided below for
reference:</p>
<ul>
<li>CPU: Intel(R) Xeon® Gold 5120 CPU @ 2.20 GHz
</li>
<li>OS: Ubuntu 20.04.3 LTS (Focal Fossa)
</li>
<li>Sandmark 2.0-beta branch: https://github.com/ocaml-bench/sandmark/tree/2.0-beta
</li>
<li>Disabled hyper-threading:
<pre><code>$ cat /sys/devices/system/cpu/smt/active
0
</code></pre>
</li>
<li>Memory (62 GB), disk (1.8 TB).
</li>
<li>OCaml variant: 4.12.0+domains
</li>
<li>Sandmark-nightly notebooks: https://github.com/ocaml-bench/sandmark-nightly/tree/main/notebooks
</li>
<li>Average of five iterations for each benchmark
<ul>
<li><code>run_in_ci</code> for sequential
</li>
<li><code>macro_bench</code> for parallel
</li>
</ul>
</li>
</ul>
<p>Time
<img src="upload://gjR8Yte7F23hEVr0162yOuWCp2r.png" alt="Current-bench-151-Time|690x236" />
Normalised
<img src="upload://wtc2aSo61cDXTtdJQLcrOvjJwmD.png" alt="Current-bench-151-Time-Normalised|690x315" />
Top heap words
<img src="upload://xxyblnCJr3GPkEEfM3ZnmAJ4LMe.png" alt="Current-bench-151-Top-heap-words|690x236" />
Normalised
<img src="upload://4JXHsIHH4b5DDeAtn0kwN8bnC0n.png" alt="Current-bench-151-Top-heap-words-Normalised|690x323" /></p>
<p>MaxRSS (KB)
<img src="upload://jys3rIAZFb5mkb3q2ZMD3uPGiQA.png" alt="Current-bench-151-MaxRSS|690x237" />
Normalised
<img src="upload://ue1TiDvFK8EXA6Wi11gOHiHMXNU.png" alt="Current-bench-151-MaxRSS-Normalised|690x325" /></p>
<p>Major Collections
<img src="upload://dm1cGbEjtV8I5UZpfxdfgt2lIaf.png" alt="Current-bench-151-Major-collections|690x236" />
Normalised
<img src="upload://sdHyKFyoDSDdok3QDvKNbyNAq0Z.png" alt="Current-bench-151-Minor-collections-Normalised|690x320" /></p>
<p>Parallel Benchmarks
<img src="upload://8BQzGtrqwFPZ0Di4WeUcsUxkQcq.png" alt="Current-bench-151-Parallel-benchmarks-I|486x500" />
<img src="upload://rIYQcXtBJwgIlniuhcCyz3WY2Q7.png" alt="Current-bench-151-Parallel-benchmarks-II|237x500" /></p>
</li>
</ul>
<p>(see the PR full for the full set of graphs, including major words and time taken)</p>
<p>Our special thanks to all the OCaml users, developers and contributors in the community for their valuable time and continued support to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>AMD: Advanced Micro Devices
</li>
<li>CI: Continuous Integration
</li>
<li>CPU: Central Processing Unit
</li>
<li>DLS: Domain Local Storage
</li>
<li>FIFO: First In, First Out
</li>
<li>GB: Gigabyte
</li>
<li>GC: Garbage Collector
</li>
<li>GCC: GNU Compiler Collection
</li>
<li>IO: Input/Output
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>OS: Operating System
</li>
<li>PR: Pull Request
</li>
<li>TB: Terabyte
</li>
<li>URL: Uniform Resource Locator
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Compiler - June-September 2021|js}
  ; slug = {js|ocaml-2021-09|js}
  ; description = {js|Monthly update from the OCaml Compiler team.|js}
  ; date = {js|2021-09-01|js}
  ; tags = 
 [{js|ocaml|js}]
  ; body_html = {js|<p>I’m happy to publish the third issue of the “OCaml compiler development newsletter”. (This is by no means exhaustive: many people didn’t end up having the time to write something, and it’s fine.)</p>
<p>Feel free of course to comment or ask questions!</p>
<p>If you have been working on the OCaml compiler and want to say something, please feel free to post in this thread! If you would like me to get in touch next time I prepare a newsletter issue (some random point in the future), please let me know by email at (gabriel.scherer at gmail).</p>
<p>Previous issues:</p>
<ul>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-2-may-2021/7965">OCaml compiler development newsletter, issue 2: May 2021</a>
</li>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-1-before-may-2021/7831">OCaml compiler development newsletter, issue 1: before May 2021</a>
</li>
</ul>
<hr />
<h2>Nicolás Ojeda Bär (@nojb)</h2>
<h3>Channels in the standard library</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10545">#10545</a> Add modules <code>In_channel</code> and <code>Out_channel</code> to the standard library. (merged)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10538">#10538</a> Add<code>Out_channel.set_buffered</code> and <code>Out_channel.is_buffered</code> to control and query the buffering mode of output channels. (merged)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10596">#10596</a> Add <code>In_channel.input_all</code>, <code>In_channel.with_open_{bin,text,gen}</code> and <code>Out_channel.with_open_{bin,text,gen}</code>. (merged)</p>
</li>
</ul>
<h3>Compiler user-interface</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10654">#10654</a> Propose an approach to enable use of debug info in bytecode binaries compiled with <code>-output-complete-exe</code>. (waiting for review)
This is the second iteration on work that could have important impact on usability of self-contained bytecode binaries -- bring <code>-output-complete-exe</code> to feature parity with <code>-custom</code>, and deprecate the latter, more fragile approach.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10555">#10555</a> Improve and clean up the AST locations stored associated to &quot;punned&quot; terms (eg <code>{x; y}</code> or <code>&lt; x; y &gt;</code>). (merged)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10560">#10560</a> The compiler now respects the <code>NO_COLOR</code> environment variable. (merged)</p>
</li>
</ul>
<h3>Internal changes</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10624">#10624</a> Apply a fix for a compile-time regression introduced in 4.08 (the fix was suggested by Leo White). (merged)</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10606">#10606</a> Clean up the implementation of the <code>non-unit-statement</code> and <code>ignored-partial-application</code> warnings. (merged)</p>
</li>
</ul>
<h2>David Allsopp (@dra27)</h2>
<ul>
<li>Relocatable Compiler. I worked on the patchset in August and September. There's a prototype for both Windows and Unix rebased to 4.12 and 4.13. With these patches, if you have multiple versions of the compiler lying around (i.e. opam!), it is now virtually impossible for a bytecode executable to load the wrong C stubs library (e.g. <code>dllunix.so</code>) or invoke the wrong version of <code>ocamlrun</code>. Furthermore, from the compiler's perspective at least, a local opam switch can now be moved to a new location.
The major thing this enables is the cloning of an existing compiler in order to create a new opam switch without any binary rewriting. With these patches, fresh local switches are building in 5-10 seconds (a lot of which is spent by opam, which has more incentive to be improved, now!).
</li>
<li>4.13 includes the first parts of work to reduce the use of scripting languages in the build system   which improves the stability of the build system and also its portability. The Cygwin distribution   recently stopped distributing the <code>iconv</code> command by default, which broke all the Windows builds of OCaml (see <a href="https://github.com/ocam/ocaml/pull/10451">#10451</a>. There's more work to go on this, but the rest of it is likely to be stalled until post OCaml 5.00. With the use of scripting vastly reduced, it was possible to get quite a long way through the build using <em>native Windows</em>-compiled GNU make (i.e. <code>make.exe</code> with no other dependencies) and no Cygwin/MSYS2/WSL.
</li>
<li>4.13 includes a full overhaul of the FlexDLL bootstrap and detection (mentioned in my April update); hopefully gone are the days of randomly picking up the wrong flexlink or suddenly finding that FlexDLL is missing. The Windows build should also be appreciably faster when bootstrapping FlexDLL (which is what opam's source builds have to do).
</li>
<li>There's some ongoing work at &quot;modernising&quot; our use of POSIX to remove some older compatibility code in the Unix Library in <a href="https://github.com/ocaml/ocaml/pull/10505">#10505</a>. It's always nice to <em>remove</em> code!
</li>
<li>Gradually completing and closing down some of my more aged PRs, often replacing them with simpler implementations. It's funny how returning to PRs can often result in realising simpler approaches; like letting tea brew! :tea:
</li>
</ul>
<h2>Xavier Leroy (@xavierleroy)</h2>
<p>I worked on an old issue with the handling of tail calls by the native-code compiler: if there are many arguments to the call and they don't all fit in the processor registers reserved for argument passing, the remaining arguments are put on the stack, and a regular, non-tail call is performed.  This limitation had been with us since day 1 of OCaml.  I tried several times in the past to implement proper tail calls in the presence of arguments passed on stack, but failed because of difficulties with the stack frame descriptors that are used by the GC to traverse the stack.</p>
<p>In <a href="https://github.com/ocaml/ocaml/pull/10595">#10595</a>, generalizing an earlier hack specific to the i386 port of OCaml, I developed a simpler approach that uses memory from the &quot;domain state&quot; structure instead of the stack.  Once the registers available for passing function arguments are exhausted, the next 64 arguments are passed in a memory area that is part of the domain state. This argument passing is compatible with tail calls, so we get guaranteed tail calls up to 70 arguments at least.</p>
<p>The domain state structure, introduced in preparation for merging Multicore OCaml, is a per-execution-domain memory area that is efficiently addressable from a register. Hence, passing arguments through the domain state is safe w.r.t. parallelism and about as efficient as passing them through the stack.</p>
<p>Enjoy your 70-arguments tail calls!</p>
<h2>Constructor unboxing (Nicolas Chataing @nchataing, Gabriel Scherer @gasche)</h2>
<p>Nicolas Chataing's internship on constructor unboxing (mentioned in the <a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-2-may-2021/7965">last issue</a> finished at the end of June. We have been working on-and-off, at a slower rate, to get the prototype to the state we can submit a PR. The first step was to propose our specification (which is different from Jeremy Yallop's original proposal), which is now posted <a href="https://github.com/ocaml/RFCs/pull/14#issuecomment-920643103">as an RFC comment</a>.</p>
<p>Hacking on this topic produced a stream of small upstream PRs, mostly cleanups and refactorings that make our implementation easier, and some documentation PRs for subtle aspects of the existing codebase we had to figure out reading the code: <a href="https://github.com/ocaml/ocaml/pull/10500">#10500</a>, <a href="https://github.com/ocaml/ocaml/pull/10512">#10512</a> (not yet merged, generating interesting discussion), <a href="https://github.com/ocaml/ocaml/pull/10516">#10516</a>, <a href="https://github.com/ocaml/ocaml/pull/10637">#10637</a>, <a href="https://github.com/ocaml/ocaml/pull/10646">#10646</a>.</p>
<h2>Vincent Laviron (@lthls(github)/@vlaviron(discuss))</h2>
<p>Léo Boitel's internship on detection and simplification of identity functions finished in June (find the corresponding blog post <a href="https://www.ocamlpro.com/2021/07/16/detecting-identity-functions-in-flambda/">at OCamlPro</a> and the discussion <a href="https://discuss.ocaml.org/t/detecting-identity-functions-in-flambda/8180">on Discuss</a>).
Pushing the results upstream isn't a priority right now, but I'm planning to build on that work and integrate it either in the main compiler or in the Flambda 2 branch at some point in the future.</p>
<p>Apart from that, I've documented the abstract domains that we use for approximations in the Flambda 2 simplification pass (you can find the result <a href="https://github.com/ocaml-flambda/flambda-backend/blob/main/middle_end/flambda2/docs/types.md">here</a>), and I've worked with Keryan Dider (@Keryan-dev) on an equivalent to the <code>-Oclassic</code> mode for Flambda 2.</p>
<p>I've also proposed and reviewed a number of small fixes both on the upstream and Flambda 2 repos, from fixes for obscure bugs (like <a href="https://github.com/ocaml/ocaml/pull/10611">this Flambda bug</a>) to small improvements to code
generation.</p>
<h2>Jacques Garrigue (@garrigue)</h2>
<p>Continued to work with Takafumi Saikawa (@t6s) on strengthening the datatypes used in the unification algorithm.</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/10337">#10337</a> Make type nodes abstract, ensuring one always sees normal forms. Merged in June.
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/10474">#10474</a> Same thing for polymorphic variants rows. Merged in September.
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/10627">#10627</a> Same thing for polymorphic variant field kinds.
</li>
<li><a href="https://github.com/ocaml/ocaml/pull/10541">#10541</a> Same thing for object field kinds and function commutation flags.
</li>
</ul>
<p>Also continued the work on creating a backend generating Coq code <a href="https://github.com/COCTI/ocaml/tree/ocaml_in_coq">GitHub - COCTI/ocaml at ocaml_in_coq</a>. This now works with many examples.</p>
|js}
  };
 
  { title = {js|OCaml Multicore - September 2021|js}
  ; slug = {js|multicore-2021-09|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-09-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the September 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by me, @ctk21, @kayceesrk and @shakthimaan. The team has been working over the past few months to finish the <a href="https://github.com/ocaml-multicore/ocaml-multicore/projects/4">last few features</a> necessary to reach feature parity with stock OCaml. We also worked closely with the core OCaml team to develop the timeline for upstreaming Multicore OCaml to stock OCaml, and have now agreed that:</p>
<p><strong>OCaml 5.0 will support shared-memory parallelism through domains <em>and</em> direct-style concurrency through effect handlers (without syntactic support)</strong>.</p>
<ul>
<li>The <a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml">Domain mechanism</a> permits OCaml programmers to speed up OCaml code by taking advantage of parallel processing via multiple cores available on modern processors.
</li>
<li>Effect handlers allow OCaml programmers to write <a href="https://github.com/ocaml-multicore/eio">high-performance concurrent programs in direct-style</a>, without the use of monadic concurrency as is the case today with the Lwt and Async libraries. Effect handlers also serve as a useful abstraction to build other non-local control-flow abstractions such as <a href="https://github.com/ocaml-multicore/effects-examples/blob/master/generator.ml">generators</a>, <a href="https://github.com/ocaml-multicore/effects-examples/blob/master/sched.ml">lightweight threads</a>, etc. OCaml will be one of <a href="https://arxiv.org/abs/2104.00250">the first industrial-strength languages to support effect handlers</a>.
</li>
</ul>
<p>The new code will have to go through the usual rigorous review process of contributions to upstream OCaml, but we expect to advance the review process over the next few months.</p>
<h2>Recap: what are effect handlers?</h2>
<p>Below is an excerpt from <a href="https://arxiv.org/pdf/2104.00250.pdf">&quot;Retrofitting Effect Handlers onto OCaml&quot;</a>:</p>
<blockquote>
<p>Effect handlers provide a modular foundation for user-defined effects. The key idea is to separate the definition of the effectful operations from their interpretations, which are given by handlers of the effects. For example:</p>
<pre><code>effect In_line : in_channel -&gt; string
</code></pre>
<p>declares an effect <code>In_line</code>, which is parameterised with an input channel of type <code>in_channel</code>, which when performed returns a <code>string</code> value. A computation can perform the <code>In_line</code> effect without knowing how the <code>In_line</code> effect is implemented. This computation may be enclosed by different handlers that handle <code>In_line</code> differently. For example, <code>In_line</code> may be implemented by performing a blocking read on the input channel or performing the read asynchronously by offloading it to an event loop such as libuv, without changing the computation.</p>
<p>Thanks to the separation of effectful operations from their implementation, effect handlers enable new approaches to modular programming. Effect handlers are a generalisation of exception handlers, where, in addition to the effect being handled, the handler is provided with the delimited continuation of the perform site. This continuation may be used to resume the suspended computation later. This enables non-local control-flow mechanisms such as resumable exceptions, lightweight threads, coroutines, generators and asynchronous I/O to be composably expressed.</p>
</blockquote>
<p>The implementation of effect handlers in OCaml are <em>single-shot</em> -- that is, a continuation can be resumed only once, and must be explicitly discontinued if not used. This restriction makes for easier reasoning about control flow in the presence of mutable data structures, and also allows for a high performance implementation.</p>
<p>You can read more about effect handlers in OCaml in the <a href="https://arxiv.org/pdf/2104.00250.pdf">full paper</a>.</p>
<h2>Why is there no syntactic support for effect handlers in OCaml 5.0?</h2>
<p>Effect handlers currently in Multicore OCaml do not ensure <a href="https://arxiv.org/abs/2104.00250"><em>effect safety</em></a>. That is, the compiler will not ensure that all the effects performed by the program are handled. Instead, unhandled effects lead to exceptions at runtime. Since we plan to extend OCaml with support for an <a href="https://github.com/ocaml/subsystem-meetings/tree/main/effect_system/2021-09-30">effect system</a> in the future, OCaml 5.0 will not feature the syntactic support for programming with effect handlers. Instead, we expose the same features through functions from the standard library, reserving the syntax decisions for when the effect system  lands. The function based effect handlers is just as expressive as the current syntaxful version in Multicore OCaml. As an example, the syntax-free version of:</p>
<pre><code class="language-ocaml=">effect E : string 

let comp () =
  print_string &quot;0 &quot;;
  print_string (perform E);
  print_string &quot;3 &quot;
     
let main () = 
  try 
    comp () 
  with effect E k -&gt; 
    print_string &quot;1 &quot;; 
    continue k &quot;2 &quot;;  
    print_string “4 &quot; 
</code></pre>
<p>will be:</p>
<pre><code class="language-ocaml=">type _ eff += E : string eff
     
let comp () = 
  print_string &quot;0 &quot;; 
  print_string (perform E); 
  print_string &quot;3 &quot;
     
let main () =
  try_with comp () 
  { effc = fun e -&gt; 
      match e with 
      | E -&gt; Some (fun k -&gt;  
          print_string &quot;1 &quot;;
          continue k &quot;2 &quot;; 
          print_string “4 “)
      | e -&gt; None }
</code></pre>
<p>One can imagine writing a ppx extension that enable programmers to write code that is close to the earlier version.</p>
<h2>Which opam switch should I use today?</h2>
<p>The <code>4.12+domains</code> opam switch has <em>all</em> the features that will go into OCaml 5.0, including the effect-handlers-as-functions. The exact module under which the functions go will likely change by 5.0, but the basic form should remain the same.</p>
<p>The <code>4.12+domains+effects</code> opam switch will be preserved, but the syntax will not be upstreamed. This switch is mainly useful to try out the examples of OCaml effect handlers in the academic literature.</p>
<p>To learn more about programming using this effect system, see the <a href="https://github.com/ocaml-multicore/eio">eio</a> library and <a href="https://watch.ocaml.org/videos/watch/74ece0a8-380f-4e2a-bef5-c6bb9092be89">this recent talk</a>. In the next few weeks, the <code>eio</code> library will be ported to <code>4.12+domains</code> to use the function based effect handlers so that it is ready for OCaml 5.0.</p>
<h2>Onto the September 21 update</h2>
<p>A number of enhancements have been merged to improve the thread safety of the stdlib, improve the test suite coverage, along with the usual bug fixes. The documentation for the ecosystem projects has been updated for readabilty, grammar and consistency. The sandmark-nightly web service is currently being Dockerized to be deployed for visualising and analysing benchmark results. The Sandmark 2.0-beta branch is also released with the 2.0 features, and is available for testing and feedback.</p>
<p>We would like to acknowledge the following people for their contribution:</p>
<ul>
<li>@lingmar (Linnea Ingmar) for reporting a segmentation fault in 4.12.0+domains at <code>caml_shared_try_alloc</code>.
</li>
<li>@dhil (Daniel Hillerström) provided a patch to remove <code>drop_continuation</code> in the compiler sources.
</li>
<li>@nilsbecker (Nils Becker) reported a crash with 14 cores when using Task.pool management.
</li>
<li>@cjen1 (Chris Jensen) observed and used ulimit to fix a <code>Unix.ENOMEM</code> error when trying out the Eio README example.
</li>
<li>@anuragsoni (Anurag Soni) has contributed an async HTTP benchmark for <code>retro-httpaf-bench</code>.
</li>
</ul>
<p>As always, the Multicore OCaml updates are listed first, which are then followed by the updates from the ecosystem tools and libraries. The Sandmark-nightly work-in-progress and the Sandmark benchmarking tasks are finally listed for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Thread Safe</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/632">ocaml-multicore/ocaml-multicore#632</a>
<code>Str</code> module multi domain safety</p>
<p>The
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/635">PR#635</a>
makes <code>lib-str</code> domain safe to work concurrently with Multicore
OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/636">ocaml-multicore/ocaml-multicore#636</a>
Library building locks for thread-safe mutability</p>
<p>An open discussion on the possibility of creating two modules for
simple, mutable-state libraries that are thread-safe.</p>
</li>
</ul>
<h4>Segmentation Fault</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/639">ocaml-multicore/ocaml-multicore#639</a>
Segfaults in GC</p>
<p>An ongoing investigation on the segmentation fault caused at
<code>caml_shared_try_alloc</code> in 4.12.0+domains as reported by @lingmar
(Linnea Ingmar) .</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/646">ocaml-multicore/ocaml-multicore#646</a>
Coq segfaults during build</p>
<p>The Coq proof assistant results in a segmentation fault when run
with Multicore OCaml, and a new tarball has been provided for
testing.</p>
</li>
</ul>
<h4>Test Suite</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/640">ocaml-multicore/ocaml-multicore#640</a>
GitHub Actions for Windows</p>
<p>The GitHub Actions have been updated to run the Multicore OCaml test
suite on Windows.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/641">ocaml-multicore/ocaml-multicore#641</a>
Get the multicore testsuite runner to parity with stock OCaml</p>
<p>The Multicore disabled tests need to be reviewed to see if they can
be re-enabled, and also run them in parallel, similar to trunk.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/637">ocaml-multicore/ocaml-multicore#637</a>
<code>caml_page_table_lookup</code> is not available in ocaml-multicore</p>
<p>The <code>ancien</code> package uses <code>Is_in_heap_or_young</code> macro which
internally uses <code>caml_page_table_lookup</code> that is not implemented yet
in Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/653">ocaml-multicore/ocaml-multicore#653</a>
Drop <code>drop_continuation</code></p>
<p>A PR contributed by @dhil (Daniel Hillerström) to remove
<code>drop_continuation</code> since <code>clone_continuation</code> has also been
removed.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/631">ocaml-multicore/ocaml-multicore#631</a>
Don't raise asynchronous exceptions from signals in <code>caml_alloc</code> C functions</p>
<p>A PR that prevents asynchronous exceptions being raised from signal
handlers, and avoids polling for pending signals from <code>caml_alloc_*</code>
calls from C.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/638">ocaml-multicore/ocaml-multicore#638</a>
Add some injectivity annotations to the standard library</p>
<p>The injectivity annotations have been backported to <code>stdlib</code> from
4.12.0 in order to compile <code>stdcompat</code> with Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/642">ocaml-multicore/ocaml-multicore#642</a>
Remove the remanents of page table functionality</p>
<p>Page tables are not used in Multicore OCaml, and the respective
macro and function definitions have been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/643">ocaml-multicore/ocaml-multicore#643</a>
<code>Core_kernel</code> minor words report are off</p>
<p>The report of allocated words are skewed because the <code>young_ptr</code> and
<code>young_end</code> are defined as <code>char *</code>. The PR to change them to <code>value *</code> has now been merged.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/652">ocaml-multicore/ocaml-multicore#652</a>
Make <code>young_start/end/ptr</code> pointers to value</p>
<p>The <code>young_start</code>, <code>young_end</code>, and <code>young_ptr</code> use in Multicore
OCaml has been updated to <code>value *</code> instead of <code>char *</code> to align
with trunk.</p>
</li>
</ul>
<h4>Backports</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/573">ocaml-multicore/ocaml-multicore#573</a>
Backport trunk safepoints PR to multicore</p>
<p>The Safepoints implementation has now been backported to Multicore
OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/644">ocaml-multicore/ocaml-multicore#644</a>
Minor fixes</p>
<p>A patch that replaces the deprecated macro <code>Modify</code> with
<code>caml_modify</code>, and adds reference to <code>caml_alloc_float_array</code> in
<code>runtime/caml/alloc.h</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/649">ocaml-multicore/ocaml-multicore#649</a>
Integrate all of trunk's EINTR fixes</p>
<p>The fixes for EINTR-based signals from
<a href="https://github.com/ocaml/ocaml/pull/9722">ocaml/ocaml#9722</a> have
been incorporated into Multicore OCaml.</p>
</li>
</ul>
<h4>Thread Safe</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/630">ocaml-multicore/ocaml-multicore#630</a>
Make signals safe for Multicore</p>
<p>The signals implementation has been overhauled in Multicore OCaml
with clear and correct semantics.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/635">ocaml-multicore/ocaml-multicore#635</a>
Make <code>lib-str</code> domain safe</p>
<p>The PR moves the use of global variables in <code>str</code> to thread local
storage. A test case that does <code>str</code> computations in parallel has
also been added.</p>
</li>
</ul>
<h4>Effect Handlers</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/650">ocaml-multicore/ocaml-multicore#650</a>
Add primitives necessary for exposing effect handlers as functions</p>
<p>The inclusion of primitives to facilitate updates to <code>4.12+domains</code>
to continue to work with changes from <code>4.12+domains+effects</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/651">ocaml-multicore/ocaml-multicore#651</a>
Expose deep and shallow handlers as functions</p>
<p>The PR exposes deep and shallow handlers as functions in the Obj
module. It also removes the ability to clone continuations.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/633">ocaml-multicore/ocaml-multicore#633</a>
Error building 4.12.0+domains with <code>no-flat-float-arrays</code></p>
<p>The linker error has been fixed in
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/644">PR#644</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/647">ocaml-multicore/ocaml-multicore#647</a>
Improving Multicore's issue template</p>
<p>The Multicore OCaml bug report template has been improved with
sections for <code>Describe the issue</code>, <code>To reproduce</code>, <code>Multicore OCaml build version</code>, <code>Did you try running it with the debug runtime and heap verificiation ON?</code>, and <code>Backtrace</code>.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h5>Ongoing</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/43">ocaml-multicore/domainslib#43</a>
Possible bug in <code>Task.pool</code> management</p>
<p>A segmentation fault on Task.pool management when using 14 cores as
reported by @nilsbecker (Nils Becker).</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/59">ocaml-multicore/multicore-opam#59</a>
Fix batteries after ocaml-multicore/ocaml-multicore#514</p>
<p>Update the <code>batteries.3.3.0+multicore</code> opam file for
<code>batteries-included</code> with the correct src URL.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/issues/60">ocaml-multicore/multicore-opam#60</a>
Multicore domains+effects language server does not work with VS Code</p>
<p>A <code>Request textDocument/hover failed</code> error shows up with VS Code
when using Multicore domains+effects language server.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/issues/81">ocaml-multicore/eio#81</a>
Is IO prioritisation possible?</p>
<p>A query on IO prioritisation and on scheduling of fibres for
consensus systems.</p>
</li>
</ul>
<h5>Completed</h5>
<h6>Build</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools/pull/3">ocaml-multicore/eventlog-tools</a>
Use ocaml/setup-ocaml@v2</p>
<p>The GitHub workflows have now been updated to use 4.12.x
ocaml-compiler and <code>ocaml/setup-ocaml@v2</code> in
<code>.github/workflows/main.yml</code> file.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/3">ocaml-multicore/tezos#3</a>
Add cron job and run tests</p>
<p>The CI Dockerfile and GitHub workflows have been changed to run the
tests periodically for Tezos on Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/tezos/pull/4">ocaml-multicore/tezos#4</a>
Run cronjob daily</p>
<p>The GitHub cronjob is now scheduled to run daily for the Tezos
builds from scratch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/issues/12">ocaml-multicore/retro-httpaf-bench#12</a>
Dockerfile fails to build</p>
<p>The issue no longer exists, and the Dockerfile now builds fine in
the CI as well.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/issues/80">ocaml-multicore/eio#80</a>
ENOMEM with README example</p>
<p>@cjen1 (Chris Jensen) reported a <code>Unix.ENOMEM</code> error that prevented
the following README example code snippet from execution. Using
<code>ulimit</code> with the a smaller memory size fixes the same.</p>
<pre><code>#require &quot;eio_main&quot;;;
open Eio.Std;;

let main ~stdout = Eio.Flow.copy_string &quot;hello World&quot; stdout
Eio_main.run @@ fun env -&gt; main ~stdout:(Eio.Stdenv.stdout env)
;;
</code></pre>
</li>
</ul>
<h6>Documentation</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/10">ocaml-multicore/parallel-programming-in-multicore-ocaml#10</a>
Edited for flow/syntax/consistency</p>
<p>The Parallel Programming in Multicore OCaml chapter has been
reviewed and updated for consistency, syntax flow and readability.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/79">ocaml-multicore/eio#79</a>
Initial edits for consistency, formatting and clarity</p>
<p>The README in the Eio project has been updated for consistency,
formatting and readability.</p>
</li>
<li>
<p>The <a href="https://github.com/ocaml-multicore/multicore-talks/tree/master/ocaml2020-workshop-parallel">ocaml2020-workshop-parallel</a>
README has been updated with reference links to books, videos,
project repository, and the OCaml Multicore wiki.</p>
</li>
</ul>
<h6>Benchmarks</h6>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/15">ocaml-multicore/retro-httpaf-bench#15</a>
Optimise Go code</p>
<p>The <code>nethttp-go/httpserv.go</code> Go benchmark now uses <code>Write</code> instead
of <code>fmt.Fprintf</code> with removal of yield() for optimization.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/16">ocaml-multicore/retro-httpaf-bench</a>
Add an async HTTP benchmark</p>
<p>@anuragsoni (Anurag Soni) has contributed an async HTTP benchmark
that was run inside Docker on a 4-core i7-8559 CPU at 2.70 GHz with
1000 connections and 60 second runs.</p>
<p><img src="upload://8VMquoc8s1vHUZQWbmHDiFQuiCI.jpeg" alt="retro-httpaf-bench-16-performance|690x460" /></p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Sandmark-nightly</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/10">ocaml-bench/sandmark-nightly#10</a>
Dockerize sandmark-nightly</p>
<p>The sandmark-nightly service needs to be dockerized to be able to
run on multiple machines.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/11">ocaml-bench/sandmark-nightly#11</a>
Refactor the sandmark-nightly notebooks</p>
<p>The code in the sandmark-nightly notebooks need to be refactored and
modularized so that they can be reused as a library.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/12">ocaml-bench/sandmark-nightly#12</a>
Normalization graphs (with greater than two benchmarks) needs to be fixed</p>
<p>The normalization graphs only produce one coloured bar group even if
there are more than two benchmarks. It needs to show more than one
coloured graph when compared with the baseline.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/13">ocaml-bench/sandmark-nightly#13</a>
Store the logs from the nightly runs along with the results</p>
<p>The nightly run logs can be stored as they are useful for debugging
any failures.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/14">ocaml-bench/sandmark-nightly#14</a>
Add <code>best-fit</code> variant to sequential benchmarks</p>
<p>The sandmark-nightly runs should include the best-fit allocator as
it is better than the next-fit allocator. The best-fit allocator can
be enabled using the following command:</p>
<pre><code>$ OCAMLRUNPARAM=&quot;a=2&quot; ./a.out
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/16">ocaml-bench/sandmark-nightly#16</a>
Cubicle and Coq benchmarks are missing from the latest navajo nightly runs</p>
<p>The UI for the sequential benchmarks fail to load normalized graphs
because of missing Cubicle and Coq benchmark .bench files.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/17">ocaml-bench/sandmark-nightly#17</a>
Navajo runs are on stale Sandmark</p>
<p>The Sandmark deployed on navajo needs to be updated to the latest
Sandmark, and the <code>git pull</code> is failing due to uncommitted changes
to the Makefile.</p>
</li>
</ul>
<h3>Sandmark</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/248">ocaml-bench/sandmark#248</a>
Coq fails to build</p>
<p>A new Coq tarball to build with Multicore OCaml is now available for
testing at
<a href="https://github.com/ejgallego/coq/releases/tag/multicore-2021-09-24">coq-multicore-2021-09-24</a>.</p>
</li>
<li>
<p>Sandmark <code>2.0-beta</code></p>
<p>The Sandmark
<a href="https://github.com/ocaml-bench/sandmark/tree/2.0-beta">2.0-beta</a>
branch is now available for testing. It includes new features such
as package override option, adding meta-information to the benchmark
results, running multiple iterations, classification of benchmarks,
user configuration, and simplifies package dependency
management. You can test the branch for the following OCaml compiler
variants:</p>
<ul>
<li>4.12.0+domains
</li>
<li>4.12.0+stock
</li>
<li>4.14.0+trunk
</li>
</ul>
<pre><code>$ git clone https://github.com/ocaml-bench/sandmark.github
$ cd sandmark
$ git checkout 2.0-beta
  
$ make clean; TAG='&quot;run_in_ci&quot;' make run_config_filtered.json
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.12.0+domains.bench

$ make clean; TAG='&quot;run_in_ci&quot;' make run_config_filtered.json
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.12.0+stock.bench

$ make clean; TAG='&quot;run_in_ci&quot;' make run_config_filtered.json
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.14.0+trunk.bench

$ make clean; TAG='&quot;macro_bench&quot;' make multicore_parallel_run_config_filtered.json
$ RUN_BENCH_TARGET=run_orunchrt BUILD_BENCH_TARGET=multibench_parallel RUN_CONFIG_JSON=multicore_parallel_run_config_filtered.json make ocaml-versions/4.12.0+domains.bench
</code></pre>
<p>Please report any issues that you face in our <a href="https://github.com/ocaml-bench/sandmark/issues">GitHub
project</a> page.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/251">ocaml-bench/sandmark#251</a>
Update dependencies to work with <code>4.14.0+trunk</code></p>
<p>The Sandmark master branch dependencies have now been updated to
build with 4.14.0+trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/253">ocaml-bench/sandmark#253</a>
Remove <code>Domain.Sync.poll()</code> from parallel benchmarks</p>
<p>The Domain.Sync.poll() function call is now deprecated and the same
has been removed from the parallel benchmarks in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/254">ocaml-bench/sandmark#254</a>
Disable sandboxing</p>
<p>The <code>--disable-sandboxing</code> option is now passed as default to opam
when setting up the local <code>_opam</code> directory for Sandmark builds.</p>
</li>
</ul>
<p>We would like to thank all the OCaml users, developers and contributors in the community for their continued support to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>CI: Continuous Integration
</li>
<li>CPU: Central Processing Unit
</li>
<li>GC: Garbage Collector
</li>
<li>HTTP: Hypertext Transfer Protocol
</li>
<li>IO: Input/Output
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>UI: User Interface
</li>
<li>URL: Uniform Resource Locator
</li>
<li>VS: Visual Studio
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - August 2021|js}
  ; slug = {js|multicore-2021-08|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-08-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<h1>Multicore OCaml: August 2021</h1>
<p>Welcome to the August 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! The following update and the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by me, @ctk21, @kayceesrk and @shakthimaan. This month's update is a bit quieter as August is also a period of downtime in Europe (and our crew in India also took well-deserved time off), but we all participated in the <a href="https://discuss.ocaml.org/t/ocaml-workshop-2021-live-stream/8366">online OCaml Workshop</a> which was held virtually this year, so there are plenty of videos to watch!</p>
<p>The multicore effort is all on track for integration into OCaml 5.0 early next year, with the core team currently organising the upstreaming code review strategy over the coming winter months.  Meanwhile, there are some blog posts and videos from the OCaml Workshop which give more detailed updates on both domains-parallelism and effects.</p>
<ul>
<li><strong>Adapting the OCaml ecosystem for Multicore OCaml</strong>
<ul>
<li><em>This talk covers how our community can adapt to the forthcoming OCaml 5.0 with parallelism.</em>
</li>
<li><a href="http://segfault.systems/blog/2021/adapting-to-multicore/">Blog post 1</a>, <a href="https://tarides.com/blog/2021-08-26-tarides-engineers-to-present-at-icfp-2021">Blog post 2</a>
</li>
<li><a href="https://watch.ocaml.org/videos/watch/629b89a8-bbd5-490d-98b0-d0c740912b02">Video</a>
</li>
</ul>
</li>
<li><strong>Parafuzz coverage guided Property Fuzzing for Multicore OCaml programs</strong>
<ul>
<li><em>We develop ParaFuzz, an input and concurrency fuzzing tool for Multicore OCaml programs. ParaFuzz builds on top of Crowbar which combines AFL-based grey box fuzzing with QuickCheck and extends it to handle parallelism.</em>
</li>
<li><a href="https://watch.ocaml.org/videos/watch/c0d591e0-91c9-4eaa-a4d7-c4f514de0a57">Video</a>
</li>
</ul>
</li>
<li><strong>Experiences with Effects</strong>
<ul>
<li><em>The multicore branch of OCaml adds support for effect handlers. In this talk, we report our experiences with effects, both from converting existing code, and from writing new code.</em>
</li>
<li><a href="https://watch.ocaml.org/videos/watch/74ece0a8-380f-4e2a-bef5-c6bb9092be89">Video</a>
</li>
</ul>
</li>
</ul>
<p>As always, the Multicore OCaml updates are listed first, which are then followed by the updates from the Ecosystem libraries and Sandmark benchmarking.</p>
<h2>Multicore OCaml</h2>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/632">ocaml-multicore/ocaml-multicore#632</a>
Str module multi domain safety</p>
<p>An issue on stdlib safety in the OCaml <code>Str</code> module to work
concurrently with Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/633">ocaml-multicore/ocaml-multicore#633</a>
Error building 4.12.0+domains with no-flat-float-arrays</p>
<p>A linker error observed by <code>Adrián Montesinos González</code> (<code>debugnik</code>)
when installing 4.12.0+domains <code>no-flat-float-arrays</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/634">ocaml-multicore/ocaml-multicore#634</a>
Strange type errors from merlin (This expression has type string/1)</p>
<p>Type errors reported from merlin (4.3.1-412) when using the effects
version of the Multicore OCaml compiler.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/624">ocaml-multicore/ocaml-multicore#624</a>
core v0.14: test triggers a segfault in the GC</p>
<p>The root cause of the segfault when running <code>core.v0.14</code> test suite
with Multicore OCaml 4.12.0+domains has been identified.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/573">ocaml-multicore/ocaml-multicore#573</a>
Backport trunk safepoints PR to multicore</p>
<p>This is an on-going effort to backport the Safepoints implementation to Multicore OCaml.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/10">ocaml-multicore/parallel-programming-in-multicore-ocaml#10</a>
Edited for flow/syntax/consistency</p>
<p>The Parallel Programming in Multicore OCaml chapter has been updated
for consistency, syntax flow and grammar.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/15">ocaml-multicore/retro-httpaf-bench#15</a>
Optimise Go code</p>
<p>The <code>nethttp-go/httpserv.go</code> benchmark has been optimised with use
of <code>Write</code> instead of <code>fmt.Fprintf</code>, and the removal of yield().</p>
<p><img src="upload://ahnwQrxkI8nIDpMurnoayzdJmA6.png" alt="retro-httpaf-bench-go-optimise|411x266" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/issues/37">ocaml-multicore/ocaml-uring#37</a>
<code>poll_add</code> test hangs on s390x</p>
<p>The use of <code>poll_add</code> causes a hang on <code>s390x</code> architecture. A
backtrace with GDB is provided for reference:</p>
<pre><code>(gdb) bt
 #0  0x000003ffb63ec01e in __GI___libc_write (nbytes=&lt;optimized out&gt;, buf=&lt;optimized out&gt;, fd=&lt;optimized out&gt;)
     at ../sysdeps/unix/sysv/linux/write.c:26
 #1  __GI___libc_write (fd=&lt;optimized out&gt;, buf=0x3ffffdee8e0, nbytes=1) at ../sysdeps/unix/sysv/linux/write.c:24
 #2  0x000002aa0dbb0ca2 in unix_write (fd=&lt;optimized out&gt;, buf=&lt;optimized out&gt;, vofs=&lt;optimized out&gt;, vlen=&lt;optimized out&gt;) at write.c:44
 #3  0x000002aa0dbd4d3a in caml_c_call ()
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/37">ocaml-multicore/domainslib#37</a>
parallel_map</p>
<p>@UnixJunkie has provided a simplified version for the interface for
scientific parallel programming as recommended by the parany library.</p>
<pre><code>val run:
?csize:int -&gt;
~nprocs: int -&gt;
demux:(unit -&gt; 'a) -&gt;
work:('a -&gt; 'b) -&gt;
mux:('b -&gt; unit) -&gt; unit
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/39">ocaml-multicore/domainslib#39</a>
Add a fast path in parallel scan</p>
<p>A patch that performs a sequential scan when the number of elements
is less than or equal to the pool size or if the number of domains
is one.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/40">ocaml-multicore/domainslib#40</a>
Parallel map</p>
<p>A PR that implements <code>parallel_map</code> in lib/task.ml that includes an
optional chunk size parameter.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/13">ocaml-multicore/retro-httpaf-bench#13</a>
Update EIO for performance improvements, multiple domains</p>
<p><code>httpf-eio</code> has been enhanced with performance improvements when
running with multiple domains. The results on an 8-core VM with 100
connections and 5 second runs is shown below:</p>
<p><img src="upload://9IoQWI68Xo8X2mKXXrfkNzXq2Oe.png" alt="retro-httpaf-bench-100-connections-5-seconds|411x262" /></p>
<p>The following illustration is from a VM for 1000 connections and 60
second runs:</p>
<p><img src="upload://5Lpf7h5AJtnPSwCT4Nox7OGkIYM.png" alt="retro-httpaf-bench-1000-connections-60-seconds|401x262" /></p>
<p>The results with <code>GOMAXPROCS=3</code> for three OCaml domains is as follows:</p>
<p><img src="upload://lr7ngwNK8tRa5Z5zKlrcY2DmrJ2.png" alt="retro-httpaf-bench-three-domains-15|411x262" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/36">ocaml-multicore/ocaml-uring#36</a>
Update to cstruct 6.0.1</p>
<p><code>ocaml-uring</code> now uses <code>Cstruct.shiftv</code> and has been updated to use cstruct.6.0.1.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/41">ocaml-multicore/domainslib#41</a>
Use the master branch in the link to usage examples</p>
<p>The README.md file has been updated to point to the sample programs in the master branch that use the new <code>num_additional_domains</code> argument label.</p>
</li>
<li>
<p>The Multicore OCaml concurrency bug detection tool named  <a href="https://github.com/ocaml-multicore/parafuzz">ParaFuzz</a> is now available in GitHub as Free/Libre and Open Source Software.</p>
</li>
<li>
<p>Tezos is a proof-of-stake distributed consensus platform designed to evolve, and is written in OCaml. The version of the <a href="https://github.com/ocaml-multicore/tezos">Tezos</a> daemon that now runs on Multicore OCaml is also available in GitHub as a work-in-progress fork.</p>
</li>
</ul>
<h4>Eio</h4>
<p>The <code>eio</code> library provides an effects-based parallel IO stack for
Multicore OCaml.</p>
<h5>Completed</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/68">ocaml-multicore/eio#68</a>
Add eio_luv backend</p>
<p>We now use <code>luv</code>, which has OCaml/Reason bindings to libuv, to
provide a cross-platform default backend for eio.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/72">ocaml-multicore/eio#72</a>
Add non-deterministic to abstract domain socket test</p>
<p>The inclusion of <code>non-deterministic=command</code> to disable a regular
<code>dune runtest</code> for the failing abstract domain socket test.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/73">ocaml-multicore/eio#73</a>
Work-around for <code>io_uring</code> bug reading from terminals</p>
<p>A work-around to fix <code>IORING_OP_READ</code> that causes <code>io_uring_enter</code>
to block the entire process when reading from a terminal.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/74">ocaml-multicore/eio#74</a>
Don't crash when receiving a signal</p>
<p>A patch to receive a signal and not crash in
<code>lib_eio_linux/eio_linux.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/75">ocaml-multicore/eio#75</a>
Add Eio.Stream</p>
<p>The <code>Stream</code> module has been added to Eio that implements bounded
queues with cancellation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/76">ocaml-multicore/eio#76</a>
Link to some eio examples</p>
<p>The README.md has been updated to point to existing eio example
project sources.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/77">ocaml-multicore/eio#77</a>
Disable opam file generation due to dune bug</p>
<p>The opam file generation with dune.2.9.0 is broken as dune does not
have the <code>subst --root</code> option. Hence, the same is now disabled in
the eio build steps.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/79">ocaml-multicore/eio#79</a>
Initial edits for consistency, formatting and clarity</p>
<p>Changes in the README.md file for consistency, syntax formatting and
for clarity.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Sandmark</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/251">ocaml-bench/sandmark#251</a><br />
Update dependencies to work with 4.14.0+trunk</p>
<p>A series of patches that update the dependencies in Sandmark to
build 4.14.0+trunk with dune.2.9.0.</p>
</li>
<li>
<p>We are continuing to integrate and test building of 4.12.0 OCaml
variants with Sandmark-2.0 with <code>current-bench</code> for both sequential
and parallel benchmarks.</p>
</li>
</ul>
<p>Our thanks to all the OCaml users, developers and contributors in the
community for their valuable time and support to the project. Stay
safe!</p>
<h2>Acronyms</h2>
<ul>
<li>GC: Garbage Collector
</li>
<li>GDB: GNU Project Debugger
</li>
<li>HTTP: Hypertext Transfer Protocol
</li>
<li>ICFP: International Conference on Functional Programming
</li>
<li>IO: Input/Output
</li>
<li>PR: Pull Request
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>VM: Virtual Machine
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - July 2021|js}
  ; slug = {js|multicore-2021-07|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-07-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the July 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> has been compiled by me, @ctk21, @kayceesrk and @shakthimaan. As August is usually a period of downtime in Europe, the next update may be merged with the September one in a couple of months (but given our geographically diverse nature now, if enough progress happens in August I'll do an update).</p>
<p>The overall status of the multicore efforts are right on track: our contributions to the next OCaml release have been <a href="https://discuss.ocaml.org/t/ocaml-4-13-0-second-alpha-release/8164">incorporated in 4.13.0~alpha2</a>, and our focus remains on crushing incompatibilities and bugs to generate domains-only parallelism patches suitable for upstream review and release.  As a lower priority activity, we continue to develop the experimental &quot;effects-based&quot; IO stack, which will feature in the upcoming virtual OCaml Workshop at ICFP in August 2021.</p>
<p>The <code>4.12.0+domains</code> trees continue to see a tail of bugs being steadily fixed. After last month's call, we saw a number of external contributors step up to submit fixes in addition to the multicore and core OCaml teams. We would like to acknowledge and thank them!</p>
<ul>
<li>@emillon (Etienne Millon) for running the Jane Street <code>core</code> v0.14 test suite with 4.12.0+domains and sharing the test results (and finding a <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/624">multicore GC edge case bug</a> while at it).
</li>
<li>@Termina1 (Vyacheslav Shebanov) for testing the compilation of <code>batteries</code> 3.30 with Multicore OCaml 4.12.0+domains.
</li>
<li>@nbecker (Nils Becker) for reporting on <code>parallel_map</code> and <code>parallel_scan</code> for domainslib.
</li>
<li>Filip Koprivec for identifying a memory leak when using <code>flush_all</code> with <code>ocamlc</code> with 4.12.0+domains.
</li>
</ul>
<p>All of these fixes, combined with some big-ticket compatibility changes (listed below) are getting me pretty close to using 4.12.0+domains as my daily OCaml opam switch of choice. I encourage you to also give it a try and report (good or bad) results on <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues">the multicore OCaml tracker</a>.  If these sorts of problems grab your attention, then <a href="https://segfault.systems/careers.html">Segfault Systems is hiring in India</a> to work with @kayceesrk and the team there on multicore OCaml.</p>
<p>For benchmarking, the Jupyter notebooks for the Sandmark nightly benchmark runs have  been updated, and we continue to test the Sandmark builds for the  4.12+ variants and 4.14.0+trunk. Progress has been made to integrate  <code>current-bench</code> OCurrent pipeline with the Sandmark 2.0 -alpha branch  changes to reproduce the current Sandmark functionality, which will allow GitHub PRs to be benchmarked systematically before being merged.</p>
<p>As always, the Multicore OCaml ongoing and completed tasks are listed first, which are then followed by the updates from the Ecosystem libraries. The Sandmark nightly build efforts, benchmarking updates and relevant current-bench tasks are then mentioned. Finally, the update on the upstream OCaml Safepoints PR is provided for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>CI Compatibility</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/602">ocaml-multicore/ocaml-multicore#602</a>
Inclusion of most of OCaml headers results in requiring pthread</p>
<p>The inclusion of multiple nested header files requires <code>pthread</code> and
the <code>decompress</code> testsuite fails.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/607">ocaml-multicore/ocaml-multicore#607</a>
<code>caml_young_end</code> is not a <code>value *</code> anymore</p>
<p>An inconsistency observed in the CI where <code>caml_young_end</code> is now a
<code>char *</code> instead of <code>value *</code>.</p>
</li>
</ul>
<h4>Crashes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/608">ocaml-multicore/ocaml-multicore#608</a>
Parmap testsuite crash</p>
<p><code>Parmap</code> is causing a segfault when its testsuite is run against
Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/611">ocaml-multicore/ocaml-multicore#611</a>
Crash running Multicore binary under AFL</p>
<p>The <code>bun</code> package crashes with Multicore OCaml 4.12+domains, but,
builds fine on 4.12.</p>
</li>
</ul>
<h4>Package Builds</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/609">ocaml-multicore/ocaml-multicore#609</a>
lablgtk's example segfaults</p>
<p>An ongoing effort to compile lablgtk with OCaml and Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/624">ocaml-multicore/ocaml-multicore#624</a>
core v0.14: test triggers a segfault in the GC</p>
<p>A segfault caused by running <code>core.v0.14</code> test suite with Multicore
OCaml 4.12.0+domains as reported by @emillon.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/625">ocaml-multicore/ocaml-multicore#625</a>
Cannot compile batteries on OCaml Multicore 4.12.0+domains</p>
<p>An effort by Vyacheslav Shebanov (@Termina1) to compile
<code>batteries.3.30</code> with Multicore OCaml 4.12.0+domains variant.</p>
</li>
</ul>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/573">ocaml-multicore/ocaml-multicore#573</a>
Backport trunk safepoints PR to multicore</p>
<p>The Safepoints implementation is being backported to Multicore
OCaml. The initial test results of running Sandmark on a large Xen2
box are shown below:</p>
</li>
</ul>
<p><img src="upload://irThoi4RbupKLP9YOqiDuCHehA1.png" alt="OCaml-Multicore-PR-573-Time|458x500" />
<img src="upload://bJSpY5klM9MvO4sUrPJ3YD6463I.png" alt="OCaml-Multicore-PR-573-Speedup|458x500" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/617">ocaml-multicore/ocaml-multicore#617</a>
Some of the compatibility macros are not placed in the same headers as in upstream OCaml</p>
<p>The introduction of a compatibility layer for GC statistics need to
be consistent with trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/618">ocaml-multicore/ocaml-multicore#618</a>
Review io.c for thread-safety and add parallel tests</p>
<p>The thread-safety fixes in io.c requires a review and additional
tests need to be added for the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/623">ocaml-multicore/ocaml-multicore#623</a>
Exposing <code>caml_channel_mutex_*</code> hooks</p>
<p>A draft PR to support <code>caml_channel_mutex_*</code> interfaces from trunk
to Multicore OCaml.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/610">ocaml-multicore/ocaml-multicore#610</a>
Add std gnu11 common cflags</p>
<p>The configure.ac file has been updated to use <code>-std=gnu11</code> in
<code>common_cflags</code> for both GCC and Clang.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/614">ocaml-multicore/ocaml-multicore#614</a>
Destroy channel mutexes after fork</p>
<p>A discussion on resetting and reinitializing mutexes after fork in
the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/616">ocaml-multicore/ocaml-multicore#616</a>
Expose functions to program with effects</p>
<p>A draft PR to enable programmers to write programs that use effects
without explicitly using the effect syntax.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/619">ocaml-multicore/ocaml-multicore#619</a>
Set resource Limit</p>
<p>A query to use <code>setrlimit</code> in Multicore OCaml, similiar, to
<code>Core.Unix.RLimit.set</code> from Jane Street's core library.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Enhancements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/601">ocaml-multicore/ocaml-multicore#601</a>
Domain better participants</p>
<p>The <code>0(n_running_domains)</code> from domain creation and the iterations
<code>0(Max_domains)</code> from STW signalling have been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/605">ocaml-multicore/ocaml-multicore#605</a>
Eventog event for condition wait</p>
<p>A new event has been added to indicate when a domain is blocked at
<code>Condition.wait</code>. This is useful for debugging any imbalance in task
distribution in domainslib.</p>
</li>
</ul>
<p><img src="upload://7CXMmjUbwuXqGtffNyfeo5B5Gd8.png" alt="OCaml-Multicore-PR-605-Illustration|536x500" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/615">ocaml-multicore/ocaml-multicore#615</a>
make depend</p>
<p>Updated <code>stdlib/.depend</code> to cover the recent developments in stdlib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/626">ocaml-multicore/ocaml-multicore#626</a>
Add Obj.drop_continuation</p>
<p>Added a <code>caml_drop_continuation</code> primitive to <code>runtime/fiber.c</code> to
prevent leaks with leftover continuations.</p>
</li>
</ul>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/584">ocaml-multicore/ocaml-multicore#584</a>
Modernise signal handling</p>
<p>The Multicore OCaml signals implementation is now closer to that of
upstream OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/600">ocaml-multicore/ocaml-multicore#600</a>
Expose a few more GC variables in headers</p>
<p>The <code>caml_young_start</code>, <code>caml_young_limit</code> and <code>caml_minor_heap_wsz</code>
variables have now been defined in the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/612">ocaml-multicore/ocaml-multicore#612</a>
Make intern and extern work with Multicore</p>
<p>The upstream changes to intern and extern have now been incorporated
to work with the Multicore OCaml runtime.</p>
</li>
</ul>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/604">ocaml-multicore/ocaml-multicore$604</a>
Fix unguarded <code>caml_skiplist_empty</code> in <code>caml_scan_global_young_roots</code></p>
<p>A patch that fixes a locking bug with global roots observed on a Mac
OS CI with <code>parallel/join.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/621">ocaml-multicore/ocaml-multicore#621</a>
otherlibs: <code>encode_terminal_status</code> does not set all fields</p>
<p>A minor fix for the error caused when moved from using
<code>caml_initialize_field</code> to <code>caml_initialize</code> in otherlibs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/628">ocaml-multicore/ocaml-multicore#628</a>
In link_channel, channel-&gt;prev should be set to NULL</p>
<p>A PR to fix the memory leak when using <code>flush_all</code> with <code>ocamlc</code> as
reported by Filip Koprivec.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/629">ocaml-multicore/ocaml-multicore#629</a>
Backtrace last exn is val unit</p>
<p>A fix for the crash reported on running core's test suite by
clearing <code>backtrace_last_exn</code> to <code>Val_unit</code> in
<code>runtime/backtrace.c</code>.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/36">ocaml-multicore/ocaml-uring#36</a>
Update to cstruct 6.0.1</p>
<p>ocaml-uring is now updated to use <code>Cstruct.shiftv</code> with the upgrade
to cstruct.6.0.1.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/37">ocaml-multicore/domainslib#37</a>
parallel_map</p>
<p>A request by @nbecker to provide a <code>parallel_map</code> function over
arrays having the following signature:</p>
<pre><code>val parallel_map : Domainslib.Task.pool -&gt; ('a -&gt; 'b) -&gt; 'a array -&gt; 'b array
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/38">ocaml-multicore/domainslib#38</a>
parallel_scan rejects arrays not larger than pool size</p>
<p>An &quot;index out of bounds&quot; exception is thrown for
<code>Task.parallel_scan</code> with arrays not larger than the pool size as
reported by @nbecker.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools/pull/4">ocaml-multicore/eventlog-tools#4</a>
Add <code>domain/condition_wait</code> event</p>
<p>The <code>lib/consts.ml</code> file in eventlog-tools now includes the
<code>domain/condition_wait</code> event.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/34">ocaml-multicore/domainslib#34</a>
Fix initial value accounting in <code>parallel_for_reduce</code></p>
<p>The initial value of <code>parallel_for_reduce</code> has been fixed so as to
not be accounted multiple times.</p>
</li>
</ul>
<h4>Eio</h4>
<p>The <code>eio</code> library provides an effects-based parallel IO stack for
Multicore OCaml.</p>
<h5>Ongoing</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/68">ocaml-multicore/eio#68</a>
WIP: Add eio_luv backend</p>
<p>A work-in-progress to use <code>luv</code> that provides OCaml/Reason bindings
to libuv for a cross-platform backend for eio.</p>
</li>
</ul>
<h5>Completed</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/62">ocaml-multicore/eio#62</a>
Update to latest MDX to fix exception reporting</p>
<p>Dune has been updated to 2.9 along with necessary changes for
exception reporting with MDX.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/63">ocaml-multicore/eio#63</a>
Update README</p>
<p>A documentation update specifying the following steps required to
manually pin the effects version of <code>ppxlib</code> and
<code>ocaml-migrate-parsetree</code>.</p>
<pre><code>opam switch create 4.12.0+domains+effects --repositories=multicore=git+https://github.com/ocaml-multicore/multicore-opam.git,default
opam pin add -yn ppxlib 0.22.0+effect-syntax
opam pin add -yn ocaml-migrate-parsetree 2.1.0+effect-syntax
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/64">ocaml-multicore/eio#64</a>
Improvements to traceln</p>
<p>Enhancements to <code>traceln</code> to make it an Effect along with changes to
trace output and addition of tests.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/65">ocaml-multicore/eio#65</a>
Add Flow.read_methods for optimised reading</p>
<p>The addition of <code>read_methods</code> in the <code>Flow</code> module as a faster
alternative to reading into a buffer.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/66">ocaml-multicore/eio#66</a>
Allow cancelling waiting for a semaphore</p>
<p>Update to <code>lib_eio/semaphore.ml</code> to allow cancel waiting for a
semaphore.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/67">ocaml-multicore/eio#67</a>
Add more generic exceptions</p>
<p>The inclusion of generic exceptions to avoid depending on
backend-specific exceptions. The tests have also been updated.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Sandmark Nightly</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/4">ocaml-bench/sandmark-nightly#4</a>
Parallel notebook pausetimes graphing for navajo results throws an error</p>
<p>The parallel Jupyter notebook for pausetimes throws a ValueError
that needs to be investigated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/5">ocaml-bench/sandmark-nightly#5</a>
Status of disabled benchmarks</p>
<p>The <code>alt-ergo</code>, <code>frama-c</code>, and <code>js_of_ocaml</code> benchmark results that
were disabled from the Jupyter notebooks have to be tested with
recent versions of Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/6">ocaml-bench/sandmark-nightly#6</a>
Parallel scalability number on navajo look odd</p>
<p>The parallel performance numbers on the navajo build server for
scalability will need to be reviewed and the experiments repeated
and validated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/7">ocaml-bench/sandmark-nightly#7</a>
Use <code>col_wrap</code> as 3 instead of 5 in the normalised results in parallel notebook</p>
<p>For better readability, it is recommended to use col_wrap as 3 in
the normalised results in the parallel notebook.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/8">ocaml-bench/sandmark-nightly#8</a>
View results for a set of benchmarks in the nightly notebooks</p>
<p>A feature request to filter benchmarks by name or by tags when used
with Jupyter notebooks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/9">ocaml-bench/sandmark-nightly#9</a>
Static HTML pages for the recent results</p>
<p>The benchmark results from the most recent build runs should be used
to generate static HTML reports for review and analysis.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/2">ocaml-bench/sandmark-nightly#2</a>
Timestamps are not sorted in the parallel_nightly notebook</p>
<p>The listing of timestamps in the drop-down option is now sorted.</p>
</li>
</ul>
<p><img src="upload://yH1GqDjGUKpHol6fVERCUgNsUfh.png" alt="Sandmark-nightly-PR-2-Fix|307x313" /></p>
<h3>Sandmark</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/243">ocaml-bench/sandmark#243</a>
Add irmin tree benchmark</p>
<p>A request to add the Irmin tree.ml benchmark to Sandmark, including
necessary dependencies and data files.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/245">ocaml-bench/sandmark#245</a>
Add dune.2.9.0</p>
<p>An update to dune.2.9.0 in order to build coq with Multicore OCaml
on Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/247">ocaml-bench/sandmark#247</a>
Sandmark breaks on OCaml 4.14.0+trunk</p>
<p>The Sandmark build for OCaml 4.14.0+trunk needs to be resolved as we
begin upstreaming more Multicore OCaml changes.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/248">ocaml-bench/sandmark#248</a>
coq fails to build</p>
<p>The <code>coq</code> package is failing to build with 4.12.0+domains+effects
with Sandmark on navajo server.</p>
</li>
</ul>
<h4>Completed</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/233">ocaml-bench/sandmark#233</a>
Update pausetimes_multicore to fit with the latest Multicore changes</p>
<p>The Multicore pausetimes have now been updated for the 4.12.0
upstream and 4.12.0 branches which now use the new Common Trace
Format (CTF).</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/235">ocaml-bench/sandmark#235</a>
Update selected benchmarks as a set for baseline benchmark</p>
<p>You now have the option to only filter from the user selected
variants in the Jupyter notebooks.</p>
</li>
</ul>
<p><img src="upload://gTg6GrPpJCJsMO4H6tmpqljtvD4.png" alt="Sandmark-PR-235-Fix|690x77" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/237">ocaml-bench/sandmark#237</a>
Run sandmark_nightly on a larger machine</p>
<p>The Sandmark nightly builds now run on a 64+ core machine to benefit
from the improvements to Domainslib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/240">ocaml-bench/sandmark#240</a>
Add navajo specific parallel config.json file</p>
<p>A navajo server-specific run_config.json file has been added to
Sandmark to run Multicore parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/242">ocaml-bench/sandmark#242</a>
Add commentary on grammatrix</p>
<p>A documentation update for the grammatrix benchmark on customised
task distribution via channels and the use of <code>parallel_for</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/244">ocaml-bench/sandmark#244</a>
Add chrt to pausetimes_multicore wrapper</p>
<p>The use of <code>chrt -r 1</code> in paramwrapper is required with
<code>pausetimes_multicore</code> to use the taskset arguments.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/246">ocaml-bench/sandmark#246</a>
Add trunk build to CI</p>
<p>The .drone.yml file has now been updated to include 4.14.0+stock
trunk build for the CI.</p>
</li>
</ul>
<h3>current-bench</h3>
<h4>Ongoing</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/117">ocurrent/current-bench#117</a>
Read stderr from the docker container</p>
<p>We are able to run Sandmark-2.0 -alpha branch with current-bench
now, and it is useful to view the error output when running with
Docker containers.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/146">ocurrent/current-bench#146</a>
Replicate ocaml-bench-server setup</p>
<p>A request to dynamically pass the Sandmark benchmark target commands
to current-bench in order to create pipelines.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>The PR has been cherry-picked on 4.13 and finally merged with
upstream OCaml.</p>
</li>
</ul>
<p>We would like to thank all the OCaml users, developers and contributors in the community for their valuable time and support to the project. Stay safe and have a great summer if you are northern hemispherically based!</p>
<h2>Acronyms</h2>
<ul>
<li>AFL: American Fuzzy Lop
</li>
<li>CI: Continuous Integration
</li>
<li>CTF: Common Trace Format
</li>
<li>GC: Garbage Collector
</li>
<li>GCC: GNU Compiler Collection
</li>
<li>GTK: GIMP ToolKit
</li>
<li>HTML: HyperText Markup Language
</li>
<li>IO: Input/Output
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>OS: Operating System
</li>
<li>PR: Pull Request
</li>
<li>STW: Stop The World
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - June 2021|js}
  ; slug = {js|multicore-2021-06|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-06-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the June 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous update's</a> have been compiled by @avsm, @ctk21, @kayceesrk and @shakthimaan.</p>
<p>Our overall goal remains on track for generating a preview tree for OCaml 5.0 multicore domains-only parallelism over the summer.</p>
<h2>Ecosystem compatibility for 4.12.0+domains</h2>
<p>In <a href="https://discuss.ocaml.org/t/multicore-ocaml-may-2021/7990#ecosystem-changes-to-prepare-for-500-domains-only-2">May's update</a>, I noted that our focus was now on adapting the ecosystem to work well with multicore, and I'm pleased to report that this is progressing very well.</p>
<ul>
<li>
<p>The 4.12.0+domains multicore compiler variant has been <a href="https://github.com/ocaml/opam-repository/pull/18960">merged into mainline opam-repo</a>, so you can now <code>opam switch 4.12.0+domains</code> directly. The <code>base-domains</code> package is also available to mark your opam project as <em>requiring</em> the <code>Domains</code> module, so you can even publish your early multicore-capable libraries to the mainline opam repository now.</p>
</li>
<li>
<p>The OCaml standard library was made safe for parallel use by multiple domains (<a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml">wiki</a>, <a href="https://github.com/ocaml/ocaml/issues/10453">issue</a>, <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues?q=is%3Aissue+label%3A%22stdlib+safety%22+is%3Aclosed">fixes</a>); and in particularly the <code>Format</code> and <code>Random</code> modules. These modules were the main sources of incompatibilities we found when running existing OCaml code with multiple domains.</p>
</li>
</ul>
<ul>
<li>
<p>The <code>Domain</code> module has had its interface slimmed with the removal of <code>critical_section</code>, <code>wait</code>, <code>notify</code> which has allowed significant runtime simplification. The GC C-API interface is now implemented and this means that Jane Street's <code>Base</code>, <code>Core</code>, and <code>Async</code> now compile on <code>4.12+domains</code> without modifications; for example <code>opam install patdiff</code> works out of the box on a <code>4.12+domains</code> switch!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/releases/tag/0.3.0">Domainslib 0.3.0</a> has been released which incorporates multiple improvements including the work-stealing deques for task distribution. The performance of reading domain local variables has also been improved with a primitive and a O(1) lookup.  The chapter on <a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml"><code>Parallel Programming in Multicore OCaml</code></a> has been updated to reflect the latest developments with Domainslib.</p>
</li>
</ul>
<p>This means that big application stacks should now compile pretty well with 4.12.0+domains (applications like the Tezos node and patdiff exercise a lot of the dependency trees in opam). If you do find incompatibilities, please do report them on the <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues">repository</a>.</p>
<h2>4.12.0+domains+effects</h2>
<p>Most of our focus has been on getting the domains-only trees (for OCaml 5.0) up to speed, but we have been progressing the direct-style effects-based IO stack as well.</p>
<ul>
<li>The <code>uring</code> bindings to Linux Io_uring are now available on opam-repository, so you can try it out on sequential OCaml too. A good mini-project would be to add a uring backend to the existing Async or Lwt engines, if anyone wants to try a substantial contribution.
</li>
<li>The <a href="https://github.com/ocaml-multicore/eio"><code>eio</code> library</a> is fairly usable now, for both filesystem and networking. We've submitted a talk to the OCaml workshop to dive into the innards of it in more detail, so stay tuned for that in the coming months if accepted.  The main changes here have been performance improvements, and the HTTP stack is fairy competitive with (e.g.) <code>rust-hyper</code>.
</li>
</ul>
<p>We will soon also have a variant of this tree that removes the custom effect syntax and implements the fibres (the runtime piece) as <code>Obj</code> functions.  This will further improve ecosystem compatibility and allow us to build direct-style OCaml libraries that use fibres internally to provide concurrency, but without exposing any use of effects in their interfaces.</p>
<h2>Benchmarking and performance</h2>
<p>We are always keen to get more benchmarks that exercise multicore features; if you want to try multicore out and help write benchmarks there are some suggestions on the <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Multicore-benchmarking-projects">wiki</a>. We've got a private server which runs a Sandmark nightly benchmark pipeline with Jupyter notebooks, which we can give access to anyone who submits benchmarks. We continue to test integration of Sandmark with <a href="https://github.com/ocurrent/current-bench">current-bench</a> for better integration with GitHub PRs.</p>
<p>As always, the Multicore OCaml ongoing and completed tasks are listed first, which are then followed by updates from the ecosystem and their associated libraries. The Sandmark benchmarking and nightly build efforts are then mentioned. Finally, the status of the upstream OCaml Safepoints PR is provided for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/573">ocaml-multicore/ocaml-multicore#573</a>
Backport trunk safepoints PR to multicore</p>
<p>A work-in-progress to backport the Safepoints PR from ocaml/ocaml to
Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/584">ocaml-multicore/ocaml-multicore#584</a>
Modernise signal handling</p>
<p>A patch to bring the Multicore OCaml signals implementation closer
to upstream OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/598">ocaml-multicore/ocaml-multicore#598</a>
Do not deliver signals to threads that have blocked them</p>
<p>A draft PR to not deliver signals to threads that are in a blocked
state. The without-systhreads case needs to be handled.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/600">ocaml-multicore/ocaml-multicore#600</a>
Expose a few more GC variables in headers</p>
<p>The <code>caml_young_start</code>, <code>caml_young_limit</code> and <code>caml_minor_heap_wsz</code>
variables have been defined in the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/601">ocaml-multicore/ocaml-multicore#601</a>
Domain better participants</p>
<p>The iterations <code>0(Max_domains)</code> from STW signalling and
<code>0(n_running_domains)</code> from domain creation have now been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/603">ocaml-multicore/ocaml-multicore#603</a>
Systhreads tick thread</p>
<p>An initial draft PR for porting the tick thread to Multicore OCaml.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Enhancements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/552">ocaml-multicore/ocaml-multicore#552</a>
Add a <code>force_instrumented_runtime</code> option to configure</p>
<p>The <code>configure</code> script now accepts a new
<code>--enable-force-instrumented-runtime</code> option to facilitate use of
the instrumented runtime on linker invocations to obtain event logs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/558">ocaml-multicore/ocaml-multicore#558</a>
Refactor <code>Domain.{spawn/join}</code> to use no critical sections</p>
<p>The critical sections in <code>Domain.{spawn/join}</code> and the use of
<code>Domain.wait</code> have been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/561">ocaml-multicore/ocaml-multicore#561</a>
Slim down <code>Domain.Sync</code>: remove <code>wait</code>, <code>notify</code>, <code>critical_section</code></p>
<p>A breaking change in <code>Domain.Sync</code> that removes <code>critical_section</code>,
<code>notify</code>, <code>wait</code>, <code>wait_for</code>, and <code>wait_until</code>. This is to remove
the need for domain-to-domain messaging in the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/576">ocaml-multicore/ocaml-multicore#576</a>
Including Git hash in runtime</p>
<p>A Git hash is now printed in the runtime as shown below:</p>
<pre><code>$ ./boot/ocamlrun -version
The OCaml runtime, version 4.12.0+multicore
Built with git hash 'ae3fb4bb6' on branch 'runtime_version' with tag '&lt;tag unavailable&gt;'
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/579">ocaml-multicore/ocaml-multicore#579</a>
Primitive for fetching DLS root</p>
<p>A new primitive has been implemented for fetching DLS, and is now a
single <code>mov</code> instruction on <code>amd64</code>.</p>
</li>
</ul>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/555">ocaml-multicore/ocaml-multicore#555</a>
runtime: <code>CAML_TRACE_VERSION</code> is now set to a Multicore specific value</p>
<p>A <code>CAML_TRACE_VERSION</code> is defined to distinguish between Multicore
OCaml and trunk for the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/581">ocaml-multicore/ocaml-multicore#581</a>
Move our usage of inline to <code>Caml_inline</code></p>
<p>We now use <code>Caml_inline</code> for all the C inlining in the runtime to
align with upstream OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/589">ocaml-multicore/ocaml-multicore#589</a>
Reintroduce <code>adjust_gc_speed</code></p>
<p>The <code>caml_adjust_gc_speed</code> function from trunk has been reintroduced
to the Multicore OCaml runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/590">ocaml-multicore/ocaml-multicore#590</a>
runtime: stub <code>caml_stat_*</code> interfaces in gc_ctrl</p>
<p>The creation of <code>caml_stat_*</code> stub functions in gc_ctrl.h to
introduce a compatibility layer for GC stat utilities that are
available in trunk.</p>
</li>
</ul>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/562">ocaml-multicore/ocaml-multicore#562</a>
Import fixes to the minor heap allocation code from DLABs</p>
<p>The multiplication factor of two used for minor heap allocation has
been removed, and the <code>Minor_heap_max</code> limit from config.h is no
longer converted to a byte size for Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/593">ocaml-multicore/ocaml-multicore#593</a>
Fix two issues with ephemerons</p>
<p>A patch to simplify ephemeron handover during termination.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/594">ocaml-multicore/ocaml-multicore#594</a>
Fix finaliser handover issue</p>
<p>The <code>caml_finish_major_cycle</code> is used leading to the major GC phase
<code>Phase_sweep_and_mark_main</code> for the correct handoff of finalisers.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/596">ocaml-multicore/ocaml-multicore#596</a>
systhreads: do <code>st_thread_id</code> after initializing the thread descriptor</p>
<p>The thread ID was set even before initializing the thread
descriptor, and this PR fixes the order.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/604">ocaml-multicore/ocaml-multicore#604</a>
Fix unguarded <code>caml_skiplist_empty</code> in <code>caml_scan_global_young_roots</code></p>
<p>The PR introduces a <code>caml_iterate_global_roots</code> function and fixes a
locking bug with global roots.</p>
</li>
</ul>
<h4>Cleanups</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/567">ocaml-multicore/ocaml-multicore#567</a>
Simplify some of the minor_gc code</p>
<p>The <code>not_alone</code> variable has been cleaned up with a simplification
to the minor_gc.c code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/580">ocaml-multicore/ocaml-multicore#580</a>
Remove struct domain</p>
<p>The <code>caml_domain_state</code> is now the single source of domain
information with the removal of <code>struct domain</code>. <code>struct dom_internal</code> is no longer leaking across the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/583">ocaml-multicore/ocaml-multicore#583</a>
Removing interrupt queues</p>
<p>The locking of <code>struct_interruptor</code> when receiving interrupts and
the use of <code>struct interrupt</code> have been removed, simplifying the
implementation of domains.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/582">ocaml-multicore/ocaml-multicore#582</a>
Make global state domain-local in Random, Hashtbl and Filename</p>
<p>The Domain-Local is now set as the default state in <code>Random</code>,
<code>Hashtbl</code> and <code>Filename</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/586">ocaml-multicore/ocaml-multicore#586</a>
Make the state in Format domain-local</p>
<p>The default state in <code>Format</code> is now set to Domain-Local.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/595">ocaml-multicore/ocaml-multicore#595</a>
Implement <code>caml_alloc_dependent_memory</code> and <code>caml_free_dependent_memory</code></p>
<p>Dependent memory are the blocks of heap memory that depend on the GC
(and finalizers) for deallocation. The <code>caml_alloc_dependent_memory</code>
and <code>caml_free_dependent_memory</code> have been added to
runtime/memory.c.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools/pull/3">ocaml-multicore/eventlog-tools#3</a>
Use ocaml/setup-ocaml@v2</p>
<p>An update to <code>.github/workflows/main.yml</code> to build for
ocaml/setup-ocaml@v2.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/7">ocaml-multicore/parallel-programming-in-multicore-ocaml#7</a>
Add a section on Domain-Local Storage</p>
<p>The README.md file now includes a section on Domain-Local Storage.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/26">ocaml-multicore/eio#26</a>
Grand Central Dispatch Backend</p>
<p>The implemention of the Grand Central Dispatch (GCD) backend for Eio
is a work-in-progress.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/34">ocaml-multicore/domainslib#34</a>
Fix initial value accounting in <code>parallel_for_reduce</code></p>
<p>A patch to fix the initial value in <code>parallel_for_reduce</code> as it was
being accounted for multiple times.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/36">ocaml-multicore/domainslib#36</a>
Switch to default <code>Random</code> module</p>
<p>The library has been updated to use the default <code>Random</code> module as
it stores its state in Domain-Local Storage which can be called from
multiple domains. The Sandmark results are given below:</p>
</li>
</ul>
<p><img src="upload://m1XhWfU6igtUJdkIZPRn6LdJlJK.png" alt="Domainslib-PR-36-Results|690x383" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/issues/56">ocaml-multicore/multicore-opam#56</a>
Base-effects depends strictly on 4.12</p>
<p>A query on the use of strict 4.12.0 lower bound for OCaml in
<code>base-effects.base/opam</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocsigen/lwt/pull/860">ocsigen/lwt#860</a>
Lwt_domain: An interfacet to Multicore parallelism</p>
<p>The <code>Lwt_domain</code> module has been ported to domainslib Task pool for
performing computations to CPU cores using Multicore OCaml's
Domains. A few benchmark results obtained on an Intel Xeon Gold 5120
processor with 24 isolated cores is shown below:</p>
<p><img src="upload://4iWKqRUh3abAAa1t8cgML8bzYrc.png" alt="Lwt-PR-860-Speedup|429x371" /></p>
</li>
</ul>
<h3>Completed</h3>
<h4>Ocaml-Uring</h4>
<p>The <code>ocaml-uring</code> repository contains bindings to <code>io_uring</code> for
OCaml.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/21">ocaml-multicore/ocaml-uring#21</a>
Add accept call</p>
<p>The <code>accept</code> call has been added to uring along with the inclusion
of the <code>unix</code> library as a dependency.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/22">ocaml-multicore/ocaml-uring#22</a>
Add support for cancellation</p>
<p>A <code>cancel</code> method is added to request jobs for cancellation. The
queuing operations and tests have also been updated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/24">ocaml-multicore/ocaml-uring#24</a>
Sort out cast</p>
<p>The <code>Int_val</code> has been changed to <code>Long_val</code> to remove the need for
sign extension instruction on 64-bit platforms.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/25">ocaml-multicore/ocaml-uring#25</a>
Fix test_cancel</p>
<p>A <code>with_uring</code> function is added with a <code>queue_depth</code> argument to
handle tests for cancellation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/26">ocaml-multicore/ocaml-uring#26</a>
Add <code>openat2</code></p>
<p>The <code>openat2</code> method has been added giving access to all the Linux
open and resolve flags.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/27">ocaml-multicore/ocaml-uring#27</a>
Fine-tune C flags for better performance</p>
<p>The CFLAGS have been updated for performance improvements. The
following results are observed for the noop benchmark:</p>
<pre><code>Before: noop   10000  │        1174227.1170 ns/run│
After:  noop   10000  │         920622.5802 ns/run│

</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/28">ocaml-multicore/ocaml-uring#28</a>
Don't allow freeing the ring while it is in use</p>
<p>The ring is added to a global set on creation and is cleaned up on
exit. Also, invalid cancellation requests are checked before
allocating a slot.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/29">ocaml-multicore/ocaml-uring#29</a>
Replace iovec with cstruct and clean up the C stubs</p>
<p>The <code>readv</code> and <code>writev</code> now accept a list of Cstructs which allow
access to sub-ranges of bigarrays, and to work with multiple
buffers. The handling of OOM errors has also been improved.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/30">ocaml-multicore/ocaml-uring#30</a>
Fix remaining TODOs in API</p>
<p>The <code>read</code> and <code>write</code> methods have been renamed to <code>read_fixed</code> and
<code>write_fixed</code> respectively. The <code>Region.to_cstruct</code> has been added
as an alternative to creating a sub-bigarray. An exception is now
raised if the user requests for a larger size chunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/31">ocaml-multicore/ocaml-uring#31</a>
Use <code>caml_enter_blocking_section</code> when waiting</p>
<p>The <code>caml_enter_blocking_section</code> and <code>caml_leave_blocking_section</code>
are used when waiting, which allows other threads to execute and the
GC can run in the case of Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/32">ocaml-multicore/ocaml-uring#32</a>
Compile <code>uring</code> using the C flags from OCaml</p>
<p>Use the OCaml C flags when building uring, and remove the unused
dune file.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/33">ocaml-multicore/ocaml-uring#33</a>
Prepare release</p>
<p>The CHANGES.md, README.md, dune-project and uring.opam files have
been updated to prepare for a release.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-uring/pull/34">ocaml-multicore/ocaml-uring#34</a>
Convert <code>liburing</code> to subtree</p>
<p>We now use a subtree instead of a submodule so that the ocaml-uring
can be submitted to the opam-repository.</p>
</li>
</ul>
<h4>Parallel Programming in Multicore OCaml</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/5">ocaml-multicore/parallel-programming-in-multicore-ocaml#5</a>
<code>num_domains</code> to <code>num_additional_domains</code></p>
<p>The documentation and code examples have been updated to now use
<code>num_additional_domains</code> instead of <code>num_domains</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/6">ocaml-multicore/parallel-programming-in-multicore-ocaml#6</a>
Update latest information about compiler versions</p>
<p>The compiler versions in the README.md have been updated to use 4.12
and its variants.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/8">ocaml-multicore/parallel-programming-in-multicore-ocaml#8</a>
Nudge people to the default chunk_size setting</p>
<p>The recommendation is to use the default <code>chunk_size</code> when using
<code>parallel_for</code>, especially when the number of domains gets larger.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml/pull/9">ocaml-multicore/parallel-programming-in-multicore-ocaml#9</a>
Eventlog section updates</p>
<p>The <code>eventlog-tools</code> library can now be used for parsing trace files
since Multicore OCaml includes CTF tracing support from trunk. The
relevant information has been updated in the README.md file.</p>
</li>
</ul>
<h4>Eio</h4>
<p>The <code>eio</code> library provides an effects-based parallel IO stack for
Multicore OCaml.</p>
<h5>Additions</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/41">ocaml-multicore/eio#41</a>
Add eio.mli file</p>
<p>A <code>lib_eio/eio.mli</code> file containing modules for <code>Generic</code>, <code>Flow</code>,
<code>Network</code>, and <code>Stdenv</code> have been added to the repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/45">ocaml-multicore/eio#45</a>
Add basic domain manager</p>
<p>The PR allows you to run a CPU-intensive task on another domain, and
adds a mutex to <code>traceln</code> to avoid overlapping output.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/46">ocaml-multicore/eio#46</a>
Add Eio.Time and allow cancelling sleeps</p>
<p>Use <code>psq</code> instead of <code>bheap</code> library to allow cancellations. The
<code>Eio.Time</code> module has been added to <code>lib_eio/eio.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/53">ocaml-multicore/eio#53</a>
Add <code>Switch.sub_opt</code></p>
<p>A new <code>Switch.sub_opt</code> implementation has been added to allow
running a function with a new switch. Also, <code>Switch.sub</code> has been
modified so that it is not a named argument.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/54">ocaml-multicore/eio#54</a>
Initial FS abstraction</p>
<p>A module <code>Dir</code> has been added to allow file system abstraction along
with the ability to create files and directories. On Linux, it uses
<code>openat2</code> and <code>RESOLVE_BENEATH</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/56">ocaml-multicore/eio#56</a>
Add <code>with_open_in</code>, <code>with_open_out</code> and <code>with_open_dir</code> helpers</p>
<p>The <code>Eio.Dir</code> module now contains a <code>with_open_in</code>, <code>with_open_out</code>
and <code>with_open_dir</code> helper functions.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/58">ocaml-multicore/eio#58</a>
Add <code>Eio_linux.{readv, writev}</code></p>
<p>The <code>Eio_linux.{readv, writev}</code> functions have been added to
<code>lib_eio_linux/eio_linux.ml</code> which uses the new OCaml-Uring API.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/59">ocaml-multicore/eio#59</a>
Add <code>Eio_linux.noop</code> and a simple benchmark</p>
<p>A <code>Eio_linux.noop</code> implementation has been added for benchmarking
Uring dispatch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/61">ocaml-multicore/eio#61</a>
Add generic Enter effect to simplify scheduler</p>
<p>A <code>Enter</code> effect has been introduced to simplify the scheduler
operations, and this does not have much effect on the noop
benchmark as illustrated below:</p>
</li>
</ul>
<p><img src="upload://8zISyoEDKIIZMORMCi3skMIPlGR.png" alt="Eio-PR-61-Benchmark|690x387" /></p>
<h5>Improvements</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/38">ocaml-multicore/eio#38</a>
Rename Flow.write to Flow.copy</p>
<p>The code and documentation have been updated to rename <code>Flow.write</code>
to <code>Flow.copy</code> for better clarity.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/36">ocaml-multicore/eio#36</a>
Use uring for accept</p>
<p>The <code>enqueue_accept</code> function now uses <code>Uring.accept</code> along with the
<code>effect Accept</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/37">ocaml-multicore/eio#37</a>
Performance improvements</p>
<p>Optimisation for <code>Eunix.free</code> and process completed events with
<code>Uring.peek</code> for better performance results.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/48">ocaml-multicore/eio#48</a>
Simplify <code>Suspend</code> operation</p>
<p>The <code>Suspend</code> effect has been simplified by replacing the older
<code>Await</code> and <code>Yield</code> effects with the code from Eio.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/52">ocaml-multicore/eio#52</a>
Split Linux support out to <code>eio_linux</code> library</p>
<p><code>eunix</code> now has common code that is shared by different backends,
and <code>eio_linux</code> provides a Linux io-uring backend. The tests and the
documentation have been updated to reflect the change.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/57">ocaml-multicore/eio#57</a>
Reraise exceptions with backtraces</p>
<p>Added support to store a reference to a backtrace when a switch
catches an exception. This is useful when you want to reraise the
exception later.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/60">ocaml-multicore/eio#60</a>
Simplify handling of completions</p>
<p>The PR adds <code>Job</code> and <code>Job_no_cancel</code> in <code>type io_job</code> along with
additional <code>Log.debug</code> messages.</p>
</li>
</ul>
<h5>Cleanups</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/42">ocaml-multicore/eio#42</a>
Merge fibreslib into eio</p>
<p>The <code>Fibreslib</code> code is now merged with <code>eio</code>. You will now need to
open <code>Eio.Std</code> instead of opening <code>Fibreslib</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/47">ocaml-multicore/eio#47</a>
Clean up the network API</p>
<p>The network APIs have been updated with few changes such as renaming
<code>bind</code> to <code>listen</code>, replacing <code>Unix.shutdown_command</code> with our own
type in Eio API, and replacing <code>Unix.sockaddr</code> with a custom type.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/49">ocaml-multicore/eio#49</a>
Remove <code>Eio.Private.Waiters</code> and <code>Eio.Private.Switch</code></p>
<p>The <code>Eio.Private.Waiters</code> and <code>Eio.Private.Switch</code> modules have been
removed, and waiting is now handled using the Eio library.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/55">ocaml-multicore/eio#55</a>
Some API and README cleanups</p>
<p>The PR has multiple cleanups and documentation changes. The
README.md has been modified to use <code>Eio.Flow.shutdown</code> instead of
<code>Eio.Flow.close</code>, and a Time section has been added. The
<code>Eio.Network</code> module has been changed to <code>Eio.Net</code>. The <code>Time.now</code>
and <code>Time.sleep_until</code> methods have been added to <code>lib_eio/eio.ml</code>.</p>
</li>
</ul>
<h5>Documentation</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/43">ocaml-multicore/eio#43</a>
Add design note about determinism</p>
<p>The README.md documentation has been updated with few design notes
on Determinism.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/50">ocaml-multicore/eio#50</a>
README improvements</p>
<p>Updated README.md and added <code>doc/prelude.ml</code> for use with MDX.</p>
</li>
</ul>
<h4>Handling Cancellation</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/39">ocaml-multicore/eio#39</a>
Allow cancelling accept operations</p>
<p>The PR now supports cancelling the server accept and read
operations.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/40">ocaml-multicore/eio#40</a>
Support cancelling the remaining Uring operations</p>
<p>The cancellation request of <code>connect</code>, <code>wait_readable</code> and
<code>await_writable</code> Uring operations is now supported.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/44">ocaml-multicore/eio#44</a>
Fix read-cancel test</p>
<p>The <code>ENOENT</code> value has been correctly fixed to use -2, and the
documentation for cancelling the read request has been updated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/51">ocaml-multicore/eio#51</a>
Getting <code>EALREADY</code> from cancel is not an error</p>
<p>Handle <code>EALREADY</code> case in <code>lib_eunix/eunix.ml</code> where an operation
got cancelled while in progress.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools/pull/2">ocaml-multicore/eventlog-tools#2</a>
Add a pausetimes tool</p>
<p>A <code>eventlog_pausetimes</code> tool has been added to <code>eventlog-tools</code> that
takes a directory of eventlog files and computes the mean, max pause
times, as well as the distribution up to the 99.9th percentiles. For
example:</p>
<pre><code>ocaml-eventlog-pausetimes /home/engil/dev/ocaml-multicore/trace3/caml-426094-* name
{
  &quot;name&quot;: &quot;name&quot;,
  &quot;mean_latency&quot;: 718617,
  &quot;max_latency&quot;: 33839379,
  &quot;distr_latency&quot;: [191,250,707,16886,55829,105386,249272,552640,1325621,13312993,26227671]
}
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/kcas/pull/9">ocaml-multicore/kcas#9</a>
Backoff with <code>cpu_relax</code></p>
<p>The <code>Domain.Sync.{critical_section, wait_for}</code> have now been
replaced with <code>Domain.Sync.cpu_relax</code>, which matches the
implementation with lockfree.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/10">ocaml-multicore/retro-httpaf-bench#10</a>
Add Eio benchmark</p>
<p>The Eio benchmark has now been added to the retro-httpaf-bench
GitHub repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/11">ocaml-multicore/retro-httpaf-bench#11</a>
Do a recursive checkout in the CI build</p>
<p>The <code>build_image.yml</code> workflow has been updated to perform a
recursive checkout of the submodules for the CI build.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/29">domainslib#29</a>
Task stealing with Chase Lev deques</p>
<p>The task-stealing Chase Lev deques for scheduling tasks across
domains is now merged, and shows promising results on machines with
128 CPU cores.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/55">ocaml-multicore/multicore-opam#55</a>
Add 0.3.0 release of domainslib</p>
<p>The opam file for <code>domainslib.0.3.0</code> has been added to the
multicore-opam repository.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark-nightly/issues/1">ocaml-bench/sandmark-nightly#1</a>
Cannot alter comparison input values</p>
<p>The <code>Timestamp</code> and <code>Variant</code> fields in the dropdown option in the
<code>parallel_nightly.ipynb</code> notebook get reset when recomputing the
whole workbook.</p>
</li>
</ul>
<p><img src="upload://vZ2JBVqK8HiyPPMtqByaY1Jhip9.png" alt="Sandmark-Nightly-1-Issue|690x139" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/230">ocaml-bench/sandmark#230</a>
Build for 4.13.0+trunk with dune.2.8.1</p>
<p>The <code>ocaml-migrate-parsetree.2.2.0</code> and <code>ppxlib.0.22.2</code> packages are
now available for 4.13.0+trunk, and we are currently porting the
Irmin Layers benchmark in Sandmark from using Irmin 2.4 to 2.6.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/231">ocaml-bench/sandmark#231</a>
View results for a set of benchmarks in the nightly notebooks</p>
<p>A feature request to filter the list of benchmarks when using the
Sandmark Jupyter notebooks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/233">ocaml-bench/sandmark#233</a>
Update pausetimes_multicore to fit with the latest Multicore changes</p>
<p>The pausetimes are now updated for both the 4.12.0 upstream and
4.12.0 Multicore branches to use the new Common Trace Format
(CTF). The generated graphs for both the sequential and parallel
pausetime results are illustrated below:</p>
</li>
</ul>
<p><img src="upload://m41amKGFNBx8T5zrassBWsdJlk9.png" alt="Sandmark-PR-233-Serial-Pausetimes|690x229" />
<img src="upload://t8BuHiEO8g6bs8fvv7stdBp0Q7z.png" alt="Sandmark-PR-233-Parallel-Pausetimes|690x355" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/235">ocaml-bench/sandmark#235</a>
Update selected benchmarks as a set for baseline benchmark</p>
<p>The baseline benchmark for comparison should only be one from the
user selected benchmarks in the Jupyter notebooks.</p>
</li>
</ul>
<p><img src="upload://zUiPdeScykJgbHhx4HrLIBegOIr.png" alt="Sandmark-Issue-235|383x82" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/236">ocaml-bench/sandmark#236</a>
Implement pausetimes support in sandmark_nightly</p>
<p>The sequential and parallel pausetimes graph results need to be
implemented in the Sandmark nightly Jupyter notebooks. The results
are similar to the Figures 10 and 12 produced in the <a href="https://arxiv.org/pdf/2004.11663.pdf">Retrofitting
Parallelism ont OCaml, ICFP 2020
paper</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/237">ocaml-bench/sandmark#237</a>
Run sandmark_nightly on a larger machine</p>
<p>The testing of Sandmark nightly sequential and parallel benchmark
runs have been done on a 24-core machine, and we would like to
deploy the same on a 64+ core machine to benefit from the recent
improvements to Domainslib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/241">ocaml-bench/sandmark#241</a>
Switch to default Random module</p>
<p>An on-going discussion on whether to switch to using <code>Random.State</code>
for the sequential Minilight, global roots micro-benchmarks and
Evolutionary Algorithm.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/232">ocaml-bench/sandmark#232</a>
<code>num_domains</code> -&gt; <code>num_additional_domains</code></p>
<p>The benchmarks have been updated to now use
<code>num_additional_domains</code>, to be consistent with the naming in
Domainslib.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/239">ocaml-bench/sandmark#239</a>
Port grammatrix to Task pool</p>
<p>The Multicore Grammatrix benchmark has now been ported to use
Domainslib Task pool. The time and speedup graphs are given below:</p>
</li>
</ul>
<p><img src="upload://tWJKlXjW8kbfE4omjfKlsDNpFv8.png" alt="Sandmark-PR-239-Time|690x357" />
<img src="upload://aMwCaRugQjIHdEzP35mCmVJyITJ.png" alt="Sandmark-PR-239-Speedup|690x297" /></p>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>The PR is currently being testing and evaluated for both ARM64 and
PowerPC architectures, in particular, the branch relaxations applied
to <code>Ipoll</code> instructions.</p>
</li>
</ul>
<p>Our thanks to all the OCaml users, developers and contributors in the community for their continued support to the project. Stay safe!</p>
|js}
  };
 
  { title = {js|OCaml Compiler - May 2021|js}
  ; slug = {js|ocaml-2021-05|js}
  ; description = {js|Monthly update from the OCaml Compiler team.|js}
  ; date = {js|2021-05-01|js}
  ; tags = 
 [{js|ocaml|js}]
  ; body_html = {js|<p>I’m happy to publish the second issue of the “OCaml compiler development newsletter”. (This is by no means exhaustive: many people didn’t end up having the time to write something, and it’s fine.)</p>
<p>Feel free of course to comment or ask questions!</p>
<p>If you have been working on the OCaml compiler and want to say something, please feel free to post in this thread! If you would like me to get in touch next time I prepare a newsletter issue (some random point in the future), please let me know by email at (gabriel.scherer at gmail).</p>
<p>Previous issue:</p>
<ul>
<li><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-1-before-may-2021/7831">OCaml compiler development newsletter, issue 1: before May 2021</a>
</li>
</ul>
<hr />
<h2>Gabriel Scherer and Nicolas Chataing (@gasche and @nchataing)</h2>
<p>[Gabriel writing] my main recent compiler-related activity is ongoing work with my intern Nicolas Chataing to implement a prototype of variant constructor unboxing, a core subset of what Jeremy Yallop proposed ( https://github.com/ocaml/RFCs/pull/14 ). Currently OCaml can &quot;unbox&quot; a variant if it has a single constructor (with a single parameter),</p>
<pre><code>type t = Int of int [@@unboxed]
</code></pre>
<p>Jeremy's idea is to support the case where there are other constructors, but the tag (immediate value or block constructor tag) of the constructor parameter is disjoint from the tag of any other value at this type.</p>
<pre><code>type t = Short of int [@unboxed] | Long of Mpz.t
</code></pre>
<p>Nicolas' prototype implementation is going along nicely, with some interesting challenges encountered and solved, and a few refactoring PRs along the way (#<a href="https://github.com/ocaml/ocaml/issues/10307">10307</a>, #<a href="https://github.com/ocaml/ocaml/issues/10412">10412</a>, #<a href="https://github.com/ocaml/ocaml/issues/10428">10428</a>).</p>
<p>A key ingredient is to be able to compute the &quot;head shape&quot; of an OCaml type, an over-approximation of the set of possible tags of its values. We hit a few engineering and research issues in doing this. Where in the codebase should this be computed (beware of circular module dependencies)? Can we compute this information in a precise way in presence of mutually-recursive types, without risking non-termination?</p>
<p>We are taking inspiration from a general approach proposed by Leo White and Stephen Dolan to compute these kind of &quot;type declaration properties&quot; on-demand instead of as part of the type declaration's signature (see their proposal for &quot;immediacy&quot; at #<a href="https://github.com/ocaml/ocaml/pull/10017">10017</a>, #<a href="https://github.com/ocaml/ocaml/pull/10041">10041</a> ), but our property is demanded more often (any occurrence of the constructor) and is more fine-grained (it is sensitive to type parameters), so we had to invent some solutions for new problems. (A close cousin is <code>get_unboxed_type_representation</code>, which avoids non-termination by using fuel, and we wanted something nicer than that.)</p>
<p>We discuss our handling of termination in (some) details in the following short abstract: <a href="http://gallium.inria.fr/~scherer/research/constructor-unboxing/constructor-unboxing-ml-workshop-2021.pdf">Unfolding ML datatype definitions without loops</a>.</p>
<h2>Xavier Leroy (@xavierleroy)</h2>
<p>I worked with Damien Doligez and Sadiq Jaffer on the &quot;safe points&quot; proposal (#<a href="https://github.com/ocaml/ocaml/issues/10039">10039</a>), which is required to move forward with integrating Multicore OCaml.  I re-expressed the static analyses that support the insertion of polls as backward dataflow analyses, making them simpler to understand and more robust.  We also discussed whether to insert polls at the top of loops or at the bottom.  Both strategies are implemented in the current state of the PR, and Sadiq is currently benchmarking them.</p>
<p>All this rekindled my interest in dataflow analyses.  I wrote a generic backward dataflow analyzer, parameterized by an abstract domain and a transfer function (#<a href="https://github.com/ocaml/ocaml/issues/10404">10404</a>).  Originally I intended to use it only for the insertion of polls, but I also used it to reimplement the liveness analysis that plays a crucial role for register allocation and dead code elimination.  A problem with the old liveness analysis is that it takes time exponential in the nesting of loops.  The new generic analyzer avoids this pitfall by starting fixpoint iterations not systematically at the bottom of the abstract domain, but at the fixpoint found earlier, if any.  This makes liveness analysis linear in the nesting of loops, and at worst cubic in the size of the function, instead of exponential.</p>
<p>Then I applied the same trick to the two passes that insert spills and reloads preventively (#<a href="https://github.com/ocaml/ocaml/issues/10414">10414</a>).  These are &quot;analyze and simultaneously transform&quot; passes, so I could not use the generic dataflow analyzer, but I could reuse the same improved fixpoint iteration strategy, again avoiding behaviors exponential in the nesting of loops.  For instance, a trivial function consisting of 16 nested &quot;for&quot; loops now compiles in a few milliseconds, while it took several seconds before.</p>
<h2>Jacques Garrigue (@garrigue)</h2>
<p>No new PR this month, but I have kept working on those that were started in April, and are not yet merged:</p>
<ul>
<li>#<a href="https://github.com/ocaml/ocaml/issues/10348">10348</a> improves the way expansion is done during unification, to avoid some spurious GADT related ambiguity errors
</li>
<li>#<a href="https://github.com/ocaml/ocaml/issues/10364">10364</a> changes the typing of the body of the cases of pattern-matchings, allowing to warn in some non-principal situations; it also uncovered a number of principality related bugs inside the the type-checker
</li>
<li>#<a href="https://github.com/ocaml/ocaml/issues/10337">10337</a> enforces that one always manipulate a normalized view of types by making type_expr an abstract type (with Takafumi Saikawa (@t6s))
</li>
</ul>
<p>For this last PR, we have interestingly observed that while this multiplied the number of calls to repr by a factor of up to 4, resulting in a 4% overhead in stdlib for instance, we could see no performance degradation in the compilation of Coq.</p>
<p>I have also discovered a new principality bug in the implementation of GADTs (see #<a href="https://github.com/ocaml/ocaml/issues/10348">10348</a> again), which fortunately should not affect soundness.</p>
<p>In a slightly different direction, I have started working on a backend targetting Coq:
https://github.com/COCTI/ocaml/tree/ocaml_in_coq</p>
<p>If you add the -coq option to ocamlc, you get a .v file in place of a .cmo.
It is still in a very early stage, only able to compile core ML programs, including references.
The main difference with coq-of-ocaml is that the translation is intended to be soundness preserving: the resulting Coq code can be typed and evaluated without axioms, and should reduce to the same resut as the source program, so that the type soudness of Coq underwrites that of ocaml (for individual programs). At this point, it only relies on a single relaxation of the positivity restriction of Coq.</p>
<h2>Thomas Refis (@trefis)</h2>
<p>Recently, Didier Rémy and I have been looking at <em>modular explicits</em>, a small extension between the core and module language to help manipulate first-class functors and give the illusion of abstraction over module arguments in the core language via a new construct (tentatively) called <em>dependent functions</em>.</p>
<p>This construct was first introduced in the context of the <a href="https://arxiv.org/pdf/1512.01895.pdf">modular implicits</a> proposal; roughly it's what you're left with if you take away the &quot;resolution of implicit arguments&quot; part of that proposal.</p>
<p>As such, it is a natural stepping stone towards modular implicits and already has its own self-contained PR: #<a href="https://github.com/ocaml/ocaml/pull/9187">9187</a>, contributed by Matthew Ryan.</p>
<p>What Didier and I have been focusing on recently is producing a more formal description of the feature and its relationship to first-class modules, as well as some arguments to justify that it is reasonable and desirable to add it to the language, even in the absence of modular implicits.</p>
<h2>Stephen Dolan (@stedolan)</h2>
<p>I've just opened #<a href="https://github.com/ocaml/ocaml/pull/10437">10437</a>, which allows explicit quantifiers for type variables in signatures and GADTs, a small feature I promised to OCaml maintainers a dozen of months ago. (The ulterior motive is that these explicit quantifiers give a good place to put layout information, but I think they're worth having on their own merits).</p>
<p>Note: The on-demand immediacy proposal in #<a href="https://github.com/ocaml/ocaml/issues/10017">10017</a> / #<a href="https://github.com/ocaml/ocaml/issues/10041">10041</a>, which Gabriel mentioned above, is extracted from part of the kinding system in the experimental branch https://github.com/janestreet/ocaml/tree/layouts , which additionally allows quantification over types of a given immediacy / layout: for instance, one can write <code>type ('a : immediate) t = { foo : 'a }</code> and have inference, etc. work as expected.</p>
<h2>Sadiq Jaffer (@sadiqj)</h2>
<p>The Safepoints PR #<a href="https://github.com/ocaml/ocaml/pull/10039/">10039</a> has a few updates. It now has a new static analysis, written by Xavier Leroy and Damien Doligez, and has working code emitters on all 64-bit platforms.</p>
<p>The static analysis had some flexibility on poll placement in loops. We've benchmarked on amd64 and arm64, choosing to go with the option that results in slightly fewer instructions and branches across the Sandmark suite. Short of some refactoring I don't think there are any other oustanding issues with the PR.</p>
<p>Building on safepoints, I should soon have an attribute to propose which will enable users with atomic code blocks to safely migrate to a version of OCaml with safepoints. A draft PR or RFC will be coming very soon.</p>
<p>I am also doing some work on the <a href="https://ocaml.org/releases/4.12/manual/instrumented-runtime.html">instrumented runtime</a>. One of the project's goals is to be able to continuously monitor OCaml applications running in a production environment. To that end I'm evaluating the instrumented runtime's performance overhead (both enabled and not), determining what work would be required to reduced the overhead and how we could modify the runtime to continuously extract metrics and events.</p>
<h2>Anil Madhavapeddy (@avsm)</h2>
<p>Ewan Mellor and I are working on a CI that'll make it easy to test individual changesets to the OCaml compiler and run &quot;reverse dependencies&quot; against a set of opam packages to isolate precisely what's causing a failure.</p>
<p>A failure to build an opam package can come from a variety of reasons. This can range from a build failure against a stable released compiler, to a failure on just OCaml trunk (but success on a released compiler), to a failure just on OCaml trunk + the PR in question.  It's the triage of which of these situations is causing the package build failure that our new CI focusses on. Having this CI should let us quickly determine a PR's impact and potential regressions on the package ecosystem. Once the CI is stable on the OCaml multicore trees, I plan to submit it as a CI to run against mainline OCaml as well.</p>
<p>The working tree is at <a href="https://github.com/ocurrent/ocaml-multicore-ci">ocaml-multicore-ci</a> (although it's called a &quot;multicore CI&quot;, its really just turned into an &quot;ocaml-compiler-ci&quot; and we will rename the repository before a first release).</p>
<h2>Florian Angeletti (@Octachron)</h2>
<p>This week I have been working a bit on adding swaps and moves to the diffing based error messages for type declarations in #<a href="https://github.com/ocaml/ocaml/pull/10361">10361</a>.</p>
<p>(And the release of the first alpha for OCaml 4.13.0)</p>
<p>The core idea of the PR is that when comparing</p>
<pre><code>type t = { a:int; b:int; c:int; d:int }
</code></pre>
<p>with</p>
<pre><code>type t = { a:int; c:int; d:int }
</code></pre>
<p>in an error message, it is better to notice that we are missing one field rather than trying to compare the fields <code>b</code> and <code>c</code>.</p>
<p>And with the machinery introduced for functor diffing, this is quite straigthforward to implement. I have been experimenting with this option since last december, and with the functor diffing PR merged #<a href="https://github.com/ocaml/ocaml/issues/9331">9331</a>, I proposed a PR #<a href="https://github.com/ocaml/ocaml/issues/10361">10361</a> in April.</p>
<p>However, compared to functors, in type declarations, we have have one supplementary piece of information: the name of fields and constructors at a given position.  Not using this piece of information yields slightly akward error messages:</p>
<pre><code>  module M: sig type t = { a:int; b:int } end = struct type t = {b:int;
a:int}
</code></pre>
<pre><code>   1. Fields have different names, x and y.
   2. Fields have different names, y and x.
</code></pre>
<p>Here, it would be better to recognize that the two fields have been swapped.</p>
<p>One simple way to do this without increasing the diffing complexity is to identify swaps at posteriori on the optimal patch produced by the diffing algorithm.</p>
<p>In this way we can replace the previous error message by</p>
<pre><code>   1&lt;-&gt;2. Fields x and y have been swapped.
</code></pre>
<p>without increasing the cost of the error analysis.</p>
<p>A similar situation happens when the position of a field changes between the interface and the implementation</p>
<pre><code class="language-ocaml">module M: sig
   type t = { a:unit; b:int; c:float}
end = struct
   type t = { b:int; c:float; a:unit}
end
</code></pre>
<p>Explaining that the implementation can be transformed into the interface by adding a field <code>a</code> before the field <code>b</code> and deleting another field <code>a</code> after <code>c</code> is correct. But it is much nicer to sum up the issue as</p>
<pre><code>1-&gt;3. Field a has been moved from position 1 to 3
</code></pre>
<p>Both composite moves are now recognized.</p>
<p>People interested by error message in OCaml should also have a look at the great work by Antal Spector-Zabusky in #<a href="https://github.com/ocaml/ocaml/pull/10407">10407</a> to improve the module level error message by expanding them with a full error trace.
(The two PRs are quite complementary.)</p>
|js}
  };
 
  { title = {js|OCaml Multicore - May 2021|js}
  ; slug = {js|multicore-2021-05|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-05-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the May 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by @avsm, @ctk21, @kayceesrk and @shakthimaan.</p>
<p>Firstly, all of our upstream activity on the OCaml compiler is now reported as part of the shiny new <a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-2-may-2021/7965">compiler development newsletter #2</a> that @gasche has started. This represents a small but important shift -- domains-only multicore is firmly locked in on the upstream roadmap for OCaml 5.0 and the whole OCaml compiler team has been helping and contributing to it, with the <a href="https://github.com/ocaml/ocaml/pull/10039">GC safe points</a> feature being one of the last major multicore-prerequisites (and due to be in OCaml 4.13 soon).</p>
<p>This multicore newsletter will now focus on getting our ecosystem ready for domains-only multicore in OCaml 5.0, and on how the (not-yet-official) effect system and multicore IO stack is progressing.  It's a long one this month, so settle in with your favourite beverage and let's begin :-)</p>
<h2>OCaml Multicore: 4.12.0+domains</h2>
<p>The multicore compiler now supports CTF runtime traces of its garbage collector and there are <a href="https://github.com/ocaml-multicore/eventlog-tools/tree/multicore_wip">tools to display chrome tracing visualisations</a> of the garbage collector events. A number of performance improvements (see speedup graphs later on) that highlight some ways to make best use of multicore were made to the existing benchmarks in Sandmark.  There has also been work on scaling up to 128 cores/domains for task-based parallelism in domainslib using <a href="https://github.com/ocaml-multicore/domainslib/pull/29">work stealing deques</a>, bringing us closer to Cilk-style task-parallel performance.</p>
<p>As important as new features are what we have decided <em>not</em> to do. We've been working on and evaluating Domain Local Allocation Buffers (DLABs) for some time, with the intention of reducing the cost of minor GCs. We've found that the resulting performance didn't match our expectations (<em>vs</em> the complexity of the change), and so we've decided not to proceed with this for OCaml 5.0.  You can find the <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers-Addendum">DLAB summary</a> page summarises our experiences. We'll come back to this post-OCaml 5.0 when there are fewer moving parts.</p>
<h2>Ecosystem changes to prepare for 5.0.0 domains-only</h2>
<p>As we are preparing 5.0 branches with the multicore branches over the coming months, we are stepping up preparations to ensure the OCaml ecosystem is ready.</p>
<h3>Making the multicore compilers available by default in opam-repo</h3>
<p>Over the next few week, we will be merging the multicore 4.12.0+domains and associated packages from their opam remote over in <a href="https://github.com/ocaml-multicore/multicore-opam">ocaml-multicore/multicore-opam</a> into the mainline opam-repository. This is to make it more convenient to use the variant compilers to start testing your own packages with <code>Domain</code>s.</p>
<p>As part of this change, there are two new base packages that will be available in opam-repository:</p>
<ul>
<li><code>base-domains</code>: This package indicates that the current compiler has the <code>Domain</code> module.
</li>
<li><code>base-effects</code>: This package indicates the current compiler has the experimental effect system.
</li>
</ul>
<p>By adding a dependency on these packages, the only valid solutions will be <code>4.12.0+domains</code> (until OCaml 5.0 which will have this module) or <code>4.12.0+effects</code>.</p>
<p>The goal of this is to let community packages more easily release versions of their code using Domains-only parallelism ahead of OCaml 5.0, so that we can start migration and thread-safety early.  We do not encourage anyone to take a dependency on base-effects currently, as it is very much a moving target.</p>
<p>This opam-repository change isn't in yet, but I'll comment on this post when it is merged.</p>
<h3>Adapting the Stdlib for thread-safety</h3>
<p>One of the first things we have to do before porting third-party libraries is to get the Stdlib ready for thread-safety. This isn't quite as simple as it might appear at first glance: if we adopt the naïve approach of simply putting a mutex around every bit of global state, our sequential performance will slow down. Therefore we are performing a more fine-grained analysis and fixes, which can be seen <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Safety-of-Stdlib-under-Multicore-OCaml">on the multicore stdlib page</a>.</p>
<p>For anyone wishing to contribute: hunt through the Stdlib for global state, and categorise it appropriately, and then create a test case exercising that module with multiple Domains running, and submit a PR to <a href="https://github.com/ocaml-multicore/ocaml-multicore">ocaml-multicore</a>.  In general, if you see any build failures or runtime failures now, we'd really appreciate an issue being filed there too. You can see some good examples of such issues <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/574">here</a> (for mirage-crypto) and <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/568">here</a> (for Coqt).</p>
<h3>Porting third-party libraries to Domains</h3>
<p>As I mentioned last month, we put a call out for libraries and maintainers who wanted to port their code over. We're starting with the following libraries and applications this month:</p>
<ul>
<li>
<p><strong>Lwt</strong>: the famous lightweight-threads library now has a PR to add <a href="https://github.com/ocsigen/lwt/pull/860">Lwt_domains</a>. This is the first simple(ish) step to using multicore cores with Lwt: it lets you run a pure (non-Lwt) function in another Domain via <code>detach : ('a -&gt; 'b) -&gt; 'a -&gt; 'b Lwt.t</code>.</p>
</li>
<li>
<p><strong>Mirage-Crypto</strong>: the next library we are adapting is the cryptography library, since it is also low-hanging fruit that should be easy to parallelise (since crypto functions do not have much global state). The port is still ongoing, as there are some minor build failures and also Stdlib functions in Format that aren't yet thread-safe that are <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/563">causing failures</a>.</p>
</li>
<li>
<p><strong>Tezos-Node</strong>: the bigger application we are applying some of the previous dependencies too is Tezos-Node, which makes use of the dependency chain here via Lwt, mirage-crypto, Irmin, Cohttp and many other libraries. We've got this <a href="https://gitlab.com/tezos/tezos/-/merge_requests/2671">compiling under 4.12.0+domains</a> now and mostly passing the test suite, but will only report significant results once the dependencies and Stdlib are passing.</p>
</li>
<li>
<p><strong>Owl</strong>: OCaml's favourite machine learning library works surprisingly well out-of-the-box with 4.12.0+domains. An experiment for a significant machine-learning codebase written using it saw about a 2-4x speedup before some false-sharing bottlenecks kicked in. This is pretty good going given that we made no changes to the codebase itself, but stay tuned for more improvements over the coming months as we analyse the bottleneck.</p>
</li>
</ul>
<p>This is hopefully a signal to all of you to start &quot;having a go&quot; with 4.12.0+domains on your own applications, and particularly with respect to seeing how wrapping it in Domains works out and identifying global state. You can read our handy <a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml">tutorial on parallel programming with Multicore OCaml</a>.</p>
<p>We are developing some tools to help find global state, but we're going to all need to work together to identify some of these cases and begin migration.  Crucially, we need some diversity in our dependency chains -- if you have interesting applications using (e.g.) Async or the vanilla <code>Thread</code> module and have some cycles to work with us, please get in touch with me or @kayceesrk .</p>
<h2>4.12.0+effects</h2>
<p>The effects-based <a href="https://github.com/ocaml-multicore/eio">eio library</a> is coming together nicely, and the interface and design rationales are all up-to-date in the README of the repository.  The primary IO backend is <a href="https://github.com/ocaml-multicore/ocaml-uring">ocaml-uring</a>, which we are preparing for a separate release to opam-repository now as it also works fine on the sequential runtime for Linux (as long as you have a fairly recent kernel. Otherwise the kernel crashes).  We also have a <a href="https://github.com/ocaml-multicore/eio/pull/26">Grand Central Dispatch effect backend</a> to give us a totally different execution model to exercise our effect handler abstractions.</p>
<p>While we won't publish the performance numbers for the effect-based IO this month, you can get a sense of the sorts of tests we are running by looking at the <a href="https://github.com/ocaml-multicore/retro-httpaf-bench">retro-httpaf-bench</a> repository, which now has various permutations of effects-based, uring-based and select-based webservers. We've submitted a talk to the upcoming OCaml Workshop later this summer, which, if accepted, will give you a deepdive into our effect-based IO.</p>
<p>As always, we begin with the Multicore OCaml ongoing and completed tasks.  The ecosystem improvements are then listed followed by the updates to the Sandmark benchmarking project. Finally, the upstream OCaml work is mentioned for your reference.  For those of you that have read this far and can think of nothing more fun than hacking on multicore programming runtimes, we are hiring in the UK, France and India -- please find the job postings at the end!</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/552">ocaml-multicore/ocaml-multicore#552</a>
Add a force_instrumented_runtime option to configure</p>
<p>A new <code>--enable-force-instrumented-runtime</code> option is introduced to
facilitate use of the instrumented runtime on linker invocations to
obtain event logs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/553">ocaml-multicore/ocaml-multicore#553</a>
Testsuite failures with flambda enabled</p>
<p>A list of tests are failing on <code>b23a416</code> with flambda enabled, and
they need to be investigated further.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/555">ocaml-multicore/ocaml-multicore#555</a>
runtime: CAML_TRACE_VERSION is now set to a Multicore specific value</p>
<p>Define a <code>CAML_TRACE_VERSION</code> to distinguish between Multicore OCaml
and trunk for the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/558">ocaml-multicore/ocaml-multicore#558</a>
Refactor Domain.{spawn/join} to use no critical sections</p>
<p>The PR removes the use of <code>Domain.wait</code> and critical sections in
<code>Domain.{spawn/join}</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/559">ocaml-multicore/ocaml-multicore#559</a>
Improve the Multicore GC Stats</p>
<p>A draft PR to include more Multicore GC statistics when using
<code>OCAMLRUNPARAM=v=0x400</code>.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/508">ocaml-multicore/ocaml-multicore#508</a>
Domain Local Allocation Buffers</p>
<p>The Domain Local Allocation Buffer implementation for OCaml Multicore has been dropped for now. A discussion is on the PR itself and there is a wiki
page <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers-Addendum">here</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/527">ocaml-multicore/ocaml-multicore#527</a>
Port eventlog to CTF</p>
<p>The porting of the <code>eventlog</code> implementation to the Common Trace
Format is now complete.</p>
<p>For an introduction to producing Chrome trace visualizations of the
runtime events see <a href="https://github.com/ocaml-multicore/eventlog-tools/tree/multicore_wip">eventlog-tools</a>. This postprocessing tool turns the CTF
trace into the Chrome tracing format that allows interactive visualizations
like this:</p>
</li>
</ul>
<p><img src="upload://hkZ1MA5sA6IdEwV9nIBm57YdmvZ.jpeg" alt="OCaml-Multicore-PR-527-Illustration|690x475" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/543">ocaml-multicore/ocaml-multicore#543</a>
Parallel version of weaklifetime test</p>
<p>A parallel version of the <code>weaklifetime.ml</code> test is now added to the
test suite.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/546">ocaml-multicore/ocaml-multicore#546</a>
Coverage of domain life-cycle in domain_dls and ephetest_par tests</p>
<p>Additional tests to increase test coverage for domain life-cycle for
<code>domain_dls.ml</code> and <code>ephetest_par.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/550">ocaml-multicore/ocaml-multicore$#550</a>
Lazy effects test</p>
<p>Inclusion of a test to address effects with Lazy computations for a
number of different use cases.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/557">ocaml-multicore/ocaml-multicore#557</a>
Remove unused domain functions</p>
<p>A clean-up to remove unused functions in <code>domain.c</code> and <code>domain.h</code>.</p>
</li>
</ul>
<h2>Ecosystem</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools/pull/2">ocaml-multicore/eventlog-tools#2</a>
Add a pausetimes tool</p>
<p>The <code>eventlog_pausetimes</code> tool takes a directory of eventlog files
and computes the mean, max pause times, as well as the distribution
up to the 99.9th percentiles. For example:</p>
<pre><code>ocaml-eventlog-pausetimes /home/engil/dev/ocaml-multicore/trace3/caml-426094-* name
{
  &quot;name&quot;: &quot;name&quot;,
  &quot;mean_latency&quot;: 718617,
  &quot;max_latency&quot;: 33839379,
  &quot;distr_latency&quot;: [191,250,707,16886,55829,105386,249272,552640,1325621,13312993,26227671]
}
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/29">domainslib#29</a>
Task stealing with CL deques</p>
<p>This ongoing work to use task-stealing Chase Lev deques for scheduling
tasks across domains is looking very promising. Particularly for machines
with 128 cores.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/10">ocaml-multicore/retro-httpaf-bench#10</a>
Add Eio benchmark</p>
<p>The addition of an Eio benchmark for retro-httpaf-bench. This is a
work-in-progress.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/26">ocaml-multicore/eio#26</a>
Grand Central Dispatch Backend</p>
<p>An early draft PR that implements the Grand Central Dispatch (GCD)
backend for Eio.</p>
</li>
<li>
<p><a href="https://github.com/ocsigen/lwt/pull/860">ocsigen/lwt#860</a>
Lwt_domain: An interfacet to Multicore parallelism</p>
<p>An on-going effort to introduce <code>Lwt_domain</code> for performing
computations to CPU cores using Multicore OCaml's Domains.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>retro-httpaf-bench</h4>
<p>The <code>retro-httpaf-bench</code> repository contains scripts for running HTTP
server benchmarks.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/6">ocaml-multicore/retro-httpaf-bench#6</a>
Move OCaml to 4.12</p>
<p>The build scripts have been updated to use 4.12.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/8">ocaml-multicore/retro-httpaf-bench#8</a>
Adds a Rust benchmark using hyper</p>
<p>The inclusion of the Hyper benchmark limited to a single core to
match the other existing benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/9">ocaml-multicore/retro-httpaf-bench#9</a>
Release builds for dune, stretch request volumes, rust fixes and remove mimalloc</p>
<p>The Dockerfile, README, build_benchmarks.sh and run_benchmarks.sh
files have been updated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/5">ocaml-multicore/retro-httpaf-bench#15</a>
Make benchmark more realistic</p>
<p>The PR enhances the implementation to correctly simulate a
hypothetical database request, and the effects code has been updated
accordingly.</p>
</li>
</ul>
<h4>eio</h4>
<p>The <code>eio</code> library provides an effects-based parallel IO stack for
Multicore OCaml.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/18">ocaml-multicore/eio#18</a>
Add fibreslib library</p>
<p>The <code>promise</code> library has been renamed to <code>fibreslib</code> to avoid
naming conflict with the existing package in opam, and the API
(waiters and effects) has been split into its own respective
modules.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/19">ocaml-multicore/eio#19</a>
Update to latest ocaml-uring</p>
<p>The code and configuration files have been updated to use the latest
<code>ocaml-uring</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/20">ocaml-multicore/eio#20</a>
Add Fibreslib.Semaphore</p>
<p>Implemented the <code>Fibreslib.Semaphone</code> module that is useful for
rate-limiting, and based on OCaml's <code>Semaphore.Counting</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/21">ocaml-multicore/eio#21</a>
Add high-level Eio API</p>
<p>A new Eio library with interfaces for sources and sinks. The README
documentation has been updated with motivation and usage.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/22">ocaml-multicore/eio#22</a>
Add switches for structured concurrency</p>
<p>Implementation of structured concurrency with documentation examples
for tracing and testing with mocks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/23">ocaml-multicore/eio#23</a>
Rename repository to eio</p>
<p>The Effects based parallel IO for OCaml repository has now been
renamed from <code>eioio</code> to <code>eio</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/24">ocaml-multicore/eio#24</a>
Rename lib_eioio to lib_eunix</p>
<p>The names have been updated to match the dune file.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/25">ocaml-multicore/eio#25</a>
Detect deadlocks</p>
<p>An exception is now raised to detect deadlocks if the scheduler
finishes while the main thread continues to run.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/27">ocaml-multicore/eio#27</a>
Convert expect tests to MDX</p>
<p>The expected tests have been updated to use the MDX format, and this
avoids the need for ppx libraries.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/28">ocaml-multicore/eio#28</a>
Use splice to copy if possible</p>
<p>The effect Splice has been implemented along with the update to
ocaml-uring, and necessary documentation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/29">ocaml-multicore/eio#29</a>
Improve exception handling in switches</p>
<p>Additional exception checks to handle when multiple threads fail,
and for <code>Switch.check</code> and <code>Fibre.fork_ignore</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/30">ocaml-multicore/eio#30</a>
Add eio_main library to select backend automatically</p>
<p>Use <code>eio_main</code> to select the appropriate backend (<code>eunix</code>, for
example) based on the platform.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/31">ocaml-multicore/eio#31</a>
Add Eio.Flow API</p>
<p>Implemented a Flow module that allows combinations such as
bidirectional flows and closable flows.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/32">ocaml-multicore/eio#32</a>
Initial support for networks</p>
<p>Eio provides a high-level API for networking, and the <code>Network</code>
module has been added.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/33">ocaml-multicore/eio#33</a>
Add some design rationale notes to the README</p>
<p>The README has been updated with design notes, and reference to
further reading on the principles of Object-capability model.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/34">ocaml-multicore/eio#34</a>
Add shutdown, allow closing listening sockets, add cstruct_source</p>
<p>Added cstruct_source, <code>shutdown</code> method along with source, sink and
file descriptor types.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eio/pull/35">ocaml-multicore/eio#35</a>
Add Switch.on_release to auto-close FDs</p>
<p>We can now attach resources such as file descriptors to switches,
and these are freed when the the switch is finished.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/23">ocaml-multicore/domainslib#23</a>
Running tests: moving to <code>dune runtest</code> from manual commands in
<code>run_test</code> target</p>
<p>The <code>dune runtest</code> command is now used to execute the tests.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/24">ocaml-multicore/domainslib#24</a>
Move to Mutex &amp; Condition from Domain.Sync.{notify/wait}</p>
<p>The channel implementation using <code>Mutex</code> and <code>Condition</code> is now
complete. The performance results are shown in the following graph:</p>
</li>
</ul>
<p><img src="upload://rRTArEtLWG8BMCq9uhtokOX2ZfD.png" alt="Domainslib-PR-24|465x500" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/53">ocaml-multicore/multicore-opam#53</a>
Add base-domains and base-effects packages</p>
<p>The <code>base-domains</code> and <code>base-effects</code> opam files have now been added
to multicore-opam.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/54">ocaml-multicore/multicore-opam#54</a>
Shift all multicore packages to unique versions and base-domains dependencies</p>
<p>The naming convention is to now use <code>base-effects</code> and
<code>base-domains</code> everywhere.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/230">ocaml-bench/sandmark#230</a>
Build for 4.13.0+trunk with dune.2.8.1</p>
<p>A work-in-progress to upgrade Sandmark to use dune.2.8.1 to build
4.13.0+trunk and generate the benchmarks. You can test the same
using:</p>
<pre><code>TAG='&quot;macro_bench&quot;' make run_config_filtered.json
RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.13.0+trunk.bench
</code></pre>
</li>
</ul>
<h3>Completed</h3>
<h4>Sandmark</h4>
<h5>Performance</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/221">ocaml-bench/sandmark#221</a>
Fix up decompress iterations of work</p>
<p>The use of <code>parallel_for</code>, simplification of <code>data_to_compress</code> to
use <code>String.init</code>, and fix to correctly count the amount of work
configured and done produces the following speed improvements:</p>
</li>
</ul>
<p><img src="upload://avtHyFpuulDQcFH70cY97b5HVDK.png" alt="PR-221-Time |690x184" />
<img src="upload://awpN69M44aG0mjB524DKoiaNWnk.png" alt="PR-221-Speedup |690x184" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/223">ocaml-bench/sandmark#223</a>
A better floyd warshall</p>
<p>An improvement to the Floyd Warshall implementation that fixes the
random seed so that it is repeatable, and improves the pattern
matching.</p>
</li>
</ul>
<p><img src="upload://aDnAjB3JQ4s27CnpOY1srPNKi4P.png" alt="Sandmark-PR-223-Time|690x184" />
<img src="upload://rbNANIAeqUwZIHi7DTmrRRS1IUo.png" alt="Sandmark-PR-223-Speedup|690x184" />
<img src="upload://t4F2AeZDvTIQo0NRuBBHAEJdTAR.png" alt="Sandmark-PR-223-Minor-Collections|690x185" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/224">ocaml-bench/sandmark#224</a>
Some improvements for matrix multiplication</p>
<p>The <code>matrix_multiplication</code> and <code>matrix_multiplication_multicore</code>
code have been updated for easier maintenance, and results are
written only after summing the values.</p>
</li>
</ul>
<p><img src="upload://oysje2XiEEF6MfC7k9iAotAYiXY.png" alt="Sandmark-PR-224-Time|690x184" />
<img src="upload://bf8cqFB61vMuwkI2L0QnlB9xKvD.png" alt="Sandmark-PR-224-Speedup|690x184" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/225">ocaml-bench/sandmark#225</a>
Better Multicore EA Benchmark</p>
<p>The Evolutionary Algorithm now inserts a poll point into <code>fittest</code>
to improve the benchmark results.</p>
</li>
</ul>
<p><img src="upload://dS7Mgz9ByLS0wIAoM60akHsxV2v.png" alt="Sandmark-PR-225-Time|690x184" />
<img src="upload://phFOvw59SaV1btTkQVFAdPBUCK0.png" alt="Sandmark-PR-225-Speedup|690x184" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/226">ocaml-bench/sandmark#226</a>
Better scaling for mandelbrot6_multicore</p>
<p>The <code>mandelbrot6_multicore</code> scales well now with the use of
<code>parallel_for</code> as observed in the following graphs:</p>
</li>
</ul>
<p><img src="upload://8oZid38MSYvuU8TqIcZr6RIDXyy.png" alt="Sandmark-PR-226-Time|690x184" />
<img src="upload://qeu6IP61DFrUCJuTrY88n8QoxJ8.png" alt="Sandmark-PR-226-Speedup|690x184" />
<img src="upload://59yQ3fHgz3RV2elebkMLg1nUJ1h.png" alt="Sandmark-PR-226-Minor-Collections|690x184" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/227">ocaml-bench/sandmark#227</a>
Improve nbody_multicore benchmark with high core counts</p>
<p>The <code>energy</code> function is now parallelised with <code>parallel_for_reduce</code>
for larger core counts.</p>
</li>
</ul>
<p><img src="upload://uuKGoQOxTXSWI3664AOD2LIdPdO.png" alt="Sandmark-PR-227-Time|690x184" />
<img src="upload://raK1diCYlKtAOolyXtDKc8eMGGj.png" alt="Sandmark-PR-227-Speedup|690x184" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/229">ocaml-bench/sandmark#229</a>
Improve game_of_life benchmarks</p>
<p>The hot functions are now inlined to improve the <code>game_of_life</code>
benchmarks, and we avoid initialising the temporary matrix with
random numbers.</p>
</li>
</ul>
<p><img src="upload://bwpeImbVr37QKJ5OiVcNh1SkkOx.png" alt="Sandmark-PR-229-Time|690x184" />
<img src="upload://xBaIx2geunZuzlebBY2NMGJt0uA.png" alt="Sandmark-PR-229-Speedup|690x184" /></p>
<h5>Sundries</h5>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/215">ocaml-bench/sandmark#215</a>
Remove Gc.promote_to from treiber_stack.ml</p>
<p>The 4.12+domains and 4.12+domains+effects branches have
<code>Gc.promote_to</code> removed from the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/216">ocaml-bench/sandmark#216</a>
Add configs for 4.12.0+stock, 4.12.0+domains, 4.12.0+domains+effects</p>
<p>The ocaml-version configuration files for 4.12.0+stock,
4.12.0+domains, and 4.12.0+domains+effects have now been included
to Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/220">ocaml-bench/sandmark#220</a>
Attempt to improve the OCAMLRUNPARAM documentation</p>
<p>The README has been updated with more documentation on the use of
OCAMLRUNPARAM configuration when running the benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/222">ocaml-bench/sandmark#222</a>
Deprecate 4.06.1 and 4.10.0 and upgrade to 4.12.0</p>
<p>The 4.06.1, 4.10.0 ocaml-versions have been removed and the CI
has been updated to use 4.12.0 as the default version.</p>
</li>
</ul>
<h4>current-bench</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/103">ocurrent/current-bench#103</a>
Ability to set scale on UI to start at 0</p>
<p>The graph origins now start from <code>[0, y_max+delta]</code> for the y-axis
for better comparison.</p>
<p><img src="images/Current-bench-PR-74.png" alt="current-bench frontend fix 0 baseline" /></p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/121">ocurrent/current-bench#121</a>
Use string representation for docker cpu setting.</p>
<p>The <code>OCAML_BENCH_DOCKER_CPU</code> setting now switches from Integer to
String to support a range of CPUs for parallel execution.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>The Sandmark benchmark runs to obtain the performance numbers for
the Safepoints PR for 4.13.0+trunk have been published. The PR is
ready to be merged.</p>
</li>
</ul>
<h2>Job Advertisements</h2>
<ul>
<li>
<p><a href="https://discuss.ocaml.org/t/runtime-systems-engineer-ocaml-labs-uk-tarides-fr-segfault-systems-in-remote/7959">Multicore OCaml Runtime Systems Engineer</a>
OCaml Labs (UK), Tarides (France) and Segfault Systems (India)</p>
</li>
<li>
<p><a href="https://tarides.com/jobs/benchmark-tooling-engineer">Benchmark Tooling Engineer</a>
Tarides</p>
</li>
</ul>
<p>Our thanks to all the OCaml users, developers and contributors in the
community for their continued support to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>AMD: Advanced Micro Devices
</li>
<li>API: Application Programming Interface
</li>
<li>CI: Continuous Integration
</li>
<li>CPU: Central Processing Unit
</li>
<li>CTF: Common Trace Format
</li>
<li>DLAB: Domain Local Allocation Buffer
</li>
<li>EA: Evolutionary Algorithm
</li>
<li>GC: Garbage Collector
</li>
<li>GCD: Grand Central Dispatch
</li>
<li>HTTP: Hypertext Transfer Protocol
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>MVP: Minimal Viable Product
</li>
<li>PR: Pull Request
</li>
<li>TPS: Transactions Per Second
</li>
<li>UI: User Interface
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Compiler - before May 2021|js}
  ; slug = {js|ocaml-2021-04|js}
  ; description = {js|Monthly update from the OCaml Compiler team.|js}
  ; date = {js|2021-04-01|js}
  ; tags = 
 [{js|ocaml|js}]
  ; body_html = {js|<p>Hi Discuss,</p>
<p>I'm happy to introduce the first issue of the &quot;OCaml compiler development newsletter&quot;. I asked frequent contributors to the OCaml compiler codebase to write a small burb on what they have been doing recently, in the interest of sharing more information on what people are interested in, looking at and working on.</p>
<p>This is by no means exhaustive: many people didn't end up having the time to write something, and it's fine. But hopefully this can give a small window on development activity related to the OCaml compiler, structured differently from the endless stream of <a href="https://github.com/ocaml/ocaml/pulls">Pull Requests</a> on the compiler codebase.</p>
<p>(This initiative is inspired by the excellent Multicore newsletter. Please don't expect that it will be as polished or consistent :yo-yo: .)</p>
<p>Note:</p>
<ul>
<li>
<p>Feel free of course to comment or ask questions, but I don't know if the people who wrote a small blurb will be looking at the thread, so no promises.</p>
</li>
<li>
<p>If you have been working on the OCaml compiler and want to say something, please feel free to post! If you would like me to get in touch next time I prepare a newsletter issue (some random point in the future), please let me know by email at (gabriel.scherer at gmail).</p>
</li>
</ul>
<hr />
<h2>@dra27 (David Allsopp)</h2>
<p>Compiler relocation patches now exist. There's still a few left to write, and they need splitting into reviewable PRs, but the core features are working. A compiler installation can be copied to a new location and still work, meaning that local switches in opam may in theory be renamed and, more importantly, we can cache previously-built compilers in an opam root to allow a new switch's compiler to be a copy. This probably won't be reviewed in time for 4.13, although it's intended that once merged opam-repository will carry back-ports to earlier compilers.</p>
<p>A whole slew of scripting pain has lead to some possible patches to reduce the use of scripts in the compiler build to somewhat closer to none.</p>
<p>FlexDLL bootstrap has been completely overhauled, reducing build time considerably. This will be in 4.13 (#<a href="https://github.com/ocaml/ocaml/pull/10135">10135</a>)</p>
<h2>@nojb (Nicolás Ojeda Bär)</h2>
<p>I am working on #<a href="https://github.com/ocaml/ocaml/pull/10159">10159</a>, which enables debug information in <code>-output-complete-exe</code> binaries. It uses <a href="https://github.com/graphitemaster/incbin">incbin</a> under Unix-like system and some other method under Windows.</p>
<h2>@gasche (Gabriel Scherer)</h2>
<p>I worked on bringing more PRs to a decision (merge or close). The number of open PRs has gone from 220-ish to 180, which feels nice.</p>
<p>I have also contributed to @Ekdohibs' project <a href="https://github.com/Ekdohibs/camlboot">camlboot</a>, which is a &quot;bootstrap-free&quot; implementation of OCaml able to compile the OCaml compiler itself. It currently targets OCaml 4.07 for various reasons. We were able to do a full build of the OCaml compiler, and check that the result produces bootstrap binaries that coincide with upstream bootstraps. This gives extremely strong confidence that the OCaml bootstrap is free from &quot;trusting trust&quot; attacks. For more details, see our <a href="http://gallium.inria.fr/~scherer/drafts/camlboot.pdf">draft paper</a>.</p>
<h4>with @Octachron (Florian Angeletti)</h4>
<p>I worked with Florian Angeletti on deprecating certain command-line warning-specifier sequences, to avoid usability issues with (new in 4.12) warning names. Before <code>-w -partial-match</code> disables warning 4, but <code>-w -partial</code> is interpreted as the sequence <code>w -p -w a -w r -w t -w i -w a -w l</code>, most of which are ignored but <code>-w a</code> silences all warnings. Now multi-letter sequences of  &quot;unsigned&quot; specifiers (<code>-p</code> is signed, <code>a</code> is unsigned) are deprecated. (We first deprecated all unsigned specifiers, but Leo White tested the result and remarked that <code>-w A</code> is common, so now we only warn on multi-letter sequences of unsigned specifiers.</p>
<p>I am working with @Octachron (Florian Angeletti) on grouping signature items when traversing module signatures. Some items are &quot;ghost items&quot; that are morally attached in a &quot;main item&quot;; the code mostly ignores this and this creates various bugs in corner cases. This is work that Florian started in September 2019 with #<a href="https://github.com/ocaml/ocaml/pull/8929">8929</a>, to fix a bug in the reprinting of signatures. I only started reviewing in May-September 2020 and we decided to do sizeable changes, he split it in several smaller changes in January 2021 and we merged it in April 2021. Now we are looking are fixing other bugs with his code (#<a href="https://github.com/ocaml/ocaml/pull/9774">9774</a>, #<a href="https://github.com/ocaml/ocaml/pull/10385">10385</a>). Just this week Florian landed a nice PR fixing several distinct issues related to signature item grouping: #<a href="https://github.com/ocaml/ocaml/pull/10401">10401</a>.</p>
<h2>@xavierleroy (Xavier Leroy)</h2>
<p>I fixed #<a href="https://github.com/ocaml/ocaml/pull/10339">10339</a>, a mysterious crash on the new Macs with &quot;Apple silicon&quot;.  This was due to a ARM (32 and 64 bits)-specific optimization of array bound checking, which was not taken into account by the platform-independent parts of the back-end, leading to incorrect liveness analysis and wrong register allocation.  #<a href="https://github.com/ocaml/ocaml/pull/10354">10354</a> fixes this by informing the platform-independent parts of the back-end that some platform-specific instructions can raise.  In passing, it refactors similar code that was duplicating platform-independent calculations (of which instructions are pure) in platform-dependent files.</p>
<p>I spent quality time with the Jenkins continuous integration system at Inria, integrating a new Mac Mini M1.  For unknown reasons, Jenkins ran the CI script in x86-64 emulation mode, so we were building and testing an x86-64 version of OCaml instead of the intended ARM64 version.  A bit of scripting later (8b1bc01c3) and voilà, arm64-macos is properly tested as part of our CI.</p>
<p>Currently, I'm reading the &quot;safe points&quot; proposal by Sadiq Jaffer (#<a href="https://github.com/ocaml/ocaml/pull/10039">10039</a>) and the changes on top of this proposed by Damien Doligez.  It's a necessary step towards Multicore OCaml, so we really need to move forward on this one.  It's a nontrivial change involving a new static analysis and a number of tweaks in every code emitter, but things are starting to look good here.</p>
<h2>@mshinwell (Mark Shinwell)</h2>
<p>I did a first pass of review on the safe points PR (#<a href="https://github.com/ocaml/ocaml/pull/10039">10039</a>) and significantly simplified the proposed backend changes.  I've also been involved in discussions about a new function-level attribute to cause an error if safe points (including allocations) might exist within a function's body, to make code that currently assumes this robust.  There will be a design document for this coming in due course.</p>
<p>I fixed the random segfaults that were occurring on the RISC-V Inria CI worker (#<a href="https://github.com/ocaml/ocaml/pull/10349">10349</a>).</p>
<p>In Flambda 2 land we spent two person-days debugging a problem relating to Infix_tag!  We discovered that the code in OCaml 4.12 onwards for traversing GC roots in static data (&quot;caml_globals&quot;) is not correct if any of the roots are closures.  This arises in part because the new compaction code (#<a href="https://github.com/ocaml/ocaml/pull/9728">9728</a>) has a hidden invariant: it must not see any field of a static data root more than once (not even via an Infix_tag).  As far as we know, these situations do not arise in the existing compiler, although we may propose a patch to guard against them.  They arise with Flambda 2 because in order to compile statically-allocated inconstant closures (ones whose environment is partially or wholly computed at runtime) we register closures directly as global roots, so we can patch their environments later.</p>
<h2>@garrigue (Jacques Garrigue)</h2>
<p>I have been working on a number of PRs fixing bugs in the type system, which are now merged:</p>
<ul>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10277">10277</a> fixes a theoretical bug in the principality of GADT type inference (#<a href="https://github.com/ocaml/ocaml/pull/10383">10383</a> applies only in -principal mode)
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10308">10308</a> fixes an interaction between local open in patterns and the new syntax for introducing existential type variables
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10322">10322</a> is an internal change using a normal reference inside of a weak one for backtracking; the weak reference was an optimization when backtracking was a seldom used feature, and was not useful anymore
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10344">10344</a> fixes a bug in the delaying of the evaluation of optional arguments
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10347">10347</a> cleans up some code in the unification algorithm, after a strengthening of universal variable scoping
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10362">10362</a> fixes a forgotten normalization in the type checking algorithm
</li>
</ul>
<p>Some are still in progress:</p>
<ul>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10348">10348</a> improves the way expansion is done during unification, to avoid some spurious GADT related ambiguity errors
</li>
<li>#<a href="https://github.com/ocaml/ocaml/pull/10364">10364</a> changes the typing of the body of the cases of pattern-matchings, allowing to warn in some non-principal situations; it also uncovered a number of principality related bugs inside the the type-checker
</li>
</ul>
<p>Finally, I have worked with Takafumi Saikawa (@t6s) on making the representation of types closer to its logical meaning, by ensuring that one always manipulate a normalized view in #<a href="https://github.com/ocaml/ocaml/pull/10337">10337</a> (large change, evaluation in progress).</p>
<h2>@let-def (Frédéric Bour)</h2>
<p>For some time, I have been working on new approaches to generate error messages from a Menhir parser.</p>
<p>My goal at the beginning was to detect and produce a precise message for the ‘let ;’ situation:</p>
<pre><code class="language-ocaml">let x = 5;
let y = 6
let z = 7
</code></pre>
<p>LR detects an error at the third ‘let’ which is technically correct, although we would like to point the user at the ‘;’ which might be the root cause of the error. This goal has been achieved, but the prototype is far from being ready for production.</p>
<p>The main idea to increase the expressiveness and maintainability of error context identification is to use a flavor of regular expressions.
The stack of a parser defines a prefix of a sentential form. Our regular expressions are matched against it. Internal details of the automaton does not leak (no reference to states), the regular language is defined by the grammar alone.
With appropriate tooling, specific situations can be captured by starting from a coarse expression and refining it to narrow down the interesting cases.</p>
<p>Now I am focusing on one specific point of the ‘error message’ development pipeline: improving the efficiency of ‘menhir --list-errors’.
This command is used to enumerate sentences that cover all erroneous situations (as defined by the LR grammar). On my computer and with the OCaml grammar, it takes a few minutes and quite a lot of RAM. Early results are encouraging and I hope to have a PR for Menhir soon. The performance improvement we are aiming for is to make the command almost real time for common grammars and to tackle bigger grammars by reducing the memory needs.
For instance, in the OCaml case, the runtime is down from 3 minutes to 2–3 seconds and memory consumption goes from a few GiB down to 200 MiB.</p>
|js}
  };
 
  { title = {js|OCaml Multicore - April 2021|js}
  ; slug = {js|multicore-2021-04|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-04-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<h1>Multicore OCaml: April 2021</h1>
<p>Welcome to the April 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! My friends and colleagues on the project in India are going through a terrible second wave of the Covid pandemic, but continue to work to deliver all the updates from the Multicore OCaml project. This month's update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by myself, @kayceesrk and @shakthimaan.</p>
<h2>Upstream OCaml 4.13 development</h2>
<p>GC safepoints continues to be the focus of the OCaml 4.13 release development for multicore. While it might seem quiet with only <a href="https://github.com/ocaml/ocaml/pull/10039">one PR</a> being worked on, you can also look at <a href="https://github.com/sadiqj/ocaml/pull/3">the compiler fork</a> where an intrepid team of adventurous compiler backend hackers have been refining the design.  You can also find more details of ongoing upstream work in the first <a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-1-before-may-2021/7831">core compiler development newsletter</a>.   To quote @xavierleroy from there, &quot;<em>it’s a nontrivial change involving a new static analysis and a number of tweaks in every code emitter, but things are starting to look good here.</em>&quot;.</p>
<h2>Multicore OCaml trees</h2>
<p>The switch to using OCaml 4.12 has now completed, and all of the development PRs are now working against that version.  We've put a lot of focus into establishing whether or not Domain Local Allocation Buffers (<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/508">ocaml-multicore#508</a>) should go into the initial 5.0 patches or not.</p>
<p>What are DLABs?  When testing multicore on larger core counts (up to 128), we observed that there was a lot of early promotion of values from the minor GCs (which are per-domain). DLABs were introduced in order to encourage domains to have more values that remained heap-local, and this <em>should</em> have increased our scalability.  But computers being computers, we noticed the opposite effect -- although the number of early promotions dropped with DLABs active, the overall performance was either flat or even lower!  We're still working on profiling to figure out the root cause -- modern architectures have complex non-uniform and hierarchical memory and cache topologies that interact in unexpected ways.  Stay tuned to next month's monthly about the decision, or follow <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/508">ocaml-multicore#508</a> directly!</p>
<h2>The multicore ecosystem</h2>
<p>Aside from this, the test suite coverage for the Multicore OCaml project has had significant improvement, and we continue to add more and more tests to the project.  Please do continue with your contribution of parallel benchmarks. With respect to benchmarking, we have been able to build the Sandmark-2.0 benchmarks with the <a href="https://github.com/ocurrent/current-bench">current-bench</a> continuous benchmarking framework, which provides a GitHub frontend and PostgreSQL database to store the results.  Some other projects such as Dune have also started also using current-bench, which is nice to see -- it would be great to establish it on the core OCaml project once it is a bit more mature.</p>
<p>We are also rolling out a <a href="https://github.com/ocurrent/ocaml-multicore-ci">multicore-specific CI</a> that can do differential testing against opam packages (for example, to help isolate if something is a multicore-specific failure or a general compilation error on upstream OCaml).  We're <a href="https://multicore.ci.ocamllabs.io:8100/?org=ocaml-multicore">pushing this live</a> at the moment, and it means that we are in a position to begin accepting projects that might benefit from multicore.  <strong>If you do have a project on opam that would benefit from being tested with multicore OCaml, and if it compiles on 4.12, then please do get in touch</strong>.  We're initially folding in codebases we're familiar with, but we need a diversity of sources to get good coverage.  The only thing we'll need is a responsive contact within the project that can work with us on the integration.  We'll start reporting on project statuses if we get a good response to this call.</p>
<p>As always, we begin with the Multicore OCaml ongoing and completed tasks. This is followed by the Sandmark benchmarking project updates and the relevant Multicore OCaml feature requests in the current-bench project. Finally, upstream OCaml work is mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Testing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/23">ocaml-multicore/domainslib#23</a>
Running tests: moving to <code>dune runtest</code> from manual commands in <code>run_test</code> target</p>
<p>At present, the tests are executed with explicit exec commands in
the Makefile, and the objective is to move to using the <code>dune runtest</code> command.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/522">ocaml-multicore/ocaml-multicore#522</a>
Building the runtime with -O0 rather than -O2 causes testsuite to fail</p>
<p>The use of <code>-O0</code> optimization fails the runtime tests, while <code>-O2</code>
optimization succeeds. This needs to be investigated further.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/526">ocaml-multicore/ocaml-multicore#526</a>
weak-ephe-final issue468 can fail with really small minor heaps</p>
<p>The failure of issue468 test is currently being looked into for the
<code>weak-ephe-final</code> tests with a small minor heap (4096 words).</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/528">ocaml-multicore/ocaml-multicore#528</a>
Expand CI runs</p>
<p>The PR implements parallel &quot;callback&quot; &quot;gc-roots&quot; &quot;effects&quot;
&quot;lib-threads&quot; &quot;lib-systhreads&quot; tests, with <code>taskset -c 0</code> option,
and using a small minor heap. The CI coverage needs to be enhanced
to add more variants and optimization flags.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/542">ocaml-multicore/ocaml-multicore#542</a>
Add ephemeron lazy test</p>
<p>Addition of tests to cover ephemerons, lazy values and domain
lifecycle with GC.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/545">ocaml-multicore/ocaml-multicore#545</a>
ephetest6 fails with more number of domains</p>
<p>The test <code>ephetest6.ml</code> fails when more number of domains are
spawned, and also deadlocks at times.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/547">ocaml-multicore/ocaml-multicore#547</a>
Investigate weaktest.ml failure</p>
<p>The <code>weaktest.ml</code> is disabled in the test suite and it is
failing. This needs to be investigated further.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/549">ocaml-multicore/ocaml-multicore#549</a>
zmq-lwt test failure</p>
<p>An opam-ci bug that has reported a failure in the <code>zmq-lwt</code> test. It
is throwing a Zmq.ZMQ_exception with a <code>Context was terminated</code>
error message.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/508">ocaml-multicore/ocaml-multicore#508</a>
Domain Local Allocation Buffers</p>
<p>The code review and the respective changes for the Domain Local
Allocation Buffer implementation is actively being worked upon.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/514">ocaml-multicore/ocaml-multicore#514</a>
Update instructions in ocaml-variants.opam</p>
<p>The <code>ocaml-variants.opam</code> and <code>configure.ac</code> have been updated to
now use the Multicore OCaml repository. We want different version
strings for <code>+domains</code> and <code>+domains+effects</code> for the branches.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/527">ocaml-multicore/ocaml-multicore#527</a>
Port eventlog to CTF</p>
<p>The code review on the porting of the <code>eventlog</code> implementation to
the Common Trace Format is in progress. The relevant code changes
have been made and the tests pass.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/529">ocaml-multicore/ocaml-multicore#529</a>
Fiber size control and statistics</p>
<p>A feature request to set the maximum stack size for fibers, and to
obtain memory statistics for the same.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/533">ocaml-multicore/ocaml-multicore#533</a>
Systhreads synchronization use pthread functions</p>
<p>The <code>pthread_*</code> functions are now used directly instead of
<code>caml_plat_*</code> functions to be in-line with OCaml trunk. The
<code>Sys_error</code> is raised now instead of <code>Fatal error</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/535">ocaml-multicore/ocaml-multicore#535</a>
Remove Multicore stats collection</p>
<p>The configurable stats collection functionality is now removed from
Multicore OCaml. This greatly reduces the diff with trunk and makes
it easy for upstreaming.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/536">ocaml-multicore/ocaml-multicore#536</a>
Remove emit_block_header_for_closure</p>
<p>The <code>emit_block_header_for_closure</code> is no longer used and hence
removed from asmcomp sources.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/537">ocaml-multicore/ocaml-multicore#537</a>
Port @stedolan &quot;Micro-optimise allocations on amd64 to save a register&quot;</p>
<p>The upstream micro-optimise allocations on amd64 to save a register
have now been ported to Multicore OCaml. This greatly brings down
the diff on amd64's emit.mlp.</p>
</li>
</ul>
<h4>Enhancements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/531">ocaml-multicore/ocaml-multicore#531</a>
Make native stack size limit configurable (and fix Gc.set)</p>
<p>The stack size limit for fibers in native made is now made
configurable through the <code>Gc.set</code> interface.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/534">ocaml-multicore/ocaml-multicore#534</a>
Move allocation size information to frame descriptors</p>
<p>The allocation size information is now propagated using the frame
descriptors so that they can be tracked by statmemprof.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/548">ocaml-multicore/ocaml-multicore#548</a>
Multicore implementation of Mutex, Condition and Semaphore</p>
<p>The <code>Mutex</code>, <code>Condition</code> and <code>Semaphore</code> modules are now fully
compatible with stdlib features and can be used with <code>Domain</code>.</p>
</li>
</ul>
<h3>Testing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/532">ocaml-multicore/ocaml-multicore#532</a>
Addition of test for finaliser callback with major cycle</p>
<p>Update to <code>test_finaliser_gc.ml</code> code that adds a test wherein a
finaliser is run with a root in a register.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/541">ocaml-multicore/ocaml-multicore#541</a>
Addition of a parallel tak testcase</p>
<p>Parallel test cases to stress the minor heap and also enter the
minor GC organically without calling a <code>Gc</code> function or a domain
termination have now been added to the repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/543">ocaml-multicore/ocaml-multicore#543</a>
Parallel version of weaklifetime test</p>
<p>The parallel implementation of the <code>weaklifetime.ml</code> test has now
been added to the test suite, where the Weak structures are accessed
by multiple domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/546">ocaml-multicore/ocaml-multicore#546</a>
Coverage of domain life-cycle in domain_dls and ephetest_par tests</p>
<p>Improvement to <code>domain_dls.ml</code> and <code>ephetest_par.ml</code> for better
coverage for domain lifecycle testing.</p>
</li>
</ul>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/530">ocaml-multicore/ocaml-multicore#530</a>
Fix off-by-1 with gc_regs buckets</p>
<p>An off-by-1 bug is now fixed when scanning the stack for the
location of the previous <code>gc_regs</code> bucket.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/540">ocaml-multicore/ocaml-multicore#540</a>
Fix small alloc retry</p>
<p>The <code>Alloc_small</code> macro was not handling the case when the GC
function does not return a minor heap with enough size, and this PR
fixes the same along with code clean-ups.</p>
</li>
</ul>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/retro-httpaf-bench/pull/3">ocaml-multicore/retro-httpaf-bench#3</a>
Add cohttp-lwt-unix to the benchmark</p>
<p>A <code>cohttp-lwt-unix</code> benchmark is now added to the
<code>retro-httpaf-bench</code> package along with the update to the
Dockerfile.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/22">ocaml-multicore/domainslib#22</a>
Move the CI to 4.12 Multicore and Github Actions</p>
<p>The CI has been switched to using GitHub Actions instead of
Travis. The version of Multicore OCaml used in the CI is now
4.12+domains+effects.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/51">ocaml-multicore/mulicore-opam#51</a>
Update merlin and ocaml-lsp installation instructions for 4.12 variants</p>
<p>The README.md has been updated with instructions to use merlin and
ocaml-lisp for <code>4.12+domains</code> and <code>4.12+domains+effects</code> branches.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/dwarf_validator">dwarf_validator</a>
DWARF validation tool</p>
<p>The DWARF validation tool in <code>eh_frame_check.py</code> is now made
available in a public repository. It single steps through the binary
as it executes, and unwinds the stack using the DWARF directives.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/523">ocaml-multicore/ocaml-multicore#523</a>
Systhreads Mutex raises Sys_error</p>
<p>The Systhreads Mutex error checks are now inline with OCaml, as
mentioned in <a href="https://github.com/ocaml/ocaml/pull/9846">Use &quot;error checking&quot; mutexes in the threads
library</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/525">ocaml-multicore/ocaml-multicore#525</a>
Add issue URL for disabled signal handling test</p>
<p>Updated <code>testsuite/disabled</code> with the issue URL
<a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/517">ocaml-multicore#517</a>
for future tracking.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/539">ocaml-multicore/ocaml-multicore#539</a>
Forcing_tag invalid argument to Gc.finalise</p>
<p>Addition of <code>Forcing_tag</code> for tag lazy values when the computation
is being forced. This is included so that <code>Gc.finalise</code> can raise an
invalid argument exception when a block with <code>Forcing_tag</code> is given
as an argument.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<h4>Sandmark</h4>
<ul>
<li>We now have the frontend showing the graph results for Sandmark 2.0 builds
with <a href="https://github.com/ocurrent/current-bench">current-bench</a> for
CI. A raw output of the graph is shown below:
</li>
</ul>
<p><img src="upload://6KOMezRFdkjjNtsfxLx1en2muu3.png" alt="current-bench Sandmark-2.0 frontend |312x499" /></p>
<p>The Sandmark 2.0 benchmarking is moving to use the <code>current-bench</code>
tooling. You can now create necessary issues and PRs for the
Multicore OCaml project in the <code>current-bench</code> project using the
<code>multicore</code> label.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/209">ocaml-bench/sandmark#209</a>
Use rule target kronecker.txt and remove from macro_bench</p>
<p>A rewrite of the graph500seq <code>kernel1.ml</code> implementation based on
the code review suggestions is currently being worked upon.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/215">ocaml-bench/sandmark#215</a>
Remove Gc.promote_to from treiber_stack.ml</p>
<p>We are updating Sandmark to run with 4.12+domains and
4.12+domains+effects, and this patch removes Gc.promote_to from the
runtime.</p>
</li>
</ul>
<h4>current-bench</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/87">ocurrent/current-bench#87</a>
Run benchmarks for old commits</p>
<p>We would like to be able to re-run the benchmarks for older commits
in a project for analysis and comparison.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/103">ocurrent/current-bench#103</a>
Ability to set scale on UI to start at 0</p>
<p>The raw results plotted in the graph need to start from <code>[0, y_max+delta]</code> for the y-axis for better comparison. A  <a href="https://github.com/ocurrent/current-bench/pull/74">PR</a> is available  for the same, and the fixed output is shown in the following graph:</p>
</li>
</ul>
<p><img src="upload://7O9maG73iBof7WgJtXGm80OtbfA.jpeg" alt="current-bench frontend fix 0 baseline" /></p>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/105">ocurrent/current-bench#105</a>
Abstract out Docker image name from <code>pipeline/lib/pipeline.ml</code></p>
<p>The Multicore OCaml uses <code>ocaml/opam:ubuntu-20.10-ocaml-4.10</code> image
while the <code>pipeline/lib/pipeline.ml</code> uses <code>ocaml/opam</code>, and it will
be useful to use an environment variable for the same.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/106">ocurrent/current-bench#106</a>
Use <code>--privileged</code> with Docker run_args for Multicore OCaml</p>
<p>The Sandmark environment uses <code>bwrap</code> for Multicore OCaml benchmark
builds, and hence we need to run the Docker container with
<code>--privileged</code> option. Otherwise, the build exits with an <code>Operation not permitted</code> error.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/107">ocurrent/current-bench#107</a>
Ability to start and run only PostgreSQL and frontend</p>
<p>For Multicore OCaml, we provision the hardware with different
configuration settings for various experiments, and using an ETL
tool to just load the results to the PostgreSQL database and
visualize the same in the frontend will be useful.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/issues/108">ocurrent/current-bench#108</a>
Support for native builds for bare metals</p>
<p>In order to avoid any overhead with Docker, we need a way to run the
Multicore OCaml benchmarks on bare metal machines.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Documentation</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/75">ocurrent/current-bench#75</a>
Fix production deployment; add instructions</p>
<p>The HACKING.md is now updated with documentation for doing a
production deployment of current-bench.</p>
</li>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/90">ocurrent/current-bench#90</a>
Add some solutions to errors that users might run into</p>
<p>Based on our testing of current-bench with Sandmark-2.0, we now have
updated the FAQ in the HACKING.md file.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocurrent/current-bench/pull/96">ocurrent/current-bench#96</a>
Remove hardcoded URL for the frontend</p>
<p>The frontend URL is now abstracted out from the code, so that we can
deploy a current-bench instance on any new pristine server.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/204">ocaml-bench/sandmark#204</a>
Adding layers.ml as a benchmark to Sandmark</p>
<p>The Irmin layers.ml benchmark is now added to Sandmark along with
its dependencies. This is tagged with <code>gt_100s</code>.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>This PR is a work-in-progress. Thanks to Mark Shinwell and Damien
Doligez and Xavier Leroy for their valuable feedback and code suggestions.</p>
</li>
</ul>
<p>Special thanks to all the OCaml users and developers from the community for their continued support and contribution to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>AMD: Advanced Micro Devices
</li>
<li>CI: Continuous Integration
</li>
<li>CTF: Common Trace Format
</li>
<li>DLAB: Domain Local Allocation Buffer
</li>
<li>DWARF: Debugging With Attributed Record Formats
</li>
<li>ETL: Extract Transform Load
</li>
<li>GC: Garbage Collector
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>UI: User Interface
</li>
<li>URL: Uniform Resource Locator
</li>
<li>ZMQ: ZeroMQ
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - February 2021|js}
  ; slug = {js|multicore-2021-02|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-02-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the February 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report. This update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous update's</a> have been compiled by me, @kayceesrk and @shakthimaan. February has seen us focus heavily on stability in the multicore trees, as unlocking the ecosystem builds and running bulk CI has given us a wealth of issues to help chase down corner case issues.  The work on upstreaming the next hunk of changes to OCaml 4.13 is also making great progress.</p>
<p>Overall, we remain on track to have a parallel-capable multicore runtime (versioned 5.0) after the next release of OCaml (4.13.0), although the exact release details have yet to be ratified in a core OCaml developers meeting.  Excitingly, we have also made significant progress on concurrency, and there are details below of a new paper on that topic.</p>
<h2>4.12.0: released with multicore-relevant changes</h2>
<p><a href="">OCaml 4.12.0 has been released</a> with a large number of internal changes <a href="https://github.com/ocaml/ocaml/issues?q=is%3Aclosed+label%3Amulticore-prerequisite+">required for multicore OCaml</a> such as GC colours handling, the removal of the page table and modifications to the heap representations.</p>
<p>From a developer perspective, there is now a new configure option called the <code>nnpchecker</code> which dynamically instruments the runtime to help you spot the use of unboxed C pointers in your bindings. This was described here <a href="https://discuss.ocaml.org/t/ann-a-dynamic-checker-for-detecting-naked-pointers/5805">earlier against 4.10</a>, but it is now also live on the <a href="https://github.com/ocurrent/opam-repo-ci/pull/79">opam repository CI</a>.  From now on, <strong>new opam package submissions will alert you with a failing test if naked pointers are detected</strong> in your opam package test suite.  Please do try to include tests in your opam package to gain the benefits of this!</p>
<p>The screenshot below shows this working on the LLVM package (which is known to have naked pointers at present).</p>
<p><img src="upload://cJM9PwGOvVdDz8eGxkZMK7DOKra.jpeg" alt="image|690x458, 75%" /></p>
<h2>4.13~dev: upstreaming progress</h2>
<p>Our PR queue for the 4.13 release is largely centred around the integration of &quot;safe points&quot;, which provide stronger guarantees that the OCaml mutator will poll the garbage collector regularly even when the application logic isn't allocating regularly.  This work began almost <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/187">three years ago</a> in the multicore OCaml trees, and is now under <a href="https://github.com/ocaml/ocaml/pull/10039">code review in upstream OCaml</a> -- please do chip in with any performance or code size tests on that PR.</p>
<p>Aside from this, the team is working various other pre-requisites such as a multicore-safe Lazy, implementing the memory model (explained in this <a href="https://dl.acm.org/doi/10.1145/3192366.3192421">PLDI 18 paper</a>) and adapting the ephemeron API to be more parallel-friendly.  It is not yet clear which of these will get into 4.13, and which will be put straight into the 5.0 trees yet.</p>
<h2>post OCaml 5.0: concurrency and fibres</h2>
<p>We are very happy to share a new preprint on <a href="https://kcsrk.info/papers/drafts/retro-concurrency.pdf">&quot;Retrofitting Effect Handlers onto OCaml&quot;</a>, which continues our &quot;retrofitting&quot; series to cover the elements of <em>concurrency</em> necessary to express interleavings in OCaml code.  This has been conditionally accepted to appear (virtually) at PLDI 2021, and we are currently working on the camera ready version. Any feedback would be most welcome to @kayceesrk or myself.  The abstract is below:</p>
<blockquote>
<p>Effect handlers have been gathering momentum as a mechanism for modular programming with user-defined effects. Effect handlers allow for non-local control flow mechanisms such as generators, async/await, lightweight threads and coroutines to be composably expressed. We present a design and evaluate a full-fledged efficient implementation of effect handlers for OCaml, an industrial-strength multi-paradigm programming language. Our implementation strives to maintain the backwards compatibility and performance profile of existing OCaml code. Retrofitting effect handlers onto OCaml is challenging since OCaml does not currently have any non-local control flow mechanisms other than exceptions. Our implementation of effect handlers for OCaml: (i) imposes negligible overhead on code that does not use effect handlers; (ii) remains compatible with program analysis tools that inspect the stack; and (iii) is efficient for new code that makes use of effect handlers.</p>
</blockquote>
<p>We have a strong focus on making sure that the existing nice properties of OCaml's native code implementation (and in particular, debugging and backtraces) are maintained in our proposed concurrency extensions. As with any such major change to OCaml, the contents of this paper should be considered research-grade until they have been ratified at a future core OCaml developers meeting.  But by all means, please do experiment with fibres and effects and get us feedback!  We're currently working on a high performance <a href="http://github.com/ocaml-multicore/eioio">direct-style IO stack</a> that has very promising early performance numbers.</p>
<p>If you want to learn more about effects, @kayceesrk gave a talk on <code>Effective Programming</code> at Lambda Days 2021 (<a href="https://speakerdeck.com/kayceesrk/effective-programming-in-ocaml-at-lambda-days-2021">presentation slides</a>).</p>
<h2>Performance Measurements with Sandmark</h2>
<p>@shakthimaan presented the upcoming features of Sandmark 2.0 and its future roadmap in a community talk. The <a href="http://shakthimaan.com/downloads/Sandmark-2.0.pdf">slide deck</a> is published online, and please do send him any feedback to questions you might have about performance benchmarking. A complete regression testing for various targets and build tags for the Sandmark 2.0 -alpha branch was completed, and we continue to work on the new features for a 2.0 release.
Onto the details then! The Multicore OCaml updates are listed first, which are then followed by the various ongoing and completed tasks for the Sandmark benchmarking project. Finally, the ongoing upstream OCaml work is listed for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/46">ocaml-multicore/multicore-opam#46</a>
Multicore compatible ocaml-migrate-parsetree.2.1.0</p>
<p>A patch to make the <code>ocaml-migrate-parsetree</code> sources use the effect
syntax. This now builds fine with Multicore OCaml <code>parallel_minor_gc</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/47">ocaml-multicore/multicore-opam#47</a>
Multicore compatible ppxlib</p>
<p>The effect syntax has now been added to <code>ppxlib</code>, and this is now
compatible with Multicore OCaml.</p>
</li>
</ul>
<h4>Improvements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/474">ocaml-multicore/ocaml-multicore#474</a>
Fixing remarking to be safe with parallel domains</p>
<p>A draft proposal to fix the problem of remarking pools owned by
another domain. The solution aims to move the remarking a pool to
the domain that owns the pool.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/477">ocaml-multicore/ocaml-multicore#477</a>
Move TLS areas to a dedicated memory space</p>
<p>The PR changes the way we allocate an individual domain's TLS. The
present implementation is not optimal for Domain Local Allocation
Buffer, and hence the patch moves the TLS areas to its own memory
alloted space.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/480">ocaml-multicore/ocaml-multicore#480</a>
Remove leave_when_done and friends from STW API</p>
<p>The <code>stw_request.leave_when_done</code> is cleaned up by removing the
barriers from <code>caml_try_run_on_all_domains*</code> and <code>stw_request</code>.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/466">ocaml-multicore/ocaml-multicore#466</a>
Fix corruption when remarking a pool in another domain and that
domain allocates</p>
<p>An on-going investigation for the bytecode test failure for
<code>parallel/domain_parallel_spawn_burn</code>. The recommendation is to have
a remark queue per domain, and a global remark queue to hold work
for any orphaned pools or work which could not be enqueued onto a
domain.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/468">ocaml-multicore/ocaml-multicore#468</a>
Finalisers causing segfault with multiple domains</p>
<p>A test case has been submitted where Finalisers cause segmentation
faults with multiple domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/471">ocaml-multicore/ocaml-multicore#471</a>
Unix.fork fails with &quot;unlock: Operation not permitted&quot;</p>
<p>The no blocking section on fork implementation is causing a fatal
error during unlock with an &quot;operation not permitted&quot; message. This
has been reported by opam-ci.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/473">ocaml-multicore/ocaml-multicore#473</a>
Building an musl requires dynamically linked execinfo</p>
<p>An attempt by Haz to build Multicore OCaml with musl. It failed
because of requiring to link with external libexecinfo.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/475">ocaml-multicore/ocaml-multicore#475</a>
Don't reuse opcode of bytecode instructions</p>
<p>An issue raised by Hugo Heuzard on extending existing opcodes and
appending instructions, instead of reusing opcodes and shifting them
in Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/479">ocaml-multicore/ocaml-multicore#479</a>
Continuation_already_taken crashes toplevel</p>
<p>A continuation already taken segmentation fault crash reported for
the iterator-to-generator exercise for 4.10.0+multicore on x86-64.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Global roots</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/472">ocaml-multicore/ocaml-multicore#472</a>
Major GC: Scan global roots from one domain</p>
<p>As a first step towards parallelizing global roots scanning, a patch
is provided that scans the global roots from only one domain in a
major cycle. The parallel benchmark results with the patch is shown
in the illustration below:</p>
</li>
</ul>
<p><img src="upload://9wDWXWe106w049s4WuxTcxe48mV.jpeg" alt="PR 472 Parallel Benchmarks|690x464" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/476">ocaml-multicore/ocaml-multicore#476</a>
Global roots parallel tests</p>
<p>The <code>globroots_parallel_single.ml</code> and
<code>globroots_parallel_multiple.ml</code> tests are now added to keep a check
on global roots interaction with domain lifecycle.</p>
</li>
</ul>
<h4>CI</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/478">ocaml-multicore/ocaml-multicore#478</a>
Remove .travis.yml</p>
<p>We have now removed the use of Travis for CI, as we now use GitHub
actions.</p>
</li>
<li>
<p>We now have introduced labels that you can use when filing bugs for
Multicore OCaml. The current set of labels are listed at
https://github.com/ocaml-multicore/ocaml-multicore/labels.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/464">ocaml-multicore/ocaml-multicore#464</a>
Replace Field_imm with Field</p>
<p>The Field_imm have been replaced with Field from the concurrent
minor collector.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/470">ocaml-multicore/ocaml-multicore#470</a>
Systhreads: Current_thread-&gt;next value should be saved</p>
<p>A fix to handle the segmentation fault caused when the backup thread
reuses the <code>Current_thread</code> slot.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/208">ocaml-bench/sandmark#208</a>
Fix params for simple-tests/capi</p>
<p>The arguments to the <code>simple-tests/capi</code> benchmarks are now passed
correctly, and they build and execute fine. The same can be verified
using the following commands:</p>
<pre><code>$ TAG='&quot;lt_1s&quot;' make run_config_filtered.json
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/209">ocaml-bench/sandmark#209</a>
Use rule target kronecker.txt and remove from macro_bench</p>
<p>The graph500seq benchmarks have been updated to use a target rule to
build kronecker.txt prior to running <code>kernel2</code> and <code>kernel3</code>. These
set of benchmarks have been removed from the <code>macro_bench</code> tag.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/205">ocaml-bench/sandmark#205</a>
[RFC] Categorize and group by benchmarks</p>
<p>A draft proposal to categorize the Sandmark benchmarks into a family
of algorithms based on their use and application. A suggested list
includes <code>library</code>, <code>formal</code>, <code>numerical</code>, <code>graph</code> etc.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/opam-repository/pull/18203">ocaml/opam-repository#18203</a>
[new release] orun (0.0.1)</p>
<p>A work-in-progress to publish the <code>orun</code> package in
opam.ocaml.org. A new <code>conf-libdw</code> package has also been created to
handle the dependencies.</p>
</li>
<li>
<p>The Sandmark 2.0 -alpha branch now includes all the bench targets
from the present Sandmark master branch, and we have been performing
regression builds for the various tags. The required dependency
packages have also been added to the respective target benchmarks.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/opam-repository/pull/18176">ocaml/opam-repository#18176</a>
[new release] rungen (0.0.1)</p>
<p>The <code>rungen</code> package has been removed from Sandmark 2.0, and is now
available in opam.ocaml.org.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>The Safepoints PR implements the prologue eliding algorithm and is
now rebased to trunk. The effect of eliding optimisation and leaf
function optimisations reduces the number of polls as illustrated
below:</p>
</li>
</ul>
<p><img src="upload://i71oOOzpkK1ZtE54mzKaNngm3qM.png" alt="PR 10039 Polls from Leaf Functions |690x326" /></p>
<p>Our thanks to all the OCaml users and developers in the community for their contribution and support to the project!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>CI: Continuous Integration
</li>
<li>DLAB: Domain Local Allocation Buffer
</li>
<li>GC: Garbage Collector
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PLDI: Programming Language Design and Implementation
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request For Comments
</li>
<li>STW: Stop The World
</li>
<li>TLS: Thread Local Storage
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - March 2021|js}
  ; slug = {js|multicore-2021-03|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-01301|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the March 2021 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> monthly report! The following update and the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous ones</a> have been compiled by me, @kayceesrk and @shakthimaan.  We remain broadly on track to integrate the last of the multicore prerequisites into the next (4.13) release, and to propose domains-only parallelism for OCaml 5.0.</p>
<h3>Upstream OCaml 4.13 development</h3>
<p>The complex safe points PR (<a href="https://github.com/ocaml/ocaml/pull/10039">#10039</a>) is continuing to make progress, with more refinement towards reducing the binary size increase that results from the introduction of more polling points. Special thanks to @damiendoligez for leaping in with a <a href="https://github.com/sadiqj/ocaml/pull/3">PR-to-the-PR</a> to home in on a workable algorithm!</p>
<h3>Multicore OCaml trees</h3>
<p>If there's one thing we're not going to miss, it's git rebasing. The multicore journey began many moons ago with OCaml <a href="https://github.com/ocaml-multicore/ocaml-multicore/commits/master-4.02.2">4.02</a>, and then <a href="https://github.com/ocaml-multicore/ocaml-multicore/tree/4.04.2+multicore">4.04</a>, <a href="https://github.com/ocaml-multicore/ocaml-multicore/tree/4.06.1+multicore">4.06</a>, and the current <a href="https://github.com/ocaml-multicore/ocaml-multicore/commits/parallel_minor_gc">4.10</a>.  We're pleased to announce the hopefully-last rebase of the multicore OCaml trees to OCaml 4.12.0 are now available.  There is now a simpler naming scheme as well to reflect our upstreaming strategy more closely:</p>
<ul>
<li>OCaml 4.12.0+domains is the domains-only parallelism that will be submitted for OCaml 5.0
</li>
<li>OCaml 4.12.0+domains+effects is the version with domains parallelism and effects-based concurrency.
</li>
</ul>
<p>You can find opam installation instructions for these over at <a href="https://github.com/ocaml-multicore/multicore-opam">the multicore-opam</a> repository. There is even an ocaml-lsp-server available, so that your favourite IDE should just work!</p>
<h4>Domains-only parallelism trees</h4>
<p>The bulk of effort this month has been around the integration and debugging of Domain Local Allocation Buffers (DLABs), and also chasing down corner-case failures from stress testing and opam bulk builds. For details, see the long list of PRs in the next section.</p>
<p>We're also cleaning up historical vestiges in order to reduce the diff to OCaml trunk, in order to clear the path to a clean diff for generating OCaml 5.0 PRs for upstream integration.</p>
<h4>Concurrency and Effects trees</h4>
<p><strong>The camera-ready paper for PLDI 2021 on <a href="https://arxiv.org/abs/2104.00250">Retrofitting Effect handlers onto OCaml</a> is now available on arXiv.</strong> The code described in the paper can be used via the <code>4.12.0+domains+effects</code> opam switches. Please feel free to keep any comments coming to @kayceesrk and myself.</p>
<p>We've also been hacking on the multicore IO stack and just beginning to combine concurrency (via effects) and parallelism (via domains) into Linux io_uring, macOS' Grand Central Dispatch and Windows iocp. We'll have more to report on this over the next few months, but early benchmarking numbers on Linux are promising.</p>
<h3>CI and Benchmarking</h3>
<p>We are continuing to expand the testing for different CI configurations for the project. With respect to Sandmark benchmarking, we are in the process of adding the Irmin layers.ml benchmark. There is also an end-to-end pipeline of using the OCurrent <a href="https://github.com/ocurrent/current-bench">current-bench</a> framework to give us benchmarking results from PRs that can be compared to previous runs.</p>
<p>As always, we begin with the Multicore OCaml updates, which are then followed by the ongoing and completed tasks for the Sandmark benchmarking project. Finally, the upstream OCaml work is listed for your reference.</p>
<h1>Detailed Updates</h1>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>DLAB</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/484">ocaml-multicore/ocaml-multicore#484</a>
Thread allocation buffers</p>
<p>The PR provides an implementation for thread local allocation
buffers or <code>Domain Local Allocation Buffers</code>. Code review and
testing of the changes is in progress.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/508">ocaml-multicore/ocaml-multicore#508</a>
Domain Local Allocation Buffers</p>
<p>This is an extension to the <code>Thread allocation buffers</code> PR with
initialization, lazy resizing of the global minor heap size, and
rebase to 4.12 branch.</p>
</li>
</ul>
<h4>Testing</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/522">ocaml-multicore/ocaml-multicore#522</a>
Building the runtime with -O0 rather than -O2 causes testsuite to fail</p>
<p>The runtime tests fail when using <code>-O0</code> instead of <code>-O2</code> and this
needs to be investigated further.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/526">ocaml-multicore/ocaml-multicore#526</a>
weak-ephe-final issue468 can fail with really small minor heaps</p>
<p>The <code>weak-ephe-final</code> tests with a small minor heap (4096 words) cause
the issue468 test to fail.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/528">ocaml-multicore/ocaml-multicore#528</a>
Expand CI runs</p>
<p>A list of requirements to expand the scope and execution of our
existing CI runs for comprehensive testing.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/514">ocaml-multicore/ocaml-multicore#514</a>
Update instructions in ocaml-variants.opam</p>
<p>The <code>ocaml-variants.opam</code> and <code>configure.ac</code> files have been updated
to use the Multicore OCaml repository, and to use a local switch
instead of a global one. The current Multicore OCaml is at the 4.12
branch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/523">ocaml-multicore/ocaml-multicore#523</a>
Systhreads Mutex raises Sys_error</p>
<p>The error checking for Systhreads Mutex should be inline with trunk,
instead of the fatal errors reported by Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/527">ocaml-multicore/ocaml-multicore#527</a>
Port eventlog to CTF</p>
<p>The <code>eventlog</code> implementation has to be ported to the Common Trace
Format. The log output should be consistent with the
parallel_minor_gc output, and stress testing need to be performed.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/490">ocaml-multicore/ocaml-multicore#490</a>
Remove getmutablefield from bytecode</p>
<p>The bytecode compiler and interpreter have been updated by removing
the <code>getmutablefield</code> opcodes.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/496">ocaml-multicore/ocaml-multicore#496</a>
Replace caml_initialize_field with caml_initialize</p>
<p>A patch to replace <code>caml_initialize_field</code>, which was earlier used
with the concurrent minor collector, is now replaced with
<code>caml_initialize</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/503">ocaml-multicore/ocaml-multicore#503</a>
Re-enable lib-obj and asmcomp/is_static tests</p>
<p>The <code>lib-obj</code> and <code>asmcomp/is_static</code> tests have been re-enabled and
the configure settings have been updated for Multicore
NO_NAKED_POINTERS.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/506">ocaml-multicore/ocaml-multicore#506</a>
Replace <code>Op_val</code> with <code>Field</code></p>
<p>The use of <code>Op_val (x)[i]</code> has been replaced with <code>Field (x, i)</code> to
be consistent with trunk implementation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/507">ocaml-multicore/ocaml-multicore#507</a>
Change interpreter to use naked code pointers</p>
<p>The changes have been made to identify naked pointers in the
interpreter stack to be compatible with trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/516">ocaml-multicore/ocaml-multicore#516</a>
Remove caml_root API</p>
<p>The <code>caml_root</code> variables have been changed to <code>value</code> type and are
managed as generational global roots. Hence, the <code>caml_root</code> API is
now removed.</p>
</li>
</ul>
<h4>DLAB</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/511">ocaml-multicore/ocaml-multicore#511</a>
Allocate unique root token on the major heap instead of the minor</p>
<p>The unique root token allocation is now done on the major heap
allocation that does not raise any exception, and exits cleanly when
a domain creation fails.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/513">ocaml-multicore/ocaml-multicore#513</a>
Clear the minor heap at the end of a collection in debug runtime</p>
<p>A debug value is written to every element of the minor heap for
debugging failures. We now clear the minor heap at the end of a
minor collection.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/519">ocaml-multicore/ocaml-multicore#519</a>
Make timing test more robust</p>
<p>The <code>timing.ml</code> test has been updated to be more resilient for
testing with DLABs.</p>
</li>
</ul>
<h4>Enhancements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/477">ocaml-multicore/ocaml-multicore#477</a>
Move TLS areas to a dedicated memory space</p>
<p>In order to support Domain Local Allocation Buffer, we now move the
TLS areas to its own memory alloted space thereby changing the way
we allocate an individual domain's TLS.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/480">ocaml-multicore/ocaml-multicore#480</a>
Remove leave_when_done and friends from STW API</p>
<p>The barriers from <code>caml_try_run_on_all_domains*</code> and <code>stw_request</code>
are removed by cleaning up the <code>stw_request.leave_when_done</code>
implementation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/481">ocaml-multicore/ocaml-multicore#481</a>
Don't share array amongst domains in gc-roots tests</p>
<p>Every domain should have its own array, and the parallel global
roots tests have been updated with this change.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/494">ocaml-multicore/ocaml-multicore#494</a>
Stronger invariants on unix_fork</p>
<p>We now enforce stronger invariants such that no other domain can run
alongside domain 0 (<code>caml_domain_alone</code>) for <code>unix_fork</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/515">ocaml-multicore/ocaml-multicore#515</a>
Add memprof stubs to build and stdlib</p>
<p>The required <code>memprof</code> functions have been added to build <code>stdlib</code>,
and also to build memprof for the runtime.</p>
</li>
</ul>
<h4>Lazy Updates</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/501">ocaml-multicore/ocaml-multicore#501</a>
Safepoints lazy fix</p>
<p>The lazy implementation need to be aware of safe points, and we need
to differentiate between recursive forcing of lazy values from
parallel forcing. These fixes are from
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/492">ocaml-multicore#492</a>
and
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/493">ocaml-multicore#493</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/505">ocaml-multicore/ocaml-multicore#505</a>
Add a unique domain token to distinguish lazy forcing failure</p>
<p>A <code>caml_ml_domain_unique_token</code> has been added to handle racy access
by multiple mutators. This fixes the <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/504">using domain id
(int)</a>
to identify forcing domain of lazy block issue.</p>
</li>
</ul>
<h4>Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/487">ocaml-multicore/ocaml-multicore#487</a>
systhreads: set gc_regs_buckets and friends to NULL at thread startup</p>
<p>Pointers have been initialized to NULL in <code>systhreads/st_stubs.c</code>
which solves the <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/485">segmentation
fault</a>
observed when running the Layers benchmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/491">ocaml-multicore/ocaml-multicore#491</a>
Reinitialize child locks after fork</p>
<p>The runtime needs to operate correctly after a <code>fork</code>, and this
patch fixes it with proper resetting of domain lock.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/495">ocaml-multicore/ocaml-multicore#495</a>
Fix problems with finaliser orphaning</p>
<p>A fix for how we merge finalization tables for orphaned finaliser
work. A test case has also been added to the PR.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/499">ocaml-multicore/ocaml-multicore#499</a>
Fix backtrace unwind</p>
<p>The unwinding of stacks over callbacks was not happening correctly
and the discrepancy in <code>caml_next_frame_descriptior</code> is now resolved.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/509">ocaml-multicore/ocaml-multicore#509</a>
Fix for bad setup of Continuation_already_taken exception in bytecode</p>
<p>A patch to fix the <code>Continuation_already_taken</code> exception which was
not set up as needed in the bytecode execution.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/510">ocaml-multicore/ocaml-multicore#510</a>
Update a testcase in principality-and-gadts.ml</p>
<p>A change in <code>principality-and-gadts.ml</code> to log the correct output as
compared to 4.12 branch in ocaml/ocaml.</p>
</li>
</ul>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/46">ocaml-multicore/multicore-opam#46</a>
Multicore compatible ocaml-migrate-parsetree.2.1.0</p>
<p>The <code>ocaml-migrate-parsetree</code> package uses the effect syntax and now
builds with Multicore OCaml <code>parallel_minor_gc</code> branch.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/47">ocaml-multicore/multicore-opam#47</a>
Multicore compatible ppxlib</p>
<p>The effect syntax has been added to <code>ppxlib</code> and is also now
compatible with Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/49">ocaml-multicore/multicore-opam#49</a>
4.12 Multicore configs</p>
<p>Added configurations to install <code>4.12.0+domains+effects</code> and
<code>4.12.0+domains</code> OCaml variants.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/473">ocaml-multicore/ocaml-multicore#473</a>
Building on musl requires dynamically linked execinfo</p>
<p>The opam files to allow installation on musl-based environments for
Multicore OCaml have been added to the repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/482">ocaml-multicore/ocaml-multicore#482</a>
Check for -lexecinfo in order to build on musl/alpine</p>
<p>A <code>configure</code> script has been added which checks for <code>-lexecinfo</code> in
order to support building Multicore OCaml on musl/alpine.</p>
</li>
</ul>
<h4>Documentation</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/502">ocaml-multicore/ocaml-multicore#502</a>
Update README to introduce 4.12+domains+effects and 4.12+domains</p>
<p>We have updated the README file with the current list of active
branches, and the names of the historic variants.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/520">ocaml-multicore/ocaml-multicore#520</a>
Clarify comment on RacyLazy</p>
<p>A documentation update in <code>stdlib/lazy.mli</code> that clarifies when
<code>RacyLazy</code> and <code>Undefined</code> are raised.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/486">ocaml-multicore/ocaml-multicore#486</a>
Sync no-effects-syntax to parallel_minor_gc branch</p>
<p>The <code>ocaml-multicore:no-effects-syntax</code> branch is now up to date
with the <code>parallel_minor_gc</code> branch changes.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/489">ocaml-multicore/ocaml-multicore#489</a>
Remove promote_to</p>
<p>The <code>promote_to</code> function was used in the concurrent minor GC. It is
not required any more and hence has been removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/500">ocaml-multicore/ocaml-multicore#500</a>
Replace caml_modify_field with caml_modify</p>
<p>The <code>caml_modify_field</code> is no longer necessary and has been replaced
with <code>caml_modify</code>.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/204">ocaml-bench/sandmark#204</a>
Adding layers.ml as a benchmark to Sandmark</p>
<p>The inclusion of Irmin layers.ml benchmark with updates to all its
dependency requirements.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/209">ocaml-bench/sandmark#209</a>
Use rule target kronecker.txt and remove from macro_bench</p>
<p>A review of the graph500seq <code>kernel1.ml</code> implementation has been
done, and code changes have been proposed. The <code>macro_bench</code> tag
will be retained for the <code>graph500</code> benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/212">ocaml-bench/sandmark#212</a>
Increasing the major heap allocation on some benchmarks</p>
<p>A work in progress to add more longer running benchmarks that
involve major heap allocation. Some of the parameters have been
updated with higher values, and more loops have been added as well.</p>
</li>
<li>
<p>We now have integrated the build of Sandmark 2.0 with
<a href="https://github.com/ocurrent/current-bench">current-bench</a> for
CI. The results of the benchmark runs are now pushed to a PostgreSQL
database as shown below:</p>
<pre><code>docker=# select * from benchmarks;
-[ RECORD 1 ]--+-------------------------------------------------------
run_at         | 2021-03-26 11:21:20.64
repo_id        | local/local
commit         | 55c6fb6416548737b715d6d8fde6c0f690526e42
branch         | 2.0.0-alpha+001
pull_number    | 
benchmark_name | 
test_name      | coq.BasicSyntax.v
metrics        | {&quot;maxrss_kB&quot;: 678096, &quot;time_secs&quot;: 101.99969387054443}
duration       | 00:37:52.776357
-[ RECORD 2 ]--+-------------------------------------------------------
run_at         | 2021-03-26 11:21:20.64
repo_id        | local/local
commit         | 55c6fb6416548737b715d6d8fde6c0f690526e42
branch         | 2.0.0-alpha+001
pull_number    | 
benchmark_name | 
test_name      | thread_ring_lwt_mvar.20_000
metrics        | {&quot;maxrss_kB&quot;: 8096, &quot;time_secs&quot;: 2.6146790981292725}
duration       | 00:37:52.776357
...
</code></pre>
<p>We will continue to work on adding more workflows and features to
<code>current-bench</code> to support Sandmark builds.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/202">ocaml-bench/sandmark#202</a>
Added bench clean target in the Makefile</p>
<p>A <code>benchclean</code> target to remove the generated benchmarks and its
results while still retaining the <code>_opam</code> folder has been added to
the Makefile.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/203">ocaml-bench/sandmark#203</a>
Implement ITER support</p>
<p>The use of ITER variable is now supported in Sandmark, and you can
run multiple iterations of the benchmarks. For example, with
<code>ITER=2</code>, a couple of summary .bench files are created with the
benchmark results as shown below:</p>
<pre><code>$ TAG='&quot;run_in_ci&quot;' make run_config_filtered.json
$ ITER=2 RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench 

$ ls _results/
4.10.0+multicore_1.orun.summary.bench  4.10.0+multicore_2.orun.summary.bench
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/208">ocaml-bench/sandmark#208</a>
Fix params for simple-tests/capi</p>
<p>A minor fix in <code>run_config.json</code> to correctly pass the arguments to
the <code>simple-tests/capi</code> benchmark execution. You can verify the same
using the following commands:</p>
<pre><code>$ TAG='&quot;lt_1s&quot;' make run_config_filtered.json
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/210">ocaml-bench/sandmark#210</a>
Don't share array in global roots parallel benchmarks</p>
<p>A patch to not share array in global roots implementation for
parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/213">ocaml-bench/sandmark#213</a>
Resolve dependencies for 4.12.1+trunk, 4.12.0+domains and 4.12.0+domains+effects</p>
<p>The <code>dependencies/packages</code> have now been updated to be able to
build <code>4.12.1+trunk</code>, <code>4.12.0+domains</code> and <code>4.12.0+domains+effects</code>
branches with Sandmark.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>The review of the Safepoints PR is in progress. Special thanks to
Damien Doligez for his <a href="https://github.com/sadiqj/ocaml/pull/3">code
suggestions</a> on safepoints
and inserting polls. There is still work to be done on
optimizations.</p>
</li>
</ul>
<p>Many thanks to all the OCaml users, developers and contributors in the
community for their support to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>CI: Continuous Integration
</li>
<li>CTF: Common Trace Format
</li>
<li>DLAB: Domain Local Allocation Buffer
</li>
<li>GC: Garbage Collector
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>STW: Stop The World
</li>
<li>TLS: Thread Local Storage
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - January 2021|js}
  ; slug = {js|multicore-2021-01|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-01-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to a double helping of the multicore monthlies, with December 2020 and January 2021 bundled together (the team collectively collapsed into the end of year break for a well deserved rest). We encourage you to review all the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous monthly </a> updates for 2020 which have been compiled by @shakthimaan, @kayceesrk, and me.</p>
<p>Looking back over 2020, we achieved a number of major milestones towards upstreaming multicore OCaml. The major highlights include the implementation of the eventlog tracing system to make debugging complex parallelism practical, the enormous rebasing of from OCaml 4.06 to 4.11, a chapter on parallel programming, the publication of &quot;Retrofitting Parallelism onto OCaml&quot; at ICFP 2020, the production use of the Sandmark benchmark, and the implementation of system threading integration.  While all this was happening in the multicore code trees, the upstreaming efforts into mainline OCaml also went into full gear, with @xavierleroy leading the efforts from the core team to ensure that the right pieces went into various releases of OCaml with the same extensive code review as any other features get.</p>
<p>The end of 2020 saw  enhancements and updates to the ecosystem libraries, with more tooling becoming available. In particular, we would like to thank:</p>
<ul>
<li>@mattpallissard for getting <code>merlin</code> and <code>dot-merlin-reader</code> working with Multicore OCaml 4.10.  This makes programming using OCaml Platform tools like the VSCode plugin much more pleasant.
</li>
<li>@eduardorfs for testing the <code>no-effect-syntax</code> Multicore OCaml branch with a ReasonML project.
</li>
</ul>
<p>@kayceesrk also gave a couple of public talks online:</p>
<ul>
<li><a href="https://www.youtube.com/watch?v=mel76DFerL0">Multicore OCaml - What's coming in 2021</a>, hosted by Nomadic Labs.
</li>
<li><a href="https://kcsrk.info/slides/nus_effects.pdf">Effect handlers in Multicore OCaml</a>. NUS PLV Research Seminar.
</li>
</ul>
<p>We're really grateful to the OCaml core developers for giving this effort so much of their time and focus in 2020!  We're working on a broader plan for 2021's exciting multicore roadmap which will be included in the next monthly after a core OCaml developer's meeting ratifies it soon.  The broad strategy remains consistent: putting pieces of functionality steadily into each upcoming OCaml release so that each can be reviewed and tested in isolation, ahead of the OCaml 5.0 release which will include domains parallelism.</p>
<p>With <a href="https://discuss.ocaml.org/t/ocaml-4-12-0-second-beta-release/7171">OCaml 4.12 out in beta</a>, our January has mainly been spent tackling some of the big pieces needed for OCaml 4.13.  In particular, the <a href="https://github.com/ocaml/ocaml/pull/10039">safe points PR</a> has seen a big update (and corresponding performance improvements), and we have been working on the design and implementation of Domain-Local Allocation Buffers (DLAB).  We've also started the process of figuring out how to merge the awesome sequential best-fit allocator with our multicore major GC, to get the best of both worlds in OCaml 5.0.  The multicore IO stack has also restarted development, with focus on Linux's new <code>io_uring</code> kernel interface before retrofitting the old stalwart <code>epoll</code> and <code>kqueue</code> interfaces.</p>
<p>Tooling-wise, the multicore Merlin support began in December is now merged, thanks to @mattpallissard and @eduardorfs. We continue to work on the enhancements for Sandmark 2.0 benchmarking suite for an upcoming alpha release -- @shakthimaan gave an online seminar about these improvements to the multicore team which has been recorded and will be available in the next monthly for anyone interested in contributing to our benchmarking efforts.</p>
<p>As with previous reports, the Multicore OCaml updates are listed first for the month of December 2020 and then January 2021. The upstream OCaml ongoing work is finally mentioned for your reference after the multicore-tree specific pieces..</p>
<h1>December 2020</h1>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/lockfree/issues/6">ocaml-multicore/lockfree#6</a>
Current status and potential improvements</p>
<p>An RFC that lists the current status of the <code>lockfree</code> library, and
possible performance improvements for the Kcas dependency, test
suite and benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/lockfree/issues/7">ocaml-multicore/lockfree#7</a>
Setup travis CI build</p>
<p>A .travis.yml file, similar to the one in
https://github.com/ocaml-multicore/domainslib/ needs to be created
for the CI build system.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/effects-examples/issues/20">ocaml-multicore/effects-examples#20</a>
Add WebServer example</p>
<p>An open task to add the <code>httpaf</code> based webserver implementation to
the effects-examples repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/effects-examples/issues/21">ocaml-multicore/effects-examples#21</a>
Investigate CI failure</p>
<p>The CI build fails on MacOS with a time out, but, it runs fine on
Linux. An on-going investigation is pending.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/issues/39">ocaml-multicore/multicore-opam#39</a>
Multicore Merlin</p>
<p>Thanks to @mattpallissard (Matt Pallissard) and @eduardorfs
(Eduardo Rafael) for testing <code>merlin</code> and <code>dot-merlin-reader</code>, and
to get it working with Multicore OCaml 4.10! The same has been
tested with VSCode and Atom, and a screenshot of the UI is shown
below.
<img src="upload://hD5jZzwblFC4oq4UEk4agfu24W7.png" alt="PR 39 Multicore Merlin Screenshot|435x350" /></p>
</li>
</ul>
<h4>API</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/448">ocaml-multicore/ocaml-multicore#448</a>
Reintroduce caml_stat_accessors in the C API</p>
<p>The <code>caml_stat_minor_words</code>, <code>caml_stat_promoted_words</code>,
<code>caml_allocated_words</code> <code>caml_stat_minor_collections</code> fields are not
exposed in Multicore OCaml. This is a discussion to address possible
solutions for the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/459">ocaml-multicore/ocaml-multicore#459</a>
Replace caml_root API with global roots</p>
<p>A work-in-progress to convert variables of type <code>caml_root</code> to
<code>value</code>, and to register them as global root or generational global
root, in order to remove the caml_root API entirely.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/450">ocaml-multicore/ocaml-multicore#450</a>
&quot;rogue&quot; systhreads and domain termination</p>
<p>An RFC to discuss on the semantics of domain termination for
non-empty thread chaining. In Multicore OCaml, a domain termination
does not mean the end of a program, and slot reuse adds complexity
to the implementation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/451">ocaml-multicore/ocaml-multicore#451</a>
Note for OCaml 5.0: Get rid of compatibility.h</p>
<p>OCaml Multicore removed <code>modify</code> and <code>initialize</code> from
<code>compatibility.h</code>, and this is a tracking issue to remove
compatibility.h for OCaml 5.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/458">ocaml-multicore/ocaml-multicore#458</a>
no-effect-syntax: Remove effects from typedtree</p>
<p>The PR removes the the effect syntax use from <code>typedtree.ml</code>, and
enables external applications that use the AST to work with
domains-only Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/461">ocaml-multicore/ocaml-multicore#461</a>
Remove stw/leader_collision events from eventlog</p>
<p>A patch to make viewing and analyzing the logs better by removing
the <code>stw/leader_collision</code> log messages.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/effects-examples/pull/23">ocaml-multicore/effects-examples#23</a>
Migrate to dune</p>
<p>The build scripts were using OCamlbuild, and they have been ported
to now use dune.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/402">ocaml-multicore/ocaml-multicore#402</a>
Split handle_gc_interrupt into handling remote and polling sections</p>
<p>The PR includes the addition of <code>caml_poll_gc_work</code> that contains
the polling of GC work done in <code>caml_handle_gc_interrupt</code>. This
facilitates handling of interrupts recursively without introducing
new state.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/439">ocaml-multicore/ocaml-multicore#439</a>
Systhread lifecycle work</p>
<p>The improvement fixes a race condition in <code>caml_thread_scan_roots</code>
when two domains are initializing, and rework has been done for
improving general resource handling and freeing of descriptors and
stacks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/446">ocaml-multicore/ocaml-multicore#446</a>
Collect GC stats at the end of minor collection</p>
<p>The GC statistics is collected at the end of a minor collection, and
the double buffering of GC sampled statistics has been removed. The
change does not have an impact on the existing benchmark runs as
observed against stock OCaml from the following illustration:</p>
<p><img src="upload://i4js513ml6Qw6GvkZuQsiVuowYB.png" alt="PR 446 Graph Image|690x317" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/454">ocaml-multicore/ocaml-multicore#454</a>
Respect ASM_CFI_SUPPORTED flag in amd64</p>
<p>The CFI directives in <code>amd64.S</code> are now guarded by
<code>ASM_CFI_SUPPORTED</code>, and thus compilation with <code>--disable-cfi</code> will
now provide a clean build.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/455">ocaml-multicore/ocaml-multicore#455</a>
No blocking section on fork</p>
<p>A patch to handle the case when a rogue thread attempts to take over
the thread <code>masterlock</code> and to prevent a child thread from moving to
an invalid state. Dune can now be used safely with Multicore OCaml.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/rungen/pull/1">ocaml-bench/rungen#1</a>
Fix compiler warnings and errors for clean build</p>
<p>The patch provides minor fixes for a clean build of <code>rungen</code> with dune
to be used with Sandmark 2.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/orun/pull/2">ocaml-bench/orun#2</a>
Fix compiler warnings and errors for clean build</p>
<p>The unused variables and functions have been removed to remove all
the warnings and errors produced when building <code>orun</code> with dune.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/198">ocaml-bench/sandmark#198</a>
Noise in Sandmark</p>
<p>An RFC to measure the noise between multiple execution runs of the
benchmarks to better understand the performance with various
hardware configuration settings, and with ASLR turned on and off.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/200">ocaml-bench/sandmark#200</a>
Global roots microbenchmark</p>
<p>The patch includes <code>globroots_seq.ml</code>, <code>globroots_sp.ml</code>, and
<code>globroots_mp.ml</code> that adds microbenchmarks to measure the
efficiency of global root scanning.</p>
</li>
<li>
<p>We are continuing to integrate the existing Sandmark benchmark test
suite with a Sandmark 2.0 native dune build environment for use with
opam compiler switch environment. The existing benchmarks have been
ported to the same to use their respective dune files. The <code>orun</code>
and <code>rungen</code> packages now live in separate GitHub repositories.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/196">ocaml-bench/sandmark#196</a>
Filter benchmarks based on tag</p>
<p>The benchmarks can now be filtered based on <code>tags</code> instead of custom
target .json files. You can now build the benchmarks using the
following commands:</p>
<pre><code>$ TAG='&quot;run_in_ci&quot;' make run_config_filtered.json 
$ RUN_CONFIG_JSON=run_config_filtered.json make ocaml-versions/4.10.0+multicore.bench
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/201">ocaml-bench/sandmark#201</a>
Fix compiler version in CI</p>
<p>A minor update in .drone.yml to use
<code>ocaml-versions/4.10.0+multicore.bench</code> in the CI for
4.10.0+multicore+serial.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9876">ocaml/ocaml#9876</a>
Do not cache young_limit in a processor register</p>
<p>This PR for the removal of <code>young_limit</code> caching in a register for
ARM64, PowerPC and RISC-V ports hardware is currently under review.</p>
</li>
</ul>
<h1>January 2021</h1>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/464">ocaml-multicore/ocaml-multicore#464</a>
Replace Field_imm with Field</p>
<p>The patch replaces the Field immediate use with Field from the
concurrent minor collector.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/468">ocaml-multicore/ocaml-multicore#468</a>
Finalisers causing segfault with multiple domains</p>
<p>An on-going test case where Finalisers cause segmentation faults
with multiple domains.</p>
</li>
<li>
<p>The design and implementation of Domain-Local Allocation Buffers
(DLAB) is underway, and the relevant notes on the same are available
in the following <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Domain-Local-Allocation-Buffers">DLAB
Wiki</a>.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/rungen/pull/1">ocaml-bench/rungen#1</a>
Fix compiler warnings and errors for clean build</p>
<p>Minor fixes for a clean build of <code>rungen</code> with dune to be used with
Sandmark 2.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/orun/pull/2">ocaml-bench/orun#2</a>
Fix compiler warnings and errors for clean build</p>
<p>A patch to remove unused variables and functions without any
warnings and errors when building <code>orun</code> with dune.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/rungen/pull/2">ocaml-bench/rungen#2</a>
Added meta files for dune-release lint</p>
<p>The <code>dune-release lint</code> checks for rungen now pass with the
inclusion of CHANGES, LICENSE and updates to rungen.opam files.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/orun/pull/3">ocaml-bench/orun#3</a>
Add meta files for dune-release lint</p>
<p>The CHANGES, LICENSE, README.md and orun.opam files have been added
to prepare the sources for an opam.ocaml.org release.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/issues/39">ocaml-multicore/multicore-opam#39</a>
Multicore Merlin</p>
<p>Thanks to @mattpallissard (Matt Pallissard) and @eduardorfs (Eduardo
Rafael) for testing <code>merlin</code> and <code>dot-merlin-reader</code>, and to get it
working with Multicore OCaml 4.10! The changes work fine with VSCode
and Atom. The corresponding
<a href="https://github.com/ocaml-multicore/multicore-opam/pull/40">PR#40</a>
is now merged.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/45">ocaml-multicore/ocaml-multicore#45</a>
Merlin and OCaml-LSP installation instructions</p>
<p>The README.md file has been updated to include installation
instructions to use Merlin and OCaml LSP Server.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/458">ocaml-multicore/ocaml-multicore#458</a>
no-effect-syntax: Remove effects from typedtree</p>
<p>The PR enables external applications that use the AST to work with
domains-only Multicore OCaml, and removes the effect syntax use from
<code>typedtree.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/461">ocaml-multicore/ocaml-multicore#461</a>
Remove stw/leader_collision events from eventlog</p>
<p>The <code>stw/leader_collision</code> log messages have been cleaned up to make
it easier to view and analyze the logs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/462">ocaml-multicore/ocaml-multicore#462</a>
Move from Travis to GitHub Actions</p>
<p>The continuous integration builds are now updated to use GitHub
Actions instead of Travis CI, in order to be similar to that of
upstream CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/463">ocaml-multicore/ocaml-multicore#463</a>
Minor GC: Restrict global roots scanning to one domain</p>
<p>The live domains scan all the global roots during a minor
collection, and the patch restricts the global root scanning to just
one domain. The sequential and parallel macro benchmark results are
given below:</p>
</li>
</ul>
<p><img src="upload://kNn97x2EouFqVZpSj82Pa6yt2wB.jpeg" alt="PR 463 OCaml Multicore Sequential |690x318" /></p>
<p><img src="upload://7usja76xxxUEOTPTRFmRUQ1H6dL.jpeg" alt="PR 463 OCaml Multicore Parallel |690x458" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/467">ocaml-multicore/ocaml-multicore#467</a>
Disable the pruning of the mark stack</p>
<p>A PR to disable the mark stack overflow for a concurrency bug that
occurs when remarking a pool in another domain when that domain also
does allocations.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/202">ocaml-bench/sandmark#202</a>
Add bench clean target in the Makefile</p>
<p>A <code>benchclean</code> target has been added to the Makefile to only remove
<code>_build</code> and <code>_results</code>. The <code>_opam</code> folder is retained with the
required packages and dependencies installed, so that the benchmarks
can be quickly re-built and executed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/203">ocaml-bench/sandmark#203</a>
Implement ITER support</p>
<p>The use of ITER has been correctly implemented with multiple
instances of the benchmarks being built, and to repeat the
executions of the benchmarks. This helps to take averages from
multiple runs for metrics. For example, using ITER=2 produces two
<code>.summary.bench</code> files as shown below:</p>
<pre><code>$ ls _build/
  4.10.0+multicore_1  4.10.0+multicore_2  log

$ ls _results/
  4.10.0+multicore_1.orun.summary.bench  4.10.0+multicore_2.orun.summary.bench
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/204">ocaml-bench/sandmark#204</a>
Adding layers.ml as a benchmark to Sandmark</p>
<p>Th inclusion of Irmin layers benchmark and its dependencies into
Sandmark. This is a work-in-progress.</p>
</li>
<li>
<p>We are continuing the enhancements for Sandmark 2.0 that uses a
native dune to build and execute the benchmarks, and also port and
test with the current Sandmark configuration files. The <code>orun</code> and
<code>rungen</code> packages have been moved to their respective
repositories. The use of a meta header entry to the .summary.bench
file, ITER support, and package override features have been
implemented.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/200">ocaml-bench/sandmark#200</a>
Global roots microbenchmark</p>
<p>The implementation of <code>globroots_seq.ml</code>, <code>globroots_sp.ml</code>, and
<code>globroots_mp.ml</code> to measure the efficiency of global root scanning
has been added to the microbenchmarks.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>An update to the draft Safepoints implementation that uses the
prologue eliding algorithm and is now rebased to trunk.The runtime
benchmark results on sherwood (an AMD EPYC 7702) and thunderx (a
Cavium ThunderX CN8890) are shown below:</p>
<p><img src="upload://p7YF1eKFPnXJjSrTQQ2AAiIPiUl.png" alt="PR 10039 OCaml Sherwood |690x391" />
<img src="upload://8o3nuJUhByBqJqVJEJK91hHsqNF.png" alt="PR 10039 OCaml ThunderX |690x389" /></p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9876">ocaml/ocaml#9876</a>
Do not cache young_limit in a processor register</p>
<p>The PR removes the caching of <code>young_limit</code> in a register for ARM64,
PowerPC and RISC-V ports hardware.</p>
</li>
</ul>
<p>Our thanks to all the OCaml users and developers in the community for their continued support and contribution to the project, and we look forward to working with you in 2021!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>ARM: Advanced RISC Machine
</li>
<li>ASLR: Address Space Layout Randomization
</li>
<li>AST: Abstract Syntax Tree
</li>
<li>CFI: Call Frame Information
</li>
<li>CI: Continuous Integration
</li>
<li>GC: Garbage Collector
</li>
<li>ICFP: International Conference on Functional Programming
</li>
<li>JSON: JavaScript Object Notation
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request For Comments
</li>
<li>RISC-V: Reduced Instruction Set Computing - V
</li>
<li>UI: User Interface
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - November 2020|js}
  ; slug = {js|multicore-2020-11|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-11-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the November 2020 Multicore OCaml report! This update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by @shakthimaan, @kayceesrk, and @avsm.</p>
<p><strong>Multicore OCaml:</strong> Since the support for systhreads has been merged last month, many more ecosystem packages compile.  We have been doing bulk builds (using a specialised <a href="http://check.ocamllabs.io:8082">opam-health-check instance</a>) against the opam repository in order to chase down the last of the lingering build bugs. Most of the breakage is around packages using C stubs related to the garbage collector, although we did find a few actual multicore bugs (related to the thread machinery when using dynlink). The details are under &quot;ecosystem&quot; below. We also spent a lot of time on optimising the stack discipline in the multicore compiler, as part of writing a draft paper on the effect system (more details on that later).</p>
<p><strong>Upstream OCaml:</strong> The <a href="https://discuss.ocaml.org/t/ocaml-4-12-0-second-alpha-release/6887">4.12.0alpha2 release</a> is now out, featuring the dynamic naked pointer checker to help make your code only used external pointers that are boxed. Please do run your codebase on it to help prepare.  For OCaml 4.13 (currently the <code>trunk</code>) branch, we had a full OCaml developers meeting where we decided on the worklist for what we're going to submit upstream.  The major effort is on <a href="https://github.com/ocaml/ocaml/pull/10039">GC safe points</a> and not caching the <a href="https://github.com/ocaml/ocaml/pull/9876">minor heap pointer</a>, after which the runtime domains support has all the necessary prerequisites upstream.  Both of those PRs are highly performance sensitive, so there is a lot of poring over graphs going on (notwithstanding the irrepressible @stedolan offering <a href="https://github.com/ocaml/ocaml/pull/10039#issuecomment-733912979">a massive driveby optimisation</a>).</p>
<p><strong>Sandmark Benchmarking:</strong> The lockfree and Graph500 benchmarks have been added and updated to Sandmark respectively, and we continue to work on the tooling aspects. Benchmarking tests are also being done on AMD, ARM and PowerPC hardware to study the performance of the compiler. With reference to stock OCaml, the safepoints PR has now landed for review.</p>
<p>As with previous updates, the Multicore OCaml tasks are listed first, which are then followed by the progress on the Sandmark benchmarking test suite. Finally, the upstream OCaml related work is mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/439">ocaml-multicore/ocaml-multicore#439</a>
Systhread lifecycle work</p>
<p>An improvement to the initialization of systhreads for general
resource handling, and freeing up of descriptors and stacks. There
now exists a new hook on domain termination in the runtime.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/440">ocaml-multicore/ocaml-multicore#440</a>
<code>ocamlfind ocamldep</code> hangs in no-effect-syntax branch</p>
<p>The <code>nocrypto</code> package fails to build for Multicore OCaml
no-effect-syntax branch, and ocamlfind loops continuously. A minimal
test example has been created to reproduce the issue.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/443">ocaml-multicore/ocaml-multicore#443</a>
Minor heap allocation startup cost</p>
<p>An issue to keep track of the ongoing investigations on the impact
of large minor heap size for OCaml Multicore programs. The
sequential and parallel exeuction run results for various minor heap
sizes are provided in the issue.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/446">ocaml-multicore/ocaml-multicore#446</a>
Collect GC stats at the end of minor collection</p>
<p>The objective is to remove the use of double buffering in the GC
statistics collection by using the barrier present during minor
collection in the parallel_minor_gc schema. There is not much
slowdown for the benchmark runs, normalized against stock OCaml as
seen in the illustration.
<img src="upload://i4js513ml6Qw6GvkZuQsiVuowYB.png" alt="PR 446 Graph Image" /></p>
</li>
</ul>
<h3>Completed</h3>
<h4>Upstream</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/426">ocaml-multicore/ocaml-multicore#426</a>
Replace global roots implementation</p>
<p>This PR replaces the existing global roots implementation with that
of OCaml's <code>globroots</code>, wherein the implementation places locks
around the skip lists. In future, the <code>Caml_root</code> usage will be
removed along with its usage in globroots.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/427">ocaml-multicore/ocaml-multicore#427</a>
Garbage Collector colours change backport</p>
<p>The <a href="https://github.com/ocaml/ocaml/pull/9756">Garbage Collector colours
change</a> PR from trunk for
the major collector have now been backported to Multicore
OCaml. This includes the optimization for <code>mark_stack_push</code>, the
<code>mark_entry</code> does not include <code>end</code>, and <code>caml_shrink_mark_stack</code>
has been adapted from trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/432">ocaml-multicore/ocaml-multicore#432</a>
Remove caml_context push/pop on stack switch</p>
<p>The motivation to remove the use of <code>caml_context</code> push/pop on stack
switches to make the implementation easier to understand, and to be
closer to upstream OCaml.</p>
</li>
</ul>
<h4>Stack Improvements</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/431">Fix stack overflow on scan stack#431</a>
Fix issue 421: Stack overflow on scan stack</p>
<p>The <code>caml_scan_stack</code> now uses a while loop to avoid a stack
overflow corner case where there is a deep nesting of fibers.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/434">ocaml-multicore/ocaml-multicore#434</a>
DWARF fixups for effect stack switching</p>
<p>The PR provides fixes for <code>runtime/amd64.S</code> on issues found using a
DWARF validator. The patch also cleans up dead commented out code,
and updates the DWARF information when we do <code>caml_free_stack</code> in
<code>caml_runstack</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/435">ocaml-multicore/ocaml-multicore#435</a>
Mark stack overflow backport</p>
<p>The mark-stack overflow implementation has been updated to be closer
to trunk OCaml. The pools are added to a skiplist first to avoid any
duplicates, and the pools in <code>pools_to_rescan</code> are marked later
during a major cycle. The result of the <code>finalise</code> benchmark time
difference with mark stack overflow is shown below:</p>
</li>
</ul>
<p><img src="upload://xZoOkroQdawrkU6SaistBe7j0FG.png" alt="PR 435 Graph Image" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/437">ocaml-multicore/ocaml-multicore#437</a>
Avoid an allocating C call when switching stacks with continue</p>
<p>The <code>caml_continuation_use</code> has been updated to use
<code>caml_continuation_use_noexc</code> and it does not throw an
exception. The allocating C <code>caml_c_call</code> is no longer required to
call <code>caml_continuation_use_noexc</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/441">ocaml-multicore/ocaml-multicore#441</a>
Tidy up and more commenting of caml_runstack in amd64.S</p>
<p>The PR adds comments on how stacks are switched, and removes
unnecessary instructions in the x86 assembler.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/442">ocaml-multicore/ocaml-multicore#442</a>
Fiber stack cache (v2)</p>
<p>Addition of stack caching for fiber stacks, which also fixes up bugs
in the test suite (DEBUG memset, order of initialization). We avoid
indirection out of <code>struct stack_info</code> when managing the stack
cache, and efficiently calculate the cache freelist bucket for a
given stack size.</p>
</li>
</ul>
<h4>Ecosystem</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/lockfree/pull/5">ocaml-multicore/lockfree#5</a>
Remove Kcas dependency</p>
<p>The <code>Kcas.Wl</code> module is now replaced with the Atomic module
available in Multicore stdlib. The exponential backoff is
implemented with <code>Domain.Sync.cpu_relax</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/21">ocaml-multicore/domainslib#21</a>
Point to the new repository URL</p>
<p>Thanks to Sora Morimoto (@smorimoto) for providing a patch that
updates the URL to the correct ocaml-multicore repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/40">ocaml-multicore/multicore-opam#40</a>
Add multicore Merlin and dot-merlin-reader</p>
<p>A patch to merlin and dot-merlin-reader to work with Multicore OCaml
4.10.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/403">ocaml-multicore/ocaml-multicore#403</a>
Segmentation fault when trying to build Tezos on Multicore</p>
<p>The latest fixes on replacing the global roots implementation, and
fixing the STW interrupt race to the no-effect-syntax branch has
resolved the issue.</p>
</li>
</ul>
<h4>Compiler Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/438">ocaml-multicore/ocaml-multicore#438</a>
Allow C++ to use caml/camlatomic.h</p>
<p>The inclusion of extern &quot;C&quot; headers to allow C++ to use
caml/camlatomic.h for building ubpf.0.1.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/447">ocaml-multicore/ocaml-multicore#447</a>
domain_state.h: Remove a warning when using -pedantic</p>
<p>A fix that uses <code>CAML_STATIC_ASSERT</code> to check the size of
<code>caml_domain_state</code> in domain_state.h, in order to remove the
warning when using -pedantic.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/449">ocaml-multicore/ocaml-multicore#449</a>
Fix stdatomic.h when used inside C++ for good</p>
<p>Update to <code>caml/camlatomic.h</code> with extern C++ declaration to use it
inside C++. This builds upbf.0.1 and libsvm.0.10.0 packages.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/422">ocaml-multicore/ocaml-multicore#422</a>
Simplify minor heaps configuration logic and masking</p>
<p>A <code>Minor_heap_max</code> size is introduced to reserve the minor heaps
area, and <code>Is_young</code> for relying on a boundary check. The
<code>Minor_heap_max</code> parameter can be overridden using the OCAMLRUNPARAM
environment variable. This implementation approach is geared towards
using Domain local allocation buffers.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/429">ocaml-multicore/ocaml-multicore#429</a>
Fix a STW interrupt race</p>
<p>A fix for the STW interrupt race in
<code>caml_try_run_on_all_domains_with_spin_work</code>. The
<code>enter_spin_callback</code> and <code>enter_spin_data</code> fields of <code>stw_request</code>
are now initialized after we interrupt other domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/430">ocaml-multicore/ocaml-multicore#430</a>
Add a test to exercise stored continuations and the GC</p>
<p>The PR adds test coverage for interactions between the GC with
stored, cloned and dropped continuations to exercise the minor and
major collectors.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/444">ocaml-multicore/ocaml-multicore#444</a>
Merge branch 'parallel_minor_gc' into 'no-effect-syntax'</p>
<p>The <code>parallel_minor_gc</code> branch has been merged into the
<code>no-effect-syntax</code> branch, and we will try to keep the
<code>no-effect-syntax</code> branch up-to-date with the latest changes.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/196">ocaml-bench/sandmark#196</a>
Filter benchmarks based on tag</p>
<p>An enhancement to move towards a generic implementation to filter
the benchmarks based on tags, instead of relying on custom targets
such as _macro.json or _ci.json.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/191">ocaml-bench/sandmark#191</a>
Make parallel.ipynb notebook interactive</p>
<p>The parallel.ipynb notebook has been made interactive with drop-down
menus to select the .bench files for analysis. The notebook README
has been merged with the top-level README file. A sample
4.10.0.orunchrt.bench along with the *pausetimes_multicore.bench
files have been moved to the test artifacts/ folder for user
testing.</p>
</li>
<li>
<p>We are continuing to test the use of <code>opam-compiler</code> switch
environment to execute the Sandmark benchmark test suite. We have
been able to build the dependencies, <code>orun</code> and <code>rungen</code>, the
<code>OCurrent</code> pipeline and its dependencies, and <code>ocaml-ci</code> for the
ocaml-multicore:no-effect-syntax branch. We hope to converge to a
2.0 implementation with the required OCaml tools and ecosystem.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/179">ocaml-bench/sandmark#179</a>
[RFC] Classifying benchmarks based on running time</p>
<p>The <a href="https://github.com/ocaml-bench/sandmark/pull/188">Classification of
benchmarks</a> PR has
been resolved, which now classifies the benchmarks based on their
running time:</p>
<ul>
<li><code>lt_1s</code>: Benchmarks that run for less than 1 second.
</li>
<li><code>lt_10s</code>: Benchmarks that run for at least 1 second, but, less than 10 seconds.
</li>
<li><code>10s_100s</code>: Benchmarks that run for at least 10 seconds, but, less than 100 seconds.
</li>
<li><code>gt_100s</code>: Benchmarks that run for at least 100 seconds.
</li>
</ul>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/189">ocaml-bench/sandmark#189</a>
Add environment support for wrapper in JSON configuration file</p>
<p>The OCAMLRUNPARAM arguments can now be passed as an environment
variable when executing the benchmarks in runtime. The environment
variables can be specified in the <code>run_config.json</code> file, as shown
below:</p>
<pre><code> {
    &quot;name&quot;: &quot;orun_2M&quot;,
    &quot;environment&quot;: &quot;OCAMLRUNPARAM='s=2M'&quot;,
    &quot;command&quot;: &quot;orun -o %{output} -- taskset --cpu-list 5 %{command}&quot;
  }
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/183">ocaml-bench/sandmark#183</a>
Use crout_decomposition name for numerical analysis benchmark</p>
<p>The <code>numerical-analysis/lu_decomposition.ml</code> benchmark has now been
renamed to <code>crout_decomposition.ml</code> to avoid naming confusion, as
there are a couple of LU decomposition benchmarks in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/190">ocaml-bench/sandmark#190</a>
Bump trunk to 4.13.0</p>
<p>The trunk version in Sandmark ocaml-versions/ has now been updated
to use <code>4.13.0+trunk.json</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/192">ocaml-bench/sandmark#192</a>
GraphSEQ corrected</p>
<p>The minor fix for the Kronecker generator has been provided for the
Graph500 benchmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/194">ocaml-bench/sandmark#194</a>
Lockfree benchmarks</p>
<p>The lockfree benchmarks for both the serial and parallel
implementation are now included in Sandmark, and it uses the
<code>lockfree_bench</code> tag. The time and speedup illustrations are as follows:</p>
</li>
</ul>
<p><img src="upload://bnMWcVZTMo1mahmtkawHOho3rA.png" alt="PR 194 Time Image" />
<img src="upload://fIrArMCzcRLfO1hyyDH7dDIpFT0.png" alt="PR 194 Speedup Image" /></p>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9876">ocaml/ocaml#9876</a>
Do not cache young_limit in a processor register</p>
<p>The removal of <code>young_limit</code> caching in a register is being
evaluated using Sandmark benchmark runs to test the impact change on
for ARM64, PowerPC and RISC-V ports hardware.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9934">ocaml/ocaml#9934</a>
Prefetching optimisations for sweeping</p>
<p>The PR includes an optimization of <code>sweep_slice</code> for the use of
prefetching, and to reduce cache misses during GC. The normalized
running time graph is as follows:</p>
</li>
</ul>
<p><img src="upload://b1kXzk2cPuQFZyw0gGLhYzzTpUP.png" alt="PR 9934 Graph" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/10039">ocaml/ocaml#10039</a>
Safepoints</p>
<p>A draft Safepoints implementation for AMD64 for the 4.11 branch that
are implemented by adding a new <code>Ipoll</code> operation to Mach. The
benchmark results on an AMD Zen2 machine are given below:</p>
</li>
</ul>
<p><img src="upload://f1LVGM7v68n8PXO2vkgspojINrr.png" alt="PR 10039 Benchmark" /></p>
<p>Many thanks to all the OCaml users and developers for their continued support, and contribution to the project.</p>
<h2>Acronyms</h2>
<ul>
<li>ARM: Advanced RISC Machine
</li>
<li>DWARF: Debugging With Attributed Record Formats
</li>
<li>GC: Garbage Collector
</li>
<li>JSON: JavaScript Object Notation
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request For Comments
</li>
<li>RISC-V: Reduced Instruction Set Computing - V
</li>
<li>STW: Stop-The-World
</li>
<li>URL: Uniform Resource Locator
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - October 2020|js}
  ; slug = {js|multicore-2020-10|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-10-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the October 2020 multicore OCaml report, compiled by @shakthimaan, @kayceesrk and of course myself. The [previous monthly (https://discuss.ocaml.org/tag/multicore-monthly) updates are also available for your perusal.</p>
<p><strong>OCaml 4.12.0-dev:</strong> The upstream OCaml tree has been branched for the 4.12 release, and the <a href="https://github.com/ocaml/opam-repository/issues/17530">OCaml readiness team</a> is busy stabilising it with the ecosystem. The 4.12.0 development stream has significant progress towards multicore support, especially with the runtime handling of naked pointers. The release will ship with a dynamic checker for naked pointers that you can use to verify that your own codebase is clean of them, as this will be a prerequisite for OCaml 5.0 and multicore compatibility. This is activated via the <code>--enable-naked-pointers-checker</code> configure option.</p>
<p><strong>Convergence with upstream and multicore trees:</strong> The multicore OCaml trees have seen significant robustness improvements as we've converged our trees with upstream OCaml (possible now that the upstream architectural changes are synched with the requirements of multicore). In particular, the handling of global C roots is much better in multicore now as it uses the upstream OCaml scheme, and the GC colour scheme also exactly matches upstream OCaml's.  This means that community libraries from <code>opam</code> work increasingly well when built with multicore OCaml (using the <code>no-effects-syntax</code> branch).</p>
<p><strong>Features:</strong> Multicore OCaml is also using domain local allocation buffers now to simplify its internals.  We are also now working on benchmarking the IO subsystem, and support for CPU parallelism for the Lwt concurrency library has been added, as well as refreshing the new Asynchronous Effect-based IO (<a href="https://github.com/kayceesrk/ocaml-aeio">aeio</a>) with Multicore OCaml, Lwt, and httpaf in an <a href="https://github.com/sadiqj/http-effects">http-effects</a> library.</p>
<p><strong>Benchmarking:</strong> The Sandmark benchmarking test suite has additional configuration options, and there are new proposals in that project to leverage as much of the OCaml tools and ecosystem as much as possible.</p>
<p>As with previous updates, the Multicore OCaml ongoing, and completed tasks are listed first, which are followed by improvements to the Sandmark benchmarking test suite. Finally, the upstream OCaml related work is mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/422">ocaml-multicore/ocaml-multicore#422</a>
Simplify minor heaps configuration logic and masking</p>
<p>The PR is a step towards using Domain local allocation buffers. A
<code>Minor_heap_max</code> size is used to reserve the minor heaps area, and
<code>Is_young</code> for relying on a boundary check. The <code>Minor_heap_max</code> can
be overridden using OCAMLRUNPARAM environment variable.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/426">ocaml-multicore/ocaml-multicore#426</a>
Replace global roots implementation</p>
<p>An effort to replace the existing global roots implementation to be
in line with OCaml's <code>globroots</code>. The objective is to also have a
per-domain skip list, and a global orphans when a domain is
terminated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/427">ocaml-multicore/ocaml-multiore#427</a>
Garbage Collector colours change backport</p>
<p>The <a href="https://github.com/ocaml/ocaml/pull/9756">Garbage Collector colour scheme
changes</a> in the major
collector have now been backported to Multicore OCaml. The
<code>mark_entry</code> does not include <code>end</code>, <code>mark_stack_push</code> resembles
closer to trunk, and <code>caml_shrink_mark_stack</code> has been adapted from
trunk.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/429">ocaml-multicore/ocaml-multicore#429</a>
Fix a STW interrupt race</p>
<p>The STW interrupt race in
<code>caml_try_run_on_all_domains_with_spin_work</code> is fixed in this PR,
where the <code>enter_spin_callback</code> and <code>enter_spin_data</code> fields of
<code>stw_request</code> are initialized after we interrupt other domains.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Systhreads support</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">ocaml-multicore/ocaml-multicore#381</a>
Reimplementing Systhreads with pthreads (Domain execution contexts)</p>
<p>The re-implementation of Systhreads with pthreads has been completed
for Multicore OCaml. The Domain Execution Context (DEC) is
introduced which allows multiple threads to run atop a domain.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/410">ocaml-multicore/ocaml-multicore#410</a>
systhreads: <code>caml_c_thread_register</code> and <code>caml_c_thread_unregister</code></p>
<p>The <code>caml_c_thread_register</code> and <code>caml_c_thread_unregister</code>
functions have been reimported to systhreads. In Multicore OCaml,
threads created by C code will be registered to domain 0 threads
chaining.</p>
</li>
</ul>
<h4>Domain Local Storage</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/404">ocaml-multicore/ocaml-multicore#404</a>
Domain.DLS.new_key takes an initialiser</p>
<p>The <code>Domain.DLS.new_key</code> now accepts an initialiser argument to
assign an associated value to a key, if not initialised
already. Also, <code>Domain.DLS.get</code> no longer returns an option value.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/405">ocaml-multicore/ocaml-multicore#405</a>
Rework Domain.DLS.get search function such that it no longer allocates</p>
<p>The <code>Domain.DLS.get</code> has been updated to remove any memory
allocation, if the key already exists in the domain local
storage. The PR also changes the <code>search</code> function to accept all
inputs as variables, instead of a closure from the environment.</p>
</li>
</ul>
<h4>Lwt</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/33">ocaml-multicore/multicore-opam#33</a>
Add lwt.5.3.0+multicore</p>
<p>The Lwt.5.3.0 concurrency library has been added to support CPU
parallelism with Multicore OCaml. A <a href="https://sudha247.github.io/2020/10/01/lwt-multicore/">blog
post</a>
introducing its installation and usage has been written by Sudha
Parimala.</p>
</li>
<li>
<p>The <a href="https://github.com/kayceesrk/ocaml-aeio">Asynchronous Effect-based IO</a> builds with a recent
Lwt, and the HTTP effects demo has been updated to work with
Multicore OCaml, Lwt, and httpaf. The demo source code is available
at the <a href="https://github.com/sadiqj/http-effects">http-effects</a> repo.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/406">ocaml-multicore/ocaml-multicore#406</a>
Remove ephemeron usage of RPC</p>
<p>The inter-domain mechanism is not required with the stop-the-world
minor GC, and hence the same has been removed in the ephemeron
implementation. The PR also does clean up and simplifies the
ephemeron data structure and code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/411">ocaml-multicore/ocaml-multicore#411</a>
Fix typo for presume and presume_arg in <code>internal_variable_names</code></p>
<p>A minor typo bug fix to rename <code>Presume</code> and <code>Presume_arg</code> in
<code>internal_variables_names.ml</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/414">ocaml-multicore/ocaml-multicore#414</a>
Fix up <code>Ppoll</code> <code>semantics_of_primitives</code> entry</p>
<p>The <code>semantics_of_primitives</code> entry for <code>Ppoll</code> has been fixed which
was causing flambda builds to remove poll points.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/416">ocaml-multicore/ocaml-multicore#416</a>
Fix callback effect bug</p>
<p>The PR fixes a bug when the C-to-OCaml callback prevents effects
crossing a C callback boundary. The stack parent is cleared before a
callback, and restored afterwards. It also makes the stack parent a
local root, so that the GC can see it inside the callback.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<h4>Configuration</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/ocaml_bench_scripts/pull/12">ocaml-bench/ocaml-bench-scripts#12</a>
Add support for parallel multibench targets and JSON input</p>
<p>The <code>RUN_CONFIG_JSON</code> and <code>BUILD_BENCH_TARGET</code> variables are now
added and passed during run-time for the execution of parallel
benchmarks. Default values are specified so that the serial
benchmarks can still run without explicitly requiring the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/180">ocaml-bench/sandmark#180</a>
Notebook Refactoring and User changes</p>
<p>A refactoring effort is underway to make the parallel benchmark
interactive. The user accounts on The Littlest JupyterHub
installation have direct access to the benchmark results produced
from <code>ocaml-bench-scripts</code> on the system.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/189">ocaml-bench/sandmark#189</a>
Add environment support for wrapper in JSON configuration file</p>
<p>The OCAMLRUNPARAM is now passed as an environment variable to the
benchmarks during runtime, so that, different parameter values can
be used to obtain multiple results for comparison. The use case and
the discussion are available at <a href="https://github.com/ocaml-bench/sandmark/issues/184">Running benchmarks with varying
OCAMLRUNPARAM</a>
issue. The environment variables can be specified in the
<code>run_config.json</code> file, as shown below:</p>
<pre><code> {
    &quot;name&quot;: &quot;orun_2M&quot;,
    &quot;environment&quot;: &quot;OCAMLRUNPARAM='s=2M'&quot;,
    &quot;command&quot;: &quot;orun -o %{output} -- taskset --cpu-list 5 %{command}&quot;
  }
</code></pre>
</li>
</ul>
<h4>Proposals</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/159">ocaml-bench/sandmark#159</a>
Implement a better way to describe tasklet cpulist</p>
<p>The discussion to implement a better way to obtain the taskset list
of cores for a benchmark run is still in progress. This is required
to be able to specify hyper-threaded cores, NUMA zones, and the
specific cores to use for the parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/179">ocaml-bench/sandmark#179</a>
[RFC] Classifying benchmarks based on running time</p>
<p>A proposal to categorize the benchmarks based on their running time
has been provided. The following classification types have been
suggested:</p>
<ul>
<li><code>lt_1s</code>: Benchmarks that run for less than 1 second.
</li>
<li><code>lt_10s</code>: Benchmarks that run for at least 1 second, but, less than 10 seconds.
</li>
<li><code>10s_100s</code>: Benchmarks that run for at least 10 seconds, but, less than 100 seconds.
</li>
<li><code>gt_100s</code>: Benchmarks that run for at least 100 seconds.
</li>
</ul>
<p>The PR for the same is available at <a href="https://github.com/ocaml-bench/sandmark/pull/188">Classification of
benchmarks</a>.</p>
</li>
<li>
<p>We are exploring the use of <code>opam-compiler</code> switch environment to
build the Sandmark benchmark test suite. The merge of <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/407">systhreads
compatibility
support</a>
now enables us to install dune natively inside the switch
environment, along with the other benchmarks. With this approach, we
hope to modularize our benchmarking test suite, and converge to
fully using the OCaml tools and ecosystem.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/181">ocaml-bench/sandmark#181</a>
Lock-free map bench</p>
<p>An implementation of a concurrent hash-array mapped trie that is
lock-free, and is based on Prokopec, A. et. al. (2011). This
cache-aware implementation benchmark is currently under review.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/183">ocaml-bench/sandmark#183</a>
Use crout_decomposition name for numerical analysis benchmark</p>
<p>A couple of LU decomposition benchmarks exist in the Sandmark
repository, and this PR renames the
<code>numerical-analysis/lu_decomposition.ml</code> benchmark to
<code>crout_decomposition.ml</code>. This is to address <a href="https://github.com/ocaml-bench/sandmark/issues/182">Rename
lu_decomposition benchmark in
numerical-analysis</a>
any naming confusion between the two benchmarks, as their
implementations are different.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/177">ocaml-bench/sandmark#177</a>
Display raw baseline numbers in normalized graphs</p>
<p>The raw baseline numbers are now included in the normalized graphs
in the sequential notebook output. The graph for <code>maxrsskb</code>, for
example, is shown below:</p>
</li>
</ul>
<p><img src="upload://1gub2PiCejOQBoMqPvuhDoxHpJo.png" alt="PR 177 Image |690x258" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/178">ocaml-bench/sandmark#178</a>
Change to new Domain.DLS API with Initializer</p>
<p>The <code>multicore-minilight</code> and <code>multicore-numerical</code> benchmarks have
now been updated to use the new Domain.DLS API with initializer.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/185">ocaml-bench/sandmark#185</a>
Clean up existing effect benchmarks</p>
<p>The PR ensures that the code compiles without any warnings, and adds
a <code>multicore_effects_run_config.json</code> configuration file, and a
<code>run_all_effect.sh</code> script to execute the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/186">ocaml-bench/sandmark#186</a>
Very simple effect microbenchmarks to cover code paths</p>
<p>A set of four microbenchmarks to test the throughput of our effects
system have now been added to the Sandmark test suite. These include
<code>effect_throughput_clone</code>, <code>effect_throughput_val</code>,
<code>effect_throughput_perform</code>, and <code>effect_throughput_perform_drop</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/187">ocaml-bench/sandmark#187</a>
Implementation of 'recursion' benchmarks for effects</p>
<p>A collection of recursion benchmarks to measure the overhead of
effects are now included to Sandmark. This is inspired by the
(Manticore
benchmarks)[https://github.com/ManticoreProject/benchmark/].</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9876">ocaml/ocaml#9876</a>
Do not cache young_limit in a processor register</p>
<p>The PR removes the caching of <code>young_limit</code> in a register for ARM64,
PowerPC and RISC-V ports. The Sandmark benchmarks are presently
being tested on the respective hardware.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9934">ocaml/ocaml#9934</a>
Prefetching optimisations for sweeping</p>
<p>The Sandmark benchmarking tests were performed for analysing a
couple of patches that optimise <code>sweep_slice</code>, and for the use of
prefetching. The objective is to reduce cache misses during GC.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9947">ocaml/ocaml#9947</a>
Add a naked pointers dynamic checker</p>
<p>The check for &quot;naked pointers&quot; (dangerous out-of-heap pointers) is
now done in run-time, and tests for the three modes: naked pointers,
naked pointers and dynamic checker, and no naked pointers have been
added in the PR.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9951/">ocaml/ocaml#9951</a>
Ensure that the mark stack push optimisation handles naked pointers</p>
<p>The PR adds a precise check on whether to push an object into the
mark stack, to handle naked pointers.</p>
</li>
</ul>
<p>We would like to thank all the OCaml users and developers in the community for their continued support, reviews and contribution to the project.</p>
<h2>Acronyms</h2>
<ul>
<li>AEIO: Asynchronous Effect-based IO
</li>
<li>API: Application Programming Interface
</li>
<li>ARM: Advanced RISC Machine
</li>
<li>CPU: Central Processing Unit
</li>
<li>DEC: Domain Execution Context
</li>
<li>DLS: Domain Local Storage
</li>
<li>GC: Garbage Collector
</li>
<li>HTTP: Hypertext Transfer Protocol
</li>
<li>JSON: JavaScript Object Notation
</li>
<li>NUMA: Non-Uniform Memory Access
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>OS: Operating System
</li>
<li>PR: Pull Request
</li>
<li>RISC-V: Reduced Instruction Set Computing - V
</li>
<li>RPC: Remote Procedure Call
</li>
<li>STW: Stop-The-World
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - September 2020|js}
  ; slug = {js|multicore-2020-09|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-09-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<h1>Multicore OCaml: September 2020</h1>
<p>Welcome to the September 2020 Multicore OCaml report! This update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous
monthly</a> updates have been compiled by @shakthimaan, @kayceesrk and @avsm.</p>
<p>Big news this month is that the <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/407">systhreads compatibility support</a> PR has been merged, which means that Dune (and other users of the <code>Thread</code> module) can compile out of the box.  You can now compile the multicore OCaml fork conveniently using the new <code>opam compiler</code> plugin (<a href="https://discuss.ocaml.org/t/ann-opam-compiler-0-1-0/6442">see announcement</a>):</p>
<pre><code class="language-bash">opam update
opam compiler create &quot;ocaml-multicore/ocaml-multicore:no-effect-syntax&quot;
eval $(opam env)
</code></pre>
<p>This selects the branch of multicore OCaml that omits the experimental <code>effect</code> syntax, and thus works with the existing ppx ecosystem.  It's quite fun opam installing ecosystem packages and seeing them operate out of the box at long last. There are still a few rough edges to the thread compatibility support (mainly at the C compatibility layer, such as registering external C threads with the GC), but these will be worked out in the coming weeks. We'd like to hear of any build failures you encounter in the opam universe with this: please report them on https://github.com/ocaml-multicore/ocaml-multicore/issues</p>
<p>A number of performance improvements to the multicore OCaml GC and the Sandmark benchmarking project have also been completed through September:</p>
<ul>
<li>we have now included the <a href="https://github.com/ocaml-bench/sandmark/pull/170">Kronecker implementation</a> from the Graph500 benchmarks to Sandmark
</li>
<li>an <a href="https://github.com/ocaml-bench/sandmark/pull/173">n-queen</a> benchmark addition is in progress
</li>
<li>benchmark runs now provide a count of the OCaml symbols as a code size metric
</li>
<li>work on building Tezos with multicore OCaml, and integration with the Sandmark
benchmarking test suite has also begun.
</li>
</ul>
<p>We have also begun an effort to <a href="https://github.com/Sudha247/lwt-multicore/tree/preemptive-multicore">port Lwt</a> to take advantage of parallelism via <code>Lwt_preemptive</code>. <a href="https://github.com/Sudha247/code-samples/">Code samples</a> and test runs have been performed, and Sudha has written <a href="https://sudha247.github.io/2020/10/01/lwt-multicore/">an introductory blog post</a> about her early results.  Note that this work doesn't change the core behaviour of Lwt (a cooperative futures framework with no context switching between <code>bind</code> calls), but allows parallelism via explicit calls to background preemptive threads.</p>
<p>On the upstreaming efforts to OCaml, the 4.12 release will freeze earlier than usual in October, and so we finished submitting the last of the <a href="https://github.com/ocaml/ocaml/pull/9756">garbage collector colour changes</a> and are aiming for the work on reliable safe points to go into OCaml 4.13.  There have been a lot of runtime changes packed into 4.12 already, and so we will issue a call for testing when the release candidate of 4.12 is cut.</p>
<p>Onto the details of the PRs. As with the previous updates, the Multicore OCaml updates are listed first, which are then followed by the enhancements to the Sandmark benchmarking project. The upstream OCaml ongoing and completed updates are finally mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/17">ocaml-multicore/domainslib#17</a>
Implement channels using Mutex and Condition Variables</p>
<p>The <code>lib/chan.ml</code> sources have been updated to implement channels
using Mutex and Condition Variables, and a
<code>LU_decomposition_multicore.exe</code> test has been added for the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">ocaml-multicore/ocaml-multicore#381</a>
Reimplementating systhreads with pthreads</p>
<p>This PR is actively being reviewed for the use of <code>pthreads</code> in
Multicore OCaml. It introduces the Domain Execution Contexts (DEC)
which allows multiple threads to run atop a domain.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/394">ocaml-multicore/ocaml-multicore#394</a>
Changes to polling placement</p>
<p>The polls placement is done at the start of the functions and on the
back-edge of loops, instead of using Feely's algorithm. This is a
work-in-progress.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/401">ocaml-multicore/ocaml-multicore#401</a>
Do not handle interrupts recursively</p>
<p>A domain local variable is introduced to prevent handling of
interrupts recursively.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/402">ocaml-multicore/ocaml-multicore#402</a>
Split handle_gc_interrupt into handling remote and polling sections</p>
<p>A <code>caml_poll_gc_work</code> is introduced that has information of GC work
done previously in <code>caml_handle_gc_interrupt</code>. This facilitates
<code>stw_handler</code> to make calls to poll and not handle service
interrupts, as it may lead to unwanted recursion.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/403">ocaml-multicore/ocaml-multicore#403</a>
Segmentation fault when building Tezos on Multicore 4.10.0 with no-effects-syntax</p>
<p>This is an on-going investigation on why the package
<code>tezos-embedded-protocol-packer</code> in Tezos is causing a segmentation
fault when building with Multicore OCaml.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Domainslib</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/19">ocaml-multicore/domainslib#19</a>
Finer grain signalling with mutex condvar for Channels</p>
<p>The use of fine grain locking for Mutex and condition variables
helps in improving the performance for larger cores, as against a
single mutex for all the signalling.</p>
</li>
</ul>
<h4>Multicore OPAM</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/31">ocaml-multicore/multicore-opam#31</a>
Patch dune.2.7.1 for Multicore OCaml</p>
<p>The opam file for dune.2.7.1 has been added along with a patch to
<code>bootstrap.ml</code> to get it working for Multicore OCaml, thanks to
Chaitanya Koparkar.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/32">ocaml-multicore/multicore-opam#32</a>
Add ocamlfind-secondary dependency to dune</p>
<p>The installation of <code>dune</code> requires <code>ocamlfind-secondary</code> as a
dependency for dune.2.7.1, and has been added to the OPAM file.</p>
</li>
</ul>
<h4>Multicore OCaml</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/395">ocaml-multicore/ocaml-multicore#395</a>
Move to SPIN_WAIT for all spins and usleep in SPIN_WAIT</p>
<p>The PR provides the SPIN_WAIT macro for all the busy spin wait
loops, and uses <code>caml_plat_spin_wait</code> when busy waiting. This
ensures that the same spin strategy is used in different places in
the code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/397">ocaml-multicore/ocaml-multicore#397</a>
Relaxation of backup thread signalling</p>
<p>The signalling to the backup thread from the mutator thread when
leaving a blocking section is modified. It reduces the potential
Operating System scheduling when re-entering OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/400">ocaml-multicore/ocaml-multicore#400</a>
Demux eventlog for backup thread</p>
<p>The events in the backup thread were emitting the same process ID as
the main thread, and this PR separates them.</p>
</li>
</ul>
<p><img src="upload://1k0ZG25zs4Vl8x9sIPXNlpBj3NX.png" alt="PR 400|690x246" /></p>
<p>In the above illustration, the backup threads are active when the
main thread is waiting on a condition variable.</p>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/159">ocaml-bench/sandmark#159</a>
Implement a better way to describe tasklet cpulist</p>
<p>We need a cleaner way to obtain the taskset list of cores for a
benchmark run when we are provided with a number of domains. We
should be able to specify hyper-threaded cores, NUMA zones to use,
and the specific cores to use for the parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/173">ocaml-bench/sandmark#173</a>
Addition of nqueens benchmark to multicore-numerical</p>
<p>A draft version of the classical <code>n queens</code> benchmark has been added
for review in Sandmark. This includes both the single and multicore
implementation.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/ocaml_bench_scripts/pull/11">ocaml-bench/ocaml_bench_scripts#11</a>
Add support for configure option and OCAMLRUNPARAM</p>
<p>The <code>ocaml_bench_scripts</code> has been updated to support passing
<code>configure</code> options and OCAMLRUNPARAM when building and running the
benchmarks in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/122">ocaml-bench/sandmark#122</a>
Measurements of code size</p>
<p>The output .bench JSON file produced from the benchmarks now
includes a code size metric for the number of CAML symbols. A sample
benchmark output is shown below:</p>
<pre><code>{&quot;name&quot;:&quot;knucleotide.&quot;, ... ,&quot;codesize&quot;:276859.0, ...}
</code></pre>
<p>The code size count for few of the benchmarks is given below:</p>
<pre><code>| Benchmark  |   Count   |
|------------|-----------|
| alt-ergo   | 2_822_040 |
| coqc       | 5_869_305 |
| cpdf       | 1_131_376 |
| nbody.exe  |   276_710 |
| stress.exe |    84_061 |
| fft.exe    |    38_914 |
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/170">ocaml-bench/sandmark#170</a>
Graph500 SEQ</p>
<p>The Graph500 benchmark with a Kronecker graph generator has now been
added to Sandmark. The generator builds three kernels for graph
construction, Breadth First Search, and Single Source Shortest
Paths.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/172">ocaml-bench/sandmark#172</a>
Remove <code>Base</code>, <code>Stdio</code> orun dependency for trunk</p>
<p>The <code>orun</code> sources in Sandmark have been updated to remove the
dependency on both <code>Base</code> and <code>Stdio</code>. They have been replaced with
functions from <code>Stdlib</code>, <code>List</code>, <code>String</code> and <code>Str</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/174">ocaml-bench/sandmark#174</a>
Cleanup our use of sudo for chrt</p>
<p>The use of <code>sudo</code> has been removed from the Makefile for running
parallel benchmarks, to avoid creating output files and directories
that require root permissions for access. The use of
<code>RUN_BENCH_TARGET=run_orunchrt</code> will execute the benchmarks using
<code>chrt -r 1</code>. The user can give permissions to the <code>chrt</code> binary
using:</p>
<pre><code>$ sudo setcap cap_sys_nice=ep /usr/bin/chrt
</code></pre>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9876">ocaml/ocaml#9876</a>
Do not cache young_limit in a processor register</p>
<p>The PR removes the caching of <code>young_limit</code> in a register for ARM64,
PowerPC and RISC-V ports, as it is problematic during polling for
signals and inter-domain communication in Multicore OCaml.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9756">ocaml/ocaml#9756</a>
Garbage collectors colour change</p>
<p>The gray colour scheme in the Garbage Collector has been removed to
facilitate merging with the Multicore OCaml collector. The existing
benchmarks in Sandmark suite that did overflow the mark stack are
show in the below illustration, and there is little negative impact
on the change.</p>
</li>
</ul>
<p><img src="upload://2nIsxMaEnUPpk8CJIjwI6UeT9yp.png" alt="PR-9756|690x495" /></p>
<p>As always, we would like to thank all the OCaml developers and users in the community for their continued support and contribution to the project.  Be well!</p>
<h2>Acronyms</h2>
<ul>
<li>ARM: Advanced RISC Machine
</li>
<li>BFS: Breadth First Search
</li>
<li>DEC: Domain Execution Context
</li>
<li>GC: Garbage Collector
</li>
<li>JSON: JavaScript Object Notation
</li>
<li>NUMA: Non-Uniform Memory Access
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>OS: Operating System
</li>
<li>PR: Pull Request
</li>
<li>RISC-V: Reduced Instruction Set Computing - V
</li>
<li>SSSP: Single Source Shortest Path
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - August 2020|js}
  ; slug = {js|multicore-2020-08|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-08-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the August 2020 Multicore OCaml report (a few weeks late due to August slowdown). This update along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a> have been compiled by @shakthimaan, @kayceesrk and myself.</p>
<p>There are some talks related to multicore OCaml which are now freely available online:</p>
<ul>
<li>At the OCaml Workshop, @sadiq presented <a href="https://www.youtube.com/watch?v=Z7YZR1q8wzI&amp;list=PLKO_ZowsIOu5fHjRj0ua7_QWE_L789K_f&amp;index=6&amp;t=0s">&quot;How to parallelise your code with Multicore OCaml&quot;</a>
</li>
<li>At ICFP, @kayceesrk presented <a href="https://www.youtube.com/watch?v=i9wgeX7e-nc&amp;t=6180s">&quot;Retrofitting Parallelism onto OCaml&quot;</a>, which was also awarded a Distinguished Paper award.
</li>
<li>At ICFP, Glenn Mével presented <a href="https://www.youtube.com/watch?v=aNLOi-1ixwM&amp;t=2610s">&quot;Cosmo: A Concurrent Separation Logic for Multicore OCaml&quot;</a>.
</li>
<li>At the WebAssembly Community Group meeting,  @kayceesrk gave a talk on <a href="https://kcsrk.info/slides/WASM_CG_4Aug20.pdf">Effect Handlers in Multicore OCaml</a>.  This is related to our longer term efforts to ensure that OCaml has an efficient compilation strategy to WebAssembly.
</li>
</ul>
<p>The Multicore OCaml project has had a number of optimisations and performance improvements in the month of August 2020:</p>
<ul>
<li>The PR on the <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">implementation of systhreads with pthreads</a> continues to undergo review and improvement. When merged, this opens up the possibility of installing dune and other packages with Multicore OCaml.
</li>
<li>Implementations of mutex and condition variables is also now <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/390">under review</a> for the <code>Domain</code> module.
</li>
<li>Work has begun on implementing <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/394">GC safe points</a> to ensure reliable, low-latency garbage collection can occur.
</li>
</ul>
<p>We would like to particularly thank these external contributors:</p>
<ul>
<li>Albin Coquereau and Guillaume Bury for their comments and recommendations on building Alt-Ergo.2.3.2 with dune.2.6.0 and Multicore OCaml 4.10.0 in a sandbox environment.
</li>
<li>@Leonidas for testing the code size metric implementation with <code>Core</code> and <code>Async</code>, and for code review changes.
</li>
</ul>
<p>Contributions such as the above towards adapting your projects with our benchmarking suites are always most welcome.  As with previous updates, we begin with the Multicore OCaml updates, which are then followed by the enchancements and bug fixes to the Sandmark benchmarking project. The upstream OCaml ongoing and completed tasks are finally mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">ocaml-multicore/ocaml-multicore#381</a>
Reimplementating systhreads with pthreads</p>
<p>This PR has made tremendous progress with additions to domain API,
changes in interaction with the backup thread, and bug fixes. We are
now able to build <code>dune.2.6.1</code> and <code>utop</code> with this PR for Multicore
OCaml, and it is ready for review!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/384">ocaml-multicore/ocaml-multicore#384</a>
Add a primitive to insert nop instruction</p>
<p>The <code>nop</code> primitive is introduced to identify the start and end of
an instruction sequence to aid in debugging low-level code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/390">ocaml-multicore/ocaml-multicore#390</a>
Initial implementation of Mutexes and Condition Variables</p>
<p>A draft proposal that adds support for Mutex variables and Condition
operations for the Multicore runtime.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Optimisations</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/16">ocaml-multicore/domainslib#16</a>
Improvement of parallel_for implementation</p>
<p>A divide-and-conquer scheme is introduced to distribute work in
<code>parallel_for</code>, and the <code>chunk_size</code> is made a parameter to improve
scaling with more than 8-16 cores. The blue line in the following
illustration shows the improvement for few benchmarks in Sandmark
using the default <code>chunk_size</code> along with this PR:
<img src="upload://u4M9bCyA5fu77JZRyJZv4KxMjj3.png" alt="OCaml-Domainslib-16-Illustration|465x500" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/28">ocaml-multicore/multicore-opam</a>
Use <code>-j%{jobs}%</code> for multicore variant builds</p>
<p>The use of <code>-j%{jobs}%</code> in the build step for multicore variants
will speed up opam installs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/374">ocaml-multicore/ocaml-multicore#374</a>
Force major slice on minor collection</p>
<p>A minor collection will need to schedule a major collection, if a
blocked thread may not progress the major GC when servicing the
minor collector through <code>handle_interrupt</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/378">ocaml-multicore/ocaml-multicore#378</a>
Hold onto empty pools if swept while allocating</p>
<p>An optimization to improve pause times and reduce the number of
locks by using a <code>release_to_global_pool</code> flag in <code>pool_sweep</code>
function that continues to hold onto the empty pools.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/379">ocaml-multicore/ocaml-multicore#379</a>
Interruptible mark and sweep</p>
<p>The mark and sweep work is now made interruptible so that domains
can enter the stop-the-world minor collections even if one domain is
performing a large task. For example, for the binary tree benchmark
with four domains, major work (pink) in domain three stalls progress
for other domains as observed in the eventlog.
<img src="upload://y7YfHHD2CGLLjUFw6rdwuBBq0zm.png" alt="OCaml-Multicore-PR-379-Illustration-Before|539x500" /></p>
<p>With this patch, we can observe that the major work in domains two
and four make progress in the following illustration:
<img src="upload://3UPxEjemdhgAAEnnqsv7iV17PK3.png" alt="OCaml-Multicore-PR-379-Illustration-After|655x500" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/380">ocaml-multicore/ocaml-multicore#380</a>
Make DLS call to <code>caml_domain_dls_get</code> <code>@@noalloc</code></p>
<p>The <code>caml_dls_get</code> is tagged with <code>@@noalloc</code> to reduce the C call
overhead.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/382">ocaml-multicore/ocaml-multicore#382</a>
Optimise <code>caml_continuation_use_function</code></p>
<p>A couple of optimisations that yield 25% performance improvements
for the generator example by using <code>caml_domain_alone</code>, and using
<code>caml_gc_log</code> under <code>DEBUG</code> mode.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/389">ocaml-multicore/ocaml-multicore#389</a>
Avoid holding domain_lock when using backup thread</p>
<p>The wait time for the main OCaml thread is reduced by altering the
backup thread logic without holding the <code>domain_lock</code> for the
<code>BT_IN_BLOCKING_SECTION</code>.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/391">ocaml-multicore/ocaml-multicore#391</a>
Use <code>Word_val</code> for pointers with <code>Patomic_load</code></p>
<p>A bug fix to correctly handle <code>Patomic_load</code> for loaded pointers.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/392">ocaml-multicore/ocaml-multicore#392</a>
Include Ipoll in leaf function test</p>
<p>The <code>Ipoll</code> operation is now added to <code>asmcomp/amd64/emit.mlp</code> as an external call.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/122">ocaml-bench/sandmark#122</a>
Measurements of code size</p>
<p>The code size of a benchmark is one measurement that is required for
<code>flambda</code> branch. A
<a href="https://github.com/ocaml-bench/sandmark/pull/165">PR</a> has been
created that now emits a count of the CAML symbols in the output of
a bench result as shown below:</p>
<pre><code>{&quot;name&quot;:&quot;knucleotide.&quot;, ... ,&quot;codesize&quot;:276859.0, ...}
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/169">ocaml-bench/sandmark#169</a>
Add check_url for .json and pkg-config, m4 in Makefile</p>
<p>A <code>check_url</code> target in the Makefile has been defined to ensure that
the <code>ocaml-versions/*.json</code> files have a URL parameter. The patch
also adds <code>pkg-config</code> and <code>m4</code> to Ubuntu dependencies.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Benchmarks</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/107">ocaml-bench/sandmark#107</a>
Add Coq benchmarks</p>
<p>The <code>fraplib</code> library from the <a href="https://github.com/achlipala/frap">Formal Reasoning About
Programs</a> has been dunified and
included in Sandmark for Coq benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/151">ocaml-bench/sandmark#151</a>
Evolutionary algorithm parallel benchmark</p>
<p>The evolutionary algorithm parallel benchmark is now added to Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/152">ocaml-bench/sandmark#152</a>
LU decomposition: random numbers initialisation in parallel</p>
<p>The random number initialisation for the LU decomposition benchmark
now has parallelism that uses <code>Domain.DLS</code> and <code>Random.State</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/153">ocaml-bench/sandmark#153</a>
Add computationally intensive Coq benchmarks</p>
<p>The <code>BasicSyntax</code> and <code>AbstractInterpretation</code> Coq files perform a
lot of minor GCs and allocations, and have been added as benchmarks
to Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/155">ocaml-bench/sandmark#155</a>
Sequential version of Evolutionary Algorithm</p>
<p>The sequential version of algorithms are used for comparison with
their respective parallel implementations. A sequential
implementation for the <code>Evolutionary Algorithm</code> has now been included
in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/157">ocaml-bench/sandmark#157</a>
Minilight Multicore: Port to Task API and DLS for Random States</p>
<p>The Minilight benchmark has been ported to use the Task API along
with the use of Domain Local Storage for the Random States. The
speedup is shown in the following illustration:</p>
<p><img src="images/OCaml-Sandmark-PR-157-Speedup.png" alt="PR 157 Image" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/164">ocaml-bench/sandmark#164</a>
Tweaks to multicore-numerical/game_of_life</p>
<p>The <code>board_size</code> for the Game of Life numerical benchmark is now
configurable, and can be supplied as an argument.</p>
</li>
</ul>
<h4>Bug Fixes</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/156">ocaml-bench/sandmark#156</a>
Fix calculation of Nbody Multicore</p>
<p>Minor fixes in the calculation of interactions of the bodies in the
<code>Nbody</code> implementation, and use of local ref vars to reduce writes and
cache traffic.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/158">ocaml-bench/sandmark#158</a>
Fix key error for Grammatrix for Jupyter notebook</p>
<p>The <code>Key Error</code> issue with <code>notebooks/parallel/parallel.ipynb</code> is
now resolved by passing a value to params in the
<code>multicore_parallel_run_config.json</code> file.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/154">ocaml-bench/sandmark#154</a>
Revert PARAMWRAPPER changes</p>
<p>Undo the <code>PARAMWRAPPER</code> configuration for parallel benchmark runs in
the Makefile, as they are not required for sequential execution.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/160">ocaml-bench/sandmark#160</a>
Specify prefix,libdir for alt-ergo sandbox builds</p>
<p>The <code>alt-ergo</code> library and parser require the <code>prefix</code> and <code>libdir</code>
to be specified with <code>configure</code> in order to build in a sandbox
environment. The initial discussion is available at
<a href="https://github.com/OCamlPro/alt-ergo/issues/351">OCamlPro/alt-ergo#351</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/162">ocaml-bench/sandmark#162</a>
Avoid installing packages which are unused for Multicore runs</p>
<p>The <code>PACKAGES</code> variable in the Makefile has been simplified to
include only those dependency packages that are required to build
Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/163">ocaml-bench/sandmark#163</a>
Update to domainslib 0.2.2 and use default chunk_size</p>
<p>The <code>domainslib</code> dependency package has been updated to use the
0.2.2 released version, and <code>chunk_size</code> for various benchmarks uses
<code>num_tasks/num_domains</code> as default.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9756">ocaml/ocaml#9756</a>
Garbage collectors colour change</p>
<p>The PR is needed for use with the Multicore OCaml major collector by
removing the need of gray colour in the garbage collector (GC)
colour scheme.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9722">ocaml/ocaml#9722</a>
EINTR-based signals, again</p>
<p>The patch provides a new implementation to solve a collection of
locking, signal-handling and error checking issues.</p>
</li>
</ul>
<p>Our thanks to all the OCaml developers and users in the community for their support and contribution to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>DLS: Domain Local Storage
</li>
<li>GC: Garbage Collector
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>LU: Lower Upper (decomposition)
</li>
<li>PR: Pull Request
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - July 2020|js}
  ; slug = {js|multicore-2020-07|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-07-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the July 2020 Multicore OCaml report! This update, along with the <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a>, has been compiled by @shakthimaan, @kayceesrk and myself.  There are a number of advances both in upstream OCaml as well as our multicore trees.</p>
<h2>Multicore OCaml</h2>
<h3>Thread compatibility via Domain Execution Contexts</h3>
<p><em>TL;DR: once <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">#381</a> is merged, dune will work with multicore OCaml.</em></p>
<p>As I <a href="https://discuss.ocaml.org/t/multicore-ocaml-june-2020/6047">noted</a> last month, not having a Thread module that is backwards compatible with traditional OCaml's is a big blocker for ecosystem compatibility.  This can be a little confusing at first glance -- why does Multicore OCaml need non-parallel threading support?  The answer lies in the relationship between <a href="https://github.com/ocaml-multicore/ocaml-multicore/wiki/Concurrency-and-parallelism-design-notes">concurrency and parallelism in multicore OCaml</a>.  <em>Concurrency</em> is how we partition multiple computations such that they run in overlapping time periods, and <em>parallelism</em> is how we run them on separate cores simultaneously to gain greater performance.  A number of packages (most notably, Dune) currently use the Thread module to conveniently gain concurrency while writing straight-line code without using monadic abstractions.  These uses do not require parallelism, but are very difficult to rewrite to not use thread-based concurrency.</p>
<p>Therefore, multicore OCaml also needs a way to provide a reasonably performant version of Thread.  The first solution we attempted (started by @jhw and continued by @engil in <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/342#issuecomment-643119638">#342</a>) mapped a Thread to a multicore Domain, but scaled poorly for a larger number of threads since we may have a far greater number of concurrency contexts (Thread instances) than we have CPUs available (Domain instances). This lead to a bit of brainstorming (<a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/357">#357</a>) to figure out a solution that would work for applications like Dune or the <a href="https://github.com/xapi-project/xen-api">XenServer stack</a> that are heavy Thread users.</p>
<p>Our solution introduces a concept that we have dubbed <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/381">Domain Execution Contexts in #381</a>, which allows us to map multiple system threads to OCaml domains.  Once that PR is reviewed and merged into the multicore OCaml branches, it will unlock many more ecosystem packages, as the Dune build system will compile unmodified.  The last &quot;big&quot; remaining blocker for wider opam testing after this is then ocaml-migrate-parsetree, which requires a small patch to support the <code>effect</code> keyword syntax that is present in the multicore OCaml trees.</p>
<h3>Domain Local Storage</h3>
<p>Domain Local Storage (DLS) (<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/372">#372</a>) is a simple way to attach OCaml values privately to a domain.  A good example of speedup when using DLS is shown in a PR to the <a href="https://github.com/ocaml-bench/sandmark/pull/152">LU decomposition benchmark</a>. In this case, the benchmark needs a lot of random numbers, and initialising them in parallel locally to the domain is a win.</p>
<p>Another example is the parallel implementation of an evolutionary algorithm (originally suggested by @per_kristian_lehre in <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/336">#336</a>) which speeds up nicely in <a href="https://github.com/ocaml-bench/sandmark/pull/151">#151</a> (for those who want to check the baseline, there is a sequential version in <a href="https://github.com/ocaml-bench/sandmark/pull/155">#155</a> that you can look up in the Sandmark web interface).</p>
<h3>Parallel Programming with Multicore OCaml (document)</h3>
<p>A tutorial on <a href="https://github.com/ocaml-multicore/parallel-programming-in-multicore-ocaml">Parallel Programming with Multicore OCaml</a> has been made available. It provides an introduction to Multicore OCaml and explains the concepts of <code>Domains</code>, <code>Domainslib</code>, and <code>Channels</code>. Profiling of OCaml code using <code>perf</code> and <code>Eventlog</code> are also illustrated with examples.</p>
<p>This draft was shared on  <a href="https://www.reddit.com/r/ocaml/comments/hluzmy/parallel_programming_in_multicore_ocaml_a_tutorial/">Reddit</a> as well as on <a href="https://news.ycombinator.com/item?id=23740869">HackerNews</a>, so you'll find more chatter about it there.</p>
<h3>Coq benchmarks</h3>
<p>The Sandmark benchmarking suite for OCaml has been successfully updated to use dune.2.6.0 and builds for Multicore OCaml 4.10.0. With this major upgrade, we have also been able to include Coq and its
dependencies. We are working on adding more regression Coq benchmarks to the test suite.</p>
<h2>Upstream OCaml</h2>
<p>The upstream OCaml trees have seen a flurry of activity in the 4.12.0dev trees with changes to prepare for multicore OCaml.  The biggest one is the (to quote @xavierleroy) fabled page-less compactor in <a href="https://github.com/ocaml/ocaml/pull/9728">ocaml/ocaml#9728</a>.  This followed on from last month's work (<a href="https://github.com/ocaml/ocaml/pull/9698">#9698</a>) to eliminate the use of the page table when the compiler is built with the &quot;no-naked-pointers&quot; option, and clears the path for the parallel multicore OCaml runtime to be integrated in a future release of OCaml.</p>
<p>One of the other changes we hope to get into OCaml 4.12 is the alignment of the use of garbage collector colours when marking and sweeping. The <a href="https://github.com/ocaml/ocaml/pull/9756">#9756</a> changes make the upstream runtime use the same scheme we described in the <a href="https://arxiv.org/abs/2004.11663">Retrofitting Parallelism onto OCaml</a> ICFP paper, with a few extra improvements that you can read about in the PR review comments.</p>
<p>If you are curious about the full set of changes, you can see all the <a href="https://github.com/ocaml/ocaml/issues?q=label%3Amulticore-prerequisite+is%3Aclosed">multicore prerequisite</a> issues that have been closed to date upstream.</p>
<h1>Detailed Updates</h1>
<p>As with the previous updates, the Multicore OCaml updates are first listed, which are then followed by the enhancements to the Sandmark benchmarking project. The upstream OCaml ongoing and completed updates are finally mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/342">ocaml-multicore/ocaml-multicore#342</a>
Implementing the threads library with Domains</p>
<p>This is an on-going effort to rebase @jhwoodyatt's implementation of the Thread
library for Domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/357">ocaml-multicore/ocaml-multicore#357</a>
Implementation of systhreads with pthreads</p>
<p>A Domain Execution Context (DEC) is being introduced in this
implementation as a concurrency abstraction for implementing
systhreads with pthreads.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/374">ocaml-multicore/ocaml-multicore#374</a>
Force major slice on minor collection</p>
<p>A blocked thread in a domain may not progress the major GC when
servicing the minor collector through <code>handle_interrupt</code>, and hence
we need to have a minor collection to schedule a major collection
slice.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Domain-Local State</h4>
<ul>
<li>
<p><a href="https://github.com/Sudha247/ocaml-multicore/pull/1">Sudha247/ocaml-multicore#1</a>
<code>dls_root</code> should be deleted before terminal GC</p>
<p>The deletion of the global root pushes an object on the mark stack,
and hence a final GC needs to be performed before the terminal GC.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/372">ocaml-multicore/ocaml-multicore#372</a>
Domain-local Storage</p>
<p>The RFC proposal <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/339">ocaml-multicore#339</a> to implement
Domain-Local Storage has been completed and merged to
Multicore OCaml.</p>
</li>
</ul>
<h4>Removal of vestiges in Concurrent Minor GC</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/370">ocaml-multicore/ocaml-multicore#370</a>
Remove Cloadmut and lloadmut</p>
<p>The <code>Cloadmut</code> and <code>Iloadmut</code> implementation and usage have been
cleaned up with this patch. This simplifies the code and brings it
closer to stock OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/371">ocaml-multicore/ocaml-multicore#371</a>
Domain interrupt cleanup</p>
<p>In <code>runtime/domain.c</code> the <code>struct interruptor* sender</code> has been
removed. The domain RPC functions have been grouped together in
<code>domain.h</code>, and consistent naming of definitions have been applied.</p>
</li>
</ul>
<h4>Code Cleanup</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/367">ocaml-multicore/ocaml-multicore#367</a>
Remove some unused RPC consumers</p>
<p>The domain RPC mechanisms are no longer in use, and have been
removed.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/368">ocaml-multicore/ocaml-multicore#368</a>
Removal of dead bits of read_barrier and caml_promote</p>
<p>This PR removes <code>caml_promote</code>, the assembly for read faults on ARM
and AMD, and the global for the read fault.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/366">ocaml-multicore/ocaml-multicore#366</a>
Add event to record idle domains</p>
<p>The <code>domain/idle_wait</code> and <code>domain/send_interrupt</code> events are added
to track domains that are idling. An eventlog screenshot with this
effect is shown below:</p>
</li>
</ul>
<p><img src="upload://nPr6W8aUgyYDU1ZhO5XOAFKMiam.png" alt="PR 366 Image |690x298" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/369">ocaml-multicore/ocaml-multicore#369</a>
Split caml_urge_major_slice into caml_request_minor_gc and
caml_request_major_slice</p>
<p>The <code>caml_urge_major_slices</code> is split into <code>caml_request_minor_gc</code>
and <code>caml_request_major_slice</code>. This reduces the total number of
minor garbage collections as observed in the following illustration:</p>
</li>
</ul>
<p><img src="upload://eCdqNjb7AtmLGmL0TpUKZG3lpeT.png" alt="PR 369 Image |690x203" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/373">ocaml-multicore/ocaml-multicore#373</a>
Fix the opam pin command in case the current directory name has spaces</p>
<p>Use the <code>-k path</code> command-line argument with <code>opam pin</code> to handle
directory names that have whitespaces.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/375">ocaml-multicore/ocaml-multicore#375</a>
Only lock the global freelist to adopt pools if needed</p>
<p>The lock acquire and release on allocation is removed when there are
no global pools requiring adoption.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/377">ocaml-multicore/ocaml-multicore#377</a>
Group env vars for run in travis CI</p>
<p>The <code>OCAMLRUNPARAM</code> parameter is defined as part of the environment
variable with the <code>USE_RUNTIME=d</code> command.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/dune/pull/3608">ocaml/dune#3608</a>
Upstream Multicore dune bootstrap patch</p>
<p>The patch is used to build dune using the secondary compiler
approach for
<a href="https://github.com/ocaml/dune/issues/3548">ocaml/dune#3548</a>.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/107">ocaml-bench/sandmark#107</a>
Add Coq benchmarks</p>
<p>The upgrade of Sandmark to use dune.2.6.0 for Multicore OCaml 4.10.0
has allowed us to install Coq and its dependencies. We are currently
working on adding more Coq regression benchmarks to Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/122">ocaml-bench/sandmark#122</a>
Measurements of code size</p>
<p>The code size of a benchmark is one measurement that is required for
<code>flambda</code> branch, and we are exploring adding the same to the
Sandmark bench runs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/142">ocaml-bench/sandmark#142</a>
[RFC] How should a user configure a sandmark run?</p>
<p>We are gathering user feedback and suggestions on how you would like
to configure benchmarking for Sandmark. Please share your thoughts
and comments in this discussion.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/150">ocaml-bench/sandmark#150</a>
Coq files that work</p>
<p>Addition of more Coq files for benchmarking in Sandmark.</p>
</li>
</ul>
<h3>Completed</h3>
<h4>Dune 2.6.0 Upgrade</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/131">ocaml-bench/sandmark#131</a>
Update decompress benchmarks</p>
<p>The decompress benchmarks were updated by @dinosaure to use the
latest decompress.1.1.0 for dune.2.6.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/132">ocaml-bench/sandmark#132</a>
Update dependency packages to use dune.2.6.0 and Multicore OCaml 4.10.0</p>
<p>Sandmark has now been updated to use dune.2.6.0 and Multicore OCaml
4.10.0 with an upgrade of over 30 dependency packages. You can test
the same using:</p>
<pre><code>$ opam install dune.2.6.0
$ make ocaml-versions/4.10.0+multicore.bench
</code></pre>
</li>
</ul>
<h4>Coq Benchmarks</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/140">ocaml-bench/sandmark#140</a>
coqc compiling with Sandmark</p>
<p>The Coq compiler is added as a dependency package to Sandmark, which
now allows us to build and run Coq benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/143">ocaml-bench/sandmark#143</a>
Added Coq library fraplib and a benchmark that depends on it</p>
<p>The <a href="https://github.com/achlipala/frap">Formal Reasoning About
Programs</a> book's <code>fraplib</code>
library benchmarks have now been included in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/144">ocaml-bench/sandmark#144</a>
Add frap as a Coq benchmark</p>
<p>The <code>CompilerCorrectness.v</code> Coq file is added as a test benchmark
for Coq in Sandmark.</p>
</li>
</ul>
<h4>Continuous Integration</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/136">ocaml-bench/sandmark#136</a>
Use BUILD_ONLY in .drone.yml</p>
<p>The .drone.yml file has been updated to use a BUILD_ONLY environment
variable to just install the dependencies and not execute the
benchmarks for the CI.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/147">ocaml-bench/sandmark#147</a>
Add support to associate tags with benchmarks</p>
<p>The <code>macro_bench</code> and <code>run_in_ci</code> tags have been introduced to
associate with the benchmarks. The benchmarks tagged as <code>run_in_ci</code>
will be executed as part of the Sandmark CI.</p>
</li>
</ul>
<h4>Sundries</h4>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/124">ocaml-bench/sandmark#124</a>
User configurable paramwrapper added to Makefile</p>
<p>The <code>--cpu-list</code> can now be specified as a <code>PARAMWRAPPER</code>
environment variable for running the parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/134">ocaml-bench/sandmark#134</a>
Include more info on README</p>
<p>The README has been updated to include documentation to reflect the
latest changes in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/141">ocaml-bench/sandmark#141</a>
Enrich the variants with additional options</p>
<p>The <code>ocaml-versions/*</code> files now use a JSON file format which allow
you to specify the ocaml-base-compiler source URL, <code>configure</code>
options and <code>OCAMLRUNPARAMS</code>. An example is provided below:</p>
<pre><code>{
  &quot;url&quot; : &quot;https://github.com/ocaml-multicore/ocaml-multicore/archive/parallel_minor_gc.tar.gz&quot;,
  &quot;configure&quot; : &quot;-q&quot;,
  &quot;runparams&quot; : &quot;v=0x400&quot;
}
</code></pre>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/146">ocaml-bench/sandmark#146</a>
Update trunk from 4.11.0 to 4.12.0</p>
<p>Sandmark now uses the latest stock OCaml 4.12.0 as trunk in
ocaml-versions/.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/148">ocaml-bench/sandmark#148</a>
Install python3-pip and intervaltree for clean CI build</p>
<p>The .drone.yml file has been updated to install <code>python3-pip</code> and
<code>intervaltree</code> software packages to avoid errors when the Makefile
is invoked.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9722">ocaml/ocaml#9722</a>
EINTR-based signals, again</p>
<p>The patch provides a new implementation to solve locking and
signal-handling issues.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9756">ocaml/ocaml#9756</a>
Garbage collector colours change</p>
<p>The PR removes the gray colour in the garbage collector (GC) colour
scheme in order to use it with the Multicore OCaml major collector.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/dune/pull/3576">ocaml/dune#3576</a>
In OCaml 4.12.0, empty archives no longer generate .a files</p>
<p>A native archive will never be generated for an empty library, and
this fixes the compatibility with OCaml 4.12.0 when dealing with
empty archives.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9541">ocaml/ocaml#9541</a>
Add manual page for the instrumented runtime</p>
<p>The <code>manual/manual/cmds/instrumented-runtime.etex</code> document has been
updated based on review comments and has been merged to stock OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9728">ocaml/ocaml#9728</a>
Simplified compaction without page table</p>
<p>A self-describing closure representation is used to simplify the
compactor, and to get rid of the page table.</p>
</li>
</ul>
<p>We would like to thank all the OCaml developers and users in the community for their continued support, code reviews, documentation and contributions to the multicore OCaml project.</p>
<h2>Acronyms</h2>
<ul>
<li>CI: Continuous Integration
</li>
<li>DEC: Domain Execution Context
</li>
<li>GC: Garbage Collector
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request for Comments
</li>
<li>RPC: Remote Procedure Call
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - June 2020|js}
  ; slug = {js|multicore-2020-06|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-06-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the June 2020 <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml</a> report! As with <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a>, many thanks to @shakthimaan and @kayceesrk for collating the updates for the month of June 2020. <em>This is an incremental update; new readers may find it helpful to flick through the previous posts first.</em></p>
<p>This month has seen a tremendous surge of activity on the upstream OCaml project to prepare for multicore integration, as @xavierleroy and the core team have driven a number of initiatives to prepare the OCaml project for the full multicore featureset.  To reflect this, from next month we will have a status page on the ocaml-multicore wiki with the current status of both our multicore branch and the upstream OCaml project itself.</p>
<p>Why not from this month? Well, there's good news and bad news.  <a href="https://discuss.ocaml.org/t/multicore-ocaml-may-2020-update/5898">Last month</a>, I observed that we are a PR away from most of the opam ecosystem working with the multicore branch.  The good news is that we are still a single PR away from it working, but it's a different one :-) The retrofitting of the <code>Threads</code> library has brought up <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/342">some design complexities</a>, and so rather than putting in a &quot;bandaid&quot; fix, we are integrating a comprehensive solution that will work with system threads, domains and (eventually) fibres. That work has taken some time to get right, and I hope to be able to update you all on an opam-friendly OCaml 4.10.0+multicore in a few weeks.</p>
<p>Aside from this, there have been a number of other improvements going into the multicore branches: <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/351">mingw Windows support</a>, <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/363">callstack improvements</a>, <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/346">fixing the Unix module</a> and so on. The full list is in the detailed report later in this update.</p>
<h2>Sandmark benchmarks</h2>
<p>A major milestone in this month has been the upgrade to the latest dune.2.6.0 to build Multicore OCaml 4.10.0 for the Sandmark benchmarking project. A number of new OPAM packages have been added, and the existing packages have been upgraded to their latest versions. The Multicore OCaml code base has seen continuous performance improvements and enhancements which can be observed from the various PRs mentioned in the report.</p>
<p>We would like to thank:</p>
<ul>
<li>@xavierleroy for working on a number of multicore-prequisite PRs to
make stock OCaml ready for Multicore OCaml.
</li>
<li>@camlspotter has reviewed and accepted the camlimages changes
and made a release of camlimages.5.0.3 required for Sandmark.
</li>
<li>@dinosaure for updating the decompress test benchmarks for Sandmark
to build and run with dune.2.6.0 for Multicore OCaml 4.10.0.
</li>
</ul>
<p>A chapter on Parallel Programming in Multicore OCaml with topics on task pool, channels section, profiling with code examples is being written. We shall provide an early draft version of the document to the community for your valuable feedback.</p>
<h2>Papers</h2>
<p>Our &quot;Retrofitting Parallism onto OCaml&quot; paper has been officially accepted at <a href="https://icfp20.sigplan.org/track/icfp-2020-papers#event-overview">ICFP 2020</a> which will be held virtually between August 23-28, 2020. A <a href="https://arxiv.org/abs/2004.11663">preprint</a> of the paper was made available earlier, and will be updated in a few days with the camera-ready version for ICFP.  Please do feel free to send on comments and queries even after the paper is published, of course.</p>
<p>Excitingly, another multicore-related paper on <a href="http://gallium.inria.fr/~fpottier/publis/mevel-jourdan-pottier-cosmo-2020.pdf">Cosmo: A Concurrent Separation Logic for Multicore OCaml</a> will also be presented at the same conference.</p>
<p>The Multicore OCaml updates are first listed in our report, which are followed by improvements to the Sandmark benchmarking project. Finally, the changes made to upstream OCaml which include both the ongoing and completed tasks are mentioned for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/339">ocaml-multicore/ocaml-multicore#339</a>
Proposal for domain-local storage</p>
<p>An RFC proposal to implement a domain-local storage in Multicore
OCaml. Kindly review the idea and share your feedback!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/342">ocaml-multicore/ocaml-multicore#342</a>
Implementing the threads library with Domains</p>
<p>An effort to rebase @jhwoodyatt's implementation of the Thread
library for Domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/357">ocaml-multicore/ocaml-multicore#357</a>
Implementation of systhreads with pthreads</p>
<p>Exploring the possibilty of implementing systhreads with pthreads,
while still maintaining compatibility with the existing solution.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/dune/issues/3548">ocaml/dune#3548</a>
Dune fails to pick up secondary compiler</p>
<p>The <code>ocaml-secondary-compiler</code> fails to install with dune.2.6.0. This
is required as Multicore OCaml cannot build the latest dune without
systhreads support.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/multicore-opam/pull/22">ocaml-multicore/multicore-opam#22</a>
Update dune to 2.6.0</p>
<p>The dune version in the Multicore OPAM repository is now updated to
use the latest 2.6.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/338">ocaml-multicore/ocaml-multicore#338</a>
Introduce Lazy.try_force and Lazy.try_force_val</p>
<p>An implementation of <code>Lazy.try_force</code> and <code>Lazy.try_force_val</code>
functions to implement concurrent lazy abstractions.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/340">ocaml-multicore/ocaml-multicore#340</a>
Fix Atomic.exchange in concurrent_minor_gc</p>
<p>A patch that introduces <code>Atomic.exchange</code> through <code>Atomic.get</code> that
provides the appropriate read barrier for correct exchange
semantics for <code>caml_atomic_exchange</code> in <code>memory.c</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/343">ocaml-multicore/ocaml-multicore#343</a>
Fix extcall noalloc DWARF</p>
<p>The DWARF information emitted for <code>extcall noalloc</code> had broken
backtraces and this PR fixes the same.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/345">ocaml-multicore/ocaml-multicore#345</a>
Absolute exception stack</p>
<p>The representation of the exception stack is changed from relative
addressing to absolute addressing and the results are promising. The
Sandmark serial benchmark results after the change is illustrated in
the following graph:</p>
</li>
</ul>
<p><img src="upload://pC6XsKYqKRDr9zy7RQmp8D6XIDE.png" alt="Absolute addressing improvements |690x218" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/347">ocaml-multicore/ocaml-multicore#347</a>
Turn on -Werror by default</p>
<p>Adds a <code>--enable-warn-error</code> option to <code>configure</code> to treat C
compiler warnings as errors.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/353">ocaml-multicore/ocaml-multicore#353</a>
Poll for interrupts in cpu_relax without locking</p>
<p>Use <code>Caml_check_gc_interrupt</code> first to poll for interrupts without
locking, and then proceeding to handle the interrupt with the lock.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/354">ocaml-multicore/ocaml-multicore#354</a>
Add Caml_state_field to domain_state.h</p>
<p>The <code>Caml_state_field</code> macro definition in domain_state.h is
required for base-v0.14.0 to build for Multicore OCaml 4.10.0 with
dune.2.6.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/355">ocaml-multicore/ocaml-multicore#355</a>
One more location to poll for interrupts without lock</p>
<p>Another use of <code>Caml_check_gc_interrupt</code> first to poll for
interrupts without lock, similar to
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/353">ocaml-multicore/ocaml-multicore#353</a>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/356">ocaml-multicore/ocaml-multicore#356</a>
Backup threads for domain</p>
<p>Introduces <code>backup threads</code> to perform GC and handle service
interrupts when the domain is blocked in the kernel.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/358">ocaml-multicore/ocaml-multicore#358</a>
Fix up bad CFI information in amd64.S</p>
<p>Add missing <code>CFI_ADJUST</code> directives in <code>runtime/amd64.S</code> for
<code>caml_call_poll</code> and <code>caml_allocN</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/359">ocaml-multicore/ocaml-multicore#359</a>
Inline caml_domain_alone</p>
<p>The PR makes <code>caml_domain_alone</code> an inline function to improve
performance for <code>caml_atomic_cas_field</code> and other atomics in
<code>memory.c</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/360">ocaml-multicore/ocaml-multicore#360</a>
Parallel minor GC inline mask rework</p>
<p>The inline mask rework for the promotion path to the
<code>parallel_minor_gc</code> branch gives a 3-5% performance improvement for
<code>test_decompress</code> sandmark benchmark, and a decrease in the executed
instructions for all other benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/361">ocaml-multicore/ocaml-multicore#361</a>
Mark stack push work credit</p>
<p>The PR improves the Multicore mark work accounting to be in line
with stock OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/362">ocaml-multicore/ocaml-multicore#362</a>
Iloadmut does not clobber rax and rdx when we do not have a read barrier</p>
<p>A code clean-up to free the registers <code>rax</code> and <code>rdx</code> for OCaml code
when <code>Iloadmut</code> is used.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/8">ocaml-bench/sandmark#8</a>
Ability to run compiler variants in Sandmark</p>
<p>A feature to specify configure options when building compiler
variants such as <code>flambda</code> is useful for development and
testing. This feature is being worked upon.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/107">ocaml-bench/sandmark#107</a>
Add Coq benchmarks</p>
<p>We are continuing to add more benchmarks to Sandmark for Multicore
OCaml and investigating adding the <a href="https://coq.inria.fr/">Coq</a>
benchmarks to our repertoire!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/124">ocaml-bench/sandmark#124</a>
User configurable paramwrapper added to Makefile</p>
<p>A <code>PARAMWRAPPER</code> environment variable can be passed as an argument
by specifying the <code>--cpu-list</code> to be used for parallel benchmark
runs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/131">ocaml-bench/sandmark#131</a>
Update decompress benchmarks</p>
<p>Thanks to @dinosaure for updating the decompress benchmarks in order
to run them with dune.2.6.0 for Multicore OCaml 4.10.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/132">ocaml-bench/sandmark#132</a>
Update dependency packages to use dune.2.6.0 and Multicore OCaml 4.10.0</p>
<p>Sandmark has been running with dune.1.11.4, and we need to move to
the latest dune.2.6.0 for using Multicore OCaml 4.10.0 and beyond,
as mentioned in <a href="https://github.com/ocaml-bench/sandmark/issues/106">Promote dune to &gt;
2.0</a>. The PR
updates over 30 dependency packages and successfully builds both
serial and parallel benchmarks!</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://gitlab.com/camlspotter/camlimages/-/merge_requests/1">camlspotter/camlimages#1</a>
Use dune-configurator instead of configurator for camlimages</p>
<p>A new release of <code>camlimages.5.0.3</code> was made by @camlspotter after
accepting the changes to camlimages.opam in order to build with
dune.2.6.0.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/115">ocaml-bench/sandmark#115</a>
Task API Port: LU-Decomposition, Floyd Warshall, Mandelbrot, Nbody</p>
<p>The changes to use the <code>Domainslib.Task</code> API for the listed benchmarks
have been merged.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/121">ocaml-bench/sandmark#121</a>
Mention sudo access for run_all_parallel.sh script</p>
<p>The README.md file has been updated with the necessary <code>sudo</code>
configuration steps to execute the <code>run_all_parallel.sh</code> script for
nightly builds.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/125">ocaml-bench/sandmark#125</a>
Add cubicle benchmarks</p>
<p>The <code>German PFS</code> and <code>Szymanski's mutual exclusion algorithm</code> cubicle
benchmarks have been included in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/126">ocaml-bench/sandmark#126</a>
Update ocaml-versions README to reflect 4.10.0+multicore</p>
<p>The README has now been updated to reflect the latest 4.10.0
Multicore OCaml compiler and its variants.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/129">ocaml-bench/sandmark#129</a>
Add target to run parallel benchmarks in the CI</p>
<p>The .drone.yml file used by the CI has been updated to run both the
serial and parallel benchmarks.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/130">ocaml-bench/sandmark#130</a>
Add missing dependencies in multicore-numerical</p>
<p>The <code>domainslib</code> library has been added to the dune file for the
multicore-numerical benchmark.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9541">ocaml/ocaml#9541</a>
Add manual page for the instrumented runtime</p>
<p>The <a href="https://github.com/ocaml/ocaml/pull/9082">instrumented runtime</a>
has been merged to OCaml 4.11.0. A manual for the same has been
created and is under review.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9619">ocaml/ocaml#9619</a>
A self-describing representation for function closures</p>
<p>The PR provides a way to record the position of the environment for
each entry point for function closures.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9649">ocaml/ocaml#9649</a>
Marshaling for the new closure representation</p>
<p>The <code>output_value</code> marshaler has been updated to use the new closure
representation. There is no change required for the <code>input_value</code>
unmarshaler.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9655">ocaml/ocaml#9655</a>
Introduce type Obj.raw_data and functions Obj.raw_field,
Obj.set_raw_field to manipulate out-of-heap pointers</p>
<p>The PR introduces a type <code>Obj.bits</code>, and functions <code>Obj.field_bits</code>
and <code>Obj.set_field_bits</code> to read and write bit representation of
block fields to support the no-naked-pointer operation.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9678">ocaml/ocaml#9678</a>
Reimplement Obj.reachable_word using a hash table to detect sharing</p>
<p>The <code>caml_obj_reachable_words</code> now uses a hash table instead of
modifying the mark bits of block headers to detect sharing. This is
required for compatibility with Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9680">ocaml/ocaml#9680</a>
Naked pointers and the bytecode interpreter</p>
<p>The bytecode interpreter implementation is updated to support the
no-naked-pointers mode operation as required by Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9682">ocaml/ocaml#9682</a>
Signal handling in native code without the page table</p>
<p>The patch uses the code fragment table instead of a page table
lookup for signal handlers to know whether the signal came from
ocamlopt-generated code.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9683">ocaml/ocaml#9683</a>
globroots.c: adapt to no-naked-pointers mode</p>
<p>The patch considers out-of-heap pointers as major-heap pointers in
no-naked-pointers mode for global roots management.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9689">ocaml/ocaml#9689</a>
Generic hashing for the new closure representation</p>
<p>The hashing functions have been updated to use the latest closure
representation from
<a href="https://github.com/ocaml/ocaml/pull/9619">ocaml/ocaml#9619</a> for the
no-naked-pointers mode.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9698">ocaml/ocaml#9698</a>
The end of the page table is near</p>
<p>The PR eliminates some of the use of the page tables in the runtime
system when built with no-naked-pointers mode.</p>
</li>
</ul>
<p>Our thanks to all the OCaml developers and users in the community for
their continued support and contribution to the project. Stay safe!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>CFI: Call Frame Information
</li>
<li>CI: Continuous Integration
</li>
<li>DWARF: Debugging With Attributed Record Formats
</li>
<li>GC: Garbage Collector
</li>
<li>ICFP: International Conference on Functional Programming
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request for Comments
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - May 2020|js}
  ; slug = {js|multicore-2020-05|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-05-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<h1>Multicore OCaml: May 2020</h1>
<p>Welcome to the May 2020 update from the Multicore OCaml team! As with <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a>, many thanks to @shakthimaan and @kayceesrk for help assembling this month's roundup.</p>
<p>A major milestone in May 2020 has been the completion of rebasing of Multicore OCaml all the way from 4.06 to 4.10! The Parallel Minor GC variant that performs stop-the-world parallel minor collection is the <a href="https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc">default branch</a> for the compiler, which means that compatibility with C bindings is now much simpler than with the older minor GC design.</p>
<p>I've received many questions asking if this means that multicore OCaml will &quot;just work&quot; with the opam ecosystem now.  Not quite yet: we estimate that we are now one PR away from this working, which requires that the existing <code>Threads</code> module is backported to multicore OCaml to support the older (non-parallel-in-the-runtime but concurrent) uses of threading that existing OCaml supports.  This effort was begun a year ago by @jhw in <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/240">#240</a> and now rebased and being reviewed by @engil in <a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/342">#342</a>. Once that is merged and tested by us on a bunch of packages and bulk builds, we should be good to start using Multicore OCaml with opam. Stay tuned for more on that next month!</p>
<p>The ongoing and completed tasks for the Multicore OCaml are listed first, which are then followed by improvements to the Sandmark benchmarking project. Finally, the status of the contributions to upstream OCaml are mentioned for your reference.  This month has also seen a meeting of the core OCaml runtime developers to assign post-rebasing tasks (such as also porting statmemprof, how to handle non-x86 architectures, Windows support, etc) to ensure a more complete view of the upstreaming tasks ahead.  The task list is long, but steadily decreasing in length.</p>
<p>As to how to contribute currently, there is an incredibly exciting seam of work that has now started on the appropriate programming abstractions to support parallel algorithms in OCaml. See <a href="https://discuss.ocaml.org/t/language-abstractions-and-scheduling-techniques-for-efficient-execution-of-parallel-algorithms-on-multicore-hardware/5822/19">this thread</a> for more on that, and also on the <a href="https://github.com/ocaml-multicore/domainslib">Domainslib</a> repository for more low-level examples of traditional parallel algorithms.  In a month or so, we expect that the multicore switch will also be more suitable for use with opam, but don't let that stop you from porting your favourite parallel benchmark to Domainslib today.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/339">ocaml-multicore/ocaml-multicore#339</a>
Proposal for domain-local storage</p>
<p>A new proposal for implementing a domain-local storage in Multicore
OCaml has been created.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/issues/8">ocaml-multicore/domainslib#8</a>
Task library slowdown if the number of domains is greater than 8</p>
<p>This is an ongoing investigation on why there is a slowdown with
<code>domainslib</code> version 0.2 for the Game of Life benchmark when the
number of domains is greater than eight.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/340">ocaml-multicore/ocaml-multicore#340</a>
Fix Atomic.exchange in concurrent_minor_gc</p>
<p>An implementation is provided for <code>Atomic.exchange</code> using
<code>Atomic.get</code> and <code>Atomic.compare_and_set</code> to obtain the correct
semantics to handle assertion failure in interp.c.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/338">ocaml-multicore/ocaml-multicore#338</a>
Introduce Lazy.try_force and Lazy.try_force_val</p>
<p>The <code>Lazy.try_force</code> and <code>Lazy.try_force_val</code> functions are
implemented for concurrent lazy abstractions to handle the RacyLazy
exception.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/333">ocaml-multicore/ocaml-multicore#333</a>
Random module functions slowdown on multiple cores</p>
<p>There is an observed slowdown for the <code>Random</code> module on multiple
cores, and the issue is being analysed in detail.</p>
<p><img src="upload://z1ggYyLuFZyEYlAIGjOFin3Dv8X.png" alt="perf Random" /></p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/343">ocaml-multicore/ocaml-multicore#343</a>
Fix extcall noalloc DWARF</p>
<p>The patch provides a fix for the emitted DWARF information for
<code>extcall noalloc</code>. This PR is currently under review.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/337/">ocaml-multicore/ocaml-multicore#337</a>
Update opam file to 4.10.0+multicore</p>
<p>The rebasing of Multicore OCaml to 4.11 branch
(<code>parallel_minor_gc_4_11</code>) point is now complete!  The
<a href="https://github.com/ocaml-multicore/multicore-opam/pull/18/">opam</a>
file for 4.10.0+multicore has been made the default in the
multicore-opam repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/335">ocaml-multicore/ocaml-multicore#335</a>
Add byte_domain_state.tbl to install files</p>
<p>A patch to install <code>byte_domain_state.tbl</code> and <code>caml/*.h</code> files has
now been included in the runtime/Makefile which is required for
parallel_minor_gc_4_10 branch.</p>
</li>
<li>
<p>The Multicore OCaml major GC implementation verification using the
SPIN model checker is available at the following GitHub repository
<a href="https://github.com/kayceesrk/multicore-ocaml-verify">ocaml-multicore/multicore-ocaml-verify</a>.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/115">ocaml-bench/sandmark#115</a>
Task API Port: LU-Decomposition, Floyd Warshall, Mandelbrot, N-body</p>
<p>Porting of the following programs - LU-Decomposition, Floyd
Warshall, Mandelbrot and N-body to use the Task API.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/37">ocaml-bench/sandmark#37</a>
Make benchmark wrapper user configurable</p>
<p>The ability to dynamically specify the input commands and their
respective arguments to the benchmark scripts is currently being
evaluated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/106">ocaml-bench/sandmark#106</a>
Promote dune &gt; 2.0</p>
<p>Sandmark works with dune 1.11.4 and we need to support dune greater
than 2.0 moving forward. The upgrade path with the necessary package
builds is being tested.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/109">ocaml-bench/sandmark#109</a>
Added sequential-interactive.ipynb</p>
<p>An interactive notebook to run and analyse sequential benchmarks has
been included. Given an artifacts directory with the benchmark
files, the notebook prompts you in the GUI to select different
commit and compiler variants for analysis. A sample screenshot of
the UI is shown below:</p>
<p><img src="upload://guDEKu51Mz8QwUwvVXA0FAqaWsf.png" alt="Sequentials select comparison" /></p>
<p>The PR adds error handling, user input validation and the project
README has also been updated.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/111">ocaml-bench/sandmark#111</a>
Add parallel initialisation and parallel copy to LU decomposition benchmark</p>
<p>The parallel initialisation is now added to LU decomposition
numerical benchmark
(benchmarks/multicore-numerical/LU_decomposition_multicore.ml).</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/113">ocaml-bench/sandmark#113</a>
Use --format=columns with pip3 list in Makefile</p>
<p>A fix for the &quot;DEPRECATION: The default format will switch to
columns in the future&quot; warning when using <code>pip3 list</code> has now been
added to the Makefile with the use of the <code>--format=columns</code> option.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/116">ocaml-bench/sandmark#116</a>
Use sudo for parallel benchmark builds</p>
<p>The Makefile has been updated with the right combination of <code>sudo</code>
and OPAM environment variables so that we can now run parallel
benchmarks in Sandmark. The sudo command is required exclusively for
using the <code>chrt</code> command. We can now perform nightly builds for both
serial and parallel benchmarks!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/118">ocaml-bench/sandmark#118</a>
Refactored README and added JupyterHub info</p>
<p>The Sandmark README file has now been updated to include information
on configuration, usage of JupyterHub, benchmarking and a quick
start guide!</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9541">ocaml/ocaml#9541</a>
Add manual page for the instrumented runtime</p>
<p>A draft manual for the instrumented runtime eventlog tracing has
been created. Please feel free to review the document and share your
valuable feedback.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/dune/issues/3500">ocaml/dune#3500</a>
Support building executables against OCaml 4.11 instrumented runtime</p>
<p>OCaml 4.11.0 has built-in support for the instrumented runtime, and
it will be useful to have dune generate instrumented targets.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9082">ocaml/ocaml#9082</a>
Eventlog tracing system</p>
<p>The Eventlog tracing proposal for the OCaml runtime that uses the
Binary Trace Format (CTF) is now merged with upstream OCaml
(4.11.0).</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9534">ocaml/ocaml#9534</a>
[RFC] Dynamic check for naked pointers</p>
<p>An RFC for adding the ability to dynamically identify naked pointers
in the 4.10.0 compiler.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9573">ocaml/ocaml#9573</a>
Reimplement Unix.create_process and related functions without Unix.fork</p>
<p>The use of process creation functions in the Unix module is not
suitable for Multicore OCaml, for both behaviour and efficiency. The
patch provides an implementation that uses <code>posix_spawn</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9564">ocaml/ocaml#9564</a>
Add a macro for out-of-heap block header</p>
<p>This PR adds a macro definition to construct a out-of-heap block
header in runtime/caml/mlvalues.h. The objective is to use the
header for out of heap objects.</p>
</li>
</ul>
<p>As always, we would like to thank all the OCaml developers and users for their continued support and contribution to the project. Stay safe out there.</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>CTF: Common Trace Format
</li>
<li>DWARF: Debugging With Attributed Record Formats
</li>
<li>GC: Garbage Collector
</li>
<li>GUI: Graphical User Interface
</li>
<li>LU: Lower-Upper
</li>
<li>OPAM: OCaml Package Manager
</li>
<li>PIP: Pip Installs Python
</li>
<li>PR: Pull Request
</li>
<li>RFC: Request for Comments
</li>
<li>UI: User Interface
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - April 2020|js}
  ; slug = {js|multicore-2020-04|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-04-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the April 2020 update from the Multicore OCaml team, across the UK, India, France and Switzerland! Although most of us are in lockdown, we continue to march forward.  As with <a href="https://discuss.ocaml.org/tag/multicore-monthly">previous updates</a>, thanks to @shakthimaan and @kayceesrk for help assembling it all.</p>
<h3>Preprint: Retrofitting Parallelism onto OCaml</h3>
<p>We've put up a preprint of a paper titled <a href="https://arxiv.org/abs/2004.11663">&quot;Retrofitting Parallelism onto OCaml&quot; </a> for which we would be grateful to receive feedback.  The paper lays out the problem space for the multicore extension of OCaml  and presents the design choices, implementation and evaluation of the  concurrent garbage collector (GC).</p>
<p>Note that this is <em>not a final paper</em> as it is currently under peer review, so any feedback given now can still be incorporated.  Please use the e-mail contact details in the <a href="https://arxiv.org/pdf/2004.11663.pdf">pdf paper</a> for @kayceesrk and myself so we can aggregate (and acknowledge!) any such comments.</p>
<h3>Rebasing Progress</h3>
<p>The Multicore OCaml rebase from 4.06.1 has gained momentum.  We have successfully rebased the parallel-minor-GC all the way onto the <a href="https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc_4_09">4.09 OCaml trees</a>.  We will publish updated opam packages when we get to the recently branched 4.11 in the next couple of weeks.</p>
<p>Rebasing complex features like this is a &quot;slow and steady&quot; process due to the number of intermediate conflicts and bootstrapping, so we will not be publishing opam packages for every intermediate version -- instead, the 4.11 trees will form the new &quot;stable base&quot; for any PRs.</p>
<h3>Higher-level Domainslib API</h3>
<p>A thread from <a href="https://discuss.ocaml.org/t/multicore-ocaml-march-2020-update/5406/8">last month's update</a> on building a parallel raytracer led to some useful advancements in the <a href="https://github.com/ocaml-multicore/domainslib">domainslib</a> library to provide async/await-style task support. See the updates below for more details.</p>
<p>There is also an interesting discussion on <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/324">ocaml-multicore/ocaml-multicore#324</a> about how to go about profiling and optimising your own small programs.  More experiments with parallel algorithms with different scheduling properties would be most useful at this time.</p>
<h3>Upstreamed features in 4.11</h3>
<p>The <a href="https://discuss.ocaml.org/t/ocaml-4-11-release-plan/5600">4.11 release has recently branched</a> and has the following multicore-relevant changes in it:</p>
<ul>
<li>
<p>A concurrency-safe marshalling implementation (originally in <a href="https://github.com/ocaml/ocaml/pull/9293">ocaml#9293</a>, then implemented again in <a href="https://github.com/ocaml/ocaml/pull/9353">ocaml#9353</a>). This will have a slight speed hit to marshalling-heavy programs, so feedback on trying this in your projects with 4.11 will be appreciated to the upstream OCaml issue tracker.</p>
</li>
<li>
<p>A runtime eventlog tracing system using the CTF format is on the verge of being merged in 4.11 over in <a href="https://github.com/ocaml/ocaml/pull/9082">ocaml#9082</a>.  This will also be of interest to those who need sequential program profiling, and is a generalisation of the infrastructure that was essential to our development of the multicore GC.  If anyone is interested in helping with hacking on the OCaml side of CTF support to build clients, please get in touch with me or @kayceesrk.</p>
</li>
</ul>
<p>In addition to the above highlights, we have also been making continuous improvements and additions to the Sandmark benchmarking test infrastructure. The various ongoing and completed tasks are provided below for your reference.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/tree/parallel_minor_gc_4_09">ocaml-multicore/ocaml-multicore</a>
Promote Multicore OCaml to trunk</p>
<p>The rebasing of Multicore OCaml from 4.06 to 4.10 is being worked, and we are now at 4.09! In a few weeks, we expect to complete the rebase to the latest trunk release.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/eventlog-tools">ocaml-multicore/eventlog-tools</a>:
OCaml Eventlog Tools</p>
<p>A project that provides a set of tools for runtime tracing for OCaml 4.11.0 and higher has been created. This includes a simple OCaml decoder for eventlog's trace and a built-in chrome converter tool.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/5">ocaml-multicore/domainslib#5</a>
Add parallel_scan to domainslib</p>
<p>A <a href="https://en.wikipedia.org/wiki/Prefix_sum#Shared_memory:_Two-level_algorithm">parallel_scan</a>  implementation that uses the Task API with prefix_sum and summed_area_table has now been added to the Domain-level Parallel Programming library for Multicore OCaml (domainslib) library.</p>
</li>
</ul>
<h3>Completed</h3>
<p>The following PRs have been merged into Multicore OCaml and its ecosystem projects:</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/328">ocaml-multicore/ocaml-multicore#328</a>
Multicore compiler with Flambda</p>
<p>Support for Flambda has been merged into the Multicore OCaml project repository. The translation is now performed at cmmgen instead of lambda for clambda conversion.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/324">ocaml-multicore/ocaml-multicore#324</a>
Optimizing a Multicore program</p>
<p>The following <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/324#issuecomment-610183856">documentation</a> provides a detailed example on how to do performance debugging for a Multicore program to improve the runtime performance.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/325">ocaml-multicore/ocaml-multicore#325</a>
Added eventlog_to_latencies.py script</p>
<p>A script to generate a latency report from an eventlog has now been  included in the ocaml-multicore repository.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/domainslib/pull/4">ocaml-multicore/domainslib#4</a>
Add support for task_pools</p>
<p>The domainslib library now has support for work-stealing task pools with async/await parallelism. You are encouraged to try the <a href="https://github.com/ocaml-multicore/domainslib/tree/task_pool/test">examples</a>.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<p>A number of new benchmarks are being ported to the <a href="https://github.com/ocaml-bench/sandmark">Sandmark</a> performance benchmarking test suite.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/104">ocaml-bench/sandmark#104</a>
Added python pip3 dependency</p>
<p>A check_dependency function has now been defined in the Makefile along with a list of dependencies and pip packages for Ubuntu. You can now run <code>make depend</code> prior to building the benchmark suite to ensure that you have the required software. The <code>python3-pip</code> package has been added to the list of dependencies.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/96">ocaml-bench/sandmark#96</a>
Sandmark Analyze notebooks</p>
<p>The setup, builds and execution scripts for developer branches on bench2.ocamllabs.io have been migrated to winter.ocamllabs.io.</p>
<p>A UI and automated script driven notebooks for analyzing sequential bench results is being worked upon.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/108">ocaml-bench/sandmark#108</a>
Porting mergesort and matrix multiplication using Task Pool API library</p>
<p>This is an on-going PR to implement merge sort and matrix_multiplication using <code>parallel_for</code>.</p>
</li>
<li>
<p><a href="https://github.com/Sudha247/cubicle/tree/add-multicore">cubicle</a></p>
<p><code>Cubicle</code> is a model checker and an automatic SMT theorem prover. At present, it is being ported to Multicore OCaml, and this is a work in progress.</p>
</li>
<li>
<p><a href="https://github.com/athas/raytracers/pull/6">raytracers</a></p>
<p>Raytracers is a repository that contains ray tracer implementation for different parallel functional programming languages. The OCaml implementation has now been updated to use the new <code>Domainslib.Task</code> API.</p>
<p>Also, a few <a href="https://github.com/kayceesrk/raytracers/blob/flambda/ocaml/myocamlbuild.ml">experiments</a> were performed on flambda parameters for the Multicore raytracer which gives around 25% speedup, but it does not yet remove the boxing of floats. The experiments are to be repeated with a merge against the wip flambda2 trees on 4.11, that removes float boxing.</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9082">ocaml/ocaml#9082</a>
Eventlog tracing system</p>
<p>A substantial number of commits have gone into this PR based on reviews and feedback. These include updates to the configure script, handling warnings and exceptions, adding build support for Windows, removing unused code and coding style changes. This patch will be cherry-picked for the 4.11 release.</p>
</li>
</ul>
<h3>Completed</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9353">ocaml/ocaml#9353</a>
Reimplement <code>output_value</code> using a hash table to detect sharing</p>
<p>This PR which implements a hash table and bit vector as required for Multicore OCaml has been merged to 4.11.</p>
</li>
</ul>
<p>Our thanks as always go to all the OCaml developers and users in the community for their continued support, and contribution to the project!</p>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>GC: Garbage Collector
</li>
<li>PIP: Pip Installs Python
</li>
<li>PR: Pull Request
</li>
<li>SMT: Satisfiability Modulo Theories
</li>
<li>UI: User Interface
</li>
</ul>
|js}
  };
 
  { title = {js|OCaml Multicore - March 2020|js}
  ; slug = {js|multicore-2020-03|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-03-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<h1>Multicore OCaml: March 2020</h1>
<p>Welcome to the March 2020 news update from the Multicore OCaml team!  This update has been assembled with @shakthimaan and @kayceesrk, as with the <a href="https://discuss.ocaml.org/t/multicore-ocaml-feb-2020-update/5227">February</a> and <a href="https://discuss.ocaml.org/t/multicore-ocaml-january-2020-update/5090">January</a> ones.</p>
<p>Our work this month was primarily focused on performance improvements to the Multicore OCaml compiler and runtime, as part of a comprehensive evaluation exercise. We continue to add additional benchmarks to the Sandmark test suite. The eventlog tracing system and the use of hash tables for marshaling in upstream OCaml are in progress, and more PRs are being queued up for OCaml 4.11.0-dev as well.</p>
<p>The biggest observable change for users trying the branch is that a new GC (the &quot;parallel minor gc&quot;) has been merged in preference to the previous one (&quot;the concurrent minor gc&quot;).  We will have the details in longer form at a later stage, but the essential gist is that <strong>the parallel minor GC no longer requires a read barrier or changes to the C API</strong>.  It may have slightly worse scalability properties at a very high number of cores, but is roughly equivalent at up to 24 cores in our evaluations.  Given the vast usability improvement from not having to port existing C FFI uses, we have decided to make the parallel minor GC the default one for our first upstream runtime patches. The concurrent minor GC follow at a later stage when we ramp up testing to 64-core+ machines.  The <a href="https://github.com/ocaml-multicore/multicore-opam">multicore opam remote</a> has been updated to reflect these changes, for those who wish to try it out at home.</p>
<p>We are now at a stage where we are porting larger applications to multicore.  Thanks go to:</p>
<ul>
<li>@UnixJunkie who helped us integrate the Gram Matrix benchmark in https://github.com/ocaml-bench/sandmark/issues/99
</li>
<li>@jhw has done extensive work towards supporting Systhreads in https://github.com/ocaml-multicore/ocaml-multicore/pull/240. Systhreads is currently disabled in multicore, leading to some popular packages not compiling.
</li>
<li>@antron has been advising us on how best to port <code>Lwt_preemptive</code> and the <code>Lwt_unix</code> modules to multicore, giving us a widely used IO stack to test more applications against.
</li>
</ul>
<p>If you do have other suggestions for application that you think might provide useful benchmarks, then please do get in touch with myself or @kayceesrk.</p>
<p>Onto the details! The various ongoing and completed tasks for Multicore OCaml are listed first, which is followed by the changes to the Sandmark benchmarking infrastructure and ongoing PRs to upstream OCaml.</p>
<h2>Multicore OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/240">ocaml-multicore/ocaml-multicore#240</a>
Proposed implementation of threads in terms of Domain and Atomic</p>
<p>A new implementation of the <code>Threads</code> library for use with the new <code>Domain</code> and <code>Atomic</code> modules in Multicore OCaml has been proposed. This builds Dune 2.4.0 which in turn makes it useful to build other packages. This PR is open for review.</p>
</li>
<li>
<p><a href="https://github.com/anmolsahoo25/ocaml-multicore/tree/safepoints-cmm-mach">ocaml-multicore/safepoints-cmm-mach</a>
Better safe points for OCaml</p>
<p>A newer implementation to insert safe points at the Cmm level is being worked upon in this branch.</p>
</li>
</ul>
<h3>Completed</h3>
<p>The following PRs have been merged into Multicore OCaml:</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/303">ocaml-multicore/ocaml-multicore#303</a>
Account correctly for incremental mark budget</p>
<p>The patch correctly measures the incremental mark budget value, and improves the maximum latency for the <code>menhir.ocamly</code> benchmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/307">ocaml-multicore/ocaml-multicore#307</a>
Put the phase change event in the actual phase change code. The PR includes the <code>major_gc/phase_change</code> event in the appropriate context.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/309">ocaml-multicore/ocaml-multicore#309</a>
Don't take all the full pools in one go.</p>
<p>The code change selects one of the <code>global_full_pools</code> to try sweeping it later, instead of adopting all of the full ones.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/310">ocaml-multicore/ocaml-multicore#310</a>
Statistics for the current domain are more recent than other domains</p>
<p>The statistics (<code>minor_words</code>, <code>promoted_words</code>, <code>major_words</code>, <code>minor_collections</code>) for the current domain are more recent, and are used in the right context.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/315">ocaml-multicore/ocaml-multicore#315</a>
Writes in <code>caml_blit_fields</code> should always use <code>caml_modify_field</code> to record <code>young_to_young</code> pointers</p>
<p>The PR enforces that <code>caml_modify_field()</code> is always used to store <code>young_to_young</code> pointers.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/316">ocaml-multicore/ocaml-multicore#316</a>
Fix bug with <code>Weak.blit</code>.</p>
<p>The ephemerons are allocated as marked, but, the keys or data can be unmarked. The blit operations copy weak references from one ephemeron to another without marking them. The patch marks the keys that are blitted in order to keep the unreachable keys alive for another major cycle.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/317">ocaml-multicore/ocaml-multicore#317</a>
Return early for 0 length blit</p>
<p>The PR forces a <code>CAMLreturn()</code> call if the blit length is zero in <code>byterun/weak.c</code>.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/320">ocaml-multicore/ocaml-multicore#320</a>
Move <code>num_domains_running</code> decrement</p>
<p>The <code>caml_domain_alone()</code> invocation needs to be used in the shared heap teardown, and hence the <code>num_domains_running</code> decrement is moved as the last operation for at least the <code>shared_heap</code> lockfree fast paths.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<p>The <a href="https://github.com/ocaml-bench/sandmark">Sandmark</a> performance benchmarking test suite has had newer benchmarks added, and work is underway to enhance its functionality.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/88">ocaml-bench/sandmark#88</a>
Add PingPong Multicore benchmark</p>
<p>The PingPong benchmark that uses producer and consumer queues has now been included into Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/98">ocaml-bench/sandmark#98</a>
Add the read/write Irmin benchmark</p>
<p>A basic read/write file performance benchmark for Irmin has been added to Sandmark. You can vary the following input parameters: number of branches, number of keys, percentage of reads and writes, number of iterations, and the number of write operations.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/100">ocaml-bench/sandmark#100</a>
Add Gram Matrix benchmark</p>
<p>A request
<a href="https://github.com/ocaml-bench/sandmark/issues/99">ocaml-bench/sandmark#99</a> to include the Gram Matrix initialization numerical benchmark was created. This is useful for machine learning applications and is now available in the Sandmark performance benchmark suite. The speedup (sequential_time/multi_threaded_time) versus number of cores for Multicore (Concurrent Minor Collector), Parmap and Parany is quite significant and illustrated in the graph:</p>
</li>
</ul>
<p><img src="upload://4GHKI2C3Au8iHUwZqGwpiR42Ori.png" alt="Gram matrix speedup benchmark" /></p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/103">ocaml-bench/sandmark#103</a>
Add depend target in Makefile</p>
<p>Sandmark now includes a <code>depend</code> target defined in the Makefile to check that both <code>libgmp-dev</code> and <code>libdw-dev</code> packages are installed and available on Ubuntu.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/issues/90">ocaml-bench/sandmark#90</a>
More parallel benchmarks</p>
<p>An issue has been created to add more parallel benchmarks. We will use this to keep track of the requests. Please feel free to add your wish list of benchmarks!</p>
</li>
</ul>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9082">ocaml/ocaml#9082</a> Eventlog tracing system</p>
<p>The configure script has now been be updated so that it can build on Windows. Apart from this major change, a number of minor commits have been made for the build and sanity checks. This PR is currently under review.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9353">ocaml/ocaml#9353</a>
Reimplement output_value using a hash table to detect sharing.</p>
<p>The <a href="https://github.com/ocaml/ocaml/pull/9293">ocaml/ocaml#9293</a> &quot;Use addrmap hash table for marshaling&quot; PR has been re-implemented using a hash table and bit vector, thanks to @xavierleroy. This is a pre-requisite for Multicore OCaml that uses a concurrent garbage collector.</p>
</li>
</ul>
<p>As always, we thank the OCaml developers and users in the community for their code reviews, support, and contribution to the project. From OCaml Labs, stay safe and healthy out there!</p>
|js}
  };
 
  { title = {js|OCaml Multicore - February 2020|js}
  ; slug = {js|multicore-2020-02|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-02-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the February 2020 news update from the Multicore OCaml team, spread across the UK, India, France and Switzerland! This follows on from <a href="https://discuss.ocaml.org/t/multicore-ocaml-january-2020-update/5090">last month's</a> update, and has been put together by @shakthimaan and @kayceesrk.</p>
<p>The <a href="https://discuss.ocaml.org/t/ocaml-4-10-released/5194">release of OCaml 4.10.0</a> has successfully pushed out some prerequisite features into the upstream compiler.  Our work in February has focussed on getting the multicore OCaml branch &quot;feature complete&quot; with respect to the complete OCaml language, and doing extensive benchmarking and stress testing to test our two minor heap implementations.</p>
<p>To this end, a number of significant patches have been merged into the <a href="https://github.com/ocaml-multicore/ocaml-multicore">Multicore OCaml trees</a> that essentially provide complete coverage of the language features. We encourage you to test the same for regressions and provide any improvements or report shortcomings to us. There are ongoing OCaml PRs and issues that are also under review, and we hope to complete those for the 4.11 release cycle. A new set of parallel benchmarks have been added to our <a href="https://github.com/ocaml-bench/sandmark">Sandmark benchmarking suite</a> (live instance <a href="http://bench2.ocamllabs.io">here</a>), including enhancements to the build setup.</p>
<h2>Multicore OCaml</h2>
<h3>Completed</h3>
<p>The following PRs have been merged into Multicore OCaml:</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/281">ocaml-multicore/ocaml-multicore#281</a>
Introduce <code>Forcing_tag</code> to fix concurrency bug with lazy values</p>
<p>A <code>Forcing_tag</code> is used to implement lazy values to handle a concurrency bug. It behaves like a locked bit, and any concurrent access by a mutator will raise an exception on that domain.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/282">ocaml-multicore/ocaml-multicore#282</a>
Safepoints</p>
<p>A preliminary version of safe points has been merged into the Multicore OCaml trees. <a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/187">ocaml-multicore/ocaml-multicore#187</a> also contains more discussion and background about how coverage can be improved in future PRs.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/285">ocaml-multicore/ocaml-multicore#285</a>
Introduce an 'opportunistic' major collection slice</p>
<p>An &quot;opportunistic work credit&quot; is implemented in this PR which forms a basis for doing mark and sweep work while waiting to synchronise with other domains.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/286">ocaml-multicore/ocaml-multicore#286</a>
Do fflush and variable args in caml_gc_log</p>
<p>The caml_gc_log() function has been updated to ensure that <code>fflush</code> is invoked only when GC logging is enabled.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/287">ocaml-multicore/ocaml-multicore#287</a>
Increase EVENT_BUF_SIZE</p>
<p>During debugging with event trace data it is useful to reduce the buffer flush times, and hence the <code>EVENT_BUF_SIZE</code> has now been increased.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/288">ocaml-multicore/ocaml-multicore#288</a>
Write barrier optimization</p>
<p>This PR closes the regression for the <code>chameneos_redux_lwt</code> benchmarking in Sandmark by using <code>intnat</code> to avoid sign extensions and cleans up <code>write_barrier</code> to improve overall performance.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/290">ocaml-multicore/ocaml-multicore#290</a>
Unify sweep budget to be in word size</p>
<p>The PR updates the sweep work units to all be in word size. This is to handle the differences between the budget for setup, sweep and for large allocations in blocks.</p>
</li>
</ul>
<h3>Ongoing</h3>
<ul>
<li>A lot of work is ongoing for the implementation of a synchronised minor garbage collector for Multicore OCaml, including benchmarking for the stop-the-world (stw) branch.  We will publish the results of this in a future update, as we are assembling a currently comprehensive evaluation of the runtime against the mainstream runtime.
</li>
</ul>
<h2>Benchmarking</h2>
<p><a href="http://bench2.ocamllabs.io/">Sandmark</a> now has support to run parallel benchmarks. We can also now about GC latency measurements for both stock OCaml and Multicore OCaml compiler.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/73">ocaml-bench/sandmark#73</a>
More parallel benchmarks</p>
<p>A number of parallel benchmarks such as N-body, Quick Sort and matrix multiplication have now been added to Sandmark!</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/76">ocaml-bench/sandmark#76</a>
Promote packages. Unbreak CI.</p>
<p>The Continuous Integration build can now execute after updating and promoting packages in Sandmark.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/78">ocaml-bench/sandmark#78</a>
Add support for collecting information about GC pausetimes on trunk</p>
<p>The PR now helps process the runtime log and produces a <code>.bench</code> file that captures the GC pause times. This works on both stock OCaml and in Multicore OCaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-bench/sandmark/pull/86">ocaml-bench/sandmark#86</a>
Read and write Irmin benchmark</p>
<p>A test for measuring Irmin's merge capabilities with Git as its filesystem is being tested with different read and write rates.</p>
</li>
<li>
<p>A number of other parallel benchmarks like Merge sort, Floyd-Warshall matrix, prime number generation, parallel map, filter et. al. have been added to Sandmark.</p>
</li>
</ul>
<h2>Documentation</h2>
<ul>
<li>Examples using domainslib and modifying Domains are currently being worked upon for a chapter on Parallel Programming for Multicore OCaml. We will release an early draft to the community for your feedback.
</li>
</ul>
<h2>OCaml</h2>
<p>One PR opened to OCaml this month, which fixes up the marshalling scheme to be multicore compatible. The complete set of <a href="https://github.com/ocaml/ocaml/labels/multicore-prerequisite">upstream multicore prerequisites</a> are labelled in the compiler issue tracker.</p>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9293">ocaml/ocaml#9293</a> Use addrmap hash table for marshaling</p>
<p>The hash table (addrmap) implementation from Multicore OCaml has been ported to upstream OCaml to avoid using GC mark bits to represent visitedness.</p>
</li>
</ul>
<h2>Acronyms</h2>
<ul>
<li>CTF: Common Trace Format
</li>
<li>CI: Continuous Integration
</li>
<li>GC: Garbage Collector
</li>
<li>PR: Pull Request
</li>
</ul>
<p>As always, many thanks to our fellow OCaml developers and users who have reviewed our code, reported bugs or otherwise assisted this month.</p>
|js}
  };
 
  { title = {js|OCaml Multicore - January 2020|js}
  ; slug = {js|multicore-2020-01|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2020-01-01|js}
  ; tags = 
 [{js|multicore|js}]
  ; body_html = {js|<p>Welcome to the January 2020 news update from the Multicore OCaml team! We're going to summarise our activites monthly to highlight what we're working on throughout this year. This update has kindly been assembled by @shakthimaan and @kayceesrk.</p>
<p>The most common question we get is how to contribute to the overall multicore effort. As I <a href="https://discuss.ocaml.org/t/multicore-prerequisite-patches-appearing-in-released-ocaml-compilers-now/4408">noted last year</a>, we are now in the process of steadily upstreaming our efforts to mainline OCaml. Therefore, the best way by far to contribute is to test for regressions or opportunities for improvements in the patches that are outstanding in the main OCaml repository.</p>
<p>A secondary benefit would be to review the PRs in the <a href="https://github.com/ocaml-multicore/ocaml-multicore/pulls">multicore repository</a>, but those tend to be more difficult to evaluate externally as they are being spotted as a result of stress testing at the moment.  A negative contribution would be to raise discussion of orthogonal features or new project management mechanisms -- this takes time and effort to reply to, and the team has a very full plate already now that the upstreaming has begun. We don't want to prevent those discussions from happening of course, but would appreciate if they were directed to the general OCaml bugtracker or another thread on this forum.</p>
<p>We'll first go over the OCaml PRs and issues, then cover the multicore repository and our Sandmark benchmarking infrastructure.  A new initiative to implement and test new parallel algorithms for Multicore OCaml is also underway.</p>
<h2>OCaml</h2>
<h3>Ongoing</h3>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9082">ocaml/ocaml#9082</a> Eventlog tracing system</p>
<p>Eventlog is a proposal for a new tracing facility for OCaml runtime that provides metrics and counters, and uses the Binary Trace Format (CTF). The next step to get this merged is to incubate the tracing features in separate runtime variant, so it can be selected at application link time.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8984">ocaml/ocaml#8984</a> Towards a new closure representation</p>
<p>A new layout for closures has been proposed for traversal by the  garbage collector without the use of a page table. This is very much useful for Multicore OCaml and for performance improvements. The PR is awaiting review from other developers, and can then be rebased against trunk for testing and merge.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/issues/187">ocaml-multicore/ocaml-multicore#187</a> Better Safe Points</p>
<p>A patch to regularly poll for inter-domain interrupts to provide better safe points is actively being reviewed. This is to ensure that any pending interrupts are notified by the runtime system.</p>
</li>
<li>
<p>Work is underway on improving the marshaling (runtime/extern.c) in upstream OCaml to avoid using GC mark bits to represent visitedness, and to use a hash table (addrmap) implementation.</p>
</li>
</ul>
<h3>Completed</h3>
<p>The following PRs have been merged to upstream OCaml trunk:</p>
<ul>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/8713">ocaml/ocaml#8713</a> Move C global variables to a dedicated structure</p>
<p>This PR moves the C global variables to a &quot;domain state&quot; table. Every domain requires its own table of domain local variables, and hence this is required for Multicore runtime.</p>
<p>This uncovered a number of <a href="https://github.com/ocaml/ocaml/issues/9205">compatability issues</a> with the C header files, which were all included in the recent OCaml 4.10.0+beta2 release via the next item.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml/pull/9253">ocaml/ocaml#9253</a> Move back <code>caml_*</code> to thematic headers</p>
<p>The <code>caml_*</code> definitions from runtime/caml/compatibility.h have been moved to provide a compatible API for OCaml versions 4.04 to 4.10. This change is also useful for Multicore domains that have their own state.</p>
</li>
</ul>
<h2>Multicore OCaml</h2>
<p>The following PRs have been merged into the Multicore OCaml trees:</p>
<ul>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/275">ocaml-multicore/ocaml-multicore#275</a>
Fix lazy behaviour for Multicore</p>
<p>A <code>caml_obj_forward_lazy()</code> function is implemented to handle lazy values in Multicore Ocaml.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/269">ocaml-multicore/ocaml-multicore#269</a>
Move from a global <code>pools_to_rescan</code> to a domain-local one</p>
<p>During stress testing, a segmentation fault occurred when a pool was  being rescanned while a domain was allocating in to it. The rescan has now been moved to the domain local, and hence this situation will not occur again.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/268">ocaml-multicore/ocaml-multicore#268</a>
Fix for a few space leaks</p>
<p>The space leaks that occurred during domain spawning and termination when performing the stress tests have been fixed in this PR.</p>
</li>
<li>
<p><a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/272">ocaml-multicore/ocaml-multicore#272</a>
Fix for DWARF CFI for non-allocating external calls</p>
<p>The entry to <code>caml_classify_float_unboxed</code> caused a corrupted backtrace, and a fix that clearly specifies the boundary between OCaml and C has been provided.</p>
</li>
<li>
<p>An effort to implement a synchronized minor garbage collector for Multicore OCaml is actively being researched and worked upon. Benchmarking for a work-sharing parallel stop-the-world branch against multicore trunk has been performed along with clearing technical debt, handling race conditions, and fixing segmentation faults. The C-API reversion changes have been tested and merged into the stop-the-world minor GC branch for Multicore OCaml.</p>
</li>
</ul>
<h2>Benchmarking</h2>
<ul>
<li>
<p>The <a href="http://bench2.ocamllabs.io/">Sandmark</a> performance benchmarking infrastructure has been improved for backfilling data, tracking branches and naming benchmarks.</p>
</li>
<li>
<p>Numerical parallel benchmarks have been added to the Multicore compiler.</p>
</li>
<li>
<p>An <a href="https://irmin.org">Irmin</a> macro benchmark has been included in Sandmark. A test for measuring Irmin's merge capabilities with Git as its filesystem is being tested with different read and write rates.</p>
</li>
<li>
<p>Work is also underway to implement parallel algorithms for N-body, reverse-complement, k-nucleotide, binary-trees, fasta, fannkuch-redux, regex-redux, Game of Life, RayTracing, Barnes Hut, Count Graphs, SSSP and from the MultiMLton benchmarks to test on Multicore OCaml.</p>
</li>
</ul>
<h2>Documentation</h2>
<ul>
<li>A chapter on Parallel Programming in Multicore OCaml is being written and an early draft will be made available to the community for their feedback. It is based on Domains, with examples to implement array sums, Pi approximation, and trapezoidal rules for definite integrals.
</li>
</ul>
<h2>Acronyms</h2>
<ul>
<li>API: Application Programming Interface
</li>
<li>CTF: Common Trace Format
</li>
<li>CFI: Call Frame Information
</li>
<li>DWARF: Debugging With Attributed Record Formats
</li>
<li>GC: Garbage Collector
</li>
<li>PR: Pull Request
</li>
<li>SSSP: Single Source Shortest Path
</li>
</ul>
|js}
  }]

