---
title: Tail call optimisation in (g)awk
description:
url: http://blog.0branch.com/posts/2016-05-13-awk-tco.html
date: 2016-05-13T11:20:00-00:00
preview_image:
featured:
authors:
- 0branch
---

<div>
  <div class="span-22">
    <div class="span-12"><h1>Tail call optimisation in (g)awk</h1></div>
    <div style="text-align: right" class="span-10 last">
      <a href="https://blog.0branch.com/index.html">#</a> May 13, 2016
    </div>
  </div>
  <hr/>
  <div>
    <p><em>or</em> &ldquo;Wait, what? Tail call optimisation in awk?&rdquo;</p>
<h1>Overview</h1>
<p>This post covers <a href="https://en.wikipedia.org/wiki/Tail_call">tail call optimisation</a> (TCO) behaviour in three common awk implementations<a href="https://blog.0branch.com/rss.xml#fn1" class="footnote-ref"><sup>1</sup></a>: <a href="https://www.gnu.org/software/gawk/">gawk</a>, <a href="http://invisible-island.net/mawk/mawk.html">mawk</a> and <a href="http://www.cs.princeton.edu/~bwk/btl.mirror/">nawk</a> (<em>AKA</em> the one true awk).</p>
<p>None of the three implement full TCO, while <code>gawk</code> alone provides self-TCO. The bulk of this post will therefore be devoted to gawk&rsquo;s implementation and related pitfalls.</p>
<h1>Initial observations</h1>
<p>Let&rsquo;s begin with a simple awk script that defines a single function, <code>recur</code>, called from the <code>BEGIN</code> block:</p>
<pre><code>$ nawk 'function recur() {return recur()} BEGIN {recur()}'
Segmentation fault: 11
$ mawk 'function recur() {return recur()} BEGIN {recur()}'
Segmentation fault: 11
$ gawk 'function recur() {return recur()} BEGIN {recur()}'
# ...runs indefinitely [?]...</code></pre>
<p>Note the difference in behaviour here: nawk and mawk blow the stack and segfault while gawk cheerily continues running. Thanks gawk.</p>
<p>But wait! Gawk is actually dynamically allocating additional stack frames&mdash;so long as there&rsquo;s memory (and swap) to consume, gawk will gobble it up and our script will plod on. Below, the first 30 seconds of (virtual) memory consumption are charted<a href="https://blog.0branch.com/rss.xml#fn2" class="footnote-ref"><sup>2</sup></a>:</p>
<p><img src="https://blog.0branch.com/images/gawk-mem-1.png" width="708" class="figure"/></p>
<p>Whoops!</p>
<h2>The gawk optimiser</h2>
<p>In order to obtain (self-)TCO and spare your poor swap partition, gawk provides the <code>-O</code> switch,</p>
<pre><code>$ gawk -O 'function foo() {return recur()} BEGIN {recur()}'
# ...runs indefinitely; air conditioning no longer required...</code></pre>
<p>and lo and behold,</p>
<p><img src="https://blog.0branch.com/images/gawk-mem-2.png" width="710" class="figure"/></p>
<h2>Doubling down</h2>
<p>What about full TCO? Let&rsquo;s expand our one liner a little to include a trampoline call:</p>
<pre><code>$ gawk -O 'function go() {return to()} function to() {return go()} BEGIN {go()}'</code></pre>
<p>and chart memory consumption again,</p>
<p><img src="https://blog.0branch.com/images/gawk-mem-3.png" width="710" class="figure"/></p>
<p>Bugger. So, it looks like gawk isn&rsquo;t keen on full blown TCO. Time to find out why.</p>
<h3>The secret sauce</h3>
<p>We&rsquo;ve just seen that gawk seems to optimise self-calls in tail position when the <code>-O</code> flag is specified. To better understand this functionality we can dump opcodes from the trampoline case and take a look under the hood:</p>
<pre><code>$ echo 'function go() {return to()} function to() {return go()} BEGIN {go()}' &gt; /tmp/trampoline.awk
$ gawk --debug -O -f /tmp/trampoline.awk
gawk&gt; dump

	# BEGIN

[     1:0x7fc00bd022e0] Op_rule             : [in_rule = BEGIN] [source_file = /tmp/trampoline.awk]
[     1:0x7fc00bd02360] Op_func_call        : [func_name = go] [arg_count = 0]
[      :0x7fc00c800f60] Op_pop              :
[      :0x7fc00c800e20] Op_no_op            :
[      :0x7fc00c800ea0] Op_atexit           :
[      :0x7fc00c800f80] Op_stop             :
[      :0x7fc00c800e60] Op_no_op            :
[      :0x7fc00bd01e00] Op_after_beginfile  :
[      :0x7fc00c800e40] Op_no_op            :
[      :0x7fc00c800e80] Op_after_endfile    :

	# Function: go ()

[     1:0x7fc00bd01f20] Op_func             : [param_cnt = 0] [source_file = /tmp/trampoline.awk]
[     1:0x7fc00bd020a0] Op_func_call        : [func_name = to] [arg_count = 0]
[     1:0x7fc00bd01fb0] Op_K_return         :
[      :0x7fc00c800ee0] Op_push_i           : Nnull_string [MALLOC|STRING|STRCUR|NUMCUR|NUMBER]
[      :0x7fc00c800f00] Op_K_return         :

	# Function: to ()

[     1:0x7fc00bd02130] Op_func             : [param_cnt = 0] [source_file = /tmp/trampoline.awk]
[     1:0x7fc00bd02270] Op_func_call        : [func_name = go] [arg_count = 0]
[     1:0x7fc00bd021f0] Op_K_return         :
[      :0x7fc00c800f20] Op_push_i           : Nnull_string [MALLOC|STRING|STRCUR|NUMCUR|NUMBER]
[      :0x7fc00c800f40] Op_K_return         :</code></pre>
<p>Note the lack of a distinct <em>jump</em> or <em>tailcall</em> opcode; instead, even with the optimiser turned on, <code>go</code> and <code>to</code> are performing <code>Op_func_call</code>s. Hmm, okay; we&rsquo;ll see a different opcode in our original <code>recur</code> case, though, right? Wrong:</p>
<pre><code>$ echo 'function recur() {return recur()} BEGIN {recur()}' &gt; /tmp/recur.awk
$ gawk --debug -O -f /tmp/recur.awk
gawk&gt; dump

	# BEGIN

[     1:0x7fc1d0408ef0] Op_rule             : [in_rule = BEGIN] [source_file = /tmp/recur.awk]
[     1:0x7fc1d0408f80] Op_func_call        : [func_name = recur] [arg_count = 0]
[      :0x7fc1d0802120] Op_pop              :
[      :0x7fc1d0802020] Op_no_op            :
[      :0x7fc1d08020a0] Op_atexit           :
[      :0x7fc1d0802140] Op_stop             :
[      :0x7fc1d0802060] Op_no_op            :
[      :0x7fc1d0408bc0] Op_after_beginfile  :
[      :0x7fc1d0802040] Op_no_op            :
[      :0x7fc1d0802080] Op_after_endfile    :

	# Function: recur ()

[     1:0x7fc1d0408ce0] Op_func             : [param_cnt = 0] [source_file = /tmp/recur.awk]
[     1:0x7fc1d0408e60] Op_func_call        : [func_name = recur] [arg_count = 0]
[     1:0x7fc1d0408d70] Op_K_return         :
[      :0x7fc1d08020e0] Op_push_i           : Nnull_string [MALLOC|STRING|STRCUR|NUMCUR|NUMBER]
[      :0x7fc1d0802100] Op_K_return         :</code></pre>
<p><tt>&macr;\_(&#12484;)_/&macr;</tt></p>
<p>Time to dig around gawk&rsquo;s grammar definition. Here&rsquo;s <code>return</code>, defined in <code>awkgram.y</code>:</p>
<div class="sourceCode"><pre class="sourceCode c"><code class="sourceCode c"><a class="sourceLine" data-line-number="1">| LEX_RETURN</a>
<a class="sourceLine" data-line-number="2">  {</a>
<a class="sourceLine" data-line-number="3">    <span class="cf">if</span> (! in_function)</a>
<a class="sourceLine" data-line-number="4">        yyerror(_(<span class="st">&quot;`return' used outside function context&quot;</span>));</a>
<a class="sourceLine" data-line-number="5">  } opt_exp statement_term {</a>
<a class="sourceLine" data-line-number="6">    <span class="cf">if</span> ($<span class="dv">3</span> == NULL) {</a>
<a class="sourceLine" data-line-number="7">        $$ = list_create($<span class="dv">1</span>);</a>
<a class="sourceLine" data-line-number="8">        (<span class="dt">void</span>) list_prepend($$, instruction(Op_push_i));</a>
<a class="sourceLine" data-line-number="9">        $$-&gt;nexti-&gt;memory = dupnode(Nnull_string);</a>
<a class="sourceLine" data-line-number="10">    } <span class="cf">else</span> {</a>
<a class="sourceLine" data-line-number="11">        <span class="cf">if</span> (do_optimize</a>
<a class="sourceLine" data-line-number="12">            &amp;&amp; $<span class="dv">3</span>-&gt;lasti-&gt;opcode == Op_func_call</a>
<a class="sourceLine" data-line-number="13">            &amp;&amp; strcmp($<span class="dv">3</span>-&gt;lasti-&gt;func_name, in_function) == <span class="dv">0</span></a>
<a class="sourceLine" data-line-number="14">        ) {</a>
<a class="sourceLine" data-line-number="15">            <span class="co">/* Do tail recursion optimization. Tail</span></a>
<a class="sourceLine" data-line-number="16"><span class="co">             * call without a return value is recognized</span></a>
<a class="sourceLine" data-line-number="17"><span class="co">             * in mk_function().</span></a>
<a class="sourceLine" data-line-number="18"><span class="co">             */</span></a>
<a class="sourceLine" data-line-number="19">            ($<span class="dv">3</span>-&gt;lasti + <span class="dv">1</span>)-&gt;tail_call = true;</a>
<a class="sourceLine" data-line-number="20">        }</a>
<a class="sourceLine" data-line-number="21"></a>
<a class="sourceLine" data-line-number="22">        $$ = list_append($<span class="dv">3</span>, $<span class="dv">1</span>);</a>
<a class="sourceLine" data-line-number="23">    }</a>
<a class="sourceLine" data-line-number="24">    $$ = add_pending_comment($$);</a>
<a class="sourceLine" data-line-number="25">  }</a></code></pre></div>
<p>Take a closer look at the code following that comment:</p>
<div class="sourceCode"><pre class="sourceCode c"><code class="sourceCode c"><a class="sourceLine" data-line-number="1"><span class="cf">if</span> (do_optimize</a>
<a class="sourceLine" data-line-number="2">  &amp;&amp; $<span class="dv">3</span>-&gt;lasti-&gt;opcode == Op_func_call</a>
<a class="sourceLine" data-line-number="3">  &amp;&amp; strcmp($<span class="dv">3</span>-&gt;lasti-&gt;func_name, in_function) == <span class="dv">0</span></a>
<a class="sourceLine" data-line-number="4">) { <span class="co">/* ... */</span></a>
<a class="sourceLine" data-line-number="5">  ($<span class="dv">3</span>-&gt;lasti + <span class="dv">1</span>)-&gt;tail_call = true; <span class="co">/* &lt;--- */</span></a>
<a class="sourceLine" data-line-number="6">}</a></code></pre></div>
<p>In other words, during a <code>return</code> gawk:</p>
<ol type="1">
<li>Checks whether the <code>do_optimize</code> flag (<code>-O</code>) is specified.</li>
<li>If so, it checks whether the previous instruction is an <code>Op_func_call</code>.</li>
<li>If that call is to a function with the same name as the current one,</li>
<li>&hellip;the <code>tail_call</code> flag is set.</li>
</ol>
<p>So it goes.</p>
<h1>At last, a conclusion</h1>
<p>Here&rsquo;re a few takeaways from the above<a href="https://blog.0branch.com/rss.xml#fn3" class="footnote-ref"><sup>3</sup></a>:</p>
<ul>
<li>Don&rsquo;t rely on TCO if you&rsquo;re writing awk.</li>
<li>Just don&rsquo;t.</li>
<li>If you <em>do</em> need TCO, make sure you&rsquo;re using gawk
<ul>
<li>Be sure to specify the <code>-O</code> flag otherwise you&rsquo;ll need to buy a new fan,</li>
<li>and make sure you&rsquo;re not trampolining as the optimiser won&rsquo;t be of any help.</li>
</ul></li>
</ul>
<p>Personally, I&rsquo;ll be sticking with nawk.</p>
<section class="footnotes">
<hr/>
<ol>
<li><p>Probably the most common.<a href="https://blog.0branch.com/rss.xml#fnref1" class="footnote-back">&#8617;</a></p></li>
<li><p>Output drawn from <code>ps</code><a href="https://blog.0branch.com/rss.xml#fnref2" class="footnote-back">&#8617;</a></p></li>
<li><p>YMMV<a href="https://blog.0branch.com/rss.xml#fnref3" class="footnote-back">&#8617;</a></p></li>
</ol>
</section>
  </div>
</div>

<hr/>

<div></div>

<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>

