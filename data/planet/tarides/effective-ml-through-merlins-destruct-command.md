---
title: Effective ML Through Merlin's Destruct Command
description: "The Merlin server and OCaml LSP server, two closely related OCaml language\nservers,
  enhance productivity with features like autocompletion\u2026"
url: https://tarides.com/blog/2024-05-29-effective-ml-through-merlin-s-destruct-command
date: 2024-05-29T00:00:00-00:00
preview_image: https://tarides.com/static/4123dfc5b00bfca3183c9f29a639a40f/7d5a2/destruct.jpg
authors:
- Tarides
source:
---

<p>The Merlin server and OCaml LSP server, two closely related OCaml language
servers, enhance productivity with features like autocompletion and type
inference. Their lesser known, yet highly useful <code>destruct</code> command simplifies
the use of pattern matching by generating exhaustive match statements, as we&rsquo;ll
illustrate in this article. The command has recently received a bit of love,
making it more usable, and we are taking advantage of this refresh to introduce
it and showcase some use cases.</p>
<p>A <em>good</em> IDE for a programming language ought to provide contextual information,
such as completion suggestions, details about expressions like types, and
real-time error feedback. However, in an ideal world, it should also serve as a
code-writing assistant, capable of generating code as needed. And even though
there are undeniably commonalities among a broad range of programming languages,
allowing for the &quot;generalisation&quot; of interactions with a code editor via a
protocol (such as <a href="https://github.com/ocaml/ocaml-lsp">LSP</a>), some languages
possess uncommon or even unique functionalities that require special
treatment. Fortunately, it is possible to develop functionalities tailored to
these particularities. These can be invoked within LSP through <strong>custom
requests</strong> to retrieve arbitrary information and <strong>code actions</strong> to transform a
document as needed. Splendid! However, such functionality can be more difficult
to discover, as it somewhat denormalises the IDE user experience. This is the
case with the <code>destruct</code> command, which is immensely useful and saves a great
deal of time.</p>
<p>In this article, we'll attempt to fathom of the command's usefulness and its
application using somewhat simplistic examples. Following that, we'll delve into
a few less artificial examples that I use in my day-to-day coding. I hope that
the article is useful and entertaining both for people who already know
<code>destruct</code> and for people who don't.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct-in-broad-terms" aria-label="destruct in broad terms permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct in Broad Terms</h2>
<p>OCaml allows the expression of <a href="https://ocamlbook.org/algebraic-types/">algebraic data
types</a> that, coupled with <a href="https://ocaml.org/docs/basic-data-types">pattern
matching</a>, can be used to describe data
structures and perform case analysis. In the event that a pattern match falls
short of being exhaustive, <strong>warning 8</strong>, known as <code>partial-match</code>, will be
raised during the compilation phase. Hence, it is advisable to uphold exhaustive
match blocks.</p>
<p>The <code>destruct</code> command aids in achieving completeness. When applied to a pattern
(via <code>M-x merlin-destruct</code> in Emacs, <code>:MerlinDestruct</code> in Vim, and <code>Alt + d</code> in
Visual Studio Code), it generates patterns. The command behaves differently
depending on the cursor&rsquo;s context:</p>
<ul>
<li>
<p>When it is called on an expression, it replaces it by a pattern match over
its constructors.</p>
</li>
<li>
<p>When it is called on a pattern of a non-exhaustive matching, it will make the
pattern matching exhaustive by adding missing cases.</p>
</li>
<li>
<p>When it is called on a wildcard pattern, it will refine it if possible.</p>
</li>
</ul>
<blockquote>
<p>For those unfamiliar with the term <code>destruct</code>, pattern matching is case
analysis, and expressing the form (a collection of patterns) on which you
<em>match</em> is called <strong>destructuring</strong>, because you are unpacking values from
structured data. This is the same terminology <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment">used in
JavaScript</a>.</p>
</blockquote>
<p>Let's examine each of these scenarios using examples.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct-on-an-expression" aria-label="destruct on an expression permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct on an Expression</h3>
<p>Destructing an expression works in a fairly obvious way. If the typechecker is
aware of the expression type (in our example, it knows this by
inference), the expression will be substituted by a matching on all enumerable
cases.</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-1.gif" alt="Destruct on expression"/>
</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct-on-a-non-exhaustive-matching" aria-label="destruct on a non exhaustive matching permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct on a Non-Exhaustive Matching</h3>
<p>The second behaviour is, in my opinion, the most practical. Although I rarely
need to substitute an expression with a pattern match, I often want to perform a
case analysis on all the constructors of a sum type. By implementing just a
single pattern, such as <code>Foo</code>, my match expression is non-exhaustive, and if I
<code>destruct</code> on this, it will generate all the missing cases.</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-2.gif" alt="Destruct on non-exhaustive match"/>
</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct-on-a-wildcard-pattern" aria-label="destruct on a wildcard pattern permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct on a Wildcard Pattern</h3>
<p>The final behaviour is very similar to the previous one; when you <code>destruct</code> a
wildcard pattern (or a pattern producing a wildcard, for example, a variable
declaration), the command will generate all the missing branches.</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-3.gif" alt="Destruct on wildcard"/>
</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#dealing-with-nesting" aria-label="dealing with nesting permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Dealing With Nesting</h3>
<p>When used interactively, it is possible to destruct nested patterns to quickly
achieve exhaustiveness. For example, let&rsquo;s imagine that our variable <code>x</code> is of
type <code>t option</code>:</p>
<ul>
<li>We start by destructing our wildcard (<code>_</code>), which will produce two branches,
<code>None</code> and <code>Some _</code>.</li>
<li>Then, we can destruct on the associated wildcard of <code>Some _</code>, which will
produce all conceivable cases for the type <code>t</code>.</li>
</ul>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-4.gif" alt="Destruct on nested patterns"/>
</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#in-the-case-of-products-instead-of-sums" aria-label="in the case of products instead of sums permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In the Case of Products (Instead of Sums)</h3>
<p>In the previous examples, we were always dealing with cases whose domains are
perfectly defined, only destructing cases of simple sum type branches. However,
the <code>destruct</code> command can also act on products. Let's consider a very ambitious
example where we will make exhaustive pattern matching on a value of type <code>t * t option</code>, generating all possible cases using <code>destruct</code> alone :</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-5.gif" alt="Destruct on nested tuples"/>
</p>
<p>It can be seen that when used interactively, the command saves a lot of time,
and coupled with Merlin's real-time feedback regarding errors, one can quickly
ascertain when our pattern matching is exhaustive. In a way, it's a bit like a
manual &quot;deriver.&quot;</p>
<p>The <code>destruct</code> command can act on any pattern, so it also works within function
arguments (although <a href="https://github.com/ocaml/ocaml/pull/12236">their representation has
changed</a> slightly for <code>5.2.0</code>), and
in addition to destructing tuples, it is also possible to destruct records,
which can be very useful for our quest for exhaustiveness!</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-6.gif" alt="Destruct on nested records"/>
</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#when-the-set-of-constructors-is-non-finite" aria-label="when the set of constructors is non finite permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>When the Set of Constructors is Non-Finite</h3>
<p>Sometimes types are not finitely enumerable. For example, how
are we to handle strings or even integers? In such situations, <code>destruct</code> will
attempt to find an example. For integers, it will be <code>0</code>, and for strings, it
will be the empty string.</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-7.gif" alt="Destruct on non-enumerable values"/>
</p>
<p>Excellent! We have covered a large portion of the behaviors of the <code>destruct</code>
command, which are quite contextually relevant. There are others (such as cases
of destruction in the presence of GADTs that only generate subsets of patterns),
but it's time to move on to an example from the real world!</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#the-quest-for-exhaustiveness-effective-ml" aria-label="the quest for exhaustiveness effective ml permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The Quest for Exhaustiveness: Effective ML</h2>
<p>In 2010, <a href="https://x.com/yminsky">Yaron Minsky</a> gave an <a href="https://www.youtube.com/watch?v=-J8YyfrSwTk">excellent
presentation</a> on the reasons (and
advantages) for using OCaml at <a href="https://www.janestreet.com/">Jane Street</a>. In
addition to being highly inspiring, it provides specific insights and gotchas on
using OCaml effectively in an incredibly sensitive industrial context (hence the
name &quot;Effective ML&quot;.)! It was in this presentation that the maxim &quot;<em>Make
illegal states unrepresentable</em>&quot; was publicly mentioned for the first time, a
phrase that would later be frequently used to promote other technologies (such
as <a href="https://www.youtube.com/watch?v=IcgmSRJHu_8">Elm</a>). Moreover, the
presentation anticipates many discussions on domain modeling, which are dear to
the <a href="https://en.wikipedia.org/wiki/Software_craftsmanship">Software Craftsmanship
community</a>, by proposing
strategies for domain reduction (later extensively developed in
the book <a href="https://pragprog.com/titles/swdddf/domain-modeling-made-functional/"><em>Domain Modeling Made
Functional</em></a>).</p>
<p>Among the list of effective approaches to using an ML language, Yaron presents a
scenario where one might too hastily use the wildcard in a case analysis. The
example is closely tied to finance, but it's easy to transpose into a simpler
example. We will implement an <code>equal</code> function for a very basic type:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span> 
  <span class="token operator">|</span> Foo
  <span class="token operator">|</span> Bar</code></pre></div>
<p>The <code>equal</code> function can be trivially implemented as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> equal a b <span class="token operator">=</span> 
  <span class="token keyword">match</span> <span class="token punctuation">(</span>a<span class="token punctuation">,</span> b<span class="token punctuation">)</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> Foo<span class="token punctuation">,</span> Foo <span class="token operator">-&gt;</span> <span class="token boolean">true</span>
  <span class="token operator">|</span> Bar<span class="token punctuation">,</span> Bar <span class="token operator">-&gt;</span> <span class="token boolean">true</span>
  <span class="token operator">|</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token boolean">false</span></code></pre></div>
<p>Our function works perfectly and is exhaustive. However, what happens if we add
a constructor to our type <code>t</code>?</p>
<div class="gatsby-highlight" data-language="diff"><pre class="language-diff"><code class="language-diff"><span class="token unchanged"><span class="token prefix unchanged"> </span> type t
<span class="token prefix unchanged"> </span>   | Foo
<span class="token prefix unchanged"> </span>   | Bar
</span><span class="token inserted-sign inserted"><span class="token prefix inserted">+</span>   | Baz</span></code></pre></div>
<p>Our function, in the case of <code>equal Baz Baz</code>, will return <code>false</code>, which is
obviously not the expected behavior. Since the wildcard makes our function
exhaustive, <strong>the compiler won't raise any errors</strong>. That's why Yaron Minsky
argues that in many cases with a wildcard clause, it's probably a mistake. If
our function had been exhaustive, adding a constructor would have raised a
<code>partial-match</code> warning, forcing us to explicitly decide how to behave in the
presence of the new constructor! Therefore, using a wildcard in this context
<strong>deprives us of the fearless refactoring</strong>, which is a strength of OCaml. This
is indeed an argument in favor of using a preprocessor to generate equality
functions, using, for example <a href="https://github.com/ocaml-ppx/ppx_deriving?tab=readme-ov-file#plugins-eq-and-ord">the <code>eq</code> standard
deriver</a>
or the more hygienic <a href="https://github.com/janestreet/ppx_compare"><code>Ppx_compare</code></a>.
But sometimes, using a preprocessor is not possible. Fortunately, the <code>destruct</code>
command can assist us in defining an exhaustive equality function!</p>
<p>We will proceed step by step, specifically separating the different cases and
using nested pattern matching to make the various cases easy to express in a
recurrent manner:</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-8.gif" alt="Destruct for equal on Foo and Bar"/>
</p>
<p>As we can see, <code>destruct</code> allows us to quickly implement an exhaustive <code>equal</code>
function without relying on wildcards. Now, we can add our <code>Baz</code> constructor to
see how the refactoring unfolds! By adding a constructor, we quickly detect a
recurring pattern where we try to give the <code>destruct</code> command <strong>as much leeway
as possible</strong> to generate the missing patterns!</p>
<p align="center">
<img src="https://tarides.com/blog/2024-05-21.merlin-destruct//merlin-destruct-9.gif" alt="Destruct for equal on Foo, Bar and Baz"/>
</p>
<p>Fantastic! We were able to quickly implement an <code>equal</code> function. Adding a
new case is trivial, leaving <code>destruct</code> to handle all the work!</p>
<p>Coupled with modern text editing features (e.g., using multi-cursors),
it's possible to save a tremendous amount of time! Another example of the
immoderate use of <code>destruct</code> (but too long to be detailed in this article) was
the <a href="https://github.com/xhtmlboi/yocaml/blob/main/lib/yocaml/mime.ml">Mime</a> module
implementation in <a href="https://github.com/xhtmlboi/yocaml">YOCaml</a> for generating RSS feeds.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#in-conclusion" aria-label="in conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>In Conclusion</h2>
<p>Paired with a formatter like
<a href="https://github.com/ocaml-ppx/ocamlformat">OCamlFormat</a> (to neatly reformat
generated code fragments), <code>destruct</code> is an unconventional tool in the IDE
landscape. It aligns with algebraic types and pattern matching to simplify code
writing and move towards code that is easier to refactor and thus maintain!
Aware of the command's utility, the <a href="https://github.com/ocaml/merlin">Merlin</a>
team continues to maintain it, streamlining the latest features of OCaml to make
the command as usable as possible in as many contexts as possible!</p>
<p>I hope this collection of illustrated examples has motivated you to use the <code>destruct</code>
feature if you were not already aware of it. Please do not hesitate to send
us ideas for improvements,
fixes, and <strong>fun use cases</strong> via <a href="https://twitter.com/tarides_">X</a> or
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a>!</p>
<p><em>Happy Hacking</em>.</p>
<blockquote>
<blockquote>
<p><a href="https://tarides.com/company">Contact Tarides</a> to see how OCaml can benefit your business and/or for support while learning OCaml. Follow us on <a href="https://twitter.com/tarides_">Twitter</a> and <a href="https://www.linkedin.com/company/tarides/">LinkedIn</a> to ensure you never miss a post, and join the OCaml discussion on <a href="https://discuss.ocaml.org/">Discuss</a>!</p>
</blockquote>
</blockquote>
