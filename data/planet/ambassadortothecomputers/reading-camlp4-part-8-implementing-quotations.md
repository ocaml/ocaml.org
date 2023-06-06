---
title: 'Reading Camlp4, part 8: implementing quotations'
description: The Camlp4 system of quotations and antiquotations is an awesome tool
  for producing  and consuming  OCaml ASTs. In this post (and the follow...
url: http://ambassadortothecomputers.blogspot.com/2010/08/reading-camlp4-part-8-implementing.html
date: 2010-08-03T23:47:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>The Camlp4 system of quotations and antiquotations is an awesome tool for <a href="http://ambassadortothecomputers.blogspot.com/2009/01/reading-camlp4-part-2-quotations_04.html">producing</a> and <a href="http://ambassadortothecomputers.blogspot.com/2009/01/reading-camlp4-part-4-consuming-ocaml.html">consuming</a> OCaml ASTs. In this post (and the following one) we will see how to provide this facility for other syntaxes and ASTs. Here we consider just quotations; we&rsquo;ll add antiquotations in the following post.</p> 
<b>An AST for JSON</b> 
<p>Our running example will be a quotation expander for <a href="http://www.ietf.org/rfc/rfc4627.txt">JSON</a>. Let&rsquo;s begin with the JSON AST, in a module <code>Jq_ast</code>:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> 
    <span class="o">|</span> <span class="nc">Jq_null</span> 
    <span class="o">|</span> <span class="nc">Jq_bool</span>   <span class="k">of</span> <span class="kt">bool</span> 
    <span class="o">|</span> <span class="nc">Jq_number</span> <span class="k">of</span> <span class="kt">float</span> 
    <span class="o">|</span> <span class="nc">Jq_string</span> <span class="k">of</span> <span class="kt">string</span> 
    <span class="o">|</span> <span class="nc">Jq_array</span>  <span class="k">of</span> <span class="n">t</span> <span class="kt">list</span> 
    <span class="o">|</span> <span class="nc">Jq_object</span> <span class="k">of</span> <span class="o">(</span><span class="kt">string</span> <span class="o">*</span> <span class="n">t</span><span class="o">)</span> <span class="kt">list</span> 
</code></pre> 
</div> 
<p>This is the same (modulo order and names) as <code>json_type</code> from the <a href="http://martin.jambon.free.fr/json-wheel.html">json-wheel</a> library, but for various reasons we will not be able to use <code>json_type</code>. The <code>Jq_</code> prefix is for <code>json_quot</code>, the name of this little library.</p> 
<b>Parsing JSON</b> 
<p>We&rsquo;ll use a Camlp4 <a href="http://ambassadortothecomputers.blogspot.com/2010/05/reading-camlp4-part-6-parsing.html">grammar</a> to parse JSON trees. It is not necessary to use Camlp4&rsquo;s parsing facilities in order to implement quotations&mdash;ultimately we will need to provide just a function from strings to ASTs, so we could use <code>ocamlyacc</code> or what-have-you instead&mdash;but it is convenient. Here is the parser:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">open</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nc">PreCast</span> 
  <span class="k">open</span> <span class="nc">Jq_ast</span> 
  
  <span class="k">module</span> <span class="nc">Gram</span> <span class="o">=</span> <span class="nc">MakeGram</span><span class="o">(</span><span class="nc">Lexer</span><span class="o">)</span> 
  <span class="k">let</span> <span class="n">json</span> <span class="o">=</span> <span class="nn">Gram</span><span class="p">.</span><span class="nn">Entry</span><span class="p">.</span><span class="n">mk</span> <span class="s2">&quot;json&quot;</span> 
  
  <span class="o">;;</span> 
  
  <span class="nc">EXTEND</span> <span class="nc">Gram</span> 
    <span class="n">json</span><span class="o">:</span> <span class="o">[[</span> 
        <span class="s2">&quot;null&quot;</span> <span class="o">-&gt;</span> <span class="nc">Jq_null</span> 
      <span class="o">|</span> <span class="s2">&quot;true&quot;</span> <span class="o">-&gt;</span> <span class="nc">Jq_bool</span> <span class="bp">true</span> 
      <span class="o">|</span> <span class="s2">&quot;false&quot;</span> <span class="o">-&gt;</span> <span class="nc">Jq_bool</span> <span class="bp">false</span> 
      <span class="o">|</span> <span class="n">i</span> <span class="o">=</span> <span class="nc">INT</span> <span class="o">-&gt;</span> <span class="nc">Jq_number</span> <span class="o">(</span><span class="n">float_of_string</span> <span class="n">i</span><span class="o">)</span> 
      <span class="o">|</span> <span class="n">f</span> <span class="o">=</span> <span class="nc">FLOAT</span> <span class="o">-&gt;</span> <span class="nc">Jq_number</span> <span class="o">(</span><span class="n">float_of_string</span> <span class="n">f</span><span class="o">)</span> 
      <span class="o">|</span> <span class="n">s</span> <span class="o">=</span> <span class="nc">STRING</span> <span class="o">-&gt;</span> <span class="nc">Jq_string</span> <span class="n">s</span> 
      <span class="o">|</span> <span class="s2">&quot;[&quot;</span><span class="o">;</span> <span class="n">es</span> <span class="o">=</span> <span class="nc">LIST0</span> <span class="n">json</span> <span class="nc">SEP</span> <span class="s2">&quot;,&quot;</span><span class="o">;</span> <span class="s2">&quot;]&quot;</span> <span class="o">-&gt;</span> <span class="nc">Jq_array</span> <span class="n">es</span> 
      <span class="o">|</span> <span class="s2">&quot;{&quot;</span><span class="o">;</span> 
          <span class="n">kvs</span> <span class="o">=</span> 
            <span class="nc">LIST0</span> 
              <span class="o">[</span> <span class="n">s</span> <span class="o">=</span> <span class="nc">STRING</span><span class="o">;</span> <span class="s2">&quot;:&quot;</span><span class="o">;</span> <span class="n">j</span> <span class="o">=</span> <span class="n">json</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">s</span><span class="o">,</span> <span class="n">j</span><span class="o">)</span> <span class="o">]</span> 
              <span class="nc">SEP</span> <span class="s2">&quot;,&quot;</span><span class="o">;</span> 
        <span class="s2">&quot;}&quot;</span> <span class="o">-&gt;</span> <span class="nc">Jq_object</span> <span class="n">kvs</span> 
    <span class="o">]];</span> 
  <span class="nc">END</span> 
</code></pre> 
</div> 
<p>We use the default Camlp4 lexer (with <code>MakeGram(Lexer)</code>); as we have seen, keywords mentioned in a Camlp4 grammar are added to the lexer, so we don&rsquo;t need to do anything special to lex <code>null</code> etc. However, while JSON/Javascript has a single number type, the default lexer returns different tokens for <code>INT</code> and <code>FLOAT</code> numbers, so we convert each to <code>Jq_number</code>. In fact, these tokens (along with <code>STRING</code>) represent OCaml <a href="http://caml.inria.fr/pub/docs/manual-ocaml/lex.html#integer-literal">integer</a>, <a href="http://caml.inria.fr/pub/docs/manual-ocaml/lex.html#float-literal">float</a> and <a href="http://caml.inria.fr/pub/docs/manual-ocaml/lex.html#string-literal">string</a> literals, which do not exactly match the corresponding JSON ones, but they are fairly close so let&rsquo;s not worry about it for now; we&rsquo;ll revisit the lexer in a later post.</p> 
 
<p>The parser itself is pleasingly compact; we can make good use of the <code>LIST0</code> special symbol and an anonymous entry for parsing objects. Unfortunately things will get a little more complicated when we come to antiquotations.</p> 
<b>Lifting the AST</b> 
<p>Next we need to &ldquo;lift&rdquo; values of the JSON AST to values of the OCaml AST. What does &ldquo;lift&rdquo; mean, and why do we need to do it? The goal is to convert quotations in OCaml code, such as</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="o">&lt;:</span><span class="n">json</span><span class="o">&lt;</span> <span class="o">[</span> <span class="mi">1</span><span class="o">,</span> <span class="s2">&quot;foo&quot;</span><span class="o">,</span> <span class="bp">true</span> <span class="o">]</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>into the equivalent</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> 
    <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_array</span> <span class="o">[</span> 
      <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_number</span> <span class="mi">1</span><span class="o">.;</span> 
      <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_string</span> <span class="s2">&quot;foo&quot;</span><span class="o">;</span> 
      <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_bool</span> <span class="bp">true</span> 
    <span class="o">]</span> 
</code></pre> 
</div> 
<p>This is to happen as part of Camlp4 preprocessing, which produces an OCaml AST, so what we produce in place of the <code>&lt;:json&lt; ... &gt;&gt;</code> expression must be a fragment of OCaml AST. We have a parser which takes a valid JSON string to the JSON AST; what remains is to take a JSON AST value to the corresponding OCaml AST. So we need a function with cases something like:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">|</span> <span class="nc">Jq_null</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="nc">Jq_null</span> <span class="o">&gt;&gt;</span> 
  <span class="o">|</span> <span class="nc">Jq_number</span> <span class="n">n</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="nc">Jq_number</span> <span class="o">$`</span><span class="n">flo</span><span class="o">:</span><span class="n">n</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
  <span class="o">|</span> <span class="o">...</span> 
</code></pre> 
</div> 
<p>It is not such a big deal to hand-write this lifting function for a small AST like JSON, but it is arduous and error-prone for full-size ASTs. Fortunately Camlp4 has a filter which does it for us. Let&rsquo;s first look at the signature of the <code>Jq_ast</code> module:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">open</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nc">PreCast</span> 
  
  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as above *)</span> 
  
  <span class="k">module</span> <span class="nc">MetaExpr</span> <span class="o">:</span> 
  <span class="k">sig</span> 
    <span class="k">val</span> <span class="n">meta_t</span> <span class="o">:</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">loc</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">expr</span> 
  <span class="k">end</span> 
  
  <span class="k">module</span> <span class="nc">MetaPatt</span> <span class="o">:</span> 
  <span class="k">sig</span> 
    <span class="k">val</span> <span class="n">meta_t</span> <span class="o">:</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">loc</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">patt</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>The generated modules <code>MetaExpr</code> and <code>MetaPatt</code> provide functions to lift a JSON AST to either an OCaml <code>expr</code> (when the quotation appears as an expression) or <code>patt</code> (when it appears as a pattern). The <code>loc</code> arguments are inserted into the resulting OCaml AST so that compile errors have correct locations.</p> 
 
<p>Now the implementation of <code>Jq_ast</code>:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">module</span> <span class="nc">Jq_ast</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">type</span> <span class="kt">float</span><span class="k">'</span> <span class="o">=</span> <span class="kt">float</span> 
  
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="c">(* almost as above *)</span> 
        <span class="o">...</span> 
      <span class="o">|</span> <span class="nc">Jq_number</span> <span class="k">of</span> <span class="kt">float</span><span class="k">'</span> 
        <span class="o">...</span> 
  <span class="k">end</span> 
  
  <span class="k">include</span> <span class="nc">Jq_ast</span> 
  
  <span class="k">open</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nc">PreCast</span> <span class="c">(* for Ast refs in generated code *)</span> 
  
  <span class="k">module</span> <span class="nc">MetaExpr</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">let</span> <span class="n">meta_float'</span> <span class="o">_</span><span class="n">loc</span> <span class="n">f</span> <span class="o">=</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="o">$`</span><span class="n">flo</span><span class="o">:</span><span class="n">f</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
    <span class="k">include</span> <span class="nn">Camlp4Filters</span><span class="p">.</span><span class="nc">MetaGeneratorExpr</span><span class="o">(</span><span class="nc">Jq_ast</span><span class="o">)</span> 
  <span class="k">end</span> 
  
  <span class="k">module</span> <span class="nc">MetaPatt</span> <span class="o">=</span> 
  <span class="k">struct</span> 
    <span class="k">let</span> <span class="n">meta_float'</span> <span class="o">_</span><span class="n">loc</span> <span class="n">f</span> <span class="o">=</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$`</span><span class="n">flo</span><span class="o">:</span><span class="n">f</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
    <span class="k">include</span> <span class="nn">Camlp4Filters</span><span class="p">.</span><span class="nc">MetaGeneratorPatt</span><span class="o">(</span><span class="nc">Jq_ast</span><span class="o">)</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>The file needs the <code>Camlp4MetaGenerator</code> filter (the <code>camlp4.metagenerator</code> package with <code>findlib</code>). The main idea is that the calls to <code>Camlp4Filters.MetaGenerator{Expr,Patt}</code> are expanded into the lifting functions. But there are a couple of fussy details:</p> 
 
<p>First: The argument module <code>Jq_ast</code> which we pass to the generators is used both on the left and right of the generated function; if you look at the generated code there are cases like:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">|</span> <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_null</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">expr</span><span class="o">&lt;</span> <span class="nn">Jq_ast</span><span class="p">.</span><span class="nc">Jq_null</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>(The <code>&lt;:expr&lt; .. &gt;&gt;</code> is already expanded in the actual generated code.) We need the AST to be available qualified by the module <code>Jq_ast</code> both in the current file and also in code that uses the quotation. So we have a nested <code>Jq_ast</code> module (for local uses, on the left-hand side) which we <code>include</code> (for external uses, on the right-hand side).</p> 
 
<p>Second: The generators scan all the types defined in the current module, then generate code from the last-appearing recursive bundle. (In this case the recursive bundle contains just <code>t</code>, but in general there can be more than one; mutually recursive lifting functions are generated.) There are some special cases for predefined types, and in particular for <code>float</code>; however, it seems to be wrong:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="n">meta_float</span> <span class="o">_</span><span class="n">loc</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Ast</span><span class="p">.</span><span class="nc">ExFlo</span> <span class="o">(_</span><span class="n">loc</span><span class="o">,</span> <span class="n">s</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>The <code>ExFlo</code> constructor takes a string representing the float, but calls to this function are generated when you use <code>float</code> in your type. To work around this, we define the type <code>float'</code> (on its own rather than as part of the last-appearing recursive bundle, or else Camlp4 would generate a <code>meta_float'</code> that calls <code>meta_float</code>), and provide correct <code>meta_float'</code> functions. There is a similar bug with <code>meta_int</code>, but <code>meta_bool</code> is correct, so our <code>Jq_bool</code> case does not need fixing.</p> 
 
<p>(It is interesting to contrast this approach of lifting the AST with how it is handled in Template Haskell using the &ldquo;scrap your boilerplate&rdquo; pattern; see Geoffrey Mainland&rsquo;s paper <a href="http://www.eecs.harvard.edu/~mainland/publications/mainland07quasiquoting.pdf">Why It&rsquo;s Nice to be Quoted</a>.)</p> 
<b>Quotations</b> 
<p>Finally we can hook the parser and AST lifter into Camlp4&rsquo;s quotation machinery, in the <code>Jq_quotations</code> module:</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">open</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nc">PreCast</span> 
  
  <span class="k">module</span> <span class="nc">Q</span> <span class="o">=</span> <span class="nn">Syntax</span><span class="p">.</span><span class="nc">Quotation</span> 
  
  <span class="k">let</span> <span class="n">json_eoi</span> <span class="o">=</span> <span class="nn">Jq_parser</span><span class="p">.</span><span class="nn">Gram</span><span class="p">.</span><span class="nn">Entry</span><span class="p">.</span><span class="n">mk</span> <span class="s2">&quot;json_eoi&quot;</span> 
  
  <span class="nc">EXTEND</span> <span class="nn">Jq_parser</span><span class="p">.</span><span class="nc">Gram</span> 
    <span class="n">json_eoi</span><span class="o">:</span> <span class="o">[[</span> <span class="n">x</span> <span class="o">=</span> <span class="nn">Jq_parser</span><span class="p">.</span><span class="n">json</span><span class="o">;</span> <span class="nc">EOI</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">]];</span> 
  <span class="nc">END</span><span class="o">;;</span> 
  
  <span class="k">let</span> <span class="n">parse_quot_string</span> <span class="n">loc</span> <span class="n">s</span> <span class="o">=</span> 
    <span class="nn">Jq_parser</span><span class="p">.</span><span class="nn">Gram</span><span class="p">.</span><span class="n">parse_string</span> <span class="n">json_eoi</span> <span class="n">loc</span> <span class="n">s</span> 
  
  <span class="k">let</span> <span class="n">expand_expr</span> <span class="n">loc</span> <span class="o">_</span> <span class="n">s</span> <span class="o">=</span> 
    <span class="nn">Jq_ast</span><span class="p">.</span><span class="nn">MetaExpr</span><span class="p">.</span><span class="n">meta_t</span> <span class="n">loc</span> <span class="o">(</span><span class="n">parse_quot_string</span> <span class="n">loc</span> <span class="n">s</span><span class="o">)</span> 
  
  <span class="k">let</span> <span class="n">expand_str_item</span> <span class="n">loc</span> <span class="o">_</span> <span class="n">s</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">exp_ast</span> <span class="o">=</span> <span class="n">expand_expr</span> <span class="n">loc</span> <span class="nc">None</span> <span class="n">s</span> <span class="k">in</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">@</span><span class="n">loc</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">exp</span><span class="o">:</span><span class="n">exp_ast</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
  
  <span class="k">let</span> <span class="n">expand_patt</span> <span class="n">loc</span> <span class="o">_</span> <span class="n">s</span> <span class="o">=</span> 
    <span class="nn">Jq_ast</span><span class="p">.</span><span class="nn">MetaPatt</span><span class="p">.</span><span class="n">meta_t</span> <span class="n">loc</span> <span class="o">(</span><span class="n">parse_quot_string</span> <span class="n">loc</span> <span class="n">s</span><span class="o">)</span> 
  
  <span class="o">;;</span> 
  
  <span class="nn">Q</span><span class="p">.</span><span class="n">add</span> <span class="s2">&quot;json&quot;</span> <span class="nn">Q</span><span class="p">.</span><span class="nn">DynAst</span><span class="p">.</span><span class="n">expr_tag</span> <span class="n">expand_expr</span><span class="o">;</span> 
  <span class="nn">Q</span><span class="p">.</span><span class="n">add</span> <span class="s2">&quot;json&quot;</span> <span class="nn">Q</span><span class="p">.</span><span class="nn">DynAst</span><span class="p">.</span><span class="n">patt_tag</span> <span class="n">expand_patt</span><span class="o">;</span> 
  <span class="nn">Q</span><span class="p">.</span><span class="n">add</span> <span class="s2">&quot;json&quot;</span> <span class="nn">Q</span><span class="p">.</span><span class="nn">DynAst</span><span class="p">.</span><span class="n">str_item_tag</span> <span class="n">expand_str_item</span><span class="o">;</span> 
  <span class="nn">Q</span><span class="p">.</span><span class="n">default</span> <span class="o">:=</span> <span class="s2">&quot;json&quot;</span> 
</code></pre> 
</div> 
<p>First, we make a new grammar entry <code>json_eoi</code> which parses a <code>json</code> expression followed by the end-of-input token <code>EOI</code>. Grammar entries ordinarily ignore the rest of the input after a successful parse. If we were to use the <code>json</code> entry directly, we would silently accept quotations with trailing garbage, and in particular incorrect quotations that happen to have a correct prefix, rather than alerting the user.</p> 
 
<p>Then we register quotation expanders for the <code>&lt;:json&lt; &gt;&gt;</code> quotation in the <code>expr</code>, <code>patt</code>, and <code>str_item</code> contexts (<code>str_item</code> is useful because that is the context at the top level prompt), using <code>Syntax.Quotation.add</code>. All the expanders do is call the parser, then run the result through the appropriate lifting function.</p> 
 
<p>Finally we set <code>json</code> as the default quotation, so we can just say <code>&lt;&lt; &gt;&gt;</code> for JSON quotations. This is perhaps a bit cheeky, since the user may want something else as the default quotation; whichever module is loaded last wins.</p> 
 
<p>It is worth reflecting on how the quotation mechanism works in the OCaml parser: There is a lexer token for quotations, but no node in the OCaml AST, so everything must happen in the parser. When a quotation is lexed, its entire contents is returned as a string. (Nested quotations are matched in the lexer&mdash;see <code>quotation</code> and <code>antiquot</code> in <code>camlp4/Camlpl4/Struct/Lexer.mll</code>&mdash;without considering the embedded syntax; this makes the <code>&lt;&lt;</code> and <code>&gt;&gt;</code> tokens unusable in the embedded syntax.) The string is then expanded according to the table of registered expanders; expanders return a fragment of OCaml AST which is inserted into the parse tree.</p> 
 
<p>You might have thought (as I did) that something fancy happens with quotations, e.g. Camlp4 switches to a different parser on the fly, then back to the original parser for antiquotations. But it is much simpler than that. At the same time, it is much more complicated than that, as we will see next time when we cover antiquotations (and in particular how nested antiquotations/quotations are handled).</p> 
 
<p>(You can find the complete code <a href="http://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/camlp4-implementing-quotations">here</a>, including a pretty-printer and integration with the top level; after building and installing you can say e.g.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">#</span> <span class="o">&lt;&lt;</span> <span class="o">[</span> <span class="mi">1</span><span class="o">,</span> <span class="s2">&quot;foo&quot;</span><span class="o">,</span> <span class="bp">true</span> <span class="o">]</span> <span class="o">&gt;&gt;;;</span> 
  <span class="o">-</span> <span class="o">:</span> <span class="nn">Jq_ast</span><span class="p">.</span><span class="n">t</span> <span class="o">=</span> <span class="o">[</span> <span class="mi">1</span><span class="o">,</span> <span class="s2">&quot;foo&quot;</span><span class="o">,</span> <span class="bp">true</span> <span class="o">]</span> 
</code></pre> 
</div> 
<p>although without antiquotations it is not very useful.)</p>
