---
title: orpc 0.3
description: I am happy to announce version 0.3 of orpc , a tool for generating RPC
  bindings from OCaml signatures. Orpc can generate ONC RPC stubs for u...
url: http://ambassadortothecomputers.blogspot.com/2010/04/orpc-03.html
date: 2010-04-03T02:18:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>I am happy to announce version 0.3 of <code>orpc</code>, a tool for generating RPC bindings from OCaml signatures. Orpc can generate ONC RPC stubs for use with <a href="http://projects.camlcity.org/projects/ocamlnet.html">Ocamlnet</a> (in place of ocamlrpcgen), and it can also generate RPC over HTTP stubs for use with <a href="http://github.com/jaked/ocamljs">ocamljs</a>. You can use most OCaml types in interfaces, as well as labelled and optional arguments.</p> 
 
<p>Changes since version 0.2 include</p> 
 
<ul> 
<li>a way to use types defined outside the interface file, so you can use a type in more than one interface</li> 
 
<li>support for polymorphic variants</li> 
 
<li>a way to specify &ldquo;abstract&rdquo; interfaces that can be instantiated for synchronous, asynchronous, and Lwt clients and servers</li> 
 
<li>bug fixes</li> 
</ul> 
 
<p>Development of <code>orpc</code> has moved from Google Code to Github; see</p> 
 
<ul> 
<li><a href="http://github.com/jaked/orpc">project page</a></li> 
 
<li><a href="http://jaked.github.com/orpc">documentation</a></li> 
 
<li><a href="http://github.com/jaked/orpc/downloads">downloads</a></li> 
</ul> 
 
<p>Let me know what you think.</p>
