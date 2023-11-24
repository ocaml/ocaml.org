---
title: 'OCamlPro Highlights: Feb 2014 '
description: 'Here is a short report of some of our activities in February 2014 !
  Displaying what OPAM is doing After releasing version 1.1.1, we have been very busy
  preparing the next big things for OPAM. We have also steadily been improving stability
  and usability, with a focus on friendly messages: for example...'
url: https://ocamlpro.com/blog/2014_03_05_ocamlpro_highlights_feb_2014
date: 2014-03-05T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\t\n  "
source:
---

<p>Here is a short report of some of our activities in February 2014 !</p>
<h4>Displaying what OPAM is doing</h4>
<p>After releasing <a href="https://github.com/ocaml/opam/releases/tag/1.1.1">version 1.1.1</a>, we have been very busy preparing the <a href="https://github.com/ocaml/opam/wiki/Roadmap">next big things</a>
for OPAM. We have also steadily been improving stability and usability,
with a focus on friendly messages: for example, there is a <a href="https://github.com/ocaml/opam/commit/4d1a79a0a92456872e4986de6d7cfc07a7ce4c7c">whole new algorithm</a> to give the best explanations on what OPAM is going to do and why:</p>
<p>With OPAM 1.1.1, you currently get this information:</p>
<pre><code class="language-shell-session">## opam install custom_printf.109.15.00
The following actions will be performed:
&ndash; remove pa_bench.109.55.02
&ndash; downgrade type_conv.109.60.01 to 109.20.00 [required by comparelib, custom_printf]
&ndash; downgrade uri.1.4.0 to 1.3.11
&ndash; recompile variantslib.109.15.03 [use type_conv]
&ndash; downgrade sexplib.110.01.00 to 109.20.00 [required by custom_printf]
&ndash; downgrade pa_ounit.109.53.02 to 109.18.00 [required by custom_printf]
&ndash; recompile ocaml-data-notation.0.0.11 [use type_conv]
&ndash; recompile fieldslib.109.20.03 [use type_conv]
&ndash; recompile dyntype.0.9.0 [use type_conv]
&ndash; recompile deriving-ocsigen.0.5 [use type_conv]
&ndash; downgrade comparelib.109.60.00 to 109.15.00
&ndash; downgrade custom_printf.109.60.00 to 109.15.00
&ndash; downgrade cohttp.0.9.16 to 0.9.15
&ndash; recompile cow.0.9.1 [use type_conv, uri]
&ndash; recompile github.0.7.0 [use type_conv, uri]
0 to install | 7 to reinstall | 0 to upgrade | 7 to downgrade | 1 to remove
</code></pre>
<p>With the next <code>trunk</code> version of OPAM, you will get the much more informative output on real dependencies:</p>
<pre><code class="language-shell-session">## opam install custom_printf.109.15.00
The following actions will be performed:
&ndash; remove pa_bench.109.55.02 [conflicts with type_conv, pa_ounit]
&ndash; downgrade type_conv from 109.60.01 to 109.20.00 [required by custom_printf]
&ndash; downgrade uri from 1.4.0 to 1.3.10 [uses sexplib]
&ndash; recompile variantslib.109.15.03 [uses type_conv]
&ndash; downgrade sexplib from 110.01.00 to 109.20.00 [required by custom_printf]
&ndash; downgrade pa_ounit from 109.53.02 to 109.18.00 [required by custom_printf]
&ndash; recompile ocaml-data-notation.0.0.11 [uses type_conv]
&ndash; recompile fieldslib.109.20.03 [uses type_conv]
&ndash; recompile dyntype.0.9.0 [uses type_conv]
&ndash; recompile deriving-ocsigen.0.5 [uses type_conv]
&ndash; downgrade comparelib from 109.60.00 to 109.15.00 [uses type_conv]
&ndash; downgrade custom_printf from 109.60.00 to 109.15.00
&ndash; downgrade cohttp from 0.9.16 to 0.9.14 [uses sexplib]
&ndash; recompile cow.0.9.1 [uses type_conv]
&ndash; recompile github.0.7.0 [uses uri, cohttp]
0 to install | 7 to reinstall | 0 to upgrade | 7 to downgrade | 1 to remove
</code></pre>
<p>Failsafe behaviour is being much improved as well, because things do
happen to go wrong when you access the network to download packages and
then compile them, and that was the biggest source of problems for our
users: errors are now more <a href="https://github.com/ocaml/opam/commit/f8808c603820771627a6a8477778a5f52e46758f">tightly controlled</a> in <a href="https://github.com/ocaml/opam/commit/c52a2f2ef12ad93f2838907ab3e5ac38d631703b">each stage</a> of the opam command.</p>
<p>For example, nothing will be changed in case of a failed or interrupted download, and if you press <code>C-c</code> in the middle of an action, you&rsquo;ll get something like this:</p>
<pre><code class="language-shell-session">[ERROR] User interruption while waiting for sub-processes

[ERROR] Failure while processing typerex.1.99.6-beta

=-=-= Error report =-=-=
These actions have been completed successfully
install conf-gtksourceview.2
upgrade cmdliner from 0.9.2 to 0.9.4
The following failed
install typerex.1.99.6-beta
Due to the errors, the following have been cancelled
install ocaml-top.1.1.2
install ocp-index.1.0.2
install ocp-build.1.99.6-beta
recompile alcotest.0.2.0
install ocp-indent.1.4.1
install lablgtk.2.16.0

The former state can be restored with opam switch import -f &ldquo;&lt;xxx&gt;.export&rdquo;
</code></pre>
<p>You also shouldn&rsquo;t have to dig anymore to find the most meaningful error when something fails.</p>
<p>With the ever-increasing number of packages and versions, resolving
requests becomes a real challenge and we&rsquo;re glad we made the choice to
rely on specialized solvers. The built-in heuristics may show its limits
when attempting <a href="https://github.com/ocaml/opam-rt/commit/f15c492b1a21ccd99e140a3d440330dd0d39a8ff">long-delayed upgrades</a>, and everybody is encouraged to install an external solver (<a href="http://potassco.sourceforge.net/index.html">aspcud</a> being the one supported at the moment).</p>
<p>Consequently, we have also been working more tightly with the Mancoosi team at <a href="http://www.irill.org/">IRILL</a> to <a href="https://github.com/ocaml/opam/commit/d3dd9b0ef46881987251f3e375e86dd209b034b8">improve interaction with the solver</a>, and how the user can <a href="https://github.com/ocaml/opam/wiki/Specifying_Solver_Preferences">get the best of it</a> is now well documented, thanks to Roberto Di Cosmo.</p>
<h4>Per-projects OPAM Switches with <code>ocp-manager</code></h4>
<p>At OCamlPro, we often use OPAM with multiple switches, to test
whether our tools are working with different versions of OCaml,
including the new ones that we are developing. Switching between
versions is not always as intuitive as we would like, as we sometimes
forget to call</p>
<pre><code class="language-shell-session">$ eval `opam config env`
</code></pre>
<p>in the right location or at the good time, and end up compiling a
project with a different version of OCaml that we would have liked.</p>
<p>It was quite surprising to discover that a tool that we had developed a long time ago, <a href="http://www.typerex.org/ocp-manager.html">ocp-manager</a>, would actually become a solution for us to a problem that appeared just now with OPAM: <code>ocp-manager</code>
was a tool we used to switch between different versions of OCaml before
OPAM. It would use a directory of wrappers, one for each OCaml tool,
and by adding this directory once and for all to the PATH, with:</p>
<pre><code class="language-shell-session">$ eval `ocp-manager -config`
</code></pre>
<p>You would be able to switch to OPAM switch 3.12.1 (that needs to have been installed first with OPAM) immediatly by using:</p>
<p>[code language=&rdquo;bash&rdquo; gutter=&rdquo;false&rdquo;]</p>
<pre><code class="language-shell-session">$ ocp-manager -set opam:3.12.1
</code></pre>
<p>Nothing much different from OPAM ? The nice thing with <code>ocp-manager</code>
is that wrappers also use environment variables and per-directory
information to choose the OCaml version of the tool they are going to
run. For example, if some top-directory of your project contains a file <code>.ocp-switch</code>
with the line &ldquo;opam:4.01.0&rdquo;, your project will always be compiled with
this version of OCaml, even if you change the global per-user
configuration. You can also override the global and local configuration
by setting the <code>OCAML_VERSION</code> environment variable.</p>
<p>Maybe <a href="https://www.typerex.org/ocp-manager.html">ocp-manager</a> can also be useful for you. Just install it with <code>opam install ocp-manager</code>,
change your shell configuration to add its directory to your PATH, and
check if it also works for you (the manpage can be very useful!).</p>
<h4>Optimization Patches for <code>ocamlopt</code> under Reviewing Process</h4>
<p>This month, we also spent a lot of time improving the optimization patches that <a href="https://github.com/chambart/ocaml">we submitted</a>
for inclusion into OCaml, and that we have described in our previous
blog posts. Mark Shinwell from Jane Street and Gabriel Scherer from
INRIA kindly accepted to devote some of their time in a thorough
reviewing process, leading to many improvements in the readability and
maintenability of our optimization code. As this first patch is a
prerequisite for our next patches, we also spent a lot of time
propagating these modifications, so that we will be able to submit them
faster once this one has been merged!</p>
<h4>Displaying the Distribution of Block Sizes with <code>ocp-memprof</code></h4>
<p>In our study to understand the memory behavior of OCaml applications,
we have investigated the distribution of block sizes, both in the heap
(live blocks) and in the free list (dead blocks). This information
should help the programmer to understand which GC parameters might be
the best ones for his application, by showing the fragmentation of the
heap and the time spent searching in the free list. It is all the more
important that improving the format of the free list with bins has been
discussed lately in the Core team.</p>
<p>Here, we display the distribution of blocks at a snapshot during the execution of <code>why3replayer</code>, a tool that we are trying to optimize during the <a href="https://bware.lri.fr/index.php/BWare_project">Bware Project</a>. The number of free blocks is displayed darker than live blocks, from size 21 to size 0.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_blocks_stats1.png" alt="blocks_stats"/></p>
<p>It is interesting to notice that, for this applications, almost all
allocations have a size smaller than 6. We are planning to use such
information to simulate the cost of allocation for this application, and
see which data structure for the free list would benefit the most to
the performance of the application.</p>
<h4>Whole Program Analysis</h4>
<p>The static OCaml analyszer is going quite well. Our set of (working) <a href="https://github.com/OCamlPro/ocaml-data-analysis/tree/master/test/samples">test samples</a> is growing in size and complexity. Our last improvement was what is called <strong>widening</strong>.
What&rsquo;s widening ? Well, the main idea is &ldquo;when I go through a big loop
5000 times, I don&rsquo;t want the analyzer to do that too&rdquo;. If we take this
sample test:</p>
<pre><code class="language-ocaml">let () = for i = 0 to 5000 do () done
</code></pre>
<p>Without widening, the analysis would loop 5000 times through that
loop. That&rsquo;s quite useless, not to mention that replacing 5000 by <code>Random.int ()</code> would make the analysis loop until max_int (2^62 times on a 64-bits computer) ! Worse, let&rsquo;s take this code:</p>
<pre><code class="language-ocaml">let () =
let x = ref 0 in
for i = 1 to 10 do
x := !x + 1
done
</code></pre>
<p>Here, the analysis would not see that the increment on !x and i would
be linked (that&rsquo;s one of the aproximations we do to make the
computation doable). So, the analyzer does not loop ten times, but again
2^62 times: we do not want that to happen.</p>
<p>The good news now: we can say to the analyzer &ldquo;every time you go
through a loop, check what integers you incremented, and suppose you&rsquo;ll
increment them again and again until you can&rsquo;t&rdquo;. This way we only go
twice through our for-loop: first to discover it, then to propagate the
widening approximation.</p>
<p>Of course this is not that simple, and we&rsquo;ll often loose information
by doing only two iterations. But in most cases, we don&rsquo;t need it or we
can get it in a quicker way than iterating billions of times through a
small loop.</p>
<p>Hopefully, we&rsquo;ll soon be able to analyze any simple program that uses only <code>Pervasives</code> and the basic language features, but <code>for</code> and <code>while</code> loops are already a good starting point !</p>
<h4>SPARK 2014: a Use-Case of Alt-Ergo</h4>
<p>The SPARK toolset, developped by the <a href="https://www.adacore.com/">AdaCore</a>
company, targets the verification of programs written in the SPARK
language; a subset of Ada used in the design of critical systems. We
published this month a <a href="https://alt-ergo.ocamlpro.com/use_cases.php">use-case</a> of Alt-Ergo that explains the integration of our solver as a back-end of the <a href="https://www.spark-2014.org/">next generation of SPARK</a>.</p>
<p>Discussions with SPARK 2014 developpers were very important for us to
understand the strengths of Alt-Ergo for them and what would be
improved in the solver. We hope this use-case will be helpful for IT
solutions providers that would need an automatic solver in their
products.</p>
<h4>Scilab 5 or Scilab 6 ?</h4>
<p>We are still working at improving the Scilab environment with new
tools written in OCaml. We are soon going to release a new version of <a href="https://scilint.ocamlpro.com/">Scilint</a>,
our style-checking tool for Scilab code, with a new parser compatible
with Scilab 5 syntax. Changing the parser of Scilint was not an easy
job: while our initial parser was partially based on the yacc parser of
the future Scilab 6, we had to write the new parser from scratch to
accept the more tolerant syntax of Scilab 5. It was also a good
opportunity to design a cleaner AST than the one copied from Scilab 6:
written in C++, Scilab 6 AST would for example have all AST nodes
inherit from the <code>Exp</code> class, even instructions or the list of parameters of a function prototype !</p>
<p>We have also started to work on a type-system for Scilab. We want the
result to be a type language expressive enough to express, say, the
(dependent) sizes of matrices, yet simple enough for clash messages not
to be complete black magic for Scilab programmers. This is not simple.
In particular, there is the other constraint to build a versatile type
system that could serve a JIT or give usable information to the
programmer. Which means that the type environment is a mix of static
information coming from the inference and of annotations, and dynamic
information gotten by introspection of the dynamic interpreter.</p>
<p>In the mean time, we are also planning to write a simpler JIT, to
mitigate the impatience of Scilab programmers expecting to feel the
underlying power of OCaml!</p>

