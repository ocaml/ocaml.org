---
title: ocaml.m4 is now in the ocaml-tools package
description:
url: http://upsilon.cc/~zack/blog/posts/2009/07/ocaml.m4_is_now_in_the_ocaml-tools_package/
date: 2009-07-19T18:17:01-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>ocaml-autoconf Debian packaged</h1>
<p><a href="http://upsilon.cc/~zack/blog/posts/2009/04/ocaml_autoconf_1.0/">A while
ago</a>, me and <a href="http://www.annexia.org/richard_w.m._jones">Richard Jones</a> have
federated the various stubs for OCaml autoconf support in the
<a href="http://ocaml-autoconf.forge.ocamlcore.org/">ocaml-autoconf</a>
project.</p>
<p>Having almost forgot about that for a while, here at <a href="http://debconf9.debconf.org/">DebCamp9</a> I've just catched up
and <a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=512834">shipped
it in Debian</a>. Instead of creating a package of its own, which
would have been ridicolously small, I've added the macros and their
docs to <a href="http://packages.debian.org/sid/ocaml-tools">ocaml-tools</a>.</p>
<p>You can find <code>ocaml.m4</code> and friends in that package,
starting from version <code>20090719-1</code>, which I've just
uploaded to unstable.</p>


