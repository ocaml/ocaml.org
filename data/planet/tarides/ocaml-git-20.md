---
title: ocaml-git 2.0
description: "I'm very happy to announce a new major release of ocaml-git (2.0).\nThis
  release is a 2-year effort to get a revamped\nstreaming API offering\u2026"
url: https://tarides.com/blog/2018-10-19-ocaml-git-2-0
date: 2018-10-19T00:00:00-00:00
preview_image: https://tarides.com/static/1d805022c72839f1abe63b28f225fd32/0132d/mesh.jpg
featured:
---

<p>I'm very happy to announce a new major release of <code>ocaml-git</code> (2.0).
This release is a 2-year effort to get a revamped
streaming API offering a full control over memory
allocation. This new version also adds production-ready implementations of
the wire protocol: <code>git push</code> and <code>git pull</code> now work very reliably
using the raw Git and smart HTTP protocol (SSH support will come
soon). <code>git gc</code> is also implemented, and all of the basic bricks are
now available to create Git servers. MirageOS support is available
out-of-the-box.</p>
<p>Two years ago, we decided to rewrite <code>ocaml-git</code> and split it into
standalone libraries. More details about these new libraries are also
given below.</p>
<p>But first, let's focus on <code>ocaml-git</code>'s new design. The primary goal was
to fix memory consumption issues that our users noticed with the previous version,
and to make <code>git push</code> work reliably. We also took care about
not breaking the API too much, to ease the transition for current users.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#controlled-allocations" aria-label="controlled allocations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Controlled allocations</h2>
<p>There is a big difference in the way <code>ocaml-git</code> and <code>git</code>
are designed: <code>git</code> is a short-lived command-line tool which does not
care that much about allocation policies, whereas we wanted to build a
library that can be linked with long-lived Git client and/or server
applications. We had to make some (performance) compromises to support
that use-case, at the benefit of tighter allocation policies &mdash; and hence
more predictable memory consumption patterns.
Other Git libraries such as <a href="https://libgit2.org/">libgit2</a>
also have to <a href="https://libgit2.org/security/">deal</a> with similar concerns.</p>
<p>In order to keep a tight control on the allocated memory, we decided to
use <a href="https://github.com/mirage/decompress">decompress</a> instead of
<code>camlzip</code>. <code>decompress</code> allows the users to provide their own buffer
instead of allocating dynamically. This allowed us to keep a better
control on memory consumption. See below for more details on <code>decompress</code>.</p>
<p>We also used <a href="https://github.com/inhabitedtype/angstrom">angstrom</a> and
<a href="https://github.com/mirage/encore">encore</a> to provide a streaming interface
to encode and decode Git objects. The streaming API is currently hidden
to the end-user, but it helped us a lot to build abstraction and, again, on
managing the allocation policy of the library.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#complete-pack-file-support-including-gc" aria-label="complete pack file support including gc permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Complete PACK file support (including GC)</h2>
<p>In order to find the right abstraction for manipulating pack files in
a long-lived application, we experimented with
<a href="https://github.com/dinosaure/sirodepac">various</a>
<a href="https://github.com/dinosaure/carton">prototypes</a>. We haven't found the
right abstractions just yet, but we believe the PACK format could be useful
to store any kind of data in the future (and not especially Git objects).</p>
<p>We implemented <code>git gc</code> by following the same heuristics as
<a href="https://github.com/git/git/blob/master/Documentation/technical/pack-heuristics.txt">Git</a>
to compress pack files and
we produce something similar in size &mdash; <code>decompress</code> has a good ratio about
compression &mdash; and we are using <code>duff</code>, our own implementation of <code>xdiff</code>, the
binary diff algorithm used by Git (more details on <code>duff</code> below).
We also had to re-implement the streaming algorithm to reconstruct <code>idx</code> files on
the fly, when receiving pack file on the network.</p>
<p>One notable feature of our compression algorithms is they work without
the assumption that the underlying system implements POSIX: hence,
they can work fully in-memory, in a browser using web storage or
inside a MirageOS unikernel with <a href="https://github.com/mirage/wodan">wodan</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#production-ready-push-and-pull" aria-label="production ready push and pull permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Production-ready push and pull</h2>
<p>We re-implemented and abstracted the <a href="https://github.com/git/git/blob/master/Documentation/technical/http-protocol.txt">Git Smart protocol</a>, and used that
abstraction to make <code>git push</code> and <code>git pull</code> work over HTTP.  By
default we provide a <a href="https://github.com/mirage/cohttp">cohttp</a>
implementation but users can use their own &mdash; for instance based on
<a href="https://github.com/inhabitedtype/httpaf">httpaf</a>.
As proof-of-concept, the <a href="https://github.com/mirage/ocaml-git/pull/227">initial
pull-request</a> of <code>ocaml-git</code> 2.0 was
created using this new implementation; moreover, we wrote a
prototype of a Git client compiled with <code>js_of_ocaml</code>, which was able
to run <code>git pull</code> over HTTP inside a browser!</p>
<p>Finally, that implementation will allow MirageOS unikernels to synchronize their
internal state with external Git stores (hosted for instance on GitHub)
using push/pull mechanisms. We also expect to release a server-side implementation
of the smart HTTP protocol, so that the state of any unikernel can be inspected
via <code>git pull</code>. Stay tuned for more updates on that topic!</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#standalone-dependencies" aria-label="standalone dependencies permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Standalone Dependencies</h2>
<p>Below you can find the details of the new stable releases of libraries that are
used by <code>ocaml-git</code> 2.0.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#optint-and-checkseum" aria-label="optint and checkseum permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>optint</code> and <code>checkseum</code></h3>
<p>In some parts of <code>ocaml-git</code>, we need to compute a Circular
Redundancy Check value. It is 32-bit integer value. <code>optint</code> provides
an abstraction of it but structurally uses an unboxed integer or a
boxed <code>int32</code> value depending on target (32 bit or 64 bit architecture).</p>
<p><code>checkseum</code> relies on <code>optint</code> and provides 3 implementations of CRC:</p>
<ul>
<li>Adler32 (used by <code>zlib</code> format)</li>
<li>CRC32 (used by <code>gzip</code> format and <code>git</code>)</li>
<li>CRC32-C (used by <code>wodan</code>)</li>
</ul>
<p><code>checkseum</code> uses the <em>linking trick</em>: this means that users of the
library program against an abstract API (only the <code>cmi</code> is provided);
at link-time, users have to select which implementation to use:
<code>checkseum.c</code> (the C implementation) or <code>checkseum.ocaml</code> (the OCaml
implementation). The process is currently a bit cumbersome but upcoming
<code>dune</code> release will make that process much more transparent to the users.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#encore-angkor" aria-label="encore angkor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>encore</code> (/<em>angkor</em>/)</h3>
<p>In <code>git</code>, we work with Git <em>objects</em> (<em>tree</em>, <em>blob</em> or
<em>commit</em>). These objects are encoded in a specific format. Then,
the hash of these objects are computed from the encoded
result to get a unique identifier. For example, the hash of your last commit is:
<code>sha1(encode(commit))</code>.</p>
<p>A common operation in <code>git</code> is to decode Git objects from an encoded
representation of them (especially in <code>.git/objects/*</code> as a <em>loose</em>
file) and restore them in another part of your Git repository (like in a
PACK file or on the command-line).</p>
<p>Hence, we need to ensure that encoding is always deterministic, and
that decoding an encoded Git object is always the identity, e.g. there is
an <em>isomorphism</em> between the decoder and the encoder.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> decoder <span class="token operator">&lt;.&gt;</span> encoder <span class="token punctuation">:</span> <span class="token keyword">value</span> <span class="token operator">-&gt;</span> <span class="token keyword">value</span> <span class="token operator">=</span> id
<span class="token keyword">let</span> encoder <span class="token operator">&lt;.&gt;</span> decoder <span class="token punctuation">:</span> string <span class="token operator">-&gt;</span> string <span class="token operator">=</span> id</code></pre></div>
<p><a href="https://github.com/mirage/encore">encore</a> is a library in which you
can describe a format (like Git format) and from it, we can derive a
streaming decoder <strong>and</strong> encoder that are isomorphic by
construction.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#duff" aria-label="duff permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>duff</code></h3>
<p><a href="https://github.com/mirage/duff">duff</a> is a pure implementation in
OCaml of the <code>xdiff</code> algorithm.
Git has an optimized representation of your Git repository. It's a
PACK file. This format uses a binary diff algorithm called <code>xdiff</code>
to compress binary data. <code>xdiff</code> takes a source A and a target B and try
to find common sub-strings between A and B.</p>
<p>This is done by a Rabin's fingerprint of the source A applied to the
target B. The fingerprint can then be used to produce a lightweight
representation of B in terms of sub-strings of A.</p>
<p><code>duff</code> implements this algorithm (with additional Git's constraints,
regarding the size of the sliding windows) in OCaml. It provides a
small binary <code>xduff</code> that complies with the format of Git without the <code>zlib</code>
layer.</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ xduff diff source target &gt; target.xduff
$ xduff patch source &lt; target.xduff &gt; target.new
$ diff target target.new
$ echo $?
0</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#decompress" aria-label="decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>decompress</code></h3>
<p><a href="https://github.com/mirage/decompress">decompress</a>
is a pure implementation in OCaml of <code>zlib</code> and
<code>rfc1951</code>. You can compress and decompress data flows and, obviously,
Git does this compression in <em>loose</em> files and PACK files.</p>
<p>It provides a non-blocking interface and is easily usable in a server
context. Indeed, the implementation never allocates and only relies on
what the user provides (<code>window</code>, input and output buffer). Then, the
distribution provides an easy example of how to use <code>decompress</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> inflate<span class="token punctuation">:</span> <span class="token operator">?</span>level<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> string <span class="token operator">-&gt;</span> string
<span class="token keyword">val</span> deflate<span class="token punctuation">:</span> string <span class="token operator">-&gt;</span> string</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#digestif" aria-label="digestif permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>digestif</code></h3>
<p><a href="https://github.com/mirage/digestif">digestif</a> is a toolbox providing
many implementations of hash algorithms such as:</p>
<ul>
<li>MD5</li>
<li>SHA1</li>
<li>SHA224</li>
<li>SHA256</li>
<li>SHA384</li>
<li>SHA512</li>
<li>BLAKE2B</li>
<li>BLAKE2S</li>
<li>RIPEMD160</li>
</ul>
<p>Like <code>checkseum</code>, <code>digestif</code> uses the linking trick too: from a
shared interface, it provides 2 implementations, in C (<code>digestif.c</code>)
and OCaml (<code>digestif.ocaml</code>).</p>
<p>Regarding Git, we use the SHA1 implementation and we are ready to
migrate <code>ocaml-git</code> to BLAKE2{B,S} as the Git core team expects - and,
in the OCaml world, it is just a <em>functor</em> application with
another implementation.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#eqaf" aria-label="eqaf permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><code>eqaf</code></h3>
<p>Some applications require that secret values are compared in constant
time. Functions like <code>String.equal</code> do not have this property, so we
have decided to provide a small package &mdash; <a href="https://github.com/mirage/eqaf">eqaf</a> &mdash;
providing a <em>constant-time</em> <code>equal</code> function.
<code>digestif</code> uses it to check equality of hashes &mdash; it also exposes
<code>unsafe_compare</code> if you don't care about timing attacks in your application.</p>
<p>Of course, the biggest work on this package is not about the
implementation of the <code>equal</code> function but a way to check the
constant-time assumption on this function. Using this, we did a
<a href="https://github.com/mirage/eqaf/tree/master/test">benchmark</a> on Linux,
Windows and Mac to check it.</p>
<p>An interesting fact is that after various experiments, we replaced the
initial implementation in C (extracted from OpenBSD's <a href="https://man.openbsd.org/timingsafe_bcmp.3">timingsafe_memcmp</a>) with an OCaml
implementation behaving in a much more predictable way on all the
tested platforms.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>The upcoming version 2.0 of <a href="https://irmin.org">Irmin</a> is using ocaml-git
to create small applications that <a href="https://github.com/mirage/irmin/blob/master/examples/push.ml">push and pull their state
to GitHub</a>.
We think that Git offers a very nice model to persist data for distributed
applications and we hope that more people will use ocaml-git to experiment
and manipulate application data in Git. Please
<a href="https://github.com/mirage/ocaml-git/issues">send us</a> your feedback!</p>
