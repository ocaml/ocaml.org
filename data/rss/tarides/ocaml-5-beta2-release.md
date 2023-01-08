---
title: OCaml 5 Beta2 Release
description: "Just about a month after the OCaml 5 Beta release, the OCaml 5 Beta2
  version has been released, taking us one step closer to the full OCaml\u2026"
url: https://tarides.com/blog/2022-11-29-ocaml-5-beta2-release
date: 2022-11-29T00:00:00-00:00
preview_image: https://tarides.com/static/37eb312d700b065239a4797fa427a8ee/0132d/beta2.jpg
featured:
---

<p>Just about a month after the <a href="https://tarides.com/blog/2022-10-17-ocaml-5-beta-release">OCaml 5 Beta release</a>, the OCaml 5 Beta2 version has been released, taking us one step closer to the full OCaml 5 with Multicore release later this year. The OCaml community's collaboration is coming to fruition! Although we're not quite ready for the RC1 (Release Candidate) version, several things have been added and improved with Beta2.</p>
<p>To learn more about the exciting things coming with OCaml 5, please watch KC Sivaramakrishnan&rsquo;s <a href="https://www.youtube.com/watch?v=zJ4G0TKwzVc">keynote address</a> and check out <a href="https://speakerdeck.com/kayceesrk/retrofitting-concurrency-lessons-from-the-engine-room">his speaker slide deck</a> as well. As always, feel free to <a href="https://tarides.com/company">contact us</a> for more information about using OCaml and for support on your OCaml projects.</p>
<p>Here's a partial list of improvements/fixes with <a href="https://github.com/ocaml/ocaml/issues">issue numbers</a>:</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/pull/11631">#11631</a> - fix an assertion dealing with a segfault found by the Multicore test suite</li>
<li><a href="https://github.com/ocaml/ocaml/issues/11662">#11662</a>, <a href="https://github.com/ocaml/ocaml/pull/11673">#11673</a> - memory leak affecting <code>dynlink</code> with frame descriptor tables (reported by Frama-C devs)</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11704">#11704</a>, <a href="https://github.com/ocaml/ocaml/issues/11669">#11669</a> - segfault with effects fixed, having been tracked down to the refactoring of <code>Effect.Unhandled</code></li>
<li><a href="https://github.com/ocaml/ocaml/pull/11701">#11701</a> - fix spurious <code>.dSYM</code> files and directories being created on macOS</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11671">#11671</a> - bug in <code>top_heap_words</code> statistics accounting fix</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11670">#11670</a> - macOS fix when creating empty archives</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11097">#11097</a> - NetBSD fixes, including ARM64 support</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11194">#11194</a>, <a href="https://github.com/ocaml/ocaml/pull/11609">#11609</a> - fixes a regression from 4.14</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11622">#11622</a> - fixes a regression in error messages since 4.10</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11725">#11725</a> - remove <code>caml_alloc_N</code></li>
<li><a href="https://github.com/ocaml/ocaml/pull/11661">#11661</a> - erroneous <code>-force-tmc</code> option removed</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11367">#11367</a>, <a href="https://github.com/ocaml/ocaml/pull/11652">#11652</a> - Windows clean-ups</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11611">#11611</a> - fix --disable-instrumented-runtime</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11639">#11639</a> - configuration bookkeeping (ensure system, etc., always set)</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11632">#11632</a> - minor bookkeeping bug fix</li>
<li><a href="https://github.com/ocaml/ocaml/pull/11559">#11559</a>, <a href="https://github.com/ocaml/ocaml/pull/11649">#11649</a>, <a href="https://github.com/ocaml/ocaml/pull/11640">#11640</a>, <a href="https://github.com/ocaml/ocaml/pull/11301">#11301</a>, <a href="https://github.com/ocaml/ocaml/pull/11705">#11705</a> - docs updates</li>
</ul>
<p>In short, we're continuing to stabilise the release. We're also dealing with reports coming from the wonderful testing that's been going on, especially Multicore tests and the Frama-C report. Keep those testing reports and feedback coming by <a href="https://github.com/ocaml/ocaml/issues">opening an issue on the GitHub repo</a> or chiming in through the <a href="https://discuss.ocaml.org/t/ocaml-5-0-0-second-beta-release/10871">OCaml Discuss forum post</a>.</p>
<p>Thanks to the hard work by all engineers working to make OCaml even better than before. It's a beautiful sight to watch brilliant developers come together on an open-source project like OCaml, and Tarides is proud to be part of this ever-growing community.</p>
