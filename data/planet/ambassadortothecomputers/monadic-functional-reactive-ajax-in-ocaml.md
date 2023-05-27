---
title: Monadic functional reactive AJAX in OCaml
description: 'Yesterday I released three related projects which I''ve been working
  on for a long time:    ocamljs , a Javascript backend for ocamlc, along ...'
url: http://ambassadortothecomputers.blogspot.com/2009/04/functional-reactive-ajax-in-ocaml.html
date: 2009-04-23T17:28:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

Yesterday I released three related projects which I've been working on for a long time:
<ul>
  <li><a href="http://code.google.com/p/ocamljs"><b>ocamljs</b></a>, a Javascript backend for ocamlc, along with some libraries for web programming</li>
  <li><a href="http://code.google.com/p/orpc2"><b>orpc</b></a>, a tool for generating RPC stubs from OCaml signatures, either ONC RPC for use with Ocamlnet's RPC implementation, or RPC over HTTP for use with ocamljs</li>
  <li><a href="http://code.google.com/p/froc"><b>froc</b></a>, a library for functional reactive programming that works with ocamljs</li>
</ul>
The idea of all this is to build a platform for client-side web programming like <a href="http://code.google.com/webtoolkit/">Google Web Toolkit</a> (but better, of course :). There is still a lot of work to get there, but already we use ocamljs and orpc for production work at <a href="http://skydeck.com/">Skydeck</a>. In my next few posts I'll work through some examples using ocamljs, orpc, and froc:
<ul>
  <li><a href="http://ambassadortothecomputers.blogspot.com/2009/04/sudoku-in-ocamljs-part-1-dom.html">part 1: DOM programming</a></li>
  <li><a href="http://ambassadortothecomputers.blogspot.com/2009/05/sudoku-in-ocamljs-part-2-rpc-over-http.html">part 2: RPC over HTTP</a></li>
  <li><a href="http://ambassadortothecomputers.blogspot.com/2009/05/sudoku-in-ocamljs-part-3-functional.html">part 3: functional reactive programming</a></li>
</ul>
