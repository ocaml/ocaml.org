---
title: Profiling the stack
description:
url: https://kcsrk.info/ocaml/profiling/2015/10/27/profiling-the-stack/
date: 2015-10-27T17:29:30-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>In the <a href="http://kcsrk.info/ocaml/profiling/2015/09/23/bytecode-allocation-profiler/">last
post</a>,
I described a <em>flat</em> allocation profiler for OCaml 4.02 bytecode interpreter.
In this post, I&rsquo;ll describe further developments which add support for call
stack information and better location information. Lets dive straight to the
usage:</p>



<h1>Enabling stack profiling</h1>

<p>Stack profiling is enabled by setting the environment variable
<code class="language-plaintext highlighter-rouge">CAML_PROFILE_STACK</code> to the intended depth of stack. Suppose we would like to
attribute any allocation to the current function, we would set
<code class="language-plaintext highlighter-rouge">CAML_PROFILE_STACK=1</code>. To do the same to the current function and its caller,
we would set <code class="language-plaintext highlighter-rouge">CAML_PROFILE_STACK=2</code>. <code class="language-plaintext highlighter-rouge">CAML_PROFILE_STACK=&lt;INFINITY&gt;</code> should
give you stack profile all the way down to the first function.</p>

<h2>Why should I care about the stack depth?</h2>

<p>Because it affects the program performance. Enabling stack profiling walks the
stack for <strong>every</strong> allocation. This has the potential to severely affect the
program performance. Most often, with a flat profile, you&rsquo;ve tracked the
offending allocation to some function in the standard library such as<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup>:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">File <span class="s2">&quot;bytes.ml&quot;</span>, line 59, characters 7-81:
  C_CALL1 caml_create_string

File <span class="s2">&quot;src/bigstring.ml&quot;</span>, line 98, characters 20-37:
  C_CALL1 caml_create_string</code></pre></figure>

<p>And all you want is to find out the caller of that standard library function in
your code. A stack depth of a small number should provide you this information.
You might have to play around with the stack depth to identify what you are
looking for.</p>

<h1>Profiling N-queens</h1>

<p>You can obtain and install the profiling enabled OCaml 4.02
<a href="http://kcsrk.info/ocaml/profiling/2015/09/23/bytecode-allocation-profiler/#instructions">here</a>.
Let us obtain the flat profile first.</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>wget http://caml.inria.fr/pub/old_caml_site/Examples/oc/basics/queens.ml
<span class="nv">$ </span>ocamlc <span class="nt">-o</span> queens <span class="nt">-g</span> queens.ml
<span class="nv">$ CAML_PROFILE_ALLOC</span><span class="o">=</span>queens.preprof ./queens
Chess boards<span class="s1">'s size ? 8
The 8 queens problem has 92 solutions.

Do you want to see the solutions &lt;n/y&gt; ? n
$ ./tools/allocprof queens.preprof queens.prof
$ head -n10 queens.prof
Total: 77,863 words
Instr   Words   % of total      Location
-----   -----   ----------      --------
2488    31440   40.38%          file &quot;list.ml&quot;, line 55, characters 32-39
27681   31440   40.38%          file &quot;queens.ml&quot;, line 61, characters 46-52
27775   5895    7.57%           file &quot;queens.ml&quot;, line 38, characters 2-113
27759   4112    5.28%           file &quot;queens.ml&quot;, line 40, characters 33-41
27687   3930    5.05%           file &quot;queens.ml&quot;, line 61, characters 14-59
2403    86      0.11%           file &quot;pervasives.ml&quot;, line 490, characters 8-63
5391    44      0.06%           file &quot;list.ml&quot;, line 20, characters 15-29</span></code></pre></figure>

<p>Observe that we now have the precise location information directly in the
profile, whereas
<a href="http://kcsrk.info/ocaml/profiling/2015/09/23/bytecode-allocation-profiler">earlier</a>
one had to manually identify the source location using the instruction
information. In this profile, we see that most allocations were in
<code class="language-plaintext highlighter-rouge">list.ml:55</code>, which is the <code class="language-plaintext highlighter-rouge">List.map</code> function. However, we cannot pin down the
source of these allocations in <code class="language-plaintext highlighter-rouge">queens.ml</code> from this profile since the profile
is flat. Let us now obtain the stack allocation profile, which will reveal the
source of these allocations in <code class="language-plaintext highlighter-rouge">queens.ml</code>.</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ CAML_PROFILE_ALLOC</span><span class="o">=</span>queens.preprof <span class="nv">CAML_PROFILE_STACK</span><span class="o">=</span>10000 ./queens
Chess boards<span class="s1">'s size ? 8
The 8 queens problem has 92 solutions.

Do you want to see the solutions &lt;n/y&gt; ? n
$ ./tools/allocprof queens.preprof queens.prof --sort-stack
$ head -n10 queens.prof
Total: 77,863 words
Instr   Current Cur %   Stack   Stack % Location
-----   ------- -----   -----   ------- --------
27836   0       0.00%   76911   98.78%  file &quot;queens.ml&quot;, line 100, characters 33-42
27549   0       0.00%   76870   98.72%  file &quot;queens.ml&quot;, line 85, characters 17-36
27466   0       0.00%   76473   98.21%  file &quot;queens.ml&quot;, line 45, characters 18-31
27715   0       0.00%   65117   83.63%  file &quot;queens.ml&quot;, line 62, characters 4-22
27694   0       0.00%   62880   80.76%  file &quot;queens.ml&quot;, line 61, characters 31-59
2487    0       0.00%   55020   70.66%  file &quot;list.ml&quot;, line 55, characters 32-39
2483    0       0.00%   31440   40.38%  file &quot;list.ml&quot;, line 55, characters 20-23</span></code></pre></figure>

<p>I&rsquo;ve chosen a stack depth of 10000 to obtain the complete stack profile of the
program. The option <code class="language-plaintext highlighter-rouge">--sort-stack</code> to <code class="language-plaintext highlighter-rouge">allocprof</code> sorts the results based on
the stack allocation profile. We can now clearly see the stack of functions
that perform most allocations. The line</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">27836   0       0.00%   76911   98.78%  file <span class="s2">&quot;queens.ml&quot;</span>, line 100, characters 33-42</code></pre></figure>

<p>says that 98.78% of all allocations were performed by the function at
<code class="language-plaintext highlighter-rouge">queens.ml:100</code>, characters 33-42, and its callees. This isn&rsquo;t surprising since
this function is the top-level <a href="https://github.com/kayceesrk/code-snippets/blob/master/queens.ml#L100"><code class="language-plaintext highlighter-rouge">main</code>
function</a>!
More interesting is the 98.21% of allocations on <code class="language-plaintext highlighter-rouge">queens.ml:45</code>. This is the
recursive call to the <a href="https://github.com/kayceesrk/code-snippets/blob/master/queens.ml#L43"><code class="language-plaintext highlighter-rouge">concmap</code>
function</a>,
which in turn invokes the <code class="language-plaintext highlighter-rouge">List.map</code> function on <code class="language-plaintext highlighter-rouge">queens.ml:61</code>. We&rsquo;ve now
pinned down the source of the allocation in <code class="language-plaintext highlighter-rouge">list.ml:55</code> to <code class="language-plaintext highlighter-rouge">queens.ml:61</code>.</p>

<h1>Caveats and conclusions</h1>

<p>Unlike stack profiles of C programs, OCaml&rsquo;s stack profile does not include all
the functions in the call stack since many calls are in tail positions. Calls
to functions at tail position will not have a frame on the stack, and hence
will not be included in the profile.</p>

<p>Please do submit issues and bug-fixes. Pull-requests are welcome! Also, here is
my trimmed down (yay \o/!), non-exhaustive wish list of features:</p>

<ul>
  <li>Dump the profile every few milliseconds to study the allocation behavior of
programs over time.</li>
  <li>Save the <a href="https://ocaml.org/meetings/ocaml/2013/proposals/profiling-memory.pdf">location information in the object
header</a>
and dump the heap at every GC to catch space leaks.</li>
</ul>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>Thanks to <a href="https://github.com/trevorsummerssmith">trevorsummerssmith</a> for the example.&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
  </ol>
</div>

