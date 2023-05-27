---
title: Polynomials over rings
description: Polynomials over rings            This post provides a workout in generic
  programming using modules &     functors.     ...
url: http://blog.shaynefletcher.org/2017/03/polynomials-over-rings.html
date: 2017-03-21T19:43:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
     
    
    <title>Polynomials over rings</title>
  </head>
  <body>
    <p>This post provides a workout in generic programming using modules &amp;
    functors.
    </p>
    <p>The program presented here models
    univariate <a href="https://en.wikipedia.org/wiki/Polynomial">polynomials</a>
    over <a href="https://en.wikipedia.org/wiki/Ring_(mathematics)">rings</a>
    based on an exercise in &quot;The Module Language&quot; chapter, of
    <a href="http://gallium.inria.fr/~remy/">Didier R&eacute;my's</a>
    book, <a href="https://caml.inria.fr/pub/docs/u3-ocaml/index.html">Using,
    Understanding and Unraveling the OCaml Lanaguage</a>.
    </p>

    <h3>Arithmetics and rings</h3>
    <p>We begin with a type for modules implementing arithmetic.
    </p><pre>
    module type ARITH = sig
      type t
      val of_int : int -&gt; t            val to_int : t -&gt; int
      val of_string : string -&gt; t      val to_string : t -&gt; string
      val zero : t                     val one : t
      val add : t -&gt; t -&gt; t            val sub : t -&gt; t -&gt; t
      val mul : t -&gt; t -&gt; t            val div : t -&gt; t -&gt; t
      val compare : t -&gt; t -&gt; int      val equal : t -&gt; t -&gt; bool
    end;;
    </pre>
    A ring is a set equipped with two binary operations that
    generalize the arithmetic operations of addition and
    multiplication.
    <pre>
    module type RING = sig
      type t
      type extern_t
      val print : t -&gt; unit
      val make : extern_t -&gt; t         val show : t -&gt; extern_t
      val zero : t                     val one : t
      val add : t -&gt; t -&gt; t            val mul : t -&gt; t -&gt; t
      val equal : t -&gt; t -&gt; bool
    end;;
    </pre>
    We can build rings over arithmetics with functors. This particular
    one fixes the external representation of the elements of the ring
    to <code>int</code>.
    <pre>
    module Ring (A : ARITH) :
      RING  with type t = A.t and type extern_t = int =
    struct
      include A
      type extern_t = int
      let make = of_int                let show = to_int
      let print x = print_int (show x)
    end;;
    </pre>
    Thus, here for example are rings over various specific arithmetic
    modules.
    <pre>
    module Ring_int32 = Ring (Int32);;
    module Ring_int64 = Ring (Int64);;
    module Ring_nativeint = Ring (Nativeint);;
    module Ring_int = Ring (
      struct
        type t = int
        let of_int x = x                   let to_int x = x
        let of_string = int_of_string      let to_string = string_of_int
        let zero = 0                       let one = 1
        let add = ( + )                    let sub = ( - )
        let mul = ( * )                    let div = ( / )
        let compare = Pervasives.compare   let equal = ( = )
      end
    );;
    </pre>
    
    <h3>Polynomials</h3>
    <p>We define now the type of polynomials.
    </p><pre>
    module type POLYNOMIAL = sig
      type coeff (*Type of coefficients*)
      type coeff_extern_t (*Type of coeff. external rep*)

      (*Polynomials satisfy the ring interface*)
      include RING (*Declares a type [t] and [extern_t]*)

      (*Function to evaluate a polynomial at a point*)
      val eval : t -&gt; coeff -&gt; coeff
    end;;
    </pre>
    Given a module implementing a ring, we can generate a module
    implementing polynomials with coefficients drawn from the ring.
    <pre>
    module Polynomial (R : RING) :
      POLYNOMIAL with type coeff = R.t
      and type coeff_extern_t = R.extern_t
      and type extern_t = (R.extern_t * int) list =
    struct
    
      type coeff = R.t (*Coefficient type*)
      type coeff_extern_t = R.extern_t (*External coeff. rep*)
      type extern_t = (coeff_extern_t * int) list (*External polynomial rep*)
    
      (*List of coefficients and their powers*)
      type t = (coeff * int) list (*Invariant : Ordered by powers,
                                    lower order terms at the front*)

      (* ... *)

    end;;
    </pre>
    As the comments indicate, the polynomial data structure is a list
    of pairs of coefficients and powers, ordered so that lower powers
    come before higher ones. Here's a simple printing utility to aid
    visualization.
    <pre>
    let print p =
      List.iter
        (fun (c, k) -&gt; Printf.printf &quot;+ (&quot;;
          R.print c;
          Printf.printf &quot;)X^%d &quot; k)
        p
    </pre>
    In order that we get a canonical representation, null
    coefficients are eliminated. In particular, the null monomial is
    simply the empty list.
    <pre>
    let zero = []
    </pre>
    The multiplicative identity <code>one</code> is not really
    necessary as it is just a particular monomial however, its
    presence makes polynomials themselves satisfy the interface of
    rings.
    <pre>
    let one = [R.one, 0]
    </pre>
    This helper function constructs monomials.
    <pre>
    let monomial (a : coeff) (k : int) =
      if k &lt; 0 then
        failwith &quot;monomial : negative powers not supported&quot;
      else if R.equal a R.zero then [] else [a, k]
    </pre>
    Next up, we define addition of polynomials by the following
    function. Care is taken to ensure the representation invariant is
    respected.
    <pre>
    let rec add u v =
      match u, v with
      | [], _ -&gt; v
      | _, [] -&gt; u
      | ((c1, k1) :: r1 as p1), ((c2, k2) :: r2 as p2) -&gt;
        if k1 &lt; k2 then
          (c1, k1) :: (add r1 p2)
        else if k1 = k2 then
          let c = R.add c1 c2 in
          if R.equal c R.zero then add r1 r2
          else (c, k1) :: (add r1 r2)
        else (c2, k2) :: (add p1 r2)
    </pre>
    With <code>monomial</code> and <code>add</code> avaialable, we can
    now write <code>make</code> that computes a polynomial from an
    external representation. We also give the inverse
    function <code>show</code> here too.
    <pre>
    let make l =
      List.fold_left (fun acc (c, k) -&gt;
        add (monomial (R.make c) k) acc) zero l

    let show p =
      List.fold_right (fun (c, k) acc -&gt; (R.show c, k) :: acc) p []
    </pre>
    The module private function <code>times</code> left-multiplies a
    polynomial by a monomial.
    <pre>
    let rec times (c, k) = function
      | [] -&gt; []
      | (c1, k1) :: q -&gt;
        let c2 = R.mul c c1 in
        if R.equal c2 R.zero then times (c, k) q
        else (c2, k + k1) :: times (c, k) q
    </pre>
    Given the existence of <code>times</code>, polynomial
    multiplication can be expressed in a &quot;one-liner&quot;.
    <pre>
    let mul p = List.fold_left (fun r m -&gt; add r (times m p)) zero
    </pre>
    Comparing two polynomials for equality is achieved with the
    following predicate.
    <pre>
    let rec equal p1 p2 =
      match p1, p2 with
      | [], [] -&gt; true
      | (c1, k1) :: q1, (c2, k2) :: q2 -&gt;
        k1 = k2 &amp;&amp; R.equal c1 c2 &amp;&amp; equal q1 q2
      | _ -&gt; false
    </pre>
    In the course of evaluating polynomials for a specific value of
    their indeterminate, we'll require a function for computing
    powers. The following routine uses
    the <a href="https://en.wikipedia.org/wiki/Exponentiation_by_squaring">exponentiation
    by squaring</a> technique.
    <pre>
    let rec pow c = function
      | 0 -&gt; R.one
      | 1 -&gt; c
      | k -&gt;
        let l = pow c (k lsr 1) in
        let l2 = R.mul l l in
        if k land 1 = 0 then l2 else R.mul c l2
    </pre>
    Finally, the function <code>eval</code> for evaluation of a
    polynomial at a specific point. The implementation
    uses <a href="https://en.wikipedia.org/wiki/Horner's_method">Horner's
    rule</a> for computationally efficient evaluation.
    <pre>
    let eval p c = match List.rev p with
      | [] -&gt; R.zero
      | (h :: t) -&gt;
        let reduce (a, k) (b, l) =
          let n = pow c (k - l) in
          let t = R.add (R.mul a n) b in
          (t, l)  in
        let a, k = List.fold_left reduce h t in
        R.mul (pow c k) a
      </pre>
    
    <h3>Testing and example usage</h3>
    <p>The following interactive session creates a polynomial with
    integer coefficients module and uses it to confirm the equivalence
    of $(1 + x)(1 - x)$ with $(1 - x^{2})$.
    </p><pre>
    # #use &quot;polynomial.ml&quot;;;
    # module R = Ring_int;;
    # module P = Polynomial (R);;
    # let p = P.mul (P.make [(1, 0); (1, 1)]) (P.make [(1, 0); (-1, 1)]);;
    # let q = P.make [(1, 0); (-1, 2)];;
    # P.equal p q;;
    - : bool = true
    </pre>
    Polynomials in two variables, can be treated as univariate
    polynomials with polynomial coefficients. For example, the
    polynomial $(X + Y)$ can be regarded as $(1 \times X^{1})Y^{0} +
    (1 \times X^{0})Y^{1}$. Similarly we can write $X - Y$ as $(1
    \times X^{1})Y^{0} + (-1 \times X^{0}) Y^1$ and now check the
    equivalence $(X + Y)(X - Y) = (X^{2} - Y^{2})$.
    
    <pre>
    #module Y = Polynomial (P);;
    
    #(* (X + Y) *)
    #let r = Y.make [
    #  ([1, 1], 0); (*(1 X^1) Y^0*)
    #  ([1, 0], 1)  (*(1 X^0) Y^1*)
    #];;

    #(* (X - Y) *)
    #let s = Y.make [
    #  ([1, 1], 0); (*(1 X^1) Y^0*)
    #  ([-1, 0], 1) (*((-1) X^0) Y^1*)
    #];;

    #(* (X^2 - Y^2) *)
    #let t = Y.make [
    #  ([1, 2], 0);   (*(1 X^2) Y^0*)
    #  ([-1, 0], 2)  (* (-1 X^0) Y^2*)
    #];;

    #Y.equal (Y.mul r s) t;;
    - : bool = true
    </pre>
    
   <hr/>
  </body>
</html>

