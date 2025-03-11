---
title: 'Learning OCaml: Quoted String Literals'
description: "While learning OCaml I\u2019ve noticed one curious feature - it has
  two types of string literals. The first type are the common and quite familiar \u201Cdouble-quoted
  string literals\u201D (or perhaps simply \u201Cstring literals\u201D?):"
url: https://batsov.com/articles/2023/04/20/learning-ocaml-quoted-string-literals/
date: 2023-04-20T13:23:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>While learning OCaml I’ve noticed one curious feature - it has two
types of string literals. The first type are the common and quite
familiar “double-quoted string literals” (or perhaps simply “string literals”?):</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">greeting</span> <span class="o">=</span> <span class="s2">"Hello, World!</span><span class="se">\n</span><span class="s2">"</span>
<span class="k">let</span> <span class="n">superscript_plus</span> <span class="o">=</span> <span class="s2">"</span><span class="err">\</span><span class="s2">u{207A}"</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">greeting</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"Hello, World!</span><span class="se">\n</span><span class="s2">"</span>
<span class="k">val</span> <span class="n">superscript_plus</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"⁺"</span>
</code></pre></div></div>

<p>Nothing really surprising here, right? But then there are also what OCaml calls
<a href="https://v2.ocaml.org/manual/lex.html#sss:stringliterals">quoted string
literals</a> (a.k.a. “quoted strings”):</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">quoted_greeting</span> <span class="o">=</span> <span class="p">{</span><span class="o">|</span><span class="s2">"Hello, World!"</span><span class="o">|</span><span class="p">}</span>
<span class="k">let</span> <span class="n">nested</span> <span class="o">=</span> <span class="p">{</span><span class="n">ext</span><span class="o">|</span><span class="n">hello</span> <span class="p">{</span><span class="o">|</span><span class="n">world</span><span class="o">|</span><span class="p">}</span><span class="o">|</span><span class="n">ext</span><span class="p">};;</span>
<span class="k">val</span> <span class="n">quoted_greeting</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"</span><span class="se">\"</span><span class="s2">Hello, World!</span><span class="se">\"</span><span class="s2">"</span>
<span class="k">val</span> <span class="n">nested</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"hello {|world|}"</span>
</code></pre></div></div>

<p>Now that’s something you don’t see every day, right? Here’s how the official
manual describes them:</p>

<blockquote>
  <p>Quoted string literals provide an alternative lexical syntax for string
literals. They are useful to represent strings of arbitrary content without
escaping. Quoted strings are delimited by a matching pair of
<code class="language-plaintext highlighter-rouge">{ quoted-string-id |</code> and <code class="language-plaintext highlighter-rouge">| quoted-string-id }</code> with the same <code class="language-plaintext highlighter-rouge">quoted-string-id</code> on
both sides. Quoted strings do not interpret any character in a special way but
requires that the sequence <code class="language-plaintext highlighter-rouge">| quoted-string-id }</code> does not occur in the string
itself. The identifier <code class="language-plaintext highlighter-rouge">quoted-string-id</code> is a (possibly empty) sequence of
lowercase letters and underscores that can be freely chosen to avoid such
issue.</p>
</blockquote>

<p>Note that all special escape sequences are ignored in quoted strings:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* regular strings *)</span>
<span class="k">let</span> <span class="n">greeting</span> <span class="o">=</span> <span class="s2">"Hello, World!</span><span class="se">\n</span><span class="s2">"</span>
<span class="k">let</span> <span class="n">superscript_plus</span> <span class="o">=</span> <span class="s2">"</span><span class="err">\</span><span class="s2">u{207A}"</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">greeting</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"Hello, World!</span><span class="se">\n</span><span class="s2">"</span>
<span class="k">val</span> <span class="n">superscript_plus</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"⁺"</span>

<span class="c">(* quoted strings *)</span>
<span class="k">let</span> <span class="n">greeting</span> <span class="o">=</span> <span class="p">{</span><span class="o">|</span><span class="nc">Hello</span><span class="o">,</span> <span class="nc">World</span><span class="o">!</span><span class="err">\</span><span class="n">n</span><span class="o">|</span><span class="p">}</span>
<span class="k">let</span> <span class="n">superscript_plus</span> <span class="o">=</span> <span class="p">{</span><span class="o">|</span><span class="err">\</span><span class="n">u</span><span class="p">{</span><span class="mi">207</span><span class="nc">A</span><span class="p">}</span><span class="o">|</span><span class="p">};;</span>
<span class="k">val</span> <span class="n">greeting</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"Hello, World!</span><span class="se">\\</span><span class="s2">n"</span>
<span class="k">val</span> <span class="n">superscript_plus</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"</span><span class="se">\\</span><span class="s2">u{207A}"</span>
</code></pre></div></div>

<p>In this way you can say they are pretty similar to single-quoted strings in
languages like Perl and Ruby (think <code class="language-plaintext highlighter-rouge">'string'</code>).</p>

<p><a href="https://dev.realworldocaml.org">Real World OCaml</a> has a <a href="https://dev.realworldocaml.org/testing.html#scrollNav-2-3">nice
example</a> that
illustrates the usefulness of quoted strings:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span><span class="o">%</span><span class="n">expect_test</span> <span class="n">_</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">example_html</span> <span class="o">=</span>
    <span class="p">{</span><span class="o">|</span>
    <span class="o">&lt;</span><span class="n">html</span><span class="o">&gt;</span>
      <span class="nc">Some</span> <span class="n">random</span> <span class="o">&lt;</span><span class="n">b</span><span class="o">&gt;</span><span class="n">text</span><span class="o">&lt;/</span><span class="n">b</span><span class="o">&gt;</span> <span class="k">with</span> <span class="n">a</span>
      <span class="o">&lt;</span><span class="n">a</span> <span class="n">href</span><span class="o">=</span><span class="s2">"http://ocaml.org/base"</span><span class="o">&gt;</span><span class="n">link</span><span class="o">&lt;/</span><span class="n">a</span><span class="o">&gt;.</span>
      <span class="nc">And</span> <span class="n">here's</span> <span class="n">another</span>
      <span class="o">&lt;</span><span class="n">a</span> <span class="n">href</span><span class="o">=</span><span class="s2">"http://github.com/ocaml/dune"</span><span class="o">&gt;</span><span class="n">link</span><span class="o">&lt;/</span><span class="n">a</span><span class="o">&gt;.</span>
      <span class="nc">And</span> <span class="n">here</span> <span class="n">is</span> <span class="o">&lt;</span><span class="n">a</span><span class="o">&gt;</span><span class="n">link</span><span class="o">&lt;/</span><span class="n">a</span><span class="o">&gt;</span> <span class="k">with</span> <span class="n">no</span> <span class="n">href</span><span class="o">.</span>
    <span class="o">&lt;/</span><span class="n">html</span><span class="o">&gt;|</span><span class="p">}</span>
  <span class="k">in</span>
  <span class="k">let</span> <span class="n">soup</span> <span class="o">=</span> <span class="nn">Soup</span><span class="p">.</span><span class="n">parse</span> <span class="n">example_html</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">hrefs</span> <span class="o">=</span> <span class="n">get_href_hosts</span> <span class="n">soup</span> <span class="k">in</span>
  <span class="n">print_s</span> <span class="p">[</span><span class="o">%</span><span class="n">sexp</span> <span class="p">(</span><span class="n">hrefs</span> <span class="o">:</span> <span class="nn">Set</span><span class="p">.</span><span class="nc">M</span><span class="p">(</span><span class="nc">String</span><span class="p">)</span><span class="o">.</span><span class="n">t</span><span class="p">)]</span>
</code></pre></div></div>

<p>As you can see one good use-case for quoted strings is embedding snippets of
code, as those typically tend to have lots of things that would normally need to be
escaped.
And because the delimiters are so flexible you don’t really have to worry about
content that uses <code class="language-plaintext highlighter-rouge">{| |}</code> internally - after all you can easily change this to
whatever you want.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">nested</span> <span class="o">=</span> <span class="p">{</span><span class="n">xoxo</span><span class="o">|</span><span class="n">hello</span> <span class="p">{</span><span class="o">|</span><span class="n">world</span><span class="o">|</span><span class="p">}</span><span class="o">|</span><span class="n">xoxo</span><span class="p">};;</span>
<span class="k">val</span> <span class="n">nested</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"hello {|world|}"</span>
</code></pre></div></div>

<p>Another good use-case for quoted strings are regular expressions.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> In regular
expressions you will often use backslash characters; it’s easier to use a quoted
string literal <code class="language-plaintext highlighter-rouge">{|...|}</code> to avoid having to escape backslashes. For example, the
following expression:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="p">{</span><span class="o">|</span><span class="n">hello</span> <span class="err">\</span><span class="p">([</span><span class="nc">A</span><span class="o">-</span><span class="nc">Za</span><span class="o">-</span><span class="n">z</span><span class="p">]</span><span class="o">+</span><span class="err">\</span><span class="p">)</span><span class="o">|</span><span class="p">}</span> <span class="k">in</span>
     <span class="nn">Str</span><span class="p">.</span><span class="n">replace_first</span> <span class="n">r</span> <span class="p">{</span><span class="o">|</span><span class="err">\</span><span class="mi">1</span><span class="o">|</span><span class="p">}</span> <span class="s2">"hello world"</span>
</code></pre></div></div>

<p>returns the string “world”.</p>

<p>If you want a regular expression that matches a literal backslash character, you need to double it: <code class="language-plaintext highlighter-rouge">Str.regexp {|\\|}</code>.</p>

<p>If we use regular string literals (“…”), we will have to escape backslashes, which makes the regular expressions a bit harder the read:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="s2">"hello </span><span class="se">\\</span><span class="s2">([A-Za-z]+</span><span class="se">\\</span><span class="s2">)"</span> <span class="k">in</span>
     <span class="nn">Str</span><span class="p">.</span><span class="n">replace_first</span> <span class="n">r</span> <span class="s2">"</span><span class="se">\\</span><span class="s2">1"</span> <span class="s2">"hello world"</span>
</code></pre></div></div>

<p>And the regular expression for matching a backslash becomes a quadruple backslash: <code class="language-plaintext highlighter-rouge">Str.regexp "\\\\"</code>. Pretty ugly, right?</p>

<p>One more thing. Quoted strings <code class="language-plaintext highlighter-rouge">{|...|}</code> can be combined with <a href="https://v2.ocaml.org/manual/extensionnodes.html#s:extension-nodes">extension
nodes</a> to
embed foreign syntax fragments. Those fragments can be interpreted by a
preprocessor and turned into OCaml code without requiring escaping quotes. A
syntax shortcut is available for them:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>
<span class="p">{</span><span class="o">%%</span><span class="n">foo</span><span class="o">|...|</span><span class="p">}</span>               <span class="o">===</span> <span class="p">[</span><span class="o">%%</span><span class="n">foo</span><span class="p">{</span><span class="o">|...|</span><span class="p">}]</span>
<span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="p">{</span><span class="o">%</span><span class="n">foo</span><span class="o">|...|</span><span class="p">}</span>        <span class="o">===</span> <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">foo</span><span class="p">{</span><span class="o">|...|</span><span class="p">}]</span>
<span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="p">{</span><span class="o">%</span><span class="n">foo</span> <span class="n">bar</span><span class="o">|...|</span><span class="n">bar</span><span class="p">}</span> <span class="o">===</span> <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">foo</span><span class="p">{</span><span class="n">bar</span><span class="o">|...|</span><span class="n">bar</span><span class="p">}]</span>

</code></pre></div></div>

<p>For instance, you can use <code class="language-plaintext highlighter-rouge">{%sql|...|}</code> to represent arbitrary SQL statements –
assuming you have a <code class="language-plaintext highlighter-rouge">ppx</code>-rewriter that recognizes the <code class="language-plaintext highlighter-rouge">%sql</code> extension.</p>

<p>I have to say I think it’s a bit funny that OCaml’s quoted strings are called
“quoted strings”. It’s not like double-quoted strings (think <code class="language-plaintext highlighter-rouge">"string"</code>) are
unquoted, right? Pretty sure this name doesn’t help with the discoverability of
this useful feature. Oh, well - naming is hard!</p>

<p>That’s all I have for you today. Please, share in the comments whether you use
quoted strings and what are some of your favorite use-cases for them. Keep
hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>The examples here use the built-in <a href="https://v2.ocaml.org/api/Str.html">Str</a> library.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
