---
title: "An in-depth Look at OCaml\u2019s new \u201CBest-fit\u201D Garbage Collector
  Strategy"
description: "An in-depth Look at OCaml\u2019s new \"Best-fit\" Garbage Collector
  Strategy The Garbage Collector probably is OCaml\u2019s greatest unsung hero. Its
  pragmatic approach allows us to allocate without much fear of efficiency loss. In
  a way, the fact that most OCaml hackers know little about it is a good sign:..."
url: https://ocamlpro.com/blog/2020_03_23_in_depth_look_at_best_fit_gc
date: 2020-03-23T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Thomas Blanc\n  "
source:
---

<p><a href="https://ocamlpro.com/blog/2020_03_23_in_depth_look_at_best_fit_gc"><img src="https://ocamlpro.com/blog/assets/img/logo_round_ocaml_search.png" alt="An in-depth Look at OCaml&rsquo;s new &quot;Best-fit&quot; Garbage Collector Strategy"/></a></p>
<p>The Garbage Collector probably is OCaml&rsquo;s greatest unsung hero. Its pragmatic approach allows us to allocate without much fear of efficiency loss. In a way, the fact that most OCaml hackers know little about it is a good sign: you want a runtime to gracefully do its job without having to mind it all the time.</p>
<p>But as OCaml 4.10.0 has now hit the shelves, a very exciting feature is <a href="https://ocaml.org/releases/4.10.0.html#Changes">in the changelog</a>:</p>
<blockquote>
<p>#8809, #9292: Add a best-fit allocator for the major heap; still experimental, it should be much better than current allocation policies (first-fit and next-fit) for programs with large heaps, reducing both GC cost and memory usage.
This new best-fit is not (yet) the default; set it explicitly with OCAMLRUNPARAM=&quot;a=2&quot; (or Gc.set from the program). You may also want to increase the <code>space_overhead</code> parameter of the GC (a percentage, 80 by default), for example OCAMLRUNPARAM=&quot;o=85&quot;, for optimal speed.
(Damien Doligez, review by Stephen Dolan, Jacques-Henri Jourdan, Xavier Leroy, Leo White)</p>
</blockquote>
<p>At OCamlPro, some of the tools that we develop, such as the package manager <a href="https://opam.ocaml.org/">opam</a>, the <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a> SMT solver or the Flambda optimizer, can be quite demanding in memory usage, so we were curious to better understand the properties of this new allocator.</p>
<h2>Minor heap and Major heap: the GC in a nutshell</h2>
<p>Not all values are allocated equal. Some will only be useful for the span of local calculations, some will last as long as the program lives. To handle those two kinds of values, the runtime uses a <em>Generational Garbage Collector</em> with two spaces:</p>
<ul>
<li>The minor heap uses the <a href="https://en.wikipedia.org/wiki/Tracing_garbage_collection#Copying_vs._mark-and-sweep_vs._mark-and-don.27t-sweep">Stop-and-copy</a> principle. It is fast but has to stop the computation to perform a full iteration.
</li>
<li>The major heap uses the <a href="https://en.wikipedia.org/wiki/Tracing_garbage_collection#Na%C3%AFve_mark-and-sweep">Mark-and-sweep</a> principle. It has the perk of being incremental and behaves better for long-lived data.
</li>
</ul>
<p>Allocation in the minor heap is straightforward and efficient: values are stored sequentially, and when there is no space anymore, space is emptied, surviving values get allocated in the major heap while dead values are just forgotten for free. However, the major heap is a bit more tricky, since we will have random allocations and deallocations that will eventually produce a scattered memory. This is called <a href="https://en.wikipedia.org/wiki/Fragmentation_(computing)">fragmentation</a>, and this means that you&rsquo;re using more memory than necessary. Thankfully, the GC has two strategies to counter that problem:</p>
<ul>
<li>Compaction: a heavyweight reallocation of everything that will remove those holes in our heap. OCaml&rsquo;s compactor is cleverly written to work in constant space, and would be worth its own specific article!
</li>
<li>Free-list Allocation: allocating the newly coming data in the holes (the free-list) in memory, de-scattering it in the process.
</li>
</ul>
<p>Of course, asking the GC to be smarter about how it allocates data makes the GC slower. Coding a good GC is a subtle art: you need to have something smart enough to avoid fragmentation but simple enough to run as fast as possible.</p>
<h2>Where and how to allocate: the 3 strategies</h2>
<p>OCaml used to propose 2 free-list allocation strategies: <em>next-fit</em>, the default, and <em>first-fit</em>. Version 4.10 of OCaml introduces the new <em>best-fit</em> strategy. Let&rsquo;s compare them:</p>
<h3>Next-fit, the original and remaining champion</h3>
<p>OCaml&rsquo;s original (and default) &ldquo;next-fit&rdquo; allocating strategy is pretty simple:</p>
<ol>
<li>Keep a (circular) list of every hole in memory ordered by increasing addresses;
</li>
<li>Have a pointer on an element of that list;
</li>
<li>When an allocation is needed, if the currently pointed-at hole is big enough, allocate in it;
</li>
<li>Otherwise, try the next hole and so-on.
</li>
</ol>
<p>This strategy is extremely efficient, but a big hole might be fragmented with very small data while small holes stay unused. In some cases, the GC would trigger costly compactions that would have been avoidable.</p>
<h3>First-fit, the unsuccessful contender</h3>
<p>To counteract that problem, the &ldquo;first-fit&rdquo; strategy was implemented in 2008 (OCaml 3.11.0):</p>
<ul>
<li>Same idea as next-fit, but with an extra allocation table.
</li>
<li>Put the pointer back at the beginning of the list for each allocation.
</li>
<li>Use the allocation table to skip some parts of the list.
</li>
</ul>
<p>Unfortunately, that strategy is slower than the previous one. This is an example of making the GC smarter ends up making it slower. It does, however, reduce fragmentation. It was still useful to have this strategy at hand for the case where compaction would be too costly (on a 100Gb heap, for instance). An application that requires low latency might want to disable compaction and use that strategy.</p>
<h3>Best-fit: a new challenger enters!</h3>
<p>This leads us to the brand new &ldquo;best-fit&rdquo; strategy. This strategy is actually composite and will have different behaviors depending on the size of the data you&rsquo;re trying to allocate.</p>
<ul>
<li>On small data (up to 32 words), <a href="https://github.com/ocaml/ocaml/blob/trunk/runtime/freelist.c#L868">segregated free lists</a> will allow allocation in (mostly) constant time.
</li>
<li>On big data, a general best-fit allocator based on <a href="https://en.wikipedia.org/wiki/Splay_tree">splay trees</a>.
</li>
</ul>
<p>This allows for the best of the two worlds, as you can easily allocate your numerous small blocks in the small holes in your memory while you take a bit more time to select a good place for your big arrays.</p>
<p>How will best-fit fare? Let&rsquo;s find out!</p>
<h2>Try it!</h2>
<p>First, let us remind you that this is still an experimental feature, which from the OCaml development team means &ldquo;We&rsquo;ve tested it thoroughly on different systems, but only for months and not on a scale as large as the whole OCaml ecosystem&rdquo;.</p>
<p>That being said, we&rsquo;d advise you don&rsquo;t use it in production code yet.</p>
<h3>Why you should try it</h3>
<p>Making benchmarks of this new strategy could be beneficial for you and the language at large: the dev team is hoping for feedback, the more quality feedback <strong>you</strong> give means the more the future GC will be tuned for your needs.</p>
<p>In 2008, the first-fit strategy was released with the hope of improving memory usage by reducing fragmentation. However, the lack of feedback meant that the developers were not aware that it didn&rsquo;t meet the users&rsquo; needs. If more feedback had been given, it&rsquo;s possible that work on improving the strategy or on better strategies would have happened sooner.</p>
<h3>Choosing the allocator strategy</h3>
<p>Now, there are two ways to control the GC behavior: through the code or through environment variables.</p>
<h4>First method: Adding instructions in your code</h4>
<p>This method should be used by those of us who have code that already does some GC fine-tuning. As early as possible in your program, you want to execute the following lines:</p>
<pre><code class="language-Ocaml">let () =
Gc.(set
  { (get()) with
    allocation_policy = 2; (* Use the best-fit strategy *)
    space_overhead = 100; (* Let the major GC work a bit less since it's more efficient *)
  })
</code></pre>
<p>You might also want to add <code>verbose = 0x400;</code> or <code>verbose = 0x404;</code> in order to get some GC debug information. See <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Gc.html">here</a> for more details on how to use the <code>GC</code> module.</p>
<p>Of course, you&rsquo;ll need to recompile your code, and this will apply only after the runtime has initialized itself, triggering a compaction in the process. Also, since you might want to easily switch between different allocation policies and overhead specifications, we suggest you use the second method.</p>
<h4>Second method: setting <code>$OCAMLRUNPARAM</code></h4>
<p>At OCamlPro, we develop and maintain a program that any OCaml developer should want to run smoothly. It&rsquo;s called <a href="https://opam.ocaml.org/">Opam</a>, maybe you&rsquo;ve heard of it? Though most commands take a few seconds, some <a href="https://opam.ocaml.org/doc/man/opam-admin-check.html">administrative-heavy</a> commands can be a strain on our computer. In other words: those are perfect for a benchmark.</p>
<p>Here&rsquo;s what we did to benchmark Opam:</p>
<pre><code class="language-shell-session">$ opam update
$ opam switch create 4.10.0
$ opam install opam-devel # or build your own code
$ export OCAMLRUNPARAM='b=1,a=2,o=100,v=0x404'
$ cd my/local/opam-repository
$ perf stat ~/.opam/4.10.0/lib/opam-devel/opam admin check --installability # requires right to execute perf, time can do the trick
</code></pre>
<p>If you want to compile and run your own benchmarks, here are a few details on <code>OCAMLRUNPARAM</code>:</p>
<ul>
<li><code>b=1</code> means &ldquo;print the backtrace in case of uncaught exception&rdquo;
</li>
<li><code>a=2</code> means &ldquo;use best-fit&rdquo; (default is <code>0</code> , first-fit is <code>1</code>)
</li>
<li><code>o=100</code> means &ldquo;do less work&rdquo; (default is <code>80</code>, lower means more work)
</li>
<li><code>v=0x404</code> means &ldquo;have the gc be verbose&rdquo; (<code>0x400</code> is &ldquo;print statistics at exit&rdquo;, 0x4 is &ldquo;print when changing heap size&rdquo;)
</li>
</ul>
<p>See the <a href="https://caml.inria.fr/pub/docs/manual-ocaml/runtime.html#s:ocamlrun-options">manual</a> for more details on <code>OCAMLRUNPARAM</code></p>
<p>You might want to compare how your code fares on all three different GC strategies (and fiddle a bit with the overhead to find your best configuration).</p>
<h2>Our results on opam</h2>
<p>Our contribution in this article is to benchmark <code>opam</code> with the different allocation strategies:</p>
<figure><table><thead><tr><td>Strategy:</td><td>Next-fit</td><td>First-fit</td><td colspan="3" scope="colgroup">Best-fit</td></tr><tr><td>Overhead:</td><td>80</td><td>80</td><td>80</td><td>100</td><td>120</td></tr><tr><td>Cycles used (Gcycle)</td><td>2,040</td><td>3,808</td><td>3,372</td><td>2,851</td><td>2,428</td></tr><tr><td>Maximum heap size (kb)</td><td>793,148</td><td>793,148</td><td>689,692</td><td>689,692</td><td>793,148</td></tr><tr><td>User time (s)</td><td>674</td><td>1,350</td><td>1,217</td><td>1,016</td><td>791</td></tr></thead></table></figure>
<p>A quick word on these results. Most of <code>opam</code>&lsquo;s calculations are done by <a href="http://www.mancoosi.org/software/">dose</a> and rely heavily on small interconnected blocks. We don&rsquo;t really have big chunks of data we want to allocate, so the strategy won&rsquo;t give us the bonus you might have as it perfectly falls into the best-case scenario of the next-fit strategy. As a matter of fact, for every strategy, we didn&rsquo;t have a single GC compaction happen. However, Best-fit still allows for a lower memory footprint!</p>
<h2>Conclusions</h2>
<p>If your software is highly reliant on memory usage, you should definitely try the new Best-fit strategy and stay tuned on its future development. If your software requires good performance, knowing if your performances are better with Best-fit (and giving feedback on those) might help you in the long run.</p>
<p>The different strategies are:</p>
<ul>
<li>Next-fit: generally good and fast, but has very bad worst cases with big heaps.
</li>
<li>First fit: mainly useful for very big heaps that must avoid compaction as much as possible.
</li>
<li>Best-fit: almost the best of both worlds, with a small performance hit for programs that fit well with next-fit.
</li>
</ul>
<p>Remember that whatever works best for you, it&rsquo;s still better than having to <code>malloc</code> and <code>free</code> by hand. Happy allocating!</p>
<h1>Comments</h1>
<p>gasche (23 March 2020 at 17 h 50 min):</p>
<blockquote>
<p>What about higher overhead values than 120, like 140, 160, 180 and 200?</p>
</blockquote>
<p>Thomas Blanc (23 March 2020 at 18 h 17 min):</p>
<blockquote>
<p>Because 100 was the overhead value Leo advised in the PR discussion I decided to put it in the results. As 120 got the same maximum heap size as next-fit I found it worth putting it in. Higher overhead values lead to faster execution time but a bigger heap.</p>
<p>I don&rsquo;t have my numbers at hand right now. You&rsquo;re probably right that they are relevant (to you and Damien at least) but I didn&rsquo;t want to have a huge table at the end of the post.</p>
</blockquote>
<p>nbbb (24 March 2020 at 11 h 18 min):</p>
<blockquote>
<p>Higher values would allow us to see if best-fit can reproduce the performance characteristics of next-fit, for some value of the overhead.</p>
</blockquote>
<p>nbbb (24 March 2020 at 16 h 51 min):</p>
<blockquote>
<p>I just realized that 120 already has a heap as bit as next-fit &mdash; so best-fit can&rsquo;t get as good as next-fit in this example, and higher values of the overhead are not quite as informative. Should have read more closely the first time.</p>
</blockquote>
<p>Thomas Blanc (24 March 2020 at 16 h 55 min):</p>
<blockquote>
<p>Sorry that it wasn&rsquo;t as clear as it could be.</p>
<p>Note that opam and dose are in the best-case scenario of best-fit. Your own code would probably produce a different result and I encourage you to test it and communicate about it.</p>
</blockquote>

