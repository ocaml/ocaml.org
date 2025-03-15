---
title: 'neocaml: a new Emacs package for OCaml programming'
description: "I wasn\u2019t an early adopter of TreeSitter in Emacs, as usually such
  big transitions are not smooth and the initial support for TreeSitter in Emacs left
  much to be desired. Recently, however, Emacs 30 was released with many improvements
  on that front, and I felt the time was right for me to (try to) embrace TreeSitter."
url: https://batsov.com/articles/2025/03/14/neocaml-a-new-emacs-package-for-ocaml-programming/
date: 2025-03-14T08:01:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>I wasn’t an early adopter of <a href="https://www.masteringemacs.org/article/how-to-get-started-tree-sitter">TreeSitter in Emacs</a>, as usually such
big transitions are not smooth and the initial support for TreeSitter in
Emacs left much to be desired. Recently, however, Emacs 30 was released with many
improvements on that front, and I felt the time was right for me to (try to) embrace
TreeSitter.</p>

<p>I’m the type of person who likes to learn by deliberate practice, that’s why I
wanted to do some work on TreeSitter-powered major modes. I’ve already been a
co-maintainer of
<a href="https://github.com/clojure-emacs/clojure-ts-mode">clojure-ts-mode</a> for a while
now, and I picked up the basics around it, but I didn’t spend much time hacking
on it until recently. After spending a bit more time studying the current
implementation of <code class="language-plaintext highlighter-rouge">clojure-ts-mode</code> and the various Emacs TreeSitter APIs, I decided to
start a new experimental project from scratch -
<a href="https://github.com/bbatsov/neocaml">neocaml</a>, a TreeSitter-powered package for
OCaml development.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup></p>

<p>Why did I start a new OCaml package, when there are already a few existing out
there? Because <code class="language-plaintext highlighter-rouge">caml-mode</code> is ancient (and probably has to be deprecated), and
<code class="language-plaintext highlighter-rouge">tuareg-mode</code> is a beast. (it’s very powerful, but also very complex) The time
seems ripe for a modern, leaner, TreeSitter-powered mode for OCaml.</p>

<p>There have been two other attempts to create TreeSitter-powered
major modes for Emacs, but they didn’t get very far:</p>

<ul>
  <li><a href="https://github.com/dmitrig/ocaml-ts-mode">ocaml-ts-mode</a> (first one, available in MELPA)</li>
  <li><a href="https://github.com/terrateamio/ocaml-ts-mode">ocaml-ts-mode</a> (second one)</li>
</ul>

<p>Looking at the code of both modes, I inferred that the authors were probably knowledgable in
OCaml, but not very familiar with Emacs Lisp and Emacs major modes in general.
For me it’s the other way around, and that’s what makes this a fun and interesting project for me:</p>

<ul>
  <li>I enjoy working on Emacs packages</li>
  <li>As noted above I want to do more work TreeSitter</li>
  <li>I really like OCaml and it’s one of my favorite “hobby” languages</li>
</ul>

<p>One last thing - we really need more Emacs packages with fun names! :D Naming is hard, and I’m
notorious “bad” at it!<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote">2</a></sup></p>

<p>They say that third time’s the charm, and I hope that <code class="language-plaintext highlighter-rouge">neocaml</code> will get farther than
the other <code class="language-plaintext highlighter-rouge">ocaml-ts-mode</code>s. Time will tell!</p>

<p>I’ve documented the code extensively inline, and in the README you’ll find my development notes detailing
some of my decisions, items that need further work and research, etc. If nothing else - I think
anyone can learn a bit about how TreeSitter works in Emacs and what are the common challenges
that one might face when working with it. To summarize my experience so far:</p>

<ul>
  <li>font-locking (syntax highlighting) with TreeSitter is fairly easy</li>
  <li>structured navigation seems reasonably straight-forward as well</li>
  <li>the indentation queries are a bit more complicated, but they are definitely not black magic</li>
</ul>

<p>Fundamentally, the main problem is that we still don’t have
easy ways to try out TreeSitter queries in Emacs, so there’s a lot of trial and error involved. (especially when it
comes to indentation logic) My other big problem is that most TreeSitter grammars
have pretty much no documentation, you one has to learn about their AST format
via experimentation (e.g. <code class="language-plaintext highlighter-rouge">treesit-explore-mode</code> and <code class="language-plaintext highlighter-rouge">treesit-inspect-mode</code>) and
reading their bundled queries for font-locking and indentation. As someone who’s
used to work with Ruby parser I really miss the docs and tools that come with
something like the Ruby <a href="https://github.com/whitequark/parser">parser</a> library.</p>

<p>What’s the state of project right now? Well, <code class="language-plaintext highlighter-rouge">neocaml</code> kind of works right now,
but the indentation logic needs a lot of polish, and I’ve yet to implement
properly structured navigation and some of the newer Emacs TreeSitter APIs
(e.g. <code class="language-plaintext highlighter-rouge">things</code>).  We can always “cheat” a bit with the indentation, by
delegating it to another Emacs package like <code class="language-plaintext highlighter-rouge">ocp-indent.el</code> or even Tuareg, but
I’m hoping to come up with a self-contained TreeSitter implementation in the end
of the day.</p>

<p>If you’re feeling adventurous you can easily install the package like this:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>M-x package-vc-install &lt;RET&gt; https://github.com/bbatsov/neocaml &lt;RET&gt;
</code></pre></div></div>

<p>In Emacs 30 you can you <code class="language-plaintext highlighter-rouge">use-package</code> to both install the package from GitHub
and configure it:</p>

<div class="language-emacs-lisp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">(</span><span class="nb">use-package</span> <span class="nv">neocaml</span>
  <span class="ss">:vc</span> <span class="p">(</span><span class="ss">:url</span> <span class="s">"https://github.com/bbatsov/neocaml"</span> <span class="ss">:rev</span> <span class="ss">:newest</span><span class="p">))</span>
</code></pre></div></div>

<p><strong>Note:</strong> <code class="language-plaintext highlighter-rouge">neocaml</code> will auto-install the required TreeSitter grammars the
first time one of the provided major modes is activated.</p>

<p>Please refer to the README for usage information, like the various configuration
options and interactive commands.</p>

<p>I’m not sure how much time I’ll be able to spend working on <code class="language-plaintext highlighter-rouge">neocaml</code> and how far
will I be able to push it.  Perhaps it will never amount to anything, perhaps it
will just be a research platform to bring TreeSitter support to Tuareg. And
perhaps it will become a viable simple, yet modern solution for OCaml
programming in Emacs. The dream is alive!</p>

<p>Contributions, suggestions and feedback are most welcome. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>I didnt’ name it <code class="language-plaintext highlighter-rouge">neocaml-mode</code> intentionally - many Emacs packages contain more things
than just major modes, so I prefer a more generic naming.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p>On a more serious note - there was never an <code class="language-plaintext highlighter-rouge">ocaml-mode</code>, so naming something <code class="language-plaintext highlighter-rouge">ocaml-ts-mode</code> is not
strictly needed. But I think an actual <code class="language-plaintext highlighter-rouge">ocaml-mode</code> should be blessed by the the maintainers of OCaml,
hosted in the primary GitHub org, and endorsed as a recommended way to program in OCaml with Emacs.
Pretty tall order!&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
