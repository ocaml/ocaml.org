---
title: Disjunctive normal forms in big steps
description: "This is probably a second-semester functional programming exercise,
  but I found it surprisingly hard, and could not find a solution online. So at the
  risk of depriving a TA from a problem for its m\u2026"
url: https://syntaxexclamation.wordpress.com/2014/04/15/big-step-disjunctive-normal-forms/
date: 2014-04-15T20:14:55-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>This is probably a second-semester functional programming exercise, but I found it surprisingly hard, and could not find a solution online. So at the risk of depriving a TA from a problem for its mid-term exam, here is my take on it, that I painfully put together yesterday.</p>
<p>Given a formula built out of conjunction, disjunction and atoms, return its <a href="http://en.wikipedia.org/wiki/Disjunctive_normal_form">disjunctive normal form</a>, <i>in big step</i> or <i>natural semantics</i>, that is, not applying repetitively the distributivity and associativity rules, but in a single function run. Before you go any further, please give it a try and send me your solution!</p>
<p><span></span></p>
<p>Formulas are described by the type <code>form</code>:</p>
<pre class="brush: fsharp; title: ; notranslate">
type atom = int

type form =
  | X of atom
  | And of form * form
  | Or of form * form
</pre>
<p>To ensure the correctness of the result, I represent disjunctive normal form by a restriction of this type, <code>disj</code>, by stratifying it into conjunctions and disjunctions:</p>
<pre class="brush: fsharp; title: ; notranslate">
type conj = X of atom | And of atom * conj
type disj = Conj of conj | Or of conj * disj
</pre>
<p>There are actually two restrictions at stake here: first, conjunctions cannot contain disjunctions, and second, all operators are necessarily right-associative. Constructor <code>Conj</code> is just a logically silent coercion. If you look carefully enough, you will notice that <code>conj</code> (resp. <code>disj</code>) is isomorphic to a non-empty list of <code>atom</code>s (resp. <code>conj</code>).</p>
<p>The first step is to lift the second restriction (associativity), and prove that we can always build a conjunction of <code>conj</code>, resp. a disjunction of <code>disj</code>. Easy enough if you think about lists: these functions look like concatenation.</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec conj : conj -&gt; conj -&gt; conj = fun xs ys -&gt; match xs with
  | X x -&gt; And (x, ys)
  | And (x, xs) -&gt; And (x, conj xs ys)

let rec disj : disj -&gt; disj -&gt; disj = fun xs ys -&gt; match xs with
  | Conj c -&gt; Or (c, ys)
  | Or (x, xs) -&gt; Or (x, disj xs ys)
</pre>
<p>Then, we will lift the second restriction, using distributivity. We must show that it is always possible to form a conjunction. First, we show how to build the conjunction of a <code>conj</code> and a <code>disj</code>:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec map : conj -&gt; disj -&gt; disj = fun x -&gt; function
  | Conj y -&gt; Conj (conj x y)
  | Or (y, ys) -&gt; Or (conj x y, map x ys)
</pre>
<p>The first case is trivial, the second reads as the distributivity of conjunction over disjunction. By analogy to lists again, I called this function <code>map</code> because it maps function <code>conj x</code> to all cells of the list.</p>
<p>Next, we show how to build the conjunction of two <code>disj</code>:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec cart : disj -&gt; disj -&gt; disj = fun xs ys -&gt; match xs with
  | Conj c -&gt; map c ys
  | Or (x, xs) -&gt; disj (map x ys) (cart xs ys)
</pre>
<p>Considering the meaning of the previously defined functions, the first case is trivial, and the second, again, reads as distributivity, only in the other direction. I called this function <code>cart</code> because it computes the cartesian product of the two &ldquo;lists&rdquo; passed as arguments (only on non-empty lists).</p>
<p>Now we can easily put together the final function computing the DNF:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec dnf : form -&gt; disj = function
  | X x -&gt; Conj (X x)
  | Or (a, b) -&gt; disj (dnf a) (dnf b)
  | And (a, b) -&gt; cart (dnf a) (dnf b)
</pre>
<p>It is easy to see that all function terminate: they are primitive recursive.</p>
<p>Wait, let&rsquo;s not forget to test our contraption:</p>
<pre class="brush: fsharp; title: ; notranslate">
let () =
  assert (dnf (Or (And (X 1, X 2), X 3)) =
          Or (And (1, X 2), Conj (X 3)));
  assert (dnf (And (Or (X 1, X 2), X 3)) =
          Or (And (1, X 3), Conj (And (2, X 3))));
  assert (dnf (And (Or (And (X 0, X 1), X 2), And (X 3, X 4))) =
          Or (And (0, And (1, And (3, X 4))), Conj (And (2, And (3, X 4)))))
</pre>
<p>That&rsquo;s my solution. Reader, is there another one? Is there a better explanation, for instance based on Danvy&rsquo;s small-step to big-step derivation? I believe there is&hellip;</p>
<h4>Supplementary exercise</h4>
<p>Technically, there still could be bugs in this code. Prove that it is correct wrt. the small-step rewrite rules, using only OCaml and GADTs. Here is the beginning of an idea: annotate <code>form</code>, <code>conj</code> and <code>disj</code> with their meaning in terms of OCaml types:</p>
<pre class="brush: fsharp; title: ; notranslate">
type ('a, 'b) union = Inl of 'a | Inr of 'b

type 'a atom = int

type 'a form =
  | X : 'a atom -&gt; 'a form
  | And : 'a form * 'b form -&gt; ('a * 'b) form
  | Or : 'a form * 'b form -&gt; ('a, 'b) union form

type 'a conj =
  | X : 'a atom -&gt; 'a conj
  | And : 'a atom * 'b conj -&gt; ('a * 'b) conj

type 'a disj =
  | Conj : 'a conj -&gt; 'a disj
  | Or : 'a conj * 'b disj -&gt; ('a, 'b) union disj
</pre>
<p>(the definition of <code>union</code> is irrelevant here), state the relation between equivalent types as a type:</p>
<pre class="brush: fsharp; title: ; notranslate">
  type ('a, 'b) equiv =
    | Refl : ('a, 'a) equiv
    | Trans : ('a, 'b) equiv * ('b, 'c) equiv -&gt; ('a, 'c) equiv
    | AssocA : (('a * 'b) * 'c, 'a * ('b * 'c)) equiv
    | AssocO : ((('a, 'b) union, 'c) union, ('a, ('b, 'c) union) union) equiv
    | DistribL : ('a * ('b, 'c) union, ('a, 'b) union * ('a, 'c) union) equiv
    | DistribR : (('b, 'c) union * 'a, ('b, 'a) union * ('c, 'a) union) equiv
</pre>
<p>pack up a solution as an existential: an equivalence proof together with a DNF:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a dnf = Dnf : ('a, 'b) equiv * 'b disj -&gt; 'a dnf
</pre>
<p>and code a function:</p>
<pre class="brush: fsharp; title: ; notranslate">
let dnf : type a. a form -&gt; a dnf =
  function _ -&gt; (assert false)   (* TODO *)
</pre>
<p>Ok fair enough, it&rsquo;s not an exercise, it&rsquo;s something I haven&rsquo;t been able to put together yet ;)</p>

