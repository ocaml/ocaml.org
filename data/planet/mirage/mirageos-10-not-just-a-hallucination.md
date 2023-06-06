---
title: 'MirageOS 1.0: not just a hallucination!'
description:
url: https://mirage.io/blog/announcing-mirage10
date: 2013-12-09T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p><em>First</em>: read the <a href="https://mirage.io/wiki/overview-of-mirage">overview</a> and
<a href="https://mirage.io/wiki/technical-background">technical background</a> behind the project.</p>
<p>When we started hacking on MirageOS back in 2009, it started off looking like a
conventional OS, except written in OCaml.   The <a href="https://github.com/mirage/mirage/tree/old-master">monolithic
repository</a> contained all the
libraries and boot code, and exposed a big <code>OS</code> module for applications to use.
We used this to do several fun <a href="http://cufp.org/conference/sessions/2011/t3-building-functional-os">tutorials</a> at conferences
such as ICFP/CUFP and get early feedback.</p>
<p>As development continued though, we started to understand what it is we were
building: a <a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">&quot;library operating system&quot;</a>.  As the number of libraries grew,
putting everything into one repository just wasn't scaling, and it made it hard
to work with third-party code.  We spent some time developing tools to make
Mirage fit into the broader OCaml ecosystem.</p>
<p>Three key things have emerged from this effort:</p>
<ul>
<li><a href="https://opam.ocaml.org">OPAM</a>, a source-based package manager for
OCaml. It supports multiple simultaneous compiler installations, flexible
package constraints, and a Git-friendly development workflow.  Since
releasing 1.0 in March 2013 and 1.1 in October, the community has leapt
in to contribute over 1800 packages in this short time.  All of the
Mirage libraries are now tracked using it, including the Xen libraries.
</li>
<li>The build system for embedded programming (such as the Xen target) is
a difficult one to get right.  After several experiments, Mirage provides
a single <strong><a href="https://github.com/mirage/mirage">command-line tool</a></strong> that
combines configuration directives (also written in OCaml) with OPAM to
make building Xen unikernels as easy as Unix binaries.
</li>
<li>All of the Mirage-compatible libraries satisfy a set of module type
signatures in a <strong><a href="https://github.com/mirage/mirage-types/blob/master/lib/v1.mli">single file</a></strong>.
This is where Mirage lives up to its name: we've gone from the early
monolithic repository to a single, standalone interface file that
describes the interfaces.  Of course, we also have libraries to go along
with this signature, and they all live in the <a href="https://github.com/mirage">MirageOS GitHub organization</a>.
</li>
</ul>
<p>With these components, I'm excited to announce that MirageOS 1.0 is finally ready
to see the light of day!  Since it consists of so many libraries, we've decided
not to have a &quot;big bang&quot; release where we dump fifty complex libraries on the
open-source community.  Instead, we're going to spend the month of December
writing a series of blog posts that explain how the core components work,
leading up to several use cases:</p>
<ul>
<li>The development team have all decided to shift our personal homepages to be Mirage
kernels running on Xen as a little Christmas present to ourselves, so we'll work through that step-by-step how to build
a dedicated unikernel and maintain and deploy it (<strong>spoiler:</strong> see <a href="https://github.com/mirage/mirage-www-deployment">this repo</a>).  This will culminate in
a webservice that our colleagues at <a href="http://horizon.ac.uk">Horizon</a> have been
building using Android apps and an HTTP backend.
</li>
<li>The <a href="http://xenserver.org">XenServer</a> crew at Citrix are using Mirage to build custom middlebox VMs
such as block device caches.
</li>
<li>For teaching purposes, the <a href="http://ocaml.io">Cambridge Computer Lab team</a> want a JavaScript backend,
so we'll explain how to port Mirage to this target (which is rather different
from either Unix or Xen, and serves to illustrate the portability of our approach).
</li>
</ul>
<h3>How to get involved</h3>
<p>Bear with us while we update all the documentation and start the blog posts off
today (the final libraries for the 1.0 release are all being merged into OPAM
while I write this, and the usually excellent <a href="http://travis-ci.org">Travis</a> continuous integration system is down due to a <a href="https://github.com/travis-ci/travis-ci/issues/1727">bug</a> on their side).  I'll edit this post to contain links to the future posts
as they happen.</p>
<p>Since we're now also a proud Xen and Linux Foundation incubator project, our mailing
list is shifting to <a href="http://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">mirageos-devel@lists.xenproject.org</a>, and we very much
welcome comments and feedback on our efforts over there.
The <code>#mirage</code> channel on FreeNode IRC is also growing increasingly popular, as
is simply reporting issues on the main <a href="http://github.com/mirage/mirage">Mirage GitHub</a> repository.</p>
<p>Several people have also commented that they want to learn OCaml properly to
start using Mirage.  I've just co-published an O'Reilly book called
<a href="https://realworldocaml.org">Real World OCaml</a> that's available for free online
and also as hardcopy/ebook.  Our Cambridge colleague John Whittington has
also written an excellent <a href="http://ocaml-book.com/">introductory text</a>, and
you can generally find more resources <a href="http://ocaml.org/docs/">online</a>.
Feel free to ask beginner OCaml questions on our mailing lists and we'll help
as best we can!</p>

      
