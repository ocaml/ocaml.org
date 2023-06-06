---
title: 'Reading Camlp4, part 5: filters'
description: Hey, long time no see!   It is high time to get back to Camlp4, so I
  would like to pick up the thread by covering Camlp4 filters . We have p...
url: http://ambassadortothecomputers.blogspot.com/2010/03/reading-camlp4-part-5-filters.html
date: 2010-03-03T02:09:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>Hey, long time no see!</p> 
<p>It is high time to get back to Camlp4, so I would like to pick up the thread by covering Camlp4 <em>filters</em>. We have previously considered the parsing and pretty-printing facilities of Camlp4 separately. But of course the most common way to use Camlp4 is as a front-end to <code>ocamlc</code>, where it processes files by parsing them into an AST and pretty-printing them back to text (well, not quite&mdash;we will see below how the AST is passed to <code>ocamlc</code>). In between we can insert filters to transform the AST.</p> 
<b>A simple filter</b> 
<p>So let&rsquo;s dive into an example: a filter for type definitions that generates <code>t_to_string</code> and <code>t_of_string</code> functions for a type <code>t</code>, a little like Haskell&rsquo;s <code>deriving Show, Read</code>. To keep it simple we handle only variant types, and only those where all the arms have no data. Here goes:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">module</span> <span class="nc">Make</span> <span class="o">(</span><span class="nc">AstFilters</span> <span class="o">:</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nn">Sig</span><span class="p">.</span><span class="nc">AstFilters</span><span class="o">)</span> <span class="o">=</span> 
<span class="k">struct</span> 
  <span class="k">open</span> <span class="nc">AstFilters</span> 
</code></pre> 
</div> 
<p>In order to hook into Camlp4&rsquo;s plugin mechanism we define the filter as a functor. By opening <code>AstFilters</code> we get an <code>Ast</code> module in scope. Unfortunately this is not the same <code>Ast</code> we got previously from <code>Camlp4.PreCast</code> (although it has the same signature) so all our code that uses <code>Ast</code> (including all OCaml syntax quotations) needs to go inside the functor body.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="k">let</span> <span class="k">rec</span> <span class="n">filter</span> <span class="n">si</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="n">wrap_str_item</span> <span class="n">si</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> <span class="k">type</span> <span class="o">$</span><span class="n">lid</span><span class="o">:</span><span class="n">tid</span><span class="o">$</span> <span class="o">=</span> <span class="o">$</span><span class="nn">Ast</span><span class="p">.</span><span class="nc">TySum</span> <span class="o">(_,</span> <span class="n">ors</span><span class="o">)$</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> 
          <span class="k">begin</span> 
            <span class="k">try</span> 
              <span class="k">let</span> <span class="n">cons</span> <span class="o">=</span> 
                <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
                  <span class="o">(</span><span class="k">function</span> 
                     <span class="o">|</span> <span class="o">&lt;:</span><span class="n">ctyp</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">&gt;&gt;</span> <span class="o">-&gt;</span> <span class="n">c</span> 
                     <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="nc">Exit</span><span class="o">)</span> 
                  <span class="o">(</span><span class="nn">Ast</span><span class="p">.</span><span class="n">list_of_ctyp</span> <span class="n">ors</span> <span class="bp">[]</span><span class="o">)</span> <span class="k">in</span> 
              <span class="n">to_of_string</span> <span class="n">si</span> <span class="n">tid</span> <span class="n">cons</span> 
            <span class="k">with</span> <span class="nc">Exit</span> <span class="o">-&gt;</span> <span class="n">si</span> 
          <span class="k">end</span> 
       <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">si</span> 
</code></pre> 
</div> 
<p>The <code>filter</code> function filters <code>Ast.str_item</code>s. (It is not actually recursive but we say <code>let rec</code> so we can define helper functions afterward). If a <code>str_item</code> has the right form we transform it by calling <code>to_of_string</code>, otherwise we return it unchanged. We match a sum type definition, then extract the constructor names (provided that they have no data) into a string list. (Recall that a <code>TySum</code> contains arms separated by <code>TyOr</code>; the call to <code>list_of_ctyp</code> converts that to a list of arms.)</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="ow">and</span> <span class="n">wrap_str_item</span> <span class="n">si</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="o">_</span><span class="n">loc</span> <span class="o">=</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">loc_of_str_item</span> <span class="n">si</span> <span class="k">in</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">si</span><span class="o">$</span> <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>For some reason, <code>&lt;:str_item&lt; $si$ &gt;&gt;</code> wraps an extra <code>StSem</code> / <code>StNil</code> around <code>si</code>, so in order to use the quotation syntax on the left-hand side of a pattern match we need to do the same wrapping.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="ow">and</span> <span class="n">to_of_string</span> <span class="n">si</span> <span class="n">tid</span> <span class="n">cons</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="o">_</span><span class="n">loc</span> <span class="o">=</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">loc_of_str_item</span> <span class="n">si</span> <span class="k">in</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> 
      <span class="o">$</span><span class="n">si</span><span class="o">$;;</span> 
      <span class="o">$</span><span class="n">to_string</span> <span class="o">_</span><span class="n">loc</span> <span class="n">tid</span> <span class="n">cons</span><span class="o">$;;</span> 
      <span class="o">$</span><span class="n">of_string</span> <span class="o">_</span><span class="n">loc</span> <span class="n">tid</span> <span class="n">cons</span><span class="o">$;;</span> 
    <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>This <code>str_item</code> replaces the original one in the output, so we include the original one in additional to new ones containing the <code>t_to_string</code> and <code>t_of_string</code> functions.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="ow">and</span> <span class="n">to_string</span> <span class="o">_</span><span class="n">loc</span> <span class="n">tid</span> <span class="n">cons</span> <span class="o">=</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> 
      <span class="k">let</span> <span class="o">$</span><span class="n">lid</span><span class="o">:</span> <span class="n">tid</span> <span class="o">^</span> <span class="s2">&quot;_to_string&quot;</span><span class="o">$</span> <span class="o">=</span> <span class="k">function</span> 
        <span class="o">$</span><span class="kt">list</span><span class="o">:</span> 
          <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
            <span class="o">(</span><span class="k">fun</span> <span class="n">c</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">&lt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$`</span><span class="n">str</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">&gt;&gt;)</span> 
            <span class="n">cons</span><span class="o">$</span> 
    <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>To convert a variant to a string, we match over its constructors and return the corresponding string.</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="ow">and</span> <span class="n">of_string</span> <span class="o">_</span><span class="n">loc</span> <span class="n">tid</span> <span class="n">cons</span> <span class="o">=</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> 
      <span class="k">let</span> <span class="o">$</span><span class="n">lid</span><span class="o">:</span> <span class="n">tid</span> <span class="o">^</span> <span class="s2">&quot;_of_string&quot;</span><span class="o">$</span> <span class="o">=</span> <span class="k">function</span> 
        <span class="o">$</span><span class="kt">list</span><span class="o">:</span> 
          <span class="nn">List</span><span class="p">.</span><span class="n">map</span> 
            <span class="o">(</span><span class="k">fun</span> <span class="n">c</span> <span class="o">-&gt;</span> <span class="o">&lt;:</span><span class="n">match_case</span><span class="o">&lt;</span> 
       <span class="o">$</span><span class="n">tup</span><span class="o">:</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$`</span><span class="n">str</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">&gt;&gt;$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> 
     <span class="o">&gt;&gt;)</span> 
            <span class="n">cons</span><span class="o">$</span> 
        <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">invalid_arg</span> <span class="s2">&quot;bad string&quot;</span> 
    <span class="o">&gt;&gt;</span> 
</code></pre> 
</div> 
<p>To convert a string to a variant, we match over the corresponding string for each constructor and return the constructor; we also need a catchall for strings that match no constructor. (What is this <code>tup</code> and <code>patt</code> business? A contrived bug which we will fix below.)</p> 
<div class="highlight"><pre><code class="ocaml">  <span class="o">;;</span> 
  <span class="nn">AstFilters</span><span class="p">.</span><span class="n">register_str_item_filter</span> <span class="k">begin</span> <span class="k">fun</span> <span class="n">si</span> <span class="o">-&gt;</span> 
    <span class="k">let</span> <span class="o">_</span><span class="n">loc</span> <span class="o">=</span> <span class="nn">Ast</span><span class="p">.</span><span class="n">loc_of_str_item</span> <span class="n">si</span> <span class="k">in</span> 
    <span class="o">&lt;:</span><span class="n">str_item</span><span class="o">&lt;</span> 
      <span class="o">$</span><span class="kt">list</span><span class="o">:</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="n">filter</span> <span class="o">(</span><span class="nn">Ast</span><span class="p">.</span><span class="n">list_of_str_item</span> <span class="n">si</span> <span class="bp">[]</span><span class="o">)$</span> 
    <span class="o">&gt;&gt;</span> 
  <span class="k">end</span> 
</code></pre> 
</div> 
<p>Now we register our filter function with Camlp4. The input <code>str_item</code> may contain many <code>str_items</code>s separated by <code>StSem</code>, so we call <code>list_of_str_item</code> to get a list of individuals.</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">end</span> 
<span class="k">module</span> <span class="nc">Id</span> <span class="o">=</span> 
<span class="k">struct</span> 
  <span class="k">let</span> <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;to_of_string&quot;</span> 
  <span class="k">let</span> <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.1&quot;</span> 
<span class="k">end</span> 
<span class="o">;;</span> 
<span class="k">let</span> <span class="k">module</span> <span class="nc">M</span> <span class="o">=</span> <span class="nn">Camlp4</span><span class="p">.</span><span class="nn">Register</span><span class="p">.</span><span class="nc">AstFilter</span><span class="o">(</span><span class="nc">Id</span><span class="o">)(</span><span class="nc">Make</span><span class="o">)</span> <span class="k">in</span> <span class="bp">()</span> 
</code></pre> 
</div> 
<p>Finally we register the plugin with Camlp4. The functor application is just for its side effect, so the plugin is registered when its <code>.cmo</code> is loaded. We can compile the plugin with</p> 
<div class="highlight"><pre><code class="bash">ocamlfind ocamlc -package camlp4.quotations.o -syntax camlp4o <span class="se">\</span> 
  -c to_of_string.ml
</code></pre> 
</div> 
<p>and run it on a file (containing <code>type t = Foo | Bar | Baz</code> or something) with</p> 
<div class="highlight"><pre><code class="bash">camlp4o to_of_string.cmo <span class="nb">test</span>.ml
</code></pre> 
</div><b>Ocamlc's AST</b> 
<p>Looks pretty good, right? But something goes wrong when we try to use our plugin as a frontend for <code>ocamlc</code>:</p> 
<div class="highlight"><pre><code class="bash">ocamlc -pp <span class="s1">'camlp4o ./to_of_string.cmo'</span> <span class="nb">test</span>.ml
</code></pre> 
</div> 
<p>We get a preprocessor error, &ldquo;singleton tuple pattern&rdquo;. It turns out that Camlp4 passes the processed AST to <code>ocamlc</code> not by pretty-printing it to text, but by converting it to the AST type that <code>ocamlc</code> uses and marshalling it. This saves the time of reparsing it, and also passes along correct file locations (compare to <code>cpp</code>&rsquo;s <code>#line</code> directives). However, as we have seen, the Camlp4 AST is pretty loose. When converting to an <code>ocamlc</code> AST, Camlp4 does some validity checks on the tree. What can be confusing is that an AST that fails these checks may look fine when pretty-printed.</p> 
<p>Here the culprit is the line</p> 
<div class="highlight"><pre><code class="ocaml">       <span class="o">$</span><span class="n">tup</span><span class="o">:</span> <span class="o">&lt;:</span><span class="n">patt</span><span class="o">&lt;</span> <span class="o">$`</span><span class="n">str</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">&gt;&gt;$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> 
</code></pre> 
</div> 
<p>which produces an invalid pattern consisting of a one-item tuple. When pretty-printed, though, the <code>tup</code> just turns into an extra set of parentheses, which <code>ocamlc</code> doesn&rsquo;t mind. What we wanted was</p> 
<div class="highlight"><pre><code class="ocaml">       <span class="o">$`</span><span class="n">str</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> <span class="o">-&gt;</span> <span class="o">$</span><span class="n">uid</span><span class="o">:</span> <span class="n">c</span><span class="o">$</span> 
</code></pre> 
</div> 
<p>This is a contrived example, but this kind of error is easy to make, and can be hard to debug, because looking at the pretty-printed output doesn&rsquo;t tell you what&rsquo;s wrong. One tactic is to run your code in the toplevel, which will print the constructors of the AST as usual. Another is to use a filter that comes with Camlp4 to &ldquo;lift&rdquo; the AST&mdash;that is, to generate the AST representing the original AST! Maybe it is easier to try it than to explain it:</p> 
<div class="highlight"><pre><code class="bash">camlp4o to_of_string.cmo -filter Camlp4AstLifter <span class="nb">test</span>.ml
</code></pre> 
</div> 
<p>Now compare the result to the tree you get back from Camlp4&rsquo;s parser for the code you <em>meant</em> to write, and you can probably spot your mistake.</p> 
<p>(If you tried to redirect the <code>camlp4o</code> command to a file or pipe it through <code>less</code> you got some line noise&mdash;this is the marshalled <code>ocamlc</code> AST. By default Camlp4 checks whether its output is a TTY; if so it calls the pretty-printer, if not the <code>ocamlc</code> AST marshaller. To override this use the <code>-printer o</code> option, or <code>-printer r</code> for revised syntax.)</p> 
<b>Other builtin filters</b> 
<p>This <code>Camlp4AstLifter</code> is pretty useful. What else comes with Camlp4? There are several other filters in <code>camlp4/Camlp4Filters</code> which you can call with <code>-filter</code>:</p> 
<ul> 
<li> 
<p><code>Camlp4FoldGenerator</code> generates visitor classes from datatypes. Try putting <code>class x = Camlp4MapGenerator.generated</code> after a type definition. The idea is that you can override methods of the visitor so you can do some transformation on a tree without having to write the boilerplate to walk the parts you don&rsquo;t care about. In fact, this filter is used as part of the Camlp4 bootstrap to generate vistors for the AST; you can see the <code>map</code> and <code>fold</code> classes in <code>camlp4/Camlp4/Sig.ml</code>.</p> 
</li> 
<li> 
<p><code>Camlp4MetaGenerator</code> generates lifting functions from a type definition&mdash;these functions are what <code>Camlp4AstLifter</code> uses to lift the AST, and it&rsquo;s also how quotations are implemented. I&rsquo;m planning to cover how to implement quotations / antiquotations (for a different language) in a future post, and <code>Camlp4MetaGenerator</code> will be crucial.</p> 
</li> 
<li> 
<p><code>Camlp4LocationStripper</code> replaces all the locations in an AST with <code>Loc.ghost</code>. I don&rsquo;t know what this is for, but it might be useful if you wanted to compare two ASTs and be insensitive to their locations.</p> 
</li> 
<li> 
<p><code>Camlp4Profiler</code> inserts profiling code, in the form of function call counts. I haven&rsquo;t tried it, and I&rsquo;m not sure when you would want it in preference to gprof.</p> 
</li> 
<li> 
<p><code>Camlp4TrashRemover</code> just filters out a module called <code>Camlp4Trash</code>. Such a module may be found in <code>camlp4/Camlp4/Struct/Camlp4Ast.mlast</code>; I think the idea is that the module is there in order to generate some stuff, but the module itself is not needed.</p> 
</li> 
<li> 
<p><code>Camlp4MapGenerator</code> has been subsumed by <code>Camlp4FoldGenerator</code>.</p> 
</li> 
<li> 
<p><code>Camlp4ExceptionTracer</code> seems to be a special-purpose tool to help debug Camlp4.</p> 
</li> 
</ul> 
<p>OK, maybe not too much useful stuff here, but it is interesting to work out how Camlp4 is bootstrapped.</p> 
<p>I think next time I will get into Camlp4&rsquo;s extensible parsers, on the way toward syntax extensions.</p> 
<b>Colophon</b> 
<p>I wrote my previous posts in raw HTML, with highlighted code generated from a hightlighted Emacs buffer by <a href="http://fly.cc.fer.hr/~hniksic/emacs/htmlize.el">htmlize.el</a>. Iterating on this setup was unutterably painful. This post was written using <a href="http://github.com/mojombo/jekyll">jekyll</a> with a simple template to approximate the Blogspot formatting, mostly so I can check that lines of code aren&rsquo;t too long. Jekyll is very nice: you can write text with <a href="http://maruku.rubyforge.org/">Markdown</a>, and highlight code with <a href="http://pygments.org/">Pygments</a>.</p>
