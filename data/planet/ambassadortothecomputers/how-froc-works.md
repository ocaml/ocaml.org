---
title: How froc works
description: I am happy to announce the release of version 0.2 of the froc  library
  for functional reactive programming in OCaml. There are a number of...
url: http://ambassadortothecomputers.blogspot.com/2010/05/how-froc-works.html
date: 2010-05-07T17:47:00-00:00
preview_image: http://4.bp.blogspot.com/_-BRxxZyoKFE/S-RS60NO3DI/AAAAAAAAAOw/KkXzrR_I14g/w1200-h630-p-k-no-nu/how-froc-works-a.png
featured:
authors:
- ambassadortothecomputers
---

 
<p>I am happy to announce the release of version 0.2 of the <code>froc</code> library for functional reactive programming in OCaml. There are a number of improvements:</p> 
 
<ul> 
<li>better event model: there is now a notion of simultaneous events, and behaviors and events can now be freely mixed</li> 
 
<li><a href="http://ttic.uchicago.edu/~umut/projects/self-adjusting-computation/">self-adjusting computation</a> is now supported via memo functions; needless recomputation can be avoided in some cases</li> 
 
<li>faster priority queue and timeline data structures</li> 
 
<li>behavior and event types split into co- and contra-variant views for subtyping</li> 
 
<li>bug fixes and cleanup</li> 
</ul> 
 
<p>Development of <code>froc</code> has moved from Google Code to Github; see</p> 
 
<ul> 
<li><a href="http://github.com/jaked/froc">project page</a></li> 
 
<li><a href="http://jaked.github.com/froc">documentation</a></li> 
 
<li><a href="http://github.com/jaked/froc/downloads">downloads</a></li> 
</ul> 
 
<p>Thanks to Ruy Ley-Wild for helpful discussion, and to Daniel B&uuml;nzli for helpful discussion and many good ideas in React.</p> 
 
<p>I thought I would take this opportunity to explain how <code>froc</code> works, because it is interesting, and to help putative <code>froc</code> users use it effectively.</p> 
<b>Dependency graphs</b> 
<p>The main idea behind <code>froc</code> (and self-adjusting computation) is that we can think of an expression as implying a dependency graph, where each subexpression depends on its subexpressions, and ultimately on some input values. When the input values change, we can recompute the expression incrementally by recursively pushing changes to dependent subexpressions.</p> 
 
<p>To be concrete, suppose we have this expression:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">u</span> <span class="o">=</span> <span class="n">v</span> <span class="o">/</span> <span class="n">w</span> <span class="o">+</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span> <span class="o">+</span> <span class="n">z</span> 
</code></pre> 
</div> 
<p>Here is a dependency graph relating expressions to their subexpressions:</p> 
 
<p><img src="http://4.bp.blogspot.com/_-BRxxZyoKFE/S-RS60NO3DI/AAAAAAAAAOw/KkXzrR_I14g/s1600/how-froc-works-a.png" alt=""/></p> 
 
<p>The edges aren&rsquo;t directed, because we can think of dependencies as either demand-driven (to compute A, we need B), or change-driven (when B changes, we must recompute A).</p> 
 
<p>Now suppose we do an initial evaluation of the expression with <code>v =
4</code>, <code>w = 2</code>, <code>x = 2</code>, <code>y = 3</code>, and <code>z = 1</code>. Then we have (giving labels to unlabelled nodes, and coloring the current value of each node green):</p> 
 
<p><img src="http://1.bp.blogspot.com/_-BRxxZyoKFE/S-RThVz19aI/AAAAAAAAAO4/3Tpx6UqcFYQ/s1600/how-froc-works-b.png" alt=""/></p> 
 
<p>If we set <code>z = 2</code>, we need only update <code>u</code> to <code>10</code>, since no other node depends on <code>z</code>. If we then set <code>v = 6</code>, we need to update <code>n0</code> to <code>3</code>, <code>n2</code> to <code>9</code> (since <code>n2</code> depends on <code>n0</code>), and <code>u</code> to <code>11</code>, but we don&rsquo;t need to update <code>n1</code>. (This is the change-driven point of view.)</p> 
 
<p>What if we set <code>z = 2</code> and <code>v = 6</code> simultaneously, then do the updates? We have to be careful to do them in the right order. If we updated <code>u</code> first (since it depends on <code>z</code>), we&rsquo;d use a stale value for <code>n2</code>. We could require that we don&rsquo;t update an expression until each of its dependencies has been updated (if necessary). Or we could respect the original evaluation order of the expressions, and say that we won&rsquo;t update an expression until each expression that came before it has been updated.</p> 
 
<p>In <code>froc</code> we take the second approach. Each expression is given a <em>timestamp</em> (not a wall-clock time, but an abstract ordered value) when it&rsquo;s initially evaluated, and we re-evaluate the computation by running through a priority queue of stale expressions, ordered by timestamp. Here is the situation, with changed values in magenta, stale values in red, and timestamps in gray:</p> 
 
<p><img src="http://1.bp.blogspot.com/_-BRxxZyoKFE/S-RUC9vfS7I/AAAAAAAAAPA/ya4vwgVjV04/s1600/how-froc-works-c.png" alt=""/></p> 
 
<p>If we update the stale nodes from their dependencies in timestamp order, we get the right answer. We will see how this approach gives us a way to handle <em>control dependencies</em>, where A does not depend on B, but A&rsquo;s execution is controlled by B.</p> 
<b>Library interface</b> 
<p>The core of <code>froc</code> has the following (simplified) signature:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">return</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">bind</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">t</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">t</span> 
</code></pre> 
</div> 
<p>The type <code>'a t</code> represents <em>changeable values</em> (or just <em>changeables</em>) of type <code>'a</code>; these are the nodes of the dependency graph. <code>Return</code> converts a regular value to a changeable value. <code>Bind</code> makes a new changeable as a dependent of an existing one; the function argument is the expression that computes the value from its dependency. We have <code>&gt;&gt;=</code> as an infix synonym for <code>bind</code>; there are also multi-argument versions (<code>bind2</code>, <code>bind3</code>, etc.) so a value can depend on more than one other value.</p> 
 
<p>We could translate the expression from the previous section as:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">n0</span> <span class="o">=</span> <span class="n">bind2</span> <span class="n">v</span> <span class="n">w</span> <span class="o">(</span><span class="k">fun</span> <span class="n">v</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">v</span> <span class="o">/</span> <span class="n">w</span><span class="o">))</span> 
  <span class="k">let</span> <span class="n">n1</span> <span class="o">=</span> <span class="n">bind2</span> <span class="n">x</span> <span class="n">y</span> <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="n">y</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">x</span> <span class="o">*</span> <span class="n">y</span><span class="o">))</span> 
  <span class="k">let</span> <span class="n">n2</span> <span class="o">=</span> <span class="n">bind2</span> <span class="n">n0</span> <span class="n">n1</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n0</span> <span class="n">n1</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">n0</span> <span class="o">+</span> <span class="n">n1</span><span class="o">))</span> 
  <span class="k">let</span> <span class="n">u</span> <span class="o">=</span> <span class="n">bind2</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">n2</span> <span class="o">+</span> <span class="n">z</span><span class="o">))</span> 
</code></pre> 
</div> 
<p>There are some convenience functions in <code>froc</code> to make this more readable (these versions are also more efficient):</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">val</span> <span class="n">blift</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">lift</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">t</span> 
</code></pre> 
</div> 
<p><code>Blift</code> is like <code>bind</code> except that you don&rsquo;t need the <code>return</code> at the end of the expression (below we&rsquo;ll see cases where you actually need <code>bind</code>); <code>lift</code> is the same as <code>blift</code> but with the arguments swapped for partial application. So we could say</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">n0</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">v</span> <span class="n">w</span> <span class="o">(</span><span class="k">fun</span> <span class="n">v</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="n">v</span> <span class="o">/</span> <span class="n">w</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">n1</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">x</span> <span class="n">y</span> <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="n">y</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">n2</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">n0</span> <span class="n">n1</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n0</span> <span class="n">n1</span> <span class="o">-&gt;</span> <span class="n">n0</span> <span class="o">+</span> <span class="n">n1</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">u</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">-&gt;</span> <span class="n">n2</span> <span class="o">+</span> <span class="n">z</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>or even</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="o">(/)</span> <span class="o">=</span> <span class="n">lift2</span> <span class="o">(/)</span> 
  <span class="k">let</span> <span class="o">(</span> <span class="o">*</span> <span class="o">)</span> <span class="o">=</span> <span class="n">lift2</span> <span class="o">(</span> <span class="o">*</span> <span class="o">)</span> 
  <span class="k">let</span> <span class="o">(+)</span> <span class="o">=</span> <span class="n">lift2</span> <span class="o">(+)</span> 
  <span class="k">let</span> <span class="n">u</span> <span class="o">=</span> <span class="n">v</span> <span class="o">/</span> <span class="n">w</span> <span class="o">+</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span> <span class="o">+</span> <span class="n">z</span> 
</code></pre> 
</div> 
<p>Now, there is no reason to break down expressions all the way&mdash;a node can have a more complicated expression, for example:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">n0</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">v</span> <span class="n">w</span> <span class="o">(</span><span class="k">fun</span> <span class="n">v</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="n">v</span> <span class="o">/</span> <span class="n">w</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">n2</span> <span class="o">=</span> <span class="n">blift3</span> <span class="n">n0</span> <span class="n">x</span> <span class="n">y</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n0</span> <span class="n">x</span> <span class="n">y</span> <span class="o">-&gt;</span> <span class="n">n0</span> <span class="o">+</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">u</span> <span class="o">=</span> <span class="n">blift2</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">(</span><span class="k">fun</span> <span class="n">n2</span> <span class="n">z</span> <span class="o">-&gt;</span> <span class="n">n2</span> <span class="o">+</span> <span class="n">z</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>There is time overhead in propagating dependencies, and space overhead in storing the dependency graph, so it&rsquo;s useful to be able to control the granularity of recomputation by trading off computation over changeable values with computation over ordinary values.</p> 
<b>Dynamic dependency graphs</b> 
<p>Take this expression:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">b</span> <span class="o">=</span> <span class="n">x</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="k">if</span> <span class="n">b</span> <span class="k">then</span> <span class="mi">0</span> <span class="k">else</span> <span class="mi">100</span> <span class="o">/</span> <span class="n">x</span> 
</code></pre> 
</div> 
<p>Here it is in <code>froc</code> form:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">b</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">x</span> <span class="o">=</span> <span class="mi">0</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">n0</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="mi">100</span> <span class="o">/</span> <span class="n">x</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="n">bind2</span> <span class="n">b</span> <span class="n">n0</span> <span class="o">(</span><span class="k">fun</span> <span class="n">b</span> <span class="n">n0</span> <span class="o">-&gt;</span> <span class="k">if</span> <span class="n">b</span> <span class="k">then</span> <span class="n">return</span> <span class="mi">0</span> <span class="k">else</span> <span class="n">n0</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>and its dependency graph, with timestamps:</p> 
 
<p><img src="http://3.bp.blogspot.com/_-BRxxZyoKFE/S-RUj5r9i7I/AAAAAAAAAPI/ROpJD6sK_PI/s1600/how-froc-works-d.png" alt=""/></p> 
 
<p>(We begin to see why <code>bind</code> is sometimes necessary instead of <code>blift</code>&mdash;in order to return <code>n0</code> in the <code>else</code> branch, the function must return <code>'b t</code> rather than <code>'b</code>.)</p> 
 
<p>Suppose we have an initial evaluation with <code>x = 10</code>, and we then set <code>x = 0</code>. If we blindly update <code>n0</code>, we get a <code>Division_by_zero</code> exception, although we get no such exception from the original code. Somehow we need to take into account the control dependency between <code>b</code> and <code>100 / x</code>, and compute <code>100 / x</code> only when <code>b</code> is false. This can be accomplished by putting it inside the <code>else</code> branch:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">b</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="n">x</span> <span class="o">=</span> <span class="mi">0</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="n">b</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">b</span> <span class="o">-&gt;</span> <span class="k">if</span> <span class="n">b</span> <span class="k">then</span> <span class="n">return</span> <span class="mi">0</span> 
                              <span class="k">else</span> <span class="n">x</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="o">(</span><span class="mi">100</span> <span class="o">/</span> <span class="n">x</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>How does this work? <code>Froc</code> keeps track of the start and finish timestamps when running an expression, and associates dependencies with the timestamp when they are attacheed. When an expression is re-run, we detach all the dependencies between the start and finish timestamps. In this case, when <code>b</code> changes, we detach the dependent expression that divides by 0 before trying to run it.</p> 
 
<p>Let&rsquo;s walk through the initial run with <code>x = 10</code>: Here is the graph showing the timestamp ranges, and on the dependency edges, the timestamp when the dependency was attached:</p> 
 
<p><img src="http://3.bp.blogspot.com/_-BRxxZyoKFE/S-RUxKV8mRI/AAAAAAAAAPQ/VuJ4wIzRhsg/s1600/how-froc-works-e.png" alt=""/></p> 
 
<p>First we evaluate <code>b</code> (attaching it as a dependent of <code>x</code> at time <code>0</code>) to get <code>false</code>. Then we evaluate <code>y</code> (attaching it as a dependent of <code>b</code> at time <code>3</code>): we check <code>b</code> and evaluate <code>n0</code> to get <code>10</code> (attaching it as a dependent of <code>x</code> at time <code>5</code>). Notice that we have a dependency edge from <code>y</code> to <code>n0</code>. This is not a true dependency, since we don&rsquo;t recompute <code>y</code> when <code>n0</code> changes; rather the value of <code>y</code> is a proxy for <code>n0</code>, so when <code>n0</code> changes we just forward the new value to <code>y</code>.</p> 
 
<p>What happens if we set <code>x = 20</code>? Both <code>b</code> and <code>n0</code> are stale since they depend on <code>x</code>. We re-run expressions in order of their start timestamp, so we run <code>b</code> and get <code>false</code>. Since the value of <code>b</code> has not changed, <code>y</code> is not stale. Then we re-run <code>n0</code>, so its value (and the value of <code>y</code> by proxy) becomes <code>5</code>.</p> 
 
<p>What happens if we set <code>x = 0</code>? We run <code>b</code> and get <code>true</code>. Now <code>y</code> is also stale, and it is next in timestamp order. We first detach all the dependencies in the timestamp range <code>4</code>-<code>9</code> from the previous run of <code>y</code>: the dependency of <code>n0</code> on <code>x</code> and the proxy dependency of <code>y</code> on <code>n0</code>. This time we take the <code>then</code> branch, so we get <code>0</code> without attaching any new dependencies. We are done; no <code>Division_by_zero</code> exception.</p> 
 
<p>Now we can see why it&rsquo;s important to handle updates in timestamp order: the value which decides a control flow point (e.g. the test of an <code>if</code>) is always evaluated before the control branches (the <code>then</code> and <code>else</code> branches), so we have the chance to fix up the dependency graph before the branches are updated.</p> 
<b>Garbage collection and cleanup functions</b> 
<p>A node points to its dependencies (so it can read their values when computing its value), and its dependencies point back to the node (so they can mark it stale when they change). This creates a problem for garbage collection: a node which becomes garbage (from the point of view of the library user) is still attached to its dependencies, taking up memory, and causing extra recomputation.</p> 
 
<p>The implementation of dynamic dependency graphs helps with this problem: as we have seen, when an expression is re-run, the dependencies attached in the course of the previous run are detached, including any dependencies for nodes which have become garbage. Still, until the expression that created them is re-run, garbage nodes remain attached.</p> 
 
<p>Some other FRP implementations use weak pointers to store a node&rsquo;s dependents, to avoid hanging on to garbage nodes. Since <code>froc</code> is designed to work in browsers (using <a href="http://jaked.github.com/ocamljs">ocamljs</a>), weak pointers aren&rsquo;t an option because they aren&rsquo;t supported in Javascript. But even in regular OCaml, there are reasons to eschew the use of weak pointers:</p> 
 
<p>First, it&rsquo;s useful to be able to set up changeable expressions which are used for their effect (say, updating the GUI) rather than their value; to do this with a system using weak pointers, you have to stash the expression somewhere so it won&rsquo;t be GC&rsquo;d. This is similar to the problem of GCing threads; it doesn&rsquo;t make sense if the threads can have an effect.</p> 
 
<p>Second, there are other resources which may need to be cleaned up in reaction to changes (say, GUI event handler registrations); weak pointers are no help here. <code>Froc</code> gives you a way to set cleanup functions during a computation, which are run when the computation is re-run, so you can clean up other resources.</p> 
 
<p>With <code>froc</code> there are two options to be sure you don&rsquo;t leak memory: you can call <code>init</code> to clean up the entire system, or you can use <code>bind</code> to control the lifetime of changeables: for instance, you could have a changeable <code>c</code> representing a counter, do a computation in the scope of a bind of <code>c</code> (you can just ignore the value), then increment the counter to clear out the previous computation.</p> 
 
<p>In fact, there are situations where <code>froc</code> cleans up too quickly&mdash;when you want to hang on to a changeable after the expression that attached it is re-run. We&rsquo;ll see shortly how to avoid this.</p> 
<b>Memoizing the previous run</b> 
<p>Here is the <code>List.map</code> function, translated to work over lists where the tail is changeable.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">lst</span> <span class="o">=</span> <span class="nc">Nil</span> <span class="o">|</span> <span class="nc">Cons</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="n">lst</span> <span class="n">t</span> 
 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">map</span> <span class="n">f</span> <span class="n">lst</span> <span class="o">=</span> 
    <span class="n">lst</span> <span class="o">&gt;&gt;=</span> <span class="k">function</span> 
      <span class="o">|</span> <span class="nc">Nil</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="nc">Nil</span> 
      <span class="o">|</span> <span class="nc">Cons</span> <span class="o">(</span><span class="n">h</span><span class="o">,</span> <span class="n">t</span><span class="o">)</span> <span class="o">-&gt;</span> 
          <span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="n">map</span> <span class="n">f</span> <span class="n">t</span> <span class="k">in</span> 
          <span class="n">return</span> <span class="o">(</span><span class="nc">Cons</span> <span class="o">(</span><span class="n">f</span> <span class="n">h</span><span class="o">,</span> <span class="n">t</span><span class="o">))</span> 
</code></pre> 
</div> 
<p>What happens if we run</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="n">map</span> <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="mi">1</span><span class="o">)</span> <span class="o">[</span> <span class="mi">1</span><span class="o">;</span> <span class="mi">2</span><span class="o">;</span> <span class="mi">3</span> <span class="o">]</span> 
</code></pre> 
</div> 
<p>? (I&rsquo;m abusing the list syntax here to mean a changeable list with these elements.) Let&rsquo;s see if we can fit the dependency graph on the page (abbreviating <code>Cons</code> and <code>Nil</code> and writing just <code>f</code> for the <code>function</code> expression):</p> 
 
<p><img src="http://2.bp.blogspot.com/_-BRxxZyoKFE/S-RVCDRbyuI/AAAAAAAAAPY/XKaamcWm3QE/s1600/how-froc-works-f.png" alt=""/></p> 
 
<p>(The dependency edges on the right-hand side don&rsquo;t mean that e.g. <code>f0</code> depends directly on <code>f1</code>, but rather that the value returned by <code>f0</code>&mdash;<code>Cons(2,f1)</code>&mdash;depends on <code>f1</code>. We don&rsquo;t re-run <code>f0</code> when <code>f1</code> changes, or even update its value by proxy as we did in the previous section. But if <code>f1</code> is stale it must be updated before we can consider <code>f0</code> up-to-date.)</p> 
 
<p>Notice how the timestamp ranges for the <code>function</code> expressions are nested each within the previous one. There is a control dependency at each recursive call: whether we make a deeper call depends on whether the argument list is <code>Nil</code>.</p> 
 
<p>So if we change <code>t3</code>, just <code>f3</code> is stale. But if we change <code>t0</code>, we must re-run <code>f0</code>, <code>f1</code>, <code>f2</code>, and <code>f3</code>&mdash;that is, the whole computation&mdash;detaching all the dependencies, then reattaching them. This is kind of annoying; we do a lot of pointless work since nothing after the first element has changed.</p> 
 
<p>If only some prefix of the list has changed, we&rsquo;d like to be able to reuse the work we did in the previous run for the unchanged suffix. <code>Froc</code> addresses this need with <em>memo functions</em>. In a way similar to ordinary memoization, a memo function records a table of arguments and values when you call it. But in <code>froc</code> we only reuse values from the previous run, and only those from the timestamp range we&rsquo;re re-running. We can define <code>map</code> as a memo function:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">map</span> <span class="n">f</span> <span class="n">lst</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">memo</span> <span class="o">=</span> <span class="n">memo</span> <span class="bp">()</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="k">rec</span> <span class="n">map</span> <span class="n">lst</span> <span class="o">=</span> 
      <span class="n">lst</span> <span class="o">&gt;&gt;=</span> <span class="k">function</span> 
        <span class="o">|</span> <span class="nc">Nil</span> <span class="o">-&gt;</span> <span class="n">return</span> <span class="nc">Nil</span> 
        <span class="o">|</span> <span class="nc">Cons</span> <span class="o">(</span><span class="n">h</span><span class="o">,</span> <span class="n">t</span><span class="o">)</span> <span class="o">-&gt;</span> 
            <span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="n">memo</span> <span class="n">map</span> <span class="n">t</span> <span class="k">in</span> 
            <span class="n">return</span> <span class="o">(</span><span class="nc">Cons</span> <span class="o">(</span><span class="n">f</span> <span class="n">h</span><span class="o">,</span> <span class="n">t</span><span class="o">))</span> <span class="k">in</span> 
    <span class="n">memo</span> <span class="n">map</span> <span class="n">lst</span> 
</code></pre> 
</div> 
<p>Here the <code>memo</code> call makes a new memo table. In the initial run we add a memo entry associating each list node (<code>t0</code>, <code>t1</code>, &hellip;) with its <code>map</code> (<code>f0</code>, <code>f1</code>, &hellip;). Now, suppose we change <code>t0</code>: <code>f0</code> is stale, so we update it. When we go to compute <code>map f t1</code> we get a memo hit returning <code>f1</code> (the computation of <code>f1</code> is contained in the timestamp range of <code>f0</code>, so it is a candidate for memo matching). <code>F1</code> is up-to-date so we return it as the value of <code>map f t1</code>.</p> 
 
<p>There is a further wrinkle: suppose we change both <code>t0</code> and <code>t2</code>, leaving <code>t1</code> unchanged. As before, we get a memo hit on <code>t1</code> returning <code>f1</code>, but since <code>f2</code> is stale, so is <code>f1</code>. We must run the update queue until <code>f1</code> is up-to-date before we return it as the value of <code>map f t1</code>. Recall that we detach the dependencies of the computation we&rsquo;re re-running; in order to update <code>f1</code> we just leave it attached to its dependencies and run the queue until the end of its timestamp range.</p> 
 
<p>In general, there can be a complicated pattern of changed and unchanged data&mdash;we could change every other element in the list, for instance&mdash;so memoization and the update loop call one another recursively. From the timestamp point of view, however, we can think of it as a linear scan through time, alternating between updating stale computations and reusing ones which have not changed.</p> 
 
<p>The memo function mechanism provides a way to keep changeables attached even after the expression that attached them is re-run. We just need to attach them from within a memo function, then look them up again on the next run, so they&rsquo;re left attached to their dependencies. The <a href="http://jaked.github.com/froc/examples/froc-dom/quickhull">quickhull</a> example (<a href="http://jaked.github.com/froc/examples/froc-dom/quickhull/quickhull.ml">source</a>) demonstrates how this works.</p> 
<b>Functional reactive programming and the event queue</b> 
<p>Functional reactive programming works with two related types: <em>behavior</em>s are values that can change over time, but are defined at all times; <em>event</em>s are defined only at particular instants in time, possibly (but not necessarily) with a different value at each instant. (<em>Signal</em>s are events or behaviors when we don&rsquo;t care which one.)</p> 
 
<p>Events can be used to represent external events entering the system (like GUI clicks or keystrokes), and can also represent occurrences within the system, such as a collision between two moving objects. It is natural for events to be defined in terms of behaviors and vice versa. (In fact they can be directly interdefined with the <code>hold</code> and <code>changes</code> functions.)</p> 
 
<p>In <code>froc</code>, behaviors are just another name for changeables. Events are implemented on top of changeables: they are just changeables with transient values. An incoming event sets the value of its underlying changeable; after changes have propagated through the dependency graph, the values of all the changeables which underlie events are removed (so they can be garbage collected).</p> 
 
<p>Signals may be defined (mutually) recursively. For example, in the <a href="http://jaked.github.com/froc/examples/froc-dom/bounce">bounce</a> example (<a href="http://jaked.github.com/froc/examples/froc-dom/bounce/bounce.ml">source</a>), the position of the ball is a behavior defined in terms of its velocity, which is a behavior defined in terms of events indicating collisions with the walls and paddle, which are defined in terms of the ball&rsquo;s position.</p> 
 
<p><code>Froc</code> provides the <code>fix_b</code> and <code>fix_e</code> functions to define signals recursively. The definition of a signal can&rsquo;t refer directly to its own current value, since it hasn&rsquo;t been determined yet; instead it sees its value from the previous update cycle. When a recursively-defined signal produces a value, an event is queued to be processed in the next update cycle, so the signal can be updated based on its new current value. (If the signal doesn&rsquo;t converge somehow this process loops.)</p> 
<b>Related systems</b> 
<p><code>Froc</code> is closely related to a few other FRP systems which are change-driven and written in an imperative, call-by-value language:</p> 
 
<p><a href="http://www.cs.brown.edu/~greg/">FrTime</a> is an FRP system for PLT Scheme. FrTime has a dependency graph and update queue mechanism similar to <code>froc</code>, but sorts stale nodes in dependency (&ldquo;topological&rdquo;) rather than timestamp order. There is a separate mechanism for handling control dependencies, using a dynamic scoping feature specific to PLT Scheme (&ldquo;parameters&rdquo;) to track dependencies attached in the course of evaluating an expression; in addition FrTime uses weak pointers to collect garbage nodes. There is no equivalent of <code>froc</code>&rsquo;s memo functions. Reactivity in FrTime is implicit: you give an ordinary Scheme program, and the compiler turns each subexpression into a changeable value. There is no programmer control over the granularity of recomputation, but there is a compiler optimization (&ldquo;lowering&rdquo;) which recovers some performance by coalescing changeables.</p> 
 
<p><a href="http://www.flapjax-lang.org/">Flapjax</a> is a descendent of FrTime for Javascript. It implements the same dependency-ordered queue as FrTime, but there is no mechanism for control dependencies, and there are no weak pointers (since there are none in Javascript), so it is fairly easy to create memory leaks (although there is a special reference-counting mechanism in certain cases). Flapjax can be used as a library; it also has a compiler similar to FrTime&rsquo;s, but since it doesn&rsquo;t handle control dependencies, the semantics of compiled programs are not preserved (e.g. you can observe exceptions that don&rsquo;t occur in the original program).</p> 
 
<p><a href="http://erratique.ch/software/react">React</a> is a library for OCaml, also based on a dependency-ordered queue, using weak pointers, without a mechanism for control dependencies.</p> 
<b>Colophon</b> 
<p>I used <a href="http://mlpost.lri.fr/">Mlpost</a> to generate the dependency graph diagrams. It is very nice!</p>
