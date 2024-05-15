---
title: 'Kcas: Building a lock-free STM for OCaml (1/2)'
description: "In the past few months I've had the pleasure of working on the\nKcas
  library. In this and a\nfollow-up post, I will discuss the history and\u2026"
url: https://tarides.com/blog/2023-08-07-kcas-building-a-lock-free-stm-for-ocaml-1-2
date: 2023-08-07T00:00:00-00:00
preview_image: https://tarides.com/static/09d856002f1fda79e188e6d85b5c79ea/0132d/robynne-hu-HOrhCnQsxnQ-unsplash.jpg
authors:
- Tarides
source:
---

<p>In the past few months I've had the pleasure of working on the
<a href="https://github.com/ocaml-multicore/kcas/">Kcas</a> library. In this and a
follow-up post, I will discuss the history and more recent development process
of optimising Kcas and turning it into a proper Software Transactional Memory
(STM) implementation for OCaml.</p>
<p>While this is not meant to serve as an introduction to programming with Kcas,
along the way we will be looking at a few code snippets. To ensure that they are
type correct &mdash; the best kind of
correct<sup><a href="https://www.youtube.com/watch?v=hou0lU8WMgo">*</a></sup> &mdash; I'll
use the <a href="https://github.com/realworldocaml/mdx#readme">MDX</a> tool to test them.
So, before we continue, let's require the libraries that we will be using:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token punctuation">#</span> <span class="token directive property">#require</span> <span class="token string">&quot;kcas&quot;</span>
<span class="token punctuation">#</span> <span class="token keyword">open</span> Kcas
<span class="token punctuation">#</span> <span class="token directive property">#require</span> <span class="token string">&quot;kcas_data&quot;</span>
<span class="token punctuation">#</span> <span class="token keyword">open</span> Kcas_data</code></pre></div>
<p>All right, let us begin!</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#origins" aria-label="origins permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Origins</h3>
<p>Contrary to popular belief, the name &quot;Kcas&quot; might not be an abbreviation of KC
and
Sadiq<sup><a title="Sadiq once joked 'I like that we named the library after KC too.'">*</a></sup>
&mdash; two early contributors to the library. The Kcas library was originally
developed for the purpose of implementing
<a href="https://aturon.github.io/academic/reagents.pdf">Reagents</a> for OCaml and is an
implementation of multi-word compare-and-set, often abbreviated as MCAS, CASN,
or &mdash; wait for it &mdash; k-CAS.</p>
<p>But what is this multi-word compare-and-set?</p>
<p>Well, it is a tool for designing lock-free algorithms that allows atomic
operations to be performed over multiple shared memory locations. Hardware
traditionally only supports the ability to perform atomic operations on
individual words, i.e. a single-word
<a href="https://v2.ocaml.org/api/Atomic.html#VALcompare_and_set">compare-and-set</a>
(CAS). Kcas basically extends that ability, through the use of intricate
algorithms, so that it works over any number of words.</p>
<p>Suppose, for example, that we are implementing operations on doubly-linked
circular lists. Instead of using a mutable field, <code>ref</code>, or <code>Atomic.t</code>, we'd use
a shared memory location, or
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Loc/index.html#type-t"><code>Loc.t</code></a>,
for the pointers in our node type:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> <span class="token type-variable function">'a</span> node <span class="token operator">=</span> <span class="token punctuation">{</span>
  succ<span class="token punctuation">:</span> <span class="token type-variable function">'a</span> node Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  pred<span class="token punctuation">:</span> <span class="token type-variable function">'a</span> node Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  datum<span class="token punctuation">:</span> <span class="token type-variable function">'a</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>To remove a node safely we want to atomically update the <code>succ</code> and <code>pred</code>
pointers of the predecessor and successor nodes and to also update the <code>succ</code>
and <code>pred</code> pointers of a node to point to the node itself, so that removal
becomes an <a href="https://en.wikipedia.org/wiki/Idempotence">idempotent</a> operation.
Using a multi-word compare-and-set one could implement the <code>remove</code> operation as
follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> remove <span class="token operator">?</span><span class="token punctuation">(</span>backoff <span class="token operator">=</span> Backoff<span class="token punctuation">.</span>default<span class="token punctuation">)</span> node <span class="token operator">=</span>
  <span class="token comment">(* Read pointer to the predecessor node and... *)</span>
  <span class="token keyword">let</span> pred <span class="token operator">=</span> Loc<span class="token punctuation">.</span>get node<span class="token punctuation">.</span>pred <span class="token keyword">in</span>
  <span class="token comment">(* ..check whether the node has already been removed. *)</span>
  <span class="token keyword">if</span> pred <span class="token operator">!=</span> node <span class="token keyword">then</span>
    <span class="token keyword">let</span> succ <span class="token operator">=</span> Loc<span class="token punctuation">.</span>get node<span class="token punctuation">.</span>succ <span class="token keyword">in</span>
    <span class="token keyword">let</span> ok <span class="token operator">=</span> Op<span class="token punctuation">.</span>atomically <span class="token punctuation">[</span>
      <span class="token comment">(* Update pointers in this node: *)</span>
      Op<span class="token punctuation">.</span>make_cas node<span class="token punctuation">.</span>succ succ node<span class="token punctuation">;</span>
      Op<span class="token punctuation">.</span>make_cas node<span class="token punctuation">.</span>pred pred node<span class="token punctuation">;</span>
      <span class="token comment">(* Update pointers to this node: *)</span>
      Op<span class="token punctuation">.</span>make_cas pred<span class="token punctuation">.</span>succ node succ<span class="token punctuation">;</span>
      Op<span class="token punctuation">.</span>make_cas succ<span class="token punctuation">.</span>pred node pred<span class="token punctuation">;</span>
    <span class="token punctuation">]</span> <span class="token keyword">in</span>
    <span class="token keyword">if</span> not ok <span class="token keyword">then</span>
      <span class="token comment">(* Someone modified the list around us, so backoff and retry. *)</span>
      remove <span class="token label property">~backoff</span><span class="token punctuation">:</span><span class="token punctuation">(</span>Backoff<span class="token punctuation">.</span>once backoff<span class="token punctuation">)</span> node</code></pre></div>
<p>The list given to
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Op/index.html#val-atomically"><code>Op.atomically</code></a>
contains the individual compare-and-set operations to perform. A single
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Op/index.html#val-make_cas"><code>Op.make_cas loc expected desired</code></a>
operation specifies to compare the current value of a location with the expected
value and, in case they are the same, set the value of the location to the
desired value.</p>
<p>Programming like this is similar to programming with single-word compare-and-set
except that the operation is extended to being able to work on multiple words.
It does get the job done, but I feel it is fair to say that this is a low level
tool only suitable for experts implementing lock-free algorithms.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#getting-curious" aria-label="getting curious permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Getting Curious</h3>
<p>I became interested in working on the Kcas library after Bartosz Modelski asked
me to review a couple of PRs to Kcas. As it happens, I had implemented the same
k-CAS algorithm, based on the paper
<a href="https://www.cl.cam.ac.uk/research/srg/netos/papers/2002-casn.pdf">A Practical Multi-Word Compare-and-Swap Operation</a>,
a few years earlier in C++ as a hobby project. I had also considered
implementing Reagents and had implemented a prototype library based on the
<a href="https://dl.acm.org/doi/10.1007/11864219_14">Transactional Locking II</a> (TL2)
algorithm for software transactional memory (STM) in C++ as another hobby
project. While reviewing the library, I could see some potential for
improvements.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#fine-grained-competition" aria-label="fine grained competition permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fine Grained Competition</h3>
<p>One of the issues in Kcas mentioned a new paper on
<a href="https://arxiv.org/pdf/2008.02527.pdf">Efficient Multi-word Compare and Swap</a>.
It was easy to adapt the new algorithm, which can even be seen as a
simplification of the previous algorithm, to OCaml. Compared to the previous
algorithm, which took <code>3k+1</code> single word CAS operations per <code>k</code>-CAS, the new
algorithm only took <code>k+1</code> single word CAS operations and was much faster. This
basically made k-CAS potentially competitive with fine grained locking
approaches, that also tend to require roughly the equivalent of one CAS per
word, used in many STM implementations.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#two-birds-with-one-stone" aria-label="two birds with one stone permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Two Birds with One Stone</h3>
<p>Both the original algorithm and the new algorithm require the locations being
updated to be in some total order. Any ordering that is used consistently in all
potentially overlapping operations would do, but the shared memory locations
created by Kcas also include a unique integer id, which can be used for ordering
locations. Initially Kcas required the user to sort the list of CAS operations.
Later an internal sorting step, that was performed by default by essentially
calling <code>List.sort</code> and taking
<a href="https://en.wikipedia.org/wiki/Time_complexity#Linearithmic_time">linearithmic</a>
<code>O(n*log(n))</code> time, was added to Kcas to make the interface less error prone.
This works, but it is possible to do better. Back when I implemented a TL2
prototype in C++ as a hobby project, I had used a
<a href="https://en.wikipedia.org/wiki/Splay_tree">splay tree</a> to record accesses of
shared memory locations. Along with the new algorithm, I also changed Kcas to
use a splay tree to store the operations internally. The splay tree was
constructed from the list of operations given by the user and then the splay
tree, instead of a list, would be traversed during the main algorithm.</p>
<p>You could ask what makes a splay tree interesting for this particular use case.
Well, there are a number of reasons. First of all, the new algorithm requires
allocating internal descriptors for each operation anyway, because those
descriptors are essentially consumed by the algorithm. So, even when the sorting
step would be skipped, an ordered data structure of descriptors would still need
to be allocated. However, what makes a splay tree particularly interesting for
this purpose is that, unlike most self-balancing trees, it can perform a
sequence of <code>n</code> accesses in linear time <code>O(n)</code>. This happens, for example, when
the accesses are in either ascending or descending order. In those cases, as
shown in the diagram below, the result is either a left or right leaning tree,
respectively, much like a list.</p>
<p align="center">
  <img src="https://tarides.com/blog/2023-06-01.building-a-lock-free-stm-for-ocaml/img-access-sequence-light.svg"/>
</p>
<p>This means that a performance conscious user could simply make sure to provide
the locations in either order and the internal tree would be constructed in
linear time and could then be traversed, also in linear time, in ascending
order. For the general case a splay tree also guarantees the same linearithmic
<code>O(n*log(n))</code> time as sorting.</p>
<p>With some fast path optimisations for preordered sequences the splay tree
construction was almost free and the flag to skip the by default sorting step
could be removed without making performance worse.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#keeping-a-journal" aria-label="keeping a journal permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Keeping a Journal</h3>
<p>Having the splay tree also opened the possibility of implementing a higher level
transactional interface.</p>
<p>But what is a transaction?</p>
<p>Well, a transaction in Kcas is essentially a function that records a log of
accesses, i.e. reads and writes, to shared memory locations. When
accessing a location for the first time, whether for reading or for writing, the
value of that location is read and stored in the log. Then, instead of reading
the location again or writing to it, the entry for the location is looked up
from the log and any change is recorded in the entry. So, a transaction does not
directly mutate shared memory locations. A transaction merely reads their
initial values and records what the effects of the accesses would be.</p>
<p>Recall the example of how to remove a node from a doubly-linked circular list.
Using the transactional interface of Kcas, we could write a transaction to
remove a node as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> remove <span class="token label property">~xt</span> node <span class="token operator">=</span>
  <span class="token comment">(* Read pointers to the predecessor and successor nodes: *)</span>
  <span class="token keyword">let</span> pred <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> node<span class="token punctuation">.</span>pred <span class="token keyword">in</span>
  <span class="token keyword">let</span> succ <span class="token operator">=</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> node<span class="token punctuation">.</span>succ <span class="token keyword">in</span>
  <span class="token comment">(* Update pointers in this node: *)</span>
  Xt<span class="token punctuation">.</span>set <span class="token label property">~xt</span> node<span class="token punctuation">.</span>succ node<span class="token punctuation">;</span>
  Xt<span class="token punctuation">.</span>set <span class="token label property">~xt</span> node<span class="token punctuation">.</span>pred node<span class="token punctuation">;</span>
  <span class="token comment">(* Update pointers to this node: *)</span>
  Xt<span class="token punctuation">.</span>set <span class="token label property">~xt</span> pred<span class="token punctuation">.</span>succ succ<span class="token punctuation">;</span>
  Xt<span class="token punctuation">.</span>set <span class="token label property">~xt</span> succ<span class="token punctuation">.</span>pred pred</code></pre></div>
<p>The labeled argument, <code>~xt</code>, refers to the transaction log. Transactional
operations like
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Xt/index.html#val-get"><code>get</code></a>
and
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Xt/index.html#val-set"><code>set</code></a>
are then recorded in that log. To actually remove a node, we need to commit the
transaction</p>
<div class="gatsby-highlight" data-language="ml"><pre class="language-ml"><code class="language-ml">Xt.commit { tx = remove node }</code></pre></div>
<p>which repeatedly calls the transaction function, <code>tx</code>, to record a transaction
log and attempts to atomically perform it until it succeeds.</p>
<p>Notice that <code>remove</code> is no longer recursive. It doesn't have to account for
failure or perform a backoff. It is also not necessary to know or keep track of
what the previous values of locations were. All of that is taken care of for us
by the transaction log and the
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Xt/index.html#val-commit"><code>commit</code></a>
function. But, I digress.</p>
<p>Having the splay tree made the implementation of the transactional interface
straightforward. Transactional operations would just use the splay tree to
lookup and record accesses of shared memory locations. The
<a href="https://ocaml-multicore.github.io/kcas/0.6.0/kcas/Kcas/Xt/index.html#val-commit"><code>commit</code></a>
function just calls the transaction with an empty splay tree and then passes the
resulting tree to the internal k-CAS algorithm.</p>
<p>But why use a splay tree? One could suggest e.g. using a hash table for the
transaction log. Accesses of individual locations would then be constant time.
However, a hash table doesn't sort the entries, so we would need something more
for that purpose. Another alternative would be to just use an unordered list or
table and perhaps use something like a
<a href="https://en.wikipedia.org/wiki/Bloom_filter">bloom filter</a> to check whether a
location has already been accessed as most accesses are likely to either target
new locations or a recently used location. However, with k-CAS, it would still
be necessary to sort the accesses later and, without some way to perform
efficient lookups, worst case performance would be quadratic <code>O(n&sup2;)</code>.</p>
<p>For the purpose of implementing a transaction log, rather than just for the
purpose of sorting a list of operations, a splay tree also offers further
advantages. A splay tree works a bit like a cache, making accesses to recently
accessed elements faster. In particular, the pattern where a location is first
read and then written</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> decr_if_positive <span class="token label property">~xt</span> x <span class="token operator">=</span>
  <span class="token keyword">if</span> Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> x <span class="token operator">&gt;</span> <span class="token number">0</span> <span class="token keyword">then</span>
    Xt<span class="token punctuation">.</span>decr <span class="token label property">~xt</span> x</code></pre></div>
<p>is optimised by the splay tree. The first access brings the location to the root
of the tree. The second access is then guaranteed constant time.</p>
<p>Using a splay tree as the transaction log also allows the user to optimise
transactions similarly to avoiding the cost of the linearithmic sorting step. A
transaction over an array of locations, for example, can be performed in linear
time simply by making sure that the locations are accessed in order.</p>
<p>Of course, none of this means that a splay tree is necessarily the best or the
most efficient data structure to implement a transaction log. Far from it. But
in OCaml, with fast memory allocations, it is probably difficult to do much
better without additional runtime or compiler support.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#take-a-number" aria-label="take a number permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Take a Number</h3>
<p>One nice thing about transactions is that the user no longer has to write loops
to perform them. With a primitive (multi-word) CAS one needs to have some
strategy to deal with failures. If an operation fails, due to another CPU core
having won the race to modify some location, it is generally not a good idea to
just immediately retry. The problem with that is that there might be multiple
CPU cores trying to access the same locations in parallel. Everyone always
retrying at the same time potentially leads to quadratic <code>O(n&sup2;)</code> bus traffic to
synchronise shared memory as every round of retries generates <code>O(n)</code> amount of
bus traffic.</p>
<p>Suppose multiple CPU cores are all simultaneously running the following na&iuml;ve
lock-free algorithm to increment an atomic location:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> naive_incr atomic <span class="token operator">=</span>
  <span class="token keyword">let</span> n <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>get atomic <span class="token keyword">in</span>
  <span class="token keyword">if</span> not <span class="token punctuation">(</span>Atomic<span class="token punctuation">.</span>compare_and_set atomic n <span class="token punctuation">(</span>n <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token keyword">then</span>
    naive_incr atomic</code></pre></div>
<p>All CPU cores read the value of the location and then attempt a compare-and-set.
Only one of them can succeed on each round of attempts. But one might still
reasonably ask: what makes this so expensive? Well, the problem comes from
<a href="https://en.wikipedia.org/wiki/MSI_protocol">the way shared memory works</a>.
Basically, when a CPU core reads a location, the location will be stored in the
cache of that core and will be marked as &quot;shared&quot; in the caches of all CPUs that
have also read that location. On the other hand, when a CPU core writes to a
location, the location will be marked as &quot;modified&quot; in the cache of that core
and as &quot;invalid&quot; in the caches of all the other cores. Although a
compare-and-set doesn't always logically write to memory, to ensure atomicity,
the CPU acts as if it does. So, on each round through the algorithm, each core
will, in turn, attempt to write to the location, which invalidates the location
in the caches of all the other cores, and require them to read the location
again. These invalidations and subsequent reads of the location tend to be very
resource intensive.</p>
<p>In some lock-free algorithms it is possible to use auxiliary data structures to
<a href="https://people.csail.mit.edu/shanir/publications/Lock_Free.pdf">deal with contention scalably</a>,
but when the specifics of the use case are unknown, something more general is
needed. Assume that, instead of all the cores retrying at the same time, the
cores would somehow form a queue and attempt their operations one at a time.
Each successful increment would still mean that the next core to attempt
increment would have to expensively read the location, but since only one core
makes the attempt, the amount of bus traffic would be linear <code>O(n)</code>.</p>
<p>A clever way to form a kind of queue is to use
<a href="https://en.wikipedia.org/wiki/Exponential_backoff">randomised exponential backoff</a>.
A random delay or backoff is applied before retrying:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> incr_with_backoff <span class="token operator">?</span><span class="token punctuation">(</span>backoff <span class="token operator">=</span> Backoff<span class="token punctuation">.</span>default<span class="token punctuation">)</span> atomic <span class="token operator">=</span>
  <span class="token keyword">let</span> n <span class="token operator">=</span> Atomic<span class="token punctuation">.</span>get atomic <span class="token keyword">in</span>
  <span class="token keyword">if</span> not <span class="token punctuation">(</span>Atomic<span class="token punctuation">.</span>compare_and_set atomic n <span class="token punctuation">(</span>n <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token keyword">then</span>
    incr_with_backoff <span class="token label property">~backoff</span><span class="token punctuation">:</span><span class="token punctuation">(</span>Backoff<span class="token punctuation">.</span>once backoff<span class="token punctuation">)</span> atomic</code></pre></div>
<p>If multiple parties are involved, this makes them retry in some random order. At
first everyone retries relatively quickly and that can cause further failures.
On each retry the maximum backoff is doubled, increasing the probability that
retries are not performed at the same time. It might seem somewhat
counterintuitive that waiting could improve performance, but this can greatly
reduce the amount of synchronisation and improve performance.</p>
<p>The Kcas library already employed a backoff mechanism. Many operations used a
backoff mechanism internally and allocated an object to hold the backoff
configuration and state as the first thing. To reduce overheads and make the
library more tunable, I redesigned the backoff mechanism to encode the
configuration and state in a single integer so that no allocations are required.
I also changed the operations to take the backoff as an optional argument so
that users could potentially tune the backoff for specific cases, such as when a
particular transaction should take priority and employ shorter backoffs, or the
opposite.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#free-from-obstructions" aria-label="free from obstructions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Free From Obstructions</h3>
<p>The new k-CAS algorithm was efficient, but it was limited to CAS operations that
always wrote to shared memory locations. Interestingly, a CAS operation can also
express a compare (CMP) operation &mdash; just use the same value as the
expected and desired value, <code>Op.make_cas loc expected expected</code>.</p>
<p>One might wonder; what is the use of read-only operations? It is actually common
for the majority of accesses to data structures to be read-only and even
read-write operations of data structures often involve read-only accesses of
particular locations. As explained in the paper
<a href="http://people.csail.mit.edu/shanir/publications/Nonblocking%20k-compare.pdf">Nonblocking k-compare-single-swap</a>,
to safely modify a singly-linked list typically requires not only atomically
updating a pointer, but also ensuring that other pointers remain unmodified.</p>
<p>The problem with using a read-write CAS to express a read-only CMP is that, due
to the synchronisation requirements, writes to shared memory are much more
expensive than reads. Writes to a single location cannot proceed in parallel.
Multiple cores trying to &quot;read&quot; a location in memory using read-write CASes
would basically cause similar expensive bus traffic, or cache line ping-pong, as
with the previously described na&iuml;ve increment operation &mdash; without even
attempting to logically write to memory.</p>
<p>To address this problem I extended the new
<a href="https://en.wikipedia.org/wiki/Non-blocking_algorithm#Lock-freedom">lock-free</a>
k-CAS algorithm to
<a href="https://github.com/ocaml-multicore/kcas/blob/main/doc/gkmz-with-read-only-cmp-ops.md">a brand new obstruction-free k-CAS-n-CMP algorithm</a>
that allows one to perform a combination of read-write CAS and read-only CMP
operations. The extension to k-CAS-n-CMP is a rather trivial addition to the
k-CAS algorithm. The gist of the k-CAS-n-CMP algorithm is to perform an
additional step to validate all the read-only CMP accesses before committing the
changes. This sort of validation step is a fairly common approach in
non-blocking algorithms.</p>
<p>The
<a href="https://en.wikipedia.org/wiki/Non-blocking_algorithm#Obstruction-freedom">obstruction-free</a>
k-CAS-n-CMP algorithm also retains the lock-free k-CAS algorithm as a subset. In
cases where only CAS operations are performed, the k-CAS-n-CMP algorithm does
the exact same thing as the k-CAS algorithm. This allows a transaction mechanism
based on the k-CAS-n-CMP algorithm to easily switch to using only CAS operations
to guarantee lock-free behavior. The difference between an obstruction-free and
a lock-free algorithm is that a lock-free algorithm guarantees that at least one
thread will be able to make progress. With the obstruction-free validation step
it is possible for two or more threads to enter a livelock situation, where they
repeatedly and indefinitely fail during the validation step. By switching to
lock-free mode, after detecting a validation failure, it is possible to avoid
such livelocks.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#giving-monads-a-pass" aria-label="giving monads a pass permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Giving Monads a Pass</h3>
<p>The original transactional API to k-CAS actually used monadic combinators.
Gabriel Scherer suggested the alternative API based on passing a mutable
transaction log explicitly that we've already used in the examples. This has the
main advantage that such an API can be easily used with all the existing control
flow structures of OCaml, such as <code>if then else</code> and <code>for to do</code> as well as
higher-order functions like <code>List.iter</code>, that would need to be encoded with
combinators in the monadic API.</p>
<p>On the other hand, a monadic API provides a very strict abstraction barrier
against misuse as it can keep users from accessing the transaction log directly.
The transaction log itself is not thread safe and should not be accessed or
reused after it has been consumed by the main k-CAS-n-CMP algorithm. Fortunately
there is a way to make such misuse much more difficult as described in the paper
<a href="https://www.microsoft.com/en-us/research/wp-content/uploads/1994/06/lazy-functional-state-threads.pdf">Lazy Functional State Threads</a>
by employing higher-rank polymorphism. By adding a type variable to the type of
the transaction log</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> <span class="token type-variable function">'x</span> t</code></pre></div>
<p>and requiring a transaction to be universally quantified</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> <span class="token type-variable function">'a</span> tx <span class="token operator">=</span> <span class="token punctuation">{</span>
  tx <span class="token punctuation">:</span> <span class="token type-variable function">'x</span><span class="token punctuation">.</span> xt<span class="token punctuation">:</span><span class="token type-variable function">'x</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>with respect to the transaction log, the type system prevents a transaction log
from being reused:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token punctuation">#</span> <span class="token keyword">let</span> futile x <span class="token operator">=</span>
    <span class="token keyword">let</span> log <span class="token operator">=</span> ref None <span class="token keyword">in</span>
    <span class="token keyword">let</span> tx <span class="token label property">~xt</span> <span class="token operator">=</span>
      <span class="token keyword">match</span> <span class="token operator">!</span>log <span class="token keyword">with</span>
      <span class="token operator">|</span> None <span class="token operator">-&gt;</span>
        log <span class="token operator">:=</span> Some xt<span class="token punctuation">;</span>
        raise Retry<span class="token punctuation">.</span>Later
      <span class="token operator">|</span> Some xt <span class="token operator">-&gt;</span>
        Xt<span class="token punctuation">.</span>get <span class="token label property">~xt</span> x <span class="token keyword">in</span>
    Xt<span class="token punctuation">.</span>commit <span class="token punctuation">{</span> tx <span class="token punctuation">}</span>
Line <span class="token number">10</span><span class="token punctuation">,</span> characters <span class="token number">17</span><span class="token operator">-</span><span class="token number">19</span><span class="token punctuation">:</span>
Error<span class="token punctuation">:</span> This field <span class="token keyword">value</span> has <span class="token keyword">type</span> xt<span class="token punctuation">:</span><span class="token type-variable function">'a</span> Xt<span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token type-variable function">'b</span> which is less general than
         <span class="token type-variable function">'x</span><span class="token punctuation">.</span> xt<span class="token punctuation">:</span><span class="token type-variable function">'x</span> Xt<span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token type-variable function">'c</span></code></pre></div>
<p>It is still possible to e.g. create a closure that refers to a transaction log
after it has been consumed, but that requires effort from the programmer and
should be unlikely to happen by accident.</p>
<p>The explicit transaction log passing API proved to work well and the original
monadic transaction API was then later removed from the Kcas library to avoid
duplicating effort.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#division-of-labour" aria-label="division of labour permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Division of Labour</h3>
<p>When was the last time you implemented a non-trivial data structure or algorithm
from scratch? For most professionals the answer might be along the lines of
&quot;when I took my data structures course at the university&quot; or &quot;when I interviewed
for the software engineering position at Big Co&quot;.</p>
<p>Kcas aims to be usable both</p>
<ul>
<li>for experts implementing correct and performant lock-free data structures, and</li>
<li>for everyone gluing together programs using such data structures.</li>
</ul>
<p>Implementing lock-free data structures, even with the help of k-CAS-n-CMP, is
not something everyone should be doing every time they are writing concurrent
programs. Instead programmers should be able to just reuse carefully constructed
data structures.</p>
<p>As an example, consider the implementation of a least-recently-used (LRU) cache
or a bounded associative map. A simple sequential approach to implement a LRU
cache is to use a hash table and a doubly-linked list and keep track of the
amount of space in the cache:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> <span class="token punctuation">(</span><span class="token type-variable function">'k</span><span class="token punctuation">,</span> <span class="token type-variable function">'v</span><span class="token punctuation">)</span> cache <span class="token operator">=</span>
  <span class="token punctuation">{</span> space<span class="token punctuation">:</span> int Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
    table<span class="token punctuation">:</span> <span class="token punctuation">(</span><span class="token type-variable function">'k</span><span class="token punctuation">,</span> <span class="token type-variable function">'k</span> Dllist<span class="token punctuation">.</span>node <span class="token operator">*</span> <span class="token type-variable function">'v</span><span class="token punctuation">)</span> Hashtbl<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
    order<span class="token punctuation">:</span> <span class="token type-variable function">'k</span> Dllist<span class="token punctuation">.</span>t <span class="token punctuation">}</span></code></pre></div>
<p>On a cache lookup the doubly-linked list node corresponding to the accessed key
is moved to the left end of the list:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> get_opt <span class="token punctuation">{</span>table<span class="token punctuation">;</span> order<span class="token punctuation">;</span> <span class="token punctuation">_</span><span class="token punctuation">}</span> key <span class="token operator">=</span>
  Hashtbl<span class="token punctuation">.</span>find_opt table key
  <span class="token operator">|&gt;</span> Option<span class="token punctuation">.</span>map <span class="token operator">@@</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span>node<span class="token punctuation">,</span> datum<span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
     Dllist<span class="token punctuation">.</span>move_l node order<span class="token punctuation">;</span> datum</code></pre></div>
<p>On a cache update, in case of overflow, the association corresponding to the
node on the right end of the list is dropped:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> set <span class="token punctuation">{</span>table<span class="token punctuation">;</span> order<span class="token punctuation">;</span> space<span class="token punctuation">;</span> <span class="token punctuation">_</span><span class="token punctuation">}</span> key datum <span class="token operator">=</span>
  <span class="token keyword">let</span> node <span class="token operator">=</span>
    <span class="token keyword">match</span> Hashtbl<span class="token punctuation">.</span>find_opt table key <span class="token keyword">with</span>
    <span class="token operator">|</span> None <span class="token operator">-&gt;</span>
      <span class="token keyword">if</span> <span class="token number">0</span> <span class="token operator">=</span> Loc<span class="token punctuation">.</span>update space <span class="token punctuation">(</span><span class="token keyword">fun</span> n <span class="token operator">-&gt;</span> max <span class="token number">0</span> <span class="token punctuation">(</span>n<span class="token operator">-</span><span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span>
      <span class="token keyword">then</span> Dllist<span class="token punctuation">.</span>take_opt_r order
           <span class="token operator">|&gt;</span> Option<span class="token punctuation">.</span>iter <span class="token punctuation">(</span>Hashtbl<span class="token punctuation">.</span>remove table<span class="token punctuation">)</span><span class="token punctuation">;</span>
      Dllist<span class="token punctuation">.</span>add_l key order
    <span class="token operator">|</span> Some <span class="token punctuation">(</span>node<span class="token punctuation">,</span> <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> Dllist<span class="token punctuation">.</span>move_l node order<span class="token punctuation">;</span> node
  <span class="token keyword">in</span>
  Hashtbl<span class="token punctuation">.</span>replace table key <span class="token punctuation">(</span>node<span class="token punctuation">,</span> datum<span class="token punctuation">)</span></code></pre></div>
<p>Sequential algorithms such as the above are so common that one does not even
think about them. Unfortunately, in a concurrent setting the above doesn't work
even if the individual operations on lists and hash tables were atomic.</p>
<p>As it happens, the individual operations used above are actually atomic, because
they come from the
<a href="https://ocaml-multicore.github.io/kcas/doc/kcas_data/Kcas_data/index.html"><code>kcas_data</code></a>
package. The <code>kcas_data</code> package provides lock-free and parallelism safe
implementations of various data structures.</p>
<p>But how would one make the operations on a cache atomic as a whole? As explained
by Maurice Herlihy in one of his talks on
<a href="https://youtu.be/ZkUrl8BZHjk?t=1503">Transactional Memory</a> adding locks to
protect the atomicity of the operation is far from trivial.</p>
<p>Fortunately, rather than having to e.g. wrap the cache implementation behind a
<a href="https://en.wikipedia.org/wiki/Lock_(computer_science)">mutex</a> and make
another individually atomic yet uncomposable data structure, or having to learn
a completely different programming model and rewrite the cache implementation,
we can use the transactional programming model provided by the Kcas library and
the transactional data structures provided by the <code>kcas_data</code> package to
trivially convert the previous implementation to a lock-free composable
transactional data structure.</p>
<p>To make it so, we simply use transactional versions, <code>*.Xt.*</code>, of operations on
the data structures and explicitly pass a transaction log, <code>~xt</code>, to the
operations. For the <code>get_opt</code> operation we end up with</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> get_opt <span class="token label property">~xt</span> <span class="token punctuation">{</span>table<span class="token punctuation">;</span> order<span class="token punctuation">;</span> <span class="token punctuation">_</span><span class="token punctuation">}</span> key <span class="token operator">=</span>
  Hashtbl<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>find_opt <span class="token label property">~xt</span> table key
  <span class="token operator">|&gt;</span> Option<span class="token punctuation">.</span>map <span class="token operator">@@</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span>node<span class="token punctuation">,</span> datum<span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
     Dllist<span class="token punctuation">.</span>Xt<span class="token punctuation">.</span>move_l <span class="token label property">~xt</span> node order<span class="token punctuation">;</span> datum</code></pre></div>
<p>and the <code>set</code> operation is just as easy to convert to a transactional version.
One way to think about transactions is that they give us back the ability to
compose programs such as the above. But, I digress, again.</p>
<p>It was not immediately clear whether Kcas would be efficient enough. A simple
node based queue, for example, seemed to be significantly slower than an
implementation of
<a href="https://www.cs.rochester.edu/~scott/papers/1996_PODC_queues.pdf">the Michael-Scott queue</a>
using atomics. How so? The reason is fundamentally very simple. Every shared
memory location takes more words of memory, every update allocates more, and the
transaction log also allocates memory. All the extra words of memory need to be
written to by the CPU and this invariably takes some time and slows things down.</p>
<p>For the implementation of high-performance data structures it is important to
offer ways, such as the ability to take advantage of the specifics of the
transaction log, to help ensure good performance. A common lock-free algorithm
design technique is to publish the desire to perform an operation so that other
parties accessing the same data structure can help to complete the operation.
With some care and ability to check whether a location has already been accessed
within a transaction it is possible to implement such algorithms also with Kcas.</p>
<p>Using such low level lock-free techniques, it was possible to implement a queue
using three stacks:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> <span class="token type-variable function">'a</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>
  front <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> list Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  middle <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> list Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
  back <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> list Loc<span class="token punctuation">.</span>t<span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>The front stack is reversed so that, most of the time, to take an element from
the queue simply requires popping the top element from the stack. Similarly to
add an element to the queue just requires pushing the element to the top of the
back stack. The difficult case is when the front becomes empty and it is
necessary to move elements from the back to the front.</p>
<p>The third stack acts as a temporary location for publishing the intent to
reverse it to the front of the queue. The operation to move the back stack to
the middle can be done outside of the transaction, as long as the back and the
middle have not yet been accessed within the transaction.</p>
<p>The three-stack queue turned out to perform well &mdash; better, for example,
than some non-compositional lock-free queue implementations. While Kcas adds
overhead, it also makes it easier to use more sophisticated data structures and
algorithms. Use of the middle stack, for example, requires atomically updating
multiple locations. With plain single-word atomics that is non-trivial.</p>
<p>Similar techniques also allowed the <code>Hashtbl</code> implementation to perform various
operations on the whole hash table in ways that avoid otherwise likely
starvation issues with large transactions.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#intermission" aria-label="intermission permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Intermission</h3>
<p>This concludes the first part of this two part post. In the next part we will
continue our discussion on the development of Kcas, starting with the addition
of a fundamentally new feature to Kcas which turns it into a proper STM
implementation.</p>
