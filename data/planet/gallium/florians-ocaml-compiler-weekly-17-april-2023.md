---
title: Florian's OCaml compiler weekly, 17 April 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-04-17
date: 2023-04-17T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on the first alpha release of OCaml 5.1.0 and some discussion
with the ocamlformat team.</p>


  

<h3>First alpha release for
OCaml 5.1.0</h3>
<p>Between Friday and Saturday, I have published the first alpha for
OCaml 5.1.0. As the first version of OCaml 5 published after the feature
freeze for OCaml 5, this version feels like a midpoint between the usual
release process for OCaml 4 and the experimental release of OCaml 5.0.0
.</p>
<p>In particular, this release will integrate many features that were
either frozen during the development of OCaml 5 or merged in the
development version after the branch for OCaml 5.0 was cut. For
instance, the support for Risc-V was merged in July last year, but it
will only be available with OCaml 5.1 around next July.</p>
<p>Contrarily, the development windows for contributors that were busy
with OCaml 5.0.0 bug fixing was especially short since there was only
four months between the OCaml 5.0.0 release and the feature freeze for
OCaml 5.1 .</p>
<p>It is a bit too soon right now to try to summarize the new features
in OCaml 5.1, since unexpected problems might still require to remove
some of the new features (even if that happens rarely in practice).</p>
<p>However, I have a quite interesting early example of unexpected
incompatibility due to a refactoring: the more precise support for
generative functors break the menhir parser generator.</p>
<h4>An
example on unintended breakage for generative functor</h4>
<p>What are generative functors?</p>
<p>In brief, generative functors are a way to express the fact that
evaluating a functor create side-effect that meaningfully impact the
types that the functor creates and thus two successive applications of
the functor should away yield different types.</p>
<p>This would be hopefully clearer with the following example, consider
the functor:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">meta</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">1</span>
<span class="k">module</span> <span class="nc">Make_counter</span><span class="o">(</span><span class="nc">X</span><span class="o">:</span> <span class="k">sig</span> <span class="k">end</span><span class="o">):</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">create</span><span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">incr</span><span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">print</span><span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">int</span>
<span class="k">end</span>
<span class="o">=</span> <span class="k">struct</span>
  <span class="k">let</span> <span class="n">stride</span> <span class="o">=</span> <span class="n">incr</span> <span class="n">meta</span><span class="o">;</span> <span class="o">!</span><span class="n">meta</span>
  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="n">ref</span>
  <span class="k">let</span> <span class="n">create</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span>
  <span class="k">let</span> <span class="n">incr</span> <span class="n">t</span> <span class="o">=</span> <span class="n">t</span> <span class="o">:=</span> <span class="o">!</span><span class="n">t</span> <span class="o">+</span> <span class="n">stride</span>
  <span class="k">let</span> <span class="n">print</span> <span class="n">x</span> <span class="o">=</span> <span class="k">assert</span> <span class="o">(!</span><span class="n">x</span> <span class="ow">mod</span> <span class="n">stride</span> <span class="o">=</span> <span class="mi">0</span><span class="o">);</span> <span class="o">!</span><span class="n">x</span>
<span class="k">end</span>
</pre></div>

<p>Here, the functor is applicative, and unsafe! We can break the
internal assertion that we only add <code>stride</code> to our counters
by using the fact that the two modules <code>Counter_1</code> and
<code>Counter_2</code> share the same types <code>t</code> in</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">struct</span> <span class="k">end</span>
<span class="k">module</span> <span class="nc">Counter_1</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="o">(</span><span class="nc">A</span><span class="o">)</span>
<span class="k">module</span> <span class="nc">Counter_2</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="o">(</span><span class="nc">A</span><span class="o">)</span>
</pre></div>

<p>Thus, we can mix calls to functions of the two modules to break one
of the internal invariants:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">assert_failure</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">c</span> <span class="o">=</span> <span class="nn">Counter_1</span><span class="p">.</span><span class="n">create</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="nn">Counter_2</span><span class="p">.</span><span class="n">incr</span> <span class="n">c</span><span class="o">;</span>
  <span class="nn">Counter_1</span><span class="p">.</span><span class="n">print</span> <span class="n">c</span>
</pre></div>

<p>Of course, here the issue is that the functor <code>Counter</code>
was intended to be used only with anonymous structure as an argument</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Counter</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="o">(</span><span class="k">struct</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<p>Here, since we have lost the identity of the anonymous module after
the application, we are guaranteed that the type <code>Counter.t</code>
is fresh.</p>
<p>Generative functors (available since OCaml 4.02) makes it possible to
express this intent in the module type system. By defining the functor
<code>Make_counter</code> as generative with</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Generative_make_counter</span><span class="bp">()</span><span class="o">:</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">create</span><span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">incr</span><span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">print</span><span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">int</span>
<span class="k">end</span>
<span class="o">=</span> <span class="k">struct</span>
  <span class="k">let</span> <span class="n">stride</span> <span class="o">=</span> <span class="n">incr</span> <span class="n">meta</span><span class="o">;</span> <span class="o">!</span><span class="n">meta</span>
  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="n">ref</span>
  <span class="k">let</span> <span class="n">create</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span>
  <span class="k">let</span> <span class="n">incr</span> <span class="n">t</span> <span class="o">=</span> <span class="n">t</span> <span class="o">:=</span> <span class="o">!</span><span class="n">t</span> <span class="o">+</span> <span class="n">stride</span>
  <span class="k">let</span> <span class="n">print</span> <span class="n">x</span> <span class="o">=</span> <span class="k">assert</span> <span class="o">(!</span><span class="n">x</span> <span class="ow">mod</span> <span class="n">stride</span> <span class="o">=</span> <span class="mi">0</span><span class="o">);</span> <span class="o">!</span><span class="n">x</span>
<span class="k">end</span>
<span class="k">module</span> <span class="nc">Counter</span> <span class="o">=</span> <span class="nc">Generative_make_counter</span><span class="bp">()</span>
</pre></div>

<p>we inform the module system that</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">A</span> = <span class="n">struct</span> <span class="nb">end</span>
<span class="k">module</span> <span class="n">Counter_1</span> = <span class="n">Generative_make_counter</span>(<span class="n">A</span>)
</pre></div>

<p>is an error which is rejected with</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="k">is</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="n">generative</span><span class="w"> </span><span class="n">functor</span><span class="o">.</span><span class="w"> </span><span class="n">It</span><span class="w"> </span><span class="n">can</span><span class="w"> </span><span class="n">only</span><span class="w"> </span><span class="n">be</span><span class="w"> </span><span class="n">applied</span><span class="w"> </span><span class="n">to</span><span class="w"> </span><span class="o">()</span><span class="w"></span>
</pre></div>

<p>Consequently, we are guaranteed that each call to
<code>Make_counter</code> creates a fresh type <code>t</code>.</p>
<p>However, back in 4.02 and 2014, it was decided to represent the
generative application as an application to a syntactic empty structure.
In other words,</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Counter_1</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="bp">()</span>
</pre></div>

<p>was represented as</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Counter_1</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="o">(</span><span class="k">struct</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<p>This choice of the representation was simpler but it has the
disadvantage of allowing some confusing code:</p>
<ul>
<li>First, applicative functors could applied to the unit argument:</li>
</ul>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">W</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="bp">()</span>
</pre></div>

<ul>
<li>Second, generative functors could be applied to a syntactically
empty structure:</li>
</ul>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">E</span> = <span class="n">Generative_make_counter</span>(<span class="n">struct</span> <span class="nb">end</span>)
</pre></div>

<p>At least, both options make it clear that the types of the generated
modules would be fresh.</p>
<p>Nevertheless, with more hindsight, it seems better to make the
distinction between the two cases clearer. Thus starting with OCaml 5.1,
the parser and the typechecker distinguishes between <code>F()</code>
and <code>F(struct end)</code>.</p>
<p>In OCaml 5.1, applying a functor to a syntactically empty
structure</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Warning</span> <span class="o">=</span> <span class="nc">Generative_make_counter</span><span class="o">(</span><span class="k">struct</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<p>generates a warning</p>
<div class="highlight"><pre><span></span><span class="nv">Warning</span> <span class="mi">73</span> [<span class="nv">generative</span><span class="o">-</span><span class="nv">application</span><span class="o">-</span><span class="nv">expects</span><span class="o">-</span><span class="nv">unit</span>]: <span class="nv">A</span> <span class="nv">generative</span> <span class="nv">functor</span>
<span class="nv">should</span> <span class="nv">be</span> <span class="nv">applied</span> <span class="nv">to</span> <span class="s1">'</span><span class="s">()</span><span class="s1">'</span><span class="c1">; using '(struct end)' is deprecated.</span>
</pre></div>

<p>This warning is here to let some breathing room for ppxs that had to
use this syntax before OCaml 5.1 .</p>
<p>Contrarily, applying an applicative functor to the empty argument
generates an error</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Error</span> <span class="o">=</span> <span class="nc">Make_counter</span><span class="bp">()</span>
</pre></div>

<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">The</span><span class="w"> </span><span class="n">functor</span><span class="w"> </span><span class="n">was</span><span class="w"> </span><span class="n">expected</span><span class="w"> </span><span class="n">to</span><span class="w"> </span><span class="n">be</span><span class="w"> </span><span class="n">applicative</span><span class="w"> </span><span class="n">at</span><span class="w"> </span><span class="k">this</span><span class="w"> </span><span class="n">position</span><span class="w"></span>
</pre></div>

<p>During the review of this change, I didn&rsquo;t think about the
possibility that some OCaml programs would have switch to generative
syntax for application without making the change to the type of the
functor itself.</p>
<p>But this was too optimistic for at least one opam package. This
package is now fixed, but it remains to be seen if this was an
unfortunate and rare accident. If this is not the case, we will need to
add a deprecation warning on this side too.</p>
<h3>OCaml Parser and ocamlformat</h3>
<p>This week, I also had an interesting discussions with members of the
ocamlformat team concerning upstreaming some of the ocamlformat patches
to the compiler.</p>
<p>As a code formatter, ocamlformat needs to maintain a more precise
mapping between its syntax tree and the code source that the main OCaml
parser. Indeed, ocamlformat cannot afford to discard meaningful
distinction in the code source due to some synctactic sugar. Contrarily,
the main compiler only need to keep enough information about the code
source to be able to report errors, and prints the parsed abstract
syntax tree in a good-enough format.</p>
<p>The objectives of the two parsers are thus not completely aligned.
However, comparing notes from time to time is a good way to catch
potential issues.</p>
<ul>
<li>Is the compiler loosing important location information?</li>
<li>Is the compiler mixing different concern in the parsing of the code
source?</li>
<li>Is the compiler making ppxs transformation harder to express because
the AST veer too far from the surface language?</li>
</ul>
<p>A good example of the last two categories was my <a href="https://cambium.inria.fr/blog/florian-weekly-2023-03-27/">change</a>
for type constraints on value binding. Indeed, before this change the
OCaml parser read</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">type</span> <span class="n">a</span> <span class="n">b</span><span class="o">.</span> <span class="n">a</span> <span class="o">-&gt;</span> <span class="n">b</span> <span class="o">-&gt;</span> <span class="n">a</span> <span class="o">=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">x</span>
</pre></div>

<p>as if the programmer had written:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">fun</span> <span class="o">(</span><span class="k">type</span> <span class="n">a</span><span class="o">)</span> <span class="o">(</span><span class="k">type</span> <span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">:</span> <span class="n">a</span> <span class="o">-&gt;</span> <span class="n">b</span> <span class="o">-&gt;</span> <span class="n">a</span><span class="o">)</span>
</pre></div>

<p>Of course, the two construct are defined to be equivalent at the
level of the typechecker. It is however pretty clear that the
distinction between the two is very meaningful for the programmer.
Moreover, the transformation is complex enough that ppx authors would
probably rather not try to undo the transformation.</p>
<p>Moving the transformation from the parser to the typechecker was thus
deemed a good move.</p>
<p>For OCaml 5.2, we will try to seek other refactoring to the parser
that would make sense in the main parser while reducing ocamlformat
maintenance burden.</p>


  
