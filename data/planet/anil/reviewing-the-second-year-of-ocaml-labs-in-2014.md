---
title: Reviewing the second year of OCaml Labs in 2014
description: Reviewing OCaml Labs' progress in 2014, covering tooling, compiler, community
  efforts, and research projects.
url: https://anil.recoil.org/notes/ocamllabs-2014-review
date: 2015-04-02T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>The <a href="https://anil.recoil.org/projects/ocamllabs">OCaml Labs</a> initiative within the <a href="http://www.cl.cam.ac.uk">Cambridge
Computer Laboratory</a> is now just over two years
old, and it is time for an update about our activities since the last
update at the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/news/index.html#Dec%202013">end of
2013</a>
and
<a href="https://anil.recoil.org/2012/10/19/announcing-ocaml-labs.html">2012</a>.</p>
<p>The theme of our group was not to be pure research, but rather a hybrid
group that takes on some of the load of day-to-day OCaml maintenance
from <a href="http://caml.inria.fr/">INRIA</a>, as well as help grow the wider
community and meet our own research agendas around topics such as
<a href="https://queue.acm.org/detail.cfm?id=2566628">unikernels</a>. To this end,
all of our projects have been highly collaborative, often involving
colleagues from <a href="http://ocamlpro.com">OCamlPro</a>,
<a href="http://caml.inria.fr/">INRIA</a>, <a href="http://janestreet.com">Jane Street</a>,
<a href="http://lexifi.com">Lexifi</a> and <a href="http://citrix.com">Citrix</a>.</p>
<p>This post covers our progress in tooling, the compiler and language,
community efforts, research projects and concludes with our priorities
for 2015.</p>
<h2><figure class="image-right"><img src="https://anil.recoil.org/images/toru-cucl-window.webp" loading="lazy" class="content-image" alt="OCaml: it's a dog's life. In this case, Toru the dog." srcset="/images/toru-cucl-window.1024.webp 1024w,/images/toru-cucl-window.1280.webp 1280w,/images/toru-cucl-window.1440.webp 1440w,/images/toru-cucl-window.1600.webp 1600w,/images/toru-cucl-window.1920.webp 1920w,/images/toru-cucl-window.2560.webp 2560w,/images/toru-cucl-window.320.webp 320w,/images/toru-cucl-window.3840.webp 3840w,/images/toru-cucl-window.480.webp 480w,/images/toru-cucl-window.640.webp 640w,/images/toru-cucl-window.768.webp 768w" title="OCaml: it's a dog's life. In this case, Toru the dog." sizes="(max-width: 768px) 100vw, 33vw"><figcaption>OCaml: it's a dog's life. In this case, Toru the dog.</figcaption></figure>

Tooling</h2>
<p>At the start of 2014, we had just helped to release <a href="http://opam.ocaml.org/blog/opam-1-1-1-released/">OPAM
1.1.1</a> with our
colleagues at <a href="http://ocamlpro.com">OCamlPro</a>, and serious OCaml users
had just started moving over to using it.</p>
<p>Our overall goal at OCaml Labs is to deliver a modular set of of
development tools around OCaml that we dub the <em>OCaml Platform</em>. The
remainder of 2014 was thus spent polishing this nascent OPAM release
into a solid base (both as a command-line tool and as a library) that we
could use as the basis for documentation, testing and build
infrastructure, all the while making sure that bigger OCaml projects
continued to migrate over to it. Things have been busy; here are the
highlights of this effort.</p>
<h3>OPAM</h3>
<p>The central <a href="https://github.com/ocaml/opam-repository">OPAM repository</a>
that contains the package descriptions has grown tremendously in 2014,
with over 280 contributors committing almost 10000 changesets across
3800 <a href="https://github.com/ocaml/opam-repository/pulls">pull requests</a> on
GitHub. The front line of incoming testing has been continuous
integration by the wonderful <a href="http://travis-ci.org/ocaml/opam-repository">Travis
CI</a>, who also granted us
access to their experimental <a href="http://docs.travis-ci.com/user/osx-ci-environment/">MacOS
X</a> build pool. The
OPAM package team also to expanded to give David Sheets, Jeremy Yallop,
Peter Zotov and Damien Doligez commit rights, and they have all been
busily triaging new packages as they come in.</p>
<p>Several large projects such as <a href="http://xapi-project.github.io/">Xapi</a>,
<a href="http://ocsigen.org">Ocsigen</a> and our own
<a href="http://openmirage.org">MirageOS</a> switched over to using OPAM for
day-to-day development, as well as prolific individual developers such
as <a href="http://erratique.ch">Daniel Buenzli</a> and <a href="http://ocaml.info/">Markus
Mottl</a>. <a href="https://blogs.janestreet.com/category/ocaml/">Jane
Street</a> continued to send
regular <a href="https://github.com/ocaml/opam-repository/pulls?utf8=%E2%9C%93&amp;q=is:pr%20author:diml%20">monthly
updates</a>
of their Core/Async suite, and releases appeared from the
<a href="https://github.com/ocaml/opam-repository/pull/3570">Facebook</a>
open-source team as well (who develop
<a href="https://code.facebook.com/posts/264544830379293/hack-a-new-programming-language-for-hhvm/">Hack</a>,
<a href="https://github.com/facebook/flow">Flow</a> and
<a href="https://github.com/facebook/pfff">Pfff</a> in OCaml).</p>
<ul>
<li>Gallery
<figure class="image-right"><img src="https://anil.recoil.org/images/opam12-contributors-mar14.webp" loading="lazy" class="content-image" alt="Number of unique contributors to the central OPAM package repository" srcset="/images/opam12-contributors-mar14.320.webp 320w,/images/opam12-contributors-mar14.480.webp 480w,/images/opam12-contributors-mar14.640.webp 640w,/images/opam12-contributors-mar14.768.webp 768w" title="Number of unique contributors to the central OPAM package repository" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Number of unique contributors to the central OPAM package repository</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/opam12-packages-mar14.webp" loading="lazy" class="content-image" alt="Total number of unique packages (including multiple versions of the same package)" srcset="/images/opam12-packages-mar14.320.webp 320w,/images/opam12-packages-mar14.480.webp 480w,/images/opam12-packages-mar14.640.webp 640w,/images/opam12-packages-mar14.768.webp 768w" title="Total number of unique packages (including multiple versions of the same package)" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Total number of unique packages (including multiple versions of the same package)</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/opam12-unique-packages-mar14.webp" loading="lazy" class="content-image" alt="Total packages with multiple versions coalesced so you can see new package growth" srcset="/images/opam12-unique-packages-mar14.320.webp 320w,/images/opam12-unique-packages-mar14.480.webp 480w,/images/opam12-unique-packages-mar14.640.webp 640w,/images/opam12-unique-packages-mar14.768.webp 768w" title="Total packages with multiple versions coalesced so you can see new package growth" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Total packages with multiple versions coalesced so you can see new package growth</figcaption></figure>
</li>
</ul>
<p>We used feedback from the users to smooth away many of the rough edges,
with:</p>
<ul>
<li>a redesigned <a href="http://opam.ocaml.org/blog/opam-1-2-pin/">development workflow</a> that lets developers quickly grab a development version of a library recompile all dependent packages automatically, and quickly publish results to GitHub.</li>
<li>binary distributions for common OS distributions via their <a href="https://github.com/ocaml/opam/wiki/Distributions">native packaging</a>, as well as <a href="http://opam.ocaml.org/blog/0install-intro/">0install</a> and <a href="https://github.com/mirage/mirage-vagrant-vms">Vagrant boxes</a>.</li>
<li>a unified way of cloning the source of any package via <code>opam source</code>. This handles any supported OPAM archive, including Git, Mercurial or Darcs remotes.</li>
<li>a richer package metadata, including source code, development archives and bug report URLs.</li>
</ul>
<p>These changes were all incorporated into the <a href="http://opam.ocaml.org/blog/opam-1-2-0-release/">OPAM 1.2</a>, along with backwards compatibility shims to keep the old 1.1 metadata format working until the migration is complete. The 1.2.x series has been a solid and usable development manager, and last week’s release of <a href="http://opam.ocaml.org/blog/opam-1-2-1-release/">OPAM 1.2.1</a> has further polished the core scripting engine.</p>
<h4>Platform Blog</h4>
<p>One of the more notable developments during 2014 was the <a href="http://coq-blog.clarus.me/use-opam-for-coq.html">adoption of
OPAM</a> further up the
ecosystem by the <a href="https://coq.inria.fr/">Coq</a> theorem prover. This
broadening of the community prompted us to create an <a href="http://opam.ocaml.org">official OPAM
blog</a> to give us a central place for new and
tips, and we’ve had posts about
<a href="http://opam.ocaml.org/blog/opam-in-xenserver/">XenServer</a> developments,
the <a href="http://opam.ocaml.org/blog/turn-your-editor-into-an-ocaml-ide/">Merlin IDE
tool</a>
and the modern <a href="http://opam.ocaml.org/blog/about-utop/">UTop</a>
interactive REPL. If you are using OPAM in an interesting or production
capacity, please do <a href="https://github.com/ocaml/platform-blog/issues">get in
touch</a> so that we can
work with you to write about it for the wider community.</p>
<p>The goal of the blog is also to start bringing together the various
components that form the OCaml Platform. These are designed to be
modular tools (so that you can pick and choose which ones are necessary
for your particular use of OCaml). There are more details available from
the OCaml Workshop presentation at ICFP 2014
(<a href="https://ocaml.org/meetings/ocaml/2014/ocaml2014_7.pdf">abstract</a>,
<a href="https://ocaml.org/meetings/ocaml/2014/ocl-platform-2014-slides.pdf">slides</a>,
<a href="https://www.youtube.com/watch?v=jxhtpQ5nJHg&amp;list=UUP9g4dLR7xt6KzCYntNqYcw">video</a>).</p>
<h4>Onboarding New Users</h4>
<p>OPAM has also been adopted now by <a href="http://harvard.edu">several</a>
<a href="http://cornell.edu">big</a> <a href="http://princeton.edu">universities</a>
(including <a href="http://www.cl.cam.ac.uk/teaching/1415/L28/">us at
Cambridge</a>!) for
undergraduate and graduate Computer Science courses. The demands
increased for an out-of-the-box solution that makes it as easy possible
for new users to get started with minimum hassle. We created a
<a href="http://lists.ocaml.org/listinfo/teaching">dedicated teaching list</a> to
aid collaboration, and a list of <a href="http://ocaml.org/learn/teaching-ocaml.html">teaching resources on
ocaml.org</a> and supported
several initiatives in collaboration with <a href="https://github.com/AltGr">Louis
Gesbert</a> at OCamlPro, as usual with OPAM
development).</p>
<p>The easiest way to make things "just work" are via regular binary builds
of the latest releases of OCaml and OPAM on Debian, Ubuntu, CentOS and
Fedora, via <a href="http://launchpad.net/~avsm">Ubuntu PPAs</a> and the <a href="https://build.opensuse.org/package/show/home:ocaml/opam">OpenSUSE
Build Service</a>
repositories. Our industrial collaborators from Citrix, <a href="http://jon.recoil.org">Jon
Ludlam</a> and <a href="http://dave.recoil.org">Dave Scott</a>
began an <a href="http://lists.ocaml.org/pipermail/opam-devel/2015-January/000910.html">upstreaming
initiative</a>
to Fedora and sponsored the creation of a <a href="http://lists.centos.org/pipermail/centos-devel/2014-November/012375.html">CentOS
SIG</a>
to ensure that binary packages remain up-to-date. We also contribute to
the hardworking packagers on MacOS X, Debian, FreeBSD, NetBSD and
OpenBSD where possible as well to ensure that binary builds are well
rounded out. Richard Mortier also assembled <a href="https://github.com/mirage/mirage-vagrant-vms">Vagrant
boxes</a> that contain OCaml,
for use with VirtualBox.</p>
<ul>
<li>Gallery il
<figure class="image-right"><img src="https://anil.recoil.org/images/opam-in-nice.webp" loading="lazy" class="content-image" alt="Louis cooks us dinner in Nice at our OPAM developer summit" srcset="/images/opam-in-nice.320.webp 320w,/images/opam-in-nice.480.webp 480w,/images/opam-in-nice.640.webp 640w,/images/opam-in-nice.768.webp 768w" title="Louis cooks us dinner in Nice at our OPAM developer summit" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Louis cooks us dinner in Nice at our OPAM developer summit</figcaption></figure>
</li>
</ul>
<p>Within OPAM itself, we applied polish to the handling of <a href="https://github.com/ocaml/opam-depext">external
dependencies</a> to automate checking
that the system libraries required by OPAM are present. Two emerging
tools that should help further in 2015 are the
<a href="https://github.com/OCamlPro/opam-user-setup">opam-user-setup</a> and
<a href="https://github.com/ocaml/opam/issues/1035">OPAM-in-a-box</a> plugins that
automate first-time configuration. These last two are primarily
developed at OCamlPro, with design input and support from OCaml Labs.</p>
<p>We do have a lot of work left to do with making the new user experience
really seamless, and help is <em>very</em> welcome from anyone who is
interested. It often helps to get the perspective of a newcomer to find
out where the stumbling blocks are, and we value any such advice. Just
mail <a href="mailto:opam-devel@lists.ocaml.org">opam-devel@lists.ocaml.org</a>
with your thoughts, or <a href="https://github.com/ocaml/opam/issues">create an
issue</a> on how we can improve. A
particularly good example of such an initiative was started by Jordan
Walke, who prototyped <a href="https://github.com/jordwalke/CommonML">CommonML</a>
with a NodeJS-style development workflow, and <a href="http://lists.ocaml.org/pipermail/opam-devel/2015-February/000975.html">wrote
up</a>
his design document for the mailing list. (Your questions or ideas do
not need to be as well developed as Jordan’s prototype!)</p>
<h3>Testing Packages</h3>
<p>The public Travis CI testing does come with some limitations, since it
only checks that the latest package sets install, but not if any
transitive dependencies fail due to interface changes. It also doesn’t
test all the optional dependency combinations due to the 50 minute time
limit.</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/travis-mascot-200px.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>
<p></p>
<p>We expanded the OPAM repository testing in several ways to get around
this:</p>
<ul>
<li>
<p><strong>Individual Repositories:</strong> Thomas Gazagnaire built <a href="http://opam.ocaml.org/blog/opam-1-2-travisci/">centralised
Travis scripts</a> that
can be used on any OCaml GitHub repository to easily test code
before it is released into OPAM. These scripts are sourced from a
central
<a href="https://github.com/ocaml/ocaml-travisci-skeleton">repository</a> and
support external, optional and reverse dependency checking across
multiple revisions of the compiler. For instance, it just needs <a href="https://github.com/mirage/ocaml-cohttp/blob/master/.travis.yml">one
file</a>
to test all the supported permutations of the
<a href="https://github.com/mirage/ocaml-cohttp">CoHTTP</a> library.</p>
</li>
<li>
<p><strong>Bulk Builds</strong>: Damien Doligez and I independently started doing
large-scale bulk builds of the repository to ensure that a single
snapshot of the package repository can automatically build as many
packages as possible. My implementation used the
<a href="http://docker.com">Docker</a> container manager to spawn off 1000s of
package builds in parallel and commit the results into a filesystem
This required building a <a href="http://avsm.github.io/ocaml-dockerfile">Dockerfile
eDSL</a>, and the results are
now online at
<a href="https://opam.ocaml.org/builds">https://opam.ocaml.org/builds</a>.</p>
</li>
<li>
<p><strong>OCamlot</strong>: An ongoing piece of infrastructure work is to take the
bulk build logs (which are around 7GB per daily run), and to store
and render them using our <a href="http://irmin.io">Irmin</a> Git store. Expect
to see more around this soon; it has the awesome feature of letting
any developer clone the build logs for their project locally, to
make triage of foreign operating systems as simple as possible.</p>
</li>
</ul>
<h4>Language Evolution</h4>
<p>This ability to do unattended builds of the package repository has also
improved the decision making process within the core compiler team.
Since we now have a large (3000+ package) corpus of OCaml code, it
became a regular occurrence in the 4.02 development cycle to “<a href="https://anil.recoil.org/2014/04/08/grepping-every-known-ocaml-package-source.html">ask
OPAM</a>”
whether a particular feature or new syntax would break any existing
code. This in turn provides an incentive for commercial users to provide
representative samples of their code; for instance, the Jane Street Core
releases in OPAM (with their very modular style) act as an open-source
canary without needing access to any closed source code.</p>
<p>One good example in 2014 was the decoupling of the
<a href="http://en.wikipedia.org/wiki/Camlp4">Camlp4</a> macro preprocessor from
the main OCaml distribution. Since Camlp4 has been used for over a
decade and there are some very commonly used syntax extensions such as
<a href="https://github.com/janestreet/type_conv">type_conv</a>, a simple removal
would break a lot of packages. We used OPAM to perform a gradual
movement that most users hopefully never noticed by the time OCaml 4.02
was released. First, we added a <a href="https://github.com/ocaml/opam-repository/pull/2558">dummy
package</a> in OPAM for
earlier versions of the compiler that had Camlp4 built-in, and then used
the OPAM constraint engine to compile it as an external tool for the
newer compiler revisions. Then we just had to triage the bulk build logs
to find build failures from packages that were missing a Camlp4
dependency, and <a href="https://github.com/ocaml/opam-repository/pulls?utf8=%E2%9C%93&amp;q=camlp4%20requires%20is:pr%20">add
them</a>
to the package metadata.</p>
<h4>GitHub Integration</h4>
<p>An interesting
<a href="https://twitter.com/vincenthz/status/563108158907097089">comment</a> from
Vincent Hanquez about OPAM is that "OCaml's OPAM is a post-GitHub
design". This is very true, as much of the workflow for pinning <code>git://</code>
URLs emerged out of being early adopters of GitHub for hosting the
MirageOS. OCaml Labs supported two pieces of infrastructure integration
around GitHub in 2014:</p>
<ul>
<li>
<p>OPAM has a compiler switch feature that lets you run simultaneous
OCaml installations and swap between them easily. I used my <a href="https://github.com/avsm/ocaml-github">GitHub
API bindings</a> to regularly
convert every GitHub pull request into a custom compiler
switch (see <a href="https://anil.recoil.org/notes/ocaml-github-and-opam">Easily OPAM switching to any OCaml feature request</a>).
This lets users reporting bugs try out a patched compiler almost
immediately upon a fix becoming available.</p>
</li>
<li>
<p>The motivation behind this feature was our collaborator Gabriel
Scherer’s
<a href="http://gallium.inria.fr/blog/patch-review-on-github/">experiment</a>
to enable patch review of OCaml on GitHub, alongside the venerable
<a href="http://caml.inria.fr/mantis/view_all_bug_page.php">Mantis bug
tracker</a>. We
supported this via adding Travis CI support to the main compiler,
and also helped to migrate a number of support libraries to GitHub,
such as <a href="https://github.com/ocaml/camlp4">camlp4</a>. These can all be
found on the <a href="https://github.com/ocaml">ocaml</a> organisation on
GitHub.</p>
</li>
</ul>
<h3>Codoc Documentation</h3>
<p>Leo White, David Sheets, Amir Chaudhry and Thomas Gazagnaire led the
charge to build a modern documentation generator for OCaml, and
<a href="http://lists.ocaml.org/pipermail/platform/2015-February/000539.html">published</a>
an <em>alpha</em> version of <a href="https://github.com/dsheets/codoc">codoc 0.2.0</a>
after a lot of work throughout 2014. In the 2014 OCaml workshop
presentation
(<a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_7.pdf">abstract</a>,
<a href="http://ocaml.org/meetings/ocaml/2014/ocl-platform-2014-slides.pdf">slides</a>,
<a href="https://www.youtube.com/watch?v=jxhtpQ5nJHg&amp;list=UUP9g4dLR7xt6KzCYntNqYcw">video</a>),
we mentioned the “module wall” for documentation and this attempts to
fix it. To try it out, simply follow the directions in the README on
that repository, or <a href="http://dsheets.github.io/codoc">browse some
samples</a> of the current, default output
of the tool. Please do bear in mind codoc and its constituent libraries
are still under heavy development and are <em>not</em> feature complete, but
we’re gathering <a href="https://github.com/dsheets/codoc/issues">feedback</a> from
early adopters.</p>
<p>codoc's aim is to provide a widely useful set of tools for generating
OCaml documentation. In particular, we are striving to:</p>
<ol>
<li>Cover all of OCaml’s language features</li>
<li>Provide accurate name resolution and linking</li>
<li>Support cross-linking between different packages</li>
<li>Expose interfaces to the components we’ve used to build <code>codoc</code></li>
<li>Provide a magic-free command-line interface to the tool itself</li>
<li>Reduce external dependencies and default integration with other
tools</li>
</ol>
<p>We haven’t yet achieved all of these at all levels of our tool stack but
are getting close, and the patches are all under discussion for
integration into the mainstream OCaml compiler. <code>codoc</code> 0.2.0 is usable
today (if a little rough in some areas like default CSS), and there is a
<a href="http://opam.ocaml.org/blog/codoc-0-2-0-released/">blog post</a> that
outlines the architecture of the new system to make it easier to
understand the design decisions that went into it.</p>
<h3>Community Governance</h3>
<p>As the amount of infrastructure built around the
<a href="http://ocaml.org">ocaml.org</a> domain grows (e.g. mailing lists, file
hosting, bulk building), it is important to establish a governance
framework to ensure that it is being used as best needed by the wider
OCaml community.</p>
<p>Amir Chaudhry took a good look at how other language communities
organise themself, and began putting together a succinct <a href="http://amirchaudhry.com/towards-governance-framework-for-ocamlorg/">governance
framework</a>
to capture how the community around <code>ocaml.org</code> operates, and how to
quickly resolve any conflicts that may arise in the future. He took care
to ensure it had a well-defined scope, is simple and self-contained, and
(crucially) documents the current reality. The result of this work is
circulating privately through all the existing volunteers for a first
round of feedback, and will go live in the next few months as a living
document that explains how our community operates.</p>
<h3>Assemblage</h3>
<p>One consequence of OCaml’s age (close to twenty years old now) is that
the tools built around the compiler have evolved fairly independently.
While OPAM now handles the high-level package management, there is quite
a complex ecosystem of other components that are complex for new users
to get to grips with: <a href="http://github.com/ocaml/oasis">OASIS</a>,
<a href="http://projects.camlcity.org/projects/findlib.html">ocamlfind</a>,
<a href="https://ocaml.org/learn/tutorials/ocamlbuild/">ocamlbuild</a>, and
<a href="https://github.com/the-lambda-church/merlin">Merlin</a> to name a few.
Each of these components (while individually stable) have their own
metadata and namespace formats, further compounding the lack of cohesion
of the tools.</p>
<p>Thomas Gazagnaire and Daniel Buenzli embarked on an effort to build an
eDSL that unifies OCaml package descriptions, with the short-term aim of
generating the support files required by the various support tools, and
the long-term goal of being the integration point for the build, test
and documentation generation lifecycle of an OCaml/OPAM package. This
prototype, dubbed <a href="https://github.com/samoht/assemblage">Assemblage</a> has
gone through several iterations and <a href="https://github.com/samoht/assemblage/labels/design">design
discussions</a> over
the summer of 2014. Daniel has since been splitting out portions of it
into the <a href="http://erratique.ch/software/bos">Bos</a> OS interaction library.</p>
<p>Assemblage is not released officially yet, but we are committed to
resuming work on it this summer when Daniel visits again, with the
intention of unifying much of our workflow through this tool. If you are
interested in build and packaging systems, now is the time to <a href="https://github.com/samoht/assemblage">make your
opinion known</a>!</p>
<h2>Core Compiler</h2>
<p>We also spent time in 2014 working on the core OCaml language and
compiler, with our work primarily led by Jeremy Yallop and Leo White.
These efforts were not looking to make any radical changes in the core
language; instead, we generally opted for evolutionary changes that
either polish rough edges in the language (such as open type and handler
cases), or new features that fit into the ML style of building programs.</p>
<h3>New Features in 4.02.0</h3>
<p>The OCaml 4.02 series was primarily developed and
<a href="https://ocaml.org/releases/4.02.html">released</a> in 2014. The
<a href="http://caml.inria.fr/pub/distrib/ocaml-4.02/notes/Changes">ChangeLog</a>
generated much <a href="https://blogs.janestreet.com/ocaml-4-02-everything-else/">user
excitement</a>,
and we were also pleased to have contributed several language
improvements.</p>
<h4>Handler Cases and exceptional syntax</h4>
<p>OCaml’s <code>try</code> and <code>match</code> constructs are good at dealing with exceptions
and values respectively, but neither constructs can handle both values
and exceptions. Jeremy Yallop investigated <a href="http://ocamllabs.github.io/compiler-hacking/2014/02/04/handler-case.html#match-exception">how to handle
success</a>
more elegantly, and an elegant unified syntax emerged. A simple example
is that of a stream iterator that uses exceptions for control flow:</p>
<pre><code>let rec iter_stream f s =
  match (try Some (MyStream.get s) with End_of_stream -&gt; None) with
  | None -&gt; ()
  | Some (x, s') -&gt; f x; iter_stream f s'
</code></pre>
<p>This code is not only verbose, but it also has to allocate an <code>option</code>
value to ensure that the <code>iter_stream</code> calls remains tail recursive. The
new syntax in OCaml 4.02 allows the above to be rewritten succinctly:</p>
<pre><code>let rec iter_stream f s =
  match MyStream.get s with
  | (x, s') -&gt; f x; iter_stream f s'
  | exception End_of_stream -&gt; ()
</code></pre>
<p>Read more about the background of this feature in Jeremy’s <a href="http://ocamllabs.github.io/compiler-hacking/2014/02/04/handler-case.html#match-exception">blog
post</a>,
the associated discussion in the <a href="http://caml.inria.fr/mantis/view.php?id=6318">upstream Mantis
bug</a>, and the final
<a href="http://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec245">manual
page</a> in
the OCaml 4.02 release. For an example of its use in a real library, see
the Jane Street
<a href="https://github.com/janestreet/sexplib/blob/1bd69553/lib/conv.ml#L213-L215">usage</a>
in the <a href="https://github.com/janestreet/sexplib">s-expression</a> handling
library (which they use widely to reify arbitrary OCaml values and
exceptions).</p>
<h4>Open Extensible Types</h4>
<p>A long-standing trick to build <a href="https://blogs.janestreet.com/rethinking-univ/">universal
containers</a> in OCaml has
been to encode them using the exception <code>exn</code> type. There is a similar
concept of a <a href="http://mlton.org/UniversalType">universal type</a> in
Standard ML, and they were described in the “<a href="http://www.andres-loeh.de/OpenDatatypes.pdf">Open Data Types and Open
Functions</a>” paper by Andres
Löh and Ralf Hinze in 2006.</p>
<p>Leo White designed, implemented and upstreamed support for <a href="http://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec246">extensible
variant
types</a> in
OCaml 4.02. Extensible variant types are variant types that can be
extended with new variant constructors. They can be defined as follows:</p>
<pre><code>type attr = ..

type attr += Str of string

type attr +=
  | Int of int
  | Float of float
</code></pre>
<p>Pattern matching on an extensible variant type requires a default case
to handle unknown variant constructors, just as is required for pattern
matching on exceptions (extensible types use the exception memory
representation at runtime).</p>
<p>With this feature added, the OCaml <code>exn</code> type simply becomes a special
case of open extensible types. Exception constructors can be declared
using the type extension syntax:</p>
<pre><code>    type exn += Exc of int
</code></pre>
<p>You can read more about the discussion behind open extensible types in
the upstream <a href="http://caml.inria.fr/mantis/view.php?id=5584">Mantis bug</a>.
If you’d like to see another example of their use, they have been
adopted by the latest releases of the Jane Street Core libraries in the
<a href="https://github.com/janestreet/core_kernel/blob/43ee3eef/lib/type_equal.ml#L64">Type_equal</a>
module.</p>
<h3>Modular Implicits</h3>
<p>A common criticism of OCaml is its lack of support for ad-hoc
polymorphism. The classic example of this is OCaml’s separate addition
operators for integers (<code>+</code>) and floating-point numbers (<code>+.</code>). Another
example is the need for type-specific printing functions (<code>print_int</code>,
<code>print_string</code>, etc.) rather than a single <code>print</code> function which works
across multiple types.</p>
<p>Taking inspiration from Scala’s
<a href="http://docs.scala-lang.org/tutorials/tour/implicit-parameters.html">implicits</a>
and <a href="http://www.mpi-sws.org/~dreyer/papers/mtc/main-long.pdf">Modular Type
Classes</a> by
Dreyer <em>et al.</em>, Leo White designed a system for ad-hoc polymorphism in
OCaml based on using modules as type-directed implicit parameters. The
design not only supports implicit modules, but also implicit functors
(that is, modules parameterised by other module types) to permit the
expression of generic modular implicits in exactly the same way that
functors are used to build abstract data structures.</p>
<p>Frederic Bour joined us as a summer intern and dove straight into the
implementation, resulting in an <a href="http://andrewray.github.io/iocamljs/modimp_show.html">online
demo</a> and ML
Workshop presentation
(<a href="https://sites.google.com/site/mlworkshoppe/modular-implicits.pdf?attredirects=0">abstract</a>,
<a href="https://www.youtube.com/watch?v=3wVUXTd4WNc">video</a> and
<a href="http://www.lpw25.net/ml2014.pdf">paper</a>). Another innovation in how
we’ve been trialling this feature is the use of Andy Ray’s
<a href="https://andrewray.github.io/iocamljs/">IOCamlJS</a> to publish an
interactive, online notebook that is fully hosted in the browser. You
can follow the examples of modular implicits
<a href="https://andrewray.github.io/iocamljs/modimp_show.html">online</a>, or try
them out on your own computer via an OPAM switch:</p>
<pre><code>opam switch 4.02.0+modular-implicits
eval `opam config env`
opam install utop 
utop
</code></pre>
<p>Some of the early feedback on modular implicits from industrial users
was interesting. Jane Street commented that although this would be a big
usability leap, it would be dangerous to lose control over exactly what
goes into the implicit environment (i.e. the programmer should always
know what <code>(a + b)</code> represents by locally reasoning about the code). The
current design thus follows the ML discipline of maintaining explicit
control over the namespace, with any ambiguities in resolving an
implicit module type resulting in a type error.</p>
<h3>Multicore</h3>
<p>In addition to ad-hoc polymorphism, support for parallel execution on
multicore CPUs is undoubtedly the most common feature request for OCaml.
This has been high on our list after improving tooling support, and
Stephen Dolan and Leo White made solid progress in 2014 on the core
runtime plumbing required.</p>
<p>Stephen initially added <a href="https://github.com/stedolan/ocaml">thread-local
support</a> to the OCaml compiler. This
design avoided the need to make the entire OCaml runtime preemptive (and
thus a huge patch) by allocating thread-local state per core.</p>
<p>We are now deep into the design and implementation of the programming
abstractions built over these low-level primitives. One exciting aspect
of our implementation is much of the scheduling logic for multicore
OCaml can be written in (single-threaded) OCaml, making the design very
flexible with respect to <a href="http://kcsrk.info/papers/mmscc_marc12.pdf">heterogenous
hardware</a> and <a href="http://fable.io">variable IPC
performance</a>.</p>
<p>To get feedback on the overall design of multicore OCaml, we presented
at OCaml 2014
(<a href="http://www.cl.cam.ac.uk/~sd601/papers/multicore_slides.pdf">slides</a>,
<a href="https://www.youtube.com/watch?v=FzmQTC_X5R4">video</a> and
<a href="https://ocaml.org/meetings/ocaml/2014/ocaml2014_1.pdf">abstract</a>), and
Stephen visited INRIA to consult with the development team and Arthur
Chargueraud (the author of
<a href="http://www.chargueraud.org/softs/pasl/">PASL</a>). Towards the end of the
year, <a href="http://kcsrk.info/">KC Sivaramakrishnan</a> finished his PhD studies
at Purdue and joined our OCaml Labs group. He is the author of
<a href="http://multimlton.cs.purdue.edu/mML/Welcome.html">MultiMlton</a>, and is
now driving the completion of the OCaml multicore work along with
Stephen Dolan, Leo White and Mark Shinwell. Stay tuned for updates from
us when there is more to show later this year!</p>
<h3>Ctypes: a Modular Foreign Function Interface</h3>
<p>The <a href="https://github.com/ocamllabs/ocaml-ctypes">Ctypes</a> library started
as an experiment with GADTs by Jeremy Yallop, and has since ballooned in
a robust, comprehensive library for safely interacting with the OCaml
foreign function interface. The first release came out in time to be
included in <a href="https://realworldocaml.org/v1/en/html/foreign-function-interface.html">Real World
OCaml</a>
in lieu of the low-level FFI (which I was not particularly enamoured
with having to explain in a tight page limit).</p>
<p>Throughout 2014, Jeremy expanded support for a number of features
requested by users (both industrial and academic) who adopted the
library in preference to manually writing C code to interface with the
runtime, and issued several updated
<a href="https://github.com/ocamllabs/ocaml-ctypes/releases">releases</a>.</p>
<h4>C Stub Generation</h4>
<p>The first release of Ctypes required the use of
<a href="https://sourceware.org/libffi/">libffi</a> to dynamically load shared
libraries and dynamically construct function call stack frames whenever
a foreign function is called. While this works for simple libraries, it
cannot cover <em>all</em> usecases, since interfacing with C demands an
understanding of <code>struct</code> memory layout, C preprocessor macros, and
other platform-dependent quirks which are more easily dealt with by
invoking a C compiler. Finally, the performance of a <code>libffi</code>-based API
will necessarily be slower than writing direct C stub code.</p>
<p>While many other language FFIs provide separate libraries for dynamic
and static FFI libraries, we decided to have a go at building a
<em>modular</em> version of Ctypes that could handle both cases from a single
description of the foreign function interface. The result (dubbed
“Cmeleon”) remained surprisingly succinct and usable, and now covers
almost every use of the OCaml foreign function interface. We submitted a
paper to <a href="http://icfpconference.org/2015">ICFP 2015</a> dubbed “<a href="https://anil.recoil.org/papers/drafts/2015-cmeleon-icfp-draft1.pdf">A modular
foreign function
interface</a>”
that describes it in detail. Here is a highlight of how simple a generic
binding looks:</p>
<pre><code>module Bindings(F : FOREIGN) = struct
  open F
  let gettimeofday = foreign "gettimeofday"
     (ptr timeval @-&gt; ptr timezone @-&gt; returning int)
end
</code></pre>
<p>The <code>FOREIGN</code> module type completely abstracts the details of whether or
not dynamic or static binding is used, and handles C complexities such
as computing the struct layout on the local machine architecture.</p>
<h4>Inverse Stubs</h4>
<p>The other nice result from functorising the foreign function interface
emerged when we tried to <em>invert</em> the FFI and serve a C interface from
OCaml code (for example, by compiling the OCaml code as a <a href="http://caml.inria.fr/pub/docs/manual-ocaml/intfc.html">shared
library</a>). This
would let us begin swapping out C libraries that we <a href="http://openssl.org">don’t
trust</a> with <a href="https://github.com/mirage/ocaml-tls">safer
equivalents</a> written in OCaml.</p>
<p>You can see an
<a href="https://github.com/yallop/ocaml-ctypes-inverted-stubs-example">example</a>
of how inverted stubs work via a simple C XML parsing exposed from the
<a href="http://erratique.ch/software/xmlm">Xmlm</a> library. We can define a C
<code>struct</code> by:</p>
<pre><code>(* Define a struct of callbacks (C function pointers) *)
let handlers : [`handlers] structure typ = structure "handlers"
let (--) s f = field handlers s (funptr f)
 let on_data      = "on_data"      -- (string @-&gt; returning void)
 let on_start_tag = "on_start_tag" -- (string @-&gt; string @-&gt; returning void)
 let on_end_tag   = "on_end_tag"   -- (void @-&gt; returning void)
 let on_dtd       = "on_dtd"       -- (string @-&gt; returning void) 
 let on_error     = "on_error"     -- (int @-&gt; int @-&gt; string @-&gt; returning void)
let () = seal handlers
</code></pre>
<p>and then expose this via C functions:</p>
<pre><code>module Stubs(I : Cstubs_inverted.INTERNAL) = struct
  (* Expose the type 'struct handlers' to C. *)
  let () = I.structure handlers

  (* We expose just a single function to C.  The first argument is a (pointer
     to a) struct of callbacks, and the second argument is a string
     representing a filename to parse. *)
  let () = I.internal "parse_xml" 
     (ptr handlers @-&gt; string @-&gt; returning void) parse
end
</code></pre>
<p>You can find the full source code to these snippets on the
<a href="https://github.com/yallop/ocaml-ctypes-inverted-stubs-example">ocaml-ctypes-inverted-stubs-example</a>
repository on GitHub.</p>
<p>We’ll be exploring this aspect of Ctypes further in 2015 for SSL/TLS
with David Kaloper and Hannes Mehnert, and Microsoft Research has
generously funded a <a href="http://research.microsoft.com/en-us/collaboration/global/phd_projects2015.aspx">PhD
studentship</a>
to facilitate the work.</p>
<h4>Community Contributions</h4>
<p>Ctypes benefited enormously from several external contributions from the
OCaml community. From a portability perspective, A. Hauptmann
contributed <a href="https://github.com/ocamllabs/ocaml-ctypes/pull/190">Windows
support</a>, and Thomas
Leonard added <a href="https://github.com/ocamllabs/ocaml-ctypes/pull/231">Xen
support</a> to allow
Ctypes bindings to work with <a href="http://openmirage.org">MirageOS
unikernels</a> (which opens up the intriguing
possibility of accessing shared libraries across virtual machine
boundaries in the future). C language support was fleshed out by Edwin
Torok contributing <a href="https://github.com/ocamllabs/ocaml-ctypes/pull/238">typedef
support</a>, Ramkumar
Ramachandra adding <a href="https://github.com/ocamllabs/ocaml-ctypes/pull/220">C99
bools</a> and Peter
Zotov integrating <a href="https://github.com/ocamllabs/ocaml-ctypes/pull/143">native
strings</a>.</p>
<p>The winner of “most enthusiastic use of OCaml Labs code” goes to <a href="https://github.com/braibant">Thomas
Braibant</a> of
<a href="http://cryptosense.com/the-team/">Cryptosense</a>, who used <em>every</em>
feature of the Ctypes library (consider multi-threaded, inverted, staged
and marshalled bindings) in their effort to <a href="http://www.economist.com/news/science-and-technology/21647269-automating-search-loopholes-software-hacking-hackers">hack the
hackers</a>.
David Sheets comes a close second with his implementation of the <a href="https://github.com/dsheets/profuse">FUSE
binary protocol</a>, parameterised by
version quirks.</p>
<p>If you’re using Ctypes, we would love to hear about your particular use.
A search on GitHub and OPAM reveals over 20 projects using it already,
including industrial use at <a href="http://cryptosense.com">Cryptosense</a> and
<a href="http://ocaml.janestreet.com">Jane Street</a>, and ports to Windows, *BSD,
MacOS X and even iPhone and Android. There’s a <a href="https://github.com/ocamllabs/ocaml-ctypes/wiki">getting
started</a> guide, and a
<a href="http://lists.ocaml.org/listinfo/ctypes">mailing list</a> available.</p>
<h2>Community and Teaching Efforts</h2>
<p>In addition to the online community building, we also participated in a
number of conferences and face-to-face events to promote education about
functional programming.</p>
<h3>Conferences and Talks</h3>
<ul>
<li>Gallery ir
<figure class="image-right"><img src="https://anil.recoil.org/images/qcon-unikernel-talk.webp" loading="lazy" class="content-image" alt="Anil speaking at QCon on unikernels" srcset="/images/qcon-unikernel-talk.1024.webp 1024w,/images/qcon-unikernel-talk.320.webp 320w,/images/qcon-unikernel-talk.480.webp 480w,/images/qcon-unikernel-talk.640.webp 640w,/images/qcon-unikernel-talk.768.webp 768w" title="Anil speaking at QCon on unikernels" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Anil speaking at QCon on unikernels</figcaption></figure>
</li>
</ul>
<p>There has been a huge growth in the number of quality conferences in
recent years, making it tough to choose which ones to attend.
<a href="http://icfpconference.org">ICFP</a> is the academic meeting point that
predates most of them, and we <a href="https://anil.recoil.org/2014/08/31/ocaml-labs-at-icfp-2014.html">participated
extensively</a>
in 2014 via talks, tutorials and a
<a href="https://www.youtube.com/watch?v=UEIHfXLMtwA">keynote</a> at the Haskell
Symposium.<br>
I also served on the <a href="http://icfpconference.org/icfp2014/">program
committee</a> and <a href="https://anil.recoil.org/2015/02/18/icfp15-call-for-sponsorships.html">industrial
relations
chair</a>
and took over as the steering committee chair of
<a href="http://cufp.org">CUFP</a>. Jeremy Yallop, Thomas Gazagnaire and Leo White
all served program committees on workshops, with Jeremy also chairing
this year’s ML Workshop.</p>
<p>Outside of academic conferences, we participated in a number of
non-academic conferences such as <a href="https://qconsf.com/">QCon</a>,
<a href="http://oscon.com">OSCON</a>, <a href="http://ccc.de">CCC</a>, <a href="https://operatingsystems.io/">New Directions in
OS</a>,
<a href="http://functionalconf.com">FunctionalConf</a>,
<a href="https://skillsmatter.com/conferences/1819-functional-programming-exchange">FPX</a>
and <a href="https://fosdem.org/2014/">FOSDEM</a>. The vast majority of these talks
were about the MirageOS, and slides can be found at
<a href="http://decks.openmirage.org">decks.openmirage.org</a>.</p>
<h4>The 2048 Browser Game</h4>
<p>Yaron Minsky and I have run OCaml tutorials for ICFP for
<a href="http://cufp.org/2011/t3-building-functional-os.html">a</a>
<a href="http://cufp.org/2013/t2-yaron-minsky-anil-madhavapeddy-ocaml-tutorial.html">few</a>
<a href="http://cufp.org/2012/t1-real-world-ocaml-anil-madhavapeddy-university-c.html">years</a>,
and we finally hung up our boots in favour of a new crowd.</p>
<p>Jeremy Yallop and Leo White stepped up to the mark with their ICFP/CUFP
2014 <a href="http://cufp.org/2014/t7-leo-white-introduction-to-ocaml.html">Introduction to
OCaml</a>
tutorial, which had the additional twist of being taught entirely in a
web browser by virtue of using the
<a href="http://ocsigen.org/js_of_ocaml">js_of_ocaml</a> and
<a href="http://andrewray.github.io/iocamljs/">IOCamlJS</a>. They decided that a
good practical target was the popular
<a href="http://gabrielecirulli.github.io/2048/">2048</a> game that has wasted many
programmer hours here at OCaml Labs. They <a href="https://github.com/ocamllabs/2048-tutorial">hacked on
it</a> over the summertime,
assisted by our visitor Daniel Buenzli who also released useful
libraries such as <a href="http://erratique.ch/software/vg">Vg</a>,
<a href="http://erratique.ch/software/react">React</a>,
<a href="http://erratique.ch/software/useri">Useri</a>, and
<a href="http://erratique.ch/software/gg">Gg</a>.</p>
<p>The end result is satisfyingly <a href="http://ocamllabs.github.io/2048-tutorial/">playable
online</a>, with the source code
available at
<a href="https://github.com/ocamllabs/2048-tutorial">ocamllabs/2048-tutorial</a>.</p>
<p>Thomas Gazagnaire got invited to Bangalore for <a href="http://functionalconf.com/">Functional
Conf</a> later in the year, and he extended the
<a href="http://gazagnaire.org/fuconf14/">interactive tutorial notebook</a> and
also ran an OCaml tutorial to a packed room. We were very happy to
support the first functional programming conference in India, and hope
to see many more such events spring up! Amir Chaudhry then went to
Belgium to <a href="https://fosdem.org/2015/">FOSDEM 2015</a> where he showed off
<a href="http://amirchaudhry.com/unikernel-arm-demo-fosdem/">the 2048 game running as an ARM
unikernel</a> to a
crowd of attendees at the Xen booth.</p>
<ul>
<li>Gallery
<figure class="image-right"><img src="https://anil.recoil.org/images/l23.webp" loading="lazy" class="content-image" alt="Jeremy Yallop giving the L23 course at Cambridge" srcset="/images/l23.320.webp 320w,/images/l23.480.webp 480w,/images/l23.640.webp 640w,/images/l23.768.webp 768w" title="Jeremy Yallop giving the L23 course at Cambridge" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Jeremy Yallop giving the L23 course at Cambridge</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/compiler-hacking-dsyme.webp" loading="lazy" class="content-image" alt="Compiling hacking with Don Syme" srcset="/images/compiler-hacking-dsyme.1024.webp 1024w,/images/compiler-hacking-dsyme.320.webp 320w,/images/compiler-hacking-dsyme.480.webp 480w,/images/compiler-hacking-dsyme.640.webp 640w,/images/compiler-hacking-dsyme.768.webp 768w" title="Compiling hacking with Don Syme" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Compiling hacking with Don Syme</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/jeremy-rwo.webp" loading="lazy" class="content-image" alt="Finding a copy of Real World OCaml in Foyles!" srcset="/images/jeremy-rwo.320.webp 320w,/images/jeremy-rwo.480.webp 480w,/images/jeremy-rwo.640.webp 640w,/images/jeremy-rwo.768.webp 768w" title="Finding a copy of Real World OCaml in Foyles!" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Finding a copy of Real World OCaml in Foyles!</figcaption></figure>
</li>
</ul>
<h3>Graduate Teaching</h3>
<p><a href="https://www.cst.cam.ac.uk/people/jdy22" class="contact">Jeremy Yallop</a> and <a href="https://github.com/lpw25" class="contact">Leo White</a> (with assistance from <a href="https://www.cl.cam.ac.uk/~am21/" class="contact">Alan Mycroft</a> and
myself) also led the design of a new graduate course on <a href="http://www.cl.cam.ac.uk/teaching/1415/L28/">Advanced
Functional Programming</a> at
the Computer Laboratory. This ran in the <a href="http://en.wikipedia.org/wiki/Lent_term">Lent
Term</a> and was over-subscribed by
three times the number who pre-registered (due to a number of PhD
students and our collaborators from <a href="http://citrix.com">Citrix</a> also
attending).</p>
<p>The course materials are <a href="http://www.cl.cam.ac.uk/teaching/1415/L28/materials.html">freely available
online</a> and
cover the theory behind functional programming, and then move onto type
inference, abstraction and parametricity, GADTs, rows, monads, and
staging. We will be running this again in future years, and the lecture
materials are already proving useful to <a href="https://sympa.inria.fr/sympa/arc/caml-list/2015-04/msg00001.html">answer mailing list
questions</a>.</p>
<h3>Mentoring Beginners</h3>
<p>We also had the pleasure of mentoring up-and-coming functional
programmers via several outreach programs, both face-to-face and remote.</p>
<h4>Cambridge Compiler Hacking</h4>
<p>We started the <a href="http://ocamllabs.github.io/compiler-hacking/">Cambridge Compiler
Hacking</a> sessions in a
small way towards the end of 2013 in order to provide a local, friendly
place to assist people who wanted to dip their toes into the
unnecessarily mysterious world of programming language hacking. The plan
was simple: provide drinks, pizza, network and a <a href="https://github.com/ocamllabs/compiler-hacking/wiki">bug list of varying
difficulty</a> for
attendees to choose from and work on for the evening, with mentoring
from the experienced OCaml contributors.</p>
<p>We continued this bi-monthly tradition in 2014, with a regular
attendance of 15-30 people, and even cross-pollinated communities with
our local F# and Haskell colleagues. We rotated locations from the
Cambridge Computer Laboratory to Citrix, Makespace, and the new
Cambridge Postdoc Centre. We posted some
<a href="http://ocamllabs.github.io/compiler-hacking/2014/06/24/highlights-from-recent-sessions.html">highlights</a>
from sessions towards the start of the year, and are very happy with how
it’s going. There has even been uptake of the bug list across the water
in France, thanks to Gabriel Scherer.</p>
<p>In 2015, we’d like to branch out further and host some sessions in
London. If you have a suggestion for a venue or theme, please <a href="http://lists.ocaml.org/listinfo/cam-compiler-hacking">get in
touch</a>!</p>
<h4>Summer Programs</h4>
<p>There has been a laudable rise in summer programs designed to encourage
diversity in our community, and we of course leap at the opportunity to
participate in these when we find them.</p>
<ul>
<li>The <a href="https://gnome.org/opw/">GNOME Outreach Program</a> (now also known
as <a href="https://www.gnome.org/outreachy/">Outreachy</a>) had one funded
place for Xen and MirageOS. <a href="http://www.somerandomidiot.com/">Mindy
Preston</a> did a spectacular <a href="http://www.somerandomidiot.com/blog/categories/ocaml/">blog
series</a> about
her experiences and motivations behind learning OCaml.</li>
<li>The <a href="https://www.google-melange.com/">Google Summer of Code 2014</a>
also had us
<a href="http://openmirage.org/blog/applying-for-gsoc2014">participating</a>
via MirageOS, and <a href="https://github.com/moonlightdrive">Jyotsna
Prakash</a> took on the challenging
job of building OCaml bindings for Amazon EC2, also detailed on <a href="https://1000hippos.wordpress.com/">her
blog</a>.</li>
<li>Amir Chaudhry began the <a href="https://github.com/mirage/mirage-www/wiki/Pioneer-Projects">Mirage Pioneer
Projects</a>
initiative to give beginners an easier onramp, and this has taken
off very effectively as a way to advertise interesting projects for
beginners at varying levels of difficulties.</li>
</ul>
<p>Our own students also had the chance to participate in such workshops to
get out of Cambridge in the summer! <a href="http://hh360.user.srcf.net/blog/">Heidi
Howard</a> liveblogged her experiences at
the
<a href="http://www.syslog.cl.cam.ac.uk/2015/01/14/programming-languages-mentoring-workshop-plmw/">PLMW</a>
workshop in Mumbai. Meanwhile, <a href="https://github.com/dsheets">David
Sheets</a> got to travel to the slightly less
exotic London to <a href="http://www.syslog.cl.cam.ac.uk/2014/11/25/new-directions-in-operating-systems/">liveblog
OSIO</a>,
and Leonhard Markert covered <a href="http://www.syslog.cl.cam.ac.uk/2014/09/05/ocaml-2014/">ICFP
2014</a> as a
student volunteer.</p>
<h3>Blogging and Online Activities</h3>
<p>Our <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/blogs/">blog roll</a>
maintains the ongoing stream of activity from the OCaml Labs crew, but
there were some particular highlights throughout 2014.</p>
<ul>
<li><a href="http://roscidus.com/blog/">Thomas Leonard</a> began writing about his
experiences with switching his <a href="http://0install.net">0install</a>
installation system from <a href="http://roscidus.com/blog/blog/2014/06/06/python-to-ocaml-retrospective/">Python to
OCaml</a>
and <a href="http://roscidus.com/blog/blog/2014/02/13/ocaml-what-you-gain/">what you gain with
OCaml</a>.
This series led to a bunch of interesting feedback on social
networking sites, and Thomas joined the group full-time to work on
our research into
<a href="http://roscidus.com/blog/blog/2015/01/21/securing-the-unikernel/">unikernels</a>.</li>
<li><a href="http://www.skjegstad.com/">Magnus Skjegstad</a> returned from Norway
to Cambridge to work on MirageOS, and came up with some <a href="http://www.skjegstad.com/blog/2015/03/25/mirageos-vm-per-url-experiment/">crazy
experiements</a>,
as well as helping to build <a href="http://www.skjegstad.com/blog/2015/01/19/mirageos-xen-virtualbox/">Vagrant
images</a>
of the OCaml development environment.</li>
<li><a href="http://amirchaudhry.com">Amir Chaudhry</a> began his quest to <a href="http://amirchaudhry.com/writing-planet-in-pure-ocaml/">port
his website</a>
website to a <a href="http://amirchaudhry.com/from-jekyll-to-unikernel-in-fifty-lines/">Jekyll
unikernel</a>.</li>
<li>The <a href="http://openmirage.org/blog/announcing-mirage-20-release">Mirage 2.0
release</a> in
the summer of 2014 saw a slew of blogs posts about the
<a href="http://openmirage.org/blog/2014-in-review">surge</a> in MirageOS
activity.</li>
</ul>
<p>It wasn’t all just blogging though, and Jeremy Yallop and Leo White in
particular participated in some epic OCaml <a href="http://caml.inria.fr/mantis/view.php?id=5528">bug
threads</a> about new
features, and
<a href="https://sympa.inria.fr/sympa/arc/caml-list/2015-02/msg00150.html">explanations</a>
about OCaml semantics on the mailing list.</p>
<p>Amir Chaudhry also continued to curate and develop the content on the
<a href="http://ocaml.org">ocaml.org</a> website with our external collaborators
<a href="https://anil.recoil.org/news.xml">Ashish Agarwal</a>, <a href="https://anil.recoil.org/news.xml">Christophe Troestler</a> and <a href="https://anil.recoil.org/news.xml">Phillippe Wang</a>.
Notably, it is now the recommended site for OCaml (with the <a href="http://caml.inria.fr">INRIA
site</a> being infrequently updated), and also hosts
the <a href="https://ocaml.org/meetings/">ACM OCaml Workshop</a> pages. One
addition that highlighted the userbase of OCaml in the teaching
community came from building a <a href="https://ocaml.org/learn/teaching-ocaml.html">map of all of the
universities</a> where the
language is taught, and this was Yan Shvartzshnaider’s <a href="http://yansnotes.blogspot.co.uk/2014/11/good-news-everyone-ocamlorg-teaching.html">first
contribution</a>
to the site.</p>
<h3>Visitors and Interns</h3>
<ul>
<li>Gallery ir
<figure class="image-right"><img src="https://anil.recoil.org/images/ocl-pub.webp" loading="lazy" class="content-image" alt="Down at the pub with the gang!" srcset="/images/ocl-pub.320.webp 320w,/images/ocl-pub.480.webp 480w,/images/ocl-pub.640.webp 640w,/images/ocl-pub.768.webp 768w" title="Down at the pub with the gang!" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Down at the pub with the gang!</figcaption></figure>
</li>
</ul>
<p>Finally, a really important part of any community is hanging out with
each other to chat over ideas in a friendly environment. As usual, we
had a very steady stream of visitors and interns throughout 2014 to
facilitate this.</p>
<p>Frederic Bour, Benjamin Farinier and Matthieu Journault joined us as
summer interns from their respective universities in France as part of
their Masters programs. Frederic worked on modular implicits and <a href="https://www.irill.org/videos/oups-december-2014/Modular_implicits">gave a
great
talk</a>
at the OCaml Users group. Benjamin and Matthieu worked on Irmin data
structures and complexity (and
<a href="https://github.com/mirage/merge-queues">merge-queues</a> and
<a href="https://github.com/mirage/merge-ropes">merge-ropes</a>), and Benjamin had
his paper on “<a href="https://anil.recoil.org/papers/2015-jfla-irmin.pdf">Mergeable Persistent Data
Structures</a>” accepted
to <a href="http://jfla.inria.fr/2015/">JFLA 2015</a>, while Matthieu’s work on
efficient algorithms for synchronising Irmin DAGs is being integrated
into the upstream source code.</p>
<p>Daniel Buenzli repeated his visit from 2013 and spent a productive
summer with us, commenting on almost every project we’re working on. In
his own words (edited for brevity):</p>
<blockquote>
<p>I started by implementing and releasing
<a href="http://erratique.ch/software/uucp">Uucp</a>, a library to provide
efficient access to a selection of the properties of the latest
Unicode Character database (UCD). […] As a side effect of the previous
point I took time to write an absolute <a href="http://erratique.ch/software/uucp/doc/Uucp.html#uminimal">minimal introduction to
Unicode</a>.
[…] Since I was in this Unicode business I took the opportunity to
propose a <a href="https://github.com/ocaml/ocaml/pull/80">31 loc patch to the standard
library</a> for a type to
represent Unicode scalar values (an Unicode character to be imprecise)
to improve interoperability.</p>
<p>The usual yearly update to OpenGL was announced at the Siggraph
conference. This prompted me to update the ctypes-based <a href="http://erratique.ch/software/tgls">tgls
library</a> for supporting the latest
entry point of OpenGL 4.5 and OpenGL ES 3.1. Since the bindings are
automatically generated from the OpenGL XML registry the work is not
too involved but there’s always the odd function signature you
don’t/can’t handle automatically yet.</p>
<p>Spend quite a bit (too much) time on
<a href="http://erratique.ch/software/useri">useri</a>, a small multi-platform
abstraction for setting up a drawing surface and gather user input
(<em>not</em> usury) as <a href="http://erratique.ch/software/react">React</a> events.
Useri started this winter as a layer on top of SDL to implement a <a href="http://erratique.ch/log/2014-05-18">CT
scan app</a> and it felt like this
could be the basis for adding interactivity and animation to Vg/Vz
visualizations – js viz libraries simply rely on the support provided
by the browser or SVG support but Vg/Vz strives for backend
independence and clear separations of concern (up to which limit
remains an open question). Unfortunately I couldn’t bring it to a
release and got a little bit lost in browser compatibility issues and
trying to reconcile what browser and SDL give us in terms of
functionality and way of operating, so that a maximum of client code
can be shared among the supported platforms. But despite this
non-release it still managed to be useful in some way, see the next
point.</p>
<p>Helped Jeremy and Leo to implement the rendering and interaction for
their ICFP tutorial <a href="https://github.com/ocamllabs/2048-tutorial">2048 js_of_ocaml
implementation</a>. This
featured the use of Gg, Vg, Useri and React and I was quite pleased
with the result (despite some performance problems in certain
browsers, but hey composable rendering and animation without a single
assignement in client code). It’s nice to see that all these pains at
trying to design good APIs eventually fit together […]</p>
</blockquote>
<p>A couple of visitors joined us from sunny
<a href="http://github.com/mirleft">Morocco</a>, where Hannes Mehnert and David
Kaloper had gone to work on a clean-slate TLS stack. They found the
<a href="http://openmirage.org">MirageOS</a> effort online, and got in touch about
visiting. After a very fun summer of hacking, their stack is now the
standard TLS option in MirageOS and resulted in the <a href="http://amirchaudhry.com/bitcoin-pinata/">Bitcoin Pinata
challenge</a> being issued! Hannes
and David have since moved to Cambridge to work on this stack full-time
in 2015, but the internships served as a great way for everyone to get
to know each other.</p>
<p>We also had the pleasure of visits from several of our usually remote
collaborators. <a href="https://github.com/Chris00">Christophe Troestler</a>,
<a href="http://ocaml.janestreet.com">Yaron Minsky</a>, <a href="http://github.com/diml">Jeremie
Diminio</a> and <a href="https://github.com/andrewray">Andy
Ray</a> all visited for the annual OCaml Labs
<a href="https://gist.github.com/avsm/18450004ae19c2facf7a">review meeting</a> in
Christ’s College. There were also many academic talks from foreign
visitors in our <a href="http://talks.cam.ac.uk/show/archive/8316">SRG seminar
series</a>, ranging from <a href="http://www.cse.iitb.ac.in/~uday/">Uday
Khedkar</a> from IIT to <a href="http://okmij.org/ftp/">Oleg
Kiselyov</a> deliver multiple talks on staging and
optimisation (as well as making a celebrity appearance at the compiler
hacking session, and <a href="http://ocaml.janestreet.com">Yaron Minsky</a>
delivering an Emacs-driven departmental seminar on his experiences with
<a href="http://talks.cam.ac.uk/talk/index/51144">Incremental</a> computation.</p>
<h2>Research Efforts</h2>
<p>The OCaml Labs are of course based in the Cambridge Computer Laboratory,
where our day job is to do academic research. Balancing the demands of
open source coding, community efforts and top-tier research has be a
tricky one, but an effort that has been worthwhile.</p>
<ul>
<li>Gallery
<figure class="image-right"><img src="https://anil.recoil.org/images/christs-dinner.webp" loading="lazy" class="content-image" alt="Dinner at Christ's College" srcset="/images/christs-dinner.1024.webp 1024w,/images/christs-dinner.1280.webp 1280w,/images/christs-dinner.1440.webp 1440w,/images/christs-dinner.1600.webp 1600w,/images/christs-dinner.1920.webp 1920w,/images/christs-dinner.320.webp 320w,/images/christs-dinner.480.webp 480w,/images/christs-dinner.640.webp 640w,/images/christs-dinner.768.webp 768w" title="Dinner at Christ's College" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Dinner at Christ's College</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/nsdi-deadline.webp" loading="lazy" class="content-image" alt="Hacking to the clock for the NSDI deadline" srcset="/images/nsdi-deadline.320.webp 320w,/images/nsdi-deadline.480.webp 480w,/images/nsdi-deadline.640.webp 640w,/images/nsdi-deadline.768.webp 768w" title="Hacking to the clock for the NSDI deadline" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Hacking to the clock for the NSDI deadline</figcaption></figure>

<figure class="image-right"><img src="https://anil.recoil.org/images/scotty.webp" loading="lazy" class="content-image" alt="Dave enters the glass filled future" srcset="/images/scotty.320.webp 320w,/images/scotty.480.webp 480w,/images/scotty.640.webp 640w" title="Dave enters the glass filled future" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Dave enters the glass filled future</figcaption></figure>
</li>
</ul>
<p>Our research efforts are broadly unchanged <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/news/index.html#Dec%202013">from
2013</a>
(it takes time to craft good ideas!), and this will not be an exhaustive
recap. Instead, we’ll summarise them here and point to our
<a href="http://www.cl.cam.ac.uk/projects/ocamllabs/papers/index.html">papers</a>
that describe the work in detail.</p>
<ul>
<li>
<p>The <a href="http://openmirage.org">MirageOS</a> really found its own feet in
2014, with a <a href="http://openmirage.org/blog/announcing-mirage-20-release">summer 2.0
release</a>
and an extensive <a href="http://openmirage.org/blog/2014-in-review">end-of-year
recap</a>. The most notable
thing has been how well the MirageOS research work has melded with
the core OCaml Labs efforts, since much of it has been constructing
good quality OCaml libraries to plug holes in the ecosystem. It also
served to make us use OPAM on a day-to-day basis for our own work,
thus creating an effective feedback loop between open-source and
research.</p>
</li>
<li>
<p>In the <a href="http://trilogy2.it.uc3m.es/">Trilogy2</a> and
<a href="http://usercentricnetworking.eu/">UCN</a> EU projects, we built out
MirageOS features such as the
<a href="https://anil.recoil.org/papers/2015-nsdi-jitsu.pdf">Jitsu</a> toolstack
for the “just-in-time” summoning of unikernels in response to DNS
requests. This paper will be presented next month at UlSENIX
<a href="https://www.usenix.org/conference/nsdi15/">NSDI</a>. It also drove the
development of the <a href="http://openmirage.org/blog/introducing-xen-minios-arm">ARMv7
port</a>, an
architecture for which OCaml has an excellent native code generator,
as well as more experimental forays into <a href="http://arxiv.org/abs/1412.4638">BitCoin incentive
schemes</a> for distributed systems.</p>
</li>
<li>
<p>The <a href="http://irmin.io">Irmin</a> Git-like branchable store created by
Thomas Gazagnaire matured, with Dave Scott
<a href="https://www.youtube.com/watch?v=DSzvFwIVm5s">prototyping</a> a complex
port of the <a href="http://wiki.xen.org/wiki/XenStore">XenStore</a> database
to Irmin, thus letting us show off <a href="http://decks.openmirage.org/xendevsummit14#/">debugging systems with
Git</a>. We had a paper
accepted on some early datastructures accepted at
<a href="https://anil.recoil.org/papers/2015-jfla-irmin.pdf">JFLA</a>, and
Thomas Leonard is building the JavaScript backend for running
in-browser, while Yan Schvartzshnaider is experimenting with <a href="http://yansnotes.blogspot.co.uk/2015/01/work-summary-ocaml-labs.html">graph
processing</a>
over the DAG representation for privacy-friendly queries. KC is
investigating how to adapt his PLDI 2015 paper on
<a href="http://kcsrk.info/papers/quelea_pldi15.pdf">Quelea</a> into using
Irmin as a backend as well.</p>
</li>
<li>
<p>The <a href="https://github.com/ocamllabs/higher">Higher</a> kinded
polymorphism library written by Jeremy Yallop and Leo White was
published in <a href="http://www.lpw25.net/flops2014.pdf">FLOPS 2014</a>,
forming a basis for building more complex use-cases that need the
flexibility of higher kinded types without requiring functorising
code.</p>
</li>
</ul>
<p>Our long standing research into <a href="http://nymote.org">personal online
privacy</a> led to our next system target that uses
unikernels: the <a href="http://arxiv.org/abs/1501.04737">Databox</a> paper
outlines the architecture, and was covered in the
<a href="http://www.theguardian.com/technology/2015/feb/01/control-personal-data-databox-end-user-agreement">Guardian</a>
newspaper. Jon Crowcroft led the establishment of the Cambridge wing of
the <a href="http://www.mccrc.eu/about-us">Microsoft Cloud Computing Research
Center</a> to consider the legal aspect of
things, and so we have made forays outside of technology into
considering the implications of <a href="http://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-863.pdf">region-specific
clouds</a> as well.</p>
<p>Some of the most exciting work done in the group as part of the
<a href="http://rems.io">REMS</a> and <a href="http://www.naas-project.org/">NaaS</a> projects
came towards the end of 2014 and start of 2015, with multiple
submissions going into top conferences. Unfortunately, due to most of
them being double blind reviewed, we cannot link to the papers yet. Keep
an eye on the blog and <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/papers/index.html">published paper
set</a>, or
ask us directly about what’s been going on!</p>
<h2>Priorities for 2015</h2>
<p>As spring breaks and the weather (almost) becomes bearable again, we’re
setting our work priorities for the remainder of the year.</p>
<ul>
<li>
<p><strong>Tooling Cohesion</strong>: The entire core team is focussed on fusing
together the individual tools that have been created last year into
a cohesive OCaml Platform release that covers the lifecycle of
documentation, testing and build. This is being managed by Amir
Chaudhry. OPAM remains at the heart of this strategy, and Louis
Gesbert and Thomas Gazagnaire have settled on the <a href="https://github.com/ocaml/opam/wiki/1.3-Roadmap">OPAM 1.3
roadmap</a>
(<a href="http://lists.ocaml.org/pipermail/opam-devel/2015-February/000940.html">summary</a>).</p>
</li>
<li>
<p><strong>Multicore</strong>: <a href="https://anil.recoil.org/kcsrk.info">KC Sivaramakrishnan</a> has joined the core
OCaml Labs fulltime to drive the multicore work into a publically
testable form. Leo White recently departed after many productive
years in Cambridge to head into a career in industry (but still
remains very much involved with OCaml development!).</p>
</li>
<li>
<p><strong>Language Evolution</strong>: Jeremy Yallop continues to drive our efforts
on staged programming, modular implicits, and a macro system for
OCaml, all of which are key features that make building complex,
reliable systems more tractable than ever.</p>
</li>
</ul>
<p>I’d like to thank the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/people/index.html">entire
team</a> and
wider community for a wonderfully enjoyable 2014 and start of 2015, and
am very thankful to the funding and support from Jane Street, Citrix,
British Telecom, RCUK, EPSRC, DARPA and the EU FP7 that made it all
possible. As always, please feel free to contact any of us directly with
questions, or reach out to me <a href="mailto:avsm2@cl.cam.ac.uk">personally</a>
with any queries, concerns or bars of chocolate as encouragement.</p>

