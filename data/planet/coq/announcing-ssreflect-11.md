---
title: Announcing Ssreflect 1.1
description:
url: https://coq.inria.fr/news/59.html
date: 2008-06-06T12:52:00-00:00
preview_image:
featured:
authors:
- coq
---


<p>The Microsoft Research-Inria Joint Center is pleased to announce<br/>
the first full release of the Ssreflect extension library for the Coq<br/>
proof assistant, version 8.1.</p>
<p>The name Ssreflect stands for &quot;small scale reflection&quot;, a style of<br/>
proof that evolved from the computer-checked proof of the Four Colour<br/>
Theorem and which leverages the higher-order nature of Coq's<br/>
underlying logic to provide effective automation for many small,<br/>
clerical proof steps. This is often accomplished by restating<br/>
(&quot;reflecting&quot;) problems in a more concrete form, hence the name. For<br/>
example, in the Ssreflect library arithmetic comparison is not an<br/>
abstract predicate, but a function computing a boolean.</p>
<p>Along with documentation, also available at<br/>
   <a href="https://hal.inria.fr/inria-00258384" title="https://hal.inria.fr/inria-00258384">https://hal.inria.fr/inria-00258384</a> the Ssreflect distribution<br/>
comprises two parts:<br/>
- A new tactic language, which promotes more structured, concise and<br/>
robust proof scripts, and is in fact independent from the &quot;reflection&quot;<br/>
proof style. It is implemented as a linkable extension to the Coq<br/>
system.<br/>
- A set of Coq libraries that provide core &quot;reflection-oriented&quot;<br/>
theories for basic combinatorics (roughly: arithmetic, lists, and<br/>
finite sets).</p>
<p>Some features of the tactic language:<br/>
- It provides tacticals for most structural steps (e.g., moving<br/>
assumptions), so that script steps mostly match logical steps.<br/>
- It provides tactics and tactical to support structured layout,<br/>
including reordering subgoals and supporting &quot;without loss of<br/>
generality&quot; arguments.<br/>
- It provides a powerful rewriting tactic that supports chained<br/>
rules, automatic unfolding of definitions and conditional rewriting,<br/>
as well as precise control over where and how much rewriting occurs.<br/>
- It can be used in combination with the classic Coq tactic<br/>
language.</p>
<p>Some features of the library:<br/>
- Exploits advanced features of Coq such as coercions an canonical<br/>
projections to build generic theories (e.g., for decidable equality).<br/>
- Uses rewrite rules and dependent predicate families to state<br/>
lemmas that can be applied deeply and bidirectionally. This means<br/>
fewer structural steps and a smaller library, respectively.<br/>
- Uses boolean functions to represent sets (i.e., comprehensions),<br/>
rather than an ad hoc set algebra.</p>
<p>The Ssreflect 1.1 distribution is available at<br/>
 <a href="http://www.msr-inria.inria.fr/projects/mathematical-components-2/" title="http://www.msr-inria.inria.fr/projects/mathematical-components-2/">http://www.msr-inria.inria.fr/projects/mathematical-components-2/</a>. It is<br/>
distributed under the CeCill-B license (the French equivalent of the<br/>
BSD license).</p>
<p>The tactic language is quite stable; we have been using it<br/>
internally for two years essentially without change. We will support<br/>
new releases of Coq in due course. We also plan to extend the core<br/>
library as our more advanced work on general and linear algebra<br/>
progresses.</p>
<p>Comments and bug reports are of course most welcome, and can be<br/>
directed at ssreflect(at-sign)msr-inria.inria.fr. To subscribe, either<br/>
send an email to <a href="mailto:sympa@msr-inria.inria.fr">sympa@msr-inria.inria.fr</a>, whose title contains the<br/>
word ssreflect, or use the following web interface:<br/>
 <a href="https://sympa.inria.fr/sympa/info/ssreflect" title="https://sympa.inria.fr/sympa/info/ssreflect">https://sympa.inria.fr/sympa/info/ssreflect</a></p>
<p>Enjoy!</p>
<p>The Mathematical Components Team,<br/>
at the Microsoft Research-Inria Joint Center</p>

 
