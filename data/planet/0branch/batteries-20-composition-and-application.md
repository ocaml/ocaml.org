---
title: 'Batteries 2.0: Composition and application'
description:
url: http://blog.0branch.com/posts/2013-02-24-batteries-v2-composition.html
date: 2013-02-24T00:00:00-00:00
preview_image:
featured:
authors:
- 0branch
---

<div>
  <div class="span-22">
    <div class="span-12"><h1>Batteries 2.0: Composition and application</h1></div>
    <div style="text-align: right" class="span-10 last">
      <a href="https://blog.0branch.com/index.html">#</a> February 24, 2013
    </div>
  </div>
  <hr/>
  <div>
    <p>A <a href="https://blog.0branch.com/posts/2012-04-17-haskell-application-ocaml.html">while back</a>, I discussed an implementation of the application operator (Haskell&rsquo;s <code>$</code>) in OCaml. In the closing section of that post, a couple of problems were raised regarding treatment of associativity and composition in <em>OCaml Batteries</em>. These issues have been addressed in <em>Batteries</em> 2.0, released in January 2013; the improvements are outlined here.</p>
<h2>Quick recap</h2>
<p>Batteries <a href="http://ocaml-batteries-team.github.com/batteries-included/hdoc/BatPervasives.html">1.x</a> defines the following operators for composition and application:</p>
<ul>
<li><code>val ( -| ) : ('a -&gt; 'b) -&gt; ('c -&gt; 'a) -&gt; 'c -&gt; 'b</code>
<ul>
<li>&ldquo;Function composition. <code>f -| g</code> is <code>fun x -&gt; f (g x)</code>. Mathematically, this is operator <code>o</code>.&rdquo;</li>
</ul></li>
<li><code>val ( **&gt; ) : ('a -&gt; 'b) -&gt; 'a -&gt; 'b</code>
<ul>
<li>&ldquo;Function application. <code>f **&gt; x</code> is equivalent to <code>f x</code>. This [operator] may be useful for composing sequences of function calls without too many parenthesis.&rdquo;</li>
</ul></li>
</ul>
<p>The problem pointed out in the comments section (now the closing <em>Update</em>) of the <a href="https://blog.0branch.com/posts/2012-04-17-haskell-application-ocaml.html">post</a> was that</p>
<blockquote>
<p>the precedence you&rsquo;d expect coming from Haskell is inverted. We&rsquo;d need to define a new application operator to address this problem as the commenter suggested&hellip;</p>
</blockquote>
<p>Specifically, the following code sample was shown to exhibit surprising behaviour for anyone familiar with Haskell&rsquo;s <code>.</code> and <code>$</code>,</p>
<pre><code># print_endline -| string_of_int **&gt; succ **&gt; sum [1; 2; 3];;
Error: This expression has type string but an expression was expected of type 'a -&gt; string</code></pre>
<h2>What&rsquo;s up, doc?</h2>
<p>In Batteries <a href="http://ocaml-batteries-team.github.com/batteries-included/hdoc2/BatPervasives.html">2.0</a>, both operators have been renamed:</p>
<ul>
<li>Composition:
<ul>
<li><code>(-|)</code> is now <code>(%)</code></li>
</ul></li>
<li>Application:
<ul>
<li><code>(**&gt;)</code> is now <code>(@@)</code></li>
</ul></li>
</ul>
<p>To appreciate the behaviour of the new operators, we can once again consult (a subsection of) the operator associativity table from the <a href="http://caml.inria.fr/pub/docs/manual-ocaml/expr.html">language manual</a>:</p>
<table>
<thead>
<tr class="header">
<th>Construction or operator</th>
<th>Associativity</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>*...</code> <code>/...</code> <code>%...</code> <code>mod</code> <code>land</code> <code>lor</code> <code>lxor</code></td>
<td>left</td>
</tr>
<tr class="even">
<td><code>+...</code> <code>-...</code></td>
<td>left</td>
</tr>
<tr class="odd">
<td><code>::</code></td>
<td>right</td>
</tr>
<tr class="even">
<td><code>@...</code> <code>^...</code></td>
<td>right</td>
</tr>
<tr class="odd">
<td><code>=...</code> <code>&lt;...</code> <code>&gt;...</code> <code>|...</code> <code>&amp;...</code> <code>$...</code></td>
<td>left</td>
</tr>
</tbody>
</table>
<p>A couple of things are worth noting:</p>
<ul>
<li>The associativity of the application operator has changed.
<ul>
<li><code>(**&gt;)</code> is left associative, <code>(@@)</code> right.</li>
<li>As discussed in the original post, right associativity is an integral feature of the application operator.</li>
</ul></li>
<li>In Batteries 1.x, application had higher precedence than composition.
<ul>
<li><code>(**&gt;)</code> is covered by the first row of the table, <code>(-|)</code> by the second.</li>
<li>As of Batteries 2.0, this precedence has been inverted.</li>
</ul></li>
</ul>
<h2>No surprises</h2>
<p>Reworking the above code sample for Batteries 2.0 is trivial&mdash;simply substitute <code>(%)</code> for <code>(-|)</code> and <code>(@@)</code> for <code>(**&gt;)</code>. With these changes in place, the code behaves as follows:</p>
<pre><code># print_endline % string_of_int @@ succ @@ sum [1; 2; 3];;
7
- : unit = ()</code></pre>
<p>Crucially, the application operator has lower precedence than the composition operator and is right associative.</p>
<p>Returning to the <a href="http://hackage.haskell.org/packages/archive/base/4.5.0.0/doc/html/Prelude.html#v:-36-">definition</a> of <code>$</code> referenced at the outset of the original post,</p>
<blockquote>
<p>This operator is redundant, since ordinary application <code>(f x)</code> means the same as <code>(f $ x)</code>. However, <code>$</code> has low, right-associative binding precedence, so it sometimes allows parentheses to be omitted.</p>
</blockquote>
<p>it should be apparent that these new operators closely conform to Haskell&rsquo;s treatment of application and composition (in particular, associativity and precedence), allowing for a straightforward translation of the above expression:</p>
<pre><code>Prelude&gt; putStrLn . show $ succ $ sum [1, 2, 3]
7</code></pre>
  </div>
</div>

<hr/>

<div></div>

<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>

