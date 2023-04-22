---
title: OCaml 5 Release Candidate Now Available!
description:
url: https://tarides.com/blog/2022-12-07-ocaml-5-release-candidate-now-available
date: 2022-12-07T00:00:00-00:00
preview_image:
featured:
---

<p>We're in the home stretch for the full OCaml 5 release. Multicore is almost here! Yesterday its Release Candidate (RC) was announced on the <a href="https://discuss.ocaml.org/t/first-release-candidate-for-ocaml-5-0-0/10922">OCaml Discuss</a>, which is the final step before the major release, expected before Christmas.</p>
<p>To learn more about the exciting features coming with OCaml 5, you can watch <a href="https://www.youtube.com/watch?v=zJ4G0TKwzVc">KC&rsquo;s keynote address</a> and check out his <a href="https://speakerdeck.com/kayceesrk/retrofitting-concurrency-lessons-from-the-engine-room">speaker slide deck</a> as well. As always, feel free to <a href="https://tarides.com/company">contact us</a> for more information about using OCaml and for support on your OCaml projects.</p>
<p>The OCaml community has worked tirelessly to release 5.0 before the end of the year, with a lot of time spent on creating a smooth transition for OCaml users. There should be just enough time for you to try out OCaml 5 for a fun holiday project or the <a href="https://tarides.com/blog/2022-11-24-solve-the-2022-advent-of-code-puzzles-with-ocaml">Advent of Code</a>.</p>
<p>Your reports resulted in these bug fixes since the Beta 2 release last week:</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/issues/11776">11776</a>: Extend environment with functor parameters in <code>strengthen_lazy</code>. (Chris Casinghino and Luke Maurer, review by Gabriel Scherer)</li>
<li><a href="https://github.com/ocaml/ocaml/issues/11533">11533</a> and <a href="https://github.com/ocaml/ocaml/issues/11534">11534</a>: follow synonyms again in <code>#show_module_type</code> (this had stopped working in 4.14.0) (Gabriel Scherer, review by Jacques Garrigue, report by Yaron Minsky)</li>
</ul>
<p>For the full change log, <a href="https://github.com/ocaml/ocaml/blob/5.0/Changes">visit the GitHub repo</a>. The source code for the release candidate is available at these addresses:</p>
<ul>
<li><a href="https://github.com/ocaml/ocaml/archive/5.0.0-rc1.tar.gz">https://github.com/ocaml/ocaml/archive/5.0.0-rc1.tar.gz</a></li>
<li><a href="https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0~rc1.tar.gz">https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0~rc1.tar.gz</a></li>
</ul>
<p>Please keep those testing reports coming in. We believe this release candidate is ready to go, but we really value testing right up to the last minute to be even more sure. Send us your valuable input! If you find something, please <a href="https://github.com/ocaml/ocaml/issues">open an issue on GitHub</a> or join the discussion on the <a href="https://discuss.ocaml.org/t/first-release-candidate-for-ocaml-5-0-0/10922">Discuss post</a>, where you can also find installation instructions.</p>
