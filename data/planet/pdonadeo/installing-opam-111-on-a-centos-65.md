---
title: Installing OPAM 1.1.1 on a CentOS 6.5
description:
url: https://www.donadeo.net/post/2014/installing-opam-1-1-1-on-a-cenos-6-5
date: 2014-05-21T23:00:00-00:00
preview_image:
featured:
authors:
- pdonadeo
---

<div>
<p class="noindent">I'm in this situation: I need to compile an OCaml program on a CentOS 6.5 server. This is actually quite problematic, because CentOS 6.5 provide out of the box a very old OCaml 3.11.2, released by INRIA in January 2010, more than four years ago.</p>

<p class="noindent">No problem, <a href="https://opam.ocaml.org/" title="OPAM -  Home">OPAM</a> come to the rescue! No. The OPAM team doesn't provide a binary executable compatible with the (actually very old) system libraries present in CentOS.
</p>

<p class="noindent">Ok, step back: OPAM can be compiled from sources (<a href="https://opam.ocaml.org/doc/Advanced_Install.html" title="OPAM -  Advanced Install">instructions here</a>) so it's just a matter of minutes. Again: nope. To compile OPAM you need at least OCaml 3.12.1, while in CentOS we have only 3.11.2.</p>

<p class="noindent">Step back: first compile and install OCaml from sources. This time I say no, because the whole point of OPAM is to get an up and running OCaml environment in a few minutes, which is <strong>actually true</strong> in most cases.</p>

<p class="noindent">I decide to install OCaml using <a href="https://godi.camlcity.org/godi/get_godi.html" title="Get GODI">GODI</a>, the &ldquo;old&rdquo; OCaml source distribution, the one everybody used before OPAM was born. So the fastest steps to have an OPAM and OCaml environment on a CentOS server are:</p>

<ul>
  <li>download and install GODI;</li>
  <li>clone the <a href="https://github.com/ocaml/opam" title="GITHUB - ocaml/opam">OPAM repository</a>, compile and install it; it will find a &ldquo;system&rdquo; compiler provided by GODI;</li>
  <li><code>$ opam switch 4.01.0</code> will recompile a new environment;</li>
  <li><code>$ opam switch remove system</code> to delete the &ldquo;system&rdquo; environment;</li>
  <li><code>$ rm -Rf ~/godi</code>.</li>
</ul>

<p class="noindent">No root access is required in this process, I usually install OPAM in <code>~/opam</code>, and GODI in <code>~/godi</code>.</p>

<p class="noindent">There is an irony in all this story: GODI has been <strong>the</strong> OCaml source distribution for years, and the coming of OPAM, which is actually newer and has some important features missing in GODI, has produced many frictions in the OCaml community, that in the end caused the <a href="https://blog.camlcity.org/blog/godi_shutdown.html" title="GODI is shutting down">shut down of GODI</a>.</p>

<p class="noindent">The moral part here is: embrace the new things, but don't be too impatient in throwing out the window the precious work that, in the end, still works.</p>

<p class="noindent">In any case, I want to thank both Gerd Stolpmann (author of GODI) and the OPAM team: they gave to the OCaml community a mature, industrial grade, set of tools to use OCaml.</p>
</div>
