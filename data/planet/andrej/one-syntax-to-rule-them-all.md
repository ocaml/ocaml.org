---
title: One syntax to rule them all
description:
url: http://math.andrej.com/2022/05/20/one-syntax-to-rule-them-all/
date: 2022-05-20T07:00:00-00:00
preview_image:
featured:
authors:
- Andrej Bauer
---

<p>I am at the <a href="https://europroofnet.github.io/wg6-kickoff-stockholm/">Syntax and Semantics of Type Theory</a> workshop in Stockholm, a kickoff meeting for <a href="https://europroofnet.github.io/wg6/">WG6</a> of the <a href="https://europroofnet.github.io">EuroProofNet</a> COST network, where I am giving a talk &ldquo;One syntax to rule them all&rdquo; based on joint work with <a href="https://danel.ahman.ee">Danel Ahman</a>.</p>



<p><strong>Abstract:</strong>
The raw syntax of a type theory, or more generally of a formal system with binding constructs, involves not only free and bound variables, but also meta-variables, which feature in inference rules. Each notion of variable has an associated notion of substitution. A syntactic translation from one type theory to another brings in one more level of substitutions, this time mapping type-theoretic constructors to terms. Working with three levels of substitution, each depending on the previous one, is cumbersome and repetitive. One gets the feeling that there should be a better way to deal with syntax.</p>

<p>In this talk I will present a relative monad capturing higher-rank syntax which takes care of all notions of substitution and binding-preserving syntactic transformations in one fell swoop. The categorical structure of the monad corresponds precisely to the desirable syntactic properties of binding and substitution. Special cases of syntax, such as ordinary first-order variables, or second-order syntax with variables and meta-variables, are obtained easily by precomposition of the relative monad with a suitable inclusion of restricted variable contexts into the general ones. The meta-theoretic properties of syntax transfer along the inclusion.</p>

<p>The relative monad is sufficiently expressive to give a notion of intrinsic syntax for simply typed theories. It remains to be seen how one could refine the monad to account for intrinsic syntax of dependent type theories.</p>

<p><strong>Talk notes:</strong>
Here are the hand-written <a href="http://math.andrej.com/asset/data/one-syntax-to-rule-them-all.pdf">talk notes</a>, which cover more than I could say during the talk.</p>

<p><strong>Formalization:</strong>
I have the beginning of a formalization of the higher-rank syntax, but it hits a problem, see below. Can someone suggest a solution? (You can download <a href="http://math.andrej.com/asset/data/Syntax.agda"><code class="language-plaintext highlighter-rouge">Syntax.agda</code></a>.)</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>{-
   An attempt at formalization of (raw) higher-rank syntax.

   We define a notion of syntax which allows for higher-rank binders,
   variables and substitutions. Ordinary notions of variables are
   special cases:

   * order 1: ordinary variables and substitutions, for example those of
     &lambda;-calculus
   * order 2: meta-variables and their instantiations
   * order 3: symbols (term formers) in dependent type theory, such as
     &Pi;, &Sigma;, W, and syntactic transformations between theories

   The syntax is parameterized by a type Class of syntactic classes. For
   example, in dependent type theory there might be two syntactic
   classes, ty and tm, corresponding to type and term expressions.
-}

module Syntax (Class : Set) where

  {- Shapes can also be called &ldquo;syntactic variable contexts&rdquo;, as they assign to
     each variable its syntactic arity, but no typing information.

     An arity is a binding shape with a syntactic class. The shape specifies
     how many arguments the variable takes and how it binds the argument's variables.
     The class specifies the syntactic class of the variable, and therefore of the
     expression formed by it.

     We model shapes as binary trees so that it is easy to concatenate
     two of them. A more traditional approach models shapes as lists, in
     which case one has to append lists.
  -}

  infixl 6 _&oplus;_

  data Shape : Set where
    &#120792; : Shape -- the empty shape
    [_,_] : &forall; (&gamma; : Shape) (cl : Class) &rarr; Shape -- the shape with precisely one variable
    _&oplus;_ : &forall; (&gamma; : Shape) (&delta; : Shape) &rarr; Shape -- disjoint sum of shapes

  infix 5 [_,_]&isin;_

  {- The de Bruijn indices are binary numbers because shapes are binary
     trees. [ &delta; , cl ]&isin; &gamma; is the set of variable indices in &gamma; whose arity
     is (&delta;, cl). -}

  data [_,_]&isin;_ : Shape &rarr; Class &rarr; Shape &rarr; Set where
    var-here : &forall; {&theta;} {cl} &rarr; [ &theta; , cl ]&isin;  [ &theta; , cl ]
    var-left :  &forall; {&theta;} {cl} {&gamma;} {&delta;} &rarr; [ &theta; , cl ]&isin; &gamma; &rarr; [ &theta; , cl ]&isin; &gamma; &oplus; &delta;
    var-right : &forall; {&theta;} {cl} {&gamma;} {&delta;} &rarr; [ &theta; , cl ]&isin; &delta; &rarr; [ &theta; , cl ]&isin; &gamma; &oplus; &delta;

  {- Examples:

  postulate ty : Class -- type class
  postulate tm : Class -- term class

  ordinary-variable-arity : Class &rarr; Shape
  ordinary-variable-arity c = [ &#120792; , c ]

  binary-type-metavariable-arity : Shape
  binary-type-metavariable-arity = [ [ &#120792; , tm ] &oplus; [ &#120792; , tm ] , ty ]

  &Pi;-arity : Shape
  &Pi;-arity = [ [ &#120792; , ty ] &oplus; [ [ &#120792; , tm ] , ty ] , ty ]

  -}

  {- Because everything is a variable, even symbols, there is a single
     expression constructor _`_ which forms and expression by applying
     the variable x to arguments ts. -}

  -- Expressions

  infix 9 _`_

  data Expr : Shape &rarr; Class &rarr; Set where
    _`_ : &forall; {&gamma;} {&delta;} {cl} (x : [ &delta; , cl ]&isin; &gamma;) &rarr;
            (ts : &forall; {&theta;} {B} (y : [ &theta; , B ]&isin; &delta;) &rarr; Expr (&gamma; &oplus; &theta;) B) &rarr; Expr &gamma; cl

  -- Renamings

  infix 5 _&rarr;&#691;_

  _&rarr;&#691;_ : Shape &rarr; Shape &rarr; Set
  &gamma; &rarr;&#691; &delta; = &forall; {&theta;} {cl} (x : [ &theta; , cl ]&isin; &gamma;) &rarr; [ &theta; , cl ]&isin; &delta;

  -- identity renaming

  &#120793;&#691; : &forall; {&gamma;} &rarr; &gamma; &rarr;&#691; &gamma;
  &#120793;&#691; x = x

  -- composition of renamings

  infixl 7 _&#8728;&#691;_

  _&#8728;&#691;_ : &forall; {&gamma;} {&delta;} {&eta;} &rarr; (&delta; &rarr;&#691; &eta;) &rarr; (&gamma; &rarr;&#691; &delta;) &rarr; (&gamma; &rarr;&#691; &eta;)
  (r &#8728;&#691; s) x =  r (s x)

  -- renaming extension

  &uArr;&#691; : &forall; {&gamma;} {&delta;} {&Theta;} &rarr; (&gamma; &rarr;&#691; &delta;) &rarr; (&gamma; &oplus; &Theta; &rarr;&#691; &delta; &oplus; &Theta;)
  &uArr;&#691; r (var-left x) =  var-left (r x)
  &uArr;&#691; r (var-right y) = var-right y

  -- the action of a renaming on an expression

  infixr 6 [_]&#691;_

  [_]&#691;_ : &forall; {&gamma;} {&delta;} {cl} (r : &gamma; &rarr;&#691; &delta;) &rarr; Expr &gamma; cl &rarr; Expr &delta; cl
  [ r ]&#691; (x ` ts) = r x ` &lambda; { y &rarr; [ &uArr;&#691; r ]&#691; ts y }

  -- substitution
  infix 5 _&rarr;&#738;_

  _&rarr;&#738;_ : Shape &rarr; Shape &rarr; Set
  &gamma; &rarr;&#738; &delta; = &forall; {&Theta;} {cl} (x : [ &Theta; , cl ]&isin; &gamma;) &rarr; Expr (&delta; &oplus; &Theta;) cl

  -- side-remark: notice that the ts in the definition of Expr is just a substituition

  -- We now hit a problem when trying to define the identity substitution in a naive
  -- fashion. Agda rejects the definition, as it is not structurally recursive.
  -- {-# TERMINATING #-}
  &#120793;&#738; : &forall; {&gamma;} &rarr; &gamma; &rarr;&#738; &gamma;
  &#120793;&#738; x = var-left x ` &lambda; y &rarr;  [ &uArr;&#691; var-right ]&#691; &#120793;&#738; y

  {- What is the best way to deal with the non-termination problem? I have tried:

     1. sized types: got mixed results, perhaps I don't know how to use them
     2. well-founded recursion: it gets messy and unpleasant to use
     3. reorganizing the above definitions, but non-structural recursion always sneeks in

     A solution which makes the identity substitition compute is highly preferred.

     The problem persists with other operations on substitutions, such as composition
     and the action of a substitution.
  -}
</code></pre></div></div>
