---
title: 'Experimenting in API Design: Riakc'
description: 'Disclaimer: Riakc''s API is in flux so not all of the code here is guaranteed
  to work by the time you read this post.  However the general ...'
url: http://functional-orbitz.blogspot.com/2013/07/experimenting-in-api-design-riakc.html
date: 2013-07-09T18:37:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
<i>
Disclaimer: Riakc's API is in flux so not all of the code here is guaranteed to work by the time you read this post.  However the general principles should hold.
</i>
</p>

<p>
While not perfect, Riakc attempts to provide an API that is very hard to use incorrectly, and hopefully easy to use correctly.  The idea being that using Riakc incorrectly will result in a compile-time error.  Riakc derives its strength from being written in Ocaml, a language with a very expressive type system.  Here are some examples of where I think Riakc is successful.
</p>

<h1>Siblings</h1>
<p>
In Riak, when you perform a <code>GET</code> you can get back multiple values associated with the a single key.  This is known as siblings.  However, a <code>PUT</code> can only associate one value with a key.  However, it is convenient to use the same object type for both <code>GET</code> and <code>PUT</code>.  In the case of Riakc, that is a <code>Riakc.Robj.t</code>.  But, what to do if you create a <code>Robj.t</code> with siblings and try to <code>PUT</code>?  In the Ptyhon client you will get a runtime error.  Riakc solves this by using phantom types.  A <code>Robj.t</code> isn't actually just that, it's a <code>'a Robj.t</code>.  The API requires that <code>'a</code> to be something specific at different parts of the code.  Here is the simplified type for <code>GET</code>:
</p>

<pre><code><b><font color="#0000FF">val</font></b> get <font color="#990000">:</font>
  t <font color="#990000">-&gt;</font>
  b<font color="#990000">:</font><font color="#009900">string</font> <font color="#990000">-&gt;</font>
  <font color="#009900">string</font> <font color="#990000">-&gt;</font>
  <font color="#990000">([</font> `<font color="#009900">Maybe_siblings</font> <font color="#990000">]</font> <b><font color="#000080">Robj</font></b><font color="#990000">.</font>t<font color="#990000">,</font> error<font color="#990000">)</font> <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><b><font color="#000080">Result</font></b><font color="#990000">.</font>t
</code></pre>

<p>
And here is the simplified type for <code>PUT</code>:
</p>

<pre><code><b><font color="#0000FF">val</font></b> put <font color="#990000">:</font>
  t <font color="#990000">-&gt;</font>
  b<font color="#990000">:</font><font color="#009900">string</font> <font color="#990000">-&gt;</font>
  <font color="#990000">?</font>k<font color="#990000">:</font><font color="#009900">string</font> <font color="#990000">-&gt;</font>
  <font color="#990000">[</font> `<font color="#009900">No_siblings</font> <font color="#990000">]</font> <b><font color="#000080">Robj</font></b><font color="#990000">.</font>t <font color="#990000">-&gt;</font>
  <font color="#990000">(([</font> `<font color="#009900">Maybe_siblings</font> <font color="#990000">]</font> <b><font color="#000080">Robj</font></b><font color="#990000">.</font>t <font color="#990000">*</font> key<font color="#990000">),</font> error<font color="#990000">)</font> <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><b><font color="#000080">Result</font></b><font color="#990000">.</font>t
</code></pre>

<p>
The important part of the API is that <code>GET</code> returns a <code>[ `Maybe_siblings ] Riak.t</code> and <code>PUT</code> takes a <code>[ `No_siblings ] Riak.t</code>.  How does one convert something that might have siblings to something that definitely doesn't?  With <code>Riakc.Robj.set_content</code>
</p>

<pre><code><b><font color="#0000FF">val</font></b> set_content  <font color="#990000">:</font> <b><font color="#000080">Content</font></b><font color="#990000">.</font>t <font color="#990000">-&gt;</font> 'a t <font color="#990000">-&gt;</font> <font color="#990000">[</font> `<font color="#009900">No_siblings</font> <font color="#990000">]</font> t
</code></pre>

<p>
<code>set_content</code> takes any kind of <code>Robj.t</code>, and a single <code>Content.t</code> and produces a <code>[ `No_siblings ] Riak.t</code>, because if you set contents to one value obviously you cannot have siblings.  Now the type system can ensure that any call to <code>PUT</code> must have a <code>set_content</code> prior to it.
</p>

<h1>Setting 2i</h1>
<p>
If you use the LevelDB backend you can use secondary indices, known as 2i, which allow you to find a set of keys based on some mapping.  When you create an object you specify the mappings to which it belongs.  Two types are supported in Riak: bin and int.  And two query types are supported: equal and range.  For example, if you encoded the time as an int you could use a range query to find all those keys that occurred within a range of times.
</p>

<p>
Riak encodes the type of the index in the name.  As an example, if you want to allow people to search by a field called &quot;foo&quot; which is a binary secondary index, you would name that index &quot;foo_bin&quot;.  In the Python Riak client, one sets an index with something like the following code:
</p>

<pre><code>obj<font color="#990000">.</font><b><font color="#000000">add_index</font></b><font color="#990000">(</font><font color="#FF0000">'field1_bin'</font><font color="#990000">,</font> <font color="#FF0000">'val1'</font><font color="#990000">)</font>
obj<font color="#990000">.</font><b><font color="#000000">add_index</font></b><font color="#990000">(</font><font color="#FF0000">'field2_int'</font><font color="#990000">,</font> <font color="#993399">100000</font><font color="#990000">)</font>
</code></pre>

<p>
In Riakc, the naming convention is hidden from the user.  Instead, the the name the field will become is encoded in the value.  The Python code looks like the following in Riakc:
</p>

<pre><code><b><font color="#0000FF">let</font></b> <b><font color="#0000FF">module</font></b> <font color="#009900">R</font> <font color="#990000">=</font> <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><font color="#009900">Robj</font> <b><font color="#0000FF">in</font></b>
<b><font color="#0000FF">let</font></b> index1 <font color="#990000">=</font>
  <b><font color="#000080">R</font></b><font color="#990000">.</font>index_create
    <font color="#990000">~</font>k<font color="#990000">:</font><font color="#FF0000">&quot;field1&quot;</font>
    <font color="#990000">~</font>v<font color="#990000">:(</font><b><font color="#000080">R</font></b><font color="#990000">.</font><b><font color="#000080">Index</font></b><font color="#990000">.</font><font color="#009900">String</font> <font color="#FF0000">&quot;val1&quot;</font><font color="#990000">)</font>
<b><font color="#0000FF">in</font></b>
<b><font color="#0000FF">let</font></b> index2 <font color="#990000">=</font>
  <b><font color="#000080">R</font></b><font color="#990000">.</font>index_create
    <font color="#990000">~</font>k<font color="#990000">:</font><font color="#FF0000">&quot;field2&quot;</font>
    <font color="#990000">~</font>v<font color="#990000">:(</font><b><font color="#000080">R</font></b><font color="#990000">.</font><b><font color="#000080">Index</font></b><font color="#990000">.</font><font color="#009900">Integer</font> <font color="#993399">10000</font><font color="#990000">)</font>
<b><font color="#0000FF">in</font></b>
<b><font color="#000080">R</font></b><font color="#990000">.</font>set_content
  <font color="#990000">(</font><b><font color="#000080">R</font></b><font color="#990000">.</font><b><font color="#000080">Content</font></b><font color="#990000">.</font>set_indices <font color="#990000">[</font>index1<font color="#990000">;</font> index2<font color="#990000">]</font> content<font color="#990000">)</font>
  robj
</code></pre>

<p>
When the <code>Robj.t</code> is written to the DB, &quot;field1&quot; and &quot;field2&quot; will be transformed into their appropriate names.
</p>

<p>
Reading from Riak results in the same translation happening.  If Riakc cannot determine the type of the value from the field name, for example if Riak gets a new index type, the field name maintains its precise name it got from Riak and the value is a <code>Riakc.Robj.Index.Unknown string</code>.
</p>

<p>
In this way, we are guaranteed at compile-time that the name of the field will always match its type.
</p>

<h1>2i Searching</h1>
<p>
With objects containing 2i entries, it is possible to search by values in those fields.  Riak allows for searching fields by their exact value or ranges of values.  While it's unclear from the Riak docs, Riakc enforces the two values in a range query are of the same type.  Also, like in setting 2i values, the field name is generated from the type of the value.  It is more verbose than the Python client but it enforces constraints. 
</p>

<p>
Here is a Python 2i search followed by the equivalent search in Riakc.
</p>

<pre><code>results <font color="#990000">=</font> client<font color="#990000">.</font><b><font color="#000000">index</font></b><font color="#990000">(</font><font color="#FF0000">'mybucket'</font><font color="#990000">,</font> <font color="#FF0000">'field1_bin'</font><font color="#990000">,</font> <font color="#FF0000">'val1'</font><font color="#990000">,</font> <font color="#FF0000">'val5'</font><font color="#990000">).</font><b><font color="#000000">run</font></b><font color="#990000">()</font>
</code></pre>

<pre><code><b><font color="#000080">Riakc</font></b><font color="#990000">.</font><b><font color="#000080">Conn</font></b><font color="#990000">.</font>index_search
  conn
  <font color="#990000">~</font>b<font color="#990000">:</font><font color="#FF0000">&quot;mybucket&quot;</font>
  <font color="#990000">~</font>index<font color="#990000">:</font><font color="#FF0000">&quot;field1&quot;</font>
  <font color="#990000">(</font>range_string
     <font color="#990000">~</font>min<font color="#990000">:</font><font color="#FF0000">&quot;val1&quot;</font>
     <font color="#990000">~</font>max<font color="#990000">:</font><font color="#FF0000">&quot;val2&quot;</font>
     <font color="#990000">~</font>return_terms<font color="#990000">:</font><b><font color="#0000FF">false</font></b><font color="#990000">)</font>
</code></pre>

<h1>Conclusion</h1>
<p>
It's a bit unfair comparing an Ocaml API to a Python one, but hopefully this has demonstrated that with a reasonable type system one can express safe and powerful APIs without being inconvenient.
</p>

