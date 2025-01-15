---
title: "Florian\u2019s compiler weekly, 13 January 2025"
description:
url: https://gallium.inria.fr/blog/florian-cw-2025-01-13
date: 2025-01-13T08:00:00-00:00
preview_image:
authors:
- GaGallium
source:
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) work on the OCaml compiler. This week subject is my
personal retrospective on the release of OCaml 5.3.0.</p>


  

  
  <p>The beginning of 2025 and the release of OCaml 5.3 feels like a good
period for some introspection on my work on the compiler during this
release.</p>
<p>Looking backk at the changelog, I have participated to more or less
50 changes in the 5.3 release. Most of those changes (~40) can be
classified into five major themes:</p>
<ul>
<li>Error messages</li>
<li>Compiler display infrastructure</li>
<li>Tooling integration</li>
<li>Manual and documentation</li>
<li>Type system bug fixes</li>
</ul>
<p>Retrospecting, I have been quite busy this release with background
work, and I still have more background work planned for OCaml 5.4.
Hopefully, this background work will bear more visible fruits in the
next releases.</p>
<h2>Error messages</h2>
<p>The first theme for this release is recurrent for me, and I hope that
I would be able to spend even more time on this subject soon. Indeed for
this release, most of the error message improvements were relatively
quick improvements on various topics (first class modules, function
labelled arguments, functors and type clashes). Nevertheless, I still
have many larger projects planned for improving error messages in the
longer terms, in particular:</p>
<ul>
<li>Efficient diffing for module level error messages: there is
prototype implementation written by Malo Monin on his summer internship
last summer which needs more polish before being integrated.</li>
<li>Semantic diffing on type expressions: using the more reliable error
trace, I hope to come back to my previous on syntaxic difference
highlighting in type expressions and implement a fully semantic
version.</li>
</ul>
<p>For more details, here are the corresponding changelog entries
extracted from the 5.3 changelog:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12980">#12980</a>:
Explain type mismatch involving first-class modules by including the
module level error message (Florian Angeletti, review by Vincent
Laviron)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12985">#12985</a>,
<a href="https://github.com/ocaml/ocaml/issues/12988">#12988</a>: Better
error messages for partially applied functors. (Florian Angeletti,
report by Arthur Wendling, review by Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13034">#13034</a>,
<a href="https://github.com/ocaml/ocaml/issues/13260">#13260</a>: Better
error messages for mismatched function labels (Florian Angeletti, report
by Daniel Bünzli, review by Gabriel Scherer and Samuel Vivien)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13341">#13341</a>:
a warning when the pattern-matching compiler pessimizes code because
side-effects may mutate the scrutinee during matching. (This warning is
disabled by default, as this rarely happens and its performance impact
is typically not noticeable.) (Gabriel Scherer, review by Nick Roberts,
Florian Angeletti and David Allsopp)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13255">#13255</a>:
Re-enable warning 34 for unused locally abstract types (Nick Roberts,
review by Chris Casinghino and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12182">#12182</a>:
Improve the type clash error message. For example, this message: This
expression has type … is changed into: The constant “42” has type …
(Jules Aguillon, review by Gabriel Scherer and Florian
Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13170">#13170</a>:
Fix a bug that would result in some floating alerts
<code>[@@@alert ...]</code> incorrectly triggering Warning 53. (Nicolás
Ojeda Bär, review by Chris Casinghino and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13203">#13203</a>:
Do not issue warning 53 if the compiler is stopping before attributes
have been accurately marked. (Chris Casinghino, review by Florian
Angeletti)</p></li>
</ul>
<h2>Compiler display
infrastructure</h2>
<p>This release I ended up spending a sizeable amount of time
refactoring or improving the various display mechanism in the compiler.
In particular, OCaml 5.3 comes with a new internal format for error
messages, a new graphical debugger printer for type expressions, and the
correction on many smaller printing bugs for booleans and the
<code>mod</code> operator.</p>
<p>This trend will continue in OCaml 5.4 since I have already launched a
project on updating the formatting of error messages and warnings, and I
am hoping to finally integrate my work on structured diagnostics in this
version of OCaml.</p>
<p>However, beyond this (significant) piece of work, don’t really have
longer plans on this subject.</p>
<p>The related changelog entries for OCaml 5.3 are:</p>
<h3>Highlights</h3>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13049">#13049</a>:
graphical debugging printer for types (Florian Angeletti, review by
Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13169">#13169</a>,
<a href="https://github.com/ocaml/ocaml/issues/13311">#13311</a>:
Introduce a document data type for compiler messages rather than relying
on <code>Format.formatter -&gt; unit</code> closures. (Florian
Angeletti, review by Gabriel Scherer)</p></li>
</ul>
<h3>Error messages styling</h3>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12891">#12891</a>:
Improved styling for initial prompt (Florian Angeletti, review by
Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13263">#13263</a>,
<a href="https://github.com/ocaml/ocaml/issues/13560">#13560</a>: fix
printing true and false in toplevel and error messages (no more
unexpected #true) (Florian Angeletti, report by Samuel Vivien, review by
Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13151">#13151</a>,
name conflicts explanation as a footnote (Florian Angeletti, review by
Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13053">#13053</a>:
Improved display of builtin types such as <code>_ list</code> when
aliased. (Samuel Vivien, review by Florian Angeletti)</p></li>
</ul>
<h3>Internal refactoring and bug
fixes</h3>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13336">#13336</a>:
compiler-libs, split the <code>Printtyp</code> in three to only keep
“user-friendly” functions in the <code>Printtyp</code> module. (Florian
Angeletti, review by Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12888">#12888</a>:
fix printing of uncaught exceptions in <code>.cmo</code> files passed on
the command-line of the toplevel. (Nicolás Ojeda Bär, review by Florian
Angeletti, report by Daniel Bünzli)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13099">#13099</a>:
Fix erroneous loading of cmis for some module type errors. (Nick
Roberts, review by Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13251">#13251</a>:
Register printer for errors in Emitaux (Vincent Laviron, review by Miod
Vallat and Florian Angeletti)</p></li>
</ul>
<h3>Source printer</h3>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13391">#13391</a>,
<a href="https://github.com/ocaml/ocaml/issues/13551">#13551</a>: fix a
printing bug with <code>-dsource</code> when using raw literal inside a
locally abstract type constraint
(i.e.&nbsp;<code>let f: type \#for. ...</code>) (Florian Angeletti, report by
Nick Roberts, review by Richard Eisenberg)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13603">#13603</a>,
<a href="https://github.com/ocaml/ocaml/issues/13604">#13604</a>: fix
source printing in the presence of the escaped raw identifier
<code>\#mod</code>. (Florian Angeletti, report by Chris Casinghino,
review by Gabriel Scherer)</p></li>
</ul>
<h2>Tooling integration</h2>
<p>Another important subject during this release was the improvement of
the metadata generated for Merlin. OCaml 5.3.0 metadata now track more
accurately identifiers across implementation and interfaces, and record
precisely how implementation identifiers were matched to interface
identifiers in a module. For the next release, I am planning on
improving tooling integration with merlin by reducing the difference
between merlin typechecker and the compiler typechecker. The exact
specification can be found following the link in the corresponding
changelog entry:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13308">#13308</a>:
keep track of relations between declaration in the cmt files. This is
useful information for external tools for navigation and analysis
purposis. (Ulysse Gérard, Florian Angeletti, review by Florian Angeletti
and Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13286">#13286</a>:
Distinguish unique identifiers <code>Shape.Uid.t</code> according to
their provenance: either an implementation or an interface. (Ulysse
Gérard, review by Florian Angeletti and Leo White)</p></li>
</ul>
<p>In a similar way, I have also worked on improving the compatibility
of the internal compiler library with ppxlib and MetaOCaml, and
implemented a new command line flag to improve the backward
compatibility of the lexer:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/11129">#11129</a>,
<a href="https://github.com/ocaml/ocaml/issues/11148">#11148</a>:
enforce that ppxs do not produce <code>parsetree</code>s with an empty
list of universally quantified type variables
(<code>. int -&gt; int</code> instead of
<code>'a . int -&gt; int'</code>) (Florian Angeletti, report by Simmo
Saan, review by Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13471">#13471</a>:
add <code>-keywords &lt;version?+list&gt;</code> flag to define the list
of keywords recognized by the lexer, for instance
<code>-keywords 5.2</code> disable the <code>effect</code> keyword.
(Florian Angeletti, review by Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13257">#13257</a>:
integrate MetaOCaml in the Menhir grammar to ease MetaOCaml maintenance.
This is a purely internal change: there is no support in the lexer, so
no change to the surface OCaml grammar. (Oleg Kiselyov, Gabriel Scherer
and Florian Angeletti, review by Jeremy Yallop)</p></li>
</ul>
<h3>Manual and documentation:</h3>
<p>As an author, I have documented the modest Unicode support introduced
in 5.3 and found the time to write down the compiler release cycles.
However, most on my time working on the documentation has been focused
on reviewing PRs, ranging from a small change to the manual css to an
update to the manual section on polymorphic recursion proposed by a new
contributor.</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13668">#13668</a>:
Document the basic support for unicode identifiers and the switch to
UTF-8 encoded Unicode text for OCaml source file (Florian Angeletti,
review by Nicolás Ojeda Bär and Daniel Bünzli)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12949">#12949</a>:
document OCaml release cycles and version strings in
<code>release-info/introduction.md</code>. (Florian Angeletti, review by
Fabrice Buoro, Kate Deplaix, Damien Doligez, and Gabriel
Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12298">#12298</a>:
Manual: emphasize that Bigarray.int refers to an OCaml integer, which
does not match the C int type. (Edwin Török, review by Florian
Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12868">#12868</a>:
Manual: simplify style colours of the post-processed manual and API HTML
pages, and fix the search button icon (Yawar Amin, review by Simon
Grondin, Gabriel Scherer, and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12976">#12976</a>:
Manual: use webman/<span class="math inline"><em>v</em><em>e</em><em>r</em><em>s</em><em>i</em><em>o</em><em>n</em>/ * .<em>h</em><em>t</em><em>m</em><em>l</em><em>a</em><em>n</em><em>d</em><em>w</em><em>e</em><em>b</em><em>m</em><em>a</em><em>n</em>/</span>version/api/
for OCaml.org HTML manual generation (Shakthi Kannan, review by Hannes
Mehnert, and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13295">#13295</a>:
Use syntax for deep effect handlers in the effect handlers manual page.
(KC Sivaramakrishnan, review by Anil Madhavapeddy, Florian Angeletti and
Miod Vallat)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13469">#13469</a>,
<a href="https://github.com/ocaml/ocaml/issues/13474">#13474</a>, <a href="https://github.com/ocaml/ocaml/issues/13535">#13535</a>: Document
that [Hashtbl.create n] creates a hash table with a default minimal
size, even if [n] is very small or negative. (Antonin Décimo, Nick
Bares, report by Nikolaus Huber and Jan Midtgaard, review by Florian
Angeletti, Anil Madhavapeddy, Gabriel Scherer, and Miod Vallat)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13666">#13666</a>:
Rewrite parts of the example code around nested lists in Chapter 6
(Polymorphism and its limitations -&gt; Polymorphic recursion) giving
the “depth” function [in the non-polymorphically-recursive part of the
example] a much more sensible behavior; also fix a typo and some
formatting. (Frank Steffahn, review by Florian Angeletti)</p></li>
</ul>
<h2>Type system bug fixes</h2>
<p>At last, but not least, I spent many hours this release fixing
internal errors due to inconsistent type constraints in the module
systems. I have also reviewed many bug fixes and in particular a serie
of issues in the typechecker related to the handling of non-injective
type parameters.</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/12959">#12959</a>,
<a href="https://github.com/ocaml/ocaml/issues/13055">#13055</a>: Avoid
an internal error on recursive module type inconsistency (Florian
Angeletti, review by Jacques Garrigue and Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13388">#13388</a>,
<a href="https://github.com/ocaml/ocaml/issues/13540">#13540</a>: raises
an error message (and not an internal compiler error) when two local
substitutions are incompatible (for instance
<code>module type   S:=sig end type t:=(module S)</code>) (Florian
Angeletti, report by Nailen Matschke, review by Gabriel Scherer, and Leo
White)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13185">#13185</a>,
<a href="https://github.com/ocaml/ocaml/issues/13192">#13192</a>: Reject
type-level module aliases on functor parameter inside signatures.
(Jacques Garrigue, report by Richard Eisenberg, review by Florian
Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13306">#13306</a>:
An algorithm in the type-checker that checks two types for equality
could sometimes, in theory, return the wrong answer. This patch fixes
the oversight. No known program triggers the bug. (Richard Eisenberg,
review by Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13495">#13495</a>,
<a href="https://github.com/ocaml/ocaml/issues/13514">#13514</a>: Fix
typechecker crash while typing objects (Jacques Garrigue, report by
Nicolás Ojeda Bär, review by Nicolas Ojeda Bär, Gabriel Scherer, Stephen
Dolan, Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13579">#13579</a>,
<a href="https://github.com/ocaml/ocaml/issues/13583">#13583</a>:
Unsoundness involving non-injective types + gadts (Jacques Garrigue,
report by <span class="citation" data-cites="v-gb">@v-gb</span>, review
by Richard Eisenberg and Florian Angeletti)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13598">#13598</a>:
Falsely triggered warning 56 [unreachable-case] This was caused by
unproper protection of the retyping function. (Jacques Garrigue, report
by Tõivo Leedjärv, review by Florian Angeletti)</p></li>
</ul>
<h2>Miscellaneous</h2>
<p>Beyond those major themes, I also had my hands or eyes at few of the
changes in the language, the standard library and the compiler build
system.</p>
<h3>Language features:</h3>
<p>In term of language features, I partipated to the review for the
newly introduced syntax for effect handler (<a href="https://github.com/ocaml/ocaml/issues/12309">#12309</a>, <a href="https://github.com/ocaml/ocaml/issues/13158">#13158</a>) on the
type system and documentation (<a href="https://github.com/ocaml/ocaml/issues/13295">#13295</a>)
sides.</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://gallium.inria.fr/blog/index.rss#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> with_gen f = <span class="kw">match</span> f () <span class="kw">with</span></span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb1-2" aria-hidden="true" tabindex="-1"></a>| effect Random_float, k -&gt; Effect.Deep.continue k (<span class="dt">Random</span>.<span class="dt">float</span> <span class="dv">1</span>.)</span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb1-3" aria-hidden="true" tabindex="-1"></a>| x -&gt; x</span></code></pre></div>
<p>I also finalized the support the new modest support of utf-8 encoded
Unicode source files in OCaml 5.3 (<a href="https://github.com/ocaml/ocaml/issues/11736">#11736</a>, <a href="https://github.com/ocaml/ocaml/issues/12664">#12664</a>, <a href="https://github.com/ocaml/ocaml/issues/13628">#13628</a>)</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://gallium.inria.fr/blog/index.rss#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> saison = Printemps | Été | Automne | Hiver</span></code></pre></div>
<p>and documented it (<a href="https://github.com/ocaml/ocaml/issues/13668">#13668</a>).</p>
<h3>Type system</h3>
<p>On the pure type system side, I have participated to the review on
the extended support for annotating types in GADT pattern. (<a href="https://github.com/ocaml/ocaml/issues/11891">#11891</a>, <a href="https://github.com/ocaml/ocaml/issues/12507">#12507</a>). It is
now possible to give a name to all type variables introduced by pattern
matching on a GADT constructor</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://gallium.inria.fr/blog/index.rss#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> _ t =</span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-2" aria-hidden="true" tabindex="-1"></a>| S: <span class="dt">string</span> -&gt; <span class="dt">char</span> <span class="dt">array</span> t</span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-3" aria-hidden="true" tabindex="-1"></a>| A: 'a <span class="dt">array</span> -&gt; 'a <span class="dt">array</span> t</span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-4" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-5" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> len (<span class="kw">type</span> a) (x:a t) = <span class="kw">match</span> x <span class="kw">with</span></span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-6" aria-hidden="true" tabindex="-1"></a>| A (<span class="kw">type</span> a) (x:a <span class="dt">array</span>) -&gt; <span class="dt">Array</span>.length x</span>
<span><a href="http://gallium.inria.fr/blog/index.rss#cb3-7" aria-hidden="true" tabindex="-1"></a>| S x -&gt; <span class="dt">String</span>.length x</span></code></pre></div>
<p>whereas it was only possible to name existentially quantified type
variables before.</p>
<h3>Standard library:</h3>
<p>I have reviewed two standard library Pull Requests (PR)</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13168">#13168</a>:
In Array.shuffle, clarify the code that validates the result of the
user-supplied function <code>rand</code>, and improve the error message
that is produced when this result is invalid. (François Pottier, review
by Florian Angeletti, Daniel Bünzli and Gabriel Scherer)</p></li>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13296">#13296</a>:
Add mem, memq, find_opt, find_index, find_map and find_mapi to Dynarray.
(Jake H, review by Gabriel Scherer and Florian Angeletti)</p></li>
</ul>
<p>and authored one PR exposing support for a hidden feature of the
Format module:</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/12133">#12133</a>:
Expose support for printing substrings in Format (Florian Angeletti,
review by Daniel Bünzli, Gabriel Scherer and Nicolás Ojeda Bär)</li>
</ul>
<h3>Build system:</h3>
<p>During the release, I also happened to review some build system
changes:</p>
<ul>
<li><p><a href="https://github.com/ocaml/ocaml/issues/13285">#13285</a>:
continue the merge of the sub-makefiles into the root Makefile started
with <a href="https://github.com/ocaml/ocaml/issues/11243">#11243</a>,
<a href="https://github.com/ocaml/ocaml/issues/11248">#11248</a>, <a href="https://github.com/ocaml/ocaml/issues/11268">#11268</a>, <a href="https://github.com/ocaml/ocaml/issues/11420">#11420</a>, <a href="https://github.com/ocaml/ocaml/issues/11675">#11675</a>, <a href="https://github.com/ocaml/ocaml/issues/12198">#12198</a>, <a href="https://github.com/ocaml/ocaml/issues/12321">#12321</a>, <a href="https://github.com/ocaml/ocaml/issues/12586">#12586</a>, <a href="https://github.com/ocaml/ocaml/issues/12616">#12616</a>, <a href="https://github.com/ocaml/ocaml/issues/12706">#12706</a> and <a href="https://github.com/ocaml/ocaml/issues/13048">#13048</a>.
(Sébastien Hinderer, review by David Allsopp and Florian
Angeletti)</p></li>
<li><p>(<em>breaking change</em>) <a href="https://github.com/ocaml/ocaml/issues/13070">#13070</a>: On
Windows, when configured with bootstrapped flexdll, don’t add +flexdll
to the search path when -nostdlib is specified (which then means
<code>-L path-to-flexdll</code> no longer gets passed to the system
linker). (David Allsopp, review by Florian Angeletti)</p></li>
</ul>


  
