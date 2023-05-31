---
title: jane street core 0.6.0 has arrived
description:
url: http://upsilon.cc/~zack/blog/posts/2009/11/jane_street_core_0.6.0_has_arrived/
date: 2009-11-13T15:47:57-00:00
preview_image:
featured:
authors:
- szacchiroli
---

<h1>Debian &quot;Core&quot; 0.6.0 packages ready</h1>
<p>I've completed the packaging of the new release of <a href="http://www.janestreet.com/ocaml"><strong>(Jane Street)
Core</strong></a>, version <strong>0.6.0</strong>. Core is (yet
another) extended / alternative standard library for OCaml,
integrating not only the much needed &quot;everyday functions&quot; but also
offering consistent abstractions throughout all stdlib modules
(with a lot of inspiration from well-known type classes from the
Haskell stdlib), consistent naming conventions (e.g. all functions
using exceptions as meaningful return values ends in
<code>_exn</code>), and significant syntax extensions.</p>
<p>While I've been thus far an <a href="http://batteries.forge.ocamlcore.org/">OCaml <strong>Batteries
Included</strong></a> fanboy, I confess that nowadays I'm more
<strong>skeptical about its success</strong> than in the past, in
spite of having contributed a tad of code to it. The reason is
simply that <a href="https://lists.ocamlcore.org/pipermail/batteries-devel/2009-September/000879.html">
the lead of the project is now gone</a> and, more importantly, has
done so without having (yet?) clearly appointed/found a new lead.
That does not change the fact that David has only to be kudoed for
his amount of impressive work on Batteries. Still, as a matter of
fact right there is no stable release yet and there is no one that
will be taking the project to deliver one, since no one else has
stepped forward (yet?).</p>
<p>In this interim the OCaml problems in delivering, on top of an
amazing core language, an amazing development platform in which
programmers are not forced to reinvent wheels, stand. Core fills
such a gap properly. I was preferring Batteries to it due to its
more open development process, but in spite of that Core is a
pretty damn good stdlib. Long life to Jane Street that currently
maintains it <img src="http://upsilon.cc/~zack/smileys/smile.png" alt=":-)"/></p>
<p>Now, back to the main topic of this post, <strong>Debian
packages for Core 0.6.0 are now available</strong>; you will be
able to get it from the main/unstable archive soon (some manual NEW
processing is required). In the meantime they can be fetched from
my personal APT repository, as usual:</p>
<pre><code>    deb http://people.debian.org/~zack/debian zack-unstable/
    deb-src http://people.debian.org/~zack/debian zack-unstable/
</code></pre>
<p>A few <strong>noteworthy changes</strong> from the past package
releases:</p>
<ul>
<li>
<p>There is now a new set of packages
(<code>libcore-extended-ocaml{,-dev}</code>) that contains
<strong>Core_extended</strong>. It is a new subset of Core, which
offers more features on top of Core, but which has more
dependencies (most notably Pcre-OCaml) and is declared to be less
thoroughly peer-reviewed than Core itself.</p>
</li>
<li>
<p>There is now a separate <strong>documentation</strong> package
(<code>libcore-ocaml-doc</code>) which contains the built ocamldoc
HTML API reference for Core and Core_extended.</p>
<p>Note that it is not exactly the same doc that <a href="http://ocaml.janestreet.com/?q=node/74">has been recently
announced</a> by Jane Street and that is now <a href="http://www.janestreet.com/ocaml/janestreet-ocamldocs/">available
on the web</a>. The latter is comprehensive of all other Jane
Street libraries (sexplib, bin-prot, ...). I'll be probably
packaging that too, but first <a href="http://lists.debian.org/debian-ocaml-maint/2009/11/msg00101.html"><em>
some licensing problems</em></a> need to be solved.</p>
</li>
</ul>
<p><strong>Update</strong> 18/10/2009: core 0.6.0 and all its
components have passed through NEW, they are now available in the
Debian archive as usual</p>


