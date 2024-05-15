---
title: OCaml 32bits longval
description: 'You will need OCaml 3.11.2 installed on a i686 linux computer. The archive
  contains: libcamlrun-linux-i686.a

  ocamlrun-linux-i686

  Makefile

  README The Makefile has two targets: sudo make install will save /usr/bin/ocamlrun
  and /usr/lib/ocaml/libcamlrun.a in the current directory and replace them with ...'
url: https://ocamlpro.com/blog/2011_05_06_ocaml_32bits_longval
date: 2011-05-06T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p>You will need OCaml 3.11.2 installed on a i686 linux computer. The archive contains:</p>
<ul>
<li>libcamlrun-linux-i686.a
</li>
<li>ocamlrun-linux-i686
</li>
<li>Makefile
</li>
<li>README
</li>
</ul>
<p>The Makefile has two targets:</p>
<ul>
<li><code>sudo make install</code> will save <code>/usr/bin/ocamlrun</code> and <code>/usr/lib/ocaml/libcamlrun.a</code> in the current directory and replace them with the longval binaries.
</li>
<li><code>sudo make restore</code> will restore the saved files.
</li>
</ul>
<p>If your install directories are not the default ones, you should modify the Makefile. After installing, you can test it with the standard OCaml top-level:</p>
<p><code>Objective Caml version 3.11.2</code></p>
<pre><code class="language-Ocaml">
# let s = ref &ldquo;&rdquo;;;
val s : string ref = {contents = &ldquo;&rdquo;}

# s := String.create 20_000_000;;
&ndash; : unit = ()
</code></pre>
<p>Now you can enjoy big values in all your strings and arrays in
bytecode. You will need to relink all your custom binaries. If you are
interested in the native version of the longval compiler, you can
<a href="mailto:contact@ocamlpro.com">contact</a> us.</p>

