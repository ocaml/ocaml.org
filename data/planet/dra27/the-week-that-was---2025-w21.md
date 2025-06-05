---
title: The week that was - 2025 w21
description: This week was a grant application, build systems, and code review - which
  it turns out is somewhere in the Amazon.
url: https://www.dra27.uk/blog/week-that-was/2025/05/24/wtw-21.html
date: 2025-05-24T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>This week was a grant application, build systems, and code review - which it
turns out is <a href="https://what3words.com/grant.builds.review">somewhere in the Amazon</a>.</p>

<p>On holiday next week, so most of this week spent attempting to do 1.5-2x the
work in order to go on holiday (one day…). Some minor diversions on the way.
The vagaries of opam-repository testing meant that an <a href="https://github.com/ocaml/opam-repository/pull/27839#issuecomment-2851180027">unrelated PR</a>
highlighted that my solitary non-OCaml-compiler opam package <a href="https://ocaml.org/p/bitmasks/latest">bitmasks</a>
had become bitrots since for OCaml 5.1.0. One <a href="https://github.com/metastack/bitmasks/pull/7"><code class="language-plaintext highlighter-rouge">to_list</code></a>
function later, and <a href="https://github.com/ocaml/opam-repository/pull/27899">1.5.0</a>
was born, for your representing-integer-masks-as-sets needs (I wrote the library
years ago for use in a never-released set of ODBC bindings, as I subsequently
got mildly distracted by opam and then the compiler).</p>

<p>More fun from the trenches doing some routine work on OCaml’s GitHub Actions
workflows to prepare for some slightly less routine Relocatable OCaml stuff. We
still maintain OCaml 4.14 while the 5.x releases converge (we’re very nearly
there: my hunch is that we may decide after OCaml 5.5 that we’re in a position
to sunset 4.14, but we’ll see). However, that means we have to sustain testing
infrastructure on a quite old branch and, well, continuous integration funnily
enough has to be continuously maintained. Previously, what would happen is that
we’d be attempting to backport something to 4.14, would discover CI was broken
and then have to spend time fixing that before getting on with the work. I got
fed up with this after <a href="https://github.com/ocaml/ocaml/pull/12520">ocaml/ocaml#12520</a>
and so did a bunch of work to synchronise all the branches (<a href="https://github.com/ocaml/ocaml/pull/12846">ocaml/ocaml#12846</a>, 
<a href="https://github.com/ocaml/ocaml/pull/12847">ocaml/ocaml#12847</a>, <a href="https://github.com/ocaml/ocaml/pull/12848">ocaml/ocaml#12848</a>
and <a href="https://github.com/ocaml/ocaml/pull/12849">ocaml/ocaml#12849</a>). Not
particularly glamorous, but it means I can now periodically do:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>git log <span class="nt">--first-parent</span> <span class="nt">--oneline</span> upstream/trunk <span class="nt">--</span> .github tools/ci/actions
</code></pre></div></div>

<p>and get a nice list of recent PRs to go through and simply cherry-pick the ones
which update the workflows - having got all the branches in sync, that tends to
be painless, and I got to a nice little sequence on <a href="https://github.com/dra27/ocaml/commits/4.14">dra27/ocaml#4.14</a>.
The ulterior motive is that I particularly wanted the updates in <a href="https://github.com/ocaml/ocaml/pull/14013">ocaml/ocaml#14013</a>
to be able to get Relocatable OCaml back to 5.2 so that it can be rebased on to
OxCaml. Took the customary amount of to-and-fro between my ridiculous
<a href="https://github.com/dra27/relocatable/blob/main/stack">re-stacking-and-backport-script</a>
and CI, but I got <a href="https://github.com/dra27/ocaml/pull/169">the 5.2 version</a>
passing from the sunny hills of Wales only an hour or two into the holiday, and
while everyone was distracted playing <a href="https://www.looneylabs.com/games/fluxx">Fluxx</a>
(which lasted a surprisingly long time, for anyone who’s ever played it…).</p>

<p>Relocatable OCaml’s test harness (<a href="https://github.com/ocaml/ocaml/pull/14014">ocaml/ocaml#14014</a>)
had some very helpful reviews, and that’s now updated and ready to merge. So,
week off and then hopefully full steam ahead with getting the third PR branch
completed and, erm, some more reviewing 🫣</p>
