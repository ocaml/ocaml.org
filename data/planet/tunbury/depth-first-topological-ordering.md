---
title: Depth-first topological ordering
description: "Over the last few months, I have written several posts on the package
  installation graphs specifically, Topological Sort of Packages, Installation order
  for opam packages and Transitive Reduction of Package Graph. In this post, I\u2019d
  like to cover a alternative ordering solution."
url: https://www.tunbury.org/2025/07/21/depth-first-topological-ordering/
date: 2025-07-21T00:00:00-00:00
preview_image: https://www.tunbury.org/images/dune-graph.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Over the last few months, I have written several posts on the package installation graphs specifically, <a href="https://www.tunbury.org/2025/03/25/topological-sort/">Topological Sort of Packages</a>, <a href="https://www.tunbury.org/2025/03/31/opam-post-deps/">Installation order for opam packages</a> and <a href="https://www.tunbury.org/2025/06/23/transitive-reduction/">Transitive Reduction of Package Graph</a>. In this post, I’d like to cover a alternative ordering solution.</p>

<p>Considering the graph above, first presented in the <a href="https://www.tunbury.org/2025/03/25/topological-sort/">Topological Sort of Packages</a>, which produces the installation order below.</p>

<ol>
  <li>base-threads.base</li>
  <li>base-unix.base</li>
  <li>ocaml-variants</li>
  <li>ocaml-config</li>
  <li>ocaml</li>
  <li>dune</li>
</ol>

<p>The code presented processed nodes when all their dependencies are satisfied (i.e., when their in-degree becomes 0). This typically means we process “leaf” nodes (nodes with no dependencies) first and then work our way up. However, it may make sense to process the leaf packages only when required rather than as soon as they can be processed. The easiest way to achieve this is to reverse the edges in the DAG, perform the topological sort, and then install the pages in reverse order.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">reverse_dag</span> <span class="p">(</span><span class="n">dag</span> <span class="o">:</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">t</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">t</span><span class="p">)</span> <span class="o">:</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">t</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">t</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">initial_reversed</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">package</span> <span class="n">_</span> <span class="n">acc</span> <span class="o">-&gt;</span>
    <span class="nn">PackageMap</span><span class="p">.</span><span class="n">add</span> <span class="n">package</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">empty</span> <span class="n">acc</span>
  <span class="p">)</span> <span class="n">dag</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">empty</span> <span class="k">in</span>
  <span class="nn">PackageMap</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">package</span> <span class="n">dependencies</span> <span class="n">reversed_dag</span> <span class="o">-&gt;</span>
    <span class="nn">PackageSet</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">dependency</span> <span class="n">acc</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">current_dependents</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">find</span> <span class="n">dependency</span> <span class="n">acc</span> <span class="k">in</span>
      <span class="nn">PackageMap</span><span class="p">.</span><span class="n">add</span> <span class="n">dependency</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.</span><span class="n">add</span> <span class="n">package</span> <span class="n">current_dependents</span><span class="p">)</span> <span class="n">acc</span>
    <span class="p">)</span> <span class="n">dependencies</span> <span class="n">reversed_dag</span>
  <span class="p">)</span> <span class="n">dag</span> <span class="n">initial_reversed</span>
</code></pre></div></div>

<p>With such a function, we can write this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">reverse_dag</span> <span class="n">dune</span> <span class="o">|&gt;</span> <span class="n">topological_sort</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">rev</span>
</code></pre></div></div>

<ol>
  <li>ocaml-variants</li>
  <li>ocaml-config</li>
  <li>ocaml</li>
  <li>base-unix.base</li>
  <li>base-threads.base</li>
  <li>dune</li>
</ol>

<p>Now, we don’t install base-unix and base-threads until they are actually required for the installation of dune.</p>
