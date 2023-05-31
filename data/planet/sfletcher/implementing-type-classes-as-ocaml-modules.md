---
title: Implementing type-classes as OCaml modules
description: Implementing type-classes as OCaml modules            Modular type classes            We
  revisit the idea of type-classe...
url: http://blog.shaynefletcher.org/2016/10/implementing-type-classes-as-ocaml.html
date: 2016-10-29T16:35:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
     
    
    <title>Implementing type-classes as OCaml modules</title>
  </head>
  <body>
    <h2>Modular type classes</h2>
    <p>
     We revisit the idea of type-classes first explored
     in <a href="http://blog.shaynefletcher.org/2016/10/haskell-type-classes-in-ocaml-and-c.html">this
     post</a>. This time though, the implementation technique will be
     by via OCaml modules inspired by the paper &quot;Modular Type Classes&quot;
     [2] by Harper et. al.
    </p>

    <p>Starting with the basics, consider the class of types whose
    values can be compared for equality. Call this
    type-class <b><code>Eq</code></b>. We represent the class as a
    module signature.
    </p><pre class="prettyprint ml">
    module type EQ = sig
      type t

      val eq : t * t &rarr; bool
    end
    </pre>
    Specific instances of <b><code>Eq</code></b> are modules that
    implement this signature. Here are two examples.
    <pre class="prettyprint ml">
    module Eq_bool : EQ with type t = bool = struct
      type t = bool
    
      let eq (a, b) = a = b
    end
    
    module Eq_int : EQ with type t = int = struct
      type t = int
    
      let eq (a, b) = a = b
    end
    </pre>
    
    <p>Given instances of class <b><code>Eq</code></b> (<code>X</code>
    and <code>Y</code> say,) we realize that products of those
    instances are also in <b><code>Eq</code></b>. This idea can be
    expressed as a functor with the following type.
    </p><pre class="prettyprint ml">
    module type EQ_PROD =
      functor (X : EQ) (Y : EQ) &rarr; EQ with type t = X.t * Y.t
    </pre>
    The implementation of this functor is simply stated as the
    following.
    <pre class="prettyprint ml">
    module Eq_prod : EQ_PROD =
      functor (X : EQ) (Y : EQ) &rarr; struct
        type t = X.t * Y.t

        let eq ((x1, y1), (x2, y2)) =  X.eq (x1, x2) &amp;&amp; Y.eq(y1, y2)
    end
    </pre>
    With this functor we can build concrete instances for
    products. Here's one example.
    <pre class="prettyprint ml">
    module Eq_bool_int : 
       EQ with type t = (bool * int) = Eq_prod (Eq_bool) (Eq_int)
    </pre>
    <p>The class <b><code>Eq</code></b> can be used as a building
    block for the construction of new type classes. For example, we
    might define a new type-class <b><code>Ord</code></b> that admits
    types that are equality comparable and whose values can be ordered
    with a &quot;less-than&quot; relation. We introduce a new module type to
    describe this class.
    </p><pre class="prettyprint ml">
    module type ORD = sig
      include EQ

      val lt : t * t &rarr; bool
    end
    </pre>
    Here's an example instance of this class.
    <pre class="prettyprint ml">
    module Ord_int : ORD with type t = int = struct
      include Eq_int
    
      let lt (x, y) = Pervasives.( &lt; ) x y
    end
    </pre>
    As before, given two instances of this class, we observe that
    products of these instances also reside in the class. Accordingly,
    we have this functor type
    <pre class="prettyprint ml">
    module type ORD_PROD =
      functor (X : ORD) (Y : ORD) &rarr; ORD with type t = X.t * Y.t
    </pre>
    with the following implementation.
    <pre class="prettyprint ml">
    module Ord_prod : ORD_PROD =
      functor (X : ORD) (Y : ORD) &rarr; struct
        include Eq_prod (X) (Y)
    
        let lt ((x1, y1), (x2, y2)) =
          X.lt (x1, x2) || X.eq (x1, x2) &amp;&amp; Y.lt (y1, y2)
      end
    </pre>
    This is the corresponding instance for pairs of intgers.
    <pre class="prettyprint ml">
    module Ord_int_int = Ord_prod (Ord_int) (Ord_int)
    </pre>
    Here's a simple usage example.
    <pre class="prettyprint ml">
    let test_ord_int_int = 
      let x = (1, 2) and y = (1, 4) in
      assert ( not (Ord_int_int.eq (x, y)) &amp;&amp; Ord_int_int.lt (x, y))
    </pre>
    
    <h2>Using type-classes to implement parameteric polymorphism</h2>

    <p>This section begins with the <b><code>Show</code></b> type-class.
    </p><pre class="prettyprint ml">
     module type SHOW = sig
      type t

      val show : t &rarr; string
    end
   </pre>
   In what follows, it is convenient to make an alias for module
   values of this type.
   <pre class="prettyprint ml">
   type &alpha; show_impl = (module SHOW with type t = &alpha;)
   </pre>
   Here are two instances of this class...
   <pre class="prettyprint ml">
    module Show_int : SHOW with type t = int = struct
      type t = int
    
      let show = Pervasives.string_of_int
    end

    module Show_bool : SHOW with type t = bool = struct
      type t = bool

      let show = function | true &rarr; &quot;True&quot; | false &rarr; &quot;False&quot;
    end
   </pre>
   ... and here these instances are &quot;packed&quot; as values.
   <pre class="prettyprint ml">
    let show_int : int show_impl = 
      (module Show_int : SHOW with type t = int)

    let show_bool : bool show_impl = 
      (module Show_bool : SHOW with type t = bool)
   </pre>
   The existence of the <b><code>Show</code></b> class is all that is
   required to enable the writing of our first parametrically
   polymorphic function.
   <pre class="prettyprint ml">
    let print : &alpha; show_impl &rarr; &alpha; &rarr; unit =
      fun (type a) (show : a show_impl) (x : a) &rarr;
      let module Show = (val show : SHOW with type t = a) in
      print_endline@@ Show.show x
    
    let test_print_1 : unit = print show_bool true
    let test_print_2 : unit = print show_int 3
   </pre>
   The function <code>print</code> can be used with values of any
   type <code>&alpha;</code> as long as the caller can produce
   evidence of <code>&alpha;</code>'s membership
   in <b><code>Show</code></b> (in the form of a compatible instance).
   
   <p>The next example begins with the definition of a
   type-class <b><code>Num</code></b> (the class of additive numbers)
   together with some example instances.
   </p><pre class="prettyprint ml">
    module type NUM = sig
      type t
    
      val from_int : int &rarr; t
      val ( + ) : t &rarr; t &rarr; t
    end
    
    module Num_int : NUM with type t = int = struct
      type t = int
    
      let from_int x = x
      let ( + ) = Pervasives.( + )
    end
    
    let num_int = (module Num_int : NUM with type t = int)
    
    module Num_bool : NUM with type t = bool = struct
      type t = bool
    
      let from_int = function | 0 &rarr; false | _ &rarr; true
      let ( + ) = function | true &rarr; fun _ &rarr; true | false &rarr; fun x &rarr; x
    end
    
    let num_bool = (module Num_bool : NUM with type t = bool)
   </pre>
   The existence of <b><code>Num</code></b> admits writing a
   polymorphic function <code>sum</code> that will work for
   any <code>&alpha; list</code> of values if only <code>&alpha;</code>
   can be shown to be in <b><code>Num</code></b>.
   <pre class="prettyprint ml">
    let sum : &alpha; num_impl &rarr; &alpha; list &rarr; &alpha; =
      fun (type a) (num : a num_impl) (ls : a list) &rarr;
        let module Num = (val num : NUM with type t = a) in
        List.fold_right Num.( + ) ls (Num.from_int 0)
    
    let test_sum = sum num_int [1; 2; 3; 4]
   </pre>
   This next function requires evidence of membership in two classes.
   <pre class="prettyprint ml">
    let print_incr : (&alpha; show_impl * &alpha; num_impl) &rarr; &alpha; &rarr; unit =
      fun (type a) ((show : a show_impl), (num : a num_impl)) (x : a) &rarr;
        let module Num = (val num : NUM with type t = a) in
        let open Num
        in print show (x + from_int 1)
    
    (*An instantiation*)
    let print_incr_int (x : int) : unit = print_incr (show_int, num_int) x
   </pre>
   
   <p>If <code>&alpha;</code> is in <b><code>Show</code></b> then we
   can easily extend <b><code>Show</code></b> to include the
   type <code>&alpha; list</code>. As we saw earlier, this kind of
   thing can be done with an approriate functor.
   </p><pre class="prettyprint ml">
    module type LIST_SHOW =
      functor (X : SHOW) &rarr; SHOW with type t = X.t list
    
    module List_show : LIST_SHOW =
      functor (X : SHOW) &rarr; struct
        type t = X.t list
    
        let show =
            fun xs &rarr;
              let rec go first = function
                | [] &rarr; &quot;]&quot;
                | h :: t &rarr;
                  (if (first) then &quot;&quot; else &quot;, &quot;) ^ X.show h ^ go false t 
              in &quot;[&quot; ^ go true xs
      end
   </pre>
   There is also another way : one can write a function to dynamically
   compute an <code>&alpha; list show_impl</code> from an <code>&alpha;
   show_impl</code>.
  <pre class="prettyprint ml">
  let show_list : &alpha; show_impl &rarr; &alpha; list show_impl =
    fun (type a) (show : a show_impl) &rarr;
      let module Show = (val show : SHOW with type t = a) in
      (module struct
        type t = a list
  
        let show : t &rarr; string =
          fun xs &rarr;
            let rec go first = function
              | [] &rarr; &quot;]&quot;
              | h :: t &rarr;
                (if (first) then &quot;&quot; else &quot;, &quot;) ^ Show.show h ^ go false t
            in &quot;[&quot; ^ go true xs
      end : SHOW with type t = a list)
    
   let testls : string = let module Show =
       (val (show_list show_int) : SHOW with type t = int list) in
      Show.show (1 :: 2 :: 3 :: [])
  </pre>
   
   <p>The type-class <b><code>Mul</code></b> is an aggregation of the
   type-classes <b><code>Eq</code></b> and <b><code>Num</code></b>
   together with a function to perform multiplication.
   </p><pre class="prettyprint ml">
   module type MUL = sig
      include EQ
      include NUM with type t := t
    
      val mul : t &rarr; t &rarr; t
   end
    
   type &alpha; mul_impl = (module MUL with type t = &alpha;)
    
   module type MUL_F =
     functor (E : EQ) (N : NUM with type t = E.t) &rarr; MUL with type t = E.t
   </pre>
   A default instance of <b><code>Mul</code></b> can be provided given
   compatible instances of <b><code>Eq</code></b>
   and <b><code>Num</code></b>.
   <pre class="prettyprint ml">
    module Mul_default : MUL_F =
      functor (E : EQ) (N : NUM with type t = E.t)  &rarr; struct
        include (E : EQ with type t = E.t)
        include (N : NUM with type t := E.t)
    
        let mul : t &rarr; t &rarr; t =
          let rec loop x y = begin match () with
            | () when eq (x, (from_int 0)) &rarr; from_int 0
            | () when eq (x, (from_int 1)) &rarr; y
            | () &rarr; y + loop (x + (from_int (-1))) y
          end in loop
    
    end
    
    module Mul_bool : MUL with type t = bool = 
      Mul_default (Eq_bool) (Num_bool)
   </pre>
   Specific instances can be constructed as needs demand.
   <pre class="prettyprint ml">
   module Mul_int : MUL with type t = int = struct
     include (Eq_int : EQ with type t = int)
     include (Num_int : NUM with type t := int)
    
     let mul = Pervasives.( * )
   end
    
   let dot : &alpha; mul_impl &rarr; &alpha; list &rarr; &alpha; list &rarr; &alpha; =
     fun (type a) (mul : a mul_impl) &rarr;
       fun xs ys &rarr;
         let module M = (val mul : MUL with type t = a) in
         sum (module M : NUM with type t = a)@@ List.map2 M.mul xs ys
    
   let test_dot =
     dot (module Mul_int : MUL with type t = int) [1; 2; 3] [4; 5; 6]
   </pre>
   Note that in this definition of <code>dot</code>, coercision of the
   provided <b><code>Mul</code></b> instance to its
   base <b><code>Num</code></b> instance is performed.
   
   <p>This last section provides an example of polymorphic recursion
   utilizing the dynamic production of evidence by way of
   the <code>show_list</code> function presented earlier.
   </p><p>
   </p><pre class="prettyprint ml">
   let rec replicate : int &rarr; &alpha; &rarr; &alpha; list =
     fun n x &rarr; if n &lt;= 0 then [] else x :: replicate (n - 1) x
   
   let rec print_nested : &alpha;. &alpha; show_impl &rarr; int &rarr; &alpha; &rarr; unit =
     fun show_mod &rarr; function
     | 0 &rarr; fun x &rarr; print show_mod x
     | n &rarr; fun x &rarr; print_nested (show_list show_mod) (n - 1) (replicate n x)
   
   let test_nested =
     let n = read_int () in
     print_nested (module Show_int : SHOW with type t = int) n 5
   </pre>
   
   
   <hr/>
   <p>
     References:<br/>
     [1] <a href="http://okmij.org/ftp/Computation/typeclass.html">Implementing, and Understanding Type Classes</a> -- Oleg Kiselyov
     [2] <a href="http://www.cse.unsw.edu.au/~chak/papers/mtc-popl.pdf">Modular Type Classes</a> -- Harper et. al.
   </p>
  </body>
</html>

