---
title: Florian compiler weekly, 11 December 2023
description:
url: https://gallium.inria.fr/blog/florian-cw-2023-12-11
date: 2023-12-11T08:00:00-00:00
preview_image:
authors:
- GaGallium
source:
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) work on the OCaml compiler. This week subject is the
release of OCaml 5.1.1, some review work on occurrences analysis for
OCaml projects and a bit of on-going work on structured logs.</p>





  <h3>OCaml 5.1.1</h3>
<p>OCaml 5.1.0 has been released nearly three months ago, in those
months we have discovered a few significant bugs that were impeding the
use of OCaml 5.1.1:</p>
<ul>
<li>one type system soundness bug</li>
<li>one dependency bug</li>
<li>one GC performance regression bug in numerical code</li>
</ul>
<p>To fix those issues, and have a version of OCaml 5.1 usable by
anyone, we have release a new patched version 5.1.1 of OCaml.</p>
<p>Let&rsquo;s spend some time analysing those issues.</p>
<h4>Type system (and type
printing) bug</h4>
<p>The first worrying bug in OCaml 5.1.0 was an issue with the
refactoring of variance computation. Suddenly, in OCaml 5.1.0 one could
write</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="o">-</span><span class="k">'</span><span class="n">a</span> <span class="n">n</span>
<span class="k">type</span> <span class="o">+</span><span class="k">'</span><span class="n">a</span> <span class="n">p</span>
<span class="k">type</span> <span class="o">+</span><span class="k">'</span><span class="n">a</span> <span class="n">ko</span> <span class="o">=</span> <span class="k">'</span><span class="n">a</span> <span class="n">p</span> <span class="n">n</span>
</pre></div>

<p>and the typechecker would accept the absurd statement that
<code>+ * - = +</code>. Such a statement can be easily exploited to
crash an OCaml program, and it was introduced due to a small typo when
refactoring the typechecker.</p>
<div class="highlight"><pre><span></span><span class="ow">and</span> <span class="n">mn</span> <span class="o">=</span>
  <span class="n">mem</span> <span class="nc">May_pos</span> <span class="n">v1</span> <span class="o">&amp;&amp;</span> <span class="n">mem</span> <span class="nc">May_neg</span> <span class="n">v2</span> <span class="o">||</span> <span class="n">mem</span> <span class="nc">May_pos</span> <span class="n">v1</span> <span class="o">&amp;&amp;</span> <span class="n">mem</span> <span class="nc">May_neg</span> <span class="n">v2</span>
</pre></div>

<p>(Can you spot the typo?)</p>
<p>Fortunately, the typo was easy to fix and the type system unsoundness
was soon fixed.</p>
<p>But that was only the first problem. Soon after, a second report came
in, mentioning that the typechecker was crashing on cyclic abbreviations
like</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">=</span> <span class="k">'</span><span class="n">a</span> <span class="n">s</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="n">irr</span>
<span class="ow">and</span> <span class="k">'</span><span class="n">a</span> <span class="n">irr</span> <span class="o">=</span> <span class="kt">unit</span>
<span class="ow">and</span>  <span class="k">'</span><span class="n">a</span> <span class="n">s</span> <span class="o">=</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>
</pre></div>

<p>but only when the <code>-short-paths</code> flag was specified. After
some investigation, it was not the typechecker that was crashing but the
type printer! (which is unfortunately not a that rare occurrence)</p>
<p>More precisely, the type printer was crashing when trying to print
the improved type error message in OCaml 5.1 for cyclic definition</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">The</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">abbreviation</span><span class="w"> </span><span class="n">t</span><span class="w"> </span><span class="k">is</span><span class="w"> </span><span class="n">cyclic</span><span class="o">:</span>
<span class="w">         </span><span class="s1">'a t = '</span><span class="n">a</span><span class="w"> </span><span class="n">s</span><span class="w"> </span><span class="o">*</span><span class="w"> </span><span class="s1">'a irr,</span>
<span class="s1">         '</span><span class="n">a</span><span class="w"> </span><span class="n">s</span><span class="w"> </span><span class="o">*</span><span class="w"> </span><span class="s1">'a irr contains '</span><span class="n">a</span><span class="w"> </span><span class="n">s</span><span class="o">,</span>
<span class="w">         </span><span class="s1">'a s = '</span><span class="n">a</span><span class="w"> </span><span class="n">t</span>
</pre></div>

<p>because in presence of the flag <code>-short-path</code> the printer
tried to find a better name for <code>'a t</code> in a type environment
which contained the recursive definition. This endeavour was doomed to
fail. Fortunately, the fix was quite straightforward: don&rsquo;t feed the
type printer invalid type environment.</p>
<h4>Packaging bug</h4>
<p>The introduced of compressed compiler artefacts (<code>.cmi</code>,
<code>.cmt</code>, and <code>.cmo</code> files) decreased the size of a
compiler installation by a third. However, when focusing on the nice
decrease in size of the installation; we forgot that using an external C
library for compression within the runtime added this library as
dependency for all users of the OCaml runtime.</p>
<p>In other words, we had added a new C dependency to all OCaml users.
If this didn&rsquo;t seem to create problem on macOS or most linux situation,
at least for developers, it was clearly a non ideal situation. A
compiler shouldn&rsquo;t impose its dependency on compiled programs.</p>
<p>Moreover, if compressed marshalling is very nice for the compiler,
this is a quite biased use case. In particular, one cannot use
marshalled data coming from untrustworthy sources (because such data
breaks type safety). Consequently, marshalled data is mostly used as a
computation cache. This is what the compiler or Coq are doing, but this
is not a frequent use case in the rest of ecosystem. Thus adding a new
dependency to all OCaml programs for a niche use case was really not
optimal.</p>
<p>Thus, after this packaging issue was discovered, we went on a journey
to remove this dependency. After exploring hacks, visiting the
limitations of dead symbol elimination by linkers, we finally reached a
not that comfortable conclusion: the most robust solution was to remove
the <code>Compression</code> flag from the standard library, while
moving the compression support to a compiler internal library.</p>
<p>With this solution, the compression library dependency is no longer
propagated to OCaml programs. But if someone wishes to used compressed
marshalling, the only simple option for now is to use the compiler
library.</p>
<p>However, this also means for the first time in a long time, a patch
version of OCaml introduces a breaking change. Such breaking changes
could have been avoided by ignoring the current
<code>Marshal.Compression</code> flag. However, having a disabled flag
exposed in the standard library sowing confusion amongst all users
seemed to be a worse outcome than breaking the code of the few advanced
users that might had released code relying on this new feature.</p>
<h4>Garbage Collection
Performance Regression</h4>
<p>Finally, while the compression odyssey was on-going, I received a
report by an user complaining that their numerical program ported to
OCaml from Python was slower in OCaml. After looking at the performance,
the Garbage Collector was surprisingly high in the list of hot
performance spot for a purely numerical program.</p>
<p>Knowing that there were <em>maybe</em> some bugs lurking in the
shadows of the 5.1.0 GC, I suggested to check the performance of this
program on OCaml 4.14.1. Lo and behold, OCaml 4.14 <em>was</em> faster
than python.</p>
<p>What happened to OCaml 5 to create such slowdown on a single thread
program? Comparing the amount of time the GC triggered a major
collection was surprising:</p>
<table>
<thead>
<tr class="header">
<th>compiler version</th>
<th>time</th>
<th>minor</th>
<th>major</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>4.14.1</td>
<td>0.803s</td>
<td>6626</td>
<td>1656</td>
</tr>
<tr class="even">
<td>5.0.0</td>
<td>1.448s</td>
<td>8697</td>
<td>8679</td>
</tr>
<tr class="odd">
<td>5.1.0</td>
<td>5.507s</td>
<td>56162</td>
<td>56156</td>
</tr>
<tr class="even">
<td>5.2.0+trunk</td>
<td>1.701s</td>
<td>10945</td>
<td>10939</td>
</tr>
<tr class="odd">
<td>5.1+gc_fixes</td>
<td>1.740s</td>
<td>10563</td>
<td>10557</td>
</tr>
</tbody>
</table>
<p>Between OCaml 4.14 and OCaml 5.1.0, the amount of major collection
had been multiplied by a factor 50 .</p>
<p>If the root cause behind this change has not been completely
understood yet, we fortunately had an easy way out: the OCaml 5.2
development version had already accumulated enough fixes to limit this
increase to a less dramatic factor 6.</p>
<p>This is still not satisfying, but this is half expected for a still
experimental runtime. And while waiting for a better solution, the
collection of bug fixes integrated in OCaml 5.1.1 should made it
possible to use numerical code in OCaml.</p>
<h3>Project-wide occurrence index</h3>
<p>Beyond the release of OCaml 5.1.1, I have been working on reviewing
PRs.</p>
<p>With Gabriel Scherer and Ulysse G&eacute;rard, we spend an afternoon reading
and discussing the design of a PR by Ulysse which improves the
<code>shape</code> metadata to make them provides an index of value and
definition occurrences within an OCaml module.</p>
<p>The <code>shape</code> metadata are a new form of metadata introduced
in OCaml 4.14. Those metadata tracks definitions of types, modules,
module types, &hellip;</p>
<p>One important characteristic of <code>shapes</code> is that they are
able to see through functors applications and includes to find back the
original definition of values.</p>
<p>With the proposed PR, which still need more review time (maybe this
week), one could use this information to find the occurrences of any
values in an OCaml project (through the use of IDEs)</p>
<h3>Structured log for the
OCaml compiler</h3>
<p>One of my ongoing work during this release cycle has been to create a
structured log API for all output of the compiler.</p>
<p>One of the expected benefits for those logs would be a complete and
versioned description of all user-facing outputs emitted by the
compiler.</p>
<p>Consequently, a scheme for a log should have a clear version. But my
current log API has a notion of nested logs, since the scheme DSL is
essentially a versioned description of Algebraic Data Types.</p>
<p>Which leads me to the question, should nested logs have a version
too?</p>
<p>My current answer is that only toplevel logs should have a version.
Currently, this is implemented in OCaml by using a handful of generative
functors as a fun use case for mixing phantom types and generative
functors.</p>
<p>The idea is that we first define a <code>Root</code> module type that
can define new versions by creating a value of type
<code>id scheme_version</code> (with <code>id</code> a fresh new
type).</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">scheme_version</span>
<span class="k">type</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">key</span>
<span class="k">module</span> <span class="k">type</span> <span class="nc">Def</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">id</span> <span class="c">(* this should be a fresh and unique id *)</span>
  <span class="k">type</span> <span class="n">scheme</span> <span class="o">=</span> <span class="n">id</span> <span class="n">sch</span>
  <span class="k">type</span> <span class="n">log</span> <span class="o">=</span> <span class="n">id</span> <span class="n">t</span>
  <span class="k">type</span> <span class="n">nonrec</span> <span class="k">'</span><span class="n">a</span> <span class="n">key</span> <span class="o">=</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="n">id</span><span class="o">)</span> <span class="n">key</span>
  <span class="k">val</span> <span class="n">scheme</span><span class="o">:</span> <span class="n">scheme</span>
<span class="k">end</span>

<span class="k">module</span> <span class="k">type</span> <span class="nc">Root</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">include</span> <span class="nc">Def</span>
  <span class="k">val</span> <span class="n">v1</span><span class="o">:</span> <span class="n">id</span> <span class="n">scheme_version</span>
  <span class="k">val</span> <span class="n">new_key</span><span class="o">:</span> <span class="n">id</span> <span class="n">scheme_version</span>  <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">typ</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">key</span>
  <span class="k">val</span> <span class="n">new_version</span><span class="o">:</span> <span class="n">version</span> <span class="o">-&gt;</span> <span class="n">id</span> <span class="n">scheme_version</span>
<span class="k">end</span>
</pre></div>

<p>Then nested records or sum types can only create new fields or
constructors by using a typed version defined by the parent module:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">Sum</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">root</span>
  <span class="k">include</span> <span class="nc">Def</span>
  <span class="k">val</span> <span class="n">new_constr</span><span class="o">:</span> <span class="n">root</span> <span class="n">scheme_version</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">typ</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">key</span>
<span class="k">end</span>
</pre></div>

<p>and we can use generative functors to ensure that our type-level
identifiers are as fresh as we need them to be:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">New_root_scheme</span><span class="bp">()</span><span class="o">:</span> <span class="nc">Root</span>
<span class="k">module</span> <span class="nc">New_record</span><span class="o">(</span><span class="nc">Root</span><span class="o">:</span><span class="nc">Def</span><span class="o">)</span><span class="bp">()</span><span class="o">:</span> <span class="nc">Record</span> <span class="k">with</span> <span class="k">type</span> <span class="n">root</span> <span class="o">:=</span> <span class="nn">Root</span><span class="p">.</span><span class="n">id</span>
<span class="k">module</span> <span class="nc">New_sum</span><span class="o">(</span><span class="nc">Root</span><span class="o">:</span><span class="nc">Def</span><span class="o">)</span><span class="bp">()</span><span class="o">:</span> <span class="nc">Sum</span> <span class="k">with</span> <span class="k">type</span> <span class="n">root</span> <span class="o">:=</span> <span class="nn">Root</span><span class="p">.</span><span class="n">id</span>
</pre></div>
