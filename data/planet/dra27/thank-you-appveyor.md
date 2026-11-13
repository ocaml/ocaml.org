---
title: Thank you, AppVeyor
description: "Just under 11 years ago, Christophe Troestler opened ocaml/ocaml#307
  and the OCaml project\u2019s association with AppVeyor began."
url: https://www.dra27.uk/blog/platform/2026/11/10/thank-you-appveyor.html
date: 2026-11-10T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
keywords:
- acknowledgement
- actions
- appveyor
- github
- hour
- runners
- spent
- travis
- windows
- years
---

<p>Just under 11 years ago, <a href="https://github.com/Chris00">Christophe Troestler</a>
opened <a href="https://github.com/ocaml/ocaml/pull/307">ocaml/ocaml#307</a> and the OCaml
project’s association with <a href="https://www.appveyor.com/">AppVeyor</a> began.</p>

<p>Travis CI had been added by <a href="https://anil.recoil.org">Anil</a> in 2014 in <a href="https://github.com/ocaml/ocaml/pull/47">ocaml/ocaml#47</a>
(back then, review took place on GitHub for PRs, but if accepted they were
actually committed manually to OCaml’s Subversion repository at Inria, which is
why all these PRs look “closed”). Windows support, as so often, had lagged
behind in the emerging field of Continuous Integration systems. Aside from the
obvious cost of OS licenses not required for Linux-testing, the virtualisation
story was harder. Inria’s CI systems, for example, were (indeed, still are)
stateful; an unacceptable configuration for arbitrary incoming pull requests.
Having spent a good chunk of my early computer years administering automated
Windows rebuilds, I knew first-hand that reliably orchestrating clouds of
Windows VMs to be created for 1 hour jobs <em>and then simply be reaped</em> was no
mean feat.</p>

<p>That, however, is what we were given - up to 1 hour per pull request or branch
push. On top of that, an incredibly useful feature of AppVeyor was that you
could even hold on to what was left of that hour and connect to the worker to
debug what had failed. On a series of evenings in 2019, I spent many hours
submitting jobs to AppVeyor to get another 30 minutes’ debugging time on a
system for which planets had aligned <a href="https://github.com/ocaml/ocaml/pull/9051">to reveal a GC bug in the Unix library</a>!
Travis CI had some planets-aligned discoveries too; <a href="https://github.com/ocaml/ocaml/pull/1483">ocaml/ocaml#1483</a>
sprang out of memory layout happening to put OCaml processes straddling the
correct address space boundary to trigger a pointer arithmetic error.</p>

<p>We switched away from Travis CI to GitHub Actions in <a href="https://github.com/ocaml/ocaml/pull/10214">ocaml/ocaml#10214</a>
in 2021, and we started using Windows runners on GitHub Actions when we restored
the MSVC port of OCaml in 2024 (<a href="https://github.com/ocaml/ocaml/pull/12954">ocaml/ocaml#12954</a>).
AppVeyor had been creaking at the seams for us for a few years, initially
because although our number of contributors had increased, as an open source
project we were still limited to just the one Windows runner, and the queue
could really build up, but also because since OCaml 5, the size of the runners
was becoming an issue, and we were having to limit testing (<a href="https://github.com/ocaml/ocaml/pull/11389">ocaml/ocaml#11389</a>).</p>

<p>But we’re finally there! Nicolás bit the bullet in <a href="https://github.com/ocaml/ocaml/pull/15209">ocaml/ocaml#15209</a>
and nerd-sniped me into doing some further work and so we’re now fully on
GitHub Actions runners for Linux, macOS and Windows. GitHub’s open source
support gives us a very generous number of runners. Looking back, the Git
history for the <a href="https://github.com/ocaml/ocaml/commits/trunk/appveyor.yml">three</a>
<a href="https://github.com/ocaml/ocaml/commits/trunk/tools/ci/appveyor/appveyor_build.sh">configuration</a>
<a href="https://github.com/ocaml/ocaml/commits/trunk/tools/ci/appveyor/appveyor_build.cmd">files</a>
suggests I’ve spent an unhealthy amount of time in the last ten years working on
this: a big thank you and acknowledgement to the team at AppVeyor for the
support we’ve had over the years, and here’s to ever-continuing Windows support
in OCaml!</p>
