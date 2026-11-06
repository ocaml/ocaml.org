---
title: 'Neocaml 0.11: OxCaml, Indentation Styles, and odoc'
description: "I\u2019m happy to announce that neocaml 0.11 is out! I never got around
  to writing about 0.10, which was mostly about neocaml-utop (a utop backend that
  talks to utop via its native editor protocol), but 0.11 is a different story."
url: https://batsov.com/articles/2026/11/05/neocaml-0-11-oxcaml-indentation-styles-and-odoc/
date: 2026-11-05T05:30:00-00:00
preview_image: https://batsov.com/assets/img/og-image.png
authors:
- Bozhidar Batsov
source:
ignore:
keywords:
- OCaml LSP
- c-c
- eio
- indentation
- melange
- neocaml
- ocamlformat
- odoc
- oxcaml
- utop
---

<p>I’m happy to announce that <a href="https://github.com/bbatsov/neocaml/releases/tag/v0.11.0">neocaml 0.11</a> is out! I never got around
to writing about 0.10, which was mostly about <code class="language-plaintext highlighter-rouge">neocaml-utop</code> (a <a href="https://github.com/ocaml-community/utop"><code class="language-plaintext highlighter-rouge">utop</code></a>
backend that talks to <code class="language-plaintext highlighter-rouge">utop</code> via its native editor protocol), but 0.11 is a
different story. Its changelog is twice as long as that of any release before
it, and by now I’ve stopped pretending that a grand 1.0 is just around the
corner.<sup><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote" role="doc-noteref">1</a></sup> There’s a lot in there, but three things stand out for me - OxCaml
support, indentation styles, and much better support for documentation. Here’s
why…</p>



<h2>OxCaml</h2>

<p><a href="https://oxcaml.org/">OxCaml</a> is Jane Street’s set of extensions to OCaml - modes and
modalities, kinds, unboxed types, stack allocation and so on. You can use them
today with an OxCaml compiler switch, and Jane Street’s libraries use them all
over the place. A lot of the heavy lifting happened upstream, as
<a href="https://github.com/tree-sitter/tree-sitter-ocaml"><code class="language-plaintext highlighter-rouge">tree-sitter-ocaml</code></a> 0.26 learned to parse OxCaml, and
<a href="https://github.com/tmcgilchrist">Tim McGilchrist</a> bumped neocaml’s grammars to it. <a href="https://github.com/314eter">Pieter
Goetschalckx</a> (the <code class="language-plaintext highlighter-rouge">tree-sitter-ocaml</code> maintainer) once again cut an
<a href="https://github.com/tree-sitter/tree-sitter-ocaml/tree/v0.26.0-abi14">ABI 14 build</a> of the release, so we didn’t have to break anyone’s
Emacs. (see the <a href="https://batsov.com/articles/2026/06/24/neocaml-0-9-repl-completion-and-robustness/">0.9 post</a>
for the whole ABI saga) Huge thanks to both of them!</p>

<p>A grammar that parses the code is only half of the job, though. Here’s a bit of
OxCaml:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
2
3
4
5
6
7
</pre></td><td class="rouge-code"><pre><span class="k">type</span> <span class="n">point</span> <span class="o">:</span> <span class="n">immutable_data</span> <span class="o">=</span> <span class="p">{</span> <span class="n">x</span> <span class="o">:</span> <span class="kt">float</span><span class="p">;</span> <span class="n">y</span> <span class="o">:</span> <span class="kt">float</span> <span class="p">}</span>

<span class="k">type</span> <span class="n">vec</span> <span class="o">=</span> <span class="o">#</span><span class="p">{</span> <span class="n">dx</span> <span class="o">:</span> <span class="kt">float</span><span class="o">#;</span> <span class="n">dy</span> <span class="o">:</span> <span class="kt">float</span><span class="o">#</span> <span class="p">}</span>

<span class="k">let</span> <span class="n">length</span> <span class="p">(</span><span class="n">xs</span> <span class="o">@</span> <span class="n">local</span><span class="p">)</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">length</span> <span class="n">xs</span>

<span class="k">let</span> <span class="n">make</span> <span class="bp">()</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">@</span> <span class="n">local</span> <span class="o">=</span> <span class="n">exclave_</span> <span class="p">[</span> <span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span> <span class="p">]</span>
</pre></td></tr></tbody></table></code></pre></div></div>

<p>neocaml now highlights and indents all of this. The new keywords (<code class="language-plaintext highlighter-rouge">stack_</code>,
<code class="language-plaintext highlighter-rouge">exclave_</code>, <code class="language-plaintext highlighter-rouge">local_</code>, <code class="language-plaintext highlighter-rouge">global_</code>, <code class="language-plaintext highlighter-rouge">borrow_</code> and <code class="language-plaintext highlighter-rouge">kind_</code>), modes and modalities,
kinds, unboxed types and literals (<code class="language-plaintext highlighter-rouge">float#</code>, <code class="language-plaintext highlighter-rouge">#1.0</code>, <code class="language-plaintext highlighter-rouge">#(...)</code>), immutable
arrays (<code class="language-plaintext highlighter-rouge">[: ... :]</code>) and comprehensions are all covered. The indentation
follows the way <a href="https://github.com/ocaml-ppx/ocamlformat"><code class="language-plaintext highlighter-rouge">ocamlformat</code></a> lays out Jane Street’s own OxCaml
libraries (e.g. <code class="language-plaintext highlighter-rouge">portable</code>, <code class="language-plaintext highlighter-rouge">unique</code> and <code class="language-plaintext highlighter-rouge">parallel</code>), which is why the body of
an <code class="language-plaintext highlighter-rouge">exclave_</code> isn’t indented, while those of <code class="language-plaintext highlighter-rouge">stack_</code> and <code class="language-plaintext highlighter-rouge">local_</code> are.<sup><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote" role="doc-noteref">2</a></sup>
Kind definitions also show up in imenu and work with the defun navigation
commands.</p>

<p>If you don’t write OxCaml, nothing changes for you - plain OCaml looks exactly
the way it did before. If you do, there’s nothing to turn on in neocaml. Just
make sure Emacs sees your OxCaml switch and you’ll get its <a href="https://github.com/ocaml/ocaml-lsp"><code class="language-plaintext highlighter-rouge">ocamllsp</code></a>
and <code class="language-plaintext highlighter-rouge">ocamlformat</code> as well. The <a href="https://neocaml.org/usage/#oxcaml">docs</a> have all the details.</p>

<h2>Indentation styles</h2>

<p>Here’s a confession - neocaml’s indentation used to be a bit of a mix. Some
layouts followed <code class="language-plaintext highlighter-rouge">ocamlformat</code>’s <code class="language-plaintext highlighter-rouge">conventional</code> profile, some followed
<code class="language-plaintext highlighter-rouge">janestreet</code>, and a few followed neither. That’s a problem, as OCaml doesn’t
have one indentation style everyone follows. <code class="language-plaintext highlighter-rouge">ocamlformat</code> ships several
profiles, Jane Street’s code doesn’t look like the compiler’s, and plenty of
projects never run a formatter at all.</p>

<p>So 0.11 lets you pick one of three styles via <code class="language-plaintext highlighter-rouge">neocaml-indent-style</code>:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">ocp-indent</code>, which indents the way <a href="https://github.com/OCamlPro/ocp-indent"><code class="language-plaintext highlighter-rouge">ocp-indent</code></a> does out of the box</li>
  <li><code class="language-plaintext highlighter-rouge">conventional</code>, after <code class="language-plaintext highlighter-rouge">ocamlformat</code>’s default profile (used by ocaml.org, ppxlib and Irmin)</li>
  <li><code class="language-plaintext highlighter-rouge">janestreet</code>, after <code class="language-plaintext highlighter-rouge">ocamlformat</code>’s <code class="language-plaintext highlighter-rouge">janestreet</code> profile (used by Jane Street’s libraries, <a href="https://dune.build/"><code class="language-plaintext highlighter-rouge">dune</code></a> and <code class="language-plaintext highlighter-rouge">ocaml-lsp</code>)</li>
</ul>

<p>They agree on most things and differ on a handful of layouts, e.g. how far the
body of a match case goes:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><table class="rouge-table"><tbody><tr><td class="rouge-gutter gl"><pre class="lineno">1
2
3
4
5
6
7
8
9
10
11
</pre></td><td class="rouge-code"><pre><span class="c">(* ocp-indent and janestreet *)</span>
<span class="k">match</span> <span class="n">value</span> <span class="k">with</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="n">payload</span> <span class="o">-&gt;</span>
  <span class="n">finish</span> <span class="n">payload</span>
<span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="mi">0</span>

<span class="c">(* conventional *)</span>
<span class="k">match</span> <span class="n">value</span> <span class="k">with</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="n">payload</span> <span class="o">-&gt;</span>
    <span class="n">finish</span> <span class="n">payload</span>
<span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="mi">0</span>
</pre></td></tr></tbody></table></code></pre></div></div>

<p>The best part is that most of the time you won’t have to pick a style yourself.
By default neocaml looks for the project’s <code class="language-plaintext highlighter-rouge">.ocamlformat</code> and picks the style
that matches its <code class="language-plaintext highlighter-rouge">profile</code> (it also respects <code class="language-plaintext highlighter-rouge">cases-exp-indent</code>). Without an
<code class="language-plaintext highlighter-rouge">.ocamlformat</code> it checks for an <code class="language-plaintext highlighter-rouge">.ocp-indent</code> file, and without either you get
the <code class="language-plaintext highlighter-rouge">ocp-indent</code> style, as that’s what most projects that don’t use
<code class="language-plaintext highlighter-rouge">ocamlformat</code> indent with. (e.g. <a href="https://opam.ocaml.org/"><code class="language-plaintext highlighter-rouge">opam</code></a>, Rocq, Frama-C, Eio and the
compiler itself) You can
also set the style per project in <code class="language-plaintext highlighter-rouge">.dir-locals.el</code>, or switch it for the
current buffer with <code class="language-plaintext highlighter-rouge">M-x neocaml-set-indent-style</code>.</p>

<p>I also wanted to know how well all of this works on real code, instead of
guessing. So I wrote a couple of small scripts (they live in <code class="language-plaintext highlighter-rouge">dev/</code>) that format
a bunch of OCaml files with each <code class="language-plaintext highlighter-rouge">ocamlformat</code> profile and count the lines
neocaml would indent differently. I ran them on the almost 300 files of the
<code class="language-plaintext highlighter-rouge">opam</code> packages in my default switch (mostly Jane Street’s <code class="language-plaintext highlighter-rouge">base</code>), and 0.10
didn’t look great. About one line in ten had no indentation rule at all, so
<code class="language-plaintext highlighter-rouge">TAB</code> simply left it wherever you typed it, and only 81.9% of the lines landed
where <code class="language-plaintext highlighter-rouge">ocamlformat</code>’s <code class="language-plaintext highlighter-rouge">conventional</code> profile puts them (77.8% for <code class="language-plaintext highlighter-rouge">janestreet</code>).
Ouch! With the matching style, 0.11 gets 97.5% and 98% of them right.<sup><a href="https://batsov.com/feeds/OCaml.xml#fn:3" class="footnote" rel="footnote" role="doc-noteref">3</a></sup> Not
perfect, but pretty close!</p>

<p>Keep in mind that indentation only places the lines you’ve broken, it doesn’t
break them for you. If you run <code class="language-plaintext highlighter-rouge">ocamlformat</code> on save it has the final word
anyway, but with the matching style less of what you type moves around when
you save.</p>

<h2>odoc and doc comments</h2>

<p>The third big theme is documentation. A few months ago <a href="https://github.com/mlemerre">mlemerre</a>
suggested (<a href="https://github.com/bbatsov/neocaml/issues/60">#60</a>) that neocaml should render the <code class="language-plaintext highlighter-rouge">ocamldoc</code> markup in
comments, instead of showing it as a soup of braces. I loved the idea, and in
0.11 doc comments finally look like documentation - <code class="language-plaintext highlighter-rouge">{b bold}</code> is bold, <code class="language-plaintext highlighter-rouge">{i
italic}</code> is italic, <code class="language-plaintext highlighter-rouge">[code]</code>, <code class="language-plaintext highlighter-rouge">{[ ... ]}</code> and <code class="language-plaintext highlighter-rouge">{@ocaml[ ... ]}</code> are shown as
code, and <code class="language-plaintext highlighter-rouge">{!references}</code> and tags like <code class="language-plaintext highlighter-rouge">@param</code> get faces of their own. This
is the new <code class="language-plaintext highlighter-rouge">doc-markup</code> font-lock feature, and it’s enabled at the default
font-lock level.</p>

<p>Tim also contributed <code class="language-plaintext highlighter-rouge">neocaml-odoc-mode</code> (<a href="https://github.com/bbatsov/neocaml/pull/46">#46</a>) for <a href="https://github.com/ocaml/odoc"><code class="language-plaintext highlighter-rouge">odoc</code></a>’s
standalone <code class="language-plaintext highlighter-rouge">.mld</code> documentation pages, built on Tim’s own <a href="https://github.com/tmcgilchrist/tree-sitter-odoc">Tree-sitter grammar
for <code class="language-plaintext highlighter-rouge">odoc</code></a>. You get font-lock for headings, inline markup,
references, links, tags, lists and tables, plus indentation and imenu. On
Emacs 30+ the code in <code class="language-plaintext highlighter-rouge">{@ocaml[...]}</code>, <code class="language-plaintext highlighter-rouge">{@dune[...]}</code> and <code class="language-plaintext highlighter-rouge">{@opam[...]}</code> blocks
is highlighted as well, using the grammars for those languages. Run <code class="language-plaintext highlighter-rouge">M-x
neocaml-odoc-install-grammar</code> to get started, and check out the
<a href="https://neocaml.org/odoc/">docs</a> for more.</p>

<p>While I was at it, I also fixed <code class="language-plaintext highlighter-rouge">M-q</code> and <code class="language-plaintext highlighter-rouge">M-j</code> in comments. Embarrassingly,
<code class="language-plaintext highlighter-rouge">M-q</code> used to always fill the first paragraph of a comment, no matter where you
were in it, and it merged code blocks into the text around them. <code class="language-plaintext highlighter-rouge">M-j</code> now
continues the <code class="language-plaintext highlighter-rouge">*</code> of comments that start each line with one.</p>

<h2>Grab Bag</h2>

<p>Those are just the highlights, of course. Here are a few more things that I
think you’ll like:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">neocaml-mlx-mode</code> for <code class="language-plaintext highlighter-rouge">.mlx</code> files (<a href="https://github.com/ocaml-mlx/mlx">OCaml with JSX</a>, as used by
<a href="https://melange.re/">Melange</a> and React), contributed by <a href="https://github.com/akirak">Akira Komamura</a></li>
  <li>commands for running the tests of the current file and dealing with <code class="language-plaintext highlighter-rouge">dune</code>’s
promotions (<code class="language-plaintext highlighter-rouge">C-c C-o T</code>, <code class="language-plaintext highlighter-rouge">C-c C-o =</code> and <code class="language-plaintext highlighter-rouge">C-c C-o P</code>), with their own
bindings in <code class="language-plaintext highlighter-rouge">neocaml-cram-mode</code></li>
  <li>the toplevel’s responses in the REPL are now highlighted with Tree-sitter,
just like your code</li>
  <li>each <code class="language-plaintext highlighter-rouge">dune</code> project in a monorepo gets its own REPL</li>
  <li><code class="language-plaintext highlighter-rouge">neocaml-format-buffer</code> replaces only the text that changed, so point and
the window positions stay put</li>
</ul>

<h2>Upgrading</h2>

<p>Most setups will keep working just fine, but a few changes in this release
require some action on your part:</p>

<ul>
  <li>neocaml needs <code class="language-plaintext highlighter-rouge">tree-sitter-ocaml</code> 0.26 now, so reinstall the OCaml grammars
with <code class="language-plaintext highlighter-rouge">C-u M-x neocaml-install-grammars</code>. The <code class="language-plaintext highlighter-rouge">dune</code> grammar moved to its new
home, <a href="https://github.com/ocaml-dune/tree-sitter-dune"><code class="language-plaintext highlighter-rouge">ocaml-dune/tree-sitter-dune</code></a>, so reinstall it as well
with <code class="language-plaintext highlighter-rouge">C-u M-x neocaml-dune-install-grammar</code>. neocaml will warn you if your
grammars are too old.</li>
  <li>Some keybindings clashed with <a href="https://github.com/tarides/ocaml-eglot"><code class="language-plaintext highlighter-rouge">ocaml-eglot</code></a> and
<a href="https://github.com/ocaml/merlin"><code class="language-plaintext highlighter-rouge">merlin</code></a>, so they had to move. In
the REPL minor modes sending the phrase at point is now <code class="language-plaintext highlighter-rouge">C-c C-e</code>, sending it
and moving to the next one <code class="language-plaintext highlighter-rouge">C-c C-s</code>, loading the file <code class="language-plaintext highlighter-rouge">C-c C-u</code> and
interrupting the toplevel <code class="language-plaintext highlighter-rouge">C-c C-q</code>. The <code class="language-plaintext highlighter-rouge">dune</code> commands moved from <code class="language-plaintext highlighter-rouge">C-c C-d</code>
to <code class="language-plaintext highlighter-rouge">C-c C-o</code>.</li>
  <li>The default indentation changed. If your project uses neither <code class="language-plaintext highlighter-rouge">ocamlformat</code>
nor <code class="language-plaintext highlighter-rouge">ocp-indent</code> a few layouts will move, so set <code class="language-plaintext highlighter-rouge">neocaml-indent-style</code> if the
<code class="language-plaintext highlighter-rouge">ocp-indent</code> style is not your cup of tea.</li>
</ul>

<h2>Epilogue</h2>

<p>With OxCaml, mlx and <code class="language-plaintext highlighter-rouge">odoc</code> on board, neocaml now covers pretty much every kind
of OCaml file I can think of. Famous last words, right?</p>

<p>So, what’s next? I don’t really have any big plans for 0.12. I’d like to switch
<code class="language-plaintext highlighter-rouge">neocaml-mlx-mode</code> to the dedicated grammar from
<a href="https://github.com/ocaml-mlx/tree-sitter-mlx"><code class="language-plaintext highlighter-rouge">tree-sitter-mlx</code></a> once it has an ABI 14 release, and there’s
the usual pile of smaller ideas in the <a href="https://github.com/bbatsov/neocaml/blob/main/ROADMAP.md">roadmap</a>. No promises, though.</p>

<p>Big thanks to <a href="https://github.com/tmcgilchrist">Tim McGilchrist</a>, who did a ton of work on the grammars
(OCaml, <code class="language-plaintext highlighter-rouge">dune</code>, <code class="language-plaintext highlighter-rouge">opam</code> and <a href="https://gallium.inria.fr/~fpottier/menhir/"><code class="language-plaintext highlighter-rouge">menhir</code></a>) and the <code class="language-plaintext highlighter-rouge">odoc</code> support! Thanks
to <a href="https://github.com/akirak">Akira Komamura</a> for bringing mlx to neocaml, and to <a href="https://github.com/dalz">Alessio
Duè</a> for fixing a sexp navigation bug! And thanks to everyone who reported problems
and shared ideas - many of the improvements in 0.11 started as an issue on
GitHub.</p>

<p>As usual - update from <a href="https://melpa.org/#/neocaml">MELPA</a>, play with it, and
let me know how it goes. The full list of changes is in the <a href="https://github.com/bbatsov/neocaml/releases/tag/v0.11.0">release
notes</a>.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li>
      <p>See the <a href="https://batsov.com/articles/2026/03/25/neocaml-0-6-opam-dune-and-more/">0.6 post</a> for how that went the last time.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩︎</a></p>
    </li>
    <li>
      <p>That’s how <code class="language-plaintext highlighter-rouge">ocamlformat</code> formats Jane Street’s code, and I’ve learned to trust it more than my own intuition here.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩︎</a></p>
    </li>
    <li>
      <p>That’s about 77,000 lines formatted with <code class="language-plaintext highlighter-rouge">ocamlformat</code> 0.27.0. The numbers depend on the code and the ocamlformat version, so take them with a grain of salt.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:3" class="reversefootnote" role="doc-backlink">↩︎</a></p>
    </li>
  </ol>
</div>
