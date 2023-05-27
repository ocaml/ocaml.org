---
title: 'Reading Camlp4, part 6: parsing'
description: "In this post I want to discuss Camlp4\u2019s stream parsers  and grammars
  . Since the OCaml parsers in Camlp4 (which we touched on previously ) u..."
url: http://ambassadortothecomputers.blogspot.com/2010/05/reading-camlp4-part-6-parsing.html
date: 2010-05-20T04:22:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>In this post I want to discuss Camlp4&rsquo;s <em>stream parsers</em> and <em>grammars</em>. Since the OCaml parsers in Camlp4 (which we touched on <a href="http://ambassadortothecomputers.blogspot.com/2009/01/reading-camlp4-part-3-quotations-in.html">previously</a>) use them, it&rsquo;s necessary to understand them in order to write syntax extensions; independently, they are a nice alternative to <code>ocamlyacc</code> and other parser generators. Stream parsers and grammars are outlined for the old Camlp4 in the <a href="http://caml.inria.fr/pub/docs/tutorial-camlp4/">tutorial</a> and <a href="http://caml.inria.fr/pub/docs/manual-camlp4/">manual</a>, but some of the details have changed, and there are many aspects of grammars which are given only a glancing treatment in that material.</p> 
<b>Streams and stream parsers</b> 
<p>Parsers generated from Camlp4 grammars are built on stream parsers, so let&rsquo;s start there. It will be easier to explain grammars with this background in hand, and we will see that it is sometimes useful to drop down to stream parsers when writing grammars.</p> 
 
<p>A <em>stream</em> of type <code>'a Stream.t</code> is a sequence of elements of type <code>'a</code>. Elements of a stream are accessed sequentially; reading the first element of a stream has the side effect of advancing the stream to the next element. You can also peek ahead into a stream without advancing it. Camlp4 provides a syntax extension for working with streams, which expands to operations on the <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Stream.html">Stream</a> module of the standard library.</p> 
 
<p>There are various ways to make a stream but we&rsquo;ll focus on consuming them; for testing you can make a literal stream with the syntax <code>[&lt; '&quot;foo&quot;; '&quot;bar&quot;; '&quot;baz&quot; &gt;]</code>&mdash;note the extra single-quotes. With the <code>parser</code> keyword we can write a function to consume a stream by pattern-matching over prefixes of the stream:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">p</span> <span class="o">=</span> <span class="n">parser</span> 
  <span class="o">|</span> <span class="o">[&lt;</span> <span class="k">'</span><span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="k">'</span><span class="n">x</span><span class="o">;</span> <span class="k">'</span><span class="s2">&quot;bar&quot;</span> <span class="o">&gt;]</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo-bar+&quot;</span> <span class="o">^</span> <span class="n">x</span> 
  <span class="o">|</span> <span class="o">[&lt;</span> <span class="k">'</span><span class="s2">&quot;baz&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">p</span> <span class="o">&gt;]</span> <span class="o">-&gt;</span> <span class="s2">&quot;baz+&quot;</span> <span class="o">^</span> <span class="n">y</span> 
</code></pre> 
</div> 
<p>The syntax <code>'&quot;foo&quot;</code> means match a value <code>&quot;foo&quot;</code>; <code>'x</code> means match any value, binding it to <code>x</code>, which can be used on the right-hand side of the match as usual; and <code>y = p</code> means call the parser <code>p</code> on the rest of the stream, binding the result to <code>y</code>. You probably get the rough idea, but let&rsquo;s run it through Camlp4 to see exactly what&rsquo;s happening:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">p</span> <span class="o">(__</span><span class="n">strm</span> <span class="o">:</span> <span class="o">_</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="o">=</span> 
  <span class="k">match</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">peek</span> <span class="o">__</span><span class="n">strm</span> <span class="k">with</span> 
  <span class="o">|</span> <span class="nc">Some</span> <span class="s2">&quot;foo&quot;</span> <span class="o">-&gt;</span> 
      <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="n">junk</span> <span class="o">__</span><span class="n">strm</span><span class="o">;</span> 
       <span class="o">(</span><span class="k">match</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">peek</span> <span class="o">__</span><span class="n">strm</span> <span class="k">with</span> 
        <span class="o">|</span> <span class="nc">Some</span> <span class="n">x</span> <span class="o">-&gt;</span> 
            <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="n">junk</span> <span class="o">__</span><span class="n">strm</span><span class="o">;</span> 
             <span class="o">(</span><span class="k">match</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">peek</span> <span class="o">__</span><span class="n">strm</span> <span class="k">with</span> 
              <span class="o">|</span> <span class="nc">Some</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="n">junk</span> <span class="o">__</span><span class="n">strm</span><span class="o">;</span> <span class="s2">&quot;foo-bar+&quot;</span> <span class="o">^</span> <span class="n">x</span><span class="o">)</span> 
              <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="nc">Error</span> <span class="s2">&quot;&quot;</span><span class="o">)))</span> 
        <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="nc">Error</span> <span class="s2">&quot;&quot;</span><span class="o">)))</span> 
  <span class="o">|</span> <span class="nc">Some</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> 
      <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="n">junk</span> <span class="o">__</span><span class="n">strm</span><span class="o">;</span> 
       <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> 
         <span class="o">(</span><span class="k">try</span> <span class="n">p</span> <span class="o">__</span><span class="n">strm</span> 
          <span class="k">with</span> <span class="o">|</span> <span class="nn">Stream</span><span class="p">.</span><span class="nc">Failure</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="nc">Error</span> <span class="s2">&quot;&quot;</span><span class="o">))</span> 
       <span class="k">in</span> <span class="s2">&quot;baz+&quot;</span> <span class="o">^</span> <span class="n">y</span><span class="o">)</span> 
  <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="nn">Stream</span><span class="p">.</span><span class="nc">Failure</span> 
</code></pre> 
</div> 
<p>We can see that &ldquo;parser&rdquo; is perhaps a strong word for this construct; it&rsquo;s really just a nested pattern match. The generated function <code>peek</code>s the next element in the stream, then <code>junk</code>s it once it finds a match (advancing the stream to the next element). If there&rsquo;s no match on the first token, that&rsquo;s a <code>Stream.Failure</code> (the stream is not advanced, giving us the opportunity to try another parser); but once we have matched the first token, a subsequent match failure is a <code>Stream.Error</code> (we have committed to a branch, and advanced the stream; if the parse fails now we can&rsquo;t try another parser).</p> 
 
<p>A call to another parser as the first element of the pattern is treated specially: for this input</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">p</span> <span class="o">=</span> <span class="n">parser</span> 
  <span class="o">|</span> <span class="o">[&lt;</span> <span class="n">x</span> <span class="o">=</span> <span class="n">q</span> <span class="o">&gt;]</span> <span class="o">-&gt;</span> <span class="n">x</span> 
  <span class="o">|</span> <span class="o">[&lt;</span> <span class="k">'</span><span class="s2">&quot;bar&quot;</span> <span class="o">&gt;]</span> <span class="o">-&gt;</span> <span class="s2">&quot;bar&quot;</span> 
</code></pre> 
</div> 
<p>we get</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="k">rec</span> <span class="n">p</span> <span class="o">(__</span><span class="n">strm</span> <span class="o">:</span> <span class="o">_</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">t</span><span class="o">)</span> <span class="o">=</span> 
  <span class="k">try</span> <span class="n">q</span> <span class="o">__</span><span class="n">strm</span> 
  <span class="k">with</span> 
  <span class="o">|</span> <span class="nn">Stream</span><span class="p">.</span><span class="nc">Failure</span> <span class="o">-&gt;</span> 
      <span class="o">(</span><span class="k">match</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">peek</span> <span class="o">__</span><span class="n">strm</span> <span class="k">with</span> 
       <span class="o">|</span> <span class="nc">Some</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="nn">Stream</span><span class="p">.</span><span class="n">junk</span> <span class="o">__</span><span class="n">strm</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span><span class="o">)</span> 
       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="nn">Stream</span><span class="p">.</span><span class="nc">Failure</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>So there is a limited means of backtracking: if <code>q</code> fails with <code>Stream.Failure</code> (meaning that the stream has not been advanced) we try the next arm of the parser.</p> 
 
<p>It&rsquo;s easy to see what would happen if we were to use the same literal as the first element of more than one arm: the first one gets the match. Same if we were to make a recursive call (to the same parser) as the first element: we&rsquo;d get an infinite loop, since it&rsquo;s just a function call. So we can&rsquo;t give arbitrary BNF-like grammars to <code>parser</code>. We could use it as a convenient way to hand-write a recursive-descent parser, but we won&rsquo;t pursue that idea here. Instead, let&rsquo;s turn to Camlp4&rsquo;s grammars, which specify a recursive-descent parser using a BNF-like syntax.</p> 
<b>Grammars</b> 
<p>Here is a complete example of a grammar:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">open</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nc">PreCast</span> 
<span class="k">module</span> <span class="nc">Gram</span> <span class="o">=</span> <span class="nc">MakeGram</span><span class="o">(</span><span class="nc">Lexer</span><span class="o">)</span> 
<span class="k">let</span> <span class="n">expr</span> <span class="o">=</span> <span class="nn">Gram</span><span class="p">.</span><span class="nn">Entry</span><span class="p">.</span><span class="n">mk</span> <span class="s2">&quot;expr&quot;</span> 
<span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">x</span> <span class="o">=</span> <span class="nc">LIDENT</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo-bar+&quot;</span> <span class="o">^</span> <span class="n">x</span> 
     <span class="o">|</span> <span class="s2">&quot;baz&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="s2">&quot;baz+&quot;</span> <span class="o">^</span> <span class="n">y</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
<span class="o">;;</span> 
<span class="k">try</span> 
  <span class="n">print_endline</span> 
    <span class="o">(</span><span class="nn">Gram</span><span class="p">.</span><span class="n">parse_string</span> <span class="n">expr</span> <span class="nn">Loc</span><span class="p">.</span><span class="n">ghost</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">argv</span><span class="o">.(</span><span class="mi">1</span><span class="o">))</span> 
<span class="k">with</span> <span class="nn">Loc</span><span class="p">.</span><span class="nc">Exc_located</span> <span class="o">(_,</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="n">x</span> 
</code></pre> 
</div> 
<p>You can build it with the following command:</p> 
<div class="highlight"><pre><code class="bash">ocamlfind ocamlc <span class="se">\</span> 
   -linkpkg -syntax camlp4o <span class="se">\</span> 
  -package camlp4.extend -package camlp4.lib <span class="se">\</span> 
  grammar1.ml -o grammar1
</code></pre> 
</div> 
<p>Let&rsquo;s cover the infrastructure before investigating <code>EXTEND</code>. We have a grammar module <code>Gram</code> which we got from <code>Camlp4.PreCast</code>; this is an empty grammar using a default lexer. We have an <em>entry</em> (a grammar nonterminal) <code>expr</code>, which is an OCaml value. We can parse a string starting at an entry using <code>Gram.parse_string</code> (we have to pass it an initial location). We trap <code>Loc.Exc_located</code> (which attaches a location to exceptions raised in parsing) and re-raise the underlying exception so it gets printed. (In subsequent examples I will give just the <code>EXTEND</code> block.)</p> 
 
<p>One way to approach <code>EXTEND</code> is to run the file through Camlp4 (<code>camlp4of</code> has the required syntax extension) to see what we get. This is fun, but the result does not yield much insight; it&rsquo;s just a simple transformation of the input, passed to <code>Gram.extend</code>. This is the entry point to a pretty hairy bunch of code that generates a recursive descent parser from the value representing the grammar. Let&rsquo;s take a different tack: <a href="http://caml.inria.fr/pub/docs/manual-camlp4/manual005.html">RTFM</a>, then run some experiments to shine light in places where the fine manual is a bit dim.</p> 
 
<p>First, what language is parsed by the grammar above? It looks pretty similar to the stream parser example. But what is <code>LIDENT</code>? The stream parser example works with a stream of strings. Here we are working with a stream of tokens, produced by the <code>Lexer</code> module; there is a variant defining the token types in <code>PreCast.mli</code>. The default lexer is OCaml-specific (but it&rsquo;s often good enough for other purposes); a <code>LIDENT</code> is an OCaml lowercase identifier. A literal string (like <code>&quot;foo&quot;</code>) indicates a <code>KEYWORD</code> token; using it in a grammar registers the keyword with the lexer. So the grammar can parse strings like <code>foo quux bar</code> or <code>baz foo quux bar</code>, but not <code>foo bar bar</code>, since <code>bar</code> is a <code>KEYWORD</code> not a <code>LIDENT</code>.</p> 
 
<p>Most tokens have associated strings; <code>x = LIDENT</code> puts the associated string in <code>x</code>. Keywords are given in double quotes (<code>x = KEYWORD</code> works, but I can&rsquo;t think of a good use for it). You can also use pattern-matching syntax (e.g. <code>`LIDENT x</code>) to get at the actual token constructor, which may carry more than just a string.</p> 
 
<p>You can try the example and see that the lexer takes care of whitespace and OCaml comments. You&rsquo;ll also notice that the parser ignores extra tokens after a successful parse; to avoid it we need an <code>EOI</code> token to indicate the end of the input (but I haven&rsquo;t bothered here).</p> 
<b>Left-factoring</b> 
<p>What happens if two rules start with the same token?</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>If this were a stream parser, the first arm would always match when the next token is <code>foo</code>; if the subsequent token is <code>baz</code> then the parse fails. But with a grammar, the <em>rule</em>s (arms, for a grammar) are <em>left-factored</em>: when there is a common prefix of <em>symbol</em>s (a symbol is a keyword, token, or entry&mdash;and we will see some others later) among different rules, the parser doesn&rsquo;t choose which rule to use until the common prefix has been parsed. You can think of a factored grammar as a tree, where the nodes are symbols and the leaves are <em>action</em>s (the right-hand side of a rule is the rule&rsquo;s action); when a symbol distinguishes two rules, that&rsquo;s a branching point. (In fact, this is how grammars are implemented: first the corresponding tree is generated, then the parser is generated from the tree.)</p> 
 
<p>What if one rule is a prefix of another?</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>In this case the parser is greedy: if the next token is <code>baz</code>, it uses the second rule, otherwise the first. To put it another way, a token or keyword is preferred over <em>epsilon</em>, the empty string (and this holds for other ways that a grammar can match epsilon&mdash;see below about special symbols).</p> 
 
<p>What if two rules call the same entry?</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">f</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>First, what is this <code>GLOBAL</code>? By default, all entries are global, meaning that they must be pre-defined with <code>Gram.Entry.mk</code>. The <code>GLOBAL</code> declaration gives a list of entries which are global, and makes the rest local, so we don&rsquo;t need to pre-define them, but we can&rsquo;t refer to them outside the grammar. Second, note that we can call entries without binding the result to a variable, and that rules don&rsquo;t need an action&mdash;in that case they return <code>()</code>. You can try it and see that factoring works on entries too. Maybe this is slightly surprising, if you&rsquo;re thinking about the rules as parse-time alternatives, but factoring happens when the parser is built.</p> 
 
<p>What about an entry vs. a token?</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">f</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;baz&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span><span class="o">;</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>Both rules parse the same language, but an explicit token or keyword trumps an entry or other symbol, so the second rule is used. You can try it and see that the order of the rules doesn&rsquo;t matter.</p> 
 
<p>What about two different entries?</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f1</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f2</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>Factoring happens only within a rule, so the parser doesn&rsquo;t know that <code>f1</code> and <code>f2</code> parse the same language. It commits to the first rule after parsing <code>foo</code>; if after parsing <code>quux</code> it then sees <code>baz</code>, it doesn&rsquo;t backtrack and try the second rule, so the parse fails. If you switch the order of the rules, then <code>baz</code> succeeds but <code>bar</code> fails.</p> 
<b>Local backtracking</b> 
<p>Why have two identical entries in the previous example? If we make them different, something a little surprising happens:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;xyzzy&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f1</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+bar&quot;</span> 
     <span class="o">|</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> <span class="n">f2</span><span class="o">;</span> <span class="s2">&quot;baz&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;foo+baz&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>Now we can parse both <code>foo quux bar</code> and <code>foo xyzzy baz</code>. How does this work? It takes a little digging into the implementation (which I will spare you) to see what&rsquo;s happening: the <code>&quot;foo&quot;</code> keyword is factored into a common prefix, then we have a choice between <code>f1</code> and <code>f2</code>. A choice betwen entries generates a stream parser, with an arm for each entry which calls the entry&rsquo;s parser. As we saw in the stream parsers sections, calling another parser in the first position of a match compiles to a limited form of backtracking. So in the example, if <code>f1</code> fails with <code>Stream.Failure</code> (which it does when the next token is not <code>quux</code>) then the parser tries to parse <code>f2</code> instead.</p> 
 
<p>Local backtracking works only when the parser is at a branch point (e.g. a choice between two entries), and when the called entry does not itself commit and advance the stream (in which case <code>Stream.Error</code> is raised on a parse error instead of <code>Stream.Failure</code>). Here is an example that fails the first criterion:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;xyzzy&quot;</span> <span class="o">]];</span> 
  <span class="n">g1</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;plugh&quot;</span> <span class="o">]];</span> 
  <span class="n">g2</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;plugh&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="n">g1</span><span class="o">;</span> <span class="n">f1</span> <span class="o">-&gt;</span> <span class="s2">&quot;f1&quot;</span> 
     <span class="o">|</span> <span class="n">g2</span><span class="o">;</span> <span class="n">f2</span> <span class="o">-&gt;</span> <span class="s2">&quot;f2&quot;</span> 
     <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>After parsing <code>g1</code>, the parser has committed to the first rule, so it&rsquo;s not possible to backtrack and try the second if <code>f1</code> fails.</p> 
 
<p>Here&rsquo;s an example that fails the second criterion:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">g</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;plugh&quot;</span> <span class="o">]];</span> 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;xyzzy&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> <span class="n">f1</span> <span class="o">-&gt;</span> <span class="s2">&quot;f1&quot;</span> <span class="o">|</span> <span class="n">f2</span> <span class="o">-&gt;</span> <span class="s2">&quot;f2&quot;</span> <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>When <code>f1</code> is called, after parsing <code>g</code> the parser is committed to <code>f1</code>, so if the next token is not <code>quux</code> the parse fails rather than backtracking.</p> 
 
<p>Local backtracking can be used to control parsing with explicit lookahead. We could repair the previous example as follows:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">test</span> <span class="o">=</span> 
  <span class="nn">Gram</span><span class="p">.</span><span class="nn">Entry</span><span class="p">.</span><span class="n">of_parser</span> <span class="s2">&quot;test&quot;</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">strm</span> <span class="o">-&gt;</span> 
       <span class="k">match</span> <span class="nn">Stream</span><span class="p">.</span><span class="n">npeek</span> <span class="mi">2</span> <span class="n">strm</span> <span class="k">with</span> 
         <span class="o">|</span> <span class="o">[</span> <span class="o">_;</span> <span class="nc">KEYWORD</span> <span class="s2">&quot;xyzzy&quot;</span><span class="o">,</span> <span class="o">_</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="nn">Stream</span><span class="p">.</span><span class="nc">Failure</span> 
         <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="o">)</span> 
<span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">g</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;plugh&quot;</span> <span class="o">]];</span> 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;xyzzy&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> <span class="n">test</span><span class="o">;</span> <span class="n">f1</span> <span class="o">-&gt;</span> <span class="s2">&quot;f1&quot;</span> <span class="o">|</span> <span class="n">f2</span> <span class="o">-&gt;</span> <span class="s2">&quot;f2&quot;</span> <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>We create an entry from a stream parser with <code>Gram.Entry.of_parser</code>. This could do some useful parsing and return a value just like any other entry, but here we just want to cause a backtrack (by raising <code>Stream.Failure</code>) if the token <em>after</em> the next one is <code>xyzzy</code>. We can see it with <code>Stream.npeek 2</code>, which returns the next two tokens, but does not advance the stream. (The stream parser syntax is not useful here since it advances the stream on a match.) You can see several examples of this technique in <code>Camlp4OCamlParser.ml</code>.</p> 
 
<p>We have seen that for stream parsers, a match of a sequence of literals compiles to a nested pattern match; as soon as the first literal matches, we&rsquo;re committed to that arm. With grammars, however, a sequence of tokens (or keywords) is matched all at once: enough tokens are <code>peek</code>ed; if all match then the stream is advanced past all of them; if any fail to match, <code>Stream.Failure</code> is raised. So in the first example of this section, <code>f1</code> could be any sequence of tokens, and local backtracking would still work. Or it could be a sequence of tokens followed by some non-tokens; as long as the failure happens in the sequence of tokens, local backtracking would still work.</p> 
<b>Self-calls</b> 
<p>Consider the following grammar:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">b</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;b&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;a&quot;</span> <span class="o">-&gt;</span> <span class="s2">&quot;a&quot;</span> <span class="o">|</span> <span class="n">b</span> <span class="o">-&gt;</span> <span class="s2">&quot;b&quot;</span> <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>We&rsquo;ve seen that a choice of entries generates a stream parser with an arm for each entry, and also that a call to another parser in a stream parser match is just a function call. So it seems like the parser should go into a loop before parsing anything.</p> 
 
<p>However, Camlp4 gives calls to the entry being defined (&ldquo;self-calls&rdquo;) special treatment. The rules of an entry actually generate two parsers, the &ldquo;start&rdquo; and &ldquo;continue&rdquo; parsers (these names are taken from the code). When a self-call appears as the first symbol of a rule, the rest of the rule goes into the continue parser; otherwise the whole rule goes into the start parser. An entry is parsed starting with the start parser; a successful parse is followed by the continue parser. So in the example, we first parse using just the second rule, to get things off the ground, then parse using just the first rule. If there are no start rules (that is, all rules begin with self-calls) the parser doesn&rsquo;t loop, but it fails without parsing anything.</p> 
<b>Levels and precedence</b> 
<p>I am sorry to say that I have not been completely honest with you. I have made it seem like entries consist of a list of rules in double square brackets. In fact, entries are lists of <em>level</em>s, in single square brackets, and each level consists of a list of rules, also in single square brackets. So each of the examples so far has contained only a single level. Here is an example with multiple levels:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[</span> <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;+&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;-&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">-</span> <span class="n">y</span> <span class="o">]</span> 
    <span class="o">|</span> <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;*&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;/&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">/</span> <span class="n">y</span> <span class="o">]</span> 
    <span class="o">|</span> <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="nc">INT</span> <span class="o">-&gt;</span> <span class="n">int_of_string</span> <span class="n">x</span> 
      <span class="o">|</span> <span class="s2">&quot;(&quot;</span><span class="o">;</span> <span class="n">e</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;)&quot;</span> <span class="o">-&gt;</span> <span class="n">e</span> <span class="o">]</span> <span class="o">];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>(You&rsquo;ll need a <code>string_of_int</code> to use this grammar with the earlier framework.) The idea with levels is that parsing begins at the topmost level; if no rule applies in the current level, then the next level down is tried. Furthermore, when making a self-call, call at the current level (or the following level; see below) rather than at the top. This gives a way to implement operator precedence: order the operators top to bottom from loosest- to tightest-binding.</p> 
 
<p>Why does this work? The multi-level grammar is just a &ldquo;stratified&rdquo; grammar, with a little extra support from Camlp4; we could write it manually like this:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">add_expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="n">x</span> <span class="o">=</span> <span class="n">add_expr</span><span class="o">;</span> <span class="s2">&quot;+&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">mul_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span> 
     <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">add_expr</span><span class="o">;</span> <span class="s2">&quot;-&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">mul_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">-</span> <span class="n">y</span> 
     <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">mul_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> 
     <span class="o">]];</span> 
 
  <span class="n">mul_expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="n">x</span> <span class="o">=</span> <span class="n">mul_expr</span><span class="o">;</span> <span class="s2">&quot;*&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">base_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span> 
     <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">mul_expr</span><span class="o">;</span> <span class="s2">&quot;/&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">base_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">/</span> <span class="n">y</span> 
     <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">base_expr</span> <span class="o">-&gt;</span> <span class="n">x</span> 
     <span class="o">]];</span> 
 
  <span class="n">base_expr</span><span class="o">:</span> 
    <span class="o">[[</span> 
       <span class="n">x</span> <span class="o">=</span> <span class="nc">INT</span> <span class="o">-&gt;</span> <span class="n">int_of_string</span> <span class="n">x</span> 
     <span class="o">|</span> <span class="s2">&quot;(&quot;</span><span class="o">;</span> <span class="n">e</span> <span class="o">=</span> <span class="n">add_expr</span><span class="o">;</span> <span class="s2">&quot;)&quot;</span> <span class="o">-&gt;</span> <span class="n">e</span> 
     <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> <span class="o">[[</span> <span class="n">add_expr</span> <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>When parsing a <code>mul_expr</code>, for instance, we don&rsquo;t want to parse an <code>add_expr</code> as a subexpression; <code>1 * 2 + 3</code> should not parse as <code>1 * (2 + 3)</code>. A stratified grammar just leaves out the rules for lower-precedence operators at each level. Why do we call <code>add_expr</code> on the left side of <code>+</code> but <code>mul_expr</code> on the right? This makes <code>+</code> left-associative; we parse <code>1 + 2 + 3</code> as <code>(1 + 2) + 3</code> since <code>add_expr</code> is a possibility only on the left. (For an ordinary recursive-descent parser we&rsquo;d want right-associativity to prevent looping, although the special treatment of self-calls makes the left-associative version work here.)</p> 
 
<p>Associativity works just the same with the multi-level grammar. By default, levels are left-associative: in the start parser (for a self-call as the first symbol of the rule), the self-call is made at the same level; in the continue parser, self-calls are made at the following level. For right-associativity it&rsquo;s the reverse, and for non-associativity both start and continue parsers call the following level. The associativity of a level can be specified by prefixing it with the keywords <code>NONA</code>, <code>LEFTA</code>, or <code>RIGHTA</code>. (Either I don&rsquo;t understand what non-associativity means, or <code>NONA</code> is broken; it seems to be the same as <code>LEFTA</code>.)</p> 
 
<p>Levels may be labelled, and the level to call may be given explicitly. So another way to write the same grammar is:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[</span> <span class="s2">&quot;add&quot;</span> 
      <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;mul&quot;</span><span class="o">;</span> <span class="s2">&quot;+&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;add&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;mul&quot;</span><span class="o">;</span> <span class="s2">&quot;-&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;add&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">-</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;mul&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">]</span> 
    <span class="o">|</span> <span class="s2">&quot;mul&quot;</span> 
      <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;base&quot;</span><span class="o">;</span> <span class="s2">&quot;*&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;mul&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;base&quot;</span><span class="o">;</span> <span class="s2">&quot;/&quot;</span><span class="o">;</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;mul&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">/</span> <span class="n">y</span> 
      <span class="o">|</span> <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;base&quot;</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">]</span> 
    <span class="o">|</span> <span class="s2">&quot;base&quot;</span> 
      <span class="o">[</span> <span class="n">x</span> <span class="o">=</span> <span class="nc">INT</span> <span class="o">-&gt;</span> <span class="n">int_of_string</span> <span class="n">x</span> 
      <span class="o">|</span> <span class="s2">&quot;[&quot;</span><span class="o">;</span> <span class="n">e</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="s2">&quot;]&quot;</span> <span class="o">-&gt;</span> <span class="n">e</span> <span class="o">]</span> <span class="o">];</span> 
<span class="nc">END</span> 
</code></pre> 
</div> 
<p>(Unfortunately, the left-associative version of this loops; explicitly specifying a level when calling an entry defeats the start / continue mechanism, since the call is not recognized as a self-call.) Calls to explicit levels can be used when calling other entries, too, not just for self calls. Level names are also useful for extending grammars, although we won&rsquo;t cover that here.</p> 
<b>Special symbols</b> 
<p>There are several special symbols: <code>SELF</code> refers to the entry being defined (at the current or following level depending on the associativity and the position of the symbol in the rule, as above); <code>NEXT</code> refers to the entry being defined, at the following level regardless of associativity or position.</p> 
 
<p>A list of zero or more items can be parsed with the syntax <code>LIST0</code> <em>elem</em>, where <em>elem</em> can be any other symbol. The return value has type <code>'a list</code> when <em>elem</em> has type <code>'a</code>. To parse separators between the elements use <code>LIST0</code> <em>elem</em> <code>SEP</code> <em>sep</em>; again <em>sep</em> can be any other symbol. <code>LIST1</code> means parse one or more items. An optional item can be parsed with <code>OPT</code> <em>elem</em>; the return value has type <code>'a
option</code>. (Both <code>LIST0</code> and <code>OPT</code> can match the empty string; see the note above about the treatment of epsilon.)</p> 
 
<p>Finally, a nested set of rules may appear in a rule, and acts like an anonymous entry (but can have only one level). For example, the rule</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="n">x</span> <span class="o">=</span> <span class="n">expr</span><span class="o">;</span> <span class="o">[</span><span class="s2">&quot;+&quot;</span> <span class="o">|</span> <span class="s2">&quot;plus&quot;</span><span class="o">];</span> <span class="n">y</span> <span class="o">=</span> <span class="n">expr</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span> 
</code></pre> 
</div> 
<p>parses both <code>1 + 2</code> and <code>1 plus 2</code>.</p> 
 
<p>Addendum: A new special symbol appeared in the 3.12.0 release, <code>TRY</code> <em>elem</em>, which provides non-local backtracking: a <code>Stream.Error</code> occurring in <em>elem</em> is converted to a <code>Stream.Failure</code>. (It works by running <em>elem</em> on an on-demand copy of the token stream; tokens are not consumed from the real token stream until <em>elem</em> succeeds.) <code>TRY</code> replaces most (all?) cases where you&rsquo;d need to drop down to a stream parser for lookahead. So another way to fix the local backtracking example above is:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="nc">EXTEND</span> <span class="nc">Gram</span> 
  <span class="nc">GLOBAL</span><span class="o">:</span> <span class="n">expr</span><span class="o">;</span> 
 
  <span class="n">g</span><span class="o">:</span> <span class="o">[[</span> <span class="s2">&quot;plugh&quot;</span> <span class="o">]];</span> 
  <span class="n">f1</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;quux&quot;</span> <span class="o">]];</span> 
  <span class="n">f2</span><span class="o">:</span> <span class="o">[[</span> <span class="n">g</span><span class="o">;</span> <span class="s2">&quot;xyzzy&quot;</span> <span class="o">]];</span> 
 
  <span class="n">expr</span><span class="o">:</span> 
    <span class="o">[[</span> <span class="nc">TRY</span> <span class="n">f1</span> <span class="o">-&gt;</span> <span class="s2">&quot;f1&quot;</span> <span class="o">|</span> <span class="n">f2</span> <span class="o">-&gt;</span> <span class="s2">&quot;f2&quot;</span> <span class="o">]];</span> 
<span class="nc">END</span> 
</code></pre> 
</div><hr/> 
<p>Almost the whole point of Camlp4 grammars is that they are extensible&mdash;you can add rules and levels to entries after the fact&mdash;so you can modify the OCaml parsers to make syntax extensions. But I am going to save that for a later post.</p>
