---
title: 'Reduced Memory Allocations with ocp-memprof '
description: In this blog post, we explain how ocp-memprof helped us identify a piece
  of code in Alt-Ergo that needed to be improved. Simply put, a function that merges
  two maps was performing a lot of unnecessary allocations, negatively impacting the
  garbage collector's activity. A simple patch allowed us to pr...
url: https://ocamlpro.com/blog/2015_05_18_reduced_memory_allocations_with_ocp_memprof
date: 2015-05-18T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>In this blog post, we explain how <code>ocp-memprof</code> helped us identify a piece of code in Alt-Ergo that needed to be improved. Simply put, a function that merges two maps was performing a lot of unnecessary allocations, negatively impacting the garbage collector's activity. A simple patch allowed us to prevent these allocations, and thus speed up Alt-Ergo's execution.</p>
<h3>The Story</h3>
<p>Il all started with a challenging example coming from an industrial user of <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a>, our SMT solver. It was proven by Alt-Ergo in approximately 70 seconds. This seemed abnormnally long and needed to be investigated. Unfortunately, all our tests with different options (number of triggers, case-split analysis, &hellip;) and different plugins (satML plugin, profiling plugin, fm-simplex plugin) of Alt-Ergo failed to improve the resolution time. We then profiled an execution using <code>ocp-memprof</code> to understand the memory behavior of this example.</p>
<h3>Profiling an Execution with <code>ocp-memprof</code></h3>
<p>As usual, profiling an OCaml application with <code>ocp-memprof</code> is very simple (see the <a href="https://memprof.typerex.org/free-version.php?action=documentation">user manual</a> for more details). We just compiled Alt-Ergo in the OPAM switch for <code>ocp-memprof</code> (version <code>4.01.0+ocp1</code>) and executed the following command:</p>
<pre><code class="language-shell-session">$ ocp-memprof -exec ./ae-4.01.0+ocp1-public-without-patch pb-many-GCs.why
</code></pre>
<p>The execution above triggers 612 garbage collections in about 114 seconds. The analysis of the generated dumps produces the evolution graph below. We notice on the graph that:</p>
<ul>
<li>we have approximately 10 MB of hash-tables allocated since the beginning of the execution, which is expected;
</li>
<li>the second most allocated data in the major heap are maps, and they keep growing during the execution of Alt-Ergo.
</li>
</ul>
<p>We are not able to precisely identify the allocation origins of the maps in this graph (maps are generic structures that are intensively used in Alt-Ergo). To investigate further, we wanted to know if some global value was abnormally retaining a lot of memory, or if some (non recursive-terminal) iterator was causing some trouble when applied on huge data structures. For that, we extended the analysis with the <code>--per-root</code> option to focus on the memory graph of the last dump. This is done by executing the following command, where 4242 is the PID of the process launched by <code>ocp-memprof --exec</code> in the previous command:</p>
<pre><code class="language-shell-session">$ ocp-memprof -load 4242 -per-root 611
</code></pre>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_before_mini.png" alt=""/>
<img src="https://ocamlpro.com/blog/assets/img/screenshot_per_root_before_mini.png" alt=""/></p>
<p>The per-root graph (above, on the right) gives more interesting information. When expanding the <code>stack</code> node and sorting the sixth column in decreasing order, we notice that:</p>
<ul>
<li>a bunch of these maps are still in the stack: the item <code>Map_at_192_offset_1</code> in the first column means that most of the memory is retained by the <code>fold</code> function, at line 192 of the <code>Map</code> module (resolution of stack frames is only available in the commercial version of <code>ocp-memprof</code>);
</li>
<li>the &quot;kind&quot; column corresponding to <code>Map_at_192_offset_1</code> gives better information. It provides the signature of the function passed to fold. This information is already provided by <a href="https://memprof.typerex.org/">the online version</a>.
</li>
</ul>
<pre><code class="language-cpp">Uf.Make(Uf.??Make.X).LX.t -&gt;;
Explanation.t -&gt;;
Explanation.t Map.Make(Uf.Make(Uf.??Make.X).LX).t -&gt;;
Explanation.t Map.Make(Uf.Make(Uf.??Make.X).LX).t
</code></pre>
<p>This information allows us to see the precise origin of the allocation: the map of module <code>LX</code> used in <a href="https://github.com/OCamlPro/alt-ergo/blob/master/src/theories/uf.ml">uf.ml</a>. Lucky us, there is only one <code>fold</code> function of <code>LX</code>'s maps in the <code>Uf</code> module with the same type.</p>
<h3>Optimizing the Code</h3>
<p>Thanks to the information provided by the <code>--per-root</code> option, we identified the code responsible for this behavior:</p>
<pre><code class="language-ocaml">(*** function extracted from module uf.ml ***)
module MapL = Map.Make(LX)

let update_neqs r1 r2 dep env =
let merge_disjoint_maps l1 ex1 mapl =
try
let ex2 = MapL.find l1 mapl in
let ex = Ex.union (Ex.union ex1 ex2) dep in
raise (Inconsistent (ex, cl_extract env))
with Not_found -&gt;;
MapL.add l1 (Ex.union ex1 dep) mapl
in
let nq_r1 = lookup_for_neqs env r1 in
let nq_r2 = lookup_for_neqs env r2 in
let mapl = MapL.fold merge_disjoint_maps nq_r1 nq_r2 in
MapX.add r2 mapl (MapX.add r1 mapl env.neqs)
</code></pre>
<p>Roughly speaking, the function above retrieves two maps <code>nq_r1</code> and <code>nq_r2</code> from <code>env</code>, and folds on the first one while providing the second map as an accumulator. The local function <code>merge_disjoint_maps</code> (passed to fold) raises <code>Exception.Inconsistent</code> if the original maps were not disjoint. Otherwise, it adds the current binding (after updating the corresponding value) to the accumulator. Finally, the result <code>mapl</code> of the fold is used to update the values of <code>r1</code> and <code>r2</code> in <code>env.neqs</code>.</p>
<p>After further debugging, we observed that one of the maps (<code>nq_r1</code> and <code>nq_r2</code>) is always empty in our situation. A straightforward fix consists in testing whether one of these two maps is empty. If it is the case, we simply return the other map. Here is the corresponding code:</p>
<pre><code class="language-ocaml">(*** first patch: testing if one of the maps is empty ***)
&hellip;
let mapl =
if MapL.is_empty nq_r1 then nq_r2
else
if MapL.is_empty nq_r2 then nq_r1
else MapL.fold_merge merge_disjoint_maps nq_r1 nq_r2
&hellip;
</code></pre>
<p>Of course, a more generic solution should not just test for emptiness, but should fold on the smallest map. In the second patch below, we used a slightly modified version of OCaml's maps that exports the <code>height</code> function (implemented in constant time). This way, we always fold on the smallest map while providing the biggest one as an accumulator.</p>
<pre><code class="language-ocaml">(*** second (better) patch : folding on the smallest map ***)
&hellip;
let small, big =
if MapL.height nq_r1 &gt; MapL.height nq_r2 then nq_r1, nq_r2
else nq_r2, nq_r1
in
let mapl = MapL.fold merge_disjoint_maps small big in
&hellip;
</code></pre>
<h3>Checking the Efficiency of our Patch</h3>
<p>Curious to see the result of the patch ? We regenerate the evolution and memory graphs of the patched code (fix 1), and we noticed:</p>
<ul>
<li>a better resolution time: from 69 seconds to 16 seconds;
</li>
<li>less garbage collection : from 53,000 minor collections to 19,000;
</li>
<li>a smaller memory footprint : from 26 MB to 24 MB;
</li>
</ul>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_after_mini.png" alt=""/>
<img src="https://ocamlpro.com/blog/assets/img/screenshot_per_root_after_mini.png" alt=""/></p>
<h3>Conclusion</h3>
<p>We show in this post that <code>ocp-memprof</code> can also be used to optimize your code, not only by decreasing memory usage, but by improving the speed of your application. The interactive graphs are online in our gallery of examples if you want to see and explore them (<a href="https://memprof.typerex.org/users/5a198a7f26b9b9d6f402276e16818a66/2015-05-15_15-32-21_48c9e783500e896444f998eb001fff4c_4242/">without the patch</a> and <a href="https://memprof.typerex.org/users/5a198a7f26b9b9d6f402276e16818a66/2015-05-15_16-13-22_4174baa4b9b5d8845653e04307b010a9_4530/">with the patch</a>).</p>
<table class="tableau2">
<tbody>
<tr>
<td></td>
<th>AE</th>
<th>AE + patch</th>
<th>Remarks</th>
</tr>
</tbody>
<tbody>
<tr>
<th>4.01.0</th>
<td>69.1 secs</td>
<td>16.4 secs</td>
<td>substantial improvement on the example</td>
</tr>
<tr>
<th>4.01.0+ocp1</th>
<td>76.3 secs</td>
<td>17.1 secs</td>
<td>when using the patched version of Alt-Ergo</td>
</tr>
<tr>
<th>dumps generation</th>
<td>114.3 secs (+49%)</td>
<td>17.6 secs (+2.8%)</td>
<td>(important) overhead when dumping<br/>
memory snapshots</td>
</tr>
<tr>
<th># dumps (major collections)</th>
<td>612 GCs</td>
<td>31 GCs</td>
<td>impressive GC activity without the patch</td>
</tr>
<tr>
<th>dumps analysis<br/>
(online ocp-memprof)</th>
<td>759 secs</td>
<td>24.3 secs</td>
<td></td>
</tr>
<tr>
<th>dumps analysis<br/>
(commercial ocp-memprof)</th>
<td>153 secs</td>
<td>3.7 secs</td>
<td>analysis with commercial ocp-memprof is<br/>
**~ x5 faster** than public version (above)</td>
</tr>
<tr>
<th>AE memory footprint</th>
<td>26 MB</td>
<td>24 MB</td>
<td>memory consumption is comparable</td>
</tr>
<tr>
<th>minor collections</th>
<td>53K</td>
<td>19K</td>
<td>fewer minor GCs thanks to the patch</td>
</tr>
</tbody>
</table>
Do not hesitate to use `ocp-memprof` on your applications. Of course, all feedback and suggestions are welcome, just [email](mailto:contact@ocamlpro.com) us !
<p>More information:</p>
<ul>
<li>Homepage: <a href="https://memprof.typerex.org/">https://memprof.typerex.org/</a>
</li>
<li>Gallery of examples: <a href="https://memprof.typerex.org/gallery.php">https://memprof.typerex.org/gallery.php</a>
</li>
<li>Free Version: <a href="https://memprof.typerex.org/free-version.php">https://memprof.typerex.org/free-version.php</a>
</li>
<li>Commercial Version: <a href="https://memprof.typerex.org/commercial-version.php">https://memprof.typerex.org/commercial-version.php</a>
</li>
<li>Report a Bug: <a href="https://memprof.typerex.org/report-a-bug.php">https://memprof.typerex.org/report-a-bug.php</a>
</li>
</ul>

