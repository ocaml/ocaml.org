---
title: 'OCamlPro Highlights: Dec 2013 & Jan 2014 '
description: 'Here is a short report of some of our activities in last December and
  January ! A New Intel Backend for ocamlopt With the support of LexiFi, we started
  working on a new Intel backend for the ocamlopt native code compiler. Currently,
  there are four Intel backends in ocamlopt: amd64/emit.mlp, amd64/em...'
url: https://ocamlpro.com/blog/2014_02_05_ocamlpro_highlights_dec_2013_jan_2014
date: 2014-02-05T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Here is a short report of some of our activities in last December and January !</p>
<h3>A New Intel Backend for ocamlopt</h3>
<p>With the support of LexiFi, we started working on a new Intel backend for the <code>ocamlopt</code> native code compiler. Currently, there are four Intel backends in <code>ocamlopt</code>: <code>amd64/emit.mlp</code>, <code>amd64/emit_nt.mlp</code>, <code>i386/emit.mlp</code> and <code>i386/emit_nt.mlp</code>, i.e. support for two processors (amd64 and i386) and two OS variants (Unices and Windows). These backends directly output assembly sources files, on which the platform assembler is called (<code>gas</code> on Unices, and <code>masm</code> on Windows).</p>
<p>The current organisation makes it hard to maintain these backends: code for a given processor has to be written in two almost identical files (Unix and Windows), with subtle differences in the syntax: for example, the destination operand is the second parameter in <code>gas</code> syntax, while it is the first one in AT&amp;T syntax (<code>masm</code>).</p>
<p>Our current work aims at merging, for each processor, the Unix and Windows backends, by making them generate an abstract representation of the assembly. This representation is shared between the two processors ('amd64' and 'i386'), so that we only have to develop two printers, one for <code>gas</code> syntax and one for <code>masm</code> syntax. As a consequence, maintenance of the backend will be much easier: while writting the assembly code, the developer does not need to care about the exact syntax. Moreover, the type-checker can verify that each assembler instruction is used with the correct number of well-formatted operands.</p>
<p>Finally, our hope is that it will be also possible to write optimization passes directly on the assembly representation, such as peephole optimizations or instruction re-scheduling. This work is available in OCaml SVN, in the <a href="https://caml.inria.fr/cgi-bin/viewvc.cgi/ocaml/branches/abstract_x86_asm/asmcomp/intel_proc.ml?view=markup">&quot;abstract_x86_asm&quot; branch</a>.</p>
<h3>OPAM, new Release 1.1.1</h3>
<p>OPAM has been shifted from the 1.1.0-RC to 1.1.1, with large stability and UI improvements. We put a lot of effort on improving the interface, and on helping to build other tools in the emerging ecosystem around OPAM. Louis visited OCamlLabs, which was a great opportunity to discuss the future of OPAM and the platform, and contribute to their effort towards <a href="https://github.com/ocaml/opam/issues/1035">opam-in-a-box</a>, a new way to generate pre-configured VirtualBox instances with all OCaml packages locally installable by OPAM, particularly convenient for computer classrooms.</p>
<p>The many plans and objectives on OPAM can be seen and discussed on the work-in-progress <a href="https://github.com/ocaml/opam/wiki/Roadmap">OPAM roadmap</a>. Lots of work is ongoing for the next releases, including Windows support, binary packages, and allowing more flexibility by shifting the compiler descriptions to the packages.</p>
<h3><code>ocp-index</code> and its new Brother, <code>ocp-grep</code></h3>
<p>On our continued efforts to improve the environment and tools for OCaml hackers, we also made some extensions to <code>ocp-index</code>, which in addition to completing and documenting the values from your libraries, using binary annotations to jump to value definitions, now comes with a tiny <code>ocp-grep</code> tool that offers the possibility to syntactically locate instances of a given identifier around your project - handling <code>open</code>, local opens, module aliases, etc. In emacs, <code>C-c /</code> will get the fully qualified version of the ident under cursor and find all its uses throughout your project. Simple, efficient and very handy for refactorings. The <code>ocp-index</code> query interface has also been made more expressive. Some documentation is <a href="https://www.typerex.org/ocp-index.html">online</a> and will be available shortly in upcoming release 1.1.</p>
<h3><code>ocp-cmicomp</code>: Compression of Interface Files for Try-OCaml</h3>
<p>While developing Try-OCaml, we noticed a problem with big compiled interface files (.cmi). In Try-OCaml, such files are embedded inside the JavaScript file by <code>js_of_ocaml</code>, resulting in huge code files to download on connection (about 12 MB when linking <code>Dom_html</code> from <code>js_of_ocaml</code>, and about 40 MB when linking <code>Core_kernel</code>), and the browser freezing for a few seconds when opening the corresponding modules.</p>
<p>To reduce this problem, we developed a tool, called <code>ocp-cmicomp</code>, to compress compiled interface files. A compiled interface file is just a huge OCaml data structure, marshalled using <code>output_value</code>. This data structure is often created by copying values from other interface files (types, names of values, etc.) during the compilation process. As this is done transitively, the data structure has a lot of redundancy, but has lost most of the sharing. <code>ocp-cmicomp</code> tries to recover this sharing: it iterates on the data structure, hash-consing the immutable parts of it, to create a new data structure with almost optimal sharing.</p>
<p>To increase the opportunities for sharing, <code>ocp-cmicomp</code> also uses some heuristics: for example, it computes the most frequent methods in objects, and sort the list of methods of each object type in increasing order of frequency. As a consequence, different object types are more likely to share the same tail. Finally, we also had to be very careful: the type-checker internally uses a lot physical comparison between types (especially with polymorphic variables and row variables), so that we still had to prevent sharing of some immutable parts to avoid typing problems.</p>
<p>The result is quite interesting. For example, <code>dom_html.cmi</code> was reduced from 2.3 MB to 0.7 MB (-71%, with a lot of object types), and the corresponding JavaScript file for Try-OCaml decreased from 12 MB to 5 MB. <code>core_kernel.cmi</code> was reduced from 13.5 MB to 10 MB (-26%, no object types), while the corresponding JavaScript decreased from 40 MB to 30 MB !</p>
<h3>OCamlRes: Bundling Auxiliary Files at Compile Time</h3>
<p>A common problem when writing portable software is to locate the resources of the program, and its predefined configuration files. The program has to know the system on which it is running, which can be done like in old times by patching the source, generating a set of globals or at run-time. Either way, paths may then vary depending on the system. For instance, paths are often completely static on Unix while they are partially forged on bundled MacOS apps or on Windows. Then, there is always the task of bundling the binary with its auxiliary files which depends on the OS.</p>
<p>For big apps with lots of system interaction, it is something you have to undertake. However, for small apps, it is an unjustified burden. The alternative proposed by <a href="http://www.typerex.org/ocp-ocamlres.html">OCamlRes</a> is to bundle these auxiliary files at compile time as an OCaml module source. Then, one can just compile the same (partially pre-generated) code for all platforms and distribute all-inclusive, naked binary files. This also has the side advantage of turning run-time exceptions for inexistent or invalid files to compile-time errors. OCamlRes is made of two parts:</p>
<ul>
<li>an <code>ocplib-ocamlres</code> library to manipulate resources at run-to time, scan input files to build resource trees, and to dump resources in various formats
</li>
<li>a command line tool <code>ocp-ocamlres</code>, that reads the ressources and bundles them into OCaml source files.
</li>
</ul>
<p>OCamlRes has several output formats, some more subtle than the default mechanism (which is to transform a directory structure on the disk into an OCaml static tree where each file is replaced by its content), and can (and will) be extended. An example is detailed in the <a href="https://www.typerex.org/ocp-ocamlres.html">documentation</a> file.</p>
<h3>Compiler optimisations</h3>
<p>The last post mentioned improvements on the prototype compiler optimization allowing recursive functions specialization. Some quite complicated corner cases needed a rethink of some parts of the architecture. The first version of the patch was meant to be as simple as possible. To this end we chose to avoid as much as possible the need to maintain non trivialy checkable invariants on the intermediate language. That decision led us to add some constraints on what we allowed us to do. One such constraint that matters here, is that we wanted every crucial information (that break things up if the information is lost) to be propagated following the scope. For instance, that means that in a case like:</p>
<pre><code class="language-ocaml">let x = let y = 1 in (y,y) in x
</code></pre>
<p>the information that <code>y</code> is an integer can escape its scope but if the information is lost, at worst the generated code is not as good as possible, but is still correct. But sometimes, some information about functions really matters:</p>
<pre><code class="language-ocaml">let f x =
  let g y = x + y in
  g

let h a =
  let g = f a in
  g a
</code></pre>
<p>Let's suppose in this example that <code>f</code> cannot be inlined, but <code>g</code> can. Then, <code>h</code> becomes (with <code>g.x</code> being access to <code>x</code> in the closure of <code>g</code>):</p>
<pre><code class="language-ocaml">let h a =
  let g = f a in
  a + g.x
</code></pre>
<p>Let's suppose that some other transformation elsewhere allowed <code>f</code> to be inlined now, then <code>h</code> becomes:</p>
<pre><code class="language-ocaml">let h a =
  let x = a in
  let g y = x + y in (* and the code can be eliminated from the closure *)
  a + g.x
</code></pre>
<p>Here the closure of of <code>g</code> changes: the code is eliminated so only the <code>x</code> field is kept in the block, hence changing its offset. This information about the closure (what is effectively available in the closure) must be propagated to the use point (<code>g.x</code>) to be able to generate the offset access in the block. If this information is lost, there is no way to compile that part. The way to avoid that problem was to limit a bit the kind of cases where inlining is possible so that this kind of information could always be propagated following the scope. But in fact a few cases did not verify that property when dealing with inlining parameters from different compilation unit.</p>
<p>So we undertook to rewrite some part to be able to ensure that those kinds of information are effectively correctly propagated and add assertions everywhere to avoid forgeting a case. The main problem was to track all the strange corner cases, that would almost never happen or wouldn't matter if they were not optimally compiled, but must not loose any information to satisfy the assertions.</p>
<h3>Alt-Ergo: More Confidence and More Features</h3>
<h4>Formalizing and Proving a Critical Part of the Core</h4>
<p>Last month, we considered the formalization and the proof of a critical component of Alt-Ergo's core. This component handles equalities solving to produce equivalent substitutions. However, since Alt-Ergo handles several theories (linear integer and rational arithmetic, enumerated datatypes, records, ...), providing a global routine that combines solvers of these individual theories is needed to be able to solve mixed equalities.</p>
<p>The example below shows one of the difficulties we faced when designing our combination algorithm: the solution of the equality <code>r = {a = r.a + r.b; b = 1; c = C}</code> cannot just be of the form <code>r |-&gt; {a = r.a + r.b; b = 1; c = C}</code> as the pivot r appears in the right-hand side of the solution. To avoid this kind of subtle occur-checks, we have to solve an auxiliary and simpler conjunction of three equalities in our combination framework: <code>r = {a = k1 + k2; b = 1; c = C}</code>, <code>r.a = k1</code> and <code>r.b = k2</code> (where <code>k1</code> and <code>k2</code> are fresh variables). We will then deduce that <code>k2 |-&gt; 1</code> and that <code>k1 + k2 = k1</code>, which has no solution.</p>
<pre><code class="language-ocaml">type enum = A | B | C
type t = { a : int ; b : enum }
logic r : t

goal g: r = {a = r.a + r.b; b = 1; c = C} -&gt; false
</code></pre>
<p>After having implemented a new combination algorithm in Alt-Ergo a few months ago, we considered its formalization and its proof, as we have done with most of the critical parts of Alt-Ergo. It was really surprising to see how types information associated to Alt-Ergo terms helped us to prove the termination of the combination algorithm, a crucial property that was hard to prove in our previous combination algorithms, and a challenging research problem as well.</p>
<h4>Models Generation</h4>
<p>On the development side, we conducted some preliminary experiments in order to extend Alt-Ergo with a model generation feature. This capability is useful to derive concrete test-cases that may either exhibit erroneous behaviors of the program being verified or bugs in its formal specification.</p>
<p>In a first step, we concentrated on model generation for the combination of the theories of uninterpreted functions and linear integer arithmetic. The following example illustrates this problem:</p>
<pre><code class="language-ocmal">logic f : int -&gt; int
logic x, y : int

goal g: 2*x &gt;= 0 -&gt; y &gt;= 0 -&gt; f(x) &lt;&gt; f(y) -&gt; false
</code></pre>
<p>We have a satisfiable (but non-valid) formula, where <code>x</code> and <code>y</code> are in the integer intervals <code>[0,+infinity[</code> and <code>f(x) &lt;&gt; f(y)</code>. We would like to find concrete values for <code>x</code>, <code>y</code> and <code>f</code> that satisfy the formula. A first attempt to answer this question may be the following:</p>
<ul>
<li>From an arithmetic point of view, <code>x = 0</code> and <code>y = 0</code> are possible values for <code>x</code> and <code>y</code>. So, Linear arithmetic suggests this partial model to other theories.
</li>
<li>The theory of uninterpreted functions cannot agree with this solution. In fact, <code>x = y = 0</code> would imply <code>f(x) = f(y)</code>, which contradicts <code>f(x) &lt;&gt; f(y)</code>. More generally, <code>x</code> should be different from <code>y</code>.
</li>
<li>Now, if linear arithmetic suggests, <code>x = 0</code> and <code>y = 1</code>, the theory of uninterpreted functions will agree. The next step is to find integer values for <code>f(0)</code> and <code>f(1)</code> such that <code>f(0) &lt;&gt; f(1)</code>.
</li>
</ul>
<p>After having implemented a brute force technique that tries to construct such models, our main concern now is to find an elegant and more efficient &quot;divide and conquer&quot; strategy that allows each theory to compute its own partial model with guarantees that this model will be coherent with the partial models of the other theories. It would be then immediate to automatically merge these partial solutions into a global one.</p>

