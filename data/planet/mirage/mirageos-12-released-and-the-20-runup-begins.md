---
title: MirageOS 1.2 released and the 2.0 runup begins
description:
url: https://mirage.io/blog/mirage-1.2-released
date: 2014-07-08T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>Summer is in full swing here in MirageOS HQ with torrential rainstorms, searing
sunshine, and our <a href="http://www.oscon.com/oscon2014/public/schedule/detail/35024">OSCON 2014</a> talk
rapidly approaching in just a few weeks.  We've been steadily releasing point releases
since the <a href="https://mirage.io/blog/mirage-1.1-released">first release</a> back in December, and today's <a href="https://github.com/mirage/mirage/releases/tag/v1.2.0">MirageOS
1.2.0</a> is the last of the <code>1.x</code> series.
The main improvements are usability-oriented:</p>
<ul>
<li>
<p>The Mirage frontend tool now generates a <code>Makefile</code> with a <code>make depend</code>
target, instead of directly invoking OPAM as part of <code>mirage configure</code>.
This greatly improves usability on slow platforms such as ARM, since the
output of OPAM as it builds can be inspected more easily. Users will now
need to run <code>make depend</code> to ensure they have the latest package set
before building their unikernel.</p>
</li>
<li>
<p>Improve formatting of the <code>mirage</code> output, including pretty colours!
This makes it easier to distinguish complex unikernel configurations
that have lots of deployment options.  The generated files are built
more verbosely by default to facilitate debugging, and with debug
symbols and backtraces enabled by default.</p>
</li>
<li>
<p>Added several <a href="https://github.com/mirage/mirage/tree/master/types">device module types</a>, including <code>ENTROPY</code> for random
noise, <code>FLOW</code> for stream-oriented connections, and exposed the <code>IPV4</code>
device in the <code>STACKV4</code> TCP/IP stack type.</p>
</li>
<li>
<p>Significant bugfixes in supporting libraries such as the TCP/IP
stack (primarily thanks to <a href="http://www.somerandomidiot.com/">Mindy Preston</a> fuzz testing
and finding some good <a href="https://github.com/mirage/mirage-tcpip/issues/56">zingers</a>).  There are too many
library releases to list individually here, but you can <a href="https://mirage.io/releases">browse the changelog</a> for more details.</p>
</li>
</ul>
<p>####&nbsp;Towards MirageOS 2.0</p>
<p>We've also been working hard on the <strong>MirageOS 2.x series</strong>, which introduces
a number of new features and usability improvements that emerged from actually
using the tools in practical projects.  Since there have been so many <a href="https://mirage.io/blog/welcome-to-our-summer-hackers">new
contributors</a> recently,
<a href="http://amirchaudhry.com">Amir Chaudhry</a> is coordinating a <a href="https://github.com/mirage/mirage/issues/257">series of blog
posts</a> in the runup to
<a href="http://www.oscon.com/oscon2014/public/schedule/detail/35024">OSCON</a> that
explains the new work in depth.  Once the release rush has subsided, we'll
be working on integrating these posts into our <a href="https://mirage.io/docs">documentation</a>
properly.</p>
<p>The new 2.0 features include the <a href="https://github.com/mirage/irmin">Irmin</a> branch-consistent distributed storage
library, the pure OCaml <a href="https://github.com/mirleft/">TLS stack</a>, <a href="https://github.com/mirage/mirage-platform/pull/93">Xen/ARM support</a> and the Conduit I/O
subsystem for <a href="http://anil.recoil.org/papers/2012-resolve-fable.pdf">mapping names to connections</a>.  Also included in the blog series
are some sample usecases on how these tie together for real applications (as a
teaser, here's a video of <a href="https://www.youtube.com/watch?v=DSzvFwIVm5s">Xen VMs booting using
Irmin</a> thanks to <a href="http://dave.recoil.org">Dave
Scott</a> and <a href="http://gazagnaire.org">Thomas Gazagnaire</a>!)</p>
<h4>Upcoming talks and tutorials</h4>
<p><a href="http://mort.io">Richard Mortier</a> and myself will be gallivanting around the world
to deliver a few talks this summer:</p>
<ul>
<li>The week of <a href="http://www.oscon.com/oscon2014">OSCON</a> on July 20th-24th.  Please get in touch via the conference website or a direct e-mail, or <a href="http://www.oscon.com/oscon2014/public/schedule/detail/35024">attend our talk</a> on Thursday morning.
There's a <a href="https://realworldocaml.org">Real World OCaml</a> book signing on Tuesday morning for the super keen as well.
</li>
<li>The <a href="http://ecoop14.it.uu.se/programme/ecoop-school.php">ECOOP summer school</a> in beautiful Uppsala in Sweden on Weds 30th July.
</li>
<li>I'll be presenting the Irmin and Xen integration at <a href="http://events.linuxfoundation.org/events/xen-project-developer-summit">Xen Project Developer Summit</a> in
Chicago on Aug 18th (as part of LinuxCon North America).  <a href="http://mort.io">Mort</a> and <a href="http://somerandomidiot.com">Mindy</a> (no jokes please) will be
joining the community panel about <a href="https://mirage.io/blog/applying-for-gsoc2014">GSoC/OPW</a> participation.
</li>
</ul>
<p>As always, if there are any particular topics you would like to see more
on, then please comment on the <a href="https://github.com/mirage/mirage/issues/257">tracking issue</a>
or <a href="https://mirage.io/community">get in touch directly</a>.  There will be a lot of releases coming out
in the next few weeks (including a beta of the new version of <a href="http://opam.ocaml.org">OPAM</a>,
so <a href="https://github.com/mirage/mirage/issues">bug reports</a> are very much appreciated for those
things that slip past <a href="http://travis-ci.org">Travis CI</a>!</p>

      
