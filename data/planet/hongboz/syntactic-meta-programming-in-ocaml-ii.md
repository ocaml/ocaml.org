---
title: Syntactic Meta-Programming in OCaml (II)
description: "In this post, we continue discussing syntactic meta-programming following
  last post. My years of experience in different meta-program system(Common Lisp,
  Template Haskell, Camlp4) tell me that quos\u2026"
url: https://hongboz.wordpress.com/2013/02/05/syntactic-meta-programming-in-ocaml-ii-5/
date: 2013-02-05T19:57:31-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- hongboz
---

<p>In this post, we continue discussing syntactic meta-programming<br/>
following <a href="https://hongboz.wordpress.com/2013/01/28/random-thoughts-about-syntactic-meta-programming-i/">last post</a>.
</p>
<p>
My years of experience in different meta-program system(Common Lisp,<br/>
Template Haskell, Camlp4) tell me that quosi-quotation is the most<br/>
essential part in syntactic meta programming. Though all three claims<br/>
they have quosi-quotation support. But Template Haskell&rsquo;s<br/>
quosi-quotation falls far behind either Camlp4 or Common Lisp. For a<br/>
decent quosi-quotation system, first, nested quotation and<br/>
anti-quotation is necessary, second, like Lisp, every part should be<br/>
able to be quoted and antiquoted except keywords position, that&rsquo;s to<br/>
say, each part of the code fragment can be parametrized.
</p>
<p>
For the notation, we denote <code>Ast^0</code> as the normal Ast, <code>Ast^1</code> as Ast<br/>
encoding <code>Ast^0</code>, the same as <code>Ast^n</code>.
</p>
<p>
So in this post, we discuss the quosi-quotation first.
</p>
<p>
The implementation of quosi-quotation heavily relies on the<br/>
implementation of the compiler, so let&rsquo;s limit the scope of how to get<br/>
quosi-quotation done to OCaml.
</p>
<p>
Let&rsquo;s ignore the antiquote part, and focus the quote part first, the<br/>
essential of quosi-quotation is to encode the Ast using Ast itself in<br/>
the meta level: there are different technologies to implement<br/>
quosi-quotations, to my knowledge, I summarized three here:
</p>
<div class="outline-3">
<h3>Raw String manipulation</h3>
<div class="outline-text-3">
<p>   This is the most intuitive way, given a string input, the normal<br/>
   way of parsing is transform it into a parsetree,
</p>
<pre class="src src-ocaml"><span style="color:#ffa500;font-weight:bold;">val</span> <span style="color:#dfaf8f;">parse</span><span style="color:#f0e68c;">:</span> <span style="color:#8cd0d3;">string </span><span style="color:#f0e68c;">-&gt;</span><span style="color:#8cd0d3;"> ast</span>
</pre>
<p>
   To encode the meta-level ast, we can do the unparsing again,<br/>
   assume we have an unparsing function which unparse the ast
</p>
<pre class="src src-ocaml"><span style="color:#ffa500;font-weight:bold;">val</span> <span style="color:#dfaf8f;">unparse</span><span style="color:#f0e68c;">:</span> <span style="color:#8cd0d3;">ast </span><span style="color:#f0e68c;">-&gt;</span><span style="color:#8cd0d3;"> string</span>
</pre>
<p>
   so after the composition of parse and unparse, you transformed a<br/>
   string into the meta-level
</p>
<pre class="src src-ocaml"><span style="color:#f0e68c;">(</span>parse <span style="color:#cc9393;">&quot;3&quot;</span><span style="color:#f0e68c;">)</span>
<span style="color:#f0e68c;">-</span> `Int <span style="color:#cc9393;">&quot;3&quot;</span>
unparse<span style="color:#f0e68c;">(</span>parse <span style="color:#cc9393;">&quot;3&quot;</span><span style="color:#f0e68c;">)</span>
<span style="color:#f0e68c;">-</span> <span style="color:#cc9393;">&quot;`Int \&quot;3\&quot;&quot;</span>

</pre>
<p>
   Then you can do <code>parse</code> again, after <code>parse(unparse (parse &quot;3&quot;))</code>,<br/>
   we managed to lift the Ast in the meta level. There are serious<br/>
   defects with this way, First, it&rsquo;s very brittle, since we are doing<br/>
   string manipulation in different levels, second, after <b>unparsing</b>,<br/>
   the location is totally lost, location is one of the most tedious<br/>
   but necessary part for a practical meta programming system, third,<br/>
   there is no easy way to integrate with antiquot. This technique is<br/>
   quite intuitive and easy to understand, but I don&rsquo;t know any<br/>
   meta-system do it this way, so feel free to tell me if you know<br/>
   anyone does similar work <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/1f609.png" alt="&#128521;" class="wp-smiley" style="height: 1em; max-height: 1em;"/>
</p>
</div>
</div>
<div class="outline-3">
<h3>Maintaining different parsers</h3>
<div class="outline-text-3">
<p>
   Unlike the string manipulation, it write different parsers for<br/>
   different actions. Suppose we are in OCaml, if we want to support<br/>
   quosi-quotations in such syntax categories
</p>
<pre class="example">sig_item, str_item, patt, expr, module_type, module_expr, class_type
class_expr, class_sig_item, class_str_item, with_constr, binding, rec_binding,
match_case,
</pre>
<p>
   And you want the quosi-quotaion appears in both <code>expr</code> and <code>patt</code><br/>
   positions, then you have to write <code>14 x (2+1)</code> parsers, the parser can<br/>
   not be re-usable, if you want to support <code>overloaded quotations</code> (I<br/>
   will talk about it later), then you have to roll your own parser<br/>
   again. Writing parser is not hard, but it&rsquo;s not fun either, and<br/>
   keeping sync up different parsers is a nightmare.
</p>
<p>
   To make things worse, once anti-quotation is considered, for each<br/>
   category, there are three parsers to write, but anti-quot makes<br/>
   them slightly different. To be honest, this way is impractical.
</p>
</div>
</div>
<div class="outline-3">
<h3>Ast Lifting</h3>
<div class="outline-text-3">
<p>   Another mechanism to do quosi-quotation is that imaging we have a<br/>
   powerful function:
</p>
<pre class="src src-ocaml"><span style="color:#ffa500;font-weight:bold;">val</span> <span style="color:#dfaf8f;">meta</span><span style="color:#f0e68c;">:</span> <span style="color:#8cd0d3;">ast</span><span style="color:#f0e68c;">^</span>0 <span style="color:#f0e68c;">-&gt;</span> ast<span style="color:#f0e68c;">^</span>1
</pre>
<p>
   This seems magic, but it&rsquo;s possible even though in OCaml we don&rsquo;t<br/>
   have generic programming support, since we have the definition<br/>
   of ast.
</p>
<p>
   The problem with this technique is that it requires an explicit<br/>
   <code>Ant</code> tag in the ast representation, since at <code>ast^0</code> level, you<br/>
   have to store <code>Ant</code> as intermediate node which will be removed when<br/>
   applied <code>meta</code> function.
</p>
<p>
   Let&rsquo;s walk through each phase in Fan
</p>
<p>
   Think about how such piece of code would be parsed in Fan:
</p>
<pre class="src src-ocaml"><span style="color:#f0e68c;">{:</span><span style="color:#8cd0d3;">expr</span><span style="color:#f0e68c;">|</span> <span style="color:#f0e68c;">$</span>x <span style="color:#f0e68c;">+</span> y<span style="color:#f0e68c;">|}</span>
</pre>
<p>
   For the first phase (I removed the location for simplicity)
</p>
<pre class="src src-ocaml">`App<span style="color:#f0e68c;">(</span>`App
      <span style="color:#f0e68c;">(</span> `Id <span style="color:#f0e68c;">(</span> `Lid <span style="color:#f0e68c;">(</span> <span style="color:#cc9393;">&quot;+&quot;</span><span style="color:#f0e68c;">)),</span>
        `Ant <span style="color:#f0e68c;">(</span> <span style="color:#f0e68c;">{</span>cxt <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;expr&quot;</span><span style="color:#f0e68c;">;</span> sep <span style="color:#f0e68c;">=</span> None<span style="color:#f0e68c;">;</span> decorations <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;&quot;</span><span style="color:#f0e68c;">;</span> content <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;x&quot;</span><span style="color:#f0e68c;">})),</span>
     `Id <span style="color:#f0e68c;">(</span> `Lid <span style="color:#f0e68c;">(</span> <span style="color:#cc9393;">&quot;y&quot;</span><span style="color:#f0e68c;">)))</span>
</pre>
<p>
   Here <code>Ant</code> exists only as intermediate node, it will be eliminated<br/>
   in the meta-step
</p>
<p>
   after applied with <code>meta</code> function
</p>
<pre class="src src-ocaml"><span style="color:#f0e68c;">(</span><span style="color:#8cd0d3;">Filters</span>.<span style="color:#8cd0d3;">ME</span>.meta_expr _loc <span style="color:#f0e68c;">(</span>t expr <span style="color:#cc9393;">&quot;$x + y&quot;</span><span style="color:#f0e68c;">));</span>
<span style="color:#f0e68c;">-</span> <span style="color:#f0e68c;">:</span> <span style="color:#8cd0d3;">FanAst.expr </span><span style="color:#f0e68c;">=</span>
`App
  <span style="color:#f0e68c;">(,</span>
   `App
     <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;App&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
      `App
        <span style="color:#f0e68c;">(,</span>
         `App
           <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;App&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
            `App
              <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Id&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
               `App
                 <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Lid&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
                  `Str <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;+&quot;</span><span style="color:#f0e68c;">)))),</span>
         `Ant <span style="color:#f0e68c;">(,</span> <span style="color:#f0e68c;">{</span>cxt <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;expr&quot;</span><span style="color:#f0e68c;">;</span> sep <span style="color:#f0e68c;">=</span> None<span style="color:#f0e68c;">;</span> decorations <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;&quot;</span><span style="color:#f0e68c;">;</span> content <span style="color:#f0e68c;">=</span> <span style="color:#cc9393;">&quot;x&quot;</span><span style="color:#f0e68c;">}))),</span>
   `App
     <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Id&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
      `App <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Lid&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span> `Str <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;y&quot;</span><span style="color:#f0e68c;">))))</span>   
</pre>
<p>
   (t is a parsing function)<br/>
   Here we see that <code>Ant</code> node is still kept and it will be<br/>
   filtering, now we can filter the <code>Ant</code> node into a normal Ast,
</p>
<pre class="src src-ocaml"><span style="color:#f0e68c;">(</span><span style="color:#8cd0d3;">Ant</span>.antiquot_expander <span style="color:#f0e68c;">~</span>parse_patt <span style="color:#f0e68c;">~</span>parse_expr<span style="color:#f0e68c;">)#</span>expr <span style="color:#f0e68c;">(</span><span style="color:#8cd0d3;">Filters</span>.<span style="color:#8cd0d3;">ME</span>.meta_expr _loc <span style="color:#f0e68c;">(</span>t expr <span style="color:#cc9393;">&quot; $x + y&quot;</span><span style="color:#f0e68c;">));</span>
<span style="color:#f0e68c;">-</span> <span style="color:#f0e68c;">:</span> <span style="color:#8cd0d3;">FanAst.expr </span><span style="color:#f0e68c;">=</span>
`App
  <span style="color:#f0e68c;">(,</span>
   `App
     <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;App&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
      `App
        <span style="color:#f0e68c;">(,</span>
         `App
           <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;App&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
            `App
              <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Id&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
               `App
                 <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Lid&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
                  `Str <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;+&quot;</span><span style="color:#f0e68c;">)))),</span>
         `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;x&quot;</span><span style="color:#f0e68c;">)))),</span>
   `App
     <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Id&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span>
      `App <span style="color:#f0e68c;">(,</span> `App <span style="color:#f0e68c;">(,</span> `Vrn <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;Lid&quot;</span><span style="color:#f0e68c;">),</span> `Id <span style="color:#f0e68c;">(,</span> `Lid <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;_loc&quot;</span><span style="color:#f0e68c;">))),</span> `Str <span style="color:#f0e68c;">(,</span> <span style="color:#cc9393;">&quot;y&quot;</span><span style="color:#f0e68c;">))))</span>   
</pre>
<p>
   (location in the meta-level is ignored)<br/>
   If we want to share the same grammar between the <code>Ast^n(n=0,1,2,...)</code>,<br/>
   Ast lifting (a function of type <code>Ast^0 -&gt; Ast^1</code>) is necessary.
</p>
</div>
</div>
<div class="outline-2">
<h2>Summary</h2>
<div class="outline-text-2">
<p>
  We see the three techniques introduced here to do the<br/>
  quosi-quotation, Fan adopts the third one, suppose we pick the<br/>
  third one, let&rsquo;s discuss what kind of Ast representation we need to<br/>
  make life easier.
</p>
<p>
  As we discussed previously, introducing records in the Abstract Syntax<br/>
  brings in un-necessary complexity when you want to encode the Ast<br/>
  using the Ast itself since you have to express the record in the<br/>
  meta-level as well.
</p>
<p>
  Another defect with current Parsetree is that it was designed without<br/>
  meta-programming in mind, so it does not provide an <code>Ant</code> tag in all<br/>
  syntax categories, so in the zero stage <code>Ast^0</code>, you can not have an<br/>
  Ast node <code>$x</code> in the outermost, since it&rsquo;s semantically incorrect in<br/>
  <code>Ast^0</code>, but syntactically correct in <code>Ast^n(n=0,1,2,...)</code>
</p>
<p>
  The third defect with the <code>Parsetree</code> is that it&rsquo;s quite irregular,<br/>
  so you can not do any meta-programming with the parsetree itself, for<br/>
  example, stripping all the location from the Ast node to derive a new<br/>
  type without locations, deriving a new type without anti-quot tags (we<br/>
  will see that such ability is quite important in <a href="https://github.com/bobzhang/Fan">Fan</a>)
</p>
<p>
  The fourth defect is more serious from the point of view of<br/>
  semantics, since in OCaml, there is no way to express absolute path,<br/>
  when you do the Ast lifting, the time you define Ast lifting is<br/>
  different from the time you use the quotations
</p>
<p>
  Camlp4&rsquo;s Ast is slightly better than Parsetree, since it does not<br/>
  introduce records to increase the complexity.
</p>
<p>
  However, Camlp4&rsquo;s Ast can not express the absolute path which<br/>
  results in a semantics imprecise, another serious implementation<br/>
  defect is that it tries to encode the anti-quote using both two<br/>
  techniques: either explicit <code>Ant</code> tag or via string mangling, prefix<br/>
  the string with <code>\\$:</code>, and Camlp4&rsquo;s tag name is totally not<br/>
  meaningful.
</p>
<p>
  Think a bit further , about syntactic meta-programming, what we<br/>
  really care about is purely syntax, <code>Int &quot;3&quot;= should not be   different whether it is of type =expr</code> or <code>patt</code>, if we take a<br/>
  location of ast node, we should not care about whether its type is<br/>
  <code>expr</code> or <code>patt</code> or <code>str_item</code>, right?
</p>
<p>
  If we compose two ast node using semi syntax <code>;</code>, we really don&rsquo;t<br/>
  care about whether it&rsquo;s expr node or patt node
</p>
<pre class="src src-ocaml"><span style="color:#ffa500;font-weight:bold;">let</span> <span style="color:#8cd0d3;">sem</span><span style="color:#dfaf8f;"> a b </span><span style="color:#f0e68c;">=</span> <span style="color:#f0e68c;">{|</span> <span style="color:#f0e68c;">$</span>a<span style="color:#f0e68c;">;</span> <span style="color:#f0e68c;">$</span>b <span style="color:#f0e68c;">|}</span>
</pre>
<p>
  The code above should work well under already syntax categories as<br/>
  long as it support <code>`Sem</code> tag.
</p>
<p>
  Changing the underlying representation of Ast means all existing<br/>
  code in Camlp4 engine can not be reused, since the quotation-kit no<br/>
  longer apply in Fan, but the tough old days are already gone, Fan<br/>
  already managed to provide the whole quotation kit from scratch.  In<br/>
  the next post we will talk about the underly Ast using polymorphic<br/>
  variants in Fan, and argue why it&rsquo;s the right direction.
</p>
<p>
  Thanks for your reading!(btw, there&rsquo;s a bug in Emacs org/blog, sorry for posting several times)
</p>
</div>
</div>


