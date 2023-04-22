---
title: 'Decompress: The New Decompress API'
description: "RFC 1951 is one of the most used standards. Indeed,\nwhen you launch
  your Linux kernel, it inflates itself according zlib\nstandard, a\u2026"
url: https://tarides.com/blog/2019-08-26-decompress-the-new-decompress-api
date: 2019-08-26T00:00:00-00:00
preview_image: https://tarides.com/static/eeb13afbb9190097a8d04be9e1361642/6b50e/hammock.jpg
featured:
---

<p><a href="https://tools.ietf.org/html/rfc1951">RFC 1951</a> is one of the most used standards. Indeed,
when you launch your Linux kernel, it inflates itself according <a href="https://zlib.net/">zlib</a>
standard, a superset of RFC 1951. Being a widely-used standard, we decided to
produce an OCaml implementation. In the process, we learned many lessons about
developing OCaml where we would normally use C. So, we are glad to present
<a href="https://github.com/mirage/decompress"><code>decompress</code></a>.</p>
<p>One of the many users of RFC 1951 is <a href="https://git-scm.com/">Git</a>, which uses it to pack data
objects into a <a href="https://git-scm.com/book/en/v2/Git-Internals-Packfiles">PACK file</a>. At the request of <a href="https://github.com/samoht">@samoht</a>,
<code>decompress</code> appeared some years ago as a Mirage-compatible replacement for zlib
to be used for compiling a <a href="https://mirage.io/">MirageOS</a> unikernel with
<a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>. Today, this little project passes a major release with
substantial improvements in several domains.</p>
<p><code>decompress</code> provides an API for inflating and deflating <em>flows</em><code>[1]</code>. The main
goal is to provide a <em>platform-agnostic</em> library: one which may be compiled on
any platform, including JavaScript. We surely cannot be faster than C
implementations like <a href="https://github.com/facebook/zstd">zstd</a> or <a href="https://github.com/lz4/lz4">lz4</a>, but we can play some
optimisation tricks to help bridge the gap. Additionally, OCaml can protect the
user against lot of bugs via the type-system <em>and</em> the runtime too (e.g. using
array bounds checking). <a href="https://github.com/mirleft/ocaml-tls"><code>ocaml-tls</code></a> was implemented partly in
response to the famous <a href="https://en.wikipedia.org/wiki/Heartbleed">failure</a> of <code>openssl</code>; a vulnerability
which could not exist in OCaml.</p>
<p><code>[1]</code>: A <em>flow</em>, in MirageOS land, is an abstraction which wants to receive
and/or transmit something under a standard. So it's usual to say a <em>TLS-flow</em>
for example.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#api-design" aria-label="api design permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>API design</h2>
<p>The API should be the most difficult part of designing a library - it reveals
what we can do and how we should do it. In this way, an API should:</p>
<ol>
<li><strong>constrain the user to avoid security issues</strong>; too much freedom can be a bad</li>
</ol>
<p>thing. As an example, consider the <code>Hashtbl.create</code> function, which allows the
user to pass <code>~random:false</code> to select a fixed hash function. The resulting
hashtable suffers deterministic key collisions, which can be exploited by an
attacker.
<br/><br/>
An example of good security-awareness in API design can be seen in
<a href="https://github.com/mirage/digestif">digestif</a>, which provided an <code>unsafe_compare</code> instead of the common
<code>compare</code> function (before <code>eqaf.0.5</code>). In this way, it enforced the user to
create an alias of it if they want to use a hash in a <code>Map</code> &ndash; however, by this
action, they should know that they are not protected against a timing-attack.</p>
<ol start="2">
<li><strong>allow some degrees of freedom to fit within many environments</strong>; a</li>
</ol>
<p>constrained API cannot support a hostile context. For example, when compiling
to an <a href="https://mirage.io/blog/2018-esp32-booting">ESP32</a> target, even small details such as the length of a stream
input buffer must be user-definable. When deploying to a server, memory
consumption should be deterministic.
<br/><br/>
Of course, this is made difficult when too much freedom will enable misuse of
the API &ndash; an example is <a href="https://github.com/ocaml/dune">dune</a> which wants consciously to limit the user
about what they can do with it.</p>
<ol start="3">
<li><strong>imply an optimal design of how to use it</strong>. Possibilities should serve the
user, but these can make the API harder to understand; this is why
documentation is important. Your API should tell your users how it wants to
be treated.</li>
</ol>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-dbuenzli-api" aria-label="a dbuenzli api permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A dbuenzli API</h3>
<p>From our experiences with protocol/format, one design stands out: the
<em><a href="https://github.com/dbuenzli/">dbuenzli</a> API</em>. If you look into some famous libraries in the OCaml
eco-system, you probably know <a href="https://github.com/dbuenzli/uutf">uutf</a>, <a href="https://github.com/dbuenzli/jsonm">jsonm</a> or <a href="https://github.com/dbuenzli/xmlm">xmlm</a>. All
of these libraries provide the same API for computing a Unicode/JSON/XML flow &ndash;
of course, the details are not the same.</p>
<p>From a MirageOS perspective, even if they use the <code>in_channel</code>/<code>out_channel</code>
abstraction rather than a <a href="https://github.com/mirage/mirage-flow">Mirage flow</a>, these libraries
are system-agnostic since they let the user to choose input and output buffers.
Most importantly, they don't use the standard OCaml <code>Unix</code> module, which cannot
be used in a unikernel.</p>
<p>The APIs are pretty consistent and try to do their <em>best-effort</em><code>[2]</code> of
decoding. The design has a type <em>state</em> which represents the current system
status; the user passes this to <code>decode</code>/<code>encode</code> to carry out the processing.
Of course, these functions have a side-effect on the state internally, but
this is hidden from the user. One advantage of including states in a design is
that the underlying implementation is very amenable to compiler optimisations (e.g.
tail-call optimisation). Internally, of course, we have a <em>porcelain</em><code>[3]</code>
implementation where any details can have an rational explanation.</p>
<p>In the beginning, <code>decompress</code> wanted to follow the same interface without the
mutability (a choice about performances) and it did. Then, the hard test was to
use it in a bigger project; in this case, <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>. An iterative
process was used to determine what was really needed, what we should not provide
(like special cases) and what we should provide to reach an uniform API that is
not too difficult to understand.</p>
<p>From this experience, we finalised the initial <code>decompress</code> API and it did not
change significantly for 4 versions (2 years).</p>
<p><code>[2]</code>: <em>best-effort</em> means an user control on the error branch where we don't
leak exception (or more generally, any interrupts)</p>
<p><code>[3]</code>: <em>porcelain</em> means implicit invariants held in the mind of the programmer
(or the assertions/comments).</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-new-decompress-api" aria-label="the new decompress api permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The new <code>decompress</code> API</h2>
<p>The new <code>decompress</code> keeps the same inflation logic, but drastically changes the
deflator to make the <em>flush</em> operation clearer. For many purposes, people don't
want to hand-craft their compressed flows &ndash; they just want
<code>of_string</code>/<code>to_string</code> functions. However, in some contexts (like a PNG
encoder/decoder), the user should be able to play with <code>decompress</code> in detail
(OpenPGP needs this too in <a href="https://tools.ietf.org/html/rfc4880">RFC 4880</a>).</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-zlib-format" aria-label="the zlib format permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Zlib format</h3>
<p>Both <code>decompress</code> and zlib use <em><a href="https://zlib.net/feldspar.html">Huffman coding</a></em>, an algorithm
for building a dictionary of variable-length codewords for a given set of
symbols (in this case, bytes). The most common byte is assigned the shortest bit
sequence; less common bytes are assigned longer codewords. Using this
dictionary, we just translate each byte into its codeword and we should achieve
a good compression ratio. Of course, there are other details, such as the fact
that all Huffman codes are <a href="https://en.wikipedia.org/wiki/Prefix_code">prefix-free</a>. The compression can be
taken further with the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">LZ77</a> algorithm.</p>
<p>The <em><a href="https://zlib.net/">zlib</a></em> format, a superset of the <a href="https://tools.ietf.org/html/rfc1951">RFC 1951</a> format, is easy
to understand. We will only consider the RFC 1951 format, since zlib adds only
minor details (such as checksums). It consists of several blocks: DEFLATE
blocks, each with a little header, and the contents. There are 3 kinds of
DEFLATE blocks:</p>
<ul>
<li>a FLAT block; no compression, just a <em>blit</em> from inputs to the current block.</li>
<li>a FIXED block; compressed using a pre-computed Huffman code.</li>
<li>a DYNAMIC block; compressed using a user-specified Huffman code.</li>
</ul>
<p>The FIXED block uses a Huffman dictionary that is computed when the OCaml runtime
is initialised. DYNAMIC blocks use dictionaries specified by the user, and so
these must be transmitted alongside the data (<em>after being compressed with
another Huffman code!</em>). The inflator decompresses this DYNAMIC dictionary and uses
it to do the <em>reverse</em> translation from bit sequences to bytes.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#inflator" aria-label="inflator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Inflator</h3>
<p>The design of the inflator did not change a lot from the last version of
<code>decompress</code>. Indeed, it's about to take an input, compute it and return an
output like a flow. Of course, the error case can be reached.</p>
<p>So the API is pretty-easy:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> decoder <span class="token operator">-&gt;</span> <span class="token punctuation">[</span> <span class="token variant variable">`Await</span> <span class="token operator">|</span> <span class="token variant variable">`Flush</span> <span class="token operator">|</span> <span class="token variant variable">`End</span> <span class="token operator">|</span> <span class="token variant variable">`Malformed</span> <span class="token keyword">of</span> string <span class="token punctuation">]</span></code></pre></div>
<p>As you can see, we have 4 cases: one which expects more inputs (<code>Await</code>), the
second which asks to the user to flush internal buffer (<code>Flush</code>), the <code>End</code> case
when we reach the end of the flow and the <code>Malformed</code> case when we encounter an
error.</p>
<p>For each case, the user can do several operations. Of course, about the <code>Await</code>
case, they can refill the contents with an other inputs buffer with:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> src <span class="token punctuation">:</span> decoder <span class="token operator">-&gt;</span> bigstring <span class="token operator">-&gt;</span> off<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> len<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> unit</code></pre></div>
<p>This function provides the decoder a new input with <code>len</code> bytes to read
starting at <code>off</code> in the given <code>bigstring</code>.</p>
<p>In the <code>Flush</code> case, the user wants some information like how many bytes are
available in the current output buffer. Then, we should provide an action to
<em>flush</em> this output buffer. In the end, this output buffer should be given by
the user (how many bytes they want to allocate to store outputs flow).</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> src <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token variant variable">`Channel</span> <span class="token keyword">of</span> in_channel <span class="token operator">|</span> <span class="token variant variable">`Manual</span> <span class="token operator">|</span> <span class="token variant variable">`String</span> <span class="token keyword">of</span> string <span class="token punctuation">]</span>

<span class="token keyword">val</span> dst_rem <span class="token punctuation">:</span> decoder <span class="token operator">-&gt;</span> int
<span class="token keyword">val</span> flush <span class="token punctuation">:</span> decoder <span class="token operator">-&gt;</span> unit
<span class="token keyword">val</span> decoder <span class="token punctuation">:</span> src <span class="token operator">-&gt;</span> o<span class="token punctuation">:</span>bigstring <span class="token operator">-&gt;</span> w<span class="token punctuation">:</span>bigstring <span class="token operator">-&gt;</span> decoder</code></pre></div>
<p>The last function, <code>decoder</code>, is the most interesting. It lets the user, at the
beginning, choose the context in which they want to inflate inputs. So they
choose:</p>
<ul>
<li><code>src</code>, where come from inputs flow</li>
<li><code>o</code>, output buffer</li>
<li><code>w</code>, window buffer</li>
</ul>
<p><code>o</code> will be used to store inflated outputs, <code>dst_rem</code> will give to us how many
bytes inflator stored in <code>o</code> and <code>flush</code> will just set <code>decoder</code> to be able to
recompute the flow.</p>
<p><code>w</code> is needed for <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a> compression. However, as we said, we let
the user give us this intermediate buffer. The idea behind that is to let the
user prepare an <em>inflation</em>. For example, in <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a>, instead of
allocating <code>w</code> systematically when we want to decompress a Git object, we
allocate <code>w</code> one time per threads and all are able to use it and <strong>re-use</strong> it.
In this way, we avoid systematic allocations (and allocate only once time) which
can have a serious impact about performances.</p>
<p>The design is pretty close to one idea, a <em>description</em> step by the <code>decoder</code>
function and a real computation loop with the <code>decode</code> function. The idea is to
prepare the inflation with some information (like <code>w</code> and <code>o</code>) before the main
(and the most expensive) computation. Internally we do that too (but it's mostly
about a macro-optimization).</p>
<p>It's the purpose of OCaml in general, be able to have a powerful way to describe
something (with constraints). In our case, we are very limited to what we need
to describe. But, in others libraries like <a href="https://github.com/inhabitedtype/angstrom">angstrom</a>, the description
step is huge (describe the parser according to the BNF) and then, we use it to
the main computation, in the case of angstrom, the parsing (another
example is [cmdliner][cmdliner]).</p>
<p>This is why <code>decoder</code> can be considered as the main function where <code>decode</code> can
be wrapped under a stream.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#deflator" aria-label="deflator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deflator</h3>
<p>The deflator is a new (complex) deal. Indeed, behind it we have two concepts:</p>
<ul>
<li>the encoder (according to RFC 1951)</li>
<li>the compressor</li>
</ul>
<p>For this new version of <code>decompress</code>, we decide to separate these concepts where
one question leads all: how to put my compression algorithm? (instead to use
<a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">LZ77</a>).</p>
<p>In fact, if you are interested in compression, several algorithms exist and, in
some context, it's preferable to use <a href="https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm">lzwa</a> for example or rabin's
fingerprint (with <a href="https://github.com/mirage/duff">duff</a>), etc.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#functor" aria-label="functor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Functor</h4>
<p>The first idea was to provide a <em>functor</em> which expects an implementation of the
compression algorithm. However, the indirection of a functor comes with (big)
performance cost. Consider the following functor example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">module</span> <span class="token keyword">type</span> S <span class="token operator">=</span> <span class="token keyword">sig</span>
  <span class="token keyword">type</span> t
  <span class="token keyword">val</span> add <span class="token punctuation">:</span> t <span class="token operator">-&gt;</span> t <span class="token operator">-&gt;</span> t
  <span class="token keyword">val</span> one <span class="token punctuation">:</span> t
<span class="token keyword">end</span>

<span class="token keyword">module</span> <span class="token module variable">Make</span> <span class="token punctuation">(</span>S <span class="token punctuation">:</span> S<span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token keyword">struct</span> <span class="token keyword">let</span> succ x <span class="token operator">=</span> S<span class="token punctuation">.</span>add x S<span class="token punctuation">.</span>one <span class="token keyword">end</span>

<span class="token keyword">include</span> <span class="token module variable">Make</span> <span class="token punctuation">(</span><span class="token keyword">struct</span>
  <span class="token keyword">type</span> t <span class="token operator">=</span> int
  <span class="token keyword">let</span> add a b <span class="token operator">=</span> a <span class="token operator">+</span> b
  <span class="token keyword">let</span> one <span class="token operator">=</span> <span class="token number">1</span>
<span class="token keyword">end</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> f x <span class="token operator">=</span> succ x</code></pre></div>
<p>Currently, with OCaml 4.07.1, the <code>f</code> function will be a <code>caml_apply2</code>. We might
wish for a simple <a href="https://en.wikipedia.org/wiki/Inline_expansion"><em>inlining</em></a> optimisation, allowing <code>f</code> to become an
<code>addq</code> instruction (indeed, <a href="https://caml.inria.fr/pub/docs/manual-ocaml/flambda.html"><code>flambda</code></a> does this), but optimizing
functors is hard. As we learned from <a href="https://github.com/chambart">Pierre Chambart</a>, it is possible
for the OCaml compiler to optimize functors directly, but this requires
respecting several constraints that are difficult to respect in practice.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#split-encoder-and-compressor" aria-label="split encoder and compressor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Split encoder and compressor</h4>
<p>So, the choice was done to made the encoder which respects RFC 1951 and the
compressor under some constraints. However, this is not what <a href="https://zlib.net/">zlib</a> did
and, by this way, we decided to provide a new design/API which did not follow,
in first instance, zlib (or some others implementations like
<a href="https://github.com/richgel999/miniz">miniz</a>).</p>
<p>To be fair, the choice from zlib and miniz comes from the first
point about API and the context where they are used. The main problem is the
shared queue between the encoder and the compressor. In C code, it can be hard
for the user to deal with it (where they are liable for buffer overflows).</p>
<p>In OCaml and for <code>decompress</code>, the shared queue can be well-abstracted and API
can ensure assumptions (like bounds checking).</p>
<p>Even if this design is much more complex than before, coverage tests are better
where we can separately test the encoder and the compressor. It breaks down the
initial black-box where compression was intrinsec with encoding &ndash; which was
error-prone. Indeed, <code>decompress</code> had a bug about generation of
Huffman codes but we never reached it because the (bad)
compressor was not able to produce something (a specific lengh with a specific
distance) to get it.</p>
<p>NOTE: you have just read the main reason for the new version of <code>decompress</code>!</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#the-compressor" aria-label="the compressor permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The compressor</h4>
<p>The compressor is the most easy part. The goal is to produce from an inputs
flow, an outputs flow which is an other (more compacted) representation. This
representation consists to:</p>
<ul>
<li>A <em>literal</em>, the byte as is</li>
<li>A <em>copy</em> code with an <em>offset</em> and a <em>length</em></li>
</ul>
<p>The last one say to copy <em>length</em> byte(s) from <em>offset</em>. For example, <code>aaaa</code> can
be compressed as <code>[ Literal 'a'; Copy (offset:1, len:3) ]</code>. By this way, instead
to have 4 bytes, we have only 2 elements which will be compressed then by an
<a href="https://zlib.net/feldspar.html">Huffman coding</a>. This is the main idea of the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a>
compression.</p>
<p>However, the compressor should need to deal with the encoder. An easy interface,
<em>&agrave; la <a href="https://github.com/dbuenzli/uutf">uutf</a></em> should be:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> compress <span class="token punctuation">:</span> state <span class="token operator">-&gt;</span> <span class="token punctuation">[</span> <span class="token variant variable">`Literal</span> <span class="token keyword">of</span> char <span class="token operator">|</span> <span class="token variant variable">`Copy</span> <span class="token keyword">of</span> <span class="token punctuation">(</span>int <span class="token operator">*</span> int<span class="token punctuation">)</span> <span class="token operator">|</span> <span class="token variant variable">`End</span> <span class="token operator">|</span> <span class="token variant variable">`Await</span> <span class="token punctuation">]</span></code></pre></div>
<p>But as I said, we need to feed a queue instead.</p>
<hr/>
<p>At this point, the purpose of the queue is not clear and not really explained.
The signature above still is a valid and understandable design. Then, we can
imagine passing <code>Literal</code> and <code>Copy</code> directly to the encoder. However, we should
(for performance purpose) use a delaying tactic between the compressor and the
deflator[^4].</p>
<p>Behind this idea, it's to be able to implement an <em>hot-loop</em> on the encoder
which will iter inside the shared queue and <em>transmit</em>/<em>encode</em> contents
directly to the outputs buffer.</p>
<hr/>
<p>So, when we make a new <code>state</code>, we let the user supply their queue:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">val state : src -&gt; w:bistring -&gt; q:queue -&gt; state
val compress : state -&gt; [ `Flush | `Await | `End ]</code></pre></div>
<p>The <code>Flush</code> case appears when the queue is full. Then, we refind the <code>w</code> window
buffer which is needed to produce the <code>Copy</code> code. A <em>copy code</em> is limited
according RFC 1951 where <em>offset</em> can not be upper than the length of the window
(commonly 32ko). <em>length</em> is limited too to <code>258</code> (an arbitrary choice).</p>
<p>Of course, about the <code>Await</code> case, the compressor comes with a <code>src</code> function as
the inflator. Then, we added some accessors, <code>literals</code> and <code>distances</code>. The
compressor does not build the <a href="https://zlib.net/feldspar.html">Huffman coding</a> which needs
frequencies, so we need firstly to keep counters about that inside the state and
a way to get them (and pass them to the encoder).</p>
<p><code>[4]</code>: About that, you should be interesting by the reason of <a href="https://www.reddit.com/r/unix/comments/6gxduc/how_is_gnu_yes_so_fast/">why GNU yes is so
fast</a> where the secret is just about buffering.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#the-encoder" aria-label="the encoder permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The encoder</h4>
<p>Finally, we can talk about the encoder which will take the shared queue filled
by the compressor and provide an RFC 1951 compliant output flow.</p>
<p>However, we need to consider a special <em>detail</em>. When we want to make a
DYNAMIC block from frequencies and then encode the inputs flow, we can reach a
case where the shared queue contains an <em>opcode</em> (a <em>literal</em> or a <em>copy</em>) which
does not appear in our dictionary.</p>
<p>In fact, if we want to encode <code>[ Literal 'a'; Literal 'b' ]</code>, we will not try to
make a dictionary which will contains the 256 possibilities of a byte but we
will only make a dictionary from frequencies which contains only <code>'a'</code> and
<code>'b'</code>. By this way, we can reach a case where the queue contains an <em>opcode</em>
(like <code>Literal 'c'</code>) which can not be encoded by the <em>pre-determined</em>
Huffman coding &ndash; remember, the DYNAMIC block <strong>starts</strong> with
the dictionary.</p>
<p>Another point is about inputs. The encoder expects, of course, contents from
the shared queue but it wants from the user the way to encode contents: which
block we want to emit. So it has two entries:</p>
<ul>
<li>the shared queue</li>
<li>an <em>user-entry</em></li>
</ul>
<p>So for many real tests, we decided to provide this kind of API:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> dst <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token variant variable">`Channel</span> <span class="token keyword">of</span> out_channel <span class="token operator">|</span> <span class="token variant variable">`Buffer</span> <span class="token keyword">of</span> <span class="token module variable">Buffer</span><span class="token punctuation">.</span>t <span class="token operator">|</span> <span class="token variant variable">`Manual</span> <span class="token punctuation">]</span>

<span class="token keyword">val</span> encoder <span class="token punctuation">:</span> dst <span class="token operator">-&gt;</span> q<span class="token punctuation">:</span>queue <span class="token operator">-&gt;</span> encoder
<span class="token keyword">val</span> encode <span class="token punctuation">:</span> encoder <span class="token operator">-&gt;</span> <span class="token punctuation">[</span> <span class="token variant variable">`Block</span> <span class="token keyword">of</span> block <span class="token operator">|</span> <span class="token variant variable">`Flush</span> <span class="token operator">|</span> <span class="token variant variable">`Await</span> <span class="token punctuation">]</span> <span class="token operator">-&gt;</span> <span class="token punctuation">[</span> <span class="token variant variable">`Ok</span> <span class="token operator">|</span> <span class="token variant variable">`Partial</span> <span class="token operator">|</span> <span class="token variant variable">`Block</span> <span class="token punctuation">]</span>
<span class="token keyword">val</span> dst <span class="token punctuation">:</span> encoder <span class="token operator">-&gt;</span> bigstring <span class="token operator">-&gt;</span> off<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> len<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> unit</code></pre></div>
<p>As expected, we take the shared queue to make a new encoder. Then, we let the
user to specify which kind of block they want to encode by the <code>Block</code>
operation.</p>
<p>The <code>Flush</code> operation tries to encode all elements present inside the shared
queue according to the current block and feed the outputs buffer. From it, the
encoder can returns some values:</p>
<ul>
<li><code>Ok</code> and the encoder encoded all <em>opcode</em> from the shared queue</li>
<li><code>Partial</code>, the outputs buffer is not enough to encode all <em>opcode</em>, the user
should flush it and give to us a new empty buffer with <code>dst</code>. Then, they must
continue with the <code>Await</code> operation.</li>
<li><code>Block</code>, the encoder reachs an <em>opcode</em> which can not be encoded with the
current block (the current dictionary). Then, the user must continue with a new
<code>Block</code> operation.</li>
</ul>
<p>The hard part is about the <em>ping-pong</em> game between the user and the encoder
where a <code>Block</code> expects a <code>Block</code> response from the user and a <code>Partial</code> expects
an <code>Await</code> response. But this design reveals something higher about zlib
this time: the <em>flush</em> mode.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#the-flush-mode" aria-label="the flush mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The <em>flush</em> mode</h4>
<p>Firstly, we talk about <em>mode</em> because zlib does not allow the user to
decide what they want to do when we reach a <code>Block</code> or a <code>Ok</code> case. So, it
defines some <a href="https://www.bolet.org/~pornin/deflate-flush.html">under-specified <em>modes</em></a> to apply a policy of what
to do in this case.</p>
<p>In <code>decompress</code>, we followed the same design and see that it may be not a good
idea where the logic is not very clear and the user wants may be an another
behavior. It was like a <em>black-box</em> with a <em>black-magic</em>.</p>
<p>Because we decided to split encoder and compressor, the idea of the <em>flush mode</em>
does not exists anymore where the user explicitly needs to give to the encoder
what they want (make a new block? which block? keep frequencies?). So we broke
the <em>black-box</em>. But, as we said, it was possible mostly because we can abstract
safely the shared queue between the compressor and the encoder.</p>
<p>OCaml is an expressive language and we can really talk about a queue where, in
C, it will be just an other <em>array</em>. As we said, the deal is about performance,
but now, we allow the user the possibility to write their code in this corner-case
which is when they reachs <code>Block</code>. Behaviors depends only on them.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#apis-in-general" aria-label="apis in general permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>APIs in general</h2>
<p>The biggest challenge of building a library is defining the API - you must
strike a compromise between allowing the user the flexibility to express their
use-case and constraining the user to avoid API misuse. If at all possible,
provide an <em>intuitive</em> API: force the user not to need to think about security
issues, memory consumption or performance.</p>
<p>Avoid making your API so expressive that it becomes unusable, but beware that
this sets hard limits on your users: the current <code>decompress</code> API can be used to
build <code>of_string</code> / <code>to_string</code> functions, but the opposite is not true - you
definitely cannot build a stream API from <code>of_string</code> / <code>to_string</code>.</p>
<p>The best advice when designing a library is to keep in mind what you <strong>really</strong>
want and let the other details fall into place gradually. It is very important
to work in an iterative loop of repeatedly trying to use your library; only this
can highlight bad design, corner-cases and details.</p>
<p>Finally, use and re-use it on your tests (important!) and inside higher-level
projects to give you interesting questions about your design. The last version
of <code>decompress</code> was not used in <a href="https://github.com/mirage/ocaml-git/">ocaml-git</a> mostly because the flush
mode was unclear.</p>
