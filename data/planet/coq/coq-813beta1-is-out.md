---
title: Coq 8.13+beta1 is out
description:
url: https://coq.inria.fr/news/coq-8-13beta1-is-out.html
date: 2020-12-07T00:00:00-00:00
preview_image:
featured:
authors:
- coq
---



<p>
The Coq development team is proud to announce the immediate availability of
<a href="https://github.com/coq/coq/releases/tag/V8.13+beta1">Coq 8.13+beta1</a>
</p>

<p>
Here the <a href="https://coq.github.io/doc/v8.13/refman/changes.html#version-8-13">full list of changes</a>.
</p>

<p>
We encourage our users to test this beta release, in particular:
</p><ul>
<li>
 The windows installer is now based on the Coq platform: This
  greatly simplifies its build process and makes it easy to add 
  more packages. At the same time this new installer was only
  tested by two people, so if you use Windows please give us
  feedback on any problem you may encounter.
</li>

<li>
 The notation system received many fixes and improvements, in
  particular the way notations are selected for printing changed:
  Coq now prefers notations which match a larger part of the term to
  abbreviate, and takes into account the order in which notations are 
  imported in the current scope only in a second instance.
  The new rules were designed together with power users, and tested
  by some of them, but our automatic testing infrastructure for 
  regressions in notation printing is still weak. If your Coq library
  makes heavy use of notations, please give us feedback on any 
  regression.
</li>
</ul>


<p>
The 8.13.0 release is expected to occur about one month from now.
</p>


 
