---
title: Relocatable OCaml - from concept to demo to PRs
description: "If you give vapourware long enough, it condenses into an actual ware!
  An idea hatched between rehearsing Handel arias in the outskirts of Munich just
  over six years ago to make running OCaml\u2019s programs a little less surprising
  is now 132 commits of reality."
url: https://www.dra27.uk/blog/platform/2025/09/15/relocatable-ocaml.html
date: 2025-09-15T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>If you give vapourware long enough, it condenses into an actual ware! An idea hatched between rehearsing Handel arias in the outskirts of Munich just over six years ago to make running OCaml’s programs a little less surprising is now <a href="https://github.com/dra27/ocaml/pull/236/commits">132 commits of reality</a>.</p>

<p>Relocatable OCaml started out as a solution to a few thorny problems with the darker corners of OCaml. The somewhat grander fast opam switches <a href="https://github.com/ocaml/RFCs/pull/53">referred to in the eventual RFC</a> followed later.</p>

<p>In a nutshell, Relocatable OCaml unlocks the ability to <em>reliably</em> distribute pre-compiled binaries for a given system. It means, for example, that if you and I are both running the same version of Ubuntu, and we both clone and build OCaml in <code class="language-plaintext highlighter-rouge">~/ocaml</code> and configured to install in <code class="language-plaintext highlighter-rouge">~/ocaml/install</code>, we’ll both get <strong>exactly</strong> the <em>same compiler</em>, even if our user names - and consequently the directory we’re installing to, differ.</p>

<p>There’s a demo of how to try out Relocatable OCaml <a href="https://discuss.ocaml.org/t/relocatable-ocaml/17253">on Discuss</a>, but I thought it might be interesting to muse for a paragraph or two on why I think it ought to be done the way I’ve done it, and to a great extent why that’s made it take quite so long to get it to a finalised state.</p>

<p>In November 2019, I posed three “problems” with OCaml installations, all based on real-world experience:</p>
<ol>
  <li>Bytecode programs were susceptible to loading the wrong C support libraries. The example I gave was a system where running <code class="language-plaintext highlighter-rouge">camlp4 -v</code> (to report the version of <code class="language-plaintext highlighter-rouge">camlp4</code> in an opam switch) instead complained about <code class="language-plaintext highlighter-rouge">dllunix.so</code> and a missing <code class="language-plaintext highlighter-rouge">caml_sigmask_hook</code> function.</li>
  <li>Executables produced by the bytecode compiler stop working if directories get renamed.</li>
  <li>Both compilers (<code class="language-plaintext highlighter-rouge">ocamlopt</code> and <code class="language-plaintext highlighter-rouge">ocamlc</code>) can fail to find the OCaml Standard Library.
and to this we can add a fourth:</li>
  <li>It takes several minutes to start an OCaml project while waiting for <code class="language-plaintext highlighter-rouge">opam</code> to build OCaml from sources.</li>
</ol>

<p><strong>All of these problems can be solved by changing the workflow!</strong></p>

<p>The first problem is comes about from <code class="language-plaintext highlighter-rouge">opam</code> abusing <code class="language-plaintext highlighter-rouge">CAML_LD_LIBRARY_PATH</code> (tracked in <a href="https://github.com/ocaml/opam-repository/issues/16406">ocaml/opam-repository#16406</a>) and can be fixed by, er, not abusing <code class="language-plaintext highlighter-rouge">CAML_LD_LIBRARY_PATH</code>.
The second problem can be fixed by building bytecode executables with <code class="language-plaintext highlighter-rouge">-custom</code> or <code class="language-plaintext highlighter-rouge">-output-complete-obj</code> so that they include their interpreter (in fact, that’s also a solution to the first problem).
The third problem comes about from the <code class="language-plaintext highlighter-rouge">OCAMLLIB</code> environment variable and can likewise be solved by simply not leaving bad or empty values of <code class="language-plaintext highlighter-rouge">OCAMLLIB</code> kicking around.
The fourth problem comes about because OCaml development - in common with many other languages - encourages having a development environment per-project, and since <code class="language-plaintext highlighter-rouge">opam</code> 2.0’s “local switches” were introduced, the common workflow is to have an entire OCaml compiler installation with each project. This problem could be fixed by sharing the compiler between installations and configuring it appropriately for each project.</p>

<p>So why don’t we just do that?</p>

<p>Papercuts. The problem is that each and every developer has to know all these things and make the connection between an obscure in front of them (for example <code class="language-plaintext highlighter-rouge">Error: Unbound module Stdlib</code> or <code class="language-plaintext highlighter-rouge">undefined symbol: caml_sigmask_hook</code>) and a seemingly unconnected change to their build or workflow.</p>

<p><strong><a href="https://en.wikipedia.org/wiki/Fluxx">Let’s simplify!</a></strong></p>

<p>As the test harness I added in <a href="https://github.com/ocaml/ocaml/pull/14014">ocaml/ocaml#14014</a> shows, OCaml has a lot of different linking and loading mechanisms. It’s a very reasonable approach instead of fixing them all to try to reduce the number we have to worry about.</p>

<p>The most complex part of Relocatable OCaml is the second PR (<a href="https://github.com/ocaml/ocaml/pull/14244">ocaml/ocaml#14244</a>), which is concerned with determining where the OCaml Standard Library is located relative to an application. In particular, applying that knowledge at link time to all of these various linking mechanisms is likewise complex. The approach I’ve advocated preserves the status quo for the many tools and builds which implicitly need to know where the OCaml Standard Library is (in case you were wondering, pretty much all PPXs rely on it). Another approach might instead be to come up with a different compiler library design so that the location of the Standard Library becomes somewhat less of a concern <em>to the linker</em>!</p>

<p>However, to those papercuts, we should also acknowledge the elephant in the blog post, which is well-documented in <a href="https://xkcd.com/927/">XKCD 927</a> - <em>new</em> workflows brought in to fix old problems will just create <em>new</em> problems.</p>

<p>I strongly contend that we must either <em>fix the old problems</em> or, if we’re going to simplify, we do actually have to simplify, not just deprecate or encourage. So if we bring in something new, it must actually cover <em>all the use-cases</em> of what was there before and if we’re going to remove choices, there need to be pathways for <em>all</em> the use-cases which were possible with the removed choices. <em>All</em> means <strong>100%</strong> or “without exception”!</p>

<p>And that’s kinda what made this such a big project:</p>
<ul>
  <li>It supports (or at least it’s supposed to support!) 100% of the actual ways of using OCaml which exist today.</li>
  <li>It supports (or at least it’s supposed to support!) 100% of the platforms that OCaml runs on with these enhancements.</li>
  <li>It doesn’t require projects <em>using</em> OCaml to be altered (either code or, more importantly, build) which means that it doesn’t <em>force</em> projects, especially libraries, which need to support older versions of OCaml for a while to have to wait or maintain two different mechanisms</li>
</ul>

<p>Sometimes the most effective way to solve a technical problem is to change the question.</p>

<p>Sometimes, however, you just have to cater for (a lot) of corner-cases…</p>
