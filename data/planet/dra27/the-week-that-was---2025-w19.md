---
title: The week that was - 2025 w19
description: "Still \U0001FA80ing somewhat, but various nice things happened this
  week."
url: https://www.dra27.uk/blog/week-that-was/2025/05/09/wtw-19.html
date: 2025-05-09T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p>Still 🪀ing somewhat, but various nice things happened this week.</p>

<p><a href="https://en.wikipedia.org/wiki/Star_Wars_Day">Star Wars Day</a> marked the opening,
finally, of the test harness for Relocatable OCaml in <a href="https://github.com/ocaml/ocaml/pull/14014">ocaml/ocaml#14014</a>,
along with a smaller PR with various bits of CI nonsense (<a href="https://github.com/ocaml/ocaml/pull/14013">ocaml/ocaml#14013</a>).
That got merged fairly swiftly (thanks Antonin!). Chipping away at getting the
three main PRs finally ready to be opened, but that can’t actually happen until
the test harness is reviewed and in…</p>

<p>Still in OCaml-land, <a href="https://github.com/ocaml/flexdll">FlexDLL</a> had accumulated
quite a collection of fixes, and having got the <a href="https://github.com/ocaml/flexdll/pull/158">last one merged</a>,
I figured it was high time for <a href="https://discuss.ocaml.org/t/flexdll-0-44-released/16614">a release</a>.</p>

<p>Changed tack (finally) had some fun playing with <a href="https://www.dra27.uk/blog/platform/2025/05/07/oxcaml-toes.html">OxCaml</a>,
versus just getting it packaged and installable. By sheer coincidence, then met
up with the “Cambridge” Jane Street trio (Dolan-Barnes-Shinwell), who were
marking the rollout of “runtime5” (i.e. OCaml 5.2) at JS with a <a href="https://www.the-geldart.co.uk/">little pub
outing</a>.</p>

<p>I finally watched the <a href="https://www.youtube.com/watch?v=gSKTfG1GXYQ">entire talk</a>
I’d been encouraging many people to watch for several months (I had skimmed it
before!!). It’s bittersweet for me: quite a few of the tricks here are things
I’ve advocated for a <em>long</em> time in opam, but it’s very cool to have another
example to point at. I got nerd-sniped by a couple of things in the talk, and
was hoping to be able to see if there were some possible OxCaml ideas - however,
on this occasion it turned out that there were some easy victories to be scored
(see <a href="https://github.com/ocaml/opam/pull/6515">ocaml/opam#6515</a>; I may have
accidentally launched a kernel build with <code class="language-plaintext highlighter-rouge">make -j</code> and no number, although
hopefully my laptop will survive). Anyway, pretty cool to get <code class="language-plaintext highlighter-rouge">opam show dune</code>
which takes about 1s on my laptop to display anything down to 140ms with only a
train journey’s-and-a-bit of merciless hacking.</p>

<p>Lots of musings around <a href="https://github.com/astral-sh/uv">uv</a> and discussions
with <a href="https://patrick.sirref.org/index/index.xml">Patrick</a> and <a href="https://ryan.freumh.org/">Ryan</a>.
Already toying with the idea of validating <a href="https://www.tunbury.org/">Mark’s</a>
bulk-builder work (that’s in use already on the pipelines for the
<a href="https://jon.recoil.org/blog/2025/04/ocaml-docs-ci-and-odoc-3.html">OCaml docs CI</a>)
by plugging it into an experimental Dune version. Now toying with whether it
would not be too crazy to put an experimental tool together instead (there’s I
think still a screaming ecosystem gap in OCaml for <code class="language-plaintext highlighter-rouge">uvx</code> or <code class="language-plaintext highlighter-rouge">uv run</code> - neither
idea’s original to <code class="language-plaintext highlighter-rouge">uv</code>, but putting them under the one roof, cargo-style, looks
kinda awesome). But there’s always the screaming sound of <a href="https://xkcd.com/927/">xkcd#927</a>.</p>
