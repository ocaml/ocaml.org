---
title: The road to a developer preview at OSCON 2013
description:
url: https://mirage.io/blog/the-road-to-a-dev-release
date: 2013-05-20T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>There's been a crazy stream of activity since the start of the year, but the most important news is that we have a release target for an integrated developer preview of the Mirage stack: a talk at <a href="http://www.oscon.com/oscon2013/public/schedule/detail/28956">O'Reilly OSCon</a> in July!  Do turn up there and find <a href="http://dave.recoil.org">Dave Scott</a> and <a href="http://anil.recoil.org">Anil Madhavapeddy</a> showing off interactive demonstrations.</p>
<p>Meanwhile, another significant announcement has been that Xen is <a href="http://www.linuxfoundation.org/news-media/announcements/2013/04/xen-become-linux-foundation-collaborative-project">joining the Linux Foundation</a> as a collaborative project.  This is great news for Mirage: as a library operating system, we can operate just as easily under other hypervisors, and even on bare-metal devices such as the <a href="http://raspberrypi.org">Raspberry Pi</a>.  We're very much looking forward to getting the Xen-based developer release done, and interacting with the wider Linux community (and FreeBSD, for that matter, thanks to Gabor Pali's <a href="https://github.com/pgj/mirage-kfreebsd">kFreeBSD</a> backend).</p>
<p>Here's some other significant news from the past few months:</p>
<ul>
<li>
<p><a href="http://www.ocamlpro.com/blog/2013/03/14/opam-1.0.0.html">OPAM 1.0 was released</a>, giving Mirage a solid package manager for handling the many libraries required to glue an application together.  <a href="https://github.com/vbmithr">Vincent Bernardoff</a> joined the team at Citrix and has been building a Mirage build-frontend called <a href="https://github.com/mirage/mirari">Mirari</a> to hide much of the system complexity from a user who isn't too familiar with either Xen or OCaml.</p>
</li>
<li>
<p>A new group called the <a href="http://ocaml.io">OCaml Labs</a> has started up in the <a href="http://www.cl.cam.ac.uk">Cambridge Computer Laboratory</a>, and is working on improving the OCaml toolchain and platform.  This gives Mirage a big boost, as we can re-use several of the documentation, build and test improvements in our own releases.  You can read up on the group's activities via the <a href="http://ocaml.io/news">monthly updates</a>, or browse through the various <a href="http://ocaml.io/tasks">projects</a>.  One of the more important projects is the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/tasks/platform.html#OCamlot">OCamlot</a> continuous build infrastructure, which will also be testing Mirage kernels as one of the supported backends.</p>
</li>
<li>
<p>As we head into release mode, we've started <a href="https://mirage.io/wiki#Weekly-calls-and-release-notes">weekly meetings</a> to coordinate all the activities.  We're keeping notes as we go along, so you should be able to skim the notes and <a href="https://lists.cam.ac.uk/pipermail/cl-mirage/">mailing list archives</a> to get a feel for the overall activities.  Anil is maintaining a <a href="https://mirage.github.io/wiki/dev-preview-checklist">release checklist</a> for the summer developer preview.</p>
</li>
<li>
<p>Anil (along with Yaron Minsky and Jason Hickey) is finishing up an O'Reilly book on <a href="http://realworldocaml.org">Real World OCaml</a>, which will be a useful guide to using OCaml for systems and network programming. If you'd like to review an early copy, please get in touch.  The final book is anticipated to be released towards the end of the year, with a <a href="http://shop.oreilly.com/category/roughcuts.do">Rough Cut</a> at the end of the summer.</p>
</li>
<li>
<p>The core system was described in an <a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">ASPLOS 2013</a> paper, which should help you understand the background behind library operating systems. Some of the Mirage libraries are also currently being integrated into the next-generation <a href="http://blogs.citrix.com/2012/05/17/introducing-windsor-a-new-xen-based-virtualization-architecture/">Windsor</a> release of the Xen Cloud Platform, which means that several of the libraries will be used in production and hence move beyond research-quality code.</p>
</li>
</ul>
<p>In the next few months, the installation notes and getting started guides will
all be revamped to match the reality of the new tooling, so expect some flux
there.   If you want to take an early try of Mirage beforehand, don't forget to
hop on the <code>#mirage</code> IRC channel on Freenode and ping us with questions
directly.  We will also be migrating some of the project infrastructure to be fully
self-hosted on Mirage and Xen, and placing some of the services onto the new <a href="http://xenproject.org">xenproject.org</a> infrastructure.</p>

      
