---
title: ocaml batteries included 1.1.0 is in debian now
description:
url: http://upsilon.cc/~zack/blog/posts/2010/03/ocaml_batteries_included_1.1.0_is_in_debian_now/
date: 2010-03-06T16:39:15-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>OCaml Batteries Included 1.1.0 has arrived in Debian</h1>
<p>I've just uploaded the <strong>Debian package of <a href="https://forge.ocamlcore.org/forum/forum.php?forum_id=552">OCaml
Batteries Included 1.1.0</a></strong> to the Debian unstable
archive; hopefully, it will quickly enter testing to be released
with the next Debian stable release. This is the first release in
Debian of the &quot;new generation&quot; of Batteries Included, which has
followed a strict diet, and now has <a href="http://camomile.sourceforge.net/">Camomile</a> as its only
external dependency.</p>
<p>It took me a while to package it due to an intertwining
transition to OCaml 3.11.2 (during which we have fleshed out the
last remaining few bits of transition to <a href="http://upsilon.cc/~zack/blog/posts/2009/11/Enforcing_type-safe_linking_using_package_dependencies/">
our new dependency system</a>). Also, I had to fix some typical
build issue with upstream, which kindly coordinated with me to have
the fixes included in 1.1.0.</p>
<p>So go, enjoy Batteries 1.1.0, and let me know your feedback:</p>
<pre><code>    # apt-get install ocaml-batteries-included
</code></pre>
<p><small>(check that it will install 1.1.0 though, it might take a
few days to hit your favorite architecture and mirror)</small></p>
<p><strong>Tip:</strong> starting from this version you will need
the following to use Batteries in place of the legacy standard
library in your sources:</p>
<pre><code>    open Batteries_uni
</code></pre>
<p>for multi-threaded programs you should rather use <code>open
Batteries</code>. Check the <code>FAQ</code> file installed under
<code>/usr/share/doc/libbatteries-ocaml-dev/</code> for more quick
start information.</p>


