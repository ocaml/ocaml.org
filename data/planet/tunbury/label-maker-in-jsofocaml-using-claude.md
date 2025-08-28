---
title: Label Maker in js_of_ocaml using Claude
description: "I\u2019ve taken a few days off, and while I\u2019ve been travelling,
  I\u2019ve been working on a personal project with Claude. I\u2019ve used Claude
  Code for the first time, which is a much more powerful experience than using claude.ai
  as Claude can apply changes to the code and use your build tools directly to quickly
  iterate on a problem. In another first, I used js_of_ocaml, which has been awesome."
url: https://www.tunbury.org/2025/08/22/label-maker/
date: 2025-08-22T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I’ve taken a few days off, and while I’ve been travelling, I’ve been working on a personal project with Claude. I’ve used Claude Code for the first time, which is a much more powerful experience than using <a href="https://claude.ai">claude.ai</a> as Claude can apply changes to the code and use your build tools directly to quickly iterate on a problem. In another first, I used <code class="language-plaintext highlighter-rouge">js_of_ocaml</code>, which has been awesome.</p>

<p>The project isn’t anything special; it’s a website that creates sheets of Avery labels. It is needed for a niche educational environment where the only devices available are iPads, which are administratively locked down, so no custom applications or fonts can be loaded. You enter what you want on the label, and it initiates the download of the resulting PDF.</p>

<p>The original <a href="https://label.tunbury.org">implementation</a>, written in OCaml (of course), uses a <a href="https://ocaml.org/p/cohttp/latest">cohttp</a> web server, which generates a <a href="https://en.wikipedia.org/wiki/ReStructuredText">reStructuredText</a> file which is processed via <a href="https://rst2pdf.org">rst2pdf</a> with custom page templates for the different label layouts. The disadvantage of this approach is that it requires a server to host it. I have wrapped the application into a Docker container, so it isn’t intrusive, but it would be easier if it could be hosted as a static file on GitHub Pages.</p>

<p>On OCaml.org, I found <a href="https://ocaml.org/p/camlpdf/latest">camlpdf</a>, <a href="https://ocaml.org/p/otfm/latest">otfm</a> and <a href="https://ocaml.org/p/vg/latest">vg</a>, which when combined with <code class="language-plaintext highlighter-rouge">js_of_ocaml</code>, should give me a complete tool in the browser. The virtual file system embeds the TTF font into the JavaScript code!</p>

<p>I set Claude to work, which didn’t take long, but the custom font embedding proved problematic. I gave Claude an example PDF from the original implementation, and after some debugging, we had a working project.</p>

<p>Let’s look at the code! I should add that the labels can optionally have a box drawn on them, which the student uses to provide feedback on how they got on with the objective. Claude produced three functions for rendering text: one for a single line, one for multiline text with a checkbox, and one for multiline text without a checkbox. I pointed out that these three functions were similar and could be combined. Claude agreed and created a merged function with the original three functions calling the new merged function. It took another prompt to update the calling locations to call the new merged function rather than having the stub functions.</p>

<p>While Claude had generated code that compiles in a functional language, the code tends to look imperative; for example, there were several instances like this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">:=</span> <span class="o">!</span><span class="n">t</span> <span class="o">+</span> <span class="n">v</span><span class="p">)</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">]</span> <span class="k">in</span>
<span class="n">t</span>
</code></pre></div></div>

<p>Where we would expect to see a <code class="language-plaintext highlighter-rouge">List.fold_left</code>! Claude can easily fix these when you point them out.</p>

<p>As I mentioned earlier, Claude code can build your project and respond to <code class="language-plaintext highlighter-rouge">dune build</code> errors for you; however, some fixes suppress the warning rather than actually fixing the root cause. A classic example of this is:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>% dune build
File "bin/main.ml", line 4, characters 4-5:
4 | let x = List.length lst
        ^
Error (warning 32 [unused-value-declaration]): unused value x.
</code></pre></div></div>

<p>The proposed fix is to discard the value of <code class="language-plaintext highlighter-rouge">x</code>, thus <code class="language-plaintext highlighter-rouge">let _x = List.length lst</code> rather than realising that the entire line is unnecessary as <code class="language-plaintext highlighter-rouge">List.length</code> has no side effects.</p>

<p>I’d been using Chrome 139 for development, but thought I’d try in the native Safari on my Monterey-based based MacPro which has Safari 17.6. This gave me this error on the JavaScript console.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>[Error] TypeError: undefined is not 
  an object (evaluating 'k.UNSIGNED_MAX.udivmod')
          db (label_maker.bc.js:1758)
          (anonymous function) (label_maker.bc.js:1930)
          Global Code (label_maker.bc.js:2727:180993)
</code></pre></div></div>

<p>I found that since <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> 6.0.1 the minimum browser version is Safari 18.2, so I switched to <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> 5.9.1 and that worked fine.</p>

<p>The resulting project can be found at <a href="https://github.com/mtelvers/label-maker-js">mtelvers/label-maker-js</a> and published at <a href="https://mtelvers.github.io/label-maker-js/">mtelvers.github.io/label-maker-js</a>.</p>
