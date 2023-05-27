---
title: Effective Concurrency with Algebraic Effects
description:
url: https://kcsrk.info/ocaml/multicore/2015/05/20/effects-multicore/
date: 2015-05-20T14:04:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>Algebraic effects and handlers provide a modular abstraction for expressing
effectful computation, allowing the programmer to separate the expression of an
effectful computation from its implementation. In this post, I will present an
extension to OCaml for programming with linear algebraic effects, and
demonstrate its use in expressing concurrency primitives for <a href="https://github.com/ocamllabs/ocaml-multicore">multicore
OCaml</a>. The design and
implementation of algebraic effects for multicore OCaml is due to <a href="http://www.lpw25.net/">Leo
White</a>, <a href="https://github.com/stedolan">Stephen Dolan</a> and
the multicore team at <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml
Labs</a>.</p>



<h2>Motivation</h2>

<p>Multicore-capable functional programming language implementations such as
<a href="https://www.haskell.org/ghc/">Glasgow Haskell Compiler</a>,
<a href="http://fsharp.org/">F#</a>, <a href="http://manticore.cs.uchicago.edu/">Manticore</a> and
<a href="https://github.com/kayceesrk/multiMLton">MultiMLton</a> expose one or more
libraries for expressing concurrent programs. The concurrent threads of
execution instantiated through the library are in turn multiplexed over the
available cores for speed up. A common theme among such runtimes is that the
primitives for concurrency along with the concurrent thread scheduler is baked
into the runtime system. Over time, the runtime system itself tends to become a
complex, monolithic piece of software, with extensive use of locks, condition
variables, timers, thread pools, and other arcana. As a result, it becomes
difficult to maintain existing concurrency libraries, let alone add new ones.
Such lack of malleability is particularly unfortunate as it prevents developers
from experimenting with custom concurrency libraries and scheduling strategies,
preventing innovation in the ecosystem. Our goal with this work is to provide a
minimal set of tools with which programmers can implement new concurrency
primitives and schedulers as OCaml libraries.</p>

<h2>A Taste of Effects</h2>

<h3>A Simple Scheduler</h3>

<p>Let us illustrate the algebraic effect extension in multicore OCaml by
constructing a concurrent round-robin scheduler with the following interface:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* Control operations on threads *)</span>
<span class="k">val</span> <span class="n">fork</span>  <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">val</span> <span class="n">yield</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="c">(* Runs the scheduler. *)</span>
<span class="k">val</span> <span class="n">run</span>   <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span></code></pre></figure>

<p>The basic tenet of programming with algebraic effects is that performing an
effectful computation is separate from its interpretation<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Eff" class="footnote" rel="footnote">1</a></sup>.
In particular, the interpretation is dynamically chosen based on the context in
which an effect is performed. In our example, spawning a new thread and
yielding control to another are effectful actions, for which we declare the
following effects:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">type</span> <span class="n">_</span> <span class="n">eff</span> <span class="o">+=</span>
<span class="o">|</span> <span class="nc">Fork</span>  <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="n">eff</span>
<span class="o">|</span> <span class="nc">Yield</span> <span class="o">:</span> <span class="kt">unit</span> <span class="n">eff</span></code></pre></figure>

<p>The type <code class="language-plaintext highlighter-rouge">'a eff</code> is the predefined extensible variant type for effects,
where <code class="language-plaintext highlighter-rouge">'a</code> represents the return type of performing the effect. For
convenience, we introduce new syntax using which the same declarations are
expressed as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="n">effect</span> <span class="nc">Fork</span>  <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="n">effect</span> <span class="nc">Yield</span> <span class="o">:</span> <span class="kt">unit</span></code></pre></figure>

<p>Effects are performed using the primitive <code class="language-plaintext highlighter-rouge">perform</code> of type <code class="language-plaintext highlighter-rouge">'a eff -&gt; 'a</code>. We
define the functions <code class="language-plaintext highlighter-rouge">fork</code> and <code class="language-plaintext highlighter-rouge">yield</code> as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">fork</span> <span class="n">f</span> <span class="o">=</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Fork</span> <span class="n">f</span><span class="p">)</span>
<span class="k">let</span> <span class="n">yield</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">perform</span> <span class="nc">Yield</span></code></pre></figure>

<p>What is left is to provide an interpretation of what it means to perform
<code class="language-plaintext highlighter-rouge">fork</code> and <code class="language-plaintext highlighter-rouge">yield</code>. This interpretation is provided with the help of
<em>handlers</em>.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><table class="rouge-table"><tbody><tr><td class="gutter gl"><pre class="lineno">1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
</pre></td><td class="code"><pre><span class="k">let</span> <span class="n">run</span> <span class="n">main</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">run_q</span> <span class="o">=</span> <span class="nn">Queue</span><span class="p">.</span><span class="n">create</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">enqueue</span> <span class="n">k</span> <span class="o">=</span> <span class="nn">Queue</span><span class="p">.</span><span class="n">push</span> <span class="n">k</span> <span class="n">run_q</span> <span class="k">in</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">dequeue</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">if</span> <span class="nn">Queue</span><span class="p">.</span><span class="n">is_empty</span> <span class="n">run_q</span> <span class="k">then</span> <span class="bp">()</span>
    <span class="k">else</span> <span class="n">continue</span> <span class="p">(</span><span class="nn">Queue</span><span class="p">.</span><span class="n">pop</span> <span class="n">run_q</span><span class="p">)</span> <span class="bp">()</span>
  <span class="k">in</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">spawn</span> <span class="n">f</span> <span class="o">=</span>
    <span class="k">match</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">with</span>
    <span class="o">|</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">dequeue</span> <span class="bp">()</span>
    <span class="o">|</span> <span class="k">exception</span> <span class="n">e</span> <span class="o">-&gt;</span>
        <span class="n">print_string</span> <span class="p">(</span><span class="n">to_string</span> <span class="n">e</span><span class="p">);</span>
        <span class="n">dequeue</span> <span class="bp">()</span>
    <span class="o">|</span> <span class="n">effect</span> <span class="nc">Yield</span> <span class="n">k</span> <span class="o">-&gt;</span>
        <span class="n">enqueue</span> <span class="n">k</span><span class="p">;</span> <span class="n">dequeue</span> <span class="bp">()</span>
    <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Fork</span> <span class="n">f</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span>
        <span class="n">enqueue</span> <span class="n">k</span><span class="p">;</span> <span class="n">spawn</span> <span class="n">f</span>
  <span class="k">in</span>
  <span class="n">spawn</span> <span class="n">main</span>
</pre></td></tr></tbody></table></code></pre></figure>

<p>The function <code class="language-plaintext highlighter-rouge">spawn f</code> (line 8) evaluates <code class="language-plaintext highlighter-rouge">f</code> in a new thread of control. <code class="language-plaintext highlighter-rouge">f</code>
may return normally with value <code class="language-plaintext highlighter-rouge">()</code> or exceptionally with an exception <code class="language-plaintext highlighter-rouge">e</code> or
effectfully with the effect performed along with the delimited
continuation<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Filinski94" class="footnote" rel="footnote">2</a></sup> <code class="language-plaintext highlighter-rouge">k</code>. In the pattern <code class="language-plaintext highlighter-rouge">effect e k</code>, if the
effect <code class="language-plaintext highlighter-rouge">e</code> has type <code class="language-plaintext highlighter-rouge">'a eff</code>, then the delimited continuation <code class="language-plaintext highlighter-rouge">k</code> has type
<code class="language-plaintext highlighter-rouge">('a,'b) continuation</code>, i.e., the return type of the effect <code class="language-plaintext highlighter-rouge">'a</code> matches the
argument type of the continuation, and the return type of the delimited
continuation is <code class="language-plaintext highlighter-rouge">'b</code>.</p>

<p>Observe that we represent the scheduler queue with a queue of delimited
continuations, with functions to manipulate the queue (lines 2&ndash;6). In the case
of normal or exceptional return, we pop the scheduler queue and resume the
resultant continuation using the <code class="language-plaintext highlighter-rouge">continue</code> primitive (line 6). <code class="language-plaintext highlighter-rouge">continue k v</code>
resumes the continuation <code class="language-plaintext highlighter-rouge">k : ('a,'b) continuation</code> with value <code class="language-plaintext highlighter-rouge">v : 'a</code> and
returns a value of type <code class="language-plaintext highlighter-rouge">'b</code>. In the case of effectful return with <code class="language-plaintext highlighter-rouge">Fork f</code>
effect (lines 16&ndash;17), we enqueue the current continuation to the scheduler
queue and spawn a new thread of control for evaluating <code class="language-plaintext highlighter-rouge">f</code>. In the case of
<code class="language-plaintext highlighter-rouge">Yield</code> effect (lines 14&ndash;15), we enqueue the current continuation, and resume
some other saved continuation from the scheduler queue.</p>

<h3>Testing the scheduler</h3>

<p>Lets write a simple concurrent program that utilises this scheduler, to create
a binary tree of tasks. The sources for this test are available
<a href="https://github.com/kayceesrk/ocaml-eff-example">here</a>. The program
<code class="language-plaintext highlighter-rouge">concurrent.ml</code>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">log</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span>

<span class="k">let</span> <span class="k">rec</span> <span class="n">f</span> <span class="n">id</span> <span class="n">depth</span> <span class="o">=</span>
  <span class="n">log</span> <span class="s2">&quot;Starting number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">id</span><span class="p">;</span>
  <span class="k">if</span> <span class="n">depth</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="k">begin</span>
    <span class="n">log</span> <span class="s2">&quot;Forking number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="p">(</span><span class="n">id</span> <span class="o">*</span> <span class="mi">2</span> <span class="o">+</span> <span class="mi">1</span><span class="p">);</span>
    <span class="nn">Sched</span><span class="p">.</span><span class="n">fork</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="p">(</span><span class="n">id</span> <span class="o">*</span> <span class="mi">2</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span> <span class="p">(</span><span class="n">depth</span> <span class="o">-</span> <span class="mi">1</span><span class="p">));</span>
    <span class="n">log</span> <span class="s2">&quot;Forking number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="p">(</span><span class="n">id</span> <span class="o">*</span> <span class="mi">2</span> <span class="o">+</span> <span class="mi">2</span><span class="p">);</span>
    <span class="nn">Sched</span><span class="p">.</span><span class="n">fork</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="p">(</span><span class="n">id</span> <span class="o">*</span> <span class="mi">2</span> <span class="o">+</span> <span class="mi">2</span><span class="p">)</span> <span class="p">(</span><span class="n">depth</span> <span class="o">-</span> <span class="mi">1</span><span class="p">))</span>
  <span class="k">end</span> <span class="k">else</span> <span class="k">begin</span>
    <span class="n">log</span> <span class="s2">&quot;Yielding in number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">id</span><span class="p">;</span>
    <span class="nn">Sched</span><span class="p">.</span><span class="n">yield</span> <span class="bp">()</span><span class="p">;</span>
    <span class="n">log</span> <span class="s2">&quot;Resumed number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">id</span><span class="p">;</span>
  <span class="k">end</span><span class="p">;</span>
  <span class="n">log</span> <span class="s2">&quot;Finishing number %i</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">id</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Sched</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="mi">0</span> <span class="mi">2</span><span class="p">)</span></code></pre></figure>

<p>generates a binary tree of depth 2, where the tasks are numbered as shown
below:</p>

<p><img src="https://kcsrk.info/assets/tree.png" alt="Binary tree"/></p>

<p>The program forks new tasks in a depth-first fashion and yields when it reaches
maximum depth, logging the actions along the way. To run the program, first
install multicore OCaml compiler, available from the <a href="https://github.com/ocamllabs/opam-repo-dev">OCaml Labs dev
repo</a>. Once the compiler is
installed, the above test program can be compiled and run as follows:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>git clone https://github.com/kayceesrk/ocaml-eff-example
<span class="nv">$ </span><span class="nb">cd </span>ocaml-eff-example
<span class="nv">$ </span>make
<span class="nv">$ </span>./concurrent
Starting number 0
Forking number 1
Starting number 1
Forking number 3
Starting number 3
Yielding <span class="k">in </span>number 3
Forking number 2
Starting number 2
Forking number 5
Starting number 5
Yielding <span class="k">in </span>number 5
Forking number 4
Starting number 4
Yielding <span class="k">in </span>number 4
Resumed number 3
Finishing number 3
Finishing number 0
Forking number 6
Starting number 6
Yielding <span class="k">in </span>number 6
Resumed number 5
Finishing number 5
Finishing number 1
Resumed number 4
Finishing number 4
Finishing number 2
Resumed number 6
Finishing number 6</code></pre></figure>

<p>The output illustrates how the tasks are forked and scheduled.</p>

<h2>Implementation</h2>

<h3>Fibers for Concurrency</h3>

<p>The main challenge in the implementation of algebraic effects is the efficient
management of delimited continuations. In multicore OCaml<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:OW14" class="footnote" rel="footnote">3</a></sup>, the delimited
continuations are implemented using <em>fibers</em>, which are small heap-allocated,
dynamically resized stacks. Fibers represent the unit of concurrency in the
runtime system.</p>

<p>Our continuations are linear (one-shot)<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Bruggeman96" class="footnote" rel="footnote">4</a></sup>, in that once captured,
they may be resumed at most once. Capturing a one-shot continuation is fast,
since it involves only obtaining a pointer to the underlying fiber, and
requires no allocation. OCaml uses a calling convention without callee-save
registers, so capturing a one-shot continuation requires saving no more context
than that necessary for a normal function call.</p>

<p>Since OCaml does not have linear types, we enforce the one-shot property at
runtime by raising an exception the second time a continuation is invoked. For
applications requiring true multi-shot continuations (such as probabilistic
programming<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Kiselyov09" class="footnote" rel="footnote">5</a></sup>), we envision providing an explicit operation to copy
a continuation.</p>

<p>While continuation based concurrent functional programming runtimes such as
Manticore and MultiMLton use undelimited continuations, our continuations are
delimited. We believe delimited continuations enable complex nested and
hierarchical schedulers to be expressed more naturally due to the fact that
they introduce parent-child relationship between fibers similar to a function
invocation.</p>

<h3>Running on Multiple Cores</h3>

<p>Multicore OCaml provides support for shared-memory parallel execution. The unit
of parallelism is a <em>domain</em>, each running a separate system thread, with a
relatively small local heap and a single shared heap shared among all of the
domains. In order to distributed the fibers amongst the available domains, work
sharing/stealing schedulers are initiated on each of the domains. The multicore
runtime exposes to the programmer a small set of locking and signalling
primitives for achieving mutual exclusion and inter-domain communication.</p>

<p>The multicore runtime has the invariant that there are no pointers between the
domain local heaps. However, the programmer utilising the effect library to
write schedulers need not be aware of this restriction as fibers are
transparently promoted from local to shared heap on demand. We will have to
save multicore-capable schedulers for another post.</p>
<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p><a href="http://www.eff-lang.org/">Eff</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Eff" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="http://www.diku.dk/hjemmesider/ansatte/andrzej/papers/RM-abstract.html">Representing Monads</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Filinski94" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="https://ocaml.org/meetings/ocaml/2014/ocaml2014_1.pdf">Multicore OCaml (pdf)</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:OW14" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="http://www.cs.indiana.edu/~dyb/pubs/call1cc-abstract.html">Representing Control in the presence of One-shot Continuations</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Bruggeman96" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="http://okmij.org/ftp/kakuritu/">Embedded domain-specific language HANSEI for probabilistic models and (nested) inference</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Kiselyov09" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
  </ol>
</div>

