---
title: 25 years of OCaml!
description: "On this day in 1996, Xavier Leroy announced Objective Caml 1.00 (the
  language wasn\u2019t officially called OCaml until 4.00.0 in July 2012). I wouldn\u2019t
  start using OCaml for another 7 years; I think I may have dropped Research Machines
  Basic by then and was mucking around with a mix of Visual Basic, Turbo Pascal and
  Delphi, but I hadn\u2019t yet got an email address either."
url: https://www.dra27.uk/blog/platform/2021/05/09/ocaml-at-25.html
date: 2021-05-09T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>On this day in 1996, Xavier Leroy <a href="https://sympa.inria.fr/sympa/arc/caml-list/1996-05/msg00003.html">announced Objective Caml 1.00</a> (the language wasn’t officially called OCaml until <a href="https://sympa.inria.fr/sympa/arc/caml-list/2012-07/msg00179.html">4.00.0 in July 2012</a>). I wouldn’t start using OCaml for another 7 years; I think I may have dropped Research Machines Basic by then and was mucking around with a mix of Visual Basic, Turbo Pascal and Delphi, but I hadn’t yet got an email address either.</p>

<p>For whatever reason, the <code class="language-plaintext highlighter-rouge">1.00</code> tag deletes the boot images, but they can be taken from the <a href="https://github.com/dra27/ocaml/tree/2de35753f7b43b11098f7d25a09b8cb904c1a2ca/boot">commit before</a>. I could get the runtime to build quite easily on Ubuntu, but alas while it appeared to be able to run <code class="language-plaintext highlighter-rouge">boot/ocamllex</code>, <code class="language-plaintext highlighter-rouge">boot/ocamlc</code> was just segfaulting. I debated firing up my old dual-Pentium III which apparently had Slackware 10 on it, but I thought I’d give the Windows port a go first!</p>

<p>According to the docs, the Windows compiler used to be bootstrapped with a different set of binary images, but this didn’t actually seem to be necessary, apart from changing <a href="https://github.com/dra27/ocaml/commit/f70db6ec87f2008caeb00d59defa9b4f914a4683">2 backslashes to forward slashes in f70db6e</a>. The sources for the GUI weren’t open, so it’s necessary to <a href="https://github.com/dra27/ocaml/commit/3262c4c90cc395c7dec94deb8a732ced70ccf0e9">disable the graph library in 3262c4</a> and make <a href="https://github.com/dra27/ocaml/commit/c9ad1c2a509bdb7032a6778c2113cdb441df185f">some very minor tweaks to the install target in c9ad1c</a> and that was it!</p>

<p>You’ll need an x86 Visual Studio build environment with Cygwin in <code class="language-plaintext highlighter-rouge">PATH</code>.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>git clone https://github.com/dra27/ocaml.git -b 25-years-of-ocaml ocaml-at-25
cd ocaml-at-25/config
copy s-nt.h s.h
copy m-nt.h m.h
cd ..
nmake -f Makefile.nt world
nmake -f Makefile.nt opt
nmake -f Makefile.nt install
set PATH=C:\ocaml\bin;%PATH%
</code></pre></div></div>

<p>There are a lot of warnings to ignore, but you should now have a working Objective Caml 1.00!</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>C:\Birthday&gt;ocaml.exe
Objective Caml version 1.00

#print_endline "Happy 25th Birthday, OCaml!";;
Happy 25th Birthday, OCaml!
- : unit = ()
##quit;;
</code></pre></div></div>

<p>and the native compiler should work too:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">rec</span> <span class="n">hip_hip</span> <span class="n">n</span> <span class="o">=</span>
  <span class="k">if</span> <span class="n">n</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span>
    <span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"hip hip! hooray!"</span> <span class="k">in</span>
    <span class="n">hip_hip</span> <span class="p">(</span><span class="n">pred</span> <span class="n">n</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">hip_hip</span> <span class="mi">25</span>
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>C:\Birthday&gt;ocamlopt -o hooray.exe hooray.ml

C:\Birthday&gt;hooray
hip hip! hooray!
...
</code></pre></div></div>

<p>Here’s to the next 25 years!</p>
