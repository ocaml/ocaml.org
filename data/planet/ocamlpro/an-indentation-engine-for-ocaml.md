---
title: An Indentation Engine for OCaml
description: 'Since our last activity report we have released the first stable versions
  of two projects: OPAM, an installation manager for OCaml source packages, and ocp-indent,
  an indentation tool. We have already described the basics of OPAM in two precedent
  blog posts, so today we will focus on the release of ...'
url: https://ocamlpro.com/blog/2013_03_18_an_indentation_engine_for_ocaml
date: 2013-03-18T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>Since our last <a href="https://ocamlpro.com/blog/2013_02_18_overview_of_current_activities">activity report</a> we have released the first stable versions of two projects: <a href="https://opam.ocamlpro.com/">OPAM</a>, an installation manager for OCaml source packages, and <a href="https://github.com/OCamlPro/ocp-indent">ocp-indent</a>, an indentation tool.</p>
<p>We have already described the basics of OPAM in two precedent <a href="https://ocamlpro.com/blog/2013_01_17_beta_release_of_opam">blog</a> <a href="https://ocamlpro.com/blog/2013_03_15_opam_1.0.0_released">posts</a>, so today we will focus on the release of <code>ocp-indent</code>.</p>
<h3>Indentation should be consistent across editors</h3>
<p>When you work on a very large code-base, it is crucial to keep a
consistent indentation scheme. This is not only good for code review
purposes (when the indentation carries semantic properties) but also
when your code is starting to evolve and when the one who makes the
change is not the one who wrote the initial piece of code. In the latter
case, the variety of editors and local configurations usually leads to
lot of small changes carrying no semantic value at all (such as changing
tabs to spaces, adding few spaces at the beginning or end of lines, and
so on). This semantic noise considerably decreases the efficiency of
any code-review and change process and is usually very good at hiding
hard-to-track bugs in your code-base.</p>
<p>A few months ago, the solutions for OCaml to this indentation problem
were limited. For instance, you could write coding guidelines and hope
that all the developers in your project would follow them. If you wanted
to be more systematic, you could create and share a common
configuration file for some popular editors (most OCaml developers use
the emacs&rsquo; <code>tuareg-mode</code> or vim) but it is very hard to get
consistent indentation result across multiple tools. Moreover, having to
rely on a specific editor mode means that it is harder to fully
automatize the indentation process, for instance when setting-up a VCS
hook.</p>
<p>In order to overcome these pitfalls, <a href="https://www.janestreet.com/">Jane Street</a> asked us to design a new external tool with the following high-level specification:</p>
<ul>
<li>it should be easy to use inside and outside any editor;
</li>
<li>it should understand the OCaml semantics and reflect it in the indentation;
</li>
<li>it should be easy to maintain and to extend;
</li>
</ul>
<p>So we started to look at the OCaml tools&rsquo; ecosystem and we found an early prototype of Jun Furuse&rsquo;s <a href="https://bitbucket.org/camlspotter">ocaml-indent</a>.
The foundation looked great but the result on real-world code sources
was not as nice as it could be, so we decided to start from this base to
build our new tool, that we called <code>ocp-indent</code>. Today, <code>ocp-indent</code> and <code>ocaml-indent</code> do not have much code in common anymore, but the global architecture of the system remains the same.</p>
<h3>Writing an indentation engine for OCaml</h3>
<p>An indentation engine may seem like a rather simple problem: given
any line in the program, we want to compute its indentation level, based
on the code structure.</p>
<p>It turns out to be much more difficult than that, mainly because
indentation is only marginally semantic, and, worse, is a matter of
taste and &ldquo;proper layout&rdquo;. In short, it&rsquo;s not a problem that can be
expressed concisely, because one really does want lots of specific cases
handled &ldquo;nicely&rdquo;, depending on the on-screen layout &mdash; position of line
breaks &mdash; rather than the semantic structure. <code>Ocp-indent</code>
does contain lots of ad-hoc logic for such cases. To make things harder,
the OCaml syntax is known to be difficult to handle, with a few
ambiguities.</p>
<h4>Indent process</h4>
<p><code>Ocp-indent</code> processes code in a simple and efficient way:</p>
<ul>
<li>We lex the input with a <a href="https://github.com/OCamlPro/ocp-indent/blob/master/src/approx_lexer.mll">modified version of the OCaml lexer</a>,
to guarantee complete consistency with OCaml itself. The parser had to
be modified to be more robust (ocaml fails on errors, the indentation
tool should not) and to keep tokens like comments, quotations, and, in
the latest version, some ocamldoc block delimiters.
</li>
<li>Taking the token stream as input, we maintain a <a href="https://github.com/OCamlPro/ocp-indent/blob/master/src/indentBlock.ml">&ldquo;block&rdquo; stack</a>
that keeps informations like the kinds of blocks we have been through
to get to the cursor position, the column and the indentation
parameters. For instance, the &ldquo;block&rdquo; stack <code>[KBody KFfun; KLet; KBody KModule]</code> corresponds to the position of <code>X</code> in the following piece of (pseudo-) code:
</li>
</ul>
<pre><code class="language-ocaml">&hellip;
module Foo = struct
&hellip;
let f = fun a &amp;&gt; X
</code></pre>
<ul>
<li>Each token may look up the stack to find its starting counterpart (<code>in</code> will look for <code>KLet</code>, etc.), or disambiguate (<code>=</code> will look for <code>KLet</code>, stopping on opening tokens like <code>KBracket</code>,
and will be inserted as an operator if none is found). This is flexible
enough to allow for &ldquo;breaking&rdquo; the stack when incorrect grammar is
found. For example, the unclosed paren in <code>module let x = ( end</code> should not break indent after the <code>end</code>. Great care was taken in deciding what tokens should be able to remove from the stack in which conditions.
</li>
<li>The stack can also be used to find a token that we want to align on, typically bars <code>|</code> in a pattern-matching.
</li>
<li>On every line break, the stack can be used to compute the indentation of the next line.
</li>
<li>In the case of partial file indentation (typically, reindenting one
line or a single block), on lines that shouldn&rsquo;t be reindented the stack
is reversely updated to adapt to the current indentation.
</li>
</ul>
<h4>Priorities</h4>
<p>The part where some abstraction can be put into the engine is the
knowledge of the semantics, and more precisely of the scope of the
operations. It&rsquo;s also in that case that the indenter can help you write,
and not only read, your code. On that matter, <code>ocp-indent</code>
has a knowledge of the precedence of operators and constructs that is
used to know how far to unwind the stack, and what to align on. For
example, a <code>;</code> will flush function applications and most operators.</p>
<p>It is that part that gives it the most edge over <code>tuareg</code>,
and avoids semantically incorrect indents. All infix operators are
defined with a priority, a kind of indentation (indentation increment or
alignment over the above concerned expression), and an indentation
value (number of spaces to add). So for example most operators have a
priority lower than function application, but not <code>.</code>, which yields correct results for:</p>
<pre><code class="language-ocaml">let f =
somefun
record.
field
y
+ z
</code></pre>
<p>Boolean operators like <code>&amp;&amp;</code> and <code>||</code> are setup for alignment instead of indentation:</p>
<pre><code class="language-ocaml">let r = a
|| b
&amp;&amp; c
|| d
</code></pre>
<p>Additionally, some special operators are wanted with a <em>negative</em> alignment in some cases. This is also handled in a generic way by the engine. In particular, this is the case for <code>;</code> or <code>|</code>:</p>
<pre><code class="language-ocaml">type t = A
| B

let r = { f1 = x
; f2 = y
}
</code></pre>
<h4>A note on the integration in editors</h4>
<p><code>ocp-indent</code> can be used on the command-line to reindent whole files (or part of them with <code>--lines</code>),
but the most common use of an indenter is from an editor. If you are
lucky enough to be able to call OCaml code from your editor, you can use
it directly as a library, but otherwise, the preferred way is to use
the option <code>--numeric</code>: instead of reprinting the file
reindented, it will only output indentation levels, which you can then
process from your editor (for instance, using <code>indent-line-to</code> with emacs). That should be cheaper and will help preserve cursor position, etc.</p>
<p>Currently, a simple emacs binding working on either the ocaml or the
tuareg mode is provided, together with a vim mode contributed by Rapha&euml;l
Proust and David Powers.</p>
<h3>Results</h3>
<p>We&rsquo;ve built <code>ocp-indent</code> based on a growing collection of <a href="https://github.com/OCamlPro/ocp-indent/tree/master/tests/passing">unit-tests</a>. If you find an indentation bug, feel free to <a href="https://github.com/OCamlPro/ocp-indent/issues">send us</a> a code snippet that we will incorporate into our test suite.</p>
<p>Our tests clearly show that the deep understanding that <code>ocp-indent</code>
has of the OCaml syntax makes it shines on specific cases. We are still
discussing and evaluating the implementation of few corner-cases
related, see for instance the <a href="http://htmlpreview.github.com/?https://github.com/OCamlPro/ocp-indent/blob/master/tests/failing.html">currently failing tests</a>.</p>
<p>We have also run some <a href="https://htmlpreview.github.com/?https://github.com/AltGr/ocp-indent-tests/blob/master/status.html">benchmarks</a> on real code-bases and the result is quite conclusive: <code>ocp-indent</code>
is always better than tuareg! This is a very nice result as most of the
existing source files are either indented manually or are following
tuareg standards. But <code>ocp-indent</code> is also orders of magnitude faster, which means you can integrate it seamlessly into any automatic process.</p>

