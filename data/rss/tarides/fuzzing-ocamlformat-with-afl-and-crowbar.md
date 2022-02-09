---
title: Fuzzing OCamlFormat with AFL and Crowbar
description: "AFL (and fuzzing in general) is often used\nto find bugs in low-level
  code like parsers, but it also works very well to find\nbugs in high\u2026"
url: https://tarides.com/blog/2020-08-03-fuzzing-ocamlformat-with-afl-and-crowbar
date: 2020-08-03T00:00:00-00:00
preview_image: https://tarides.com/static/e6219992a464284115d27348b49c3910/0132d/feather2.jpg
featured:
---

<p><a href="https://lcamtuf.coredump.cx/afl/">AFL</a> (and fuzzing in general) is often used
to find bugs in low-level code like parsers, but it also works very well to find
bugs in high level code, provided the right ingredients. We applied this
technique to feed random programs to OCamlFormat and found many formatting bugs.</p>
<p>OCamlFormat is a tool to format source code. To do so, it parses the source code
to an Abstract Syntax Tree (AST) and then applies formatting rules to the AST.</p>
<p>It can be tricky to correctly format the output. For example, say we want to
format <code>(a+b)*c</code>. The corresponding AST will look like <code>Apply(&quot;*&quot;, Apply (&quot;+&quot;, Var &quot;a&quot;, Var &quot;b&quot;), Var &quot;c&quot;)</code>. A naive formatter would look like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> format <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token module variable">Var</span> s <span class="token operator">-&gt;</span> s
  <span class="token operator">|</span> <span class="token module variable">Apply</span> <span class="token punctuation">(</span>op<span class="token punctuation">,</span> e1<span class="token punctuation">,</span> e2<span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
      <span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">&quot;%s %s %s&quot;</span> <span class="token punctuation">(</span>format e1<span class="token punctuation">)</span> op <span class="token punctuation">(</span>format e2<span class="token punctuation">)</span></code></pre></div>
<p>But this is not correct, as it will print <code>(a+b)*c</code> as <code>a+b*c</code>, which is a
different program. In this particular case, the common solution would be to
track the relative precedence of the expressions and to emit only necessary
parentheses.</p>
<p>OCamlFormat has similar cases. To make sure we do not change a program when
formatting it, there is an extra check at the end to parse the output and
compare the output AST with the input AST. This ensures that, in case of bugs,
OCamlFormat exits with an error rather than changing the meaning of the input
program.</p>
<p>When we consider the whole OCaml language, the rules are complex and it is
difficult to make sure that we are correctly handling all programs. There are
two main failure modes: either we put too many parentheses, and the program does
not look good, or we do not put enough, and the AST changes (and OCamlFormat
exits with an error). We need a way to make sure that the latter does not
happen. Tests work to some extent, but some edge cases happen only when a
certain combination of language features is used. Because of this combinatorial
explosion, it is impossible to get good coverage using tests only.</p>
<p>Fortunately there is a technique we can use to automatically explore the program
space: fuzzing. For a primer on using this technique on OCaml programs, one can
refer to <a href="https://tarides.com/blog/2019-09-04-an-introduction-to-fuzzing-ocaml-with-afl-crowbar-and-bun">this article</a>.</p>
<p>To make this work we need two elements: a random program generator, and a
property to check. Here, we are interested in programs that are valid (in the
sense that they parse correctly) but do not format correctly. We can use the
OCamlFormat internals to do the following:</p>
<ol>
<li>try to parse input: in case of a parse error, just reject this input as</li>
</ol>
<p>invalid.</p>
<ol>
<li>otherwise, with have a valid program. try to format it. If this happens with</li>
</ol>
<p>no error at all, reject this input as well.</p>
<ol>
<li>otherwise, it means that the AST changed, comments moved, or something</li>
</ol>
<p>similar, in a valid program. This is what we are after.</p>
<p>Generating random programs is a bit more difficult. We can feed random strings
to AFL, but even with a corpus of existing valid code it will generate many
invalid programs. We are not interested in these for this project, we would
rather start from valid programs.</p>
<p>A good way to do that is to use Crowbar to directly generate AST values. Thanks
to <a href="https://github.com/yomimono/ppx_deriving_crowbar"><code>ppx_deriving_crowbar</code></a> and <a href="https://github.com/ocaml-ppx/ppx_import"><code>ppx_import</code></a>
it is possible to generate random values for an external type like
<code>Parsetree.structure</code> (the contents of <code>.ml</code> files). Even more fortunately
<a href="https://github.com/yomimono/ocaml-test-omp/blob/d086037027537ba4e23ce027766187979c85aa3d/test/parsetree_405.ml">somebody already did the work</a>. Thanks, Mindy!</p>
<p>This approach works really well: it generates 5k-10k programs per second, which
is very good performance (AFL starts complaining below 100/s).</p>
<p>Quickly, AFL was able to find crashes related to attributes. These are &quot;labels&quot;
attached to various nodes of the AST. For example the expression <code>(x || y) [@a]</code>
(logical or between <code>x</code> and <code>y</code>, attach attribute <code>a</code> to the &quot;or&quot; expression)
would get formatted as <code>x || y [@a]</code> (attribute <code>a</code> is attached to the <code>y</code>
variable). Once again, there is a check in place in OCamlFormat to make sure
that it does not save the file in this case, but it would exit with an error.</p>
<p>After the fuzzer has run for a bit longer, it found crashes where comments would
jump around in expressions like <code>f (*a*) (*bb*) x</code>. Wait, what? We never told
the program generator how to generate comments. Inspecting the intermediate AST,
the part in the middle is actually an integer literal with value <code>&quot;(*a*) (*bb*)&quot;</code> (integer literals are represented as strings so that <a href="https://github.com/Drup/Zarith-ppx">a third party
library could add literals for arbitrary precision numbers</a> for
example).</p>
<p>AFL comes with a program called <code>afl-tmin</code> that is used to minimize a crash. It
will try to find a smaller example of a program that crashes OCamlFormat. It
works well even with Crowbar in between. For example it is able to turn <code>(new aaaaaa &amp; [0;0;0;0])[@aaaaaaaaaa]</code> into <code>(0&amp;0)[@a]</code> (neither AFL nor OCamlFormat
knows about types, so they can operate on nonsensical programs. Finding a
well-typed version of a crash is usually not very difficult, but it has to be
done manually).</p>
<p>In total, letting AFL run overnight on a single core (that is relatively short
in terms of fuzzing) caused 453 crashes. After minimization and deduplication,
this corresponded to <a href="https://github.com/ocaml-ppx/ocamlformat/issues?q=label:fuzz">about 30 unique issues</a>.</p>
<p>Most of them are related to attributes that OCamlFormat did not try to include
in the output, or where it forgot to add parentheses. Fortunately, there are
safeguards in OCamlFormat: since it checks that the formatting preserves the AST
structure, it will exit with an error instead of outputting a different program.</p>
<p>Once again, fuzzing has proved itself as a powerful technique to find actual
bugs (including high-level ones). A possible approach for a next iteration is to
try to detect more problems during formatting, such as finding cases where lines
are longer than allowed. It is also possible to extend the random program
generator so that it tries to generate comments, and let OCamlFormat check that
they are all laid out correctly in the output. We look forward to employing
fuzzing more extensively for OCamlFormat development in future.</p>
