---
title: Into the sunset or into the dawn?
description: "Earlier this year, I returned to the Computer Laboratory at the University
  of Cambridge, as part of the Energy and Environment Group, combining with my work
  at Tarides. It\u2019s been something of a whirlwind, which doesn\u2019t look like
  it\u2019ll be abating just yet, but there\u2019s still been the odd chance to consider
  where things are and where we might be headed. I\u2019m minded of a scene from an
  opera I performed a few years ago in Hannover. In the second act of Henrico Leone
  (\U0001F981, rather than \U0001F42B, but hey), Henrico\u2019s wife, Metilda, in
  a vision sees her husband defeated in battle:"
url: https://www.dra27.uk/blog/platform/2025/07/18/through-a-glass-darkly.html
date: 2025-07-18T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>Earlier this year, I returned to the <a href="https://www.cst.cam.ac.uk">Computer Laboratory</a>
at the <a href="https://www.cam.ac.uk">University of Cambridge</a>, as part of the
<a href="https://www.cst.cam.ac.uk/research/eeg">Energy and Environment Group</a>,
combining with my work at <a href="https://www.tarides.com">Tarides</a>. It’s been
something of a whirlwind, which doesn’t look like it’ll be abating just yet, but
there’s still been the odd chance to consider where things are and where we
might be headed. I’m minded of a scene from an opera I performed a few years ago
in Hannover. In the second act of <em>Henrico Leone</em> (🦁, rather than 🐫, but hey),
Henrico’s wife, Metilda, in a vision sees her husband defeated in battle:</p>

<div style="float: right;" title="David Allsopp; NDR Radiophilharmonie; Lajos Rovatkay">
<audio controls="" controlslist="nodownload noplaybackrate">
  <source src="https://www.dra27.uk/assets/2025-07-18/2025-07-18-steffani.mp3" type="audio/mpeg">
  Your browser does not support the audio tag.
</audio>
</div>

<p><em>Morirò fra strazi e scempi e dirassi, ingiusti dei, che salvando i vostri
templi io per voi tutto perdei.</em></p>

<p>Dying, Henrico manages one last scream (almost literally in the opera; the role
is portrayed by an alto castrato), declaring, “I will die amidst torment and
destruction and it will be said, unjust gods, that in saving your temples I lost
everything for you.”. Agentic coding and the end of the programmer?
<a href="https://oxcaml.org">OxCaml</a> and the end of OCaml? <a href="https://github.com/dra27">@dra27</a>
switching from Windows to macOS? Fortunately, the vision is, as visions often
are, a Mirage. Henrico, luckily for a three act opera, has not been killed in
Act II (he survived a shipwreck at the beginning of the opera, so he – along
with the metaphor – is doing quite well!). My feeling, set down in 2025 ready
for me to laugh at, um, later in 2025 (or hopefully a few years down the line),
is that we’ll still be here for some time to come; programming in OCaml.</p>

<p>For me, the challenges and requirements on the ecosystem presented by our new AI
tooling seem very little different from the challenges and requirements we had
before. I’ve often (and not entirely originally) remarked that Windows doesn’t
usually throw up portability problems, it’s more that it shines a light and
exaggerates unfortunate parts of a system’s design (expecting to keep databases
in gazillions of flat files, assuming there’s only one directory separator
character, assuming there’s one root file system, etc., etc.). So too the needs
of LLMs shine a light on our stateful packaging systems (which we already knew
were too stateful), on the pain of package-to-library-to-module namespacing, on
the need for aggressive caching of previous build results to be able to explore
a search space. Looking at stats from <a href="https://octoverse.github.com/2022/top-programming-languages">2022</a>
(the <a href="https://github.blog/news-insights/octoverse/octoverse-2024/">2024</a> report
doesn’t appear to contain an updated statistic), one can glean that most of
GitHub’s 420+ million repositories are written in around 500 different
programming languages. My entirely ill-educated guess is that there’s not going
to be the breadth of either existing material (for training) or even need to
give your favourite agent the ability to synthesise the programming language as
well as the program any time soon!</p>

<p>I’m excited to see what’s happening and going to be happening with OxCaml. There
are several great features which have already made it from Jane Street over to
OCaml, and I fully expect the next few releases of OCaml to be reminiscent of
OCaml 4.10+, as Multicore OCaml features started to migrate over to mainline
OCaml. Also reminiscent of Multicore OCaml are things like missing Windows
support! Plus ça change, plus c’est la même chose, I guess, but then <a href="https://github.com/ocaml/ocaml/pull/9927">keeping</a>
<a href="https://github.com/ocaml-multicore/ocaml-multicore/pull/351">these</a>
<a href="https://github.com/ocaml/ocaml/pull/11642">things</a> <a href="https://github.com/ocaml/ocaml/pull/12954">going</a>
<a href="https://github.com/ocaml/ocaml/pulls?q=is:pr%20author:dra27%20fix%20in:title%20is:closed">is</a>
<a href="https://github.com/ocaml/opam/pulls?q=is:pr%20is:closed%20author:dra27%20in:title%20fix">very</a>
<a href="https://github.com/ocaml/flexdll/pulls?q=is:pr%20is:closed%20author:dra27%20in:title%20fix">much</a>
<a href="https://github.com/ocaml/ocaml/pull/14014">what</a> <a href="https://github.com/dra27/ocaml/pulls?q=is:pr%20is:open%20label:relocatable">drives</a>
<a href="https://github.com/dra27">me</a>. For better or worse, I don’t really seem to change
(although I do occasionally use macOS 😁)</p>

<p>I have always regarded my working life as divided between my work as a singer in
the performing arts and my work as an engineer/scientist in technology. More
recently, perhaps with a middle-aged tendency to muse, I see the common thread
<em>in me</em> between the two and conclude that, despite my best efforts as a geeky
child, I act more artistically than scientifically. Performing is deeply
personal. It is also a service for an audience and one’s skill, one’s expertise,
one’s talent is poured into the perfecting of that performance in the service of
its audience. For me, everything leading up to it (learning, practice,
rehearsal, etc.) is profoundly irrelevant next to the artefact of the
performance itself and the sole purpose of that preparatory work (however
satisfying and enjoyable!) is the perfecting of that artefact for that service
of performance. My personal realisation is that this idea of service has always
underpinned my drive in technology as well. From my very earliest days dabbling
with setting up school computer networks, from the first software systems I
programmed, the work was fascinating and the challenges stimulating, but it was
and is driven by the pursuit of the perfect, or right, system in the service of
its users.</p>

<p>But what of the art itself? Standing in my office now, with computers both in
front and behind me, beside me are shelves of scores and piles of other music. I
can’t easily count the number of times I have performed the major works of Bach
and Handel over the last two decades, but at each repeat performance, I strive
to achieve a closer perfection of that art from the one which preceded it -
serving both the audience <em>and</em> the art. And here I find the service of the
art-<em>e-fact</em> - the maintenance of that which one has written or which one has
done. I don’t abandon that which I haven’t yet perfected and which still has an
audience.</p>

<p>Perhaps it is this service of the art in the service of others which has driven
and continues to drive my desire to improve our small corner of the world of
technology, rather than necessarily to produce other things with it. Although it
really is nice to get to do that occasionally, too. Which in a meandering sort
of a way is where the last year, and in particular this last 3-4 months, have
been. Relocatable OCaml was an idea formulated over a few hours of thinking and
writing in 2019, and in fact originally conceived during a rehearsal. Showing
that it was a technically viable idea was done over a few weeks of hacking
in 2021. Getting it to a stable state such that it could be demonstrated across
the three major platforms on all current releases of OCaml was done over a few
months of feverish work in 2022. You can possibly see where this is going:
getting it to an upstreamable state where it can be maintained for the future
has taken the next order of magnitude in time, it would appear!</p>

<p>I’ve already written in some detail <a href="https://github.com/dra27/RFCs/blob/relocatable/rfcs/relocatable.md">what it’s supposed to do</a>.
Why it matters seems to touch so many areas for so many users. With Relocatable
OCaml, opam switches can be created to your heart’s content, wasting neither CPU
time and energy to build the same compiler again, nor disk space to store it,
and without having to wait until we can morph the entire ecosystem to another
different way of doing things instead. Likewise, in Dune, the compiler can
finally be treated as any other package and cached between projects. Engineers
working on the compiler itself can now drop in a replacement development
compiler into an opam switch without having to curse and rebuild it with the
correct prefix for that switch. For users, it Just Works™, and hopefully in a
few years’ time newcomers will wonder how it could ever not always have been
that way.</p>

<p>When the curtain comes down on this performance, hopefully all its users will
applaud through some measure of decreased grumpiness and increased productivity.
Hopefully the coffee market will not be too impacted by the lack of
<code class="language-plaintext highlighter-rouge">opam switch create</code>-induced breaks. Hopefully the distance to perfection will
be a little smaller.</p>

<p>And I’ll look to the next performance. We aren’t done yet.</p>
