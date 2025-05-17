---
title: OPAM 1.1 beta available, with pretty colours
description: OPAM 1.1 beta is available with improved stability and new features.
url: https://anil.recoil.org/notes/opam-1-1-beta
date: 2013-09-20T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p><a href="https://github.com/samoht" class="contact">Thomas Gazagnaire</a> just announced the availability of the
<a href="http://opam.ocamlpro.com">OPAM</a> beta release. This has been a huge
amount of work for him and <a href="http://louis.gesbert.fr/">Louis</a>, so I’m
excited to see this release!</p>
<p>Aside from general stability, the main
highlights for me are:</p>
<ul>
<li>
<p>A switch to the
<a href="http://creativecommons.org/publicdomain/zero/1.0/">CC0</a>
public-domain-like license for the repository, and LGPL2+linking
exception for OPAM itself. The <a href="https://github.com/OCamlPro/opam-repository/issues/955">cutover to the new
license</a> was
the first non-gratuitous use of GitHub’s fancy issue lists I’ve
seen, too! As part of this, we’re also beginning a transition over
to hosting it at <code>opam.ocaml.org</code>, to underline our committment to
maintaining it as an OCaml community resource.</p>
</li>
<li>
<p>Much-improved support for package pinning and updates. This is the
feature that makes OPAM work well with
<a href="http://openmirage.org">MirageOS</a>, since we often need to do
development work on a low-level library (such as a <a href="https://github.com/mirage/ocaml-xen-block-driver">device
driver</a> and
recompile all the reverse dependencies.</p>
</li>
<li>
<p>Support for post-installation messages (e.g. to display <a href="https://github.com/OCamlPro/opam-repository/pull/1100">licensing
information</a>
or configuration hints) and better support for the external library
management issues I explained in an earlier post about <a href="https://anil.recoil.org/2013/09/09/ocamlot-autotriaging.html">OCamlot
testing</a>.</p>
</li>
<li>
<p>Better library structuring to let tools like
<a href="http://github.com/OCamlPro/opam2web">Opam2web</a> work with the
package metadata. For instance, my group’s <a href="http://ocaml.io">OCaml
Labs</a> has a comprehensive list of <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/pkg/index.html">the software
packages that we work
on</a>
generated directly from an OPAM remote.</p>
</li>
<li>
<p>A growing set of administration tools (via the <code>opam-admin</code> binary)
that run health checks and compute statistics over package
repositories. For example, here’s the result of running
<code>opam-admin stats</code> over the latest package repository to show
various growth curves.</p>
</li>
</ul>

