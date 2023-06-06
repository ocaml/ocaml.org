---
title: Coq 8.12.1 is out
description:
url: https://coq.inria.fr/news/coq-8-12-1-is-out.html
date: 2020-11-16T00:00:00-00:00
preview_image:
featured:
authors:
- coq
---



<p>We are happy to announce the <a href="https://github.com/coq/coq/releases/tag/V8.12.1">release of Coq
8.12.1</a>.

</p><p>This release contains numerous bug fixes and documentation improvements. Some bug fix highlights:</p>
<ul>
<li>Polymorphic side-effects inside monomorphic definitions were incorrectly handled as not inlined. This allowed deriving an inconsistency.
</li><li>Regression in error reporting after SSReflect's <code>case</code> tactic. A generic error message &quot;Could not fill dependent hole in apply&quot; was reported for any error following <code>case</code> or <code>elim</code>.
</li><li>Several bugs with <code>Search</code>.
</li><li>The <code>details</code> environment introduced in coqdoc in Coq 8.12 can now be used as advertised in the reference manual.
</li><li>View menu &quot;Display parentheses&quot; introduced in CoqIDE in Coq 8.12 now works correctly.
</li></ul>
<p>See the <a href="https://coq.inria.fr/refman/changes.html#changes-in-8-12-1">changelog</a> for details and a more complete list.</p>


 
