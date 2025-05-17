---
title: Concurrent revisions for OCaml
description:
url: https://anil.recoil.org/ideas/concurrent-revisions
date: 2013-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Concurrent revisions for OCaml</h1>
<p>This is an idea proposed in 2013 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Dimitar Popov</a>.</p>
<p>The biggest challenge when using parallel programming is typically how to keep
track of the side effects of computations that are executed in parallel and
that involve shared mutable state.  Traditional methods for dealing with this
issue often limit concurrency, do not provide sufficient determinism and are
error prone. Ideally, we would like a concept where all conflicts between
parallel tasks are resolved deterministically with minimized effort from the
programmer.
This project aims to design and build a library for OCaml that implements the
concept of <a href="https://www.microsoft.com/en-us/research/project/concurrent-revisions/">concurrent
revisions</a>.</p>
<p>Concurrent revisions as initially proposed highlight these design choices:</p>
<ol>
<li>Declarative data sharing: the user declares what data is to be shared between parallel tasks by the use of isolation types</li>
<li>Automatic isolation: each task has its own private stable copy of the data that is taken at the time of the fork</li>
<li>Deterministic conflict resolution: the user specifies a merge function that is used to resolve write-write conflicts that might arise when joining parallel tasks. Given that this function is deterministic, the conflict resolution is also deterministic.</li>
</ol>
<p>In this framework the unit of concurrency are asynchronous tasks called
<em>revisions</em>. They provide the typical functionality for asynchronous tasks -
the user can create, fork and join them. This removes the complexity of
synchronization out of the tasks themselves and gathers it into a single place; the <code>merge</code> function.</p>
<p>A key outcome is to improve our understanding of the tradeoffs both between the
different paths that can be chosen during the implementation of this library
and the more traditional means of concurrent programming.  We will design an
evaluation of the differences between the API of the original concurrent
revisions limplementation written in C# and the more functional style of one
built in OCaml.</p>
<p>The project was successfully completed, with the major decision being whether
or not to switch to a monadic API vs a direct-style one with better lower-level
control.</p>
<h2>Related Reading</h2>
<ul>
<li><a href="https://www.microsoft.com/en-us/research/project/concurrent-revisions/">Concurrent Revisions at Microsoft Research</a></li>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The dissertation <a href="https://github.com/dpp23/ocaml_revisions/">PDF is available</a>
publically along with the <a href="https://github.com/dpp23/ocaml_revisions/">source code to the prototype
library</a> which implemented a logging
and chat server to demonstrate the use of concurrent revisions.</p>

