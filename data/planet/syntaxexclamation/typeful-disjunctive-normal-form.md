---
title: Typeful disjunctive normal form
description: "This is the answer to last post\u2019s puzzle. I gave an algorithm to
  put a formula in disjunctive normal form, and suggested to prove it correct in OCaml,
  thanks to GADTs. My solution happens to \u2026"
url: https://syntaxexclamation.wordpress.com/2014/04/18/547/
date: 2014-04-18T16:13:34-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>This is the answer to <a href="https://syntaxexclamation.wordpress.com/2014/04/15/big-step-disjunctive-normal-forms/" title="Big-step disjunctive normal forms">last post&rsquo;s puzzle</a>. I gave an algorithm to put a formula in disjunctive normal form, and suggested to prove it correct <i>in OCaml</i>, thanks to GADTs. My solution happens to include a wealth of little exercises that could be reused I think, so here it is.</p>
<p>I put the code snippets in the order that I think is more pedagogical, and leave to the reader to reorganize them in the right one.</p>
<p><span></span></p>
<p>First, as I hinted previously, we are annotating formulas, conjunctions and disjunctions with their corresponding OCaml type, in order to reason on these types:</p>
<pre class="brush: fsharp; title: ; notranslate">
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
<p>What we are eventually looking for is a function <code>dnf</code> mapping an <code>'a form&nbsp;</code>to a <code>'b disj</code>, but now these two must be related: they must represent two <i>equivalent</i> formulae. So, correcting what I just said: <code>dnf</code> must return the pair of a <code>'b disj</code> and a proof that <code>'a</code> and <code>'b</code> are equivalent. This pair is an existential type, which is easily coded with a GADT (we do similarly for conjunctions):</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a cnj = Cnj : 'b conj * ('a, 'b) equiv -&gt; 'a cnj
type 'a dsj = Dsj : 'b disj * ('a, 'b) equiv -&gt; 'a dsj
</pre>
<p>Let&rsquo;s leave out the definition of <code>equiv</code> for a while. Now the code from the previous post is fairly easily adapted:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec conj : type a b. a conj -&gt; b conj -&gt; (a * b) cnj =
  fun xs ys -&gt; match xs with
  | X x -&gt; Cnj (And (x, ys), refl)
  | And (x, xs) -&gt;
    let Cnj (zs, e) = conj xs ys in
    Cnj (And (x, zs), lemma0 e)

let rec disj : type a b. a disj -&gt; b disj -&gt; (a, b) union dsj =
  fun xs ys -&gt; match xs with
  | Conj c -&gt; Dsj (Or (c, ys), refl)
  | Or (x, xs) -&gt;
    let Dsj (zs, e) = disj xs ys in
    Dsj (Or (x, zs), lemma1 e)

let rec map : type a b. a conj -&gt; b disj -&gt; (a * b) dsj =
  fun x -&gt; function
  | Conj y -&gt;
    let Cnj (z, e) = conj x y in
    Dsj (Conj z, e)
  | Or (y, ys) -&gt;
    let Cnj (z, e1) = conj x y in
    let Dsj (t, e2) = map x ys in
    Dsj (Or (z, t), lemma2 e1 e2)

let rec cart : type a b. a disj -&gt; b disj -&gt; (a * b) dsj =
  fun xs ys -&gt; match xs with
  | Conj c -&gt; map c ys
  | Or (x, xs) -&gt;
    let Dsj (z, e1) = map x ys in
    let Dsj (t, e2) = cart xs ys in
    let Dsj (u, e3) = disj z t in
    Dsj (u, lemma3 e1 e2 e3)

let rec dnf : type a. a form -&gt; a dsj = function
  | X x -&gt; Dsj (Conj (X x), refl)
  | Or (a, b) -&gt;
    let Dsj (c, e1) = dnf a in
    let Dsj (d, e2) = dnf b in
    let Dsj (e, e3) = disj c d in
    Dsj (e, lemma4 e1 e2 e3)
  | And (a, b) -&gt;
    let Dsj (c, e1) = dnf a in
    let Dsj (d, e2) = dnf b in
    let Dsj (e, e3) = cart c d in
    Dsj (e, lemma5 e1 e2 e3)
</pre>
<p>It seems more verbose, but since the functions now return existentials, we need to deconstruct them and pass them around. I abstracted over the combinators that compose the proofs of equivalence <code>lemma1</code>&hellip;<code>lemma5</code>, we&rsquo;ll deal with them in a moment. For now, you can replace them by <code>Obj.magic</code> and read off their types with <code>C-c C-t</code> to see if they make sense logically. Look at the last function&rsquo;s type. It states, as expected: for any formula <img src="https://s0.wp.com/latex.php?latex=A&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002" srcset="https://s0.wp.com/latex.php?latex=A&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002 1x, https://s0.wp.com/latex.php?latex=A&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002&amp;zoom=4.5 4x" alt="A" class="latex"/>, there exists a disjuctive normal form <img src="https://s0.wp.com/latex.php?latex=B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002" srcset="https://s0.wp.com/latex.php?latex=B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002 1x, https://s0.wp.com/latex.php?latex=B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002&amp;zoom=4.5 4x" alt="B" class="latex"/> such that <img src="https://s0.wp.com/latex.php?latex=A%20%5CLeftrightarrow%20B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002" srcset="https://s0.wp.com/latex.php?latex=A+%5CLeftrightarrow+B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002 1x, https://s0.wp.com/latex.php?latex=A+%5CLeftrightarrow+B&amp;bg=fff&amp;fg=444444&amp;s=0&amp;c=20201002&amp;zoom=4.5 4x" alt="A \Leftrightarrow B" class="latex"/>.</p>
<p>Now on this subject, what is it for two types to be equivalent? Well, that&rsquo;s the &ldquo;trick&rdquo;: let&rsquo;s just use our dear old Curry-Howard correspondence! <code>'a</code> and <code>'b</code> are equivalent if there are two functions <code>'a -&gt; 'b</code> and <code>'b -&gt; 'a</code> (provided of course that we swear to use only the purely functional core of OCaml when giving them):</p>
<pre class="brush: fsharp; title: ; notranslate">
type ('a, 'b) equiv = ('a -&gt; 'b) * ('b -&gt; 'a)
</pre>
<p>Now we can state and prove a number of small results on equivalence with respect to the type constructors we&rsquo;re using (pairs and unions). Just help yourself&nbsp;into these if you&rsquo;re preparing an exercise sheet on Curry-Howard :)</p>
<pre class="brush: fsharp; title: ; notranslate">
(* a = a *)
let refl : type a. (a, a) equiv =
  (fun a -&gt; a), (fun a -&gt; a)

(* a = b -&gt; b = a *)
let sym : type a b. (a, b) equiv -&gt; (b, a) equiv =
  fun (ab, ba) -&gt; (fun b -&gt; ba b), (fun a -&gt; ab a)

(* a = b -&gt; b = c -&gt; a = c *)
let trans : type a b c. (b, c) equiv -&gt; (a, b) equiv -&gt; (a, c) equiv =
  fun (bc, cb) (ab, ba) -&gt; (fun a -&gt; bc (ab a)), (fun c -&gt; ba (cb c))

(* a = b -&gt; c = d -&gt; c * a = d * b *)
let conj_morphism : type a b c d. (a, b) equiv -&gt; (c, d) equiv -&gt;
  (c * a, d * b) equiv = fun (ab, ba) (cd, dc) -&gt;
    (fun (c, a) -&gt; cd c, ab a),
    (fun (c, b) -&gt; dc c, ba b)

let conj_comm : type a b. (a * b, b * a) equiv =
  (fun (x, y) -&gt; y, x), (fun (x, y) -&gt; y, x)

(* (a * b) * c = a * (b * c) *)
let conj_assoc : type a b c. ((a * b) * c, a * (b * c)) equiv =
  (fun ((x, y), z) -&gt; x, (y, z)),
  (fun (x, (y, z)) -&gt; (x, y), z)

(* a = b -&gt; c + a = c + b *)
let disj_morphism : type a b c d. (a, b) equiv -&gt; (c, d) equiv -&gt;
  ((c, a) union, (d, b) union) equiv =
  fun (ab, ba) (cd, dc) -&gt;
    (function Inl c -&gt; Inl (cd c) | Inr a -&gt; Inr (ab a)),
    (function Inl d -&gt; Inl (dc d) | Inr b -&gt; Inr (ba b))

(* (a + b) + c = a + (b + c) *)
let disj_assoc : type a b c. (((a, b) union, c) union,
                              (a, (b, c) union) union) equiv =
  (function Inl (Inl a) -&gt; Inl a
          | Inl (Inr b) -&gt; Inr (Inl b)
          | Inr c -&gt; Inr (Inr c)),
  (function Inl a -&gt; Inl (Inl a)
          | Inr (Inl b) -&gt; Inl (Inr b)
          | Inr (Inr c) -&gt; Inr c)

(* a * (b + c) = (a * b) + (a * c) *)
let conj_distrib : type a b c. (a * (b, c) union,
                               (a * b, a * c) union) equiv =
  (function a, Inl b -&gt; Inl (a, b)
          | a, Inr c -&gt; Inr (a, c)),
  (function Inl (a, b) -&gt; a, Inl b
          | Inr (a, c) -&gt; a, Inr c)
</pre>
<p>Finally, thanks to these primitive combinators, we can prove the lemmas we needed. Again, these are amusing little exercises.</p>
<pre class="brush: fsharp; title: ; notranslate">
let lemma0 : type a b c d. (a * b, c) equiv -&gt; ((d * a) * b, d * c) equiv =
  fun e -&gt; trans (conj_morphism e refl) conj_assoc

let lemma1 : type a b c d. ((a, b) union, d) equiv -&gt;
  (((c, a) union, b) union, (c, d) union) equiv =
  fun e -&gt; trans (disj_morphism e refl) disj_assoc

let lemma2 : type a c d u v. (a * c, u) equiv -&gt; (a * d, v) equiv -&gt;
  (a * (c, d) union, (u, v) union) equiv =
  fun e1 e2 -&gt; trans (disj_morphism e2 e1) conj_distrib

let lemma3 : type a b c d e f. (a * b, c) equiv -&gt; (d * b, e) equiv -&gt;
((c, e) union, f) equiv -&gt; ((a, d) union * b, f) equiv =
  fun e1 e2 e3 -&gt;
    trans e3
      (trans (disj_morphism e2 e1)
         (trans (disj_morphism conj_comm conj_comm)
            (trans conj_distrib
               conj_comm)))

let lemma4 : type a b c d e. (a, c) equiv -&gt; (b, d) equiv -&gt;
  ((c, d) union, e) equiv -&gt; ((a, b) union, e) equiv =
  fun e1 e2 e3 -&gt; trans e3 (disj_morphism e2 e1)

let lemma5 : type a b c d e. (a, c) equiv -&gt;
(b, d) equiv -&gt; (c * d, e) equiv -&gt; ((a * b), e) equiv =
  fun e1 e2 e3 -&gt; trans e3 (conj_morphism e2 e1)
</pre>
<p>Note that I only needed the previous primitives to prove these lemmas (and as such to define my functions), so we can even make the type <code>equiv</code> abstract, provided that we are giving a complete set of primitives (which is not the case here). Although I&rsquo;m not sure what it would buy us&hellip;</p>
<p>Anyway. That&rsquo;s my solution! What&rsquo;s yours?</p>

