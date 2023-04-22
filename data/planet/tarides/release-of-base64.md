---
title: Release of Base64
description: "MirageOS is a library operating system written from the ground up in
  OCaml.\nIt has an impossible and incredibly huge goal to re-implement\u2026"
url: https://tarides.com/blog/2019-02-08-release-of-base64
date: 2019-02-08T00:00:00-00:00
preview_image: https://tarides.com/static/50a0344945c9df2a67b60ef32ee43a0f/0132d/mailboxes.jpg
featured:
---

<p>MirageOS is a library operating system written from the ground up in OCaml.
It has an impossible and incredibly huge goal to re-implement all of the
world! Looking back at the work accomplished by the MirageOS team, it appears that's
what happened for several years. Re-implementing the entire stack, in particular
the lower layers that we often take for granted, requires a great attention to
detail. While it may seem reasonably easy to implement a given RFC, a huge
amount of work is often hidden under the surface.</p>
<p>In this article, we will explain the development process we went through, as we
updated a small part of the MirageOS stack: the library <code>ocaml-base64</code>. It's a
suitable example as the library is small (few hundreds lines of code), but it
needs ongoing development to ensure good quality and to be able to trust it for
higher level libraries (like <a href="https://github.com/mirage/mrmime">mrmime</a>).</p>
<p>Updating the library was instigated by a problem I ran into with the existing
base64 implementation while working on the e-mail stack. Indeed, we got some
errors when we tried to compute an <em>encoded-word</em> according to the <a href="https://www.ietf.org/rfc/rfc2047.txt">RFC
2047</a>. So after several years of not being touched, we decided to
update <a href="https://github.com/mirage/ocaml-base64"><code>ocaml-base64</code></a>.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#the-critique-of-pure-reason" aria-label="the critique of pure reason permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Critique of Pure Reason</h1>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-first-problem" aria-label="the first problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The first problem</h2>
<p>We started by attempting to use <code>ocaml-base64</code> on some examples extracted from
actual e-mails, and we quickly ran into cases where the library failed. This
highlighted that reality is much more complex than you can imagine from reading
an RFC. In this situation, what do you do: try to implement a best-effort
strategy and continue parsing? Or stick to the letter of the RFC and fail? In
the context of e-mails, which has accumulated a lot of baggage over time, you
cannot get around implementing a best-effort strategy.</p>
<p>The particular error we were seeing was a <code>Not_found</code> exception when decoding an
<em>encoded-word</em>. This exception appeared because the implementation relied on
<code>String.contains</code>, and the input contained a character which was not part of the
base64 alphabet.</p>
<p>This was the first reason why we thought it necessary to rewrite <code>ocaml-base64</code>.
Of course, we could just catch the exception and continue the initial
computation, but then another reason appeared.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-second-problem" aria-label="the second problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The second problem</h2>
<p>As <a href="https://github.com/clecat">@clecat</a> and I reviewed RFC 2045, we noticed the
following requirement:</p>
<blockquote>
<p>The encoded output stream must be represented in lines of no more than 76
characters each.</p>
<p>See RFC 2045, section 6.8</p>
</blockquote>
<p>Pretty specific, but general to e-mails, we should never have more than 78
characters per line according to <a href="https://www.ietf.org/rfc/rfc822.txt">RFC 822</a>, nor more than 998 characters
according to <a href="https://www.ietf.org/rfc/rfc2822.txt">RFC 2822</a>.</p>
<p>Having a decoder that abided RFC 2045 more closely, including the requirement
above, further spurred us to implement a new decoder.</p>
<p>As part of the new implementation, we decided to implement tests and fuzzers to
ensure correctness. This also had the benefit, that we could run the fuzzer on
the existing codebase. When fuzzing an encoder/decoder pair, an excellent check
is whether the following isomorphism holds:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> iso0 input <span class="token operator">=</span> <span class="token keyword">assert</span> <span class="token punctuation">(</span>decode <span class="token punctuation">(</span>encode input<span class="token punctuation">)</span> <span class="token operator">=</span> input<span class="token punctuation">)</span>
<span class="token keyword">let</span> iso1 input <span class="token operator">=</span> <span class="token keyword">assert</span> <span class="token punctuation">(</span>encode <span class="token punctuation">(</span>decode input<span class="token punctuation">)</span> <span class="token operator">=</span> input<span class="token punctuation">)</span></code></pre></div>
<p>However, at this point <a href="https://github.com/hannesm">@hannesm</a> ran into another error (see
<a href="https://github.com/mirage/ocaml-base64/issues/20">#20</a>).</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-third-problem" aria-label="the third problem permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The third problem</h2>
<p>We started to review the <a href="https://github.com/mirleft/ocaml-nocrypto"><code>nocrypto</code></a> implementation of base64, which
respects our requirements. We had some concerns about the performance of the
implementation though, so we decided to see if we would get a performance
regression by switching to this implementation.</p>
<p>A quick benchmark based on random input revealed the opposite, however!
<code>nocrypto</code>'s implementation was faster than <code>ocaml-base64</code>:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">ocaml-base64's implementation on bytes (length: 5000): 466 272.34ns
nocrypto's implementation on bytes (length: 5000): 137 406.04ns</code></pre></div>
<p>Based on all these observations, we thought there was sufficient reason to
reconsider the <code>ocaml-base64</code> implementation. It's also worth mentioning that
the last real release (excluding <code>dune</code>/<code>jbuilder</code>/<code>topkg</code> updates) is from Dec.
24 2014. So, it's pretty old code and the OCaml eco-system has improved a lot
since 2014.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#implementation--review" aria-label="implementation  review permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Implementation &amp; review</h1>
<p>We started integrating the <code>nocrypto</code> implementation. Of course, implementing
<a href="https://www.ietf.org/rfc/rfc4648.txt">RFC 4648</a> is not as easy as just reading examples and trying to do
something which works. The devil is in the detail.</p>
<p>@hannesm and <a href="https://github.com/cfcs">@cfcs</a> decided to do a big review of expected behavior
according to the RFC, and another about implementation and security issues.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#canonicalization" aria-label="canonicalization permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Canonicalization</h2>
<p>The biggest problem about RFC 4648 is regarding canonical inputs. Indeed, there
are cases where two different inputs are associated with the same value:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token string">&quot;Zm9vCg==&quot;</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">&quot;foo\n&quot;</span>
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token string">&quot;Zm9vCh==&quot;</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">&quot;foo\n&quot;</span></code></pre></div>
<p>This is mostly because the base64 format encodes the input 6 bits at a time. The
result is that 4 base64 encoded bytes are equal to 3 decoded bytes (<code>6 * 4 = 8 * 3</code>). Because of this, 2 base64 encoded bytes provide 1 byte plus 4 bits. What do
we need to do with these 4 bits? Nothing.</p>
<p>That's why the last character in our example can be something else than <code>g</code>. <code>g</code>
is the canonical byte to indicate using the 2 bits afterward the 6 bits
delivered by <code>C</code> (and make a byte - 8 bits). But <code>h</code> can be used where we just
need 2 bits at the end.</p>
<p>Due to this behavior, the check used for fuzzing changes: from a canonical
input, we should check isomorphism.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#invalid-character" aria-label="invalid character permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Invalid character</h2>
<p>As mentioned above (&quot;The first problem&quot;), how should invalid characters be
handled? This happens when decoding a byte which is not a part of the base64
alphabet. In the old version, <code>ocaml-base64</code> would simply leak a <code>Not_found</code>
exception from <code>String.contains</code>.</p>
<p>The MirageOS team has taken <a href="https://mirage.io/wiki/mirage-3.0-errors">a stance on exceptions</a>, which is
to &quot;use exceptions for exceptional conditions&quot; - invalid input is hardly one of
those. This is to avoid any exception leaks, as it can be really hard to track
the origin of an exception in a unikernel. Because of this, several packages
have been updated to return a <code>result</code> type instead, and we wanted the new
implementation to follow suit.</p>
<p>On the other hand, exceptions can be useful when considered as a more
constrained form of assembly jump. Of course, they break the control flow, but
from a performance point of view, it's interesting to use this trick:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">exception</span> <span class="token module variable">Found</span>

<span class="token keyword">let</span> contains str chr <span class="token operator">=</span>
  <span class="token keyword">let</span> idx <span class="token operator">=</span> ref <span class="token number">0</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> len <span class="token operator">=</span> <span class="token module variable">String</span><span class="token punctuation">.</span>length str <span class="token keyword">in</span>
  <span class="token keyword">try</span> <span class="token keyword">while</span> <span class="token operator">!</span>idx <span class="token operator">&lt;</span> len
      <span class="token keyword">do</span> <span class="token keyword">if</span> <span class="token module variable">String</span><span class="token punctuation">.</span>unsafe_get str <span class="token operator">!</span>idx <span class="token operator">=</span> chr <span class="token keyword">then</span> raise <span class="token module variable">Found</span> <span class="token punctuation">;</span> incr idx <span class="token keyword">done</span> <span class="token punctuation">;</span>
      <span class="token module variable">None</span>
  <span class="token keyword">with</span> <span class="token module variable">Found</span> <span class="token operator">-&gt;</span> <span class="token module variable">Some</span> <span class="token operator">!</span>idx</code></pre></div>
<p>This kind of code for example is ~20% faster than <code>String.contains</code>.</p>
<p>As such, exceptions can be a useful tool for performance optimizations, but we
need to be extra careful not to expose them to the users of the library. This
code needs to be hidden behind a fancy functional interface. With this in mind,
we should assert that our <code>decode</code> function never leaks an exception. We'll
describe how we've adressed this problem later.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#special-cases" aria-label="special cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Special cases</h2>
<p>RFC 4648 has some detailed cases and while we would sometimes like to work in a
perfect world where we will never need to deal with such errors, from our
experience, we cannot imagine what the end-user will do to formats, protocols
and such.</p>
<p>Even though the RFC has detailed examples, we have to read between lines to know
special cases and how to deal with them.</p>
<p>@hannesm noticed one of these cases, where padding (<code>=</code> sign at the end of
input) is not mandatory:</p>
<blockquote>
<p>The pad character &quot;=&quot; is typically percent-encoded when used in an URI [9],
but if the data length is known implicitly, this can be avoided by skipping
the padding; see section 3.2.</p>
<p>See RFC 4648, section 5</p>
</blockquote>
<p>That mostly means that the following kind of input can be valid:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">false</span> <span class="token string">&quot;Zm9vCg&quot;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">&quot;foo\n&quot;</span></code></pre></div>
<p>It's only valid in a specific context though: when <em>length is known implicitly</em>.
Only the caller of <code>decode</code> can determine whether the length is implicitly known
such that padding can be omitted. To that end, we've added a new optional
argument <code>?pad</code> to the function <code>Base64.decode</code>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#allocation-sub-off-and-len" aria-label="allocation sub off and len permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Allocation, <code>sub</code>, <code>?off</code> and <code>?len</code></h2>
<p>Xavier Leroy has described the garbage collector in the following way:</p>
<blockquote>
<p>You see, the Caml garbage collector is like a god from ancient mythology:
mighty, but very irritable. If you mess with it, it'll make you suffer in
surprising ways.</p>
</blockquote>
<p>That's probably why my experience with improving the allocation policy of
(<code>ocaml-git</code>)<a href="https://github.com/mirage/ocaml-git">ocaml-git</a> was quite a nightmare. Allowing the user to control
allocation is important for efficiency, and we wanted to <code>ocaml-base64</code> to be a
good citizen.</p>
<p>At the beginning, <code>ocaml-base64</code> had a very simple API:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> decode <span class="token punctuation">:</span> string <span class="token operator">-&gt;</span> string
<span class="token keyword">val</span> encode <span class="token punctuation">:</span> string <span class="token operator">-&gt;</span> string</code></pre></div>
<p>This API forces allocations in two ways.</p>
<p>Firstly, if the caller needs to encode a part of a string, this part needs to be
extracted, e.g. using <code>String.sub</code>, which will allocate a new string. To avoid
this, two new optional arguments have been added to <code>encode</code>: <code>?off</code> and <code>?len</code>,
which specifies the substring to encode. Here's an example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* We want to encode the part 'foo' without prefix or suffix *)</span>

<span class="token comment">(* Old API -- forces allocation *)</span>
<span class="token module variable">Base64</span><span class="token punctuation">.</span>encode <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>sub <span class="token string">&quot;prefix foo suffix&quot;</span> <span class="token number">7</span> <span class="token number">3</span><span class="token punctuation">)</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">&quot;Zm9v&quot;</span>

<span class="token comment">(* New API -- avoids allocation *)</span>
<span class="token module variable">Base64</span><span class="token punctuation">.</span>encode <span class="token label function">~off</span><span class="token punctuation">:</span><span class="token number">7</span> <span class="token label function">~len</span><span class="token punctuation">:</span><span class="token number">3</span> <span class="token string">&quot;prefix foo suffix&quot;</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token operator">-</span> <span class="token punctuation">:</span> string <span class="token operator">=</span> <span class="token string">&quot;Zm9v&quot;</span></code></pre></div>
<p>Secondly, a new string is allocated to hold the resulting string. We can
calculate a bound on the length of this string in the following manner:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token operator">//</span><span class="token punctuation">)</span> x y <span class="token operator">=</span>
  <span class="token keyword">if</span> y <span class="token operator">&lt;</span> <span class="token number">1</span> <span class="token keyword">then</span> raise <span class="token module variable">Division_by_zero</span> <span class="token punctuation">;</span>
  <span class="token keyword">if</span> x <span class="token operator">&gt;</span> <span class="token number">0</span> <span class="token keyword">then</span> <span class="token number">1</span> <span class="token operator">+</span> <span class="token punctuation">(</span><span class="token punctuation">(</span>x <span class="token operator">-</span> <span class="token number">1</span><span class="token punctuation">)</span> <span class="token operator">/</span> y<span class="token punctuation">)</span> <span class="token keyword">else</span> <span class="token number">0</span>

<span class="token keyword">let</span> encode input <span class="token operator">=</span>
  <span class="token keyword">let</span> res <span class="token operator">=</span> <span class="token module variable">Bytes</span><span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length input <span class="token operator">//</span> <span class="token number">3</span> <span class="token operator">*</span> <span class="token number">4</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> decode input <span class="token operator">=</span>
  <span class="token keyword">let</span> res <span class="token operator">=</span> <span class="token module variable">Bytes</span><span class="token punctuation">.</span>create <span class="token punctuation">(</span><span class="token module variable">String</span><span class="token punctuation">.</span>length input <span class="token operator">//</span> <span class="token number">4</span> <span class="token operator">*</span> <span class="token number">3</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<p>Unfortunately we cannot know the exact length of the result prior to computing
it. This forces a call to <code>String.sub</code> at the end of the computation to return a
string of the correct length. This means we have two allocations rather than
one. To avoid the additional allocation, [@avsm][avsm] proposed to provide a new
type <code>sub = string * int * int</code>. This lets the user call <code>String.sub</code> if
required (and allocate a new string), or use simply use the returned <code>sub</code> for
_blit_ting to another buffer or similar.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#fuzz-everything" aria-label="fuzz everything permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fuzz everything!</h1>
<p>There's a strong trend of fuzzing libraries for MirageOS, which is quite easy
thanks to the brilliant work by <a href="https://github.com/yomimono">@yomimono</a> and <a href="https://github.com/stedolan">@stedolan</a>!
The integrated fuzzing in OCaml builds on <a href="http://lcamtuf.coredump.cx/afl/">American fuzzy lop</a>, which is
very smart about discarding paths of execution that have already been tested and
generating unseen inputs which break your assumptions. My first experience with
fuzzing was with the library <a href="https://github.com/mirage/decompress"><code>decompress</code></a>, and I was impressed by
<a href="https://github.com/mirage/decompress/pull/34">precise error</a> it found about a name clash.</p>
<p>Earlier in this article, I listed some properties we wanted to check for
<code>ocaml-base64</code>:</p>
<ul>
<li>The functions <code>encode</code> and <code>decode</code> should be be isomorphic taking
canonicalization into account:</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> iso0 input <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">false</span> input <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> <span class="token module variable">Ok</span> result0 <span class="token operator">-&gt;</span>
    <span class="token keyword">let</span> result1 <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn result0 <span class="token keyword">in</span>
    <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">true</span> result1 <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token operator">|</span> <span class="token module variable">Ok</span> result2 <span class="token operator">-&gt;</span> check_eq result0 result2

<span class="token keyword">let</span> iso1 input <span class="token operator">=</span>
  <span class="token keyword">let</span> result <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn input <span class="token keyword">in</span>
  <span class="token keyword">match</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode <span class="token label function">~pad</span><span class="token punctuation">:</span><span class="token boolean">true</span> result0 <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token module variable">Error</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token operator">|</span> <span class="token module variable">Ok</span> result1 <span class="token operator">-&gt;</span>
    <span class="token keyword">let</span> result2 <span class="token operator">=</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>encode_exn result1 <span class="token keyword">in</span>
    check_eq result0 result2</code></pre></div>
<ul>
<li>The function <code>decode</code> should <em>never</em> raise an exception, but rather return a
result type:</li>
</ul>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> no_exn input <span class="token operator">=</span>
  <span class="token keyword">try</span> ignore <span class="token operator">@@</span> <span class="token module variable">Base64</span><span class="token punctuation">.</span>decode input <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> fail <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<ul>
<li>And finally, we should randomize <code>?off</code> and <code>?len</code> arguments to ensure that we
don't get an <code>Out_of_bounds</code> exception when accessing input.</li>
</ul>
<p>Just because we've applied fuzzing to the new implementation for a long time, it
doesn't mean that the code is completely infallible. People can use our library
in an unimaginable way (and it's mostly what happens in the real world) and get
an unknowable error.</p>
<p>But, with the fuzzer, we've managed to test some properties across a very wide
range of input instead of unit testing with random (or not so random) inputs
from our brains. This development process allows <em>fixing the semantics</em> of
implementations (even if it's <strong>not</strong> a formal definition of semantics), but
it's better than nothing or outdated documentation.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h1>
<p>Based on our recent update to <code>ocaml-base64</code>, this blog post explains our
development process as go about rewriting the world to MirageOS, one bit at a
time. There's an important point to be made though:</p>
<p><code>ocaml-base64</code> is a small project. Currently, the implementation is about 250
lines of code. So it's a really small project. But as stated in the
introduction, we are fortunate enough to push the restart button of the computer
world - yes, we want to make a new operating system.</p>
<p>That's a massive task, and we shouldn't make it any harder on ourselves than
necessary. As such, we need to justify any step, any line of code, and why we
decided to spend our time on any change (why we decided to re-implement <code>git</code>
for example). So before committing any time to projects, we try to do a deep
analysis of the problem, get feedback from others, and find a consensus between
what we already know, what we want and what we should have (in the case of
<code>ocaml-base64</code>, @hannesm did a look on the PHP implementation and the Go
implementation).</p>
<p>Indeed, this is a hard question which nobody can answer perfectly in isolation.
So, the story of this update to <code>ocaml-base64</code> is an invitation for you to enter
the arcanas of the computer world through MirageOS :) ! Don't be afraid!</p>
