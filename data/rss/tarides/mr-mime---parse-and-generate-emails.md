---
title: Mr. MIME - Parse and generate emails
description: "We're glad to announce the first release of mrmime, a parser and a\ngenerator
  of emails. This library provides an OCaml way to analyze and\u2026"
url: https://tarides.com/blog/2019-09-25-mr-mime-parse-and-generate-emails
date: 2019-09-25T00:00:00-00:00
preview_image: https://tarides.com/static/14bcc335478eae1bbad1c2f4cdd244af/0132d/mailboxes2.jpg
featured:
---

<p>We're glad to announce the first release of <a href="https://github.com/mirage/mrmime.git"><code>mrmime</code></a>, a parser and a
generator of emails. This library provides an <em>OCaml way</em> to analyze and craft
an email. The eventual goal is to build an entire <em>unikernel-compatible</em> stack
for email (such as SMTP or IMAP).</p>
<p>In this article, we will show what is currently possible with <code>mrmime</code> and
present a few of the useful libraries that we developed along the way.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#an-email-parser" aria-label="an email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An email parser</h2>
<p>Some years ago, Romain gave <a href="https://www.youtube.com/watch?v=kQkRsNEo25k">a talk</a> about what an email really <em>is</em>.
Behind the human-comprehensible format (or <em>rich-document</em> as we said a
long time ago), there are several details of emails which complicate the process of
analyzing them (and can be prone to security lapses). These details are mostly described
by three RFCs:</p>
<ul>
<li><a href="https://tools.ietf.org/html/rfc822">RFC822</a></li>
<li><a href="https://tools.ietf.org/html/rfc2822">RFC2822</a></li>
<li><a href="https://tools.ietf.org/html/rfc5322">RFC5322</a></li>
</ul>
<p>Even though they are cross-compatible, providing full legacy email parsing is an
archaeological exercise: each RFC retains support for the older design decisions
(which were not recognized as bad or ugly in 1970 when they were first standardized).</p>
<p>The latest email-related RFC (RFC5322) tried to fix the issue and provide a better
<a href="https://tools.ietf.org/html/rfc5234">formal specification</a> of the email format &ndash; but of course, it comes with plenty of
<em>obsolete</em> rules which need to be implemented. In the standard, you find
both the current grammar rule and its obsolete equivalent.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#an-extended-email-parser" aria-label="an extended email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An extended email parser</h3>
<p>Even if the email format can defined by &quot;only&quot; 3 RFCs, you will
miss email internationalization (<a href="https://tools.ietf.org/html/rfc6532">RFC6532</a>), the MIME format
(<a href="https://tools.ietf.org/html/rfc2045">RFC2045</a>, <a href="https://tools.ietf.org/html/rfc2046">RFC2046</a>, <a href="https://tools.ietf.org/html/rfc2047">RFC2047</a>,
<a href="https://tools.ietf.org/html/rfc2049">RFC2049</a>), or certain details needed to be interoperable with SMTP
(<a href="https://tools.ietf.org/html/rfc5321">RFC5321</a>). There are still more RFCs which add extra features
to the email format such as S/MIME or the Content-Disposition field.</p>
<p>Given this complexity, we took the most general RFCs and tried to provide an easy way to deal
with them. The main difficulty is the <em>multipart</em> parser, which deals with email
attachments (anyone who has tried to make an HTTP 1.1 parser knows about this).</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-realistic-email-parser" aria-label="a realistic email parser permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A realistic email parser</h3>
<p>Respecting the rules described by RFCs is not enough to be able to analyze any
email from the real world: existing email generators can, and do, produce
<em>non-compliant</em> email. We stress-tested <code>mrmime</code> by feeding it a batch of 2
billion emails taken from the wild, to see if it could parse everything (even if
it does not produce the expected result). Whenever we noticed a recurring
formatting mistake, we updated the details of the <a href="https://tools.ietf.org/html/rfc5234">ABNF</a> to enable
<code>mrmime</code> to parse it anyway.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-parser-usable-by-others" aria-label="a parser usable by others permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A parser usable by others</h3>
<p>One demonstration of the usability of <code>mrmime</code> is <a href="https://github.com/dinosaure/ocaml-dkim.git"><code>ocaml-dkim</code></a>, which wants to
extract a specific field from your mail and then verify that the hash and signature
are as expected.</p>
<p><code>ocaml-dkim</code> is used by the latest implementation of <a href="https://github.com/mirage/ocaml-dns.git"><code>ocaml-dns</code></a> to request
public keys in order to verify email.</p>
<p>The most important question about <code>ocaml-dkim</code> is: is it able to
verify your email in one pass? Indeed, currently some implementations of DKIM
need 2 passes to verify your email (one to extract the DKIM signature, the other
to digest some fields and bodies). We focused on verifying in a <em>single</em> pass in
order to provide a unikernel SMTP <em>relay</em> with no need to store your email between
verification passes.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#an-email-generator" aria-label="an email generator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>An email generator</h2>
<p>OCaml is a good language for making little DSLs for specialized use-cases. In this
case, we took advantage of OCaml to allow the user to easily craft an email from
nothing.</p>
<p>The idea is to build an OCaml value describing the desired email header, and
then let the Mr. MIME generator transform this into a stream of characters that
can be consumed by, for example, an SMTP implementation. The description step
is quite simple:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token directive important">#require</span> <span class="token string">&quot;mrmime&quot;</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token directive important">#require</span> <span class="token string">&quot;ptime.clock.os&quot;</span> <span class="token punctuation">;</span><span class="token punctuation">;</span>

<span class="token keyword">open</span> <span class="token module variable">Mrmime</span>

<span class="token keyword">let</span> romain_calascibetta <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Mailbox</span> <span class="token keyword">in</span>
  <span class="token module variable">Local</span><span class="token punctuation">.</span><span class="token punctuation">[</span> w <span class="token string">&quot;romain&quot;</span><span class="token punctuation">;</span> w <span class="token string">&quot;calascibetta&quot;</span> <span class="token punctuation">]</span> <span class="token operator">@</span> <span class="token module variable">Domain</span><span class="token punctuation">.</span><span class="token punctuation">(</span>domain<span class="token punctuation">,</span> <span class="token punctuation">[</span> a <span class="token string">&quot;gmail&quot;</span><span class="token punctuation">;</span> a <span class="token string">&quot;com&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> john_doe <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Mailbox</span> <span class="token keyword">in</span>
  <span class="token module variable">Local</span><span class="token punctuation">.</span><span class="token punctuation">[</span> w <span class="token string">&quot;john&quot;</span> <span class="token punctuation">]</span> <span class="token operator">@</span> <span class="token module variable">Domain</span><span class="token punctuation">.</span><span class="token punctuation">(</span>domain<span class="token punctuation">,</span> <span class="token punctuation">[</span> a <span class="token string">&quot;doe&quot;</span><span class="token punctuation">;</span> a <span class="token string">&quot;org&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>
  <span class="token operator">|&gt;</span> with_name <span class="token module variable">Phrase</span><span class="token punctuation">.</span><span class="token punctuation">(</span>v <span class="token punctuation">[</span> w <span class="token string">&quot;John&quot;</span><span class="token punctuation">;</span> w <span class="token string">&quot;D.&quot;</span> <span class="token punctuation">]</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> now <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Date</span> <span class="token keyword">in</span>
  of_ptime <span class="token label function">~zone</span><span class="token punctuation">:</span><span class="token module variable">Zone</span><span class="token punctuation">.</span><span class="token module variable">GMT</span> <span class="token punctuation">(</span><span class="token module variable">Ptime_clock</span><span class="token punctuation">.</span>now <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> subject <span class="token operator">=</span>
  <span class="token module variable">Unstructured</span><span class="token punctuation">.</span><span class="token punctuation">[</span> v <span class="token string">&quot;A&quot;</span><span class="token punctuation">;</span> sp <span class="token number">1</span><span class="token punctuation">;</span> v <span class="token string">&quot;Simple&quot;</span><span class="token punctuation">;</span> sp <span class="token number">1</span><span class="token punctuation">;</span> v <span class="token string">&quot;Mail&quot;</span> <span class="token punctuation">]</span>

<span class="token keyword">let</span> header <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">open</span> <span class="token module variable">Header</span> <span class="token keyword">in</span>
  <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Subject</span> <span class="token operator">$</span> subject<span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Sender</span> <span class="token operator">$</span> romain_calascibetta<span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">To</span> <span class="token operator">$</span> <span class="token module variable">Address</span><span class="token punctuation">.</span><span class="token punctuation">[</span> mailbox john_doe <span class="token punctuation">]</span><span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> <span class="token module variable">Field</span><span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token module variable">Date</span> <span class="token operator">$</span> now <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">)</span>
  <span class="token operator">&amp;</span> empty

<span class="token keyword">let</span> stream <span class="token operator">=</span> <span class="token module variable">Header</span><span class="token punctuation">.</span>to_stream header

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> <span class="token keyword">rec</span> go <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
    <span class="token keyword">match</span> stream <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Some</span> buf <span class="token operator">-&gt;</span> print_string buf<span class="token punctuation">;</span> go <span class="token punctuation">(</span><span class="token punctuation">)</span>
    <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-&gt;</span> <span class="token punctuation">(</span><span class="token punctuation">)</span>
  <span class="token keyword">in</span>
  go <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>This code produces the following header:</p>
<div class="gatsby-highlight" data-language="mail"><pre class="language-mail"><code class="language-mail">Date: 2 Aug 2019 14:10:10 GMT
To: John &quot;D.&quot; &lt;john@doe.org&gt;
Sender: romain.calascibetta@gmail.com
Subject: A Simple Mail</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#78-character-rule" aria-label="78 character rule permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>78-character rule</h3>
<p>One aspect about email and SMTP is about some historical rules of how to
generate them. One of them is about the limitation of bytes per line. Indeed, a
generator of mail should emit at most 80 bytes per line - and, of course, it
should emits entirely the email line per line.</p>
<p>So <code>mrmime</code> has his own encoder which tries to wrap your mail into this limit.
It was mostly inspired by <a href="https://github.com/inhabitedtype/faraday">Faraday</a> and <a href="https://caml.inria.fr/pub/docs/manual-ocaml/libref/Format.html">Format</a> powered with
GADT to easily describe how to encode/generate parts of an email.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#a-multipart-email-generator" aria-label="a multipart email generator permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>A multipart email generator</h3>
<p>Of course, the main point about email is to be able to generate a multipart
email - just to be able to send file attachments. And, of course, a deep work
was done about that to make parts, compose them into specific <code>Content-Type</code>
fields and merge them into one email.</p>
<p>Eventually, you can easily make a stream from it, which respects rules (78 bytes
per line, stream line per line) and use it directly into an SMTP implementation.</p>
<p>This is what we did with the project <a href="https://github.com/dinosaure/facteur"><code>facteur</code></a>. It's a little
command-line tool to send with file attachement mails in pure OCaml - but it
works only on an UNIX operating system for instance.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#behind-the-forest" aria-label="behind the forest permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Behind the forest</h2>
<p>Even if you are able to parse and generate an email, more work is needed to get the expected results.</p>
<p>Indeed, email is a exchange unit between people and the biggest deal on that is
to find a common way to ensure a understable communication each others. About
that, encoding is probably the most important piece and when a French person wants
to communicate with a <em>latin1</em> encoding, an American person can still use ASCII.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#rosetta" aria-label="rosetta permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Rosetta</h3>
<p>So about this problem, the choice was made to unify any contents to UTF-8 as the
most general encoding of the world. So, we did some libraries which map an encoding flow
to Unicode code-point, and we use <code>uutf</code> (thanks to <a href="https://github.com/dbuenzli">dbuenzli</a>) to normalize it to UTF-8.</p>
<p>The main goal is to avoid a headache to the user about that and even if
contents of the mail is encoded with <em>latin1</em> we ensure to translate it
correctly (and according RFCs) to UTF-8.</p>
<p>This project is <a href="https://github.com/mirage/rosetta"><code>rosetta</code></a> and it comes with:</p>
<ul>
<li><a href="https://github.com/mirage/uuuu"><code>uuuu</code></a> for ISO-8859 encoding</li>
<li><a href="https://github.com/mirage/coin"><code>coin</code></a> for KOI8-{R,U} encoding</li>
<li><a href="https://github.com/mirage/yuscii"><code>yuscii</code></a> for UTF-7 encoding</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#pecu-and-base64" aria-label="pecu and base64 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Pecu and Base64</h3>
<p>Then, bodies can be encoded in some ways, 2 precisely (if we took the main
standard):</p>
<ul>
<li>A base64 encoding, used to store your file</li>
<li>A quoted-printable encoding</li>
</ul>
<p>So, about the <code>base64</code> package, it comes with a sub-package <code>base64.rfc2045</code>
which respects the special case to encode a body according RFC2045 and SMTP
limitation.</p>
<p>Then, <code>pecu</code> was made to encode and decode <em>quoted-printable</em> contents. It was
tested and fuzzed of course like any others MirageOS's libraries.</p>
<p>These libraries are needed for an other historical reason which is: bytes used
to store mail should use only 7 bits instead of 8 bits. This is the purpose of
the base64 and the <em>quoted-printable</em> encoding which uses only 127 possibilities
of a byte. Again, this limitation comes with SMTP protocol.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p><code>mrmime</code> is tackling the difficult task to parse and generate emails according to 50 years of usability, several RFCs and legacy rules.
So, it
still is an experimental project. We reach the first version of it because we
are currently able to parse many mails and then generate them correctly.</p>
<p>Of course, a <em>bug</em> (a malformed mail, a server which does not respect standards
or a bad use of our API) can appear easily where we did not test everything. But
we have the feeling it was the time to release it and let people to use
it.</p>
<p>The best feedback about <code>mrmime</code> and the best improvement is yours. So don't be
afraid to use it and start to hack your emails with it.</p>
