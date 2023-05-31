---
title: ocaml batteries in Debian unstable
description:
url: http://upsilon.cc/~zack/blog/posts/2009/04/ocaml_batteries_in_Debian_unstable/
date: 2009-04-03T10:35:02-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>batteries approaching Beta 1: now in unstable</h1>
<p><a href="http://upsilon.cc/~zack/blog/posts/2008/10/ocaml_batteries_included_debian_packages/">
It's been a while</a>, but work on <a href="http://batteries.forge.ocamlcore.org">OCaml batteries included</a>
has continued steadily in the past months. We are now approaching
the first <strong>Beta release</strong>, which is due in a few
days.</p>
<p>In the meantime, a couple of days ago I've uploaded the Debian
<a href="http://packages.debian.org/sid/ocaml-batteries-included"><strong>ocaml-batteries
package</strong></a> to the unstable archive for the first time (it
was only available from experimental thus far). It is an &ldquo;almost
Beta&rdquo; release which you are <strong>encouraged to test</strong>
both for packaging aspects and for having a feeling of what
batteries will look like in its final shape.</p>
<p>To <strong>get started</strong> just do the following:</p>
<pre><code># aptitude install ocaml-batteries-included
$ ledit ocaml-batteries
</code></pre>

