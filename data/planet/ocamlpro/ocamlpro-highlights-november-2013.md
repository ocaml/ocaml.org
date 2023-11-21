---
title: 'OCamlPro Highlights: November 2013'
description: 'New Team Members We are pleased to welcome three new members in our
  OCamlPro team since the beginning of November: Benjamin Canou started working at
  OCamlPro on the Richelieu project, an effort to bring better safety and performance
  to the Scilab language. He is in charge of a type inference algorit...'
url: https://ocamlpro.com/blog/2013_12_02_ocamlpro_highlights_november_2013
date: 2013-12-03T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<h2>New Team Members</h2>
<p>We are pleased to welcome three new members in our OCamlPro team since the beginning of November:</p>
<ul>
<li>Benjamin Canou started working at OCamlPro on the Richelieu project,
an effort to bring better safety and performance to the
<a href="https://www.scilab.org/">Scilab</a> language. He is in charge of a
type inference algorithm that will serve both as a developper tool
and in coordination with a JIT. He spent his first month
understanding the darkest corners of the language, and then writing
a versatile AST with a parser to build it. Actually, this is not an
easy task, because the language gives different statuses to
characters (including spaces) depending on the context, leading to
non-trivial lexing. But the real source of problems is the fact that
the original lexparser is intermingled with the interpreter inside a
big bunch of venerable FORTRAN code. This old fellow makes parsing
choices depending on the dynamic typing context, allows its users to
catch syntax errors at runtime, among other fun things. The new
OCaml lexer and parser is handwritten in around a thousand lines,
has performance comparable to a <code>Lex</code> and <code>Yacc</code> generated one, and
is resilient to errors so it could be integrated into an IDE to
detect errors on the fly without stopping on the first one. Once
again, it&rsquo;s OCaml to the rescue of the weak and elderly!An example
of the kind of code that can be written in Scilab:
</li>
</ul>
<pre><code class="language-scilab">if return = while then [ 12..
34.. &hellip; .. &hellip;
56 } ; else &lsquo;&rdquo;&lsquo;&rdquo;
end
</code></pre>
<p>which is parsed into:</p>
<pre><code class="language-scilab">&mdash; parsed in 0.000189&ndash;
(script (if (== !return !while) (matrix (row 123456)) &ldquo;&lsquo;&rdquo;))
&mdash; messages
1.10:1.11: use of deprecated operator &lsquo;=&rsquo;
&mdash; end
</code></pre>
<ul>
<li>
<p>Gregoire Henry started working at OCamlPro on the Bware project. He
is tackling the optimization of memory performance of automatic
provers written in OCaml, in collaboration with Cagdas Bozman. One
of his first contributions after joining us was to exhume his
internship work of 2004, an implementation of <a href="https://github.com/OCamlPro/ocplib-graphics">Graphics for Mac OS
X</a> that we are going to
use for our online OCaml IDE!</p>
</li>
<li>
<p>Thomas Blanc started a PhD at OCamlPro after his summer internship
with us. He is going to continue his work on whole-program analysis,
especially as a way to detect uncaught exceptions. We hope his tool
will be a good replacement for the <a href="https://github.com/OCamlPro/ocamlexc">ocamlexn
tool</a>
written by Francois Pessaux.</p>
</li>
</ul>
<h2>Compiler Updates</h2>
<p>On the compiler optimization front, Pierre Chambart got direct access
to the OCaml SVN, so that he will soon upload his work directly into
an SVN branch, easier for reviewing and integration into the official
compiler. A current set of optimizations is already scheduled for the
new branch, and is now working on inlining recursive functions, such
<code>List.map</code>, by inlining the function definition at the call site, when
at least one of its arguments is invariant during recursion.</p>
<p>A function that can benefit a lot from that transformation is:</p>
<pre><code class="language-ocaml">let f l = List.fold_left (+) 0 l
</code></pre>
<pre><code>camlTest__f_1013:
.L102:
movq %rax, %rdi
movq $1, %rbx
jmp camlTest__fold_left_1017@PLT

camlTest__fold_left_1017:
.L101:
cmpq $1, %rdi
je .L100
movq 8(%rdi), %rsi
movq (%rdi), %rdi
leaq -1(%rbx, %rdi), %rbx
movq %rsi, %rdi
jmp .L101
.align 4
.L100:
movq %rbx, %rax
ret
</code></pre>
<h2>Development Tools</h2>
<h3>Release of OPAM 1.1</h3>
<p>After lots of testing and fixing, the official version 1.1.0 of OPAM
has finally been released. It features lots of stability improvements,
and a reorganized and cleaner repo now hosted at
<a href="https://opam.ocaml.org">https://opam.ocaml.org</a>. Work goes on on OPAM
as we&rsquo;ll release <code>opam-installer</code> soon, a small script that enables
using and testing <code>.install</code> files. This is a step toward a better
integration of OPAM with existing build tools, and are experimenting
with ways to ease usage for Coq packages, to generate binary packages,
and to enhance portability.</p>
<h3>Binary Packages for OPAM</h3>
<p>We also started to experiment with binary packages. We developed a
very small tool, <code>ocp-bin</code>, that monitors the compilation of every OPAM
package, takes a snapshot of OPAM files before and after the
compilation and installation, and generates a binary archive for the
package. The next time the package is re-installed, with the same
dependencies, the archive is used instead of compiling the package
again.</p>
<p>For a typical package, the standard OPAM file:</p>
<pre><code>build: [
[ &ldquo;./configure&rdquo; &ldquo;&ndash;prefix&rdquo; &ldquo;%{prefix}%&rdquo;]
[ &ldquo;make]
[ make &ldquo;install&rdquo;]
]
remove: [
[ make &ldquo;uninstall&rdquo; ]
]
</code></pre>
<p>has to be modified in:</p>
<pre><code>build: [
[ &ldquo;ocp-bin&rdquo; &ldquo;begin&rdquo; &ldquo;%{package}%&rdquo; &ldquo;%{version}%&rdquo; &ldquo;%{compiler}%&rdquo; &ldquo;%{prefix}%&rdquo;
&ldquo;-opam&rdquo; &ldquo;-depends&rdquo; &ldquo;%{depends}%&rdquo; &ldquo;-hash&rdquo; &ldquo;%{hash}%&rdquo;
&ldquo;-nodeps&rdquo; &ldquo;ocamlfind.&rdquo; ]
[ &ldquo;ocp-bin&rdquo; &ldquo;&ndash;&rdquo; &ldquo;./configure&rdquo; &ldquo;&ndash;prefix&rdquo; &ldquo;%{prefix}%&rdquo;]
[ &ldquo;ocp-bin&rdquo; &ldquo;&ndash;&rdquo; make]
[ &ldquo;ocp-bin&rdquo; &ldquo;&ndash;&rdquo; make &ldquo;install&rdquo;]
[ &ldquo;ocp-bin&rdquo; &ldquo;end&rdquo; ]
]
remove: [
[ &ldquo;!&rdquo; &ldquo;ocp-bin&rdquo; &ldquo;uninstall&rdquo;
&ldquo;%{package}%&rdquo; &ldquo;%{version}%&rdquo; &ldquo;%{compiler}%&rdquo; &ldquo;%{prefix}%&rdquo; ]
</code></pre>
<p>Such a transformation would be automated in the future by adding a
field <code>ocp-bin: true</code>. Note that, since <code>ocp-bin</code> takes care of the
deinstallation of the package, it would ensure a complete and correct
deinstallation of all packages.</p>
<p>We also implemented a client-server version of <code>ocp-bin</code>, to be able
to share binary packages between users. The current limitation with
this approach is that many binary packages are not relocatable: if
packages are compiled by Bob to be installed in
<code>/home/bob/.opam/4.01.0</code>, the same packages will only be usable on a
different computer by a user with the same home path! Although it can
still be useful for a user with several computers, we plan to
investigate now on how to build relocatable packages for OCaml.</p>
<h3>Stable Release of ocp-index</h3>
<p>Always looking for a way to provide better tools to the OCaml
programmer, we are happy to announce the first stable release of
<code>ocp-index</code>, which provides quick access to the installed interfaces
and documentation as well as some source-browsing features (lookup
ident definition, search for uses of an ident, etc).</p>
<h2>Profiling Alt-Ergo with <code>ocp-memprof</code>: The Killer App</h2>
<p>One of the most exciting events this month is the use of the
<code>ocp-memprof</code> tool to profile an execution of Alt-Ergo on a big formula
generated by the Cubicle model checker. The story is the following:</p>
<p>The formula was generated from a transition system modeling the FLASH
coherence cache protocol, plus additional information computed by
Cubicle during the verification of FLASH&rsquo;s safety. It contains a
sub-formula made of nested conjunctions of 999 elements. Its proof
requires reasoning in the combination of the free theory of equality,
enumerated data types and quantifiers. Alt-Ergo was able to discharge
it in only 10 seconds. However, Alain Mebsout &mdash; who is doing his Phd
thesis on Cubicle &mdash; noticed that Alt-Ergo allocates more than 60 MB
during its execution.</p>
<p>In order to localize the source of this abnormal memory consumption,
we installed the OCaml Memory Profiler runtime, version 4.00.1+memprof
(available in the private OPAM repository of OCamlPro) and compiled
Alt-Ergo using -bin-annot option in order to dump .cmt files. We then
executed the prover on Alain&rsquo;s example as shown below, without any
instrumentation of Alt-Ergo&rsquo;s code.</p>
<pre><code class="language-shell-session">$ OCAMLRUNPARAM=m ./alt-ergo.opt formula.mlw
</code></pre>
<p>This execution caused the modified OCaml compiler to dump a snapshot
of the typed heap at every major collection of the GC. The names of
dumped files are of the form
<code>memprof.&lt;PID&gt;.&lt;DUMP-NAME&gt;.&lt;image-number&gt;.dump</code>, where PID is a natural
number that identifies the set of dumped files during a particular
execution.</p>
<p>Dumped files were then fed to the <code>ocp-memprof</code> tool (available in the
TypeRex-Pro toolbox) using the syntax below. The synthesis of this
step (.hp file) was then converted to a .ps file thanks to hp2ps
command. At the end, we obtained the diagram shown in the figure
below.</p>
<pre><code class="language-shell-session">$ ./ocp-memprof -loc -sizes PID
</code></pre>
<p><img src="https://ocamlpro.com/blog/assets/img/alt-ergo-memprof-before.png" alt="alt-ergo-memprof-before.png"/></p>
<p>From the figure above, one can extract the following information:</p>
<ul>
<li>
<p>there were 15 major collections of OCaml&rsquo;s GC during the above execution (the x-axis),</p>
</li>
<li>
<p>Alt-Ergo allocated more than 60 MB during its execution (the y-axis),</p>
</li>
<li>
<p>Some function in file <code>src/preprocess/why_typing.ml</code> is allocating a
lot of data of type <code>Parsed.pp_desc</code> at line 868 (the first square
of the legend).</p>
</li>
</ul>
<p>The third point corresponds to a piece of code used in a recursive
function that performs alpha renaming on parsed formulas to avoid
variable captures. This code is the following:</p>
<pre><code class="language-ocaml">let rec alpha_renaming_b s f =
&hellip;

| PPinfix(f1, op, f2) -&gt; (* &lsquo;op&rsquo; may be the AND operator *)
let ff1 = alpha_renaming_b s f1 in
let ff2 = alpha_renaming_b s f2 in
PPinfix(ff1, op, ff2) (* line 868 *)

&hellip;
</code></pre>
<p>Actually, in 99% there are no capture problems and the function just
reconstructs a new value <code>PPinfix(ff1, op, ff2)</code> that is structurally
equal (=) to its argument <code>f</code>. In case of very big formulas (recall that
Alain&rsquo;s formula contains a nested conjunction of 999 elements), this
causes Alt-Ergo to allocate a lot.</p>
<p>Fixing this behavior was straightforward. We only had to check whether
recursive calls to alpha renaming function returned modified values
using physical equality <code>==</code>. If not, no renaming is performed and we
safely return the formula given in the argument. This way, the
function will never allocate for formulas without capture issues. For
instance, the piece of code given above is fixed as follows:</p>
<pre><code class="language-ocaml">let rec alpha_renaming_b s f =
&hellip;

| PPinfix(f1, op, f2) -&gt;
let ff1 = alpha_renaming_b s f1 in
let ff2 = alpha_renaming_b s f2 in
if ff1 == f1 &amp;&amp; ff2 == f2 then f (* no renaming performed by recursive calls ? *)
else PPinfix(ff1, op, ff2)

&hellip;
</code></pre>
<p>Once we applied the patch on the hole function alpha_renaming_b,
<code>Alt-Ergo</code> only needed 2 seconds and less than 2.2MB memory to prove our
formula. Profiling an execution of patched version of the prover with
OCaml 4.00.1+memprof and <code>ocp-memprof</code> produced the diagram below. The
difference with the first drawing was really impressive.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/alt-ergo-memprof-after.png" alt="alt-ergo-memprof-after.png"/></p>
<h2>Other R&amp;D Projects</h2>
<h3>Scilint, the Scilab Style-Checker</h3>
<p>This month our work on Richelieu was mainly focused on improving
Scilint. After some discussions with Scilab knowledgeable users, we
chose a new set of warnings to implement. Among other things those
warnings analyze primitive fonctions and their arguments as well as
loop variables. Another important thing was to allow SciNotes,
Scilab&rsquo;s editor, to display our warnings. This has been done by
implementing support for Firehose. Finally some minor bugs were also
fixed.</p>

