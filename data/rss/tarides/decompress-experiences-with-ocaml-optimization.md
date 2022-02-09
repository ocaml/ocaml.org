---
title: 'Decompress: Experiences with OCaml optimization'
description: "In our first article we mostly discussed\nthe API design of decompress
  and did not talk too much about the issue of\noptimizing performance\u2026"
url: https://tarides.com/blog/2019-09-13-decompress-experiences-with-ocaml-optimization
date: 2019-09-13T00:00:00-00:00
preview_image: https://tarides.com/static/fff1a2a9a2dbdd9ac7efd7c97ac5aa2a/96c5f/camel_sunset.jpg
featured:
---

<p>In our <a href="https://tarides.com/blog/2019-08-26-decompress-the-new-decompress-api.html">first article</a> we mostly discussed
the API design of <code>decompress</code> and did not talk too much about the issue of
optimizing performance. In this second article, we will relate our experiences
of optimizing <code>decompress</code>.</p>
<p>As you might suspect, <code>decompress</code> needs to be optimized a lot. It was used by
several projects as an underlying layer of some formats (like Git), so it can be
a real bottleneck in those projects. Of course, we start with a footgun by using
a garbage-collected language; comparing the performance of <code>decompress</code> with a C
implementation (like <a href="https://zlib.net/">zlib</a> or <a href="https://github.com/richgel999/miniz">miniz</a>) is obviously not very fair.</p>
<p>However, using something like <code>decompress</code> instead of C implementations can be
very interesting for many purposes, especially when thinking about <em>unikernels</em>.
As we said in the previous article, we can take the advantage of the <em>runtime</em>
and the type-system to provide something <em>safer</em> (of course, it's not really
true since zlib has received several security audits).</p>
<p>The main idea in this article is not to give snippets to copy/paste into your
codebase but to explain some behaviors of the compiler / runtime and hopefully
give you some ideas about how to optimize your own code. We'll discuss the
following optimizations:</p>
<ul>
<li>specialization</li>
<li>inlining</li>
<li>untagged integers</li>
<li>exceptions</li>
<li>unrolling</li>
<li>hot-loop</li>
<li>caml_modify</li>
<li>representation sizes</li>
</ul>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#cautionary-advice" aria-label="cautionary advice permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Cautionary advice</h3>
<p>Before we begin discussing optimization, keep this rule in mind:</p>
<blockquote>
<p>Only perform optimization at the <strong>end</strong> of the development process.</p>
</blockquote>
<p>An optimization pass
can change your code significantly, so you need to keep a state of your project
that can be trusted. This state will provide a comparison point for both
benchmarks and behaviors. In other words, your stable implementation will be the
oracle for your benchmarks. If you start with nothing, you'll achieve
arbitrarily-good performance at the cost of arbitrary behavior!</p>
<p>We optimized <code>decompress</code> because we are using it in bigger projects for a long
time (2 years). So we have an oracle (even if <code>zlib</code> can act as an oracle in
this special case).</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#specialization" aria-label="specialization permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Specialization</h2>
<p>One of the biggest specializations in <code>decompress</code> is regarding the <code>min</code>
function. If you don't know, in OCaml <code>min</code> is polymorphic; you can compare
anything. So you probably have some concerns about how <code>min</code> is implemented?</p>
<p>You are right to be concerned: if you examine the details, <code>min</code> calls the C
function <code>do_compare_val</code>, which traverses your structure and does a comparison
according the run-time representation of your structure. Of course, for integers, it
should be only a <code>cmpq</code> assembly instruction. However, some simple code like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> x <span class="token operator">=</span> min <span class="token number">0</span> <span class="token number">1</span></code></pre></div>
<p>will produce this CMM and assembly code:</p>
<div class="gatsby-highlight" data-language="cmm"><pre class="language-cmm"><code class="language-cmm">(let x/1002 (app{main.ml:1,8-15} &quot;camlStdlib__min_1028&quot; 1 3 val)
   ...)</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L101:
        movq    $3, %rbx
        movq    $1, %rax
        call    camlStdlib__min_1028@PLT</code></pre></div>
<p>Note that <em><a href="https://en.wikipedia.org/wiki/Lambda_calculus#Beta_reduction">beta-reduction</a></em>, <em><a href="https://en.wikipedia.org/wiki/Inline_expansion">inlining</a></em> and
specialization were not done in this code. OCaml does not optimize your code
very much &ndash; the good point is predictability of the produced assembly output.</p>
<p>If you help the compiler a little bit with:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">external</span> <span class="token punctuation">(</span> <span class="token operator">&lt;=</span> <span class="token punctuation">)</span> <span class="token punctuation">:</span> int <span class="token operator">-&gt;</span> int <span class="token operator">-&gt;</span> bool <span class="token operator">=</span> <span class="token string">&quot;%lessequal&quot;</span>
<span class="token keyword">let</span> min a b <span class="token operator">=</span> <span class="token keyword">if</span> a <span class="token operator">&lt;=</span> b <span class="token keyword">then</span> a <span class="token keyword">else</span> b <span class="token punctuation">[</span><span class="token operator">@@</span>inline<span class="token punctuation">]</span>

<span class="token keyword">let</span> x <span class="token operator">=</span> min <span class="token number">0</span> <span class="token number">1</span></code></pre></div>
<p>We have:</p>
<div class="gatsby-highlight" data-language="cmm"><pre class="language-cmm"><code class="language-cmm">(function{main.ml:2,8-43} camlMain__min_1003 (a/1004: val b/1005: val)
 (if (&lt;= a/1004 b/1005) a/1004 b/1005))

(function camlMain__entry ()
 (let x/1006 1 (store val(root-init) (+a &quot;camlMain&quot; 8) 1)) 1a)</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L101:
        cmpq    %rbx, %rax
        jg      .L100
        ret</code></pre></div>
<p>So we have all optimizations, in this produced code, <code>x</code> was evaluated as <code>0</code>
(<code>let x/... (store ... 1)</code>) (beta-reduction and inlining) and <code>min</code> was
specialized to accept only integers &ndash; so we are able to emit <code>cmpq</code>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#results" aria-label="results permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Results</h3>
<p>With specialization, we won 10 Mb/s on decompression, where <code>min</code> is used
in several places. We completely avoid an indirection and a call to the slow
<code>do_compare_val</code> function.</p>
<p>This kind of specialization is already done by <a href="https://caml.inria.fr/pub/docs/manual-ocaml/flambda.html"><code>flambda</code></a>, however, we
currently use OCaml 4.07.1. So we decided to this kind of optimization by
ourselves.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#inlining" aria-label="inlining permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Inlining</h2>
<p>In the first example, we showed code with the <code>[@@inline]</code> keyword which is
useful to force the compiler to inline a little function. We will go outside the
OCaml world and study C code (gcc 5.4.0) to really understand
<em>inlining</em>.</p>
<p>In fact, inlining is not necessarily the best optimization. Consider the
following (nonsensical) C program:</p>
<div class="gatsby-highlight" data-language="c"><pre class="language-c"><code class="language-c"><span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;stdio.h&gt;</span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;string.h&gt;</span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;unistd.h&gt;</span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;time.h&gt;</span></span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">include</span> <span class="token string">&lt;stdlib.h&gt;</span></span>

<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">ifdef</span> <span class="token expression">HIDE_ALIGNEMENT</span></span>
<span class="token keyword">__attribute__</span><span class="token punctuation">(</span><span class="token punctuation">(</span>noinline<span class="token punctuation">,</span> noclone<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token macro property"><span class="token directive-hash">#</span><span class="token directive keyword">endif</span></span>
<span class="token keyword">void</span> <span class="token operator">*</span>
<span class="token function">hide</span><span class="token punctuation">(</span><span class="token keyword">void</span> <span class="token operator">*</span> p<span class="token punctuation">)</span> <span class="token punctuation">{</span> <span class="token keyword">return</span> p<span class="token punctuation">;</span> <span class="token punctuation">}</span>

<span class="token keyword">int</span> <span class="token function">main</span><span class="token punctuation">(</span><span class="token keyword">int</span> ac<span class="token punctuation">,</span> <span class="token keyword">const</span> <span class="token keyword">char</span> <span class="token operator">*</span>av<span class="token punctuation">[</span><span class="token punctuation">]</span><span class="token punctuation">)</span>
<span class="token punctuation">{</span>
  <span class="token keyword">char</span> <span class="token operator">*</span>s <span class="token operator">=</span> <span class="token function">calloc</span><span class="token punctuation">(</span><span class="token number">1</span> <span class="token operator">&lt;&lt;</span> <span class="token number">20</span><span class="token punctuation">,</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
  s <span class="token operator">=</span> <span class="token function">hide</span><span class="token punctuation">(</span>s<span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token function">memset</span><span class="token punctuation">(</span>s<span class="token punctuation">,</span> <span class="token string">'B'</span><span class="token punctuation">,</span> <span class="token number">100000</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token class-name">clock_t</span> start <span class="token operator">=</span> <span class="token function">clock</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token keyword">for</span> <span class="token punctuation">(</span><span class="token keyword">int</span> i <span class="token operator">=</span> <span class="token number">0</span><span class="token punctuation">;</span> i <span class="token operator">&lt;</span> <span class="token number">1280000</span><span class="token punctuation">;</span> <span class="token operator">++</span>i<span class="token punctuation">)</span>
    s<span class="token punctuation">[</span><span class="token function">strlen</span><span class="token punctuation">(</span>s<span class="token punctuation">)</span><span class="token punctuation">]</span> <span class="token operator">=</span> <span class="token string">'A'</span><span class="token punctuation">;</span>

  <span class="token class-name">clock_t</span> end <span class="token operator">=</span> <span class="token function">clock</span><span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token function">printf</span><span class="token punctuation">(</span><span class="token string">&quot;%lld\n&quot;</span><span class="token punctuation">,</span> <span class="token punctuation">(</span><span class="token keyword">long</span> <span class="token keyword">long</span><span class="token punctuation">)</span> <span class="token punctuation">(</span>end<span class="token operator">-</span>start<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span>

  <span class="token keyword">return</span> <span class="token number">0</span><span class="token punctuation">;</span>
<span class="token punctuation">}</span></code></pre></div>
<p>We will compile this code with <code>-O2</code> (the second level of optimization in C),
once with <code>-DHIDE_ALIGNEMENT</code> and once without. The assembly emitted differs:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L3:
	movq	%rbp, %rdi
	call	strlen
	subl	$1, %ebx
	movb	$65, 0(%rbp,%rax)
	jne	.L3</code></pre></div>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L3:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L3</code></pre></div>
<p>In the first output (with <code>-DHIDE_ALIGNEMENT</code>), the optimization pass
decides to disable inlining of <code>strlen</code>; in the second output (without
<code>-DHIDEAlIGNEMENT</code>), it decides to inline <code>strlen</code> (and do some other clever
optimizations). The reason behind this complex behavior from the compiler is
clearly described <a href="https://stackoverflow.com/a/55589634">here</a>.</p>
<p>But what we want to say is that inlining is <strong>not</strong> an automatic optimization;
it might act as a <em>pessimization</em>. This is the goal of <code>flambda</code>: do the right
optimization under the right context. If you are really curious about what <code>gcc</code>
does and why, even if it's very interesting, the reverse engineering of the
optimization process and which information is relevant about the choice to
optimize or not is deep, long and surely too complicated.</p>
<p>A non-spontaneous optimization is to annotate some parts of your code with
<code>[@@inline never]</code> &ndash; so, explicitly say to the compiler to not inline the
function. This constraint is to help the compiler to generate a smaller code
which will have more chance to fit under the processor cache.</p>
<p>For all of these reasons, <code>[@@inline]</code> should be used sparingly and an oracle to
compare performances if you inline or not this or this function is necessary to
avoid a <em>pessimization</em>.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#in-decompress" aria-label="in decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In <code>decompress</code></h3>
<p>Inlining in <code>decompress</code> was done on small functions which need to allocate
to return a value. If we inline them, we can take the opportunity to store
returned value in registers (of course, it depends how many registers are free).</p>
<p>As we said, the goal of the inflator is to translate a bit sequence to a byte.
The largest bit sequence possible according to RFC 1951 has length 15. So, when
we process an inputs flow, we eat it 15 bits per 15 bits. For each packet, we
want to recognize an existing associated bit sequence and then, binded values
will be the real length of the bit sequence and the byte:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> find <span class="token punctuation">:</span> bits<span class="token punctuation">:</span>int <span class="token operator">-&gt;</span> <span class="token punctuation">{</span> len<span class="token punctuation">:</span> int<span class="token punctuation">;</span> byte<span class="token punctuation">:</span> int<span class="token punctuation">;</span> <span class="token punctuation">}</span></code></pre></div>
<p>So for each call to this function, we need to allocate a record/tuple. It's
why we choose to inline this function. <code>min</code> was inlined too and some other
small functions. But as we said, the situation is complex; where we think that
<em>inlining</em> can help us, it's not systematically true.</p>
<p>NOTE: we can recognize bits sequence with, at most, 15 bits because a
<a href="https://zlib.net/feldspar.html">Huffman coding</a> is <a href="https://en.wikipedia.org/wiki/Prefix_code">prefix-free</a>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#untagged-integers" aria-label="untagged integers permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Untagged integers</h2>
<p>When reading assembly, the integer <code>0</code> is written as <code>$1</code>.
It's because of the <a href="https://blog.janestreet.com/what-is-gained-and-lost-with-63-bit-integers/">GC bit</a> needed to differentiate a pointer
and an unboxed integer. This is why, in OCaml, we talk about a 31-bits integer
or a 63-bits integer (depending on your architecture).</p>
<p>We will not try to start a debate about this arbitrary choice on the
representation of an integer in OCaml. However, we can talk about some
operations which can have an impact on performances.</p>
<p>The biggest example is about the <code>mod</code> operation. Between OCaml and C, <code>%</code> or
<code>mod</code> should be the same:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> f a b <span class="token operator">=</span> a <span class="token operator">mod</span> b</code></pre></div>
<p>The output assembly is:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L105:
        movq    %rdi, %rcx
        sarq    $1, %rcx     // b &gt;&gt; 1
        movq    (%rsp), %rax
        sarq    $1, %rax     // a &gt;&gt; 1
        testq   %rcx, %rcx   // b != 0
        je      .L107
        cqto
        idivq   %rcx         // a % b
        jmp     .L106
.L107:
        movq    caml_backtrace_pos@GOTPCREL(%rip), %rax
        xorq    %rbx, %rbx
        movl    %ebx, (%rax)
        movq    caml_exn_Division_by_zero@GOTPCREL(%rip), %rax
        call    caml_raise_exn@PLT
.L106:
        salq    $1, %rdx     // x &lt;&lt; 1
        incq    %rdx         // x + 1
        movq    %rbx, %rax</code></pre></div>
<p>where idiomatically the same C code produce:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L2:
        movl    -12(%rbp), %eax
        cltd
        idivl   -8(%rbp)
        movl    %edx, -4(%rbp)</code></pre></div>
<p>Of course, we can notice firstly the exception in OCaml (<code>Divided_by_zero</code>) -
which is pretty good because it protects us against an interrupt from assembly
(and keep the trace). Then, we need to <em>untag</em> <code>a</code> and <code>b</code> with <code>sarq</code> assembly
operation. We do, as the C code, <code>idiv</code> and then we must <em>retag</em> returned value
<code>x</code> with <code>salq</code> and <code>incq</code>.</p>
<p>So in some parts, it should be more interesting to use <code>Nativeint</code>. However, by
default, a <code>nativeint</code> is boxed. <em>boxed</em> means that the value is allocated in
the OCaml heap alongside a header.</p>
<p>Of course, this is not what we want so, if our <code>nativeint ref</code> (to have
side-effect, like <code>x</code>) stay inside a function and then, you return the real
value with the deref <code>!</code> operator, OCaml, by a good planet alignment, can
directly use registers and real integers. So it should be possible to avoid
these needed conversions.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#readability-versus-performance" aria-label="readability versus performance permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Readability versus performance</h3>
<p>We use this optimization only in few parts of the code. In fact, switch
between <code>int</code> and <code>nativeint</code> is little bit noisy:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">hold <span class="token operator">:=</span> <span class="token module variable">Nativeint</span><span class="token punctuation">.</span>logor <span class="token operator">!</span>hold <span class="token module variable">Nativeint</span><span class="token punctuation">.</span><span class="token punctuation">(</span>shift_left <span class="token punctuation">(</span>of_int <span class="token punctuation">(</span>unsafe_get_uint8 d<span class="token punctuation">.</span>i <span class="token operator">!</span>i_pos<span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token operator">!</span>bits<span class="token punctuation">)</span></code></pre></div>
<p>In the end, we only gained 0.5Mb/s of inflation rate, so it's not worthwhile
to do systematically this optimization. Especially that the gain is not very
big. But this case show a more troubling problem: loss of readability.</p>
<p>In fact, we can optimize more and more a code (OCaml or C) but we lost, step by
step, readability. You should be afraid by the implementation of <code>strlen</code> for
example. In the end, the loss of readability makes it harder to understand the purpose
of the code, leading to errors whenever some other person (or you in 10 years time)
tries to make a change.</p>
<p>And we think that this kind of optimization is not the way of OCaml in general
where we prefer to produce an understandable and abstracted code than a cryptic
and super fast one.</p>
<p>Again, <code>flambda</code> wants to fix this problem and let the compiler to do this
optimization. The goal is to be able to write a fast code without any pain.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#exceptions" aria-label="exceptions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Exceptions</h2>
<p>If you remember our <a href="https://tarides.com/blog/2019-02-08-release-of-base64.html">article</a> about the release of <code>base64</code>, we talked a
bit about exceptions and used them as a <em>jump</em>. In fact, it's pretty
common for an OCaml developer to break the control-flow with an exception.
Behind this common design/optimization, it's about calling convention.</p>
<p>Indeed, choose the <em>jump</em> word to describe OCaml exception is not the best where
we don't use <code>setjmp</code>/<code>longjmp</code>.</p>
<p>In the details, when you start a code with a <code>try .. with</code>, OCaml saves a <em>trap</em>
in the stack which contains information about the <code>with</code>, the catcher. Then,
when you <code>raise</code>, you <em>jump</em> directly to this trap and can just discard several
stack frames (and, by this way, you did not check each return codes).</p>
<p>In several places and mostly in the <em>hot-loop</em>, we use this <em>pattern</em>. However,
it completely breaks the control flow and can be error-prone.</p>
<p>To limit errors and because this pattern is usual, we prefer to use a <em>local</em>
exception which will be used only inside the function. By this way, we enforce
the fact that exception should not (and can not) be caught by something else
than inside the function.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml">    <span class="token keyword">let</span> <span class="token keyword">exception</span> <span class="token module variable">Break</span> <span class="token keyword">in</span>

    <span class="token punctuation">(</span> <span class="token keyword">try</span> <span class="token keyword">while</span> <span class="token operator">!</span>max <span class="token operator">&gt;=</span> <span class="token number">1</span> <span class="token keyword">do</span>
          <span class="token keyword">if</span> bl_count<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token operator">!</span>max<span class="token punctuation">)</span> <span class="token operator">!=</span> <span class="token number">0</span> <span class="token keyword">then</span> raise_notrace <span class="token module variable">Break</span>
        <span class="token punctuation">;</span> decr max <span class="token keyword">done</span> <span class="token keyword">with</span> <span class="token module variable">Break</span> <span class="token operator">-&gt;</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token punctuation">)</span> <span class="token punctuation">;</span></code></pre></div>
<p>This code above produce this assembly code:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">.L105:
        pushq   %r14
        movq    %rsp, %r14
.L103:
        cmpq    $3, %rdi              // while !max &gt;= 1
        jl      .L102
        movq    -4(%rbx,%rdi,4), %rsi // bl_count,(!max)
        cmpq    $1, %rsi              // bl_count.(!max) != 0
        je      .L104
        movq    %r14, %rsp
        popq    %r14
        ret                           // raise_notrace Break
.L104:
        addq    $-2, %rdi             // decr max
        movq    %rdi, 16(%rsp)
        jmp     .L103</code></pre></div>
<p>Where the <code>ret</code> is the <code>raise_notrace Break</code>. A <code>raise_notrace</code> is needed,
otherwise, you will see:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">        movq    caml_backtrace_pos@GOTPCREL(%rip), %rbx
        xorq    %rdi, %rdi
        movl    %edi, (%rbx)
        call    caml_raise_exn@PLT</code></pre></div>
<p>Instead the <code>ret</code> assembly code. Indeed, in this case, we need to store where we
raised the exception.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#unrolling" aria-label="unrolling permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Unrolling</h2>
<p>When we showed the optimization done by <code>gcc</code> when the string is aligned, <code>gcc</code>
did another optimization. Instead of setting the string byte per byte, it decides to
update it 4 bytes per 4 bytes.</p>
<p>This kind of this optimization is an <em>unroll</em> and we did it in <code>decompress</code>.
Indeed, when we reach the <em>copy</em> <em>opcode</em> emitted by the <a href="https://en.wikipedia.org/wiki/LZ77_and_LZ78">lz77</a>
compressor, we want to <em>blit</em> <em>length</em> byte(s) from a source to the outputs
flow. It can appear that this <code>memcpy</code> can be optimized to copy 4 bytes per 4
bytes &ndash; 4 bytes is generally a good idea where it's the size of an <code>int32</code> and
should fit under any architectures.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> blit src src_off dst dst_off <span class="token operator">=</span>
  <span class="token keyword">if</span> dst_off &ndash; src_off <span class="token operator">&lt;</span> <span class="token number">4</span>
  <span class="token keyword">then</span> slow_blit src src_off dst dst_off
  <span class="token keyword">else</span>
    <span class="token keyword">let</span> len0 <span class="token operator">=</span> len <span class="token operator">land</span> <span class="token number">3</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> len1 <span class="token operator">=</span> len <span class="token operator">asr</span> <span class="token number">2</span> <span class="token keyword">in</span>

    <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> len1 &ndash; <span class="token number">1</span>
    <span class="token keyword">do</span>
      <span class="token keyword">let</span> i <span class="token operator">=</span> i <span class="token operator">*</span> <span class="token number">4</span> <span class="token keyword">in</span>
      <span class="token keyword">let</span> v <span class="token operator">=</span> unsafe_get_uint32 src <span class="token punctuation">(</span>src_off <span class="token operator">+</span> i<span class="token punctuation">)</span> <span class="token keyword">in</span>
      unsafe_set_uint32 dst <span class="token punctuation">(</span>dst_off <span class="token operator">+</span> i<span class="token punctuation">)</span> v <span class="token punctuation">;</span>
    <span class="token keyword">done</span> <span class="token punctuation">;</span>

    <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> len0 &ndash; <span class="token number">1</span>
    <span class="token keyword">do</span>
      <span class="token keyword">let</span> i <span class="token operator">=</span> len1 <span class="token operator">*</span> <span class="token number">4</span> <span class="token operator">+</span> i <span class="token keyword">in</span>
      <span class="token keyword">let</span> v <span class="token operator">=</span> unsafe_get_uint8 src <span class="token punctuation">(</span>src_off <span class="token operator">+</span> i<span class="token punctuation">)</span> <span class="token keyword">in</span>
      unsafe_set_uint8 dst <span class="token punctuation">(</span>dst_off <span class="token operator">+</span> i<span class="token punctuation">)</span> v <span class="token punctuation">;</span>
    <span class="token keyword">done</span></code></pre></div>
<p>In this code, at the beginning, we copy 4 bytes per 4 bytes and if <code>len</code> is not
a multiple of 4, we start the <em>trailing</em> loop to copy byte per byte then. In
this context, OCaml can <em>unbox</em> <code>int32</code> and use registers. So this function does
not deal with the heap, and by this way, with the garbage collector.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#results-1" aria-label="results 1 permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Results</h3>
<p>In the end, we gained an extra 10Mb/s of inflation rate. The <code>blit</code> function is the
most important function when it comes to inflating the window to an output flow.
As the specialization on the <code>min</code> function, this is one of the biggest optimization on
<code>decompress</code>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#hot-loop" aria-label="hot loop permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a><em>hot-loop</em></h2>
<p>A common design about decompression (but we can find it on hash implementation
too), is the <em>hot-loop</em>. An <em>hot-loop</em> is mainly a loop on the most common
operation in your process. In the context of <code>decompress</code>, the <em>hot-loop</em> is
about a repeated translation from bits-sequence to byte(s) from the inputs flow
to the outputs flow and the window.</p>
<p>The main idea behind the <em>hot-loop</em> is to initialize all information needed for
the translation before to start the <em>hot-loop</em>. Then, it's mostly an imperative
loop with a <em>pattern-matching</em> which corresponds to the current state of the
global computation.</p>
<p>In OCaml, we can take this opportunity to use <code>int ref</code> (or <code>nativeint ref</code>), and then, they will be translated into registers (which is the fastest
area to store something).</p>
<p>Another deal inside the <em>hot-loop</em> is to avoid any allocation &ndash; and it's why we
talk about <code>int</code> or <code>nativeint</code>. Indeed, a more complex structure like an option
will add a blocker to the garbage collection (a call to <code>caml_call_gc</code>).</p>
<p>Of course, this kind of design is completely wrong if we think in a functional
way. However, this is the (biggest?) advantage of OCaml: hide this ugly/hacky
part inside a functional interface.</p>
<p>In the API, we talked about a state which represents the <em>inflation</em> (or the
<em>deflation</em>). At the beginning, the goal is to store into some references
essentials values like the position into the inputs flow, bits available,
dictionary, etc. Then, we launch the <em>hot-loop</em> and only at the end, we update the state.</p>
<p>So we keep the optimal design about <em>inflation</em> and the functional way outside
the <em>hot-loop</em>.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#caml_modify" aria-label="caml_modify permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>caml_modify</h2>
<p>One issue that we need to consider is the call to <code>caml_modify</code>. In
fact, for a complex data-structure like an <code>int array</code> or a <code>int option</code> (so,
other than an integer or a boolean or an <em>immediate</em> value), values can move to the
major heap.</p>
<p>In this context, <code>caml_modify</code> is used to assign a new value into your mutable
block. It is a bit slower than a simple assignment but needed to
ensure pointer correspondence between minor heap and major heap.</p>
<p>With this OCaml code for example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span> <span class="token keyword">mutable</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>

<span class="token keyword">let</span> f t v <span class="token operator">=</span> t<span class="token punctuation">.</span>v <span class="token operator">&lt;-</span> v</code></pre></div>
<p>We produce this assembly:</p>
<div class="gatsby-highlight" data-language="asm"><pre class="language-asm"><code class="language-asm">camlExample__f_1004:
        subq    $8, %rsp
        movq    %rax, %rdi
        movq    %rbx, %rsi
        call    caml_modify@PLT
        movq    $1, %rax
        addq    $8, %rsp
        ret</code></pre></div>
<p>Where we see the call to <code>caml_modify</code> which will be take care about the
assignment of <code>v</code> into <code>t.v</code>. This call is needed mostly because the type of <code>t.v</code> is not an <em>immediate</em> value like an integer. So, for many values in the
<em>inflator</em> and the <em>deflator</em>, we mostly use integers.</p>
<p>Of course, at some points, we use <code>int array</code> and set them at some specific
points of the <em>inflator</em> &ndash; where we inflated the dictionary. However, the impact
of <code>caml_modify</code> is not very clear where it is commonly pretty fast.</p>
<p>Sometimes, however, it can be a real bottleneck in your computation and
this depends on how long your values live in the heap. A little program (which is
not very reproducible) can show that:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> t <span class="token operator">=</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>init <span class="token punctuation">(</span>int_of_string <span class="token module variable">Sys</span><span class="token punctuation">.</span>argv<span class="token punctuation">.</span><span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token module variable">Random</span><span class="token punctuation">.</span>int <span class="token number">256</span><span class="token punctuation">)</span>

<span class="token keyword">let</span> pr fmt <span class="token operator">=</span> <span class="token module variable">Format</span><span class="token punctuation">.</span>printf fmt

<span class="token keyword">type</span> t0 <span class="token operator">=</span> <span class="token punctuation">{</span> <span class="token keyword">mutable</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>
<span class="token keyword">type</span> t1 <span class="token operator">=</span> <span class="token punctuation">{</span> v <span class="token punctuation">:</span> int option <span class="token punctuation">}</span>

<span class="token keyword">let</span> f0 <span class="token punctuation">(</span>t0 <span class="token punctuation">:</span> t0<span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>length t &ndash; <span class="token number">1</span>
  <span class="token keyword">do</span> <span class="token keyword">let</span> v <span class="token operator">=</span> <span class="token keyword">match</span> t0<span class="token punctuation">.</span>v<span class="token punctuation">,</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span> <span class="token keyword">with</span>
             <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">_</span> <span class="token keyword">as</span> v<span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> v
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token number">5</span> <span class="token operator">-&gt;</span> <span class="token module variable">Some</span> i
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token module variable">None</span> <span class="token keyword">in</span>
     t0<span class="token punctuation">.</span>v <span class="token operator">&lt;-</span> v
  <span class="token keyword">done</span><span class="token punctuation">;</span> t0

<span class="token keyword">let</span> f1 <span class="token punctuation">(</span>t1 <span class="token punctuation">:</span> t1<span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> t1 <span class="token operator">=</span> ref t1 <span class="token keyword">in</span>
  <span class="token keyword">for</span> i <span class="token operator">=</span> <span class="token number">0</span> <span class="token keyword">to</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>length t &ndash; <span class="token number">1</span>
  <span class="token keyword">do</span> <span class="token keyword">let</span> v <span class="token operator">=</span> <span class="token keyword">match</span> <span class="token operator">!</span>t1<span class="token punctuation">.</span>v<span class="token punctuation">,</span> t<span class="token punctuation">.</span><span class="token punctuation">(</span>i<span class="token punctuation">)</span> <span class="token keyword">with</span>
             <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">_</span> <span class="token keyword">as</span> v<span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> v
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token number">5</span> <span class="token operator">-&gt;</span> <span class="token module variable">Some</span> i
             <span class="token operator">|</span> <span class="token module variable">None</span><span class="token punctuation">,</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token module variable">None</span> <span class="token keyword">in</span>
     t1 <span class="token operator">:=</span> <span class="token punctuation">{</span> v <span class="token punctuation">}</span>
  <span class="token keyword">done</span><span class="token punctuation">;</span> <span class="token operator">!</span>t1

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token keyword">let</span> t0 <span class="token punctuation">:</span> t0 <span class="token operator">=</span> <span class="token punctuation">{</span> v<span class="token operator">=</span> <span class="token module variable">None</span> <span class="token punctuation">}</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> t1 <span class="token punctuation">:</span> t1 <span class="token operator">=</span> <span class="token punctuation">{</span> v<span class="token operator">=</span> <span class="token module variable">None</span> <span class="token punctuation">}</span> <span class="token keyword">in</span>
  <span class="token keyword">let</span> time0 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  ignore <span class="token punctuation">(</span>f0 t0<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token keyword">let</span> time1 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>
  ignore <span class="token punctuation">(</span>f1 t1<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  <span class="token keyword">let</span> time2 <span class="token operator">=</span> <span class="token module variable">Unix</span><span class="token punctuation">.</span>gettimeofday <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token keyword">in</span>

  pr <span class="token string">&quot;f0: %f ns\n%!&quot;</span> <span class="token punctuation">(</span>time1 <span class="token operator">-.</span> time0<span class="token punctuation">)</span> <span class="token punctuation">;</span>
  pr <span class="token string">&quot;f1: %f ns\n%!&quot;</span> <span class="token punctuation">(</span>time2 <span class="token operator">-.</span> time1<span class="token punctuation">)</span> <span class="token punctuation">;</span>

  <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>In our bare-metal server, if you launch the program with 1000, the <code>f0</code>
computation, even if it has <code>caml_modify</code> will be the fastest. However, if you
launch the program with 1000000000, <code>f1</code> will be the fastest.</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ ./a.out 1000
f0: 0.000006 ns
f1: 0.000015 ns
$ ./a.out 1000000000
f0: 7.931782 ns
f1: 5.719370 ns</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#about-decompress" aria-label="about decompress permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>About <code>decompress</code></h3>
<p>At the beginning, our choice was made to have, as @dbuenzli does, mutable
structure to represent state. Then, @yallop did a big patch to update it to an
immutable state and we won 9Mb/s on <em>inflation</em>.</p>
<p>However, the new version is more focused on the <em>hot-loop</em> and it is 3
times faster than before.</p>
<p>As we said, the deal about <code>caml_modify</code> is not clear and depends a lot about
how long your data lives in the heap and how many times you want to update it.
If we localize <code>caml_modify</code> only on few places, it should be fine. But it still
is one of the most complex question about (macro?) optimization.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#smaller-representation" aria-label="smaller representation permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Smaller representation</h2>
<p>We've discussed the impact that integer types can have on the use of immediate
values. More generally, the choice of type to represent your values can have
significant performance implications.</p>
<p>For example, a dictionary which associates a bits-sequence (an integer) to the
length of it <strong>AND</strong> the byte, it can be represented by a: <code>(int * int) array</code>, or
more idiomatically <code>{ len: int; byte: int; } array</code> (which is structurally the
same).</p>
<p>However, that means an allocation for each bytes to represent every bytes.
Extraction of it will need an allocation if <code>find : bits:int -&gt; { len: int; byte: int; }</code> is not inlined as we said. And about memory, the array can be
really <em>heavy</em> in your heap.</p>
<p>At this point, we used <code>spacetime</code> to show how many blocks we allocated for a
common <em>inflation</em> and we saw that we allocate a lot. The choice was made to use
a smaller representation. Where <code>len</code> can not be upper than 15 according RFC 1951
and when byte can represent only 256 possibilities (and should fit under one
byte), we can decide to merge them into one integer (which can have, at least,
31 bits).</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> static_literal_tree <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">|</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">12</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">140</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">(</span><span class="token number">8</span><span class="token punctuation">,</span> <span class="token number">76</span><span class="token punctuation">)</span><span class="token punctuation">;</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span> <span class="token operator">|</span><span class="token punctuation">]</span>
<span class="token keyword">let</span> static_literal_tree <span class="token operator">=</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>map <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span>len<span class="token punctuation">,</span> byte<span class="token punctuation">)</span> <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>len <span class="token operator">lsl</span> <span class="token number">8</span><span class="token punctuation">)</span> <span class="token operator">lor</span> byte<span class="token punctuation">)</span> static_literal_tree</code></pre></div>
<p>In the code above, we just translate the static dictionary (for a STATIC DEFLATE
block) to a smaller representation where <code>len</code> will be the left part of the
integer and <code>byte</code> will be the right part. Of course, it's depends on what you
want to store.</p>
<p>Another point is readability. <a href="https://github.com/mirage/ocaml-cstruct#ppx"><code>cstruct-ppx</code></a> and
<a href="https://bitbucket.org/thanatonauts/bitstring/src"><code>bitstring</code></a> can help you but <code>decompress</code>
wants to depend only on OCaml.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>We conclude with some closing advice about optimising your OCaml programs:</p>
<ul>
<li>
<p><strong>Optimization is specific to your task</strong>. The points highlighted in this
article may not fit your particular problem, but they are intended to give you
ideas. Our optimizations were only possible because we completely assimilated
the ideas of <code>zlib</code> and had a clear vision of what we really needed to
optimize (like <code>blit</code>).
<br/><br/>
As your first project, this article can not help you a lot to optimize your
code where it's mostly about <em>micro</em>-optimization under a specific context
(<em>hot-loop</em>). But it helps you to understand what is really done by the
compiler &ndash; which is still really interesting.</p>
</li>
<li>
<p><strong>Optimise only with respect to an oracle</strong>. All optimizations were done
because we did a comparison point between the old implementation of
<code>decompress</code> and <code>zlib</code> as oracles. Optimizations can change the semantics of your
code and you should systematically take care at any step about expected
behaviors. So it's a long run.</p>
</li>
<li>
<p><strong>Use the predictability of the OCaml compiler to your advantage</strong>. For sure,
the compiler does not optimize a lot your code &ndash; but it sill produce realistic
programs if we think about performance. For many cases, <strong>you don't need</strong> to
optimize your OCaml code. And the good point is about expected behavior.
<br/><br/>
The mind-link between the OCaml and the assembly exists (much more than the C
and the assembly sometimes where we let the C compiler to optimize the code).
The cool fact is to keep a mental-model about what is going on on your code
easily without to be afraid by what the compiler can produce. And, in some
critical parts like <a href="https://github.com/mirage/eqaf">eqaf</a>, it's really needed.</p>
</li>
</ul>
<p>We have not discussed benchmarking, which is another hard issue: who should you
compare with? where? how? For example, a global comparison between <code>zlib</code> and
<code>decompress</code> is not very relevant in many ways &ndash; especially because of the
garbage collector. This could be another article!</p>
<p>Finally, all of these optimizations should be done by <code>flambda</code>; the difference
between compiling <code>decompress</code> with or without <code>flambda</code> is not very big. We
optimized <code>decompress</code> by hand mostly to keep compatibility with OCaml (since
<code>flambda</code> needs another switch) and, in this way, to gain an understanding of
<code>flambda</code> optimizations so that we can use it effectively!</p>
