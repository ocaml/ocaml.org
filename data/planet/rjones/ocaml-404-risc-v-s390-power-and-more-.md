---
title: "OCaml 4.04, RISC-V, S/390, POWER and more \u2026"
description: "I pushed OCaml 4.04.0 to Fedora Rawhide last week. There are loads of
  new features for OCaml users, but the ones that particularly affect Fedora are:
  New, upstream POWER (ppc64, ppc64le) backend, r\u2026"
url: https://rwmj.wordpress.com/2016/11/19/ocaml-4-04-risc-v-s390-power-and-more/
date: 2016-11-19T14:46:11-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>I pushed <a href="https://ocaml.org/releases/4.04.html">OCaml 4.04.0</a> <a href="https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/X63CN5B7FMFES3SCQKVUWTQO6TGVK7KU/">to Fedora Rawhide</a> last week.  There are loads of new features for OCaml users, but the ones that particularly affect Fedora are:</p>
<ul>
<li> New, upstream POWER (ppc64, ppc64le) backend, replacing the downstream one that we have maintained for a few years.  I was quite apprehensive about this change because I had tried the new backend during the OCaml 4.03 release cycle and found it to be quite unstable.  However the latest version looks rock solid and has no problem compiling the entire Fedora+OCaml software suite.
</li><li> New, upstream S/390x backend.  I actually <a href="https://caml.inria.fr/mantis/view.php?id=7405">found and fixed</a> a bug, go me!
</li><li> New, <a href="https://github.com/nojb/riscv-ocaml">non-upstream RISC-V backend</a>.  I <a href="https://github.com/nojb/riscv-ocaml/issues/1">found a bug</a> in this backend too, but it proved to be easy to fix.  You can now install and run most of the OCaml packages <a href="https://fedoraproject.org/wiki/Architectures/RISC-V">on Fedora/RISC-V</a>.
</li></ul>
<p>And talking about Fedora/RISC-V, it took a month, but the <a href="https://fedorapeople.org/groups/risc-v/logs/status-2.html">mass-rebuild of all Fedora packages</a> completed, and now we&rsquo;ve got about &#8532;rds of all Fedora packages available for RISC-V.  That&rsquo;s quite a lot:</p>
<pre>
$ <b>du -sh SRPMS/ RPMS/</b>
<b>31G</b>	<a href="https://fedorapeople.org/groups/risc-v/SRPMS/">SRPMS/</a>
<b>27G</b>	<a href="https://fedorapeople.org/groups/risc-v/RPMS/">RPMS/</a>
</pre>

