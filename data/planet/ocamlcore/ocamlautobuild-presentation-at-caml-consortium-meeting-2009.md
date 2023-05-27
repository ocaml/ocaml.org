---
title: OCamlAutobuild presentation at Caml Consortium meeting 2009
description:
url: http://www.ocamlcore.com/wp/2009/12/ocamlautobuild-presentation-at-caml-consortium-meeting-2009/
date: 2009-12-14T16:03:29-00:00
preview_image:
featured:
authors:
- ocamlcore
---

<p>One year ago, OCamlCore has started a project to help creating a fully featured build system: OCamlAutobuild.</p>
<p>This system is designed to help upstream developers to standardize their build system around a few entry points that can be re-used by packaging system. It doesn&rsquo;t create yet another build system but just provide a way to use one already existing &mdash; applying a standard to call it.</p>
<p>On Friday, 4th December 2009, OCamlCore was at the annual Caml Consortium meeting and gave a talk about OCamlAutobuild. Packaging issues was discussed before within the consortium and OCamlCore wanted to show the progress of its own project.</p>
<p>The conclusion of this presentation was:</p>
<ul>
<li>Its name is too close to &ldquo;automake&rdquo;, which some people consider as old and full of black magic;</li>
<li>Will it really ease the work of packagers ?</li>
</ul>
<p>The solution of the first point is to rename the project to &ldquo;OASIS&rdquo;. This is derived from the name of the central file used for OCamlAutobuild: <em>_oasis</em>.</p>
<p>The second point is more difficult to answer. We are planning to be able to produce GODIVA files by translating <em>_oasis</em> files. Using a plugin such as &ldquo;StdFiles&rdquo; we can meet the policy of GODIVA concerning upstream package (a script called <em>configure</em>, <tt>make all</tt> and <tt>make opt</tt>). However, GODIVA can only handle a subset of what GODI can process. This is a restriction but hopefully this will still help GODI maintainers.</p>
<p>Concerning cooperation with other packagers such as Debian and Fedora, I think we will only check that data from <em>_oasis</em> and from the packaging system are almost synchronized. For example, we will check that build depends in &ldquo;debian/control&rdquo; is enough to fulfill build depends in <em>_oasis</em>.</p>
<p>OASIS supports now OCamlbuild by default and is planning support for OCamlMakefile and OMake.</p>
<p>More informations:</p>
<p><a href="https://forge.ocamlcore.org/docman/view.php/54/94/Presentation.pdf">OASIS Slides</a></p>
<p><a href="https://forge.ocamlcore.org/projects/ocaml-autobuild/">OASIS OCaml forge project</a></p>
<p><a href="http://darcs.ocamlcore.org/cgi-bin/darcsweb.cgi?r=ocaml-autobuild%3Ba=summary">OASIS Darcs repository</a></p>
<p>Related projects:</p>
<p><a href="http://godi.camlcity.org">GODI</a></p>
<p><a href="http://projects.phauna.org/godiva/">GODIVA</a>, <a href="http://projects.phauna.org/godiva/docs/policy.html">GODIVA policy</a></p>
<p><a href="http://ocaml.info/home/ocaml_sources.html#ocaml-make">OCamlMakefile</a></p>
<p><a href="http://omake.metaprl.org/index.html">OMake</a></p>
<p>&nbsp;</p>

