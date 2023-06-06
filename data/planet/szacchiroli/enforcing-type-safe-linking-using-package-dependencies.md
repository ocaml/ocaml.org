---
title: Enforcing type-safe linking using package dependencies
description:
url: http://upsilon.cc/~zack/blog/posts/2009/11/Enforcing_type-safe_linking_using_package_dependencies/
date: 2009-11-28T13:00:16-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>Eclectic paper: dh-ocaml</h1>
<p>In my day job as a researcher, I mostly <a href="http://upsilon.cc/~zack/research/publications/">publish papers</a> along the lines
of my main research interests (theorem proving, web technologies,
formal methods applied to software engineering, ...). Some time
though, I just come up to some <strong>eclectic idea</strong>, not
strictly related to my job, that I feel like cooking up as a paper
to be reviewed by some scientific venue.</p>
<p>It happened some weeks ago with <a href="http://packages.debian.org/sid/dh-ocaml"><strong>dh-ocaml</strong></a>,
the package implementing the <strong>new dependency scheme for
OCaml-related packages</strong> in Debian. It took us (as in
<a href="http://wiki.debian.org/Teams/OCamlTaskForce">Debian OCaml
maintainers</a>) several years to get it right and satisfactory for
maintainers, users, release team, etc.</p>
<p>The problem which dh-ocaml addresses is that, differently than C
and other system-level languages, <strong>OCaml breaks ABI
compatibility very often</strong>, due to the need of ensuring type
safety across different libraries at link time. Other similar
strongly typed languages, such as Haskell, behave similarly. This
is at odds with the implicit assumption of forward-compatibility
(unless otherwise &quot;stated&quot;, e.g. with soname changes) that is
relied upon by versioned dependencies in distributions like
Debian.</p>
<p>This discussion, the analysis of possible solutions, and the
description of the solution we have actually implemented in
dh-ocaml (called <strong>ABI approximation</strong>) turned out to
be interesting for the French functional programming academic
community: the <a href="http://upsilon.cc/~zack/research/publications/jfla10-dh-ocaml.pdf"><strong>paper on
dh-ocaml</strong></a> has been accepted at forthcoming <a href="http://jfla.inria.fr/2010/">JFLA 2010</a>.</p>
<p>It is no rocket science <img src="http://upsilon.cc/~zack/smileys/smile.png" alt=":-)"/> , but people maintaining programs and libraries written in
languages with concerns similar to OCaml's (e.g. Haskell, hello
<a href="http://www.joachim-breitner.de/blog/">nomeata</a>) might
want to have a look.</p>


