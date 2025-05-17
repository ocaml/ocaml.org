---
title: Bidirectional Hazel to OCaml programming
description:
url: https://anil.recoil.org/ideas/hazel-to-ocaml-to-hazel
date: 2025-04-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Bidirectional Hazel to OCaml programming</h1>
<p>This is an idea proposed in 2025 as a good starter project, and is <span class="idea-discussion">under discussion</span> with a student but not yet confirmed. It may be co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a> and <a href="https://web.eecs.umich.edu/~comar/" class="contact">Cyrus Omar</a>.</p>
<p><a href="https://hazel.org">Hazel</a> is a pure subset of OCaml with a live functional
programming environment that is able to typecheck, manipulate, and even run
incomplete programs. As a pure language with no effects, Hazel is a great
choice for domains such as configuration languages where some control flow
is needed, but not the full power of a general purpose programming language.
On the other hand, Hazel only currently has an interpreter and so is fairly slow
to evaluate compared to a full programming language such as OCaml.</p>
<p>This summer project aims to do two things:</p>
<ul>
<li>Build a simple Hazel -&gt; OCaml transpiler that will directly evaluate a Hazel
program with no typed holes as OCaml. If there is a typed hole, then an
exception can be raised. With some creative thinking, we may be able to raise
an OCaml effect instead and do something useful to continue the execution of the program.</li>
<li>Build on <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>'s <a href="https://github.com/patricoferris/hazel_of_ocaml">OCaml to Hazel transpiler</a> which goes
from a subset of OCaml code to Hazel.</li>
</ul>
<p>Once we can go back and forth, we can explore some interesting domains where this is useful. For example,
can we build a configuration language frontend in Hazel, and then directly convert that into OCaml code
for embedding into an application? Could we build a simple blog/wiki frontend where layout is expressed
in livelit Hazel, and then when ready is converted to OCaml for publishing on the web?</p>
<p>We don't know if any of this will work, but we'd like to explore this "context
switching" between languages of different expressivity in order to explore the
divide between interactive, exploratory programming, and high performance and
more static published code.</p>

