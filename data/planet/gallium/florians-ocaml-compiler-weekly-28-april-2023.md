---
title: Florian's OCaml compiler weekly, 28 April 2023
description:
url: http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-28
date: 2023-04-28T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



    <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on compiler messages and backward compatibility.</p>


  

  
<h3>A tag for quoting inline
code</h3>
<p>Last week, while I was investigating the breaking change in behavior
for polymorphic variants, I have also started a much more boring change:
uniformizing the quoting style for inline code in the compiler
messages.</p>
<p>Currently, this quoting style is mostly left to the appreciation of
authors of every compiler messages. This has lead the OCaml compiler
messages to be quite heterogeneous, with different messages using
<code>&quot;...&quot;</code>, other <code>'...'</code>, or <code>`...'</code>,
depending on the preference of the initial author.</p>
<p>To make the compiler message, I spent the time to introduce a new
<code>inline_code</code> tag in the set of <code>Format</code> tags used
by the compiler.</p>
<p>With this new tag, the compiler message</p>
<div class="highlight"><pre><span></span><span class="n">fprintf</span> <span class="n">ppf</span> <span class="s2">&quot;The external function `%s' is not available&quot;</span> <span class="n">s</span>
</pre></div>

<p>can be rewritten as</p>
<div class="highlight"><pre><span></span><span class="n">fprintf</span> <span class="n">ppf</span> <span class="s2">&quot;The external function %a is not available&quot;</span> <span class="nn">Style</span><span class="p">.</span><span class="n">inline_code</span> <span class="n">s</span>
</pre></div>

<p>which has the advantage of centralizing the styling of inline code
fragment in a single location. In particular, this means that we could
adapt the styling to the rendering medium (fancy terminal could use
fancy styling while basic terminal use a textual quote).</p>
<p>My proposal with this change is currently available as a <a href="https://github.com/ocaml/ocaml/pull/12210">pull request</a>.</p>
<h3>Cleaning-up error messages</h3>
<p>Adding an <code>inline_code</code> tag was also a good occasion to
spot small mistakes in error messages. For example, the error message
for non-overriding inheritance</p>
<div class="highlight"><pre><span></span><span class="k">class</span> <span class="n">empty</span> <span class="o">=</span> <span class="k">object</span> <span class="k">end</span>
<span class="k">class</span> <span class="n">also_empty</span> <span class="o">=</span> <span class="k">object</span> <span class="k">inherit</span><span class="o">!</span> <span class="n">empty</span> <span class="k">end</span>
</pre></div>

<p>lost a word at some point it time, yielding the following error
message</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="n">inheritance</span><span class="w"> </span><span class="n">does</span><span class="w"> </span><span class="n">not</span><span class="w"> </span><span class="kd">override</span><span class="w"> </span><span class="n">any</span><span class="w"> </span><span class="n">method</span><span class="w"> </span><span class="n">instance</span><span class="w"> </span><span class="n">variable</span><span class="w"></span>
</pre></div>

<p>which may confuse reader wondering what is a
<code>method instance variable</code>. The sentence is quite easier to
read once we add back the missing <code>and</code> and plurals</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="n">inheritance</span><span class="w"> </span><span class="n">does</span><span class="w"> </span><span class="n">not</span><span class="w"> </span><span class="kd">override</span><span class="w"> </span><span class="n">any</span><span class="w"> </span><span class="n">methods</span><span class="w"> </span><span class="n">or</span><span class="w"> </span><span class="n">instance</span><span class="w"> </span><span class="n">variables</span><span class="o">.</span><span class="w"></span>
</pre></div>

<h3>Backward
compatibility and polymorphic variants</h3>
<p>As discussed last week, I have been working with Gabriel Scherer on a
way to preserve backward compatibility for programs that mix open
polymorphic variant types and explicit polymorphic annotation in OCaml
5.1:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>The backward compatibility hack that we came up with last week is to
automatically add the missing annotations:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="k">'</span><span class="n">r</span><span class="o">.</span> <span class="o">(</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span> <span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>However, while writing a description of this hack in <a href="https://github.com/ocaml/ocaml#12211">my pull request</a>, I
realized that this change was breaking backward compatibility in
<em>another</em> corner case:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">Foo</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="k">fun</span> <span class="o">(`</span><span class="nc">Bar</span><span class="o">|_)</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span>
</pre></div>

<p>Here the issue is that writing such type annotation let the
typechecker infers that the real type of the row variable is
<code>[&gt; `Foo | `Bar` ]</code></p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">Foo</span> <span class="o">|</span> <span class="o">`</span><span class="nc">Bar</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="k">fun</span> <span class="o">(`</span><span class="nc">Bar</span><span class="o">|_)</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span>
</pre></div>

<p>and not just <code>[&gt; `Foo ]</code>. However, with our hack, this
code will be converted to</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">b</span> <span class="k">'</span><span class="n">r</span><span class="o">.</span> <span class="o">([&gt;</span> <span class="o">`</span><span class="nc">Foo</span>  <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span>  <span class="k">fun</span> <span class="o">(`</span><span class="nc">Bar</span><span class="o">|_)</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span>
</pre></div>

<p>where suddenly we cannot widen <code>[&gt; `Foo ]</code> to
<code>[&gt; `Foo | `Bar` ]</code>. And thus the line above fails to
compile with</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="n">pattern</span><span class="w"> </span><span class="n">matches</span><span class="w"> </span><span class="n">values</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="o">[?</span><span class="w"> </span><span class="err">`</span><span class="n">Bar</span><span class="w"> </span><span class="o">]</span><span class="w"></span>
<span class="w">       </span><span class="n">but</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="n">pattern</span><span class="w"> </span><span class="n">was</span><span class="w"> </span><span class="n">expected</span><span class="w"> </span><span class="n">which</span><span class="w"> </span><span class="n">matches</span><span class="w"> </span><span class="n">values</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="o">[&gt;</span><span class="w"> </span><span class="err">`</span><span class="n">Foo</span><span class="w"> </span><span class="o">]</span><span class="w"></span>
<span class="w">       </span><span class="n">The</span><span class="w"> </span><span class="n">second</span><span class="w"> </span><span class="n">variant</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="k">is</span><span class="w"> </span><span class="n">bound</span><span class="w"> </span><span class="n">to</span><span class="w"> </span><span class="n">the</span><span class="w"> </span><span class="n">universal</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">variable</span><span class="w"> </span><span class="err">'</span><span class="n">a</span><span class="o">,</span><span class="w"></span>
<span class="w">       </span><span class="n">it</span><span class="w"> </span><span class="n">may</span><span class="w"> </span><span class="n">not</span><span class="w"> </span><span class="n">allow</span><span class="w"> </span><span class="n">the</span><span class="w"> </span><span class="n">tag</span><span class="o">(</span><span class="n">s</span><span class="o">)</span><span class="w"> </span><span class="err">`</span><span class="n">Bar</span><span class="w"></span>
</pre></div>

<p>To avoid this regression, Jacques Garrigue proposed to only add
annotations to polymorphic variant types that contains references to
universal type variables. In other words, with this updated rule</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">Foo</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="k">fun</span> <span class="o">(`</span><span class="nc">Bar</span><span class="o">|_)</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span>
</pre></div>

<p>is kept unchanged because <code>[&gt; `Foo ]</code> does not point to
<code>'b</code> (or any universally quantified type variables).</p>
<p>Contrarily</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>is transformed into</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="k">'</span><span class="n">r</span><span class="o">.</span> <span class="o">([&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>because <code>[&gt; `X  of 'a ]</code> refers to the explicitly
quantified type variable <code>'a</code>.</p>
<p>Moreover, this rule is still well behaved in presence of nested
explicitly polymorphic annotations. For instance, looking at</p>
<div class="highlight"><pre><span></span><span class="n">let</span><span class="w"> </span><span class="n">nested</span><span class="o">:</span><span class="w"> </span><span class="s">'a.</span>
<span class="s">  &lt;m: '</span><span class="n">b</span><span class="p">.</span><span class="w"></span>
<span class="w">     </span><span class="o">&lt;</span><span class="n">n</span><span class="o">:</span><span class="s">'irr. ('</span><span class="n">irr</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="n">unit</span><span class="p">)</span><span class="w"> </span><span class="o">*</span><span class="w"> </span><span class="p">([</span><span class="o">&gt;</span><span class="w"> </span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="kr">of</span><span class="w"> </span><span class="s">'a | `Y of '</span><span class="n">b</span><span class="w"> </span><span class="p">]</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="s">'a) &gt;</span>
<span class="s">  &gt; -&gt; '</span><span class="n">a</span><span class="w">  </span><span class="o">=</span><span class="w"> </span><span class="n">fun</span><span class="w"> </span><span class="n">o</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="p">(</span><span class="n">snd</span><span class="w"> </span><span class="n">o</span><span class="err">#</span><span class="n">m</span><span class="err">#</span><span class="n">n</span><span class="p">)</span><span class="w"> </span><span class="p">(</span><span class="err">`</span><span class="n">Y</span><span class="w"> </span><span class="mi">0</span><span class="p">)</span><span class="w"></span>
</pre></div>

<p>we can see that the nearest explicit annotation where all universal
variables involved in <code>[&gt; `X of 'a | `Y of 'b]</code> are bound
is the one the method <code>m</code>. Thus the type above is equivalent
with the new rule to:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">nested</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="o">.</span>
  <span class="o">&lt;</span> <span class="n">m</span> <span class="o">:</span> <span class="k">'</span><span class="n">r</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span>
      <span class="o">&lt;</span> <span class="n">n</span> <span class="o">:</span> <span class="k">'</span><span class="n">irr</span><span class="o">.</span> <span class="o">(</span><span class="k">'</span><span class="n">irr</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="o">)</span> <span class="o">*</span> <span class="o">(([&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">|</span> <span class="o">`</span><span class="nc">Y</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span> <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span> <span class="o">&gt;</span>
<span class="o">&gt;</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="o">...</span>
</pre></div>

<p>On the one hand, I am not sure if the restoration of backward
compatibility in OCaml 5.1 is really worth the complexity of this new
rule. On the other hand, the new rule is conservative enough that we
could use it to emit warnings or hint messages with a sensible
resolution if the missing feature for constrained abstract types lands
in OCaml.</p>


  
