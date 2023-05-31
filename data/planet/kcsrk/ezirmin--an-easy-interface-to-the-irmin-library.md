---
title: 'Ezirmin : An easy interface to the Irmin library'
description:
url: https://kcsrk.info/ocaml/irmin/crdt/2017/02/15/an-easy-interface-to-irmin-library/
date: 2017-02-15T13:46:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p><a href="https://github.com/kayceesrk/ezirmin">Ezirmin</a> is an easy interface over the
<a href="https://github.com/mirage/irmin">Irmin</a>, a library database for building
persistent mergeable data structures based on the principles of Git. In this
post, I will primarily discuss the Ezirmin library, but also discuss some of the
finer technical details of mergeable data types implemented over Irmin.</p>



<h1>Contents</h1>

<ul>
  <li><a href="https://kcsrk.info/atom-ocaml.xml#contents">Contents</a></li>
  <li><a href="https://kcsrk.info/atom-ocaml.xml#irmin-and-ezirmin">Irmin and Ezirmin</a></li>
  <li><a href="https://kcsrk.info/atom-ocaml.xml#quick-tour-of-ezirmin">Quick tour of Ezirmin</a>    <ul>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#merge-semantics">Merge semantics</a></li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#working-with-history">Working with history</a></li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#reacting-to-changes">Reacting to changes</a></li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#interaction-with-remotes">Interaction with remotes</a></li>
    </ul>
  </li>
  <li><a href="https://kcsrk.info/atom-ocaml.xml#mergeable-persistent-data-types">Mergeable persistent data types</a>    <ul>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#irmin-architecture">Irmin Architecture</a></li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#user-defined-merges">User-defined merges</a></li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#mergeable-counters">Mergeable Counters</a>        <ul>
          <li><a href="https://kcsrk.info/atom-ocaml.xml#theory-of-merges">Theory of merges</a></li>
          <li><a href="https://kcsrk.info/atom-ocaml.xml#recursive-merges">Recursive merges</a></li>
        </ul>
      </li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#mergeable-logs">Mergeable logs</a>        <ul>
          <li><a href="https://kcsrk.info/atom-ocaml.xml#efficient-mergeable-logs">Efficient mergeable logs</a></li>
        </ul>
      </li>
      <li><a href="https://kcsrk.info/atom-ocaml.xml#mergeable-ropes">Mergeable ropes</a></li>
    </ul>
  </li>
  <li><a href="https://kcsrk.info/atom-ocaml.xml#next-steps">Next steps</a></li>
</ul>

<h1>Irmin and Ezirmin</h1>

<p>Irmin is a library for manipulating persistent mergeable data structures
(including CRDTs) that follows the same principles of Git. In particular, it has
built-in support for snapshots, branches and reverts, and can compile to
multiple backends. Being written in pure OCaml, apps written using Irmin, as
well as running natively, can run in the browsers or be compiled to Unikernels.
A good introduction to the capabilities of Irmin can be found in the Irmin
<a href="https://github.com/mirage/irmin/blob/master/README.md">README</a> file.</p>

<p>One of the downsides to being extremely configurable is that the Irmin library
is not beginner friendly. In particular, the library tends to be rather functor
heavy, and even <a href="https://github.com/mirage/irmin/blob/master/README.md#usage">simple
uses</a> require
multiple functor instantiations<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:irmin" class="footnote" rel="footnote">1</a></sup>. The primary goal of Ezirmin is to
provide a defuntorized interface to Irmin, specialized to useful defaults.
However, as I&rsquo;ve continued to build Ezirmin, it has come to include a collection
of useful mergeable data types including counters, queues, ropes, logs, etc. I
will spend some time describing some of the interesting aspects of these data
structures.</p>

<h1>Quick tour of Ezirmin</h1>

<p>You can install the latest version of Ezirmin by</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>git clone https://github.com/kayceesrk/ezirmin
<span class="nv">$ </span><span class="nb">cd </span>ezirmin
<span class="nv">$ </span>opam pin add ezirmin <span class="nb">.</span>
</code></pre></div></div>

<p>Stable versions are also available through OPAM:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>opam <span class="nb">install </span>ezirmin
</code></pre></div></div>

<p>Let&rsquo;s fire up <code class="language-plaintext highlighter-rouge">utop</code> and get started:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">$</span> <span class="n">utop</span>
<span class="n">utop</span> <span class="o">#</span> <span class="o">#</span><span class="n">require</span> <span class="s2">&quot;ezirmin&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Infix</span><span class="p">;;</span>
</code></pre></div></div>

<p>We&rsquo;ll create a mergeable queue of strings using the Git file system backend
rooted at <code class="language-plaintext highlighter-rouge">/tmp/ezirminq</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Ezirmin</span><span class="p">.</span><span class="nc">FS_queue</span><span class="p">(</span><span class="nn">Tc</span><span class="p">.</span><span class="nc">String</span><span class="p">);;</span> <span class="c">(* Mergeable queue of strings *)</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nc">M</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="n">init</span> <span class="o">~</span><span class="n">root</span><span class="o">:</span><span class="s2">&quot;/tmp/ezirminq&quot;</span> <span class="o">~</span><span class="n">bare</span><span class="o">:</span><span class="bp">true</span> <span class="bp">()</span> <span class="o">&gt;&gt;=</span> <span class="n">master</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">m</span> <span class="o">:</span> <span class="n">branch</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
</code></pre></div></div>

<p><code class="language-plaintext highlighter-rouge">m</code> is the master branch of the repository. Ezirmin exposes a key value store,
where keys are hierarchical paths and values are whatever data types is stored in
the repo. In this case, the data type is a queue. Let&rsquo;s push some elements into
the queue:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">push</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="s2">&quot;buy milk&quot;</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">push</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;work&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="s2">&quot;publish ezirmin&quot;</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">];;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;buy milk&quot;</span><span class="p">]</span>
</code></pre></div></div>

<p>The updates to the queue is saved in the Git repository at <code class="language-plaintext highlighter-rouge">/tmp/ezirminq</code>. In
another terminal,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">$</span> <span class="n">utop</span>
<span class="n">utop</span> <span class="o">#</span> <span class="o">#</span><span class="n">require</span> <span class="s2">&quot;ezirmin&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Ezirmin</span><span class="p">.</span><span class="nc">FS_queue</span><span class="p">(</span><span class="nn">Tc</span><span class="p">.</span><span class="nc">String</span><span class="p">);;</span> <span class="c">(* Mergeable queue of strings *)</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nc">M</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Infix</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="n">init</span> <span class="o">~</span><span class="n">root</span><span class="o">:</span><span class="s2">&quot;/tmp/ezirminq&quot;</span> <span class="o">~</span><span class="n">bare</span><span class="o">:</span><span class="bp">true</span> <span class="bp">()</span> <span class="o">&gt;&gt;=</span> <span class="n">master</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">m</span> <span class="o">:</span> <span class="n">branch</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">pop</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">];;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="n">option</span> <span class="o">=</span> <span class="nc">Some</span> <span class="s2">&quot;buy milk&quot;</span>
</code></pre></div></div>

<p>For concurrency control, use branches. In the first terminal,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">wip</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="o">@@</span> <span class="n">clone_force</span> <span class="n">m</span> <span class="s2">&quot;wip&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">push</span> <span class="n">wip</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="s2">&quot;walk dog&quot;</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">push</span> <span class="n">wip</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="s2">&quot;take out trash&quot;</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>

<p>The changes are not visible until the branches are merged.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">];;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="bp">[]</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">merge</span> <span class="n">wip</span> <span class="o">~</span><span class="n">into</span><span class="o">:</span><span class="n">m</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">];;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;walk dog&quot;</span><span class="p">;</span> <span class="s2">&quot;take out trash&quot;</span><span class="p">]</span>
</code></pre></div></div>

<h2>Merge semantics</h2>

<p>What should be the semantics of popping the queue at <code class="language-plaintext highlighter-rouge">home/todo</code> concurrently
at the master branch and wip branch? It is reasonable to ascribe exactly once
semantics to pop such that popping the same element on both branches and
subsequently merging the queues would lead to a merge conflict. However, a more
useful semantics is where we relax this invariant and allow elements to be
popped more than once on different branches. In particular, the merge operation
on the queue ensures that:</p>

<ol>
  <li>An element popped in one of the branches is not present after the merge.</li>
  <li>Merges respect the program order in each of the branches.</li>
  <li>Merges converge.</li>
</ol>

<p>Hence, our merge queues are CRDTs.</p>

<h2>Working with history</h2>

<p>Irmin is fully compatible with Git. Hence, we can explore the history of the
operations using the git command line. In another terminal:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span><span class="nb">cd</span> /tmp/ezirminq
<span class="nv">$ </span>git lg
<span class="k">*</span> e75da48 - <span class="o">(</span>4 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126] <span class="o">(</span>HEAD -&gt; master, wip<span class="o">)</span>
<span class="k">*</span> 40ed32d - <span class="o">(</span>4 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
<span class="k">*</span> 6a56fb0 - <span class="o">(</span>5 minutes ago<span class="o">)</span> pop - Irmin xxxx.cam.ac.uk.[73221]
<span class="k">*</span> 6a2cc9a - <span class="o">(</span>6 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
<span class="k">*</span> 55f7fc8 - <span class="o">(</span>6 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
</code></pre></div></div>

<p>The Git log shows that there have been 4 pushes and 1 pop in this repository.
In addition to the data structures being mergeable, they are also persistent.
In particular, every object stored in Irmin has complete provenance. You can
also manipulate history using the Git command line.</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>git reset HEAD~2 <span class="nt">--hard</span>
<span class="nv">$ </span>git lg
<span class="k">*</span> e75da48 - <span class="o">(</span>8 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126] <span class="o">(</span>wip<span class="o">)</span>
<span class="k">*</span> 40ed32d - <span class="o">(</span>9 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
<span class="k">*</span> 6a56fb0 - <span class="o">(</span>9 minutes ago<span class="o">)</span> pop - Irmin xxxx.cam.ac.uk.[73221] <span class="o">(</span>HEAD -&gt; master<span class="o">)</span>
<span class="k">*</span> 6a2cc9a - <span class="o">(</span>10 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
<span class="k">*</span> 55f7fc8 - <span class="o">(</span>10 minutes ago<span class="o">)</span> push - Irmin xxxx.cam.ac.uk.[73126]
</code></pre></div></div>

<p>Back in the first terminal:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">];;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="bp">[]</span>
</code></pre></div></div>

<p>Since we rolled back the master to before the pushes were merged, we see an
empty list. Ezirmin also provides APIs for working with history
programmatically.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">run</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">repo</span> <span class="o">=</span> <span class="n">run</span> <span class="o">@@</span> <span class="n">init</span> <span class="bp">()</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">path</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;Books&quot;</span><span class="p">;</span> <span class="s2">&quot;Ovine Supply Logistics&quot;</span><span class="p">];;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">push_msg</span> <span class="o">=</span> <span class="n">push</span> <span class="n">m</span> <span class="o">~</span><span class="n">path</span><span class="p">;;</span>

<span class="n">utop</span> <span class="o">#</span> <span class="k">begin</span>
  <span class="n">push_msg</span> <span class="s2">&quot;Baa&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
  <span class="n">push_msg</span> <span class="s2">&quot;Baa&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
  <span class="n">push_msg</span> <span class="s2">&quot;Black&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
  <span class="n">push_msg</span> <span class="s2">&quot;Camel&quot;</span>
<span class="k">end</span><span class="p">;;</span>

<span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="n">path</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Black&quot;</span><span class="p">;</span> <span class="s2">&quot;Camel&quot;</span><span class="p">]</span>
</code></pre></div></div>

<p>Clearly this is wrong. Let&rsquo;s fix this by reverting to earlier version:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">m_1</span><span class="o">::_</span> <span class="o">=</span> <span class="n">run</span> <span class="o">@@</span> <span class="n">predecessors</span> <span class="n">repo</span> <span class="n">m</span><span class="p">;;</span> <span class="c">(** HEAD~1 version *)</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m_1</span> <span class="n">path</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Black&quot;</span><span class="p">]</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">update_branch</span> <span class="n">m</span> <span class="o">~</span><span class="n">set</span><span class="o">:</span><span class="n">m_1</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">to_list</span> <span class="n">m</span> <span class="n">path</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Black&quot;</span><span class="p">]</span>
</code></pre></div></div>

<p>Now that we&rsquo;ve undone the error, we can do the right thing.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">push_msg</span> <span class="s2">&quot;Sheep&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">run</span> <span class="o">@@</span> <span class="n">to_list</span> <span class="n">m</span> <span class="n">path</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Baa&quot;</span><span class="p">;</span> <span class="s2">&quot;Black&quot;</span><span class="p">;</span> <span class="s2">&quot;Sheep&quot;</span><span class="p">]</span>
</code></pre></div></div>

<h2>Reacting to changes</h2>

<p>Ezirmin supports watching a particular key for updates and invoking a callback
function when there is one.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">cb</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="p">(</span><span class="n">print_endline</span> <span class="s2">&quot;callback: update to home/todo&quot;</span><span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">watch</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="n">cb</span>
</code></pre></div></div>

<p>The code above installs a listener <code class="language-plaintext highlighter-rouge">cb</code> on the queue at <code class="language-plaintext highlighter-rouge">home/todo</code>, which is
run every time the queue is updated. This includes local <code class="language-plaintext highlighter-rouge">push</code> and <code class="language-plaintext highlighter-rouge">pop</code>
operations as well as updates due to merges.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">push</span> <span class="n">m</span> <span class="p">[</span><span class="s2">&quot;home&quot;</span><span class="p">;</span> <span class="s2">&quot;todo&quot;</span><span class="p">]</span> <span class="s2">&quot;hang pictures&quot;</span><span class="p">;;</span>
<span class="n">callback</span><span class="o">:</span> <span class="n">update</span> <span class="k">to</span> <span class="n">home</span><span class="o">/</span><span class="n">todo</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>
<h2>Interaction with remotes</h2>

<p>Unlike distributed data stores, where the updates are disseminated
transparently between the replicas, Ezirmin provides you the necessary building
blocks for building your own dissemination protocol. As with Git, Ezirmin
exposes the functionality to <code class="language-plaintext highlighter-rouge">push</code><sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:push" class="footnote" rel="footnote">2</a></sup> and <code class="language-plaintext highlighter-rouge">pull</code> changes from remotes.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">show_module</span> <span class="nc">Sync</span><span class="p">;;</span>
<span class="k">module</span> <span class="nc">Sync</span> <span class="o">:</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">remote</span>
  <span class="k">val</span> <span class="n">remote_uri</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="n">remote</span>
  <span class="k">val</span> <span class="n">pull</span> <span class="o">:</span> <span class="n">remote</span> <span class="o">-&gt;</span> <span class="n">branch</span> <span class="o">-&gt;</span> <span class="p">[</span> <span class="nt">`Merge</span> <span class="o">|</span> <span class="nt">`Update</span> <span class="p">]</span> <span class="o">-&gt;</span> <span class="p">[</span> <span class="nt">`Conflict</span> <span class="k">of</span> <span class="kt">string</span> <span class="o">|</span> <span class="nt">`Error</span> <span class="o">|</span> <span class="nt">`No_head</span> <span class="o">|</span> <span class="nt">`Ok</span> <span class="p">]</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span>
  <span class="k">val</span> <span class="n">push</span> <span class="o">:</span> <span class="n">remote</span> <span class="o">-&gt;</span> <span class="n">branch</span> <span class="o">-&gt;</span> <span class="p">[</span> <span class="nt">`Error</span> <span class="o">|</span> <span class="nt">`Ok</span> <span class="p">]</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span>
<span class="k">end</span>
</code></pre></div></div>

<p>This design provides the flexibility to describe your own network layout, with
anti-entropy mechanisms built-in to the synchronization protocol. For example,
one might deploy the replicas in a hub-and-spoke model where each replica
accepts client writes locally and periodically publishes changes to the master
and also fetches any latest updates. The data structures provided by Ezirmin
are always mergeable and converge. Hence, the updates are never rejected. It is
important to note that even though we have a centralized master, this
deployment is still highly available. Even if the master is unavailable, the
other nodes can still accept client requests. The replicas may also be
connected in a peer-to-peer fashion without a centralized master for a more
resilient deployment.</p>

<h1>Mergeable persistent data types</h1>

<p>Ezirmin is equipped with a <a href="https://github.com/kayceesrk/ezirmin#whats-in-the-box">growing
collection</a> of mergeable
data types. The mergeable datatypes occupy a unique position in the space of
CRDTs. Given that we have the history, the design of mergeable datatypes is much
simpler. Additionally, this also leads to <a href="http://gazagnaire.org/pub/FGM15.pdf">richer
structures</a> typically not found in CRDTs.
It is worth studying them in detail.</p>

<h2>Irmin Architecture</h2>

<p>Irmin provides a high-level key-value interface built over two lower level
heaps: a <strong>block store</strong> and a <strong>tag store</strong>. A block store is an append-only
content-addressable store that stores serialized values of application contents,
prefix-tree nodes, history meta-data, etc. Instead of using physical memory
address of blocks, the blocks are identified by the hash of their contents. As a
result block store enjoys very nice properties. Being content-addressed, we get
sharing for free: two blocks with the same content will have the have the same
hash. This not only applies for individual blocks, but also for
linked-structures. For example,</p>

<p align="center"> <img src="https://kcsrk.info/assets/linked_list.png" alt="Hash list"/> </p>

<p>The linked list above is uniquely identified by hash <code class="language-plaintext highlighter-rouge">h0</code> since <code class="language-plaintext highlighter-rouge">h0</code> was
computed from the content <code class="language-plaintext highlighter-rouge">a</code> and the hash of the tail of the list <code class="language-plaintext highlighter-rouge">h1</code>. No
other list has hash <code class="language-plaintext highlighter-rouge">h0</code>. Changing <code class="language-plaintext highlighter-rouge">c</code> to <code class="language-plaintext highlighter-rouge">C</code> in this list would result in a
different hash for the head of the list<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:blockchain" class="footnote" rel="footnote">3</a></sup>. Moreover, since the block
store is append-only, all previous versions of a application-level data
structure is also available, and thus providing persistence. This also makes for
a nice concurrency story for multiple processes/threads operating on the block
store. The absence of mutations on block store mean that no additional
concurrency control mechanisms are necessary.</p>

<p>The only mutable part of the Irmin architecture is the tag store, that maps
global names to blocks in the block store. The notion of branches are built on
top of the tag store. Cloning a branch creates a new tag that points to the same
block as the cloned branch.</p>

<h2>User-defined merges</h2>

<p>The real power of Irmin is due to the user-defined merges. Irmin expects the
developer to provide a 3-way merge function with the following signature:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">t</span>
<span class="c">(** User-defined contents. *)</span>

<span class="k">val</span> <span class="n">merge</span> <span class="o">:</span> <span class="n">old</span><span class="o">:</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">[</span><span class="nt">`Ok</span> <span class="k">of</span> <span class="n">t</span> <span class="o">|</span> <span class="nt">`Conflict</span> <span class="k">of</span> <span class="kt">string</span><span class="p">]</span>
<span class="c">(** 3-way merge. *)</span>
</code></pre></div></div>

<p>Given the common ancestor <code class="language-plaintext highlighter-rouge">old</code> and the two versions, merge function can either
return a successful merge or mark a conflict. It is up to the developer to ensure
that merges are commutative (<code class="language-plaintext highlighter-rouge">merge old a b = merge old b a</code>) and that the merge
captures the intent of the two branches. <em>If the merge function never conflicts,
we have CRDTs</em>.</p>

<h2>Mergeable Counters</h2>

<p>The simplest mergeable data type is a counter with an increment and decrement
operations. Given that we have a 3-way merge function, the merge is intuitive:</p>



<p>Given the two new values for the counter <code class="language-plaintext highlighter-rouge">t1</code> and <code class="language-plaintext highlighter-rouge">t2</code>, and their lowest common
ancestor value <code class="language-plaintext highlighter-rouge">old</code>, the new value of the counter is the sum of the <code class="language-plaintext highlighter-rouge">old</code> value
and the two deltas: <code class="language-plaintext highlighter-rouge">old + (t1 - old) + (t2 - old) = t1 + t2 - old</code>.</p>

<h3>Theory of merges</h3>

<p>While this definition is intuitive, the proof of why this strategy (i.e.,
computing deltas and applying to the common ancestor) is correct is quite
subtle. It happens to be the case that the patches (deltas) in this case,
integers under addition, form an <a href="https://en.wikipedia.org/wiki/Abelian_group">abelian
group</a>. Judah Jacobson formalizes
<a href="ftp://ftp.math.ucla.edu/pub/camreport/cam09-83.pdf">patches for Darcs as inverse
semigroups</a> and proves
convergence. Every abelian group is also an inverse semigroup. Hence, the above
strategy is correct. Merges can also be equivalently viewed as a <a href="https://arxiv.org/pdf/1311.3903.pdf">pushout in
category theory</a>, leading to the same
result. I will have to save the discussion of the category theoretic reasoning
of Irmin merges for another time. But Liam O&rsquo;Connor has written a concise
<a href="http://liamoc.net/posts/2015-11-10-patch-theory.html">post</a> on the theory of patches
which is worth a read.</p>

<h3>Recursive merges</h3>

<p>Since Ezirmin allows arbitrary branching and merging, the lowest common ancestor
need not be unique. One way to end up with multiple lowest common ancestors is
criss-cross merges. For example, consider the history graph below:</p>

<p align="center"> <img src="https://kcsrk.info/assets/criss_cross.png" alt="Criss cross merge"/> </p>

<p>The counter at some key in the <code class="language-plaintext highlighter-rouge">master</code> was initially <code class="language-plaintext highlighter-rouge">0</code>. The branch <code class="language-plaintext highlighter-rouge">wip</code> was
cloned at this point. The counter is incremented by <code class="language-plaintext highlighter-rouge">1</code> at <code class="language-plaintext highlighter-rouge">master</code> and <code class="language-plaintext highlighter-rouge">2</code> at
<code class="language-plaintext highlighter-rouge">wip</code>. At this point, both branches are merged into the other branch. The common
ancestor here is the initial state of counter <code class="language-plaintext highlighter-rouge">0</code>. This results in counter value
of <code class="language-plaintext highlighter-rouge">3</code> in both branches. Suppose there are further increments, <code class="language-plaintext highlighter-rouge">2</code> at <code class="language-plaintext highlighter-rouge">master</code>
and <code class="language-plaintext highlighter-rouge">4</code> at <code class="language-plaintext highlighter-rouge">wip</code>, resulting in counter values <code class="language-plaintext highlighter-rouge">5</code> and <code class="language-plaintext highlighter-rouge">7</code> respectively in
<code class="language-plaintext highlighter-rouge">master</code> and <code class="language-plaintext highlighter-rouge">wip</code>.</p>

<p>If the <code class="language-plaintext highlighter-rouge">wip</code> branch is now merged in <code class="language-plaintext highlighter-rouge">master</code>, there are two lowest common
ancestors: the commit with value <code class="language-plaintext highlighter-rouge">1</code> at master and <code class="language-plaintext highlighter-rouge">2</code> in wip. Since the 3-way
merge algorithm only work for a single common ancestor, the we adopt a recursive
merge strategy, where the lowest common ancestors are first merged resulting in
a internal commit with value <code class="language-plaintext highlighter-rouge">3</code> (represented by a dotted circle). This commit
is now used as the common ancestor for merging, which results in <code class="language-plaintext highlighter-rouge">9</code> as the new
state of the counter. This matches the increments done in both branches. The
recursive merge strategy is also the default merge strategy for Git.</p>

<h2>Mergeable logs</h2>

<p>Another useful data type is <a href="http://kcsrk.info/ezirmin/Ezirmin.Blob_log.html">mergeable
logs</a>, where each log message
is a string. The merge operation accumulates the logs in reverse chronological
order. To this end, each log entry is a pair of timestamp and message, and the
log itself is a list of entries. They are constructed using
<a href="https://github.com/mirage/mirage-tc">mirage-tc</a>:</p>



<p>The merge function extracts the newer entries from either branches, sorts them
and appends to the front of the old list.</p>



<p>While this implementation is simple, it does not scale well. In particular, each
commit stores the entire log as a single serialized blob. This does not take
advantage of the fact that every commit can share the tail of the log with its
predecessor. Moreover, every append to the log needs to deserialize the entire
log, append the new entry and serialize the log again. Hence, append is an
<code class="language-plaintext highlighter-rouge">O(n)</code> operation, where <code class="language-plaintext highlighter-rouge">n</code> is the size of the log. Merges are also worst case
<code class="language-plaintext highlighter-rouge">O(n)</code>. This is undesirable.</p>

<h3>Efficient mergeable logs</h3>

<p>We can implement a <a href="http://kcsrk.info/ezirmin/Ezirmin.Log.html">efficient logs</a>
by taking advantage of the fact that every commit shares the tail of the log
with its predecessor.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">log_entry</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">time</span>    <span class="o">:</span> <span class="nn">Time</span><span class="p">.</span><span class="n">t</span><span class="p">;</span>
  <span class="n">message</span> <span class="o">:</span> <span class="nn">V</span><span class="p">.</span><span class="n">t</span><span class="p">;</span>        <span class="c">(** V.t is type of message. *)</span>
  <span class="n">prev</span>    <span class="o">:</span> <span class="nn">K</span><span class="p">.</span><span class="n">t</span> <span class="n">option</span>  <span class="c">(** K.t is the type of address in the block store. *)</span>
<span class="p">}</span>
</code></pre></div></div>

<p>Merges simply add a new node which points to the logs of merged branches,
resulting in a DAG that captures the causal history. The following sequence of
operations:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="o">#</span><span class="n">require</span> <span class="s2">&quot;ezirmin&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Infix</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Ezirmin</span><span class="p">.</span><span class="nc">Memory_log</span><span class="p">(</span><span class="nn">Tc</span><span class="p">.</span><span class="nc">String</span><span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nc">M</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="n">init</span> <span class="bp">()</span> <span class="o">&gt;&gt;=</span> <span class="n">master</span><span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span>
  <span class="n">append</span> <span class="n">m</span> <span class="bp">[]</span> <span class="s2">&quot;m0&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">m</span> <span class="bp">[]</span> <span class="s2">&quot;m1&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">clone_force</span> <span class="n">m</span> <span class="s2">&quot;wip&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">w</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">w</span> <span class="bp">[]</span> <span class="s2">&quot;w0&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">m</span> <span class="bp">[]</span> <span class="s2">&quot;m2&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">merge</span> <span class="n">w</span> <span class="o">~</span><span class="n">into</span><span class="o">:</span><span class="n">m</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">w</span> <span class="bp">[]</span> <span class="s2">&quot;w1&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">w</span> <span class="bp">[]</span> <span class="s2">&quot;w2&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">m</span> <span class="bp">[]</span> <span class="s2">&quot;m3&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="n">append</span> <span class="n">m</span> <span class="bp">[]</span> <span class="s2">&quot;m4&quot;</span>
<span class="p">);;</span>
</code></pre></div></div>

<p>results in the heap below.</p>

<p align="center"> <img src="https://kcsrk.info/assets/log.png" alt="Merge log"/> </p>

<p>Read traverses the log in reverse chronological order.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">read_all</span> <span class="n">m</span> <span class="bp">[]</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">&quot;m4&quot;</span><span class="p">;</span> <span class="s2">&quot;m3&quot;</span><span class="p">;</span> <span class="s2">&quot;m2&quot;</span><span class="p">;</span> <span class="s2">&quot;w0&quot;</span><span class="p">;</span> <span class="s2">&quot;m1&quot;</span><span class="p">;</span> <span class="s2">&quot;m0&quot;</span><span class="p">]</span>
</code></pre></div></div>

<p>This implementation has <code class="language-plaintext highlighter-rouge">O(1)</code> appends and <code class="language-plaintext highlighter-rouge">O(1)</code> merges, resulting in much
better performance. The graph below compares the blob log implementation and
this linked implementation with file system backend by performing repeated
appends to the log and measuring the latency for append.</p>

<p align="center"> <img src="https://kcsrk.info/assets/perf_log.png" alt="Perf log"/> </p>

<p>Each point represents the average latency for the previous 100 appends. The
results show that the append latency for linked implementation remains
relatively constant while the blob implementation slows down considerably with
increasing number of appends. Additionally, the linked implementation also
supports efficient <a href="http://kcsrk.info/ezirmin/Ezirmin.Log.html#VALread">paginated
reads</a>.</p>

<h2>Mergeable ropes</h2>

<p>A rope data structure is used for efficiently storing and manipulating very long
strings. Ezirmin provides <a href="http://kcsrk.info/ezirmin/Ezirmin.Rope.html">mergeable
ropes</a> where for <a href="http://kcsrk.info/ezirmin/Ezirmin.Rope_content.html">arbitrary
contents</a>, but also
specialized for <a href="http://kcsrk.info/ezirmin/Ezirmin.Rope_string.html">strings</a>.
Ropes automatically rebalance to maintain the invariant that the height of the
tree is proportional to the length of the contents. The crux of the merge
strategy is that given a common ancestor and the two trees to be merged,
the merge algorithm works out the smallest subtrees where the modification
occurred. If the modifications are on distinct subtrees, then the merge is
trivial.</p>

<p align="center"> <img src="https://kcsrk.info/assets/merge_rope.png" alt="merge rope"/> </p>

<p>If the modification is on the same subtree, then the algorithm delegates to
merge the contents. This problem has been well studied under the name of
<a href="https://en.wikipedia.org/wiki/Operational_transformation">operational
transformation</a> (OT).
OT can be categorically explained in terms of pushouts.
Mergeable strings with insert, delete and replace operations are isomorphic to
counters with increment and decrement. We apply a similar strategy to merge
string.</p>



<p>First we compute the diff between the common ancestor and the new tree using
<a href="https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm">Wagner-Fischer
algorithm</a>. Then
we transform one patch with respect to the other using standard OT definition
such that we can first apply one of the original patch to the common ancestor
and then apply the transformed patch of the other branch to get the result tree.</p>

<p>For example,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="o">#</span><span class="n">require</span> <span class="s2">&quot;ezirmin&quot;</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Infix</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Ezirmin</span><span class="p">.</span><span class="nc">Memory_rope_string</span><span class="p">;;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="n">init</span> <span class="bp">()</span> <span class="o">&gt;&gt;=</span> <span class="n">master</span><span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span>
  <span class="n">make</span> <span class="s2">&quot;abc&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">t</span> <span class="o">-&gt;</span>
  <span class="n">write</span> <span class="n">m</span> <span class="bp">[]</span> <span class="n">t</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>
  <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="n">t</span>
<span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">w</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="n">clone_force</span> <span class="n">m</span> <span class="s2">&quot;w&quot;</span><span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span>
  <span class="n">set</span> <span class="n">t</span> <span class="mi">1</span> <span class="k">'</span><span class="n">x'</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">t'</span> <span class="c">(* &quot;axc&quot; *)</span> <span class="o">-&gt;</span>
  <span class="n">write</span> <span class="n">m</span> <span class="bp">[]</span> <span class="n">t'</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>

  <span class="n">insert</span> <span class="n">t</span> <span class="mi">1</span> <span class="s2">&quot;y&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">t'</span> <span class="c">(* &quot;aybc&quot; *)</span><span class="o">-&gt;</span>
  <span class="n">write</span> <span class="n">w</span> <span class="bp">[]</span> <span class="n">t'</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span>

  <span class="n">merge</span> <span class="n">w</span> <span class="o">~</span><span class="n">into</span><span class="o">:</span><span class="n">m</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">_</span> <span class="c">(* &quot;ayxc&quot; *)</span> <span class="o">-&gt;</span>
  <span class="n">merge</span> <span class="n">m</span> <span class="o">~</span><span class="n">into</span><span class="o">:</span><span class="n">w</span>
<span class="p">);;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span>
  <span class="n">read</span> <span class="n">m</span> <span class="bp">[]</span> <span class="o">&gt;&gt;=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;impossible&quot;</span>
  <span class="o">|</span> <span class="nc">Some</span> <span class="n">r</span> <span class="o">-&gt;</span> <span class="n">flush</span> <span class="n">r</span> <span class="o">&gt;|=</span> <span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;m is </span><span class="se">\&quot;</span><span class="s2">%s</span><span class="se">\&quot;\n</span><span class="s2">&quot;</span> <span class="n">s</span>
<span class="p">);;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">m</span> <span class="n">is</span> <span class="s2">&quot;ayxc&quot;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span>
  <span class="n">read</span> <span class="n">w</span> <span class="bp">[]</span> <span class="o">&gt;&gt;=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;impossible&quot;</span>
  <span class="o">|</span> <span class="nc">Some</span> <span class="n">r</span> <span class="o">-&gt;</span> <span class="n">flush</span> <span class="n">r</span> <span class="o">&gt;|=</span> <span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;w is </span><span class="se">\&quot;</span><span class="s2">%s</span><span class="se">\&quot;\n</span><span class="s2">&quot;</span> <span class="n">s</span>
<span class="p">)</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="n">w</span> <span class="n">is</span> <span class="s2">&quot;ayxc&quot;</span>
</code></pre></div></div>

<p>The combination of mergeable ropes with OT gets the best of both worlds.
Compared to a purely OT based implementation, diffs are only computed if updates
conflict at the leaves. The representation using ropes is also efficient in
terms of storage where multiple versions of the tree shares blocks. A purely
rope based implementation either has the option of storing individual characters
(atoms) at the leaves (and resolve conflicts based on some deterministic
mechanism such as timestamps or other deterministic strategies) or manifest the
conflict at the leaves to the user to get it resolved. A simple strategy might
be to present both of the conflicting strings, and ask the user to resolve it.
Hence, mergeable ropes + OT is strictly better than either of the approaches.</p>

<h1>Next steps</h1>

<p>Ezirmin is open to comments and contributions. Next steps would be:</p>

<ul>
  <li>Implement more mergeable data types</li>
  <li>Implement generic mergeable datatypes using <a href="https://github.com/samoht/depyt">depyt</a>.</li>
  <li>Explore the data types which admit conflicts. For example, a bank account with
non-negative balance does not form a CRDT with a <code class="language-plaintext highlighter-rouge">withdraw</code> operation. However,
operations such as <code class="language-plaintext highlighter-rouge">deposit</code> and <code class="language-plaintext highlighter-rouge">accrue_interest</code> can be coordination-free.</li>
</ul>

<h1 class="no_toc">Footnotes</h1>
<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>Things are indeed improving with a cleaner API in the <a href="https://github.com/mirage/irmin/pull/397">1.0 release</a>.&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:irmin" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p>Push is currently <a href="https://github.com/mirage/irmin/issues/379">broken</a>. But given that Irmin is compatible with git, one can use <code class="language-plaintext highlighter-rouge">git-push</code> to publish changes.&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:push" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p>The same principle underlies the irrefutability of <a href="https://en.wikipedia.org/wiki/Blockchain_(database)">blockchain</a>. No block can be changed without reflecting the change in every subsequent block.&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:blockchain" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
  </ol>
</div>

