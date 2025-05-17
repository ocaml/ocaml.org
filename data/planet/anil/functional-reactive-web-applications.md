---
title: Functional Reactive Web Applications
description:
url: https://anil.recoil.org/ideas/frp-web-ocaml
date: 2010-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Functional Reactive Web Applications</h1>
<p>This is an idea proposed in 2010 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Henry Hughes</a>.</p>
<p>There are a variety of programming languages which can be used to create
desktop applications, and each provides different tradeoffs. This could be
anything from the runtime guarantees the programming language provides to rapid
development and prototyping. It does not make much difference to the user which
of these languages was used, as all they want to do is run their favourite
application reliably.</p>
<p>When writing an application for the web, however, the programmer
is forced to use a specific set of APIs that come under the umbrella
term AJAX (Asynchronous JavaScript and XML). AJAX involves writing client-side
code in JavaScript and performing asynchronous requests to a server. This
provides a more interactive environment than the classical web application
model. The classical model uses the server to create the next web page on the
fly and then reloads the current page with the new one. This is often less
desirable because loading a new page causes a break in the user’s work flow.</p>
<p>While JavaScript is a full-featured language there are other programming
languages which provide features for more robust coding. This project explores
how AJAX applications might be written using a paradigm known as
<em>functional reactive programming</em>, and implement it in the OCaml language
and compile it to JavaScript via the <code>ocamljs</code> transpiler. The project uses
the <a href="https://github.com/jaked/froc">froc</a> FRP library by Jake Donham.</p>
<h2>Related Reading</h2>
<ul>
<li><a href="https://github.com/jaked/froc">FROC</a></li>
<li><a href="http://ambassadortothecomputers.blogspot.com/search/label/froc">Discussion about FROC and reactive programming</a>, Jake Donham</li>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The dissertation PDF isn't available publically but
should be in the Cambridge Computer Lab archives somewhere.
The source code is also archived but not publically available.</p>

