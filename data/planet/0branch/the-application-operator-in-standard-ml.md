---
title: The application operator in Standard ML
description:
url: http://blog.0branch.com/posts/2012-04-22-application-operator.html
date: 2012-04-22T00:00:00-00:00
preview_image:
featured:
authors:
- 0branch
---

<div>
  <div class="span-22">
    <div class="span-12"><h1>The application operator in Standard ML</h1></div>
    <div style="text-align: right" class="span-10 last">
      <a href="https://blog.0branch.com/index.html">#</a> April 22, 2012
    </div>
  </div>
  <hr/>
  <div>
    <p>In the <a href="https://blog.0branch.com/posts/2012-04-17-haskell-application-ocaml.html">previous post</a> I introduced the <code>$</code> operator to OCaml using two different approaches:</p>
<ol type="1">
<li>Renaming the operator to <code>**$</code> or <code>@$</code> in order to achieve the necessary associativity.</li>
<li>Leveraging Camlp4 to provide a syntax extension.</li>
</ol>
<p>In the comments section<a href="https://blog.0branch.com/rss.xml#fn1" class="footnote-ref"><sup>1</sup></a>, variants of these operators were provided that mirror Haskell&rsquo;s relative precedence of application and composition.</p>
<p>As a postscript, I thought it might be interesting to look at the implementation of <code>$</code> in Standard ML. Here it is in the <a href="http://www.smlnj.org">SML/NJ</a> toplevel,</p>
<pre><code>Standard ML of New Jersey v110.74 [built: Wed Apr 11 13:33:07 2012]
- infixr 0 $;
infixr $
- fun (f $ x) = f x;
val $ = fn : ('a -&gt; 'b) * 'a -&gt; 'b</code></pre>
<p>Of note:</p>
<ul>
<li>Standard ML lets us specify the associativity of newly defined operators explicitly (using the <code>infix*</code> fixity directives) whereas OCaml follows an operator naming convention.</li>
<li>As such, we have no need to fall back on syntax extensions here; <code>$</code> is a valid name for a right associative operator.</li>
</ul>
<p>To replicate the target example of the previous post we&rsquo;ll need to define a few utilities,</p>
<pre><code>- fun succ x = x + 1;
val succ = fn : int -&gt; int
- val sum = foldl op+ 0;
val sum = fn : int list -&gt; int
- fun printLn str = print $ str ^ &quot;\n&quot;;
val printLn = fn : string -&gt; unit</code></pre>
<p>Note that <code>printLn</code> is defined using <code>$</code>; the standard approach would be <code>fun printLn str = print (str ^ &quot;\n&quot;)</code>.</p>
<p>With these definitions in place, we can employ <code>$</code> to print the desired result:</p>
<pre><code>- printLn $ Int.toString $ succ $ sum [1, 2, 3];
7
val it = () : unit</code></pre>
<p>Finally, since <code>$</code> was defined with a precedence level of <code>0</code>, it interacts correctly with SML&rsquo;s composition operator, <code>o</code>, which has a precedence of <code>3</code> (as per the Standard):</p>
<pre><code>- printLn o Int.toString $ succ $ sum [1, 2, 3];
7
val it = () : unit</code></pre>
<section class="footnotes">
<hr/>
<ol>
<li><p>See the closing <em>Update</em>.<a href="https://blog.0branch.com/rss.xml#fnref1" class="footnote-back">&#8617;</a></p></li>
</ol>
</section>
  </div>
</div>

<hr/>

<div></div>

<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>

