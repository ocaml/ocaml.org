---
title: 'Better Inlining: Progress Report'
description: As announced some time ago, I am working on a new intermediate language
  within the OCaml compiler to improve its inlining strategy. After some time of bug
  squashing, I prepared a testable version of the patchset, available either on Github
  (branch flambda_experiments), or through OPAM, in the follow...
url: https://ocamlpro.com/blog/2013_07_11_better_inlining_progress_report
date: 2013-07-11T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Chambart\n  "
source:
---

<p>As announced <a href="https://ocamlpro.com/blog/optimisations-you-shouldnt-do">some time ago</a>, I am working on a new intermediate language within the OCaml compiler to improve its inlining strategy. After some time of bug squashing, I prepared a testable version of the patchset, available either on <a href="https://github.com/chambart/ocaml.git">Github</a> (branch <code>flambda_experiments</code>), or through OPAM, in the following repository:</p>
<pre><code class="language-shell-session">opam repo add inlining https://github.com/OCamlPro/opam-compilers-repository.git
opam switch flambda
opam install inlining-benchs
</code></pre>
<p>The series of patches is not ready for benchmarking against real applications, as no cross module information is propagated yet (this is more practical for development because it simplifies debugging a lot), but it already works quite well on single-file code. Some very simple benchmark examples are available in the <code>inlining-benchs</code> package.</p>
<p>The series of patches implements a set of 'reasonable' compilation passes, that do not try anything too complicated, but combined, generates quite efficient code.</p>
<h2>Current Status</h2>
<p>As said in the previous post, I decided to design a new intermediate language to implement better inlining heuristics in the compiler. This intermediate language, called <code>flambda</code>, lies between the <code>lambda</code> code and the <code>Clambda</code> code. It has an explicit representation of closures, making them easier to manipulate, and modules do not appear in it anymore (they have already been compiled to static structures).</p>
<p>I then started to implement new inlining heuristics as functions from the <code>lambda</code> code to the <code>flambda</code> code. The following features are already present:</p>
<ul>
<li>intra function value analysis
</li>
<li>variable rebinding
</li>
<li>dead code elimination (which needs purity analysis)
</li>
<li>known match / if branch elimination
</li>
</ul>
<p>In more detail, the chosen strategy is divided into two passes, which can be described by the following pseudo-code:</p>
<pre><code>if function is at toplevel
then if applied to at least one constant OR small enough
then inline
else if applied to at least one constant AND small enough
then inline
</code></pre>
<pre><code>if function is small enough
AND does not contain local function declarations
then inline
</code></pre>
<p>The first pass eliminates most functor applications and functions of the kind:</p>
<pre><code class="language-ocaml">let iter f x =
let rec aux x = ... f ... in
aux x
</code></pre>
<p>The second pass eliminates the same kind of functions as Ocaml 4.01, but being after the first pass, it can also inline functions revealed by inlining functors.</p>
<h2>Benchmarks</h2>
<p>I ran a few benchmarks to ensure that there were no obvious miscompilations (and there were, but they are now fixed). On benchmarks that were too carefully written there was not much gain, but I got interesting results on some examples: those illustrate quite well the improvements, and can be seen at <code>$(opam config var lib)/inlining-benchs</code> (binaries at <code>$(opam congfig var bin)/bench-*</code>).</p>
<h3>The Knuth-Bendix Benchmark (single-file)</h3>
<p>Performance gains against OCaml 4.01 are around 20%. The main difference is that exceptions are compiled to constants, hence not allocated when raised. In that particular example, this halves the allocations.</p>
<p>In general, constant exceptions can be compiled to constants when predefined (<code>Not_found</code>, <code>Failure</code>, ...). They cannot yet when user defined: to improve this a few things need to be changed in <code>translcore.ml</code> to annotate values created by exceptions.</p>
<h3>The Noiz Benchmark:</h3>
<p>Performance gains are around 30% against OCaml 4.01. This code uses a lot of higher order functions of the kind:</p>
<pre><code class="language-ocaml">let map_triple f (a,b,c) = (f a, f b, f c)
</code></pre>
<p>OCaml 4.01 can inline <code>map_triple</code> itself but then cannot inline the parameter <code>f</code>. Moreover, when writing:</p>
<pre><code class="language-ocaml">let (x,y,z) = map_triple f (1,2,3)
</code></pre>
<p>the tuples are not really used, and after inlining their allocations can be eliminated (thanks to rebinding and dead code elimination)</p>
<h3>The Set Example</h3>
<p>Performance gains are around 20% compared to OCaml 4.01. This example shows how inlining can help defunctorization: when inlining the <code>Set</code> functor, the provided comparison function can be inlined in <code>Set.add</code>, allowing direct calls everywhere.</p>
<h2>Known Bugs</h2>
<h3>Recursive Values</h3>
<p>A problem may arise in a rare case of recursive values where a field access can be considered to be a constant. Something that would look like (if it were allowed):</p>
<pre><code class="language-ocaml">type 'a v = { v : 'a }

let rec a = { v = b }
and b = (a.v, a.v)
</code></pre>
<p>I have a few solutions, but not sure yet which one is best. This probably won't appear in any normal test. This bug manifests through a segmentation fault (<code>cmmgen</code> fails to compile that recursive value reasonably).</p>
<h3>Pattern-Matching</h3>
<p>The new passes assume that every identifier is declared only once in a given module, but this assumption can be broken on some rare pattern matching cases. I will have to dig through <code>matching.ml</code> to add a substitution in these cases. (the only non hand-built occurence that I found is in <code>ocamlnet</code>)</p>
<h2>Known Mis-compilations</h2>
<ul>
<li>since there is no cross-module information at the moment, calls to functions from other modules are always slow.
</li>
<li>In some rare cases, there could be functions with more values in their closure, thus resulting in more allocations.
</li>
</ul>
<h2>What's next ?</h2>
<p>I would now like to add back cross-module information, and after a bit of cleanup the first series of patches should be ready to propose upstream.</p>

