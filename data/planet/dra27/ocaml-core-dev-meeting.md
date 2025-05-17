---
title: OCaml Core Dev Meeting
description: "OCaml Core Dev meeting at Inria yesterday. These are roughly biannual
  synchronous catchups which provide a chance to find out what others are up to, get
  feedback on any major ongoing work, and attempt to unblock some stalled PRs. Sometimes
  tempers get frayed, but not this time round\u2026"
url: https://www.dra27.uk/blog/platform/2025/03/28/ocaml-dev-meeting.html
date: 2025-03-28T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>OCaml Core Dev meeting at <a href="https://inria.fr">Inria</a> yesterday. These are
roughly biannual synchronous catchups which provide a chance to find out what
others are up to, get feedback on any major ongoing work, and attempt to unblock
some stalled PRs. Sometimes tempers get frayed, but not this time round…</p>

<p>Quick round-table: ongoing work to get modular explicits/implicits into OCaml; a
lot of work on GC pacing to get the 5.x GC to follow its space overhead setting
properly; lot of work on flambda 2; OCaml Language committee has been launched
and has two proposals under consideration; quite a lot of reviewing of new
features from Jane Street in flight; work on pluggable GC to be able to try out
alternate GCs in the main runtime.</p>

<p>Two presentations on the table. The OCaml 5.x GC isn’t working hard enough to
keep to its space overhead - Jane Street had seen issues with it, as have
Semgrep (and <a href="https://semgrep.dev/blog/2025/upgrading-semgrep-from-ocaml-4-to-ocaml-5/">blogged about it</a>).
<a href="https://github.com/stedolan">Stephen Dolan</a>, <a href="https://github.com/NickBarnes">Nick Barnes</a>
and <a href="https://github.com/damiendoligez">Damien Doligez</a> have been doing a lot of
investigation and work recently into this, which Stephen presented. Lots of
maths and logical argument leading to a very pleasingly small patch which vastly
reduces the overshoot of the 5.x GC. Unlikely to be in 5.4, but it’s in use
already inside JS and should be with us for 5.5.</p>

<p>My Relocatable OCaml was next, with fewer graphs, but a functioning demo!
Managed to push the <a href="https://github.com/ocaml/RFCs/pull/53">RFC for it</a> a few
hours before the meeting. The combined version of it passed <a href="https://ci.inria.fr/ocaml/job/precheck/1030/">on all platforms</a>
in the early hours of Thursday morning! Main aim presenting it’s to get sign-off
on the principles behind it, see if anyone’s too horrified by the suggested
design, and then beg to see if it can still be being reviewed past the feature
freeze for 5.4. Well-received - a few bits of useful feedback to experiment with
and as ever getting these things reviewed will be fun.</p>

<p>Feature freeze for OCaml 5.4 on 15 April - useful discussion on reviewing
requirements for large changes coming out of Jane Street (and affecting Tarides
a bit, too).</p>

<p>Presentation and considerable discussion on pure functors (<a href="https://github.com/ocaml/ocaml/pull/13905">ocaml/ocaml#13905</a>).
Didn’t particularly reach a conclusion.</p>

<p>Follow-up discussion on <a href="https://github.com/ocaml/ocaml/pull/12307">ocaml/ocaml#12307</a>,
looking to stop using MD5 in the Standard Library (finally). It’s amazing how
backwards-compatibility concerns end up eating so much time with these things:
plan is to switch the default hashing to 128bit Blake2 in 5.5 (which yields
hashes of the same length as MD5 as a stop-gap to check how bad any breakage is)
and then perhaps switch it again to something stronger. Main aim is to ensure
that we get the ecosystem to a point where anyone using a <em>default</em> hash really
isn’t relying on the choice of what that is (and it means we stop getting
criticised for the consistency checksums in OCaml’s .cmi files and so forth not
being a crytographically secure hash function…….).</p>

<p>Some more maintenance discussions: we’d vastly reduced the complexity behind
building the <code class="language-plaintext highlighter-rouge">Dynlink</code> library in 5.3, and I’d had a quick sprint one weekend in
January on removing loads of duplicated code in the toplevel by shifting
<code class="language-plaintext highlighter-rouge">Dynlink</code> into the Standard Library (<a href="https://github.com/ocaml/ocaml/pull/13745">ocaml/ocaml#13745</a>).
Decision instead of moving <code class="language-plaintext highlighter-rouge">Dynlink</code> towards the Standard Library was to try
moving the toplevel further out in the build, making its build more like the
debugger. Sewing kit needed on the PR, but the code-reduction effect will still
be the same! Also a quick “temperature in the room” discussion on whether it’d
be a good idea at some point to split the parts of the Standard Library which
are really about the runtime into a separate library (the various “internal”
modules, <code class="language-plaintext highlighter-rouge">Obj</code>, <code class="language-plaintext highlighter-rouge">Marshal</code>, <code class="language-plaintext highlighter-rouge">Callback</code>, etc.). Surprisingly diverse reasons for
possibly wanting to do that, ranging from making the GC clearer to understand in
the runtime, to helping with Standard Library replacements (Core, etc.).
Maintenance discussion on <code class="language-plaintext highlighter-rouge">ocamltest</code> as well - conclusion is that there’s quite
a lot of things we’d like to do to improve it, and some of us may even get round
to doing some of them! 32-bit platforms were talked about, too - what might we
gain if we stopped supporting them. There’s various bits of code in the runtime
which some of us might wish weren’t there (but which aren’t necessarily causing
maintenance pain). There was some hope from the Jane Street side that we might
be able to get rid of the need to track immediate64 (that is, values which are
immediates on a 64bit system but are boxed on a 32bit system), but both
JavaScript and WebAssembly mean that even if we stopped building the runtime on
32bit systems, we’d still need that that distinction internally. Conclusion for
now is that the bell is probably tolling, but it’s not yet time to remove them
(which keeps me happy for now… there’s a hoarder in me that never really wants
to remove anything which still actually works!).</p>

<p>Atomic records (<a href="https://github.com/ocaml/ocaml/pull/13404">ocaml/ocaml#13404</a>
and <a href="https://github.com/ocaml/ocaml/pull/13707">ocaml/ocaml#13707</a>) got
discussed again. Just about agreed that <code class="language-plaintext highlighter-rouge">[%atomic.loc]</code> might go in - but
there’s still a lingering concern that pointers might creep in…! More naming
things, too (why is naming so hard?!) - although in this case we’ve accidentally
ended up with a proposal for a function intended to block on a mutex having
<code class="language-plaintext highlighter-rouge">_non_blocking</code> in its name, so maybe naming really is that hard! Similarly, an
agreement that having <code class="language-plaintext highlighter-rouge">let+</code>, <code class="language-plaintext highlighter-rouge">and+</code>, <code class="language-plaintext highlighter-rouge">let*</code> and <code class="language-plaintext highlighter-rouge">and*</code> operators in submodules
should go ahead (this is for <code class="language-plaintext highlighter-rouge">Result.Syntax</code> in <a href="https://github.com/ocaml/ocaml/pull/13696">ocaml/ocaml#13696</a>),
but possibly with even more discussion on the name <code class="language-plaintext highlighter-rouge">Syntax</code> required 😁</p>

<p>Following on from the last meeting in October, there’d been some ideas behind
being able to signal to the GC that a program is not in the “steady state”
(where memory is allocated at the same rate as memory is becoming garbage).
That’s been exposed as two new functions <code class="language-plaintext highlighter-rouge">Gc.ramp_up</code> and <code class="language-plaintext highlighter-rouge">Gc.ramp_down</code> in
<a href="https://github.com/ocaml/ocaml/pull/13861">ocaml/ocaml#13861</a> and benchmarking
in Rocq is showing that it’s beneficial when you have a lot of data to
unmarshal. Sounds like that’ll be in 5.4 - the same workloads may also benefit
from the GC pacing changes, but having programs be able to tell the GC that
they’re either in the process of allocating or releasing large amounts of memory
is useful knowledge, regardless.</p>

<p>The evaluation order is not defined! Except that programs seem to rely on it. It
turns out that having it change in subtle ways in the compiler is confusing and
problematic for implementation reasons, too - we agreed that it should be made
consistent <strong>if still technically not defined</strong> (<a href="https://github.com/ocaml/ocaml/pull/13882">ocaml/ocaml#13882</a>).</p>

<p>We don’t have enough ways to write strings in OCaml sources (<a href="https://github.com/ocaml/ocaml/issues/13860">ocaml/ocaml#13860</a>),
but given that we’d end up using this “readable multi-line quoted string
literals” in the compiler’s sources, if we added them, there’s a consensus that
we should come to a consensus on how to write them!</p>

<p>Finally, as we steamed towards the end of the meeting, we agreed that this:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>type t = T
type u = t
type v = u = T
</code></pre></div></div>

<p>identified in <a href="https://github.com/ocaml/ocaml/issues/13872">ocaml/ocaml#13872</a>
would still not be allowed, but thank goodness that “Their kinds differ” is no
longer the error message.</p>

<p>Not quite as many things settled on for stalled PRs and so forth as we did in
October’s meeting, but various things moved forward. Now to continue steaming
towards actually opening the pull requests for Relocatable OCaml…</p>
