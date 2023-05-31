---
title: Coq 8.5 beta 3 is out!
description:
url: https://coq.inria.fr/news/coq-85beta3-is-out.html
date: 2015-11-11T19:30:00-00:00
preview_image:
featured:
authors:
- coq
---


The <a href="https://coq.inria.fr/coq-85">third beta release of Coq 8.5</a> is available for
testing. The 8.5 version brings several major features to Coq:

<ul>
<li>asynchronous edition of documents under CoqIDE to keep working on a proof
  while Coq checks the other proofs in the background (by Enrico Tassi);</li>
<li>universe polymorphism making it possible to reuse the same definitions at
  various universe levels (by Matthieu Sozeau);</li>
<li>primitive projections improving space and time efficiency of records, and
  adding eta-conversion for records (by Matthieu Sozeau);</li>
 <li>a new tactic engine allowing dependent subgoals, fully backtracking
  tactics, as well as tactics which can consider multiple goals together (by
  Arnaud Spiwack);</li>
<li>a new reduction procedure called <tt>native_compute</tt> to evaluate terms
  using the OCaml native compiler, for proofs with large computational
  steps (by Maxime D&eacute;n&egrave;s).</li>
</ul>

More information about the changes from 8.4 to 8.5 and since the first two
beta releases can be found in the <a href="https://coq.inria.fr/distrib/V8.5beta3/CHANGES">CHANGES</a> file. Feedback and <a href="https://coq.inria.fr/bugs">bug reports</a> are extremely welcome. Enjoy!  
 
