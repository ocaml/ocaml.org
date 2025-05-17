---
title: Announcing OCaml Labs
description: Introducing OCaml Labs, a new project at Cambridge Computer Lab to develop
  and improve the OCaml programming language.
url: https://anil.recoil.org/notes/announcing-ocaml-labs
date: 2012-10-19T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>I’m very excited to announce <a href="https://anil.recoil.org/projects/ocamllabs">OCaml Labs</a>, the latest project
to hit the Cambridge Computer Lab. As anyone that hangs out near me
probably realises, I very much enjoy functional programming. My weapon
of choice tends to be <a href="http://www.ocaml-lang.org">OCaml</a>, as it
condenses <a href="http://events.inf.ed.ac.uk/Milner2012/X_Leroy-html5-mp4.html">decades of
research</a>
into a pragmatic blend of functional, imperative and object-oriented
programming styles. What’s perhaps less well known are the steady
<a href="http://www.ocaml-lang.org/companies.html">inroads</a> that OCaml has been
making into mission-critical areas of industry. At <a href="http://ocaml.janestreet.com">Jane
Street</a>, billions of dollars of
transactions are routed through a huge ML code-base that is designed to
catch bugs <a href="http://vimeo.com/14313378">at compile-time</a>. At
<a href="http://github.com/xen-org/xen-api">Citrix</a>, the Xen management
toolstack that powers
<a href="http://blogs.citrix.com/2012/10/09/one-in-a-million/">millions</a> of
hosts in the cloud is <a href="https://anil.recoil.org/papers/2010-icfp-xen.pdf">largely written in
OCaml</a>. Facebook does
sophisticated <a href="https://github.com/facebook/pfff/wiki/Main">static
analysis</a> using OCaml over
their vast PHP codebase to close security holes.</p>
<p>The OCaml community is small but dedicated, but there is always more to
do to improve the language and ecosystem. So, thanks to a generous
platform grant from <a href="http://ocaml.janestreet.com">Jane Street</a>, we are
launching a program to help with the open-source development of OCaml
from Cambridge.</p>
<p>The <em><a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml Labs</a></em> are
based in the <a href="http://www.cl.cam.ac.uk">Cambridge Computer Lab</a> and led
my myself, <a href="http://www.cl.cam.ac.uk/~am21/">Alan Mycroft</a> and <a href="http://www.cl.cam.ac.uk/~iml1/">Ian
Leslie</a>. We’re closely affiliated with
other
<a href="http://www.cl.cam.ac.uk/projects/ocamllabs/collaboration.html">groups</a>,
and will be:</p>
<ul>
<li>
<p>developing the OCaml Platform, which will bundle the official OCaml
compiler from INRIA with a tested set of community libraries that
refreshed every six months.</p>
</li>
<li>
<p>working with the core OCaml team at INRIA’s
<a href="http://gallium.inria.fr/">Gallium</a> group on the compiler, and with
commercial partners like <a href="http://ocamlpro.com">OCamlPro</a> on tool
development. OCamlPro are making some very impressive progress
already with the <a href="http://opam.ocamlpro.com">OPAM</a> packge manager and
<a href="http://www.typerex.org">TypeRex</a> IDE helper.</p>
</li>
<li>
<p>supporting the online presence with more teaching material and
content. Yaron, Jason and I are working hard on a <a href="http://realworldocaml.org">new
book</a> that will be published next year,
and the OCaml Web team (led by <a href="http://ashishagarwal.org">Ashish</a>
and
<a href="https://plus.google.com/109604597514379193052/posts">Christophe</a>)
have made great progress on a <a href="http://www.ocaml-lang.org">brand new
website</a> that we will move to the
<code>ocaml.org</code> domain soon.</p>
</li>
</ul>
<h3>Research efforts</h3>
<p>Of course, it is difficult to hack on a language in a void, and we also
<em>use</em> OCaml heavily in our own research. The other half of OCaml Lab’s
goals are more disruptive (and riskier!):</p>
<ul>
<li>The upcoming first beta release of <a href="http://openmirage.org">Mirage</a>,
which is an operating system designed for cloud and embedded
environments, and is written almost entirely from the ground up in
OCaml. The outputs of Mirage include a <a href="http://www.openmirage.org/blog/breaking-up-is-easy-with-opam">large number of
libraries</a>
which are usable separately, such as pure implementations of TCP/IP,
DNS, SSH, DHCP and HTTP. The Xen hackers, led by <a href="http://dave.recoil.org">David Scott</a>, are out in force to integrate Mirage
into their <a href="http://www.xen.org/xensummit/xs12na_talks/T2.html">next-generation</a>
platform. Meanwhile, Raphael Proust is busy eliminating the <a href="https://anil.recoil.org/papers/drafts/2012-places-limel-draft1.pdf">garbage
collector</a>
with his cut-down “LinearML” variant.</li>
<li>Working with our collaborators at the <a href="http://horizon.ac.uk">Horizon
Institute</a> on privacy-preserving technologies
such as
<a href="https://anil.recoil.org/papers/2012-sigcomm-signposts-demo.pdf">Signposts</a>
which let you build and maintain your own personal clouds that
operate <a href="https://anil.recoil.org/papers/2011-icdcn-droplets.pdf">autonomously</a>
from the central cloud. You can read more about our <a href="http://www.cam.ac.uk/research/features/privacy-by-design/">privacy-by-design</a> philosophy too.</li>
<li>Extending OCaml to run on secure hardware platforms that doesn’t
compromise on performance, using the MIPS64-based <a href="http://www.cl.cam.ac.uk/research/security/ctsrd/cheri.html">capability
processor</a>
that is being developed at at the Lab.</li>
<li>The <a href="http://www.trilogy-project.org">Trilogy</a> was a hugely
successful EU-funded effort on future evolution of the Internet, and
resulted in <a href="http://trilogy-project.org/publications/standards-contributions.html">numerous
RFCs</a>
on subjects such as multipath-TCP. We’re partipating in the
follow-up (imaginatively dubbed “Trilogy2”), and look forward to
working on more structured abstractions for programming large-scale
networks.</li>
</ul>
<h3>Getting involved</h3>
<p>So, how can you get involved? We are initially advertising three
positions for full-time developers and researchers
(<a href="http://www.jobs.cam.ac.uk/job/-21662/">junior</a> and
<a href="http://www.jobs.cam.ac.uk/job/-21942/">senior</a>) to help us get started
with the OCaml Platform and compiler development. These aren’t
conventional pure research jobs, and a successful candidate should enjoy
the open-source development cycle (you retain your own copyright for
your own projects). The Computer Lab offers a pretty unique environment:
a friendly, non-hierarchical group in a beautiful city, and some of the
best faculty and students you could hope to hang out with.</p>
<p>And finally, there is a longer lead time on <a href="http://www.cl.cam.ac.uk/admissions/phd/">applying for
PhDs</a>, but this is a great time
to get involved. When I started at the Lab in 2002, a little project
called <a href="http://xen.org">Xen</a> was just kicking off, and many of us had a
wild (and oft great) time riding that wave. Get in touch with myself,
<a href="http://www.cl.cam.ac.uk/~am21/">Alan</a>,
<a href="http://www.cl.cam.ac.uk/~iml1/">Ian</a> or
<a href="http://www.cl.cam.ac.uk/~jac22/">Jon</a> soon if you are interested in
applying! There’s some more information available on the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/collaboration.html">OCaml Labs
pages</a>
about options.</p>

