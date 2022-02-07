---
title: Release of OCamlFormat 0.9
description: "We are pleased to announce the release of OCamlFormat (available on
  opam).\nThere have been numerous changes since the last release,\nso here\u2026"
url: https://tarides.com/blog/2019-03-29-release-of-ocamlformat-0-9
date: 2019-03-29T00:00:00-00:00
preview_image: https://tarides.com/static/b0a6eda566f64c66aa1761737cf3ea4a/0132d/ceiling-arches.jpg
featured:
---

<p>We are pleased to announce the release of OCamlFormat (available on opam).
There have been numerous changes since the last release,
so here is a comprehensive list of the new features and breaking changes to help the transition from OCamlFormat 0.8.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#additional-dependencies" aria-label="additional dependencies permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Additional dependencies</h1>
<p>OCamlFormat now requires:</p>
<ul>
<li>ocaml &gt;= 4.06 (up from 4.04.1)</li>
<li>dune &gt;= 1.1.1</li>
<li>octavius &gt;= 1.2.0</li>
<li>uutf</li>
</ul>
<p>OCamlFormat_Reason now requires:</p>
<ul>
<li>ocaml &gt;= 4.06</li>
<li>dune &gt;= 1.1.1</li>
<li>ocaml-migrate-parsetree &gt;= 1.0.10 (up from 1.0.6)</li>
<li>octavius &gt;= 1.2.0</li>
<li>uutf</li>
<li>reason &gt;= 3.2.0 (up from 1.13.4)</li>
</ul>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#new-preset-profiles" aria-label="new preset profiles permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>New preset profiles</h1>
<p>The <code>ocamlformat</code> profile aims to take advantage of the strengths of a parsetree-based auto-formatter,
and to limit the consequences of the weaknesses imposed by the current implementation.
This is a style which optimizes for what the formatter can do best, rather than to match the style of any existing code.
General guidelines that have directed the design include:</p>
<ul>
<li>Legibility, in the sense of making it as hard as possible for quick visual parsing to give the wrong interpretation,
is of highest priority;</li>
<li>Whenever possible the high-level structure of the code should be obvious by looking only at the left margin,
in particular, it should not be necessary to visually jump from left to right hunting for critical keywords, tokens, etc;</li>
<li>All else equal compact code is preferred as reading without scrolling is easier,
so indentation or white space is avoided unless it helps legibility;</li>
<li>Attention has been given to making some syntactic gotchas visually obvious.</li>
</ul>
<p><code>ocamlformat</code> is the new default profile.</p>
<p>The <code>conventional</code> profile aims to be as familiar and &quot;conventional&quot; appearing as the available options allow.</p>
<p>The <code>default</code> profile is <code>ocamlformat</code> with <code>break-cases=fit</code>.
<code>default</code> is deprecated and will be removed in version 0.10.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#ocamlformat-diff-tool" aria-label="ocamlformat diff tool permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>OCamlFormat diff tool</h1>
<p><code>ocamlformat-diff</code> is a tool that uses OCamlFormat to apply the same formatting to compared OCaml files,
so that the formatting differences between the two files are not displayed.
Note that <code>ocamlformat-diff</code> comes in a separate opam package and is not included in the <code>ocamlformat</code> package.</p>
<p>The file comparison is then performed by any diff backend.</p>
<p>The options' documentation is available through <code>ocamlformat-diff --help</code>.</p>
<p>The option <code>--diff</code> allows you to configure the diff command that is used to compare the formatted files.
The default value is the vanilla <code>diff</code>, but you can also use <code>patdiff</code> or any other similar comparison tool.</p>
<p><code>ocamlformat-diff</code> can be integrated with <code>git diff</code>,
as explained in the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/0.9/tools/ocamlformat-diff/README.md">online documentation</a>.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#formatting-docstrings" aria-label="formatting docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Formatting docstrings</h1>
<p>Previously, the docstrings <code>(** This is a docstring *)</code> could only be formatted like regular comments,
a new option <code>--parse-docstrings</code> has been added so that docstrings can be nicely formatted.</p>
<p>Here is a small example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(** {1 Printers and escapes used by Cmdliner module} *)</span>

<span class="token keyword">val</span> subst_vars <span class="token punctuation">:</span> subst<span class="token punctuation">:</span><span class="token punctuation">(</span>string <span class="token operator">-&gt;</span> string option<span class="token punctuation">)</span> <span class="token operator">-&gt;</span> <span class="token module variable">Buffer</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> string <span class="token operator">-&gt;</span> string
<span class="token comment">(** [subst b ~subst s], using [b], substitutes in [s] variables of the form
    &quot;$(doc)&quot; by their [subst] definition. This leaves escapes and markup
    directives $(markup,...) intact.
    @raise Invalid_argument in case of illegal syntax. *)</span></code></pre></div>
<p>Note that this option is disabled by default and you have to set it manually by adding <code>--parse-docstrings</code> to your command line
or <code>parse-docstrings=true</code> to your <code>.ocamlformat</code> file.
If you get the following error message:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Error: Formatting of (** ... *) is unstable (e.g. parses as a list or not depending on the margin), please tighten up this comment in the source or disable the formatting using the option --no-parse-docstrings.</code></pre></div>
<p>It means the original docstring cannot be formatted (e.g. because it does not comply with the odoc syntax)
and you have to edit it or disable the formatting of docstrings.</p>
<p>Of course if you think your docstring complies with the odoc syntax and there might be a bug in OCamlFormat,
<a href="https://github.com/ocaml-ppx/ocamlformat/issues">feel free to file an issue on github</a>.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#print-the-configuration" aria-label="print the configuration permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Print the configuration</h1>
<p>The new <code>--print-config</code> flag prints the configuration determined by the environment variable,
the configuration files, preset profiles and command line. Attributes are not considered.</p>
<p>It provides the full list of options with the values they are set to, and the source of this value.
For example <code>ocamlformat --print-config</code> prints:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">profile=ocamlformat (file .ocamlformat:1)
quiet=false (profile ocamlformat (file .ocamlformat:1))
max-iters=10 (profile ocamlformat (file .ocamlformat:1))
comment-check=true (profile ocamlformat (file .ocamlformat:1))
wrap-fun-args=true (profile ocamlformat (file .ocamlformat:1))
wrap-comments=true (file .ocamlformat:5)
type-decl=compact (profile ocamlformat (file .ocamlformat:1))
space-around-collection-expressions=false (profile ocamlformat (file .ocamlformat:1))
single-case=compact (profile ocamlformat (file .ocamlformat:1))
sequence-style=separator (profile ocamlformat (file .ocamlformat:1))
parse-docstrings=true (file .ocamlformat:4)
parens-tuple-patterns=multi-line-only (profile ocamlformat (file .ocamlformat:1))
parens-tuple=always (profile ocamlformat (file .ocamlformat:1))
parens-ite=false (profile ocamlformat (file .ocamlformat:1))
ocp-indent-compat=false (profile ocamlformat (file .ocamlformat:1))
module-item-spacing=sparse (profile ocamlformat (file .ocamlformat:1))
margin=77 (file .ocamlformat:3)
let-open=preserve (profile ocamlformat (file .ocamlformat:1))
let-binding-spacing=compact (profile ocamlformat (file .ocamlformat:1))
let-and=compact (profile ocamlformat (file .ocamlformat:1))
leading-nested-match-parens=false (profile ocamlformat (file .ocamlformat:1))
infix-precedence=indent (profile ocamlformat (file .ocamlformat:1))
indicate-nested-or-patterns=space (profile ocamlformat (file .ocamlformat:1))
indicate-multiline-delimiters=true (profile ocamlformat (file .ocamlformat:1))
if-then-else=compact (profile ocamlformat (file .ocamlformat:1))
field-space=tight (profile ocamlformat (file .ocamlformat:1))
extension-sugar=preserve (profile ocamlformat (file .ocamlformat:1))
escape-strings=preserve (profile ocamlformat (file .ocamlformat:1))
escape-chars=preserve (profile ocamlformat (file .ocamlformat:1))
doc-comments-tag-only=default (profile ocamlformat (file .ocamlformat:1))
doc-comments-padding=2 (profile ocamlformat (file .ocamlformat:1))
doc-comments=after (profile ocamlformat (file .ocamlformat:1))
disable=false (profile ocamlformat (file .ocamlformat:1))
cases-exp-indent=4 (profile ocamlformat (file .ocamlformat:1))
break-struct=force (profile ocamlformat (file .ocamlformat:1))
break-string-literals=wrap (profile ocamlformat (file .ocamlformat:1))
break-sequences=false (profile ocamlformat (file .ocamlformat:1))
break-separators=before (profile ocamlformat (file .ocamlformat:1))
break-infix-before-func=true (profile ocamlformat (file .ocamlformat:1))
break-infix=wrap (profile ocamlformat (file .ocamlformat:1))
break-fun-decl=wrap (profile ocamlformat (file .ocamlformat:1))
break-collection-expressions=fit-or-vertical (profile ocamlformat (file .ocamlformat:1))
break-cases=fit (file .ocamlformat:2)</code></pre></div>
<p>If many input files are specified, only print the configuration for the first file.
If no input file is specified, print the configuration for the root directory if specified,
or for the current working directory otherwise.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#parentheses-around-if-then-else-branches" aria-label="parentheses around if then else branches permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Parentheses around if-then-else branches</h1>
<p>A new option <code>parens-ite</code> has been added to decide whether to use parentheses
around if-then-else branches that spread across multiple lines.</p>
<p>If this option is set, the following function:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> loop count a <span class="token operator">=</span>
  <span class="token keyword">if</span> count <span class="token operator">&gt;=</span> self#len
  <span class="token keyword">then</span> a
  <span class="token keyword">else</span>
    <span class="token keyword">let</span> a' <span class="token operator">=</span> f cur#get count a <span class="token keyword">in</span>
    cur#incr <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    loop <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> a'</code></pre></div>
<p>will be formatted as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token keyword">rec</span> loop count a <span class="token operator">=</span>
  <span class="token keyword">if</span> count <span class="token operator">&gt;=</span> self#len
  <span class="token keyword">then</span> a
  <span class="token keyword">else</span> <span class="token punctuation">(</span>
    <span class="token keyword">let</span> a' <span class="token operator">=</span> f cur#get count a <span class="token keyword">in</span>
    cur#incr <span class="token punctuation">(</span><span class="token punctuation">)</span><span class="token punctuation">;</span>
    loop <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span> a' <span class="token punctuation">)</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#parentheses-around-tuple-patterns" aria-label="parentheses around tuple patterns permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Parentheses around tuple patterns</h1>
<p>A new option <code>parens-tuple-patterns</code> has been added, that mimics <code>parens-tuple</code> but only applies to patterns,
whereas <code>parens-tuples</code> only applies to expressions.
<code>parens-tuple-patterns=multi-line-only</code> mode will try to skip parentheses for single-line tuple patterns,
this is the default value.
<code>parens-tuple-patterns=always</code> always uses parentheses around tuples patterns.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with parens-tuple-patterns=always *)</span>
<span class="token keyword">let</span> <span class="token punctuation">(</span>a<span class="token punctuation">,</span> b<span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2</span><span class="token punctuation">)</span>

<span class="token comment">(* with parens-tuple-patterns=multi-line-only *)</span>
<span class="token keyword">let</span> a<span class="token punctuation">,</span> b <span class="token operator">=</span> <span class="token punctuation">(</span><span class="token number">1</span><span class="token punctuation">,</span> <span class="token number">2</span><span class="token punctuation">)</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#single-case-pattern-matching-expressions" aria-label="single case pattern matching expressions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Single-case pattern-matching expressions</h1>
<p>The new option <code>single-case</code> defines the style of pattern-matching expressions with only a single case.
<code>single-case=compact</code> will try to format a single case on a single line, this is the default value.
<code>single-case=sparse</code> will always break the line before a single case.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with single-case=compact *)</span>
<span class="token keyword">try</span> some_irrelevant_expression
<span class="token keyword">with</span> <span class="token module variable">Undefined_recursive_module</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token boolean">true</span>

<span class="token comment">(* with single-case=sparse *)</span>
<span class="token keyword">try</span> some_irrelevant_expression
<span class="token keyword">with</span>
<span class="token operator">|</span> <span class="token module variable">Undefined_recursive_module</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token boolean">true</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#space-around-collection-expressions" aria-label="space around collection expressions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Space around collection expressions</h1>
<p>The new option <code>space-around-collection-expressions</code> decides whether to add a space
inside the delimiters of collection expressions (lists, arrays, records).</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* by default *)</span>
<span class="token keyword">type</span> wkind <span class="token operator">=</span> <span class="token punctuation">{</span>f <span class="token punctuation">:</span> <span class="token type-variable function">'a</span><span class="token punctuation">.</span> <span class="token type-variable function">'a</span> tag <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> kind<span class="token punctuation">}</span>
<span class="token keyword">let</span> l <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token string">&quot;Nil&quot;</span><span class="token punctuation">,</span> <span class="token module variable">TCnoarg</span> <span class="token module variable">Thd</span><span class="token punctuation">;</span> <span class="token string">&quot;Cons&quot;</span><span class="token punctuation">,</span> <span class="token module variable">TCarg</span> <span class="token punctuation">(</span><span class="token module variable">Ttl</span> <span class="token module variable">Thd</span><span class="token punctuation">,</span> tcons<span class="token punctuation">)</span><span class="token punctuation">]</span>

<span class="token comment">(* with space-around-collection-expressions *)</span>
<span class="token keyword">type</span> wkind <span class="token operator">=</span> <span class="token punctuation">{</span> f <span class="token punctuation">:</span> <span class="token type-variable function">'a</span><span class="token punctuation">.</span> <span class="token type-variable function">'a</span> tag <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> kind <span class="token punctuation">}</span>
<span class="token keyword">let</span> l <span class="token operator">=</span> <span class="token punctuation">[</span> <span class="token string">&quot;Nil&quot;</span><span class="token punctuation">,</span> <span class="token module variable">TCnoarg</span> <span class="token module variable">Thd</span><span class="token punctuation">;</span> <span class="token string">&quot;Cons&quot;</span><span class="token punctuation">,</span> <span class="token module variable">TCarg</span> <span class="token punctuation">(</span><span class="token module variable">Ttl</span> <span class="token module variable">Thd</span><span class="token punctuation">,</span> tcons<span class="token punctuation">)</span> <span class="token punctuation">]</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#break-separators" aria-label="break separators permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break separators</h1>
<p>The new option <code>break-separators</code> decides whether to break before or after separators such as <code>;</code> in list or record expressions,
<code>*</code> in tuples or <code>-&gt;</code> in arrow types.
<code>break-separators=before</code> breaks the expressions before the separator, this is the default value.
<code>break-separators=after</code> breaks the expressions after the separator.
<code>break-separators=after-and-docked</code> breaks the expressions after the separator and docks the brackets for records.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with break-separators=before *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo
  <span class="token punctuation">;</span> fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo <span class="token punctuation">}</span>

<span class="token comment">(* with break-separators=after *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo<span class="token punctuation">;</span>
    fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo <span class="token punctuation">}</span>

<span class="token comment">(* with break-separators=after-and-docked *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>
  foooooooooooooooooooooooo<span class="token punctuation">:</span> foooooooooooooooooooooooooooooooooooooooo<span class="token punctuation">;</span>
  fooooooooooooooooooooooooooooo<span class="token punctuation">:</span> fooooooooooooooooooooooooooo
<span class="token punctuation">}</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#not-breaking-before-bindmap-operators" aria-label="not breaking before bindmap operators permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Not breaking before bind/map operators</h1>
<p>The new option <code>break-infix-before-func</code> decides whether to break infix operators
whose right arguments are anonymous functions specially.
This option is set by default, if you disable it with <code>--no-break-infix-before-func</code>,
it will not break before the operator so that the first line of the function appears docked at the end of line after the operator.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* by default *)</span>
f x
<span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span>
g y
<span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
f x <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span> g y <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> f x <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span> g y <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> y <span class="token punctuation">(</span><span class="token punctuation">)</span>

<span class="token comment">(* with break-infix-before-func = false *)</span>
f x <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span>
g y <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
f x <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span> g y <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> f x <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> y <span class="token operator">-&gt;</span> g y <span class="token operator">&gt;&gt;=</span> <span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> y <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#break-toplevel-cases" aria-label="break toplevel cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break toplevel cases</h1>
<p>There is a new value for the <code>break-cases</code> option: <code>toplevel</code>,
that forces top-level cases (i.e. not nested or-patterns) to break across lines,
otherwise breaks naturally at the margin.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> f <span class="token operator">=</span>
  <span class="token keyword">let</span> g <span class="token operator">=</span> <span class="token keyword">function</span>
    <span class="token operator">|</span> H <span class="token keyword">when</span> x y <span class="token operator">&lt;&gt;</span> k <span class="token operator">-&gt;</span> <span class="token number">2</span>
    <span class="token operator">|</span> T <span class="token operator">|</span> P <span class="token operator">|</span> U <span class="token operator">-&gt;</span> <span class="token number">3</span>
  <span class="token keyword">in</span>
  <span class="token keyword">fun</span> x g t h y u <span class="token operator">-&gt;</span>
    <span class="token keyword">match</span> x <span class="token keyword">with</span>
    <span class="token operator">|</span> E <span class="token operator">-&gt;</span> <span class="token number">4</span>
    <span class="token operator">|</span> Z <span class="token operator">|</span> P <span class="token operator">|</span> M <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>
      <span class="token keyword">match</span> y <span class="token keyword">with</span>
      <span class="token operator">|</span> O <span class="token operator">-&gt;</span> <span class="token number">5</span>
      <span class="token operator">|</span> P <span class="token keyword">when</span> h x <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>
          <span class="token keyword">function</span>
          <span class="token operator">|</span> A <span class="token operator">-&gt;</span> <span class="token number">6</span> <span class="token punctuation">)</span> <span class="token punctuation">)</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#number-of-spaces-before-docstrings" aria-label="number of spaces before docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Number of spaces before docstrings</h1>
<p>The new option <code>doc-comments-padding</code> controls how many spaces are printed before doc comments in type declarations.
The default value is 2.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with doc-comments-padding = 2 *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>a<span class="token punctuation">:</span> int  <span class="token comment">(** a *)</span><span class="token punctuation">;</span> b<span class="token punctuation">:</span> int  <span class="token comment">(** b *)</span><span class="token punctuation">}</span>

<span class="token comment">(* with doc-comments-padding = 1 *)</span>
<span class="token keyword">type</span> t <span class="token operator">=</span> <span class="token punctuation">{</span>a<span class="token punctuation">:</span> int <span class="token comment">(** a *)</span><span class="token punctuation">;</span> b<span class="token punctuation">:</span> int <span class="token comment">(** b *)</span><span class="token punctuation">}</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#ignore-files" aria-label="ignore files permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Ignore files</h1>
<p>An <code>.ocamlformat-ignore</code> file specifies files that OCamlFormat should ignore.
Each line in an <code>.ocamlformat-ignore</code> file specifies a filename relative to the directory containing the <code>.ocamlformat-ignore</code> file.
Lines starting with <code>#</code> are ignored and can be used as comments.</p>
<p>Here is an example of such <code>.ocamlformat-ignore</code> file:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">#This is a comment
dir2/ignore_1.ml</code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#tag-only-docstrings" aria-label="tag only docstrings permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tag-only docstrings</h1>
<p>The new option <code>doc-comments-tag-only</code> controls the position of doc comments only containing tags.
<code>doc-comments-tag-only=default</code> means no special treatment is done, this is the default value.
<code>doc-comments-tag-only=fit</code> puts doc comments on the same line if it fits.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with doc-comments-tag-only = default *)</span>

<span class="token comment">(** @deprecated  *)</span>
<span class="token keyword">open</span> <span class="token module variable">Module</span>

<span class="token comment">(* with doc-comments-tag-only = fit *)</span>

<span class="token keyword">open</span> <span class="token module variable">Module</span> <span class="token comment">(** @deprecated  *)</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#fit-or-vertical-mode-for-if-then-else" aria-label="fit or vertical mode for if then else permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Fit or vertical mode for if-then-else</h1>
<p>There is a new value for the option <code>if-then-else</code>: <code>fit-or-vertical</code>.
<code>fit-or-vertical</code> vertically breaks all branches if they do not fit on a single line.
Compared to the <code>compact</code> (default) value, it breaks all branches if at least one of them does not fit on a single line.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with if-then-else = compact *)</span>
<span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">1</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
    a <span class="token operator">+</span> b
  <span class="token keyword">else</span> <span class="token keyword">if</span> foo <span class="token keyword">then</span> <span class="token number">12</span>
  <span class="token keyword">else</span> <span class="token number">0</span>

<span class="token comment">(* with if-then-else = fit-or-vertical *)</span>
<span class="token keyword">let</span> <span class="token punctuation">_</span> <span class="token operator">=</span>
  <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">1</span> <span class="token keyword">in</span>
    <span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
    a <span class="token operator">+</span> b
  <span class="token keyword">else</span> <span class="token keyword">if</span> foo <span class="token keyword">then</span>
    <span class="token number">12</span>
  <span class="token keyword">else</span>
    <span class="token number">0</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#check-mode" aria-label="check mode permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Check mode</h1>
<p>A new <code>--check</code> flag has been added.
It checks whether the input files already are formatted.
This flag is mutually exclusive with <code>--inplace</code> and <code>--output</code>.
It returns <code>0</code> if the input files are indeed already formatted, or <code>1</code> otherwise.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#break-function-declarations" aria-label="break function declarations permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Break function declarations</h1>
<p>The new option <code>break-fun-decl</code> controls the style for function declarations and types.
<code>break-fun-decl=wrap</code> breaks only if necessary, this is the default value.
<code>break-fun-decl=fit-or-vertical</code> vertically breaks arguments if they do not fit on a single line.
<code>break-fun-decl=smart</code> is like <code>fit-or-vertical</code> but try to fit arguments on their line if they fit.
The <code>wrap-fun-args</code> option now only controls the style for function calls, and no more for function declarations.</p>
<p>For example:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* with break-fun-decl = wrap *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff aaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbb
    cccccccccccccccccccccc <span class="token operator">=</span>
  g

<span class="token comment">(* with break-fun-decl = fit-or-vertical *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff
    aaaaaaaaaaaaaaaaaaaaaa
    bbbbbbbbbbbbbbbbbbbbbb
    cccccccccccccccccccccc <span class="token operator">=</span>
  g

<span class="token comment">(* with break-fun-decl = smart *)</span>
<span class="token keyword">let</span> ffffffffffffffffffff
    aaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbb cccccccccccccccccccccc <span class="token operator">=</span>
  g</code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#disable-configuration-in-files-and-attributes" aria-label="disable configuration in files and attributes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Disable configuration in files and attributes</h1>
<p>Two new options have been added so that <code>.ocamlformat</code> configuration files and attributes in OCaml files do not change the
configuration.
These options can be useful if you use some preset profile
and you do not want attributes and <code>.ocamlformat</code> files to interfere with your preset configuration.
<code>--disable-conf-attrs</code> disables the configuration in attributes,
and <code>--disable-conf-files</code> disables <code>.ocamlformat</code> configuration files.</p>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#preserve-module-items-spacing" aria-label="preserve module items spacing permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Preserve module items spacing</h1>
<p>There is a new value for the option <code>module-item-spacing</code>: <code>preserve</code>,
that will not leave open lines between one-liners of similar sorts unless there is an open line in the input.</p>
<p>For example the line breaks are preserved in the following code:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> cmos_rtc_seconds <span class="token operator">=</span> <span class="token number">0x00</span>
<span class="token keyword">let</span> cmos_rtc_seconds_alarm <span class="token operator">=</span> <span class="token number">0x01</span>
<span class="token keyword">let</span> cmos_rtc_minutes <span class="token operator">=</span> <span class="token number">0x02</span>

<span class="token keyword">let</span> x <span class="token operator">=</span> o

<span class="token keyword">let</span> log_other <span class="token operator">=</span> <span class="token number">0x000001</span>
<span class="token keyword">let</span> log_cpu <span class="token operator">=</span> <span class="token number">0x000002</span>
<span class="token keyword">let</span> log_fpu <span class="token operator">=</span> <span class="token number">0x000004</span></code></pre></div>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#breaking-changes" aria-label="breaking changes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Breaking changes</h1>
<ul>
<li>When <code>--disable-outside-detected-project</code> is set, disable ocamlformat when no <code>.ocamlformat</code> file is found.</li>
<li>Files are not parsed when ocamlformat is disabled.</li>
<li>Disallow <code>-</code> with other input files.</li>
<li>The <code>wrap-fun-args</code> option now only controls the style for function calls, and no more for function declarations.</li>
<li>The default profile is now named <code>ocamlformat</code>.</li>
<li>The deprecated syntax for <code>.ocamlformat</code> files: <code>option value</code> is no more supported anymore and you should use the <code>option = value</code> syntax instead.</li>
</ul>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#miscellaneous-bugfixes" aria-label="miscellaneous bugfixes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Miscellaneous bugfixes</h1>
<ul>
<li>Preserve shebang (e.g. <code>#!/usr/bin/env ocaml</code>) at the beginning of a file.</li>
<li>Improve the formatting when <code>ocp-indent-compat</code> is set.</li>
<li>UTF8 characters are now correctly printed in comments.</li>
<li>Add parentheses around a constrained any-pattern (e.g. <code>let (_ : int) = x1</code>).</li>
<li>Emacs: the temporary buffer is now killed.</li>
<li>Emacs: add the keybinding in tuareg's map instead of merlin's.</li>
<li>Lots of improvements on the comments, docstrings, attributes formatting.</li>
<li>Lots of improvements on the formatting of modules.</li>
<li>Lots of improvements in the Reason support.</li>
<li>Do not rely on the file-system to format sources.</li>
<li>The <code>--debug</code> mode is more user-friendly.</li>
</ul>
<h1 style="position:relative;"><a href="https://tarides.com/feed.xml#credits" aria-label="credits permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Credits</h1>
<p>This release also contains many other changes and bug fixes that we cannot detail here.</p>
<p>Special thanks to our maintainers and contributors for this release: Jules Aguillon, Mathieu Barbin, Josh Berdine, J&eacute;r&eacute;mie Dimino, Hugo Heuzard, Ludwig Pacifici, Guillaume Petiot, Nathan Rebours and Louis Roch&eacute;.</p>
<p>If you wish to get involved with OCamlFormat development or file an issue,
please read the <a href="https://github.com/ocaml-ppx/ocamlformat/blob/master/CONTRIBUTING.md">contributing guide</a>,
any contribution is welcomed.</p>
