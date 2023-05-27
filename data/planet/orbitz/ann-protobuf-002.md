---
title: '[ANN] Protobuf 0.0.2'
description: Protobuf is an Ocaml library for communicating with Google's protobuf
  format.  It provides a method for writing parsers and builders.  Ther...
url: http://functional-orbitz.blogspot.com/2013/03/ann-protobuf-002.html
date: 2013-03-17T14:21:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
Protobuf is an Ocaml library for communicating with Google's protobuf format.  It provides a method for writing parsers and builders.  There is no protoc support, yet and writing it is not a top goal right now.  Protobuf is meant to be fairly lightweight and straight forward to use.  The only other Protobuf support for Ocaml I am aware of is through <a href="http://piqi.org/">piqi</a>, however that was too heavy for my needs.
</p>

<p>
Protobuf is meant to be very low level, mostly dealing with representation of values and not semantics.  For example, the <code>fixed32</code> and <code>sfixed32</code> values are both parsed as <code>Int32.t</code>'s.  Dealing with being signed or not is left up to the user.
</p>

<p>
The source code can be viewed <a href="https://github.com/orbitz/ocaml-protobuf/tree/0.0.2">here</a>.  Protobuf is in opam, to install it <code>opam install protobuf</code>.
</p>

<p>
The hope is that parsers and builders look reasonably close to the <code>.proto</code> files such that translation is straight forward, at least until protoc support is added.  This is an early release and, without a doubt, has bugs in it please submit pull requests and issues.
</p>

<p>
<a href="https://github.com/orbitz/ocaml-protobuf/tree/0.0.2/">https://github.com/orbitz/ocaml-protobuf/tree/0.0.2/</a>
</p>

<h1>Examples</h1>
<p>
The best collection of examples right now is the <a href="https://github.com/orbitz/ocaml-protobuf/blob/0.0.2/lib/protobuf/protobuf_test.ml">tests</a>.  An example from the file:
</p>

<p>
</p><pre><code><b><font color="#0000FF">let</font></b> simple <font color="#990000">=</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font><font color="#009900">int32</font> <font color="#993399">1</font> <font color="#990000">&gt;&gt;=</font> <b><font color="#000080">P</font></b><font color="#990000">.</font>return

<b><font color="#0000FF">let</font></b> complex <font color="#990000">=</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font><font color="#009900">int32</font> <font color="#993399">1</font>           <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> num <font color="#990000">-&gt;</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font><font color="#009900">string</font> <font color="#993399">2</font>          <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> s <font color="#990000">-&gt;</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font>embd_msg <font color="#993399">3</font> simple <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> emsg <font color="#990000">-&gt;</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font>return <font color="#990000">(</font>num<font color="#990000">,</font> s<font color="#990000">,</font> emsg<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> run_complex str <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#000080">P</font></b><font color="#990000">.</font><b><font color="#000080">State</font></b><font color="#990000">.</font>create <font color="#990000">(</font><b><font color="#000080">Bitstring</font></b><font color="#990000">.</font>bitstring_of_string str<font color="#990000">)</font>
  <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> s <font color="#990000">-&gt;</font>
  <b><font color="#000080">P</font></b><font color="#990000">.</font>run complex s
</code></pre>


<p>
The builder for this message looks like:
</p>

<p>
</p><pre><code><b><font color="#0000FF">let</font></b> build_simple i <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">let</font></b> b <font color="#990000">=</font> <b><font color="#000080">B</font></b><font color="#990000">.</font>create <font color="#990000">()</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#000080">B</font></b><font color="#990000">.</font><font color="#009900">int32</font> b <font color="#993399">1</font> i <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  <font color="#009900">Ok</font> <font color="#990000">(</font><b><font color="#000080">B</font></b><font color="#990000">.</font>to_string b<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> build_complex <font color="#990000">(</font>i1<font color="#990000">,</font> s<font color="#990000">,</font> i2<font color="#990000">)</font> <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">let</font></b> b <font color="#990000">=</font> <b><font color="#000080">B</font></b><font color="#990000">.</font>create <font color="#990000">()</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#000080">B</font></b><font color="#990000">.</font><font color="#009900">int32</font> b <font color="#993399">1</font> i1                 <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  <b><font color="#000080">B</font></b><font color="#990000">.</font><font color="#009900">string</font> b <font color="#993399">2</font> s                 <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  <b><font color="#000080">B</font></b><font color="#990000">.</font>embd_msg b <font color="#993399">3</font> i2 build_simple <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  <font color="#009900">Ok</font> <font color="#990000">(</font><b><font color="#000080">B</font></b><font color="#990000">.</font>to_string b<font color="#990000">)</font>
</code></pre>

