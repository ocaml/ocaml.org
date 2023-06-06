---
title: Two variants of the Bind rule
description:
url: http://cambium.inria.fr/blog/two-variants-of-the-bind-rule
date: 2023-05-30T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



<p>This post discusses two ways of writing the Bind rule of Separation
Logic. They are logically equivalent, but in practice, one should choose
wisely between them.</p>




<p>The Bind rule of Separation Logic is the rule that allows reasoning
about a sequence of two instructions. In the statements that follow,
such a sequence takes the form <code>bind m1 m2</code>.</p>
<p>There are several ways of writing this rule. The form that is
traditionally used in the Hoare logic community has two premises, along
the following lines:</p>
<div class="highlight"><pre><span></span><span class="x">  WP m1 </span><span class="cp">{{</span> <span class="err">&phi;</span> <span class="cp">}}</span><span class="x"> -&lowast;</span>
<span class="x">  (&forall; v, &phi; v -&lowast; WP (m2 v) </span><span class="cp">{{</span> <span class="err">&psi;</span> <span class="cp">}}</span><span class="x">) -&lowast;</span>
<span class="x">  WP (bind m1 m2) </span><span class="cp">{{</span> <span class="err">&psi;</span> <span class="cp">}}</span><span class="x">.</span>
</pre></div>

<p>This means that, to verify the program <code>bind m1 m2</code>, one
must first verify the subprogram <code>m1</code> and establish that,
when <code>m1</code> terminates, some property <code>&phi;</code> holds.
Then, under the assumption that <code>&phi;</code> holds when the execution
of <code>m2</code> begins, one must prove that it is safe to run
<code>m2</code>. It is up to the user to choose or guess the logical
assertion <code>&phi;</code> that describes the intermediate state.</p>
<p>The form that is most often used in the Iris community has only one
premise:</p>
<div class="highlight"><pre><span></span><span class="x">  WP m1 </span><span class="cp">{{</span> <span class="err">&lambda;</span> <span class="nv">v</span><span class="o">,</span> <span class="nv">WP</span> <span class="o">(</span><span class="nv">m2</span> <span class="nv">v</span><span class="o">)</span> <span class="o">{{</span> <span class="err">&psi;</span> <span class="cp">}}</span><span class="x"> }} -&lowast;</span>
<span class="x">  WP (bind m1 m2) </span><span class="cp">{{</span> <span class="err">&psi;</span> <span class="cp">}}</span><span class="x">.</span>
</pre></div>

<p>This means that, to verify the program <code>bind m1 m2</code>, one
must first verify establish that, when <code>m1</code> terminates, it is
safe to run <code>m2</code>.</p>
<p>These two forms of the Bind rule are logically equivalent. The second
form follows from the first one by instantiating <code>&phi;</code> with
<code>&lambda; v, WP (m2 v) {{ &psi; }}</code>. Conversely, the first form follows
from the second one and from the Consequence rule of Separation
Logic.</p>
<h3>Which form is preferable?</h3>
<p>Does this mean that the two forms of the Bind rule are
interchangeable? Not quite; there are practical reasons for preferring
one over the other.</p>
<p>The second form can seem preferable because it does not require
guessing or choosing a suitable postcondition <code>&phi;</code>. Indeed, it
automatically uses the most permissive <code>&phi;</code>, which is
<code>&lambda; v, WP (m2 v) {{ &psi; }}</code>. Thus, this form may seem as though
it is more amenable to automation.</p>
<p>However, this second form comes with a caveat. If the verification of
the subprogram <code>m1</code> involves a case analysis, then it is
usually desirable to limit the scope of this case analysis to just
<code>m1</code>. In other words, the scope of the case analysis must not
encompass <code>m2</code>, because that would imply that <code>m2</code>
must be verified several times.</p>
<p>Because the first form of the Bind rule introduces two subgoals (one
for <code>m1</code> and one for <code>m2</code>), the scope of a case
analysis inside <code>m1</code> is naturally limited to the first
subgoal. The second form of the Bind rule does not have this property:
because it has just one premise, a user who naively performs a case
analysis while verifying <code>m1</code> ends up having to verify
<code>m2</code> several times.</p>
<p>In summary, if <code>m1</code> is a conditional construct (e.g., an
<code>if</code> or <code>match</code> construct) then the middle point
between <code>m1</code> and <code>m2</code> is a <em>join point</em> and
the first form of the Bind rule, where the user must provide
<code>&phi;</code>, should be preferred. Otherwise, the second form of the
Bind rule can be used and there is no need for the user to provide
<code>&phi;</code>.</p>
<p>This is not a deep remark. It is just a possibly-useful reminder that
two logically equivalent statements can have quite different qualities
in practical usage scenarios.</p>


