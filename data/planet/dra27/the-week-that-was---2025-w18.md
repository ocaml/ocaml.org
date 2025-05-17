---
title: The week that was - 2025 w18
description: "Don\u2019t let the road to perfect intentions be the enemy of the good.
  Or some other mixed metaphor. Anyhow, an attempt at musing on the week so that musing
  on musings may be slightly easier."
url: https://www.dra27.uk/blog/week-that-was/2025/05/02/wtw-18.html
date: 2025-05-02T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>Don’t let the road to perfect intentions be the enemy of the good. Or some other
mixed metaphor. Anyhow, an attempt at musing on the week so that musing on
musings may be slightly easier.</p>

<p>Hacked around with the opam packaging of OxCaml at the weekend in <a href="https://github.com/janestreet/opam-repository/tree/3cb7f5ee49e3be100d322e4dd9be18aab28dd3e8">janestreet/opam-repository#with-extensions</a>
to try to get this to work with <code class="language-plaintext highlighter-rouge">dune pkg</code>. Quick update to my opam repository
for getting <a href="https://preview.dune.build/">Dune Developer Preview</a> without
binaries (<a href="https://github.com/dra27/opam-repository/commits/e504b2c1857ec9e68b6ece7aaff95c7c6728d2da">dra27/opam-repository#dune-dp</a>),
and a thought that automating that would be an entertaining thing for Claude.
Got it working (cf. <a href="https://github.com/ocaml/dune/issues/11652#issuecomment-2833502572">ocaml/dune#11652 (comment)</a>).
Something very strange going on with the build time, as it takes twice the time
to build the first time in <code class="language-plaintext highlighter-rouge">dune pkg</code> as it does to make an opam switch
(something very strange meaning that <a href="https://github.com/dra27/opam-repository/commit/1f9445b0e8abd8b638260863e80e591548dc420b">this hack</a>
reduced the build time…).</p>

<p>We played <a href="https://boardgamegeek.com/boardgame/256680/return-to-dark-tower">RTDT</a>
for the first time in a few weeks. Undaunted Aegis and Devious Swindler vs
Utuk-ku with Covenant on gritty. Fun adversary quest laying various “ambush”
tokens on the board in order to counter unimprovable cards against the
adversary. We just won (that’s feeling like a pattern with Covenant on gritty:
not quite as, “OMG, we’re all gonna die” as Alliances on gritty).
Entertainingly we ended with the maximum 5 corruptions between us.</p>

<p>Week itself was frustratingly treacle-ish. Cursing towards getting the PR for
the test harness for Relocatable OCaml opened, to finally get this off my desk.
Challenge is to tame ~3500 lines of OCaml into something that’s vaguely
explainable and definitely maintainable and without completely breaking all the
branches which make changes to it. First baby step: break it up, but with a
little help from the OCaml module system so that rebasing the dozen or so things
which sit on top of it don’t become impossibly difficult to resolve. Lots of:</p>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">TestRelocation</span> <span class="o">:</span> <span class="k">sig</span>
<span class="c">(* Stuff that will eventually be in testRelocation.mli *)</span>
<span class="k">end</span> <span class="o">=</span> <span class="k">struct</span>
<span class="c">(* Stuff that will eventually be in testRelocation.ml *)</span>
<span class="k">end</span>
</code></pre></div></div>
<p>Got that all reconstituted and not failing late Sunday night. Having broken it
up, next challenge to be able to explain it all. The tests themselves aren’t too
bad (had to comment all that, or I didn’t understand it…), but the support
functions were an unadulterated mess. They’re not now (hopefully). And another
yay for labelled tuples (although there were a few places where I’d got a bit
too over-excited and went back to inline records…). Anyway, it’s all taken way
too long, but that branch is finally ready to write up and open 🥵</p>

<p>Circles (or possibly whack-a-mole) continued in opam world, but hopefully now
resolved. When we’ve once-and-for-all solved universal package management, we’ll
have the right story in OCaml for dealing with system compilers. Various
solutions were being juggled around… fortunately, it looks as though with some
sleight of hand, a correct alignment of planets, and a little tweak in the
repository, we should be able to have it that new users stop getting system
compilers they didn’t expect and landing into problems without breaking advanced
users in the process. TL;DR In opam 2.4, if you want a system compiler, you need
to request <code class="language-plaintext highlighter-rouge">ocaml-system</code> explicitly (which is a good thing); if you do any of
<code class="language-plaintext highlighter-rouge">opam switch create 5.3.0</code>, <code class="language-plaintext highlighter-rouge">opam switch create .</code>,
<code class="language-plaintext highlighter-rouge">opam switch create foo ocaml</code>, <code class="language-plaintext highlighter-rouge">opam switch create ocaml.5.3.0</code> and so forth,
you will hopefully end up with a compiler built from source which, unless you
<strong>REALLY</strong> know what you’re doing, is what you need.</p>

<p>Planetary Computing Group Wednesday lunches resumed, more political this week,
than necessarily technical (but then there’s a lot of politics going on 😔).
Slotted from that to an OCaml triage meeting (45 minutes of gold-dust time every
fortnight which hopefully nudge a few things forward, help a few of us core devs
vaguely stay on top of the issue tracker, and mean that we don’t have to go
through hundreds and hundreds of issues at the bigger core dev meetings). Dashed
from that to the station to get to London. Trains messing up in both directions.
Ah well…</p>

<p>Real life collided with everything else for Thursday, which messed up getting
to, well, anything. In the spirit of Flanders and Swann’s <em>The Gasman Cometh</em>,
we learned that gas boilers don’t ignite when the gas meter runs out of battery,
as it locks the supply shut instead of open at that point: and it’s not regarded
as a user diagnosable fault! We also learned that induction hobs sometimes get
upset when asked to heat things…</p>

<p>So, not a particularly wonderful week, although with a new toy having arrived
today, perhaps some tinkering to be done for a change…</p>

<p><img src="https://www.dra27.uk/assets/2025-05-02/2025-05-02-precision.jpg" alt="What to do with 7 DisplayPort sockets?"></p>
