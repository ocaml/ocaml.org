---
title: BAP Graph Library
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/graphlib
date: 2016-01-10T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>Although BAP is well-documented, its
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli">vast</a>
interface may be a little hard to navigate when looking for specific features.
This is the first in a series of posts which introduces some of BAP&rsquo;s features
by way of &ldquo;usage patterns&rdquo;. The intention is to provide you with small snippets
of code that encapsulate uses of BAP features.</p>

<p>At the bottom of this post you can find a template file and example source for
the binary used in the examples.</p>

<p>In this post we focus on BAP&rsquo;s Graphlib.</p>

<h2>Graphlib</h2>

<h4>Dot Output</h4>

<blockquote>
  <p>How do I output my program&rsquo;s callgraph in dot format?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">callgraph</span> <span class="o">=</span> <span class="nn">Program</span><span class="p">.</span><span class="n">to_graph</span> <span class="o">@@</span> <span class="nn">Project</span><span class="p">.</span><span class="n">program</span> <span class="n">project</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">string_of_node</span> <span class="n">n</span> <span class="o">=</span>
  <span class="n">sprintf</span> <span class="s2">&quot;%S&quot;</span> <span class="o">@@</span> <span class="nn">Tid</span><span class="p">.</span><span class="n">name</span> <span class="o">@@</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Callgraph</span><span class="p">.</span><span class="nn">Node</span><span class="p">.</span><span class="n">label</span> <span class="n">n</span> <span class="k">in</span>
<span class="nn">Graphlib</span><span class="p">.</span><span class="n">to_dot</span> <span class="p">(</span><span class="k">module</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nc">Callgraph</span><span class="p">)</span>
  <span class="o">~</span><span class="n">string_of_node</span> <span class="o">~</span><span class="n">filename</span><span class="o">:</span><span class="s2">&quot;callgraph.dot&quot;</span> <span class="n">callgraph</span><span class="p">;</span>
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>BAP&rsquo;s graphlib module has a dedicated submodule for
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4388">callgraphs</a>:
<code class="language-plaintext highlighter-rouge">Graphlib.Callgraph</code></li>
</ul>

<p>The output file <code class="language-plaintext highlighter-rouge">callgraph.dot</code> for the example binary appears as follows:</p>

<p>&lt;img style=&rdquo;display: block; margin-left: auto; margin-right:auto&rdquo;
src=/assets/graphlib/callgraph.png width=300 height=300/&gt;</p>

<hr/>

<blockquote>
  <p>How do I output the CFG of of &ldquo;main&rdquo; in dot format?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">program</span> <span class="o">=</span> <span class="nn">Project</span><span class="p">.</span><span class="n">program</span> <span class="n">project</span> <span class="k">in</span>

<span class="k">let</span> <span class="n">left_justify</span> <span class="o">=</span>
  <span class="nn">String</span><span class="p">.</span><span class="n">concat_map</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">c</span> <span class="o">-&gt;</span>
      <span class="k">if</span> <span class="n">c</span> <span class="o">=</span> <span class="sc">'\n'</span> <span class="k">then</span> <span class="s2">&quot;</span><span class="se">\\</span><span class="s2">l&quot;</span> <span class="k">else</span> <span class="nn">Char</span><span class="p">.</span><span class="n">to_string</span> <span class="n">c</span><span class="p">)</span> <span class="k">in</span>

<span class="p">(</span><span class="k">match</span> <span class="nn">Term</span><span class="p">.</span><span class="n">find</span> <span class="n">sub_t</span> <span class="n">program</span> <span class="nn">Tid</span><span class="p">.(</span><span class="o">!</span><span class="s2">&quot;@main&quot;</span><span class="p">)</span> <span class="k">with</span>
 <span class="o">|</span> <span class="nc">Some</span> <span class="n">main_sub</span> <span class="o">-&gt;</span>
   <span class="k">let</span> <span class="n">node_attrs</span> <span class="n">_</span> <span class="o">=</span>
     <span class="p">[</span><span class="nt">`Shape</span> <span class="nt">`Box</span><span class="p">]</span> <span class="k">in</span>
   <span class="k">let</span> <span class="n">string_of_node</span> <span class="n">node</span> <span class="o">=</span> <span class="n">sprintf</span> <span class="s2">&quot;</span><span class="se">\&quot;\\</span><span class="s2">%s</span><span class="se">\&quot;</span><span class="s2">&quot;</span>
     <span class="o">@@</span> <span class="nn">Blk</span><span class="p">.</span><span class="n">to_string</span> <span class="o">@@</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Ir</span><span class="p">.</span><span class="nn">Node</span><span class="p">.</span><span class="n">label</span> <span class="n">node</span> <span class="o">|&gt;</span> <span class="n">left_justify</span> <span class="k">in</span>
   <span class="nn">Graphlib</span><span class="p">.</span><span class="n">to_dot</span> <span class="p">(</span><span class="k">module</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nc">Ir</span><span class="p">)</span> <span class="o">~</span><span class="n">string_of_node</span> <span class="o">~</span><span class="n">node_attrs</span>
     <span class="o">~</span><span class="n">filename</span><span class="o">:</span><span class="s2">&quot;main.dot&quot;</span> <span class="o">@@</span> <span class="nn">Sub</span><span class="p">.</span><span class="n">to_cfg</span> <span class="n">main_sub</span>
 <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="p">);</span>
</code></pre></div></div>

<p>The ouptut file <code class="language-plaintext highlighter-rouge">main.dot</code> appears as follows:</p>

<p>&lt;img style=&rdquo;display: block; margin-left: auto; margin-right:auto&rdquo;
src=/assets/graphlib/main.png width=500 height=500/&gt;</p>

<p>Notes:</p>

<ul>
  <li>
    <p><code class="language-plaintext highlighter-rouge">Tid.(!&quot;@main&quot;)</code> looks for a function called <code class="language-plaintext highlighter-rouge">main</code>. Your program needs to be
compiled with debugging symbols, or you need to use the <code class="language-plaintext highlighter-rouge">--use-ida</code> option if
you want to use this notation. Alternatively, use <code class="language-plaintext highlighter-rouge">Tid.(!&quot;@sub_400440&quot;)</code> where
<code class="language-plaintext highlighter-rouge">400440</code> corresponds to the address (in hex) of your function (for example,
entry point).</p>
  </li>
  <li>
    <p>Here we use <code class="language-plaintext highlighter-rouge">Sub.to_cfg</code>, which returns a graph corresponding to
<code class="language-plaintext highlighter-rouge">Graphlib.Ir</code>. Nodes of <code class="language-plaintext highlighter-rouge">Graphlib.Ir</code> are <code class="language-plaintext highlighter-rouge">blk</code>s.</p>
  </li>
</ul>

<hr/>

<blockquote>
  <p>What if I don&rsquo;t want all of the IR in my CFG, but rather nodes and edges labeled with identifiers?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">program</span> <span class="o">=</span> <span class="nn">Project</span><span class="p">.</span><span class="n">program</span> <span class="n">project</span> <span class="k">in</span>
<span class="nn">Option</span><span class="p">.(</span><span class="nn">Term</span><span class="p">.</span><span class="n">find</span> <span class="n">sub_t</span> <span class="n">program</span> <span class="nn">Tid</span><span class="p">.(</span><span class="o">!</span><span class="s2">&quot;@main&quot;</span><span class="p">)</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">main_sub</span> <span class="o">-&gt;</span>
        <span class="k">let</span> <span class="n">string_of_node</span> <span class="n">n</span> <span class="o">=</span> <span class="n">sprintf</span> <span class="s2">&quot;</span><span class="se">\&quot;\\</span><span class="s2">%s</span><span class="se">\&quot;</span><span class="s2">&quot;</span>
            <span class="o">@@</span> <span class="nn">Tid</span><span class="p">.</span><span class="n">name</span> <span class="o">@@</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Tid</span><span class="p">.</span><span class="nn">Tid</span><span class="p">.</span><span class="nn">Node</span><span class="p">.</span><span class="n">label</span> <span class="n">n</span> <span class="k">in</span>
        <span class="k">let</span> <span class="n">string_of_edge</span> <span class="n">e</span> <span class="o">=</span> <span class="nn">Tid</span><span class="p">.</span><span class="n">name</span> <span class="o">@@</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Tid</span><span class="p">.</span><span class="nn">Tid</span><span class="p">.</span><span class="nn">Edge</span><span class="p">.</span><span class="n">label</span> <span class="n">e</span> <span class="k">in</span>
            <span class="nn">Graphlib</span><span class="p">.</span><span class="n">to_dot</span> <span class="o">~</span><span class="n">string_of_node</span> <span class="o">~</span><span class="n">string_of_edge</span>
              <span class="o">~</span><span class="n">filename</span><span class="o">:</span><span class="s2">&quot;main_with_tids.dot&quot;</span> <span class="p">(</span><span class="k">module</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Tid</span><span class="p">.</span><span class="nc">Tid</span><span class="p">)</span> <span class="o">@@</span>
          <span class="nn">Sub</span><span class="p">.</span><span class="n">to_graph</span> <span class="n">main_sub</span><span class="p">;</span> <span class="nc">Some</span> <span class="n">main_sub</span><span class="p">)</span>
<span class="o">|&gt;</span> <span class="nn">Pervasives</span><span class="p">.</span><span class="n">ignore</span><span class="p">;</span>
</code></pre></div></div>

<p>&lt;img style=&rdquo;display: block; margin-left: auto; margin-right:auto&rdquo;
src=/assets/graphlib/tid_only_graph.png width=250 height=250/&gt;</p>

<p>Notes:</p>

<ul>
  <li>Here we use <code class="language-plaintext highlighter-rouge">Sub.to_graph</code>, and the appropriate types for labels: tid, as
opposed to blk in the previous example. See <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L6867">bap documentation</a>
for why you might want this instead.</li>
</ul>

<hr/>

<h4>Strongly Connected Components</h4>

<blockquote>
  <p>How do I find strongly connected components in my program?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">callgraph</span> <span class="o">=</span> <span class="nn">Program</span><span class="p">.</span><span class="n">to_graph</span> <span class="o">@@</span> <span class="nn">Project</span><span class="p">.</span><span class="n">program</span> <span class="n">project</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">scc_partition</span> <span class="o">=</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="n">strong_components</span>
    <span class="p">(</span><span class="k">module</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nc">Callgraph</span><span class="p">)</span> <span class="n">callgraph</span> <span class="k">in</span>
<span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;%d components found:</span><span class="se">\n</span><span class="s2">&quot;</span>
<span class="o">@@</span> <span class="nn">Partition</span><span class="p">.</span><span class="n">number_of_groups</span> <span class="n">scc_partition</span><span class="p">;</span>

<span class="nn">Seq</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="nn">Partition</span><span class="p">.</span><span class="n">groups</span> <span class="n">scc_partition</span><span class="p">)</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">group</span> <span class="o">-&gt;</span>
    <span class="nn">Group</span><span class="p">.</span><span class="n">enum</span> <span class="n">group</span> <span class="o">|&gt;</span> <span class="nn">Seq</span><span class="p">.</span><span class="n">iter</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span>
        <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;%s &quot;</span> <span class="o">@@</span> <span class="nn">Tid</span><span class="p">.</span><span class="n">to_string</span> <span class="n">x</span><span class="p">);</span>
    <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;</span><span class="se">\n</span><span class="s2">&quot;</span><span class="p">);</span>
<span class="nc">Some</span> <span class="n">scc_partition</span>
<span class="o">|&gt;</span> <span class="nn">Pervasives</span><span class="p">.</span><span class="n">ignore</span><span class="p">;</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>7 components found:
@sub_4003e0
@sub_400410
@sub_400430
@h @g
@f
@main
@__libc_csu_init
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>Notice that the two functions <code class="language-plaintext highlighter-rouge">@h</code> and <code class="language-plaintext highlighter-rouge">@g</code> are printed on the same line,
indicating that they belong to the same group (i.e., they form a strongly
connected component).</li>
</ul>

<hr/>

<h4>Graph Construction</h4>

<blockquote>
  <p>How can I construct arbitrary graphs?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">module</span> <span class="nc">G</span> <span class="o">=</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="nn">Int</span><span class="p">.</span><span class="nc">Unit</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">g</span> <span class="o">=</span> <span class="nn">Graphlib</span><span class="p">.</span><span class="n">create</span> <span class="p">(</span><span class="k">module</span> <span class="nc">G</span><span class="p">)</span> <span class="o">~</span><span class="n">edges</span><span class="o">:</span><span class="p">[</span><span class="mi">0</span><span class="o">,</span><span class="mi">1</span><span class="o">,</span><span class="bp">()</span><span class="p">;</span><span class="mi">1</span><span class="o">,</span><span class="mi">1</span><span class="o">,</span><span class="bp">()</span><span class="p">]</span> <span class="bp">()</span> <span class="k">in</span>
<span class="nn">Graphlib</span><span class="p">.</span><span class="n">to_dot</span> <span class="p">(</span><span class="k">module</span> <span class="nc">G</span><span class="p">)</span> <span class="o">~</span><span class="n">filename</span><span class="o">:</span><span class="s2">&quot;graph.dot&quot;</span> <span class="n">g</span><span class="p">;</span>
</code></pre></div></div>

<p>&lt;img style=&rdquo;display: block; margin-left: auto; margin-right:auto&rdquo;
src=/assets/graphlib/simple_graph.png width=100 height=100/&gt;</p>

<p>Notes:</p>

<ul>
  <li>BAP&rsquo;s Graphlib is in fact
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L209">generic</a>,
and graphs over arbitrary types may be constructed.</li>
</ul>

<hr/>

<h2>Wrap-up</h2>

<p>This really just scratches the surface of Graphlib. There are a number of other
interesting functions in the library that can be referred to. Notable ones
include:</p>

<ul>
  <li><a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4001">dominators</a></li>
  <li><a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4029">shortest_path</a></li>
  <li><a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4038">is_reachable</a></li>
</ul>

<h2>Template</h2>

<p>All of the snippets above may be substituted into the following template.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">use</span> <span class="s2">&quot;topfind&quot;</span><span class="p">;;</span>
<span class="o">#</span><span class="n">require</span> <span class="s2">&quot;bap.top&quot;</span><span class="p">;;</span>
<span class="k">open</span> <span class="nn">Core_kernel</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nn">Bap</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">open</span> <span class="nc">Or_error</span>

<span class="k">let</span> <span class="n">main</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Project</span><span class="p">.</span><span class="n">from_file</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">argv</span><span class="o">.</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">project</span> <span class="o">-&gt;</span>

    <span class="c">(* Place snippet here *)</span>

  <span class="n">return</span> <span class="bp">()</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="k">try</span> <span class="n">main</span> <span class="bp">()</span>
      <span class="o">|&gt;</span> <span class="k">function</span>
      <span class="o">|</span> <span class="nc">Ok</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">()</span>
      <span class="o">|</span> <span class="nc">Error</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;BAP error: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="o">@@</span> <span class="nn">Error</span><span class="p">.</span><span class="n">to_string_hum</span> <span class="n">e</span>
  <span class="k">with</span>
  <span class="o">|</span> <span class="nc">Invalid_argument</span> <span class="n">_</span> <span class="o">-&gt;</span>
    <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;Please specify a file on the command line</span><span class="se">\n</span><span class="s2">&quot;</span>
</code></pre></div></div>

<p>It can then be run on the commandline as follows:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>ocaml template.ml example
</code></pre></div></div>

<p>For the example binary <code class="language-plaintext highlighter-rouge">example</code>, you may compile the following:</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="cp">#include &lt;stdio.h&gt;
</span>
<span class="kt">int</span> <span class="nf">g</span><span class="p">(</span><span class="kt">int</span> <span class="n">i</span><span class="p">);</span>

<span class="kt">int</span> <span class="nf">h</span><span class="p">(</span><span class="kt">int</span> <span class="n">i</span><span class="p">)</span> <span class="p">{</span>
  <span class="n">i</span> <span class="o">+=</span> <span class="mi">1</span><span class="p">;</span>
  <span class="k">return</span> <span class="n">g</span><span class="p">(</span><span class="n">i</span><span class="p">);</span>
<span class="p">}</span>

<span class="kt">int</span> <span class="nf">g</span><span class="p">(</span><span class="kt">int</span> <span class="n">i</span><span class="p">)</span> <span class="p">{</span>
  <span class="k">if</span> <span class="p">(</span><span class="n">i</span> <span class="o">&gt;</span> <span class="mi">10</span><span class="p">)</span> <span class="p">{</span>
    <span class="k">return</span> <span class="n">i</span><span class="p">;</span>
  <span class="p">}</span>
  <span class="n">i</span> <span class="o">+=</span> <span class="mi">1</span><span class="p">;</span>
  <span class="k">return</span> <span class="n">h</span><span class="p">(</span><span class="n">i</span><span class="p">);</span>
<span class="p">}</span>

<span class="kt">int</span> <span class="nf">f</span><span class="p">(</span><span class="kt">int</span> <span class="n">i</span><span class="p">)</span> <span class="p">{</span>
  <span class="n">i</span> <span class="o">+=</span> <span class="mi">1</span><span class="p">;</span>
  <span class="k">return</span> <span class="n">g</span><span class="p">(</span><span class="n">i</span><span class="p">);</span>
<span class="p">}</span>

<span class="kt">int</span> <span class="nf">main</span><span class="p">()</span> <span class="p">{</span>
  <span class="kt">int</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span>
  <span class="kt">int</span> <span class="n">result</span><span class="p">;</span>

  <span class="n">result</span> <span class="o">=</span> <span class="n">f</span><span class="p">(</span><span class="n">i</span><span class="p">);</span>
  <span class="n">printf</span><span class="p">(</span><span class="s">&quot;Res: %d</span><span class="se">\n</span><span class="s">&quot;</span><span class="p">,</span> <span class="n">result</span><span class="p">);</span>
<span class="p">}</span>
</code></pre></div></div>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>gcc -o example example.c
</code></pre></div></div>


