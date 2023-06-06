---
title: Representing pattern-matching with GADTs
description: "Here is a little programming pearl. I\u2019ve been wanting to work on
  pattern-matching for a while now, and it seems like I will finally have this opportunity
  here at my new (academic) home, McGil\u2026"
url: https://syntaxexclamation.wordpress.com/2014/04/12/representing-pattern-matching-with-gadts/
date: 2014-04-11T22:38:56-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>Here is a little programming pearl. I&rsquo;ve been wanting to work on pattern-matching for a while now, and it seems like I will finally have this opportunity here at my new (academic) home, <a href="http://cs.mcgill.ca/">McGill</a>.</p>
<p>Encoding some simply-typed languages with GADTs is now routine for a lot of OCaml programmers. You can even take (kind of) advantage of (some form of) convenient binding representation, like (weak) HOAS; you then use OCaml variables to denote your language&rsquo;s variables. But what about pattern-matching? Patterns are possibly &ldquo;deep&rdquo;, i.e. they bind several variables at a time, and they don&rsquo;t respect the usual discipline that a variable is bound for exactly its subterm in the AST.</p>
<p>It turns out that there is an adequate encoding, that relies on two simple ideas. The first is to treat variables in patterns as nameless placeholders bound by &lambda;-abstractions on the right side of the arrow (this is how e.g. Coq encodes matches: <code>match E&#8321; with (y, z) -&gt; E&#8322;</code> actually is sugar for <code>match E&#8321; with (_, _) -&gt; fun x y -&gt; E&#8322;</code>); the second is to thread and accumulate type arguments in a GADT, much like we demonstrated in our <code>printf</code> example <a href="https://syntaxexclamation.wordpress.com/2014/02/14/update-on-typeful-normalization-by-evaluation/">recently</a>.</p>
<p>The ideas probably extends seamlessly to De Bruijn indices, by threading an explicit environment throughout the term. It stemmed from a discussion on LF encodings of pattern-matching with <a href="http://www.cs.mcgill.ca/~fferre8/">Francisco</a> over lunch yesterday: what I will show enables also to represent adequately pattern-matching in LF, which I do not think was ever done this way before.</p>
<p><span></span></p>
<p>Let&rsquo;s start with two basic type definitions:</p>
<pre class="brush: fsharp; title: ; notranslate">
type ('a, 'b) union = Inl of 'a | Inr of 'b
type ('a, 'b) pair = Pair of 'a * 'b
</pre>
<h3>The encoding</h3>
<p>First, I encode simply-typed &lambda;-expressions with sums and products, in the very standard way with GADTs: I annotate every constructor by the (OCaml) type of its denotation.</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a exp =
  | Lam : ('a exp -&gt; 'b exp) -&gt; ('a -&gt; 'b) exp
  | App : ('a -&gt; 'b) exp * 'a exp -&gt; 'b exp
  | Var : 'a -&gt; 'a exp
  | Pair : 'a exp * 'b exp -&gt; ('a, 'b) pair exp
  | Inl : 'a exp -&gt; (('a, 'b) union) exp
  | Inr : 'b exp -&gt; ('a, 'b) union exp
  | Unit : unit exp
</pre>
<p>At this point, I only included data type <i>constructors</i>, not their <i>destructors</i>. These are replaced by a pattern-matching construct: it takes a scrutinee of type <code>'s</code>, and a list of branches, each returning a value of the same type <code>'c</code>.</p>
<pre class="brush: fsharp; title: ; notranslate">
  | Match : 's exp * ('s, 'c) branch list -&gt; 'c exp
</pre>
<p>Now, each branch is the pair of a pattern, possibly deep, possibly containing variables, and an expression where all these variables are bound.</p>
<pre class="brush: fsharp; title: ; notranslate">
(* 's = type of scrutinee; 'c = type of return *)
and ('s, 'c) branch =
  | Branch : ('s, 'a, 'c exp) patt * 'a -&gt; ('s, 'c) branch
</pre>
<p>To account for these bindings, I use a trick when defining patterns that is similar to the one used for <a href="http://caml.inria.fr/mantis/view.php?id=6017">printf with GADTs</a>. In the type of the <code>Branch</code> constructor, the type <code>'a</code> is an &ldquo;accumulator&rdquo; for all variables appearing in the pattern, eventually returning a <code>'c exp</code>. For instance, annotation <code>'a</code> for a pattern that binds two variables of type <code>'a -&gt; 'b</code> and <code>'a</code> would be <code>('a -&gt; 'b) exp -&gt; 'a exp -&gt; 'c exp</code>.</p>
<p>Let&rsquo;s define type <code>patt</code>. Note that it also carries and checks the annotation <code>'s</code> for the type of the scrutinee. The first three cases are quite easy:</p>
<pre class="brush: fsharp; title: ; notranslate">
(* 's = type of scrutinee;
   'a = accumulator for to bind variables;
   'c = type of return *)
and ('s, 'a, 'c) patt =
  | PUnit : (unit, 'c, 'c) patt
  | PInl : ('s, 'a, 'c) patt -&gt; (('s, 't) union, 'a, 'c) patt
  | PInr : ('t, 'a, 'c) patt -&gt; (('s, 't) union, 'a, 'c) patt
</pre>
<p>Now, the variable case is just a nameless dummy that &ldquo;stacks up&rdquo; one more argument in the &ldquo;accumulator&rdquo;, i.e. what will be the type of the right-hand side of the branch:</p>
<pre class="brush: fsharp; title: ; notranslate">
  | X : ('s, 's exp -&gt; 'c, 'c) patt
</pre>
<p>Finally, the pair case is the only binary node. It need to thread the accumulator, to the left node, then to the right.</p>
<pre class="brush: fsharp; title: ; notranslate">
  | PPair : ('s, 'a, 'b) patt * ('t, 'b, 'c) patt 
    -&gt; (('s, 't) pair, 'a, 'c) patt
</pre>
<p>Note that it is possible to swap the two sides of the pair; we would then bind variables in the opposite order on the right-hand side.</p>
<p>That&rsquo;s the encoding. Note that it ensures only well-typing of terms, not exhaustiveness of patterns (which is another story that I would like to tell in a future post).</p>
<h3>Examples</h3>
<p>Here are a couple of example encoded terms: first the shallow, OCaml value, then its representation:</p>
<pre class="brush: fsharp; title: ; notranslate">
let ex1 : = fun x -&gt; match x with
  | Inl x -&gt; Inr x
  | Inr x -&gt; Inl x

let ex1_encoded : 'a 'b. (('a, 'b) union -&gt; ('b, 'a) union) exp =
  Lam (fun x -&gt; Match (x, [
      Branch (PInl X, fun x -&gt; Inr x);
      Branch (PInr X, fun x -&gt; Inl x);
    ]))

let ex2 : 'a 'b. ((('a, 'b) union, ('a, 'b) union) pair
    -&gt; ('a, 'b) union) =
  fun x -&gt; match x with
    | Pair (x, Inl _) -&gt; x
    | Pair (Inr _, x) -&gt; x
    | Pair (_, Inr x) -&gt; Inr x

let ex2_encoded : 'a 'b. ((('a, 'b) union, ('a, 'b) union) pair 
    -&gt; ('a, 'b) union) exp =
  Lam (fun x -&gt; Match (x, [
      Branch (PPair (X, PInl X), (fun x _ -&gt; x));
      Branch (PPair (PInr X, X), (fun _ x -&gt; x));
      Branch (PPair (X, PInr X), (fun _ x -&gt; Inr x));
    ]))
</pre>
<h3>An interpreter</h3>
<p>Finally, we can code an evaluator for this language. It takes an expression to its (well-typed) denotation. The first few lines are standard:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec eval : type a. a exp -&gt; a = function
  | Lam f -&gt; fun x -&gt; eval (f (Var x))
  | App (m, n) -&gt; eval m (eval n)
  | Var x -&gt; x
  | Pair (m, n) -&gt; Pair (eval m, eval n)
  | Inl m -&gt; Inl (eval m)
  | Inr m -&gt; Inr (eval m)
  | Unit -&gt; ()
  | Match (m, bs) -&gt; branches (eval m) bs
</pre>
<p>Now for pattern-matching, we call an auxilliary function <code>branches</code> that will try each branch sequentially:</p>
<pre class="brush: fsharp; title: ; notranslate">
and branches : type s a. s -&gt; (s, a) branch list -&gt; a = fun v -&gt; function
  | [] -&gt; failwith &quot;pattern-matching failure&quot;
  | Branch (p, e) :: bs -&gt; 
    try eval (branch e (p, v)) with Not_found -&gt; branches v bs
</pre>
<p>A branch is tested by function <code>branch</code>, which is where the magic happens: it matches the pattern and the value of the scrutinee, and returns a (potentially only) partially applied resulting expression. The first cases are self-explanatory:</p>
<pre class="brush: fsharp; title: ; notranslate">
and branch : type s a c. a -&gt; (s, a, c) patt * s -&gt; c = fun e -&gt; function
  | PUnit, () -&gt; e
  | PInl p, Inl v -&gt; branch e (p, v)
  | PInr p, Inr v -&gt; branch e (p, v)
  | PInl _, Inr _ -&gt; raise Not_found
  | PInr _, Inl _ -&gt; raise Not_found
</pre>
<p>In the variable case, we know that <code>e</code> is a function that expects an argument: the value <code>v</code> of the scrutinee.</p>
<pre class="brush: fsharp; title: ; notranslate">
  | X, v -&gt; e (Var v)
</pre>
<p>The pair case is simple and beautiful: we just compose the application of <code>branch</code> on both sub-patterns.</p>
<pre class="brush: fsharp; title: ; notranslate">
  | PPair (p, q), Pair (v, w) -&gt; branch (branch e (p, v)) (q, w)
</pre>
<p>That&rsquo;s it. Nice eh? There are two obvious questions that I leave for future posts: can we compile this encoding down to simple case statement, with the guarantee of type preservation? and could we enhance the encoding such as to guarantee statically exhaustiveness?</p>
<p>See you soon!</p>

