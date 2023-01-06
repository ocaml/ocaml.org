---
title: OCaml 5 Multicore Testing Tools
description: "The new version of OCaml 5 is here! It brings the ability to program
  multicore applications and to maximise our usage of all the CPU cores\u2026"
url: https://tarides.com/blog/2022-12-22-ocaml-5-multicore-testing-tools
date: 2022-12-22T00:00:00-00:00
preview_image: https://tarides.com/static/982dc8891224a366db621bea7a32ad66/309a6/MC_testing.jpg
featured:
---

<p>The new version of OCaml 5 is here! It brings the ability to program multicore applications and to maximise our usage of all the CPU cores without a global lock getting in the way of performance. What's most exciting to me though is that we have a whole new way of writing... bugs!</p>
<p>And with so much potential for mistakes comes a new era of testing tools to help us write correct applications:</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#memory-model" aria-label="memory model permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Memory Model</h2>
<p>The first of those is the <a href="https://kcsrk.info/webman/manual/memorymodel.html"><em>memory model</em> of OCaml 5</a>. If you already know what those two words mean, please skip this part because I won't pretend that I do. (I'm still convinced that it's just some fancy legalese terms to confuse people.) But it may actually matter when you realise that you've been living in a fantasy your whole CPU life:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">left <span class="token operator">:=</span> <span class="token number">42</span> <span class="token punctuation">;</span>
right <span class="token operator">:=</span> <span class="token number">0</span> <span class="token punctuation">;</span></code></pre></div>
<p>When I read these two lines, I have years of beliefs telling me that the reference <code>left</code> will be updated before the <code>right</code> one is. But modern compilers and hardware conspire to break any sanity that may exist in my brain. You see, the order of operations doesn't actually matter <em>if</em> you can't see that the CPU is doing things in another order. It may just happen that the compiler or CPU will choose to do those two operations in reverse if they think it would be more convenient. And without this, our software would be so much slower that <em>&quot;instructions are executed in order&quot;</em> is an essential lie. (Well, is it even a lie if it makes no difference?)</p>
<p>To catch a liar, you need a second observer to correlate their claims. This is exactly what the other CPU cores will do. The bad news is that they are not actively looking for bad behavior from their colleagues, but they will end up reading values that aren't quite written in the order expected. This will wreak havoc into your invariants and trigger very, very weird bugs.</p>
<p>I'm not kidding when I say &quot;very, very weird.&quot; Below is a real example of an out-of-order read/write that happened on my computer. This was a very simple program, with only two references, <code>left</code> and <code>right</code>, that got updated by two different domains (shown as two branches here):</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">                          !left    = 42
                          !right   = 0
                                 |
              .------------------------------------.
              |                                    |
              |                               left  := 1
              |                               right := 2
         right := 3                                |
        !left        = 42                    !right       = 3
                      ^^^^
                      how?</code></pre></div>
<p>I tried to align the sequence of operations according to the observed memory values, but no ordering actually made sense. We can't have both <code>!left = 42</code> and <code>!right = 3</code> in the end.</p>
<p>Here's another attempt to align the instructions in a coherent way:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">                          !left    = 42
                          !right   = 0
                                 |
              .------------------------------------.
              |                                    |
         right := 3                                |
        !left        = 42                          |
                                              left  := 1
                                              right := 2
                                             !right       = 3
                                                          ^^^^
                                                          how?</code></pre></div>
<p>It already requires some time to unpack this short example, but imagine how bad it would get to debug such a thing in production!</p>
<p>I want to stress that this specific execution wasn't the result of a compiler optimisation that we could have discovered by reading the assembly code. The program was running just fine over many iterations before being disturbed by a sudden hardware optimisation. The probability of observing this behavior from your CPU is very low---not low enough that you can ignore it, but you won't be able to reproduce this exact bug in any reasonable time. (But we'll see how to catch our CPU cores red-handed in the following sections!)</p>
<p>But ok, wait---come again. How is any of this nonsense a good memory model? For starters, the values you can read &quot;out-of-order&quot; are still real values that have been assigned to the references, not imaginary ones. Yes, it could be even weirder, but you don't want to know. It's all fun and games with integers, but this property really matters for pointers (where following the wrong one would lead you down a segmentation fault). You need to be wary of this in other languages, but not in OCaml. Memory safety is preserved. It's not an instant <em>Game Over</em> to do an accidental out-of-order read.</p>
<p>Secondly, when reading and writing to shared memory, you should use the new <code>Atomic</code> module to ensure the proper memory ordering of operations. This will introduce the required memory barriers to bring back sanity---at a small performance cost---so it's opt-in and only required for shared memory! (Note: you can also use a <code>Mutex</code> lock to protect your read/write into shared memory.)</p>
<p>In technical words, OCaml 5 programs enjoy the <em>&quot;Sequential Consistency for Data Race Freedom (DRF-SC)&quot;</em> property. If your program has no data races, then you can reason about your code under sequential consistency where the operations from different threads are interleaved with each other, but the instructions don't seem to be executed out of order.</p>
<p><a href="https://kcsrk.info/webman/manual/memorymodel.html">Read more about the memory model in the OCaml 5 manual</a></p>
<p>By using <code>Atomic</code>, we are back in the wonderful land where operations happen in the expected order! The memory model becomes a tool for your brain, enabling it to reason about your algorithms. This one is so intuitive that I can once again pretend that it doesn't exist (without getting hit by an unexpected bug later.)</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#threadsanitizer" aria-label="threadsanitizer permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>ThreadSanitizer</h2>
<p>Alright, so how do we check that our programs aren't susceptible to an &quot;out-of-order&quot; bug caused by a missing <code>Atomic</code> or <code>Mutex</code>? ThreadSanitizer was created by Google as a lightweight instrumentation to discover these runtime data races.</p>
<p>To enable it on your OCaml program, you&rsquo;ll need a special compiler that adds the required instrumentation to your software. Don't worry, it&rsquo;s super easy to setup thanks to opam switches!</p>
<p><a href="https://github.com/ocaml-multicore/ocaml-tsan">Install and usage informations on the <code>ocaml-tsan</code> repository</a></p>
<p>As a running example to demonstrate the usefulness of each tool, let's look at different implementations of simple banking accounts, where users can transfer money to each other <em>if</em> they have enough money in their account:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> Bank <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> int array

  <span class="token keyword">let</span> transfer t from_account to_account money <span class="token operator">=</span>
    <span class="token keyword">if</span> money <span class="token operator">&gt;</span> <span class="token number">0</span>                     <span class="token comment">(* no negative transfer! *)</span>
    <span class="token operator">&amp;&amp;</span> from_account <span class="token operator">&lt;&gt;</span> to_account    <span class="token comment">(* or transfer to self! *)</span>
    <span class="token operator">&amp;&amp;</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>from_account<span class="token punctuation">)</span> <span class="token operator">&gt;=</span> money     <span class="token comment">(* and you must have enough money! *)</span>
    <span class="token keyword">then</span> <span class="token keyword">begin</span>
      t<span class="token punctuation">.</span><span class="token punctuation">(</span>from_account<span class="token punctuation">)</span> <span class="token operator">&lt;-</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>from_account<span class="token punctuation">)</span> <span class="token operator">-</span> money <span class="token punctuation">;</span>
      t<span class="token punctuation">.</span><span class="token punctuation">(</span>to_account<span class="token punctuation">)</span>   <span class="token operator">&lt;-</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>to_account<span class="token punctuation">)</span>   <span class="token operator">+</span> money <span class="token punctuation">;</span>
    <span class="token keyword">end</span>
<span class="token keyword">end</span></code></pre></div>
<p>This module could be part of a much larger program that receives transaction requests from the network and handles them. For simplicity here, we'll only be running a small simulation, but ThreadSanitizer is intended to be used on large real programs with messy I/O and side effects, not just broken toys and unit tests.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> t <span class="token punctuation">:</span> Bank<span class="token punctuation">.</span>t <span class="token operator">=</span> Array<span class="token punctuation">.</span>make <span class="token number">8</span> <span class="token number">100</span>  <span class="token comment">(* 8 accounts with $100 each *)</span>

<span class="token keyword">let</span> money_shuffle <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token comment">(* simulate an economy *)</span>
  <span class="token keyword">for</span> <span class="token punctuation">_</span> <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token number">10</span> <span class="token keyword">do</span>
    Unix<span class="token punctuation">.</span>sleepf <span class="token number">0.1</span> <span class="token punctuation">;</span> <span class="token comment">(* wait for a network request *)</span>
    Bank<span class="token punctuation">.</span>transfer t <span class="token punctuation">(</span>Random<span class="token punctuation">.</span>int <span class="token number">8</span><span class="token punctuation">)</span> <span class="token punctuation">(</span>Random<span class="token punctuation">.</span>int <span class="token number">8</span><span class="token punctuation">)</span> <span class="token number">1</span> <span class="token punctuation">;</span> <span class="token comment">(* transfer $1 *)</span>
  <span class="token keyword">done</span>

<span class="token keyword">let</span> account_balances <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token comment">(* inspect the bank accounts *)</span>
  <span class="token keyword">for</span> <span class="token punctuation">_</span> <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token number">10</span> <span class="token keyword">do</span>
    Array<span class="token punctuation">.</span>iter <span class="token punctuation">(</span>Format<span class="token punctuation">.</span>printf <span class="token string">&quot;%i &quot;</span><span class="token punctuation">)</span> t <span class="token punctuation">;</span> Format<span class="token punctuation">.</span>printf <span class="token string">&quot;@.&quot;</span> <span class="token punctuation">;</span>
    Unix<span class="token punctuation">.</span>sleepf <span class="token number">0.1</span> <span class="token punctuation">;</span>
  <span class="token keyword">done</span>

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token comment">(* run the simulation and the debug view in parallel *)</span>
  <span class="token operator-like-punctuation punctuation">[|</span> Domain<span class="token punctuation">.</span>spawn money_shuffle <span class="token punctuation">;</span> Domain<span class="token punctuation">.</span>spawn account_balances <span class="token operator-like-punctuation punctuation">|]</span> 
  <span class="token operator">|&gt;</span> Array<span class="token punctuation">.</span>iter Domain<span class="token punctuation">.</span>join</code></pre></div>
<p>It should be pretty clear that our code is not thread-safe and that transferring money while printing the account balances is asking for trouble! Running it with ThreadSanitizer enabled will print warnings into the terminal as soon as a potential data-race is observed (and it's even better in real life as the output is colorful!):</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">WARNING: ThreadSanitizer: data race (pid=1178477)
  Write of size 8 at 0x7fc4936fd6b0 by thread T4 (mutexes: write M87):
    #0 camlDune__exe__V0.transfer_317 &lt;null&gt; (v0.exe+0x6ae1a)
    #1 camlDune__exe__V0.money_shuffle_325 &lt;null&gt; (v0.exe+0x6af8d)
    .. ...

  Previous read of size 8 at 0x7fc4936fd6b0 by thread T1 (mutexes: write M83):
    #0 camlStdlib__Array.iter_329 &lt;null&gt; (v0.exe+0x9c675)
    #1 camlDune__exe__V0.account_balances_563 &lt;null&gt; (v0.exe+0x6b054)
    .. ...</code></pre></div>
<p>The issue is reported very clearly thanks to the two conflicting stacktraces. There's a read/write data-race happening between the <code>money_shuffle</code> execution and the <code>account_balances</code> one, which could result in unreasonable memory reordering artifacts. In fact, it would be even worse if we were to <code>transfer</code> money from multiple domains in parallel (which we'll attempt to do in the next section as an interesting way of speeding up our bank transactions with Multicore).</p>
<p>It looks like we can fix the read/write data-race by adding a <code>Mutex</code> lock around the <code>transfer</code> function <em>write</em> operations:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> lock <span class="token operator">=</span> Mutex<span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> transfer t from_account to_account money <span class="token operator">=</span>
  Mutex<span class="token punctuation">.</span>lock lock <span class="token punctuation">;</span>
  <span class="token comment">(* ... same as before ... *)</span>
  Mutex<span class="token punctuation">.</span>unlock lock</code></pre></div>
<p>But ThreadSanitizer is not easily fooled and will still complain loudly. We also need to use the same <code>Mutex</code> to protect the array reads in the <code>account_balances</code> function, as it would otherwise be perfectly valid to optimise away the shared memory reads into oblivion:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> account_balances_optimized <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token comment">(* faster... but wrong-er! *)</span>
  <span class="token keyword">let</span> str <span class="token operator">=</span> String<span class="token punctuation">.</span>concat <span class="token string">&quot; &quot;</span> <span class="token operator">@@</span> Array<span class="token punctuation">.</span>of_list <span class="token operator">@@</span> Array<span class="token punctuation">.</span>map string_of_int t <span class="token keyword">in</span>
  <span class="token keyword">for</span> <span class="token punctuation">_</span> <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token number">10</span> <span class="token keyword">do</span>
    Format<span class="token punctuation">.</span>printf <span class="token string">&quot;%s @.&quot;</span> str <span class="token punctuation">;</span>
    Unix<span class="token punctuation">.</span>sleepf <span class="token number">0.1</span> <span class="token punctuation">;</span>
  <span class="token keyword">done</span></code></pre></div>
<p>The data races reported by ThreadSanitizer are not only the ones where an absurd &ldquo;out-of-order&rdquo; happened, but preemptively, all those that could potentially trigger such a problem. If you are porting an existing multi-threaded application to OCaml 5, this compiler variant should probably be your default debug build.</p>
<p>Note that the ThreadSanitizer instrumentation does add a performance cost and doesn't increase memory safety by itself. Run it for a bit, track down your shared memory misuses, and add the required <code>Atomic</code> and <code>Mutex</code> operations.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#multicore-tests-lin-and-stm" aria-label="multicore tests lin and stm permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Multicore Tests: <code>Lin</code> (and <code>STM</code>)</h2>
<p>How do we unit test our Multicore libraries? It's business as usual, and the standard Alcotest will do well, for example. But there are some new properties that we should look for when writing and using libraries in a multicore setting. Let's revisit the bank accounts implementation by using <code>Atomic</code> operations this time rather than a <code>Mutex</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> Bank <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> int Atomic<span class="token punctuation">.</span>t array

  <span class="token keyword">let</span> get t client <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>get t<span class="token punctuation">.</span><span class="token punctuation">(</span>client<span class="token punctuation">)</span>

  <span class="token keyword">let</span> transfer t from_account to_account money <span class="token operator">=</span>
    <span class="token keyword">if</span> money <span class="token operator">&gt;</span> <span class="token number">0</span>
    <span class="token operator">&amp;&amp;</span> from_account <span class="token operator">&lt;&gt;</span> to_account
    <span class="token operator">&amp;&amp;</span> get t from_account <span class="token operator">&gt;=</span> money
    <span class="token keyword">then</span> <span class="token keyword">begin</span>
      <span class="token comment">(* [fetch_and_add x v] is an atomic operation that does [x := !x + v] *)</span>
      <span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token punctuation">:</span> int <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>fetch_and_add t<span class="token punctuation">.</span><span class="token punctuation">(</span>from_account<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token operator">-</span> money<span class="token punctuation">)</span> <span class="token keyword">in</span>
      <span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token punctuation">:</span> int <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>fetch_and_add t<span class="token punctuation">.</span><span class="token punctuation">(</span>to_account<span class="token punctuation">)</span> money <span class="token keyword">in</span>
      <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token keyword">end</span>
<span class="token keyword">end</span></code></pre></div>
<p>See how careful I was to use <code>Atomic</code> to read and write from shared memory? (I even used a fancy <code>fetch_and_add</code>!) Therefore, it must be correct if used by different domains, right? While this program doesn't have a data race, the definition of &quot;correctness&quot; is more subtle in a multicore setting.</p>
<p>It's easier to explain if I show you the problem. To test this interface with the <code>Lin</code> library, we only need to describe how to <code>init</code>ialise a new bank and the API signature of available functions:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> Lin

<span class="token keyword">module</span> Bank_test <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> Bank<span class="token punctuation">.</span>t

  <span class="token keyword">let</span> init <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token comment">(* 8 accounts with $100 each *)</span>
    Array<span class="token punctuation">.</span>init <span class="token number">8</span> <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> Atomic<span class="token punctuation">.</span>make <span class="token number">100</span><span class="token punctuation">)</span>
  <span class="token keyword">let</span> cleanup <span class="token punctuation">_</span> <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token punctuation">)</span>

  <span class="token keyword">let</span> account <span class="token operator">=</span> int_bound <span class="token number">7</span> <span class="token comment">(* array index between 0..7 *)</span>
  <span class="token keyword">let</span> api <span class="token operator">=</span> <span class="token punctuation">[</span>
    val_ <span class="token string">&quot;get&quot;</span> Bank<span class="token punctuation">.</span>get <span class="token punctuation">(</span>t <span class="token operator">@-&gt;</span> account <span class="token operator">@-&gt;</span> returning int<span class="token punctuation">)</span> <span class="token punctuation">;</span>
    val_ <span class="token string">&quot;transfer&quot;</span> Bank<span class="token punctuation">.</span>transfer
      <span class="token punctuation">(</span>t <span class="token operator">@-&gt;</span> account <span class="token operator">@-&gt;</span> account <span class="token operator">@-&gt;</span> nat_small <span class="token operator">@-&gt;</span> returning unit<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token punctuation">]</span>
<span class="token keyword">end</span>

<span class="token keyword">module</span> Run <span class="token operator">=</span> Lin_domain<span class="token punctuation">.</span>Make <span class="token punctuation">(</span>Bank_test<span class="token punctuation">)</span>

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  QCheck_base_runner<span class="token punctuation">.</span>run_tests_main <span class="token punctuation">[</span>Run<span class="token punctuation">.</span>lin_test <span class="token label property">~count</span><span class="token punctuation">:</span><span class="token number">1000</span> <span class="token label property">~name</span><span class="token punctuation">:</span><span class="token string">&quot;Bank&quot;</span><span class="token punctuation">]</span></code></pre></div>
<p>That's all! A small DSL to define the types of our functions and we are done. Run this test to admire the beautiful ASCII art... craAaAash:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">  Results incompatible with sequential execution

                                   |
                                   |
                .------------------------------------.
                |                                    |
     transfer t 4 0 8  : ()               transfer t 4 0 93  : ()
          get t 4  : -1</code></pre></div>
<p><code>Lin</code> found a bug! The account number <code>4</code> is trying to simultaneously transfer $8 and $93 to account number <code>0</code>. It then naturally ends up with a negative $1 on its account, which is obviously bad for a banking system... but we never told <code>Lin</code> that this was illegal, so why is it complaining?</p>
<p>In the tradition of QuickCheck, <code>Lin</code> not only generates random arguments to test our API, but it also creates full programs to execute on two domains. It then runs these generated programs and checks if the intermediate results are &quot;sequentially consistent,&quot; the property of a well-behaved API where we can always explain its multicore behavior as a linear execution of the calls on a single core.</p>
<p>Without this &quot;sequential consistency&quot; property, the internals of our functions leak when multiple cores interleave their execution. In the example above, it wouldn't be possible to reach a negative $1 account on a single core, so <code>Lin</code> reports that sequential consistency is broken. It doesn't know that negative accounts are illegal, but it knows that this state is unreachable without multicore shenanigans.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/1ef04969f6bdb69e1799b67f09b8acfe/c1b63/nonseq.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 32.35294117647059%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAGCAYAAADDl76dAAAACXBIWXMAABsjAAAbIwGgXpL4AAABSklEQVQY042Py0rDUBRF81N+QkGFOnXijzjVgSOh1IGCoOBI0JEPRGmF2oriuz6oNpXah200aVPb5CYxuXdJq4hOxA2bBYfNgqMJIRBeQJ9RKEC6qKiDikxU+Mq7/0LL1LFsCwUEQYBwXHwh8DyPwVGpTwKaZRRoXk/SqyzQqW/BWwq6B9DJIc0MmAfUintctSsU8ciJZ6aMQ9a6RUTPwQ/fB6II8FWI1sinuJ4doTQ3RikZR0+MUk/GMFYmCO7WcI17KjWdi5cyJ6LBUvWYoY1phnZniO0nGE4niB/OM362zI71gObYFu5TAad4Tuc8hZ1dp72ziL09TzezinuTpVK44KR6z5H1yG41z2bpjHTtlly9wGlT5/K1jN5uDF7X+CPSc3CbZYyHPC3L5D/RlFIoKVEy+l0lv0dhX97foJBKEklJ9IPyq33XB4K9t4ViMf/EAAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/1ef04969f6bdb69e1799b67f09b8acfe/c5bb3/nonseq.png" class="gatsby-resp-image-image" alt="nonseq" title="nonseq" srcset="/static/1ef04969f6bdb69e1799b67f09b8acfe/04472/nonseq.png 170w,
/static/1ef04969f6bdb69e1799b67f09b8acfe/9f933/nonseq.png 340w,
/static/1ef04969f6bdb69e1799b67f09b8acfe/c5bb3/nonseq.png 680w,
/static/1ef04969f6bdb69e1799b67f09b8acfe/b12f7/nonseq.png 1020w,
/static/1ef04969f6bdb69e1799b67f09b8acfe/c1b63/nonseq.png 1200w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>Even though this is not a data race, a user of our library would have an equally hard time understanding the outcomes of our functions, when they depend so much on their accidental interleaving. <em>&quot;It sometimes doesn't work&quot;</em> is not a bug report I wish to see!</p>
<p>An intuitive way of thinking about &quot;sequential consistency&quot; is that our functions should behave as if they were a single atomic operation: Either we see none of their side effects, or we see all of them. It shouldn't be possible to see an in between, as this would result in a non-sequentialisable execution.</p>
<p>Once again, the easiest solution here is to use a <code>Mutex</code> to lock all the accounts during a transfer and when reading an account balance. Run the test suite again with <code>Lin</code>, and yep, we are safe. The operations are now sequentially consistent! (But we don't need the Atomics anymore with the <code>Mutex</code>.)</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/e315b196ba7386891ed868b245f87e1d/c1b63/seqmutex.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 21.176470588235293%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAECAYAAACOXx+WAAAACXBIWXMAABrOAAAazgFG4XaGAAAA/0lEQVQY013Lu0oDQQCF4X0YSxEEBe8IophCCPgMNrb6JrbaeGuMYUVBSwsxUVEwIWAZlKCz2Z2d2YuZdTfzS7bMgY9THI4TtHYQD1N4j7OY9iKye8ZR9MHcT42VvsukOOcUCZ8nfN1P4DXm0S/TFL0DLrwOG/4NC6LOjFdjN2viyM4+orGG91whaVeJg1eOsy6b/jVb8pYlv84lIQiX7+YywVuV6L0C4pBW1GO7f8e6uGLVc9lLn3AYSxwbcp1ANAA9gMhglEbFGfEvjKZRS53xl5rxO461BdbmJWxBmiaoSOOHkkCFJakUWiuUkoRhgNYSFUoGxjDEktthqbCWf3EAGIv5wvv1AAAAAElFTkSuQmCC'); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/e315b196ba7386891ed868b245f87e1d/c5bb3/seqmutex.png" class="gatsby-resp-image-image" alt="seqmutex" title="seqmutex" srcset="/static/e315b196ba7386891ed868b245f87e1d/04472/seqmutex.png 170w,
/static/e315b196ba7386891ed868b245f87e1d/9f933/seqmutex.png 340w,
/static/e315b196ba7386891ed868b245f87e1d/c5bb3/seqmutex.png 680w,
/static/e315b196ba7386891ed868b245f87e1d/b12f7/seqmutex.png 1020w,
/static/e315b196ba7386891ed868b245f87e1d/c1b63/seqmutex.png 1200w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>I really like how low effort / high reward <code>Lin</code> is. In just a few lines of declarative code, we can check that our code is correct when running on multiple cores. It's very extensive in its testing, which is just what we need when bugs are this hard to reproduce. The Multicore testing suite also provides a state-machine interface <code>STM</code>, which allows you to specify more properties that your system should respect (not only sequential consistency, but custom business logic!)</p>
<p><a href="https://github.com/ocaml-multicore/multicoretests">More examples on the <code>multicoretests</code> repository</a></p>
<p>Fun fact: The earlier &quot;out-of-order&quot; memory read/write on mutable references was also generated by <code>Lin</code>. While this tool is not specialised like ThreadSanitizer for discovering data-races, it can still trigger and identify the hardware memory reordering since they produce outcome that can't be explained on a single core. Here's the complete test if you want to see your computer memory <del>misbehaving</del> optimising:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> Lin

<span class="token keyword">module</span> Int_array <span class="token operator">=</span> <span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> int array
  <span class="token keyword">let</span> init <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token operator-like-punctuation punctuation">[|</span> <span class="token number">0</span> <span class="token punctuation">;</span> <span class="token number">0</span> <span class="token operator-like-punctuation punctuation">|]</span>
  <span class="token keyword">let</span> cleanup <span class="token punctuation">_</span> <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token keyword">let</span> index <span class="token operator">=</span> int_bound <span class="token number">1</span>
  <span class="token keyword">let</span> api <span class="token operator">=</span> <span class="token punctuation">[</span>
    val_ <span class="token string">&quot;get&quot;</span> Array<span class="token punctuation">.</span>get <span class="token punctuation">(</span>t <span class="token operator">@-&gt;</span> index <span class="token operator">@-&gt;</span> returning int<span class="token punctuation">)</span> <span class="token punctuation">;</span>
    val_ <span class="token string">&quot;set&quot;</span> Array<span class="token punctuation">.</span>set <span class="token punctuation">(</span>t <span class="token operator">@-&gt;</span> index <span class="token operator">@-&gt;</span> int <span class="token operator">@-&gt;</span> returning unit<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token punctuation">]</span>
<span class="token keyword">end</span>

<span class="token keyword">module</span> Run <span class="token operator">=</span> Lin_domain<span class="token punctuation">.</span>Make <span class="token punctuation">(</span>Int_array<span class="token punctuation">)</span>
<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> QCheck_base_runner<span class="token punctuation">.</span>run_tests_main <span class="token punctuation">[</span>Run<span class="token punctuation">.</span>lin_test <span class="token label property">~count</span><span class="token punctuation">:</span><span class="token number">10_000</span> <span class="token label property">~name</span><span class="token punctuation">:</span><span class="token string">&quot;Array&quot;</span><span class="token punctuation">]</span></code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#dscheck" aria-label="dscheck permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Dscheck</h2>
<p>While adding a <code>Mutex</code> restores the sequential consistency of the <code>transfer</code> function, it's unsatisfying to slow down all transactions with a global lock. Most transfers are going to happen on different accounts, so could we be more precise in our safety measures? This is far from easy with locks, if we don't want to end up bankrupt with <a href="https://en.wikipedia.org/wiki/Dining_philosophers_problem">hungry philosophers</a>!</p>
<p>One alternative solution is called lock-free programming, and as the name implies, it gets rid of all the locks---but at the cost of more complex algorithms. By using only <code>Atomic</code> operations, there are ways of encoding our <code>transfer</code> operation without blocking the other cores (such that they don't get stuck waiting on the unrelated threads to finish their transaction).</p>
<p>Lock-free algorithms have a bad reputation of being crazy hard to implement correctly. It's very easy to convince yourself that you found the right solution, only to discover that your algorithm only works when the OS scheduler is on your side (which it generally is...until it isn't). This is another type of hard-to-reproduce bug. We can't coerce the OS scheduler to be evil when testing our software.</p>
<p>Our last testing tool is the library <code>dscheck</code>. It provides a way to <em>exhaustively</em> test all the possible schedulings of a Multicore execution in order to discover the worst-case scenario that would lead to a crash. It does so by simulating parallelism on a single core using concurrency, thanks to algebraic effects and a custom scheduler. Dscheck is very fast because it doesn't test <em>all</em> possible interleaving but only the ones that matters.</p>
<p>In order to use it, you only need to replace the <code>Atomic</code> module by a custom one, and then write your unit test. Here I simply copy-pasted the bug generated by <code>Lin</code> earlier:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> Atomic <span class="token operator">=</span> Dscheck<span class="token punctuation">.</span>TracedAtomic
<span class="token keyword">module</span> Test   <span class="token operator">=</span> Dscheck<span class="token punctuation">.</span>TracedAtomic

<span class="token keyword">module</span> Bank <span class="token operator">=</span> <span class="token keyword">struct</span> <span class="token comment">(* same as before, but now using the traced Atomic *)</span> <span class="token keyword">end</span>

<span class="token keyword">let</span> test <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> t <span class="token operator">=</span> Array<span class="token punctuation">.</span>init <span class="token number">2</span> <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> Atomic<span class="token punctuation">.</span>make <span class="token number">100</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  Test<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Bank<span class="token punctuation">.</span>transfer t <span class="token number">0</span> <span class="token number">1</span> <span class="token number">8</span><span class="token punctuation">)</span> <span class="token punctuation">;</span> <span class="token comment">(* fake a Domain.spawn *)</span>
  Bank<span class="token punctuation">.</span>transfer t <span class="token number">0</span> <span class="token number">1</span> <span class="token number">93</span> <span class="token punctuation">;</span>
  <span class="token keyword">assert</span> <span class="token punctuation">(</span>Bank<span class="token punctuation">.</span>get t <span class="token number">0</span> <span class="token operator">&gt;=</span> <span class="token number">0</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> Test<span class="token punctuation">.</span>trace test <span class="token comment">(* exhaustively test all interleaving *)</span></code></pre></div>
<p>Dscheck will then run our <code>test</code> function multiple times, discovering all the interesting paths that the scheduler could lead us down, and finally outputs a visualisation describing the worst-case scheduling that lead to crashes:</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/72fbe0068c73cadf22e018262c394504/ad997/dscheck.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 107.6470588235294%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAWCAYAAADAQbwGAAAACXBIWXMAAAsTAAALEwEAmpwYAAAC1ElEQVQ4y5VVzUtiURTvnwjaVIsQSooIJMhciNhA0a5Fi7YGrlpE7aY/oEWrFmKboNWLlk0ftGkyoRpILY20FEms8eP5+d5Tn0/9DffMPOc1mToXLvfdc88973d+5+P2oM1oNBq0lstlpFIp+q7X6+2uoOezg1qtRqvL5cLCwgLm5+dxcnLy7uy/DCqKQuvBwQH6+vrQ29sLp9NJsmq1SujVqfWmp5O7pVIJPp8PFxcX9N1Ot61BrWIul0M4HEatXoNYFlGtV6E0FJpdI1TJj8ViMJvNsJqt2HftY/PHJrYD23BEHHA+OZGpZD4a1P5FnfXGb4OVSgXn389x9O0IyXwSL9IL/Ak/gnwQ0UIUck1ujVDLQ6sAFQqF5p4Lc3Cn3J9zqAoYKkmRICoiBEUAL/AoSkWEgiF4PB6igemkyink5BzQQGsO1Y1QFbD3sgfHkwM7oR1s3W/h8O4Qc1/mMGWcwsPDwx9In3v1ziCLYlbOIibE4P/pR7qSRr6Ux/3dPS4vL4lPhpIltho0bS5+4FA98Oa84OJcU4nP8IjH423z7yNCDR/RWBS3gVs8Pj7i7OwMXq8XgUAAp6enJAsGg5ROHRGqbmx83YDJaMLMzAwmJiawurqK9fV16PV6WK1WWCwWrKysdO+yIAhIp9PI5/N4e3uD2+0mDhkqJuN5vplGXRtkl7LZLJXc1dUVbm5uEAqFkMlkujeoury2toaxsTGYTCbodDosLy+TiwMDA5ienobBYIDNZmuWaEeErBm8vr4imUzi+fkZ19fXNFlAEokE0cBQtkSorV8tSu2IRCLUwlo1kH/vt21fbLD8MxqNmJyc/FspnZ4AWZbp3ZAkCcVikSLJyGdBYW8JewaOj4/JXVXOaGG6oihS42U2CCHHcbDb7VhaWsLs7CwFY3R0FCMjIxgcHER/fz+GhoYoIMPDwyRje6YzPj5OObm4uEiB293dxS9CzTkEbWlaHgAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/72fbe0068c73cadf22e018262c394504/c5bb3/dscheck.png" class="gatsby-resp-image-image" alt="dscheck" title="dscheck" srcset="/static/72fbe0068c73cadf22e018262c394504/04472/dscheck.png 170w,
/static/72fbe0068c73cadf22e018262c394504/9f933/dscheck.png 340w,
/static/72fbe0068c73cadf22e018262c394504/c5bb3/dscheck.png 680w,
/static/72fbe0068c73cadf22e018262c394504/ad997/dscheck.png 1012w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>This is a low-level view of the bug. By inspecting the sequence of <code>Atomic</code> operations along the bad paths, we can discover the origin of the problem: the code is not careful when removing money from an account.</p>
<p>Perhaps this would work better:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> transfer t from_account to_account money <span class="token operator">=</span>
  <span class="token keyword">let</span> money_from <span class="token operator">=</span> get t from_account <span class="token keyword">in</span>
  <span class="token keyword">if</span> money <span class="token operator">&gt;</span> <span class="token number">0</span>
  <span class="token operator">&amp;&amp;</span> from_account <span class="token operator">&lt;&gt;</span> to_account
  <span class="token operator">&amp;&amp;</span> money_from <span class="token operator">&gt;=</span> money
  <span class="token keyword">then</span> <span class="token keyword">begin</span>
    <span class="token keyword">if</span> Atomic<span class="token punctuation">.</span>compare_and_set t<span class="token punctuation">.</span><span class="token punctuation">(</span>from_account<span class="token punctuation">)</span> money_from <span class="token punctuation">(</span>money_from <span class="token operator">-</span> money<span class="token punctuation">)</span>
    <span class="token keyword">then</span> <span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token punctuation">:</span> int <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>fetch_and_add t<span class="token punctuation">.</span><span class="token punctuation">(</span>to_account<span class="token punctuation">)</span> money <span class="token keyword">in</span> <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token keyword">else</span> transfer t from_account to_account money <span class="token comment">(* retry *)</span>
  <span class="token keyword">end</span></code></pre></div>
<p>And yes, Dscheck now happily validates all possible interleaving of this unit test!</p>
<p><a href="https://github.com/ocaml-multicore/dscheck">More examples on the <code>dscheck</code> repository</a></p>
<p>So, does it mean our banking system works now? Nope! <code>Lin</code> reports new counter examples that break sequential consistency. I told you that lock-free was hard! Still, we can keep iterating, and we will eventually get it right because our tools remove the doubt and the impossibility of reproducibility that would otherwise make the task insurmountable. It's like having tiny assistants to double-check our assumptions. I love it. I've never been so excited to test my software!</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">                           get t 3  : 100
                           get t 4  : 100
                                   |
                .------------------------------------.
                |                                    |
                |                             transfer t 4 3 10  : ()
           get t 4  : 90
           get t 3  : 100
                     ^^^^^
                how? account 4 sent the money, but account 3 didn't receive it!</code></pre></div>
<p>Would you have caught this bug? Can you fix it? ;)</p>
<p>This was a tiny example, and it already brought some surprises. The multicore testing <code>Lin</code>, <code>STM</code>, and <code>dscheck</code> have been applied to real datastructures with great success. In fact, I wouldn't trust lock-free algorithms that were not validated by them.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>It's 2022 and OCaml is finally Multicore. Even if this article is only scratching the surface of a specific itch, I hope it has convinced you that the Multicore metamorphose wasn't only about lifting a global lock somewhere in the runtime. A lot of care and attention also went into creating a great environment to tackle really hard problems. Here we've only looked at:</p>
<ul>
<li>The memory model to be able to reason about our programs</li>
<li>ThreadSanitizer to detect dangerous use of shared memory</li>
<li><code>Lin</code> and <code>STM</code> to discover logical bugs in a multicore setting</li>
<li>Dscheck to validate unit tests of lock-free algorithms by exhaustively checking all possible interleavings of their Atomic operations</li>
</ul>
<p>There's still a lot more to discover in the latest release of OCaml. In the meantime, not only can we do Multicore, we can do it with confidence that our code works!</p>
