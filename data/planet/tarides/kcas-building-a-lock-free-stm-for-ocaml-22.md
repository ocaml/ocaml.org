---
title: 'Kcas: Building a Lock-Free STM for OCaml (2/2)'
description: "This is the follow-up post continuing the discussion of the development
  of Kcas.\nPart 1 discussed the development done on the library to\u2026"
url: https://tarides.com/blog/2023-08-10-kcas-building-a-lock-free-stm-for-ocaml-2-2
date: 2023-08-10T00:00:00-00:00
preview_image: https://tarides.com/static/96f411a726847c30f58ab7482c07ed4a/eee8e/Goldenbrain.jpg
authors:
- Tarides
source:
---

<p>This is the follow-up post continuing the discussion of the development of Kcas.
<a href="https://tarides.com/blog/2023-08-07-kcas-building-a-lock-free-stm-for-ocaml-1-2/">Part 1</a> discussed the development done on the library to improve
performance and add a transaction mechanism that makes it easy to compose
atomic operations without really adding more expressive power.</p>
<p>In this part we'll discuss adding a fundamentally new feature to Kcas that makes it into a proper STM implementation.</p>

<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#get-busy-waiting" aria-label="get busy waiting permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Get Busy Waiting</h3>
<p>If shared memory locations and transactions over them essentially replace
traditional mutexes, then one might ask what replaces condition variables. It is
very common in concurrent programming for threads to not just want to avoid
stepping on each other's toes, or the I of
<a href="https://en.wikipedia.org/wiki/ACID">ACID</a>, but to actually prefer to follow in each other's
footsteps. Or, to put it more technically, wait for events triggered
or data provided by other threads.</p>
<p>Following the approach introduced in the paper
<a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/2005-ppopp-composable.pdf?from=https://research.microsoft.com/~simonpj/papers/stm/stm.pdf">Composable Memory Transactions</a>,
I implemented a retry mechanism that allows a transaction to essentially wait on
arbitrary conditions over the state of shared memory locations. A transaction
may simply raise an exception,
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Retry/index.html#exception-Later"><code>Retry.Later</code></a>,
to signal to the commit mechanism that a transaction should only be retried
after another thread has made changes to the shared memory locations examined by
the transaction.</p>
<p>A trivial example would be to convert a non-blocking take on a queue to a
blocking operation:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> take_blocking <span class="token label property">~xt</span> queue <span class="token operator">=</span>
  <span class="token keyword">match</span> Queue<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>take_opt <span class="token label property">~xt</span> queue <span class="token keyword">with</span>
  <span class="token operator">|</span> None <span class="token operator">-&gt;</span> Retry<span class="token punctuation">.</span>later <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> Some elem <span class="token operator">-&gt;</span> elem</code></pre></div>
<p>Of course, the
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas_data/Kcas_data/Queue/index.html"><code>Queue</code></a>
provided by <strong>kcas_data</strong> already has a blocking take which essentially results in the above
implementation.</p>
<p>Perhaps the main technical challenge in implementing a retry mechanism in
multicore OCaml is that it should perform blocking in a scheduler friendly
manner such that other fibers, as in
<a href="https://github.com/ocaml-multicore/eio">Eio</a>, or tasks, as in
<a href="https://github.com/ocaml-multicore/domainslib">Domainslib</a>, are not prevented
from running on the domain while one of them is blocked. The difficulty with
that is that each scheduler potentially has its own way for suspending a fiber
or waiting for a task.</p>
<p>To solve this problem such that we can provide an updated and convenient blocking experience, we introduced a library that provides a
<a href="https://github.com/ocaml-multicore/domain-local-await/">domain-local-await</a>
mechanism, whose interface is inspired by Arthur Wendling's
<a href="https://github.com/ocaml-multicore/saturn/pull/68">proposal</a> for the Saturn
library. The idea is simple. Schedulers like Eio and Domainslib install their
own implementation of the blocking mechanism, stored in a domain local variable,
and then libraries like Kcas can obtain the mechanism to block in a scheduler
friendly manner. This allows blocking abstractions to not only work on one
specific scheduler, but also allows blocking abstractions to work
<a href="https://discuss.ocaml.org/t/interaction-between-eio-and-domainslib-unhandled-exceptions/11971/10">across different schedulers</a>.</p>
<p>Another challenge is the desire to support both conjunctive and disjunctive
combinations of transactions. As explained in the paper
<a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/2005-ppopp-composable.pdf?from=https://research.microsoft.com/~simonpj/papers/stm/stm.pdf">Composable Memory Transactions</a>,
this in turn requires support for nested transactions. Consider the following attempt at a
conditional blocking take from a queue:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> non_nestable_take_if <span class="token label property">~xt</span> predicate queue <span class="token operator">=</span>
  <span class="token keyword">let</span> x <span class="token operator">=</span> Queue<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>take_blocking <span class="token label property">~xt</span> queue <span class="token keyword">in</span>
  <span class="token keyword">if</span> not <span class="token punctuation">(</span>predicate x<span class="token punctuation">)</span> <span class="token keyword">then</span>
    Retry<span class="token punctuation">.</span>later <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
  x</code></pre></div>
<p>If one were to try to use the above to take an element from the
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-first"><code>first</code></a>
of two queues</p>
<div class="gatsby-highlight" data-language="ml"><pre class="language-ml"><code class="language-ml">Xt.first [
  non_nestable_take_if predicate queue_a;
  non_nestable_take_if predicate queue_b;
]</code></pre></div>
<p>one would run into the following problem: while only a value that passes the
predicate would be returned, an element might be taken from both queues.</p>
<p>To avoid this problem, we need a way to roll back changes recorded by a
transaction attempt. The way Kcas supports this is via an explicit scoping
mechanism. Here is a working (nestable) version of conditional blocking take:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> take_if <span class="token label property">~xt</span> predicate queue <span class="token operator">=</span>
  <span class="token keyword">let</span> snap <span class="token operator">=</span> Xt<span class="token punctuation">.</span>snapshot <span class="token label property">~xt</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> x <span class="token operator">=</span> Queue<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>take_blocking <span class="token label property">~xt</span> queue <span class="token keyword">in</span>
  <span class="token keyword">if</span> not <span class="token punctuation">(</span>predicate x<span class="token punctuation">)</span> <span class="token keyword">then</span>
    Retry<span class="token punctuation">.</span>later <span class="token punctuation">(</span>Xt<span class="token punctuation">.</span>rollback <span class="token label property">~xt</span> snap<span class="token punctuation">)</span><span class="token punctuation">;</span>
  x</code></pre></div>
<p>First a
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-snapshot"><code>snapshot</code></a>
of the transaction log is taken and then, in case the predicate is not
satisfied, a
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-rollback"><code>rollback</code></a>
to the snapshot is performed before signaling a retry. The obvious disadvantage of
this kind of explicit approach is that it requires more care from the
programmer. The advantage is that it allows the programmer to explicitly scope
nested transactions and perform rollbacks only when necessary and in a more
fine-tuned manner, which can allow for better performance.</p>
<p>With properly nestable transactions one can express both conjunctive and
disjunctive compositions of conditional transactions.</p>
<p>As an aside, having talked about the splay tree a few times in my previous post, I should
mention that the implementation of the rollback operation using the splay tree
also worked out surprisingly nicely. In the general case, a rollback may have an
effect on all accesses to shared memory locations recorded in a transaction log.
This means that, in order to support rollback, worst case linear time cost in
the number of locations accessed seems to be the minimum &mdash; no matter how
transactions might be implemented. A single operation on a splay tree may
already take linear time, but it is also possible to take advantage of the tree
structure and sharing of the immutable spine of splay trees and stop early as
soon as the snapshot and the log being rolled back are the same.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#will-they-come" aria-label="will they come permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Will They Come</h3>
<p>Blocking or retrying a transaction indefinitely is often not acceptable. The
transaction mechanism with blocking is actually already powerful enough to
support timeouts, because a transaction will be retried after any location
accessed by the transaction has been modified. So, to have timeouts, one could
create a location, make it so that it is changed when the timeout expires, and
read that location in the transaction to determine whether the timeout has
expired.</p>
<p>Creating, checking, and also cancelling timeouts manually can be a lot of work.
For this reason Kcas was also extended with direct support for timeouts. To
perform a transaction with a timeout one can simply explicitly specify a
<code>timeoutf</code> in seconds:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> try_take_in <span class="token label property">~seconds</span> queue <span class="token operator">=</span>
  Xt<span class="token punctuation">.</span>commit <span class="token label property">~timeoutf</span><span class="token punctuation">:</span>seconds <span class="token punctuation">{</span> tx <span class="token operator">=</span> Queue<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>take_blocking queue <span class="token punctuation">}</span></code></pre></div>
<p>Internally Kcas uses the
<a href="https://github.com/ocaml-multicore/domain-local-timeout">domain-local-timeout</a>
library for timeouts. The OCaml standard library doesn't directly provide a
timeout mechanism, but it is a typical service provided by concurrent
schedulers. Just like with the previously mentioned domain local <em>await</em>, the
idea with domain local <em>timeout</em> is to allow libraries like Kcas to tap into the
native mechanism of whatever scheduler is currently in use and to do so
conveniently without pervasive parameterisation. More generally this should
allow libraries like Kcas to be scheduler agnostic and help to
<a href="http://rgrinberg.com/posts/abandoning-async/">avoid duplication of effort</a>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#hollow-man" aria-label="hollow man permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Hollow Man</h3>
<p>Let's recall the features of Kcas transactions briefly.</p>
<p>First of all, passing the transaction <code>~xt</code> through the computation allows
<em>sequential composition</em> of transactions:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> bind <span class="token label property">~xt</span> a b <span class="token operator">=</span>
  <span class="token keyword">let</span> x <span class="token operator">=</span> a <span class="token label property">~xt</span> <span class="token keyword">in</span>
  b <span class="token label property">~xt</span> x</code></pre></div>
<p>This also gives <em>conjunctive composition</em> as a trivial consequence:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> pair <span class="token label property">~xt</span> a b <span class="token operator">=</span>
  <span class="token punctuation">(</span>a <span class="token label property">~xt</span><span class="token punctuation">,</span> b <span class="token label property">~xt</span><span class="token punctuation">)</span></code></pre></div>
<p>Nesting, via
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-snapshot"><code>snapshot</code></a>
and
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-rollback"><code>rollback</code></a>,
allows <em>conditional composition</em>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> if_else <span class="token label property">~xt</span> predicate a b <span class="token operator">=</span>
  <span class="token keyword">let</span> snap <span class="token operator">=</span> Xt<span class="token punctuation">.</span>snapshot <span class="token label property">~xt</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> x <span class="token operator">=</span> a <span class="token label property">~xt</span> <span class="token keyword">in</span>
  <span class="token keyword">if</span> predicate x <span class="token keyword">then</span>
    x
  <span class="token keyword">else</span> <span class="token keyword">begin</span>
    Xt<span class="token punctuation">.</span>rollback <span class="token label property">~xt</span> snap<span class="token punctuation">;</span>
    b <span class="token label property">~xt</span>
  <span class="token keyword">end</span></code></pre></div>
<p>Nesting combined with blocking, via the
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Retry/index.html#exception-Later"><code>Retry.Later</code></a>
exception, allows <em>disjunctive composition</em></p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> or_else <span class="token label property">~xt</span> a b <span class="token operator">=</span>
  <span class="token keyword">let</span> snap <span class="token operator">=</span> Xt<span class="token punctuation">.</span>snapshot <span class="token label property">~xt</span> <span class="token keyword">in</span>
  <span class="token keyword">match</span> a <span class="token label property">~xt</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> x <span class="token operator">-&gt;</span> x
  <span class="token operator">|</span> <span class="token keyword">exception</span> Retry<span class="token punctuation">.</span>Later <span class="token operator">-&gt;</span>
    Xt<span class="token punctuation">.</span>rollback <span class="token label property">~xt</span> snap<span class="token punctuation">;</span>
    b <span class="token label property">~xt</span></code></pre></div>
<p>of blocking transactions, which is also supported via the
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-first"><code>first</code></a>
combinator.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#what-is-missing" aria-label="what is missing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is Missing?</h3>
<blockquote>
<p>The limits of my language mean the limits of my world. &mdash; Ludwig
Wittgenstein</p>
</blockquote>
<p>The main limitation of transactions is that they are invisible to each other. A
transaction does not directly modify any shared memory locations and, once it
does, the modifications appear as atomic to other transactions and outside
observers.</p>
<p>The mutual invisibility means that
<a href="https://en.wikipedia.org/wiki/Rendezvous_(Plan_9)">rendezvous</a> between two
(or more) threads cannot be expressed as a pair of composable transactions. For
example, it is not possible to implement synchronous message passing as can be
found e.g. in
<a href="https://people.cs.uchicago.edu/~jhr/papers/cml.html">Concurrent ML</a>,
<a href="https://go.dev/">Go</a>, and various other languages and libraries, including zero
capacity Eio
<a href="https://ocaml-multicore.github.io/eio/eio/Eio/Stream/index.html#val-create"><code>Stream</code></a>s,
as simple transactions with a signature such as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token keyword">type</span> Channel <span class="token operator">=</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> <span class="token type-variable function">'a</span> t
  <span class="token keyword">module</span> Xt <span class="token punctuation">:</span> <span class="token keyword">sig</span>
    <span class="token keyword">val</span> give <span class="token punctuation">:</span> xt<span class="token punctuation">:</span><span class="token type-variable function">'x</span> Xt<span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> <span class="token operator">-&gt;</span> unit
    <span class="token keyword">val</span> take <span class="token punctuation">:</span> xt<span class="token punctuation">:</span><span class="token type-variable function">'x</span> Xt<span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span>
  <span class="token keyword">end</span>
<span class="token keyword">end</span></code></pre></div>
<p>Languages such as Concurrent ML and Go allow disjunctive composition of such
synchronous message passing operations and some other libraries even allow
conjunctive, e.g. <a href="http://twistedsquare.com/CHP.pdf">CHP</a>, or even sequential
composition, e.g.
<a href="https://www.cs.cornell.edu/people/fluet/research/tx-events/ICFP06/icfp06.pdf">TE</a>
and <a href="https://aturon.github.io/academic/reagents.pdf">Reagents</a>, of such message
passing operations.</p>
<p>Although the above <code>Channel</code> signature is unimplementable, it does not mean that
one could not implement a non-compositional <code>Channel</code></p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token keyword">type</span> Channel <span class="token operator">=</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> <span class="token type-variable function">'a</span> t
  <span class="token keyword">val</span> give <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> <span class="token operator">-&gt;</span> unit
  <span class="token keyword">val</span> take <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span>
<span class="token keyword">end</span></code></pre></div>
<p>or implement a compositional message passing model that allows such operations
to be composed. Indeed, both the <a href="http://twistedsquare.com/CHP.pdf">CHP</a> and
<a href="https://www.cs.cornell.edu/people/fluet/research/tx-events/ICFP06/icfp06.pdf">TE</a>
libraries were implemented on top of Software Transactional Memory with the same
fundamental invisibility of transactions. In other words, it is possible to
build a new composition mechanism, distinct from transactions, by using
transactions. To allow such synchronisation between threads requires committing
multiple transactions.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#torn-reads" aria-label="torn reads permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Torn Reads</h3>
<p>The k-CAS-n-CMP algorithm underlying Kcas ensures that it is not possible to
read uncommitted changes to shared memory locations and that an operation can
only commit successfully after all of the accesses taken together have been
atomic, i.e. strictly serialisable or both
<a href="https://en.wikipedia.org/wiki/Linearizability">linearisable</a> and
<a href="https://en.wikipedia.org/wiki/Serializability">serialisable</a> in database
terminology. These are very strong guarantees and make it much easier to
implement correct concurrent algorithms.</p>
<p>Unfortunately, the k-CAS-n-CMP algorithm does not prevent one specific
concurrency anomaly. When a transaction reads multiple locations, it is possible
for the transaction to observe an inconsistent state when other transactions commit
changes between reads of different locations. This is traditionally called <em>read
skew</em> in database terminology. Having observed such an inconsistent state, a
Kcas transaction cannot succeed and must be retried.</p>
<p>Even though a transaction must retry after having observed read skew, unless
taken into account, read skew can still cause serious problems. Consider, for
example, the following transaction:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> unsafe_subscript <span class="token label property">~xt</span> array index <span class="token operator">=</span>
  <span class="token keyword">let</span> a <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> array <span class="token keyword">in</span>
  <span class="token keyword">let</span> i <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> index <span class="token keyword">in</span>
  a<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span></code></pre></div>
<p>The assumption is that the <code>array</code> and <code>index</code> locations are always updated
atomically such that the subscript operation should be safe. Unfortunately due
to read skew the array and index might not match and the subscript operation
could result in an &quot;index out of bounds&quot; exception.</p>
<p>Even more subtle problems are possible. For example, a balanced binary search
tree implementation using
<a href="https://en.wikipedia.org/wiki/Tree_rotation">rotations</a> can, due to read skew,
be seen to have a cycle. Consider the below diagram. Assume that a lookup for
node <code>2</code> has just read the link from node <code>3</code> to node <code>1</code>. At that point another
transaction commits a rotation that makes node <code>3</code> a child of node <code>1</code>. As the
lookup reads the link from node <code>1</code> it leads back to node <code>3</code> creating a cycle.</p>
<p align="center">
  <img src="https://tarides.com/blog/2023-06-01.building-a-lock-free-stm-for-ocaml/img-rotation-cycle-light.svg" alt="Tree rotations"/>
</p>
<p>There are several ways to deal with these problems. It is, of course, possible
to use ad hoc techniques, like checking invariants manually, within
transactions. The Kcas library itself addresses these problems in a couple of
ways.</p>
<p>First of all, Kcas performs periodic validation of the entire transaction log
when an access, such as <code>get</code> or <code>set</code>, of a shared memory location is made
through the transaction log. It would take quadratic time to validate the entire
log on every access. To avoid changing the time complexity of transactions, the
number of accesses between validations is doubled after each validation.</p>
<p>Periodic validation is an effective way to make loops that access shared memory
locations, such as the lookup of a key from a binary search tree, resistant
against read skew. Such loops will eventually be aborted on some access and will
then be retried. Periodic validation is not effective against problems that
might occur due to non-transactional operations made after reading inconsistent
state. For those cases an explicit
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas/Kcas/Xt/index.html#val-validate"><code>validate</code></a>
operation is provided that can be used to validate that the accesses of
particular locations have been atomic:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> subscript <span class="token label property">~xt</span> array index <span class="token operator">=</span>
  <span class="token keyword">let</span> a <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> array <span class="token keyword">in</span>
  <span class="token keyword">let</span> i <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> index <span class="token keyword">in</span>
  <span class="token comment">(* Validate accesses after making them: *)</span>
  Xt<span class="token punctuation">.</span>validate <span class="token label property">~xt</span> index<span class="token punctuation">;</span>
  Xt<span class="token punctuation">.</span>validate <span class="token label property">~xt</span> array<span class="token punctuation">;</span>
  a<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span></code></pre></div>
<p>It is entirely fair to ask whether it is acceptable for an STM mechanism to
allow read skew. A candidate correctness criterion for transactional memory
called &quot;opacity&quot;, introduced in the paper
<a href="https://dl.acm.org/doi/10.1145/1345206.1345233">On the correctness of transactional memory</a>,
does not allow it. The trade-off is that the known software techniques to
provide opacity tend to introduce a global sequential bottleneck, such as a
global transaction version number accessed by every transaction, that can and
<a href="https://en.wikipedia.org/wiki/Amdahl's_law">will limit scalability</a>
especially when transactions are relatively short, which is usually the case.</p>
<p>At the time of writing this there are several STM implementations that do not
provide opacity. The current Haskell STM implementation, for example,
<a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/2005-ppopp-composable.pdf">introduced in 2005</a>,
allows similar read skew. In Haskell, however, STM is implemented at the runtime
level and transactions are guaranteed to be pure by the type system. This allows
the Haskell STM runtime to validate transactions when switching threads.
Nevertheless there have been experiments to replace the Haskell STM using
algorithms that provide opacity as described in the paper
<a href="https://dl.acm.org/doi/abs/10.1145/3241625.2976020">Revisiting software transactional memory in Haskell</a>,
for example. The Scala ZIO STM
<a href="https://github.com/zio/zio/issues/6324">also allows read skew</a>. In his talk
<a href="https://www.youtube.com/watch?v=k20nWb9fHj0">Transactional Memory in Practice</a>,
Brett Hall describes their experience in using a STM in C++ that also allows
read skew.</p>
<p>It is not entirely clear how problematic it is to have to account for the possibility
of read skew. Although I expect to see read skew issues in the
future, the relative success of the Haskell STM would seem to suggest that it is
not necessarily a show stopper. While advanced data structure implementations
tend to have intricate invariants and include loops, compositions of
transactions using such data structures, like the LRU cache implementation, tend
to be loopless and relatively free of such invariants and work well.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#tomorrow-may-come" aria-label="tomorrow may come permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tomorrow May Come</h3>
<p>At the time of writing this, the <code>kcas</code> and <code>kcas_data</code> packages are still
marked experimental, but are very close to being labeled 1.0.0. The core Kcas
library itself is more or less feature complete. The Kcas data library, by its
nature, could acquire new data structure implementations over time, but there is
one important feature missing from Kcas data &mdash; a bounded queue.</p>
<p>It is, of course, possible to simply compose a transaction that checks the
length of a queue. Unfortunately that would not perform optimally, because
computing the exact length of a queue unavoidably requires synchronisation
between readers and writers. A bounded queue implementation doesn't usually need
to know the exact length &mdash; it only needs to have a conservative
approximation of whether there is room in the queue and then the computation of
the exact length can be avoided much of the time. Ideally the default queue
implementation would allow an optional capacity to the specified. The challenge
is to implement the queue without making it any slower in the unbounded case.</p>
<p>Less importantly the Kcas data library currently does not provide an ordered map
nor a priority queue. Those serve use cases that are not covered by the current
selection of data structures. For an ordered map something like a
<a href="https://en.wikipedia.org/wiki/WAVL_tree">WAVL tree</a> could be a good starting
point for a reasonably scalable implementation. A priority queue, on the other
hand, is more difficult to scale, because the top element of a priority queue
might need to be examined or even change on every mutation, which makes it a
sequential bottleneck. On the other hand, updating elements far from the top
shouldn't require much synchronisation. Some sort of two level scheme like a
priority queue of per domain priority queues might provide best of both worlds.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#but-why" aria-label="but why permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>But Why?</h3>
<p>If you look at a typical textbook on concurrent programming it will likely tell
you that the essence of concurrent programming boils down to two (or three)
things:</p>
<ul>
<li>independent sequential threads of control, and</li>
<li>mechanisms for threads to communicate and synchronise.</li>
</ul>
<p>The first bullet on that list has received a lot of focus in the form of
libraries like <a href="https://github.com/ocaml-multicore/eio">Eio</a> and
<a href="https://github.com/ocaml-multicore/domainslib">Domainslib</a> that utilise OCaml's
support for algebraic effects. Indeed, the second bullet is kind of meaningless
unless you have threads. However, that does not make it less important.</p>
<p>Programming with threads is all about how threads communicate and synchronise
with each other.</p>
<p>A survey of concurrent programming techniques could easily fill an entire book,
but if you look at most typical programming languages, they provide you with a
plethora of communication and synchronisation primitives such as</p>
<ul>
<li>atomic operations,</li>
<li>spin locks,</li>
<li>barriers and count down latches,</li>
<li>semaphores,</li>
<li>mutexes and condition variables,</li>
<li>message queues,</li>
<li>other concurrent collections,</li>
<li>and more.</li>
</ul>
<p>The main difficulty with these traditional primitives is their relative lack of
composability. Every concurrency problem becomes a puzzle whose solution is some
ad hoc combination of these primitives. For example, given a concurrent thread
safe stack and a queue it may be impossible to atomically move an element from
the stack to the queue without wrapping both behind some synchronisation
mechanism, which also likely reduces scalability.</p>
<p>There are also some languages based on asynchronous message passing with the
ability to receive multiple messages selectively using both conjunctive and
disjunctive patterns. A few languages are based on rendezvous or synchronous
message passing and offer the ability to disjunctively and sometimes also
conjunctively select between potential communications. I see these as
fundamentally different from the traditional primitives as the number of
building blocks is much smaller and the whole is more like unified language for
solving concurrency problems rather than just a grab bag of non-composable
primitives. My observation, however, has been that these kind of message passing
models are not familiar to most programmers and can be challenging to program
with.</p>
<p>As an aside, why should one care about composability? Why would anyone care
about being able to e.g. disjunctively either pop an element from a stack or
take an element from a queue, but not both, atomically? Well, it is not about
stacks and queues, those are just examples. It is about modularity and
scalability. Being able to, in general, understand independently developed
concurrent abstractions on their own and to also combine them to form effective
and efficient solutions to new problems.</p>
<p>Another approach to concurrent programming is transactions over mutable data
structures whether in the form of databases or Software Transactional Memory
(STM). Transactional databases, in particular, have definitely proven to be a
major enabler. STM hasn't yet had a similar impact. There are probably many
reasons for that. One probable reason is that many languages already offered a
selection of familiar traditional primitives and millions of lines of code using
those before getting STM. Another reason might be that attempts to provide STM
in a form where one could just wrap any code inside an atomic block and have it
work perfectly proved to be unsuccessful. This resulted in many publications and
blog posts, e.g.
<a href="https://joeduffyblog.com/2010/01/03/a-brief-retrospective-on-transactional-memory/">A (brief) retrospective on transactional memory</a>,
discussing the problems resulting from such doomed attempts and likely
contributed to making STM seem less desirable.</p>
<p>However, STM is not without some success. More modest, and more successful,
approaches either strictly limit what can be performed atomically or require the
programmer to understand the limits and program accordingly. While not a
panacea, STM provides both composability and a relatively simple and familiar
programming model based on mutable shared memory locations.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#crossroads" aria-label="crossroads permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Crossroads</h3>
<p>Having just recently acquired the ability to have multiple domains running in
parallel, OCaml is in a unique position. Instead of having a long history of
concurrent multicore programming we can start afresh.</p>
<p>What sort of model of concurrent programming should OCaml offer?</p>
<p>One possible road for OCaml to take would be to offer STM as the go-to approach
for solving most concurrent programming problems.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#until-next-time" aria-label="until next time permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Until Next Time</h3>
<p>I've had a lot of fun working on Kcas. I'd like to thank my colleagues for
putting up with my obsession to work on it. I also hope that people will find
Kcas and find it useful or learn something from it!</p>
