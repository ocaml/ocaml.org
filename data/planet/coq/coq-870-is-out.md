---
title: Coq 8.7.0 is out
description:
url: https://coq.inria.fr/news/coq-870-is-out.html
date: 2017-10-17T00:00:00-00:00
preview_image:
featured:
authors:
- coq
---


The <a href="https://coq.inria.fr/coq-87">final release of Coq 8.7.0</a> is available.

Coq 8.7 includes:

<ul>
  <li>A large amount of work on cleaning and speeding up the code base, notably
    the work of Pierre-Marie P&eacute;drot on making the tactic-level system
    insensitive to existential variable expansion, providing a safer API to
    plugin writers and making the code more robust.</li>
  <li>New tactics:
    <ul>
      <li>Variants of tactics supporting existential variables <tt>eassert</tt>,
        <tt>eenough</tt>, etc. by Hugo Herbelin;</li>
      <li>Tactics <tt>extensionality in H</tt> and <tt>inversion_sigma</tt> by
        Jason Gross;</li>
      <li><tt>specialize with</tt> accepting partial bindings by Pierre
        Courtieu.</li>
    </ul>
  </li>
  <li>Cumulative Polymorphic Inductive Types, allowing cumulativity of
    universes to go through applied inductive types, by Amin Timany and
    Matthieu Sozeau.</li>
  <li>The SSReflect plugin by Georges Gonthier, Assia Mahboubi and Enrico Tassi
    was integrated (with its documentation in the reference manual) by Maxime
    D&eacute;n&egrave;s, Assia Mahboubi and Enrico Tassi.</li>
  <li>The <tt>coq_makefile</tt> tool was completely redesigned to improve its
    maintainability and the extensibility of generated Makefiles, and to make
    <tt>_CoqProject</tt> files more palatable to IDEs by Enrico Tassi.</li>
</ul>

<p>More information can be found in the <a href="https://github.com/coq/coq/blob/V8.7.0/CHANGES">CHANGES</a> file. Feedback and
<a href="https://coq.inria.fr/bugs">bug reports</a> are extremely welcome.</p>

<p>This is the second release of Coq developed on a time-based development
  cycle. Its development spanned 9 months from the release of Coq 8.6 and was
  based on a public road-map. It attracted many external contributions. Code
  reviews and continuous integration testing were systematically used before
  integration of new features, with an important focus given to compatibility
  and performance issues.</p>
<ul>


 </ul>
