---
title: '[ANN] ocaml-vclock - 0.0.0'
description: I ported some Erlang vector clock code to Ocaml for fun and learning.  It's
  not well tested and it hasn't any performance optimizations.  I...
url: http://functional-orbitz.blogspot.com/2013/02/ann-ocaml-vclock-000.html
date: 2013-02-07T21:52:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
I ported some Erlang vector clock code to Ocaml for fun and learning.  It's not well tested and it hasn't any performance optimizations.  I'm not ready yet but I have some projects in mind to use it so it will likely get fleshed out more.
</p>

<p>
Vector clocks are a system for determining the partial ordering of events in a distributed environment.  You can determine if one value is the ancestor of another, equal, or was concurrently updated.  It is one mechanism that distributed databases, such as Riak, use to automatically resolve some conflicts in data while maintaining availability.
</p>

<p>
The vector clock implementation allows for user defined site id type.  It also allows metadata to be encoded in the site id, which is useful if you want your vector clock to be prunable by encoding timestamps in it.
</p>

<p>
The repo can be found <a href="https://github.com/orbitz/ocaml-vclock/tree/0.0.0">here</a>.  If you'd like to learn more about vector clocks read the wikipedia page <a href="http://en.wikipedia.org/wiki/Vector_clock">here</a>.  The Riak website also has some content on vector clocks <a href="http://docs.basho.com/riak/latest/references/appendices/concepts/Vector-Clocks/">here</a>.
</p>
