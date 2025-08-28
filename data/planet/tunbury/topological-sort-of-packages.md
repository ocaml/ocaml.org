---
title: Topological Sort of Packages
description: Given a list of packages and their dependencies, what order should those
  packages be installed in?
url: https://www.tunbury.org/2025/03/25/topological-sort/
date: 2025-03-25T00:00:00-00:00
preview_image: https://www.tunbury.org/images/dune-graph.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Given a list of packages and their dependencies, what order should those packages be installed in?</p>

<p>The above graph gives a simple example of the dependencies of the package <code class="language-plaintext highlighter-rouge">dune</code> nicely ordered right to left.</p>

<p>We might choose to model this in OCaml using a map with the package name as the key and a set of the dependent packages:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">PackageSet</span> <span class="o">=</span> <span class="nn">Set</span><span class="p">.</span><span class="nc">Make</span> <span class="p">(</span><span class="nc">String</span><span class="p">);;</span>
<span class="k">module</span> <span class="nc">PackageMap</span> <span class="o">=</span> <span class="nn">Map</span><span class="p">.</span><span class="nc">Make</span> <span class="p">(</span><span class="nc">String</span><span class="p">);;</span>
</code></pre></div></div>

<p>Thus, the <code class="language-plaintext highlighter-rouge">dune</code> example could be defined like this.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">dune</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.(</span><span class="n">empty</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"ocaml"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.(</span><span class="n">empty</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"ocaml-config"</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"ocaml-variants"</span><span class="p">))</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"ocaml-config"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.(</span><span class="n">empty</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"ocaml-variants"</span><span class="p">))</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"dune"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.(</span><span class="n">empty</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"ocaml"</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"base-unix.base"</span> <span class="o">|&gt;</span> <span class="n">add</span> <span class="s2">"base-threads.base"</span><span class="p">))</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"ocaml-variants"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.</span><span class="n">empty</span><span class="p">)</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"base-unix.base"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.</span><span class="n">empty</span><span class="p">)</span> <span class="o">|&gt;</span>
    <span class="n">add</span> <span class="s2">"base-threads.base"</span> <span class="p">(</span><span class="nn">PackageSet</span><span class="p">.</span><span class="n">empty</span><span class="p">)</span>
  <span class="p">);;</span>
</code></pre></div></div>

<p>We can create a topological sort by first choosing any package with an empty set of dependencies.  This package should then be removed from the map of packages and also removed as a dependency from any of the sets.  This can be written concisely in OCaml</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">rec</span> <span class="n">topological_sort</span> <span class="n">pkgs</span> <span class="o">=</span>
  <span class="k">match</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">is_empty</span> <span class="n">pkgs</span> <span class="k">with</span>
  <span class="o">|</span> <span class="bp">true</span> <span class="o">-&gt;</span> <span class="bp">[]</span>
  <span class="o">|</span> <span class="bp">false</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">installable</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="n">deps</span> <span class="o">-&gt;</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">is_empty</span> <span class="n">deps</span><span class="p">)</span> <span class="n">pkgs</span> <span class="k">in</span>
      <span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="k">assert</span> <span class="p">(</span><span class="n">not</span> <span class="p">(</span><span class="nn">PackageMap</span><span class="p">.</span><span class="n">is_empty</span> <span class="n">installable</span><span class="p">))</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">i</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">choose</span> <span class="n">installable</span> <span class="o">|&gt;</span> <span class="n">fst</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">pkgs</span> <span class="o">=</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">remove</span> <span class="n">i</span> <span class="n">pkgs</span> <span class="o">|&gt;</span> <span class="nn">PackageMap</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">deps</span> <span class="o">-&gt;</span> <span class="nn">PackageSet</span><span class="p">.</span><span class="n">remove</span> <span class="n">i</span> <span class="n">deps</span><span class="p">)</span> <span class="k">in</span>
      <span class="n">i</span> <span class="o">::</span> <span class="n">topological_sort</span> <span class="n">pkgs</span>
</code></pre></div></div>

<p>This gives us the correct installation order:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code># topological_sort dune;;
- : PackageMap.key list =
["base-threads.base"; "base-unix.base"; "ocaml-variants"; "ocaml-config"; "ocaml"; "dune"]
</code></pre></div></div>
