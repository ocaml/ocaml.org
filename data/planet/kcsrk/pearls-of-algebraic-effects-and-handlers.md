---
title: Pearls of Algebraic Effects and Handlers
description:
url: https://kcsrk.info/ocaml/multicore/effects/2015/05/27/more-effects/
date: 2015-05-27T14:06:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>In the <a href="http://kcsrk.info/ocaml/multicore/2015/05/20/effects-multicore/">previous
post</a>, I
presented a simple cooperative multithreaded scheduler written using algebraic
effects and their handlers. Algebraic effects are of course useful for
expressing other forms of effectful computations. In this post, I will present
a series of simple examples to illustrate the utility of algebraic effects and
handlers in OCaml. Some of the examples presented here were borrowed from the
excellent paper on Eff programming language<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Eff" class="footnote" rel="footnote">1</a></sup>. All of the examples
presented below are available
<a href="https://github.com/kayceesrk/ocaml-eff-example">here</a>.</p>



<h2>State</h2>

<p>We can use algebraic effects to model <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/state.ml">stateful
computation</a>,
with the ability to retrieve (<code class="language-plaintext highlighter-rouge">get</code>) and update (<code class="language-plaintext highlighter-rouge">put</code>) the current state:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">module</span> <span class="k">type</span> <span class="nc">STATE</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">put</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">get</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">run</span> <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="n">init</span><span class="o">:</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">end</span></code></pre></figure>

<p>The function <code class="language-plaintext highlighter-rouge">run</code> runs a stateful computation with the given initial state.
Here is the implementation of the module <code class="language-plaintext highlighter-rouge">State</code> which provides the desired
behaviour:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><table class="rouge-table"><tbody><tr><td class="gutter gl"><pre class="lineno">1
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
12
13
14
15
16
17
</pre></td><td class="code"><pre><span class="k">module</span> <span class="nc">State</span> <span class="p">(</span><span class="nc">S</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span><span class="p">)</span> <span class="o">:</span> <span class="nc">STATE</span> <span class="k">with</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="nn">S</span><span class="p">.</span><span class="n">t</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="nn">S</span><span class="p">.</span><span class="n">t</span>

  <span class="n">effect</span> <span class="nc">Put</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">let</span> <span class="n">put</span> <span class="n">v</span> <span class="o">=</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Put</span> <span class="n">v</span><span class="p">)</span>

  <span class="n">effect</span> <span class="nc">Get</span> <span class="o">:</span> <span class="n">t</span>
  <span class="k">let</span> <span class="n">get</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">perform</span> <span class="nc">Get</span>

  <span class="k">let</span> <span class="n">run</span> <span class="n">f</span> <span class="o">~</span><span class="n">init</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">comp</span> <span class="o">=</span>
      <span class="k">match</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">with</span>
      <span class="o">|</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="p">)</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Put</span> <span class="n">s'</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span> <span class="n">s'</span><span class="p">)</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="nc">Get</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">continue</span> <span class="n">k</span> <span class="n">s</span> <span class="n">s</span><span class="p">)</span>
    <span class="k">in</span> <span class="n">comp</span> <span class="n">init</span>
<span class="k">end</span>
</pre></td></tr></tbody></table></code></pre></figure>

<p>The key idea here is that the handler converts the stateful computation to
functions that accept the state. For example, observe that if the function <code class="language-plaintext highlighter-rouge">f</code>
returns a <code class="language-plaintext highlighter-rouge">unit</code> value (line 13), we return a function which accepts a state
<code class="language-plaintext highlighter-rouge">s</code> and returns <code class="language-plaintext highlighter-rouge">unit</code>. The handler for effect <code class="language-plaintext highlighter-rouge">Get</code> (line 15) passes the current state <code class="language-plaintext highlighter-rouge">s</code>
to the continuation <code class="language-plaintext highlighter-rouge">k</code>. The expression <code class="language-plaintext highlighter-rouge">continue k s</code> returns a function that
accepts the current state and returns <code class="language-plaintext highlighter-rouge">unit</code>. Since fetching the current state
does not modify it, we apply this function to <code class="language-plaintext highlighter-rouge">s</code>, the original state. Since
<code class="language-plaintext highlighter-rouge">Put</code> modifies the state (line 14), the function returned by <code class="language-plaintext highlighter-rouge">continue k ()</code> is applied
to the new state <code class="language-plaintext highlighter-rouge">s'</code>. We evaluate the computation by applying it to the initial
state <code class="language-plaintext highlighter-rouge">init</code> (line 16).</p>

<p>Observe that the implementation of the handler for the stateful computation is
similar to the implementation of <a href="https://wiki.haskell.org/State_Monad#Implementation">State
monad</a> in Haskell. Except
that in Haskell, you would have the stateful computation <code class="language-plaintext highlighter-rouge">f</code> have the type
<code class="language-plaintext highlighter-rouge">State t ()</code>, which says that <code class="language-plaintext highlighter-rouge">f</code> is a stateful computation where <code class="language-plaintext highlighter-rouge">t</code> is the
type of state and  <code class="language-plaintext highlighter-rouge">()</code> the type of return value. Since multicore OCaml does
not have a effect system, <code class="language-plaintext highlighter-rouge">f</code> simply has type <code class="language-plaintext highlighter-rouge">unit -&gt; unit</code> as opposed to
being explicitly tagged with the effects being performed. While the OCaml type
of <code class="language-plaintext highlighter-rouge">f</code> under specifies the behaviour of <code class="language-plaintext highlighter-rouge">f</code>, it does allow you to combine various
kinds of effects directly, without the need for monad transformer
gymnastics<sup role="doc-noteref"><a href="https://kcsrk.info/atom-ocaml.xml#fn:Idris-eff" class="footnote" rel="footnote">2</a></sup>. For example, the following code snippet combines an int
and string typed state computations, each with its own handler:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">module</span> <span class="nc">IS</span> <span class="o">=</span> <span class="nc">State</span> <span class="p">(</span><span class="k">struct</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="k">end</span><span class="p">)</span>
<span class="k">module</span> <span class="nc">SS</span> <span class="o">=</span> <span class="nc">State</span> <span class="p">(</span><span class="k">struct</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">string</span> <span class="k">end</span><span class="p">)</span>

<span class="k">let</span> <span class="n">foo</span> <span class="bp">()</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span>
  <span class="n">printf</span> <span class="s2">&quot;%d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">IS</span><span class="p">.</span><span class="n">get</span> <span class="bp">()</span><span class="p">);</span>
  <span class="nn">IS</span><span class="p">.</span><span class="n">put</span> <span class="mi">42</span><span class="p">;</span>
  <span class="n">printf</span> <span class="s2">&quot;%d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">IS</span><span class="p">.</span><span class="n">get</span> <span class="bp">()</span><span class="p">);</span>
  <span class="nn">IS</span><span class="p">.</span><span class="n">put</span> <span class="mi">21</span><span class="p">;</span>
  <span class="n">printf</span> <span class="s2">&quot;%d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">IS</span><span class="p">.</span><span class="n">get</span> <span class="bp">()</span><span class="p">);</span>
  <span class="nn">SS</span><span class="p">.</span><span class="n">put</span> <span class="s2">&quot;hello&quot;</span><span class="p">;</span>
  <span class="n">printf</span> <span class="s2">&quot;%s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">SS</span><span class="p">.</span><span class="n">get</span> <span class="bp">()</span><span class="p">);</span>
  <span class="nn">SS</span><span class="p">.</span><span class="n">put</span> <span class="s2">&quot;world&quot;</span><span class="p">;</span>
  <span class="n">printf</span> <span class="s2">&quot;%s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="nn">SS</span><span class="p">.</span><span class="n">get</span> <span class="bp">()</span><span class="p">)</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">IS</span><span class="p">.</span><span class="n">run</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="nn">SS</span><span class="p">.</span><span class="n">run</span> <span class="n">foo</span> <span class="s2">&quot;&quot;</span><span class="p">)</span> <span class="mi">0</span></code></pre></figure>

<p>which prints:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">0
42
21
hello
world</code></pre></figure>

<h2>References</h2>

<p>We can expand upon our state example, to model <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/ref.ml">ML style
references</a>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">module</span> <span class="nc">State</span> <span class="o">:</span> <span class="k">sig</span>
    <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>

    <span class="k">val</span> <span class="n">ref</span>  <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>
    <span class="k">val</span> <span class="p">(</span><span class="o">!</span><span class="p">)</span>  <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
    <span class="k">val</span> <span class="p">(</span><span class="o">:=</span><span class="p">)</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">unit</span>

    <span class="k">val</span> <span class="n">run</span>  <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
  <span class="k">end</span> <span class="o">=</span> <span class="k">struct</span>

  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">=</span> <span class="p">{</span><span class="n">inj</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="nn">Univ</span><span class="p">.</span><span class="n">t</span><span class="p">;</span> <span class="n">prj</span> <span class="o">:</span> <span class="nn">Univ</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">option</span><span class="p">}</span>

  <span class="n">effect</span> <span class="nc">Ref</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>
  <span class="k">let</span> <span class="n">ref</span> <span class="n">v</span> <span class="o">=</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Ref</span> <span class="n">v</span><span class="p">)</span>

  <span class="n">effect</span> <span class="nc">Read</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
  <span class="k">let</span> <span class="p">(</span><span class="o">!</span><span class="p">)</span> <span class="o">=</span> <span class="k">fun</span> <span class="n">r</span> <span class="o">-&gt;</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Read</span> <span class="n">r</span><span class="p">)</span>

  <span class="n">effect</span> <span class="nc">Write</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">let</span> <span class="p">(</span><span class="o">:=</span><span class="p">)</span> <span class="o">=</span> <span class="k">fun</span> <span class="n">r</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Write</span> <span class="p">(</span><span class="n">r</span><span class="o">,</span><span class="n">v</span><span class="p">))</span>

  <span class="k">let</span> <span class="n">run</span> <span class="n">f</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">comp</span> <span class="o">=</span>
      <span class="k">match</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">with</span>
      <span class="o">|</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">v</span><span class="p">)</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Ref</span> <span class="n">v</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span>
          <span class="k">let</span> <span class="p">(</span><span class="n">inj</span><span class="o">,</span> <span class="n">prj</span><span class="p">)</span> <span class="o">=</span> <span class="nn">Univ</span><span class="p">.</span><span class="n">embed</span> <span class="bp">()</span> <span class="k">in</span>
          <span class="k">let</span> <span class="n">cont</span> <span class="o">=</span> <span class="n">continue</span> <span class="n">k</span> <span class="p">{</span><span class="n">inj</span><span class="p">;</span><span class="n">prj</span><span class="p">}</span> <span class="k">in</span>
          <span class="n">cont</span> <span class="p">(</span><span class="n">inj</span> <span class="n">v</span><span class="o">::</span><span class="n">s</span><span class="p">))</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Read</span> <span class="p">{</span><span class="n">inj</span><span class="p">;</span> <span class="n">prj</span><span class="p">})</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span>
          <span class="k">match</span> <span class="n">find</span> <span class="n">prj</span> <span class="n">s</span> <span class="k">with</span>
          <span class="o">|</span> <span class="nc">Some</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">continue</span> <span class="n">k</span> <span class="n">v</span> <span class="n">s</span>
          <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;Ref.run: Impossible -&gt; ref not found&quot;</span><span class="p">)</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Write</span> <span class="p">({</span><span class="n">inj</span><span class="p">;</span> <span class="n">prj</span><span class="p">}</span><span class="o">,</span> <span class="n">v</span><span class="p">))</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">s</span> <span class="o">-&gt;</span>
          <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span> <span class="p">(</span><span class="n">inj</span> <span class="n">v</span><span class="o">::</span><span class="n">s</span><span class="p">))</span>
    <span class="k">in</span> <span class="n">comp</span> <span class="bp">[]</span>
<span class="k">end</span></code></pre></figure>

<p>The idea is to represent the state as a list of universal typed values,
references as a record with inject and project functions to and from universal
type values, assign as appending a new value to the head of the state list, and
dereference as linear search through the list for a matching assignment. The
<a href="https://blogs.janestreet.com/a-universal-type/#comment-163">universal type
implementation</a> is
due to Alan Frisch.</p>

<h2>Transactions</h2>

<p>We may handle lookup and update to implement
<a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/transaction.ml">transactions</a>
that discards the updates to references in case an exception occurs:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml">  <span class="k">let</span> <span class="n">atomically</span> <span class="n">f</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">comp</span> <span class="o">=</span>
      <span class="k">match</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">with</span>
      <span class="o">|</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">x</span><span class="p">)</span>
      <span class="o">|</span> <span class="k">exception</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">rb</span> <span class="o">-&gt;</span> <span class="n">rb</span> <span class="bp">()</span><span class="p">;</span> <span class="k">raise</span> <span class="n">e</span><span class="p">)</span>
      <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Update</span> <span class="p">(</span><span class="n">r</span><span class="o">,</span><span class="n">v</span><span class="p">))</span> <span class="n">k</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">fun</span> <span class="n">rb</span> <span class="o">-&gt;</span>
          <span class="k">let</span> <span class="n">old_v</span> <span class="o">=</span> <span class="o">!</span><span class="n">r</span> <span class="k">in</span>
          <span class="n">r</span> <span class="o">:=</span> <span class="n">v</span><span class="p">;</span>
          <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">r</span> <span class="o">:=</span> <span class="n">old_v</span><span class="p">;</span> <span class="n">rb</span> <span class="bp">()</span><span class="p">))</span>
    <span class="k">in</span> <span class="n">comp</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="p">)</span></code></pre></figure>

<p>Updating a reference builds up a rollback function that negates the effect of
the update. In case of an exception, the rollback function is evaluated before
re-raising the exception. For example, in the following code snippet:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">exception</span> <span class="nc">Res</span> <span class="k">of</span> <span class="kt">int</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">atomically</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="c">(* T0 *)</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">10</span> <span class="k">in</span>
  <span class="n">printf</span> <span class="s2">&quot;T0: %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="o">!</span><span class="n">r</span><span class="p">);</span>
  <span class="k">try</span> <span class="n">atomically</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="c">(* T1 *)</span>
    <span class="n">r</span> <span class="o">:=</span> <span class="mi">20</span><span class="p">;</span>
    <span class="n">r</span> <span class="o">:=</span> <span class="mi">21</span><span class="p">;</span>
    <span class="n">printf</span> <span class="s2">&quot;T1: Before abort %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="o">!</span><span class="n">r</span><span class="p">);</span>
    <span class="k">raise</span> <span class="p">(</span><span class="nc">Res</span> <span class="o">!</span><span class="n">r</span><span class="p">);</span>
    <span class="n">printf</span> <span class="s2">&quot;T1: After abort %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="p">(</span><span class="o">!</span><span class="n">r</span><span class="p">);</span>
    <span class="n">r</span> <span class="o">:=</span> <span class="mi">30</span><span class="p">)</span>
  <span class="k">with</span>
  <span class="o">|</span> <span class="nc">Res</span> <span class="n">v</span> <span class="o">-&gt;</span> <span class="n">printf</span> <span class="s2">&quot;T0: T1 aborted with %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="n">v</span><span class="p">;</span>
  <span class="n">printf</span> <span class="s2">&quot;T0: %d</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="o">!</span><span class="n">r</span><span class="p">)</span></code></pre></figure>

<p>the updates to reference <code class="language-plaintext highlighter-rouge">r</code> by transaction <code class="language-plaintext highlighter-rouge">T1</code> are discarded on exception and
the program prints the following:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash">T0: 10
T1: Before abort 21
T0: T1 aborted with 21
T0: 10</code></pre></figure>

<h2>From Iterators to Generators</h2>

<p>An iterator is a fold-function of type <code class="language-plaintext highlighter-rouge">('a -&gt; unit) -&gt; unit</code>, that iterates a
client function over all the elements of a data structure. A generator is a
function of type <code class="language-plaintext highlighter-rouge">unit -&gt; 'a option</code> that returns <code class="language-plaintext highlighter-rouge">Some v</code> each time the
function is invoked, where <code class="language-plaintext highlighter-rouge">v</code> is the <em>next-element</em> in the data structure. The
function returns <code class="language-plaintext highlighter-rouge">None</code> if the traversal is complete. Unlike an iterator, the
generator hands over control of the traversal to the client of the library.</p>

<p>Gabriel Scherer&rsquo;s insightful article on <a href="http://gallium.inria.fr/blog/generators-iterators-control-and-continuations/">generators, iterators, control and
continuations</a>
nicely distinguish, motivate and provide implementation of different kinds of
iterators and generators for binary trees. While the iterator implementation is
obvious and straight-forward, the generator implementation requires translating
the code to CPS style and manually performing simplifications for efficient
traversal. Since algebraic effects handlers give us a handle to the
continuation, we can essentially <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/generator.ml"><em>derive</em> the generator implementation from
the
iterator</a>.</p>

<p>Let us consider a binary tree with the following type:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">=</span> <span class="nc">Leaf</span> <span class="o">|</span> <span class="nc">Node</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span></code></pre></figure>

<p>We can define an iterator that traverses the tree from left to right as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">iter</span> <span class="n">f</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="nc">Leaf</span> <span class="o">-&gt;</span> <span class="bp">()</span>
  <span class="o">|</span> <span class="nc">Node</span> <span class="p">(</span><span class="n">l</span><span class="o">,</span> <span class="n">x</span><span class="o">,</span> <span class="n">r</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="n">iter</span> <span class="n">f</span> <span class="n">l</span><span class="p">;</span> <span class="n">f</span> <span class="n">x</span><span class="p">;</span> <span class="n">iter</span> <span class="n">f</span> <span class="n">r</span></code></pre></figure>

<p>From this iterator, we derive the generator as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><table class="rouge-table"><tbody><tr><td class="gutter gl"><pre class="lineno">1
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
12
13
14
</pre></td><td class="code"><pre><span class="k">let</span> <span class="n">to_gen</span> <span class="p">(</span><span class="k">type</span> <span class="n">a</span><span class="p">)</span> <span class="p">(</span><span class="n">t</span> <span class="o">:</span> <span class="n">a</span> <span class="n">t</span><span class="p">)</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="k">struct</span> <span class="n">effect</span> <span class="nc">Next</span> <span class="o">:</span> <span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="k">end</span> <span class="k">in</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nc">M</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">step</span> <span class="o">=</span> <span class="n">ref</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span><span class="p">)</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">first_step</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">try</span>
      <span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">perform</span> <span class="p">(</span><span class="nc">Next</span> <span class="n">x</span><span class="p">))</span> <span class="n">t</span><span class="p">;</span>
      <span class="nc">None</span>
    <span class="k">with</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Next</span> <span class="n">v</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span>
      <span class="n">step</span> <span class="o">:=</span> <span class="n">continue</span> <span class="n">k</span><span class="p">;</span>
      <span class="nc">Some</span> <span class="n">v</span>
  <span class="k">in</span>
    <span class="n">step</span> <span class="o">:=</span> <span class="n">first_step</span><span class="p">;</span>
    <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="o">!</span><span class="n">step</span> <span class="bp">()</span>
</pre></td></tr></tbody></table></code></pre></figure>

<p>At each step of the iteration, we perform the effect <code class="language-plaintext highlighter-rouge">Next : a -&gt; unit</code> (line
7), which is handled by saving the continuation to a local reference and
returning the value (line 9 - 11). Since the effect handlers are provided with
the continuation, we are able to invert the control from the library to the
client of the library. This avoids the need to perform manual CPS translation.</p>

<h2>Direct-style asynchronous IO</h2>

<p>Since the effect handler has access to the continuation, we can implement
minimal <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/aio.ml">asynchronous IO in
direct-style</a>
as opposed to the monadic style of asynchronous IO libraries such as Lwt and
Async. Our asynchronous IO library has the following interface:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">module</span> <span class="k">type</span> <span class="nc">AIO</span> <span class="o">=</span> <span class="k">sig</span>

  <span class="k">val</span> <span class="n">fork</span>  <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">yield</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span>

  <span class="k">type</span> <span class="n">file_descr</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">file_descr</span>
  <span class="k">type</span> <span class="n">sockaddr</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">sockaddr</span>
  <span class="k">type</span> <span class="n">msg_flag</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">msg_flag</span>

  <span class="k">val</span> <span class="n">accept</span> <span class="o">:</span> <span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="n">file_descr</span> <span class="o">*</span> <span class="n">sockaddr</span>
  <span class="k">val</span> <span class="n">recv</span>   <span class="o">:</span> <span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="n">bytes</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="n">msg_flag</span> <span class="kt">list</span> <span class="o">-&gt;</span> <span class="kt">int</span>
  <span class="k">val</span> <span class="n">send</span>   <span class="o">:</span> <span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="n">bytes</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="n">msg_flag</span> <span class="kt">list</span> <span class="o">-&gt;</span> <span class="kt">int</span>
  <span class="k">val</span> <span class="n">sleep</span>  <span class="o">:</span> <span class="kt">float</span> <span class="o">-&gt;</span> <span class="kt">unit</span>

  <span class="k">val</span> <span class="n">run</span> <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">end</span></code></pre></figure>

<p>Observe that the return type of the non-blocking function calls <code class="language-plaintext highlighter-rouge">accept</code>,
<code class="language-plaintext highlighter-rouge">recv</code>, <code class="language-plaintext highlighter-rouge">send</code> and <code class="language-plaintext highlighter-rouge">sleep</code> are the same as their blocking counterparts from
<a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Unix.html">Unix</a> module.</p>

<p>The asynchronous IO implementation works as follows. For each blocking action,
if the action can be performed immediately, then it is. Otherwise, the thread
performing the blocking task is suspended and add to a pool of threads waiting
to perform IO:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* Block until data is available to read on the socket. *)</span>
<span class="n">effect</span> <span class="nc">Blk_read</span>  <span class="o">:</span> <span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="c">(* Block until socket is writable. *)</span>
<span class="n">effect</span> <span class="nc">Blk_write</span> <span class="o">:</span> <span class="n">file_descr</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="c">(* Sleep for given number of seconds. *)</span>
<span class="n">effect</span> <span class="nc">Sleep</span> <span class="o">:</span> <span class="kt">float</span> <span class="o">-&gt;</span> <span class="kt">unit</span>

<span class="k">let</span> <span class="k">rec</span> <span class="n">core</span> <span class="n">f</span> <span class="o">=</span>
  <span class="k">match</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">with</span>
  <span class="o">...</span>
  <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Blk_read</span> <span class="n">fd</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span>
      <span class="k">if</span> <span class="n">poll_rd</span> <span class="n">fd</span> <span class="k">then</span> <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span>
      <span class="k">else</span> <span class="p">(</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="n">add</span> <span class="n">read_ht</span> <span class="n">fd</span> <span class="n">k</span><span class="p">;</span>
            <span class="n">dequeue</span> <span class="bp">()</span><span class="p">)</span>
  <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Blk_write</span> <span class="n">fd</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span>
      <span class="k">if</span> <span class="n">poll_wr</span> <span class="n">fd</span> <span class="k">then</span> <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span>
      <span class="k">else</span> <span class="p">(</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="n">add</span> <span class="n">write_ht</span> <span class="n">fd</span> <span class="n">k</span><span class="p">;</span>
            <span class="n">dequeue</span> <span class="bp">()</span><span class="p">)</span>
  <span class="o">|</span> <span class="n">effect</span> <span class="p">(</span><span class="nc">Sleep</span> <span class="n">t</span><span class="p">)</span> <span class="n">k</span> <span class="o">-&gt;</span>
        <span class="k">if</span> <span class="n">t</span> <span class="o">&lt;=</span> <span class="mi">0</span><span class="o">.</span> <span class="k">then</span> <span class="n">continue</span> <span class="n">k</span> <span class="bp">()</span>
        <span class="k">else</span> <span class="p">(</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="n">add</span> <span class="n">sleep_ht</span> <span class="p">(</span><span class="nn">Unix</span><span class="p">.</span><span class="n">gettimeofday</span> <span class="bp">()</span> <span class="o">+.</span> <span class="n">t</span><span class="p">)</span> <span class="n">k</span><span class="p">;</span>
              <span class="n">dequeue</span> <span class="bp">()</span><span class="p">)</span>

<span class="k">let</span> <span class="n">accept</span> <span class="n">fd</span> <span class="o">=</span>
  <span class="n">perform</span> <span class="p">(</span><span class="nc">Blk_read</span> <span class="n">fd</span><span class="p">);</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">accept</span> <span class="n">fd</span>

<span class="k">let</span> <span class="n">recv</span> <span class="n">fd</span> <span class="n">buf</span> <span class="n">pos</span> <span class="n">len</span> <span class="n">mode</span> <span class="o">=</span>
  <span class="n">perform</span> <span class="p">(</span><span class="nc">Blk_read</span> <span class="n">fd</span><span class="p">);</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">recv</span> <span class="n">fd</span> <span class="n">buf</span> <span class="n">pos</span> <span class="n">len</span> <span class="n">mode</span>

<span class="k">let</span> <span class="n">send</span> <span class="n">fd</span> <span class="n">bus</span> <span class="n">pos</span> <span class="n">len</span> <span class="n">mode</span> <span class="o">=</span>
  <span class="n">perform</span> <span class="p">(</span><span class="nc">Blk_write</span> <span class="n">fd</span><span class="p">);</span>
  <span class="nn">Unix</span><span class="p">.</span><span class="n">send</span> <span class="n">fd</span> <span class="n">bus</span> <span class="n">pos</span> <span class="n">len</span> <span class="n">mode</span></code></pre></figure>

<p>The scheduler works by running all of the available threads until there are no
more threads to run. At this point, if there are threads that are waiting to
complete an IO operation, the scheduler invokes <code class="language-plaintext highlighter-rouge">select()</code> call and blocks
until one of the IO actions becomes available. The scheduler then resumes those
threads whose IO actions are now available:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* When there are no threads to run, perform blocking io. *)</span>
<span class="k">let</span> <span class="n">perform_io</span> <span class="n">timeout</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">rd_fds</span> <span class="o">=</span> <span class="nn">Hashtbl</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">fd</span> <span class="n">_</span> <span class="n">acc</span> <span class="o">-&gt;</span> <span class="n">fd</span><span class="o">::</span><span class="n">acc</span><span class="p">)</span> <span class="n">read_ht</span> <span class="bp">[]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">wr_fds</span> <span class="o">=</span> <span class="nn">Hashtbl</span><span class="p">.</span><span class="n">fold</span> <span class="p">(</span><span class="k">fun</span> <span class="n">fd</span> <span class="n">_</span> <span class="n">acc</span> <span class="o">-&gt;</span> <span class="n">fd</span><span class="o">::</span><span class="n">acc</span><span class="p">)</span> <span class="n">write_ht</span> <span class="bp">[]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">rdy_rd_fds</span><span class="o">,</span> <span class="n">rdy_wr_fds</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">select</span> <span class="n">rd_fds</span> <span class="n">wr_fds</span> <span class="bp">[]</span> <span class="n">timeout</span> <span class="k">in</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">resume</span> <span class="n">ht</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="bp">()</span>
  <span class="o">|</span> <span class="n">x</span><span class="o">::</span><span class="n">xs</span> <span class="o">-&gt;</span>
      <span class="n">enqueue</span> <span class="p">(</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="n">find</span> <span class="n">ht</span> <span class="n">x</span><span class="p">);</span>
      <span class="nn">Hashtbl</span><span class="p">.</span><span class="n">remove</span> <span class="n">ht</span> <span class="n">x</span><span class="p">;</span>
      <span class="n">resume</span> <span class="n">ht</span> <span class="n">xs</span>
  <span class="k">in</span>
  <span class="n">resume</span> <span class="n">read_ht</span> <span class="n">rdy_rd_fds</span><span class="p">;</span>
  <span class="n">resume</span> <span class="n">write_ht</span> <span class="n">rdy_wr_fds</span><span class="p">;</span>
  <span class="k">if</span> <span class="n">timeout</span> <span class="o">&gt;=</span> <span class="mi">0</span><span class="o">.</span> <span class="k">then</span> <span class="n">ignore</span> <span class="p">(</span><span class="n">wakeup</span> <span class="p">(</span><span class="nn">Unix</span><span class="p">.</span><span class="n">gettimeofday</span> <span class="bp">()</span><span class="p">))</span> <span class="k">else</span> <span class="bp">()</span><span class="p">;</span>
  <span class="n">dequeue</span> <span class="bp">()</span></code></pre></figure>

<p>The
<a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/aio.ml">program</a>
implements a simple echo server. The server listens on localhost port 9301. It
accepts multiple clients and echoes back to the client any data sent to the
server. This server is a direct-style reimplementation of the echo server found
<a href="http://www.mega-nerd.com/erikd/Blog/CodeHacking/Ocaml/ocaml_select.html">here</a>,
which implements the echo server in CPS style:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* Repeat what the client says until the client goes away. *)</span>
<span class="k">let</span> <span class="k">rec</span> <span class="n">echo_server</span> <span class="n">sock</span> <span class="n">addr</span> <span class="o">=</span>
  <span class="k">try</span>
    <span class="k">let</span> <span class="n">data</span> <span class="o">=</span> <span class="n">recv</span> <span class="n">sock</span> <span class="mi">1024</span> <span class="k">in</span>
    <span class="k">if</span> <span class="nn">String</span><span class="p">.</span><span class="n">length</span> <span class="n">data</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span>
      <span class="p">(</span><span class="n">ignore</span> <span class="p">(</span><span class="n">send</span> <span class="n">sock</span> <span class="n">data</span><span class="p">);</span>
       <span class="n">echo_server</span> <span class="n">sock</span> <span class="n">addr</span><span class="p">)</span>
    <span class="k">else</span>
      <span class="k">let</span> <span class="n">cn</span> <span class="o">=</span> <span class="n">string_of_sockaddr</span> <span class="n">addr</span> <span class="k">in</span>
      <span class="p">(</span><span class="n">printf</span> <span class="s2">&quot;echo_server : client (%s) disconnected.</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">cn</span><span class="p">;</span>
       <span class="n">close</span> <span class="n">sock</span><span class="p">)</span>
  <span class="k">with</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">close</span> <span class="n">sock</span></code></pre></figure>

<p>The echo server can be tested with a telnet client by starting the server and
on the same machine running <code class="language-plaintext highlighter-rouge">telnet localhost 9301</code>.</p>

<h2>Conclusion</h2>

<p>The aim of the post is to illustrate the variety of alternative programming
paradigms that arise due to algebraic effects and handlers, and hopefully
kindle interest in reasoning and programming with effects and handlers in
OCaml. Algebraic effects and handlers support in OCaml is in active development
within the context of <a href="https://github.com/ocamllabs/ocaml-multicore">multicore
OCaml</a>. When you find those
inevitable bugs, please report them to the <a href="https://github.com/ocamllabs/ocaml-multicore/issues">issue
tracker</a>.</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p><a href="http://arxiv.org/pdf/1203.1539v1.pdf">Programming with Algebraic Effects and Handlers (pdf)</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Eff" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="http://eb.host.cs.st-andrews.ac.uk/drafts/effects.pdf">Programming and Reasoning with Algebraic Effects and Dependent Types (pdf)</a>&nbsp;<a href="https://kcsrk.info/atom-ocaml.xml#fnref:Idris-eff" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
  </ol>
</div>

