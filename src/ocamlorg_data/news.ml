
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
 
  { title = {js|opam releases: 2.0.10, 2.1.1, & opam depext 1.2!|js}
  ; slug = {js|opam-2-0-10-2-1-1-depext|js}
  ; description = {js|???|js}
  ; date = {js|2021-11-15|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-1-opam-2-0-10-opam-depext-1-2/8872">Discuss</a>!</em></p>
<p>We are pleased to announce several minor releases: <a href="https://github.com/ocaml/opam/releases/tag/2.0.10">opam 2.0.10</a>, <a href="https://github.com/ocaml/opam/releases/tag/2.1.1">opam 2.1.1</a>, and <a href="https://github.com/ocaml-opam/opam-depext/releases/tag/1.2">opam-depext 1.2</a>.</p>
<p>The opam releases consist of backported fixes, while <code>opam-depext</code> has been adapted to be compatible with opam 2.1, to allow for workflows which need to maintain compatibility with opam 2.0. With opam 2.1.1, if you export <code>OPAMCLI=2.0</code> into your environment then workflows expecting opam 2.0 should now behave even more equivalently.</p>
<h2>opam-depext 1.2</h2>
<p>Previous versions of opam-depext were made unavailable when using opam 2.1, since depext handling is done directly by opam 2.1 and later. This is still the recommended way, but this left workflows which wanted to maintain compatibility with opam 2.0 without a single command to install depexts. You can now run <code>OPAMCLI=2.0 opam depext -y package1 package2</code> and expect this to work correctly with any version of opam 2. If you don't specify <code>OPAMCLI=2.0</code> then the plugin will remind you that you should be using the integrated depext support! Calling <code>opam depext</code> this way with opam 2.1 and later still exposes the same double-solving problem that opam 2.0 has, but if for some reason the solver returns a different solution at <code>opam install</code> then the correct depexts would be installed.</p>
<p>For opam 2.0, some useful depext handling changes are back-ported from opam 2.1.x to the plugin:
With opam 2.0:</p>
<ul>
<li>yum-based distributions: force not to upgrade (<a href="https://github.com/ocaml-opam/opam-depext/pull/137">#137</a>)
</li>
<li>Archlinux: always upgrade all the installed packages when installing a new package (<a href="https://github.com/ocaml-opam/opam-depext/pull/138">#138</a>)
</li>
</ul>
<h2><a href="https://github.com/ocaml/opam/blob/2.1.1/CHANGES">opam 2.1.1</a></h2>
<p>opam 2.1.1 includes both the fixes in opam 2.0.10.</p>
<p>General fixes:</p>
<ul>
<li>Restore support for switch creation with &quot;positional&quot; package arguments and <code>--packages</code> option for CLI version 2.0, e.g. <code>OPAMCLI=2.0 opam switch create . 4.12.0+options --packages=ocaml-option-flambda</code>. In opam 2.1 and later, this syntax remains an error (<a href="https://github.com/ocaml/opam/issues/4843">#4843</a>)
</li>
<li>Fix <code>opam switch set-invariant</code>: default repositories were loaded instead of the switch's repositories selection (<a href="https://github.com/ocaml/opam/pull/4869">#4869</a>)
</li>
<li>Run the sandbox check in a temporary directory (<a href="https://github.com/ocaml/opam/issues/4783">#4783</a>)
</li>
</ul>
<p>Integrated depext support has a few updates:</p>
<ul>
<li>Homebrew now has support for casks and full-names (<a href="https://github.com/ocaml/opam/issues/4800">#4800</a>)
</li>
<li>Archlinux now handles virtual package detection (<a href="https://github.com/ocaml/opam/pull/4833">#4833</a>, partially addressing <a href="https://github.com/ocaml/opam/issues/4759">#4759</a>)
</li>
<li>Disable the detection of available packages on RHEL-based distributions.
This fixes an issue on RHEL-based distributions where yum list used to detect
available and installed packages would wait for user input without showing
any output and/or fail in some cases (<a href="https://github.com/ocaml/opam/pull/4791">#4791</a>)
</li>
</ul>
<p>And finally two regressions have been dealt with:</p>
<ul>
<li>Regression: avoid calling <code>Unix.environment</code> on load (as a toplevel expression). This regression affected opam's libraries, rather than the binary itself (<a href="https://github.com/ocaml/opam/pull/4789">#4789</a>)
</li>
<li>Regression: handle empty environment variable updates (<a href="https://github.com/ocaml/opam/pull/4840">#4840</a>)
</li>
</ul>
<p>A few issues with the compilation of opam from sources have been fixed as well (e.g. mingw-w64 with g++ 11.2 now works)</p>
<h2><a href="https://github.com/ocaml/opam/blob/2.0.10/CHANGES">opam 2.0.10</a></h2>
<p>Two subtle fixes are included in opam 2.0.10. These actually affect the <code>ocaml</code> package. Both of these are Heisenbugs - investigating what's going wrong on your system may well have fixed them, they were both found on Windows!</p>
<p><code>$(opam env --revert)</code> is the reverse of the more familiar <code>$(opam env)</code> but it's effectively called by opam whenever you change switch. It has been wrong since 2.0.0 for the case where several values are added to an environment variable in one <code>setenv</code> update. For example, if a package included a <code>setenv</code> field of the form <code>[PATH += &quot;dir1:dir2&quot;]</code>, then this would not be reverted, but <code>[[PATH += &quot;dir1&quot;] [PATH += &quot;dir2&quot;]]</code> would be reverted. As it happens, this bug affects the <code>ocaml</code> package, but it was masked by another <code>setenv</code> update in the same package.</p>
<p>The other fix is also to do with <code>setenv</code>. It can be seen immediately after creating a switch but before any additional packages are installed, as this <code>Dockerfile</code> shows:</p>
<pre><code>FROM ocaml/opam@sha256:244b948376767fe91e2cd5caca3b422b2f8d332f105ef2c8e14fcc9a20b66e25
RUN sudo apt-get install -y ocaml-nox
RUN opam --version
RUN opam switch create show-issue ocaml-system
RUN eval $(opam env) ; echo $CAML_LD_LIBRARY_PATH
RUN opam install conf-which
RUN eval $(opam env) ; echo $CAML_LD_LIBRARY_PATH
</code></pre>
<p>Immediately after switch creation, <code>$CAML_LD_LIBRARY_PATH</code> was set to <code>/home/opam/.opam/show-issue/lib/stublibs:</code>, rather than <code>/home/opam/.opam/show-issue/lib/stublibs:/usr/local/lib/ocaml/4.08.1/stublibs:/usr/lib/ocaml/stublibs</code></p>
<hr />
<p>Opam installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.1&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.1">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.1#compiling-this-repo">README</a>.</p>
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
 
  { title = {js|opam 2.1.0 is released!|js}
  ; slug = {js|opam-2-1-0|js}
  ; description = {js|???|js}
  ; date = {js|2021-08-04|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0/8255">Discuss</a>!</em></p>
<p>We are happy to announce the release of opam 2.1.0.</p>
<p>Many new features made it in (see the <a href="https://github.com/ocaml/opam/blob/2.1.0/CHANGES">pre-release
changelogs</a> or <a href="https://github.com/ocaml/opam/releases">release
notes</a> for the details),
but here are a few highlights.</p>
<h2>What's new in opam 2.1?</h2>
<ul>
<li>Integration of system dependencies (formerly the opam-depext plugin),
increasing their reliability as it integrates the solving step
</li>
<li>Creation of lock files for reproducible installations (formerly the opam-lock
plugin)
</li>
<li>Switch invariants, replacing the &quot;base packages&quot; in opam 2.0 and allowing for
easier compiler upgrades
</li>
<li>Improved options configuration (see the new <code>option</code> and expanded <code>var</code> sub-commands)
</li>
<li>CLI versioning, allowing cleaner deprecations for opam now and also
improvements to semantics in future without breaking backwards-compatibility
</li>
<li>opam root readability by newer and older versions, even if the format changed
</li>
<li>Performance improvements to opam-update, conflict messages, and many other
areas
</li>
</ul>
<h3>Seamless integration of System dependencies handling (a.k.a. &quot;depexts&quot;)</h3>
<p>opam has long included the ability to install system dependencies automatically
via the <a href="https://github.com/ocaml-opam/opam-depext">depext plugin</a>. This plugin
has been promoted to a native feature of opam 2.1.0 onwards, giving the
following benefits:</p>
<ul>
<li>You no longer have to remember to run <code>opam depext</code>, opam always checks
depexts (there are options to disable this or automate it for CI use).
Installation of an opam package in a CI system is now as easy as <code>opam install .</code>, without having to do the dance of <code>opam pin add -n/depext/install</code>. Just
one command now for the common case!
</li>
<li>The solver is only called once, which both saves time and also stabilises the
behaviour of opam in cases where the solver result is not stable. It was
possible to get one package solution for the <code>opam depext</code> stage and a
different solution for the <code>opam install</code> stage, resulting in some depexts
missing.
</li>
<li>opam now has full knowledge of depexts, which means that packages can be
automatically selected based on whether a system package is already installed.
For example, if you have <em>neither</em> MariaDB nor MySQL dev libraries installed,
<code>opam install mysql</code> will offer to install <code>conf-mysql</code> and <code>mysql</code>, but if you
have the MariaDB dev libraries installed, opam will offer to install
<code>conf-mariadb</code> and <code>mysql</code>.
</li>
</ul>
<p><em>Hint: You can set <code>OPAMCONFIRMLEVEL=unsafe-yes</code> or
<code>--confirm-level=unsafe-yes</code> to launch non interactive system package commands.</em></p>
<h3>opam lock files and reproducibility</h3>
<p>When opam was first released, it had the mission of gathering together
scattered OCaml source code to build a <a href="https://github.com/ocaml/opam-repository">community
repository</a>. As time marches on, the
size of the opam repository has grown tremendously, to over 3000 unique
packages with over 19500 unique versions. opam looks at all these packages and
is designed to solve for the best constraints for a given package, so that your
project can keep up with releases of your dependencies.</p>
<p>While this works well for libraries, we need a different strategy for projects
that need to test and ship using a fixed set of dependencies. To satisfy this
use-case, opam 2.0.0 shipped with support for <em>using</em> <code>project.opam.locked</code>
files. These are normal opam files but with exact versions of dependencies. The
lock file can be used as simply as <code>opam install . --locked</code> to have a
reproducible package installation.</p>
<p>With opam 2.1.0, the creation of lock files is also now integrated into the
client:</p>
<ul>
<li><code>opam lock</code> will create a <code>.locked</code> file for your current switch and project,
that you can check into the repository.
</li>
<li><code>opam switch create . --locked</code> can be used by users to reproduce your
dependencies in a fresh switch.
</li>
</ul>
<p>This lets a project simultaneously keep up with the latest dependencies
(without lock files) while providing a stricter set for projects that need it
(with lock files).</p>
<p><em>Hint: You can export the full configuration of a switch with <code>opam switch export</code> new options, <code>--full</code> to have all packages metadata included, and
<code>--freeze</code> to freeze all VCS to their current commit.</em></p>
<h3>Switch invariants</h3>
<p>In opam 2.0, when a switch is created the packages selected are put into the
“base” of the switch. These packages are not normally considered for upgrade,
in order to ease pressure on opam's solver. This was a much bigger concern
early on in opam 2.0's development, but is less of a problem with the default
mccs solver.</p>
<p>However, it's a problem for system compilers. opam would detect that your
system compiler version had changed, but be unable to upgrade the ocaml-system
package unless you went through a slightly convoluted process with
<code>--unlock-base</code>.</p>
<p>In opam 2.1, base packages have been replaced by switch invariants. The switch
invariant is a package formula which must be satisfied on every upgrade and
install. All existing switches' base packages could just be expressed as
<code>package1 &amp; package2 &amp; package3</code> etc. but opam 2.1 recognises many existing
patterns and simplifies them, so in most cases the invariant will be
<code>&quot;ocaml-base-compiler&quot; {= &quot;4.11.1&quot;}</code>, etc. This means that <code>opam switch create my_switch ocaml-system</code> now creates a <em>switch invariant</em> of <code>&quot;ocaml-system&quot;</code>
rather than a specific version of the <code>ocaml-system</code> package. If your system
OCaml package is updated, <code>opam upgrade</code> will seamlessly switch to the new
package.</p>
<p>This also allows you to have switches which automatically install new point
releases of OCaml. For example:</p>
<pre><code>opam switch create ocaml-4.11 --formula='&quot;ocaml-base-compiler&quot; {&gt;= &quot;4.11.0&quot; &amp; &lt; &quot;4.12.0~&quot;}' --repos=old=git+https://github.com/ocaml/opam-repository#a11299d81591
opam install utop
</code></pre>
<p>Creates a switch with OCaml 4.11.0 (the <code>--repos=</code> was just to select a version
of opam-repository from before 4.11.1 was released). Now issue:</p>
<pre><code>opam repo set-url old git+https://github.com/ocaml/opam-repository
opam upgrade
</code></pre>
<p>and opam 2.1 will automatically offer to upgrade OCaml 4.11.1 along with a
rebuild of the switch. There's not yet a clean CLI for specifying the formula,
but we intend to iterate further on this with future opam releases so that
there is an easier way of saying “install OCaml 4.11.x”.</p>
<p><em>Hint: You can set up a default invariant that will apply for all new switches,
via a specific <code>opamrc</code>. The default one is <code>ocaml &gt;= 4.05.0</code></em></p>
<h3>Configuring opam from the command-line</h3>
<p>Configuring opam is not a simple task: you need to use an <code>opamrc</code> at init
stage, or hack global/switch config file, or use <code>opam config var</code> for
additional variables. To ease that step, and permit a more consistent opam
config tweaking, a new command was added : <code>opam option</code>.</p>
<!--
The new `opam option` command allows to configure several options,
without requiring manual edition of the configuration files.
-->
<p>For example:</p>
<ul>
<li><code>opam option download-jobs</code> gives the global <code>download-jobs</code> value (as it
exists only in global configuration)
</li>
<li><code>opam option jobs=6 --global</code> will set the number of parallel build
jobs opam is allowed to run (along with the associated <code>jobs</code> variable)
</li>
<li><code>opam option depext-run-commands=false</code> disables the use of <code>sudo</code> for
handling system dependencies; it will be replaced by a prompt to run the
installation commands
</li>
<li><code>opam option depext-bypass=m4 --global</code> bypass <code>m4</code> system package check
globally, while <code>opam option depext-bypass=m4 --switch myswitch</code> will only
bypass it in the selected switch
</li>
</ul>
<p>The command <code>opam var</code> is extended with the same format, acting on switch and
global variables.</p>
<p><em>Hint: to revert your changes use <code>opam option &lt;field&gt;=</code>, it will take its
default value.</em></p>
<h3>CLI Versioning</h3>
<p>A new <code>--cli</code> switch was added to the first beta release, but it's only now
that it's being widely used. opam is a complex enough system that sometimes bug
fixes need to change the semantics of some commands. For example:</p>
<ul>
<li><code>opam show --file</code> needed to change behaviour
</li>
<li>The addition of new controls for setting global variables means that the
<code>opam config</code> was becoming cluttered and some things want to move to <code>opam var</code>
</li>
<li><code>opam switch install 4.11.1</code> still works in opam 2.0, but it's really an OPAM
1.2.2 syntax.
</li>
</ul>
<p>Changing the CLI is exceptionally painful since it can break scripts and tools
which themselves need to drive <code>opam</code>. CLI versioning is our attempt to solve
this. The feature is inspired by the <code>(lang dune ...)</code> stanza in <code>dune-project</code>
files which has allowed the Dune project to rename variables and alter
semantics without requiring every single package using Dune to upgrade their
<code>dune</code> files on each release.</p>
<p>Now you can specify which version of opam you expected the command to be run
against. In day-to-day use of opam at the terminal, you wouldn't specify it,
and you'll get the latest version of the CLI. For example: <code>opam var --global</code>
is the same as <code>opam var --cli=2.1 --global</code>. However, if you issue <code>opam var --cli=2.0 --global</code>, you will told that <code>--global</code> was added in 2.1 and so is
not available to you. You can see similar things with the renaming of <code>opam upgrade --unlock-base</code> to <code>opam upgrade --update-invariant</code>.</p>
<p>The intention is that <code>--cli</code> should be used in scripts, user guides (e.g. blog
posts), and in software which calls opam. The only decision you have to take is
the <em>oldest</em> version of opam which you need to support. If your script is using
a new opam 2.1 feature (for example <code>opam switch create --formula=</code>) then you
simply don't support opam 2.0. If you need to support opam 2.0, then you can't
use <code>--formula</code> and should use <code>--packages</code> instead. opam 2.0 does not have the
<code>--cli</code> option, so for opam 2.0 instead of <code>--cli=2.0</code> you should set the
environment variable <code>OPAMCLI</code> to <code>2.0</code>. As with <em>all</em> opam command line
switches, <code>OPAMCLI</code> is simply the equivalent of <code>--cli</code> which opam 2.1 will
pick-up but opam 2.0 will quietly ignore (and, as with other options, the
command line takes precedence over the environment).</p>
<p>Note that opam 2.1 sets <code>OPAMCLI=2.0</code> when building packages, so on the rare
instances where you need to use the <code>opam</code> command in a <em>package</em> <code>build:</code>
command (or in your build system), you <em>must</em> specify <code>--cli=2.1</code> if you're
using new features.</p>
<p>Since 2.1.0~rc2, CLI versioning applies to opam environment variables. The
previous behavior was to ignore unknown or wrongly set environment variable,
while now you will have a warning to let you know that the environment variable
won't be handled by this version of opam.</p>
<p>To ensure not breaking compatibility of some widely used deprecated options,
a <em>default</em> CLI is introduced: when no CLI is specified, those deprecated
options are accepted. It concerns <code>opam exec</code> and <code>opam var</code> subcommands.</p>
<p>There's even more detail on this feature <a href="https://github.com/ocaml/opam/wiki/Spec-for-opam-CLI-versioning">in our
wiki</a>. We're
hoping that this feature will make it much easier in future releases for opam
to make required changes and improvements to the CLI without breaking existing
set-ups and tools.</p>
<p><em>Note: For opam libraries users, since 2.1 environment variable are no more
loaded by the libraries, only by opam client. You need to load them explicitly.</em></p>
<h3>opam root portability</h3>
<p>opam root format changes during opam life-cycle, new field are added or
removed, new files are added ; an older opam version sometimes can no longer
read an upgraded or newly created opam root. opam root format has been updated
to allow new versions of opam to indicate that the root may still be read by
older versions of the opam libraries. A plugin compiled against the 2.0.9 opam
libraries will therefore be able to read information about an opam 2.1 root
(plugins and tools compiled against 2.0.8 are unable to load opam 2.1.0 roots).
It is a <em>read-only</em> best effort access, any attempt to modify the opam root
fails.</p>
<p><em>Hint: for opam libraries users, you can safely load states with
<a href="https://github.com/ocaml/opam/blob/master/src/state/opamStateConfig.mli"><code>OpamStateConfig</code></a>
load functions.</em></p>
<!--
_ change to the opam root format which allows new versions of opam to indicate
that the root may still be read by older versions of the opam libraries. A
plugin compiled against the 2.0.9 opam libraries will therefore be able to read
information about an opam 2.1 root (plugins and tools compiled against 2.0.8
are unable to load opam 2.1.0 roots). _
-->
<p><strong>Tremendous thanks to all involved people, who've developed, tested &amp; retested,
helped with issue reports, comments, feedback...</strong></p>
<h1>Try it!</h1>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>
<p>Either from binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.0&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0">the Github &quot;Releases&quot; page</a> to your PATH.</p>
</li>
<li>
<p>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>You should then run:</p>
<pre><code>opam init --reinit -ni
</code></pre>
|js}
  };
 
  { title = {js|opam 2.0.9 release|js}
  ; slug = {js|opam-2-0-9|js}
  ; description = {js|???|js}
  ; date = {js|2021-08-03|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0/8255">Discuss</a>!</em></p>
<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.9">opam 2.0.9</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/4547">back-ported</a> fixes.</p>
<h2>New features</h2>
<ul>
<li>Back-ported ability to load upgraded roots read-only; allows applications compiled with opam-state 2.0.9 to load a root which has been upgraded to opam 2.1 [<a href="https://github.com/ocaml/opam/issues/4636">#4636</a>]
</li>
<li>macOS sandbox now supports <code>OPAM_USER_PATH_RO</code> for adding a custom read-only directory to the sandbox [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>, <a href="https://github.com/ocaml/opam/issues/4609">#4609</a>]
</li>
<li><code>OPAMROOT</code> and <code>OPAMSWITCH</code> now reflect the <code>--root</code> and <code>--switch</code> parameters in the package build [<a href="https://github.com/ocaml/opam/issues/4668">#4668</a>]
</li>
<li>When built with opam-file-format 2.1.3+, opam-format 2.0.x displays better errors for newer opam files [<a href="https://github.com/ocaml/opam/issues/4394">#4394</a>]
</li>
</ul>
<h2>Bug fixes</h2>
<ul>
<li>Linux sandbox now mounts <em>host</em> <code>$TMPDIR</code> read-only, then sets the <em>sandbox</em> <code>$TMPDIR</code> to a new separate tmpfs. <strong>Hardcoded <code>/tmp</code> access no longer works if <code>TMPDIR</code> points to another directory</strong> [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>]
</li>
<li>Stop clobbering <code>DUNE_CACHE</code> in the sandbox script [<a href="https://github.com/ocaml/opam/issues/4535">#4535</a>, fixing <a href="https://github.com/ocaml/dune/issues/4166">ocaml/dune#4166</a>]
</li>
<li>Ctrl-C now correctly terminates builds with bubblewrap; sandbox now requires bubblewrap 0.1.8 or later [<a href="https://github.com/ocaml/opam/issues/4400">#4400</a>]
</li>
<li>Linux sandbox script no longer makes <code>PWD</code> read-write on remove actions [<a href="https://github.com/ocaml/opam/issues/4589">#4589</a>]
</li>
<li>Lint W59 and E60 no longer trigger for packages flagged <code>conf</code> [<a href="https://github.com/ocaml/opam/issues/4549">#4549</a>]
</li>
<li>Reduce the length of temporary file names for pin caching to ease pressure on Windows [<a href="https://github.com/ocaml/opam/issues/4590">#4590</a>]
</li>
<li>Security: correct quoting of arguments when removing switches [<a href="https://github.com/ocaml/opam/issues/4707">#4707</a>]
</li>
<li>Stop advertising the removed option <code>--compiler</code> when creating local switches [<a href="https://github.com/ocaml/opam/issues/4718">#4718</a>]
</li>
<li>Pinning no longer fails if the archive's opam file is malformed [<a href="https://github.com/ocaml/opam/issues/4580">#4580</a>]
</li>
<li>Fish: stop using deprecated <code>^</code> syntax to fix support for Fish 3.3.0+ [<a href="https://github.com/ocaml/opam/issues/4736">#4736</a>]
</li>
</ul>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.9&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.9">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.9#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
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
 
  { title = {js|opam 2.1.0~rc2 released|js}
  ; slug = {js|opam-2-1-0-rc2|js}
  ; description = {js|???|js}
  ; date = {js|2021-06-23|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0-rc2/8042">Discuss</a>!</em></p>
<p>The opam team has great pleasure in announcing opam 2.1.0~rc2!</p>
<p>The focus since beta4 has been preparing for a world with more than one released version of opam (i.e. 2.0.x and 2.1.x). The release candidate extends CLI versioning further and, under the hood, includes a big change to the opam root format which allows new versions of opam to indicate that the root may still be read by older versions of the opam libraries. A plugin compiled against the 2.0.9 opam libraries will therefore be able to read information about an opam 2.1 root (plugins and tools compiled against 2.0.8 are unable to load opam 2.1.0 roots).</p>
<p>Please do take this release candidate for a spin! It is available in the Docker images at ocaml/opam on <a href="https://hub.docker.com/r/ocaml/opam/tags">Docker Hub</a> as the opam-2.1 command (or you can <code>sudo ln -f /usr/bin/opam-2.1 /usr/bin/opam</code> in your <code>Dockerfile</code> to switch to it permanently). The release candidate can also be tested via our installation script (see the <a href="https://github.com/ocaml/opam/wiki/How-to-test-an-opam-feature#from-a-tagged-release-including-pre-releases">wiki</a> for more information).</p>
<p>Thank you to anyone who noticed the unannounced first release candidate and tried it out. Between tagging and what would have been announcing it, we discovered an issue with upgrading local switches from earlier alpha/beta releases, and so fixed that for this second release candidate.</p>
<p>Assuming no showstoppers, we plan to release opam 2.1.0 next week. The improvements made in 2.1.0 will allow for a much faster release cycle, and we look forward to posting about the 2.2.0 plans soon!</p>
<h1>Try it!</h1>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>
<p>Either from binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.0~rc2&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-rc2">the Github &quot;Releases&quot; page</a> to your PATH.</p>
</li>
<li>
<p>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0-rc2#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>You should then run:</p>
<pre><code>opam init --reinit -ni
</code></pre>
<p>We hope there won't be any, but please report any issues to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.
Thanks for trying it out, and hoping you enjoy!</p>
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
 
  { title = {js|OCaml Multicore - March 2021|js}
  ; slug = {js|multicore-2021-03|js}
  ; description = {js|Monthly update from the OCaml Multicore team.|js}
  ; date = {js|2021-03-01|js}
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
 
  { title = {js|opam 2.1.0~beta4 released|js}
  ; slug = {js|opam-2-1-0-beta4|js}
  ; description = {js|???|js}
  ; date = {js|2021-02-08|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0-beta4/7252">Discuss</a>!</em></p>
<p>On behalf of the opam team, it gives me great pleasure to announce the third beta release of opam 2.1. Don’t worry, you didn’t miss beta3 - we had an issue with a configure script that caused beta2 to report as beta3 in some instances, so we skipped to beta4 to avoid any further confusion!</p>
<p>We encourage you to try out this new beta release: there are instructions for doing so in <a href="https://github.com/ocaml/opam/wiki/How-to-test-an-opam-feature">our wiki</a>. The instructions include taking a backup of your <code>~/.opam</code> root as part of the process, which can be restored in order to wind back. <em>Please note that local switches which are written to by opam 2.1 are upgraded and will need to be rebuilt if you go back to opam 2.0</em>. This can either be done by removing <code>_opam</code> and repeating whatever you use in your build process to create the switch, or you can use <code>opam switch export switch.export</code> to backup the switch to a file before installing new packages. Note that opam 2.1 <em>shouldn’t</em> upgrade a local switch unless you upgrade the base packages (i.e. the compiler).</p>
<h2>What’s new in opam 2.1?</h2>
<ul>
<li>Switch invariants
</li>
<li>Improved options configuration (see the new <code>option</code> and expanded <code>var</code> sub-commands)
</li>
<li>Integration of system dependencies (formerly the opam-depext plugin), increasing their reliability as it integrates the solving step
</li>
<li>Creation of lock files for reproducible installations (formerly the opam-lock plugin)
</li>
<li>CLI versioning, allowing cleaner deprecations for opam now and also improvements to semantics in future without breaking backwards-compatibility
</li>
<li>Performance improvements to opam-update, conflict messages, and many other areas
</li>
<li>New plugins: opam-compiler and opam-monorepo
</li>
</ul>
<h3>Switch invariants</h3>
<p>In opam 2.0, when a switch is created the packages selected are put into the “base” of the switch. These packages are not normally considered for upgrade, in order to ease pressure on opam’s solver. This was a much bigger concern early on in opam 2.0’s development, but is less of a problem with the default mccs solver.</p>
<p>However, it’s a problem for system compilers. opam would detect that your system compiler version had changed, but be unable to upgrade the ocaml-system package unless you went through a slightly convoluted process with <code>--unlock-base</code>.</p>
<p>In opam 2.1, base packages have been replaced by switch invariants. The switch invariant is a package formula which must be satisfied on every upgrade and install. All existing switches’ base packages could just be expressed as <code>package1 &amp; package2 &amp; package3</code> etc. but opam 2.1 recognises many existing patterns and simplifies them, so in most cases the invariant will be <code>&quot;ocaml-base-compiler&quot; {= 4.11.1}</code>, etc. This means that <code>opam switch create my_switch ocaml-system</code> now creates a <em>switch invariant</em> of <code>&quot;ocaml-system&quot;</code> rather than a specific version of the <code>ocaml-system</code> package. If your system OCaml package is updated, <code>opam upgrade</code> will seamlessly switch to the new package.</p>
<p>This also allows you to have switches which automatically install new point releases of OCaml. For example:</p>
<pre><code>opam switch create ocaml-4.11 --formula='&quot;ocaml-base-compiler&quot; {&gt;= &quot;4.11.0&quot; &amp; &lt; &quot;4.12.0~&quot;}' --repos=old=git+https://github.com/ocaml/opam-repository#a11299d81591
opam install utop

</code></pre>
<p>Creates a switch with OCaml 4.11.0 (the <code>--repos=</code> was just to select a version of opam-repository from before 4.11.1 was released). Now issue:</p>
<pre><code>opam repo set-url old git+https://github.com/ocaml/opam-repository
opam upgrade
</code></pre>
<p>and opam 2.1 will automatically offer to upgrade OCaml 4.11.1 along with a rebuild of the switch. There’s not yet a clean CLI for specifying the formula, but we intend to iterate further on this with future opam releases so that there is an easier way of saying “install OCaml 4.11.x”.</p>
<h3>opam depext integration</h3>
<p>opam has long included the ability to install system dependencies automatically via the <a href="https://github.com/ocaml-opam/opam-depext">depext plugin</a>. This plugin has been promoted to a native feature of opam 2.1.0 onwards, giving the following benefits:</p>
<ul>
<li>You no longer have to remember to run <code>opam depext</code>, opam always checks depexts (there are options to disable this or automate it for CI use). Installation of an opam package in a CI system is now as easy as <code>opam install .</code>, without having to do the dance of <code>opam pin add -n/depext/install</code>. Just one command now for the common case!
</li>
<li>The solver is only called once, which both saves time and also stabilises the behaviour of opam in cases where the solver result is not stable. It was possible to get one package solution for the <code>opam depext</code> stage and a different solution for the <code>opam install</code> stage, resulting in some depexts missing.
</li>
<li>opam now has full knowledge of depexts, which means that packages can be automatically selected based on whether a system package is already installed. For example, if you have <em>neither</em> MariaDB nor MySQL dev libraries installed, <code>opam install mysql</code> will offer to install <code>conf-mysql</code> and <code>mysql</code>, but if you have the MariaDB dev libraries installed, opam will offer to install <code>conf-mariadb</code> and <code>mysql</code>.
</li>
</ul>
<h3>opam lock files and reproducibility</h3>
<p>When opam was first released, it had the mission of gathering together scattered OCaml source code to build a <a href="https://github.com/ocaml/opam-repository">community repository</a>. As time marches on, the size of the opam repository has grown tremendously, to over 3000 unique packages with over 18000 unique versions. opam looks at all these packages and is designed to solve for the best constraints for a given package, so that your project can keep up with releases of your dependencies.</p>
<p>While this works well for libraries, we need a different strategy for projects that need to test and ship using a fixed set of dependencies. To satisfy this use-case, opam 2.0.0 shipped with support for <em>using</em> <code>project.opam.locked</code> files. These are normal opam files but with exact versions of dependencies. The lock file can be used as simply as <code>opam install . --locked</code> to have a reproducible package installation.</p>
<p>With opam 2.1.0, the creation of lock files is also now integrated into the client:</p>
<ul>
<li><code>opam lock</code> will create a <code>.locked</code> file for your current switch and project, that you can check into the repository.
</li>
<li><code>opam switch create . --locked</code> can be used by users to reproduce your dependencies in a fresh switch.
</li>
</ul>
<p>This lets a project simultaneously keep up with the latest dependencies (without lock files) while providing a stricter set for projects that need it (with lock files).</p>
<h3>CLI Versioning</h3>
<p>A new <code>--cli</code> switch was added to the first beta release, but it’s only now that it’s being widely used. opam is a complex enough system that sometimes bug fixes need to change the semantics of some commands. For example:</p>
<ul>
<li><code>opam show --file</code> needed to change behaviour
</li>
<li>The addition of new controls for setting global variables means that the <code>opam config</code> was becoming cluttered and some things want to move to <code>opam var</code>
</li>
<li><code>opam switch install 4.11.1</code> still works in opam 2.0, but it’s really an OPAM 1.2.2 syntax.
</li>
</ul>
<p>Changing the CLI is exceptionally painful since it can break scripts and tools which themselves need to drive <code>opam</code>. CLI versioning is our attempt to solve this. The feature is inspired by the <code>(lang dune ...)</code> stanza in <code>dune-project</code> files which has allowed the Dune project to rename variables and alter semantics without requiring every single package using Dune to upgrade their <code>dune</code> files on each release.</p>
<p>Now you can specify which version of opam you expected the command to be run against. In day-to-day use of opam at the terminal, you wouldn’t specify it, and you’ll get the latest version of the CLI. For example: <code>opam var --global</code> is the same as <code>opam var --cli=2.1 --global</code>. However, if you issue <code>opam var --cli=2.0 --global</code>, you will told that <code>--global</code> was added in 2.1 and so is not available to you. You can see similar things with the renaming of <code>opam upgrade --unlock-base</code> to <code>opam upgrade --update-invariant</code>.</p>
<p>The intention is that <code>--cli</code> should be used in scripts, user guides (e.g. blog posts), and in software which calls opam. The only decision you have to take is the <em>oldest</em> version of opam which you need to support. If your script is using a new opam 2.1 feature (for example <code>opam switch create --formula=</code>) then you simply don’t support opam 2.0. If you need to support opam 2.0, then you can’t use <code>--formula</code> and should use <code>--packages</code> instead. opam 2.0 does not have the <code>--cli</code> option, so for opam 2.0 instead of <code>--cli=2.0</code> you should set the environment variable <code>OPAMCLI</code> to <code>2.0</code>. As with <em>all</em> opam command line switches, <code>OPAMCLI</code> is simply the equivalent of <code>--cli</code> which opam 2.1 will pick-up but opam 2.0 will quietly ignore (and, as with other options, the command line takes precedence over the environment).</p>
<p>Note that opam 2.1 sets <code>OPAMCLI=2.0</code> when building packages, so on the rare instances where you need to use the <code>opam</code> command in a <em>package</em> <code>build:</code> command (or in your build system), you <em>must</em> specify <code>--cli=2.1</code> if you’re using new features.</p>
<p>There’s even more detail on this feature <a href="https://github.com/ocaml/opam/wiki/Spec-for-opam-CLI-versioning">in our wiki</a>. We’re still finalising some details on exactly how <code>opam</code> behaves when <code>--cli</code> is not given, but we’re hoping that this feature will make it much easier in future releases for opam to make required changes and improvements to the CLI without breaking existing set-ups and tools.</p>
<h2>What’s new since the last beta?</h2>
<ul>
<li>opam now uses CLI versioning (<a href="https://github.com/ocaml/opam/pull/4385">#4385</a>)
</li>
<li>opam now exits with code 31 if all failures were during fetch operations (<a href="https://github.com/ocaml/opam/issues/4214">#4214</a>)
</li>
<li><code>opam install</code> now has a <code>--download-only</code> flag (<a href="https://github.com/ocaml/opam/issues/4036">#4036</a>), allowing opam’s caches to be primed
</li>
<li><code>opam init</code> now advises the correct shell-specific command for <code>eval $(opam env)</code> (<a href="https://github.com/ocaml/opam/pull/4427">#4427</a>)
</li>
<li><code>post-install</code> hooks are now allowed to modify or remove installed files (<a href="https://github.com/ocaml/opam/pull/4388">#4388</a>)
</li>
<li>New package variable <code>opamfile-loc</code> with the location of the installed package opam file (<a href="https://github.com/ocaml/opam/pull/4402">#4402</a>)
</li>
<li><code>opam update</code> now has <code>--depexts</code> flag (<a href="https://github.com/ocaml/opam/issues/4355">#4355</a>), allowing the system package manager to update too
</li>
<li>depext support NetBSD and DragonFlyBSD added (<a href="https://github.com/ocaml/opam/pull/4396">#4396</a>)
</li>
<li>The format-preserving opam file printer has been overhauled (<a href="https://github.com/ocaml/opam/issues/3993">#3993</a>, <a href="https://github.com/ocaml/opam/pull/4298">#4298</a> and <a href="https://github.com/ocaml/opam/pull/4302">#4302</a>)
</li>
<li>pins are now fetched in parallel (<a href="https://github.com/ocaml/opam/issues/4315">#4315</a>)
</li>
<li><code>os-family=ubuntu</code> is now treated as <code>os-family=debian</code> (<a href="https://github.com/ocaml/opam/pull/4441">#4441</a>)
</li>
<li><code>opam lint</code> now checks that strings in filtered package formulae are booleans or variables (<a href="https://github.com/ocaml/opam/issues/4439">#4439</a>)
</li>
</ul>
<p>and many other bug fixes as listed <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-beta4">on the release page</a>.</p>
<h2>New Plugins</h2>
<p>Several features that were formerly plugins have been integrated into opam 2.1.0. We have also developed some <em>new</em> plugins that satisfy emerging workflows from the community and the core OCaml team. They are available for use with the opam 2.1 beta as well, and feedback on them should be directed to the respective GitHub trackers for those plugins.</p>
<h3>opam compiler</h3>
<p>The <a href="https://github.com/ocaml-opam/opam-compiler"><code>opam compiler</code></a> plugin can be used to create switches from various sources such as the main opam repository, the ocaml-multicore fork, or a local development directory. It can use Git tag names, branch names, or PR numbers to specify what to install.</p>
<p>Once installed, these are normal opam switches, and one can install packages in them. To iterate on a compiler feature and try opam packages at the same time, it supports two ways to reinstall the compiler: either a safe and slow technique that will reinstall all packages, or a quick way that will just overwrite the compiler in place.</p>
<h3>opam monorepo</h3>
<p>The <a href="https://github.com/ocamllabs/opam-monorepo"><code>opam monorepo</code></a> plugin lets you assemble standalone dune workspaces with your projects and all of their opam dependencies, letting you build it all from scratch using only Dune and OCaml. This satisfies the “monorepo” workflow which is commonly requested by large projects that need all of their dependencies in one place. It is also being used by projects that need global cross-compilation for all aspects of a codebase (including C stubs in packages), such as the MirageOS unikernel framework.</p>
<h2>Next Steps</h2>
<p>This is anticipated to be the final beta in the 2.1 series, and we will be moving to release candidate status after this. We could really use your help with testing this release in your infrastructure and projects and let us know if you run into any blockers. If you have feature requests, please also report them on <a href="https://github.com/ocaml/opam/issues">our issue tracker</a> -- we will be planning the next release cycle once we ship opam 2.1.0 shortly.</p>
|js}
  };
 
  { title = {js|opam 2.0.8 release|js}
  ; slug = {js|opam-2-0-8|js}
  ; description = {js|???|js}
  ; date = {js|2021-02-08|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">opam 2.0.8</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/4425">backported</a> fixes:</p>
<ul>
<li><strong>Critical for fish users!</strong> Don't add <code>.</code> to <code>PATH</code>. [<a href="https://github.com/ocaml/opam/issues/4078">#4078</a>]
</li>
<li>Fix sandbox script for newer <code>ccache</code> versions. [<a href="https://github.com/ocaml/opam/issues/4079">#4079</a> and <a href="https://github.com/ocaml/opam/pull/4087">#4087</a>]
</li>
<li>Fix sandbox crash when <code>~/.cache</code> is a symlink. [<a href="https://github.com/ocaml/opam/issues/4068">#4068</a>]
</li>
<li>User modifications to the sandbox script are no longer overwritten by <code>opam init</code>. [<a href="https://github.com/ocaml/opam/pull/4092">#4020</a> &amp; <a href="https://github.com/ocaml/opam/pull/4092">#4092</a>]
</li>
<li>macOS sandbox script always mounts <code>/tmp</code> read-write, regardless of <code>TMPDIR</code> [<a href="https://github.com/ocaml/opam/pull/3742">#3742</a>, addressing <a href="https://github.com/ocaml/opam-repository/issues/13339">ocaml/opam-repository#13339</a>]
</li>
<li><code>pre-</code> and <code>post-session</code> hooks can now print to the console [<a href="https://github.com/ocaml/opam/issues/4359">#4359</a>]
</li>
<li>Switch-specific pre/post sessions hooks are now actually run [<a href="https://github.com/ocaml/opam/issues/4472">#4472</a>]
</li>
<li>Standalone <code>opam-installer</code> now correctly builds from sources [<a href="https://github.com/ocaml/opam/issues/4173">#4173</a>]
</li>
<li>Fix <code>arch</code> variable detection when using 32bit mode on ARM64 and i486 [<a href="https://github.com/ocaml/opam/pull/4462">#4462</a>]
</li>
</ul>
<p>A more complete <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">release note</a> is available.</p>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.8&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.8">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.8#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>, and published in <a href="https://discuss.ocaml.org/t/ann-opam-2-0-8-release/7242">discuss.ocaml.org</a>. Please head to the latter for the comments!</p>
</blockquote>
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
 
  { title = {js|opam 2.1.0 alpha is here!|js}
  ; slug = {js|opam-2-1-0-alpha|js}
  ; description = {js|???|js}
  ; date = {js|2020-04-21|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are happy to announce a alpha for opam 2.1.0, one year and a half in the
making after the release of 2.0.0.</p>
<p>Many new features made it in (see the <a href="https://github.com/ocaml/opam/blob/2.1.0-alpha/CHANGES">complete
changelog</a> or <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-alpha">release
note</a> for the details),
but here are a few highlights of this release.</p>
<h1>Release highlights</h1>
<p>The two following features have been around for a while as plugins and are now
completely integrated in the core of opam. No extra installs needed anymore, and
a more smooth experience.</p>
<h3>Seamless integration of System dependencies handling (a.k.a. &quot;depexts&quot;)</h3>
<p>A number of opam packages depend on tools or libraries installed on the system,
which are out of the scope of opam itself. Previous versions of opam added a
<a href="http://opam.ocaml.org/doc/Manual.html#opamfield-depexts">specification format</a>,
and opam 2.0 already handled checking the OS and extracting the required system
package names.</p>
<p>However, the workflow generally involved letting opam fail once, then installing
the dependencies and retrying, or explicitely using the
<a href="https://github.com/ocaml/opam-depext">opam-depext plugin</a>, which was invaluable
for CI but still incurred extra steps.</p>
<p>With opam 2.1.0, <em>depexts</em> are seamlessly integrated, and you basically won't
have to worry about them ahead of time:</p>
<ul>
<li>Before applying its course of actions, opam 2.1.0 checks that external
dependencies are present, and will prompt you to install them. You are free to
let it do it using <code>sudo</code>, or just run the provided commands yourself.
</li>
<li>It is resilient to <em>depexts</em> getting removed or out of sync.
</li>
<li>Opam 2.1.0 detects packages that depend on stuff that is not available on your
OS version, and automatically avoids them.
</li>
</ul>
<p>This is all fully configurable, and can be bypassed without tricky commands when
you need it (<em>e.g.</em> when you compiled a dependency yourself).</p>
<h3>Dependency locking</h3>
<p>To share a project for development, it is often necessary to be able to
reproduce the exact same environment and dependencies setting — as opposed to
allowing a range of versions as opam encourages you to do for releases.</p>
<p>For some reason, most other package managers call this feature &quot;lock files&quot;.
Opam can handle those in the form of <code>[foo.]opam.locked</code> files, and the
<code>--locked</code> option.</p>
<p>With 2.1.0, you no longer need a plugin to generate these files: just running
<code>opam lock</code> will create them for existing <code>opam</code> files, enforcing the exact
version of all dependencies (including locally pinned packages).</p>
<p>If you check-in these files, new users would just have run
<code>opam switch create . --locked</code> on a fresh clone to get a local switch ready to
build the project.</p>
<h3>Pinning sub-directories</h3>
<p>This one is completely new: fans of the <em>Monorepo</em> rejoice, opam is now able to
handle projects in subtrees of a repository.</p>
<ul>
<li>Using <code>opam pin PROJECT_ROOT --subpath SUB_PROJECT</code>, opam will look for
<code>PROJECT_ROOT/SUB_PROJECT/foo.opam</code>. This will behave as a pinning to
<code>PROJECT_ROOT/SUB_PROJECT</code>, except that the version-control handling is done
in <code>PROJECT_ROOT</code>.
</li>
<li>Use <code>opam pin PROJECT_ROOT --recursive</code> to automatically lookup all sub-trees
with opam files and pin them.
</li>
</ul>
<h3>Opam switches are now defined by invariants</h3>
<p>Previous versions of opam defined switches based on <em>base packages</em>, which
typically included a compiler, and were immutable. Opam 2.1.0 instead defines
them in terms of an <em>invariant</em>, which is a generic dependency formula.</p>
<p>This removes a lot of the rigidity <code>opam switch</code> commands had, with little
changes on the existing commands. For example, <code>opam upgrade ocaml</code> commands are
now possible; you could also define the invariant as <code>ocaml-system</code> and have
its version change along with the version of the OCaml compiler installed
system-wide.</p>
<h3>Configuring opam from the command-line</h3>
<p>The new <code>opam option</code> command allows to configure several options,
without requiring manual edition of the configuration files.</p>
<p>For example:</p>
<ul>
<li><code>opam option jobs=6 --global</code> will set the number of parallel build
jobs opam is allowed to run (along with the associated <code>jobs</code> variable)
</li>
<li><code>opam option depext-run-commands=false</code> disables the use of <code>sudo</code> for
handling system dependencies; it will be replaced by a prompt to run the
installation commands.
</li>
</ul>
<p>The command <code>opam var</code> is extended with the same format, acting on switch and
global variables.</p>
<h1>Try it!</h1>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>
<p>Either from binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.0~alpha&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-alpha">the Github &quot;Releases&quot; page</a> to your PATH.</p>
</li>
<li>
<p>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0-alpha#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>You should then run:</p>
<pre><code>opam init --reinit -ni
</code></pre>
<p>This is still a alpha, so a few glitches or regressions are to be expected.
Please report them to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.
Thanks for trying it out, and hoping you enjoy!</p>
<blockquote>
<p>NOTE: this article is cross-posted on
<a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and
<a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the
latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.7 release|js}
  ; slug = {js|opam-2-0-7|js}
  ; description = {js|???|js}
  ; date = {js|2020-04-21|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.7">opam 2.0.7</a>.</p>
<p>This new version contains <a href="https://github.com/ocaml/opam/pull/4143">backported</a> small fixes:</p>
<ul>
<li>Escape Windows paths on manpages [<a href="https://github.com/ocaml/opam/pull/4129">#4129</a> <a href="https://github.com/AltGr">@AltGr</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Fix opam installer opam file [<a href="https://github.com/ocaml/opam/pull/4058">#4058</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Fix various warnings [<a href="https://github.com/ocaml/opam/pull/4132">#4132</a> <a href="https://github.com/rjbou">@rjbou</a> <a href="https://github.com/AltGr">@AltGr</a> - fix <a href="https://github.com/ocaml/opam/issues/4100">#4100</a>]
</li>
<li>Fix dune 2.5.0 promote-install-files duplication [<a href="https://github.com/ocaml/opam/pull/4132">#4132</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.7&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.7">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.7#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
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
 
  { title = {js|opam 2.0.6 release|js}
  ; slug = {js|opam-2-0-6|js}
  ; description = {js|???|js}
  ; date = {js|2020-01-16|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.6">opam 2.0.6</a>.</p>
<p>This new version contains some small <a href="https://github.com/ocaml/opam/pull/3973">backported</a> fixes and build update:</p>
<ul>
<li>Don't remove git cache objects that may be used [<a href="https://github.com/ocaml/opam/pull/3831">#3831</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>Don't include .gitattributes in index.tar.gz [<a href="https://github.com/ocaml/opam/pull/3873">#3873</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Update FAQ uri [<a href="https://github.com/ocaml/opam/pull/3941">#3941</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Lock: add warning in case of missing locked file [<a href="https://github.com/ocaml/opam/pull/3939">#3939</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>Directory tracking: fix cached entries retrieving with precise
tracking [<a href="https://github.com/ocaml/opam/pull/4038">#4038</a> <a href="https://github.com/hannesm">@hannesm</a>]
</li>
<li>Build:
<ul>
<li>Add sanity checks [<a href="https://github.com/ocaml/opam/pull/3934">#3934</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Build man pages using dune [<a href="https://github.com/ocaml/opam/issues/3902">#3902</a> ]
</li>
<li>Add patch and bunzip check for make cold [<a href="https://github.com/ocaml/opam/pull/4006">#4006</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3842">#3842</a>]
</li>
</ul>
</li>
<li>Shell:
<ul>
<li>fish: add colon for fish manpath [<a href="https://github.com/ocaml/opam/pull/3886">#3886</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3878">#3878</a>]
</li>
</ul>
</li>
<li>Sandbox:
<ul>
<li>Add dune cache as rw [<a href="https://github.com/ocaml/opam/pull/4019">#4019</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/4012">#4012</a>]
</li>
<li>Do not fail if $HOME/.ccache is missing [<a href="https://github.com/ocaml/opam/pull/3957">#3957</a> <a href="https://github.com/mseri">@mseri</a>]
</li>
</ul>
</li>
<li>opam-devel file: avoid copying extraneous files in opam-devel example [<a href="https://github.com/ocaml/opam/pull/3999">#3999</a> <a href="https://github.com/maroneze">@maroneze</a>]
</li>
</ul>
<p>As <strong>sandbox scripts</strong> have been updated, don't forget to run <code>opam init --reinit -ni</code> to update yours.</p>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.0.6&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.6">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.6#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
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
  };
 
  { title = {js|opam 2.0.5 release|js}
  ; slug = {js|opam-2-0-5|js}
  ; description = {js|???|js}
  ; date = {js|2019-07-11|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.5">opam 2.0.5</a>.</p>
<p>This new version contains build update and small fixes:</p>
<ul>
<li>Bump src_ext Dune to 1.6.3, allows compilation with OCaml 4.08.0. [<a href="https://github.com/ocaml/opam/pull/3887">#3887</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Support Dune 1.7.0 and later [<a href="https://github.com/ocaml/opam/pull/3888">#3888</a> <a href="https://github.com/dra27">@dra27</a> - fix <a href="https://github.com/ocaml/opam/issues/3870">#3870</a>]
</li>
<li>Bump the ocaml_mccs lib-ext, to include latest changes [<a href="https://github.com/ocaml/opam/pull/3896">#3896</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>Fix cppo detection in configure [<a href="https://github.com/ocaml/opam/pull/3917">#3917</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Read jobs variable from OpamStateConfig [<a href="https://github.com/ocaml/opam/pull/3916">#3916</a> <a href="https://github.com/dra27">@dra27</a>]
</li>
<li>Linting:
<ul>
<li>add check upstream option [<a href="https://github.com/ocaml/opam/pull/3758">#3758</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>add warning for with-test in run-test field [<a href="https://github.com/ocaml/opam/pull/3765">#3765</a>, <a href="https://github.com/ocaml/opam/pull/3860">#3860</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>fix misleading <code>doc</code> filter warning [<a href="https://github.com/ocaml/opam/pull/3871">#3871</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
</li>
<li>Fix typos [<a href="https://github.com/ocaml/opam/pull/3891">#3891</a> <a href="https://github.com/dra27">@dra27</a>, <a href="https://github.com/mehdid">@mehdid</a>]
</li>
</ul>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.5">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.5#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.4 release|js}
  ; slug = {js|opam-2-0-4|js}
  ; description = {js|???|js}
  ; date = {js|2019-04-10|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.4">opam 2.0.4</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/3805">backported fixes</a>:</p>
<ul>
<li>Sandboxing on macOS: considering the possibility that TMPDIR is unset [<a href="https://github.com/ocaml/opam/pull/3597">#3597</a> <a href="https://github.com/herbelin">@herbelin</a> - fix <a href="https://github.com/ocaml/opam/issues/3576">#3576</a>]
</li>
<li>display: Fix <code>opam config var</code> display, aligned on <code>opam config list</code> [<a href="https://github.com/ocaml/opam/pull/3723">#3723</a> <a href="https://github.com/rjbou">@rjbou</a> - rel. <a href="https://github.com/ocaml/opam/issues/3717">#3717</a>]
</li>
<li>pin:
<ul>
<li>update source of (version) pinned directory [<a href="https://github.com/ocaml/opam/pull/3726">#3726</a> <a href="https://github.com/rjbou">@rjbou</a> - <a href="https://github.com/ocaml/opam/issues/3651">#3651</a>]
</li>
<li>fix <code>--ignore-pin-depends</code> with autopin [<a href="https://github.com/ocaml/opam/pull/3736">#3736</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
<li>fix pinnings not installing/upgrading already pinned packages (introduced in 2.0.2) [<a href="https://github.com/ocaml/opam/pull/3800">#3800</a> <a href="https://github.com/AltGr">@AltGr</a>]
</li>
</ul>
</li>
<li>opam clean: Ignore errors trying to remove directories [<a href="https://github.com/ocaml/opam/pull/3732">#3732</a> <a href="https://github.com/kit">@kit-ty-kate</a>]
</li>
<li>remove wrong &quot;mismatched extra-files&quot; warning [<a href="https://github.com/ocaml/opam/pull/3744">#3744</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>urls: fix hg opam 1.2 url parsing [<a href="https://github.com/ocaml/opam/pull/3754">#3754</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>lint: update message of warning 47, to avoid confusion because of missing <code>synopsis</code> field internally inferred from <code>descr</code> [<a href="https://github.com/ocaml/opam/pull/3753">#3753</a> <a href="https://github.com/rjbou">@rjbou</a> - fix <a href="https://github.com/ocaml/opam/issues/3738">#3738</a>]
</li>
<li>system:
<ul>
<li>lock &amp; signals: don't interrupt at non terminal signals [<a href="https://github.com/ocaml/opam/pull/3541">#3541</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>shell: fix fish manpath setting [<a href="https://github.com/ocaml/opam/pull/3728">#3728</a> <a href="https://github.com/gregory">@gregory-nisbet</a>]
</li>
<li>git: use <code>diff.noprefix=false</code> config argument to overwrite user defined configuration [<a href="https://github.com/ocaml/opam/pull/3788">#3788</a> <a href="https://github.com/rjbou">@rjbou</a>, <a href="https://github.com/ocaml/opam/pull/3628">#3628</a> <a href="https://github.com/Blaisorblade">@Blaisorblade</a> - fix <a href="https://github.com/ocaml/opam/issues/3627">#3627</a>]
</li>
</ul>
</li>
<li>dirtrack: fix precise tracking mode [<a href="https://github.com/ocaml/opam/pull/3796">#3796</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
<li>fix some mispellings [<a href="https://github.com/ocaml/opam/pull/3731">#3731</a> <a href="https://github.com/MisterDA">@MisterDA</a>]
</li>
<li>CI enhancement &amp; fixes [<a href="https://github.com/ocaml/opam/pull/3706">#3706</a> <a href="https://github.com/dra27">@dra27</a>, <a href="https://github.com/ocaml/opam/pull/3748">#3748</a> <a href="https://github.com/rjbou">@rjbou</a>, <a href="https://github.com/ocaml/opam/pull/3801">#3801</a> <a href="https://github.com/rjbou">@rjbou</a>]
</li>
</ul>
<blockquote>
<p>Note: To homogenise macOS name on system detection, we decided to keep <code>macos</code>, and convert <code>darwin</code> to <code>macos</code> in opam. For the moment, to not break jobs &amp; CIs, we keep uploading <code>darwin</code> &amp; <code>macos</code> binaries, but from the 2.1.0 release, only <code>macos</code> ones will be kept.</p>
</blockquote>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.4">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.4#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0 tips|js}
  ; slug = {js|opam-20-tips|js}
  ; description = {js|???|js}
  ; date = {js|2019-03-12|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>This blog post looks back on some of the improvements in opam 2.0, and gives
tips on the new workflows available.</p>
<h2>Package development environment management</h2>
<p>Opam 2.0 has been vastly improved to handle locally defined packages. Assuming
you have a project <code>~/projects/foo</code>, defining two packages <code>foo-lib</code> and
<code>foo-bin</code>, you would have:</p>
<pre><code>~/projects/foo
|-- foo-lib.opam
|-- foo-bin.opam
`-- src/ ...
</code></pre>
<p>(See also about
<a href="../opam-extended-dependencies/#Computed-versions">computed dependency constraints</a>
for handling multiple package definitions with mutual constraints)</p>
<h3>Automatic pinning</h3>
<p>The underlying mechanism is the same, but this is an interface improvement that
replaces most of the opam 1.2 workflows based on <code>opam pin</code>.</p>
<p>The usual commands (<code>install</code>, <code>upgrade</code>, <code>remove</code>, etc.) have been extended to
support specifying a directory as argument. So when working on project <code>foo</code>,
just write:</p>
<pre><code>cd ~/projects/foo
opam install .
</code></pre>
<p>and both <code>foo-lib</code> and <code>foo-bin</code> will get automatically pinned to the current
directory (using git if your project is versioned), and installed. You may
prefer to use:</p>
<pre><code>opam install . --deps-only
</code></pre>
<p>to just get the package dependencies ready before you start hacking on it.
<a href="#Reproducing-build-environments">See below</a> for details on how to reproduce a
build environment more precisely. Note that <code>opam depext .</code> will not work at the
moment, which will be fixed in the next release when the external dependency
handling is integrated (opam will still list you the proper packages to install
for your OS upon failure).</p>
<p>If your project is versioned and you made changes, remember to either commit, or
add <code>--working-dir</code> so that your uncommitted changes are taken into account.</p>
<h2>Local switches</h2>
<blockquote>
<p>Opam 2.0 introduced a new feature called &quot;local switches&quot;. This section
explains what it is about, why, when and how to use them.</p>
</blockquote>
<p>Opam <em>switches</em> allow to maintain several separate development environments,
each with its own set of packages installed. This is particularly useful when
you need different OCaml versions, or for working on projects with different
dependency sets.</p>
<p>It can sometimes become tedious, though, to manage, or remember what switch to
use with what project. Here is where &quot;local switches&quot; come in handy.</p>
<h3>How local switches are handled</h3>
<p>A local switch is simply stored inside a <code>_opam/</code> directory, and will be
selected automatically by opam whenever your current directory is below its
parent directory.</p>
<blockquote>
<p>NOTE: it's highly recommended that you enable the new <em>shell hooks</em> when using
local switches. Just run <code>opam init --enable-shell-hook</code>: this will make sure
your PATH is always set for the proper switch.</p>
<p>You will otherwise need to keep remembering to run <code>eval $(opam env)</code> every
time you <code>cd</code> to a directory containing a local switch. See also
<a href="http://opam.ocaml.org/doc/Tricks.html#Display-the-current-quot-opam-switch-quot-in-the-prompt">how to display the current switch in your prompt</a></p>
</blockquote>
<p>For example, if you have <code>~/projects/foo/_opam</code>, the switch will be selected
whenever in project <code>foo</code>, allowing you to tailor what it has installed for the
needs of your project.</p>
<p>If you remove the switch dir, or your whole project, opam will forget about it
transparently. Be careful not to move it around, though, as some packages still
contain hardcoded paths and don't handle relocation well (we're working on
that).</p>
<h3>Creating a local switch</h3>
<p>This can generally start with:</p>
<pre><code>cd ~/projects/foo
opam switch create . --deps-only
</code></pre>
<p>Local switch handles are just their path, instead of a raw name. Additionally,
the above will detect package definitions present in <code>~/projects/foo</code>, pick a
compatible version of OCaml (if you didn't explicitely mention any), and
automatically install all the local package dependencies.</p>
<p>Without <code>--deps-only</code>, the packages themselves would also get installed in the
local switch.</p>
<h3>Using an existing switch</h3>
<p>If you just want an already existing switch to be selected automatically,
without recompiling one for each project, you can use <code>opam switch link</code>:</p>
<pre><code>cd ~/projects/bar
opam switch link 4.07.1
</code></pre>
<p>will make sure that switch <code>4.07.1</code> is chosen whenever you are in project <code>bar</code>.
You could even link to <code>../foo</code> here, to share <code>foo</code>'s local switch between the
two projects.</p>
<h2>Reproducing build environments</h2>
<h4>Pinnings</h4>
<p>If your package depends on development versions of some dependencies (e.g. you
had to push a fix upstream), add to your opam file:</p>
<pre><code>depends: [ &quot;some-package&quot; ] # Remember that pin-depends are depends too
pin-depends: [
  [ &quot;some-package.version&quot; &quot;git+https://gitfoo.com/blob.git#mybranch&quot; ]
]
</code></pre>
<p>This will have no effect when your package is published in a repository, but
when it gets pinned to its dev version, opam will first make sure to pin
<code>some-package</code> to the given URL.</p>
<h4>Lock-files</h4>
<p>Dependency contraints are sometimes too wide, and you don't want to explore all
the versions of your dependencies while developing. For this reason, you may
want to reproduce a known-working set of dependencies. If you use:</p>
<pre><code>opam lock .
</code></pre>
<p>opam will check what version of the dependencies are installed in your current
switch, and explicit them in <code>*.opam.locked</code> files. <code>opam lock</code> is a plugin at
the moment, but will get automatically installed when needed.</p>
<p>Then, assuming you checked these files into version control, any user can do</p>
<pre><code>opam install . --deps-only --locked
</code></pre>
<p>to instruct opam to reproduce the same build environment (the <code>--locked</code> option
is also available to <code>opam switch create</code>, to make things easier).</p>
<p>The generated lock-files will also contain added constraints to reproduce the
presence/absence of optional dependencies, and reproduce the appropriate
dependency pins using <code>pin-depends</code>. Add the <code>--direct-only</code> option if you don't
want to enforce the versions of all recursive dependencies, but only direct
ones.</p>
|js}
  };
 
  { title = {js|opam 2.0.3 release|js}
  ; slug = {js|opam-2-0-3|js}
  ; description = {js|???|js}
  ; date = {js|2019-01-28|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.3">opam 2.0.3</a>.</p>
<p>This new version contains some <a href="https://github.com/ocaml/opam/pull/3715">backported fixes</a>:</p>
<ul>
<li>Fix manpage remaining $ (OPAMBESTEFFORT)
</li>
<li>Fix OPAMROOTISOK handling
</li>
<li>Regenerate missing environment file
</li>
</ul>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.3">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.3#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.2 release|js}
  ; slug = {js|opam-2-0-2|js}
  ; description = {js|???|js}
  ; date = {js|2018-12-12|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.2">opam 2.0.2</a>.</p>
<p>As <strong>sandbox scripts</strong> have been updated, don't forget to run <code>opam init --reinit -ni</code> to update yours.</p>
<p>This new version contains mainly <a href="https://github.com/ocaml/opam/pull/3669">backported fixes</a>:</p>
<ul>
<li>Doc:
<ul>
<li>update man page
</li>
<li>add message for deprecated options
</li>
<li>reinsert removed ones to print a deprecated message instead of fail (e.g. <code>--alias-of</code>)
</li>
<li>deprecate <code>no-aspcud</code>
</li>
</ul>
</li>
<li>Pin:
<ul>
<li>on pinning, rebuild updated <code>pin-depends</code> packages reliably
</li>
<li>include descr &amp; url files on pinning 1.2 opam files
</li>
</ul>
</li>
<li>Sandbox:
<ul>
<li>handle symlinks in bubblewrap for system directories such as <code>/bin</code> or <code>/lib</code> (<a href="https://github.com/ocaml/opam/pull/3661">#3661</a>).  Fixes sandboxing on some distributions such as CentOS 7 and Arch Linux.
</li>
<li>allow use of unix domain sockets on macOS (<a href="https://github.com/ocaml/opam/issues/3659">#3659</a>)
</li>
<li>change one-line conditional to if statement which was incompatible with set -e
</li>
<li>make /var readonly instead of empty and rw
</li>
</ul>
</li>
<li>Path: resolve default opam root path
</li>
<li>System: suffix .out for read_command_output stdout files
</li>
<li>Locked: check consistency with opam file when reading lock file to suggest regeneration message
</li>
<li>Show: remove pin depends messages
</li>
<li>Cudf: Fix closure computation in the presence of cycles to have a complete graph if a cycle is present in the graph (typically <code>ocaml-base-compiler</code> ⇄ <code>ocaml</code>)
</li>
<li>List: Fix some cases of listing coinstallable packages
</li>
<li>Format upgrade: extract archived source files of version-pinned packages
</li>
<li>Core: add is_archive in OpamSystem and OpamFilename
</li>
<li>Init: don't fail if empty compiler given
</li>
<li>Lint: fix light_uninstall flag for error 52
</li>
<li>Build: partial port to dune
</li>
<li>Update cold compiler to 4.07.1
</li>
</ul>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.2">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.2#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.1 is out!|js}
  ; slug = {js|opam-2-0-1|js}
  ; description = {js|???|js}
  ; date = {js|2018-10-24|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.1">opam 2.0.1</a>.</p>
<p>This new version contains mainly <a href="https://github.com/ocaml/opam/pull/3560">backported fixes</a>, some platform-specific:</p>
<ul>
<li>Cold boot for MacOS/CentOS/Alpine
</li>
<li>Install checksum validation on MacOS
</li>
<li>Archive extraction for OpenBSD now defaults to using <code>gtar</code>
</li>
<li>Fix compilation of mccs on MacOS and Nix platforms
</li>
<li>Do not use GNU-sed specific features in the release Makefile, to fix build on OpenBSD/FreeBSD
</li>
<li>Cleaning to enable reproducible builds
</li>
<li>Update configure scripts
</li>
</ul>
<p>And some opam specific:</p>
<ul>
<li>git: fix git fetch by sha1 for git &lt; 2.14
</li>
<li>linting: add <code>test</code> variable warning and empty description error
</li>
<li>upgrade: convert pinned but not installed opam files
</li>
<li>error reporting: more comprehensible error message for tar extraction, and upgrade of git-url compilers
</li>
<li>opam show: upgrade given local files
</li>
<li>list: as opam 2.0.0 <code>list</code> doesn't return non-zero code if list is empty, add <code>--silent</code> option for a silent output and returns 1 if list is empty
</li>
</ul>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.1">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.1#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.0 release and repository upgrade|js}
  ; slug = {js|opam-2-0-0|js}
  ; description = {js|???|js}
  ; date = {js|2018-09-18|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are happy to announce the final release of <a href="https://github.com/ocaml/opam/releases/tag/2.0.0">opam 2.0.0</a>.</p>
<p>A few weeks ago, we released a <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4">last release candidate</a> to be later promoted to 2.0.0, synchronised with the <a href="https://github.com/ocaml/opam-repository">opam package repository</a> <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap/">upgrade</a>.</p>
<p>You are encouraged to update as soon as you see fit, to continue to get package updates: opam 2.0.0 supports the older formats, and 1.2.2 will no longer get regular updates. See the <a href="http://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">Upgrade Guide</a> for details about the new features and changes.</p>
<p>The website opam.ocaml.org has been updated, with the full 2.0.0 documentation pages. You can still find the documentation for the previous versions in the corresponding menu.</p>
<p>Package maintainers should be aware of the following:</p>
<ul>
<li>the master branch of the <a href="https://github.com/ocaml/opam-repository">opam package repository</a> is now in the 2.0.0 format
</li>
<li>package submissions must accordingly be made in the 2.0.0 format, or using the new version of <code>opam-publish</code> (2.0.0)
</li>
<li>anything that was merged into the repository in 1.2 format has been automatically updated to the 2.0.0 format
</li>
<li>the 1.2 format repository has been forked to its own branch, and will only be updated for critical fixes
</li>
</ul>
<p>For custom repositories, the <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap/#Advice-for-custom-repository-maintainers">advice</a> remains the same.</p>
<hr />
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc4#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new major version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|Last stretch! Repository upgrade and opam 2.0.0 roadmap|js}
  ; slug = {js|opam-2-0-0-repo-upgrade-roadmap|js}
  ; description = {js|???|js}
  ; date = {js|2018-08-02|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>A few days ago, we released <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4/">opam 2.0.0~rc4</a>, and explained that this final release candidate was expected be promoted to 2.0.0, in sync with an upgrade to the <a href="https://github.com/ocaml/opam-repository">opam package repository</a>. So here are the details about this!</p>
<h2>If you are an opam user, and don't maintain opam packages</h2>
<ul>
<li>
<p>You are encouraged to <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4/">upgrade</a>) as soon as comfortable, and get used to the <a href="http://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">changes and new features</a></p>
</li>
<li>
<p>All packages installing in opam 1.2.2 should exist and install fine on 2.0.0~rc4 (if you find one that doesn't, <a href="https://github.com/ocaml/opam/issues">please report</a>!)</p>
</li>
<li>
<p>If you haven't updated by <strong>September 17th</strong>, the amount of updates and new packages you receive may become limited<a href="#foot-1">¹</a>.</p>
</li>
</ul>
<h2>So what will happen on September 17th ?</h2>
<ul>
<li>
<p>Opam 2.0.0~rc4 gets officially released as 2.0.0</p>
</li>
<li>
<p>On the <code>ocaml/opam-repository</code> Github repository, a 1.2 branch is forked, and the 2.0.0 branch is merged into the master branch</p>
</li>
<li>
<p>From then on, pull-requests to <code>ocaml/opam-repository</code> need to be in 2.0.0 format. Fixes to the 1.2 repository can be merged if important: pulls need to be requested against the 1.2 branch in that case.</p>
</li>
<li>
<p>The opam website shows the 2.0.0 repository by default (https://opam.ocaml.org/2.0-preview/ becomes https://opam.ocaml.org/)</p>
</li>
<li>
<p>The http repositories for 1.2 and 2.0 (as used by <code>opam update</code>) are accordingly moved, with proper redirections put in place</p>
</li>
</ul>
<h2>Advice for package maintainers</h2>
<ul>
<li>
<p>Until September 17th, pull-requests filed to the master branch of <code>ocaml/opam-repository</code> need to be in 1.2.2 format</p>
</li>
<li>
<p>The CI checks for all PRs ensure that the package passes on both 1.2.2 and 2.0.0. After the 17th of september, only 2.0.0 will be checked (and 1.2.2 only if relevant fixes are required).</p>
</li>
<li>
<p>The 2.0.0 branch of the repository will contain the automatically updated 2.0.0 version of your package definitions</p>
</li>
<li>
<p>You can publish 1.2 packages while using opam 2.0.0 by installing <code>opam-publish.0.3.5</code> (running <code>opam pin opam-publish 0.3.5</code> is recommended)</p>
</li>
<li>
<p>You should only need to keep an opam 1.2 installation for more complex setups (multiple packages, or if you need to be able to test the 1.2 package installations locally). In this case you might want to use an alias, <em>e.g.</em> <code>alias opam.1.2=&quot;OPAMROOT=$HOME/.opam.1.2 ~/local/bin/opam.1.2</code>. You should also probably disable opam 2.0.0's automatic environment update in that case (<code>opam init --disable-shell-hook</code>)</p>
</li>
<li>
<p><code>opam-publish.2.0.0~beta</code> has a fully revamped interface, and many new features, like filing a single PR for multiple packages. It files pull-request <strong>in 2.0 format only</strong>, however. At the moment, it will file PR only to the 2.0.0 branch of the repository, but pushing 1.2 format packages to master is still preferred until September 17th.</p>
</li>
<li>
<p>It is also advised to keep in-source opam files in 1.2 format until that date, so as not to break uses of <code>opam pin add --dev-repo</code> by opam 1.2 users. The small <code>opam-package-upgrade</code> plugin can be used to upgrade single 1.2 <code>opam</code> files to 2.0 format.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml-ci-scripts"><code>ocaml-ci-script</code></a> already switched to opam 2.0.0. To keep testing opam 1.2.2, you can set the variable <code>OPAM_VERSION=1.2.2</code> in the <code>.travis.yml</code> file.</p>
</li>
</ul>
<h2>Advice for custom repository maintainers</h2>
<ul>
<li>
<p>The <code>opam admin upgrade</code> command can be used to upgrade your repository to 2.0.0 format. We recommand using it, as otherwise clients using opam 2.0.0 will do the upgrade locally every time. Add the option <code>--mirror</code> to continue serving both versions, with automatic redirects.</p>
</li>
<li>
<p>It's your place to decide when/if you want to switch your base repository to 2.0.0 format. You'll benefit from many new possibilities and safety features, but that will exclude users of earlier opam versions, as there is no backwards conversion tool.</p>
</li>
</ul>
<p><a id="foot-1">¹</a> Sorry for the inconvenience. We'd be happy if we could keep maintaining the 1.2.2 repository for more time; repository maintainers are doing an awesome job, but just don't have the resources to maintain both versions in parallel.</p>
|js}
  };
 
  { title = {js|opam 2.0.0 RC4-final is out!|js}
  ; slug = {js|opam-2-0-0-rc4|js}
  ; description = {js|???|js}
  ; date = {js|2018-07-26|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are happy to announce the <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc4">opam 2.0.0 final release candidate</a>! 🍾</p>
<p>This release features a few bugfixes over <a href="../opam-2-0-0-rc3">Release Candidate 3</a>. <strong>It will be promoted to 2.0.0 proper within a few weeks, when the <a href="https://github.com/ocaml/opam-repository">official repository</a> format switches from 1.2.0 to 2.0.0.</strong> After that date, updates to the 1.2.0 repository may become limited, as new features are getting used in packages.</p>
<p>It is safe to update as soon as you see fit, since opam 2.0.0 supports the older formats. See the <a href="http://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">Upgrade Guide</a> for details about the new features and changes. If you are a package maintainer, you should keep publishing as before for now: the <a href="https://opam.ocaml.org/blog/opam-2-0-0-repo-upgrade-roadmap">roadmap</a> for the repository upgrade will be detailed shortly.</p>
<p>The opam.ocaml.org pages have also been refreshed a bit, and the new version showing the 2.0.0 branch of the repository is already online at <a href="http://opam.ocaml.org/2.0-preview/">http://opam.ocaml.org/2.0-preview/</a> (report any issues <a href="https://github.com/ocaml/opam2web/issues">here</a>).</p>
<hr />
<p>Installation instructions:</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc4">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc4#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0.0 Release Candidate 3 is out!|js}
  ; slug = {js|opam-2-0-0-rc3|js}
  ; description = {js|???|js}
  ; date = {js|2018-06-22|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of a third release candidate for opam 2.0.0. This one is expected to be the last before 2.0.0 comes out.</p>
<p>Changes since the <a href="../opam-2-0-0-rc2">2.0.0~rc2</a> are, as expected, mostly fixes. We deemed it useful, however, to bring in the following:</p>
<ul>
<li>a new command <code>opam switch link</code> that allows to select a switch to be used in a given directory (particularly convenient if you use the shell hook for automatic opam environment update)
</li>
<li>a new option <code>opam install --assume-built</code>, that allows to install a package using its normal opam procedure, but for a source repository that has been built by hand. This fills a gap that remained in the local development workflows.
</li>
</ul>
<p>The preview of the opam 2 webpages can be browsed at http://opam.ocaml.org/2.0-preview/ (please report issues <a href="https://github.com/ocaml/opam2web/issues">here</a>).</p>
<p>Installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc3">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc3#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>Thanks a lot for testing out this new RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find.</p>
|js}
  };
 
  { title = {js|opam 2.0.0 Release Candidate 2 is out!|js}
  ; slug = {js|opam-2-0-0-rc2|js}
  ; description = {js|???|js}
  ; date = {js|2018-05-22|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce the release of a second release candidate for opam 2.0.0.</p>
<p>This new version brings us very close to a final 2.0.0 release, and in addition to many fixes, features big performance enhancements over the RC1.</p>
<p>Among the new features, we have squeezed in full sandboxing of package commands for both Linux and macOS, to protect our users from any <a href="http://opam.ocaml.org/blog/camlp5-system/">misbehaving scripts</a>.</p>
<blockquote>
<p>NOTE: if upgrading manually from 2.0.0~rc, you need to run
<code>opam init --reinit -ni</code> to enable sandboxing.</p>
</blockquote>
<p>The new release candidate also offers the possibility to setup a hook in your shell, so that you won't need to run <code>eval $(opam env)</code> anymore. This is specially useful in combination with local switches, because with it enabled, you are guaranteed that running <code>make</code> from a project directory containing a local switch will use it.</p>
<p>The documentation has also been updated, and a preview of the opam 2 webpages can be browsed at http://opam.ocaml.org/2.0-preview/ (please report issues <a href="https://github.com/ocaml/opam2web/issues">here</a>). This provides the list of packages available for opam 2 (the <code>2.0</code> branch of <a href="https://github.com/ocaml/opam-repository/tree/2.0.0">opam-repository</a>), including the <a href="https://opam.ocaml.org/2.0-preview/packages/ocaml-base-compiler/">compiler packages</a>.</p>
<p>Installation instructions:</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc2">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc2#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>Thanks a lot for testing out this new RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|Urgent problem with camlp5 7.03 and macOS OCaml 4.06.1|js}
  ; slug = {js|camlp5-system|js}
  ; description = {js|???|js}
  ; date = {js|2018-05-04|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<h1>Packaging problem with opam-repository camlp5 7.03 when upgrading to OCaml 4.06.1</h1>
<p>Between 26 Oct 2017 and 17 Feb 2018, the OPAM package for camlp5 7.03 in <a href="https://github.com/ocaml/opam-repository">opam-repository</a> was under certain circumstances able to trigger <code>rm -rf /</code> on macOS and other systems which don't by default prevent recursive root deletion. This article contains advice on how to identify if your OPAM installation is affected and what you can do to fix it.</p>
<p>TL;DR If <code>rm --preserve-root</code> gives a message along the lines of <code>unrecognised option</code> rather than <code>missing operand</code> and you are running OPAM 1.2.2, ensure you run <code>opam update</code> <strong>before</strong> upgrading your system compiler to OCaml 4.06.1. If you have already upgraded <em>your system compiler</em> to OCaml 4.06.1 (e.g. with Homebrew) then please read on.</p>
<h2>Identifying whether you're affected</h2>
<p><strong>You are at serious risk of erasing all your files if the following three things are true:</strong></p>
<ul>
<li>Your system <code>rm</code> command does not support the <code>--preserve-root</code> default (you can identify this by running <code>rm --preserve-root</code> and noting whether the error message refers to an ‘unrecognised option’ rather than a ‘missing operand’)
</li>
<li>Your system OCaml compiler is 4.06.1 and you are using OPAM 1.2.2
</li>
<li>You have synchronised with opam-repository after 26 Oct 2017 but have not synchronised since 18 Feb 2018
</li>
</ul>
<p>If your system is affected, most OPAM commands cannot be run. In particular, if OPAM asks:</p>
<pre><code>dra@bionic:~$ opam update
Your system compiler has been changed. Do you want to upgrade your OPAM installation ? [Y/n] n
</code></pre>
<p><strong>YOU MUST ANSWER NO TO THIS QUESTION</strong>.</p>
<p>I have written a script which can safely identify if your system is affected, which can be reviewed on <a href="https://github.com/dra27/opam/blob/camlp5-detection/shell/opam-detect.sh">GitHub</a> or run directly by executing:</p>
<pre><code>$ curl -L https://raw.githubusercontent.com/dra27/opam/camlp5-detection/shell/opam-detect.sh | sh -
</code></pre>
<p>This script scans the directory identified by <code>$HOME</code> for anything which looks like an OPAM root. Virtually all users will have one OPAM root in <code>~/.opam</code> and if you don't know how to run OPAM with multiple roots, then you probably don't have any others to worry about!</p>
<p>The script may display a variety of messages. If your system contains at least one affected OPAM 1.2 root, you will see output like this:</p>
<pre><code>dra@bionic:~/opam$ shell/opam-detect.sh 
opam 1.2.2 found
Scanning /home/dra for opam roots...
opam 1.2 root found in /home/dra/.opam
camlp5 is faulty AND installed AND the system compiler is OCaml 4.06.1

THIS ROOT CANNOT BE UPDATED OR UPGRADED. DO NOT ALLOW OPAM TO UPGRADE THE SYSTEM
COMPILER. DOING SO WILL ATTEMPT TO ERASE YOUR MACHINE
Please see https://github.com/ocaml/opam/issues/3322 for more information
</code></pre>
<h2>Fixing it</h2>
<p>In all cases, one fix is to install the latest release candidate for opam 2, and upgrade your OPAM 1.2 root to opam 2 format. The upgrade prevents OPAM 1.2.2 from being able to read the root. If you received the message above and choose to upgrade to opam 2 (the easiest way to upgrade a root is to run <code>opam list</code> after installing opam 2) and then run the <code>opam-detect.sh</code> script again. As before, <strong>DO NOT ANSWER YES TO THE Your system compiler has changed. QUESTION IF YOU ARE ASKED</strong>.</p>
<p>If you do not wish to upgrade to opam 2, and there are many good reasons for not wanting to do this, there are two other possibilities. The easiest is to downgrade your system compiler back to 4.06.0 (or an earlier release). You can then run <code>opam-detect.sh</code> again and check the error message. As long as the message is no longer the one above, you can then run <code>opam update</code> to update the repository metadata on the switch. You can then upgrade your system compiler back to OCaml 4.06.1 again. To be absolutely sure, you can then run the <code>opam-detect.sh</code> script again and, assuming the message is still not the one above, you can then allow OPAM 1.2.2 to upgrade your system switch. <em>This is the recommended course of action.</em></p>
<p>The final option is that you can edit the opam root by hand and trick opam into believing that the camlp5 package is no longer installed. This is done by editing the file <code>system/installed</code> within the root and removing <strong>both</strong> the <code>camlp5</code> line and any package which depends on camlp5 (for example, <code>coq</code>). You cannot use the <code>opam</code> to determine dependencies at this stage, so you will need to use the online index to check for dependent packages. If you fail to remove all the packages which depend on camlp5, OPAM will display an installation prompt like this:</p>
<pre><code>dra@bionic:~$ opam update
Your system compiler has been changed. Do you want to upgrade your OPAM installation ? [Y/n] y

=-=- Upgrading system -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
The following actions will be performed:
  ∗  install camlp5        7.03               [required by coq]
  ∗  install conf-m4       1    
  ∗  install base-threads  base 
  ∗  install base-unix     base 
  ∗  install base-bigarray base 
  ∗  install ocamlfind     1.7.3
  ∗  install num           1.1  
  ∗  install coq           8.7.0
===== ∗  8 =====
Do you want to continue ? [Y/n] 
</code></pre>
<p>If this happens, answer no, but at this stage your system switch will have been emptied of all packages (you can now safely run <code>opam update</code> of course). Of course, you can back-up the OPAM root prior to trying this. Once upgraded, you can then run <code>opam update</code> and reinstall the missing packages. <strong>This course of action is not recommended as the <code>opam-detect.sh</code> script will no longer help. You are strongly advised to back up your files before attempting this solution</strong>.</p>
<h2>The problem</h2>
<p>On 26 Oct 2017, <a href="https://github.com/ocaml/opam-repository/pull/10523">PR#10523</a> was merged which packaged <a href="https://github.com/camlp5/camlp5">camlp5</a> 7.03. This was the first version of camlp5 released to opam which supported OCaml 4.06.0.</p>
<p>Unfortunately, it was also the first version of the opam package to include a <code>remove</code> section which executed <code>make uninstall</code>. The package also contained an incorrect <code>available</code> constraint - it should have permitted only OCaml 4.06.0 from the 4.06 branch, but the constraint given permitted all versions.</p>
<p>camlp5's <code>configure</code> script is responsible for writing <code>config/Makefile</code> with all the usual configuration settings, including <code>PREFIX</code> and so forth. This script includes a version check for OCaml and fails if the version is not supported. Unfortunately, even when it fails, it writes a partial <code>config/Makefile</code> to enable some development targets. Sadly this left the command <code>rm -rf &quot;$(DESTDIR)$(LIBDIR)/$(CAMLP5N)&quot;</code> in the <code>uninstall</code> target with all three variables undefined, leaving the certainly unwanted <code>rm -rf /</code>.</p>
<p>Users of GNU coreutils have, since November 2003 (in release 5.1.0) had the <code>--preserve-root</code> option set by default, which causes <code>rm -rf /</code> to raise an error. Unfortunately, macOS does not use GNU coreutils by default.</p>
<p>Prior to OPAM 1.2, the <code>build</code> and <code>install</code> sections of an <code>opam</code> file were combined. For this reason, if the <code>build</code> failed, OPAM would silently execute the <code>remove</code> commands in order to clean-up any partial installation which may have taken place. Although OPAM 1.2 recommended separating the <code>build</code> and <code>install</code> commands, this was not mandatory and it therefore retains the “silent remove” behaviour. opam 2 mandates the separation (and, if sandboxing is available, now enforces it). opam 2 also expects <code>remove</code> commands to be run in a clean source tree which, for this camlp5 case, means <strong>opam 2 users are UNAFFECTED by this issue</strong>.</p>
<p>OCaml 4.06.1 was added to opam-repository on 16 Feb 2018 in <a href="https://github.com/ocaml/opam-repository/pull/11433">PR#11433</a>. During the following 48 hours, it was noticed that the camlp5 package was attempting to run <code>rm -rf /</code> (see <a href="https://github.com/ocaml/opam-repository/issues/11440">Issue #11440</a>) and the package was patched on 18 Feb 2018 in <a href="https://github.com/ocaml/opam-repository/pull/11443">PR#11443</a>. Unfortunately, the signifance of the GNU coreutils protection was not realised at this point and it was also assumed that the problem would only be hit if one were unlucky enough to have updated OPAM between the release of OCaml 4.06.1 to opam-repository and the patching of camlp5 7.03 in opam-repository (so 16–18 February 2018) and it was on this basis that OPAM <a href="https://github.com/ocaml/opam/issues/3231">PR#3231</a> was deemed to have been very unlucky.</p>
<p>However, the real problem is the upgrading of the system compiler to 4.06.1, which wasn't noticed in that Issue but was correctly identified in <a href="https://github.com/ocaml/opam/issues/3316">Issue #3316</a>. This unfortunately gives a much wider window for the problem - if you ran <code>opam update</code> between 26 Oct 2017 and 18 Feb 2018 and haven't run it since, then your system will be at risk if you update your system compiler to OCaml 4.06.1 without first running <code>opam update</code>.</p>
<p>If the system compiler alters, OPAM 1.2.2 on virtually all commands (including <code>opam update</code>) first asks to upgrade the <code>system</code> switch. This step is mandatory, preventing further safe use of OPAM 1.2.2.</p>
<h2>Future mitigation</h2>
<p>Owing to the changes made to how opam 2 processes package installations, opam 2 has been unaffected by this situation but opam 2's lead developer <a href="https://github.com/AltGr">@AltGr</a> freely admits that this is more by luck than judgement. However, the second release candidate for opam 2 includes mandatory support for sandboxing on Linux and macOS. Sandboxing package building and installation will protect opam 2 against future issues of this kind, as a malfunctioning build system will be unable to operate on files outside its build directory or, during installation, switch root.</p>
|js}
  };
 
  { title = {js|opam 2.0.0 Release Candidate 1 is out!|js}
  ; slug = {js|opam-2-0-0-rc|js}
  ; description = {js|???|js}
  ; date = {js|2018-02-02|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are pleased to announce a first release candidate for the long-awaited opam 2.0.0.</p>
<p>A lot of polishing has been done since the <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/">last beta</a>, including tweaks to the built-in solver, allowing in-source package definitions to be gathered in an <code>opam/</code> directory, and much more.</p>
<p>With all of the 2.0.0 features getting pretty solid, we are now focusing on bringing all the guides up-to-date<a href="#foot-1">¹</a>, updating the tools and infrastructure, making sure there are no usability issues with the new workflows, and being future-proof so that further updates break as little as possible.</p>
<p>You are invited to read the <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/">beta5 announcement</a> for details on the 2.0.0 features. Installation instructions haven't changed:</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc">the Github &quot;Releases&quot; page</a> to your PATH.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc#opam---a-package-manager-for-ocaml">README</a>.</p>
</li>
</ol>
<p>Thanks a lot for testing out the RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find. See <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/#What-we-need-tested">what we need tested</a> for more detail.</p>
<hr />
<p><a id="foot-1">¹</a> You can at the moment rely on the <a href="http://opam.ocaml.org/doc/2.0/man/opam.html">manpages</a>, the <a href="http://opam.ocaml.org/doc/2.0/Manual.html">Manual</a>, and of course the <a href="http://opam.ocaml.org/doc/2.0/api/">API</a>, but other pages might be outdated.</p>
|js}
  };
 
  { title = {js|opam 2.0 Beta5 is out!|js}
  ; slug = {js|opam-2-0-beta5|js}
  ; description = {js|???|js}
  ; date = {js|2017-11-27|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>After a few more months brewing, we are pleased to announce a new beta release
of opam. With this new milestone, opam is reaching feature-freeze, with an
expected 2.0.0 by the beginning of next year.</p>
<p>This version brings many new features, stability fixes, and big improvements to
the local development workflows.</p>
<h2>What's new</h2>
<p>The features presented in past announcements:
<a href="http://opam.ocaml.org/blog/opam-local-switches/">local switches</a>,
<a href="http://opam.ocaml.org/blog/opam-install-dir/">in-source package definition handling</a>,
<a href="http://opam.ocaml.org/blog/opam-extended-dependencies/">extended dependencies</a>
are of course all present. But now, all the glue to make them interact nicely
together is here to provide new smooth workflows. For example, the following
command, if run from the source tree of a given project, creates a local switch
where it will restore a precise installation, including explicit versions of all
packages and pinnings:</p>
<pre><code>opam switch create ./ --locked
</code></pre>
<p>this leverages the presence of <code>opam.locked</code> or <code>&lt;name&gt;.opam.locked</code> files,
which are valid package definitions that contain additional details of the build
environment, and can be generated with the
<a href="https://github.com/AltGr/opam-lock"><code>opam-lock</code> plugin</a> (the <code>lock</code> command may
be merged into opam once finalised).</p>
<p>But this new beta also provides a large amount of quality of life improvements,
and other features. A big one, for example, is the integration of a built-in
solver (derived from <a href="http://www.i3s.unice.fr/~cpjm/misc/mccs.html"><code>mccs</code></a> and
<a href="https://www.gnu.org/software/glpk/"><code>glpk</code></a>). This means that the <code>opam</code> binary
works out-of-the box, without requiring the external
<a href="https://www.cs.uni-potsdam.de/wv/aspcud/"><code>aspcud</code></a> solver, and on all
platforms. It is also faster.</p>
<p>Another big change is that detection of architecture and OS details is now done
in opam, and can be used to select the external dependencies with the new format
of the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-depexts"><code>depexts:</code></a>
field, but also to affect dependencies or build flags.</p>
<p>There is much more to it. Please see the
<a href="https://github.com/ocaml/opam/blob/2.0.0-beta5/CHANGES">changelog</a>, and the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html">updated manual</a>.</p>
<h2>How to try it out</h2>
<p>Our warm thanks for trying the new beta and
<a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may hit.</p>
<p>There are three main ways to get the update:</p>
<ol>
<li>
<p>The easiest is to use our pre-compiled binaries.
<a href="https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh">This script</a>
will also make backups if you migrate from 1.x, and has an option to revert
back:</p>
<pre><code>sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>This uses the binaries from https://github.com/ocaml/opam/releases/tag/2.0.0-beta5</p>
</li>
<li>
<p>Another option is to compile from source, using an existing opam
installation. Simply run:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>and follow the instructions (you will need to copy the compiled binary to
your PATH).</p>
</li>
<li>
<p>Compiling by hand from the
<a href="https://github.com/ocaml/opam/releases/download/2.0.0-beta5/opam-full-2.0.0-beta5.tar.gz">inclusive source archive</a>,
or from the <a href="https://github.com/ocaml/opam/tree/2.0.0-beta5">git repo</a>. Use
<code>./configure &amp;&amp; make lib-ext &amp;&amp; make</code> if you have OCaml &gt;= 4.02.3 already
available; <code>make cold</code> otherwise.</p>
<p>If the build fails after updating a git repo from a previous version, try
<code>git clean -fdx src/</code> to remove any stale artefacts.</p>
</li>
</ol>
<p>Note that the repository format is different from that of opam 1.2. Opam 2 will
be automatically redirected from the
<a href="https://github.com/ocaml/opam-repository">opam-repository</a> to an automatically
rewritten 2.0 mirror, and is otherwise able to do the conversion on the fly
(both for package definitions when pinning, and for whole repositories). You may
not yet contribute packages in 2.0 format to opam-repository, though.</p>
<h2>What we need tested</h2>
<p>We are interested in all opinions and reports, but here are a few areas where
your feedback would be specially useful to us:</p>
<ul>
<li>Use 2.0 day-to-day, in particular check any packages you may be maintaining.
We would like to ensure there are no regressions due to the rewrite from 1.2
to 2.0.
</li>
<li>Check the quality of the solutions provided by the solver (or conflicts, when
applicable).
</li>
<li>Test the different pinning mechanisms (rsync, git, hg, darcs) with your
project version control systems. See the <code>--working-dir</code> option.
</li>
<li>Experiment with local switches for your project (and/or <code>opam install DIR</code>).
Give us feedback on the workflow. Use <code>opam lock</code> and share development
environments.
</li>
<li>If you have any custom repositories, please try the conversion to 2.0 format
with <code>opam admin upgrade --mirror</code> on them, and use the generated mirror.
</li>
<li>Start porting your CI systems for larger projects to use opam 2, and give us
feedback on any improvements you need for automated scripting (e.g. the
<code>--json</code> output).
</li>
</ul>
|js}
  };
 
  { title = {js|Deprecating opam 1.2.0|js}
  ; slug = {js|deprecating-opam-1-2-0|js}
  ; description = {js|???|js}
  ; date = {js|2017-06-14|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>Opam 1.2.0 will be actively deprecated in favour of opam 1.2.2, which now becomes
the only supported stable release.</p>
<h3>Why deprecate opam 1.2.0</h3>
<p>OPAM 1.2.0 was released in October 2014, and saw rapid uptake from the
community. We did some rapid bugfixing to solve common problems, and OPAM 1.2.2
was released in April 2015. Since then, 1.2.2 has been a very solid release and
has been the stable version in use to date.</p>
<p>Unfortunately, part of the bugfixes in the 1.2.2 series resulted in an <code>opam</code>
file format that is not fully backwards compatible with the 1.2.0 syntax, and
the net effect is that users of 1.2.0 now see a broken package repository. Our
CI tests for new packages regularly fail on 1.2.0, even if they succeed on 1.2.2
and higher.</p>
<p>As we prepare the plan for <a href="https://github.com/ocaml/opam/issues/2918">1.2.2 -&gt; 2.0
migration</a>, it is clear that we need
a &quot;one-in one-out&quot; policy on releases in order to preserve the overall health of
the package repository -- maintaining three separate releases and formats of the
repository is not practical. Therefore the 1.2.0 release needs to be actively
deprecated, and we could use some help from the community to make this happen.</p>
<h3>Who is still using opam 1.2.0?</h3>
<p>I found that the Debian Jessie (stable) release includes 1.2.0, and this is
probably the last major distribution including it. The <a href="https://wiki.debian.org/DebianStretch">Debian
Stretch</a> is due to become the stable
release on the 17th June 2017, and so at that point there will hopefully be no
distributions actively sending opam 1.2.0 out.</p>
<h3>How do we deprecate it?</h3>
<p>The format changes, although small, would cause errors on 1.2.0 users with the
main repository. To avoid those, as was done for 1.1.0, we are going to redirect
users of 1.2.0 to a frozen mirror of the repository, making new package updates
unavailable to them.</p>
<p>If there are any remaining users of opam 1.2.0, particularly industrial ones, please reach
out (<em>e.g.</em> on <a href="https://github.com/ocaml/opam-repository/issues">Github</a>). By
performing an active deprecation of an older release, we hope we can focus our
efforts on ensuring the opam users have a good out-of-the-box experience with
opam 1.2.2 and the forthcoming opam 2.0.</p>
<p>Please also see the <a href="https://discuss.ocaml.org/t/rfc-deprecating-opam-1-2-0/332">discussion thread</a>
regarding the deprecation on the OCaml Discourse forums.</p>
|js}
  };
 
  { title = {js|new opam features: more expressive dependencies|js}
  ; slug = {js|opam-extended-dependencies|js}
  ; description = {js|???|js}
  ; date = {js|2017-05-11|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>This blog will cover yet another aspect of the improvements opam 2.0 has over opam 1.2. I may be a little more technical than previous issues, as it covers a feature directed specifically at packagers and repository maintainers, and regarding the package definition format.</p>
<h3>Specifying dependencies in opam 1.2</h3>
<p>Opam 1.2 already has an advanced way of specifying package dependencies, using formulas on packages and versions, with the following syntax:</p>
<pre><code>depends: [
  &quot;foo&quot; {&gt;= &quot;3.0&quot; &amp; &lt; &quot;4.0~&quot;}
  ( &quot;bar&quot; | &quot;baz&quot; {&gt;= &quot;1.0&quot;} )
]
</code></pre>
<p>meaning that the package being defined depends on both package <code>foo</code>, within the <code>3.x</code> series, and one of <code>bar</code> or <code>baz</code>, the latter with version at least <code>1.0</code>. See <a href="https://opam.ocaml.org/doc/Manual.html#PackageFormulas">here</a> for a complete documentation.</p>
<p>This only allows, however, dependencies that are static for a given package.</p>
<p>Opam 1.2 introduced <code>build</code>, <code>test</code> and <code>doc</code> &quot;dependency flags&quot; that could provide some specifics for dependencies (<em>e.g.</em> <code>test</code> dependencies would only be needed when tests were requested for the package). These were constrained to appear before the version constraints, <em>e.g.</em> <code>&quot;foo&quot; {build &amp; doc &amp; &gt;= &quot;3.0&quot;}</code>.</p>
<h3>Extensions in opam 2.0</h3>
<p>Opam 2.0 generalises the dependency flags, and makes the dependencies specification more expressive by allowing to mix <em>filters</em>, <em>i.e.</em> formulas based on opam variables, with the version constraints. If that formula holds, the dependency is enforced, if not, it is discarded.</p>
<p>This is documented in more detail <a href="https://opam.ocaml.org/doc/2.0/Manual.html#Filteredpackageformulas">in the opam 2.0 manual</a>.</p>
<p>Note also that, since the compilers are now packages, the required OCaml version is now expressed using this mechanism as well, through a dependency to the (virtual) package <code>ocaml</code>, <em>e.g.</em> <code>depends: [ &quot;ocaml&quot; {&gt;= &quot;4.03.0&quot;} ]</code>. This replaces uses of the <code>available:</code> field and <code>ocaml-version</code> switch variable.</p>
<h4>Conditional dependencies</h4>
<p>This makes it trivial to add, for example, a condition on the OS to a given dependency, using the built-in variable <code>os</code>:</p>
<pre><code>depends: [ &quot;foo&quot; {&gt;= &quot;3.0&quot; &amp; &lt; &quot;4.0~&quot; &amp; os = &quot;linux&quot;} ]
</code></pre>
<p>here, <code>foo</code> is simply not needed if the OS isn't Linux. We could also be more specific about other OSes using more complex formulas:</p>
<pre><code>depends: [
  &quot;foo&quot; { &quot;1.0+linux&quot; &amp; os = &quot;linux&quot; |
          &quot;1.0+osx&quot; &amp; os = &quot;darwin&quot; }
  &quot;bar&quot; { os != &quot;osx&quot; &amp; os != &quot;darwin&quot; }
]
</code></pre>
<p>Meaning that Linux and OSX require <code>foo</code>, respectively versions <code>1.0+linux</code> and <code>1.0+osx</code>, while other systems require <code>bar</code>, any version.</p>
<h4>Dependency flags</h4>
<p>Dependency flags, as used in 1.2, are no longer needed, and are replaced by variables that can appear anywhere in the version specification. The following variables are typically useful there:</p>
<ul>
<li><code>with-test</code>, <code>with-doc</code>: replace the <code>test</code> and <code>doc</code> dependency flags, and are <code>true</code> when the package's tests or documentation have been requested
</li>
<li>likewise, <code>build</code> behaves similarly as before, limiting the dependency to a &quot;build-dependency&quot;, implying that the package won't need to be rebuilt if the dependency changes
</li>
<li><code>dev</code>: this boolean variable holds <code>true</code> on &quot;development&quot; packages, that is, packages that are bound to a non-stable source (a version control system, or if the package is pinned to an archive without known checksum). <code>dev</code> sources often happen to need an additional preliminary step (e.g. <code>autoconf</code>), which may have its own dependencies.
</li>
</ul>
<p>Use <code>opam config list</code> for a list of pre-defined variables. Note that the <code>with-test</code>, <code>with-doc</code> and <code>build</code> variables are not available everywhere: the first two are allowed only in the <code>depends:</code>, <code>depopts:</code>, <code>build:</code> and <code>install:</code> fields, and the latter is specific to the <code>depends:</code> and <code>depopts:</code> fields.</p>
<p>For example, the <code>datakit.0.9.0</code> package has:</p>
<pre><code>depends: [
  ...
  &quot;datakit-server&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-client&quot; {with-test &amp; &gt;= &quot;0.9.0&quot;}
  &quot;datakit-github&quot; {with-test &amp; &gt;= &quot;0.9.0&quot;}
  &quot;alcotest&quot; {with-test &amp; &gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>When running <code>opam install datakit.0.9.0</code>, the <code>with-test</code> variable is set to <code>false</code>, and the <code>datakit-client</code>, <code>datakit-github</code> and <code>alcotest</code> dependencies are filtered out: they won't be required. With <code>opam install datakit.0.9.0 --with-test</code>, the <code>with-test</code> variable is true (for that package only, tests on packages not listed on the command-line are not enabled!). In this case, the dependencies resolve to:</p>
<pre><code>depends: [
  ...
  &quot;datakit-server&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-client&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;datakit-github&quot; {&gt;= &quot;0.9.0&quot;}
  &quot;alcotest&quot; {&gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>which is treated normally.</p>
<h4>Computed versions</h4>
<p>It is also possible to use variables, not only as conditions, but to compute the version values: <code>&quot;foo&quot; {= var}</code> is allowed and will require the version of package <code>foo</code> corresponding to the value of variable <code>var</code>.</p>
<p>This is useful, for example, to define a family of packages, which are released together with the same version number: instead of having to update the dependencies of each package to match the common version at each release, you can leverage the <code>version</code> package-variable to mean &quot;that other package, at the same version as current package&quot;. For example, <code>foo-client</code> could have the following:</p>
<pre><code>depends: [ &quot;foo-core&quot; {= version} ]
</code></pre>
<p>It is even possible to use variable interpolations within versions, <em>e.g.</em> specifying an os-specific version differently than above:</p>
<pre><code>depends: [ &quot;foo&quot; {= &quot;1.0+%{os}%&quot;} ]
</code></pre>
<p>this will expand the <code>os</code> variable, resolving to <code>1.0+linux</code>, <code>1.0+darwin</code>, etc.</p>
<p>Getting back to our <code>datakit</code> example, we could leverage this and rewrite it to the more generic:</p>
<pre><code>depends: [
  ...
  &quot;datakit-server&quot; {&gt;= version}
  &quot;datakit-client&quot; {with-test &amp; &gt;= version}
  &quot;datakit-github&quot; {with-test &amp; &gt;= version}
  &quot;alcotest&quot; {with-test &amp; &gt;= &quot;0.7.0&quot;}
]
</code></pre>
<p>Since the <code>datakit-*</code> packages follow the same versioning, this avoids having to rewrite the opam file on every new version, with a risk of error each time.</p>
<p>As a side note, these variables are consistent with what is now used in the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build"><code>build:</code></a> field, and the <a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-build-test"><code>build-test:</code></a> field is now deprecated. So this other part of the same <code>datakit</code> opam file:</p>
<pre><code>build:
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;false&quot;]
build-test: [
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;true&quot;]
  [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;test&quot;]
]
</code></pre>
<p>would now be preferably written as:</p>
<pre><code>build: [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;build&quot; &quot;--pinned&quot; &quot;%{pinned}%&quot; &quot;--tests&quot; &quot;%{with-test}%&quot;]
run-test: [&quot;ocaml&quot; &quot;pkg/pkg.ml&quot; &quot;test&quot;]
</code></pre>
<p>which avoids building twice just to change the options.</p>
<h4>Conclusion</h4>
<p>Hopefully this extension to expressivity in dependencies will make the life of packagers easier; feedback is welcome on your personal use-cases.</p>
<p>Note that the official repository is still in 1.2 format (served as 2.0 at <code>https://opam.ocaml.org/2.0</code>, through automatic conversion), and will only be migrated a little while after opam 2.0 is finally released. You are welcome to experiment on custom repositories or pinned packages already, but will need a little more patience before you can contribute package definitions making use of the above to the <a href="https://github.com/ocaml/opam-repository">official repository</a>.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|new opam features: "opam install <dir>"|js}
  ; slug = {js|opam-install-dir|js}
  ; description = {js|???|js}
  ; date = {js|2017-05-04|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>After the <a href="../opam-build">opam build</a> feature was announced followed a lot of discussions, mainly having to do with its interface, and misleading name. The base features it offered, though, were still widely asked for:</p>
<ul>
<li>a way to work directly with the project in the current directory, assuming it contains definitions for one or more packages
</li>
<li>a way to copy the installed files of a package below a specified <code>destdir</code>
</li>
<li>an easier way to get started hacking on a project, even without an initialised opam
</li>
</ul>
<h3>Status of <code>opam build</code></h3>
<p><code>opam build</code>, as described in a <a href="../opam-build">previous post</a> has been dropped. It will be absent from the next Beta, where the following replaces it.</p>
<h3>Handling a local project</h3>
<p>Consistently with what was done with local switches, it was decided, where meaningful, to overload the <code>&lt;packages&gt;</code> arguments of the commands, allowing directory names instead, and meaning &quot;all packages defined there&quot;, with some side-effects.</p>
<p>For example, the following command is now allowed, and I believe it will be extra convenient to many:</p>
<pre><code>opam install . --deps-only
</code></pre>
<p>What this does is find <code>opam</code> (or <code>&lt;pkgname&gt;.opam</code>) files in the current directory (<code>.</code>), resolve their installations, and install all required packages. That should be the single step before running the source build by hand.</p>
<p>The following is a little bit more complex:</p>
<pre><code>opam install .
</code></pre>
<p>This also retrieves the packages defined at <code>.</code>, <strong>pins them</strong> to the current source (using version-control if present), and installs them. Note that subsequent runs actually synchronise the pinnings, so that packages removed or renamed in the source tree are tracked properly (<em>i.e.</em> removed ones are unpinned, new ones pinned, the other ones upgraded as necessary).</p>
<p><code>opam upgrade</code>, <code>opam reinstall</code>, and <code>opam remove</code> have also been updated to handle directories as arguments, and will work on &quot;all packages pinned to that target&quot;, <em>i.e.</em> the packages pinned by the previous call to <code>opam install &lt;dir&gt;</code>. In addition, <code>opam remove &lt;dir&gt;</code> unpins the packages, consistently reverting the converse <code>install</code> operation.</p>
<p><code>opam show</code> already had a <code>--file</code> option, but has also been extended in the same way, for consistency and convenience.</p>
<p>This all, of course, works well with a local switch at <code>./</code>, but the two features can be used completely independently. Note also that the directory name must be made unambiguous with a possible package name, so make sure to use <code>./foo</code> rather than just <code>foo</code> for a local project in subdirectory <code>foo</code>.</p>
<h3>Specifying a destdir</h3>
<p>This relies on installed files tracking, but was actually independent from the other <code>opam build</code> features. It is now simply a new option to <code>opam install</code>:</p>
<pre><code>opam install foo --destdir ~/local/
</code></pre>
<p>will install <code>foo</code> normally (if it isn't installed already) and copy all its installed files, following the same hierarchy, into <code>~/local</code>. <code>opam remove --destdir</code> is also supported, to remove these files.</p>
<h3>Initialising</h3>
<p>Automatic initialisation has been dropped for the moment. It was only saving one command (<code>opam init</code>, that opam will kindly print out for you if you forget it), and had two drawbacks:</p>
<ul>
<li>some important details (like shell setup for opam) were skipped
</li>
<li>the initialisation options were much reduced, so you would often have to go back to <code>opam init</code> anyway. The other possibility being to duplicate <code>init</code> options to all commands, adding lots of noise. Keeping things separate has its merits.
</li>
</ul>
<p>Granted, another command, <code>opam switch create .</code>, was made implicit. But using a local switch is a user choice, and worse, in contradiction with the previous de facto opam default, so not creating one automatically seems safer: having to specify <code>--no-autoinit</code> to <code>opam build</code> in order to get the more simple behaviour was inconvenient and error-prone.</p>
<p>One thing is provided to help with initialisation, though: <code>opam switch create &lt;dir&gt;</code> has been improved to handle package definitions at <code>&lt;dir&gt;</code>, and will use them to choose a compatible compiler, as <code>opam build</code> did. This avoids the frustration of creating a switch, then finding out that the package wasn't compatible with the chosen compiler version, and having to start over with an explicit choice of a different compiler.</p>
<p>If you would really like automatic initialisation, and have a better interface to propose, your feedback is welcome!</p>
<h3>More related options</h3>
<p>A few other new options have been added to <code>opam install</code> and related commands, to improve the project-local workflows:</p>
<ul>
<li><code>opam install --keep-build-dir</code> is now complemented with <code>--reuse-build-dir</code>, for incremental builds within opam (assuming your build-system supports it correctly). At the moment, you should specify both on every upgrade of the concerned packages, or you could set the <code>OPAMKEEPBUILDDIR</code> and <code>OPAMREUSEBUILDDIR</code> environment variables.
</li>
<li><code>opam install --inplace-build</code> runs the scripts directly within the source dir instead of a dedicated copy. If multiple packages are pinned to the same directory, this disables parallel builds of these packages.
</li>
<li><code>opam install --working-dir</code> uses the working directory state of your project, instead of the state registered in the version control system. Don't worry, opam will warn you if you have uncommitted changes and forgot to specify <code>--working-dir</code>.
</li>
</ul>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|new opam features: local switches|js}
  ; slug = {js|opam-local-switches|js}
  ; description = {js|???|js}
  ; date = {js|2017-04-27|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>Among the areas we wanted to improve on for opam 2.0 was the handling of
<em>switches</em>. In opam 1.2, they are simply accessed by a name (the OCaml version
by default), and are always stored into <code>~/.opam/&lt;name&gt;</code>. This is fine, but can
get a bit cumbersome when many switches are in presence, as there is no way to
sort them or associate them with a given project.</p>
<blockquote>
<h3>A reminder about <em>switches</em></h3>
<p>For those unfamiliar with it, switches, in opam, are independent prefixes with
their own compiler and set of installed packages. The <code>opam switch</code> command
allows to create and remove switches, as well as select the currently active
one, where operations like <code>opam install</code> will operate.</p>
<p>Their uses include easily juggling between versions of OCaml, or of a library,
having incompatible packages installed separately but at the same time, running
tests without damaging your &quot;main&quot; environment, and, quite often, separation of
environment for working on different projects.</p>
<p>You can also select a specific switch for a single command, with</p>
<pre><code>opam install foo --switch other
</code></pre>
<p>or even for a single shell session, with</p>
<pre><code>eval $(opam env --switch other)
</code></pre>
</blockquote>
<p>What opam 2.0 adds to this is the possibility to create so-called <em>local
switches</em>, stored below a directory of your choice. This gets users back in
control of how switches are organised, and wiping the directory is a safe way to
get rid of the switch.</p>
<h3>Using within projects</h3>
<p>This is the main intended use: the user can define a switch within the source of
a project, for use specifically in that project. One nice side-effect to help
with this is that, if a &quot;local switch&quot; is detected in the current directory or a
parent, opam will select it automatically. Just don't forget to run <code>eval $(opam env)</code> to make the environment up-to-date before running <code>make</code>.</p>
<h3>Interface</h3>
<p>The interface simply overloads the <code>switch-name</code> arguments, wherever they were
present, allowing directory names instead. So for example:</p>
<pre><code>cd ~/src/project
opam switch create ./
</code></pre>
<p>will create a local switch in the directory <code>~/src/project</code>. Then, it is for
example equivalent to run <code>opam list</code> from that directory, or <code>opam list --switch=~/src/project</code> from anywhere.</p>
<p>Note that you can bypass the automatic local-switch selection if needed by using
the <code>--switch</code> argument, by defining the variable <code>OPAMSWITCH</code> or by using <code>eval $(opam env --switch &lt;name&gt;)</code></p>
<h3>Implementation</h3>
<p>In practice, the switch contents are placed in a <code>_opam/</code> subdirectory. So if
you create the switch <code>~/src/project</code>, you can browse its contents at
<code>~/src/project/_opam</code>. This is the direct prefix for the switch, so e.g.
binaries can be found directly at <code>_opam/bin/</code>: easier than searching the opam
root! The opam metadata is placed below that directory, in a <code>.opam-switch/</code>
subdirectory.</p>
<p>Local switches still share the opam root, and in particular depend on the
repositories defined and cached there. It is now possible, however, to select
different repositories for different switches, but that is a subject for another
post.</p>
<p>Finally, note that removing that <code>_opam</code> directory is handled transparently by
opam, and that if you want to share a local switch between projects, symlinking
the <code>_opam</code> directory is allowed.</p>
<h3>Current status</h3>
<p>This feature has been present in our dev builds for a while, and you can already
use it in the
<a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta2">current beta</a>.</p>
<h3>Limitations and future extensions</h3>
<p>It is not, at the moment, possible to move a local switch directory around,
mainly due to issues related to relocating the OCaml compiler.</p>
<p>Creating a new switch still implies to recompile all the packages, and even the
compiler itself (unless you rely on a system installation). The projected
solution is to add a build cache, avoiding the need to recompile the same
package with the same dependencies. This should actually be possible with the
current opam 2.0 code, by leveraging the new hooks that are made available. Note
that relocation of OCaml is also an issue for this, though.</p>
<p>Editing tools like <code>ocp-indent</code> or <code>merlin</code> can also become an annoyance with
the multiplication of switches, because they are not automatically found if not
installed in the current switch. But the <code>user-setup</code> plugin (run <code>opam user-setup install</code>) already handles this well, and will access <code>ocp-indent</code> or
<code>tuareg</code> from their initial switch, if not found in the current one. You will
still need to install tools that are tightly bound to a compiler version, like
<code>merlin</code> and <code>ocp-index</code>, in the switches where you need them, though.</p>
<blockquote>
<p>NOTE: this article is cross-posted on
<a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and
<a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the
latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|new opam features: "opam build"|js}
  ; slug = {js|opam-build|js}
  ; description = {js|???|js}
  ; date = {js|2017-03-16|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<blockquote>
<p>UPDATE: after discussions following this post, this feature was abandoned with
the interface presented below. See <a href="../opam-install-dir">this post</a> for
the details and the new interface!</p>
</blockquote>
<p>The new opam 2.0 release, currently in beta, introduces several new features.
This post gets into some detail on the new <code>opam build</code> command, its purpose,
its use, and some implementation aspects.</p>
<p><strong><code>opam build</code> is run from the source tree of a project, and does not rely on a
pre-existing opam installation.</strong> As such, it adds a new option besides the
existing workflows based on managing shared OCaml installations in the form of
switches.</p>
<h3>What does it do ?</h3>
<p>Typically, this is used in a fresh git clone of some OCaml project. Like when
pinning the package, opam will find and leverage package definitions found in
the source, in the form of <code>opam</code> files.</p>
<ul>
<li>if opam hasn't been initialised (no <code>~/.opam</code>), this is taken care of.
</li>
<li>if no switch is otherwise explicitely selected, a <em>local switch</em> is used, and
created if necessary (<em>i.e.</em> in <code>./_opam/</code>)
</li>
<li>the metadata for the current project is registered, and the package installed
after its dependencies, as opam usually does
</li>
</ul>
<p>This is particularly useful for <strong>distributing projects</strong> to people not used to
opam and the OCaml ecosystem: the setup steps are automatically taken care of,
and a single <code>opam build</code> invocation can take care of resolving the dependency
chains for your package.</p>
<p>If building the project directly is preferred, adding <code>--deps-only</code> is a good
way to get the dependencies ready for the project:</p>
<pre><code>opam build --deps-only
eval $(opam config env)
./configure; make; etc.
</code></pre>
<p>Note that if you just want to handle project-local opam files, <code>opam build</code> can
also be used in your existing switches: just specify <code>--no-autoinit</code>, <code>--switch</code>
or make sure the <code>OPAMSWITCH</code> variable is set. <em>E.g.</em> <code>opam build --no-autoinit --deps-only</code> is a convenient way to get the dependencies for the local project
ready in your current switch.</p>
<h3>Additional functions</h3>
<h4>Installation</h4>
<p>The installation of the packages happens as usual to the prefix corresponding to
the switch used (<code>&lt;project-root&gt;/_opam/</code> for a local switch). But it is
possible, with <code>--install-prefix</code>, to further install the package to the system:</p>
<pre><code>opam build --install-prefix ~/local
</code></pre>
<p>will install the results of the package found in the current directory below
~/local.</p>
<p>The dependencies of the package won't be installed, so this is intended for
programs, assuming they are relocatable, and not for libraries.</p>
<h4>Choosing custom repositories</h4>
<p>The user can pre-select the repositories to use on the creation of the local
switch with:</p>
<pre><code>opam build --repositories &lt;repos&gt;
</code></pre>
<p>where <code>&lt;repos&gt;</code> is a comma-separated list of repositories, specified either as
<code>name=URL</code>, or <code>name</code> if already configured on the system.</p>
<h4>Multiple packages</h4>
<p>Multiple packages are commonly found to share a single repository. In this case,
<code>opam build</code> registers and builds all of them, respecting cross-dependencies.
The opam files to use can also be explicitely selected on the command-line.</p>
<p>In this case, specific opam files must be named <code>&lt;package-name&gt;.opam</code>.</p>
<h3>Implementation details</h3>
<p>The choice of the compiler, on automatic initialisation, is either explicit,
using the <code>--compiler</code> option, or automatic. In the latter case, the default
selection is used (see <code>opam init --help</code>, section &quot;CONFIGURATION FILE&quot; for
details), but a compiler compatible with the local packages found is searched
from that. This allows, for example, to choose a system compiler when available
and compatible, avoiding a recompilation of OCaml.</p>
<p>When using <code>--install-prefix</code>, the normal installation is done, then the
tracking of package-installed files, introduced in opam 2.0, is used to extract
the installed files from the switch and copy them to the prefix.</p>
<p>The packages installed through <code>opam build</code> are not registered in any
repository, and this is not an implicit use of <code>opam pin</code>: the rationale is that
packages installed this way will also be updated by repeating <code>opam build</code>. This
means that when using other commands, <em>e.g.</em> <code>opam upgrade</code>, opam won't try to
keep the packages to their local, source version, and will either revert them to
their repository definition, or remove them, if they need recompilation.</p>
<h3>Planned extensions</h3>
<p>This is still in beta: there are still rough edges, please experiment and give
feedback! It is still possible that the command syntax and semantics change
significantly before release.</p>
<p>Another use-case that we are striving to improve is sharing of development
setups (share sets of pinned packages, depend on specific remotes or git hashes,
etc.). We have <a href="https://github.com/ocaml/opam/issues/2762">many</a>
<a href="https://github.com/ocaml/opam/issues/2495">ideas</a> to
<a href="https://github.com/ocaml/opam/issues/1734">improve</a> on this, but <code>opam build</code>
is not, as of today, a direct solution to this. In particular, installing this
way still relies on the default opam repository; a way to define specific
options for the switch that is implicitely created on <code>opam build</code> is in the
works.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="http://www.ocamlpro.com/category/blog/">ocamlpro.com</a>. Please head to the latter for the comments!</p>
</blockquote>
|js}
  };
 
  { title = {js|opam 2.0 Beta is out!|js}
  ; slug = {js|opam-2-0-beta|js}
  ; description = {js|???|js}
  ; date = {js|2017-02-09|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<blockquote>
<p>UPDATE (2017-02-14): A beta2 is online, which fixes issues and performance of
the <code>opam build</code> command. Get the new
<a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta2">binaries</a>, or
recompile the <a href="http://opam.ocaml.org/packages/opam-devel/">opam-devel</a> package
and replace the previous binary.</p>
</blockquote>
<p>We are pleased to announce that the beta release of opam 2.0 is now live! You
can try it already, bootstrapping from a working 1.2 opam installation, with:</p>
<pre><code>opam update; opam install opam-devel
</code></pre>
<p>With about a thousand patches since the last stable release, we took the time to
gather feedback after <a href="../opam-2-0-preview">our last announcement</a> and
implemented a couple of additional, most-wanted features:</p>
<ul>
<li>An <code>opam build</code> command that, from the root of a source tree containing one
or more package definitions, can automatically handle initialisation and
building of the sources in a local switch.
</li>
<li>Support for
<a href="https://github.com/hannesm/conex-paper/raw/master/paper.pdf">repository signing</a>
through the external <a href="https://github.com/hannesm/conex">Conex</a> tool, being
developed in parallel.
</li>
</ul>
<p>There are many more features, like the new <code>opam clean</code> and <code>opam admin</code>
commands, a new archive caching system, etc., but we'll let you check the full
<a href="https://github.com/ocaml/opam/blob/2.0.0-beta/CHANGES">changelog</a>.</p>
<p>We also improved still on the
<a href="../opam-2-0-preview/#Afewhighlights">already announced features</a>, including
compilers as packages, local switches, per-switch repository configuration,
package file tracking, etc.</p>
<p>The updated documentation is at http://opam.ocaml.org/doc/2.0/. If you are
developing in opam-related tools, you may also want to browse the
<a href="https://opam.ocaml.org/doc/2.0/api/index.html">new APIs</a>.</p>
<h2>Try it out</h2>
<p>Please try out the beta, and report any issues or missing features. You can:</p>
<ul>
<li>Build it from source in opam, as shown above (<code>opam install opam-devel</code>)
</li>
<li>Use the <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta">pre-built binaries</a>.
</li>
<li>Building from the source tarball:
<a href="https://github.com/ocaml/opam/releases/download/2.0.0-beta/opam-full-2.0.0-beta.tar.gz">download here</a>
and build using <code>./configure &amp;&amp; make lib-ext &amp;&amp; make</code> if you have OCaml &gt;=
4.01 already available; <code>make cold</code> otherwise
</li>
<li>Or directly from the
<a href="https://github.com/ocaml/opam/tree/2.0.0-beta">git tree</a>, following the
instructions included in the README. Some files have been moved around, so if
your build fails after you updated an existing git clone, try to clean it up
(<code>git clean -dx</code>).
</li>
</ul>
<p>Some users have been using the alpha for the past months without problems, but
you may want to keep your opam 1.2 installation intact until the release is out.
An easy way to do this is with an alias:</p>
<pre><code>alias opam2=&quot;OPAMROOT=~/.opam2 path/to/opam-2-binary&quot;
</code></pre>
<h2>Changes to be aware of</h2>
<h3>Command-line interface</h3>
<ul>
<li><code>opam switch create</code> is now needed to create new switches, and <code>opam switch</code>
is now much more expressive
</li>
<li><code>opam list</code> is also much more expressive, but be aware that the output may
have changed if you used it in scripts
</li>
<li>new commands:
<ul>
<li><code>opam build</code>: setup and build a local source tree
</li>
<li><code>opam clean</code>: various cleanup operations (wiping caches, etc.)
</li>
<li><code>opam admin</code>: manage software repositories, including upgrading them to
opam 2.0 format (replaces the <code>opam-admin</code> tool)
</li>
<li><code>opam env</code>, <code>opam exec</code>, <code>opam var</code>: shortcuts for the <code>opam config</code> subcommands
</li>
</ul>
</li>
<li><code>opam repository add</code> will now setup the new repository for the current switch
only, unless you specify <code>--all</code>
</li>
<li>Some flags, like <code>--test</code>, now apply to the packages listed on the
command-line only. For example, <code>opam install lwt --test</code> will build and
install lwt and all its dependencies, but only build/run the tests of the
<code>lwt</code> package. Test-dependencies of its dependencies are also ignored
</li>
<li>The new <code>opam install --soft-request</code> is useful for batch runs, it will
maximise the installed packages among the requested ones, but won't fail if
all can't be installed
</li>
</ul>
<p>As before, opam is self-documenting, so be sure to check <code>opam COMMAND --help</code>
first when in doubt. The bash completion scripts have also been thoroughly
improved, and may help navigating the new options.</p>
<h3>Metadata</h3>
<p>There are both a few changes (extensions, mostly) to the package description
format, and more drastic changes to the repository format, mainly related to
translating the old compiler definitions into packages.</p>
<ul>
<li>opam will automatically update, internally, definitions of pinned packages as
well as repositories in the 1.2 format
</li>
<li>however, it is faster to use repositories in the 2.0 format directly. To that
end, please use the <code>opam admin upgrade</code> command on your repositories. The
<code>--mirror</code> option will create a 2.0 mirror and put in place proper
redirections, allowing your original repository to retain the old format
</li>
</ul>
<p>The official opam repository at https://opam.ocaml.org remains in 1.2 format for
now, but has a live-updated 2.0 mirror to which you should be automatically
redirected. It cannot yet accept package definitions in 2.0 format.</p>
<h4>Package format</h4>
<ul>
<li>Any <code>available:</code> constraints based on the OCaml compiler version should be
rewritten into dependencies to the <code>ocaml</code> package
</li>
<li>Separate <code>build:</code> and <code>install:</code> instructions are now required
</li>
<li>It is now preferred to include the old <code>url</code> and <code>descr</code> files (containing the
archive URL and package description) in the <code>opam</code> file itself: (see the new
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-synopsis"><code>synopsis:</code></a>
and
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamfield-description"><code>description:</code></a>
fields, and the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opamsection-url">url {}</a> file
section)
</li>
<li>Building tests and documentation should now be part of the main <code>build:</code>
instructions, using the <code>{test}</code> and <code>{doc}</code> filters. The <code>build-test:</code> and
<code>build-doc:</code> fields are still supported.
</li>
<li>It is now possible to use opam variables within dependencies, for example
<code>depends: [ &quot;foo&quot; {= version} ]</code>, for a dependency to package <code>foo</code> at the
same version as the package being defined, or <code>depends: [ &quot;bar&quot; {os = &quot;linux&quot;} ]</code> for a dependency that only applies on Linux.
</li>
<li>The new <code>conflict-class:</code> field allows mutual conflicts among a set of
packages to be declared. Useful, for example, when there are many concurrent,
incompatible implementations.
</li>
<li>The <code>ocaml-version:</code> field has been deprecated for a long time and is no
longer accepted. This should now be a dependency on the <code>ocaml</code> package
</li>
<li>Three types of checksums are now accepted: you should use <code>md5=&lt;hex-value&gt;</code>,
<code>sha256=&lt;hex-value&gt;</code> or <code>sha512=&lt;hex-value&gt;</code>. We'll be gradually deprecating
md5 in favour of the more secure algorithms; multiple checksums are allowed
</li>
<li>Patches supplied in the <code>patches:</code> field must apply with <code>patch -p1</code>
</li>
<li>The new <code>setenv:</code> field allows packages to export updates to environment
variables;
</li>
<li>Custom fields <code>x-foo:</code> can be used for extensions and external tools
</li>
<li><code>&quot;&quot;&quot;</code> delimiters allow unescaped strings
</li>
<li><code>&amp;</code> has now the customary higher precedence than <code>|</code> in formulas
</li>
<li>Installed files are now automatically tracked meaning that the <code>remove:</code>
field is usually no longer required.
</li>
</ul>
<p>The full, up-to-date specification of the format can be browsed in the
<a href="http://opam.ocaml.org/doc/2.0/Manual.html#opam">manual</a>.</p>
<h4>Repository format</h4>
<p>In the official, default repository, and also when migrating repositories from
older format versions, there are:</p>
<ul>
<li>A virtual <code>ocaml</code> package, that depends on any implementation of the OCaml
compiler. This is what packages should depend on, and the version is the
corresponding base OCaml version (e.g. <code>4.04.0</code> for the <code>4.04.0+fp</code> compiler).
It also defines various configuration variables, see <code>opam config list ocaml</code>.
</li>
<li>Three mutually-exclusive packages providing actual implementations of the
OCaml toolchain:
<ul>
<li><code>ocaml-base-compiler</code> is the official releases
</li>
<li><code>ocaml-variants.&lt;base-version&gt;+&lt;variant-name&gt;</code> contains all the other
variants
</li>
<li><code>ocaml-system-compiler</code> maps to a compiler installed on the system
outside of opam
</li>
</ul>
</li>
</ul>
<p>The layout is otherwise the same, apart from:</p>
<ul>
<li>The <code>compilers/</code> directory is ignored
</li>
<li>A <code>repo</code> file should be present, containing at least the line <code>opam-version: &quot;2.0&quot;</code>
</li>
<li>The indexes for serving over HTTP have been simplified, and <code>urls.txt</code> is no
longer needed. See <code>opam admin index --help</code>
</li>
<li>The <code>archives/</code> directory is no longer used. The cache now uses a different
format and is configured through the <code>repo</code> file, defaulting to <code>cache/</code> on
the same server. See <code>opam admin cache --help</code>
</li>
</ul>
<h2>Feedback</h2>
<p>Thanks for trying out the beta! Please let us have feedback, preferably to the
<a href="https://github.com/ocaml/opam/issues">opam tracker</a>; other options include the
<a href="mailto:opam-devel@lists.ocaml.org">opam-devel</a> list and #opam IRC channel on
Freenode.</p>
|js}
  };
 
  { title = {js|opam-lib 1.3 available|js}
  ; slug = {js|opam-lib-1-3|js}
  ; description = {js|???|js}
  ; date = {js|2016-11-21|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<style type="text/css"><!--
  .opam {font-family: Tahoma,Verdana,sans-serif; font-size: 110%; font-weight: lighter; line-height: 90.9%}
--></style>
<h2>opam-lib 1.3</h2>
<p>The package for opam-lib version 1.3 has just been released in the official
<span class="opam">opam</span> repository. There is no release of
<span class="opam">opam</span> with version 1.3, but this is an intermediate
version of the library that retains compatibility of the file formats with
1.2.2.</p>
<p>The purpose of this release is twofold:</p>
<ul>
<li><strong>provide some fixes and enhancements over opam-lib 1.2.2.</strong> For example, 1.3
has an enhanced <code>lint</code> function
</li>
<li><strong>be a step towards migration to opam-lib 2.0.</strong>
</li>
</ul>
<p><strong>This version is compatible with the current stable release of opam (1.2.2)</strong>,
but dependencies have been updated so that you are not (e.g.) stuck on an old
version of ocamlgraph.</p>
<p>Therefore, I encourage all maintainers of tools based on opam-lib to migrate to
1.3.</p>
<p>The respective APIs are available in html for
<a href="https://opam.ocaml.org/doc/1.2/api">1.2</a> and <a href="https://opam.ocaml.org/doc/1.3/api">1.3</a>.</p>
<blockquote>
<p><strong>A note on plugins</strong>: when you write opam-related tools, remember that by
setting <code>flags: plugin</code> in their definition and installing a binary named
<code>opam-toolname</code>, you will enable the users to install package <code>toolname</code> and
run your tool with a single <code>opam toolname</code> command.</p>
</blockquote>
<h3>Architectural changes</h3>
<p>If you need to migrate from 1.2 to 1.3, these tips may help:</p>
<ul>
<li>
<p>there are now 6 different ocamlfind sub-libraries instead of just 4: <code>format</code>
contains the handlers for opam types and file formats, has been split out from
the core library, while <code>state</code> handles the state of a given opam root and
switch and has been split from the <code>client</code> library.</p>
</li>
<li>
<p><code>OpamMisc</code> is gone and moved into the better organised <code>OpamStd</code>, with
submodules for <code>String</code>, <code>List</code>, etc.</p>
</li>
<li>
<p><code>OpamGlobals</code> is gone too, and its contents have been moved to:</p>
<ul>
<li><code>OpamConsole</code> for the printing, logging, and shell interface handling part
</li>
<li><code>OpamXxxConfig</code> modules for each of the libraries for handling the global
configuration variables. You should call the respective <code>init</code> functions,
with the options you want to set, for proper initialisation of the lib
options (and handling the <code>OPAMXXX</code> environment variables)
</li>
</ul>
</li>
<li>
<p><code>OpamPath.Repository</code> is now <code>OpamRepositoryPath</code>, and part of the
<code>repository</code> sub-library.</p>
</li>
</ul>
<h2>opam-lib 2.0 ?</h2>
<p>The development version of the opam-lib (<code>2.0~alpha5</code> as of writing) is already
available on opam. The name has been changed to provide a finer granularity, so
it can actually be installed concurrently -- but be careful not to confuse the
ocamlfind package names (<code>opam-lib.format</code> for 1.3 vs <code>opam-format</code> for 2.0).</p>
<p>The provided packages are:</p>
<ul>
<li><a href="https://opam.ocaml.org/packages/opam-file-format"><code>opam-file-format</code></a>: now
separated from the opam source tree, this has no dependencies and can be used
to parse and print the raw opam syntax.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-core"><code>opam-core</code></a>: the basic toolbox
used by opam, which actually doesn't include the opam specific part. Includes
a tiny extra stdlib, the engine for running a graph of processes in parallel,
some system handling functions, etc. Depends on ocamlgraph and re only.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-format"><code>opam-format</code></a>: defines opam
data types and their file i/o functions. Depends just on the two above.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-core"><code>opam-solver</code></a>: opam's interface
with the <a href="https://opam.ocaml.org/packages/dose3">dose3</a> library and external
solvers.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-repository"><code>opam-repository</code></a>: fetching
repositories and package sources from all handled remote types.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-state"><code>opam-state</code></a>: handling of the
opam states, at the global, repository and switch levels.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-client"><code>opam-client</code></a>: the client
library, providing the top-level operations (installing packages...), and CLI.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-devel"><code>opam-devel</code></a>: this packages the
development version of the opam tool itself, for bootstrapping. You can
install it safely as it doesn't install the new <code>opam</code> in the PATH.
</li>
</ul>
<p>The new API can be also be <a href="https://opam.ocaml.org/doc/2.0/api">browsed</a> ;
please get in touch if you have trouble migrating.</p>
|js}
  };
 
  { title = {js|opam 2.0 preview release!|js}
  ; slug = {js|opam-2-0-preview|js}
  ; description = {js|???|js}
  ; date = {js|2016-09-20|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<style type="text/css"><!--
  .opam {font-family: Tahoma,Verdana,sans-serif; font-size: 110%; font-weight: lighter; line-height: 90.9%}
--></style>
<p>We are pleased to announce a preview release for <span class="opam">opam</span> 2.0, with over 700
patches since <a href="https://opam.ocaml.org/blog/opam-1-2-2-release/">1.2.2</a>. Version
<a href="https://github.com/ocaml/opam/releases/2.0-alpha4">2.0~alpha4</a> has just been
released, and is ready to be more widely tested.</p>
<p>This version brings many new features and changes, the most notable one being
that OCaml compiler packages are no longer special entities, and are replaced
by standard package definition files. This in turn means that <span class="opam">opam</span> users have
more flexibility in how switches are managed, including for managing non-OCaml
environments such as <a href="http://coq.io/opam/">Coq</a> using the same familiar tools.</p>
<h2>A few highlights</h2>
<p>This is just a sample, see the full
<a href="https://github.com/ocaml/opam/blob/2.0-alpha4/CHANGES">changelog</a> for more:</p>
<ul>
<li>
<p><strong>Sandboxed builds:</strong> Command wrappers can be configured to, for example,
restrict permissions of the build and install processes using Linux
namespaces, or run the builds within Docker containers.</p>
</li>
<li>
<p><strong>Compilers as packages:</strong> This brings many advantages for <span class="opam">opam</span> workflows,
such as being able to upgrade the compiler in a given switch, better tooling for
local compilers, and the possibility to define <code>coq</code> as a compiler or even
use <span class="opam">opam</span> as a generic shell scripting engine with dependency tracking.</p>
</li>
<li>
<p><strong>Local switches:</strong> Create switches within your projects for easier
management. Simply run <code>opam switch create &lt;directory&gt; &lt;compiler&gt;</code> to get
started.</p>
</li>
<li>
<p><strong>Inplace build:</strong> Use <span class="opam">opam</span> to build directly from
your source directory. Ensure the package is pinned locally then run <code>opam install --inplace-build</code>.</p>
</li>
<li>
<p><strong>Automatic file tracking:</strong>: <span class="opam">opam</span> now tracks the files installed by packages
and is able to cleanly remove them when no existing files were modified.
The <code>remove:</code> field is now optional as a result.</p>
</li>
<li>
<p><strong>Configuration file:</strong> This can be used to direct choices at <code>opam init</code>
automatically (e.g. specific repositories, wrappers, variables, fetch
commands, or the external solver). This can be used to override all of <span class="opam">opam</span>'s
OCaml-related settings.</p>
</li>
<li>
<p><strong>Simpler library:</strong> the OCaml API is completely rewritten and should make it
much easier to write external tools and plugins. Existing tools will need to be
ported.</p>
</li>
<li>
<p><strong>Better error mitigation:</strong> Through clever ordering of the shell actions and
separation of <code>build</code> and <code>install</code>, most build failures can keep your current
installation intact, not resulting in removed packages anymore.</p>
</li>
</ul>
<h2>Roll out</h2>
<p>You are very welcome to try out the alpha, and report any issues. The repository
at <code>opam.ocaml.org</code> will remain in 1.2 format (with a 2.0 mirror at
<code>opam.ocaml.org/2.0~dev</code> in sync) until after the release is out, which means
the extensions can not be used there yet, but you are welcome to test on local
or custom repositories, or package pinnings. The reverse translation (2.0 to
1.2) is planned, to keep supporting 1.2 installations after that date.</p>
<p>The documentation for the new version is available at
http://opam.ocaml.org/doc/2.0/. This is still work in progress, so please do ask
if anything is unclear.</p>
<h2>Interface changes</h2>
<p>Commands <code>opam switch</code> and <code>opam list</code> have been rehauled for more consistency
and flexibility: the former won't implicitly create new switches unless called
with the <code>create</code> subcommand, and <code>opam list</code> now allows to combine filters and
finely specify the output format. They may not be fully backwards compatible, so
please check your scripts.</p>
<p>Most other commands have also seen fixes or improvements. For example, <span class="opam">opam</span>
doesn't forget about your set of installed packages on the first error, and the
new <code>opam install --restore</code> can be used to reinstall your selection after a
failed upgrade.</p>
<h2>Repository changes</h2>
<p>While users of <span class="opam">opam</span> 1.2 should feel at home with the changes, the 2.0 repository
and package formats are not compatible. Indeed, the move of the compilers to
standard packages implies some conversions, and updates to the relationships
between packages and their compiler. For example, package constraints like</p>
<pre><code>available: [ ocaml-version &gt;= &quot;4.02&quot; ]
</code></pre>
<p>are now written as normal package dependencies:</p>
<pre><code>depends: [ &quot;ocaml&quot; {&gt;= &quot;4.02&quot;} ]
</code></pre>
<p>To make the transition easier,</p>
<ul>
<li>upgrade of a custom repository is simply a matter of running <code>opam-admin upgrade-format</code> at its root;
</li>
<li>the official repository at <code>opam.ocaml.org</code> already has a 2.0 mirror, to which
you will be automatically redirected;
</li>
<li>packages definition are automatically converted when you pin a package.
</li>
</ul>
<p>Note that the <code>ocaml</code> package on the official repository is actually a wrapper
that depends on one of <code>ocaml-base-compiler</code>, <code>ocaml-system</code> or
<code>ocaml-variants</code>, which contain the different flavours of the actual compiler.
It is expected that it may only get picked up when requested by package
dependencies.</p>
<h2>Package format changes</h2>
<p>The <span class="opam">opam</span> package definition format is very similar to before, but there are
quite a few extensions and some changes:</p>
<ul>
<li>it is now mandatory to separate the <code>build:</code> and <code>install:</code> steps (this allows
tracking of installed files, better error recovery, and some optional security
features);
</li>
<li>the url and description can now optionally be included in the <code>opam</code> file
using the section <code>url {}</code> and fields <code>synopsis:</code> and <code>description:</code>;
</li>
<li>it is now possible to have dependencies toggled by globally-defined <span class="opam">opam</span>
variables (<em>e.g.</em> for a dependency needed on some OS only), or even rely on
the package information (<em>e.g.</em> have a dependency at the same version);
</li>
<li>the new <code>setenv:</code> field allows packages to export updates to environment
variables;
</li>
<li>custom fields <code>x-foo:</code> can be used for extensions and external tools;
</li>
<li>allow <code>&quot;&quot;&quot;</code> delimiters around unescaped strings
</li>
<li><code>&amp;</code> is now parsed with higher priority than <code>|</code>
</li>
<li>field <code>ocaml-version:</code> can no longer be used
</li>
<li>the <code>remove:</code> field should not be used anymore for simple cases (just removing
files)
</li>
</ul>
<h2>Let's go then -- how to try it ?</h2>
<p>First, be aware that you'll be prompted to update your <code>~/.opam</code> to 2.0 format
before anything else, so if you value it, make a backup. Or just export
<code>OPAMROOT</code> to test the alpha on a temporary opam root.</p>
<p>Packages for opam 2.0 are already in the opam repository, so if you have a
working opam installation of opam (at least 1.2.1), you can bootstrap as easily
as:</p>
<pre><code>opam install opam-devel
</code></pre>
<p>This doesn't install the new opam to your PATH within the current opam root for
obvious reasons, so you can manually install it as e.g. &quot;opam2&quot; using:</p>
<pre><code>sudo cp $(opam config var &quot;opam-devel:lib&quot;)/opam /usr/local/bin/opam2
</code></pre>
<p>You can otherwise install as usual:</p>
<ul>
<li>
<p>Using pre-built binaries (available for OSX and Linux x86, x86_64, armhf) and
our install script:</p>
<p>wget https://raw.github.com/ocaml/opam/2.0-alpha4-devel/shell/opam_installer.sh -O - | sh -s /usr/local/bin</p>
<p>Equivalently,
<a href="https://github.com/ocaml/opam/releases/2.0-alpha4">pick your version</a> and
download it to your PATH;</p>
</li>
<li>
<p>Building from our inclusive source tarball:
<a href="https://github.com/ocaml/opam/releases/download/2.0-alpha4/opam-full-2.0-alpha4.tar.gz">download here</a>
and build using <code>./configure &amp;&amp; make lib-ext &amp;&amp; make &amp;&amp; make install</code> if you
have OCaml &gt;= 4.01 already available, <code>make cold &amp;&amp; make install</code> otherwise;</p>
</li>
<li>
<p>Or from <a href="https://github.com/ocaml/opam/tree/2.0-alpha4">source</a>, following the
included instructions from the README. Some files have been moved around, so
if your build fails after you updated an existing git clone, try to clean it
up (<code>git clean -fdx</code>).</p>
</li>
</ul>
|js}
  };
 
  { title = {js|Signing the OPAM repository|js}
  ; slug = {js|signing-the-opam-repository|js}
  ; description = {js|???|js}
  ; date = {js|2015-06-05|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<blockquote>
<p>NOTE (September 2016): updated proposal from OCaml 2016 workshop is
<a href="https://github.com/hannesm/conex-paper/blob/master/paper.pdf">available</a>,
including links to prototype implementation.</p>
</blockquote>
<blockquote>
<p>This is an initial proposal on signing the OPAM repository. Comments and
discussion are expected on the
<a href="http://lists.ocaml.org/listinfo/platform">platform mailing-list</a>.</p>
</blockquote>
<p>The purpose of this proposal is to enable a secure distribution of
OCaml packages. The package repository does not have to be trusted if
package developers sign their releases.</p>
<p>Like <a href="http://www.python.org/dev/peps/pep-0458/">Python's pip</a>, <a href="https://corner.squareup.com/2013/12/securing-rubygems-with-tuf-part-1.html">Ruby's gems</a> or more recently
<a href="http://www.well-typed.com/blog/2015/04/improving-hackage-security/">Haskell's hackage</a>, we are going to implement a flavour of The
Upgrade Framework (<a href="http://theupdateframework.com/">TUF</a>). This is good because:</p>
<ul>
<li>it has been designed by people who <a href="http://google-opensource.blogspot.jp/2009/03/thandy-secure-update-for-tor.html">know the stuff</a> much better than
us
</li>
<li>it is built upon a threat model including many kinds of attacks, and there are
some non-obvious ones (see the <a href="https://raw.githubusercontent.com/theupdateframework/tuf/develop/docs/tuf-spec.txt">specification</a>, and below)
</li>
<li>it has been thoroughly reviewed
</li>
<li>following it may help us avoid a lot of mistakes
</li>
</ul>
<p>Importantly, it doesn't enforce any specific cryptography, allowing us to go
with what we have <a href="http://opam.ocaml.org/packages/nocrypto/nocrypto.0.3.1/">at the moment</a> in native OCaml, and evolve later,
<em>e.g.</em> by allowing ed25519.</p>
<p>There are several differences between the goal of TUF and opam, namely
TUF distributes a directory structure containing the code archive,
whereas opam distributes metadata about OCaml packages. Opam uses git
(and GitHub at the moment) as a first class citizen: new packages are
submitted as pull requests by developers who already have a GitHub
account.</p>
<p>Note that TUF specifies the signing hierarchy and the format to deliver and
check signatures, but allows a lot of flexibility in how the original files are
signed: we can have packages automatically signed on the official repository, or
individually signed by developers. Or indeed allow both, depending on the
package.</p>
<p>Below, we tried to explain the specifics of our implementation, and mostly the
user and developer-visible changes. It should be understandable without prior
knowledge of TUF.</p>
<p>We are inspired by <a href="https://github.com/commercialhaskell/commercialhaskell/wiki/Git-backed-Hackage-index-signing-and-distribution">Haskell's adjustments</a> (and
<a href="https://github.com/commercialhaskell/commercialhaskell/wiki/Package-signing-detailed-propsal">e2e</a>) to TUF using a git repository for packages. A
signed repository and signed packages are orthogonal. In this
proposal, we aim for both, but will describe them independently.</p>
<h2>Threat model</h2>
<ul>
<li>
<p>An attacker can compromise at least one of the package distribution
system's online trusted keys.</p>
</li>
<li>
<p>An attacker compromising multiple keys may do so at once or over a
period of time.</p>
</li>
<li>
<p>An attacker can respond to client requests (MITM or server
compromise) during downloading of the repository, a package, and
also while uploading a new package release.</p>
</li>
<li>
<p>An attacker knows of vulnerabilities in historical versions of one or
more packages, but not in any current version (protecting against
zero-day exploits is emphatically out-of-scope).</p>
</li>
<li>
<p>Offline keys are safe and securely stored.</p>
</li>
</ul>
<p>An attacker is considered successful if they can cause a client to
build and install (or leave installed) something other than the most
up-to-date version of the software the client is updating. If the
attacker is preventing the installation of updates, they want clients
to not realize there is anything wrong.</p>
<h2>Attacks</h2>
<ul>
<li>
<p>Arbitrary package: an attacker should not be able to provide a package
they created in place of a package a user wants to install (via MITM
during package upload, package download, or server compromise).</p>
</li>
<li>
<p>Rollback attacks: an attacker should not be able to trick clients into
installing software that is older than that which the client
previously knew to be available.</p>
</li>
<li>
<p>Indefinite freeze attacks: an attacker should not be able to respond
to client requests with the same, outdated metadata without the
client being aware of the problem.</p>
</li>
<li>
<p>Endless data attacks: an attacker should not be able to respond to
client requests with huge amounts of data (extremely large files)
that interfere with the client's system.</p>
</li>
<li>
<p>Slow retrieval attacks: an attacker should not be able to prevent
clients from being aware of interference with receiving updates by
responding to client requests so slowly that automated updates never
complete.</p>
</li>
<li>
<p>Extraneous dependencies attacks: an attacker should not be able to
cause clients to download or install software dependencies that are
not the intended dependencies.</p>
</li>
<li>
<p>Mix-and-match attacks: an attacker should not be able to trick clients
into using a combination of metadata that never existed together on
the repository at the same time.</p>
</li>
<li>
<p>Malicious repository mirrors: should not be able to prevent updates
from good mirrors.</p>
</li>
<li>
<p>Wrong developer attack: an attacker should not be able to upload a new
version of a package for which they are not the real developer.</p>
</li>
</ul>
<h2>Trust</h2>
<p>A difficult problem in a cryptosystem is key distribution. In TUF and
this proposal, a set of root keys are distributed with opam. A
threshold of these root keys needs to sign (transitively) all keys
which are used to verify opam repository and its packages.</p>
<h3>Root keys</h3>
<p>The root of trust is stored in a set of root keys. In the case of the official
opam OCaml repository, the public keys are to be stored in the opam source,
allowing it to validate the whole trust chain. The private keys will be held by
the opam and repository maintainers, and stored password-encrypted, securely
offline, preferably on unplugged storage.</p>
<p>They are used to sign all the top-level keys, using a quorum. The quorum has
several benefits:</p>
<ul>
<li>the compromise of a number of root keys less than the quorum is harmless
</li>
<li>it allows to safely revoke and replace a key, even if it was lost
</li>
</ul>
<p>The added cost is more maintenance burden, but this remains small since these
keys are not often used (only when keys are going to expire, were compromised or
in the event new top-level keys need to be added).</p>
<p>The initial root keys could be distributed as such:</p>
<ul>
<li>Louis Gesbert, opam maintainer, OCamlPro
</li>
<li>Anil Madhavapeddy, main repository maintainer, OCaml Labs
</li>
<li>Thomas Gazagnaire, main repository maintainer, OCaml Labs
</li>
<li>Grégoire Henry, OCamlPro safekeeper
</li>
<li>Someone in the OCaml team ?
</li>
</ul>
<p>Keys will be set with an expiry date so that one expires each year in turn,
leaving room for smooth rollover.</p>
<p>For other repositories, there will be three options:</p>
<ul>
<li>no signatures (backwards compatible ?), <em>e.g.</em> for local network repositories.
This should be allowed, but with proper warnings.
</li>
<li>trust on first use: get the root keys on first access, let the user confirm
their fingerprints, then fully trust them.
</li>
<li>let the user manually supply the root keys.
</li>
</ul>
<h3>End-to-end signing</h3>
<p>This requires the end-user to be able to validate a signature made by the
original developer. There are two trust paths for the chain of trust (where
&quot;→&quot; stands for &quot;signs for&quot;):</p>
<ul>
<li>(<em>high</em>) root keys →
repository maintainer keys → (signs individually)
package delegation + developer key →
package files
</li>
<li>(<em>low</em>) root keys →
snapshot key → (signs as part of snapshot)
package delegation + developer key →
package files
</li>
</ul>
<p>It is intended that packages may initially follow the <em>low</em> trust path, adding
as little burden and delay as possible when adding new packages, and may then be
promoted to the <em>high</em> path with manual intervention, after verification, from
repository maintainers. This way, most well-known and widely used packages will
be provided with higher trust, and the scope of an attack on the low trust path
would be reduced to new, experimental or little-used packages.</p>
<h3>Repository signing</h3>
<p>This provides consistent, up-to-date snapshots of the repository, and protects
against a whole different class of attacks than end-to-end signing (<em>e.g.</em>
rollbacks, mix-and-match, freeze, etc.)</p>
<p>This is done automatically by a snapshot bot (might run on the repository
server), using the <em>snapshot key</em>, which is signed directly by the root keys,
hence the chain of trust:</p>
<ul>
<li>root keys →
snapshot key →
commit-hash
</li>
</ul>
<p>Where &quot;commit-hash&quot; is the head of the repository's git repository (and thus a
valid cryptographic hash of the full repository state, as well as its history)</p>
<h4>Repository maintainer (RM) keys</h4>
<p>Repository maintainers hold the central role in monitoring the repository and
warranting its security, with or without signing. Their keys (called <em>targets
keys</em> in the TUF framework) are signed directly by the root keys. As they have a
high security potential, in order to reduce the consequences of a compromise, we
will be requiring a quorum for signing sensitive operations</p>
<p>These keys are stored password-encrypted on the RM computers.</p>
<h4>Snapshot key</h4>
<p>This key is held by the <em>snapshot bot</em> and signed directly by the root keys. It
is used to guarantee consistency and freshness of repository snapshots, and does
so by signing a git commit-hash and a time-stamp.</p>
<p>It is held online and used by the snapshot bot for automatic signing: it has
lower security than the RM keys, but also a lower potential: it can not be used
directly to inject malicious code or metadata in any existing package.</p>
<h4>Delegate developer keys</h4>
<p>These keys are used by the package developers for end-to-end signing. They can
be generated locally as needed by new packagers (<em>e.g.</em> by the <code>opam-publish</code>
tool), and should be stored password-encrypted. They can be added to the
repository through pull-requests, waiting to be signed (i) as part of snapshots
(which also prevents them to be modified later, but we'll get to it) and (ii)
directly by RMs.</p>
<h4>Initial bootstrap</h4>
<p>We'll need to start somewhere, and the current repository isn't signed. An
additional key, <em>initial-bootstrap</em>, will be used for guaranteeing integrity of
existing, but yet unverified packages.</p>
<p>This is a one-go key, signed by the root keys, and that will then be destroyed.
It is allowed to sign for packages without delegation.</p>
<h3>Trust chain and revocation</h3>
<p>In order to build the trust chain, the opam client downloads a <code>keys/root</code> key
file initially and before every update operation. This file is signed by the
root keys, and can be verified by the client using its built-in keys (or one of
the ways mentioned above for unofficial repositories). It must be signed by a
quorum of known root keys, and contains the comprehensive set of root, RM,
snapshot and initial bootstrap keys: any missing keys are implicitly revoked.
The new set of root keys is stored by the opam client and used instead of the
built-in ones on subsequent runs.</p>
<p>Developer keys are stored in files <code>keys/dev/&lt;id&gt;</code>, self-signed, possibly RM
signed (and, obviously, snapshot-signed). The conditions of their verification,
removal or replacement are included in our validation of metadata update (see
below).</p>
<h2>File formats and hierarchy</h2>
<h3>Signed files and tags</h3>
<p>The files follow the opam syntax: a list of <em>fields</em> <code>fieldname:</code> followed by
contents. The format is detailed in <a href="https://opam.ocaml.org/doc/Manual.html#Generalfileformat">opam's documentation</a>.</p>
<p>The signature of files in opam is done on the canonical textual representation,
following these rules:</p>
<ul>
<li>any existing <code>signature:</code> field is removed
</li>
<li>one field per line, ending with a newline
</li>
<li>fields are sorted lexicographically by field name
</li>
<li>newlines, backslashes and double-quotes are escaped in string literals
</li>
<li>spaces are limited to one, and to these cases: after field leaders
<code>fieldname:</code>, between elements in lists, before braced options, between
operators and their operands
</li>
<li>comments are erased
</li>
<li>fields containing an empty list, or a singleton list containing an empty
list, are erased
</li>
</ul>
<p>The <code>signature:</code> field is a list with elements in the format of string triplets
<code>[ &quot;&lt;keyid&gt;&quot; &quot;&lt;algorithm&gt;&quot; &quot;&lt;signature&gt;&quot; ]</code>. For example:</p>
<pre><code>opam-version: &quot;1.2&quot;
name: &quot;opam&quot;
signature: [
  [ &quot;louis.gesbert@ocamlpro.com&quot; &quot;RSASSA-PSS&quot; &quot;048b6fb4394148267df...&quot; ]
]
</code></pre>
<p>Signed tags are git annotated tags, and their contents follow the same rules. In
this case, the format should contain the field <code>commit:</code>, pointing to the
commit-hash that is being signed and tagged.</p>
<h3>File hierarchy</h3>
<p>The repository format is changed by the addition of:</p>
<ul>
<li>a directory <code>keys/</code> at the root
</li>
<li>delegation files <code>packages/&lt;pkgname&gt;/delegate</code> and
<code>compilers/&lt;patchname&gt;.delegate</code>
</li>
<li>signed checksum files at <code>packages/&lt;pkgname&gt;/&lt;pkgname&gt;.&lt;version&gt;/signature</code>
</li>
</ul>
<p>Here is an example:</p>
<pre><code>repository root /
|--packages/
|  |--pkgname/
|  |  |--delegation                    - signed by developer, repo maintainer
|  |  |--pkgname.version1/
|  |  |  |--opam
|  |  |  |--descr
|  |  |  |--url
|  |  |  `--signature                  - signed by developer1
|  |  `--pkgname.version2/ ...
|  `--pkgname2/ ...
|--compilers/
|  |--version/
|  |  |--version+patch/
|  |  |  |--version+patch.comp
|  |  |  |--version+patch.descr
|  |  |  `--version+patch.signature
|  |  `--version+patch2/ ...
|  |--patch.delegate
|  |--patch2.delegate
|  `--version2/ ...
`--keys/
   |--root
   `--dev/
      |--developer1-email              - signed by developer1,
      `--developer2-email ...            and repo maint. once verified
</code></pre>
<p>Keys are provided in different files as string triplets
<code>[ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]</code>. <code>keyid</code> must not conflict with any
previously-defined keys, and <code>algo</code> may be &quot;rsa&quot; and keys encoded in PEM format,
with further options available later.</p>
<p>For example, the <code>keys/root</code> file will have the format:</p>
<pre><code>date: &quot;2015-06-04T13:53:00Z&quot;
root-keys: [ [ &quot;keyid&quot; &quot;{expire-date}&quot; &quot;algo&quot; &quot;key&quot; ] ]
snapshot-keys: [ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]
repository-maintainer-keys: [ [ &quot;keyid&quot; &quot;algo&quot; &quot;key&quot; ] ]
</code></pre>
<p>This file is signed by current <em>and past</em> root keys -- to allow clients to
update. The <code>date:</code> field provides further protection against rollback attacks:
no clients may accept a file with a date older than what they currently have.
Date is in the ISO 8601 standard with 0 UTC offset, as suggested in TUF.</p>
<h4>Delegation files</h4>
<p><code>/packages/pkgname/delegation</code> delegates ownership on versions of package
<code>pkgname</code>. The file contains version constraints associated with keyids, <em>e.g.</em>:</p>
<pre><code>name: pkgname
delegates: [
  &quot;thomas@gazagnaire.org&quot;
  &quot;louis.gesbert@ocamlpro.com&quot; {&gt;= &quot;1.0&quot;}
]
</code></pre>
<p>The file is signed:</p>
<ul>
<li>by the original developer submitting it
</li>
<li>or by a developer previously having delegation for all versions, for changes
</li>
<li>or directly by repository maintainers, validating the delegation, and
increasing the level of trust
</li>
</ul>
<p>Every key a developer delegates trust to must also be signed by the developer.</p>
<p><code>compilers/patch.delegate</code> files follow a similar format (we are considering
changing the hierarchy of compilers to match that of packages, to make things
simpler).</p>
<p>The <code>delegates:</code> field may be empty: in this case, no packages by this name are
allowed on the repository. This may be useful to mark deletion of obsolete
packages, and make sure a new, different package doesn't take the same name by
mistake or malice.</p>
<h4>Package signature files</h4>
<p>These guarantee the integrity of a package: this includes metadata and the
package archive itself (which may, or may not, be mirrored on the the opam
repository server).</p>
<p>The file, besides the package name and version, has a field <code>package-files:</code>
containing a list of files below <code>packages/&lt;pkgname&gt;/&lt;pkgname&gt;.&lt;version&gt;</code>
together with their file sizes in bytes and one or more hashes, prefixed by their
kind, and a field <code>archive:</code> containing the same details for the upstream
archive. For example:</p>
<pre><code>name: pkgname
version: pkgversion
package-files: [
  &quot;opam&quot; {901 [ sha1 &quot;7f9bc3cc8a43bd8047656975bec20b578eb7eed9&quot; md5 &quot;1234567890&quot; ]}
  &quot;descr&quot; {448 [ sha1 &quot;8541f98524d22eeb6dd669f1e9cddef302182333&quot; ]}
  &quot;url&quot; {112 [ sha1 &quot;0a07dd3208baf4726015d656bc916e00cd33732c&quot; ]}
  &quot;files/ocaml.4.02.patch&quot; {17243 [ sha1 &quot;b3995688b9fd6f5ebd0dc4669fc113c631340fde&quot; ]}
]
archive: [ 908460 [ sha1 &quot;ec5642fd2faf3ebd9a28f9de85acce0743e53cc2&quot; ] ]
</code></pre>
<p>This file is signed either:</p>
<ul>
<li>by the <code>initial-bootstrap</code> key, only initially
</li>
<li>by a delegate key (<em>i.e.</em> by a delegated-to developer)
</li>
<li>by a quorum of repository maintainers
</li>
</ul>
<p>The latter is needed to hot-fix packages on the repository: repository
maintainers often need to do so. A quorum is still required, to prevent a single
RM key compromise from allowing arbitrary changes to every package. The quorum
is not initially required to sign a delegation, but is, consistently, required
for any change to an existing, signed delegation.</p>
<p>Compiler signature files <code>&lt;version&gt;+&lt;patch&gt;.signature</code> are similar, with fields
<code>compiler-files</code> containing checksums for <code>&lt;version&gt;+&lt;patch&gt;.*</code>, the same field
<code>archive:</code> and an additional optional field <code>patches:</code>, containing the sizes and
hashes of upstream patches used by this compiler.</p>
<p>If the delegation or signature can't be validated, the package or compiler is
ignored. If any file doesn't correspond to its size or hashes, it is ignored as
well. Any file not mentioned in the signature file is ignored.</p>
<h2>Snapshots and linearity</h2>
<h3>Main snapshot role</h3>
<p>The snapshot key automatically adds a <code>signed</code> annotated tag to the top of the
served branch of the repository. This tag contains the commit-hash and the
current timestamp, effectively ensuring freshness and consistency of the full
repository. This protects against mix-and-match, rollback and freeze attacks.</p>
<p>The <code>signed</code> annotated tag is deleted and recreated by the snapshot bot, after
checking the validity of the update, periodically and after each change.</p>
<h3>Linearity</h3>
<p>The repository is served using git: this means, not only the latest version, but
the full history of changes are known. This as several benefits, among them,
incremental downloads &quot;for free&quot;; and a very easy way to sign snapshots. Another
good point is that we have a working full OCaml implementation.</p>
<p>We mentioned above that we use the snapshot signatures not only for repository
signing, but also as an initial guarantee for submitted developer's keys and
delegations. One may also have noticed, in the above, that we sign for
delegations, keys etc. individually, but without a bundle file that would ensure
no signed files have been maliciously removed.</p>
<p>These concerns are all addressed by a <em>linearity condition</em> on the repository's
git: the snapshot bot does not only check and sign for a given state of the
repository, it checks every individual change to the repository since the last
well-known, signed state: patches have to follow from that git commit
(descendants on the same branch), and are validated to respect certain
conditions: no signed files are removed or altered without signature, etc.</p>
<p>Moreover, this check is also done on clients, every time they update: it is
slightly weaker, as the client don't update continuously (an attacker may have
rewritten the commits since last update), but still gives very good guarantees.</p>
<p>A key and delegation that have been submitted by a developer and merged, even
without RM signature, are signed as part of a snapshot: git and the linearity
conditions allow us to guarantee that this delegation won't be altered or
removed afterwards, even without an individual signature. Even if the repository
is compromised, an attacker won't be able to roll out malicious updates breaking
these conditions to clients.</p>
<p>The linearity invariants are:</p>
<ol>
<li>no key, delegation, or package version (signed files) may be removed
</li>
<li>a new key is signed by itself, and optionally by a RM
</li>
<li>a new delegation is signed by the delegate key, optionally by a RM. Signing
keys must also sign the delegate keys
</li>
<li>a new package or package version is signed by a valid key holding a valid
delegation for this package version
</li>
<li>keys can only be modified with signature from the previous key or a quorum
of RM keys
</li>
<li>delegations can only be modified with signature by a quorum of RMs, or
possibly by a former delegate key (without version constraints) in case
there was previously no RM signature
</li>
<li>any package modification is signed by an appropriate delegate key, or by a
quorum of RM keys
</li>
</ol>
<p>It is sometimes needed to do operations, like key revocation, that are not
allowed by the above rules. These are enabled by the following additional rules,
that require the commit including the changes to be signed by a quorum of
repository maintainers using an annotated tag:</p>
<ol>
<li>package or package version removal
</li>
<li>removal (revocation) of a developer key
</li>
<li>removal of a package delegation (it's in general preferable to leave an
empty delegation)
</li>
</ol>
<p>Changes to the <code>keys/root</code> file, which may add, modify or revoke keys for root,
RMs and snapshot keys is verified in the normal way, but needs to be handled for
checking linearity since it decides the validity of RM signatures. Since this
file may be needed before we can check the <code>signed</code> tag, it has its own
timestamp to prevent rollback attacks.</p>
<p>In case the linearity invariant check fail:</p>
<ul>
<li>on the GitHub repository, this is marked and the RMs are advised not to merge
(or to complete missing tag signatures)
</li>
<li>on the clients, the update is refused, and the user informed of what's going
on (the repository has likely been compromised at that point)
</li>
<li>on the repository (checks by the snapshot bot), update is stalled and all
repository maintainers immediately warned. To recover, the broken commits
(between the last <code>signed</code> tag and master) need to be amended.
</li>
</ul>
<h2>Work and changes involved</h2>
<h3>General</h3>
<p>Write modules for key handling ; signing and verification of opam files.</p>
<p>Write the git synchronisation module with linearity checks.</p>
<h3>opam</h3>
<p>Rewrite the default HTTP repository synchronisation module to use git fetch,
verify, and git pull. This should be fully transparent, except:</p>
<ul>
<li>in the cases of errors, of course
</li>
<li>when registering a non-official repository
</li>
<li>for some warnings with features that disable signatures, like source pinning
(probably only the first time would be good)
</li>
</ul>
<p>Include the public root keys for the default repository, and implement
management of updated keys in <code>~/.opam/repo/name</code>.</p>
<p>Handle the new formats for checksums and non-repackaged archives.</p>
<p>Allow a per-repository security threshold (<em>e.g.</em> allow all, allow only signed
packages, allow only packages signed by a verified key, allow only packages
signed by their verified developer). It should be easy but explicit to add a
local network, unsigned repository. Backends other than git won't be signed
anyway (local, rsync...).</p>
<h3>opam-publish</h3>
<p>Generate keys, handle locally stored keys, generate <code>signature</code> files, handle
signing, submit signatures, check delegation, submit new delegation, request
delegation change (might require repository maintainer intervention if an RM
signed the delegation), delete developer, delete package.</p>
<p>Manage local keys. Probably including re-generating, and asking for revocation.</p>
<h3>opam-admin</h3>
<p>Most operations on signatures and keys will be implemented as independent
modules (as to be usable from <em>e.g.</em> unikernels working on the repository). We
should also make them available from <code>opam-admin</code>, for testing and manual
management. Special tooling will also be needed by RMs.</p>
<ul>
<li>fetch the archives (but don't repackage as <code>pkg+opam.tar.gz</code> anymore)
</li>
<li>allow all useful operations for repository maintainers (maybe in a different
tool ?):
<ul>
<li>manage their keys
</li>
<li>list and sign changed packages directly
</li>
<li>list and sign waiting delegations to developer keys
</li>
<li>validate signatures, print reports
</li>
<li>sign tags, including adding a signature to an existing tag to meet the
quorum
</li>
<li>list quorums waiting to be met on a given branch
</li>
</ul>
</li>
<li>generate signed snapshots (same as the snapshot bot, for testing)
</li>
</ul>
<h3>Signing bots</h3>
<p>If we don't want to have this processed on the publicly visible host serving the
repository, we'll need a mechanism to fetch the repository, and submit the
signed tag back to the repository server.</p>
<p>Doing this through mirage unikernels would be cool, and provide good isolation.
We could imagine running this process regularly:</p>
<ul>
<li>fetch changes from the repository's git (GitHub)
</li>
<li>check for consistency (linearity)
</li>
<li>generate and sign the <code>signed</code> tag
</li>
<li>push tag back to the release repository
</li>
</ul>
<h3>Travis</h3>
<p>All security information and check results should be available to RMs before
they make the decision to merge a commit to the repository. This means including
signature and linearity checks in a process running on Travis, or similarly on
every pull-request to the repository, and displaying the results in the GitHub
tracker.</p>
<p>This should avoid most cases where the snapshot bot fails the validation,
leaving it stuck (as well as any repository updates) until the bad commits are
rewritten.</p>
<h2>Some more detailed scenarios</h2>
<h3><code>opam init</code> and <code>update</code> scenario</h3>
<p>On <code>init</code>, the client would clone the repository and get to the <code>signed</code> tag,
get and check the associated <code>keys/root</code> file, and validate the <code>signed</code> tag
according to the new keyset. If all goes well, the new set of root, RM and
snapshot keys is registered.</p>
<p>Then all files' signatures are checked following the trust chains, and copied to
the internal repository mirror opam will be using (<code>~/.opam/repo/&lt;name&gt;</code>). When
a package archive is needed, the download is done either from the repository, if
the file is mirrored, or from its upstream, in both cases with known file size
and upper limit: the download is stopped if going above the expected size, and
the file removed if it doesn't match both.</p>
<p>On subsequent updates, the process is the same except that a fetch operation is
done on the existing clone, and that the repository is forwarded to the new
<code>signed</code> tag only if linearity checks passed (and the update is aborted
otherwise).</p>
<h3><code>opam-publish</code> scenario</h3>
<ul>
<li>The first time a developer runs <code>opam-publish submit</code>, a developer key is
generated, and stored locally.
</li>
<li>Upon <code>opam-publish submit</code>, the package is signed using the key, and the
signature is included in the submission.
</li>
<li>If the key is known, and delegation for this package matches, all is good
</li>
<li>If the key is not already registered, it is added to <code>/keys/dev/</code> within the
pull-request, self-signed.
</li>
<li>If there is no delegation for the package, the <code>/packages/pkgname/delegation</code>
file is added, delegating to the developer key and signed by it.
</li>
<li>If there is an existing delegation that doesn't include the auhor's key,
this will require manual intervention from the repository managers. We may yet
submit a pull-request adding the new key as delegate for this package, and ask
the repository maintainers -- or former developers -- to sign it.
</li>
</ul>
<h2>Security analysis</h2>
<p>We claim that the above measures give protection against:</p>
<ul>
<li>
<p>Arbitrary packages: if an existing package is not signed, it is not installed
(or even visible) to the user. Anybody can submit new unclaimed packages (but,
in the current setting, still need GitHub write access to the repository, or
to bypass GitHub's security).</p>
</li>
<li>
<p>Rollback attacks: git updates must follow the currently known <code>signed</code> tag. if
the snapshot bot detects deletions of packages, it refuses to sign, and
clients double-check this. The <code>keys/root</code> file contains a timestamp.</p>
</li>
<li>
<p>Indefinite freeze attacks: the snapshot bot periodically signs the <code>signed</code>
tag with a timestamp, if a client receives a tag older than the expected age
it will notice.</p>
</li>
<li>
<p>Endless data attacks: we rely on the git protocol and this does not defend
against endless data. Downloading of package archive (of which the origin may
be any mirror), though, is protected. The scope of the attack is mitigated in
our setting, because there are no unattended updates: the program is run
manually, and interactively, so the user is most likely to notice.</p>
</li>
<li>
<p>Slow retrieval attacks: same as above.</p>
</li>
<li>
<p>Extraneous dependencies attacks: metadata is signed, and if the signature does
not match, it is not accepted.</p>
<blockquote>
<p>NOTE: the <code>provides</code> field -- yet unimplemented, see the document in
<code>opam/doc/design</code> -- could provide a vector in this case, by advertising a
replacement for a popular package. Additional measures will be taken when
implementing the feature, like requiring a signature for the provided
package.</p>
</blockquote>
</li>
<li>
<p>Mix-and-match attacks: the repository has a linearity condition, and partial
repositories are not possible.</p>
</li>
<li>
<p>Malicious repository mirrors: if the signature does not match, reject.</p>
</li>
<li>
<p>Wrong developer attack: if the developer is not in the delegation, reject.</p>
</li>
</ul>
<h3>GitHub repository</h3>
<p>Is the link between GitHub (opam-repository) and the signing bot special?
If there is a MITM on this link, they can add arbitrary new packages, but
due to missing signatures only custom universes. No existing package can
be altered or deleted, otherwise consistency condition above does not hold
anymore and the signing bot will not sign.</p>
<p>Certainly, the access can be frozen, thus the signing bot does not receive
updates, but continues to sign the old repository version.</p>
<h3>Snapshot key</h3>
<p>If the snapshot key is compromised, an attacker is able to:</p>
<ul>
<li>
<p>Add arbitrary (non already existing) packages, as above.</p>
</li>
<li>
<p>Freeze, by forever re-signing the <code>signed</code> tag with an updated timestamp.</p>
</li>
</ul>
<p>Most importantly, the attacker won't be able to tamper with existing packages.
This hudgely reduces the potential of an attack, even with a compromised
snapshot key.</p>
<p>The attacks above would also require either a MITM between the repository and
the client, or a compromise of the opam repository: in the latter case, since
the linearity check is reproduces even from the clients:</p>
<ul>
<li>any tamper could be detected very quickly, and measures taken.
</li>
<li>a freeze would be detected as soon as a developer checks that their
package is really online. That currently happens
<a href="https://github.com/ocaml/opam-repository/pulse">several times a day</a>.
</li>
</ul>
<p>The repository would then just have to be reset to before the attack, which git
makes as easy as it can get, and the holders of the root keys would sign a new
<code>/auth/root</code>, revoking the compromised snapshot key and introducing a new one.</p>
<p>In the time before the signing bot can be put back online with the new snapshot
key -- <em>i.e.</em> the breach has been found and fixed -- a developer could manually
sign time-stamped tags before they expire (<em>e.g.</em> once a day) so as not to hold
back updates.</p>
<h3>Repository Maintainer keys</h3>
<p>Repository maintainers are powerful, they can modify existing opam files and
sign them (as hotfix), introduce new delegations for packages, etc.).</p>
<p>However, by requiring a quorum for sensitive operations, we limit the scope of a
single RM key compromise to the validation of new developer keys or delegations
(which should be the most common operation done by RMs): this enables to raise
the level of security of the new, malicious packages but otherwise doesn't
change much from what can be done with just access to the git repository.</p>
<p>A further compromise of a quorum of RM keys would allow to remove or tamper with
any developer key, delegation or package: any of these amounts to being able to
replace any package with a compromised version. Cleaning up would require
replacing all but the root keys, and resetting the repository to before any
malicious commit.</p>
<h2>Difference to TUF</h2>
<ul>
<li>we use git
</li>
<li>thus get linearity &quot;for free&quot;
</li>
<li>and already have a hash over the entire repository
</li>
<li>TUF provides a mechanism for delegation, but it's both heavier and not
expressive enough for what we wanted -- delegate to packages directly.
</li>
<li>We split in lots more files, and per-package ones, to fit with and nicely
extend the git-based workflow that made the success of opam. The original TUF
would have big json files signing for a lot of files, and likely to conflict.
Both developers and repository maintainers should be able to safely work
concurrently without issue. Signing bundles in TUF gives the additional
guarantee that no file is removed without proper signature, but this is
handled by git and signed tags.
</li>
<li>instead of a single file with all signed packages by a specific developer,
one file per package
</li>
</ul>
<h3>Differences to Haskell:</h3>
<ul>
<li>use TUF keys, not gpg
</li>
<li>e2e signing
</li>
</ul>
|js}
  };
 
  { title = {js|OPAM 1.2.2 Released|js}
  ; slug = {js|opam-1-2-2-release|js}
  ; description = {js|???|js}
  ; date = {js|2015-05-07|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><a href="https://github.com/ocaml/opam/releases/tag/1.2.2">OPAM 1.2.2</a> has just been
released. This fixes a few issues over 1.2.1 and brings a couple of improvements,
in particular better use of the solver to keep the installation as up-to-date as
possible even when the latest version of a package can not be installed.</p>
<h3>Upgrade from 1.2.1 (or earlier)</h3>
<p>See the normal
<a href="https://opam.ocaml.org/doc/Install.html">installation instructions</a>: you should
generally pick up the packages from the same origin as you did for the last
version -- possibly switching from the official repository packages to the ones
we provide for your distribution, in case the former are lagging behind.</p>
<p>There are no changes in repository format, and you can roll back to earlier
versions in the 1.2 branch if needed.</p>
<h3>Improvements</h3>
<ul>
<li>Conflict messages now report the original version constraints without
translation, and they have been made more concise in some cases
</li>
<li>Some new <code>opam lint</code> checks, <code>opam lint</code> now numbers its warnings and may
provide script-friendly output
</li>
<li>Feature to <strong>automatically install plugins</strong>, e.g. <code>opam depext</code> will prompt
to install <code>depext</code> if available and not already installed
</li>
<li><strong>Priority to newer versions</strong> even when the latest can't be installed (with a
recent solver only. Before, all non-latest versions were equivalent to the
solver)
</li>
<li>Added <code>opam list --resolve</code> to list a consistent installation scenario
</li>
<li>Be cool by default on errors in OPAM files, these don't concern end-users and
packagers and CI now have <code>opam lint</code> to check them.
</li>
</ul>
<h3>Fixes</h3>
<ul>
<li>OSX: state cache got broken in 1.2.1, which could induce longer startup times.
This is now fixed
</li>
<li><code>opam config report</code> has been fixed to report the external solver properly
</li>
<li><code>--dry-run --verbose</code> properly outputs all commands that would be run again
</li>
<li>Providing a simple path to an aspcud executable as external solver (through
options or environment) works again, for backwards-compatibility
</li>
<li>Fixed a fd leak on solver calls (thanks Ivan Gotovchits)
</li>
<li><code>opam list</code> now returns 0 when no packages match but no pattern was supplied,
which is more helpful in scripts relying on it to check dependencies.
</li>
</ul>
|js}
  };
 
  { title = {js|OPAM 1.2.1 Released|js}
  ; slug = {js|opam-1-2-1-release|js}
  ; description = {js|???|js}
  ; date = {js|2015-03-18|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><a href="https://github.com/ocaml/opam/releases/tag/1.2.1">OPAM 1.2.1</a> has just been
released. This patch version brings a number of fixes and improvements
over 1.2.0, without breaking compatibility.</p>
<h3>Upgrade from 1.2.0 (or earlier)</h3>
<p>See the normal
<a href="https://opam.ocaml.org/doc/Install.html">installation instructions</a>: you should
generally pick up the packages from the same origin as you did for the last
version -- possibly switching from the official repository packages to the ones
we provide for your distribution, in case the former are lagging behind.</p>
<h3>What's new</h3>
<p>No huge new features in this point release -- which means you can roll back
to 1.2.0 in case of problems -- but lots going on under the hood, and quite a
few visible changes nonetheless:</p>
<ul>
<li>The engine that processes package builds and other commands in parallel has
been rewritten. You'll notice the cool new display but it's also much more
reliable and efficient. Make sure to set <code>jobs:</code> to a value greater than 1 in
<code>~/.opam/config</code> in case you updated from an older version.
</li>
<li>The install/upgrade/downgrade/remove/reinstall actions are also processed in a
better way: the consequences of a failed actions are minimised, when it used
to abort the full command.
</li>
<li>When using version control to pin a package to a local directory without
specifying a branch, only the tracked files are used by OPAM, but their
changes don't need to be checked in. This was found to be the most convenient
compromise.
</li>
<li>Sources used for several OPAM packages may use <code>&lt;name&gt;.opam</code> files for package
pinning. URLs of the form <code>git+ssh://</code> or <code>hg+https://</code> are now allowed.
</li>
<li><code>opam lint</code> has been vastly improved.
</li>
</ul>
<p>... and much more</p>
<p>There is also a <a href="https://opam.ocaml.org/doc/Manual.html">new manual</a> documenting
the file and repository formats.</p>
<h3>Fixes</h3>
<p>See <a href="https://github.com/ocaml/opam/blob/1.2.1/CHANGES">the changelog</a> for a
summary or
<a href="https://github.com/ocaml/opam/issues?q=is%3Aissue+closed%3A%3E2014-10-16+closed%3A%3C2015-03-05+">closed issues</a>
in the bug-tracker for an overview.</p>
<h3>Experimental features</h3>
<p>These are mostly improvements to the file formats. You are welcome to use them,
but they won't be accepted into the
<a href="https://github.com/ocaml/opam-repository">official repository</a> until the next
release.</p>
<ul>
<li>New field <code>features:</code> in opam files, to help with <code>./configure</code> scripts and
documenting the specific features enabled in a given build. See the
<a href="https://github.com/ocaml/opam/blob/master/doc/design/depopts-and-features">original proposal</a>
and the section in the <a href="https://opam.ocaml.org/doc/Manual.html#opam">new manual</a>
</li>
<li>The &quot;filter&quot; language in opam files is now well defined, and documented in the
<a href="https://opam.ocaml.org/doc/Manual.html#Filters">manual</a>. In particular,
undefined variables are consistently handled, as well as conversions between
string and boolean values, with new syntax for converting bools to strings.
</li>
<li>New package flag &quot;verbose&quot; in opam files, that outputs the package's build
script to stdout
</li>
<li>New field <code>libexec:</code> in <code>&lt;name&gt;.install</code> files, to install into the package's
lib dir with the execution bit set.
</li>
<li>Compilers can now be defined without source nor build instructions, and the
base packages defined in the <code>packages:</code> field are now resolved and then
locked. In practice, this means that repository maintainers can move the
compiler itself to a package, giving a lot more flexibility.
</li>
</ul>
|js}
  };
 
  { title = {js|Improving the OCaml documentation toolchain|js}
  ; slug = {js|codoc-0-2-0-released|js}
  ; description = {js|???|js}
  ; date = {js|2015-02-20|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>Last week, we
<a href="http://lists.ocaml.org/pipermail/platform/2015-February/000539.html">published</a>
an <em>alpha</em> version of a new OCaml documentation generator,
<a href="https://github.com/dsheets/codoc">codoc 0.2.0</a>.
In the 2014 OCaml workshop presentation (<a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_7.pdf">abstract</a>, <a href="http://ocaml.org/meetings/ocaml/2014/ocl-platform-2014-slides.pdf">slides</a>, <a href="https://www.youtube.com/watch?v=jxhtpQ5nJHg&amp;list=UUP9g4dLR7xt6KzCYntNqYcw">video</a>),
we mentioned the 'module wall' for documentation and this attempts to fix it.
To try it out, simply follow the directions in the README on that repository,
or <a href="http://dsheets.github.io/codoc">browse some samples</a> of the current,
default output of the tool. Please do bear in mind codoc and its constituent
libraries are still under heavy development and are <em>not</em> feature complete.</p>
<p><code>codoc</code>'s aim is to provide a widely useful set of tools for generating OCaml
documentation. In particular, we are striving to:</p>
<ol>
<li>Cover all of OCaml's language features
</li>
<li>Provide accurate name resolution and linking
</li>
<li>Support cross-linking between different packages
</li>
<li>Expose interfaces to the components we've used to build <code>codoc</code>
</li>
<li>Provide a magic-free command-line interface to the tool itself
</li>
<li>Reduce external dependencies and default integration with other tools
</li>
</ol>
<p>We haven't yet achieved all of these at all levels of our tool stack but are
getting close. <code>codoc</code> 0.2.0 is usable today (if a little rough in some areas
like default CSS).  This post outlines the architecture of the new system to
make it easier to understand the design decisions that went into it.</p>
<h2>The five stages of documentation</h2>
<p>There are five stages in generating documentation from OCaml source
code. Here we describe how each was handled in the <em>past</em> (using
OCamldoc), the <em>present</em> (using our current prototype), and the <em>future</em>
(using the final version of the tools we are developing).</p>
<h3>Associating comments with definitions</h3>
<p>The first stage is to associate the various documentation comments in
an <code>.ml</code> or <code>.mli</code> file with the definitions that they correspond to.</p>
<h4>Past</h4>
<p>Associating comments with definitions is handled by the OCamldoc
tool, which does this in two steps. First it parses the file using the regular
OCaml parser or <a href="https://github.com/ocaml/camlp4">camlp4</a>, just as in
normal compilation. It uses the syntax tree from the first step and then
re-parses the file looking for comments. This second parse is guided by the
location information in the syntax tree; for example if there is a definition
which ends on line 5 then OCamldoc will look for comments to attach to that
definition starting at line 6.</p>
<p>The rules used for attaching comments are quite intricate and whitespace
dependent. This makes it difficult to parse the file and attach comments
using a single parser. In particular, it would be difficult to do so in
a way that doesn't cause a lot of problems for camlp4 extensions. This
is why OCamldoc does the process in two steps.</p>
<p>A disadvantage of this two-step approach is that it assumes that the
input to any preprocessor is something which could reasonably be read by
the compiler/tool creating documentation, which may not always be the
case.</p>
<h4>Present</h4>
<p>Our current prototype associates comments with definitions within the
compiler itself. This relies on a patch to the OCaml compiler
(<a href="https://github.com/ocaml/ocaml/pull/51">pull request #51 on GitHub</a>).
Comment association is activated by the <code>-doc</code> command-line flag. It
uses (a rewritten version of) the same two-step algorithm currently
used by OCamldoc. The comments are then attached to the appropriate node
in the syntax tree as an attribute. These attributes are passed through
the type-checker and appear in <code>.cmt</code>/<code>.cmti</code> files, where they can be
read by other tools.</p>
<h4>Future</h4>
<p>We intend to move away from the two-step approach taken by OCamldoc. To
do this we will need to simplify the rules for associating comments with
definitions. One suggestion was to use the same rules as attributes,
however that seems to be overly restrictive. So the approach we hope to
take is to keep quite close to what OCamldoc currently supports, but
disallow some of the more ambiguous cases. For example,</p>
<pre><code>val x : int
(** Is this for x or y? *)
val y : float
</code></pre>
<p>may well not be supported in our final version.
We will take care to understand the impact of such design decisions and we
hope to arrive at a robust solution for the future.
By avoiding the two-step
approach, it should be safe to always turn on comment association rather
than requiring a <code>-doc</code> command-line flag.</p>
<h3>Parsing the contents of comments</h3>
<p>Once you have associated documentation comments with definitions, you must
parse the contents of these comments.</p>
<h4>Past</h4>
<p>OCamldoc parses the contents of comments.</p>
<h4>Present</h4>
<p>In our current prototype, the contents of comments are parsed in the
compiler, so that the documentation attributes available in
<code>.cmt</code>/<code>.cmti</code> files contain a structured representation of the
documentation.</p>
<h4>Future</h4>
<p>We intend to separate parsing the contents of documentation comments
from the compiler. This means that the documentation will be stored as
strings within the <code>.cmt</code>/<code>.cmti</code> files and parsed by external
tools. This will allow the documentation language (and its parser) to
evolve faster than the distribution cycle of the compiler.</p>
<h3>Representing compilation units with types and documentation</h3>
<p>The typed syntax tree stored in <code>.cmt</code>/<code>.cmti</code> files is not a convenient
representation for generating documentation from, so the next stage is
to convert the syntax tree and comments into some suitable intermediate
form. In particular, this allows <code>.cmt</code> files and <code>.cmti</code> files to be
treated uniformly.</p>
<h4>Past</h4>
<p>OCamldoc generates an intermediate form from a syntax tree, a typed
syntax tree, and the comments that it found and parsed in the earlier
stages. The need for both an untyped and typed syntax tree is a
historical artefact that is no longer necessary.</p>
<h4>Present</h4>
<p>Our current prototype creates an intermediate form in the
<a href="https://github.com/lpw25/doc-ock-lib">doc-ock</a> library. This form can be
currently be created from <code>.cmti</code> files or <code>.cmi</code> files. <code>.cmi</code> files do
not contain enough information for complete documentation, but you can
use them to produce partial documentation if the <code>.cmti</code> files are not
available to you.</p>
<p>This intermediate form can be serialised to XML using
<a href="https://github.com/lpw25/doc-ock-xml">doc-ock-xml</a>.</p>
<h4>Future</h4>
<p>In the final version, doc-ock will also support reading <code>.cmt</code> files.</p>
<h3>Resolving references</h3>
<p>Once you have a representation for documentation, you need to resolve
all the paths and references so that links can point to the correct
locations. For example,</p>
<p>(* This type is used by {!Foo} *)
type t = Bar.t</p>
<p>The path <code>Bar.t</code> and the reference <code>Foo</code> must be resolved so that the
documentation can include links to the corresponding definitions.</p>
<p>If you are generating documentation for a large collection of packages, there
may be more than one module called <code>Foo</code>. So it is important to be able
to work out which one of these <code>Foo</code>s the reference is referring to.</p>
<p>Unlike most languages, resolving paths can be very difficult in
OCaml due to the powerful module system. For example, consider the
following code:</p>
<pre><code class="language-ocaml">module Dep1 : sig
 module type S = sig
   class c : object
     method m : int
   end
 end
 module X : sig
   module Y : S
 end
end

module Dep2 :
 functor (Arg : sig module type S module X : sig module Y : S end end) -&gt;
   sig
     module A : sig
       module Y : Arg.S
     end
     module B = A.Y
   end

type dep1 = Dep2(Dep1).B.c;;
</code></pre>
<p>Here it looks like, <code>Dep2(Dep1).B.c</code> would be defined by a type
definition <code>c</code> within the submodule <code>B</code> of the functor <code>Dep2</code>. However,
<code>Dep2.B</code>'s type is actually dependent on the type of <code>Dep2</code>'s <code>Arg</code>
parameter, so the actual definition is the class definition within the
module type <code>S</code> of the <code>Dep1</code> module.</p>
<h4>Past</h4>
<p>OCamldoc does resolution using a very simple string based lookup. This
is not designed to handle collections of projects, where module names
are not unique. It is also not sophisticated enough to handle advanced
uses of OCaml's module system (e.g. it fails to resolve the path
<code>Dep2(Dep1).B.c</code> in the above example).</p>
<h4>Present</h4>
<p>In our current prototype, path and reference resolution are performed by
the <a href="https://github.com/lpw25/doc-ock-lib">doc-ock</a> library. The implementation
amounts to a reimplementation of OCaml's module system that tracks
additional information required to produce accurate paths and references
(it is also lazy to improve performance). The system uses the digests
provided by <code>.cmti</code>/<code>.cmi</code> files to resolve references to other modules,
rather than just relying on the module's name.</p>
<h4>Future</h4>
<p>There are still some paths handled incorrectly by doc-ock-lib, which
will be fixed, but mostly the final version will be the same as the
current prototype.</p>
<h3>Producing output</h3>
<p>Finally, you are ready to produce some output from the tools.</p>
<h4>Past</h4>
<p>OCamldoc supports a variety of output formats, including HTML and
LaTeX. It also includes support for plugins called &quot;custom generators&quot;
which allow users to add support for additional formats.</p>
<h4>Present</h4>
<p><code>codoc</code> only supports HTML and XML output at present, although extra output
formats such as JSON should be very easy to add once the interfaces settle
down.  <code>codoc</code> defines a documentation index XML format for tracking package
hierarchies, documentation issues, and hierarchically localized configuration.</p>
<p><code>codoc</code> also defines a scriptable command-line interface giving users access
to its internal documentation phases: extraction, linking, and rendering. The
latest instructions on how to use the CLI can be found in the
<a href="https://github.com/dsheets/codoc">README</a>.  We provide an OPAM remote with
all the working versions of the new libraries and compiler patches required to
drive the new documentation engine.</p>
<h4>Future</h4>
<p>As previously mentioned, <a href="https://github.com/dsheets/codoc">codoc</a> and its
constituent libraries <a href="https://github.com/lpw25/doc-ock-lib">doc-ock-lib</a>
and <a href="https://github.com/dsheets/doc-ock-xml">doc-ock-xml</a> are still under
heavy development and are not yet feature complete. Notably, there are some
important outstanding issues:</p>
<ol>
<li>Class and class type documentation has no generated HTML. (<a href="https://github.com/dsheets/codoc/issues/9">issue codoc#9</a>)
</li>
<li>CSS is subpar. (<a href="https://github.com/dsheets/codoc/issues/22">issue codoc#27</a>)
</li>
<li>codoc HTML does not understand <code>--package</code>. (<a href="https://github.com/dsheets/codoc/issues/42">issue codoc#42</a>)
</li>
<li>opam doc is too invasive (temporary for demonstration purposes; tracked by (<a href="https://github.com/dsheets/codoc/issues/48">issue codoc#48</a>))
</li>
<li>Documentation syntax errors are not reported in the correct phase or obviously enough. (<a href="https://github.com/dsheets/codoc/issues/58">issue codoc#58</a>)
</li>
<li>Character sets are not handled correctly (<a href="https://github.com/lpw25/doc-ock-lib/issues/43">issue doc-ock-lib#43</a>)
</li>
<li>-pack and cmt extraction are not supported (<a href="https://github.com/lpw25/doc-ock-lib/issues/35">issue doc-ock-lib#35</a> and <a href="https://github.com/lpw25/doc-ock-lib/issues/3">issue doc-ock-lib#3</a>)
</li>
<li>Inclusion/substitution is not supported (<a href="https://github.com/lpw25/doc-ock-lib/issues/2">issue doc-ock-lib#2</a>)
</li>
</ol>
<p>We are very happy to take bug reports and patches at
<a href="https://github.com/dsheets/codoc/issues">https://github.com/dsheets/codoc/issues</a>. For wider suggestions, comments,
complaints and discussions, please join us on the
<a href="http://lists.ocaml.org/listinfo/platform">Platform mailing list</a>.
We do hope that you'll let us know what you think and help us build a next
generation documentation tool which will serve our community admirably.</p>
|js}
  };
 
  { title = {js|Why we use OPAM for XenServer development|js}
  ; slug = {js|opam-in-xenserver|js}
  ; description = {js|???|js}
  ; date = {js|2015-02-18|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><em>This is a guest post from an OPAM user about how they use it.  If you would like to post
about your own use, <a href="https://github.com/ocaml/platform-blog/issues">please let us know</a>.</em></p>
<p><a href="http://www.xenserver.org/">XenServer</a> uses the
<a href="http://www.xenproject.org/">Xen project's</a>
&quot;<a href="http://www.xenproject.org/developers/teams/xapi.html">Xapi toolstack</a>&quot;:
a suite of tools written mostly in OCaml which</p>
<ul>
<li>manages clusters of Xen hosts with shared storage and networking
</li>
<li>allows running VMs to be migrated between hosts (with or without storage)
with minimal downtime
</li>
<li>automatically restarts VMs after host failure
(<a href="http://xapi-project.github.io/features/HA/HA.html">High Availability</a>)
</li>
<li>allows cross-site <a href="http://xapi-project.github.io/features/DR/DR.html">Disaster Recovery</a>
</li>
<li>simplifies maintainence through <a href="http://xapi-project.github.io/features/RPU/RPU.html">Rolling Pool Upgrade</a>
</li>
<li>collects performance statistics for historical analysis and for alerting
</li>
<li>has a full-featured
<a href="http://xapi-project.github.io/xen-api/">XML-RPC based API</a>,
used by clients such as
<a href="https://github.com/xenserver/xenadmin">XenCenter</a>,
<a href="https://xen-orchestra.com">Xen Orchestra</a>,
<a href="http://www.openstack.org">OpenStack</a>
and <a href="http://cloudstack.apache.org">CloudStack</a>
</li>
</ul>
<p>The Xapi toolstack is built from a large set of libraries and components
which are
developed independently and versioned separately. It's easy for us to
share code with other open-source projects like
<a href="http://www.openmirage.org/">Mirage</a>, however
this flexibility comes
with a cost: when one binary such as &quot;xapi&quot; (the cluster manager)
depends on 45 separate libraries,
how do we quickly set up a
build environment?
Exactly which libraries do we need? How do we apply updates?
If we change one of these libraries (e.g. to make a bugfix), exactly which
bits should we rebuild?
This is where <a href="https://opam.ocaml.org">OPAM</a>,
the source package manager, makes everything easy.</p>
<p>Installing a build environment with OPAM is particularly easy.
For example in a CentOS 6.5 VM,
first <a href="https://opam.ocaml.org/doc/Install.html">install OPAM</a>:</p>
<p>and then:</p>
<pre><code>$ opam init --comp=4.01.0
$ eval `opam config env`
</code></pre>
<p>Next install the necessary C libraries and development tools for xapi
using a command like</p>
<pre><code>$ sudo yum install `opam install xapi -e centos`
</code></pre>
<p>Finally to build xapi itself:</p>
<pre><code>$ opam install xapi
  ∗  install obuild                 0.1.1          [required by cdrom, nbd]
  ∗  install base-no-ppx            base           [required by lwt]
  ∗  install cmdliner               0.9.7          [required by nbd, tar-format]
  ∗  install camlp4                 4.01.0         [required by nbd]
  ∗  install ocamlfind              1.5.5          [required by xapi]
  ∗  install xmlm                   1.2.0          [required by xapi-libs-transitional, rpc, xen-api-client]
  ∗  install uuidm                  0.9.5          [required by xapi-forkexecd]
  ∗  install type_conv              111.13.00      [required by rpc]
  ∗  install syslog                 1.4            [required by xapi-forkexecd]
  ∗  install ssl                    0.4.7          [required by xapi]
  ∗  install ounit                  2.0.0          [required by xapi]
  ∗  install omake                  0.9.8.6-0.rc1  [required by xapi]
  ∗  install oclock                 0.4.0          [required by xapi]
  ∗  install libvhd                 0.9.0          [required by xapi]
  ∗  install fd-send-recv           1.0.1          [required by xapi]
  ∗  install cppo                   1.1.2          [required by ocplib-endian]
  ∗  install cdrom                  0.9.1          [required by xapi]
  ∗  install base-bytes             legacy         [required by ctypes, re]
  ∗  install sexplib                111.17.00      [required by cstruct]
  ∗  install fieldslib              109.20.03      [required by cohttp]
  ∗  install lwt                    2.4.7          [required by tar-format, nbd, rpc, xen-api-client]
  ∗  install xapi-stdext            0.12.0         [required by xapi]
  ∗  install stringext              1.2.0          [required by uri]
  ∗  install re                     1.3.0          [required by xapi-forkexecd, tar-format, xen-api-client]
  ∗  install ocplib-endian          0.8            [required by cstruct]
  ∗  install ctypes                 0.3.4          [required by opasswd]
  ∗  install xenctrl                0.9.26         [required by xapi]
  ∗  install rpc                    1.5.1          [required by xapi]
  ∗  install xapi-inventory         0.9.1          [required by xapi]
  ∗  install uri                    1.7.2          [required by xen-api-client]
  ∗  install cstruct                1.5.0          [required by tar-format, nbd, xen-api-client]
  ∗  install opasswd                0.9.3          [required by xapi]
  ∗  install xapi-rrd               0.9.1          [required by xapi-idl, xapi-rrd-transport]
  ∗  install cohttp                 0.10.1         [required by xen-api-client]
  ∗  install xenstore               1.2.5          [required by xapi]
  ∗  install tar-format             0.2.1          [required by xapi]
  ∗  install nbd                    1.0.2          [required by xapi]
  ∗  install io-page                1.2.0          [required by xapi-rrd-transport]
  ∗  install crc                    0.9.0          [required by xapi-rrd-transport]
  ∗  install xen-api-client         0.9.7          [required by xapi]
  ∗  install message-switch         0.10.4         [required by xapi-idl]
  ∗  install xenstore_transport     0.9.4          [required by xapi-libs-transitional]
  ∗  install mirage-profile         0.4            [required by xen-gnt]
  ∗  install xapi-idl               0.9.19         [required by xapi]
  ∗  install xen-gnt                2.2.0          [required by xapi-rrd-transport]
  ∗  install xapi-forkexecd         0.9.2          [required by xapi]
  ∗  install xapi-rrd-transport     0.7.2          [required by xapi-rrdd-plugin]
  ∗  install xapi-tapctl            0.9.2          [required by xapi]
  ∗  install xapi-netdev            0.9.1          [required by xapi]
  ∗  install xapi-libs-transitional 0.9.6          [required by xapi]
  ∗  install xapi-rrdd-plugin       0.6.0          [required by xapi]
  ∗  install xapi                   1.9.56
===== ∗  52 =====
Do you want to continue ? [Y/n] y
</code></pre>
<p>Obviously it's extremely tedious to do all that by hand!</p>
<p>OPAM also makes iterative development very easy.
Consider a scenario where a
<a href="https://github.com/xapi-project/xcp-idl">common interface</a> has to be changed.
Without OPAM we have to figure out which components to rebuild manually--
this is both time-consuming and error-prone. When we want to make some
local changes we simply clone the repo and tell OPAM to &quot;pin&quot; the package
to the local checkout. OPAM will take care of rebuilding only the
dependent packages:</p>
<pre><code>$ git clone git://github.com/xapi-project/xcp-idl
... make some local changes ...
$ opam pin add xapi-idl ./xcp-idl
$ opam install xapi
...
xapi-idl needs to be reinstalled.
The following actions will be performed:
  ↻  recompile xapi-idl               0.9.19*
  ↻  recompile xapi-rrd-transport     0.7.2    [uses xapi-idl]
  ↻  recompile xapi-forkexecd         0.9.2    [uses xapi-idl]
  ↻  recompile xapi-tapctl            0.9.2    [uses xapi-forkexecd]
  ↻  recompile xapi-netdev            0.9.1    [uses xapi-forkexecd]
  ↻  recompile xapi-libs-transitional 0.9.6    [uses xapi-forkexecd]
  ↻  recompile xapi-rrdd-plugin       0.6.0    [uses xapi-idl]
  ↻  recompile xapi                   1.9.56   [uses xapi-idl]
===== ↻  8 =====
Do you want to continue ? [Y/n] 
</code></pre>
<p>It's even easier if you just want to pin to a branch, such as master:</p>
<pre><code>$ opam pin add xapi-idl git://github.com/xapi-project/xcp-idl
</code></pre>
<p>It's important to be able to iterate quickly when testing a bugfix--
OPAM makes this easy too. After making a change to a &quot;pinned&quot; repository
the user just has to type</p>
<pre><code>$ opam update -u
</code></pre>
<p>and only the affected components will be rebuilt.</p>
<p>OPAM allows us to create our own 'development remotes' containing the
latest, bleeding-edge versions of our libraries. To install these unstable
versions we only need to type:</p>
<pre><code>$ opam remote add xapi-project git://github.com/xapi-project/opam-repo-dev
$ opam update -u

=-=- Updating package repositories =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
[xapi-project] git://github.com/xapi-project/opam-repo-dev already up-to-date
[default] /home/djs/ocaml/opam-repository synchronized

Updates available for 4.01.0, apply them with 'opam upgrade':
=== ∗  1   ↻  6   ↗  6 ===
The following actions will be performed:
  ∗  install   xapi-backtrace         0.2               [required by xapi-idl, xapi-stdext]
  ↗  upgrade   xenctrl                0.9.26 to 0.9.28
  ↗  upgrade   xapi-stdext            0.12.0 to 0.13.0
  ↻  recompile xapi-rrd               0.9.1             [uses xapi-stdext]
  ↻  recompile xapi-inventory         0.9.1             [uses xapi-stdext]
  ↗  upgrade   xapi-idl               0.9.19 to 0.9.21
  ↻  recompile xapi-rrd-transport     0.7.2             [uses xapi-idl]
  ↻  recompile xapi-forkexecd         0.9.2             [uses xapi-idl, xapi-stdext]
  ↗  upgrade   xapi-libs-transitional 0.9.6 to 0.9.7
  ↻  recompile xapi-tapctl            0.9.2             [uses xapi-stdext]
  ↻  recompile xapi-netdev            0.9.1             [uses xapi-stdext]
  ↗  upgrade   xapi-rrdd-plugin       0.6.0 to 0.6.1
  ↗  upgrade   xapi                   1.9.56 to 1.9.58
===== ∗  1   ↻  6   ↗  6 =====
Do you want to continue ? [Y/n]
</code></pre>
<p>When a linked set of changes are ready to be pushed, we can make a
<a href="https://github.com/xapi-project/opam-repo-dev/pull/66">single pull request</a>
updating a set of components, which triggers the
<a href="https://travis-ci.org/">travis</a>
integration tests.</p>
<h2>Summary</h2>
<p>The Xapi toolstack is built from a large set of libraries, independently
versioned and released, many of them shared with other projects
(such as <a href="http://www.openmirage.org/">Mirage</a>). The libraries are
easy to build and test separately, but the sheer number of dependencies
makes it difficult to build the whole project -- this is where opam
really shines. OPAM simplifies our day-to-day lives by</p>
<ul>
<li>automatically rebuilding dependent software when dependencies change
</li>
<li>allowing us to share 'development remotes' containing bleeding-edge software
amongst the development team
</li>
<li>allowing us to 'release' a co-ordinated set of versions with a <code>git push</code>
and then trigger integration tests via <a href="https://travis-ci.org/">travis</a>
</li>
</ul>
<p>If you have a lot of OCaml code to build, try OPAM!</p>
|js}
  };
 
  { title = {js|OPAM 1.2 and Travis CI|js}
  ; slug = {js|opam-1-2-travisci|js}
  ; description = {js|???|js}
  ; date = {js|2014-12-18|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>The <a href="https://opam.ocaml.org/blog/opam-1-2-pin/">new pinning feature</a> of OPAM 1.2 enables new interesting
workflows for your day-to-day development in OCaml projects. I will
briefly describe one of them here: simplifying continuous testing with
<a href="https://travis-ci.org/">Travis CI</a> and
<a href="https://github.com/">GitHub</a>.</p>
<h2>Creating an <code>opam</code> file</h2>
<p>As explained in the <a href="https://opam.ocaml.org/blog/opam-1-2-pin/">previous post</a>, adding an <code>opam</code> file at the
root of your project now lets you pin development versions of your
project directly. It's very easy to create a default template with OPAM 1.2:</p>
<pre><code>$ opam pin add &lt;my-project-name&gt; . --edit
[... follow the instructions ...]
</code></pre>
<p>That command should create a fresh <code>opam</code> file; if not, you might
need to fix the warnings in the file by re-running the command. Once
the file is created, you can edit it directly and use <code>opam lint</code> to
check that is is well-formed.</p>
<p>If you want to run tests, you can also mark test-only dependencies with the
<code>{test}</code> constraint, and add a <code>build-test</code> field. For instance, if you use
<code>oasis</code> and <code>ounit</code>, you can use something like:</p>
<pre><code>build: [
  [&quot;./configure&quot; &quot;--prefix=%{prefix}%&quot; &quot;--%{ounit:enable}%-tests&quot;]
  [make]
]
build-test: [make &quot;test&quot;]
depends: [
  ...
  &quot;ounit&quot; {test}
  ...
]
</code></pre>
<p>Without the <code>build-test</code> field, the continuous integration scripts
will just test the compilation of your project for various OCaml
compilers.
OPAM doesn't run tests by default, but you can make it do so by
using <code>opam install -t</code> or setting the <code>OPAMBUILDTEST</code>
environment variable in your local setup.</p>
<h2>Installing the Travis CI scripts</h2>
<p><img style="float:right; padding: 5px"
src="https://travis-ci.com/img/travis-mascot-200px.png"
width="200px">
</img></p>
<p><a href="https://travis-ci.org/">Travis CI</a> is a free service that enables continuous testing on your
GitHub projects. It uses Ubuntu containers and runs the tests for at most 50
minutes per test run.</p>
<p>To use Travis CI with your OCaml project, you can follow the instructions on
<a href="https://github.com/ocaml/ocaml-travisci-skeleton">https://github.com/ocaml/ocaml-travisci-skeleton</a>. Basically, this involves:</p>
<ul>
<li>adding
<a href="https://github.com/ocaml/ocaml-travisci-skeleton/blob/master/.travis.yml">.travis.yml</a>
at the root of your project. You can tweak this file to test your
project with different versions of OCaml. By default, it will use
the latest stable version (today: 4.02.1, but it will be updated for
each new compiler release).  For every OCaml version that you want to
test (supported values for <code>&lt;VERSION&gt;</code> are <code>3.12</code>, <code>4.00</code>,
<code>4.01</code> and <code>4.02</code>) add the line:
</li>
</ul>
<pre><code>env:
 - OCAML_VERSION=&lt;VERSION&gt;
</code></pre>
<ul>
<li>signing in at <a href="https://travis-ci.org/">TravisCI</a> using your GitHub account and
enabling the tests for your project (click on the <code>+</code> button on the
left pane).
</li>
</ul>
<p>And that's it, your project now has continuous integration, using the OPAM 1.2
pinning feature and Travis CI scripts.</p>
<h2>Testing Optional Dependencies</h2>
<p>By default, the script will not try to install the <a href="https://opam.ocaml.org/doc/manual/dev-manual.html#sec9">optional
dependencies</a> specified in your <code>opam</code> file. To do so, you
need to manually specify which combination of optional dependencies
you want to tests using the <code>DEPOPTS</code> environment variable. For
instance, to test <code>cohttp</code> first with <code>lwt</code>, then with <code>async</code> and
finally with both <code>lwt</code> and <code>async</code> (but only on the <code>4.01</code> compiler)
you should write:</p>
<pre><code>env:
   - OCAML_VERSION=latest DEPOPTS=lwt
   - OCAML_VERSION=latest DEPOPTS=async
   - OCAML_VERSION=4.01   DEPOPTS=&quot;lwt async&quot;
</code></pre>
<p>As usual, your contributions and feedback on this new feature are <a href="https://github.com/ocaml/ocaml-travisci-skeleton/issues/">gladly welcome</a>.</p>
|js}
  };
 
  { title = {js|Merlin 2.0 release|js}
  ; slug = {js|merlin-2-0-0-released|js}
  ; description = {js|???|js}
  ; date = {js|2014-11-03|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>After a few months of development, we are pleased to announce the
<a href="https://github.com/the-lambda-church/merlin/blob/master/CHANGELOG">stable release</a> of
<a href="https://github.com/the-lambda-church/merlin">Merlin 2.0</a>.<br />
Supported OCaml versions range from 4.00.1 to 4.02.1.</p>
<h3>Overview</h3>
<p>Merlin is a tool focused on helping you code in OCaml by providing features
such as:</p>
<ul>
<li>automatic completion of identifiers, using scope and type information,
</li>
<li>interactively typing definitions and expressions during edition,
</li>
<li>jumping to the definition of any identifier,
</li>
<li>quickly reporting errors in the editor.
</li>
</ul>
<p>We provide integration into Vim and Emacs.  An external plugin is also
available for <a href="https://github.com/def-lkb/sublime-text-merlin">Sublime Text</a>.</p>
<h3>What's new</h3>
<p>This release provides great improvements in robustness and quality of analysis.
Files that changed on disk are now automatically reloaded.
The parsing process is finer grained to provide more accurate recovery and error
messages.
Integration with Jane Street Core and js_of_ocaml has also improved.</p>
<p>Vim &amp; Emacs are still the main targeted editors.
Thanks to <a href="https://github.com/Cynddl">Luc Rocher</a>, preliminary support for
Sublime Text is also available, see
<a href="https://github.com/def-lkb/sublime-text-merlin">Sublime-text-merlin</a>.
Help is welcome to improve and extend supported editing environments.</p>
<p>Windows support also received some fixes.  Merlin is now distributed in
<a href="http://wodi.forge.ocamlcore.org/">WODI</a>.  Integration in
<a href="http://protz.github.io/ocaml-installer/">OCaml-on-windows</a> is planned.</p>
<h3>Installation</h3>
<p>This new version of Merlin is already available with opam using <code>opam install merlin</code>, and can also be built from the sources which are available at
<a href="http://github.com/the-lambda-church/merlin">the-lambda-church/merlin</a>.</p>
<h3>Changelog</h3>
<p>This is a major release which we worked on for several months, rewriting many
parts of the codebase. An exhaustive list of changes is therefore impossible to
give, but here are some key points (from an user perspective):</p>
<ul>
<li>support for OCaml 4.02.{0,1}
</li>
<li>more precise recovery in presence of syntax errors
</li>
<li>more user-friendly messages for syntax errors
</li>
<li>locate now works on MLI files
</li>
<li>automatic reloading of .merlin files (when they are update or created), it
is no longer necessary to restart Merlin
</li>
<li>introduced a small refactoring command: rename, who renames all occurences
of an identifier. See <a href="http://yawdp.com/~host/merlin_rename.webm">here</a>.
</li>
</ul>
<p>This release also contains contributions from: Yotam Barnoy, Jacques-Pascal
Deplaix, Geoff Gole, Rudi Grinberg, Steve Purcell and Jan Rehders.</p>
<p>We also thank Gabriel Scherer and Jane Street for their continued support.</p>
|js}
  };
 
  { title = {js|OPAM 1.2.0 Released|js}
  ; slug = {js|opam-1-2-0-release|js}
  ; description = {js|???|js}
  ; date = {js|2014-10-23|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are very proud to announce the availability of OPAM 1.2.0.</p>
<h3>Upgrade from 1.1</h3>
<p>Simply follow the usual instructions, using your preferred method (package from
your distribution, binary, source, etc.) as documented on the
<a href="https://opam.ocaml.org/doc/Install.html">homepage</a>.</p>
<blockquote>
<p><strong>NOTE</strong>: There are small changes to the internal repository format (~/.opam).
It will be transparently updated on first run, but in case you might want to
go back and have anything precious there, you're advised to back it up.</p>
</blockquote>
<h3>Usability</h3>
<p>Lot of work has been put into providing a cleaner interface, with helpful
behaviour and messages in case of errors.</p>
<p>The <a href="https://opam.ocaml.org/doc/">documentation pages</a> also have been largely
rewritten for consistency and clarity.</p>
<h3>New features</h3>
<p>This is just the top of the list:</p>
<ul>
<li>A extended and versatile <code>opam pin</code> command. See the
<a href="../opam-1-2-pin">Simplified packaging workflow</a>
</li>
<li>More expressive queries, see for example <code>opam source</code>
</li>
<li>New metadata fields, including source repositories, bug-trackers, and finer
control of package behaviour
</li>
<li>An <code>opam lint</code> command to check the quality of packages
</li>
</ul>
<p>For more detail, see <a href="../opam-1-2-0-beta4">the announcement for the beta</a>,
<a href="https://raw.githubusercontent.com/ocaml/opam/1.2.0/CHANGES">the full changelog</a>,
and <a href="https://github.com/ocaml/opam/issues?q=label%3A%22Feature+Wish%22+milestone%3A1.2+is%3Aclosed">the bug-tracker</a>.</p>
<h3>Package format</h3>
<p>The package format has been extended to the benefit of both packagers and users.
The repository already accepts packages in the 1.2 format, and this won't
affect 1.1 users as a rewrite is done on the server for compatibility with 1.1.</p>
<p>If you are hosting a repository, you may be interested in these
<a href="https://github.com/ocaml/opam/tree/master/admin-scripts">administration scripts</a>
to quickly take advantage of the new features or retain compatibility.</p>
|js}
  };
 
  { title = {js|Binary distribution with 0install|js}
  ; slug = {js|0install-intro|js}
  ; description = {js|0install provides an easy way to distribute binaries to users, complementing OPAM's support for source distribution.|js}
  ; date = {js|2014-10-14|js}
  ; tags = 
 [{js|opam|js}; {js|platform|js}]
  ; body_html = {js|<p><a href="http://0install.net/">0install</a> provides an easy way to distribute binaries to users, complementing OPAM's support for source distribution.</p>
<p>The traditional way to distribute binaries is to make separate packages for recent versions of the more popular Linux distributions (RPMs, Debs, PKGBUILDs, etc), a <code>.pkg</code> for OS X, a <code>setup.exe</code> Windows, etc, plus some generic binaries for users of other systems or who lack root privileges.
This requires a considerable amount of work, and expertise with many different package formats.
0install provides a single format that supports all platforms, meaning that you only need to do the packaging work once (though you should still <em>test</em> on multiple platforms).</p>
<h1>Example: OPAM binaries</h1>
<p>You can install a binary release of OPAM on most systems by first installing the &quot;0install&quot; package from your distribution (&quot;zeroinstall-injector&quot; on older distributions) and then adding OPAM.</p>
<ol>
<li>
<p><a href="http://0install.net/injector.html">Get 0install</a>. For the major Linux distributions:</p>
<pre><code> $ yaourt -S zeroinstall-injector             # Arch Linux
 $ sudo apt-get install zeroinstall-injector  # Debian, Ubuntu, etc
 $ sudo yum install 0install                  # Fedora
 $ sudo yum install zeroinstall-injector      # Red Hat
 $ sudo zypper install zeroinstall-injector   # OpenSUSE
</code></pre>
<p>For OS X: <a href="http://downloads.sourceforge.net/project/zero-install/0install/2.7/ZeroInstall.pkg">ZeroInstall.pkg</a></p>
<p>0install also has <a href="https://0install.de/downloads/">Windows support</a>, but there is currently no Windows binary of OPAM so I didn't publish one with 0install either.</p>
</li>
<li>
<p>Install OPAM:</p>
<pre><code> $ 0install add opam http://tools.ocaml.org/opam.xml
 $ opam --version
 1.1.1
</code></pre>
<p>If you already have an <code>opam</code> command but want to try the 0install version anyway,
just give it a different name (e.g. <code>0install add 0opam http://tools.ocaml.org/opam.xml</code> to create a <code>0opam</code> command).</p>
</li>
</ol>
<p><code>0install add</code> will open a window if a display is available, or show progress on the console if not:</p>
<p><img src="0install-opam.png" alt="" /></p>
<p>If you want to use the console in all cases, use <code>--console</code>.</p>
<p>0install identifies each package with a full URI rather than with a short name.
Here, we are telling 0install to create a local command called <code>opam</code> that runs the program <a href="http://tools.ocaml.org/opam.xml">http://tools.ocaml.org/opam.xml</a>.</p>
<p>0install keeps each package it installs in a separate directory where it won't conflict with anything.
You can see where it put OPAM with the &quot;show&quot; command:</p>
<pre><code>$ 0install show opam
- URI: http://tools.ocaml.org/opam.xml
  Version: 1.1.1
  Path: /home/test/.cache/0install.net/implementations/sha256new_RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA
  
  - URI: http://repo.roscidus.com/utils/aspcud
    Version: 1.9.0
    Path: /home/test/.cache/0install.net/implementations/sha1new=5f838f78e489dabc2e2965ba100f14ae8350cbce
  
  - URI: http://repo.roscidus.com/utils/curl
    Version: 7.32.0-10.20
    Path: (package:rpm:curl:7.32.0-10.20:x86_64)
</code></pre>
<p>OPAM depends on two other programs: <code>aspcud</code> provides a better solver than the internal one and <code>curl</code> is used to download OPAM packages (it also generally needs <code>gcc</code>, <code>m4</code> and <code>patch</code>, but I started with just the ones people are likely to be missing).
In this case, 0install has satisfied the curl dependency using an official Fedora package, but needed to install aspcud using 0install. On Arch Linux, it can use distribution packages for both.
0install will install any required distribution packages using PackageKit, which will prompt the user for permission according to its policy.</p>
<p>You can upgrade (or downgrade) the package by adding a version constraint.
By default, 0install prefers the &quot;stable&quot; version of a program:</p>
<pre><code>$ 0install update opam
A later version (http://tools.ocaml.org/opam.xml 1.2.0-pre4) exists but was not selected.
Using 1.1.1 instead.
To select &quot;testing&quot; versions, use:
0install config help_with_testing True
</code></pre>
<p>You could do as it suggests and tell it to prefer testing versions globally, or you can add a version constraint if you just want to affect this one program:</p>
<pre><code>$ 0install update opam --not-before=1.2.0-pre4
http://tools.ocaml.org/opam.xml: 1.1.1 -&gt; 1.2.0-pre4
</code></pre>
<p>You can also specify an upper bound (<code>--before</code>) or a fixed version (<code>--version</code>) if you prefer.
You can control the versions of dependencies with <code>--version-for</code>.
By the way, 0install supports tab-completion everywhere: it can do completion on the sub-command (<code>update</code>), the application name (<code>opam</code>), the option (<code>--not-before</code>) and even the list of available versions!</p>
<p>Finally, if an upgrade stops a program from working then you can use <code>whatchanged</code> to see the latest changes:</p>
<pre><code>$ 0install whatchanged opam
Last checked    : 2014-08-26 11:00
Last update     : 2014-08-26
Previous update : 2014-07-03

http://tools.ocaml.org/opam.xml: 1.1.1 -&gt; 1.2.0-pre4

To run using the previous selections, use:
0install run /home/tal/.config/0install.net/apps/opam/selections-2014-07-03.xml
</code></pre>
<p>Note: this has a granularity of a day, so you won't see any changes if you're following along, since you didn't have it installed yesterday.</p>
<h2>The package metadata</h2>
<p>If you visit <a href="http://tools.ocaml.org/opam.xml">http://tools.ocaml.org/opam.xml</a> you should see a normal-looking web-page describing the package.
If you view the source in your browser, you'll see that it's actually an XML document with a stylesheet providing the formatting.
Here's an extract:</p>
<pre><code>&lt;group license=&quot;OSI Approved :: GNU Lesser General Public License (LGPL)&quot;&gt;
  &lt;group&gt;
    &lt;requires interface=&quot;http://repo.roscidus.com/utils/aspcud&quot;
              importance=&quot;recommended&quot;&gt;
      &lt;executable-in-var name=&quot;OPAMEXTERNALSOLVER&quot;/&gt;
    &lt;/requires&gt;

    &lt;requires interface=&quot;http://repo.roscidus.com/utils/curl&quot;
              importance=&quot;recommended&quot;&gt;
      &lt;executable-in-var name=&quot;OPAMCURL&quot;/&gt;
    &lt;/requires&gt;

    &lt;command name=&quot;run&quot; path=&quot;opam&quot;/&gt;

    &lt;implementation arch=&quot;Linux-x86_64&quot;
                    id=&quot;sha1new=6e16ff6ee58e39c9ebbed2fb6c6b6cc437b624a4&quot;
                    released=&quot;2014-04-17&quot;
                    stability=&quot;stable&quot;
                    version=&quot;1.1.1&quot;&gt;
      &lt;manifest-digest sha256new=&quot;RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA&quot;/&gt;
      &lt;archive href=&quot;http://test.roscidus.com/archives/opam-Linux-x86_64-1.1.1.tgz&quot;
               size=&quot;1476315&quot;/&gt;
    &lt;/implementation&gt;
</code></pre>
<p>This says that the 64-bit Linux binary for OPAM 1.1.1 is available at the given URL and, when unpacked, has the given SHA256 digest.
It can be run by executing the <code>opam</code> binary within the archive.
It depends on <code>aspcud</code> and <code>curl</code>, which live in other repositories (ideally, these would be the official project sites for these programs, but currently they are provided by a third party).
In both cases, we tell OPAM about the chosen version by setting an environment variable.
The <code>&lt;group&gt;</code> elements avoid repeating the same information for multiple versions.
<code>curl</code> is marked as <code>recommended</code> because, while <a href="http://0install.net/distribution-integration.html">0install supports most distribution package managers</a>, if it can't find a curl package then it's more likely that it failed to find the curl package than that the platform doesn't have curl.</p>
<p>Lower down there is a more complex entry saying how to build from source, which provides a way to generate more binaries, and
the XML is followed by a GPG signature block (formatted as an XML comment so that the document is still valid XML).</p>
<h2>Security</h2>
<p>When you use a program for the first time, 0install downloads the signing GPG key and checks it with the key information service.
If this service knows the key, it saves it as a trusted key for that site.
If not, it prompts you to confirm.
In future, it will check that all updates from that site are signed with the same key, prompting you if not (much like <code>ssh</code> does).</p>
<p>If you would like to see the key information hints rather than having them approved automatically, use <code>0install config auto_approve_keys false</code> or turn off &quot;Automatic approval for new feeds&quot; in the GUI, and untrust the key (right-click on it for a menu):</p>
<p><img src="0install-keys.png" alt="" /></p>
<p>You will then see prompts like this when using a new site for the first time:</p>
<p><img src="0install-key-confirm.png" alt="" /></p>
<h2>Making packages</h2>
<p>Ideally, OPAM's own Git repository would contain an XML file describing its build and runtime dependencies (<code>curl</code> and <code>aspcud</code> in this case) and
how to build binaries from it.
We would then generate the XML for releases from it automatically using tools such as <a href="http://0install.net/0release.html">0release</a>.
However, when trying out 0install you may prefer to package up an existing binary release, and this is what I did for OPAM.</p>
<p>The simplest case is that the binary is in the current directory.
In this case, the XML just describes its dependencies and how to run it, but not how to download the program.
You can create a template XML file using <a href="http://0install.net/0template.html">0template</a> (or just write it yourself):</p>
<pre><code>$ 0install add 0template http://0install.net/tools/0template.xml
$ 0template opam.xml
'opam.xml' does not exist; creating new template.

As it ends with .xml, not .xml.template, I assume you want a feed for
a local project (e.g. a Git checkout). If you want a template for
publishing existing releases, use opam.xml.template instead.

Does your program need to be compiled before it can be used?

1) Generate a source template (e.g. for compiling C source code)
2) Generate a binary template (e.g. for a pre-compiled binary or script)
&gt; 2

Writing opam.xml
</code></pre>
<p>Filling in the blanks, we get:</p>
<pre><code>&lt;?xml version=&quot;1.0&quot;?&gt;
&lt;interface xmlns=&quot;http://zero-install.sourceforge.net/2004/injector/interface&quot;&gt;
  &lt;name&gt;OPAM&lt;/name&gt;
  &lt;summary&gt;OCaml package manager&lt;/summary&gt;

  &lt;description&gt;
    OPAM is an open-source package manager edited by OCamlPro.
    It supports multiple simultaneous compiler installations, flexible
    package constraints, and a Git-friendly development workflow.
  &lt;/description&gt;

  &lt;homepage&gt;https://opam.ocaml.org/&lt;/homepage&gt;

  &lt;feed-for interface=&quot;http://tools.ocaml.org/opam.xml&quot;/&gt;

  &lt;group license=&quot;OSI Approved :: GNU Lesser General Public License (LGPL)&quot;&gt;
    &lt;requires importance=&quot;recommended&quot; interface=&quot;http://repo.roscidus.com/utils/aspcud&quot;&gt;
      &lt;executable-in-var name=&quot;OPAMEXTERNALSOLVER&quot;/&gt;
    &lt;/requires&gt;

    &lt;requires importance=&quot;recommended&quot; interface=&quot;http://repo.roscidus.com/utils/curl&quot;&gt;
      &lt;executable-in-var name=&quot;OPAMCURL&quot;/&gt;
    &lt;/requires&gt;

    &lt;command name=&quot;run&quot; path=&quot;opam&quot;/&gt;

    &lt;implementation arch=&quot;Linux-x86_64&quot; id=&quot;.&quot; local-path=&quot;.&quot; version=&quot;1.1.1&quot;/&gt;
  &lt;/group&gt;
&lt;/interface&gt;
</code></pre>
<p>This is almost the same as the XML above, except that we specify <code>local-path=&quot;.&quot;</code> rather than giving a URL and digest
(see the <a href="http://0install.net/interface-spec.html">Feed file format specification</a> for details).
The <code>&lt;feed-for&gt;</code> says where we will eventually host the public list of all versions.</p>
<p>You can test your XML locally like this:</p>
<pre><code>$ 0install run opam.xml --version
1.1.1

$ 0install select opam.xml          
- URI: /tmp/opam/opam.xml
  Version: 1.1.1
  Path: /tmp/opam
  
  - URI: http://repo.roscidus.com/utils/aspcud
    Version: 1.9.0-1
    Path: (package:arch:aspcud:1.9.0-1:x86_64)
  
  - URI: http://repo.roscidus.com/utils/curl
    Version: 7.37.1-1
    Path: (package:arch:curl:7.37.1-1:x86_64)
</code></pre>
<p>Now we need a way to generate similar XML for released archives on the web.
Rename <code>opam.xml</code> to <code>opam.xml.template</code> and change the <code>&lt;implementation&gt;</code> to:</p>
<pre><code>&lt;implementation arch=&quot;{arch}&quot; version=&quot;{version}&quot;&gt;
  &lt;manifest-digest/&gt;
  &lt;archive href=&quot;http://example.com/archives/opam-{arch}-{version}.tgz&quot;/&gt;
&lt;/implementation&gt;
</code></pre>
<p>If the archive is already published somewhere, you can use the full URL in the <code>&lt;archive&gt;</code>.
If you're making a new release locally, just put the archive in the same directory as the XML and give the leaf only (<code>href=&quot;opam-{arch}-{version}.tgz&quot;</code>).</p>
<p>You can now run <code>0template</code> on the template XML to generate the XML with the hashes, sizes, etc, filled in:</p>
<pre><code>$ 0template opam.xml.template version=1.1.1 arch=Linux-x86_64
Writing opam-1.1.1.xml
</code></pre>
<p>This generates:</p>
<pre><code>&lt;group license=&quot;OSI Approved :: GNU Lesser General Public License (LGPL)&quot;&gt;
  &lt;requires importance=&quot;recommended&quot; interface=&quot;http://repo.roscidus.com/utils/aspcud&quot;&gt;
    &lt;executable-in-var name=&quot;OPAMEXTERNALSOLVER&quot;/&gt;
  &lt;/requires&gt;

  &lt;requires importance=&quot;recommended&quot; interface=&quot;http://repo.roscidus.com/utils/curl&quot;&gt;
    &lt;executable-in-var name=&quot;OPAMCURL&quot;/&gt;
  &lt;/requires&gt;

  &lt;command name=&quot;run&quot; path=&quot;opam&quot;/&gt;

  &lt;implementation arch=&quot;Linux-x86_64&quot;
                  id=&quot;sha1new=6e16ff6ee58e39c9ebbed2fb6c6b6cc437b624a4&quot;
                  released=&quot;2014-08-26&quot;
                  version=&quot;1.1.1&quot;&gt;
    &lt;manifest-digest sha256new=&quot;RUOX6PWGDCHH5TDNEDRHQJ54YZZ4TSAGBB5AEBRNOKSHM3N7XORA&quot;/&gt;
    &lt;archive href=&quot;http://example.com/archives/opam-Linux-x86_64-1.1.1.tgz&quot; size=&quot;1476315&quot;/&gt;
  &lt;/implementation&gt;
&lt;/group&gt;
</code></pre>
<p>You can test this as before:</p>
<pre><code>$ 0install run opam-1.1.1.xml --version
1.1.1
</code></pre>
<p>Finally, you can submit the XML to a repository (which is easy to host yourself) using the <a href="http://0install.net/0repo.html">0repo</a> tool:</p>
<pre><code>$ 0install add 0repo http://0install.net/tools/0repo.xml
[ ... configure your repository ... ]
$ 0repo add opam-1.1.1.xml
</code></pre>
<p>0repo will merge the XML into the repository's master list of versions, upload the archive (or test the URL, if already uploaded), commit the final XML to Git, and push the XML to your web server.
There are simpler ways to get the signed XML, e.g. using <a href="http://0install.net/packaging-binaries.html">0publish-gui</a> for a graphical UI, but
if you're going to release more than one version of one program then the automation (and sanity checking) you get from 0repo is usually worth it.
In my case, I configured 0repo to push the signed XML to a GitHub Pages repository.</p>
<p>There are plenty of ways to extend this.
For the OPAM 1.2 release, instead of adding the official binaries one by one, I used 0template to make a template for the source code,
added the 1.2 source release, and used that to generate the binaries (mainly because I wanted to build in an older docker container so the binaries would work on more systems).
For my own software, I commit an XML file saying how to build it to my Git repository and let <a href="http://0install.net/0release.html">0release</a> handle the whole release process (from tagging the Git repository, to building the binaries in various VMs, to publishing the archives and the final signed XML).
In the future, we hope to integrate this with OPAM so that source and binary releases can happen together.</p>
<h2>Extending 0install</h2>
<p>0install is easy to script.
It has a stable command line interface (and a new <a href="http://0install.net/json-api.html">JSON API</a> too).
There is also an OCaml API, but this is not yet stable (it's still rather Pythonic, as the software was recently <a href="http://roscidus.com/blog/blog/2014/06/06/python-to-ocaml-retrospective/">ported from Python</a>).</p>
<p>For example, I have used 0install to manage Xen images of <a href="http://openmirage.org/">Mirage unikernels</a>.
This command shows the latest binary of the <code>mir-hello</code> unikernel for Xen (downloading it first if needed):</p>
<pre><code>$ 0install download --os=Xen http://test.roscidus.com/mir-console.xml --show
- URI: http://test.roscidus.com/mir-console.xml
  Version: 0.2
  Path: /home/tal/.cache/0install.net/implementations/sha256new_EY2FDE4ECMNCXSRUZ3BSGTJQMFXE2U6C634PBDJKOBUU3SWD5GDA
</code></pre>
<h2>Summary</h2>
<p>0install is a mature cross-platform system for managing software that is included in the repositories of most Linux distributions and is also available for Windows, OS X and Unix.
It is useful to distribute binary executables in cases where users shouldn't have to compile from source.
It supports GPG signature checking, automatic updates, pinned versions and parallel installations of multiple versions.
A single package format is sufficient for all platforms (you still need to create separate binary archives for e.g. OS X and Linux, of course).</p>
<p>0install is a decentralised system, meaning that there is no central repository.
Packages are named by URI and the metadata is downloaded directly from the named repository.
There are some extra services (such as the <a href="http://roscidus.com/0mirror/">default mirror service</a>, the search service and the key information service), but these are all optional.</p>
<p>Using 0install to get OPAM means that all platforms can be supported without the need to package separately for each one, and users who don't wish to install as root still get signature checking, dependency handling and automatic updates.
We hope that 0install will make it easier for you to distribute binaries of your own applications.</p>
<p>My talk at OCaml 2014 (<a href="https://www.youtube.com/watch?v=dYRT6z0NGII&amp;list=UUP9g4dLR7xt6KzCYntNqYcw">video</a>, <a href="https://ocaml.org/meetings/ocaml/2014/0install-slides.pdf">slides</a>) gives more information about 0install and its conversion to OCaml.</p>
|js}
  };
 
  { title = {js|UTop: a much improved interface to the OCaml toplevel|js}
  ; slug = {js|about-utop|js}
  ; description = {js|This is a post about the utop toplevel provided in the OPAM repository as an alternative to the standard OCaml one.|js}
  ; date = {js|2014-08-26|js}
  ; tags = 
 [{js|opam|js}; {js|platform|js}]
  ; body_html = {js|<p><em>This is a post about the <code>utop</code> toplevel provided in the OPAM
repository as an alternative to the standard OCaml one.</em></p>
<p>OCaml comes with an interactive toplevel. If you type <code>ocaml</code> in a
shell you will get a prompt where you can type OCaml code that is
compiled and executed on the fly.</p>
<pre><code>$ ocaml
    OCaml version 4.02.0+dev12-2014-07-30

# 1 + 1;;
- : int = 2
</code></pre>
<p>You can load libraries and your own modules in the toplevel, and it is
great for playing with your code. You'll quickly notice that
the user experience is not ideal, as there is no editing support:
you cannot conveniently change what you type nor can you rewind to
previously typed phrases.</p>
<p>This can be improved by using tools such as
<a href="http://pauillac.inria.fr/~ddr/ledit/">ledit</a> or
<a href="http://freecode.com/projects/rlwrap">rlwrap</a> which adds line editing
support for any program: <code>rlwrap ocaml</code>. This is better but still
doesn't provide fancy features such as context sensitive completion.</p>
<p>That's why <a href="https://github.com/diml/utop">UTop</a> was started. UTop is a
shiny frontend to the OCaml interactive toplevel, which tries to focus
on the user experience and features:</p>
<ul>
<li>interactive line editing
</li>
<li>real-time tab completion of functions and values
</li>
<li>syntax highlighting
</li>
</ul>
<p>And many other things which make life easier for users that have been
added over time.</p>
<h2>What does UTop stand for?</h2>
<p>UTop stands for <code>Universal Toplevel</code>. Universal because it can be used
in a terminal or in Emacs (I originally planned to add a windowed
version using GTK but unfortunately never completed it).</p>
<h2>The UTop prompt</h2>
<p>The utop prompt looks much more 'blinky' than the one of the default
toplevel. Install it using OPAM very simply:</p>
<pre><code>opam install utop
eval `opam config env`  # may not be needed
utop
</code></pre>
<p>This is typically what you see when you start utop:</p>
<pre><code>─( 16:36:52 )─&lt; command 0 &gt;───────────────────────{ counter: 0 }─
utop #
┌───┬────────────┬─────┬───────────┬──────────────┬───────┬─────┐
│Arg│Arith_status│Array│ArrayLabels│Assert_failure│Big_int│Bigar│
└───┴────────────┴─────┴───────────┴──────────────┴───────┴─────┘
</code></pre>
<p>It displays:</p>
<ul>
<li>the time
</li>
<li>the command number
</li>
<li>the macro counter (for Emacs style macros)
</li>
</ul>
<p>The box at the bottom is for completion, which is described in the
next section.</p>
<p>If the colors seem too bright you can type <code>#utop_prompt_fancy_light</code>,
which is better for light backgrounds. This can be set permanently by
adding the line to <code>~/.ocamlinit</code> or by adding <code>profile: light</code> to
<code>~/.utoprc</code>.</p>
<p>The prompt can be customized by the user, by setting the reference
<code>UTop.prompt</code>:</p>
<pre><code>utop # UTop.prompt;;
- : LTerm_text.t React.signal ref = {contents = &lt;abstr&gt;}
</code></pre>
<p><code>LTerm_text.t</code> is for styled text while <code>React.signal</code> means that it
is a reactive signal, from the
<a href="http://erratique.ch/software/react">react</a> library. This makes it very
easy to create a prompt where the time is updated every second for
instance.</p>
<h2>Real-time completion</h2>
<p>This is the main feature that motivated the creation of UTop. UTop makes use
of the compiler internals to find possible completions on:</p>
<ul>
<li>function names
</li>
<li>function argument names
</li>
<li>constructor names
</li>
<li>record fields
</li>
<li>method names
</li>
</ul>
<p>Instead of the classic way of displaying a list of words when the user
press TAB, I chose to dynamically display the different
possibilities as the user types. This idea comes from the dmenu tool
from the <a href="http://dwm.suckless.org/">dwm</a> window manager.</p>
<p>The possible completions are displayed in the completion bar below the
prompt. It is possible to navigate in the list by using the meta key
(<code>Alt</code> by default most of the time) and the left and right arrows. A
word can be selected by pressing the meta key and <code>TAB</code>. Also pressing
just <code>TAB</code> will insert the longest common prefix of all possibilities.</p>
<h2>Syntax highlighting</h2>
<p>UTop can do basic syntax highlighting. This is disabled by default but
can be enabled by writing a <code>~/.utoprc</code> file. You can copy one from
the repository, either for
<a href="https://github.com/diml/utop/blob/master/utoprc-dark">dark background</a>
or
<a href="https://github.com/diml/utop/blob/master/utoprc-light">light background</a>.</p>
<h2>Emacs integration</h2>
<p>As said earlier UTop can be run in Emacs. Instructions to set this up
can be found in <a href="https://github.com/diml/utop">UTop's readme</a>. The
default toplevel can also be run this way but UTop is better in the
following respects:</p>
<ol>
<li>it provides context-sensitive completion
</li>
<li>it behaves like a real shell, i.e. you cannot delete the prompt
</li>
</ol>
<p>They are several Emacs libraries for writing shell-like modes but I
wrote my own because with all of the ones I found it is possible to
insert or remove characters from the prompt, which I found frustrating
Even with the mode used by the Emacs Shell mode it is
possible. AFAIK at the time I wrote it the UTop mode was the only one
where it was really impossible to edit the something in the <em>frozen</em>
part of the buffer.</p>
<h2>Other features</h2>
<p>This is a non-exhaustive list of features that have been added over
time to enhance the user experience. Some of them might be
controversial, so I tried to choose what was the most requested most of
the time.</p>
<ul>
<li>when using the <a href="http://ocsigen.org/lwt/">lwt</a> or
<a href="https://github.com/janestreet/async">async</a> libraries, UTop will
automatically wait for ['a Lwt.t] or ['a Deferred.t] values and
return the ['a] instead
</li>
<li>made <code>-short-paths</code> the default. This option allow to display
shorter types when using packed libraries such as
<a href="https://github.com/janestreet/core">core</a>
</li>
<li>hide identifiers starting with <code>_</code> to the user. This is for hiding
the churn generated by syntax extensions. This can be disabled with
<code>UTop.set_hide_reserved</code> or with the command line argument
<code>-show-reserved</code>.
</li>
<li>automatically load <code>camlp4</code> when the user requests a syntax
extension. In the default toplevel one has to type <code>#camlp4</code> first.
</li>
<li>hide verbose messages from the <code>findlib</code> library manager.
</li>
<li>add a <code>typeof</code> directive to show the type of modules and values.
</li>
<li>automatically load files from <code>$OCAML_TOPLEVEL_PATH/autoload</code> at
startup.
</li>
<li>allow to specify libraries to be loaded on the command line.
</li>
</ul>
<h2>Libraries developed to support UTop</h2>
<p>For the needs of UTop I wrote
<a href="https://github.com/diml/lambda-term">lambda-term</a>, which is kind of
an equivalent of ncurses+readline, but written in OCaml. It was
written because I wasn't happy with the ncurses API and I wanted something more
fancy than readline, especially for completion. In the end I believe
that it is much more fun to write terminal applications in OCaml using
lambda-term.</p>
<p>The pure editing part is managed by the
<a href="https://github.com/diml/zed">zed</a> library, which is independent from
the user interface.</p>
<h2>UTop development</h2>
<p>Utop is fairly feature-complete, and so I don't spend much time on it
these days. It became the recommended toplevel to use with the
<a href="https://realworldocaml.org">Real World OCaml</a> book, and most users
are happier with the interactive interface than using the traditional
toplevel.</p>
<p>Many thanks to <a href="https://github.com/whitequark">Peter Zotov</a> who recently joined
the project to keep it up-to-date and add new features such as extension point
support. Contributions from others (particularly around editor integration) are
very welcome, so if you are interested on hacking on it get in touch via the
<a href="https://github.com/diml/utop">GitHub issue tracker</a> or via the <a href="http://lists.ocaml.org/listinfo/platform">OCaml Platform
mailing list</a>.</p>
|js}
  };
 
  { title = {js|Turn your editor into a full fledged OCaml IDE|js}
  ; slug = {js|turn-your-editor-into-an-ocaml-ide|js}
  ; description = {js|???|js}
  ; date = {js|2014-08-21|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>This post is a short presentation of a couple of tools you can use with your
editor to have a smoother experience while developing in OCaml.  We are working
towards making these tools work out-of-the-box with OPAM, and hence will be
blogging about them here along with the OPAM tool itself.</p>
<p>At the time of writing, interfaces to these tools are available for
Emacs and Vim.  Efforts are underway to add support for other editors,
including <a href="https://github.com/raphael-proust/merlin-acme">Acme</a> and
<a href="https://github.com/def-lkb/sublime-text-merlin">Sublime Text 3</a>.</p>
<h1>Overview</h1>
<p>The first tool, <a href="http://www.typerex.org/ocp-indent.html">ocp-indent</a>,
handles the task of indenting your OCaml files.  It is an OCaml executable that
can be used from the command line or directly from your editor.</p>
<p>The second tool, <a href="http://the-lambda-church.github.io/merlin/">merlin</a> performs
&quot;static analysis&quot; of your source files.  The analysis is then used to provide error reporting, source
browsing, auto-completion and more.</p>
<h2>Ocp-indent for indentation</h2>
<p>Most editors provide some kind of indentation &quot;out of the box&quot;.
However recently a good chunk of the OCaml community has moved to using
ocp-indent for fine-tuned indentation:</p>
<ul>
<li>it follows language evolution closely, nicely handling recent features,
</li>
<li>it will indent the same even if your co-worker has a different editor,
</li>
<li>it is more flexible, for instance by supporting project-specific styles;
</li>
</ul>
<p>Indeed the indentation behaviour of ocp-indent can be configured through several
options, directing how it will behave when encountering different OCaml language constructs.
These options can either be set in a configuration file (such as
<a href="https://github.com/OCamlPro/ocp-indent/blob/master/.ocp-indent">this example configuration</a>)
or passed directly as parameters when ocp-indent is invoked from the command line.</p>
<p>Finally, ocp-indent will also recognize a number of common syntax extensions of the
OCaml ecosystem and indent them meaningfully, while your editor probably will not.</p>
<h2>Merlin for analysis</h2>
<p>Merlin enhances your experience editing OCaml code by providing interactive
feedback about your code.</p>
<p>Under the hood, it maintains a &quot;code model&quot; of the file you are editing.  For
other files in your project, it will use the output produced by the compiler;
rebuild regularly after editing to keep the model synchronized with your code.</p>
<p>From this code model, it provides a lot of useful features:</p>
<ul>
<li>scope/context-aware completion, like IntelliSense;
</li>
<li>querying the type of any expression in the file;
</li>
<li>quick reporting of type and syntax errors, shortening the editing cycle;
</li>
<li>jumping to definitions;
</li>
<li>listing uses of identifiers in the current buffer.
</li>
</ul>
<p><img src="turn-your-editor-into-an-ocaml-ide-merlin.png" alt="" /></p>
<h1>Quick start</h1>
<p>Assuming opam is already installed on your system, you just need to invoke</p>
<pre><code>$ opam install ocp-indent merlin
</code></pre>
<p>to install these two tools.</p>
<p><strong>Emacs.</strong> You will have to add <code>opam/share</code> to <code>'load-path</code> and then load the plugin-specific
file.  This can be done by adding the following lines to your <code>.emacs</code>:</p>
<pre><code class="language-lisp">(setq opam-share (substring (shell-command-to-string &quot;opam config var share 2&gt; /dev/null&quot;) 0 -1))
(add-to-list 'load-path (concat opam-share &quot;/emacs/site-lisp&quot;))

(require 'ocp-indent)
(require 'merlin)
</code></pre>
<p>For more information about merlin setup, you can look at
<a href="https://github.com/the-lambda-church/merlin/wiki">the dedicated merlin wiki</a>.</p>
<p><strong>Vim &amp; ocp-indent.</strong>  We recommend using the
<a href="https://github.com/def-lkb/ocp-indent-vim">ocp-indent-vim</a> plugin instead of
the default one. It provides interactive indentation &quot;as you type&quot;, while the
official mode only provides an indenting function to call manually but
no passive indentation.</p>
<p>This mode does require vim to be compiled with Python support, while the
official one doesn't.</p>
<p>Installing is as simple as cloning
<a href="https://github.com/def-lkb/ocp-indent-vim">ocp-indent-vim</a> and adding the
directory to your runtime-path.</p>
<p>Assuming your clone is in <code>~/my-clone-of/ocp-indent-vim</code>, add this to <code>.vimrc</code>:</p>
<pre><code class="language-viml">set rtp+=~/my-clone-of/ocp-indent-vim
</code></pre>
<p><strong>Vim &amp; merlin.</strong>  A comprehensive guide to the installation procedure for
merlin is available on <a href="https://github.com/the-lambda-church/merlin/wiki">the dedicated
merlin wiki</a>.  Once again, if you
just want to get started the following lines contain everything you need.</p>
<p>Loading merlin in vim boils down to adding the plugin directory to the
runtime path. However as merlin depends on your current opam switch, a more
flexible way is to find the current switch and use it as the base directory.</p>
<p>This code does exactly that: it finds the current opam share directory, then adds
the merlin plugin subdirectory to the current runtime path. Add it to your <code>.vimrc</code>:</p>
<pre><code class="language-viml">let g:opamshare = substitute(system('opam config var share'),'\\n$','','''')
execute &quot;set rtp+=&quot; . g:opamshare . &quot;/merlin/vim&quot;
</code></pre>
<h2>Integrating with your project</h2>
<p>To maintain synchronization with the compiler, merlin needs some information
about the structure of your project: build and source directories, package
dependencies, syntax extensions.  This structure can be described in a <code>.merlin</code> file in the root directory of your project.
The <a href="https://github.com/the-lambda-church/merlin/blob/master/.merlin"><code>.merlin</code> file for the merlin project</a> illustrates the syntax.</p>
<p>The <code>.merlin</code> file will be loaded the next time you open an OCaml file in the editor.</p>
<p>To benefit from code navigation across files you'll also need to turn on
generation of &quot;cmt&quot; files by passing the <code>-bin-annot</code> flag to the OCaml
compiler.  You can do this in <code>ocamlbuild</code> by adding the <code>bin_annot</code> tag
into the <code>_tags</code> file with OCaml 4.01 and higher.</p>
|js}
  };
 
  { title = {js|OPAM 1.2: Repository Pinning|js}
  ; slug = {js|opam-1-2-pin|js}
  ; description = {js|???|js}
  ; date = {js|2014-08-19|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><img style="float:left; padding: 5px" src="camel-pin.jpg" width="200px"></img></p>
<p>Most package managers support some <em>pin</em> functionality to ensure that a given
package remains at a particular version without being upgraded.
The stable OPAM 1.1 already supported this by allowing any existing package to be
pinned to a <em>target</em>, which could be a specific released version, a local filesystem
path, or a remote version-controlled repository.</p>
<p>However, the OPAM 1.1 pinning workflow only lets you pin packages that <em>already exist</em> in your OPAM
repositories. To declare a new package, you had to go through creating a
local repository, registering it in OPAM, and adding your package definition there.
That workflow, while reasonably clear, required the user to know about the repository
format and the configuration of an internal repository in OPAM before actually getting to
writing a package. Besides, you were on your own for writing the package
definition, and the edit-test loop wasn't as friendly as it could have been.</p>
<p>A natural, simpler workflow emerged from allowing users to <em>pin</em> new package
names that don't yet exist in an OPAM repository:</p>
<ol>
<li>choose a name for your new package
</li>
<li><code>opam pin add</code> in the development source tree
</li>
<li>the package is created on-the-fly and registered locally.
</li>
</ol>
<p>To make it even easier, OPAM can now interactively help you write the
package definition, and you can test your updates with a single command.
This blog post explains this new OPAM 1.2 functionality in more detail;
you may also want to check out the new <a href="https://opam.ocaml.org/doc/1.2/Packaging.html" title="OPAM 1.2 doc preview, packaging guide">Packaging tutorial</a>
relying on this workflow.</p>
<h3>From source to package</h3>
<p>For illustration purposes in this post I'll use a tiny tool that I wrote some time ago and
never released: <a href="https://github.com/OCamlPro/ocp-reloc" title="ocp-reloc repo on Github">ocp-reloc</a>.  It's a simple binary that fixes up the
headers of OCaml bytecode files to make them relocatable, which I'd like
to release into the public OPAM repository.</p>
<h4>&quot;opam pin add&quot;</h4>
<p>The command <code>opam pin add &lt;name&gt; &lt;target&gt;</code> pins package <code>&lt;name&gt;</code> to
<code>&lt;target&gt;</code>. We're interested in pinning the <code>ocp-reloc</code> package
name to the project's source directory.</p>
<pre><code>cd ocp-reloc
opam pin add ocp-reloc .
</code></pre>
<p>If <code>ocp-reloc</code> were an existing package, the metadata would be fetched from
the package description in the OPAM repositories. Since the package doesn't yet exist,
OPAM 1.2 will instead prompt for on-the-fly creation:</p>
<pre><code>Package ocp-reloc does not exist, create as a NEW package ? [Y/n] y
ocp-reloc is now path-pinned to ~/src/ocp-reloc
</code></pre>
<blockquote>
<p>NOTE: if you are using <strong>beta4</strong>, you may get a <em>version-control</em>-pin instead,
because we added auto-detection of version-controlled repos. This turned out to
be confusing (<a href="https://github.com/ocaml/opam/issues/1582">issue #1582</a>),
because your changes wouldn't be reflected until you commit, so
this has been reverted in favor of a warning. Add the <code>--kind path</code> option to
make sure that you get a <em>path</em>-pin.</p>
</blockquote>
<h4>OPAM Package Template</h4>
<p>Now your package still needs some kind of definition for OPAM to acknowledge it;
that's where templates kick in, the above triggering an editor with a pre-filled
<code>opam</code> file that you just have to complete. This not only saves time in
looking up the documentation, it also helps getting consistent package
definitions, reduces errors, and promotes filling in optional but recommended
fields (homepage, etc.).</p>
<pre><code>opam-version: &quot;1.2&quot;
name: &quot;ocp-reloc&quot;
version: &quot;0.1&quot;
maintainer: &quot;Louis Gesbert &lt;louis.gesbert@ocamlpro.com&gt;&quot;
authors: &quot;Louis Gesbert &lt;louis.gesbert@ocamlpro.com&gt;&quot;
homepage: &quot;&quot;
bug-reports: &quot;&quot;
license: &quot;&quot;
build: [
  [&quot;./configure&quot; &quot;--prefix=%{prefix}%&quot;]
  [make]
]
install: [make &quot;install&quot;]
remove: [&quot;ocamlfind&quot; &quot;remove&quot; &quot;ocp-reloc&quot;]
depends: &quot;ocamlfind&quot; {build}
</code></pre>
<p>After adding some details (most importantly the dependencies and
build instructions), I can just save and exit.  Much like other system tools
such as <code>visudo</code>, it checks for syntax errors immediately:</p>
<pre><code>[ERROR] File &quot;/home/lg/.opam/4.01.0/overlay/ocp-reloc/opam&quot;, line 13, character 35-36: '.' is not a valid token.
Errors in /home/lg/.opam/4.01.0/overlay/ocp-reloc/opam, retry editing ? [Y/n]
</code></pre>
<h4>Installation</h4>
<p>You probably want to try your brand new package right away, so
OPAM's default action is to try and install it (unless you specified <code>-n</code>):</p>
<pre><code>ocp-reloc needs to be installed.
The following actions will be performed:
 - install   cmdliner.0.9.5                        [required by ocp-reloc]
 - install   ocp-reloc.0.1*
=== 1 to install ===
Do you want to continue ? [Y/n]
</code></pre>
<p>I usually don't get it working the first time around, but <code>opam pin edit ocp-reloc</code> and <code>opam install ocp-reloc -v</code> can be used to edit and retry until
it does.</p>
<h4>Package Updates</h4>
<p>How do you keep working on your project as you edit the source code, now that
you are installing through OPAM? This is as simple as:</p>
<pre><code>opam upgrade ocp-reloc
</code></pre>
<p>This will pick up changes from your source repository and reinstall any packages
that are dependent on <code>ocp-reloc</code> as well, if any.</p>
<p>So far, we've been dealing with the metadata locally used by your OPAM
installation, but you'll probably want to share this among developers of your
project even if you're not releasing anything yet. OPAM takes care of this
by prompting you to save the <code>opam</code> file back to your source tree, where
you can commit it directly into your code repository.</p>
<pre><code>cd ocp-reloc
git add opam
git commit -m 'Add OPAM metadata'
git push
</code></pre>
<h3>Publishing your New Package</h3>
<p>The above information is sufficient to use OPAM locally to integrate new code
into an OPAM installation.  Let's look at how other developers can share this
metadata.</p>
<h4>Picking up your development package</h4>
<p>If another developer wants to pick up <code>ocp-reloc</code>, they can directly use
your existing metadata by cloning a copy of your repository and issuing their
own pin.</p>
<pre><code>git clone git://github.com/OCamlPro/ocp-reloc.git
opam pin add ocp-reloc/
</code></pre>
<p>Even specifying the package name is optional since this is documented in
<code>ocp-reloc/opam</code>. They can start hacking, and if needed use <code>opam pin edit</code> to
amend the opam file too. No need for a repository, no need to share anything more than a
versioned <code>opam</code> file within your project.</p>
<h4>Cloning already existing packages</h4>
<p>We have been focusing on an unreleased package, but the same
functionality is also of great help in handling existing packages, whether you
need to quickly hack into them or are just curious.  Let's consider how to
modify the <a href="https://github.com/ocaml/omd" title="OMD page on Github"><code>omd</code> Markdown library</a>.</p>
<pre><code>opam source omd --pin
cd omd.0.9.7
...patch...
opam upgrade omd
</code></pre>
<p>The new <code>opam source</code> command will clone the source code of the library you
specify, and the <code>--pin</code> option will also pin it locally to ensure it is used
in preference to all other versions.  This will also take care of recompiling
any installed packages that are dependent on <code>omd</code> using your patched version
so that you notice any issues right away.</p>
<blockquote>
<p>There's a new OPAM field available in 1.2 called <code>dev-repo</code>.  If you specify
this in your metadata, you can directly pin to the upstream repository via
<code>opam source --dev-repo --pin</code>.</p>
</blockquote>
<p>If the upstream repository for the package contains an <code>opam</code> file, that file will be picked up
in preference to the one from the OPAM repository as soon as you pin the package.
The idea is to have:</p>
<ul>
<li>a <em>development</em> <code>opam</code> file that is versioned along with your source code
(and thus accurately tracks the latest dependencies for your package).
</li>
<li>a <em>release</em> <code>opam</code> file that is published on the OPAM repository and can
be updated independently without making a new release of the source code.
</li>
</ul>
<p>How to get from the former to the latter will be the subject of another post!
In the meantime, all users of the <a href="../opam-1-2-0-beta4" title="OPAM 1.2.0 beta4 announcement">beta</a> are welcome to share their
experience and thoughts on the new workflow on the <a href="https://github.com/ocaml/opam/issues" title="OPAM bug-tracker on Github">bug tracker</a>.</p>
|js}
  };
 
  { title = {js|OPAM 1.2.0 public beta released|js}
  ; slug = {js|opam-1-2-0-beta4|js}
  ; description = {js|???|js}
  ; date = {js|2014-08-14|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>It has only been 18 months since the first release of OPAM, but it is already
difficult to remember a time when we did OCaml development without it.  OPAM
has helped bring together much of the open-source code in the OCaml community
under a single umbrella, making it easier to discover, depend on, and maintain
OCaml applications and libraries.  We have seen steady growth in the number
of new packages, updates to existing code, and a diverse group of contributors.
<a href="packages.png"><img style="float:right; padding: 5px" src="packages.png" width="350px" /></a></p>
<p>OPAM has turned out to be more than just another package manager. It is also
increasingly central to the demanding workflow of industrial OCaml development,
since it supports multiple simultaneous (patched) compiler installations,
sophisticated package version constraints that ensure statically-typed code can
be recompiled without conflict, and a distributed workflow that integrates
seamlessly with Git, Mercurial or Darcs version control.  OPAM tracks multiple
revisions of a single package, thereby letting packages rely on older
interfaces if they need to for long-term support. It also supports multiple
package repositories, letting users blend the global stable package set with
their internal revisions, or building completely isolated package universes for
closed-source products.</p>
<p>Since its initial release, we have been learning from the extensive feedback
from our users about how they use these features as part of their day-to-day
workflows.  Larger projects like <a href="http://wiki.xen.org/wiki/XAPI">XenAPI</a>, the <a href="http://ocsigen.org">Ocsigen</a> web suite,
and the <a href="http://openmirage.org">Mirage OS</a> publish OPAM <a href="https://opam.ocaml.org/doc/Advanced_Usage.html#Handlingofrepositories">remotes</a> that build
their particular software suites.
Complex applications such as the <a href="https://github.com/facebook/pfff/wiki/Main">Pfff</a> static analysis tool and <a href="https://code.facebook.com/posts/264544830379293/hack-a-new-programming-language-for-hhvm/">Hack</a>
language from Facebook, the <a href="https://github.com/frenetic-lang/frenetic">Frenetic</a> SDN language and the <a href="http://arakoon.org">Arakoon</a>
distributed key store have all appeared alongside these libraries.
<a href="https://www.janestreet.com">Jane Street</a> pushes regular releases of their
production <a href="http://janestreet.github.io/">Core/Async</a> suite every couple
of weeks.</p>
<p>One pleasant side-effect of the growing package database has been the
contribution of tools from the community that make the day-to-day use of OCaml
easier.  These include the <a href="https://github.com/diml/utop">utop</a> interactive toplevel, the <a href="https://github.com/andrewray/iocaml">IOCaml</a>
browser notebook, and the <a href="https://github.com/the-lambda-church/merlin">Merlin</a> IDE extension.  While these tools are an
essential first step, there's still some distance to go to make the OCaml
development experience feel fully integrated and polished.</p>
<p>Today, we are kicking off the next phase of evolution of OPAM and starting the
journey towards building an <em>OCaml Platform</em> that combines the OCaml compiler
toolchain with a coherent workflow for build, documentation, testing and IDE
integration. As always with OPAM, this effort has been a collaborative effort,
coordinated by the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml Labs</a> group in Cambridge and
<a href="http://www.ocamlpro.com">OCamlPro</a> in France.
The OCaml Platform builds heavily on OPAM, since it forms the substrate that
pulls together the tools and facilitates a consistent development workflow.
We've therefore created this blog on <a href="https://opam.ocaml.org">opam.ocaml.org</a> to chart its progress,
announce major milestones, and eventually become a community repository of all
significant activity.</p>
<p>Major points:</p>
<ul>
<li>
<p><strong>OPAM 1.2 beta available</strong>:
Firstly, we're announcing <strong>the availability of the OPAM 1.2 beta</strong>,
which includes a number of new features, hundreds of bug fixes, and pretty
new colours in the CLI.  We really need your feedback to ensure a polished
release, so please do read the release notes below.</p>
</li>
<li>
<p>In the coming weeks, we will provide an overview of what the OCaml Platform is
(and is not), and describe an example workflow that the Platform can enable.</p>
</li>
<li>
<p><strong>Feedback</strong>: If you have questions or comments as you read these posts,
then please do join the <a href="http://lists.ocaml.org/listinfo/platform">platform@lists.ocaml.org</a> and make
them known to us.</p>
</li>
</ul>
<h2>Releasing the OPAM 1.2 beta4</h2>
<p>We are proud to announce the latest beta of OPAM 1.2.  It comes packed with
<a href="https://github.com/ocaml/opam/issues?q=label%3A%22Feature+Wish%22+milestone%3A1.2+is%3Aclosed" title="Features added in 1.2 from the tracker on Github">new features</a>, stability and usability improvements. Here the
highlights.</p>
<h3>Binary RPMs and DEBs!</h3>
<p>We now have binary packages available for Fedora 19/20, CentOS 6/7, RHEL7,
Debian Wheezy and Ubuntu!  You can see the full set at the <a href="https://build.opensuse.org/package/show/home:ocaml/opam#">OpenSUSE Builder</a> site and
<a href="http://software.opensuse.org/download.html?project=home:ocaml&amp;package=opam">download instructions</a> for your particular platform.</p>
<p>An OPAM binary installation doesn't need OCaml to be installed on the system, so you
can initialize a fresh, modern version of OCaml on older systems without needing it
to be packaged there.
On CentOS 6 for example:</p>
<pre><code>cd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/home:ocaml/CentOS_6/home:ocaml.repo
yum install opam
opam init --comp=4.01.0
</code></pre>
<h3>Simpler user workflow</h3>
<p>For this version, we focused on improving the user interface and workflow. OPAM
is a complex piece of software that needs to handle complex development
situations. This implies things might go wrong, which is precisely when good
support and error messages are essential.  OPAM 1.2 has much improved stability
and error handling: fewer errors and more helpful messages plus better state backups
when they happen.</p>
<p>In particular, a clear and meaningful explanation is extracted from the solver
whenever you are attempting an impossible action (unavailable package,
conflicts, etc.):</p>
<pre><code>$ opam install mirage-www=0.3.0
The following dependencies couldn't be met:
  - mirage-www -&gt; cstruct &lt; 0.6.0
  - mirage-www -&gt; mirage-fs &gt;= 0.4.0 -&gt; cstruct &gt;= 0.6.0
Your request can't be satisfied:
  - Conflicting version constraints for cstruct
</code></pre>
<p>This sets OPAM ahead of many other package managers in terms of
user-friendliness.  Since this is made possible using the tools from
<a href="http://www.irill.org" title="IRILL">irill</a> (which are also used for <a href="https://qa.debian.org/dose/debcheck/testing_main/" title="Debian Weather Service">Debian</a>), we hope that
this work will find its way into other package managers.
The extra analyses in the package solver interface are used to improve the
health of the central package repository, via the <a href="http://ows.irill.org" title="The OPAM Weather Service">OPAM Weather service</a>.</p>
<p>And in case stuff does go wrong, we added the <code>opam upgrade --fixup</code>
command that will get you back to the closest clean state.</p>
<p>The command-line interface is also more detailed and convenient, polishing and
documenting the rough areas.  Just run <code>opam &lt;subcommand&gt; --help</code> to see the
manual page for the below features.</p>
<ul>
<li>
<p>More expressive queries based on dependencies.</p>
<pre><code>$ opam list --depends-on cow --rec
# Available packages recursively depending on cow.0.10.0 for 4.01.0:
cowabloga   0.0.7  Simple static blogging support.
iocaml      0.4.4  A webserver for iocaml-kernel and iocamljs-kernel.
mirage-www  1.2.0  Mirage website (written in Mirage)
opam2web    1.3.1 (pinned)  A tool to generate a website from an OPAM repository
opium       0.9.1  Sinatra like web toolkit based on Async + Cohttp
stone       0.3.2  Simple static website generator, useful for a portfolio or documentation pages
</code></pre>
</li>
<li>
<p>Check on existing <code>opam</code> files to base new packages from.</p>
<pre><code>$ opam show cow --raw
opam-version: &quot;1&quot;
name: &quot;cow&quot;
version: &quot;0.10.0&quot;
[...]
</code></pre>
</li>
<li>
<p>Clone the source code for any OPAM package to modify or browse the interfaces.</p>
<pre><code>$ opam source cow
Downloading archive of cow.0.10.0...
[...]
$ cd cow.0.10.0
</code></pre>
</li>
</ul>
<p>We've also improved the general speed of the tool to cope with the much bigger
size of the central repository, which will be of importance for people building
on low-power ARM machines, and added a mechanism that will let you install
newer releases of OPAM directly from OPAM if you choose so.</p>
<h3>Yet more control for the packagers</h3>
<p>Packaging new libraries has been made as straight-forward as possible.
Here is a quick overview, you may also want to check the <a href="../opam-1-2-pin" title="Blog post on OPAM Pin">OPAM 1.2 pinning</a> post.</p>
<pre><code>opam pin add &lt;name&gt; &lt;sourcedir&gt;
</code></pre>
<p>will generate a new package on the fly by detecting the presence of an <code>opam</code>
file within the source repository itself.  We'll do a followup post next week
with more details of this extended <code>opam pin</code> workflow.</p>
<p>The package description format has also been extended with some new fields:</p>
<ul>
<li><code>bug-reports:</code> and <code>dev-repo:</code> add useful URLs
</li>
<li><code>install:</code> allows build and install commands to be split,
</li>
<li><code>flags:</code> is an entry point for several extensions that can affect your package.
</li>
</ul>
<p>Packagers can limit dependencies in scope by adding one
of the keywords <code>build</code>, <code>test</code> or <code>doc</code> in front of their constraints:</p>
<pre><code>depends: [
  &quot;ocamlfind&quot; {build &amp; &gt;= 1.4.0}
  &quot;ounit&quot; {test}
]
</code></pre>
<p>Here you don't specifically require <code>ocamlfind</code> at runtime, so changing it
won't trigger recompilation of your package. <code>ounit</code> is marked as only required
for the package's <code>build-test:</code> target, <em>i.e.</em> when installing with
<code>opam install -t</code>.  This will reduce the amount of (re)compilation required
in day-to-day use.</p>
<p>We've also made optional dependencies more consistent by <em>removing</em> version
constraints from the <code>depopts:</code> field: their meaning was <a href="https://github.com/ocaml/opam/issues/200">unclear</a> and confusing.
The <code>conflicts</code> field is used to indicate versions of the optional dependencies
that are incompatible with your package to remove all ambiguity:</p>
<pre><code>depopts: [ &quot;async&quot; {&gt;= &quot;109.15.00&quot;} &amp; &quot;async_ssl&quot; {&gt;= &quot;111.06.00&quot;} ]
</code></pre>
<p>becomes:</p>
<pre><code>depopts: [ &quot;async&quot; &quot;async_ssl&quot; ]
conflicts: [ &quot;async&quot; {&lt; &quot;109.15.00&quot;}
             &quot;async_ssl&quot; {&lt; &quot;111.06.00&quot;} ]
</code></pre>
<p>There is an <a href="https://github.com/ocaml/opam/pull/1325" title="PR for preliminary 'features' feature on Github">upcoming <code>features</code> field</a> that will give more
flexibility in a clearer and consistent way for such complex cases.</p>
<h3>Easier to package and install</h3>
<p>Efforts were made on the build of OPAM itself as well to make it as easy as possible
to compile, bootstrap or install.  There is no more dependency on camlp4 (which has
been moved out of the core distribution in OCaml 4.02.0), and the build process
is more conventional (get the source, run <code>./configure</code>, <code>make lib-ext</code> to get the few
internal dependencies, <code>make</code> and <code>make install</code>).  Packagers can use <code>make cold</code>
to build OPAM with a locally compiled version of OCaml (useful for platforms where
it isn't packaged), and also use <code>make download-ext</code> to store all the external archives
within the source tree (for automated builds which forbid external net access).</p>
<p>The <a href="http://opam.ocaml.org/doc" title="Preview of documentation for OPAM 1.2">whole documentation</a> has been rewritten as well, to be better focused and
easier to browse.  Please leave any feedback or changes on the documentation on the
<a href="https://github.com/ocaml/opam/issues">issue tracker</a>.</p>
<h3>Try it out !</h3>
<p>The <a href="https://github.com/ocaml/opam/releases/tag/1.2.0-beta4" title="Opam 1.2-beta4 release">public beta of OPAM 1.2</a> is just out. You're welcome to give it a try and
give us feedback before we roll out the release!</p>
<p>We'd be most interested on feedback on how easily you can work with the new
pinning features, on how the new metadata works for you... and on any errors you
may trigger that aren't followed by informative messages or clean behaviour.</p>
<p>If you are hosting a repository, the <a href="https://github.com/ocaml/opam/tree/master/admin-scripts" title="Opam admin scripts directory on Github">administration scripts</a> may help you quickly update all your packages to
benefit from the new features.</p>
|js}
  };
 
  { title = {js|OPAM 1.1.1 released|js}
  ; slug = {js|opam-1-1-1-released|js}
  ; description = {js|???|js}
  ; date = {js|2014-01-29|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are proud to announce that <em>OPAM 1.1.1</em> has just been released.</p>
<p>This minor release features mostly stability and UI/doc improvements over
OPAM 1.1.0, but also focuses on improving the API and tools to be a better
base for the platform (functions for <code>opam-doc</code>, interface with tools like
<code>opamfu</code> and <code>opam-installer</code>). Lots of bigger changes are in the works, and
will be merged progressively after this release.</p>
<h2>Installing</h2>
<p>Installation instructions are available
<a href="http://opam.ocaml.org/doc/Quick_Install.html">on the wiki</a>.</p>
<p>Note that some packages may take a few days until they get out of the
pipeline. If you're eager to get 1.1.1, either use our
<a href="https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh">binary installer</a> or
<a href="https://github.com/ocaml/opam/releases/tag/1.1.1">compile from source</a>.</p>
<p>The 'official' package repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
synchronised with the Git repository at
<a href="http://github.com/ocaml/opam-repository">http://github.com/ocaml/opam-repository</a>,
where you can contribute new packages descriptions. Those are under a CC0
license, a.k.a. public domain, to ensure they will always belong to the
community.</p>
<p>Thanks to all of you who have helped build this repository and made OPAM
such a success.</p>
<h2>Changes</h2>
<p>From the changelog:</p>
<ul>
<li>Fix <code>opam-admin make &lt;packages&gt; -r</code> (#990)
</li>
<li>Explicitly prettyprint list of lists, to fix <code>opam-admin depexts</code> (#997)
</li>
<li>Tell the user which fields is invalid in a configuration file (#1016)
</li>
<li>Add <code>OpamSolver.empty_universe</code> for flexible universe instantiation (#1033)
</li>
<li>Add <code>OpamFormula.eval_relop</code> and <code>OpamFormula.check_relop</code> (#1042)
</li>
<li>Change <code>OpamCompiler.compare</code> to match <code>Pervasives.compare</code> (#1042)
</li>
<li>Add <code>OpamCompiler.eval_relop</code> (#1042)
</li>
<li>Add <code>OpamPackage.Name.compare</code> (#1046)
</li>
<li>Add types <code>version_constraint</code> and <code>version_formula</code> to <code>OpamFormula</code> (#1046)
</li>
<li>Clearer command aliases. Made <code>info</code> an alias for <code>show</code> and added the alias
<code>uninstall</code> (#944)
</li>
<li>Fixed <code>opam init --root=&lt;relative path&gt;</code> (#1047)
</li>
<li>Display OS constraints in <code>opam info</code> (#1052)
</li>
<li>Add a new 'opam-installer' script to make <code>.install</code> files usable outside of opam (#1026)
</li>
<li>Add a <code>--resolve</code> option to <code>opam-admin make</code> that builds just the archives you need for a specific installation (#1031)
</li>
<li>Fixed handling of spaces in filenames in internal files (#1014)
</li>
<li>Replace calls to <code>which</code> by a more portable call (#1061)
</li>
<li>Fixed generation of the init scripts in some cases (#1011)
</li>
<li>Better reports on package patch errors (#987, #988)
</li>
<li>More accurate warnings for unknown package dependencies (#1079)
</li>
<li>Added <code>opam config report</code> to help with bug reports (#1034)
</li>
<li>Do not reinstall dev packages with <code>opam upgrade &lt;pkg&gt;</code> (#1001)
</li>
<li>Be more careful with <code>opam init</code> to a non-empty root directory (#974)
</li>
<li>Cleanup build-dir after successful compiler installation to save on space (#1006)
</li>
<li>Improved OSX compatibility in the external solver tools (#1074)
</li>
<li>Fixed messages printed on update that were plain wrong (#1030)
</li>
<li>Improved detection of meaningful changes from upstream packages to trigger recompilation
</li>
</ul>
|js}
  };
 
  { title = {js|OPAM 1.1.0 released|js}
  ; slug = {js|opam-1-1-0-released|js}
  ; description = {js|???|js}
  ; date = {js|2013-11-08|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>After a while staged as RC, we are proud to announce the final release of
<em>OPAM 1.1.0</em>!</p>
<p>Thanks again to those who have helped testing and fixing the last few issues.</p>
<h2>Important note</h2>
<p>The repository format has been improved with incompatible new features; to
account for this, the <em>new</em> repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
and the legacy repository at <a href="http://opam.ocamlpro.com">opam.ocamlpro.com</a> is kept to support OPAM
1.0 installations, but is unlikely to benefit from many package updates.
Migration to <a href="https://opam.ocaml.org">opam.ocaml.org</a> will be done automatically as soon as you
upgrade your OPAM version.</p>
<p>You're still free, of course, to use any third-party repositories instead or
in addition.</p>
<h2>Installing</h2>
<p>NOTE: When switching from 1.0, the internal state will need to be upgraded.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your
<code>~/.opam</code> folder, it is advised to <strong>backup that folder before you upgrade
to 1.1.0</strong>.</p>
<p>Using the binary installer:</p>
<ul>
<li>download and run http://www.ocamlpro.com/pub/opam_installer.sh
</li>
</ul>
<p>Using the .deb packages from Anil's PPA (binaries are <a href="https://launchpad.net/~avsm/+archive/ppa/+builds?build_state=pending">currently syncing</a>):
add-apt-repository ppa:avsm/ppa
apt-get update
sudo apt-get install opam</p>
<p>For OSX users, the homebrew package will be updated shortly.</p>
<p>or build it from sources at :</p>
<ul>
<li>http://www.ocamlpro.com/pub/opam-full-1.1.0.tar.gz
</li>
<li>https://github.com/ocaml/opam/releases/tag/1.1.0
</li>
</ul>
<h2>For those who haven't been paying attention</h2>
<p>OPAM is a source-based package manager for OCaml. It supports multiple
simultaneous compiler installations, flexible package constraints, and
a Git-friendly development workflow. OPAM is edited and
maintained by OCamlPro, with continuous support from OCamlLabs and the
community at large (including its main industrial users such as
Jane-Street and Citrix).</p>
<p>The 'official' package repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
synchronised with the Git repository at
<a href="http://github.com/ocaml/opam-repository">http://github.com/ocaml/opam-repository</a>, where you can contribute
new packages descriptions. Those are under a CC0 license, a.k.a. public
domain, to ensure they will always belong to the community.</p>
<p>Thanks to all of you who have helped build this repository and made OPAM
such a success.</p>
<h2>Changes</h2>
<p>Too many to list here, see
<a href="https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES">https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES</a></p>
<p>For packagers, some new fields have appeared in the OPAM description format:</p>
<ul>
<li><code>depexts</code> provides facilities for dealing with system (non ocaml) dependencies
</li>
<li><code>messages</code>, <code>post-messages</code> can be used to notify the user eg. of licensing information,
or help her  troobleshoot at package installation.
</li>
<li><code>available</code> supersedes <code>ocaml-version</code> and <code>os</code> constraints, and can contain
more expressive formulas
</li>
</ul>
<p>Also, we have integrated the main package repository with Travis, which will
help us to improve the quality of contributions (see <a href="http://anil.recoil.org/2013/09/30/travis-and-ocaml.html">Anil's post</a>).</p>
|js}
  };
 
  { title = {js|OPAM 1.1.0 release candidate out|js}
  ; slug = {js|opam-1-1-0-release-candidate|js}
  ; description = {js|???|js}
  ; date = {js|2013-10-14|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p><strong>OPAM 1.1.0 is ready</strong>, and we are shipping a release candidate for
packagers and all interested to try it out.</p>
<p>This version features several bug-fixes over the September beta release, and
quite a few stability and usability improvements. Thanks to all beta-testers
who have taken the time to file reports, and helped a lot tackling the
remaining issues.</p>
<h2>Repository change to opam.ocaml.org</h2>
<p>This release is synchronized with the migration of the main repository from
ocamlpro.com to ocaml.org. A redirection has been put in place, so that all
up-to-date installation of OPAM should be redirected seamlessly.
OPAM 1.0 instances will stay on the old repository, so that they won't be
broken by incompatible package updates.</p>
<p>We are very happy to see the impressive amount of contributions to the OPAM
repository, and this change, together with the licensing of all metadata under
CC0 (almost pubic domain), guarantees that these efforts belong to the
community.</p>
<h1>If you are upgrading from 1.0</h1>
<p>The internal state will need to be upgraded at the first run of OPAM 1.1.0.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your
<code>~/.opam folder</code>, it is advised to <strong>backup that folder before you upgrade to 1.1.0</strong>.</p>
<h2>Installing</h2>
<p>Using the binary installer:</p>
<ul>
<li>download and run http://www.ocamlpro.com/pub/opam_installer.sh
</li>
</ul>
<p>You can also get the new version either from Anil's unstable PPA:
add-apt-repository ppa:avsm/ppa-testing
apt-get update
sudo apt-get install opam</p>
<p>or build it from sources at :</p>
<ul>
<li>http://www.ocamlpro.com/pub/opam-full-1.1.0.tar.gz
</li>
<li>https://github.com/OCamlPro/opam/releases/tag/1.1.0-RC
</li>
</ul>
<h2>Changes</h2>
<p>Too many to list here, see
<a href="https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES">https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES</a></p>
<p>For packagers, some new fields have appeared in the OPAM description format:</p>
<ul>
<li><code>depexts</code> provides facilities for dealing with system (non ocaml)
dependencies
</li>
<li><code>messages</code>, <code>post-messages</code> can be used to notify the user or help her troubleshoot at package installation.
</li>
<li><code>available</code> supersedes <code>ocaml-version</code> and <code>os</code> constraints, and can contain
more expressive formulas
</li>
</ul>
|js}
  };
 
  { title = {js|OPAM 1.1.0 beta released|js}
  ; slug = {js|opam-1-1-0-beta|js}
  ; description = {js|???|js}
  ; date = {js|2013-09-20|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>We are very happy to announce the <strong>beta release</strong> of OPAM version 1.1.0!</p>
<p>OPAM is a source-based package manager for OCaml. It supports multiple
simultaneous compiler installations, flexible package constraints, and
a Git-friendly development workflow which. OPAM is edited and
maintained by OCamlPro, with continuous support from OCamlLabs and the
community at large (including its main industrial users such as
Jane-Street and Citrix).</p>
<p>Since its first official release <a href="http://www.ocamlpro.com/blog/2013/03/14/opam-1.0.0.html">last March</a>, we have fixed many
bugs and added lots of <a href="https://github.com/OCamlPro/opam/issues?milestone=17&amp;page=1&amp;state=closed">new features and stability improvements</a>. New
features go from more metadata to the package and compiler
descriptions, to improved package pin workflow, through a much faster
update algorithm. The full changeset is included below.</p>
<p>We are also delighted to see the growing number of contributions from
the community to both OPAM itself (35 contributors) and to its
metadata repository (100+ contributors, 500+ unique packages, 1500+
packages). It is really great to also see alternative metadata
repositories appearing in the wild (see for instance the repositories
for <a href="https://github.com/vouillon/opam-android-repository">Android</a>, <a href="https://github.com/vouillon/opam-windows-repository">Windows</a> and <a href="https://github.com/search?q=opam-repo&amp;type=Repositories&amp;ref=searchresults">so on</a>). To be sure that the
community efforts will continue to benefit to everyone and to
underline our committment to OPAM, we are rehousing it at
<code>http://opam.ocaml.org</code> and switching the license to CC0 (see <a href="https://github.com/OCamlPro/opam-repository/issues/955">issue #955</a>,
where 85 people are commenting on the thread).</p>
<p>The binary installer has been updated for OSX and x86_64:</p>
<ul>
<li>http://www.ocamlpro.com/pub/opam_installer.sh
</li>
</ul>
<p>You can also get the new version either from Anil's unstable PPA:
add-apt-repository ppa:avsm/ppa-testing
apt-get update
sudo apt-get install opam</p>
<p>or build it from sources at :</p>
<ul>
<li>http://www.ocamlpro.com/pub/opam-full-1.1.0-beta.tar.gz
</li>
<li>https://github.com/OCamlPro/opam/releases/tag/1.1.0-beta
</li>
</ul>
<p>NOTE: If you upgrade from OPAM 1.0, the first time you will run the
new <code>opam</code> binary it will upgrade its internal state in an incompatible
way: THIS PROCESS CANNOT BE REVERTED. We have tried hard to make this
process fault-resistant, but failures might happen. In case you have
precious data in your <code>~/.opam</code> folder, it is advised to <strong>backup that
folder before you upgrade to 1.1</strong>.</p>
<h2>Changes</h2>
<ul>
<li>Automatic backup before any operation which might alter the list of installed packages
</li>
<li>Support for arbitrary sub-directories for metadata repositories
</li>
<li>Lots of colors
</li>
<li>New option <code>opam update -u</code> equivalent to <code>opam update &amp;&amp; opam upgrade --yes</code>
</li>
<li>New <code>opam-admin</code> tool, bundling the features of <code>opam-mk-repo</code> and
<code>opam-repo-check</code> + new 'opam-admin stats' tool
</li>
<li>New <code>available</code>: field in opam files, superseding <code>ocaml-version</code> and <code>os</code> fields
</li>
<li>Package names specified on the command-line are now understood
case-insensitively (#705)
</li>
<li>Fixed parsing of malformed opam files (#696)
</li>
<li>Fixed recompilation of a package when uninstalling its optional dependencies (#692)
</li>
<li>Added conditional post-messages support, to help users when a package fails to
install for a known reason (#662)
</li>
<li>Rewrite the code which updates pin et dev packages to be quicker and more reliable
</li>
<li>Add {opam,url,desc,files/} overlay for all packages
</li>
<li><code>opam config env</code> now detects the current shell and outputs a sensible default if
no override is provided.
</li>
<li>Improve <code>opam pin</code> stability and start display information about dev revisions
</li>
<li>Add a new <code>man</code> field in <code>.install</code> files
</li>
<li>Support hierarchical installation in <code>.install</code> files
</li>
<li>Add a new <code>stublibs</code> field in <code>.install</code> files
</li>
<li>OPAM works even when the current directory has been deleted
</li>
<li>speed-up invocation of <code>opam config var VARIABLE</code> when variable is simple
(eg. <code>prefix</code>, <code>lib</code>, ...)
</li>
<li><code>opam list</code> now display only the installed packages. Use <code>opam list -a</code> to get
the previous behavior.
</li>
<li>Inverse the depext tag selection (useful for <code>ocamlot</code>)
</li>
<li>Add a <code>--sexp</code> option to <code>opam config env</code> to load the configuration under emacs
</li>
<li>Purge <code>~/.opam/log</code> on each invocation of OPAM
</li>
<li>System compiler with versions such as <code>version+patches</code> are now handled as if this
was simply <code>version</code>
</li>
<li>New <code>OpamVCS</code> functor to generate OPAM backends
</li>
<li>More efficient <code>opam update</code>
</li>
<li>Switch license to LGPL with linking exception
</li>
<li><code>opam search</code> now also searches through the tags
</li>
<li>minor API changes for <code>API.list</code> and <code>API.SWITCH.list</code>
</li>
<li>Improve the syntax of filters
</li>
<li>Add a <code>messages</code> field
</li>
<li>Add a <code>--jobs</code> command line option and add <code>%{jobs}%</code> to be used in OPAM files
</li>
<li>Various improvements in the solver heuristics
</li>
<li>By default, turn-on checking of certificates for downloaded dependency archives
</li>
<li>Check the md5sum of downloaded archives when compiling OPAM
</li>
<li>Improved <code>opam info</code> command (more information, non-zero error code when no patterns match)
</li>
<li>Display OS and OPAM version on internal errors to ease error reporting
</li>
<li>Fix <code>opam reinstall</code> when reinstalling a package wich is a dependency of installed packages
</li>
<li>Export and read <code>OPAMSWITCH</code> to be able to call OPAM in different switches
</li>
<li><code>opam-client</code> can now be used in a toplevel
</li>
<li><code>-n</code> now means <code>--no-setup</code> and not <code>--no-checksums</code> anymore
</li>
<li>Fix support of FreeBSD
</li>
<li>Fix installation of local compilers with local paths endings with <code>../ocaml/</code>
</li>
<li>Fix the contents of <code>~/.opam/opam-init/variable.sh</code> after a switch
</li>
</ul>
|js}
  };
 
  { title = {js|OPAM 1.0.0 released|js}
  ; slug = {js|opam-1-0-0-released|js}
  ; description = {js|???|js}
  ; date = {js|2013-03-15|js}
  ; tags = 
 [{js|platform|js}]
  ; body_html = {js|<p>I am <em>very</em> happy to announce the first official release of OPAM!</p>
<p>Many of you already know and use OPAM so I won't be long. Please read
<a href="http://www.ocamlpro.com/blog/2013/01/17/opam-beta.html">http://www.ocamlpro.com/blog/2013/01/17/opam-beta.html</a> for a
longer description.</p>
<p>1.0.0 fixes many bugs and add few new features to the previously announced
beta-release.</p>
<p>The most visible new feature, which should be useful for beginners with
OCaml and OPAM,  is an auto-configuration tool. This tool easily enables all
the features of OPAM (auto-completion, fix the loading of scripts for the
toplevel, opam-switch-eval alias, etc). This tool runs interactively on each
<code>opam init</code> invocation. If you don't like OPAM to change your configuration
files, use <code>opam init --no-setup</code>. If you trust the tool blindly,  use
<code>opam init --auto-setup</code>. You can later review the setup by doing
<code>opam config setup --list</code> and call the tool again using <code>opam config setup</code>
(and you can of course manually edit your ~/.profile (or ~/.zshrc for zsh
users), ~/.ocamlinit and ~/.opam/opam-init/*).</p>
<p>Please report:</p>
<ul>
<li>Bug reports and feature requests for the OPAM tool: http://github.com/OCamlPro/opam/issues
</li>
<li>Packaging issues or requests for a new packages: http://github.com/OCamlPro/opam-repository/issues
</li>
<li>General queries to: http://lists.ocaml.org/listinfo/platform
</li>
<li>More specific queries about the internals of OPAM to: http://lists.ocaml.org/listinfo/opam-devel
</li>
</ul>
<h2>Install</h2>
<p>Packages for Debian and OSX (at least homebrew) should follow shortly and
I'm looking for volunteers to create and maintain rpm packages. The binary
installer is up-to-date for Linux and Darwin 64-bit architectures, the
32-bit version for Linux should arrive shortly.</p>
<p>If you want to build from sources, the full archive (including dependencies)
is available here:</p>
<p>http://www.ocamlpro.com/pub/opam-full-latest.tar.gz</p>
<h3>Upgrade</h3>
<p>If you are upgrading from 0.9.* you won't  have anything special to do apart
installing the new binary. You can then update your package metadata by
running <code>opam update</code>. If you want to use the auto-setup feature, remove the
&quot;eval <code>opam config env</code> line you have previously added in your ~/.profile
and run <code>opam config setup --all</code>.</p>
<p>So everything should be fine. But you never know ... so if something goes
horribly wrong in the upgrade process (of if your are upgrading from an old
version of OPAM) you can still trash your ~/.opam, manually remove what OPAM
added in  your ~/.profile (~/.zshrc for zsh users) and ~/.ocamlinit, and
start again from scratch.</p>
<h3>Random stats</h3>
<p>Great success on github. Thanks everybody for the great contributions!</p>
<p>https://github.com/OCamlPro/opam: +2000 commits, 26 contributors
https://github.com/OCamlPro/opam-repository: +1700 commits, 75 contributors, 370+ packages</p>
<p>on http://opam.ocamlpro.com/
+400 unique visitor per week, 15k 'opam update' per week
+1300 unique visitor per month, 55k 'opam update' per month
3815 unique visitor since the alpha release</p>
<h3>Changelog</h3>
<p>The full change-log since the beta release in January:</p>
<p>1.0.0 [Mar 2013]</p>
<ul>
<li>Improve the lexer performance (thx to @oandrieu)
</li>
<li>Fix various typos (thx to @chaudhuri)
</li>
<li>Fix build issue (thx to @avsm)
</li>
</ul>
<p>0.9.6 [Mar 2013]</p>
<ul>
<li>Fix installation of pinned packages on BSD (thx to @smondet)
</li>
<li>Fix configuration for zsh users (thx to @AltGr)
</li>
<li>Fix loading of <code>~/.profile</code> when using dash (eg. in Debian/Ubuntu)
</li>
<li>Fix installation of packages with symbolic links (regression introduced in 0.9.5)
</li>
</ul>
<p>0.9.5 [Mar 2013]</p>
<ul>
<li>If necessary, apply patches and substitute files before removing a package
</li>
<li>Fix <code>opam remove &lt;pkg&gt; --keep-build-dir</code> keeps the folder if a source archive is extracted
</li>
<li>Add build and install rules using ocamlbuild to help distro packagers
</li>
<li>Support arbitrary level of nested subdirectories in packages repositories
</li>
<li>Add <code>opam config exec &quot;CMD ARG1 ... ARGn&quot; --switch=SWITCH</code> to execute a command in a subshell
</li>
<li>Improve the behaviour of <code>opam update</code> wrt. pinned packages
</li>
<li>Change the default external solver criteria (only useful if you have aspcud installed on your machine)
</li>
<li>Add support for global and user configuration for OPAM (<code>opam config setup</code>)
</li>
<li>Stop yelling when OPAM is not up-to-date
</li>
<li>Update or generate <code>~/.ocamlinit</code> when running <code>opam init</code>
</li>
<li>Fix tests on *BSD (thx Arnaud Degroote)
</li>
<li>Fix compilation for the source archive
</li>
</ul>
<p>0.9.4 [Feb 2013]</p>
<ul>
<li>Disable auto-removal of unused dependencies. This can now be enabled on-demand using <code>-a</code>
</li>
<li>Fix compilation and basic usage on Cygwin
</li>
<li>Fix BSD support (use <code>type</code> instead of <code>which</code> to detect existing commands)
</li>
<li>Add a way to tag external dependencies in OPAM files
</li>
<li>Better error messages when trying to upgrade pinned packages
</li>
<li>Display <code>depends</code> and <code>depopts</code> fields in <code>opam info</code>
</li>
<li><code>opam info pkg.version</code> shows the metadata for this given package version
</li>
<li>Add missing <code>doc</code> fields in <code>.install</code> files
</li>
<li><code>opam list</code> now only shows installable packages
</li>
</ul>
<p>0.9.3 [Feb 2013]</p>
<ul>
<li>Add system compiler constraints in OPAM files
</li>
<li>Better error messages in case of conflicts
</li>
<li>Cleaner API to install/uninstall packages
</li>
<li>On upgrade, OPAM now perform all the remove action first
</li>
<li>Use a cache for main storing OPAM metadata: this greatly speed-up OPAM invocations
</li>
<li>after an upgrade, propose to reinstall a pinned package only if there were some changes
</li>
<li>improvements to the solver heuristics
</li>
<li>better error messages on cyclic dependencies
</li>
</ul>
<p>0.9.2 [Jan 2013]</p>
<ul>
<li>Install all the API files
</li>
<li>Fix <code>opam repo remove repo-name</code>
</li>
<li>speed-up <code>opam config env</code>
</li>
<li>support for <code>opam-foo</code> scripts (which can be called using <code>opam foo</code>)
</li>
<li>'opam update pinned-package' works
</li>
<li>Fix 'opam-mk-repo -a'
</li>
<li>Fix 'opam-mk-repo -i'
</li>
<li>clean-up pinned cache dir when a pinned package fails to install
</li>
</ul>
<p>0.9.1 [Jan 2013]</p>
<ul>
<li>Use ocaml-re 1.2.0
</li>
</ul>
|js}
  }]

