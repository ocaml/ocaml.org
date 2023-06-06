---
title: ocamljs 0.3
description: I am happy to announce version 0.3 of ocamljs. Ocamljs is a system for
  compiling OCaml to Javascript. It includes a Javascript back-end for ...
url: http://ambassadortothecomputers.blogspot.com/2010/08/ocamljs-03.html
date: 2010-08-26T21:45:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>I am happy to announce version 0.3 of ocamljs. Ocamljs is a system for compiling OCaml to Javascript. It includes a Javascript back-end for the OCaml compiler, as well as several support libraries, such as bindings to the browser DOM. Ocamljs also works with <a href="http://jaked.github.com/orpc">orpc</a> for RPC over HTTP, and <a href="http://jaked.github.com/froc">froc</a> for functional reactive browser programming.</p> 
 
<p>Changes since version 0.2 include:</p> 
 
<ul> 
<li>support for OCaml 3.11.x and 3.12.0</li> 
 
<li>jQuery binding (contributed by Dave Benjamin)</li> 
 
<li>full support for OCaml objects (interoperable with Javascript objects)</li> 
 
<li>Lwt 2.x support</li> 
 
<li>ocamllex and ocamlyacc support</li> 
 
<li>better interoperability with Javascript</li> 
 
<li>many small fixes and improvements</li> 
</ul> 
 
<p>Development of ocamljs has moved from Google Code to Github; see</p> 
 
<ul> 
<li>project page: <a href="http://github.com/jaked/ocamljs">http://github.com/jaked/ocamljs</a></li> 
 
<li>documentation: <a href="http://jaked.github.com/ocamljs">http://jaked.github.com/ocamljs</a></li> 
 
<li>downloads: <a href="http://github.com/jaked/ocamljs/downloads">http://github.com/jaked/ocamljs/downloads</a></li> 
</ul> 
<b>Comparison to js_of_ocaml</b> 
<p>Since I last did an <code>ocamljs</code> release, a new OCaml-to-Javascript system has arrived, <a href="http://ocsigen.org/js_of_ocaml/"><code>js_of_ocaml</code></a>. I want to say a little about how the two systems compare:</p> 
 
<p><code>Ocamljs</code> is a back-end to the existing OCaml compiler; it translates the &ldquo;lambda&rdquo; intermediate language to Javascript. (This is also where the bytecode and native code back-ends connect to the common front-end.) <code>Js_of_ocaml</code> post-processes ordinary OCaml bytecode (compiled and linked with the ordinary OCaml bytecode compiler) into Javascript. With <code>ocamljs</code> you need a special installation of the compiler (and special support for <code>ocamlbuild</code> and <code>ocamlfind</code>), you need to recompile libraries, and you need the OCaml source to build it. With <code>js_of_ocaml</code> you don&rsquo;t need any of this.</p> 
 
<p>Since <code>ocamljs</code> recompiles libraries, it&rsquo;s possible to special-case code for the Javascript build to take advantage of Javascript facilities. For example, <code>ocamljs</code> implements the <code>Buffer</code> module on top of Javascript arrays instead of strings, for better performance. Similarly, it implements <code>CamlinternalOO</code> to use Javascript method dispatch directly instead of layering OCaml method dispatch on top. <code>Js_of_ocaml</code> can&rsquo;t do this (or at least it would be necessary to recognize the compiled bytecode and replace it with the special case).</p> 
 
<p>Because <code>js_of_ocaml</code> works from bytecode, it can&rsquo;t always know the type of values (at the bytecode level, <code>int</code>s, <code>bool</code>s, and <code>char</code>s all have the same representation, for example). This makes interoperating with native Javascript more difficult: you usually need conversion functions between the OCaml and Javascript representation of values when you call a Javascript function from OCaml. <code>Ocamljs</code> has more information to work with, and can represent OCaml bools as Javascript bools, for example, so you can usually call a Javascript function from OCaml without conversions.</p> 
 
<p><code>Ocamljs</code> has a mixed representation of strings: literal strings and the result of <code>^</code>, <code>Buffer.contents</code>, and <code>Printf.sprintf</code> are all immutable Javascript strings; strings created with <code>String.create</code> are mutable strings implemented by Javascript arrays (with a <code>toString</code> method which returns the represented string). This is good for interoperability&mdash;you can usually pass a string directly to Javascript&mdash;but it doesn&rsquo;t match regular OCaml&rsquo;s semantics, and it can cause runtime failures (e.g. if you try to mutate an immutable string). <code>Js_of_ocaml</code> implements only mutable strings, so you need conversions when calling Javascript, but the semantics match regular OCaml.</p> 
 
<p>With <code>ocamljs</code>, Javascript objects can be called from OCaml using the ordinary OCaml method-call syntax, and objects written in OCaml can be called using the ordinary Javascript syntax. With <code>js_of_ocaml</code>, a special syntax is needed to call Javascript objects, and OCaml objects can&rsquo;t easily be called from Javascript. However, there is an advantage to having a special call syntax: with <code>ocamljs</code> it is not possible to partially apply calls to native Javascript methods, but this is not caught by the compiler, so there can be a runtime failure.</p> 
 
<p><code>Ocamljs</code> supports inline Javascript, while <code>js_of_ocaml</code> does not. I think it might be possible for <code>js_of_ocaml</code> to do so using the same approach that <code>ocamljs</code> takes: use Camlp4 quotations to embed a syntax tree, then convert the syntax tree from its OCaml representation (as lambda code or bytecode) into Javascript. However, you would still need conversion functions between OCaml and Javascript values.</p> 
 
<p>I haven&rsquo;t compared the performance of the two systems. It seems like there must be a speed penalty to translating from bytecode compared to translating from lambda code. On the other hand, while <code>ocamljs</code> is very naive in its translation, <code>js_of_ocaml</code> makes several optimization passes. With many programs it doesn&rsquo;t matter, since most of the time is spent in browser code. (For example, the <code>planet</code> example seems to run at the same speed in <a href="http://jaked.github.com/ocamljs/examples/dom/planet/"><code>ocamljs</code></a> and <a href="http://ocsigen.org/js_of_ocaml/planet/"><code>js_of_ocaml</code></a>.) It would be interesting to compare them on something computationally intensive like Andrej Bauer&rsquo;s <a href="http://random-art.org/">random-art.org</a>.</p> 
 
<p><code>Js_of_ocaml</code> is more complete and careful in its implementation of OCaml (e.g. it supports <code>int64</code>s), and it generates much more compact code than <code>ocamljs</code>. I hope to close the gap in these areas, possibly by borrowing some code and good ideas from <code>js_of_ocaml</code>.</p>
