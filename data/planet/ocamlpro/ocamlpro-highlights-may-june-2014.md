---
title: 'OCamlPro Highlights: May-June 2014'
description: 'Here is a short report on some of our public activities in May and June
  2014. Towards OPAM 1.2 After a lot of discussions and work on OPAM itself, we are
  now getting to a clear workflow for OCaml developpers and packagers: the preliminary
  document for OPAM 1.2 is available here. The idea is that you...'
url: https://ocamlpro.com/blog/2014_07_16_ocamlpro_highlights_may_june_2014
date: 2014-07-16T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Here is a short report on some of our public activities in May and June 2014.</p>
<h3>Towards OPAM 1.2</h3>
<p>After a lot of discussions and work on OPAM itself, we are now getting to a clear workflow for OCaml developpers and packagers: the preliminary document for OPAM 1.2 is available <a href="https://github.com/AltGr/opam-wiki/blob/1.2/Packaging.md">here</a>. The idea is that you can now easily create and test the metadata locally, before having to get your package included in any repo: there is less administrative burden and it's much quicker to start, fix it, test it and get it right.</p>
<p>Things getting pretty stable, we are closing the last few bugs and should be releasing 1.2~beta very shortly.</p>
<h3>OCaml Hacking Session</h3>
<p>We participated in the first OCaml hacking session in Paris organized by Thomas Braibant and supervised by Gabriel Scherer, who had kindly prepared in advance a selection of tasks. In particular, he came with a list of open bugs in Mantis that makes for good first descents in the compiler's code.</p>
<p>It was the first event of this kind for the OCaml Users in Paris (<a href="https://www.meetup.com/ocaml-paris/">OUPS</a>) meetup group. It was a success since everybody enjoyed it and some work has actually been achieved. We'll have to wait for the next one to confirm that !</p>
<p>On our front, Fabrice started working (with others) on a good, consensual Emacs profile; Pierre worked on building cross-compilers using Makefile templates; Benjamin wanted to evaluate the feasibility of handling ppx extension nodes correctly inside Emacs, and it turns out that elisp tools exist for the task! You can see a first experiment running in the following screen capture, or even <a href="https://files.ocamlpro.com/files/tuareg-mode-with-ppx.el">try the code</a> (just open it in emacs, do a <code>M-x eval-buffer</code> on it and then a <code>M-x tuareg-mode-with-ppx</code> on an OCaml file). But beware, it's not yet very mainstream and can make your Emacs crash.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_polymode_tuareg.png" alt="polymode-tuareg.png"/></p>
<h3>Alt-Ergo Development</h3>
<p>During the last two months, we participated in the supervision of an intern, Albin Coquereau - a graduted student at University Paris-Sud - in the VALS team who worked on a conservative extension of the <a href="https://smtlib.cs.uiowa.edu/language.shtml">SMT2 standard input language</a> with prenex polymorphism a la ML and overloading. First results are promising. In the future, we plan to replace Alt-Ergo's input language with our extension of SMT2 in order to get advantage from SMT2's features and <a href="https://www.lri.fr/~conchon/publis/conchon-smt08.pdf">polymorphism's expressiveness</a>.</p>
<p>Recenlty, we have also published an <a href="https://ocamlpro.com/blog/2014_07_15_try_alt_ergo_in_your_browser/">online Javascript-based version of Alt-Ergo</a> (based on private release 0.99).</p>
<h3>OCaml Adventures in Scilab Land</h3>
<p>We are currently working on the proper integration of our Scilab tools in the Scilab world, respecting its ways and conventions. For this, we built a Scilab module respecting the standard ATOMS interface. This module can embed an OCaml program inside the run-time environment of Scilab, so that OCaml functions can be called as external primitives. (Dyn)linking Scilab's various components, LLVM's and the OCaml run-time together was not that easy.</p>
<p>Symmetrically, we built an OCaml library to manipulate and build Scilab values from OCaml, so that our tools can introspect the dynamic envrionment of Scilab's interprete. We also worked with the Scilab team to defined an AST interchange mechanism.</p>
<p>We plan to use this module as an entry point for our JIT oriented type system, as well as to integrate Scilint, our style checker, so that a Scilab user can check their functions without leaving the Scilab toplevel.</p>
<h3>Experiment with Bytes and Backward Compatibility</h3>
<p>As announced by a long discussion in the caml-list, OCaml 4.02 introduces the first step to eliminate a long known OCaml problem: String Mutability. The main difficulty being that resolving that problem necessarilly breaks backward compatibility.</p>
<p>To achieve this first step, OCaml 4.02 comes with a new <code>bytes</code> type and a corresponding <code>Bytes</code> module, similar to OCaml 4.01 <code>String</code> module, but using the <code>bytes</code> type. The type of a few functions from the <code>String</code> module changed to use the <code>bytes</code> type (like <code>String.set</code>, <code>String.blit</code>... ). By default the <code>string</code> and <code>bytes</code> types are equal, hence ensuring backward compatibility for this release, but a new argument &quot;<code>-safe-string</code>&quot; to the compiler can be used to remove this equality, and will probably become the default in some future release.</p>
<pre><code class="language-ocaml"># let s = &quot;foo&quot;;;
val s : string = &quot;foo&quot;
# s.[0] &lt;- 'a';;
Characters 0-1:
s.[0] &lt;- 'a';;
^
Error: This expression has type string but an expression was expected of type bytes
</code></pre>
<p>Notice that even when using <code>-safe-string</code> you shouldn't rely on strings being immutable. For instance even if you compile that file with <code>-safe-string</code>, the assertion in the function <code>g</code> does not necessarilly hold:</p>
<p>If the following file <code>a.ml</code> is compiled with <code>-safe-string</code></p>
<pre><code class="language-ocaml">let s = &quot;foo&quot;
let f () = s
let g () = assert(s = &quot;foo&quot;)
</code></pre>
<p>and the following file <code>b.ml</code> is compiled without -safe-string</p>
<pre><code class="language-ocaml">let s = A.f () in
s.[0] &lt;- 'a';
A.g ()
</code></pre>
<p>In <code>b.ml</code> the equality holds, so modifying the string is possible, and the assertion from <code>A.g</code> will fail.</p>
<p>So you should consider that for now <code>-safe-string</code> is only a compiler-enforced good practice. But this may (and should) change in future versions. The <code>ocamlc</code> man page says:</p>
<pre><code class="language-shell-session">-safe-string
Enforce the separation between types string and bytes, thereby
making strings read-only. This will become the default in a
future version of OCaml.
</code></pre>
<p>In other words if you want your current code to be forward-compatible, your code should start using <code>bytes</code> instead of <code>string</code> as soon as possible.</p>
<h4>Maintaining Compatibility between 4.01 and 4.02</h4>
<p>In our experiments, we found a convenient solution to start using the <code>bytes</code> type while still providing compatibility with 4.01: we use a small <code>StringCompat</code> module that we open at the beginning of all our files making use of <code>bytes</code>. Depending on the version of OCaml used to build the program, we provide two different implementations of <code>stringCompat.ml</code>.</p>
<ul>
<li>Before 4.02, our <code>stringCompat.ml</code> file provides a <code>bytes</code> type and a <code>Bytes</code> module, including the <code>String</code> module plus an often used <code>Bytes.to_string</code> equivalent<code>:</code>
</li>
</ul>
<pre><code class="language-ocaml">type bytes = string
module Bytes = struct
include String
let to_string t = t
end
</code></pre>
<ul>
<li>After 4.02, our <code>stringCompat.ml</code> file is much simpler:
</li>
</ul>
<pre><code class="language-ocaml">type t = bytes
type bytes = t
module Bytes = Bytes
</code></pre>
<p>You might actually even wonder why it is not empty ? In fact, it is also a good practice to compile with a warning for unused <code>open</code>, and an empty <code>stringCompat.ml</code> would always trigger a warning in 4.02 for not being useful. Instead, this simple implementation is always seen as useful, as any use of <code>bytes</code> or <code>Bytes</code> will use the (virtual) indirection through <code>StringCompat</code>.</p>
<p>We plan to upload this module as a <code>string-compat</code> package in OPAM, so that everybody can use this trick. If you have a better solution, we'll be pleased to discuss it via the pull on <code>opam-repository</code>.</p>
<h4>Testing whether your project correctly builds with &quot;-safe-string&quot;</h4>
<p>When your code have been adapted to use the bytes whenever you need to modify a string, you can test if you didn't miss a case using OCaml 4.02 without changing your build system. To do that, you can just set the environment variable <code>OCAMLPARAM</code> to <code>&quot;safe-string=1,_&quot;</code>. Notice that &quot;<code>OCAMLPARAM</code>&quot; should only be used for testing purpose, never set it in your build system or tools, this would prevent testing new compiler options on your package (and you will receive complaints when the core developers can't desactivate the <code>&quot;-w A -warn-error&quot;</code> generated by your build system) !</p>
<p>If your project passes this test and you don't use <code>&quot;-warn-error&quot;</code>, your package should continue to build without modification in the near and the not-so-near future (unless you link with the compiler internals of course).</p>

