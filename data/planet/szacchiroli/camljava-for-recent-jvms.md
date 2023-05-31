---
title: camljava for recent JVMs
description:
url: http://upsilon.cc/~zack/blog/posts/2009/12/camljava_for_recent_JVMs/
date: 2009-12-01T14:25:37-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>resurrecting CamlJava (testers welcome)</h1>
<p><a href="http://pauillac.inria.fr/~xleroy/software.html#camljava"><strong>CamlJava</strong></a>
is a great project by <a href="http://pauillac.inria.fr/~xleroy/">almighty Xavier</a> that
<strong>bridges the OCaml and Java worlds</strong> via the
respective C interfaces (Caml/C interface for OCaml and JNI for
Java).</p>
<p>Unfortunately, the last stable release was a bit out of date and
seemed not to work with recent JDK (both in terms of buildability
and of runtime correctness, i.e., segfaults). With the tremendous
help of <a href="http://www.pps.jussieu.fr/~henry/">Gr&eacute;goire
Henry</a>, I've managed to prepare <a href="http://git.debian.org/?p=pkg-ocaml-maint/packages/camljava.git%3Ba=tree%3Bf=debian/patches">
<strong>a set of patches</strong></a> that enables to build (and
use without segfaults ...) CamlJava with <strong>recent
JVM</strong>: in particular it <em>seems</em> now to work with both
Sun's JVM and OpenJDK.</p>
<p>A <strong>Debian package</strong> <a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=558090">has been
prepared</a>; while it gets processed by archive manager, you can
get an equivalent unofficial package from my APT repo:</p>
<pre><code>    deb http://people.debian.org/~zack/debian zack-unstable/
    deb-src http://people.debian.org/~zack/debian zack-unstable/
</code></pre>
<p>Any form of <strong>testing is very welcome</strong>.</p>
<p>In case you want to try <a href="http://www.pps.jussieu.fr/~henry/ojacare/index.en.html">O'Jacare</a>
on top of CamlJava however, you need to wait a bit more: Gr&eacute;goire
is working on it, but in the process he banged his head against
bugs in both CamlP4 and CamlP5 (the only two available porting
paths from the last stable release of O'Jacare) <img src="http://upsilon.cc/~zack/smileys/smile.png" alt=":-)"/></p>
<p><strong>Update 1</strong>: we made into <a href="http://alan.petitepomme.net/cwn/2009.12.08.html#1">this week Caml
Weekly News</a></p>
<p><strong>Update 2</strong>: even if I haven't been contacted yet,
<a href="https://forge.ocamlcore.org/projects/camljava/">Xavier has
registered a Caml/Java project</a> on the OCaml forge, good sign!
<img src="http://upsilon.cc/~zack/smileys/smile.png" alt=":-)"/></p>


