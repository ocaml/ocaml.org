---
title: OCaml 5.4 and opam 2.4 on their way
description: "opam 2.4 was branched last week\u2026 very pleasing to see Ryan\u2019s
  work on Nix depext support get merged (we spent quite a bit of time on that together
  last summer). It\u2019s a subtle-sounding (huge) change, but the move away from
  relying on patch and diff as external commands (which has been a HUGE amount of
  work done by @kit-ty-kate) paves the way for being able to sort out the incredible
  slowness of opam update on Windows."
url: https://www.dra27.uk/blog/platform/2025/04/22/branching-out.html
date: 2025-04-22T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p><a href="https://opam.ocaml.org/blog/opam-2-4-0-alpha1/">opam 2.4</a> was branched last
week… very pleasing to see <a href="https://ryan.freumh.org/">Ryan’s</a> work on Nix depext
support get merged (we spent quite a bit of time on that together last summer).
It’s a subtle-sounding (huge) change, but the move away from relying on <code class="language-plaintext highlighter-rouge">patch</code>
and <code class="language-plaintext highlighter-rouge">diff</code> as external commands (which has been a HUGE amount of work done by
<a href="https://github.com/kit-ty-kate">@kit-ty-kate</a>) paves the way for being able to
sort out the incredible slowness of <code class="language-plaintext highlighter-rouge">opam update</code> on Windows.</p>

<p><a href="https://icfp24.sigplan.org/details/ocaml-2024-papers/10/Opam-2-2-and-beyond">Not at all coincidentally</a>,
OCaml 5.4 was frozen two days ago as well. Relocatable OCaml not quite ready in
time, but at least those PRs will be ready really, really[, really] soon 🫣…</p>
