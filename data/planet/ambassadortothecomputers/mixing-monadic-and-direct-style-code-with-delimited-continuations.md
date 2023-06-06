---
title: Mixing monadic and direct-style code with delimited continuations
description: "The Lwt  library is a really nice way to write concurrent programs.
  A big downside, however, is that you can\u2019t use direct-style libraries wi..."
url: http://ambassadortothecomputers.blogspot.com/2010/08/mixing-monadic-and-direct-style-code.html
date: 2010-08-21T00:50:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>The <a href="http://ocsigen.org/lwt">Lwt</a> library is a really nice way to write concurrent programs. A big downside, however, is that you can&rsquo;t use direct-style libraries with it. Suppose we&rsquo;re writing an XMPP server, and we want to parse XML as it arrives over a network connection, using Daniel B&uuml;nzli&rsquo;s nice <a href="http://erratique.ch/software/xmlm"><code>xmlm</code></a> library. <code>Xmlm</code> can read from a <code>string</code>, or from a <code>Pervasives.in_channel</code>, or you can give it a function of type <code>(unit -&gt; int)</code> to return the next character of input. But there is no way to have it read from an Lwt thread; that is, we can&rsquo;t give it a function of type <code>(unit -&gt; int Lwt.t)</code>, since it doesn&rsquo;t know what do with an <code>Lwt.t</code>. To keep track of the parser state at the point the input blocks, the whole library would need to be rewritten in Lwt style (i.e. monadic style).</p> 
 
<p>Now, Lwt does provide the <code>Lwt_preemptive</code> module, which gives you a way to spin off a preemptive thread (implemented as an ordinary OCaml thread) and wait for its result in the usual Lwt way with <code>bind</code>. This is useful, but has two drawbacks: preemptive threads are <em>preemptive</em>, so you&rsquo;re back to traditional locking if you want to operate on shared data; and preemptive threads are <em>threads</em>, so they are much heavier than Lwt threads, and (continuing the XMPP hypothetical) it may not be feasible to use one per open connection.</p> 
<b>Fibers</b> 
<p>What we would really like is to be able spin off a cooperative, direct-style thread. The thread needs a way to block on Lwt threads, but when it blocks we need to be able to schedule another Lwt thread. As a cooperative thread it of course has exclusive access to the process state while it is running. A cooperative, direct-style thread is sometimes called a <em>coroutine</em> (although to me that word connotes a particular style of inter-thread communication as well, where values are yielded between coroutines), or a <em>fiber</em>.</p> 
 
<p>Here&rsquo;s an API for mixing Lwt threads with fibers:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">val</span> <span class="n">start</span> <span class="o">:</span> <span class="o">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span> 
  <span class="k">val</span> <span class="n">await</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> 
</code></pre> 
</div> 
<p>The <code>start</code> function spins off a fiber, returning an Lwt thread which is woken with the result of the fiber once it completes. The <code>await</code> function (which may be called only from within a fiber) blocks on the result of an Lwt thread, allowing another Lwt thread to be scheduled while it is waiting.</p> 
 
<p>With this API we could implement our XMPP server by calling <code>xmlm</code> from within a fiber, and passing it a function that <code>await</code>s the next character available on the network connection. But how do we implement it?</p> 
<b>Delimited continuations</b> 
<p><a href="http://okmij.org/ftp/">Oleg Kiselyov</a>&rsquo;s recent <a href="http://caml.inria.fr/pub/ml-archives/caml-list/2010/08/3567e58838e79cacc3441da7508d46fe.en.html">announcement</a> of a native-code version of his <code>Delimcc</code> library for delimited continuations in OCaml reminded me of two things:</p> 
 
<ol> 
<li>I should find out what delimited continuations are.</li> 
 
<li>They sound useful for implementing fibers.</li> 
</ol> 
 
<p>The paper describing the library, <a href="http://okmij.org/ftp/continuations/caml-shift.pdf">Delimited Control in OCaml, Abstractly and Concretely</a>, has a pretty good overview of delimited continuations, and section 2 of <a href="http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.68.9352">A Monadic Framework for Delimited Continuations</a> is helpful too.</p> 
 
<p>The core API is small:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">prompt</span> 
  <span class="k">type</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">subcont</span> 
  
  <span class="k">val</span> <span class="n">new_prompt</span>   <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">prompt</span> 
  
  <span class="k">val</span> <span class="n">push_prompt</span>  <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">prompt</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> 
  <span class="k">val</span> <span class="n">take_subcont</span> <span class="o">:</span> 
    <span class="k">'</span><span class="n">b</span> <span class="n">prompt</span> <span class="o">-&gt;</span> <span class="o">((</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">subcont</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> 
  <span class="k">val</span> <span class="n">push_subcont</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">subcont</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> 
</code></pre> 
</div> 
<p>I find it easiest to think about these functions as operations on the stack. A prompt is an identifier used to mark a point on the stack (the stack can be marked more than once with the same prompt). The function <code>new_prompt</code> makes a new prompt which is not equal to any other prompt.</p> 
 
<p>The call <code>push_prompt p f</code> marks the stack with <code>p</code> then runs <code>f</code>, so the stack, growing to the right, looks like</p> 
<pre> 
  ABCDpEFGH
</pre> 
<p>where <code>ABCD</code> are stack frames in the continuation of the call to <code>push_prompt</code>, and <code>EFGH</code> are frames created while running <code>f</code>. If <code>f</code> returns normally (that is, without calling <code>take_subcont</code>) then its return value is returned by <code>push_prompt</code>, and we are back to the original stack <code>ABCD</code>.</p> 
 
<p>If <code>take_subcont p g</code> is called while running <code>f</code>, the stack fragment <code>EFGH</code> is packaged up as an <code>('a,'b) subcont</code> and passed to <code>g</code>. You can think of an <code>('a,'b) subcont</code> as a function of type <code>'a -&gt; 'b</code>, where <code>'a</code> is the return type of the call to <code>take_subcont</code> and <code>'b</code> is the return type of the call to <code>push_prompt</code>. <code>Take_subcont</code> removes the fragment <code>pEFGH</code> from the stack, and there are some new frames <code>IJKL</code> from running <code>g</code>, so we have</p> 
<pre> 
  ABCDIJKL
</pre> 
<p>Now <code>g</code> can make use of the passed-in <code>subcont</code> using <code>push_subcont</code>. (Thinking of a <code>subcont</code> as a function, <code>push_subcont</code> is just a weird function application operator, which takes the argument as a thunk). Then the stack becomes</p> 
<pre> 
  ABCDIJKLEFGH
</pre> 
<p>Of course <code>g</code> can call the <code>subcont</code> as many times as you like.</p> 
 
<p>A common pattern is to re-mark the stack with <code>push_prompt</code> before calling <code>push_subcont</code> (so <code>take_subcont</code> may be called again). There is an optimized version of this combination called <code>push_delim_subcont</code>, which produces the stack</p> 
<pre> 
  ABCDIJKLpEFGH
</pre> 
<p>The idea that a <code>subcont</code> is a kind of function is realized by <code>shift0</code>, which is like <code>take_subcont</code> except that instead of passing a <code>subcont</code> to <code>g</code> it passes an ordinary function. The passed function just wraps a call to <code>push_delim_subcont</code>. (It is <code>push_delim_subcont</code> rather than <code>push_subcont</code> for historical reasons I think&mdash;see the Monadic Framework paper for a comparison of various delimited continuation primitives.)</p> 
<b>Implementing fibers</b> 
<p>To implement fibers, we want <code>start f</code> to mark the stack, then run <code>f</code>; and <code>await t</code> to unwind the stack back to the mark, wait for <code>t</code> to complete, then restore the stack. Here is <code>start</code>:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">active_prompt</span> <span class="o">=</span> <span class="n">ref</span> <span class="nc">None</span> 
  
  <span class="k">let</span> <span class="n">start</span> <span class="n">f</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">t</span><span class="o">,</span> <span class="n">u</span> <span class="o">=</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">wait</span> <span class="bp">()</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="nn">Delimcc</span><span class="p">.</span><span class="n">new_prompt</span> <span class="bp">()</span> <span class="k">in</span> 
    <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">Some</span> <span class="n">p</span><span class="o">;</span> 
  
    <span class="nn">Delimcc</span><span class="p">.</span><span class="n">push_prompt</span> <span class="n">p</span> <span class="k">begin</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> 
      <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> 
        <span class="k">try</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Return</span> <span class="o">(</span><span class="n">f</span> <span class="bp">()</span><span class="o">)</span> 
        <span class="k">with</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Fail</span> <span class="n">e</span> <span class="k">in</span> 
      <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">None</span><span class="o">;</span> 
      <span class="k">match</span> <span class="n">r</span> <span class="k">with</span> 
        <span class="o">|</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Return</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">wakeup</span> <span class="n">u</span> <span class="n">v</span> 
        <span class="o">|</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Fail</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">wakeup_exn</span> <span class="n">u</span> <span class="n">e</span> 
        <span class="o">|</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Sleep</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span> 
    <span class="k">end</span><span class="o">;</span> 
    <span class="n">t</span> 
</code></pre> 
</div> 
<p>We make a sleeping Lwt thread, and store a new prompt in a global (this is OK because we won&rsquo;t yield control to another Lwt thread before using it; of course this is not safe with OCaml threads). Then we mark the stack with <code>push_prompt</code> and run the fiber. (The <code>let r = ... match r with ...</code> is to avoid calling <code>Lwt.wakeup{,_exn}</code> in the scope of the <code>try</code>; we use <code>Lwt.state</code> as a handy type to store either a result or an exception.) If the fiber completes without calling <code>await</code> then all we do is wake up the Lwt thread with the returned value or exception.</p> 
 
<p>Here is <code>await</code>:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">await</span> <span class="n">t</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> 
      <span class="k">match</span> <span class="o">!</span><span class="n">active_prompt</span> <span class="k">with</span> 
        <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;await called outside start&quot;</span> 
        <span class="o">|</span> <span class="nc">Some</span> <span class="n">p</span> <span class="o">-&gt;</span> <span class="n">p</span> <span class="k">in</span> 
    <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">None</span><span class="o">;</span> 
 
    <span class="k">match</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">poll</span> <span class="n">t</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="nc">Some</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">v</span> 
      <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> 
          <span class="nn">Delimcc</span><span class="p">.</span><span class="n">shift0</span> <span class="n">p</span> <span class="k">begin</span> <span class="k">fun</span> <span class="n">k</span> <span class="o">-&gt;</span> 
            <span class="k">let</span> <span class="n">ready</span> <span class="o">_</span> <span class="o">=</span> 
              <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">Some</span> <span class="n">p</span><span class="o">;</span> 
              <span class="n">k</span> <span class="bp">()</span><span class="o">;</span> 
              <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span> <span class="k">in</span> 
            <span class="n">ignore</span> <span class="o">(</span><span class="nn">Lwt</span><span class="p">.</span><span class="n">try_bind</span> <span class="o">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">t</span><span class="o">)</span> <span class="n">ready</span> <span class="n">ready</span><span class="o">)</span> 
          <span class="k">end</span><span class="o">;</span> 
          <span class="k">match</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">poll</span> <span class="n">t</span> <span class="k">with</span> 
            <span class="o">|</span> <span class="nc">Some</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">v</span> 
            <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span> 
</code></pre> 
</div> 
<p>We first check to be sure that we are in the scope of <code>start</code>, and that <code>t</code> isn&rsquo;t already completed (in which case we just return its result). If we actually need to wait for <code>t</code>, we call <code>shift0</code>, which capture the stack fragment back to the <code>push_prompt</code> call in <code>start</code> (this continuation includes the subsequent <code>match Lwt.poll t</code> and everything after the call to <code>await</code>), then <code>try_bind</code> so we can restore the stack fragment when <code>t</code> completes (whether by success or failure). When <code>t</code> completes, the <code>ready</code> function restores the global <code>active_prompt</code>, in case the fiber calls <code>await</code> again, then restores the stack by calling <code>k</code> (recall that this also re-marks the stack with <code>p</code>, which is needed if the fiber calls <code>await</code> again).</p> 
 
<p>It&rsquo;s pretty difficult to follow what&rsquo;s going on here, so let&rsquo;s try it with stacks. After calling <code>start</code> we have</p> 
<pre> 
  ABCDpEFGH
</pre> 
<p>where <code>ABCD</code> is the continuation of <code>push_prompt</code> in <code>start</code> (just the return of <code>t</code>) and <code>EFGH</code> are frames created by the thunk passed to <code>start</code>. Now, a call to <code>await</code> (on an uncompleted thread) calls <code>shift0</code>, which packs up <code>EFGH</code> as <code>k</code> and unwinds the stack to <code>p</code>. The function passed to <code>shift0</code> stores <code>k</code> in <code>ready</code> but doesn&rsquo;t call it, and control returns to <code>start</code> (since the stack has been unwound).</p> 
 
<p>The program continues normally until <code>t</code> completes. Now control is in <code>Lwt.run_waiters</code> running threads that were waiting on <code>t</code>; one of them is our <code>ready</code> function. When it is called, the stack is re-marked and <code>EFGH</code> is restored, so we have</p> 
<pre> 
  QRSTpEFGH
</pre> 
<p>where <code>QRST</code> is wherever we happen to be in the main program, ending in <code>Lwt.run_waiters</code>. Now, <code>EFGH</code> ends with the second call to <code>match Lwt.poll</code> in <code>await</code>, which returns the value of <code>t</code> and continues the thunk passed to <code>start</code>. The stack is now marked with <code>p</code> inside <code>Lwt.run_waiters</code>, so when <code>await</code> is called again control returns there.</p> 
<b>Events vs. threads</b> 
<p>We have seen that we can use fibers to write Lwt threads in direct style. Should we abandon Lwt&rsquo;s monadic style entirely, and use Lwt only for its event handling?</p> 
 
<p>First, how does each style perform? Every time a fiber blocks and resumes, we have to copy, unwind, and restore its entire stack. With Lwt threads, the &ldquo;stack&rdquo; is a bunch of linked closures in the heap, so we don&rsquo;t need to do anything to block or resume. On the other hand, building and garbage-collecting the closures is more expensive than pushing and popping the stack. We can imagine that which style performs better depends on the thread: if it blocks infrequently enough, the amortized cost of copying and restoring the stack might be lower than the cost of building and garbage-collecting the closures. (We can also imagine that a different implementation of delimited continuations might change this tradeoff.)</p> 
 
<p>Second, how does the code look? The paper <a href="http://www.stanford.edu/class/cs240/readings/usenix2002-fibers.pdf">Cooperative Task Management without Manual Stack Management</a> considers this question in the context of the &ldquo;events vs. threads&rdquo; debate. Many of its points lose their force when translated to OCaml and Lwt&mdash;closures, the <code>&gt;&gt;=</code> operator, and Lwt&rsquo;s syntax extension go a long way toward making Lwt code look like direct style&mdash;but some are still germane. In favor of fibers is that existing direct-style code need not be rewritten to work with Lwt (what motivated us in the first place). In favor of monadic style is that the type of a function reflects the possibility that it might block, yield control to another thread, and disturb state invariants.</p> 
<b>Direct-style FRP</b> 
<p>We could apply this idea, of replacing monadic style with direct style using delimited continuations, to other monads&mdash;in particular to the <a href="http://github.com/jaked/froc"><code>froc</code></a> library for functional reactive programming. (The Scala.React FRP library also uses delimited continuations to implement direct style; see <a href="http://lamp.epfl.ch/~imaier/pub/DeprecatingObserversTR2010.pdf">Deprecating the Observer Pattern</a> for details.)</p> 
 
<p>Here&rsquo;s the API:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">val</span> <span class="n">direct</span> <span class="o">:</span> <span class="o">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="nn">Froc</span><span class="p">.</span><span class="n">behavior</span> 
  <span class="k">val</span> <span class="n">read</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="nn">Froc</span><span class="p">.</span><span class="n">behavior</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> 
</code></pre> 
</div> 
<p>Not surprisingly, it&rsquo;s just the same as for Lwt, but with a different monad and different names (I don&rsquo;t know if <code>direct</code> is quite right but it is better than <code>start</code>). There is already a function <code>Froc.sample</code> with the same type as <code>read</code>, but it has a different meaning: <code>sample</code> takes a snapshot of a behavior but creates no dependency on it.</p> 
 
<p>The implementation is very similar as well:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">active_prompt</span> <span class="o">=</span> <span class="n">ref</span> <span class="nc">None</span> 
  
  <span class="k">let</span> <span class="n">direct</span> <span class="n">f</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">t</span><span class="o">,</span> <span class="n">u</span> <span class="o">=</span> <span class="nn">Froc_ddg</span><span class="p">.</span><span class="n">make_changeable</span> <span class="bp">()</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="nn">Delimcc</span><span class="p">.</span><span class="n">new_prompt</span> <span class="bp">()</span> <span class="k">in</span> 
    <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">Some</span> <span class="n">p</span><span class="o">;</span> 
  
    <span class="nn">Delimcc</span><span class="p">.</span><span class="n">push_prompt</span> <span class="n">p</span> <span class="k">begin</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> 
      <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> 
        <span class="k">try</span> <span class="nn">Froc_ddg</span><span class="p">.</span><span class="nc">Value</span> <span class="o">(</span><span class="n">f</span> <span class="bp">()</span><span class="o">)</span> 
        <span class="k">with</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="nn">Froc_ddg</span><span class="p">.</span><span class="nc">Fail</span> <span class="n">e</span> <span class="k">in</span> 
      <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">None</span><span class="o">;</span> 
      <span class="nn">Froc_ddg</span><span class="p">.</span><span class="n">write_result</span> <span class="n">u</span> <span class="n">r</span> 
    <span class="k">end</span><span class="o">;</span> 
    <span class="o">(</span><span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="n">t</span> <span class="o">:</span> <span class="o">_</span> <span class="nn">Froc</span><span class="p">.</span><span class="n">behavior</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>This is essentially the same code as <code>start</code>, modulo the change of monad. However, some of the functions we need aren&rsquo;t exported from <code>Froc</code>, so we need to use the underlying <code>Froc_ddg</code> module and magic the result at the end. <code>Froc_ddg.make_changeable</code> is the equivalent of <code>Lwt.wait</code>: it returns an &ldquo;uninitialized&rdquo; monadic value along with a writer for that value. We use <code>Froc_ddg.result</code> instead of <code>Lwt.state</code> to store a value or exception, and <code>Froc_ddg.write_result</code> instead of the pattern match and <code>Lwt.wakeup{,_exn}</code>.</p> 
<div class="highlight"><pre><code class="ocaml">  
  <span class="k">let</span> <span class="n">read</span> <span class="n">t</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> 
      <span class="k">match</span> <span class="o">!</span><span class="n">active_prompt</span> <span class="k">with</span> 
        <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;read called outside direct&quot;</span> 
        <span class="o">|</span> <span class="nc">Some</span> <span class="n">p</span> <span class="o">-&gt;</span> <span class="n">p</span> <span class="k">in</span> 
    <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">None</span><span class="o">;</span> 
  
    <span class="nn">Delimcc</span><span class="p">.</span><span class="n">shift0</span> <span class="n">p</span> <span class="k">begin</span> <span class="k">fun</span> <span class="n">k</span> <span class="o">-&gt;</span> 
      <span class="nn">Froc</span><span class="p">.</span><span class="n">notify_result_b</span> <span class="n">t</span> <span class="k">begin</span> <span class="k">fun</span> <span class="o">_</span> <span class="o">-&gt;</span> 
        <span class="n">active_prompt</span> <span class="o">:=</span> <span class="nc">Some</span> <span class="n">p</span><span class="o">;</span> 
        <span class="n">k</span> <span class="bp">()</span> 
      <span class="k">end</span> 
    <span class="k">end</span><span class="o">;</span> 
    <span class="nn">Froc</span><span class="p">.</span><span class="n">sample</span> <span class="n">t</span> 
</code></pre> 
</div> 
<p>And this is essentially the same code as <code>await</code>. A <code>Froc.behavior</code> always has a value, so we don&rsquo;t poll it as we did with <code>Lwt.t</code>, but go straight to <code>shift0</code>. We have <code>Froc.try_bind</code> but it&rsquo;s a little more compact to use use <code>notify_result_b</code>, which passes a <code>result</code>.</p> 
<b>Monadic reflection</b> 
<p>The similarity between these implementations suggests that we could use the same code to get a direct style version of any monad; we only need a way to create an uninitialized monadic value, then set it. The call to <code>Lwt.poll</code> in <code>await</code> is an optimization which we would have to forgo. (In both these examples we have a monad with failure, and <code>try_bind</code>, but we could do without it.)</p> 
 
<p>A little googling turns up Andrzej Filinski&rsquo;s paper <a href="http://www.diku.dk/hjemmesider/ansatte/andrzej/papers/RM-abstract.html">Representing Monads</a>, which reaches the same conclusion, with a lot more rigor. In that work <code>start</code>/<code>direct</code> are called <code>reify</code>, and <code>await</code>/<code>read</code> are called <code>reflect</code>. <code>Reflect</code> is close to the implementations above, but in <code>reify</code> the paper marks the stack inside a function passed to <code>bind</code> rather than creating an uninitialized monadic value and later setting it.</p> 
 
<p>This makes sense&mdash;inside <code>bind</code> an uninitialized monadic value is created, then set from the result of the function passed to <code>bind</code>. So we are partially duplicating <code>bind</code> in the code above. If we mark the stack in the right place we should be able to use <code>bind</code> directly. It is hard to see how to make the details work out, however, since <code>Lwt.bind</code> and <code>Froc.bind</code> each have some cases where uninitialized values are not created.</p> 
 
<p>(You can find the complete code for Lwt fibers <a href="http://github.com/jaked/lwt-equeue/tree/master/src/lwt-fiber">here</a> and direct-style <code>froc</code> <a href="http://github.com/jaked/froc/tree/master/src/froc-direct">here</a>.)</p> 
 
<p>(revised 10/22)</p>
