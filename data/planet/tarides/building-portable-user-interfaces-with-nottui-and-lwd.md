---
title: Building portable user interfaces with Nottui and Lwd
description: "At Tarides, we build many tools and writing UI is usually a tedious
  task. In this post we will see how to write functional UIs in OCaml\u2026"
url: https://tarides.com/blog/2020-09-24-building-portable-user-interfaces-with-nottui-and-lwd
date: 2020-09-24T00:00:00-00:00
preview_image: https://tarides.com/static/06fbdcdb40efa879b814b744c5ea3fbf/fcfee/nottui-rain.png
featured:
---

<p>At Tarides, we build many tools and writing UI is usually a tedious task. In this post we will see how to write functional UIs in OCaml using the <code>Nottui</code> &amp; <code>Lwd</code> libraries.</p>
<p>These libraries were developed for <a href="https://github.com/ocurrent/citty">Citty</a>, a frontend to the <a href="https://github.com/ocurrent/ocaml-ci">Continuous Integration service</a> of OCaml Labs.</p>
<div>
  <video controls="controls" width="100%">
    <source src="./nottui-citty.mp4" type="video/mp4"></source>
    <source src="./nottui-citty.webm" type="video/webm;codecs=vp9"></source>
  </video>
</div>
<p>In this recording, you can see the lists of repositories, branches and jobs monitored by the CI service, as well as the result of job execution. Most of the logic is asynchronous, with all the contents being received from the network in a non-blocking way.</p>
<p><code>Nottui</code> extends <a href="https://github.com/pqwy/notty">Notty</a>, a library for declaring terminal images, to better suit the needs of UIs. <code>Lwd</code> (Lightweight Document) exposes a simple form of reactive computation (values that evolve over time). It can be thought of as an alternative to the DOM, suitable for building interactive documents.
They are used in tandem: <code>Nottui</code> for rendering the UI and <code>Lwd</code> for making it interactive.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#nottui--notty-with-layout-and-events" aria-label="nottui  notty with layout and events permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Nottui = Notty with layout and events</h2>
<p>Notty exposes a nice way to display images in a terminal. A Notty image is matrix of characters with optional styling attributes (tweaking foreground and background colors, using <strong>bold</strong> glyphs...).</p>
<p>These images are pure values and can be composed (concatenated, cropped, ...) very efficiently, making them very convenient to manipulate in a functional way.</p>
<p>However these images are inert: their contents are fixed and their only purpose is to be displayed. Nottui reuses Notty images and exposes essentially the same interface but it adds two features: layout &amp; event dispatch. UI elements now adapt to the space available and can react to keyboard and mouse actions.</p>
<p><strong>Layout DSL</strong>. Specifying a layout is done using &quot;stretchable&quot; dimensions, a concept loosely borrowed from TeX. Each UI element has a fixed size (expressed as a number of columns and rows) and a stretchable size (possibly empty). The stretchable part is interpreted as a strength that is used to determine how to share the space available among all UI elements.</p>
<p>This is a simple system amenable to an efficient implementation while being powerful enough to express common layout patterns.</p>
<p><strong>Event dispatch</strong>. Reacting to mouse and keyboard events is better done using local behaviors, specific to an element. In Nottui, images are augmented with handlers for common actions. There is also a global notion of focus to determine which element should consume input events.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#interactivity-with-lwd" aria-label="interactivity with lwd permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Interactivity with Lwd</h2>
<p>Nottui's additions are nice for resizing and attaching behaviors to images, but they are still static objects. In practice, user interfaces are very dynamic: parts can be independently updated to display new information.</p>
<p>This interactivity layer is brought by Lwd and is developed separately from the core UI library. It is built around a central type, <code>'a Lwd.t</code>, that represents a value of type <code>'a</code> that can change over time.</p>
<p><code>Lwd.t</code> is an <a href="https://en.wikipedia.org/wiki/Applicative_functor">applicative functor</a> (and even a monad), making it a highly composable abstraction.</p>
<p>Primitive changes are introduced by <code>Lwd.var</code>, which are OCaml references with an extra operation <code>val get : 'a Lwd.var -&gt; 'a Lwd.t</code>. This operation turns a variable into a <em>changing value</em> that changes whenever the variable is set.</p>
<p>In practice this leads to a mostly declarative style of programming interactive documents (as opposed to the DOM that is deeply mutable). Most of the code is just function applications without spooky action at a distance! However, it is possible to opt-out of this pure style by introducing an <code>Lwd.var</code>, on a case-by-case basis.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#and-much-more" aria-label="and much more permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>And much more...</h2>
<p>A few extra libraries are provided to target more specific problems.</p>
<p><code>Lwd_table</code> and <code>Lwd_seq</code> are two datastructures to manipulate dynamic collections. <code>Nottui_pretty</code> is an interactive pretty printing library that supports arbitrary Nottui layouts and widgets. Finally <code>Tyxml_lwd</code> is a strongly-typed abstraction of the DOM driven by Lwd.</p>
<p>Version 0.1 has just been released on OPAM.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#getting-started" aria-label="getting started permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Getting started!</h2>
<p>Here is a small example to start using the library. First, install the Nottui library:</p>
<div class="gatsby-highlight" data-language="sh"><pre class="language-sh"><code class="language-sh">$ opam install nottui</code></pre></div>
<p>Now we can play in the top-level. We will start with a simple button that counts the number of clicks:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token operator">$</span> utop
# <span class="token directive important">#require</span> <span class="token string">&quot;nottui&quot;</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">open</span> <span class="token module variable">Nottui</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">module</span> W <span class="token operator">=</span> <span class="token module variable">Nottui_widgets</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* State for holding the number of clicks *)</span>
# <span class="token keyword">let</span> vcount <span class="token operator">=</span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>var <span class="token number">0</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Image of the button parametrized by the number of clicks *)</span>
# <span class="token keyword">let</span> button count <span class="token operator">=</span>
    W<span class="token punctuation">.</span>button <span class="token label function">~attr</span><span class="token punctuation">:</span><span class="token module variable">Notty</span><span class="token punctuation">.</span>A<span class="token punctuation">.</span><span class="token punctuation">(</span>bg green <span class="token operator">++</span> fg black<span class="token punctuation">)</span>
      <span class="token punctuation">(</span><span class="token module variable">Printf</span><span class="token punctuation">.</span>sprintf <span class="token string">&quot;Clicked %d times!&quot;</span> count<span class="token punctuation">)</span>
      <span class="token punctuation">(</span><span class="token keyword">fun</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>set vcount <span class="token punctuation">(</span>count <span class="token operator">+</span> <span class="token number">1</span><span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Run the UI! *)</span>
# <span class="token module variable">Ui_loop</span><span class="token punctuation">.</span>run <span class="token punctuation">(</span><span class="token module variable">Lwd</span><span class="token punctuation">.</span>map button <span class="token punctuation">(</span><span class="token module variable">Lwd</span><span class="token punctuation">.</span>get vcount<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span></code></pre></div>
<p><strong>Note:</strong> to quit the example, you can press Ctrl-Q or Esc.</p>
<p>We will improve the example and turn it into a mini cookie clicker game.</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token comment">(* Achievements to unlock in the cookie clicker *)</span>
# <span class="token keyword">let</span> badges <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token number">15</span><span class="token punctuation">,</span> <span class="token string">&quot;Cursor&quot;</span><span class="token punctuation">;</span> <span class="token number">50</span><span class="token punctuation">,</span> <span class="token string">&quot;Grandma&quot;</span><span class="token punctuation">;</span> <span class="token number">150</span><span class="token punctuation">,</span> <span class="token string">&quot;Farm&quot;</span><span class="token punctuation">;</span> <span class="token number">300</span><span class="token punctuation">,</span> <span class="token string">&quot;Mine&quot;</span><span class="token punctuation">]</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* List the achievements unlocked by the player *)</span>
# <span class="token keyword">let</span> unlocked_ui count <span class="token operator">=</span>
    <span class="token comment">(* Filter the achievements *)</span>
    <span class="token keyword">let</span> predicate <span class="token punctuation">(</span>target<span class="token punctuation">,</span> text<span class="token punctuation">)</span> <span class="token operator">=</span>
      <span class="token keyword">if</span> count <span class="token operator">&gt;=</span> target
      <span class="token keyword">then</span> <span class="token module variable">Some</span> <span class="token punctuation">(</span>W<span class="token punctuation">.</span>printf <span class="token string">&quot;% 4d: %s&quot;</span> target text<span class="token punctuation">)</span>
      <span class="token keyword">else</span> <span class="token module variable">None</span>
    <span class="token keyword">in</span>
    <span class="token comment">(* Concatenate the UI elements vertically *)</span>
    <span class="token module variable">Ui</span><span class="token punctuation">.</span>vcat <span class="token punctuation">(</span><span class="token module variable">List</span><span class="token punctuation">.</span>filter_map predicate badges<span class="token punctuation">)</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Display the next achievement to reach *)</span>
# <span class="token keyword">let</span> next_ui count <span class="token operator">=</span>
    <span class="token keyword">let</span> predicate <span class="token punctuation">(</span>target<span class="token punctuation">,</span> <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token operator">=</span> target <span class="token operator">&gt;</span> ciybt <span class="token keyword">in</span>
    <span class="token keyword">match</span> <span class="token module variable">List</span><span class="token punctuation">.</span>find_opt predicate badges <span class="token keyword">with</span>
    <span class="token operator">|</span> <span class="token module variable">Some</span> <span class="token punctuation">(</span>target<span class="token punctuation">,</span> <span class="token punctuation">_</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
      W<span class="token punctuation">.</span>printf <span class="token label function">~attr</span><span class="token punctuation">:</span><span class="token module variable">Notty</span><span class="token punctuation">.</span>A<span class="token punctuation">.</span><span class="token punctuation">(</span>st bold<span class="token punctuation">)</span> <span class="token string">&quot;% 4d: ???&quot;</span> target
    <span class="token operator">|</span> <span class="token module variable">None</span> <span class="token operator">-&gt;</span> <span class="token module variable">Ui</span><span class="token punctuation">.</span>empty<span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Let's make use of the fancy let-operators recently added to OCaml *)</span>
# <span class="token keyword">open</span> <span class="token module variable">Lwd_infix</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
# <span class="token keyword">let</span> ui <span class="token operator">=</span>
    <span class="token keyword">let</span><span class="token operator">$</span> count <span class="token operator">=</span> <span class="token module variable">Lwd</span><span class="token punctuation">.</span>get vcount <span class="token keyword">in</span>
    <span class="token module variable">Ui</span><span class="token punctuation">.</span>vcat <span class="token punctuation">[</span>button count<span class="token punctuation">;</span> unlocked_ui count<span class="token punctuation">;</span> next_ui count<span class="token punctuation">]</span><span class="token punctuation">;</span><span class="token punctuation">;</span>
<span class="token comment">(* Launch the game! *)</span>
# <span class="token module variable">Ui_loop</span><span class="token punctuation">.</span>run ui<span class="token punctuation">;</span><span class="token punctuation">;</span></code></pre></div>
<div>
  <video controls="controls">
    <source src="./nottui-cookie-clicker.mp4" type="video/mp4"></source>
    <source src="./nottui-cookie-clicker.webm" type="video/webm;codecs=vp9"></source>
  </video>
</div>
<p>Et voil&agrave;! We hope you enjoy experimenting with <code>Nottui</code> and <code>Lwd</code>. Check out the <a href="https://github.com/let-def/lwd/tree/master/lib/nottui">Nottui page</a> for more examples, and watch our recent presentation of these libraries at the 2020 ML Workshop here:</p>
<div style="position: relative; width: 100%; height: 0; padding-bottom: 56.25%">
  <iframe style="position: absolute; width: 100%; height: 100%; left: 0; right: 0" src="https://www.youtube-nocookie.com/embed/w7jc35kgBZE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen">
  </iframe>
</div>
