---
title: Nesting quoted strings in OCaml
description: Quoting             According to the lexical conventions of OCaml, characters
  different from \  and "  can be enclosed in sing...
url: http://blog.shaynefletcher.org/2017/10/nesting-quoted-strings-in-ocaml.html
date: 2017-10-28T00:53:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>Quoting</title>
  </head>
  <body>
    <p>
According to the lexical conventions of OCaml, characters different from <code class="code">\</code> and <code class="code">&quot;</code> can be enclosed in single quotes and appear in strings. The special characters <code class="code">\</code> and <code class="code">&quot;</code> are represented in these contexts by their <em>escape sequences</em>. The 
escape sequence <code class="code">\\</code> denotes the character <code class="code">\</code> and <code class="code">\&quot;</code> denotes the character <code>&quot;</code>.
</p>
<p>Here we print the string <code class="code">&quot;Hello world!</code>&quot;. The quotes delimit the string and are not themselves part of the string.
</p><pre><code class="code">utop[0]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf <span class="string">&quot;Hello world!&quot;</span>;;
<span class="string">Hello world!</span>- : unit = ()
</code></pre>
<p>
To capture the quotes we need to write them into the string by their escape sequence.
</p><pre><code class="code">utop[1]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf <span class="string">&quot;\&quot;Hello world!\&quot;&quot;</span>;;
<span class="string">&quot;Hello world!&quot;</span>- : unit = ()
</code></pre>

<p>
What now if we wish to quote a string within a string?
</p><pre><code class="code">utop[3]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf 
<span class="string">&quot;\&quot;A quoted string with \\\&quot;a nested quoted string\\\&quot;\&quot;&quot;</span>;;
<span class="string">&quot;A quoted string with \&quot;a nested quoted
string\&quot;&quot;</span>- : unit = ()
</code></pre>
<p>
We see that in rendering the above string, <code class="code">printf</code> has rendered the escape sequence <code class="code">\&quot;</code> as <code class="code">&quot;</code> and <code class="code">\\\&quot;</code> as <code class="code">\&quot;</code> as required. The pattern continues if we now wish to quote a string within a quoted string within a quoted string.
</p><pre><code class="code">utop[4]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf 
<span class="string">&quot;\&quot;A quoted string with \\\&quot;a nested \\\\\\\&quot;nested\\\\\\\&quot;
quoted string\\\&quot;\&quot;&quot;</span>;;
<span class="string">&quot;A quoted string with \&quot;a nested \\\&quot;nested\\\&quot;
quoted string\&quot;&quot;</span>- : unit = ()
</code></pre>

<p>As you can see, things get crazy pretty quickly and you can easily drive yourself mad working out the correct escape sequences to get the desired nesting!
</p>
<p>Here's a hack : If the string has <i>k</i> levels of quoting, then count how many occurences of <code class="code">\</code>s precede the <code class="code">&quot;</code> at that level. Let that number be <i>n</i> say. To get the next level of quoting you need to concatenate a sequence of <i>n + 1</i> <code class="code">\</code>s to them to get a total of <i>2n + 1</i> <code class="code">\</code>s. To illustrate, look again at the last example:
</p><pre><code class="code">utop[4]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf 
<span class="string">&quot;\&quot;A quoted string with \\\&quot;a nested \\\\\\\&quot;nested\\\\\\\&quot;
quoted string\\\&quot;\&quot;&quot;</span>;;
<span class="string">&quot;A quoted string with \&quot;a nested \\\&quot;nested\\\&quot;
quoted string\&quot;&quot;</span>- : unit = ()
</code></pre>
That's three level of quoting. At the third level we have the sequence <code class="code">\\\\\\\&quot;</code>. That's <i>7</i> <code class="code">\</code>s. To quote to the fourth level then we need <i>8 + 7 = 15</i> <code class="code">\</code>s:
<pre><code class="code">utop[5]&gt; <span class="constructor">Caml</span>.<span class="constructor">Printf</span>.printf 
<span class="string">&quot;\&quot;A quoted string with \\\&quot;a nested \\\\\\\&quot;nested
\\\\\\\\\\\\\\\&quot;nested\\\\\\\\\\\\\\\&quot; \\\\\\\&quot; quoted string\\\&quot;\&quot;&quot;</span>;;
<span class="string">&quot;A quoted string with \&quot;a nested \\\&quot;nested
\\\\\\\&quot;nested\\\\\\\&quot; \\\&quot; quoted string\&quot;&quot;</span>- : unit = ()
</code></pre>
      
<p>In general, the number of <code class="code">\</code>s required for <i>n</i> levels of quoting is <i>2<sup>n</sup> - 1</i> (that is, an exponential function). The solution follows from the recurrence relation <i>Q<sub>0</sub> = 0</i> and <i>Q<sub>n</sub> = 2Q<sub>n - 1</sub> + 1</i> which in fact establishes a connection to the &quot;Towers of Hanoi&quot; problem.
</p>
    <hr/>
  </body>
</html>

