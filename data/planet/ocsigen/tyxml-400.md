---
title: TyXML 4.0.0
description:
url: https://ocsigen.github.io/blog/2016/05/20/tyxml4/
date: 2016-05-20T00:00:00-00:00
preview_image:
featured:
authors:
- The Ocsigen Team
---

<p>It is with great pleasure that we are announcing the release of <a href="https://github.com/ocsigen/tyxml/releases/tag/4.0.0">TyXML 4.0.0</a>. The major features of this new release are a new PPX syntax extension that allows to use the standard HTML syntax and an improved user experience for both old and new TyXML users.</p>

<h2>What is TyXML ?</h2>

<p>TyXML is a library for building statically correct HTML5 and SVG documents.
It provides a set of combinators which use the OCaml type system to ensure the validity of the generated document. TyXML&rsquo;s combinators can be used to build textual HTML and SVG, but also DOM trees or reactive interfaces, using <a href="https://ocsigen.org/eliom/manual/clientserver-html">Eliom</a> and <a href="https://ocsigen.org/js_of_ocaml/api/Tyxml_js">Js_of_ocaml</a>.</p>

<h2>New TyXML manual and improved documentation</h2>

<p>A new TyXML manual is now available <a href="https://ocsigen.org/tyxml/4.0/manual/intro">here</a>. The documentation of the various TyXML modules was also improved. Do not hesitate to provide feedback via <a href="https://github.com/ocsigen/tyxml/issues">our bug tracker</a>!</p>

<h2>HTML syntax with the new PPX syntax extension</h2>

<p>It is now possible to use the standard HTML syntax:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">open</span> <span class="nc">Tyxml</span>
<span class="k">let</span><span class="o">%</span><span class="n">html</span> <span class="n">to_ocaml</span> <span class="o">=</span> <span class="s2">&quot;&lt;a href='ocaml.org'&gt;OCaml!&lt;/a&gt;&quot;</span></code></pre></figure>

<p>It supports insertion of OCaml code inside the HTML and can be used with all the TyXML modules (such as <a href="https://ocsigen.org/js_of_ocaml/api/Tyxml_js">Js_of_ocaml</a> and <a href="https://ocsigen.org/eliom/manual/clientserver-html">Eliom</a>) and with SVG. A complete overview can be found <a href="https://ocsigen.org/tyxml/4.0/manual/ppx">in the manual</a>.</p>

<p>This new PPX syntax extension leverages the (awesome) <a href="https://github.com/aantron/markup.ml">Markup.ml</a> library and was contributed by <a href="https://github.com/aantron">Anton Bachin</a>.</p>

<h2>Others</h2>

<ul>
  <li>Toplevel printers are now available for the base HTML and SVG implementations:</li>
</ul>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="o">#</span> <span class="nn">Tyxml</span><span class="p">.</span><span class="nn">Html</span><span class="p">.(</span><span class="n">div</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Oh!&quot;</span><span class="p">])</span> <span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Div</span> <span class="p">]</span> <span class="nn">Tyxml</span><span class="p">.</span><span class="nn">Html</span><span class="p">.</span><span class="n">elt</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">div</span><span class="o">&gt;</span><span class="nc">Oh</span><span class="o">!&lt;/</span><span class="n">div</span><span class="o">&gt;</span></code></pre></figure>

<ul>
  <li>
    <p>The HTML and SVG combinators have received numerous improvements to make them more consistent and easier to use. This means that several modules and functions have been renamed and some types have been changed, which breaks compatibility with previous TyXML versions.</p>
  </li>
  <li>
    <p>A healthy amount of new elements and attributes.</p>
  </li>
  <li>
    <p>The full changelog is available <a href="https://github.com/ocsigen/tyxml/releases/tag/4.0.0">here</a>.</p>
  </li>
</ul>

<h2>Compatibility</h2>

<p>This new version breaks compatibility. Compatible versions of <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> and Eliom are available in the respective <code class="language-plaintext highlighter-rouge">master</code> branches.
A compatible <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> version should be released shortly&trade;.</p>

<p>TyXML 4.0.0 is only available on OCaml &gt;= 4.02.</p>

<h2>The future</h2>

<p>While nothing is decided yet, some work has already started to enhance the syntax extension with <a href="https://github.com/ocsigen/tyxml/pull/128">type safe templating</a>.</p>

<p>Happy HTML and SVG hacking!</p>

