---
title: 'Introducing Irmin: Git-like distributed, branchable storage'
description:
url: https://mirage.io/blog/introducing-irmin
date: 2014-07-18T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Gazagnaire
---


        <blockquote>
<p>This is the first post in a series which will describe <a href="https://github.com/mirage/irmin">Irmin</a>,
the new Git-like storage layer for Mirage OS 2.0. This post gives a
high-level description on Irmin and its overall architecture, and
later posts will detail how to use Irmin in real systems.</p>
</blockquote>
<p><a href="https://github.com/mirage/irmin">Irmin</a> is a library to persist and synchronize distributed
data structures both on-disk and in-memory. It enables a style of
programming very similar to the <a href="http://git-scm.com/">Git</a> workflow, where
distributed nodes fork, fetch, merge and push data between
each other. The general idea is that you want every active node to
get a local (partial) copy of a global database and always be very
explicit about how and when data is shared and migrated.</p>
<p>Irmin is <em>not</em>, strictly speaking, a full database engine. It
is, as are all other components of Mirage OS, a collection of
libraries designed to solve different flavours of the challenges raised
by the <a href="http://en.wikipedia.org/wiki/CAP_theorem">CAP theorem</a>. Each application can select the right
combination of libraries to solve its particular distributed problem. More
precisely, Irmin consists of a core of well-defined low-level
data structures that specify how data should be persisted
and be shared across nodes. It defines algorithms for efficient
synchronization of those distributed low-level constructs. It also
builds a collection of higher-level data structures, like persistent
<a href="https://github.com/mirage/merge-queues">mergeable queues</a>, that can be used by developers without
having to know precisely how Irmin works underneath.</p>
<p>Since it's a part of Mirage OS, Irmin does not make strong assumptions about the
OS environment that it runs in. This makes the system very portable, and the
details below hold for in-memory databases as well as for slower persistent
serialization such as SSDs, hard drives, web browser local storage, or even
the Git file format.</p>
<h3>Persistent Data Structures</h3>
<p>Persistent data structures are well known and used pervasively in many
different areas. The programming language community has
investigated the concepts <a href="https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf">widely</a> (and this is <a href="http://en.wikipedia.org/wiki/Object_copy">not
limited</a> to functional programming), and in the meantime,
the systems community experimented with various persistent
strategies such as <a href="http://en.wikipedia.org/wiki/Copy-on-write">copy-on-write</a> filesystems. In most of these
systems, the main concern is how to optimize the space complexity by
maximizing the sharing of immutable sub-structures.</p>
<p>The Irmin design ideas share roots with previous works on persistent data
structures, as it provides an efficient way to <em>fork</em> data structures,
but it also explores new strategies and mechanisms to be able to
efficiently <em>merge</em> back these forked structures. This offers
programming constructs very similar to the Git workflow.</p>
<p>Irmin focuses on two main aspects:</p>
<ul>
<li>
<p><strong>Semantics</strong>: what properties the resulting merged objects should
verify.</p>
</li>
<li>
<p><strong>Complexity</strong>: how to design efficient merge and synchronization
primitives, taking advantage of the immutable nature of the underlying
objects.</p>
</li>
</ul>
<p>Although it is pervasively used, <em>data persistence</em> has a very broad and
fuzzy meaning. In this blog post, I will refer to data persistence as
a way for:</p>
<ul>
<li>
<p>a single process to lazily populate a process memory on startup.
You need this when you want the process to be able to resume while
holding part of its previous state if it crashes</p>
</li>
<li>
<p>concurrent processes to share references between objects living in
a global pool of data. Sharing references, as opposed to sharing
values, reduces memory copies and allow different processes to
concurrently update a shared store.</p>
</li>
</ul>
<p>In both cases, you need a global pool of data (the Irmin <em>block store</em>)
and a way to name values in that pool (the Irmin <em>tag store</em>).</p>
<h3>The Block Store: a Virtual Heap</h3>
<p>Even high-level data structures need to be allocated in memory, and it
is the purpose of the runtime to map such high-level constructs into
low-level memory graph blocks. One of the strengths of <a href="http://ocaml.org">OCaml</a>
is the very simple and deterministic mapping from high-level data
structures to low-level block representations (the <em>heap</em>): see for
instance, the excellent series of blog posts on <a href="http://rwmj.wordpress.com/2009/08/04/ocaml-internals/">OCaml
internals</a> by Richard W. Jones, or
<a href="https://realworldocaml.org/v1/en/html/memory-representation-of-values.html">Chapter 20: Memory Representation of Values</a> in
<a href="https://realworldocaml.org">Real World OCaml</a>.</p>
<p>An Irmin <em>block store</em> can be seen as a virtual OCaml heap that uses a more
abstract way of connecting heap blocks. Instead of using the concrete physical
memory addresses of blocks, Irmin uses the hash of the block contents as an
address. As for any <a href="http://en.wikipedia.org/wiki/Content-addressable_storage">content-addressable storage</a>, this gives Irmin
block stores a lot of nice properties and greatly simplifies the way distributed
stores can be synchronized.</p>
<p><em>Persistent</em> data structures are immutable, and once a block is created in
the block store, its contents will never change again.
Updating an immutable data structure means returning a completely new
structure, while trying to share common sub-parts to avoid the cost of
making new allocations as much as possible. For instance, modifying a
value in a persistent tree means creating a chain of new blocks, from
the root of the tree to the modified leaf.
For convenience, Irmin only considers acyclic block graphs --
it is difficult in a non-lazy pure language to generate complex cyclic
values with reasonable space usage.</p>
<p>Conceptually, an Irmin block store has the following signature:</p>
<pre><code class="language-ocaml">type t
(** The type for Irmin block store. *)

type key
(** The type for Irmin pointers *)

type value = ...
(** The type for Irmin blocks *)

val read: t -&gt; key -&gt; value option
(** [read t k] is the block stored at the location [k] of the
store. It is [None] if no block is available at that location. *)

val add: t -&gt; key -&gt; value -&gt; t
(** [add t k v] is the *new* store storing the block [v] at the
location [k]. *)
</code></pre>
<p>Persistent data structures are very efficient to store in memory and on
disk as you do not need <a href="http://en.wikipedia.org/wiki/Write_barrier">write barriers</a>, and updates
can be written <a href="http://en.wikipedia.org/wiki/Write_amplification#Sequential_writes">sequentially</a> instead of requiring random
access into the data structure.</p>
<h3>The Tag Store: Controlled Mutability and Concurrency</h3>
<p>So far, we have only discussed purely functional data structures,
where updating a structure means returning a pointer to a new
structure in the heap that shares most of its contents with the previous
one. This style of programming is appealing when implementing
<a href="https://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation">complex protocols</a> as it leads to better compositional properties.</p>
<img src="https://mirage.io/graphics/irmin-stores.png" alt="Irmin Stores" style="float:right; border: 5px" width="250px"/>
<p>However, this makes sharing information between processes much more
difficult, as you need a way to &quot;inject&quot; the state of one structure into another process's memory. In order to do so, Irmin borrows the concept of
<em>branches</em> from Git by relating every operation to a branch name, and
modifying the tip of the branch if it has side-effects.
The Irmin <em>tag store</em> is the only mutable part of the whole system and
is responsible for mapping some global (branch) names to blocks in the
block store. These tag names can then be used to pass block references between
different processes.</p>
<p>A block store and a tag store can be combined to build
a higher-level store (the Irmin store) with fine concurrency control
and atomicity guarantees. As mutation happens only in the tag store,
we can ensure that as long a given tag is not updated, no change made
in the block store will be visible by anyone. This also gives a nice
story for concurrency: as in Git, creating a concurrent view of the
store is the straightforward operation of creating a new tag that
denotes a new branch. All concurrent operations can then happen on
different branches:</p>
<pre><code class="language-ocaml">type t
(** The type for Irmin store. *)

type tag
(** Mutable tags *)

type key = ...
(** The type for user-defined keys (for instance a list of strings) *)

type value = ...
(** The type for user-defined values *)

val read: t -&gt; ?branch:tag -&gt; key -&gt; value option
(** [read t ?branch k] reads the contents of the key [k] in the branch
[branch] of the store [t]. If no branch is specified, then use the
[&quot;HEAD&quot;] one. *)

val update: t -&gt; ?branch:tag -&gt; key -&gt; value -&gt; unit
(** [update t ?branch k v] *updates* the branch [branch] of the store
[t] the association of the key [key] to the value [value]. *)
</code></pre>
<p>Interactions between concurrent processes are completely explicit and
need to happen via synchronization points and merge events (more on
this below). It is also possible to emulate the behaviour of
transactions by recording the sequence of operations (<code>read</code> and
<code>update</code>) on a given branch -- that sequence is used before a merge
to check that all the operations are valid (i.e. that all reads in the
transaction still return the same result on the current tip of the
store) and it can be discarded after the merge takes place.</p>
<h3>Merging Data Structures</h3>
<p>To merge two data structures in a consistent way, one has to compute
the sequence of operations which leads, from an initial common state, to two
diverging states (the ones that you want to merge). Once these two
sequences of operations have been found, they must be combined (if
possible) in a sensible way and then applied again back on the initial
state, in order to get the new merged state. This mechanism sounds
nice, but in practice it has two major drawbacks:</p>
<ul>
<li>It does not specify how we find the initial state from two diverging
states -- this is generally not possible (think of diverging
counters); and
</li>
<li>It means we need to compute the sequence of <code>update</code> operations
that leads from one state to an other.  This is easier than finding
the common initial state between two branches, but is still generally
not very efficient.
</li>
</ul>
<p>In Irmin, we solve these problems using two mechanisms.</p>
<p>First of all, an interesting observation is that that we can model the
sequence of store tips as a purely functional data-structure. We model
the partial order of tips as a directed acyclic graph where nodes are
the tips, and there is an edge between two tips if either <em>(i)</em> one is
the result of applying a sequence of <code>update</code>s to the other, or <em>(ii)</em>
one is the result of a merge operation between the other and some
other tips. Practically speaking, that means that every tip should
contains the list of its predecessors as well as the actual data it
associated to. As it is purely functional, we can (and we do) store
that graph in an Irmin block store.</p>
<img src="https://mirage.io/graphics/irmin-merge.png" alt="Finding a common ancestor" style="float:right; border:5px" width="150px"/>
<p>Having a persistent and immutable history is good for various obvious
reasons, such as access to a forensics if an error occurs or
snapshot and rollback features for free. But another less obvious
useful property is that we can now find the greatest common
ancestors of two data structures without an expensive global search.</p>
<p>The second mechanism is that we require the data structures used in
Irmin to be equipped with a well-defined 3-way merge operation, which
takes two diverging states, the corresponding initial state (computed
using the previous mechanism) and that return either a new state or a
conflict (similar to the <code>EAGAIN</code> exception that you get when you try
to commit a conflicting transaction in more traditional transactional
databases). Having access to the common ancestors makes a great
difference when designing new merge functions, as usually no
modification is required to the data-structure itself. In contrast,
the conventional approach is more invasive as it requires the data
structure to carry more information about the operation history
(for instance <a href="http://hal.upmc.fr/docs/00/55/55/88/PDF/techreport.pdf">conflict-free replicated
datatypes</a>, which relies on unbounded vector clocks).</p>
<p>We have thus been designing interesting data structure equipped with a 3-way
merge, such as counters, <a href="https://github.com/mirage/merge-queues">queues</a> and ropes.</p>
<p>This is what the implementation of distributed and mergeable counters
looks like:</p>
<pre><code class="language-ocaml">type t = int
(** distributed counters are just normal integers! *)

let merge ~old t1 t2 = old + (t1-old) + (t2-old)
(** Merging counters means:
   - computing the increments of the two states [t1] and [t2]
     relatively to the initial state [old]; and
   - and add these two increments to [old]. *)
</code></pre>
<h3>Next steps, how to git at your data</h3>
<p>From a design perspective, having access to the history makes it easier to
design complex data structures with good compositional properties to use in
unikernels. Moreover, as we made few assumptions on how the substrate of the
low-level constructs need to be implemented, the Irmin engine can be be ported
to many exotic backends such as JavaScript or anywhere else that Mirage OS
runs: this is just a matter of implementing a rather trivial
<a href="https://github.com/mirage/irmin/blob/4b06467ddee1e20c35bad64812769587fb9fa8a4/lib/core/irminStore.mli#L61">signature</a>.</p>
<p>From a developer perspective, this means that the full history of operations is
available to inspect, and that the history model is very similar to the Git
workflow that is increasingly familiar. So similar, in fact, that we've
developed a bidirectional mapping between Irmin data structures and the Git
format to permit the <code>git</code> command-line to interact with.</p>
<p>The <a href="https://mirage.io/blog/introducing-irmin-in-xenstore">next post in our series</a> explains what <a href="http://dave.recoil.org/">Dave Scott</a> has been doing
with the new version of the <a href="http://wiki.xen.org/wiki/XenStoreReference">Xenstore</a> database that powers every Xen host,
where the entire database is stored in a prefix-tree Irmin data-structure and exposed
as a Git repository which is live-updated!  Here's a sneak preview...</p>
<div class="flex-video">
  <iframe width="480" height="360" src="//www.youtube-nocookie.com/embed/DSzvFwIVm5s" frameborder="0" allowfullscreen="1"></iframe>
</div>

      
