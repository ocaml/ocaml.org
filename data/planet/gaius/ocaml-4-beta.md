---
title: OCaml 4 beta
description: "OCaml 4 beta 2 has been released, and so I quickly tested OCI*ML with
  it. Only a couple of minor tweaks were necessary, due to the following changes:
  Some .cmi for toplevel internals that used to b\u2026"
url: https://gaius.tech/2012/06/07/ocaml-4-beta/
date: 2012-06-07T18:17:03-00:00
preview_image: https://gaiustech.files.wordpress.com/2018/07/cropped-lynx.jpg?w=180
featured:
authors:
- gaius
---

<p><a href="http://caml.inria.fr/pub/distrib/ocaml-4.00/">OCaml 4 beta 2</a> has been released, and so I quickly tested <a href="http://gaiustech.github.com/ociml/">OCI*ML</a> with it. Only a couple of minor tweaks were necessary, due to the following <a href="http://caml.inria.fr/pub/distrib/ocaml-4.00/notes/Changes">changes</a>:</p>
<ul>
<li>Some .cmi for toplevel internals that used to be installed in`<code>ocamlc -where`</code> are now to be found in  <code>`ocamlc -where`/compiler-libs</code>. Add &ldquo;<code>-I +compiler-libs</code>&rdquo; where needed.</li>
<li>Warning 28 is now enabled by default.</li>
</ul>
<p>The impact of these was that the <a href="https://gaiustech.wordpress.com/2011/05/28/ociml-minor-updates/">toplevel prompt</a> wasn&rsquo;t working in the shell, and one non-fatal warning when compiling, so nothing that would have broken any code, but it&rsquo;s good to be up-to-date. The necessary changes have been checked in on Github. </p>
<p>Speaking of which, bearing in mind the <a href="http://www.bbc.co.uk/news/technology-18338956">LinkedIn d&eacute;b&agrave;cle</a>, I have a <a href="http://github.com/gaiustech/MkPasswd">password generator</a> too&hellip;</p>

