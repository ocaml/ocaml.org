---
title: Making type inference explode
description:
url: http://blog.emillon.org/posts/2014-05-21-making-type-inference-explode.html
date: 2014-05-21T00:00:00-00:00
preview_image:
featured:
authors:
- emillon
---

<p>Hindley-Milner type systems are in a sweet spot in that they are both expressive
and easy to infer. For example, type inference can turn this program:</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> <span class="kw">rec</span> length = <span class="kw">function</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-2" aria-hidden="true" tabindex="-1"></a>  | [] -&gt; <span class="dv">0</span> </span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-3" aria-hidden="true" tabindex="-1"></a>  | x::xs -&gt; <span class="dv">1</span> + length xs</span></code></pre></div>
<p>into this one (the top-level type <code>'a list -&gt; int</code> is usually what is
interesting but the compiler has to infer the type of every subexpression):</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> <span class="kw">rec</span> length : 'a <span class="dt">list</span> -&gt; <span class="dt">int</span> = <span class="kw">function</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-2" aria-hidden="true" tabindex="-1"></a>  | [] -&gt; (<span class="dv">0</span> : <span class="dt">int</span>)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-3" aria-hidden="true" tabindex="-1"></a>  | (x:'a)::(xs : 'a <span class="dt">list</span>) -&gt; (<span class="dv">1</span> : <span class="dt">int</span>)</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb2-4" aria-hidden="true" tabindex="-1"></a>        + ((length : 'a <span class="dt">list</span> -&gt; <span class="dt">int</span>) (xs : 'a <span class="dt">list</span>) : <span class="dt">int</span>)</span></code></pre></div>
<p>Because the compiler does so much work, it is reasonable to wonder whether it is
efficient. The theoretical answer to this question is that type inference is
EXP-complete, but given reasonable constraints on the program, it can be done in
quasi-linear time (<span class="math inline"><em>n</em>&nbsp;log&#8198;&nbsp;<em>n</em></span> where <span class="math inline"><em>n</em></span> is the size of the program).</p>
<p>Still, one may wonder what kind of pathological cases show this exponential
effect. Here is one such example:</p>
<div class="sourceCode"><pre class="sourceCode ocaml"><code class="sourceCode ocaml"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> p x y = <span class="kw">fun</span> z -&gt; z x y ;;</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-2" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-3" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> r () =</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-4" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> x1 = <span class="kw">fun</span> x -&gt; p x x <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-5" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> x2 = <span class="kw">fun</span> z -&gt; x1 (x1 z) <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-6" aria-hidden="true" tabindex="-1"></a><span class="kw">let</span> x3 = <span class="kw">fun</span> z -&gt; x2 (x2 z) <span class="kw">in</span></span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-7" aria-hidden="true" tabindex="-1"></a>x3 (<span class="kw">fun</span> z -&gt; z);;</span></code></pre></div>
<p>The type signature of <code>r</code> is already daunting:</p>
<pre><code>% ocamlc -i types.ml
val p : 'a -&gt; 'b -&gt; ('a -&gt; 'b -&gt; 'c) -&gt; 'c
val r :
  unit -&gt;
  (((((((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt;
       ((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt; 'c) -&gt;
      'c) -&gt;
     ((((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt;
       ((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt; 'c) -&gt;
      'c) -&gt;
     'd) -&gt;
    'd) -&gt;
   ((((((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt;
       ((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt; 'c) -&gt;
      'c) -&gt;
     ((((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt;
       ((('a -&gt; 'a) -&gt; ('a -&gt; 'a) -&gt; 'b) -&gt; 'b) -&gt; 'c) -&gt;
      'c) -&gt;
     'd) -&gt;
    'd) -&gt;
   'e) -&gt;
  'e</code></pre>
<p>But what&rsquo;s interesting about this program is that we can add (or remove) lines
to study how input size can alter the processing time and output type size. It
explodes:</p>
<table>
<thead>
<tr class="header">
<th>n</th>
<th style="text-align: right;">wc -c</th>
<th style="text-align: right;">time</th>
<th style="text-align: right;">leaves(n)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1</td>
<td style="text-align: right;">98</td>
<td style="text-align: right;">15ms</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td>2</td>
<td style="text-align: right;">167</td>
<td style="text-align: right;">15ms</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td>3</td>
<td style="text-align: right;">610</td>
<td style="text-align: right;">15ms</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="even">
<td>4</td>
<td style="text-align: right;">11630</td>
<td style="text-align: right;">38ms</td>
<td style="text-align: right;">128</td>
</tr>
<tr class="odd">
<td>5</td>
<td style="text-align: right;">4276270</td>
<td style="text-align: right;">6.3s</td>
<td style="text-align: right;">32768</td>
</tr>
</tbody>
</table>
<p>Observing the number of <code>('a -&gt; 'a)</code> leaves in the output type reveals that it
is is squared and doubled at each step, leading to an exponential growth.</p>
<p>In practice, this effect does not appear in day-to-day programs because
programmers annotate the top-level declarations with their types. In that case,
the size of the types would be merely proportional to the size of the program,
because the type annotation would be gigantic.</p>
<p>Also, programmers tend to write functions that do something useful, which these
do not seem to do &#9786;.</p>
