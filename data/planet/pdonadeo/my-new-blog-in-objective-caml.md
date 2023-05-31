---
title: "My new blog\u2026 in Objective Caml"
description:
url: https://www.donadeo.net/post/2010/my-new-blog-in-objective-caml
date: 2010-08-03T08:26:00-00:00
preview_image:
featured:
authors:
- pdonadeo
---

<div><p class="noindent">More than a year ago I decided to dismiss my Wordpress blog, and to write a new one from scratch in OCaml. Unfortunately my spare time for programming projects is getting less and less, so this simple work took a lot of time to reach an usable state.</p>

<p>I put online a preliminary release a month ago and immediately several bugs and little problems have arose, so I had to pass through the usual karma of recurring corrections. Now it seems stable.</p>

<h4>Software design (strong words, actually!)</h4>

<p class="noindent">To write this blog I decided to use <a href="https://projects.camlcity.org/projects/ocamlnet.html">Ocamlnet</a> to produce a FastCGI server, providing dynamic contents through Apache, leaving the HTTP server alone to serve static resources, like Javascript, CSS and images.</p>

<p>Ocamlnet is an excellent network framework, but it offers a low level interface, if compared with <a href="https://ocsigen.org/">Ocsigen</a>, which is web specific. Ocsigen (<a href="https://ocsigen.org/eliom/manual/1.3.0/">Eliom</a>, actually) is a complete, modern and mature web framework, and I was afraid I couldn't use it, but AFAIK it lacks the possibility to create a FastCGI executable. I need this kind of setup because the blog runs on a production server of mine, where Apache is already installed and many virtual hosts are configured to run several sites and web apps, written in Django (Python) or even PHP.
</p>

<p>To write the blog <del>I stole many ideas</del> I was inspired by many ideas taken here and there. It's fair to list them, and to thank the authors:</p>

<ul>
  <li>from Eliom I took the idea of a way to create the parameters of the web page in a type safe way, using <a href="https://ocsigen.org/docu/1.3.0/Eliom_parameters.html">some combinators</a> that describe the expected type of the parameter and rebuild it from the CGI string from the browser. The implementation present in Eliom is of course outstanding, while my piece of code just solves a small subset of the problem of parameters reconstruction;</li>
  <li>the blog of <a href="https://eigenclass.org/R2/">Mauricio Fern&aacute;ndez</a> is written with Ocsigen (<a href="https://github.com/mfp/ocsiblog">source here</a>) and contains a simple <a href="https://eigenclass.org/R2/writings/fast-extensible-simplified-markdown-in-ocaml">markdown-like language processor</a> used to format comments. I wrote something like that, but I'm learning to write parsers combinators so my implementation only processes a subset of the language recognized by Mauricio's parser;</li>
  <li><a href="https://ambassadortothecomputers.blogspot.com/">Jake Donham</a> wrote lwt-equeue as part of the <a href="https://github.com/jaked/orpc">orpc</a> project. It's a module providing the same interface of <a href="https://ocsigen.org/lwt/">Lwt</a>, but runs on <a href="https://projects.camlcity.org/projects/dl/ocamlnet-2.2.9/doc/html-main/Equeue.html">equeue</a>, the low level event loop engine of Ocamlnet, and I used it to write a simple SMTP client in a monadic way without having to drop Ocamlnet and FastCGI;</li>
  <li><a href="https://batteries.forge.ocamlcore.org/">Batteries</a> is of course used almost everywhere;</li>
  <li>as a template engine to render HTML I used <a href="https://forge.ocamlcore.org/projects/camltemplate/">CamlTemplate</a> by Benjamin Geer (maintained by Dmitry Grebeniuk).</li>
</ul>

<p>The resulting software is far from being well structured and designed, but I wrote yet another blog exactly to have the opportunity to test many libraries and programming paradigms in OCaml and, with respect to this goal, the result is a success :-)</p>

<h4>Blog features</h4>
<p class="noindent">While the code is a mess, the blog itself has many useful features: a very simple administration to edit posts, RSS feeds, comments, <a href="https://akismet.com/">antispam</a>, and a completely useless URL shortening service available at <a href="https://www.donadeo.net/u">https://www.donadeo.net/u</a>.</p>


<h4>Performance</h4>
<p class="noindent">What about the performance of the whole object? I don't know how to realistically test the blog, because using the classical <code>ab</code> is rather pointless, since it is generally used with static resources that, in my case, are served by Apache. If someone has some good ideas about 1) how to make a stress test and 2) have some good reference in term of expected hit per second, please don't hesitate and contact me, of course to blame me about how the blog is slow.</p>


<h4>Conclusions</h4>
<p class="noindent">The blog is up and running and I don't see any particular bug. In the next months I'll probably add some features, like the possibility to follow comments via email, or a decent XML site map.</p></div>
