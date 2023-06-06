---
title: Highlights from recent sessions
description:
url: http://ocamllabs.github.com/compiler-hacking/2014/06/24/highlights-from-recent-sessions
date: 2014-06-24T03:00:00-00:00
preview_image:
featured:
authors:
- ocamllabs
---

<h2>Highlights from recent sessions</h2>

<p>With the <a href="http://ocamllabs.github.io/compiler-hacking/2014/06/20/sixth-compiler-hacking-session.html">next compiler hacking meeting</a> due to take place in a couple of days it's time for a look back at some results from our last couple of sessions.</p>

<p><a name="the-front-end"></a></p>

<h3>The front end</h3>

<figure style="float: right; padding: 15px; width: 350px">
<img src="https://farm3.staticflickr.com/2756/4150220583_57a993cc61_z_d.jpg" style="width: 350px" alt="Camel front end"/><br/>
<figcaption><center><small>(<a href="https://www.flickr.com/photos/paperpariah/4150220583"><i>today I stared a camel in the face</i></a> by <a href="https://www.flickr.com/photos/paperpariah/">Adam Foster</a>)</small></center></figcaption>
</figure>

<p>The front end (i.e. <a href="https://realworldocaml.org/v1/en/html/the-compiler-frontend-parsing-and-type-checking.html">the parser and type checker</a>) saw a number of enhancements.</p>

<p><a name="succinct-functor-syntax"></a></p>

<h4>Succinct functor syntax</h4>

<p>Syntax tweaks are always popular, if <a href="http://www.haskell.org/haskellwiki/Wadler's_Law">often contentious</a>.   However, reaching agreement is significantly easier when adding syntax is a simple matter of extending an existing correspondence between two parts of the language.  For example, it was clear which syntax to use when adding support for <a href="http://caml.inria.fr/pub/docs/manual-ocaml-400/manual021.html#toc73">lazy patterns</a>: since patterns generally mirror the syntax for the values they match, patterns for destructing lazy values should use the same <code>lazy</code> keyword as the expressions which construct them.</p>

<p>A second correspondence in OCaml's syntax relates modules and values.  Module names and variables are both bound with <code>=</code>; module signatures and types are both ascribed with <code>:</code>; module fields and record fields are both projected with <code>.</code>.  The syntax for functors and functions is also similar, but the latter offers a number of shortcuts not available in the module language; you can write</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">fun</span> <span class="n">x</span> <span class="n">y</span> <span class="n">z</span> <span class="o">-&gt;</span> <span class="n">e</span>
</code></pre></div>
<p>instead of the more prolix equivalent:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="k">fun</span> <span class="n">y</span> <span class="o">-&gt;</span> <span class="k">fun</span> <span class="n">z</span> <span class="o">-&gt;</span> <span class="n">e</span>
</code></pre></div>
<p>but multi-argument functors must be written out in full:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">functor</span> <span class="o">(</span><span class="nc">X</span> <span class="o">:</span> <span class="nc">R</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="nc">S</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">Z</span> <span class="o">:</span> <span class="nc">T</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="nc">M</span>
</code></pre></div>
<p>In February's meeting, <a href="http://gazagnaire.org">Thomas</a> wrote a <a href="https://github.com/ocaml/ocaml/pull/16">patch</a> that adds an analogue of the shorter syntax to the module language, allowing the repeated <code>functor</code> to be left out:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">functor</span> <span class="o">(</span><span class="nc">X</span> <span class="o">:</span> <span class="nc">R</span><span class="o">)</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="nc">S</span><span class="o">)</span> <span class="o">(</span><span class="nc">Z</span> <span class="o">:</span> <span class="nc">T</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="nc">M</span>
</code></pre></div>
<p>The patch also adds support for a corresponding abbreviation at the module type level.  Defining the type of a multi-argument functor currently involves writing a rather clunky sequence of <code>functor</code> abstractions:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">F</span> <span class="o">=</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">X</span> <span class="o">:</span> <span class="nc">R</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="nc">S</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">Z</span> <span class="o">:</span> <span class="nc">T</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="nc">U</span>
</code></pre></div>
<p>With Thomas's patch all but the first occurrence of <code>functor</code> disappear:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">F</span> <span class="o">=</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">X</span> <span class="o">:</span> <span class="nc">R</span><span class="o">)</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="nc">S</span><span class="o">)</span> <span class="o">(</span><span class="nc">Z</span> <span class="o">:</span> <span class="nc">T</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="nc">U</span>
</code></pre></div>
<p>Since Thomas's patch has been merged into trunk, you can try out the new syntax using the <a href="http://alan.petitepomme.net/cwn/2014.05.27.html#2">4.02.0 beta</a>, which is available as a compiler switch in the OPAM repository:</p>
<div class="highlight"><pre><code class="language-bash" data-lang="bash"><span></span>opam switch <span class="m">4</span>.02.0+trunk
</code></pre></div>
<p>The next step is to find out whether the verbose syntax was a symptom or a cause of the infrequency of higher-order functors in OCaml code.  Will we see a surge in the popularity of higher-order modules as the syntax becomes more accommodating?</p>

<p><a name="integer-ranges"></a></p>

<h4>Integer ranges</h4>

<p><a href="http://github.com/dsheets">David</a> started work on extending OCaml's range patterns, which currently support only characters, to support <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on#wiki-integer-range-patterns">integer ranges</a>.  For example, consider the following <a href="https://github.com/ygrek/mldonkey/blob/03896bfc/src/utils/ocamlrss/rss_date.ml#L195-L202">code from MLDonkey</a>:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">match</span> <span class="n">mdn</span> <span class="k">with</span>
  <span class="nc">None</span>       <span class="k">when</span> <span class="n">h</span> <span class="o">&gt;=</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">h</span> <span class="o">&lt;=</span> <span class="mi">23</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="n">h</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">false</span> <span class="k">when</span> <span class="n">h</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">h</span> <span class="o">&lt;=</span> <span class="mi">11</span>  <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="n">h</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">false</span> <span class="k">when</span> <span class="n">h</span> <span class="o">=</span> <span class="mi">12</span>            <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="mi">0</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">true</span>  <span class="k">when</span> <span class="n">h</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">h</span> <span class="o">&lt;=</span> <span class="mi">11</span>  <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="o">(</span><span class="n">h</span> <span class="o">+</span> <span class="mi">12</span><span class="o">)</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">true</span>  <span class="k">when</span> <span class="n">h</span> <span class="o">=</span> <span class="mi">12</span>            <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="mi">12</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="o">_</span>                            <span class="o">-&gt;</span> <span class="nc">None</span>
<span class="o">|</span> <span class="nc">None</span>                              <span class="o">-&gt;</span> <span class="nc">None</span>
</code></pre></div>
<p>Although this is fairly clear, it could be made even clearer if we had a <a href="http://en.wikipedia.org/wiki/Rule_of_least_power"><em>less</em> powerful language</a> for expressing the tests involving <code>h</code>.  Since the whole OCaml language is available in the <code>when</code> guard of a case, the reader has to examine the code carefully before concluding that the tests are all simple range checks.  Perhaps worse, using guards inhibits the useful checks that the OCaml compiler performs to determine whether patterns are exhaustive or redundant.  David's patch makes it possible to rewrite the tests without guards, making the simple nature of the tests on <code>h</code> clear at a glance (and making it possible once again to check exhaustiveness and redundancy):</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">match</span> <span class="n">mdn</span><span class="o">,</span> <span class="n">h</span> <span class="k">with</span>
  <span class="nc">None</span>      <span class="o">,</span> <span class="mi">0</span><span class="o">..</span><span class="mi">23</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">false</span><span class="o">,</span> <span class="mi">1</span><span class="o">..</span><span class="mi">11</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="n">h</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">false</span><span class="o">,</span> <span class="mi">12</span>    <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="mi">0</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">true</span> <span class="o">,</span> <span class="mi">1</span><span class="o">..</span><span class="mi">11</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="o">(</span><span class="n">h</span> <span class="o">+</span> <span class="mi">12</span><span class="o">)</span>
<span class="o">|</span> <span class="nc">Some</span> <span class="bp">true</span> <span class="o">,</span> <span class="mi">12</span>    <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="mi">12</span>
<span class="o">|</span> <span class="o">_</span>                 <span class="o">-&gt;</span> <span class="nc">None</span>
</code></pre></div>
<p>The work on range patterns led to a robust exchange of views about which other types should be supported -- should we support any enumerable type (e.g. variants with nullary constructors)? or perhaps even any ordered type (e.g. floats or strings)?  For the moment, there seems to be a much clearer consensus in favour of supporting integer types than there is for generalising range patterns any further.</p>

<p><a name="extensible-variants"></a></p>

<h4>Extensible variants</h4>

<p>Since the compiler hacking group only meets for an evening every couple of months or so, most of the <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on">projects we work on</a> are designed so that it's possible to implement them in a few hours.  <a href="http://www.lpw25.net/">Leo</a>'s proposal for extensible variants is a notable exception, <a href="https://sympa.inria.fr/sympa/arc/caml-list/2012-01/msg00050.html">predating</a> both the <a href="http://ocamllabs.github.io/compiler-hacking/2013/09/17/compiler-hacking-july-2013.html">compiler hacking group</a> and <a href="http://anil.recoil.org/2012/10/19/announcing-ocaml-labs.html">OCaml Labs</a> itself.</p>

<p>Extensible variants generalise exceptions: with Leo's patch the exception type <code>exn</code> becomes a particular instance of a class of types that can be defined by the user rather than a special builtin provided by the compiler:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="c">(* Define an extensible variant type *)</span>
<span class="k">type</span> <span class="n">exn</span> <span class="o">=</span> <span class="o">..</span>

<span class="c">(* Extend the type with a constructor *)</span>
<span class="k">type</span> <span class="n">exn</span> <span class="o">+=</span> <span class="nc">Not_found</span>

<span class="c">(* Extend the type with another constructor *)</span>
<span class="k">type</span> <span class="n">exn</span> <span class="o">+=</span> <span class="nc">Invalid_argument</span> <span class="k">of</span> <span class="kt">string</span>
</code></pre></div>
<p>Even better, extensible variants come with all the power of regular variant types: they can take type parameters, and even support GADT definitions:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="c">(* Define a parameterised extensible variant type *)</span>
<span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">error</span> <span class="o">=</span> <span class="o">..</span>

<span class="c">(* Extend the type with a constructor *)</span>
<span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">error</span> <span class="o">=</span> <span class="nc">Error</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span>

<span class="c">(* Extend the type with a GADT constructor *)</span>
<span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">error</span> <span class="o">:</span> <span class="nc">IntError</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="n">error</span>
</code></pre></div>
<p>On the evening of the last compiler hacking meeting, Leo <a href="http://caml.inria.fr/mantis/view.php?id=5584#c11335">completed</a> the patch; shortly afterwards it was <a href="https://github.com/ocaml/ocaml/commit/b56dc4b3df8d022b54f40682a9d5d4168c690413">merged to trunk</a>, ready for inclusion in <a href="http://alan.petitepomme.net/cwn/2014.05.27.html#2">OCaml 4.02</a>!</p>

<p>Extensible variants are a significant addition to the language, and there's more to them than these simple examples show.  A forthcoming post from Leo will describe the new feature in more detail.  In the meantime, since they've been merged into the 4.02 release candidate, you can try them out with OPAM:</p>
<div class="highlight"><pre><code class="language-bash" data-lang="bash"><span></span>opam switch <span class="m">4</span>.02.0+trunk
</code></pre></div>
<p><a name="lazy-record-fields"></a></p>

<h4>Lazy record fields</h4>

<p>Not everything we work on makes is destined to make it upstream.  A few years ago, <a href="http://alain.frisch.fr/">Alain Frisch</a> <a href="http://www.lexifi.com/blog/ocaml-extensions-lexifi-semi-implicit-laziness">described</a> an OCaml extension in use at <a href="http://lexifi.com/">Lexifi</a> for marking record fields lazy, making it possible to delay the evaluation of initializing expressions without writing the <code>lazy</code> keyword every time a record is constructed.  Alain's post was received enthusiastically, and lazy record fields seemed like an obvious candidate for inclusion upstream, so in April's meeting Thomas put together a <a href="https://github.com/ocaml/ocaml/pull/48">patch</a> implementing the design.  Although the OCaml team decided not to merge the patch, it led to an enlightening <a href="https://github.com/ocaml/ocaml/pull/48#issuecomment-41758626">discussion</a> with comments from several core developers, including Alain, who described <a href="https://github.com/ocaml/ocaml/pull/48#issuecomment-41758626">subsequent, less positive, experience with the feature at Lexifi</a>, and Xavier, who explained the <a href="https://github.com/ocaml/ocaml/pull/48#issuecomment-41779525">rationale underlying the current design</a>.</p>

<p><a name="back-end"></a></p>

<h3>The back end</h3>

<figure style="float: right; padding: 15px; width: 350px">
<img src="http://farm4.staticflickr.com/3157/2877029132_b34943c8d7_z_d.jpg" style="width: 350px" alt="Camel back end"/><br/>
<figcaption><center><small>(<a href="http://www.flickr.com/photos/16230215@N08/2877029132"><i>Relief</i></a>
by <a href="http://www.flickr.com/photos/h-k-d/">Hartwig HKD</a>)</small></center></figcaption>
</figure>

<p>The OCaml back end (i.e. the <a href="https://realworldocaml.org/v1/en/html/the-compiler-backend-byte-code-and-native-code.html">code generation portion of the compiler</a>) also saw a proposed enhancement.</p>

<p><a name="constant-arithmetic-optimization"></a></p>

<h4>Constant arithmetic optimization</h4>

<p>Stephen submitted a <a href="https://github.com/ocaml/ocaml/pull/17">patch</a> improving the generated code for functions that perform constant arithmetic on integers.</p>

<p>In OCaml, integers and characters are <a href="https://realworldocaml.org/v1/en/html/memory-representation-of-values.html#table20-1_ocaml">represented as shifted immediate values</a>, with the least significant bit set to distinguish them from pointers.  This makes some arithmetic operations <a href="https://realworldocaml.org/v1/en/html/memory-representation-of-values.html#idm181610127856">a little more expensive</a>.  For example, consider a function that <code>int_of_digits</code> that builds an integer from three character digits:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="n">int_of_digits</span> <span class="sc">'3'</span> <span class="sc">'4'</span> <span class="sc">'5'</span> <span class="o">=&gt;</span> <span class="mi">345</span>
</code></pre></div>
<p>We might define <code>int_of_digits</code> as follows:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="n">int_of_digits</span> <span class="n">a</span> <span class="n">b</span> <span class="n">c</span> <span class="o">=</span> 
  <span class="mi">100</span> <span class="o">*</span> <span class="o">(</span><span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="n">a</span> <span class="o">-</span> <span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="sc">'0'</span><span class="o">)</span> <span class="o">+</span> 
   <span class="mi">10</span> <span class="o">*</span> <span class="o">(</span><span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="n">b</span> <span class="o">-</span> <span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="sc">'0'</span><span class="o">)</span> <span class="o">+</span>
    <span class="mi">1</span> <span class="o">*</span> <span class="o">(</span><span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="n">c</span> <span class="o">-</span> <span class="nn">Char</span><span class="p">.</span><span class="n">code</span> <span class="sc">'0'</span><span class="o">)</span>
</code></pre></div>
<p>Passing the <code>-dcmm</code> flag to ocamlopt shows the results of compiling the function to the <a href="https://github.com/ocaml/ocaml/blob/trunk/asmcomp/cmm.mli">C-- intermediate language</a>. </p>
<div class="highlight"><pre><code class="language-bash" data-lang="bash"><span></span>ocamlopt -dcmm int_of_digits.ml
</code></pre></div>
<p>The generated code has the following form (reformatted for readability):</p>
<div class="highlight"><pre><code class="language-c" data-lang="c"><span></span><span class="mi">200</span> <span class="o">*</span> <span class="p">((</span><span class="n">a</span> <span class="o">-</span> <span class="mi">96</span><span class="p">)</span> <span class="o">&gt;&gt;</span> <span class="mi">1</span><span class="p">)</span> <span class="o">+</span>
 <span class="mi">20</span> <span class="o">*</span> <span class="p">((</span><span class="n">b</span> <span class="o">-</span> <span class="mi">96</span><span class="p">)</span> <span class="o">&gt;&gt;</span> <span class="mi">1</span><span class="p">)</span> <span class="o">+</span>
  <span class="mi">2</span> <span class="o">*</span> <span class="p">((</span><span class="n">c</span> <span class="o">-</span> <span class="mi">96</span><span class="p">)</span> <span class="o">&gt;&gt;</span> <span class="mi">1</span><span class="p">)</span> <span class="o">+</span> <span class="mi">1</span>
</code></pre></div>
<p>The right shifts convert the tagged representation into native integers, and the final <code>+ 1</code> converts the result back to a tagged integer.</p>

<p>Stephen's patch floats the arithmetic operations that involve constant operands outwards, eliminating most of the tag-munging code in favour of a final correcting addition:</p>
<div class="highlight"><pre><code class="language-c" data-lang="c"><span></span><span class="p">(</span><span class="n">a</span> <span class="o">*</span> <span class="mi">100</span><span class="p">)</span> <span class="o">+</span>
<span class="p">(</span><span class="n">b</span> <span class="o">*</span> <span class="mi">10</span><span class="p">)</span> <span class="o">+</span>
 <span class="n">c</span> <span class="o">-</span> <span class="mi">10766</span>
</code></pre></div>
<p>Although these changes are not yet merged, you can easily try them out, thanks to Anil's script that <a href="http://anil.recoil.org/2014/03/25/ocaml-github-and-opam.html">makes compiler pull requests available as OPAM switches</a>:</p>
<div class="highlight"><pre><code class="language-text" data-lang="text"><span></span>opam switch 4.03.0+pr17
</code></pre></div>
<p><a name="standard-library"></a></p>

<h3>Standard library and beyond</h3>

<figure style="float: right; padding: 15px; width: 350px">
<img src="http://i.imgur.com/KKsM0tu.jpg" style="width: 350px" alt="Camel library"/><br/>
<figcaption><center><small>(Literary advocate <a href="http://www.papertigers.org/wordpress/interview-with-dashdondog-jamba-mongolian-author-and-literacy-advocate/">Dashdondog Jamba</a>, and his mobile library, described in <a href="http://www.bookdepository.com/My-Librarian-Is-a-Camel-Margriet-Ruurs/9781590780930"><i>My librarian is a camel</i></a>)</small></center></figcaption>
</figure>

<p>Our compiler hacking group defines &quot;compiler&quot; rather broadly.  As a result people often work on improving the standard library and tools as well as the compiler proper.  For example, in recent sessions, David added a small patch to <a href="http://caml.inria.fr/mantis/view.php?id=6105">expose the is_inet6_addr</a> function, and <a href="http://philippewang.info/">Philippe</a> proposed <a href="https://github.com/ocaml/ocaml/pull/15">a patch that eliminates unnecessary bounds checking</a> in the buffer module.  The last session also saw <a href="http://www.cl.cam.ac.uk/~rp452/">Rapha&euml;l</a> and Simon push a <a href="https://github.com/ocaml/opam-repository/pull/1961">number</a> <a href="https://github.com/ocaml/opam-repository/pull/1968">of</a> <a href="https://github.com/ocaml/opam-repository/pull/1972">patches</a> for integrating <a href="https://github.com/the-lambda-church/merlin">merlin</a> with the <a href="http://en.wikipedia.org/wiki/Acme_(text_editor)">acme</a> editor to OPAM, improving OCaml support in Plan 9.</p>

<h2>Next session</h2>

<p>The compiler hacking group is open to anyone with an interest in contributing to the OCaml compiler.  If you're local to Cambridge, you're welcome to join us at the <a href="http://ocamllabs.github.io/compiler-hacking/2014/06/20/sixth-compiler-hacking-session.html">next session</a>!</p>

