---
title: 'The Mirage retreat: field trip report'
description:
url: http://gallium.inria.fr/blog/mirage-retreat-field-trip-report
date: 2019-04-15T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



    <p>Between March 6th and March 13th 2019, I attended the Mirage retreat
organized by Hannes Mehnert in Marrakesh, Morocco.</p>
<p>The Mirage retreat takes place in an artist residency organized as a
hostel (shared rooms with simple beds). Hannes gathers a lot of people
whose activity is relevant to the Mirage project; some of them work
within the OCaml ecosystem (but not necessarily Mirage), some work on
system programming (not necessarily in OCaml). The whole place is for
all of us for one week, excellent food is provided, and we get to do
whatever we want. (Thanks to the work of the people there who make this
possible.)</p>
<p>This was my second time attending the retreat &ndash; first time in
November 2017. It is probably the work-related trip I enjoy most. When I
get back home, I&rsquo;m exhausted, thrilled, I met fascinating people and I
learned a lot.</p>


    

    <h2>Marracheck</h2>
<p>This week I came with a specific project (that was decided
spontaneously maybe three weeks before that): I would work with Arma&euml;l
Gu&eacute;neau, also attending the retreat, on mixing ideas for the existing
tools to check opam packages (<a href="https://github.com/OCamlPro/opam-builder">opam-builder</a>, <a href="https://github.com/damiendoligez/opamcheck">opamcheck</a>, <a href="https://github.com/kit-ty-kate/opam-health-check">opam-health-check</a>),
with the objective of building a tool that can build the whole
opam-repository is less than a day on my laptop machine. The ultimate
goal is to make it extremely easy for anyone to test the impact of a
change to the OCaml compiler on the OCaml ecosystem.</p>
<p>We started with a <em>lot</em> of discussions on the design, inspired
by our knowledge of opam-builder and opamcheck &ndash; I had hacked on
opam-builder a bit before, and had detailed discussion with Damien about
the design of opamcheck &ndash; and discussions with Kate, working on
opam-health-check and in general the opam CI, also attending the
retreat. Then we did a good bit of pair-programming, with Arma&euml;l behind
the keyboard. We decided to rebuild a tool from scratch and to use the
<code>opam-libs</code> (the library-level API of the <code>opam</code>
codebase). By the end of the week, we were still quite far from a
working release, but we have a skeleton in place.</p>
<p>This would not have been possible without the presence, at the
retreat, of Louis Gesbert and Raja Boujbel, who helped us navigating the
(sometimes daunting) opam API. (We also noticed a few opportunities for
improvements and sent a couple pull-requests to opam itself.) Louis and
Raja are impressive in their handling of the opam codebase. There are
obscure and ugly and painful things within the opam APIs, but they come
from elegance/simplicity/pragmatism compromises that they made,
understand well, and are consistently able to justify. It feels like a
complex codebase that is growing as it discovers its use-cases, with
inevitable cruft, but good hands at work to manage this complexity,
within resource limits.</p>
<h2>Network drivers</h2>
<p>My roommate was Fabian Bonk, who participated to the &ldquo;ixy project&rdquo;,
at the TUM (Technische Universit&auml;t M&uuml;nchen), Munich, Germany. The &ldquo;ixy
project&rsquo; aims to implement a simple userland network driver (for some
specific Intel network card) in many different languages, and see what
work and what doesn&rsquo;t. Fabian wrote the OCaml implementation, and was
interested in finding ways to improve its performances.</p>
<p>At first I preferred to hear about his work from a distance; I know
nothing of network card, and there were people at the retreat noticeably
more knowledgeable about writing high-performance OCaml code. Then I
realized that this was a dangerous strategy: for essientally any topic
there is someone more knowledgeable than you at the retreat. So why not
work on userland network drivers?</p>
<p>Fabian and I made a few attempts at making the program faster, which
had the somewhat hilarious result of making the program about 500x
slower. It&rsquo;s an interesting problem domain. The driver author says &ldquo;I
would really need to remove this copy here, even though that would
require changing the whole Mirage API&rdquo;; the first reaction is to argue
that copying memory is actually quite fast, so it&rsquo;s probably not the
bottleneck. &ldquo;But we have to copy&rdquo;, they say, &ldquo;ten gibibytes per
second!&rdquo;. Ouch.</p>
<p>Anyway, after some tinkering, I realized that Fabian working over SSH
to a machine in Munich with the network card, and being able to run
latency tests because &ldquo;for this you need an optical splitter and I don&rsquo;t
have the privilege level to access the one our university has&rdquo;, wasn&rsquo;t
that great for benchmarking. So I decided to convince Fabian to
implement a compliant network card, in C, on his machine &ndash; he insists on
calling it a &ldquo;simulator&rdquo; but what&rsquo;s the difference between software and
hardware these days? The idea was, anyone could then use his network
card on their own machine to test and benchmark the driver against, and
make it faster. Unfortunately, he had an OSX machine, and everything you
would need to implement this nicely is sort of broken on OSX (working
POSIX-compliant shared memory? nope!).</p>
<h2>Crowbar</h2>
<p>One thing I realized during the retreat is that I have an amazing
(dis)advantage over some other people there (Hannes included): I know
that Crowbar is extremely easy to use. (You write a generator, a
quickcheck-style test, you listen to the tool tell you how to set a few
weird environment variables, and boom, there come the bugs.)</p>
<p>Apparently people who haven&rsquo;t tried Crowbar yet are unwilling to do
so because they&rsquo;re not sure how easy it is. Unfortunately, having the
amazing power to find bugs is also a curse: Hannes persuaded me to write
a test for an OCaml implementation of the <code>patch</code> utility
instead of sleeping one evening.</p>
<p>I&rsquo;m not sure what tool authors can do to reduce this particular
barrier to entry. Maybe one thing that works is to simply demo the tool
in front of a crowded audience, every time you have a chance.</p>
<h2>Mystery in a box</h2>
<p>I helped Antonio Monteiro track down a failure in his HTTP/2
implementation, and over the course of that I caught a glimpse of the <a href="https://github.com/inhabitedtype/angstrom">angstrom</a> codebase.
Angstrom contains a single-field record (used for first-class
polymorphism) in one apparently-central data structure, and I noticed
that the record does not carry the <code>[@@unboxed]</code> annotation
(so it is one extra indirection at runtime). So I decided to add the
annotation, hoping it would improve performances.</p>
<p>There is a dirty secret about <code>[@@unboxed]</code>: despite what
most people think, it is extremely rare that it can make programs
noticeably faster, because the GC is quite fast and combines allocations
together &ndash; many allocations of a boxed object are combined with an
allocation for their content or container, and and often the indirection
points to an immediately adjacent place in memory so is basically free
to dereference. It may help in some extreme low-latency scenario where
code is written to not allocate at all, but I have never personally seen
a program where <code>[@@unboxed]</code> makes a noticeable performance
difference.</p>
<p>That is, until <code>angstrom</code>. Adding <code>[@@unboxed]</code>
to this record field makes the program noticeably <em>slower</em>. The
generated code, at the point where this record is used, is much nicer,
each run allocates less words, but the program is noticeably slower &ndash; 7%
slower. I found it extremely puzzling; Romain <span class="citation" data-cites="dinosaure">@dinosaure</span> Calabiscetta pointed out that
he tried the same thing, and was similarly puzzled.</p>
<p>Eventually I lured Pierre Chambart into studying the problem with me,
and we figured it out. I won&rsquo;t get into the technical details here
(hopefully later), but I&rsquo;ll point out that we tested our hypothesis by
inserting <code>();</code> in several places in the program, and
Arma&euml;l&rsquo;s baffled look made it more than worthwhile.</p>
<h2>Video games</h2>
<p>When invited to work on &ldquo;anything they wanted&rdquo;, some people had a
projects that sounded a bit more fun than a parallel compiler of all
OPAM packages &ndash; a gameboy emulator, for example. Of course, everyone
knows that having fun side-projects to work on from time to time is an
excellent thing. Yet those were kept in the recent past after more
pressing side-projects on my TODO list (typically releasing ocamlbuild,
batteries, ppx_deriving and plugins once in a while, or reviewing a
compiler Pull Request). While no one was working on that specifically,
this retreat made me want to try (eventually) something that I&rsquo;ve never
done before, namely implement a video game in OCaml. We&rsquo;ll see whether
that happens someday.</p>
<h2>Conclusion</h2>
<p>Thanks to everyone who was at the retreat (including the people that
worked hard to ensure we could be there in the best condition). I had a
great time and I&rsquo;m hoping to come again for one of the next
retreats.</p>



