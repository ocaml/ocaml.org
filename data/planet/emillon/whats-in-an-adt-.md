---
title: What's in an ADT ?
description:
url: http://blog.emillon.org/posts/2011-12-14-what-s-in-an-adt.html
date: 2011-12-14T00:00:00-00:00
preview_image:
featured:
authors:
- emillon
---

<h2>Introduction</h2>
<p>Algebraic Data Types, or ADTs for short, are a core feature of functional
languages such as OCaml or Haskell. They are a handy model of closed disjoint
unions and unfortunately, outside of the functional realm, they are only seldom
used.</p>
<p>In this article, I will explain what ADTs are, how they are used in OCaml and
what trimmed-down versions of them exist in other languages. I will use OCaml,
but the big picture is about the same in Haskell.</p>
<h2>Principles</h2>
<p>Functional languages offer a myriad of types for the programmer.</p>
<ul>
<li>some <em>base</em> types, such as <code>int</code>, <code>char</code> or <code>bool</code>.</li>
<li>functions, ie <em>arrow</em> types. A function with domain <code>a</code> and codomain <code>b</code> has
type <code>a -&gt; b</code>.</li>
<li>tuples, ie <em>product</em> types. A tuple is an heterogeneous, fixed-width
container type (its set-theoretic counterpart is the cartesian product) For
example, <code>(2, true, 'x')</code> has type <code>int * bool * char</code>. <em>record</em> types are a
(mostly) syntactic extension to give name to their fields.</li>
<li>some <em>parametric</em> types. For example, if <code>t</code> is a type, <code>t list</code> is the type
of homogeneous linked list of elements having type <code>t</code>.</li>
<li>what we are talking about today, <em>algebraic</em> types (or <em>sum</em> types, or
<em>variant</em> types).</li>
</ul>
<p>If product types represent the cartesian product, algebraic types represent the
disjoint union. In another words, they are very adapted for a case
analysis.</p>
<p>We will take the example of integer ranges. One can say that an integer range is
either :</p>
<ul>
<li>the empty range</li>
<li>of the form <code>]-&infin;;a]</code></li>
<li>of the form <code>[a;+&infin;[</code></li>
<li>an interval of the form <code>[a;b]</code> (where a &le; b)</li>
<li>the whole range (ie, &#8484;)</li>
</ul>
<p>With the following properties :</p>
<ul>
<li>Disjunction : no range can be of two forms at a time.</li>
<li>Injectivity : if <code>[a;b]</code> = <code>[c;d]</code>, then <code>a</code> = <code>c</code> and <code>b</code> = <code>d</code> (and
similarly for other forms).</li>
<li>Exhaustiveness : it cannot be of another form.</li>
</ul>
<h2>Syntax &amp; semantics</h2>
<p>This can be encoded as an ADT :</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> range =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-2" aria-hidden="true" tabindex="-1"></a>  | Empty</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-3" aria-hidden="true" tabindex="-1"></a>  | HalfLeft <span class="kw">of</span> <span class="dt">int</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-4" aria-hidden="true" tabindex="-1"></a>  | HalfRight <span class="kw">of</span> <span class="dt">int</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-5" aria-hidden="true" tabindex="-1"></a>  | Range <span class="kw">of</span> <span class="dt">int</span> * <span class="dt">int</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-6" aria-hidden="true" tabindex="-1"></a>  | FullRange</span></code></pre></div>
<p><code>Empty</code>, <code>HalfLeft</code>, <code>HalfRight</code>, <code>Range</code> and <code>FullRange</code> are <code>t</code>&rsquo;s
<em>constructors</em>. They are the only way to build a value of type <code>t</code>. For example,
<code>Empty</code>, <code>HalfLeft 3</code> and <code>Range (2, 5)</code> are all values of type <code>t</code><a href="http://blog.emillon.org/feeds/ocaml.xml#fn1" class="footnote-ref" role="doc-noteref"><sup>1</sup></a>. They
each have a specific <em>arity</em> (the number of arguments they take).</p>
<p>To <em>deconstruct</em> a value of type <code>t</code>, we have to use a powerful construct,
<em>pattern matching</em>, which is about matching a value against a sequence of
patterns (yes, that&rsquo;s about it).</p>
<p>To illustrate this, we will write a function that computes the minimum value of
such a range. Of course, this can be &plusmn;&infin; too, so we have to define a type to
represent the return value.</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> ext_int =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-2" aria-hidden="true" tabindex="-1"></a>  | MinusInfinity</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-3" aria-hidden="true" tabindex="-1"></a>  | Finite <span class="kw">of</span> <span class="dt">int</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-4" aria-hidden="true" tabindex="-1"></a>  | PlusInfinity</span></code></pre></div>
<p>In a math textbook, we would write the case analysis as :</p>
<ul>
<li>min &empty; = +&infin;</li>
<li>min ]-&infin;;a] = -&infin;</li>
<li>min [a;+&infin;[ = a</li>
<li>min [a;b] = a</li>
<li>min &#8484; = -&infin;</li>
</ul>
<p>That translates to the following (executable !) OCaml code :</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> range_min x =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-2" aria-hidden="true" tabindex="-1"></a>  <span class="kw">match</span> x <span class="kw">with</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-3" aria-hidden="true" tabindex="-1"></a>  | Empty -&gt; PlusInfinity</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-4" aria-hidden="true" tabindex="-1"></a>  | HalfLeft a -&gt; MinusInfinity</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-5" aria-hidden="true" tabindex="-1"></a>  | HalfRight a -&gt; Finite a</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-6" aria-hidden="true" tabindex="-1"></a>  | Range (a, b) -&gt; Finite a</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-7" aria-hidden="true" tabindex="-1"></a>  | FullRange -&gt; MinusInfinity</span></code></pre></div>
<p>In the pattern <code>HalfLeft a</code>, <code>a</code> is a variable name, so it get bounds to the
argument&rsquo;s value. In other words, <code>match (HalfLeft 2) with HalfLeft x -&gt; e</code>
bounds <code>x</code> to 2 in <code>e</code>.</p>
<h2>It&rsquo;s functions all the way down</h2>
<p>Pattern matching seems magical at first, but it is only a syntactic trick.
Indeed, the definition of the above type is equivalent to the following
definition :</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-1" aria-hidden="true" tabindex="-1"></a><span class="kw">type</span> range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-2" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-3" aria-hidden="true" tabindex="-1"></a><span class="co">(* The following is not syntactically correct *)</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-4" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> Empty : range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-5" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> HalfLeft : <span class="dt">int</span> -&gt; range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-6" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> HalfRight : <span class="dt">int</span> -&gt; range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-7" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> Range : <span class="dt">int</span> * <span class="dt">int</span> -&gt; range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-8" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> FullRange : range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-9" aria-hidden="true" tabindex="-1"></a><span class="co">(* Moreover, we know that they are injective and mutually disjoint *)</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-10" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-11" aria-hidden="true" tabindex="-1"></a><span class="kw">val</span> deconstruct_range :</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-12" aria-hidden="true" tabindex="-1"></a>  (<span class="dt">unit</span> -&gt; 'a) -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-13" aria-hidden="true" tabindex="-1"></a>  (<span class="dt">int</span> -&gt; 'a) -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-14" aria-hidden="true" tabindex="-1"></a>  (<span class="dt">int</span> -&gt; 'a) -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-15" aria-hidden="true" tabindex="-1"></a>  (<span class="dt">int</span> * <span class="dt">int</span> -&gt; 'a) -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-16" aria-hidden="true" tabindex="-1"></a>  (<span class="dt">unit</span> -&gt; 'a) -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-17" aria-hidden="true" tabindex="-1"></a>  range -&gt;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-18" aria-hidden="true" tabindex="-1"></a>  'a</span></code></pre></div>
<p><code>deconstruct_range</code> is what replaces pattern matching. It also embodies the notion of
exhaustiveness, because given any value of type <code>range</code>, we can build a
deconstructed value out of it.</p>
<p>Its type looks scary at first, but if we look closer, its arguments are a
sequence of case-specific deconstructors<a href="http://blog.emillon.org/feeds/ocaml.xml#fn2" class="footnote-ref" role="doc-noteref"><sup>2</sup></a> and the value to get &ldquo;matched&rdquo;
against.</p>
<p>To show the equivalence, we can implement <code>deconstruct_range</code> using pattern
patching and <code>range_min</code> using <code>deconstruct_range</code><a href="http://blog.emillon.org/feeds/ocaml.xml#fn3" class="footnote-ref" role="doc-noteref"><sup>3</sup></a> :</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> deconstruct_range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-2" aria-hidden="true" tabindex="-1"></a>      f_empty</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-3" aria-hidden="true" tabindex="-1"></a>      f_halfleft</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-4" aria-hidden="true" tabindex="-1"></a>      f_halfright</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-5" aria-hidden="true" tabindex="-1"></a>      f_range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-6" aria-hidden="true" tabindex="-1"></a>      f_fullrange</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-7" aria-hidden="true" tabindex="-1"></a>      x</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-8" aria-hidden="true" tabindex="-1"></a>    =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-9" aria-hidden="true" tabindex="-1"></a>  <span class="kw">match</span> x <span class="kw">with</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-10" aria-hidden="true" tabindex="-1"></a>  | Empty -&gt; f_empty ()</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-11" aria-hidden="true" tabindex="-1"></a>  | HalfLeft a -&gt; f_halfleft a</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-12" aria-hidden="true" tabindex="-1"></a>  | HalfRight a -&gt; f_halfright a</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-13" aria-hidden="true" tabindex="-1"></a>  | Range (a, b) -&gt; f_range (a, b)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb5-14" aria-hidden="true" tabindex="-1"></a>  | FullRange -&gt; f_fullrange ()</span></code></pre></div>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> range_min' x =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-2" aria-hidden="true" tabindex="-1"></a>  deconstruct_range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-3" aria-hidden="true" tabindex="-1"></a>    (<span class="kw">fun</span> () -&gt; PlusInfinity)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-4" aria-hidden="true" tabindex="-1"></a>    (<span class="kw">fun</span> a -&gt; MinusInfinity)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-5" aria-hidden="true" tabindex="-1"></a>    (<span class="kw">fun</span> a -&gt; Finite a)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-6" aria-hidden="true" tabindex="-1"></a>    (<span class="kw">fun</span> (a, b) -&gt; Finite a)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-7" aria-hidden="true" tabindex="-1"></a>    (<span class="kw">fun</span> () -&gt; MinusInfinity)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb6-8" aria-hidden="true" tabindex="-1"></a>    x</span></code></pre></div>
<h2>Implementation</h2>
<p>After this trip in denotational-land, let&rsquo;s get back to operational-land : how
is this implemented ?</p>
<p>In OCaml, no type information exists at runtime. Everything exists with a
uniform representation and is either an integer or a pointer to a block. Each
block starts with a tag, a size and a number of fields.</p>
<p>With the <code>Obj</code> module (kids, don&rsquo;t try this at home), it is possible to inspect
blocks at runtime. Let&rsquo;s write a dumper for <code>range</code> value and watch outputs :</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-1" aria-hidden="true" tabindex="-1"></a><span class="co">(* Range of integers between a and b *)</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-2" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> <span class="kw">rec</span> rng a b =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-3" aria-hidden="true" tabindex="-1"></a>  <span class="kw">if</span> a &gt; b <span class="kw">then</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-4" aria-hidden="true" tabindex="-1"></a>    []</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-5" aria-hidden="true" tabindex="-1"></a>  <span class="kw">else</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-6" aria-hidden="true" tabindex="-1"></a>    a :: rng (a+<span class="dv">1</span>) b</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-7" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-8" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> view_block o =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-9" aria-hidden="true" tabindex="-1"></a>  <span class="kw">if</span> (Obj.is_block o) <span class="kw">then</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-10" aria-hidden="true" tabindex="-1"></a>    <span class="kw">begin</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-11" aria-hidden="true" tabindex="-1"></a>      <span class="kw">let</span> tag = Obj.tag o <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-12" aria-hidden="true" tabindex="-1"></a>      <span class="kw">let</span> sz = Obj.size o <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-13" aria-hidden="true" tabindex="-1"></a>      <span class="kw">let</span> f n =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-14" aria-hidden="true" tabindex="-1"></a>        <span class="kw">let</span> f = Obj.field o n <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-15" aria-hidden="true" tabindex="-1"></a>        <span class="kw">assert</span> (Obj.is_int f);</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-16" aria-hidden="true" tabindex="-1"></a>        Obj.obj f</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-17" aria-hidden="true" tabindex="-1"></a>      <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-18" aria-hidden="true" tabindex="-1"></a>      tag :: <span class="dt">List</span>.map f (rng <span class="dv">0</span> (sz<span class="dv">-1</span>))</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-19" aria-hidden="true" tabindex="-1"></a>    <span class="kw">end</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-20" aria-hidden="true" tabindex="-1"></a>  <span class="kw">else</span> <span class="kw">if</span> Obj.is_int o <span class="kw">then</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-21" aria-hidden="true" tabindex="-1"></a>    [Obj.obj o]</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-22" aria-hidden="true" tabindex="-1"></a>  <span class="kw">else</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-23" aria-hidden="true" tabindex="-1"></a>    <span class="kw">assert</span> <span class="kw">false</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-24" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-25" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> examples () =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-26" aria-hidden="true" tabindex="-1"></a>  <span class="kw">let</span> p_list l =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-27" aria-hidden="true" tabindex="-1"></a>    <span class="dt">String</span>.concat <span class="st">&quot;;&quot;</span> (<span class="dt">List</span>.map <span class="dt">string_of_int</span> l)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-28" aria-hidden="true" tabindex="-1"></a>  <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-29" aria-hidden="true" tabindex="-1"></a>  <span class="kw">let</span> explore_range r =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-30" aria-hidden="true" tabindex="-1"></a>    <span class="dt">print_endline</span> (p_list (view_block (Obj.repr r)))</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-31" aria-hidden="true" tabindex="-1"></a>  <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-32" aria-hidden="true" tabindex="-1"></a>  <span class="dt">List</span>.iter explore_range</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-33" aria-hidden="true" tabindex="-1"></a>    [ Empty</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-34" aria-hidden="true" tabindex="-1"></a>    ; HalfLeft <span class="dv">8</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-35" aria-hidden="true" tabindex="-1"></a>    ; HalfRight <span class="dv">13</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-36" aria-hidden="true" tabindex="-1"></a>    ; Range (<span class="dv">2</span>, <span class="dv">5</span>)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-37" aria-hidden="true" tabindex="-1"></a>    ; FullRange</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb7-38" aria-hidden="true" tabindex="-1"></a>    ]</span></code></pre></div>
<p>When we run <code>examples ()</code>, it outputs :</p>
<pre><code>0
0;8
1;13
2;2;5
1</code></pre>
<p>We can see the following distinction :</p>
<ul>
<li>0-ary constructors (<code>Empty</code> and <code>FullRange</code>) are encoded are simple
integers.</li>
<li>other ones are encoded blocks with a constructor number as tag (0 for
<code>HalfLeft</code>, 1 for <code>HalfRight</code> and 2 for <code>Range</code>) and their argument list
afterwards.</li>
</ul>
<p>Thanks to this uniform representation, pattern-matching is straightforward : the
runtime system will only look at the tag number to decide which constructor has
been used, and if there are arguments to be bound, they are just after in the
same block.</p>
<h2>Conclusion</h2>
<p>Algebraic Data Types are a simple model of disjoint unions, for which
case analyses are the most natural. In more mainstream languages, some
alternatives exist but they are more limited to model the same problem.</p>
<p>For example, in object-oriented languages, the Visitor pattern is the natural
way to do it. But class trees are inherently &ldquo;open&rdquo;, thus breaking the
exhaustivity property.</p>
<p>The closest implementation is tagged unions in C, but they require to roll your
own solution using <code>enum</code>s, <code>struct</code>s and <code>union</code>s. This also means that all
your hand-allocated blocks will have the same size.</p>
<p>Oh, and I would love to know how this problem is solved with other paradigms !</p>
<section class="footnotes footnotes-end-of-document" role="doc-endnotes">
<hr/>
<ol>
<li><p>Unfortunately, so is <code>Range (10, 2)</code>. The invariant that a &le; b has to be
enforced by the programmer when using this constructor.<a href="http://blog.emillon.org/feeds/ocaml.xml#fnref1" class="footnote-back" role="doc-backlink">&#8617;&#65038;</a></p></li>
<li><p>For 0-ary constructors, the type has to be <code>unit -&gt; 'a</code> instead of <code>'a</code> to
allow side effects to happen during pattern matching.<a href="http://blog.emillon.org/feeds/ocaml.xml#fnref2" class="footnote-back" role="doc-backlink">&#8617;&#65038;</a></p></li>
<li><p>More precisely, we would have to show that any function written with
pattern matching can be adapted to use the deconstructor instead. I hope
that this example is general enough to get the idea.<a href="http://blog.emillon.org/feeds/ocaml.xml#fnref3" class="footnote-back" role="doc-backlink">&#8617;&#65038;</a></p></li>
</ol>
</section>
