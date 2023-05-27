---
title: 'Reading Camlp4, part 11: syntax extensions'
description: In this final (?) post in my series on Camlp4, I want at last to cover
  syntax extensions. A nontrivial syntax extension involves almost all ...
url: http://ambassadortothecomputers.blogspot.com/2010/09/reading-camlp4-part-11-syntax.html
date: 2010-09-11T00:16:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>In this final (?) post in my series on Camlp4, I want at last to cover syntax extensions. A nontrivial syntax extension involves almost all the topics we have <a href="http://ambassadortothecomputers.blogspot.com/p/reading-camlp4.html">previously covered</a>, so it seems fitting that we treat them last.</p> 
<b>Extending grammars</b> 
<p>In the post on <a href="http://ambassadortothecomputers.blogspot.com/2010/05/reading-camlp4-part-6-parsing.html">parsing</a> we covered Camlp4 grammars but stopped short of explaining how to extend them. Well, this is not completely true: we used the <code>EXTEND</code> form to extend an empty grammar, and we can also use it to extend non-empty grammars. We saw a small example of this when implementing <a href="http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-8-implementing.html">quotations</a>, where we extended the JSON grammar with a new <code>json_eoi</code> entry (which refered to an entry in the original grammar). Rules and levels may also be added to existing entries, and rules may be deleted.</p> 
 
<p>Let&rsquo;s look at a complete syntax extension, which demonstrates modifying Camlp4&rsquo;s OCaml grammar. The purpose of the extension is to change the precedence of the method call operator <code>#</code> to make &ldquo;method chaining&rdquo; read better. For example, if the <code>foo</code> method returns an object, you can write</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="n">obj</span><span class="o">#</span><span class="n">foo</span> <span class="s2">&quot;bar&quot;</span> <span class="o">#</span><span class="n">baz</span> 
</code></pre> 
</div> 
<p>to call the <code>baz</code> method, rather than needing</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">(</span><span class="n">obj</span><span class="o">#</span><span class="n">foo</span> <span class="s2">&quot;bar&quot;</span><span class="o">)#</span><span class="n">baz</span> 
</code></pre> 
</div> 
<p>(I originally wrote this for use with the <a href="http://github.com/jaked/ocamljs/tree/master/src/jquery/"><code>jQuery</code> binding for <code>ocamljs</code></a>; method chaining is common with <code>jQuery</code>.)</p> 
 
<p>Here is the extension:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">open</span> <span class="nc">Camlp4</span> 
  
  <span class="k">module</span> <span class="nc">Id</span> <span class="o">:</span> <span class="nn">Sig</span><span class="p">.</span><span class="nc">Id</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">let</span> <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;pa_jquery&quot;</span> 
    <span class="k">let</span> <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.1&quot;</span> 
  <span class="k">end</span> 
  
  <span class="k">module</span> <span class="nc">Make</span> <span class="o">(</span><span class="nc">Syntax</span> <span class="o">:</span> <span class="nn">Sig</span><span class="p">.</span><span class="nc">Camlp4Syntax</span><span class="o">)</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">open</span> <span class="nc">Sig</span> 
    <span class="k">include</span> <span class="nc">Syntax</span> 
  
    <span class="nc">DELETE_RULE</span> <span class="nc">Gram</span> <span class="n">expr</span><span class="o">:</span> <span class="nc">SELF</span><span class="o">;</span> <span class="s2">&quot;#&quot;</span><span class="o">;</span> <span class="n">label</span> <span class="nc">END</span><span class="o">;</span> 
  
    <span class="nc">EXTEND</span> <span class="nc">Gram</span> 
      <span class="n">expr</span><span class="o">:</span> <span class="nc">BEFORE</span> <span class="s2">&quot;apply&quot;</span> 
        <span class="o">[</span> <span class="s2">&quot;#&quot;</span> <span class="nc">LEFTA</span> 
          <span class="o">[</span> <span class="n">e</span> <span class="o">=</span> <span class="nc">SELF</span><span class="o">;</span> <span class="s2">&quot;#&quot;</span><span class="o">;</span> <span class="n">lab</span> <span class="o">=</span> <span class="n">label</span> <span class="o">-&gt;</span> 
              <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">#</span> <span class="o">$</span><span class="n">lab</span><span class="o">$</span> <span class="o">&gt;&gt;</span> <span class="o">]</span> 
        <span class="o">];</span> 
    <span class="nc">END</span> 
  <span class="k">end</span> 
  
  <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Register</span><span class="p">.</span><span class="nc">OCamlSyntaxExtension</span><span class="o">(</span><span class="nc">Id</span><span class="o">)(</span><span class="nc">Make</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>To make sense of a syntax extension it&rsquo;s helpful to refer to <code>Camlp4OCamlRevisedParser.ml</code> (which defines the revised syntax grammar) and <code>Camlp4OCamlParser.ml</code> (which defines the original syntax as an extension of the revised syntax). There we see that the <code>#</code> operator is parsed in the <code>expr</code> entry, in a level called &rdquo;<code>.</code>&rdquo; (which includes other dereferencing operators), and that this level appears below the <code>apply</code> level, which parses function application. Recall from the <a href="http://ambassadortothecomputers.blogspot.com/2010/05/reading-camlp4-part-6-parsing.html">parsing</a> post that operators in lower levels bind more tightly. So to get the effect we want, we need to move the <code>#</code> rule above the <code>apply</code> level in the grammar.</p> 
 
<p>First we delete the rule from its original location: <code>DELETE_RULE</code> takes the grammar, the entry, and the symbols on the left-hand side of the rule, followed by <code>END</code>; you don&rsquo;t have to say in what level it appears. Then we add the rule at a new location: we create a new level <code>#</code> containing the rule from the original grammar, and add it before the level named <code>apply</code>.</p> 
 
<p>There are several ways to specify where a level is inserted: <code>BEFORE</code> <em>level</em> and <code>AFTER</code> <em>level</em> put it before or after some other level; <code>LEVEL</code> <em>level</em> adds rules to an existing level (you will be warned but not stopped from changing the label or associativity of the level); <code>FIRST</code> and <code>LAST</code> put the level before or after all other levels. If you don&rsquo;t specify, rules are added to the topmost level in the entry. The resulting grammar works just as if you had given it all at once, making the insertions in the specified places. (However, it is not very clear from the code how ordering works when inserting rules into an existing level; it is perhaps best not to rely on the order of rules in a level anyway.)</p> 
 
<p>Finally we register the extension. The <code>Make</code> argument to <code>OCamlSyntaxExtension</code> returns a <code>Sig.Camlp4Syntax</code> for some reason (in <code>Register.ml</code> it is just ignored) so we <code>include Syntax</code> to provide it.</p> 
 
<p>(The complete code for this example is <a href="http://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/camlp4-syntax-extensions/pa_jquery">here</a>.)</p> 
<b>Transforming the AST</b> 
<p>Let&rsquo;s do a slightly more complicated example involving some transformation of the parsed AST. It often comes up that we want to <code>let</code>-bind the value of an expression to a name, trapping exceptions, then evaluate the body of the <code>let</code> outside the scope of the exception handler. This is a bit painful to write in stock OCaml; we can only straightforwardly express trapping exceptions in the whole <code>let</code> expression:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">try</span> <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">e1</span> <span class="k">in</span> <span class="n">e2</span> 
  <span class="k">with</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">h</span> 
</code></pre> 
</div> 
<p>A nice alternative is to use thunks to delay the evaluation of the body, doing it outside the scope of the <code>try</code>/<code>with</code>:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">(</span><span class="k">try</span> <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">e1</span> <span class="k">in</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">e2</span> 
   <span class="k">with</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">h</span><span class="o">)</span><span class="bp">()</span> 
</code></pre> 
</div> 
<p>(We must thunkify the exception handler to make the types work out.) This is simple enough to do by hand, but let&rsquo;s give it some syntactic sugar:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="k">try</span> <span class="n">x</span> <span class="o">=</span> <span class="n">e1</span> <span class="k">in</span> <span class="n">e2</span> 
  <span class="k">with</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">h</span> 
</code></pre> 
</div> 
<p>which should expand to the thunkified version above. (The idea and syntax are taken from Martin Jambon&rsquo;s <a href="http://martin.jambon.free.fr/micmatch.html">micmatch</a> extension.)</p> 
 
<p>Let&rsquo;s look at the existing rules in <code>Camlp4OCamlRevisedParser.ml</code> for <code>let</code> and <code>try</code> to get an idea of how to parse the <code>let</code>/<code>try</code> form:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">[</span> <span class="s2">&quot;let&quot;</span><span class="o">;</span> <span class="n">r</span> <span class="o">=</span> <span class="n">opt_rec</span><span class="o">;</span> <span class="n">bi</span> <span class="o">=</span> <span class="n">binding</span><span class="o">;</span> <span class="s2">&quot;in&quot;</span><span class="o">;</span> <span class="n">x</span> <span class="o">=</span> <span class="nc">SELF</span> <span class="o">-&gt;</span> 
      <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="k">let</span> <span class="o">$</span><span class="k">rec</span><span class="o">:</span><span class="n">r</span><span class="o">$</span> <span class="o">$</span><span class="n">bi</span><span class="o">$</span> <span class="k">in</span> <span class="o">$</span><span class="n">x</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
  <span class="o">...</span> 
  <span class="o">|</span> <span class="s2">&quot;try&quot;</span><span class="o">;</span> <span class="n">e</span> <span class="o">=</span> <span class="n">sequence</span><span class="o">;</span> <span class="s2">&quot;with&quot;</span><span class="o">;</span> <span class="n">a</span> <span class="o">=</span> <span class="n">match_case</span> <span class="o">-&gt;</span> 
      <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="k">try</span> <span class="o">$</span><span class="n">mksequence'</span> <span class="o">_</span><span class="n">loc</span> <span class="n">e</span><span class="o">$</span> <span class="k">with</span> <span class="o">[</span> <span class="o">$</span><span class="n">a</span><span class="o">$</span> <span class="o">]</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>For <code>let</code>, the <code>opt_rec</code> entry parses an optional <code>rec</code> keyword (we see there is a special antiquotation for interpolating <code>rec</code>). <code>Binding</code> parses a group of bindings separated by <code>and</code>. <code>SELF</code> is just <code>expr</code>. For <code>try</code>, <code>sequence</code> is a sequence of expressions separated by <code>;</code>, and <code>match_case</code> is a group of match cases separated by <code>|</code>. (These entries are both a little different in the original syntax, to account for the different semicolon rules and the <code>[]</code> delimiters around the match cases.) Recall that <code>Camlp4OCamlRevisedParser.ml</code> uses the revised syntax quotations, so we have <code>[]</code> around the match cases. The call to <code>mksequence'</code> just wraps a <code>do {}</code> around a sequence if necessary; more on this below.</p> 
 
<p>The parsing rule we want is a combination of these. Here is the extension:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="nc">EXTEND</span> <span class="nc">Gram</span> 
    <span class="n">expr</span><span class="o">:</span> <span class="nc">LEVEL</span> <span class="s2">&quot;top&quot;</span> <span class="o">[</span> 
      <span class="o">[</span> <span class="s2">&quot;let&quot;</span><span class="o">;</span> <span class="s2">&quot;try&quot;</span><span class="o">;</span> <span class="n">r</span> <span class="o">=</span> <span class="n">opt_rec</span><span class="o">;</span> <span class="n">bi</span> <span class="o">=</span> <span class="n">binding</span><span class="o">;</span> <span class="s2">&quot;in&quot;</span><span class="o">;</span> 
        <span class="n">e</span> <span class="o">=</span> <span class="n">sequence</span><span class="o">;</span> <span class="s2">&quot;with&quot;</span><span class="o">;</span> <span class="n">a</span> <span class="o">=</span> <span class="n">match_case</span> <span class="o">-&gt;</span> 
          <span class="k">let</span> <span class="n">a</span> <span class="o">=</span> 
            <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
              <span class="o">(</span><span class="k">function</span> 
                 <span class="o">|</span> <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">p</span><span class="o">$</span> <span class="k">when</span> <span class="o">$</span><span class="n">w</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> 
                     <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">&lt;</span> 
                       <span class="o">$</span><span class="n">p</span><span class="o">$</span> <span class="k">when</span> <span class="o">$</span><span class="n">w</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> 
                     <span class="o">&gt;&gt;</span> 
                 <span class="o">|</span> <span class="n">mc</span> <span class="o">-&gt;</span> <span class="n">mc</span><span class="o">)</span> 
              <span class="o">(</span><span class="nn">Ast</span><span class="p">.</span><span class="n">list_of_match_case</span> <span class="n">a</span> <span class="bp">[]</span><span class="o">)</span> <span class="k">in</span> 
          <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> 
            <span class="o">(</span><span class="k">try</span> <span class="k">let</span> <span class="o">$</span><span class="k">rec</span><span class="o">:</span><span class="n">r</span><span class="o">$</span> <span class="o">$</span><span class="n">bi</span><span class="o">$</span> <span class="k">in</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="k">do</span> <span class="o">{</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">}</span> 
             <span class="k">with</span> <span class="o">[</span> <span class="o">$</span><span class="kt">list</span><span class="o">:</span><span class="n">a</span><span class="o">$</span> <span class="o">])</span><span class="bp">()</span> 
          <span class="o">&gt;&gt;</span> 
      <span class="o">]</span> 
    <span class="o">];</span> 
  <span class="nc">END</span> 
</code></pre> 
</div> 
<p>We put <code>rec</code> after <code>try</code> (following <code>micmatch</code>), which is a little weird <s>, but if we put it before we would need to look ahead to
disambiguate `let` from `let try`; once we parse `opt_rec` we are
committed to one rule or the other</s> ; instead we could start the rule <code>&quot;let&quot;; r = opt_rec; &quot;try&quot;</code>, which has no ambiguity with the ordinary <code>let</code> rule because the <code>&quot;let&quot;; opt_rec</code> prefix is factored out; the parser doesn&rsquo;t choose between the rules until it tries to parse <code>try</code>. After <code>in</code> we parse <code>sequence</code> rather than <code>SELF</code>; this seems like a good choice because there is a <code>with</code> to end the sequence.</p> 
 
<p>Now, to transform the AST, we map over the match cases. The <code>match_case</code> entry returns a list of cases separated by <code>Ast.McOr</code>; we call <code>list_of_match_case</code> to get an ordinary list. For each case, we match the pattern, <code>when</code> clause, and expression on the right-hand side (these are packaged in an <code>Ast.McArr</code>, where the <code>when</code> clause field is <code>Ast.ExNil</code> if there is no <code>when</code> clause), and return it with the expression thunkified. Then we return the whole <code>let</code> inside <code>try</code>, with the body sequence thunkified.</p> 
 
<p>We have to add a <code>do {}</code> around the body, creating an <code>Ast.ExSeq</code> node, because that&rsquo;s what is expected by <code>Camlp4Ast2OCamlAst.ml</code>&mdash;recall from the <a href="http://ambassadortothecomputers.blogspot.com/2010/03/reading-camlp4-part-5-filters.html">filters</a> post that the Camlp4 AST is translated to an OCaml AST and marshalled to the compiler. If we forget this (and &ldquo;we&rdquo; often forget these idiosyncrasies) then we get the error &rdquo;<code>expr; expr: not allowed here, use do {...} or [|...|] to surround them</code>&rdquo;, which is pretty helpful as these errors go.</p> 
 
<p>(The complete code for this example is <a href="http://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/camlp4-syntax-extensions/pa_let_try">here</a>.)</p> 
<b>Extending pattern matching</b> 
<p>As a final example, let&rsquo;s extend OCaml&rsquo;s pattern syntax. In the <a href="http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-9-implementing.html">quotations</a> post we noted that JSON quotations in a pattern are not very useful, because we would usually like a pattern to match even if the fields of an object come in a different order or there are extra fields. To keep the code short let&rsquo;s abstract the problem a little and consider matching association lists: if we write a match case</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">|</span> <span class="n">alist</span> <span class="o">[</span> <span class="s2">&quot;foo&quot;</span><span class="o">,</span> <span class="n">x</span><span class="o">;</span> <span class="s2">&quot;bar&quot;</span><span class="o">,</span> <span class="n">y</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">e</span> 
</code></pre> 
</div> 
<p>we would like it to match association lists with <code>&quot;foo&quot;</code> and <code>&quot;bar&quot;</code> keys, in any order, with any extra pairs in the list. Our translation looks like this:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">|</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span> <span class="k">when</span> 
      <span class="o">(</span><span class="k">match</span> <span class="o">((</span><span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;foo&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span><span class="o">)</span> 
               <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="o">),</span> 
              <span class="o">(</span><span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;bar&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span><span class="o">)</span> 
               <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="o">))</span> 
       <span class="k">with</span> 
       <span class="o">|</span> <span class="o">(</span><span class="nc">Some</span> <span class="n">x</span><span class="o">,</span> <span class="nc">Some</span> <span class="n">y</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="bp">true</span> 
       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="o">)</span> 
      <span class="o">-&gt;</span> 
      <span class="o">(</span><span class="k">match</span> <span class="o">((</span><span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;foo&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span><span class="o">)</span> 
               <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="o">),</span> 
              <span class="o">(</span><span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;bar&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span><span class="o">)</span> 
               <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="o">))</span> 
       <span class="k">with</span> 
       <span class="o">|</span> <span class="o">(</span><span class="nc">Some</span> <span class="n">x</span><span class="o">,</span> <span class="nc">Some</span> <span class="n">y</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">e</span> 
       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>This might seem overcomplicated, and it is true that we could simplify it for this case. But the built-in pattern syntax is complicated, and it is tricky handling all the cases to make things work smoothly; the strategy that produces the code above will handle some (but not all) of the complications. (We&rsquo;ll consider some improvements below.)</p> 
 
<p>The basic idea is that when we come to an <code>alist</code> we replace it with a new fresh name, then do further matching in a <code>when</code> clause, so if it fails we can continue to the next case by returning <code>false</code>. In the <code>when</code> clause we look up the keys, putting them in <code>option</code>s, then match on the <code>option</code>s; we handle nested patterns (to the right of a key) by embedding them in the <code>when</code> clause match. The <code>when</code> clause match also binds variables appearing in the original pattern, so they are available to the <code>when</code> clause of the original case (if there is one). Finally, we do the whole thing over again in the match case body to provide bindings to the original body.</p> 
 
<p>In order to implement this we&rsquo;ll use both a syntax extension and a filter. The reason is that we&rsquo;d like to extend the <code>patt</code> entry, but to do the AST transformation we sketched above we need to transform <code>match_case</code>s. We could replace the <code>match_case</code> part of the parser as well but that seems needlessly hairy, and generally when writing a syntax extension we&rsquo;d like to touch as little of the parser as possible so it interoperates well with other extensions.</p> 
 
<p>First, here is the syntax extension:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="nc">EXTEND</span> <span class="nc">Gram</span> 
    <span class="n">patt</span><span class="o">:</span> <span class="nc">LEVEL</span> <span class="s2">&quot;simple&quot;</span> 
    <span class="o">[[</span> 
       <span class="s2">&quot;alist&quot;</span><span class="o">;</span> <span class="s2">&quot;[&quot;</span><span class="o">;</span> 
         <span class="n">l</span> <span class="o">=</span> 
           <span class="nc">LIST0</span> 
             <span class="o">[</span> <span class="n">e</span> <span class="o">=</span> <span class="n">expr</span> <span class="nc">LEVEL</span> <span class="s2">&quot;simple&quot;</span><span class="o">;</span> <span class="s2">&quot;,&quot;</span><span class="o">;</span> 
               <span class="n">p</span> <span class="o">=</span> <span class="n">patt</span> <span class="nc">LEVEL</span> <span class="s2">&quot;simple&quot;</span> <span class="o">-&gt;</span> 
                 <span class="nn">Ast</span><span class="p">.</span><span class="nc">PaOlbi</span> <span class="o">(_</span><span class="n">loc</span><span class="o">,</span> <span class="s2">&quot;&quot;</span><span class="o">,</span> <span class="n">p</span><span class="o">,</span> <span class="n">e</span><span class="o">)</span> <span class="o">]</span> 
             <span class="nc">SEP</span> <span class="s2">&quot;;&quot;</span><span class="o">;</span> 
       <span class="s2">&quot;]&quot;</span> <span class="o">-&gt;</span> 
         <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span><span class="s2">&quot;alist&quot;</span><span class="o">$</span> <span class="o">$</span><span class="nn">Ast</span><span class="p">.</span><span class="n">paSem_of_list</span> <span class="n">l</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
    <span class="o">]];</span> 
  <span class="nc">END</span> 
</code></pre> 
</div> 
<p>We extend the <code>simple</code> level of the <code>patt</code> entry, which parses primitive patterns. Inside <code>alist []</code> we parse a list of <code>expr</code> / <code>patt</code> pairs; we parse <code>expr</code> at the <code>simple</code> level or else it would parse the whole pair as an <code>expr</code>, and the same for <code>patt</code> just in case. Then we return the pair of expression and pattern in an <code>Ast.PaOlbi</code> (ordinarily used for optional argument defaults in function definitions). Why? Well, we need to return something of type <code>patt</code>, but we need somehow to get the <code>expr</code> to our filter, and this is the only <code>patt</code> constructor that holds an <code>expr</code>. (As an alternative we could parse a <code>patt</code> instead of an <code>expr</code>, but then we&rsquo;d need to translate it to an <code>expr</code> at the point we use it.) Finally we return the list wrapped in a data constructor so we can recognize it easily in the filter; because it is lower-case, we can be sure that &ldquo;alist&rdquo; is not the identifier of a real data constructor.</p> 
 
<p>Now let&rsquo;s look at the filter. First, some helper functions:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">fresh</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">id</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span> 
    <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> 
      <span class="n">incr</span> <span class="n">id</span><span class="o">;</span> 
      <span class="s2">&quot;__pa_alist_patt_&quot;</span>  <span class="o">^</span> <span class="n">string_of_int</span> <span class="o">!</span><span class="n">id</span> 
 
  <span class="k">let</span> <span class="n">expr_tup_of_list</span> <span class="o">_</span><span class="n">loc</span> <span class="o">=</span> <span class="k">function</span> 
    <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="bp">()</span> <span class="o">&gt;&gt;</span> 
    <span class="o">|</span> <span class="o">[</span> <span class="n">v</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">v</span> 
    <span class="o">|</span> <span class="n">vs</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">tup</span><span class="o">:</span><span class="nn">Ast</span><span class="p">.</span><span class="n">exCom_of_list</span> <span class="n">vs</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
 
  <span class="k">let</span> <span class="n">patt_tup_of_list</span> <span class="o">_</span><span class="n">loc</span> <span class="o">=</span> <span class="k">function</span> 
    <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="bp">()</span> <span class="o">&gt;&gt;</span> 
    <span class="o">|</span> <span class="o">[</span> <span class="n">p</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">p</span> 
    <span class="o">|</span> <span class="n">ps</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">tup</span><span class="o">:</span><span class="nn">Ast</span><span class="p">.</span><span class="n">paCom_of_list</span> <span class="n">ps</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>We have a function to generate fresh names, a function to turn a list of expressions into a tuple, and a similar function for patterns. The reason we need these latter two is that a tuple with 0 or 1 elements is not allowed by <code>Camlp4Ast2OCamlAst.ml</code> (the empty &ldquo;tuple&rdquo; is actually a special identifier in the Camlp4 AST). Next, the main rewrite function:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">rewrite</span> <span class="o">_</span><span class="n">loc</span> <span class="n">p</span> <span class="n">w</span> <span class="n">e</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">k</span> <span class="o">=</span> <span class="n">ref</span> <span class="o">(</span><span class="k">fun</span> <span class="n">s</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="n">s</span><span class="o">)</span> <span class="k">in</span> 
</code></pre> 
</div> 
<p>The function takes the parts of an <code>Ast.McArr</code> (that is, a match case). We&rsquo;re going to map over the pattern <code>p</code>, building up a function <code>k</code> as we encounter nested <code>alist</code> forms. We want to generate the same matching code in the <code>when</code> clause and the body, so <code>k</code> is parameterized with an expression in case of success (the original <code>when</code> clause or the body) and in case of failure (<code>false</code> or <code>assert
false</code>). We will build <code>k</code> from the inside out, starting with a function that just returns the success expression.</p> 
<div class="highlight"><pre><code class="ocaml">    <span class="k">let</span> <span class="n">map</span> <span class="o">=</span> 
      <span class="k">object</span> 
        <span class="k">inherit</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">map</span> <span class="k">as</span> <span class="n">super</span> 
 
        <span class="k">method</span> <span class="n">patt</span> <span class="n">p</span> <span class="o">=</span> 
          <span class="k">match</span> <span class="n">super</span><span class="o">#</span><span class="n">patt</span> <span class="n">p</span> <span class="k">with</span> 
            <span class="o">|</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span><span class="s2">&quot;alist&quot;</span><span class="o">$</span> <span class="o">$</span><span class="n">l</span><span class="o">$</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> 
                <span class="k">let</span> <span class="n">id</span> <span class="o">=</span> <span class="n">fresh</span> <span class="bp">()</span> <span class="k">in</span> 
                <span class="k">let</span> <span class="n">l</span> <span class="o">=</span> 
                  <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
                    <span class="o">(</span><span class="k">function</span> 
                       <span class="o">|</span> <span class="nn">Ast</span><span class="p">.</span><span class="nc">PaOlbi</span> <span class="o">(_,</span> <span class="o">_,</span> <span class="n">p</span><span class="o">,</span> <span class="n">e</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">p</span><span class="o">,</span> <span class="n">e</span> 
                       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span><span class="o">)</span> 
                    <span class="o">(</span><span class="nn">Ast</span><span class="p">.</span><span class="n">list_of_patt</span> <span class="n">l</span> <span class="bp">[]</span><span class="o">)</span> <span class="k">in</span> 
                <span class="k">let</span> <span class="n">vs</span> <span class="o">=</span> 
                  <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
                    <span class="o">(</span><span class="k">fun</span> <span class="o">(_,</span> <span class="n">e</span><span class="o">)</span> <span class="o">-&gt;</span> 
                       <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> 
                         <span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">$</span><span class="n">lid</span><span class="o">:</span><span class="n">id</span><span class="o">$)</span> 
                         <span class="k">with</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span> 
                       <span class="o">&gt;&gt;)</span> 
                    <span class="n">l</span> <span class="k">in</span> 
                <span class="k">let</span> <span class="n">ps</span> <span class="o">=</span> 
                  <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
                    <span class="o">(</span><span class="k">fun</span> <span class="o">(</span><span class="n">p</span><span class="o">,</span> <span class="o">_)</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="nc">Some</span> <span class="o">$</span><span class="n">p</span><span class="o">$</span> <span class="o">&gt;&gt;)</span> 
                    <span class="n">l</span> <span class="k">in</span> 
                <span class="k">let</span> <span class="n">k'</span> <span class="o">=</span> <span class="o">!</span><span class="n">k</span> <span class="k">in</span> 
                <span class="n">k</span> <span class="o">:=</span> 
                  <span class="o">(</span><span class="k">fun</span> <span class="n">s</span> <span class="n">f</span> <span class="o">-&gt;</span> 
                     <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> 
                       <span class="k">match</span> <span class="o">$</span><span class="n">expr_tup_of_list</span> <span class="o">_</span><span class="n">loc</span> <span class="n">vs</span><span class="o">$</span> <span class="k">with</span> 
                         <span class="o">|</span> <span class="o">$</span><span class="n">patt_tup_of_list</span> <span class="o">_</span><span class="n">loc</span> <span class="n">ps</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">k'</span> <span class="n">s</span> <span class="n">f</span><span class="o">$</span> 
                         <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">f</span><span class="o">$</span> 
                     <span class="o">&gt;&gt;);</span> 
                <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">lid</span><span class="o">:</span><span class="n">id</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
            <span class="o">|</span> <span class="n">p</span> <span class="o">-&gt;</span> <span class="n">p</span> 
      <span class="k">end</span> <span class="k">in</span> 
</code></pre> 
</div> 
<p>The <code>Ast.map</code> object provides methods to map each syntactic class of the AST, along with default implementations which return the node unchanged. We extend it to walk over the pattern, leaving it unchanged except when we come to our special <code>alist</code> constructor. In that case we generate a fresh name, which we return as the value of the function. Then we extract the <code>expr</code> / <code>patt</code> pairs and map them to <code>try Some (List.assoc ...</code> expressions and <code>Some</code> patterns. Finally we extend <code>k</code> by matching all the expressions against all the patterns; if the match succeeds we call the previous <code>k</code>, otherwise the failure expression. Since we build <code>k</code> from the inside out, we transform subpatterns first (by matching over <code>super#patt p</code>).</p> 
<div class="highlight"><pre><code class="ocaml">    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="n">map</span><span class="o">#</span><span class="n">patt</span> <span class="n">p</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">w</span> <span class="o">=</span> <span class="k">match</span> <span class="n">w</span> <span class="k">with</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="bp">true</span> <span class="o">&gt;&gt;</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">w</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">w</span> <span class="o">=</span> <span class="o">!</span><span class="n">k</span> <span class="n">w</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="bp">false</span> <span class="o">&gt;&gt;</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">e</span> <span class="o">=</span> <span class="o">!</span><span class="n">k</span> <span class="n">e</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="k">assert</span> <span class="bp">false</span> <span class="o">&gt;&gt;</span> <span class="k">in</span> 
    <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">p</span><span class="o">$</span> <span class="k">when</span> <span class="o">$</span><span class="n">w</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>We call <code>map#patt</code> on <code>p</code> to replace special <code>alist</code> constructor nodes with fresh names and build up <code>k</code>, then call the resulting <code>k</code> on the <code>when</code> clause (if there is no <code>when</code> clause we replace it with <code>true</code>) and body, and finally return the result as a <code>match_case</code>, completing the rewrite function.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">filter</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">map</span> <span class="o">=</span> 
      <span class="k">object</span> 
        <span class="k">inherit</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">map</span> <span class="k">as</span> <span class="n">super</span> 
 
        <span class="k">method</span> <span class="n">match_case</span> <span class="n">mc</span> <span class="o">=</span> 
          <span class="k">match</span> <span class="n">super</span><span class="o">#</span><span class="n">match_case</span> <span class="n">mc</span> <span class="k">with</span> 
            <span class="o">|</span> <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">@_</span><span class="n">loc</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">p</span><span class="o">$</span> <span class="k">when</span> <span class="o">$</span><span class="n">w</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">e</span><span class="o">$</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> 
                <span class="n">rewrite</span> <span class="o">_</span><span class="n">loc</span> <span class="n">p</span> <span class="n">w</span> <span class="n">e</span> 
            <span class="o">|</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">e</span> 
      <span class="k">end</span> <span class="k">in</span> 
    <span class="n">map</span><span class="o">#</span><span class="n">str_item</span> 
 
  <span class="k">let</span> <span class="o">_</span> <span class="o">=</span> <span class="nn">AstFilters</span><span class="p">.</span><span class="n">register_str_item_filter</span> <span class="n">filter</span> 
</code></pre> 
</div> 
<p>We extend <code>Ast.map</code> again to call the rewrite function on each <code>match_case</code>, then register the resulting filter.</p> 
 
<p>The code above handles <code>when</code> clauses and nested <code>alist</code> patterns, and interacts properly with ordinary OCaml patterns. However, it completely falls down on nested pattern alternatives. If we write</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">match</span> <span class="n">x</span> <span class="k">with</span> 
  <span class="o">|</span> <span class="n">alist</span> <span class="o">[</span> <span class="s2">&quot;foo&quot;</span><span class="o">,</span> <span class="n">f</span> <span class="o">]</span> 
  <span class="o">|</span> <span class="n">alist</span> <span class="o">[</span> <span class="s2">&quot;fooz&quot;</span><span class="o">,</span> <span class="n">f</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">e</span> 
</code></pre> 
</div> 
<p>we get this mess:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">|</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span> <span class="o">|</span> <span class="o">__</span><span class="n">pa_alist_patt_2</span> <span class="k">when</span> 
      <span class="o">(</span><span class="k">match</span> <span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;fooz&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_2</span><span class="o">)</span> 
             <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span> 
       <span class="k">with</span> 
       <span class="o">|</span> <span class="nc">Some</span> <span class="n">f</span> <span class="o">-&gt;</span> 
           <span class="o">(</span><span class="k">match</span> <span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">assoc</span> <span class="s2">&quot;foo&quot;</span> <span class="o">__</span><span class="n">pa_alist_patt_1</span><span class="o">)</span> 
                  <span class="k">with</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="nc">None</span> 
            <span class="k">with</span> 
            <span class="o">|</span> <span class="nc">Some</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="bp">true</span> 
            <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="o">)</span> 
       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="o">)</span> 
      <span class="o">-&gt;</span> 
      <span class="o">...</span> <span class="c">(* the same mess for the body *)</span> 
</code></pre> 
</div> 
<p>The first problem is that both arms of an alternative must bind the same names, but we have replaced them with two different fresh names. The second problem is that we have blindly treated alternative <code>alist</code> patterns as being nested one inside the other. A solution to both these problems is to split nested alternatives into separate cases, at the cost of duplicating the <code>when</code> clause and body in each.</p> 
 
<p>Jeremy Yallop&rsquo;s <a href="http://code.google.com/p/ocaml-patterns">patterns</a> framework (see <a href="http://github.com/jaked/patterns">here</a> for an update that works with OCaml 3.12.0) allows multiple pattern extensions to coexist, and provides some common facilities to make them easier to write. In particular it splits nested alternatives into separate cases. Another deficiency in the code above is that it duplicates the match expression (built in <code>k</code>) in the <code>when</code> clause and body. This can be avoided by computing the body within the <code>when</code> clause, setting a reference, and dereferencing it in the body. However, the reference must be bound outside the <code>match_case</code> to be visible both in the <code>when</code> clause and the body, so this approach must transform each AST node that contains <code>match_case</code>s in order to bind the refs in the right place. The <code>patterns</code> framework handles this as well.</p> 
 
<p>(The complete code for this example is <a href="http://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/camlp4-syntax-extensions/pa_alist_patt">here</a>. A version using the <code>patterns</code> framework is <a href="http://github.com/jaked/patterns/blob/master/applications/alist/pa_alist.ml">here</a>.)</p>
