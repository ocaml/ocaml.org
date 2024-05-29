---
title: 'OCamlPro Highlights: April 2014'
description: Here is a short report on some of our activities in April 2014, and a
  short analysis of OCaml evolution since its first release. OPAM Improvements We're
  still working on release 1.2. It was decided to include quite a few new features
  in this release, which delayed it a little bit since we want to be...
url: https://ocamlpro.com/blog/2014_05_20_ocamlpro_highlights_april_2014
date: 2014-05-20T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Here is a short report on some of our activities in April 2014, and a short analysis of OCaml evolution since its first release.</p>
<h3>OPAM Improvements</h3>
<p>We're still working on release 1.2. It was decided to include quite a few new features in this release, which delayed it a little bit since we want to be sure to get it right. It's now getting stabilized, documented and tested. One of the biggest improvements concerns the development workflow and the use of pinned packages, which is a powerful and complex feature that could also get a bit confusing. We are grateful for the large amount of feedback from the community that helped in its design. The basic idea is to use OPAM metadata from within the source packages, because it's most useful while developping and helps get the packaging right. It was possible before, but a little bit awkward : you now only need to provide an <code>opam</code> file or directory at the root of your project, and when pinned to either a local path or a version-controlled repository, opam will pick it up and use it. It will then be synchronized on any subsequent <code>opam update</code>. You can even do this if there is no corresponding package in the repository, OPAM will create it and store it in its internal repository for you. And in case this metadata is getting in the way, or you just want a quick local fix, you can always do <code>opam pin edit &lt;package&gt;</code> to locally change the metadata used by opam.</p>
<p>During this month, we've also been improving performance by a large amount in several areas, because delays could become noticeable for people using it on eg. raspberry pis. There is an important clarification on the <a href="https://github.com/ocaml/opam/blob/master/doc/design/metadata-evolution">handling of optional dependencies</a>; and we worked hard on making the build of OPAM as painless as possible on every possible setting.</p>
<h3>OPAM Weather Service</h3>
<p>Last month, we presented an <a href="https://cudf-solvers.irill.org/">online service</a> for OPAM, to provide advanced CUDF solvers to every OPAM user. The service is provided by <a href="https://www.irill.org/">IRILL</a>, and based on the tools they implemented to manipulate CUDF files (some of them are also used directly in OPAM).</p>
<p>This month, we are happy to introduce a new service, that we helped them put online: the <a href="https://ows.irill.org/">OPAM Weather Service</a>, an instantiation for OPAM of a <a href="https://qa.debian.org/dose/debcheck.html">service</a> they also provide for Debian. It shows the evolution of the installability of all packages in the official OPAM repository, for <a href="https://ows.irill.org/table.html">three stable versions</a> of OCaml (3.12.1, 4.00.1 and 4.01.0). It should help maintainers track dependency problems with their packages, when old packages are removed or new conflicting dependencies are introduced.</p>
<h3>An Internship on OCaml Namespaces</h3>
<p>This month, we welcomed Pierrick Couderc for an internship in our lab. He is going to work on adding namespaces to OCaml. His goal is to design a kind of namespaces that extend the current module mechanism in a consistent but powerful way. One challenge of his job will be to make these namespaces also extend our <a href="https://ocamlpro.com/blog/2011_08_10_packing_and_functors">big functors</a> to provide functors at the namespace level.</p>
<p>Pierrick is not a complete newcomer in our team: last year, he already worked for us with David Maison (now working at TrustInSoft) on an online service to <a href="https://edit.ocamlpro.com/">edit and compile</a> OCaml code for students.</p>
<h3>The Evolution of OCaml Sources</h3>
<p>This month, there was also a lot of activity for the Core team, as we are closing to the feature freeze for OCaml 4.02. We took this opportunity to have a look at the evolution of OCaml sources since the first release of OCaml 1.00, in 1996.</p>
<p>Our first graph plots the size of uncompressed OCaml sources in bytes, from the first release to the current trunk:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_ocaml_bytes.png" alt="ocaml-bytes"/></p>
<p>The graph shows four interesting events:</p>
<ul>
<li>in 2002-2003, between 3.02 and 3.06, an increase of 4 MB
</li>
<li>in 2007, between 3.09.3 and 3.10.0, an increase of again 4 MB
</li>
<li>in 2013, between 4.00.1 and 4.01.0, an increase of 2 MB
</li>
<li>in 2014, between 4.01.0 and 4.02.0, a decrease of 6 MB
</li>
</ul>
<p>Our second graph plots the number of files per kind (OCaml sources, OCaml interfaces, C sources and C headers):</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_ocaml_files.png" alt="ocaml-file"/></p>
<p>We can now check the files that were added and removed at the four events that we noticed on the first graph:</p>
<ul>
<li>the first event corresponds to the addition of 174 files for <code>camlp4</code> in 3.04, and then 70 files for <code>ocamldoc</code> in 3.06. Also, <code>labltk</code> increased a lot, with many new examples;
</li>
<li>the second event corresponds to the addition of 225 files for <code>ocamlbuild</code> in 3.10.0, and the replacement of <code>camlp4</code> (renamed into <code>camlp5</code>) by a new implementation;
</li>
<li>the third event corresponds to ... a change in the size of <code>boot/myocamlbuild.boot</code>, the bytecode file used by <code>ocamlbuild</code> to bootstrap itself !
</li>
<li>finally, the incoming new event corresponds to the removal of <code>camlp4</code> and <code>labltk</code> from 4.02, i.e. about 300 files for each of them.
</li>
</ul>
<p>Our third graph shows the number of lines per kind of file, again:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_ocaml_lines.png" alt="ocaml-lines"/></p>
<p>This graph does not show us much more than what we have seen by number of files, but what might be interesting is to compute the ratio, i.e. the number of lines per file, for each kind of file:</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_ocaml_ratio.png" alt="ocaml-ratio"/></p>
<p>There is a general trend to increase the number of lines per file, from about 200 lines in an OCaml source file in 1996 to about 330 lines in 2014. This ratio increased considerably for release 3.04, because <code>camlp4</code> used to generate a huge bootstrap file of its own pre-preprocessed OCaml sources. More interestingly, the ratio didn't decrease in 2014, when <code>camlp4</code> was removed from the distribution ! Interface files also grew bigger, but most of the increase was in 3.06, when <code>ocamldoc</code> was added to the distribution, and an effort was done to document <code>mli</code> files.</p>

