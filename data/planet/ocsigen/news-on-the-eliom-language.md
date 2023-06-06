---
title: News on the Eliom language
description:
url: https://ocsigen.github.io/blog/2017/02/06/eliomlang/
date: 2017-02-06T00:00:00-00:00
preview_image:
featured:
authors:
- Gabriel `Drup` Radanne
---

<p>The <a href="https://ocsigen.org/eliom/">Eliom framework</a> is the part of the <a href="https://ocsigen.org">ocsigen project</a> that aims to provide
high level libraries for developing client/server web applications.
It contains a <a href="https://ocsigen.org/eliom/6.1/manual/ppx-syntax">language extension</a> of OCaml that allows implementing both the client
and the server parts of your application as a single program. It also
contains <a href="https://ocsigen.org/eliom/manual/">several libraries and utilities</a> to facilitate web programming.</p>

<p>The various Ocsigen libraries have received a lot of care
lately. Notably, we have reworked the <a href="https://ocsigen.github.io/blog/2016/12/12/eliom6/">service API</a>, we
have added support for mobile applications and, we have developed
<a href="https://github.com/ocsigen/ocsigen-start">ocsigen-start</a>.</p>

<p>Today, I will not talk about the ocsigen libraries. I will talk solely about
the language extension.</p>

<h2>The current language extension</h2>

<p>The Eliom language extension extends OCaml with various annotations that
allows specifying where things are to be defined and executed.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">server</span> <span class="n">s</span> <span class="o">=</span> <span class="mi">1</span> <span class="o">+</span> <span class="mi">2</span> <span class="c">(* I'm executed on the server *)</span>
<span class="k">let</span><span class="o">%</span><span class="n">server</span> <span class="n">s2</span> <span class="o">=</span> <span class="c">(* I'm declared on the server *)</span>
  <span class="p">[</span><span class="o">%</span><span class="n">client</span> <span class="mi">1</span> <span class="o">+</span> <span class="mi">2</span> <span class="c">(* But I will be executed on the client! *)</span> <span class="p">]</span>
<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">c</span> <span class="o">=</span>
  <span class="o">~%</span><span class="n">s</span> <span class="o">+</span> <span class="o">~%</span><span class="n">s2</span> <span class="o">+</span> <span class="mi">1</span>
  <span class="c">(* I access values on the server and execute things on the client! *)</span></code></pre></figure>

<p>The semantics is that the server part is executed first,
then the web page is sent to the client,
then the client part is executed.
See <a href="https://ocsigen.org/eliom/6.1/manual/ppx-syntax">the documentation</a> for detail on the current extension.</p>

<p>The language extension is currently implemented using a PPX extension and
a custom (and a bit sophisticated) compilation scheme. Note here that I used
the word &ldquo;language&rdquo; extension on purpose: this is not a simple syntax extension,
the Eliom language has its own type system, semantics and compilation
scheme, which are extensions of the OCaml ones.</p>

<p>The current implementation of our language, based on PPX, started to
show its limits in terms of flexibility, convenience and with respect to
the safety guarantees it can provide. This is why I started, as part
of my PhD thesis, to redesign and improve it.</p>

<h2>Formalizing the Eliom language</h2>

<p>Our first goal was to formalize the Eliom language as an extension of the OCaml
language. Formalizing the language allowed us to better understand its type 
system and semantics, which led to various improvements and bug fixes.
The formalization was <a href="https://hal.archives-ouvertes.fr/hal-01349774">published in APLAS 2016</a>. In this paper,
we present a (rather simple) type system based on two distinct type
universes and the notion of converters, that allows passing values from
the server to the client. We also show that the intuitive semantics
of Eliom, that server code is executed immediately and client code is executed
later in the exact same order it was encountered, does correspond to the
compilation scheme used to slice Eliom programs into a server program and a
client program.</p>

<p>In the the current implementation, when passing
a server value of type <code class="language-plaintext highlighter-rouge">Foo.t</code> to the client. It also has type <code class="language-plaintext highlighter-rouge">Foo.t</code>,
but the type is now the one available on the client. The actual object
can also be transformed while passing the client/server boundary using
<a href="https://ocsigen.org/eliom/6.1/manual/clientserver-wrapping">wrappers</a>. Unfortunately, this API is very difficult to use, not
flexible and quite unsafe. Instead, we propose to use converters.
Converters can be though as a pair of function: a server serialization
function <code class="language-plaintext highlighter-rouge">ty_server -&gt; string</code> and a client deserialization function
<code class="language-plaintext highlighter-rouge">string -&gt; ty_client</code> (the actual implementation will be a bit different to make (de)serializer composable).
The correctness of a converter depends of course on the good behavior of these
two functions, but the language guarantees that they will be used together
properly and each sides will properly respect the types of the converter.</p>

<p>By using converters, we can provide a convenient programming model and make
Eliom much easier to extend. We demonstrated this with multiple examples in
<a href="https://hal.archives-ouvertes.fr/hal-01407898">another paper published in IFL 2016</a>.
Unfortunately, a proper implementation of converters is only possible
with some form of ad-hoc polymorphism, which involve using modular implicits.</p>

<h2>Implementing the Eliom language</h2>

<p>In order to actually implement all these new things, I started to work on an
extension of the OCaml compiler capable of handling the Eliom language
constructs. Working directly in the compiler has several advantages:</p>

<ul>
  <li>We can implement the actual type system of Eliom directly.</li>
  <li>Easier to extend with new features.</li>
  <li>Much better error messages.</li>
  <li>A simpler and faster compilation scheme.</li>
</ul>

<p>The current work-in-progress compiler is available in the repository
<a href="https://github.com/ocsigen/ocaml-eliom">ocsigen/ocaml-eliom</a>. A minimal runtime,
along with various
associated tools are available in <a href="https://github.com/ocsigen/eliomlang">ocsigen/eliomlang</a>.
A (perpetually broken) playground containing an extremely bare-bone
website using eliomlang without the complete framework is available in <a href="https://github.com/ocsigen/eliomlang-playground">ocsigen/eliomlang-playground</a>.</p>

<p>Finally, the work on using this new compiler to compile the Eliom framework can be followed via <a href="https://github.com/ocsigen/eliom/pull/459">this pull-request</a>.</p>

<h2>Going further</h2>

<p>A more in-depth presentation of the Eliom language can be found <a href="https://www.irif.fr/~gradanne/papers/eliom/talk_gallium.pdf">here</a>.
The <a href="https://hal.archives-ouvertes.fr/hal-01349774">APLAS paper</a> is quite formal and is mostly aimed at people
that want to really understand the minute details of the language. The
<a href="https://hal.archives-ouvertes.fr/hal-01407898">IFL paper</a>, on the other hand, should be accessible to most OCaml programmers
(even those who don&rsquo;t know Eliom) and demonstrates how to use the new Eliom
constructs to build nice, tierless and typesafe libraries for client/server
web programming.</p>

<h2>The future</h2>

<p>The work on the Eliom language is far from done. A current area of work
is to extend the OCaml module language to be aware of the Eliom annotations.
A particularly delicate (but promising!) area is the ability to use
Eliom annotations inside functors.
A second area of work is that of stabilizing, debugging and documenting the patched compiler.
Finally, a difficulty raised by this new compiler is that existing build systems,
and in particular ocamlbuild, do not handle the Eliom compilation scheme
very well. Some details on this can be found <a href="https://github.com/ocsigen/eliom/pull/459">here</a>.</p>

<p>I wish this progress report has awaken your appetite for well-typed
and modular tierless programming in OCaml. I hope I will be able to
share more news in a few months.</p>

<p>Happy Eliom programming!</p>

