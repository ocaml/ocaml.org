---
title: Coq 8.6 rc 1 is out
description:
url: https://coq.inria.fr/news/coq-86rc1-is-out.html
date: 2016-12-08T00:00:00-00:00
preview_image:
featured:
authors:
- coq
---


The <a href="https://coq.inria.fr/coq-86">first release candidate of Coq 8.6</a> is available for
testing.

Coq 8.6 includes:

<ul>
<li>A new, faster state-of-the-art universe constraint checker by
  Jacques-Henri Jourdan.</li>
<li>In CoqIDE and other asynchronous interfaces, more fine-grained
  asynchronous processing and error reporting by Enrico Tassi, making
  Coq capable of recovering from errors and continuing to process the
  document.</li>
<li>Better access to the proof engine features from Ltac: goal management
  primitives, range selectors and a typeclasses eauto engine handling
  multiple goals and multiple successes, by Cyprien Mangin, Matthieu
  Sozeau and Arnaud Spiwack.</li>
<li>Tactic behavior uniformization and specification, generalization of
  intro-patterns by Hugo Herbelin and others.</li>
<li>A brand new warning system allowing to control warnings, turn them
  into errors or ignore them selectively by Maxime D&eacute;n&egrave;s, Guillaume
  Melquiond, Pierre-Marie P&eacute;drot and others.</li>
<li>Irrefutable patterns in abstractions, by Daniel de Rauglaudre.</li>
<li>The ssreflect subterm selection algorithm by Georges Gonthier and
  Enrico Tassi, now accessible to tactic writers through the
  ssrmatching plugin.</li>
<li>LtacProf, a profiler for Ltac by Jason Gross, Paul Steckler, Enrico
  Tassi and Tobias Tebbi.</li>
</ul>

<p>More information can be found in the <a href="https://coq.inria.fr/distrib/V8.6rc1/CHANGES">CHANGES</a> file. Feedback and
<a href="https://coq.inria.fr/bugs">bug reports</a> are extremely welcome.</p>

<p>Coq 8.6 initiates a time-based release cycle, with a major version being
released every 10 months. The roadmap is also made public.</p>

<p>To date, Coq 8.6 contains more external contributions than any previous
Coq version. Code reviews were systematically done before integration
of new features, with an important focus given to compatibility and
performance issues.</p>


 
