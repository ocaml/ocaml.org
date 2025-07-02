---
title: Easy parsing with reasonable error messages in OCaml's Angstrom
description: How to use 'labels' to provide helpful parse error messages
url: https://dev.to/yawaramin/easy-parsing-with-reasonable-error-messages-in-ocamls-angstrom-g5f
date: 2025-05-08T22:00:40-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fzvd8k6z1rfbs10d93mx4.png
authors:
- Yawar Amin
source:
ignore:
---

<p>PARSER combinators are widely used in the world of functional programming, and OCaml's <a href="https://github.com/inhabitedtype/angstrom" rel="noopener noreferrer">Angstrom</a> library is one of them. It is used to implement many foundational parsers in the OCaml ecosystem, eg HTTP parsers for the <a href="https://github.com/inhabitedtype/httpaf" rel="noopener noreferrer">httpaf</a> stack.</p>

<p>However, one of their bigger downsides is the lack of accurate parse error reporting. Let's take a look. Suppose you want to parse records of this format: <code>1 Bob</code> ie an ID number followed by one or more spaces, followed by an alphabetic word (a name). Here's a basic Angstrom parser for this:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">open</span> <span class="nc">Angstrom</span>

<span class="k">type</span> <span class="n">person</span> <span class="o">=</span> <span class="p">{</span> <span class="n">id</span> <span class="o">:</span> <span class="kt">int</span><span class="p">;</span> <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span> <span class="p">}</span>

<span class="k">let</span> <span class="n">sp</span> <span class="o">=</span> <span class="n">skip_many1</span> <span class="p">(</span><span class="kt">char</span> <span class="k">'</span> <span class="k">'</span><span class="p">)</span>
<span class="k">let</span> <span class="n">word</span> <span class="o">=</span> <span class="n">take_while1</span> <span class="p">(</span><span class="k">function</span> <span class="k">'</span><span class="nn">A'</span> <span class="p">..</span> <span class="err">'</span><span class="nc">Z'</span> <span class="o">|</span> <span class="k">'</span><span class="n">a'</span><span class="o">..</span><span class="k">'</span><span class="n">z'</span> <span class="o">-&gt;</span> <span class="bp">true</span> <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="p">)</span>
<span class="k">let</span> <span class="n">num</span> <span class="o">=</span> <span class="n">take_while1</span> <span class="p">(</span><span class="k">function</span> <span class="k">'</span><span class="mi">0</span><span class="k">'</span><span class="o">..</span><span class="k">'</span><span class="mi">9</span><span class="k">'</span> <span class="o">-&gt;</span> <span class="bp">true</span> <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="p">)</span>

<span class="k">let</span> <span class="n">person</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">id</span> <span class="o">=</span> <span class="n">num</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">sp</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">name</span> <span class="o">=</span> <span class="n">word</span>
  <span class="ow">and</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">end_of_input</span> <span class="k">in</span>
  <span class="p">{</span> <span class="n">id</span> <span class="o">=</span> <span class="n">int_of_string</span> <span class="n">id</span><span class="p">;</span> <span class="n">name</span> <span class="p">}</span>
</code></pre>

</div>



<p>Let's try out various bad inputs and check the errors:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># parse_string ~consume:Consume.All person "";;
- : (person, string) result = Error ": count_while1"

# parse_string ~consume:Consume.All person "1";;
- : (person, string) result = Error ": not enough input"

# parse_string ~consume:Consume.All person "1 ";;
- : (person, string) result = Error ": count_while1"

# parse_string ~consume:Consume.All person "1 1";;
- : (person, string) result = Error ": count_while1"
</code></pre>

</div>



<p>The error messages are not great, unfortunately! It's hard to tell what went wrong. Of course, in this case we know what caused each error because we are feeding small inputs to the parser. But it's easy to imagine that for larger inputs it may be difficult to understand why a parse is failing.</p>

<p>Fortunately, parser combinator libraries usually provide a 'label' function to improve the error messages slightly. In Angstrom, a label works like this: <code>parser &lt;?&gt; "label string"</code>. But the default label functionality allows labelling with only a static string. Let's improve labelling even more! Using a little-known feature of Angstrom, we can take a snapshot of the remaining string left to parse and actually include it in the error message if parsing fails.</p>

<p>Here, we are just augmenting the built-in label operator with a more powerful, snapshotting version:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="p">(</span> <span class="o">&lt;?&gt;</span> <span class="p">)</span> <span class="n">p</span> <span class="n">l</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">*</span> <span class="n">remaining</span> <span class="o">=</span> <span class="n">available</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">remaining</span> <span class="o">=</span> <span class="n">min</span> <span class="n">remaining</span> <span class="mi">20</span> <span class="k">in</span>
  <span class="k">let</span><span class="o">*</span> <span class="n">s</span> <span class="o">=</span> <span class="n">peek_string</span> <span class="n">remaining</span> <span class="k">in</span>
  <span class="n">p</span> <span class="o">&lt;?&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="s2">"%s, got: [%s]"</span> <span class="n">l</span> <span class="n">s</span>
</code></pre>

</div>



<p>Now let's redefine our parsers to use this augmented labelling operator:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">sp</span> <span class="o">=</span> <span class="n">skip_many1</span> <span class="p">(</span><span class="kt">char</span> <span class="k">'</span> <span class="k">'</span><span class="p">)</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected one or more spaces"</span>
<span class="k">let</span> <span class="n">word</span> <span class="o">=</span> <span class="n">take_while1</span> <span class="p">(</span><span class="k">function</span> <span class="k">'</span><span class="nn">A'</span> <span class="p">..</span> <span class="err">'</span><span class="nc">Z'</span> <span class="o">|</span> <span class="k">'</span><span class="n">a'</span><span class="o">..</span><span class="k">'</span><span class="n">z'</span> <span class="o">-&gt;</span> <span class="bp">true</span> <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="p">)</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected a word"</span>
<span class="k">let</span> <span class="n">num</span> <span class="o">=</span> <span class="n">take_while1</span> <span class="p">(</span><span class="k">function</span> <span class="k">'</span><span class="mi">0</span><span class="k">'</span><span class="o">..</span><span class="k">'</span><span class="mi">9</span><span class="k">'</span> <span class="o">-&gt;</span> <span class="bp">true</span> <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="p">)</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected a number"</span>

<span class="k">let</span> <span class="n">person</span> <span class="o">=</span>
  <span class="p">(</span><span class="k">let</span><span class="o">+</span> <span class="n">id</span> <span class="o">=</span> <span class="n">num</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected a numeric ID"</span>
   <span class="ow">and</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">sp</span>
   <span class="ow">and</span><span class="o">+</span> <span class="n">name</span> <span class="o">=</span> <span class="n">word</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected a name"</span>
   <span class="ow">and</span><span class="o">+</span> <span class="n">_</span> <span class="o">=</span> <span class="n">end_of_input</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected end of input"</span> <span class="k">in</span>
   <span class="p">{</span> <span class="n">id</span> <span class="o">=</span> <span class="n">int_of_string</span> <span class="n">id</span><span class="p">;</span> <span class="n">name</span> <span class="p">})</span> <span class="o">&lt;?&gt;</span> <span class="s2">"expected a person"</span>
</code></pre>

</div>



<p>Let's try the same error scenarios:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># parse_string ~consume:Consume.All person "";;
- : (person, string) result =
Error
 "expected a person, got: [] &gt; expected a numeric ID, got: [] &gt; expected a number, got: []: count_while1"

# parse_string ~consume:Consume.All person "1";;
- : (person, string) result =
Error
 "expected a person, got: [1] &gt; expected one or more spaces, got: []: not enough input"

# parse_string ~consume:Consume.All person "1 ";;
- : (person, string) result =
Error
 "expected a person, got: [1 ] &gt; expected a name, got: [] &gt; expected a word, got: []: count_while1"

# parse_string ~consume:Consume.All person "1 b1";;
- : (person, string) result =
Error
 "expected a person, got: [1 b1] &gt; expected end of input, got: [1]: end_of_input"
</code></pre>

</div>



<p>The text in the brackets shows a snapshot of the string remaining to parse, which narrows down at each level to the exact string where the parse failed! With this snapshot of the remaining string, we can easily figure out where the parse failed.</p>

<p>Happy parsing!</p>


