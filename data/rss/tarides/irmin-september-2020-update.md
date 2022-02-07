---
title: 'Irmin: September 2020 update'
description: "This post will survey the latest design decisions and performance improvements\nmade
  to irmin-pack, the Irmin storage backend used by\nTezos\u2026"
url: https://tarides.com/blog/2020-09-08-irmin-september-2020-update
date: 2020-09-08T00:00:00-00:00
preview_image: https://tarides.com/static/eb48bbf490e4011a9fa8806a56d4098b/0132d/tree_autumn.jpg
featured:
---

<p>This post will survey the latest design decisions and performance improvements
made to <code>irmin-pack</code>, the <a href="https://irmin.org/">Irmin</a> storage backend used by
<a href="https://tezos.gitlab.io/">Tezos</a>. Tezos is an open-source blockchain technology,
written in OCaml, which uses many libraries from the MirageOS ecosystem. For
more context on the design of <code>irmin-pack</code> and how it is optimised for the Tezos
use-case, you can check out our <a href="https://tarides.com/blog/2020-09-01-introducing-irmin-pack">previous blog post</a>.</p>
<p>This post showcases the improvements to <code>irmin-pack</code> since its initial
deployment on Tezos:</p>
<ol>
<li><a href="https://tarides.com/feed.xml#faster-read-only-store-instances">Faster read-only store instances</a></li>
<li><a href="https://tarides.com/feed.xml#better-flushing-for-the-read-write-instance">Improved automatic flushing</a></li>
<li><a href="https://tarides.com/feed.xml#faster-serialisation-for-irmintype">Staging generic serialisation operations</a></li>
<li><a href="https://tarides.com/feed.xml#more-control-over-indexmerge">More control over <code>Index.merge</code></a></li>
<li><a href="https://tarides.com/feed.xml#clearing-stores">Clearing stores</a></li>
</ol>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#faster-read-only-store-instances" aria-label="faster read only store instances permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Faster read-only store instances</h2>
<p>The Tezos use-case of Irmin requires both <em>read-only</em> and <em>read-write</em>
store handles, with multiple readers and a single writer all accessing the same
Irmin store concurrently. These store handles are held by different processes
(with disjoint memory spaces) so the instances must use files on disk to
synchronise, ensuring that the readers never miss updates from the writer. The
writer instance automatically flushes its internal buffers to disk at regular
intervals, allowing the readers to regularly pick up <code>replace</code> calls.</p>
<p>Until recently, each time a reader looked for a value &ndash; be it a commit, a node,
or a blob &ndash; it first checked if the writer had flushed new contents to disk. This
ensured that the readers always see the latest changes from the writer. However,
if the writer isn't actively modifying the regions being read, the readers make
one unnecessary system call per <code>find</code>. The higher the rate of reads, the more
time is lost to these synchronisation points. This is particularly problematic
in two use-cases:</p>
<ul>
<li>
<p><strong>Taking snapshots of the store</strong>. Tezos supports <a href="https://tezos.gitlab.io/user/snapshots.html">exporting portable
snapshots</a> of the store data. Since this operation only reads
<em>historic</em> data in the store (traversing backwards from a given block hash),
it's never necessary to synchronise with the writer.</p>
</li>
<li>
<p><strong>Bulk writes</strong>. It's sometimes necessary for the writer to dump lots of new
data to disk at once (for instance, when adding a commit to the history). In
these cases, any readers will repeatedly synchronise with the disk even though
they don't need to do so until the bulk operation is complete. More on this in
the coming months!</p>
</li>
</ul>
<p>To better support these use-cases, we dropped the requirement for readers to
maintain strict consistency with the writer instance. Instead, readers can call
an explicit <code>sync</code> function only when they <em>need</em> to see the latest concurrent
updates from the writer instance.</p>
<p>In our benchmarks, there is a clear speed-up for <code>find</code> operations from readers:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">[RO] Find in random order with implicit syncs
        Total time: 67.276527
        Operations per second: 148640.253086
        Mbytes per second: 6.378948
        Read amplification in syscalls: 3.919739
        Read amplification in bytes: 63.943734

[RO] Find in random order with only one call to sync
        Total time: 40.817458
        Operations per second: 244993.208543
        Mbytes per second: 10.513968
        Read amplification in syscalls: 0.919588
        Read amplification in bytes: 63.258072</code></pre></div>
<p>Not only it is faster, we can see also that fewer system calls are used in the
<code>Read amplification in syscalls</code> column. The benchmarks consists of reading
10,000,000 entries of 45 bytes each.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/irmin/pull/1008">irmin #1008</a>,
<a href="https://github.com/mirage/index/pull/175">index #175</a>,
<a href="https://github.com/mirage/index/pull/198">index #198</a> and
<a href="https://github.com/mirage/index/pull/203">index #203</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#better-flushing-for-the-read-write-instance" aria-label="better flushing for the read write instance permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Better flushing for the read-write instance</h2>
<p>Irmin-pack uses an <a href="https://github.com/mirage/index/">index</a> to speed up <code>find</code>
calls: a <code>pack</code> file is used to store pairs of <code>(key, value)</code> and an <code>index</code>
records the address in pack where a <code>key</code> is stored. A read-write instance has
to write both the <code>index</code> and the <code>pack</code> file, for a read-only instance to find
a value. Moreover, the order in which the data is flushed to disk for the two
files is important: the address for the pair <code>(key, value)</code> cannot be written
before the pair itself. Otherwise the read-only instance can read an address for
a non existing <code>(key, value)</code> pair. But both <code>pack</code> and <code>index</code> have internal
buffers that accumulate data, in order to reduce the number of system calls, and
both decide arbitrarily when to flush those buffers to disk.</p>
<p>We introduce a <code>flush_callback</code> argument in <code>index</code>, which registers a callback
for whenever the index decides to flush. <code>irmin-pack</code> uses this callback to flush
its pack file, resolving the issue of the dangling address.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/189">index #189</a>,
<a href="https://github.com/mirage/index/pull/216">index #216</a>,
<a href="https://github.com/mirage/irmin/pull/1051">irmin #1051</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#faster-serialisation-for-irmintype" aria-label="faster serialisation for irmintype permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Faster serialisation for <code>Irmin.Type</code></h2>
<p>Irmin uses a library of <a href="http://ocamllabs.io/iocamljs/generic_programming.html"><em>generic</em></a> operations: functions
that take a runtime representation of a type and derive some operation on that
type. These are used in many places to automatically derive encoders and
decoders for our types, which are then used to move data to and from disk. For
instance:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> string <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span>
<span class="token comment">(** [decode t] is the binary decoder of values represented by [t]. *)</span>

<span class="token comment">(** Read an integer from a binary-encoded file. *)</span>
<span class="token keyword">let</span> int_of_file <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|&gt;</span> input_line <span class="token operator">|&gt;</span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32</code></pre></div>
<p>The generic <code>decode</code> takes a <em>representation</em> of the type <code>int32</code> and uses
this to select the right binary decoder. Unfortunately, we pay the cost of this
runtime specialisation <em>every time</em> we call <code>int_of_file</code>. If we're invoking
the decoder for a particular type very often &ndash; such as when serialising store
values &ndash; it's more efficient to specialise <code>decode</code> once:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** Specialised binary decoder for integers. *)</span>
<span class="token keyword">let</span> decode_int32 <span class="token operator">=</span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32

<span class="token keyword">let</span> int_of_file_fast <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|&gt;</span> input_line <span class="token operator">|&gt;</span> decode_int32 contents</code></pre></div>
<p>The question then becomes: how can we change <code>decode</code> to encourage it to be
used in this more-efficient way? We can add a type wrapper &ndash; called <code>staged</code> &ndash;
to prevent the user from passing two arguments to <code>decode</code> at once:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token module variable">Staged</span> <span class="token punctuation">:</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> <span class="token operator">+</span><span class="token type-variable function">'a</span> t
  <span class="token keyword">val</span>   stage <span class="token punctuation">:</span> <span class="token type-variable function">'a</span>   <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> t
  <span class="token keyword">val</span> unstage <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span>
<span class="token keyword">end</span>

<span class="token keyword">val</span> decode <span class="token punctuation">:</span> <span class="token type-variable function">'a</span> t <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>string <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span><span class="token punctuation">)</span> <span class="token module variable">Staged</span><span class="token punctuation">.</span>t
<span class="token comment">(** [decode t] needs to be explicitly unstaged before being used. *)</span></code></pre></div>
<p>By forcing the user to add a <code>Staged.unstage</code> type coercion when using this
function, we're encouraging them to hoist such operations out of their
hot-loops:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** The slow implementation no longer type-checks: *)</span>

<span class="token keyword">let</span> int_of_file <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|&gt;</span> input_line <span class="token operator">|&gt;</span> decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32
<span class="token comment">(* Error: This expression has type (string -&gt; 'a) Staged.t
 *        but an expression was expected of type string -&gt; 'a *)</span>

<span class="token comment">(* Instead, we know to pull [Staged.t] values out of hot-loops: *)</span>

<span class="token keyword">let</span> decode_int32 <span class="token operator">=</span> <span class="token module variable">Staged</span><span class="token punctuation">.</span>unstage <span class="token punctuation">(</span>decode <span class="token module variable">Irmin</span><span class="token punctuation">.</span><span class="token module variable">Type</span><span class="token punctuation">.</span>int32<span class="token punctuation">)</span>

<span class="token keyword">let</span> int_of_file_fast <span class="token label function">~path</span> <span class="token operator">=</span> open_in_bin path <span class="token operator">|&gt;</span> input_line <span class="token operator">|&gt;</span> decode_int32 contents</code></pre></div>
<p>We made similar changes to the performance-critical generic functions in
<a href="https://mirage.github.io/irmin/irmin/Irmin/Type/index.html"><code>Irmin.Type</code></a>, and observed significant performance improvements.
We also added benchmarks for serialising various types.</p>
<div style="text-align: center;">
  <img src="https://tarides.com/staged-type.svg" style="height: 550px; max-width: 100%"/>
</div>
<p>Relevant PRs: <a href="https://github.com/mirage/irmin/pull/1030">irmin #1030</a> and
<a href="https://github.com/mirage/irmin/pull/1028">irmin #1028</a>.</p>
<p>There are other interesting factors at play, such as altering <code>decode</code> to
increase the efficiency of the specialised decoders; we leave this for a future
blog post.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#more-control-over-indexmerge" aria-label="more control over indexmerge permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>More control over <code>Index.merge</code></h2>
<p>index regularly does a maintenance operation, called <code>merge</code>, to ensure fast
look-ups while having a small memory imprint. This operation is concurrent with
the most of other functions, it is however not concurrent with itself: a second
merge needs to wait for a previous one to finish. When writing big chunks of
data very often, <code>merge</code> operations become blocking. To help measuring and
detecting a blocking <code>merge</code>, we added in the <code>index</code> API calls to check whether
a merge is ongoing, and to time it.</p>
<p>We mentioned that <code>merge</code> is concurrent with most of the other function in
<code>index</code>. One notable exception was <code>close</code>, which had to wait for any ongoing
<code>merge</code> to finish, before closing the index. Now <code>close</code> interrupts an ongoing
merge, but still leaves the index in a clean state.</p>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/185">index #185</a>,
<a href="https://github.com/mirage/irmin/pull/1049">irmin #1049</a> and
<a href="https://github.com/mirage/index/pull/215">index #215</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#clearing-stores" aria-label="clearing stores permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Clearing stores</h2>
<p>Another feature we recently added is the possibility to <code>clear</code> the store. It is
implemented by removing the old files on disk and opening fresh ones. However
in <code>irmin-pack</code>, the read-only instance has to detect that a clear occurred. To
do this, we add a <code>generation</code> in the header of the files used by an
<code>irmin-pack</code> store, which is increased by the clear operation. A generation
change signals to the read-only instance that it needs to close the file and
open it again, to be able to read the latest values.</p>
<p>As the header of the files on disk changed with the addition of the clear
operation, the <code>irmin-pack</code> stores created previous to this change are no longer
supported. We added a migration function for stores created with the previous
version (version 1) to the new version (version 2) of the store. You can call
this migration function as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"> <span class="token keyword">let</span> open_store <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
    <span class="token module variable">Store</span><span class="token punctuation">.</span><span class="token module variable">Repo</span><span class="token punctuation">.</span>v config
  <span class="token keyword">in</span>
  <span class="token module variable">Lwt</span><span class="token punctuation">.</span>catch open_store <span class="token punctuation">(</span><span class="token keyword">function</span>
      <span class="token operator">|</span> <span class="token module variable">Irmin_pack</span><span class="token punctuation">.</span><span class="token module variable">Unsupported_version</span> <span class="token variant variable">`V1</span> <span class="token operator">-&gt;</span>
          <span class="token module variable">Logs</span><span class="token punctuation">.</span>app <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-&gt;</span> l <span class="token string">&quot;migrating store to version 2&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">;</span>
          <span class="token module variable">Store</span><span class="token punctuation">.</span>migrate config <span class="token punctuation">;</span>
          <span class="token module variable">Logs</span><span class="token punctuation">.</span>app <span class="token punctuation">(</span><span class="token keyword">fun</span> l <span class="token operator">-&gt;</span> l <span class="token string">&quot;migration ended, opening store&quot;</span><span class="token punctuation">)</span> <span class="token punctuation">;</span>
          open_store <span class="token punctuation">(</span><span class="token punctuation">)</span>
      <span class="token operator">|</span> exn <span class="token operator">-&gt;</span>
          <span class="token module variable">Lwt</span><span class="token punctuation">.</span>fail exn<span class="token punctuation">)</span></code></pre></div>
<p>Relevant PRs: <a href="https://github.com/mirage/index/pull/211">index #211</a>,
<a href="https://github.com/mirage/irmin/pull/1047">irmin #1047</a>,
<a href="https://github.com/mirage/irmin/pull/1070">irmin #1070</a> and
<a href="https://github.com/mirage/irmin/pull/1071">irmin #1071</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>We hope you've enjoyed this discussion of our recent work. <a href="https://twitter.com/tarides_">Stay
tuned</a> for our next Tezos / MirageOS development update! Thanks
to our commercial customers, users and open-source contributors for making this
work possible.</p>
