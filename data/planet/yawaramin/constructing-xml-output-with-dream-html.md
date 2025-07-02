---
title: Constructing XML output with dream-html
description: How to have complete control over the XML output from your code
url: https://dev.to/yawaramin/constructing-xml-output-with-dream-html-1pgb
date: 2024-07-14T21:53:00-00:00
preview_image: https://media2.dev.to/dynamic/image/width=1000,height=500,fit=cover,gravity=auto,format=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fniz4ui5hmyu7p5ywgqaq.png
authors:
- Yawar Amin
source:
ignore:
---

<p>FOR some time now, I have been maintaining an OCaml library called <a href="https://github.com/yawaramin/dream-html" rel="noopener noreferrer">dream-html</a>. This library is primarily intended to render correctly-constructed HTML, SVG, and MathML. Recently, I added the ability to render well-formed XML markup, which has slightly different rules than HTML. For example, in HTML if you want to write an empty <code>div</code> tag, you do: <code>&lt;div&gt;&lt;/div&gt;</code>. But according to the rules of XML, you could <em>also</em> write <code>&lt;div/&gt;</code> ie a self-closing tag, however HTML 5 does not have the concept of self-closing tags!</p>

<p>So by having the library take care of these subtle but crucial details, you can just concentrate on writing code that generates the markup. Of course, this has many other advantages too, but in this post I will just look at XML.</p>

<p>It turns out that often we need to serialize some data into XML format, for storage or communication purposes. There are a few packages in the OCaml ecosystem which handle XML, however I think dream-html actually does it surprisingly well now. Let's take a look.</p>

<p>But first, a small clarification about the dream-html package itself. Recently I split it up into <em>two</em> packages:</p>

<ol>
<li>
<code>pure-html</code> has all the functionality needed to write valid HTML and XML</li>
<li>
<code>dream-html</code> has all of the above, plus some integration with the <a href="https://aantron.github.io/dream" rel="noopener noreferrer">Dream</a> web framework for ease of use.</li>
</ol>

<p>As you might imagine, the reason for the split was to allow using the HTML/XML functionality of the package without having to pull in the entire Dream dependency cone, which is quite large, especially if you happen to be using a different dependency cone as well. So <code>pure-html</code> depends only on the <code>uri</code> package to help construct correct URI strings.</p>

<p>To start using it, just install: <code>opam install pure-html</code></p>

<p>And add to your <code>dune</code> file: <code>(libraries pure-html)</code></p>

<p>Now, let's look at an example of how you can use it to construct XML. Suppose you have the following type:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">type</span> <span class="n">person</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">email</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
<span class="p">}</span>
</code></pre>

</div>



<p>And you need to serialize it to XML like this:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight xml"><code><span class="nt">&lt;person</span> <span class="na">name=</span><span class="s">"Bob"</span> <span class="na">email=</span><span class="s">"bob@info.com"</span><span class="nt">/&gt;</span>
</code></pre>

</div>



<p>Let's write a serializer using the <code>pure-html</code> package:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">open</span> <span class="nc">Pure_html</span>

<span class="k">let</span> <span class="n">person_xml</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">person</span> <span class="o">=</span> <span class="n">std_tag</span> <span class="s2">"person"</span>
  <span class="ow">and</span> <span class="n">name</span> <span class="o">=</span> <span class="n">string_attr</span> <span class="s2">"name"</span>
  <span class="ow">and</span> <span class="n">email</span> <span class="o">=</span> <span class="n">string_attr</span> <span class="s2">"email"</span> <span class="k">in</span>
  <span class="k">fun</span> <span class="p">{</span> <span class="n">name</span> <span class="o">=</span> <span class="n">n</span><span class="p">;</span> <span class="n">email</span> <span class="o">=</span> <span class="n">e</span> <span class="p">}</span> <span class="o">-&gt;</span> <span class="n">person</span> <span class="p">[</span><span class="n">name</span> <span class="s2">"%s"</span> <span class="n">n</span><span class="p">;</span> <span class="n">email</span> <span class="s2">"%s"</span> <span class="n">e</span><span class="p">]</span> <span class="bp">[]</span>
</code></pre>

</div>



<p>Let's test it out:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code>$ utop -require pure-html
# open Pure_html;;
# let pp = pp_xml ~header:true;;
val pp : Format.formatter -&gt; node -&gt; unit = &lt;fun&gt;
# #install_printer pp;;
# type person = {
  name : string;
  email : string;
};;
type person = { name : string; email : string; }
# let person_xml =
  let person = std_tag "person"
  and name = string_attr "name"
  and email = string_attr "email" in
  fun { name = n; email = e } -&gt; person [name "%s" n; email "%s" e] [];;
val person_xml : person -&gt; node = &lt;fun&gt;
# person_xml { name = "Bob"; email = "bob@example.com" };;
- : node =
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;person
name="Bob"
email="bob@example.com" /&gt;
</code></pre>

</div>



<p>OK cool, so our <code>person</code> record is serialized in this specific way. But, what if we need to serialize it like:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight xml"><code><span class="nt">&lt;person&gt;</span>
  <span class="nt">&lt;name&gt;</span>Bob<span class="nt">&lt;/name&gt;</span>
  <span class="nt">&lt;email&gt;</span>bob@example.com<span class="nt">&lt;/email&gt;</span>
<span class="nt">&lt;/person&gt;</span>
</code></pre>

</div>



<p>After all, this is a common way of formatting records in XML. Let's write the serializer in this style:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">person_xml</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">person</span> <span class="o">=</span> <span class="n">std_tag</span> <span class="s2">"person"</span>
  <span class="ow">and</span> <span class="n">name</span> <span class="o">=</span> <span class="n">std_tag</span> <span class="s2">"name"</span>
  <span class="ow">and</span> <span class="n">email</span> <span class="o">=</span> <span class="n">std_tag</span> <span class="s2">"email"</span> <span class="k">in</span>
  <span class="k">fun</span> <span class="p">{</span> <span class="n">name</span> <span class="o">=</span> <span class="n">n</span><span class="p">;</span> <span class="n">email</span> <span class="o">=</span> <span class="n">e</span> <span class="p">}</span> <span class="o">-&gt;</span>
    <span class="n">person</span> <span class="bp">[]</span> <span class="p">[</span>
      <span class="n">name</span> <span class="bp">[]</span> <span class="p">[</span><span class="n">txt</span> <span class="s2">"%s"</span> <span class="n">n</span><span class="p">];</span>
      <span class="n">email</span> <span class="bp">[]</span> <span class="p">[</span><span class="n">txt</span> <span class="s2">"%s"</span> <span class="n">e</span><span class="p">];</span>
    <span class="p">]</span>
</code></pre>

</div>



<p>Let's try it out:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight plaintext"><code># let person_xml =
  let person = std_tag "person"
  and name = std_tag "name"
  and email = std_tag "email" in
  fun { name = n; email = e } -&gt;
    person [] [
      name [] [txt "%s" n];
      email [] [txt "%s" e];
    ];;
val person_xml : person -&gt; node = &lt;fun&gt;
# person_xml { name = "Bob"; email = "bob@example.com" };;
- : node =
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;person&gt;&lt;name&gt;Bob&lt;/name&gt;&lt;email&gt;bob@example.com&lt;/email&gt;&lt;/person&gt;
</code></pre>

</div>



<p>Looks good! Let's examine the functions from the <code>pure-html</code> package used here to achieve this.</p>

<h2>
  
  
  <code>std_tag</code>
</h2>

<p>This function lets us define a custom tag: <code>let person = std_tag "person"</code>. Note that it's trivial to add a namespace: <code>let person = std_tag "my:person"</code>.</p>

<h2>
  
  
  <code>string_attr</code>
</h2>

<p>This allows us to define a custom attribute which takes a <em>string</em> payload: <code>let name = string_attr "name"</code>. Again, easy to add a namespace: <code>let name = string_attr "my:name"</code>.</p>

<p>There are other attribute definition functions which allow <code>int</code> payloads and so on. See the package documentation for details.</p>

<h2>
  
  
  <code>pp_xml</code>
</h2>

<p>This allows us to define a <a href="https://dev.to/yawaramin/how-to-print-anything-in-ocaml-1hkl">printer</a> which renders XML correctly according to its syntactic rules:<br>
</p>

<div class="highlight js-code-highlight">
<pre class="highlight ocaml"><code><span class="k">let</span> <span class="n">pp</span> <span class="o">=</span> <span class="n">pp_xml</span> <span class="o">~</span><span class="n">header</span><span class="o">:</span><span class="bp">true</span>
</code></pre>

</div>



<p>The optional <code>header</code> argument lets us specify whether we want to always print the XML header or not. In many serialization cases, we do.</p>

<p>There's also a similar function which, instead of defining a <em>printer,</em> just <em>converts</em> the constructed node into a string directly: <code>to_xml</code>.</p>

<h2>
  
  
  Conclusion
</h2>

<p>With these basic functions, it's possible to <em>precisely</em> control how the serialized XML looks. Note that <code>dream-html</code> and <code>pure-html</code> support only <em>serialization</em> of data into XML format, and not <em>deserialization</em> ie <em>parsing</em> XML. For that, there are <a href="https://ocaml.org/cookbook/xml-parse/ezxmlm" rel="noopener noreferrer">other packages</a>!</p>


