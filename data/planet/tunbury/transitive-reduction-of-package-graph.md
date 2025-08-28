---
title: Transitive Reduction of Package Graph
description: I have previously written about using a topological sort of a directed
  acyclic graph (DAG) of package dependencies to create an ordered list of installation
  operations. I now want to create a transitive reduction, giving a graph with the
  same vertices and the fewest number of edges possible.
url: https://www.tunbury.org/2025/06/23/transitive-reduction/
date: 2025-06-23T00:00:00-00:00
preview_image: https://www.tunbury.org/images/dune-graph.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I have previously written about using a <a href="https://www.tunbury.org/topological-sort/">topological sort</a> of a directed acyclic graph (DAG) of package dependencies to create an ordered list of installation operations. I now want to create a transitive reduction, giving a graph with the same vertices and the fewest number of edges possible.</p>

<p>This is interesting in opam, where a typical package is defined to depend upon both OCaml and Dune. However, Dune depends upon OCaml, so minimally the package only depends upon Dune. For opam, we would typically list both, as they may have version constraints.</p>

<div class="language-yaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="na">depends</span><span class="pi">:</span> <span class="pi">[</span>
  <span class="s2">"</span><span class="s">dune"</span> <span class="pi">{</span><span class="err">&gt;</span><span class="nv">= "3.17"</span><span class="pi">}</span>
  <span class="s2">"</span><span class="s">ocaml"</span>
<span class="pi">]</span>
</code></pre></div></div>

<p>Given a topologically sorted list of packages, we can fold over the list to build a map of the packages and dependencies. As each package is considered in turn, it must either have no dependencies or the dependent package must already be in the map.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">pkg_deps</span> <span class="n">solution</span> <span class="o">=</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">fold_left</span> <span class="p">(</span><span class="k">fun</span> <span class="n">map</span> <span class="n">pkg</span> <span class="o">-&gt;</span>
    <span class="k">let</span> <span class="n">deps_direct</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">find</span> <span class="n">pkg</span> <span class="n">solution</span> <span class="k">in</span>
    <span class="k">let</span> <span class="n">deps_plus_children</span> <span class="o">=</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">pkg</span> <span class="n">acc</span> <span class="o">-&gt;</span>
      <span class="nn">PackageSet</span><span class="p">.</span><span class="n">union</span> <span class="n">acc</span> <span class="p">(</span><span class="nn">PackageMap</span><span class="p">.</span><span class="n">find</span> <span class="n">pkg</span> <span class="n">map</span><span class="p">))</span> <span class="n">deps_direct</span> <span class="n">deps_direct</span> <span class="k">in</span>
    <span class="nn">PackageMap</span><span class="p">.</span><span class="n">add</span> <span class="n">pkg</span> <span class="n">deps_plus_children</span> <span class="n">map</span><span class="p">)</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">empty</span><span class="p">;;</span>
</code></pre></div></div>

<p>To generate the transitive reduction, take each set of dependencies for every package in the solution and remove those where the package is a member of the set of all the dependencies of any other directly descendant package.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">reduce</span> <span class="n">dependencies</span> <span class="o">=</span>
  <span class="nn">PackageMap</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">u</span> <span class="o">-&gt;</span>
    <span class="nn">PackageSet</span><span class="p">.</span><span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">v</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">others</span> <span class="o">=</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">remove</span> <span class="n">v</span> <span class="n">u</span> <span class="k">in</span>
      <span class="nn">PackageSet</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">o</span> <span class="n">acc</span> <span class="o">-&gt;</span>
        <span class="n">acc</span> <span class="o">||</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">mem</span> <span class="n">v</span> <span class="p">(</span><span class="nn">PackageMap</span><span class="p">.</span><span class="n">find</span> <span class="n">o</span> <span class="n">dependencies</span><span class="p">)</span>
      <span class="p">)</span> <span class="n">others</span> <span class="bp">false</span> <span class="o">|&gt;</span> <span class="n">not</span>
    <span class="p">)</span> <span class="n">u</span>
  <span class="p">);;</span>
</code></pre></div></div>

<p>Let’s create a quick print function and then test the code:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">print</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">p</span> <span class="n">deps</span> <span class="o">-&gt;</span>
  <span class="n">print_endline</span> <span class="p">(</span><span class="n">p</span> <span class="o">^</span> <span class="s2">": "</span> <span class="o">^</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.</span><span class="n">to_list</span> <span class="n">deps</span> <span class="o">|&gt;</span> <span class="nn">String</span><span class="p">.</span><span class="n">concat</span> <span class="s2">","</span><span class="p">))</span>
<span class="p">);;</span>
</code></pre></div></div>

<p>The original solution is</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span> <span class="n">print</span> <span class="n">dune</span><span class="p">;;</span>
<span class="n">base</span><span class="o">-</span><span class="n">threads</span><span class="o">.</span><span class="n">base</span><span class="o">:</span>
<span class="n">base</span><span class="o">-</span><span class="n">unix</span><span class="o">.</span><span class="n">base</span><span class="o">:</span>
<span class="n">dune</span><span class="o">:</span> <span class="n">base</span><span class="o">-</span><span class="n">threads</span><span class="o">.</span><span class="n">base</span><span class="o">,</span><span class="n">base</span><span class="o">-</span><span class="n">unix</span><span class="o">.</span><span class="n">base</span><span class="o">,</span><span class="n">ocaml</span>
<span class="n">ocaml</span><span class="o">:</span> <span class="n">ocaml</span><span class="o">-</span><span class="n">config</span><span class="o">,</span><span class="n">ocaml</span><span class="o">-</span><span class="n">variants</span>
<span class="n">ocaml</span><span class="o">-</span><span class="n">config</span><span class="o">:</span> <span class="n">ocaml</span><span class="o">-</span><span class="n">variants</span>
<span class="n">ocaml</span><span class="o">-</span><span class="n">variants</span><span class="o">:</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>

<p>And the reduced solution is:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span> <span class="k">let</span> <span class="n">dependencies</span> <span class="o">=</span> <span class="n">pkg_deps</span> <span class="n">dune</span> <span class="p">(</span><span class="n">topological_sort</span> <span class="n">dune</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">dependencies</span> <span class="o">:</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">t</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="o">#</span> <span class="n">print</span> <span class="p">(</span><span class="n">reduce</span> <span class="n">dependencies</span> <span class="n">dune</span><span class="p">);;</span>
<span class="n">base</span><span class="o">-</span><span class="n">threads</span><span class="o">.</span><span class="n">base</span><span class="o">:</span>
<span class="n">base</span><span class="o">-</span><span class="n">unix</span><span class="o">.</span><span class="n">base</span><span class="o">:</span>
<span class="n">dune</span><span class="o">:</span> <span class="n">base</span><span class="o">-</span><span class="n">threads</span><span class="o">.</span><span class="n">base</span><span class="o">,</span><span class="n">base</span><span class="o">-</span><span class="n">unix</span><span class="o">.</span><span class="n">base</span><span class="o">,</span><span class="n">ocaml</span>
<span class="n">ocaml</span><span class="o">:</span> <span class="n">ocaml</span><span class="o">-</span><span class="n">config</span>
<span class="n">ocaml</span><span class="o">-</span><span class="n">config</span><span class="o">:</span> <span class="n">ocaml</span><span class="o">-</span><span class="n">variants</span>
<span class="n">ocaml</span><span class="o">-</span><span class="n">variants</span><span class="o">:</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>

<p>This doesn’t look like much of a difference, but when applied to a larger graph, for example, 0install.2.18, the reduction is quite dramatic.</p>

<p>Initial graph</p>

<p><img src="https://www.tunbury.org/images/0install-graph.png" alt="opam installation graph for 0install"></p>

<p>Transitive reduction</p>

<p><img src="https://www.tunbury.org/images/0install-reduced-graph.png" alt="Transitive reduction of the opam installation graph for 0install"></p>
