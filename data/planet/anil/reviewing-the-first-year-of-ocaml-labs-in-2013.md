---
title: Reviewing the first year of OCaml Labs in 2013
description: Reviewing OCaml Labs' first year, including progress on OPAM, the compiler,
  and community efforts.
url: https://anil.recoil.org/notes/the-year-in-ocamllabs
date: 2013-12-29T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>This time last year in 2012, I had just
<a href="https://anil.recoil.org/2012/10/19/announcing-ocaml-labs.html">announced</a>
the formation of a new group called <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml
Labs</a> in the <a href="http://www.cl.cam.ac.uk">Cambridge
Computer Lab</a> that would combine research and
community work towards the practical application of functional
programming. An incredible year has absolutely flown by, and I’ve put
together this post to summarise what’s gone on, and point to our future
directions for 2014.</p>
<p>The theme of our group was not to be pure research, but rather a hybrid
group that would take on some of the load of day-to-day OCaml
maintenance from <a href="http://caml.inria.fr">INRIA</a>, as well as help grow the
wider OCaml community. To this end, all of our projects have been highly
collaborative, often involving colleagues from
<a href="http://ocamlpro.com">OCamlPro</a>, <a href="http://gallium.inria.fr/">INRIA</a>,
<a href="http://janestreet.com">Jane Street</a>, <a href="http://www.lexifi.com/">Lexifi</a>
and <a href="http://citrix.com">Citrix</a>.</p>
<p>This post covers progress in <a href="https://anil.recoil.org/news.xml#tooling">tooling</a>, the <a href="https://anil.recoil.org/news.xml#core_compiler">compiler and
language</a>, <a href="https://anil.recoil.org/news.xml#community_efforts">community efforts</a>,
<a href="https://anil.recoil.org/news.xml#research_projects">research projects</a> and concludes with our
<a href="https://anil.recoil.org/news.xml#priorities_for_2014">priorities for 2014</a>.</p>
<h2>Tooling</h2>
<p>At the start of 2013, OCaml was in the interesting position of being a
mature decades-old language with a small, loyal community of industrial
users who built mission critical applications using it. We had the
opportunity to sit down with many of them at the <a href="http://caml.inria.fr/consortium/">OCaml
Consortium</a> meeting and prioritise
where we started work. The answer came back clearly: while the compiler
itself is legendary for its stability, the tooling around it (such as
package management) was a pressing problem.</p>
<h3>OPAM</h3>
<p>Our solution to this tooling was centered around the
<a href="http://opam.ocaml.org">OPAM</a> package manager that
<a href="http://ocamlpro.com">OCamlPro</a> released into beta just at the end of
2012, and had its first stable release in March 2013. OPAM differs from
most system package managers by emphasising a flexible distributed
workflow that uses version constraints to ensure incompatible libraries
aren’t mixed up (important for the statically-typed OCaml that is very
careful about dependencies). Working closely with
<a href="http://ocamlpro.com">OCamlPro</a> we developed a git-based workflow to
make it possible for users (both individual or industrial) to easily
build up their own package repositories and redistribute OCaml code, and
started curating the <a href="https://github.com/ocaml/opam-repository">package
repository</a>.</p>
<p>The results have been satisfying: we started with an initial set of
around 100 packages in OPAM (mostly imported by the 4 developers), and
ended 2013 with 587 unique packages and 2000 individual versions, with
contributions from 160 individuals. We now have a curated <a href="https://github.com/ocaml/opam-repository">central
package repository</a> for anyone
to submit their OCaml code, several third-party remotes are maintained
(e.g. the <a href="https://github.com/xapi-project/opam-repo-dev">Xen Project</a>
and <a href="https://github.com/ocsigen/opam-ocsigen">Ocsigen</a>). We also
regularly receive releases of the <a href="http://ocaml.janestreet.com">Core</a>
libraries from Jane Street, and updates from sources as varied as
<a href="https://github.com/ocaml/opam-repository/pull/1300">Facebook</a>,
<a href="https://anil.recoil.org/2013/09/16/camlpdf-the-end-of-sucky-pdf-tools.html">Coherent
PDF</a>,
to the <a href="http://ocaml.org/meetings/ocaml/2013/slides/guha.pdf">Frenetic
SDN</a> research.</p>
<p><img src="https://anil.recoil.org/images/opam11-contributors-dec13.webp" loading="lazy" class="content-image" alt="" srcset="/images/opam11-contributors-dec13.320.webp 320w,/images/opam11-contributors-dec13.480.webp 480w,/images/opam11-contributors-dec13.640.webp 640w,/images/opam11-contributors-dec13.768.webp 768w" title="Number of unique contributors to the central OPAM package repository" sizes="(max-width: 768px) 100vw, 33vw">


<img src="https://anil.recoil.org/images/opam11-packages-dec13.webp" loading="lazy" class="content-image" alt="" srcset="/images/opam11-packages-dec13.320.webp 320w,/images/opam11-packages-dec13.480.webp 480w,/images/opam11-packages-dec13.640.webp 640w,/images/opam11-packages-dec13.768.webp 768w" title="Total number of unique packages (including multiple versions of the same package)" sizes="(max-width: 768px) 100vw, 33vw">


<img src="https://anil.recoil.org/images/opam11-unique-packages-dec13.webp" loading="lazy" class="content-image" alt="" srcset="/images/opam11-unique-packages-dec13.320.webp 320w,/images/opam11-unique-packages-dec13.480.webp 480w,/images/opam11-unique-packages-dec13.640.webp 640w,/images/opam11-unique-packages-dec13.768.webp 768w" title="Total packages with multiple versions coalesced so you can see new package growth" sizes="(max-width: 768px) 100vw, 33vw">

</p>
<p>A notable contribution from OCamlPro during this time was to
<a href="https://github.com/ocaml/opam-repository/issues/955">clarify</a> the
licensing on the package repository to be the liberal
<a href="http://creativecommons.org/choose/zero/">CC0</a>, and also to pass
ownership to the <a href="http://github.com/ocaml">OCaml</a> organization on
GitHub, where it’s now jointly maintained by OCaml Labs, OCamlPro and
anyone else that wishes to contribute.</p>
<h3>A lens into global OCaml code</h3>
<p>It’s been quite interesting just watching all the varied code fly into
the repository, but stability quickly became a concern as the new
packages piled up. OCaml compiles to native code on not just x86, but
also PowerPC, Sparc and
<a href="https://anil.recoil.org/2012/02/25/dreamplug-debian-and-ocaml.html">ARM</a>
CPUs. We kicked off various efforts into automated testing: firstly
<a href="https://github.com/dsheets">David Sheets</a> built the
<a href="https://github.com/ocaml/v2.ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/ocamlot.pdf">OCamlot</a>
daemon that would schedule builds across all the exotic hardware. Later
in the year, the <a href="http://travis-ci.org">Travis</a> service launched support
for testing from GitHub pull requests, and this became the front line of
<a href="https://web.archive.org/web/20181114154831/https://anil.recoil.org/2013/09/30/travis-and-ocaml.html">automated
checking</a> for
all incoming new packages to OPAM.</p>
<p>A major headache with automated testing is usually setting up the right
build environment with external library dependencies, and so we <a href="https://anil.recoil.org/2013/11/15/docker-and-opam.html">added
Docker support</a>
to make it easier to bulk-build packages for local developer use, with
the results of builds available
<a href="https://github.com/avsm/opam-bulk-logs">publically</a> for anyone to help
triage. Unfortunately fixing the bugs themselves is still a <a href="https://github.com/ocaml/opam-repository/issues/1304">very manual
process</a>, so more
volunteers are always welcome to help out!</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/travis-mascot-200px.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

We’re going to be really seeing the rewards from all this effort as
OCaml 4.02 development proceeds, since we can now adopt a data-driven
approach to changing language features instead of guessing how much
third-party code will break. If your code is in OPAM, then it’ll be
tested as new features such as <a href="http://caml.inria.fr/mantis/view.php?id=6063">module
aliases</a>,
<a href="http://ocaml.org/meetings/ocaml/2013/slides/garrigue.pdf">injectivity</a>
and <a href="http://ocaml.org/meetings/ocaml/2013/slides/white.pdf">extension
points</a> show up.<p></p>
<h3>Better documentation</h3>
<p>The venerable
<a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual029.html">OCamlDoc</a>
tool has done an admirable job for the last decade, but is increasingly
showing its age due to a lack of support for cross-referencing across
packages. We started working on this problem in the summer when <a href="https://github.com/vincent-botbol">Vincent
Botbol</a> visited us on an internship,
expecting it to be a quick job to come up with something as good as
Haskell’s excellent <a href="http://www.haskell.org/haddock/">Haddock</a> online
documentation.</p>
<p>Instead, we ran into the "module wall": since OCaml makes it so easy to
parameterise code over other modules, it makes it hard to generate
static documentation without outputting hundreds of megabytes of HTML
every time. After some hard work from Vincent and Leo, we’ve got a
working prototype that lets you simply run
<code>opam install opam-doc &amp;&amp; opam doc core async</code> to generate package
documentation. You can see the results for
<a href="http://mirage.github.io/">Mirage</a> online, but expect to see this
integrated into the main OCaml site for all OPAM packages as we work
through polishing up the user interface.</p>
<h3>Turning OPAM into libraries</h3>
<p>The other behind-the-scenes effort for OPAM has been to keep the core
command-line tool simple and stable, and to have it install OCaml
libraries that can be interfaced with by other tools to do
domain-specific tasks. <a href="http://gazagnaire.org">Thomas Gazagnaire</a>,
<a href="http://louis.gesbert.fr/cv.en.html">Louis Gesbert</a> and <a href="https://github.com/dsheets">David
Sheets</a> have been steadily hacking away at
this and we now have <a href="https://github.com/ocamllabs/opamfu">opamfu</a> to
run operations over all packages, and an easy-to-template
<a href="https://github.com/ocaml/opam2web">opam2web</a> that generates the live
<a href="http://opam.ocaml.org">opam.ocaml.org</a> website.</p>
<p>This makes OPAM easier to deploy within other organizations that want to
integrate it into their workflow. For example, the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/pkg/">software
section</a> of the OCaml
Labs website is regularly generated from a search of all OPAM packages
tagged <code>ocamllabs</code>. We also used it to rewrite the entire OPAM
repository <a href="https://github.com/ocaml/opam-repository/pull/1240">in one epic
diff</a> to add
external library dependencies via a <a href="https://github.com/ocaml/opam/pull/886/files">command-line
shim</a>.</p>
<h3>OPAM-in-a-Box</h3>
<p>All of this effort is geared towards making it easier to maintain
reusable local OPAM installations. After several requests from big
universities to help out their teaching needs, we’re putting together
all the support needed to easily redistribute OPAM packages via an
“<a href="https://github.com/ocaml/opam/issues/1035">OPAM-in-a-Box</a>” command
that uses <a href="http://docker.io">Docker</a> containers to let you clone and do
lightweight modifications of OCaml installations.</p>
<p>This will also be useful for anyone who’d like to run tutorials or teach
OCaml, without having to rely on flaky network connectivity at
conference venues: a problem we’ve <a href="http://amirchaudhry.com/fpdays-review">suffered
from</a> too!</p>
<h2>Core Compiler</h2>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/compiler-hacking.webp" loading="lazy" class="content-image" alt="Compiling hacking at the Cambridge Makespace" srcset="/images/compiler-hacking.320.webp 320w,/images/compiler-hacking.480.webp 480w,/images/compiler-hacking.640.webp 640w,/images/compiler-hacking.768.webp 768w" title="Compiling hacking at the Cambridge Makespace" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Compiling hacking at the Cambridge Makespace</figcaption></figure>

Starting to work on a real compiler can often be a daunting prospect,
and so one initiative we started this year is to host regular <a href="http://ocamllabs.github.io/compiler-hacking/2013/10/30/third-compiler-hacking-session.html">compiler
hacking
sessions</a>
where people could find a <a href="https://github.com/ocamllabs/compiler-hacking/wiki">curated list of
features</a> to work
on, with the regular developers at hand to help out when people get
stuck, and free beer and pizza to oil the coding wheels. This has worked
out well, with around 20 people showing up on average for the three we
held, and <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-previously-worked-on">several
patches</a>
submitted upstream to OCaml. <a href="http://gallium.inria.fr/~scherer/">Gabriel
Scherer</a> and <a href="http://cristal.inria.fr/~doligez/">Damien
Doligez</a> have been helping this
effort by tagging <a href="http://caml.inria.fr/mantis/search.php?project_id=1&amp;sticky_issues=1&amp;sortby=last_updated&amp;dir=DESC&amp;highlight_changed=24&amp;hide_status_id=90&amp;tag_string=junior_job">junior
jobs</a>
in the OCaml Mantis bug tracker as they are filed.<p></p>
<h3>Syntax transformations and extension points</h3>
<p><a href="http://www.lpw25.net">Leo White</a> started the year fresh out of
completing his PhD with <a href="https://www.cl.cam.ac.uk/~am21/">Alan Mycroft</a>,
and before he realized what he’d gotten himself into was working with
<a href="http://alain.frisch.fr/">Alain Frisch</a> on the future of syntax
transformations in OCaml. We started off our first
<a href="http://lists.ocaml.org/listinfo/wg-camlp4">wg-camlp4</a> working group on
the new <a href="http://lists.ocaml.org">lists.ocaml.org</a> host, and a spirited
discussion
<a href="http://lists.ocaml.org/pipermail/wg-camlp4/2013-January/thread.html">started</a>
that went
<a href="http://lists.ocaml.org/pipermail/wg-camlp4/2013-February/thread.html">on</a>
and
<a href="http://lists.ocaml.org/pipermail/wg-camlp4/2013-March/thread.html">on</a>
for several months. It ended with a very satisfying design for a simpler
<em>extension points</em> mechanism which Leo
<a href="http://ocaml.org/meetings/ocaml/2013/slides/white.pdf">presented</a> at
the OCaml 2013 workshop at ICFP, and is now merged into OCaml
4.02-trunk.</p>
<h3>Namespaces</h3>
<p>Not all of the working groups were quite as successful in coming to a
conclusion as the Camlp4 one. On the Platform mailing list, Gabriel
Scherer started a discussion on the design for
<a href="http://lists.ocaml.org/pipermail/platform/2013-February/000050.html">namespaces</a>
in OCaml. The resulting discussion was useful in separating multiple
concerns that were intermingled in the initial proposal, and Leo wrote a
<a href="http://www.lpw25.net/2013/03/10/ocaml-namespaces.html">comprehensive blog
post</a> on a
proposed namespace design.</p>
<p>After further discussion at <a href="http://icfpconference.org/icfp2013/">ICFP
2013</a> with Jacques Garrigue later
in the year, it turns out adding support for <a href="http://caml.inria.fr/mantis/view.php?id=6063">module
aliases</a> would solve much
of the cost associated with compiling large libraries such as
<a href="http://ocaml.janestreet.com">Core</a>, with no backwards compatibility
issues. This solution has now been integrated into OCaml 4.02.0dev and
is being tested with Core.</p>
<h3>Delving into the bug tracker</h3>
<p>Jeremy Yallop joined us in April, and he and Leo also leapt into the
core compiler and started triaging issues on the OCaml <a href="http://caml.inria.fr/mantis">bug
tracker</a>. This seems unglamorous in the
beginning, but there rapidly turned out to be many fascinating threads
that shed light on OCaml’s design and implementation through seemingly
harmless bugs. Here is a pick of some interesting threads through the
year that we’ve been involved with:</p>
<ul>
<li>An <a href="http://caml.inria.fr/mantis/view.php?id=5985&amp;nbn=49#bugnotes">unexpected interaction between variance and GADTs</a>
that led to Jacques Garrigue’s
<a href="http://ocaml.org/meetings/ocaml/2013/slides/garrigue.pdf">talk</a> at
OCaml 2013.</li>
<li>Type unsoundness by <a href="http://caml.inria.fr/mantis/view.php?id=5992">pattern matching lazy mutable
values</a>, thus shedding
light on the precise semantics of the order of pattern matching.</li>
<li>Leo proposed an <a href="http://caml.inria.fr/mantis/view.php?id=5584">open types</a> extension to
allow abstract types to be declared open. You can try it via
<code>opam switch 4.00.1+open-types</code>.</li>
<li>Designing the popular, but controversial <a href="http://caml.inria.fr/mantis/view.php?id=5759">record disambiguation feature</a> in OCaml
4.01.0, and debating <a href="http://caml.inria.fr/mantis/view.php?id=6000">the right warnings</a> needed to
prevent programmer surprise.</li>
<li>Exposing a <a href="http://caml.inria.fr/mantis/view.php?id=6064">GADT representation for Bigarray</a>.</li>
</ul>
<p>This is just a sample of some of the issues solved in Mantis; if you
want to learn more about OCaml, it’s well worth browsing through it to
learn from over a decade of interesting discussions from all the
developers.</p>
<h3>Thread-local storage runtime</h3>
<p>While OCamlPro was working on their <a href="https://github.com/lucasaiu/ocaml">reentrant OCaml
runtime</a>, we took a different tack by
adding <a href="https://github.com/ocamllabs/ocaml/tree/multicore">thread-local
storage</a> to the
runtime instead, courtesy of <a href="http://mu.netsoc.ie/">Stephen Dolan</a>. This
is an important choice to make at the outset of adding multicore, so
both approaches are warranted. The preemptive runtime adds a lot of code
churn (due to adding a context parameter to most function calls) and
takes up a register, whereas the thread-local storage approach we tried
doesn’t permit callbacks to different threads.</p>
<p>Much of this work isn’t interesting on its own, but forms the basis for
a fully multicore runtime (with associated programming model) in 2014.
Stay tuned!</p>
<h3>Ctypes</h3>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/c.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

One other complaint from the Consortium members was quite surprising:
the difficulty of using the OCaml foreign function interface safely to
interface with C code. Jeremy Yallop began working on the
<a href="https://github.com/ocamllabs/ocaml-ctypes">ctypes</a> library that had the
goal of eliminating the need to write any C code at all for the vast
majority of foreign bindings.<p></p>
<p>Instead, Ctypes lets you describe any C function call as an OCaml value,
and provides various linkage options to invoke that function into C. The
first option he implemented was a <code>dlopen</code> interface, which immediately
brought us the same level of functionality as the
<a href="http://docs.python.org/2/library/ctypes.html">Python</a> or
<a href="http://www.haskell.org/haskellwiki/Library/libffi">Haskell</a> Ctypes
equivalents. This early code was in itself startlingly useful and more
pleasant to use than the raw FFI, and various folk (such as David
Sheets’ <a href="https://github.com/dsheets/ocaml-sodium">libsodium</a>
cryptography bindings) started adopting it.</p>
<p>At this point, I happened to be struggling to write the Foreign Function
Interface chapter of <a href="https://realworldocaml.org">Real World OCaml</a>
without blowing through our page budget with a comprehensive explanation
of the existing system. I decided to take a risk and write about Ctypes
instead, since it let new users to the language have a <em>far</em> more
productive experience to get started. Xavier Leroy pointed out <a href="https://github.com/realworldocaml/book/issues/1701">some
shortcomings</a> of the
library in his technical book review, most notably with the lack of an
interface with C macros. The design of Ctypes fully supports alternate
linking mechanisms than just <code>dlopen</code> though, and Jeremy has added
automatic C stub generation support as well. This means that if you use
Ctypes to build an OCaml binding in 2014, you can choose several
mechanisms for the same source code to link to the external system.
Jeremy even demonstrated a forking model at OCaml 2013 that protects the
OCaml runtime from the C binding via process separation.</p>
<p>The effort is paying off: Daniel Bünzli <a href="http://alan.petitepomme.net/cwn/2013.12.17.html#9">ported
SDL2</a> using ctypes,
and gave us extensive
<a href="https://github.com/ocamllabs/ocaml-ctypes/issues">feedback</a> about any
missing corner cases, and the resulting bindings don’t require any C
code to be written. <a href="http://xulforum.org">Jonathan Protzenko</a> even used
it to implement an OCaml controller for the <a href="http://gallium.inria.fr/blog/raspi-lcd/">Adafruit Raspberry Pi RGB
LCD</a>!</p>
<h2>Community Efforts</h2>
<p>Our community efforts were largely online, but we also hosted visitors
over the year and regular face-to-face tutorials.</p>
<h3>Online at OCaml.org</h3>
<p>While the rest of the crew were hacking on OPAM and OCaml, <a href="http://amirchaudhry.com/">Amir
Chaudhry</a> and <a href="http://philippewang.info/CL/">Philippe
Wang</a> teamed up with Ashish Agarwal and
Christophe Troestler to redesign and relaunch the <a href="http://ocaml.org">OCaml
website</a>. Historically, OCaml’s homepage has been the
<a href="http://caml.inria.fr">caml.inria.fr</a> domain, and the
<a href="http://ocaml.org">ocaml.org</a> effort was begun by Christophe and Ashish
<a href="https://www.mail-archive.com/caml-list@inria.fr/msg00169.html">some years
ago</a> to
modernize the web presence.</p>
<p>The webpages were already rather large with complex scripting (for
example, the <a href="http://ocaml.org/learn/tutorials/99problems.html">99
Problems</a> page runs
the OCaml code to autogenerate the output). Philippe developed a
<a href="https://github.com/pw374/MPP-language-blender">template DSL</a> that made
it easier to unify a lot of the templates around the website, and also a
<a href="https://github.com/pw374/omd">Markdown parser</a> that we could link to as
a library from the rest of the infrastructure without shelling out to
Pandoc.</p>
<p>Meanwhile, Amir designed a series of <a href="http://amirchaudhry.com/wireframe-demos-for-ocamlorg/">interactive wireframe
sketches</a> and
<a href="http://amirchaudhry.com/ocamlorg-request-for-feedback/">gathered feedback</a> on it
from the community. A local <a href="http://onespacemedia.com">design agency</a> in
Cambridge helped with visual look and feel, and finally at the end of
the summer we began the
<a href="http://amirchaudhry.com/migration-plan-ocaml-org/">migration</a> to the
new website, followed by a triumphant
<a href="http://amirchaudhry.com/announcing-new-ocamlorg/">switchover</a> in
November to the design you see today.</p>
<p>The domain isn’t just limited to the website itself. Leo and I set up a
<a href="https://github.com/ocaml/ocaml.org-scripts">SVN-to-Git mirror</a> of the
OCaml compiler <a href="http://caml.inria.fr/ocaml/anonsvn.en.html">Subversion
repository</a> on the GitHub
<a href="https://github.com/ocaml/ocaml">OCaml organization</a>, which is proving
popular with developers. There is an ongoing effort to simplify the core
compiler tree by splitting out some of the larger components, and so
<a href="http://github.com/ocaml/camlp4">camlp4</a> is also now hosted on that
organization, along with <a href="https://github.com/ocaml/oasis">OASIS</a>. We
also administer several subdomains of <a href="http://ocaml.org">ocaml.org</a>,
such as the <a href="http://lists.ocaml.org">mailing lists</a> and the <a href="http://opam.ocaml.org">OPAM
repository</a>, and other services such as the
<a href="http://forge.ocamlcore.org">OCaml Forge</a> are currently migrating over.
This was made significantly easier thanks to sponsorship from <a href="http://rackspace.com">Rackspace
Cloud</a> (users of <a href="http://xenserver.org">XenServer</a>
which is written in OCaml). They saw our struggles with managing
physical machines and gave us developer accounts, and all of the
ocaml.org infrastructure is now hosted on Rackspace. We’re very grateful
to their ongoing help!</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/rackspace.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

If you’d like to contribute to infrastructure help (for example, I’m
experimenting with a <a href="http://git.ocaml.org/public/">GitLab</a> mirror),
then please join the
<a href="http://lists.ocaml.org/listinfo/infrastructure">infrastructure@lists.ocaml.org</a>
mailing list and share your thoughts. The website team also need help
with adding content and <a href="https://github.com/ocaml/ocaml.org/issues/376">international
translations</a>, so head
over to the <a href="http://github.com/ocaml/ocaml.org/issues">website issue
tracker</a> and start proposing
improvements you’d like to see.<p></p>
<h3>Next steps for ocaml.org</h3>
<p>The floodgates requesting features opened up after the launch of the new
look and feel. Pretty much everyone wanted deeper OPAM integration into
the main website, for features such as:</p>
<ul>
<li>Starring and reviewing packages</li>
<li>Integrating the <a href="https://github.com/ocamllabs/opam-doc">opam-doc</a>
documentation with the metadata</li>
<li>Display test results and a compatibility matrix for non-x86 and
non-Linux architectures.</li>
<li>Link to blog posts and tutorials about the package.</li>
</ul>
<p>Many of these features were part of the <a href="http://amirchaudhry.com/wireframe-demos-for-ocamlorg/">original
wireframes</a> but
we’re being careful to take a long-term view of how they should be
created and maintained. Rather than building all of this as a huge
bloated <a href="https://github.com/ocaml/opam2web">opam2web</a> extension, David
Sheets (our resident relucant-to-admit-it web expert) has designed an
overlay directory scheme that permits the overlaying of different
metadata onto the website. This lets one particular feature (such as
blog post aggregation) be handled separately from the others via Atom
aggregators.</p>
<h3>Real World OCaml</h3>
<p><img src="https://anil.recoil.org/papers/rwo" alt="%r">
A big effort that took up most of the year for me was finishing and
publishing an O’Reilly book called <a href="https://realworldocaml.org">Real World
OCaml</a> with <a href="https://ocaml.janestreet.com/?q=blog/5">Yaron
Minsky</a> and Jason Hickey. Yaron
describes how it all started in <a href="https://ocaml.janestreet.com/?q=node/117">his blog
post</a>, but I learnt a lot from
developing a book using the <a href="https://web.archive.org/web/20160324164610/https://anil.recoil.org/2013/08/06/real-world-ocaml-beta2.html">open commenting
scheme</a>
that we developed just for this.</p>
<p>In particular, the book ended up shining a bright light into dark
language corners that we might otherwise not have explored in OCaml
Labs. Two chapters of the book that I wasn’t satisfied with were the
<a href="https://realworldocaml.org/v1/en/html/objects.html">objects</a> and
<a href="https://realworldocaml.org/v1/en/html/classes.html">classes</a> chapters,
largely since neither Yaron nor Jason nor I had ever really used their
full power in our own code. Luckily, Leo White decided to pick up the
baton and champion these oft-maligned (but very powerful) features of
OCaml, and the result is the clearest explanation of them that I’ve read
yet. Meanwhile, Jeremy Yallop helped out with extensive review of the
<a href="https://realworldocaml.org/v1/en/html/foreign-function-interface.html">Foreign Function
Interface</a>
chapter that used his
<a href="https://github.com/ocamllabs/ocaml-ctypes">ctypes</a> library. Finally,
<a href="https://plus.google.com/100586365409172579442/posts">Jeremie Diminio</a>
at Jane Street worked hard on adding several features to his
<a href="https://github.com/diml/utop">utop</a> toplevel that made it compelling
enough to become our default recommendation for newcomers.</p>
<p>All in all, we ended up closing over <a href="https://web.archive.org/web/20160101000000*/https://anil.recoil.org/2013/08/06/real-world-ocaml-beta2.html">2000
comments</a>
in the process of writing the book, and I’m very proud of the result
(freely available <a href="https://realworldocaml.org">online</a>, but do <a href="http://www.amazon.com/Real-World-OCaml-Functional-programming/dp/144932391X/">buy a
copy</a>
if you can to support it). Still, there’s more I’d like to do in 2014 to
improve the ease of using OCaml further. In particular, I removed a
chapter on packaging and build systems since I wasn’t happy with its
quality, and both <a href="http://gazagnaire.org">Thomas Gazagnaire</a> and I
intend to spend time in 2014 on improving this part of the ecosystem.</p>
<h3>Tutorials and Talks</h3>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/pfff.webp" loading="lazy" class="content-image" alt="Julien Verlaguet and Yoann Padioleau show off Pfff code visualisation at Facebook." srcset="/images/pfff.1024.webp 1024w,/images/pfff.320.webp 320w,/images/pfff.480.webp 480w,/images/pfff.640.webp 640w,/images/pfff.768.webp 768w" title="Julien Verlaguet and Yoann Padioleau show off Pfff code visualisation at Facebook." sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Julien Verlaguet and Yoann Padioleau show off Pfff code visualisation at Facebook.</figcaption></figure>

We had a lively presence at <a href="http://icfpconference.org">ICFP 2013</a> this
year, with the third iteration of the <a href="http://ocaml.org/meetings/ocaml/2013/program.html">OCaml
2013</a> held there, and
Stephen Dolan presenting a paper in the main conference. I <a href="http://www.syslog.cl.cam.ac.uk/2013/09/24/liveblogging-ocaml-workshop-2013/">liveblogged
OCaml
2013</a>
and <a href="http://www.syslog.cl.cam.ac.uk/2013/09/22/liveblogging-cufp-2013/">CUFP
2013</a>
as they happened, and all the
<a href="http://ocaml.org/meetings/ocaml/2013/program.html">talks</a> we gave are
linked from the program. The most exciting part of the conference for a
lot of us were the two talks by Facebook on their use of OCaml: first
for <a href="http://ocaml.org/meetings/ocaml/2013/slides/padioleau.pdf">program analysis using
Pfff</a> and
then to migrate their massive PHP codebase <a href="http://www.youtube.com/watch?feature=player_detailpage&amp;v=gKWNjFagR9k#t=1150">using an OCaml
compiler</a>.
I also had the opportunity to participate in a panel at the Haskell
Workshop on whether <a href="http://ezyang.tumblr.com/post/62157468762/haskell-haskell-and-ghc-too-big-to-fail-panel">Haskell is too big to fail
yet</a>;
lots of interesting perspectives on scaling another formerly academic
language into the real world.<p></p>
<p><a href="https://github.com/yminsky" class="contact">Yaron Minsky</a> and I have been
giving tutorials on OCaml at ICFP for several years, but the release of
Real World OCaml has made it significantly easier to give tutorials
without the sort of labor intensity that it took in previous years (one
memorable ICFP 2011 tutorial that we did took almost 2 hours to get
everyone installed with OCaml. In ICFP 2013, it took us 15 minutes or so
to get everyone started). Still, giving tutorials at ICFP is very much
preaching to the choir, and so we’ve started speaking at more
general-purpose events.</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/marius-yaron-icfp.webp" loading="lazy" class="content-image" alt="Marius Eriksen and Yaron Minsky start a Scala vs OCaml rap battle at the ICFP industrial fair. Maybe." srcset="/images/marius-yaron-icfp.320.webp 320w,/images/marius-yaron-icfp.480.webp 480w,/images/marius-yaron-icfp.640.webp 640w,/images/marius-yaron-icfp.768.webp 768w" title="Marius Eriksen and Yaron Minsky start a Scala vs OCaml rap battle at the ICFP industrial fair. Maybe." sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Marius Eriksen and Yaron Minsky start a Scala vs OCaml rap battle at the ICFP industrial fair. Maybe.</figcaption></figure>

Our first local effort was <a href="http://fpdays.net/2013/">FPDays</a> in
Cambridge, where Jeremy Yallop and Amir Chaudhry ran the tutorial with
help from Phillipe Wang, Leo White and David Sheets. The OCaml session
there ended up being the biggest one in the entire two days, and Amir
<a href="http://amirchaudhry.com/fpdays-review/">wrote up</a> their experiences.
One interesting change from our ICFP tutorial is that Jeremy used
<a href="https://github.com/ocsigen/js_of_ocaml">js_of_ocaml</a> to teach OCaml
via JavaScript by building a fun <a href="https://github.com/ocamllabs/fpdays-skeleton">Monty
Hall</a> game.<p></p>
<h3>Visitors and Interns</h3>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/thomas-nycoug-2013.webp" loading="lazy" class="content-image" alt="Thomas Gazagnaire presents at Jane Street" srcset="" title="Thomas Gazagnaire presents at Jane Street" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Thomas Gazagnaire presents at Jane Street</figcaption></figure>

Since OCaml Labs is a normal group within the <a href="http://www.cl.cam.ac.uk">Cambridge Computer
Lab</a>, we often host academic visitors and
interns who pass through. This year was certainly diverse, and we
welcomed a range of colleagues:<p></p>
<ul>
<li><a href="http://www.lip6.fr/actualite/personnes-fiche.php?ident=D1161&amp;LANG=en">Mathias
Bourgoin</a>
has just finished his work on interfacing OCaml with GPUs, and gave
us a seminar on how his
<a href="http://www.algo-prog.info/spoc/web/index.php?id=spoc">SPOC</a> tool
works (also available in OPAM via a <a href="http://www.algo-prog.info/spoc/distribution/opam/">custom
remote</a>).</li>
<li><a href="http://www.benjamin.canou.fr/">Benjamin Canou</a> (now at OCamlPro)
practised his <a href="http://ocaml.org/meetings/ocaml/2013/slides/canou.pdf">OCaml 2013
talk</a> on
building high-level interfaces to JavaScript with OCaml by giving a
departmental seminar.</li>
<li><a href="http://www.dicosmo.org/">Roberto Di Cosmo</a>, who directs the
<a href="http://www.irill.org/">IRILL</a> organization on Free Software in
Paris delivered a seminar on constraint solving for <a href="http://mancoosi.org">package
systems</a> that are as large-scale as Debian’s.</li>
<li><a href="http://gazagnaire.org">Thomas Gazagnaire</a> visited during the summer
to help plot the <a href="http://openmirage.org/blog/mirage-1.0.3-released">Mirage
1.0</a> and <a href="https://anil.recoil.org/2013/09/20/opam-1-1-beta.html">OPAM
1.1</a> releases.
He has also since joined OCaml Labs fulltime to work on
<a href="http://nymote.org">Nymote</a>.</li>
<li><a href="http://louis.gesbert.fr/cv.en.html">Louis Gesbert</a> from OCamlPro
visited for 2 weeks in December and kicked off the inaugral OPAM
developers summit (which was, admittedly, just 5 developers in the
<a href="http://www.kingston-arms.co.uk/">Kingston Arms</a>, but all good
things start in a pub, right?)</li>
<li><a href="http://www.xulforum.org/">Jonathan Protzenko</a> presented his PhD
work on <a href="http://protz.github.io/mezzo/">Mezzo</a> (which is now <a href="http://gallium.inria.fr/blog/mezzo-on-opam/">merged
into OPAM</a>), and
educated us on the vagaries of <a href="http://protz.github.io/ocaml-installer/">Windows
support</a>.</li>
<li><a href="http://gallium.inria.fr/~scherer/">Gabriel Scherer</a> from the
Gallium INRIA group visited to discuss the direction of OPAM and
various language feature discussions (such as namespaces). He didn’t
give a talk, but promises to do so next time!</li>
<li><a href="https://github.com/bvaugon">Benoît Vaugon</a> gave a seminar on his
<a href="http://oud.ocaml.org/2012/slides/oud2012-paper10-slides.pdf">OCamlCC</a>
OCaml-to-C compiler, talked about porting OCaml to <a href="http://www.algo-prog.info/ocaml_for_pic/web/index.php?id=ocapic">8-bit
PICs</a>,
and using GADTs to <a href="http://caml.inria.fr/mantis/view.php?id=6017">implement
Printf</a> properly.</li>
</ul>
<p>We were also visited several times by <a href="http://danmey.org/">Wojciech
Meyer</a> from ARM, who was an OCaml developer who
maintained (among other things) the
<a href="http://brion.inria.fr/gallium/index.php/Ocamlbuild">ocamlbuild</a> system
and worked on <a href="http://www.youtube.com/watch?v=d9Hg5L76FG8">DragonKit</a>
(an extensible LLVM-like compiler written in OCaml). Wojciech very sadly
passed away on November 18th, and we all fondly remember his
enthusiastic and intelligent contributions to our small Cambridge
community.</p>
<p>We also hosted visitors to live in Cambridge and work with us over the
summer. In addition to Vincent Botbol (who worked on OPAM-doc as
described earlier) we had the pleasure of having <a href="http://erratique.ch/">Daniel
Bünzli</a> and <a href="http://www.x9c.fr/">Xavier Clerc</a>
work here. Here’s what they did in their own words.</p>
<h4>Xavier Clerc: OCamlJava</h4>
<p>Xavier Clerc took a break from his regular duties at INRIA to join us
over the summer to work on
<a href="http://ocamljava.x9c.fr/preview/">OCaml-Java</a> and adapt it to the
latest JVM features. This is an incredibly important project to bridge
OCaml with the huge Java community, and here’s his report:</p>
<blockquote>
<p>After a four-month visit to the OCaml Labs dedicated to the
<a href="http://ocamljava.x9c.fr/preview/">OCaml-Java</a> project, the time has
come for an appraisal! The undertaken work can be split into two
areas: improvements to code generation, and interaction between the
OCaml &amp; Java languages. Regarding code generation, several classical
optimizations have been added to the compiler, for example loop
unrolling, more aggressive unboxing, better handling of globals, or
partial evaluation (at the bytecode level). A new tool, namely
ocamljar, has been introduced allowing post-compilation optimizations.
The underlying idea is that some optimizations cannot always be
applied (e.g. depending whether multiple threads/programs will
coexist), but enabling them through command-line flags would lead to
recompilation and/or multiple installations of each library according
to the set of chosen optimizations. It is thus far more easier to
first build an executable jar file, and then modify it according to
these optimizations. Furthermore, this workflow allows the ocamljar
tool to take advantage of whole-program information for some
optimizations. All these improvements, combined, often lead to a gain
of roughly 1/3 in terms of execution time.</p>
<p>Regarding language interoperability, there are actually two directions
depending on whether you want to call OCaml code from Java, or want to
call Java code from OCaml. For the first direction, a tool allows to
generate Java source files from OCaml compiled interfaces, mapping the
various constructs of the OCaml language to Java classes. It is then
possible to call functions, and to manipulate instances of OCaml types
in pure Java, still benefiting from the type safety provided by the
OCaml language. In the other direction, an extension of the OCaml
typer is provided allowing to create and manipulate Java instances
directly from OCaml sources. This typer extension is indeed a thin
layer upon the original OCaml typer, that is mainly responsible for
encoding Java types into OCaml types. This encoding uses a number of
advanced elements such as polymorphic variants, subtyping, variance
annotations, phantom typing, and printf-hack, but the end-user does
not have to be aware of this encoding. On the surface, the type of
instances of the Java Object classes is
<code>java'lang'Object java_instance</code>, and instances can be created by
calling Java.make <code>Object()</code>.</p>
<p>While still under heavy development, a working prototype <a href="http://ocamljava.x9c.fr/preview/">is
available</a>, and bugs <a href="http://bugs.x9c.fr/">can be
reported</a>. Finally, I would like to thank the
OCaml Labs for providing a great working environment.</p>
</blockquote>
<h4>Daniel Bünzli: Typography and Visualisation</h4>
<p>Daniel joined us from Switzerland, and spent some time at Citrix before
joining us in OCaml Labs. All of his
<a href="http://erratique.ch/software">software</a> is now on OPAM, and is seeing
ever-increasing adoption from the community.</p>
<blockquote>
<p>Released a first version of <a href="http://erratique.ch/software/vg">Vg</a> […]
I’m especially happy about that as I wanted to use and work on these
ideas since at least 2008. The project is a long term project and is
certainly not finished yet but this is already a huge step.</p>
<p>Adjusted and released a first version of
<a href="http://erratique.ch/software/gg">Gg</a>. While the module was already
mostly written before my arrival to Cambridge, the development of Vg
and Vz prompted me to make some changes to the module.</p>
<p>[…] released <a href="http://erratique.ch/software/otfm">Otfm</a>, a module to
decode OpenType fonts. This is a work in progress as not every
OpenType table has built-in support for decoding yet. But since it is
needed by Vg’s PDF renderer I had to cut a release. It can however
already be used to implement certain simple things like font kerning
with Vg, this can be seen in action in the <code>vecho</code> binary installed by
Vg.</p>
<p>Started to work on <a href="http://erratique.ch/software/vz/doc/Vz.html">Vz</a>,
a module for helping to map data to Vg images. This is really
unfinished and is still considered to be at a design stage. There are
a few things that are however well implemented like (human)
perceptually meaningful <a href="http://erratique.ch/software/vz/demos/color_schemes.html">color
palettes</a>
and the small folding stat module (<code>Vz.Stat</code>). However it quickly
became evident that I needed to have more in the box w.r.t. text
rendering in Vg/Otfm. Things like d3js entirely rely on the SVG/CSS
support for text which makes it easy to e.g. align things (like tick
labels on <a href="http://erratique.ch/software/vz/demos/iris.html">such
drawings</a>). If you
can’t rely on that you need ways of measuring rendered text. So I
decided to suspend the work on Vz and put more energy in making a
first good release of Vg. Vz still needs quite some design work,
especially since it tries to be independent of Vg’s backend and from
the mechanism for user input.</p>
<p>Spent some time figuring out a new “opam-friendly” release workflow in
pkgopkg. One of my problem is that by designing in the small for
programming in the large — what a slogan — the number of packages I’m
publishing is growing (12 and still counting). This means that I need
to scale horizontally maintenance-wise unhelped by the sad state of
build systems for OCaml. I need tools that make the release process
flawless, painless and up to my quality standards. This lead me to
enhance and consolidate my old scattered distribution scripts in that
repo, killing my dependencies on Oasis and ocamlfind along the way.
<em>(edited for brevity, see
<a href="https://github.com/dbuenzli/pkgopkg">here</a>)</em></p>
</blockquote>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/daniel-presentation-vg.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

Daniel also left his bicycle here for future visitors to use, and the
“Bünzli-bike” is available for our next visitor! (<a href="https://anil.recoil.org/news.xml" class="contact">Louis Gesbert</a> even
donated lights, giving it a semblance of safety).<p></p>
<h3>Industrial Fellows</h3>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/xenserver.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

Most of our regular funding bodies such as <a href="http://epsrc.ac.uk">EPSRC</a>
or <a href="http://cordis.europa.eu/fp7/home_en.html">EU FP7</a> provide funding,
but leave all the intellectual input to the academics. A compelling
aspect of OCaml Labs has been how involved our industrial colleagues
have been with the day-to-day problems that we solve. Both Jane Street
and Citrix have senior staff regularly visiting our group and working
alongside us as industrial fellows in the Computer Lab.<p></p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/js.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

<a href="http://www.three-tuns.net/mark/">Mark Shinwell</a> from Jane Street
Europe has been working on improving the <a href="http://www.youtube.com/watch?v=NF2WpWnB-nk">state of native
debugging</a> in OCaml, by
adding extended DWARF debugging information to the compiler output.
Mark is also a useful source of feedback about the forthcoming
design of multicore, since he has daily insight into a huge
production codebase at Jane Street (and can tell us about it without
us requiring access!).<p></p>
<p><a href="http://dave.recoil.org">Dave Scott</a> is the principal architect of
<a href="http://xenserver.org">XenServer</a> at Citrix in Cambridge. This year
has been transformative for that project, since Citrix <a href="http://blogs.citrix.com/2013/06/26/open-source-what-does-it-mean-for-xenserver/">open-sourced
XenServer</a>
to GitHub and fully adopted OPAM into their workflow. Dave is the
author of numerous libraries that have all been released to OPAM,
and his colleagues <a href="http://jon.recoil.org">Jon Ludlam</a> and <a href="http://www.xenserver.org/blog/blogger/listings/euanh.html">Euan
Harris</a>
are also regular visitors who have also been contributors to the
OPAM and Mirage ecosystems.</p>
<h2>Research Projects</h2>
<p>The other 100% of our time at the Labs is spent on research projects.
When we started the group, I wanted to set up a feedback loop between
local people <em>using</em> OCaml to build systems, with the folk <em>developing</em>
OCaml itself. This has worked out particularly well with a couple of big
research projects in the Lab.</p>
<h3>Mirage</h3>
<p>Mirage is a <a href="https://anil.recoil.org/papers/2013-asplos-mirage.pdf">library operating
system</a> written in
OCaml that compiles source code into specialised Xen microkernels,
developed at the Cambridge Computer Lab, Citrix and the <a href="http://horizon.ac.uk">Horizon Digital
Economy</a> institute at Nottingham. This year saw
several years of effort culminate in the first release of <a href="http://openmirage.org">Mirage
1.0</a> as a self-hosting entity. While Mirage
started off as a <a href="https://anil.recoil.org/papers/2010-hotcloud-lamp.pdf">quick
experiment</a> into
building specialised virtual appliances, it rapidly became useful to
make into a real system for use in bigger research projects. You can
learn more about Mirage <a href="http://openmirage.org/docs">here</a>, or read the
<a href="http://cacm.acm.org/magazines/2014/1/170866-unikernels/abstract">Communications of the
ACM</a>
article that <a href="http://dave.recoil.org">Dave Scott</a> and I wrote to close
out the year.</p>
<p>This project is where the OCaml Labs “feedback loop” has been strongest.
A typical <a href="http://www.openmirage.org/wiki/hello-world">Mirage
application</a> consists of
around 50 libraries that are all installed via OPAM. These range from
<a href="https://github.com/mirage/mirage-block-xen">device drivers</a> to protocol
libraries for <a href="https://github.com/avsm/ocaml-cohttp">HTTP</a> or
<a href="https://github.com/mirage/ocaml-dns">DNS</a>, to filesystems such as
<a href="https://github.com/mirage/ocaml-fat">FAT32</a>. Coordinating <a href="http://openmirage.org/blog/mirage-1.0.3-released">regular
releases</a> of all of
these would be near impossible without using OPAM, and has also forced
us to use our own tools daily, helping to sort out bugs more quickly.
You can see the full list of libraries on the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/pkg/">OCaml Labs software
page</a>.</p>
<p>Mirage is also starting to share code with big projects such as
<a href="http://xenserver.org">XenServer</a> now, and we have been working with
Citrix engineers to help them to move to the
<a href="http://ocaml.janestreet.com">Core</a> library that Jane Street has
released (and that is covered in <a href="https://realworldocaml.org">Real World
OCaml</a>). Moving production codebases this
large can take years, but OCaml Labs is turning out to be a good place
to start unifying some of the bigger users of OCaml into one place.
We’re also now an official <a href="http://www.xenproject.org/developers/teams/mirage-os.html">Xen Project incubator
project</a>,
which helps us to validate functional programming to other Linux
Foundation efforts.</p>
<h3>Nymote and User Centric Networking</h3>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/nymote.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

The release of Mirage 1.0 has put us on the road to simplifying embedded
systems programming. The move to the centralized cloud has led to
regular well-publicised privacy and security threats to the way <a href="http://de2013.org/wp-content/uploads/2013/09/de2013_submission_25-1.pdf">we
handle</a>
our digital infrastructure, and so <a href="http://www.cl.cam.ac.uk/~jac22/">Jon
Crowcroft</a>, <a href="http://www.cs.nott.ac.uk/~rmm/">Richard
Mortier</a> and I are leading an effort to
build an alternative privacy-preserving infrastructure using embedded
devices as part of the <a href="http://usercentricnetworking.eu/">User Centric
Networking</a> project, in collaboration
with a host of companies led by <a href="http://www.thlab.net/">Technicolor</a>
Paris. This work also plays on the strong points of OCaml: it already
has a <a href="https://anil.recoil.org/2012/02/25/dreamplug-debian-and-ocaml.html">fast ARM
backend</a>,
and Mirage can easily be ported to the new Xen/ARM target as hardware
becomes available.<p></p>
<p>One of the most difficult aspects of programming on the “wide area”
Internet are dealing with the lack of a distributed identity service
that’s fully secure. We published <a href="https://anil.recoil.org/papers/2013-foci-signposts.pdf">our
thoughts</a> on this
at the USENIX Free and Open Communications on the Internet workhsop, and
David Sheets is working towards a full implementation using Mirage. If
you’re interested in following this effort, Amir Chaudhry is blogging at
the <a href="http://nymote.org/">Nymote</a> project website, where we’ll talk about
the components as they are released.</p>
<h3>Data Center Networking</h3>
<p>At the other extreme from embedded programming is datacenter networking,
and we started the
<a href="http://gow.epsrc.ac.uk/NGBOViewGrant.aspx?GrantRef=EP/K034723/1">Network-as-a-Service</a>
research project with <a href="http://gow.epsrc.ac.uk/NGBOViewGrant.aspx?GrantRef=EP/K032968/1">Imperial
College</a>
and
<a href="http://gow.epsrc.ac.uk/NGBOViewGrant.aspx?GrantRef=EP/K031724/1">Nottingham</a>.
With the rapid rise of <a href="http://en.wikipedia.org/wiki/Software-defined_networking">Software Defined
Networking</a>
this year, we are investigating how application-specific customisation
of network resources can build fast, better, cheaper infrasructure.
OCaml is in a good position here: several other groups have built
OpenFlow controllers in OCaml (most notably, the <a href="https://github.com/frenetic-lang">Frenetic
Project</a>), and Mirage is specifically
designed to assemble such bespoke infrastructure.</p>
<p>Another aspect we’ve been considering is how to solve the problem of
optimal connectivity across nodes. TCP is increasingly considered
harmful in high-through, high-density clusters, and <a href="http://www.sussex.ac.uk/informatics/people/peoplelists/person/334868">George
Parisis</a>
led the design of
<a href="https://anil.recoil.org/papers/2013-hotnets-trevi.pdf">Trevi</a>, which is
a fountain-coding based alternative for storage networking. Meanwhile,
<a href="http://gazagnaire.org">Thomas Gazagnaire</a> (who joined OCaml Labs in
November), has been working on a branch-consistent data store called
<a href="https://github.com/samoht/irminsule">Irminsule</a> which supports scalable
data sharing and reconciliation using Mirage. Both of these systems will
see implementations based on the research done this year.</p>
<h3>Higher Kinded Programming</h3>
<p>Jeremy Yallop and Leo White have been developing an approach that makes
it possible to write programs with higher-kinded polymorphism (such as
monadic functions that are polymorphic in the monad they use) without
using functors. It’s early days yet, but there’s a
<a href="https://github.com/ocamllabs/higher">library</a> available on
<a href="http://opam.ocaml.org/pkg/higher/higher.0.1">OPAM</a> that implements the
approach, and a <a href="https://github.com/ocamllabs/higher/raw/paper/higher.pdf">draft
paper</a> that
outlines the design.</p>
<h2>Priorities for 2014</h2>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/camel.webp" loading="lazy" class="content-image" alt="" srcset="" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

This year has been a wild ride to get us up to speed, but we now have a
solid sense of what to work on for 2014. We’ve decided on a high-level
set of priorities led by the senior members of the group:<p></p>
<ul>
<li><strong>Multicore</strong>: Leo White will be leading efforts in putting an
end-to-end multicore capable OCaml together.</li>
<li><strong>Metaprogramming</strong>: Jeremy Yallop will direct the metaprogramming
efforts, continuing with Ctypes and into macros and extension
points.</li>
<li><strong>Platform</strong>: Thomas Gazagnaire will continue to drive OPAM
development towards becoming the first <a href="http://ocaml.org/meetings/ocaml/2013/slides/madhavapeddy.pdf">OCaml
Platform</a>.</li>
<li><strong>Online</strong>: Amir Chaudhry will develop the online and community
efforts that started in 2013.</li>
</ul>
<p>These are guidelines to choosing where to spend our time, but not
excluding other work or day-to-day bugfixing. Our focus on collaboration
with Jane Street, Citrix, Lexifi, OCamlPro and our existing colleagues
will continue, as well as warmly welcoming new community members that
wish to work with us on any of the projects, either via internships,
studentships or good old-fashioned open source hacking.</p>
<p>I appreciate the <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/people/">whole
team's</a> feedback in
editing this long post into shape, the amazing professorial support from
<a href="http://www.cl.cam.ac.uk/~jac22/">Jon Crowcroft</a>, <a href="https://www.cl.cam.ac.uk/~iml1/">Ian
Leslie</a> and <a href="https://www.cl.cam.ac.uk/~am21/">Alan
Mycroft</a> throughout the year, and of
course the funding and support from Jane Street, Citrix, RCUK, EPSRC,
DARPA and the EU FP7 that made all this possible. Roll on 2014, and
please do <a href="mailto:avsm2@cl.cam.ac.uk">get in touch</a> with me with any
queries!</p>
<p></p><figure class="image-center"><img src="https://anil.recoil.org/images/fpdays2013-04.webp" loading="lazy" class="content-image" alt="A successful FPDays tutorial in Cambridge, with all attendees getting a free copy of RWO!" srcset="/images/fpdays2013-04.320.webp 320w,/images/fpdays2013-04.480.webp 480w" title="A successful FPDays tutorial in Cambridge, with all attendees getting a free copy of RWO!" sizes="(max-width: 768px) 100vw, 33vw"><figcaption>A successful FPDays tutorial in Cambridge, with all attendees getting a free copy of RWO!</figcaption></figure>
<p></p>

