---
title: 'Multicore Testing Tools: DSCheck Pt 2'
description: "Welcome to part two! If you haven't already, check out part one, where
  we introduce DSCheck and share one of its uses in a naive counter\u2026"
url: https://tarides.com/blog/2024-04-10-multicore-testing-tools-dscheck-pt-2
date: 2024-04-10T00:00:00-00:00
preview_image: https://tarides.com/static/2a97b296e84c067e346ff826cce2b2ee/2070e/DSCheck2.jpg
featured:
authors:
- Tarides
source:
---

<p>Welcome to part two! If you haven't already, check out <a href="https://tarides.com/blog/2024-02-14-multicore-testing-tools-dscheck-pt-1/">part one</a>, where we introduce DSCheck and share one of its uses in a naive counter implementation. This post will give you a behind-the-scenes look at how DSCheck works its magic, including the theory behind it and how to write a test for our naive counter implementation example. We&rsquo;ll conclude by going a bit further, showing you how DSCheck can be used to check otherwise hard-to-prove properties in the <a href="https://github.com/ocaml-multicore/saturn">Saturn</a> library.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#how-does-dscheck-work" aria-label="how does dscheck work permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>How Does DSCheck Work?</h2>
<p>Developers use DSCheck to catch non-deterministic, hard-to-reproduce bugs in their multithreaded programs. DSCheck does so by ensuring that all the executions possible on the multiple cores (called interleavings) are valid and do not result in faults. Doing this without a designated tool like DSCheck would be incredibly resource-intensive.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#in-theory" aria-label="in theory permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In Theory</h3>
<p>DSCheck operates by simulating parallelism on a single core, which is possible thanks to <a href="https://overreacted.io/algebraic-effects-for-the-rest-of-us/">algebraic effects</a> and a custom scheduler. DSCheck doesn't actually exhaustively 'check' all interleavings but examines a select number of relevant ones that allow it to ensure that all terminal states are valid and that no edge cases have been missed.</p>
<p>You may reasonably be asking yourself how this works. Well, the emergence of <a href="https://users.soe.ucsc.edu/~cormac/papers/popl05.pdf">Dynamic Partial-Order Reduction</a> (DPOR) methods have made DSCheck-like model checkers possible. The DPOR approach to model-checking stems from observations of real-world programs, where many interleavings are equivalent. If at least one of them is covered, so is its entire equivalent class &ndash; which is called a trace. DSCheck, therefore, checks one interleaving per trace, which lets it ensure that the whole equivalent trace is without faults.</p>
<p>Let's illustrate this with a straightforward example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>make <span class="token number">0</span> <span class="token keyword">in</span>
<span class="token keyword">let</span> b <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>make <span class="token number">0</span> <span class="token keyword">in</span>
<span class="token comment">(* Domain A *)</span>
Domain<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
    Atomic<span class="token punctuation">.</span>set a <span class="token number">1</span><span class="token punctuation">;</span> <span class="token comment">(* A1 *)</span>
    Atomic<span class="token punctuation">.</span>set b <span class="token number">1</span><span class="token punctuation">;</span> <span class="token comment">(* A2 *)</span>
    <span class="token punctuation">)</span> <span class="token operator">|&gt;</span> ignore<span class="token punctuation">;</span>
<span class="token comment">(* Domain B *)</span>
Domain<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
    Atomic<span class="token punctuation">.</span>set a <span class="token number">2</span><span class="token punctuation">;</span> <span class="token comment">(* B *)</span>
    <span class="token punctuation">)</span> <span class="token operator">|&gt;</span> ignore</code></pre></div>
<p>There are three possible interleavings: A1.A2.B, A1.B.A2, and B.A1.A2. The ordering between B and the second step of the first domain, A2, does not matter as it does not affect the same variable. Thus, the execution sequences A1.A2.B and A1.B.A2 are different interleavings of the same trace, which means that if at least one is covered, so is the other.</p>
<p>DPOR skips the redundant execution sequences and provides an exponential performance improvement over an exhaustive (also called naive) search. Since naive model checkers try to explore every single interleaving, and since interleavings grow exponentially with the size of code, there quickly comes a point where the number of interleavings far exceeds what the model checker can cover in a reasonable amount of time. This approach is inefficient to the degree that the only programs a naive model checker can check are so simple that it's almost useless to do so.</p>
<p>By reducing the amount of interleavings that need to be checked, we have significantly expanded the universe of checkable programs. DSCheck has reached a point where its performance is strong enough to test relatively long code, and most significantly, we can use it for data structure implementation.</p>
<p>In addition to the DPOR approach, some conditions must be met for the validations that DSCheck performs to be sound. These conditions include:</p>
<ul>
<li><strong>Determinism:</strong> DSCheck runs the same program multiple times (once per explored interleaving). There should be no randomness in between these executions, meaning that they should all run with the same seed, since otherwise DSCheck may miss some traces and thus miss bugs.</li>
<li><strong>Data-Races:</strong> The program being tested cannot have data races between non-atomic variables, as DSCheck does not see such different behaviours. You should use <a href="https://github.com/ocaml-multicore/ocaml-tsan">TSan</a> before running DSCheck to remove data races.</li>
<li><strong>Atomics:</strong> Domains can only communicate through atomic variables. Validation, including higher-level synchronisation primitives (like mutexes), has not yet been implemented.</li>
<li><strong>Lock-Free:</strong> Programs being tested have to be at least lock-free. Lock-free programs are programs that have multiple threads that share access memory, where none of the threads can block each other. If a program has a thread that cannot finish independently, DSCheck will explore its transitions ad infinitum. To partially mitigate this problem, we can force tests to be lock-free. For example, we can modify a spinlock to explicitly fail once it reaches an artificial limit.</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#in-practice" aria-label="in practice permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In Practice</h3>
<p>Let's look at how a DSCheck test can catch a bug in a naive counter implementation. To see how we set up the naive counter implementation in this example, have a look <a href="https://tarides.com/blog/2024-02-14-multicore-testing-tools-dscheck-pt-1/#an-example-of-dscheck-in-practice-naive-counter-implementation">at part one</a> of our two-part DSCheck series.</p>
<p>This is how to write a test for the previous naive counter module we introduced in part one:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> Atomic <span class="token operator">=</span> Dscheck<span class="token punctuation">.</span>TracedAtomic
<span class="token comment">(* The test needs to use DSCheck's atomic module *)</span>

<span class="token keyword">let</span> test_counter <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  Atomic<span class="token punctuation">.</span>trace <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
      <span class="token keyword">let</span> counter <span class="token operator">=</span> Counter<span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
      Atomic<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Counter<span class="token punctuation">.</span>incr counter<span class="token punctuation">)</span><span class="token punctuation">;</span>
      <span class="token comment">(* [Atomic.spawn] is the DSCheck function to simulate [Domain.spawn] *)</span>
      Atomic<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Counter<span class="token punctuation">.</span>incr counter<span class="token punctuation">)</span><span class="token punctuation">;</span>
      <span class="token comment">(* There is no need to join domains as DSCheck does not actually spawn domains. *)</span>
      Atomic<span class="token punctuation">.</span>final <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Atomic<span class="token punctuation">.</span>check <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Counter<span class="token punctuation">.</span>get counter <span class="token operator">==</span> <span class="token number">2</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>As you can tell, the test is very similar to the <a href="https://tarides.com/blog/2024-02-14-multicore-testing-tools-dscheck-pt-1/#an-example-of-dscheck-in-practice-naive-counter-implementation"><code>main</code> function we wrote previously</a> to check our counter manually, but now it uses DSCheck's interface. This includes:</p>
<ul>
<li>Shadowing the atomic module with DSCheck's <code>TracedAtomic</code>, which adds the algebraic effects we need to compute the interleavings</li>
<li><code>Atomic.trace</code> takes the code for which we want to test its interleavings as an input.</li>
<li><code>Atomic.spawn</code> simulates <code>Domain.spawn</code>.</li>
</ul>
<p>In this case, DSCheck will return the following output:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Found assertion violation at run 2:
sequence 2
----------------------------------------
P0 P1
----------------------------------------
start
get a
                        start
                        get a
set a
                        set a
----------------------------------------</code></pre></div>
<p>This output reveals the buggy interleaving with one column per domain (<code>P0</code> and <code>P1</code>). We need to infer ourselves that <code>a</code> means <code>counter</code> here, but once we know that this is pretty straightforward to read, isn't it?</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#case-study-saturn" aria-label="case study saturn permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Case Study: Saturn</h2>
<p>Let's take a closer look at using DSCheck with <a href="https://github.com/ocaml-multicore/saturn">Saturn</a>. Offering industrial-strength, well-tested data structures for OCaml 5, the library makes it easier for Multicore users to find data structures that fit their needs. If you use a data structure from Saturn, you can be sure it has been tested to perform well with Multicore usage. In Saturn, DSCheck has two primary uses: firstly, the one demonstrated above, i.e. catching interleavings that return buggy results; secondly, we use it to detect blocking situations.</p>
<p>Most data structures available through Saturn need to be lock-free. As part of the lock-free property&rsquo;s definition, the structure also needs to be obstruction-free, which technically means that a domain running in isolation can always make progress or be free of blocking situations. So, if all domains bar one are paused partway through their execution, the one still working can finish without issue or being blocked. The most common blocking situation is due to a lock; if one domain acquires a lock, all the other domains must wait until the first one has released the lock to proceed.</p>
<p>Let's take a look at how DSCheck tests for blocking situations:</p>
<p>Here is an example of a code that is <strong>not</strong> obstruction-free. This is a straightforward implementation of a barrier for two domains. Both domains need to increment it to pass the whole loop.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">  <span class="token keyword">let</span> barrier <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>make <span class="token number">0</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> work id <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
    print_endline <span class="token punctuation">(</span><span class="token string">&quot;Hello world, I'm &quot;</span><span class="token operator">^</span> id<span class="token punctuation">)</span><span class="token punctuation">;</span>
    Atomic<span class="token punctuation">.</span>incr barrier<span class="token punctuation">;</span>
    <span class="token keyword">while</span> Atomic<span class="token punctuation">.</span>get barrier <span class="token operator">&lt;</span> <span class="token number">2</span> <span class="token keyword">do</span>
      <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token keyword">done</span>
  <span class="token keyword">in</span>
  <span class="token keyword">let</span> domainA <span class="token operator">=</span> Domain<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span>work <span class="token string">&quot;A&quot;</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> domainB <span class="token operator">=</span> Domain<span class="token punctuation">.</span>spawn <span class="token punctuation">(</span>work <span class="token string">&quot;B&quot;</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  Domain<span class="token punctuation">.</span>join domainA<span class="token punctuation">;</span>
  Domain<span class="token punctuation">.</span>join domain</code></pre></div>
<p>In this example, if B is paused by the operating system after printing <code>&quot;Hello world, I'm B&quot;</code>, then A can not progress past the barrier even though it is the only domain currently working. This code is thus not obstruction-free.</p>
<p>If we run this code through DSCheck, here is one interleaving it will explore.</p>
<table>
<thead>
<tr>
<th>Step</th>
<th>Domain A</th>
<th>Domain B</th>
<th>Barrier</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td></td>
<td>prints &quot;Hello world, I'm B!&quot;</td>
<td>0</td>
</tr>
<tr>
<td>2</td>
<td>prints &quot;Hello world, I'm A!&quot;</td>
<td></td>
<td>0</td>
</tr>
<tr>
<td>3</td>
<td>Increases <code>barrier</code></td>
<td></td>
<td>`</td>
</tr>
<tr>
<td>4</td>
<td>Reads <code>barrier</code> and loops</td>
<td></td>
<td>1</td>
</tr>
<tr>
<td>5</td>
<td></td>
<td>Increases <code>barrier</code></td>
<td>2</td>
</tr>
<tr>
<td>6</td>
<td></td>
<td>Reads <code>barrier</code> and passes the loop</td>
<td>2</td>
</tr>
<tr>
<td>7</td>
<td>Reads <code>barrier</code> and passes the loop</td>
<td></td>
<td>2</td>
</tr>
</tbody>
</table>
<p>In this interleaving, domain A only performs the loop once, waiting for domain B to increase the barrier. However, nothing prevents A from looping forever here if B never takes step 5. In other words, step 4 can be repeated one, two, three&hellip; an infinite number of times, creating a <em>new</em> trace (i.e. a new interleaving that is not equivalent to the previous one) each time. As DSCheck will try to explore every possible trace (i.e. each equivalent class of interleavings), the test will never finish. We can determine that a test is not going to finish by noting how the explored interleavings keep growing in size. In this case, they will look like B-A-A-A-B-B-A, then B-A-A-A-A-B-B-A, then B-A-A-A-A-A-B-B-A and so on. When this scenario occurs, we can conclude that our code is not obstruction-free.</p>
<p>To summarise, if DSCheck runs on some accidentally blocking code, it will not be able to terminate its execution as it will have infinite traces to explore. This is one way to determine if your tested code is obstruction-free, a property that is otherwise hard to prove, and a handy test for Saturn as it's a property that most of its data structures are supposed to have. It is important to note that we have simplified our example for this post, and in practice DSCheck also checks for lock-freedom.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#want-more-info" aria-label="want more info permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Want More Info?</h2>
<p>We invite you to discover more about DSCheck and the features that come with the multicore testing suite. You can read about the library on <a href="https://github.com/ocaml-multicore/dscheck#motivation">GitHub</a>, including more examples and performance optimisations since its initial release.</p>
<p>We also previously published a <a href="https://tarides.com/blog/2022-12-22-ocaml-5-multicore-testing-tools/">blog post about Multicore testing tools</a> that includes a section on DSCheck. It provides additional helpful context to the set of tools that surround DSCheck.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#until-next-time" aria-label="until next time permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Until Next Time</h2>
<p>We hope you enjoyed this sojourn into the realm of DSCheck! If you have any questions or comments, please reach out to us on <a href="https://twitter.com/tarides_">X</a> or <a href="https://www.linkedin.com/company/tarides">LinkedIN</a>.</p>
<p>You can also <a href="https://tarides.com/contact/">contact us</a> with questions or feedback and <a href="https://tarides.com/newsletter/">sign up for our newsletter</a> to stay up-to-date with what we're doing.</p>
