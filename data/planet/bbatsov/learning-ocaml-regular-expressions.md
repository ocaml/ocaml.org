---
title: 'Learning OCaml: Regular Expressions'
description: "One of the things that bothered me initially in OCaml was the poor support
  for working in regular expressions in the standard library. Technically speaking,
  there\u2019s no support for them at all!"
url: https://batsov.com/articles/2025/04/04/learning-ocaml-regular-expressions/
date: 2025-04-04T11:22:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>One of the things that bothered me initially in OCaml was the poor support for
working in regular expressions in the <a href="https://batsov.com/articles/2025/03/14/ocaml-s-standard-library/">standard library</a>.
Technically speaking, there’s no support for them at all!</p>

<p>What do I mean by this? Well, there’s the older <a href="https://ocaml.org/manual/5.3/api/Str.html">Str</a> library that provides support for regular expressions, but it’s:</p>

<ul>
  <li>not really a part of the standard library (it’s bundled with OCaml, but not part of <code class="language-plaintext highlighter-rouge">Stdlib</code>)</li>
  <li>it doesn’t work with unicode characters, as it treats strings as sequences of bytes</li>
  <li>very confusingly named (when I see something named <code class="language-plaintext highlighter-rouge">Str</code> I’m thinking of strings)</li>
</ul>

<p><strong>Note:</strong> Use <code class="language-plaintext highlighter-rouge">#require "str";;</code> in the top-level to load <code class="language-plaintext highlighter-rouge">Str</code>.</p>

<p>Here’s a trivial example using it:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">text</span> <span class="o">=</span> <span class="s2">"hello123world"</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="s2">"[0-9]+"</span> <span class="k">in</span>
<span class="k">if</span> <span class="nn">Str</span><span class="p">.</span><span class="n">string_match</span> <span class="n">re</span> <span class="n">text</span> <span class="mi">0</span> <span class="k">then</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Matched: %s</span><span class="se">\n</span><span class="s2">"</span> <span class="p">(</span><span class="n">matched_string</span> <span class="n">text</span><span class="p">)</span>
<span class="k">else</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"No match</span><span class="se">\n</span><span class="s2">"</span><span class="p">;;</span>

<span class="nn">Str</span><span class="p">.</span><span class="n">global_replace</span> <span class="p">(</span><span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="s2">"[0-9]+"</span><span class="p">)</span> <span class="s2">"#"</span> <span class="s2">"hello123world456"</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"hello#world#"</span>

<span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="p">{</span><span class="o">|</span><span class="n">hello</span> <span class="err">\</span><span class="p">([</span><span class="nc">A</span><span class="o">-</span><span class="nc">Za</span><span class="o">-</span><span class="n">z</span><span class="p">]</span><span class="o">+</span><span class="err">\</span><span class="p">)</span><span class="o">|</span><span class="p">}</span> <span class="k">in</span>
      <span class="nn">Str</span><span class="p">.</span><span class="n">replace_first</span> <span class="n">re</span> <span class="p">{</span><span class="o">|</span><span class="err">\</span><span class="mi">1</span><span class="o">|</span><span class="p">}</span> <span class="s2">"hello world"</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"world"</span>

<span class="nn">Str</span><span class="p">.</span><span class="n">split</span> <span class="p">(</span><span class="nn">Str</span><span class="p">.</span><span class="n">regexp</span> <span class="s2">"[ </span><span class="se">\t</span><span class="s2">]+"</span><span class="p">)</span> <span class="s2">"hello world"</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="s2">"hello"</span><span class="p">;</span> <span class="s2">"world"</span><span class="p">]</span>
</code></pre></div></div>

<p>I hope the examples are self-explanatory. <code class="language-plaintext highlighter-rouge">Str</code>’s API is quite similar to what you’d find in most imperative
languages, which is part of the reason the library is frowned upon.</p>

<p><strong>Tip:</strong> If you find string literals like <code class="language-plaintext highlighter-rouge">{|foo bar|}</code> strange, please consult <a href="https://batsov.com/articles/2023/04/20/learning-ocaml-quoted-string-literals/">this article</a>.</p>

<p>I won’t dwell much on <code class="language-plaintext highlighter-rouge">Str</code> as few people use it these days, especially if they need to do more
complex tasks with regular expressions. Enter the <a href="https://github.com/ocaml/ocaml-re">Re</a> library.
Before we do something with <code class="language-plaintext highlighter-rouge">Re</code> we’ll need to install it:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam <span class="nb">install </span>re
</code></pre></div></div>

<p>One interesting thing about <code class="language-plaintext highlighter-rouge">Re</code> is that it supports various flavors of regular expressions:</p>

<ul>
  <li>Perl-style regular expressions (module <code class="language-plaintext highlighter-rouge">Re.Perl</code>);</li>
  <li>Posix extended regular expressions (module <code class="language-plaintext highlighter-rouge">Re.Posix</code>);</li>
  <li>Emacs-style regular expressions (module <code class="language-plaintext highlighter-rouge">Re.Emacs</code>);</li>
  <li>Shell-style file globbing (module <code class="language-plaintext highlighter-rouge">Re.Glob</code>).</li>
</ul>

<p>Okay, shell globbing is not exactly regular expressions, and I’m not sure who would want to use Emacs style regular expressions
outside Emacs, but you sure have options! I’m a big fan of Perl’s regular expressions, so I’ll stick with them going forward.</p>

<p>Now, let’s see it in action (I encourage to try the examples below in <code class="language-plaintext highlighter-rouge">utop</code>):</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">require</span> <span class="s2">"re"</span><span class="p">;;</span>

<span class="c">(* basic matching *)</span>
<span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Perl</span><span class="p">.</span><span class="n">re</span> <span class="s2">"[0-9]+"</span> <span class="o">|&gt;</span> <span class="nn">Re</span><span class="p">.</span><span class="n">compile</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">text</span> <span class="o">=</span> <span class="s2">"hello123world"</span> <span class="k">in</span>
<span class="k">match</span> <span class="nn">Re</span><span class="p">.</span><span class="n">exec_opt</span> <span class="n">re</span> <span class="n">text</span> <span class="k">with</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="n">group</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Matched: %s</span><span class="se">\n</span><span class="s2">"</span> <span class="p">(</span><span class="nn">Re</span><span class="p">.</span><span class="nn">Group</span><span class="p">.</span><span class="n">get</span> <span class="n">group</span> <span class="mi">0</span><span class="p">)</span>
<span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"No match</span><span class="se">\n</span><span class="s2">"</span>
<span class="p">;;</span>

<span class="c">(* replace matches *)</span>
<span class="k">let</span> <span class="n">replace_digits</span> <span class="n">str</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Perl</span><span class="p">.</span><span class="n">re</span> <span class="s2">"[0-9]+"</span> <span class="o">|&gt;</span> <span class="nn">Re</span><span class="p">.</span><span class="n">compile</span> <span class="k">in</span>
  <span class="nn">Re</span><span class="p">.</span><span class="n">replace_string</span> <span class="n">re</span> <span class="o">~</span><span class="n">by</span><span class="o">:</span><span class="s2">"#"</span>
    <span class="n">str</span>
<span class="p">;;</span>

<span class="n">print_endline</span> <span class="p">(</span><span class="n">replace_digits</span> <span class="s2">"hello123world456"</span><span class="p">);;</span>

<span class="c">(* use matching groups *)</span>
<span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Perl</span><span class="p">.</span><span class="n">re</span> <span class="s2">"(</span><span class="se">\\</span><span class="s2">w+)-(</span><span class="se">\\</span><span class="s2">d+)"</span> <span class="o">|&gt;</span> <span class="nn">Re</span><span class="p">.</span><span class="n">compile</span> <span class="k">in</span>
<span class="k">match</span> <span class="nn">Re</span><span class="p">.</span><span class="n">exec_opt</span> <span class="n">re</span> <span class="s2">"item-42"</span> <span class="k">with</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="n">group</span> <span class="o">-&gt;</span>
    <span class="k">let</span> <span class="n">name</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Group</span><span class="p">.</span><span class="n">get</span> <span class="n">group</span> <span class="mi">1</span> <span class="k">in</span>
    <span class="k">let</span> <span class="n">number</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Group</span><span class="p">.</span><span class="n">get</span> <span class="n">group</span> <span class="mi">2</span> <span class="k">in</span>
    <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"name: %s, number: %s</span><span class="se">\n</span><span class="s2">"</span> <span class="n">name</span> <span class="n">number</span>
<span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">"No match"</span>
<span class="p">;;</span>

<span class="c">(* composable regular expressions *)</span>
<span class="k">let</span> <span class="n">word</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="n">rep1</span> <span class="nn">Re</span><span class="p">.</span><span class="n">wordc</span><span class="p">;;</span>
<span class="k">let</span> <span class="n">dash</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="n">char</span> <span class="k">'</span><span class="o">-</span><span class="k">'</span> <span class="p">;;</span>
<span class="k">let</span> <span class="n">digits</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="n">rep1</span> <span class="nn">Re</span><span class="p">.</span><span class="n">digit</span><span class="p">;;</span>

<span class="k">let</span> <span class="n">re</span> <span class="o">=</span>
  <span class="nn">Re</span><span class="p">.</span><span class="n">seq</span> <span class="p">[</span><span class="n">word</span><span class="p">;</span> <span class="n">dash</span><span class="p">;</span> <span class="n">digits</span><span class="p">]</span> <span class="o">|&gt;</span> <span class="nn">Re</span><span class="p">.</span><span class="n">compile</span>
<span class="p">;;</span>

<span class="k">let</span> <span class="n">input</span> <span class="o">=</span> <span class="s2">"hello-123"</span> <span class="k">in</span>
<span class="k">match</span> <span class="nn">Re</span><span class="p">.</span><span class="n">exec_opt</span> <span class="n">re</span> <span class="n">input</span> <span class="k">with</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="n">g</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="p">(</span><span class="s2">"Matched: "</span> <span class="o">^</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Group</span><span class="p">.</span><span class="n">get</span> <span class="n">g</span> <span class="mi">0</span><span class="p">)</span>
<span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">print_endline</span> <span class="s2">"No match"</span>
<span class="p">;;</span>

<span class="c">(* iterate over all matches *)</span>
<span class="k">let</span> <span class="n">re</span> <span class="o">=</span> <span class="nn">Re</span><span class="p">.</span><span class="nn">Perl</span><span class="p">.</span><span class="n">re</span> <span class="s2">"</span><span class="se">\\</span><span class="s2">d+"</span> <span class="o">|&gt;</span> <span class="nn">Re</span><span class="p">.</span><span class="n">compile</span><span class="p">;;</span>

<span class="k">let</span> <span class="n">all_matches</span> <span class="n">str</span> <span class="o">=</span>
  <span class="nn">Re</span><span class="p">.</span><span class="n">all</span> <span class="n">re</span> <span class="n">str</span>
  <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">g</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Match: %s</span><span class="se">\n</span><span class="s2">"</span> <span class="p">(</span><span class="nn">Re</span><span class="p">.</span><span class="nn">Group</span><span class="p">.</span><span class="n">get</span> <span class="n">g</span> <span class="mi">0</span><span class="p">))</span>
<span class="p">;;</span>

<span class="n">all_matches</span> <span class="s2">"a1 b22 c333"</span><span class="p">;;</span>
</code></pre></div></div>

<p>I hope it’s clear that <code class="language-plaintext highlighter-rouge">Re</code> allows you to program in a more functional way.
I’ve barely scratched the surface here, as the library has pretty big API,
that everyone serious about it should eventually explore.
Below is a list of its most useful combinators:</p>

<table>
  <thead>
    <tr>
      <th>Combinator</th>
      <th>Meaning</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.char c</code></td>
      <td>Match a single char</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.string s</code></td>
      <td>Match exact string</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.alt [r1; r2]</code></td>
      <td>Alternation (r1 | r2)</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.seq [r1; r2]</code></td>
      <td>Concatenation (r1 r2)</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.rep r</code></td>
      <td>Zero or more (<code class="language-plaintext highlighter-rouge">r*</code>)</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.rep1 r</code></td>
      <td>One or more (<code class="language-plaintext highlighter-rouge">r+</code>)</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.opt r</code></td>
      <td>Optional (<code class="language-plaintext highlighter-rouge">r?</code>)</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.group r</code></td>
      <td>Capture group</td>
    </tr>
    <tr>
      <td><code class="language-plaintext highlighter-rouge">Re.compile</code></td>
      <td>Compile the regex</td>
    </tr>
  </tbody>
</table>

<p>And here’s a brief comparison of <code class="language-plaintext highlighter-rouge">Str</code> vs <code class="language-plaintext highlighter-rouge">Re</code>:</p>

<table>
  <thead>
    <tr>
      <th>Feature</th>
      <th><code class="language-plaintext highlighter-rouge">Str</code> (legacy)</th>
      <th><code class="language-plaintext highlighter-rouge">Re</code> (modern)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Availability</td>
      <td>Built-in (kind of)</td>
      <td>External library (<code class="language-plaintext highlighter-rouge">re</code> package)</td>
    </tr>
    <tr>
      <td>API Style</td>
      <td>Imperative, stateful</td>
      <td>Functional, composable</td>
    </tr>
    <tr>
      <td>Regex Flavor</td>
      <td>POSIX-like</td>
      <td>Multiple backends (<code class="language-plaintext highlighter-rouge">Perl</code>, <code class="language-plaintext highlighter-rouge">Str</code>, <code class="language-plaintext highlighter-rouge">Emacs</code>, etc.)</td>
    </tr>
    <tr>
      <td>Unicode support</td>
      <td>Poor</td>
      <td>Better (though OCaml string handling is limited)</td>
    </tr>
    <tr>
      <td>Match iteration</td>
      <td>Awkward (<code class="language-plaintext highlighter-rouge">search_forward</code> loop)</td>
      <td>Elegant (<code class="language-plaintext highlighter-rouge">Re.all</code>, <code class="language-plaintext highlighter-rouge">Re.iter</code>)</td>
    </tr>
    <tr>
      <td>Replacement</td>
      <td>String only</td>
      <td>Function or string</td>
    </tr>
    <tr>
      <td>Error messages</td>
      <td>Vague</td>
      <td>Clear, structured</td>
    </tr>
    <tr>
      <td>Composability</td>
      <td>Poor (regexp strings only)</td>
      <td>Excellent (regex combinators like <code class="language-plaintext highlighter-rouge">seq</code>, <code class="language-plaintext highlighter-rouge">alt</code>)</td>
    </tr>
  </tbody>
</table>

<p>To sum it up:</p>

<ul>
  <li>Use <code class="language-plaintext highlighter-rouge">Str</code> only if you want zero dependencies and can tolerate legacy, clunky APIs.</li>
  <li>Use <code class="language-plaintext highlighter-rouge">Re</code> if you care about code clarity, safety, composability, and are okay with pulling in an external dependency (which you should be in 2025).</li>
</ul>

<p>That article sat in my backlog for quite a while, as regular expressions were
one of the most frustrating aspects for me when I started to play with OCaml
(Perl and Ruby had really spoiled me on that front), but eventually I kind of
got used to them, so I no longer felt much need to write the article. Still,
I hope some newcomers to OCaml will find it userful!</p>

<p>That’s all I have for you today. Keep hacking!</p>
