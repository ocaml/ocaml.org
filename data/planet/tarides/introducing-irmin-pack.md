---
title: Introducing irmin-pack
description: "irmin-pack is an Irmin storage backend\nthat we developed over the last
  year specifically to meet the\nTezos use-case. Tezos nodes were\u2026"
url: https://tarides.com/blog/2020-09-01-introducing-irmin-pack
date: 2020-09-01T00:00:00-00:00
preview_image: https://tarides.com/static/5dbd4ce5058bf6225c3a8ac98e4dda54/ed842/drawers.jpg
featured:
---

<p><code>irmin-pack</code> is an Irmin <a href="https://irmin.org/tutorial/backend">storage backend</a>
that we developed over the last year specifically to meet the
<a href="https://tezos.gitlab.io/">Tezos</a> use-case. Tezos nodes were initially using an
LMDB-based backend for their storage, which after only a year of activity led to
<code>250 GB</code> disk space usage, with a monthly growth of <code>25 GB</code>. Our goal was to
dramatically reduce this disk space usage.</p>
<p>Part of the <a href="https://tarides.com/blog/2019-11-21-irmin-v2">Irmin.2.0.0 release</a>
and still under active development, it has been successfully integrated as the
storage layer of Tezos nodes and has been running in production for the last ten
months with great results. It reduces disk usage by a factor of 10, while still
ensuring similar performance and consistency guarantees in a memory-constrained
and concurrent environment.</p>
<p><code>irmin-pack</code> was presented along with Irmin v2 at the OCaml workshop 2020; you
can watch the presentation here:</p>
<div style="position: relative; width: 100%; height: 0; padding-bottom: 56.25%">
  <iframe style="position: absolute; width: 100%; height: 100%; left: 0; right: 0" src="https://www.youtube-nocookie.com/embed/v1lfMUM332w" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen">
  </iframe>
</div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#general-structure" aria-label="general structure permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>General structure</h2>
<p><code>irmin-pack</code> exposes functors that allow the user to provide arbitrary low-level
modules for handling I/O, and provides a fast key-value store interface composed
of three components:</p>
<ul>
<li>The <code>pack</code> is used to store the data contained in the Irmin store, as blobs.</li>
<li>The <code>dict</code> stores the paths where these blobs should live.</li>
<li>The <code>index</code> keeps track of the blobs that are present in the repository by
containing location information in the <code>pack</code>.</li>
</ul>
<p>Each of these use both on-disk storage for persistence and concurrence and
various in-memory caches for speed.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#storing-the-data-in-the-pack-file" aria-label="storing the data in the pack file permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Storing the data in the <code>pack</code> file</h3>
<p>The <code>pack</code> contains most of the data stored in this Irmin backend. It is an
append-only file containing the serialized data stored in the Irmin repository.
All three Irmin stores (see our <a href="https://irmin.org/tutorial/architecture">architecture
page</a> in the tutorial to learn more)
are contained in this single file.</p>
<p><code>Content</code> and <code>Commit</code> serialization is straightforward through
<a href="https://docs.mirage.io/irmin/Irmin/Type/index.html"><code>Irmin.Type</code></a>. They are written along with their length (to allow
correct reading) and hash (to enable integrity checks). The hash is used to
resolve internal links inside the pack when nodes are written.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/65f80d5690bb49cd0ead891e2e7346c8/f989d/pack.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 16.470588235294116%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAADCAYAAACTWi8uAAAACXBIWXMACSfAAAknwAFlKNyIAAAAwUlEQVQI1x2JXUvDMAAA+///jyB9EATtNupq18GU2NWkMW3TGPop3aZwQh+O47hgyD8YKkvdO9zc4CaLHS2F1ZheUQ9mpRkNpTdIp7FjjfGedmpYFs/fdeC6dPxeegJ3f0cWPvIkDryoHdtzxF6lhElCVr8Sy5hNvuHYpETiwEMWE3/uCPcJkXjm26VYFWOKLbdJEFzEOy6XnFvNV6/QnUL5EmEMupNrl51aX95I3kyO9AUnLVfPc8Uy1vyMFbel5R+3ito8hFIP1gAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/65f80d5690bb49cd0ead891e2e7346c8/c5bb3/pack.png" class="gatsby-resp-image-image" alt="The pack file" title="The pack file" srcset="/static/65f80d5690bb49cd0ead891e2e7346c8/04472/pack.png 170w,
/static/65f80d5690bb49cd0ead891e2e7346c8/9f933/pack.png 340w,
/static/65f80d5690bb49cd0ead891e2e7346c8/c5bb3/pack.png 680w,
/static/65f80d5690bb49cd0ead891e2e7346c8/b12f7/pack.png 1020w,
/static/65f80d5690bb49cd0ead891e2e7346c8/b5a09/pack.png 1360w,
/static/65f80d5690bb49cd0ead891e2e7346c8/f989d/pack.png 5206w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#optimizing-large-nodes" aria-label="optimizing large nodes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Optimizing large nodes</h4>
<p>Serializing nodes is not as simple as contents. In fact, nodes might contain an
arbitrarily large number of children, and serializing them as a long list of
references might harm performance, as that means loading and writing a large
amount of data for each modification, no matter how small this modification
might be. Similarly, browsing the tree means reading large blocks of data, even
though only one child is needed.</p>
<p>For this reason, we implemented a <a href="https://en.wikipedia.org/wiki/Radix_tree">Patricia Tree</a> representation of
internal nodes that allows us to split the child list into smaller parts that
can be accessed and modified independently, while still being quickly available
when needed. This reduces duplication of tree data in the Irmin store and
improves disk access times.</p>
<p>Of course, we provide a custom hashing mechanism, so that hashing the nodes
using this partitioning is still backwards-compatible for users who rely on hash
information regardless of whether the node is split or not.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#optimizing-internal-references" aria-label="optimizing internal references permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Optimizing internal references</h4>
<p>In the Git model, all data are content-addressable (i.e. data are always
referenced by their hash). This naturally lends to indexing data by hashes on
the disk itself (i.e. the links from <code>commits</code> to <code>nodes</code> and from <code>nodes</code> to
<code>nodes</code> or <code>contents</code> are realized by hash).</p>
<p>We did not comply to this approach in <code>irmin-pack</code>, for at least two reasons:</p>
<ul>
<li>
<p>Referencing by hash does not allow fast recovery of the children, since
there is no way to find the relevant blob directly in the <code>pack</code> by providing
the hash. We will go into the details of this later in this post.</p>
</li>
<li>
<p>While hashes are being used as simple objects, their size is not negligible.
The default hashing function in Irmin is BLAKE2B, which provides 64-byte
digests.</p>
</li>
</ul>
<p>Instead, our internal links in the <code>pack</code> file are concretized by the offsets &ndash;
<code>int64</code> integers &ndash; of the children instead of their hash. Provided that the
trees are always written bottom-up (so that children already exist in the <code>pack</code>
when their parents are written), this solves both issues above. The data handled
by the backend is always immutable, and the file is append-only, ensuring that
the links can never be broken.</p>
<p>Of course, that encoding does not break the content-addressable property: one
can always retrieve an arbitrary piece of data through its hash, but it allows
internal links to avoid that indirection.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#deduplicating-the-path-names-through-the-dict" aria-label="deduplicating the path names through the dict permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deduplicating the path names through the <code>dict</code></h3>
<p>In fact, the most common operations when using <code>irmin-pack</code> consist of modifying
the tree's leaves rather then its shape. This is similar to the way most of us
use Git: modifying the contents of files is very frequent, while renaming or
adding new files is rather rare. Even still, when writing a <code>node</code> in a new
commit, that node must contain the path names of its children, which end up
being duplicated a large number of times.</p>
<p>The <code>dict</code> is used for deduplication of path names so that the <code>pack</code> file can
uniquely reference them using shorter identifiers. It is composed of an
in-memory bidirectional hash table, allowing to query from path to identifier
when serializing and referencing, and from identifier to path when deserializing
and dereferencing.</p>
<p>To ensure persistence of the data across multiple runs and in case of crashes,
the small size of the <code>dict</code> &ndash; less than <code>15 Mb</code> in the Tezos use-case &ndash; allows
us to write the bindings to a write-only, append-only file that is fully read
and loaded on start-up.</p>
<p>We guarantee that the <code>dict</code> memory usage is bounded by providing a <code>capacity</code>
parameter. Adding a binding is guarded by this capacity, and will be inlined in
the <code>pack</code> file in case this limit has been reached. This scenario does not
happen during normal use of <code>irmin-pack</code>, but prevents attacks that would make
the memory grow in an unbounded way.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/cec17f425cdf458a385babbac24c0c04/f7171/dict.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 46.470588235294116%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAJCAYAAAAywQxIAAAACXBIWXMACSfAAAknwAFlKNyIAAABvUlEQVQoz22O226bUBBF+f//qdT6qbHjxkl8BQIhjRPwDewkYChwOOcAq4K4T+lIW1oz0mwtw/c8VJYhRU6piq+RxX/vSglqLalrSVOrnrWqMOLRFXI6ZWtPWEVL7MOK5W6KdVhhHZY926GJeVj0/HDh99hFZi8UyTPnk4tI1+jCx9h+/8Z+MODhZsDIu2YezBh7Q355456H7k8mTxOW2yVDp+MbZsGUj8QmCU3W7ohXb8xxMwPpY6Q3Y+R8zs65xYxMzP2c1X7WW3U2nWXHd/51f388Oix204uhT94belTZK7rYYOiypIuqShpqkuJEXqXUTY3QJamIOZcfvOcRcfGGUAVxfkTIApqWpqn71FqhlcTgMm3b8ui6xElKViVkIiEtYqQSNHXdP2styUXOuThzyvZUWqC16n//jdEt3d42mvfQ5WrxiB3aLHb3RB8OiD2qCJC5D9WG43HPyHJZHWY4ocmf9Dc0ivYiZXAphJqm3DC4tbh/mTF5nvB2fgAZQOV/pvYJQ58f9wvu1rcsgiki96BVnx1dYW/IZ6HINgyXHk7kYIXmxXCHLgJUHvSGUbRlZDm4Jxs3sr4Y/gV1k563ex97NwAAAABJRU5ErkJggg=='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/cec17f425cdf458a385babbac24c0c04/c5bb3/dict.png" class="gatsby-resp-image-image" alt="The dict" title="The dict" srcset="/static/cec17f425cdf458a385babbac24c0c04/04472/dict.png 170w,
/static/cec17f425cdf458a385babbac24c0c04/9f933/dict.png 340w,
/static/cec17f425cdf458a385babbac24c0c04/c5bb3/dict.png 680w,
/static/cec17f425cdf458a385babbac24c0c04/b12f7/dict.png 1020w,
/static/cec17f425cdf458a385babbac24c0c04/b5a09/dict.png 1360w,
/static/cec17f425cdf458a385babbac24c0c04/f7171/dict.png 3456w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#retrieve-the-data-in-the-pack-by-indexing" aria-label="retrieve the data in the pack by indexing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Retrieve the data in the <code>pack</code> by indexing</h3>
<p>Since the <code>pack</code> file is append-only, naively reading its data would require a
linear search through the whole file for each lookup. Instead, we provide an
index that maps hashes of data blocks to their location in the <code>pack</code> file,
along with their length. This module allows quick recovery of the values queried
by hash.</p>
<p>It provides a simple key-value interface, that actually hides the most complex
part of <code>irmin-pack</code>.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t
<span class="token keyword">val</span> v <span class="token punctuation">:</span> readonly<span class="token punctuation">:</span>bool <span class="token operator">-&gt;</span> path<span class="token punctuation">:</span>string <span class="token operator">-&gt;</span> t

<span class="token keyword">val</span> find    <span class="token punctuation">:</span> t <span class="token operator">-&gt;</span> <span class="token module variable">Key</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token module variable">Value</span><span class="token punctuation">.</span>t
<span class="token keyword">val</span> replace <span class="token punctuation">:</span> t <span class="token operator">-&gt;</span> <span class="token module variable">Key</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> <span class="token module variable">Value</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> unit
<span class="token comment">(* ... *)</span></code></pre></div>
<p>It has lead most of our efforts in the development of <code>irmin-pack</code> and is now
available as a separate library, wisely named <code>index,</code> that you can checkout on
GitHub under <a href="https://github.com/mirage/index/">mirage/index</a> and via <code>opam</code> as
the <code>index</code> and <code>index-unix</code> packages.</p>
<p>When <code>index</code> is used inside <code>irmin-pack</code>, the keys are the hashes of the data
stored in the backend, and the values are the <code>(offset, length)</code> pair that
indicates the location in the <code>pack</code> file. From now on in this post, we will
stick to the <code>index</code> abstraction: <code>key</code> and <code>value</code> will refer to the keys and
values as viewed by the <code>index</code>.</p>
<p>Our index is split into two major parts. The <code>log</code> is relatively small, and most
importantly, bounded; it contains the recently-added bindings. The <code>data</code> is
much larger, and contains older bindings.</p>
<p>The <code>log</code> part consists of a hash table associating keys to values. In order to
ensure concurrent access, and to be able to recover on a crash, we also maintain
a write-only, append-only file with the same contents, such that both always
contain exactly the same data at any time.</p>
<p>When a new key-value binding is added index, the value is simply serialized
along with its key and added to the <code>log</code>.</p>
<p>An obvious caveat of this approach is that the in-memory representation of the
<code>log</code> (the hashtable) is unbounded. It also grows a lot, as the Tezos node
stores more that 400 million objects. Our memory constraint obviously does not
allow such unbounded structures. This is where the <code>data</code> part comes in.</p>
<p>When the <code>log</code> size reaches a &ndash; customizable &ndash; threshold, its bindings are
flushed into a <code>data</code> component, that may already contain flushed data from
former <code>log</code> overloads. We call this operation a <em>merge</em>.</p>
<p><span class="gatsby-resp-image-wrapper" style="position: relative; display: block; margin-left: auto; margin-right: auto; max-width: 680px; ">
      <a href="https://tarides.com/static/7663e5dd55a9fa612393be5ae1952bf5/e9c53/merges.png" class="gatsby-resp-image-link" style="display: block" target="_blank" rel="noopener">
    <span class="gatsby-resp-image-background-image" style="padding-bottom: 28.82352941176471%; position: relative; bottom: 0; left: 0; background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAGCAYAAADDl76dAAAACXBIWXMAAC4jAAAuIwF4pT92AAABQElEQVQY032RbXOaQBSF+f9/Km0sQTSFpDqQqBt3QUFY5KVKRczydIY23zI5M8+cuefTOXOtKAxYiZDNXpBWKUmZUNYZTa2pq4ymqfiQMQPm3fCVrOT7Hb/WDo5ycISNLWzi1CeLPFI1J083/D63DANUOmW59VBHQVQK1HFDVL6N90dmZVISJYp9kaAbTV7nHKucojigdUpZFRhjaNsLMhd4scPPyMGLpzwqm8fo4Z+rhzG3AuXjyRnLncdrvuTlsCDMFoSHBcv0iV2tYICmObFKQpy3O2ZyMjJXNs+7OX7s4kcuT/EMy4+nzNQEV97jygnu9n5kLn8w3X5jnQX0/W2c3PYnkiYiLiVSC+o/JWYw3N57uuuF7tphbYs1G/0yIvQr4r+vDgHB/pmkium6ntP5zLGsaM8Xrt1tbP3ZU/4C4hC6W7cBBZQAAAAASUVORK5CYII='); background-size: cover; display: block;"></span>
  <img src="https://tarides.com/static/7663e5dd55a9fa612393be5ae1952bf5/c5bb3/merges.png" class="gatsby-resp-image-image" alt="Merging the index" title="Merging the index" srcset="/static/7663e5dd55a9fa612393be5ae1952bf5/04472/merges.png 170w,
/static/7663e5dd55a9fa612393be5ae1952bf5/9f933/merges.png 340w,
/static/7663e5dd55a9fa612393be5ae1952bf5/c5bb3/merges.png 680w,
/static/7663e5dd55a9fa612393be5ae1952bf5/b12f7/merges.png 1020w,
/static/7663e5dd55a9fa612393be5ae1952bf5/b5a09/merges.png 1360w,
/static/7663e5dd55a9fa612393be5ae1952bf5/e9c53/merges.png 7470w" sizes="(max-width: 680px) 100vw, 680px" style="width:100%;height:100%;margin:0;vertical-align:middle;position:absolute;top:0;left:0;" loading="lazy" decoding="async"/>
  </a>
    </span></p>
<p>The important invariant maintained by the <code>merge</code> operation is that the <code>data</code>
file must remain sorted by the hash of the bindings. This will enable a fast
recovery of the data.</p>
<p>During this operation, both the <code>log</code> and the former <code>data</code> are read in sorted
order &ndash; <code>data</code> is already sorted, and <code>log</code> is small thus easy to sort in
memory &ndash; and merged into a <code>merging_data</code> file. This file is atomically renamed
at the end of the operation to replace the older <code>data</code> while still ensuring
correct concurrent accesses.</p>
<p>This operation obviously needs to re-write the whole index, so its execution
is very expensive. For this reason, it is performed by a separate thread in the
background to still allow regular use of the index and be transparent to the
user.</p>
<p>In the meantime, a <code>log_async</code> &ndash; similar to <code>log</code>, with a file and a hash table
&ndash; is used to hold new bindings and ensure the data being merged and the new data
are correctly separated. At the end of the merge, the <code>log_async</code> becomes the
new <code>log</code> and is cleared to be ready for the next merge.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#recovering-the-data" aria-label="recovering the data permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Recovering the data</h4>
<p>This design allows us a fast lookup of the data present in the index. Whenever
<code>find</code> or <code>mem</code> is called, we first look into the <code>log</code>, which is simply a call
to the corresponding <code>Hashtbl</code> function, since this data is contained in memory.
If the data is not found in the <code>log</code>, the <code>data</code> file will be browsed. This
means access to recent values is generally faster, because it does not require
any access to the disk.</p>
<p>Searching in the <code>data</code> file is made efficient by the invariant that we kept
during the <code>merge</code>: the file is sorted by hash. The search algorithm consists in
an interpolation search, which is permitted by the even distribution of the
hashes that we store. The theoretical complexity of the interpolation search is
<code>O(log (log n))</code>, which is generally better than a binary search, provided that
the computation of the interpolant is cheaper than reads, which is the case
here.</p>
<p>This approach allows us to find the data using approximately 5-6 reading steps
in the file, which is good, but still a source of slowdowns. For this reason, we
use a fan-out module on top of the interpolation search, able to tell us the
exact page in which a given key is located, in constant time, for an additional
space cost of <code>~100 Mb</code>. We use this to find the correct page of the disk, then
run the interpolation search in that page only. That approach allows us to find
the correct value with a single read in the <code>data</code> file.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>This new backend is now used byt the Tezos nodes in production, and manages to
reduce the storage size from <code>250 Gb</code> down to <code>25 Gb</code>, with a monthly growth
rate of <code>2 Gb</code> , achieving a tenfold reduction.</p>
<p>In the meantime, it provides and single writer, multiple readers access pattern
that enables bakers and clients to connect to the same storage while it is operated.</p>
<p>On the memory side, all our components are memory bounded, and the bound is
generally customizable, the largest source of memory usage being the <code>log</code> part
of the <code>index</code>. While it can be reduced to fit in <code>1 Gb</code> of memory and run on
small VPS or Raspberry Pi, one can easily set a higher memory limit on a more
powerful machine, and achieve even better time performance.</p>
