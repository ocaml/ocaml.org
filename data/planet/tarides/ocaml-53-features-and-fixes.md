---
title: 'OCaml 5.3: Features and Fixes!'
description: OCaml 5.3 is released! This post gives you an overview of returning features,
  optimisations, and fixes as well as a taste for what's to come.
url: https://tarides.com/blog/2025-01-09-ocaml-5-3-features-and-fixes
date: 2025-01-09T00:00:00-00:00
preview_image: https://tarides.com/blog/images/OCaml53-1360w.webp
authors:
- Tarides
source:
---

<p>We have a brand new OCaml release on our hands! 5.3 comes packed with features, fixes, and optimisations, including the return of some ‘familiar faces’. Support for the MSVC port is returning, as is statistical memory profiling now compatible with multicore projects.</p>
<p>This post highlights new and restored features, notable changes and user experience improvements, plus some bug fixes. There is no way that I can cover everything in this update, so I recommend that you check out the <a href="https://github.com/ocaml/ocaml/blob/5.3/Changes">Changes document</a> on GitHub for the full list of contributions!</p>
<h2>MSVC</h2>
<p>The 5.3 release restores support for the MSVC port of OCaml on Windows, marking the last remaining platform from 4.x to regain support in 5.x. This is part of a wider effort to achieve feature parity between OCaml 4.14 and OCaml 5, of which <a href="https://tarides.com/blog/2024-09-11-feature-parity-series-compaction-is-back/">compaction</a> is a previous example, making the transition between versions as smooth as possible. The bulk of the effort is summarised in PRs <a href="https://github.com/ocaml/ocaml/pull/12954">#12954</a> and <a href="https://github.com/ocaml/ocaml/pull/12909">#12909</a> opened by David Allsopp, Antonin Décimo, and Samuel Hym (review by Miod Vallat and Nicolás Ojeda Bär).</p>
<p>Since the OCaml 5 runtime uses C11 atomics, supported platforms need to be compatible with them as well. Visual Studio 2022 introduced experimental support for C11 atomics which made the MSVC port of OCaml 5 possible, but the team needed to test out the feature first. This exploratory effort led to <a href="https://developercommunity.visualstudio.com/t/C11-atomics-Pointers-to-atomic-values-/10507360">several bug reports</a> addressed by Microsoft, and once these were completed (alongside a lot of other work, including fixing the <code>winpthreads</code> library of the <code>mingw-w64</code> project to that it builds with MSVC), the MSVC port was ready for public release.</p>
<p>As part of the project bringing MSVC back the team explored <a href="https://clang.llvm.org/docs/UsersManual.html#clang-cl">clang-cl</a>, an alternative command line interface to <a href="https://clang.llvm.org/">Clang</a> designed to be compatible with the MSVC compiler cl.exe. This was helpful because clang-cl has a different set of warnings and tips to MSVC, and using it effectively gave them a ‘second opinion’ on their code. The main PR for this side of the project is <a href="https://github.com/ocaml/ocaml/pull/13093">#13093</a>.</p>
<h2>Statmemprof</h2>
<p>OCaml 4.14 had support for statistical memory profiling, a feature of the language that can sample memory allocations allowing tools like <a href="https://github.com/janestreet/memtrace">Memtrace</a> to <a href="https://blog.janestreet.com/finding-memory-leaks-with-memtrace/">help users identify how their programs are using memory</a>. The multicore update introduced significant complexity to the process which made it necessary to drop support for 5.0; but work soon commenced to restore support under our feature parity banner! In 5.3, <code>statmemprof</code> makes its return, now equipped with multicore capabilities.</p>
<p>So how does it work? <code>Statmemprof</code> can check the allocation of memory at some given frequency (lambda) per word or unit of data. By sampling a fraction of allocations at random, we are able to monitor programs in a language like OCaml which allocates high rates of memory. It would be far too expensive performance-wise to monitor every allocation.</p>
<p>The new design has a lot in common with the OCaml 4 implementation of statmemprof, but with several tricky optimisations and changes to account for the significant complication of multiple domains and threads. Delve into the details in the PRs <a href="https://github.com/ocaml/ocaml/pull/12923">#12923</a> and <a href="https://github.com/ocaml/ocaml/issues/11911">#11911</a> by Nick Barnes (external reviews by Stephen Dolan, Jacques-Henri Jourdan,  and Guillaume Munch-Maccagnoni).</p>
<h2>Deep Effect Handlers</h2>
<p>OCaml 5.0 came with experimental support for algebraic effects, which allow users to describe computations and what effects they are expected to create. A <em>handler</em> essentially manages a computation by monitoring its execution and keeping track of resulting  effects. This ‘management’ can be done in two ways, <em>deeply</em> or <em>shallowly</em>. A shallow effect handler  monitors a computation until it either terminates or generates one effect, only handling that effect. A deep effect handler always manages a computation until it terminates and handles all of the effects performed by it.</p>
<p>PR <a href="https://github.com/ocaml/ocaml/pull/12309">#12309</a> (Leo White, Tom Kelly, Anil Madhavapeddy, KC Sivaramakrishnan, Xavier Leroy and Florian Angeletti, review by the same, Hugo Heuzard, and Ulysse Gérard) introduces effect syntax for deep effect handlers, rules that define the structure for writing them, compatible with the type checker and with support for pattern matching. This change aims to simplify the code needed to use deep effect handlers, improving user experience. Note that you can still use shallow effect handlers, and there is a good tutorial for using both in the <a href="https://ocaml.org/manual/5.3/effects.html">correspondingly updated manual page</a>.</p>
<h2>Debugging Improvements</h2>
<p>Another long-term project coming to fruition in this update are the several improvements to debugging on macOS. The platform is popular with a wide variety of OCaml users, including compiler developers, and they need good debugging workflows for their programs.</p>
<p><a href="https://lldb.llvm.org">LLDB</a> is the only supported native debugger on macOS, for both the ARM64 and x86_64 architectures. The improvements enable several new features:</p>
<ul>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13163">#13163</a> enable frame pointers on macOS x86_64 (Tim McGilchrist, review by Sébastien Hinderer and Fabrice Buoro):</strong> This PR introduces support for a common technique used by profiling tools including Linux perf, eBPF, FreeBSD, and LLDB, called stack-walking. Various performance tools use stack walking to reconstruct call graphs for programs, and frame pointers are what enable them to do so.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13241">#13241</a>, <a href="https://github.com/ocaml/ocaml/pull/13261">#13261</a>, <a href="https://github.com/ocaml/ocaml/pull/13271">#13271</a>, add CFI_SIGNAL_FRAME to arm64 and RISC-V runtimes for the purpose of displaying backtraces correctly in GDB (Tim McGilchrist, review by Miod Vallat, Gabriel Scherer and KC Sivaramakrishnan):</strong> This change helps sync up the runtime for the arm64 architecture for macOS (and the RISC-V runtime) with the amd64 and s390x runtimes. The two additional PRs add improvements to the first.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13136">#13136</a> Compatible LLDB and GDB Python extensions (Nick Barnes):</strong> This PR replaces some old GDB macros (used to debug OCaml programs) with faster and more capable extensions, and makes those extensions available in LLDB. This is especially useful to macOS users who can’t use GDB.</li>
</ul>
<h2>OS-Based Synchronisation for Stop-the-World Sections</h2>
<p>PR <a href="https://github.com/ocaml/ocaml/pull/12579">#12579</a> (B. Szilvasy, review by Miod Vallat, Nick Barnes, Olivier Nicole, Gabriel Scherer and Damien Doligez) improves user experience by replacing generic busy-wait synchronisation with OS-based synchronisation primitives, namely barriers and futexes. The change has significant performance benefits, especially on Windows machines, where spinning was causing long wait times. You can learn more about it in <a href="https://tarides.com/blog/2024-07-10-deep-dive-optimising-multicore-ocaml-for-windows/">our blog post on the project</a>.</p>
<h2>User Experience Improvements</h2>
<ul>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/12868">#12868</a> Refresh HTML manual/API docs style (Yawar Amin, review by Simon Grondin, Gabriel Scherer, and Florian Angeletti):</strong>  An update to the <a href="https://ocaml.org/manual/5.3/index.html">OCaml Manual</a> which simplifies the colours, removes the gradients, and fixes the search button. It’s a nice improvement to a part of the OCaml ecosystem that is visible to users of all different backgrounds and contexts.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13201">#13201</a>, <a href="https://github.com/ocaml/ocaml/pull/13244">#13244</a> (Sébastien Hinderer, review by Miod Vallat, Gabriel Scherer and Olivier Nicole), and <a href="https://github.com/ocaml/ocaml/pull/12904">#12904</a> (Olivier Nicole, suggested by Sébastien Hinderer and David Allsopp, external review by Gabriel Scherer) various improvements to TSan:</strong> These three PRs represent the continuous work being put in to bring improvements to TheadSanitizer or TSan. They include speedups and the ability for users to choose which PRs they want to run the TSan testsuite on.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13014">#13014</a> (Miod Vallat, review by Nicolás Ojeda Bär) add per function sections support to the missing compiler backends:</strong> This PR is an example of how much focus there is on ensuring that each native backend is equally supported, having features available across all Tier-1 platforms. Here, the compile-time option <code>function–sections</code> was re-enabled on all previously unsupported (POWER, riscv64, and s390x) native backends.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/11996">#11996</a> emancipate <code>dynlink</code> from <code>compilerlibs</code> (Sébastien Hinderer and Stephen Dolan, review by Damien Doligez and Hugo Heuzard):</strong> The <code>dynlink</code> library used to depend on <code>compilerlibs</code>, having to embed a copy of <code>compilerlibs</code> meaning that it would be compiled twice, costing the user in time and performance. After the change, the build time and size of both <code>dynlink.cma</code> and <code>dynlink.cmxa</code>were reduced.</li>
</ul>
<h2>Miscellaneous Bug Fixes</h2>
<p>These two bug fixes grew out of internship projects at Tarides, it's great to see how these projects can benefit the language as a whole.</p>
<ul>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13419">#13419</a> (B. Szilvasy and Nick Barnes, review by Miod Vallat, Nick Barnes, Tim McGilchrist, and Gabriel Scherer):</strong> This PR addressed resource leaks that caused memory bugs in the runtime events system.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13535">#13535</a> (Antonin Décimo, Nick Barnes, report by Nikolaus Huber and Jan Midtgaard, review by Florian Angeletti, Anil Madhavapeddy, Gabriel Scherer, and Miod Vallat):</strong> Expanded the documentation for <code>Hashtbl.create</code> to explain that negative values are allowed in the hash table but will be disregarded.</li>
</ul>
<p>These bug fixes stem from discoveries made during the release cycle of the 5.3 update. Catching and fixing broken bits of code is an important but often lengthy part of the release process.</p>
<ul>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13138">#13138</a> (Gabriel Scherer, review by Nick Roberts):</strong> This PR is an old one, first opened eight years ago in 2016! Optimised pattern matching with mutable and lazy patterns was observed to result in occasions where seemingly impossible cases were taken, causing unsoundness issues. After <em>lengthy</em> efforts to narrow down the cause, the problem has been fixed for 5.3!</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13519">#13519</a> (Sébastien Hinderer, report by William Hu, review by David Allsopp):</strong> This PR restored backward compatibility lost when renaming some items in <code>Makefile.config</code>.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13591">#13591</a> (Antonin Décimo, review by Nick Barnes, report by Kate Deplaix):</strong> This PR fixed a problem whereby compiling C++ code using the OCaml C API resulted in a name-mangled <code>caml_state</code> on Cygwin. The fix ensured that installed headers were compatible with C++ and protected the ones that were not with <code>CAML_INTERNALS</code>.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13471">#13471</a> (Florian Angeletti, review by Gabriel Scherer):</strong> Added a flag to define the list of keywords recognisable by the lexer, making adding future keywords to OCaml easier.</li>
<li><strong><a href="https://github.com/ocaml/ocaml/pull/13520">#13520</a> (David Allsopp, review by Sébastien Hinderer and Miod Vallat):</strong> Fixed the compilation of native-code versions of systhreads.</li>
</ul>
<h2>What’s Next?</h2>
<p>Work on OCaml continues! The next few months will bring more features and bug fixes to the language, with focus on big changes like the relocatable compiler, unloadable runtime, and laying the ground work for project-wide renaming and other powerful navigation and refactoring features. The <a href="https://ocaml.org/changelog">OCaml changelog</a> is the place to go to keep up with what’s new, as well as the <a href="https://discuss.ocaml.org/">OCaml Discuss</a> forum.</p>
<p>You can connect with us on <a href="https://bsky.app/profile/tarides.com">Bluesky</a>, <a href="https://twitter.com/tarides_">X</a>, <a href="https://mastodon.social/@tarides">Mastodon</a>, <a href="https://www.threads.net/@taridesltd">Threads</a>, and <a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for our mailing list to stay updated on our latest projects. We look forward to hearing from you!</p>
