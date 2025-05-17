---
title: Using memtrace on Windows
description: "It is said that good things come to those who wait. Jacques-Henri Jourdan
  demonstrated Statistically profiling memory in OCaml at the 2016 OCaml Workshop
  and experimental branches of it existed for OCaml 4.03\u20134.07 in opam. Parts
  of the work were merged in OCaml 4.10 and the final sections landed with 4.11. The
  compiler provides support in the form of a series of hooks in various parts of the
  runtime\u2019s allocation and garbage collection routines. A few weeks ago, Jane
  Street released memtrace and Memtrace viewer and earlier this week blogged about
  its use. I thought I\u2019d quickly share the experience of using it on native Windows."
url: https://www.dra27.uk/blog/platform/2020/10/08/windows-memtrace.html
date: 2020-10-08T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>It is said that good things come to those who wait. Jacques-Henri Jourdan demonstrated <a href="https://ocaml.org/meetings/ocaml/2016/Jourdan-statistically_profiling_memory_in_OCaml.pdf">Statistically profiling memory in OCaml</a> at the 2016 OCaml Workshop and experimental branches of it existed for OCaml 4.03–4.07 in opam. Parts of the work were merged in OCaml 4.10 and the final sections landed with 4.11. The compiler provides support in the form of a series of hooks in various parts of the runtime’s allocation and garbage collection routines. A few weeks ago, Jane Street released <a href="https://github.com/janestreet/memtrace">memtrace</a> and <a href="https://github.com/janestreet/memtrace_viewer">Memtrace viewer</a> and earlier this week <a href="https://blog.janestreet.com/finding-memory-leaks-with-memtrace/">blogged about its use</a>. I thought I’d quickly share the experience of using it on native Windows.</p>

<p>At present, although the memtrace library is portable, the memtrace-viewer itself is not (as it happens, this is simply down to Core’s command line parser pulling in a little too much Unix-specific stuff, and the use of Async as a backend to Cohttp, rather than Lwt, but that’s for another time!). However, WSL to the rescue…</p>

<p>I’ve set-up a <a href="https://github.com/dra27/leaky">demo repository</a> which allows you to run the buggy version of <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> from Luke’s blog post as a native Windows application which can emit a trace, then use memtrace-viewer from Ubuntu running in WSL in the same directory to serve the trace locally, which can then be browsed in Edge.</p>

<p>The repo assumes you’ve set-up any one of the four native Windows ports (yes, unlike Spacetime, this works with 32-bit too!) and have a working OCaml compiler in <code class="language-plaintext highlighter-rouge">Path</code>. The demo repository provides all of the dependencies as Git submodules: there’s a patch <a href="https://github.com/ocaml/dune/pull/3793">for Dune</a> awaiting merge, a small patch <a href="https://github.com/janestreet/memtrace/pull/1">for memtrace</a> and some minor tweaks to the dependencies for <a href="https://github.com/dra27/memtrace_viewer_with_deps/commits/leaky">memtrace_viewer</a> which I’ll upstream in the next few days. Anyway:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>git clone https://github.com/dra27/leaky.git --recurse-submodules
cd leaky
cd vendor\dune-repo
ocaml bootstrap.ml
cd ..\..
</code></pre></div></div>

<p>That gets us a working Dune. We need something to run our buggy <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> over, so how about memtrace-viewer’s client library:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>vendor\dune-repo\dune build vendor\memtrace_viewer_with_deps\client\main.bc
</code></pre></div></div>

<p>Now we’re ready to get a trace:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>set MEMTRACE=leaky.ctf
vendor\dune-repo\dune exec -- js_of_ocaml.exe compile -o foo.js _build\default\vendor\memtrace_viewer_with_deps\client\main.bc
</code></pre></div></div>

<p>You’ll get various messages along the way, but you should now have a <code class="language-plaintext highlighter-rouge">leaky.ctf</code> file which can be fed to <code class="language-plaintext highlighter-rouge">memtrace-viewer</code> in WSL:</p>

<p><img src="https://www.dra27.uk/assets/2020-10-08/2020-10-08-leaky.png" alt="memtrace-viewer in action"></p>

<p>Obviously, at some point it’ll be nice not to have to rely on a Unix subsystem in order to run the viewer, but meanwhile it’s great to have a workflow on the same machine to be able to investigate memory leaks in native Windows programs!</p>
