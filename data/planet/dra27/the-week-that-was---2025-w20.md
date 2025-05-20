---
title: The week that was - 2025 w20
description: "This week consisted of a lot of spinning plates, which is unfortunate
  because it\u2019s not something I\u2019m very good at!"
url: https://www.dra27.uk/blog/week-that-was/2025/05/18/wtw-20.html
date: 2025-05-18T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>This week consisted of a lot of spinning plates, which is unfortunate because
it’s not something I’m very good at!</p>

<p><a href="https://ryan.freumh.org/">Ryan</a> and I spent some time investigating being able
to get opam packages to emerge via <code class="language-plaintext highlighter-rouge">pipx</code> (and therefore, <code class="language-plaintext highlighter-rouge">uvx</code>). Idea here is
to be able to consume an OCaml application from a Python ecosystem (i.e. the
fact it’s OCaml is probably unimportant to the person invoking it). Requires
quite a few layers on the Python infra side - we’re meeting in the middle using
<a href="https://pypi.org/project/scikit-build-core/">scikit-build-core</a> on the Python
side to give us the ability to invoke stuff on the OCaml-side. Pulls in some of
our cross-ecosystem encoding work from last year as well. More to go, and also
interested to nudge this from the other direction - opening up the possibility
of consuming OCaml applications this way becomes even more interesting if the
OCaml ecosystem also encourages them to be packaged this way (i.e.
opam-repository is mostly libraries, not applications…).</p>

<p>This all sparked off more discussions with <a href="https://patrick.sirref.org/index/index.xml">Patrick</a>
and <a href="https://ryan.freumh.org/">Ryan</a> on the formalism in our package management
paper, but <a href="https://ryan.freumh.org/2025-05-12.html#update-the-package-management-paper-for-arxiv-publication">Ryan wrote that up!</a></p>

<p>The Relocatable OCaml spinning plate got some updates, too: <a href="https://github.com/ocaml/ocaml/pull/13728">ocaml/ocaml#13728</a>
got merged, which allowed <a href="https://github.com/ocaml/ocaml/pull/14014">ocaml/ocaml#14014</a>
to be updated to remove it. That PR had some helpful review feedback and, while
poking another of the branches, found a minor bug in it! While trying to put
a coherent explanation for the second of the “big” PRs, found a(nother) design
flaw. There’s a bigger post to come about the history of this change, but
fortunately as with the previous issues, it’s more that the “complicated”
approach needed in one place is also needed in another. I’ve found the bugs in
this branch have all meant resurrected previous commits which I’d thought were
overcomplicating things, rather than actually having to write new stuff. Anyhow,
having fixed that, I managed to consolidate an essay at <a href="https://github.com/dra27/ocaml/pull/162">dra27/ocaml#162</a>
and the gory details of what should now be the final approach for this are in
the “Technical background” fold on that PR! At some point in the coming weeks
I’ll try to add the history behind getting to that here, if only so I don’t
forget it!</p>

<p>Incidentally, there’s a plea gone out from my core maintainer colleagues for
anyone who’d like to take a go at reviewing these things to have a look (see
<a href="https://discuss.ocaml.org/t/volunteers-to-review-the-relocatable-ocaml-work/16667">this Discuss thread</a>.</p>

<p>More whiteboarding with <a href="https://jon.recoil.org">Jon</a> figuring out some build-
related ideas behind his JavaScript toplevels (odoc-notebook). The whole thing
becomes cross-compilation on speed, but particularly interesting that we might
be able to get some OxCaml demos going with it, while temporarily keeping the
main parts of the compilation still in OCaml, avoiding problems with patches
that aren’t yet available for OxCaml support (means you’d be able to show
OxCaml code, with some under-the-hood work in the equivalent OCaml compiler
doing the rendering heavy lifting for now).</p>

<p>In the meantime, also putting together some ideas for an EoI for <a href="https://www.software.ac.uk/research-software-maintenance-fund/round-1">RSMF</a>,
which is all a bit new (the process is new; the ideas are fundmentally not, as
that’s the point of the call!). Getting that fully tied up will be a chunk of
next week, along with getting various other things in line in order to be
incognito the week following.</p>
