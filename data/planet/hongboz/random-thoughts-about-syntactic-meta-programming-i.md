---
title: Random thoughts about Syntactic Meta Programming (I)
description: "I should write this blog long time ago, but I am so adddicted to Fan
  that I don\u2019t have time to write it, programming is much more fun than blogging.
  Anyway, better late than never, XD. What&#\u2026"
url: https://hongboz.wordpress.com/2013/01/28/random-thoughts-about-syntactic-meta-programming-i/
date: 2013-01-28T05:00:00-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- hongboz
---


<p>I should write this blog long time ago, but I am so adddicted to <a href="https://github.com/bobzhang/Fan">Fan</a>  that I don&rsquo;t have time to write it, programming is much more fun than blogging. </p>
<p> Anyway, better late than never, XD. </p>
<div class="outline-2">
<h2>What&rsquo;s syntactic meta programming?</h2>
<div class="outline-text-2">     </div>
<div class="outline-3">
<h3>What&rsquo;s meta programming?</h3>
<div class="outline-text-3">
<p>    Meta programming is an interesting but also challenging domain, the    essential idea is that &ldquo;program as data&rdquo;. Wait, you may wonder that    in <a href="http://en.wikipedia.org/wiki/Von_Neumann_architecture">Von Neumann architecture</a>, program is <b>always</b> data, so to be more    precise, meta programming is kinda &ldquo;program as structured data&rdquo;, the    structured data should be easy to manipulate and generate. Think    about Lisp, since it does not have any concrete syntax, its program    is always <a href="http://en.wikipedia.org/wiki/S-expression">S-expression</a>, a hierachical data structure which is easy    to manipulate and process. </p>
</div>
</div>
<div class="outline-3">
<h3>Meta-program at different layers</h3>
<div class="outline-text-3">
<p>    When you write a compiler, the program should have different    representations in different stages, think about the ocaml compiler    workflow </p>
<pre class="example">Raw String --&gt;  Token Stream --&gt;
Parsetree --&gt; Typedtree --&gt; Lambda --&gt;
ULambda --&gt; C-- --&gt; Mach --&gt; Linear --&gt;
Assembly
</pre>
<p>    So, at different stages, the program as a structured data can be    processed in different ways. </p>
<p>    You can insert plugins per level, for example, the c macros mainly    does the token stream transformation, but there is a problem with    the token stream that it is not a structured data. </p>
<p>    Ther earlier stage you do the transformation, the easier it is to    be mapped to you original source program, the later stage you do    the transformation, the compiler do more program analysis, but it&rsquo;s    harder to map to the original program. So each stage has its use    case. </p>
<p>    Here we only talk about syntactic meta programming(SMP), where the    layer is in the parsetree or called Abstract Syntax and we only    talk about the host language <a href="http://caml.inria.fr/">OCaml</a> (OCaml is really a great    language, you should have a try!), but some high level design    choices should be applied to other host languages as well. </p>
</div>
</div>
</div>
<div class="outline-2">
<h2>The essential part of SMP</h2>
<div class="outline-text-2">
<p>   I suggest anyone who are interested in SMP should learn <a href="http://en.wikipedia.org/wiki/Common_Lisp">Common Lisp</a>,   there are so many brilliant ideas there and forgotten by people   outside the community. And two books are really fun, one is <a href="http://www.paulgraham.com/onlisp.html">On Lisp</a>,   the other is <a href="http://letoverlambda.com/">Let Over Lambda</a> . </p>
<p>   The essential part of SMP is Quasi-Quotation. There is a nice paper   introduces the benefits of Quasi-Quotation: <a href="https://hongboz.wordpress.com/feed/#people.csail.mit.edu-alan-ftp-quasiquote-v59.ps.gz">Quasiquotation in Lisp</a>. </p>
<p>   Here we only scratch its surface a tiny bit: &ldquo;Quasiquotation is a   <b>parameterized version</b> of ordinary quotation, where instead of   specifying a value exactly, some <b>holes</b> are left to be filled in   later. A quasiquotation is a template.&rdquo;, breifly, quasi-quotation   entitiles you the ability to <b>abstraction over code</b>. </p>
<p>   As the paper said, a typical use of quasiquotation in a macro   definition looks like </p>
<pre class="src src-lisp">(<span style="color:#af00ff;">defmacro</span> (<span style="color:#0000ff;">push</span> expr var)
 `(set! ,var (cons ,expr ,var)))
</pre>
<p>   Here the &ldquo;`&rdquo; introduces a quasi-quotaion, and &ldquo;,&rdquo; introduces a   parameter(we also call it anti-quote), there are a number of   languages which supports quasiquotation except the lisp family, but   <b>none</b> of them are even close to Lisp. </p>
<p>   One challenging part lies not in quote part, it lies in <b>anti-quote</b>   part, however. In lisp, you can antiquote <b>everywhere</b>, suppose you   are writing <code>Template Haskell</code>, you can write some thing like this </p>
<pre class="example">[| import $module |]
</pre>
<p>   In lisp, it allows very <b>fine-grained</b> quasi-quote. </p>
<p>   The other challegning part is <b>nested quosi-quotation</b>. Since   meta-program itself  is a normal program, when you do meta   programming a lot in Common Lisp, you will find you wrote a lot of   duplicated meta-programs, here nested quasi-quotation came to   rescue. </p>
<p>   Discussing nested quasi-quotation may goes beyond the scope of the   first blog, but you can have a taste here </p>
<pre class="src src-lisp">(<span style="color:#af00ff;">defmacro</span> (<span style="color:#0000ff;">def-caller</span> abbrev proc)
 `(<span style="color:#af00ff;">defmacro</span> (,abbrev var expr)
    `(,`,proc (<span style="color:#af00ff;">lambda</span> (,var) ,expr))))
</pre>
</div>
<div class="outline-3">
<h3>Some defects in Lisp Style Macors</h3>
<div class="outline-text-3">
<p>    Though I really enjoyed Lisp Macros, to be honest, the S-expression    as concrete syntax to represent a program is not the optimal way to    express ideas. </p>
<p>    For the extreme flexibility, you have to pay that for each program    you use a sub-optimal concrete syntax. </p>
<p>    The second problem is that Lisp is a dynamically typed language,    though currently practical type system can help catch only some    trivial errors, but they <b>do help a lot</b>. </p>
<p>    For a sufficient smart compiler, like <a href="http://www.sbcl.org/">SBCL</a>, they did type inference    or constraint propgation, and that <b>emits really helpful warnings</b>,    the type checking may not be that important there, but that depends    on the compiler implementation, some young implementations, like    <a href="http://clojure.org/">clojure</a>, the compiler is not smart enough to help diagnose, yet. </p>
<p>    The third problem is that Lisp macros ignore <b>locations</b> totally,    when you process the raw S-expression, no location is kept, in some    domains, code generation, for example, location is not that    important since you only emit a large trunk of code, in other    domains, Ast transformation, location is important to help emit    helpful error messages. Keeping location correct is very tedious    but necessary, IMHO. Some meta programming system, Template    Haskell, ignores locations as well. </p>
</div>
</div>
</div>
<div class="outline-2">
<h2>How to do SMP in rich syntax language</h2>
<div class="outline-text-2">
<p>   Now let&rsquo;s go back to OCaml, the great language XD. </p>
<p>   It is the same as Lisp, you have to encode the Ast in the host   language, you can encode the ocaml&rsquo;s Ast using S-expression as well. </p>
<p>   S-expression is a viable option, <a href="http://felix-lang.org/">Felix</a> adopts this mechanism. The   advantage of using S-exprssion to encode the S-expression is that   you can reach <b>the maximum code reuse</b> and <b>don&rsquo;t need to fight   against the type system</b> from time to time. </p>
<p>   For example, in <a href="http://brion.inria.fr/gallium/index.php/Camlp4">Camlp4</a>, once you want to get the location of an Ast   node, you have to fix its type, so if have to write a lot of   bolierpolate code like this </p>
<pre class="src src-ocaml"><span style="color:#0000ee;font-weight:bold;">val</span> <span style="color:#af5f00;">loc_of_expr</span><span style="color:#af0000;">:</span> <span style="color:#008700;">expr </span><span style="color:#af0000;">-&gt;</span><span style="color:#008700;"> loc</span>
<span style="color:#0000ee;font-weight:bold;">val</span> <span style="color:#af5f00;">loc_of_ctyp</span><span style="color:#af0000;">:</span> <span style="color:#008700;">ctyp </span><span style="color:#af0000;">-&gt;</span><span style="color:#008700;"> loc</span>
<span style="color:#0000ee;font-weight:bold;">val</span> <span style="color:#af5f00;">loc_of_patt</span><span style="color:#af0000;">:</span> <span style="color:#008700;">patt </span><span style="color:#af0000;">-&gt;</span><span style="color:#008700;"> loc</span>
<span style="color:#af0000;">....</span>
</pre>
<p>   Things turn out to be better with <a href="http://en.wikipedia.org/wiki/Type_class">type class</a> support in Haskell, but   that&rsquo;s another story.  </p>
<p>   Think about the case you want to use a <b>semi</b> <code>;</code> to connect two Ast   node, you have to write things like </p>
<pre class="src src-ocaml"><span style="color:#0000ee;font-weight:bold;">let</span> <span style="color:#0000ff;">sem</span><span style="color:#af5f00;"> e1 e2 </span><span style="color:#af0000;">=</span>
   <span style="color:#0000ee;font-weight:bold;">let</span> <span style="color:#af5f00;">_loc </span><span style="color:#af0000;">=</span> <span style="color:#008700;">Loc</span>.merge <span style="color:#af0000;">(</span>loc_of_expr e1 <span style="color:#af0000;">)</span> <span style="color:#af0000;">(</span>loc_of_expr e2<span style="color:#af0000;">)</span> <span style="color:#0000ee;font-weight:bold;">in</span>
   Sem<span style="color:#af0000;">(</span>_loc<span style="color:#af0000;">,</span> e1<span style="color:#af0000;">,</span>e2<span style="color:#af0000;">)</span>
</pre>
<p>   Everytime you want to fetch the location, you have to <b>fix its   type</b>,  that&rsquo;s too bad, the API to process the Syntax is <b>too verbose</b> </p>
<p>   But using Algebraic Data Type <b>does have some advantages</b>, the first   is <b>pattern match</b> (with exhuastive check), the second is type   checking, we do tell some difference between <code>Ast.expr</code> and   <code>Ast.patt</code>, and that helps, but you can not tell whether it&rsquo;s an   expresson of type int or type boolean, for example  </p>
<pre class="src src-ocaml"><span style="color:#af0000;">(</span>Int <span style="color:#87005f;">&quot;3&quot;</span> <span style="color:#af0000;">:</span> <span style="color:#008700;">expr</span><span style="color:#af0000;">)</span>
<span style="color:#af0000;">(</span>String <span style="color:#87005f;">&quot;3&quot;</span> <span style="color:#af0000;">:</span><span style="color:#008700;">expr</span><span style="color:#af0000;">)</span>
</pre>
<p>   <a href="https://hongboz.wordpress.com/feed/#http-www.metaocaml.org">MetaOCaml</a> can guarantees the type correctness, but there is always a   trade off between expressivity and type safety. Anyway, in a   staticly typed language, i.e, OCaml, the generated program is always   type checked.  </p>
<p>   So, in OCaml or other ML dialects , you can encode the Abstract   Syntax using one of those: untyped s-expression, partial typed sum   types, records, GADT, or mixins of records and sum types.   there is another unique solution which exists in OCaml, <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual006.html">variants</a>. </p>
<p>   We will discuss it further in the next post. </p>
</div>
<div class="outline-3">
<h3>Quasi-quotation in OCaml</h3>
<div class="outline-text-3">
<p>       Quasi-quotation in lisp is free, since the concrete syntax is    exactly the same as abstract syntax. </p>
<pre class="src src-lisp">(+ a 3 4) <span style="color:#af0000;">;; </span><span style="color:#af0000;">program</span>

`(+ a 3 4) <span style="color:#af0000;">;; </span><span style="color:#af0000;">data </span>
</pre>
<p>    There is a paper which summarizes how to do quasi-quotation in rich    syntax language: <a href="http://ipaper.googlecode.com/git-history/969fbd798753dc0b10ea9efe5af7773ff10f728a/Miscs/why-its-nice-to-be-quoted.pdf">Why it&rsquo;s nice to be quoted.</a>  </p>
<p>    Unlike Lisp, the different between program and data is obvious </p>
<pre class="src src-ocaml">3 <span style="color:#af0000;">(* </span><span style="color:#af0000;">program </span><span style="color:#af0000;">*)</span>
`Int <span style="color:#af0000;">(</span>_loc<span style="color:#af0000;">,</span> <span style="color:#87005f;">&quot;3&quot;</span><span style="color:#af0000;">)</span> <span style="color:#af0000;">(* </span><span style="color:#af0000;">data </span><span style="color:#af0000;">*)</span>

<span style="color:#87005f;">&quot;3&quot;</span> <span style="color:#af0000;">(* </span><span style="color:#af0000;">program </span><span style="color:#af0000;">*)</span>
`String <span style="color:#af0000;">(</span>_loc<span style="color:#af0000;">,</span> <span style="color:#87005f;">&quot;3&quot;</span><span style="color:#af0000;">)</span> <span style="color:#af0000;">(* </span><span style="color:#af0000;">data </span><span style="color:#af0000;">*)</span>
</pre>
<p>    (Here we use a qutoe &ldquo;`&rdquo; to denote that it&rsquo;s an Ast ) </p>
<p>    Let&rsquo;s take a look at the parsing phase (for simplicity, we ignore    the locations). </p>
<p>    When you do the parsing, the normal behavior  is as follows: </p>
<pre class="src src-ocaml"> <span style="color:#87005f;">&quot;3 + 4&quot;</span>
 <span style="color:#af0000;">==&gt;</span> <span style="color:#af00ff;">to</span> the Ast 
`App <span style="color:#af0000;">((</span>`App <span style="color:#af0000;">((</span>`Id <span style="color:#af0000;">(</span>`Lid <span style="color:#87005f;">&quot;+&quot;</span><span style="color:#af0000;">)),</span> <span style="color:#af0000;">(</span>`Int <span style="color:#87005f;">&quot;3&quot;</span><span style="color:#af0000;">))),</span> <span style="color:#af0000;">(</span>`Int <span style="color:#87005f;">&quot;4&quot;</span><span style="color:#af0000;">))</span>
</pre>
<p>    But to do the quasi-quotation, you need to turn the Ast itself into    data, so you need to encode the Ast using the Ast itself </p>
<pre class="src src-ocaml"><span style="color:#87005f;">&quot;3+4&quot;</span>
<span style="color:#af0000;">==&gt;</span> <span style="color:#af00ff;">to</span> the Ast
`App <span style="color:#af0000;">((</span>`App <span style="color:#af0000;">((</span>`Id <span style="color:#af0000;">(</span>`Lid <span style="color:#87005f;">&quot;+&quot;</span><span style="color:#af0000;">)),</span> <span style="color:#af0000;">(</span>`Int <span style="color:#87005f;">&quot;3&quot;</span><span style="color:#af0000;">))),</span> <span style="color:#af0000;">(</span>`Int <span style="color:#87005f;">&quot;4&quot;</span><span style="color:#af0000;">))</span>

<span style="color:#af0000;">==&gt;</span> <span style="color:#af00ff;">to</span> the Data
`App
 <span style="color:#af0000;">((</span>`App
     <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;App&quot;</span><span style="color:#af0000;">),</span>
       <span style="color:#af0000;">(</span>`App
          <span style="color:#af0000;">((</span>`App
              <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;App&quot;</span><span style="color:#af0000;">),</span>
                <span style="color:#af0000;">(</span>`App <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;Id&quot;</span><span style="color:#af0000;">),</span> <span style="color:#af0000;">(</span>`App <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;Lid&quot;</span><span style="color:#af0000;">),</span> <span style="color:#af0000;">(</span>`Str <span style="color:#87005f;">&quot;+&quot;</span><span style="color:#af0000;">))))))),</span>
            <span style="color:#af0000;">(</span>`App <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;Int&quot;</span><span style="color:#af0000;">),</span> <span style="color:#af0000;">(</span>`Str <span style="color:#87005f;">&quot;3&quot;</span><span style="color:#af0000;">))))))),</span>
   <span style="color:#af0000;">(</span>`App <span style="color:#af0000;">((</span>`Vrn <span style="color:#87005f;">&quot;Int&quot;</span><span style="color:#af0000;">),</span> <span style="color:#af0000;">(</span>`Str <span style="color:#87005f;">&quot;4&quot;</span><span style="color:#af0000;">))))</span>
</pre>
<p>    So, to do it once for all, we needs      a function (for simplicty) </p>
<pre class="src src-ocaml"><span style="color:#0000ee;font-weight:bold;">val</span> <span style="color:#af5f00;">meta_expr</span><span style="color:#af0000;">:</span> <span style="color:#008700;">expr</span><span style="color:#af0000;">^</span>0 <span style="color:#af0000;">-&gt;</span> expr<span style="color:#af0000;">^</span>1 
</pre>
<p>    Luckily since <code>expr^1</code> is a subset of <code>expr^0</code>, so you get the    belowing function for free </p>
<pre class="src src-ocaml"><span style="color:#0000ee;font-weight:bold;">val</span> <span style="color:#af5f00;">meta_expr</span><span style="color:#af0000;">:</span> <span style="color:#008700;">expr</span><span style="color:#af0000;">^</span>1 <span style="color:#af0000;">-&gt;</span> expr<span style="color:#af0000;">^</span>2 
</pre>
<p>    Actually you may find that the category <code>expr^2</code> is exactly the    same as <code>expr^1</code>, so once you have <code>expr^0 -&gt; expr^1</code>, you have    <code>expr^0 -&gt; expr^n</code>. (antiquotation will be discussed later). </p>
<p>    So the problem only lies into how to write the function    <code>expr^0-&gt;expr^1</code>,  you need to encode the Ast using the Ast itself,    this requires that the Ast should be expressive enough to express    itself. This is alwasy not true, suppose you use the <a href="http://en.wikipedia.org/wiki/Higher-order_abstract_syntax">HOAS</a>, HOAS is    not expressive enough to express itself. </p>
<p>    If you mixin the records with sum types, you have to express both    records and sum types, the Ast lifting is <b>neither easy to write</b>,    <b>nor easy to read</b>, with locations, it becomes even more cmoplex,    the best case is to <b>do it automatically and once for all</b>. </p>
<p>    Suppose you only use sum types, luckily we might find that only    <b>five tags</b> are expressive enough to express this function <code>expr^0    -&gt; expr^1</code>, here are <b>five tags</b> </p>
<pre class="src src-ocaml">App Vrn Str Tup Com
</pre>
<p>    Here <code>Tup</code> means &ldquo;tuple&rdquo;, and <code>Com</code> means &ldquo;Comma&rdquo;. </p>
<p>       The minimal, the better, this means as long as the changes to the    Abstract Syntax Tree does not involves the <b>five tags</b>, it will    always work out of the box. </p>
<p>    So, to design the right Ast for meta programming, the first thing    is to <b>keep it simple</b>, don&rsquo;t use <b>Records</b> or other complex data    types , Sum types or polymorphic variants are rich enough to    express the who syntax of ocaml but itself is very simple to do the    Ast Lifting. </p>
<p>    In the next blog, we may discuss tThe right way to design an    Abstract Syntax Tree for SMP. </p>
</div>
</div>
</div>

