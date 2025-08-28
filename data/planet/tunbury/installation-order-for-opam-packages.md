---
title: Installation order for opam packages
description: Previously, I discussed the installation order for a simple directed
  acyclic graph without any cycles. However, opam packages include post dependencies.
  Rather than package A depending upon B where B would be installed first, post dependencies
  require X to be installed after Y. The post dependencies only occur in a small number
  of core OCaml packages. They are quite often empty and exist to direct the solver.
  Up until now, I had been using a base layer with an opam switch containing the base
  compiler and, therefore, did not need to deal with any post dependencies.
url: https://www.tunbury.org/2025/03/31/opam-post-deps/
date: 2025-03-31T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Previously, I discussed the installation order for a simple directed acyclic graph without any cycles. However, <code class="language-plaintext highlighter-rouge">opam</code> packages include <em>post</em> dependencies. Rather than package A depending upon B where B would be installed first, <em>post</em> dependencies require X to be installed after Y. The <em>post</em> dependencies only occur in a small number of core OCaml packages. They are quite often empty and exist to direct the solver. Up until now, I had been using a base layer with an opam switch containing the base compiler and, therefore, did not need to deal with any <em>post</em> dependencies.</p>

<p>Here is the graph of <a href="https://www.tunbury.org/images/0install.2.18-with-post-with-colour.pdf">0install</a> with <em>post</em> dependencies coloured in red.</p>

<p>Removing the <em>post</em> dependencies gives an unsatisfying graph with orphaned dependencies. <a href="https://www.tunbury.org/images/0install.2.18-without-post.pdf">0install without post</a>. Note <code class="language-plaintext highlighter-rouge">base-nnp.base</code> and <code class="language-plaintext highlighter-rouge">base-effects.base</code>. However, this graph can be used to produce a linear installation order. The orphaned packages can be removed with a recursive search.</p>

<p>When opam wants to decide the installation order, it uses OCamlgraph’s topological sort capability.</p>

<blockquote>
  <p>This functor provides functions which allow iterating over a graph in topological order. Cycles in graphs are allowed. Specification is the following: If vertex [x] is visited before vertex [y] then either there is a path from [x] to [y], or there is no path from [y] to [x].  In the particular case of a DAG, this simplifies to: if there is an edge from [x] to [y], then [x] is visited before [y].</p>
</blockquote>

<p>The description of <code class="language-plaintext highlighter-rouge">fold</code> is particularly interesting as the order for cycles is unspecified.</p>

<blockquote>
  <p>[fold action g seed] allows iterating over the graph [g] in topological order. [action node accu] is called repeatedly, where [node] is the node being visited, and [accu] is the result of the [action]’s previous invocation, if any, and [seed] otherwise.  If [g] contains cycles, the order is unspecified inside the cycles and every node in the cycles will be presented exactly once</p>
</blockquote>

<p>In my testing, the installation order matches the order used by opam within the variation allowed above.</p>

<p>Layers can be built up using the intersection of packages installed so far and the required dependencies.</p>
