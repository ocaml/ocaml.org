---
title: 'OASIS-DB: a CPAN for OCaml'
description:
url: http://www.ocamlcore.com/wp/2010/07/oasis-db-a-cpan-for-ocaml/
date: 2010-07-15T13:18:22-00:00
preview_image:
featured:
authors:
- ocamlcore
---

<p>OCamlCore, with support from the OCaml enthusiasts at <a href="http://janestreet.com">Jane Street</a>, is working on creating OASIS-DB, a <a href="http://en.wikipedia.org/wiki/CPAN">CPAN</a> for OCaml. The goals of OASIS-DB are to reduce the paperwork required to release and update an OCaml package, and to provide integrated management of library dependencies.</p>
<p style="text-align: center;"><img src="http://www.ocamlcore.com/wp/wp-content/uploads/logo.png" width="160" height="150" alt="OASIS logo"/></p>
<p>OASIS-DB is also intended to help packagers for a variety of systems, including <a href="http://www.debian.org">Debian</a>, <a href="http://fedoraproject.org/">Fedora</a>, <a href="http://godi.camlcity.org/godi/index.html">GODI</a> and others, by:</p>
<ul>
<li>providing consistent metadata: description, synopsis, build dependencies</li>
<li>displaying version number of packages in each distribution</li>
<li>displaying available patches</li>
</ul>
<p>In addition, we hope to ease integration with GODI by publishing packages using an alternative GODI repository, when translation of the _oasis file with <a href="http://projects.phauna.org/GODIVA/">GODIVA</a> is possible. It will also integrate with other indices of OCaml packages, like the OCaml <a href="http://links.camlcity.org/">LinkDB</a> and the OCaml <a href="http://caml.inria.fr//cgi-bin/hump.en.cgi">Hump</a>. </p>
<p>The project is almost a pure OCaml project. It uses <a href="http://ocsigen.org">ocsigen</a> for its website and processes _oasis file in an uploaded tarball to publish a package. The project is in fact a sub-project of the <a href="http://oasis.forge.ocamlcore.org">OASIS</a> project and reuses user information provided for this tool.</p>
<p>We hope that this project will provide the OCaml community with a great tool to manage a growing number of small libraries. Don&rsquo;t hesitate to comment on our technical specifications, if you think we&rsquo;re missing something.</p>
<p>This project will cover what was named &quot;bocage&quot; and &quot;OASIS self-contained&quot; during the <a href="https://forge.ocamlcore.org/docman/view.php/77/108/OCamlMeeting2010_OASIS_Slides.pdf">OASIS presentation</a> at OCaml Meeting 2010.</p>
<p><a href="http://oasis.forge.ocamlcore.org/oasis-db.html">More information</a></p>

