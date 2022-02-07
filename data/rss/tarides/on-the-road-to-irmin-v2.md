---
title: On the road to Irmin v2
description: "Over the past few months, we have been heavily engaged in release\nengineering
  the Irmin 2.0 release,\nwhich covers multiple years of work on\u2026"
url: https://tarides.com/blog/2019-05-13-on-the-road-to-irmin-v2
date: 2019-05-13T00:00:00-00:00
preview_image: https://tarides.com/static/76876b69b77bdec1f25009b2ef2a6d33/ed333/tree_canopy2.jpg
featured:
---

<p>Over the past few months, we have been heavily engaged in release
engineering the <a href="https://github.com/mirage/irmin/issues/658">Irmin 2.0 release</a>,
which covers multiple years of work on all of its constituent
elements. We first began Irmin in late 2013 to act as a
<a href="https://mirage.io/blog/introducing-irmin">Git-like distributed and branchable storage substrate</a>
that would let us escape the <a href="https://www.cl.cam.ac.uk/~pes20/SOSP15-paper102-submitted.pdf">perils of POSIX filesystems</a>.</p>
<p>The Irmin libraries provide snapshotting, branching and merging
operations over storage and can communicate via Git both on-disk and
remotely. Irmin today therefore consists of many discrete OCaml
libraries that compose together to form a set of <a href="https://blog.acolyer.org/2015/01/14/mergeable-persistent-data-structures/">mergeable data structures</a>
that can be used in MirageOS unikernels and normal OCaml daemons such
as <a href="http://tezos.com">Tezos</a>.</p>
<p>In this blog post, we wanted to explain some of the release
engineering ongoing, and to highlight some areas where we could use
help from the community to test out pieces (and hopefully find your
own uses in your own infrastructure for it).  The overall effort is
tracked in <a href="https://github.com/mirage/irmin/issues/658">mirage/irmin#658</a>, so
feel free to comment on there as well.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#ocaml-git" aria-label="ocaml git permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>ocaml-git</h3>
<p>Irmin is parameterised over the exact communication mechanisms it uses
between nodes, both as an on-disk format and also the remoting
protocol.  The most important concrete implementation is Git, which
has turned into the world&rsquo;s most popular version control system.  In
order to seamlessly integrate with Irmin, we embarked on an effort to
build a complete re-implementation of
<a href="https://github.com/mirage/ocaml-git">Git from scratch in pure OCaml</a>.</p>
<p>You can read <a href="https://tarides.com/blog/2018-10-19-ocaml-git-2-0.html">details of the git 2.0 release</a>
on this blog, but from a release engineering perspective we have steadily
been fixing corner cases in this implementation.  The development
ocaml-git trees feature <a href="https://github.com/mirage/ocaml-git/pull/348">fixes to https+git</a>,
for <a href="https://github.com/mirage/ocaml-git/pull/351">listing remotes</a>, supporting
<a href="https://github.com/mirage/ocaml-git/pull/341">authenticated URIs</a> and
more.</p>
<p>These fixes are possible because users tried end-to-end usecases that
found these corner cases, so we&rsquo;d really like to see more.  For
example, our friends at <a href="https://robur.io">Robur</a> have submitted fixes
from their integration of it into their upcoming <a href="https://github.com/roburio/caldav">CalDAV engine</a>.
The Mirage <a href="https://github.com/Engil/Canopy">canopy</a> blog engine can now also
push/pull reliably from pure MirageOS unikernels between nodes, which
is a huge step.</p>
<p>If you get a chance to try ocaml-git in your infrastructure, please
let us know how you get along as we prepare a release of the git
libraries with all these fixes (which will be used in Irmin 2.0).</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#wodan" aria-label="wodan permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Wodan</h3>
<p>Irmin&rsquo;s storage layer is also well abstracted, so backends other than
a Unix filesystem or Git are supported.  Irmin can run in highly
diverse and OS-free environments, and so we began engineering the
<a href="https://github.com/mirage/wodan">Wodan filesystem</a> as a
domain-specific filesystem designed for MirageOS, Irmin and modern
flash drives.  See <a href="https://g2p.github.io/research/wodan.pdf">the OCaml Workshop 2017 abstract on
it</a> for more design
rationale)</p>
<p>As part of the Irmin 2.0 release, Wodan is also being prepared for a
release, and you can find <a href="https://github.com/mirage/wodan/tree/master/src/wodan-irmin">Irmin 2.0
support</a>
in the source.  If you&rsquo;d like a standalone block-device based
persistence environment for Irmin, please try this out.  This is the
preferred backend for using Irmin storage in a unikernel.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#tezos-and-irmin-pack" aria-label="tezos and irmin pack permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Tezos and irmin-pack</h3>
<p>Another big user of Irmin is the <a href="https://tezos.com">Tezos blockchain</a>,
and we have been optimising the persistent space usage of Irmin as their
network grows.  Because Tezos doesn&rsquo;t require full Git format support,
we created a hybrid backend that grabs the best bits of Git (e.g. the
packfile mechanism) and engineered a domain-specific backend tailored
for Tezos usage. Crucially, because of the way Irmin is split into
clean libraries and OCaml modules, we only had to modify a small part
of the codebase and could also re-use elements of the Git 2.0
engineering effort we described above.</p>
<p>The <a href="https://github.com/mirage/irmin/pull/615">irmin-pack backend</a> is
currently being reviewed and integrated ahead of Irmin 2.0 to provide
a significant improvement in disk usage -- more information to come soon.
There is a corresponding <a href="https://gitlab.com/samoht/tezos/tree/snapshot-irmin-pack">Tezos branch</a>
using the Irmin 2.0 code that will be integrated downstream in Tezos
once we complete the Irmin 2.0 tests.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#irmin-graphql-and-browser-irmin" aria-label="irmin graphql and browser irmin permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Irmin-GraphQL and &ldquo;browser Irmin&rdquo;</h3>
<p>Another new area of huge interest to us is
<a href="https://graphql.org">GraphQL</a> in order to provide frontends a rich
query language for Irmin hosted applications.  Irmin 2.0 includes a
builtin GraphQL server so you can <a href="https://twitter.com/cuvius/status/1017136581755457539">manipulate your Git repo via
GraphQL</a>.</p>
<p>If you are interested in (for example) compiling elements of Irmin to
JavaScript or wasm, for usage in frontends, then the Irmin 2.0 release
makes it significantly easier to support this architecture.  We&rsquo;ve
already seen some exploratory efforts <a href="https://github.com/mirage/irmin/issues/681">report issues</a>
when doing this, and we&rsquo;ve had it working ourselves in <a href="http://roscidus.com/blog/blog/2015/04/28/cuekeeper-gitting-things-done-in-the-browser/">Irmin 1.0 Cuekeeper</a>
so we are excited by the potential power of applications built using
this model.  If you have ideas/questions, please get in touch on the
<a href="https://github.com/mirage/irmin/issues">issue tracker</a> with your
usecase.</p>
<p>This post is just the precursor to the Irmin 2.0 release, so expect to
hear more about it in the coming weeks and months.  This is primarily
a call for help from early adopters interested in helping the project
out.  All of our code is liberally licensed open source, and so this
is a good time to tie together end-to-end usecases and help ensure we
don&rsquo;t make any decisions in Irmin 2.0 that go counter to some product
you&rsquo;d like to build. That&rsquo;s only possible with your feedback, so
either get in touch via the <a href="https://github.com/mirage/irmin/issues">issue tracker</a>, on
<a href="https://discuss.ocaml.org">discuss.ocaml.org</a> via the <code>mirageos</code> tag,
or just <a href="mailto:mirageos-devel@lists.xenproject.org">email us</a>.</p>
<p>A huge thank you to all our commercial customers, end users and open
source developers who have contributed their time, expertise and
financial support to help us achieve our goal of delivering a modern
storage stack in the spirit of Git. We look forward to getting Irmin
2.0 into your hands very soon!</p>
