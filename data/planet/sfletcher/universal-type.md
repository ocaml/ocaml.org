---
title: Universal type
description: Universal type      A universal type is a type into which all other types
  can be     embedded. A module implementing such a type here wi...
url: http://blog.shaynefletcher.org/2017/03/universal-type.html
date: 2017-03-10T18:06:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

    <h2>Universal type</h2>
    <p>A universal type is a type into which all other types can be
    embedded. A module implementing such a type here will satisfy the
    following signature.
      </p><pre class="prettyprint ml">
module type UNIVERSAL = sig
  type t
  val embed : unit &rarr; (&alpha; &rarr; t) * (t &rarr; &alpha; option)
end;;
      </pre>
      The <code>type t</code> is the universal type and each call
      to <code>embed</code> returns a pair of functions : an injection
      function for embedding a value into the universal type and, a
      projection function for extracting the value from its embedding
      in the universal type. The following code demonstrates intended
      usage.
      <pre class="prettyprint ml">
module type TEST = sig
  val run : unit &rarr; unit
end;;

module type UNIVERSAL_TEST = functor (U : UNIVERSAL) &rarr; TEST;;

module Basic_usage : UNIVERSAL_TEST = 
  functor (U : UNIVERSAL) &rarr; struct
    let run () =
      let ((of_int : int &rarr; U.t)
         , (to_int : U.t &rarr; int option)) = U.embed () in
      let ((of_string : string &rarr; U.t)
         , (to_string : U.t &rarr; string option)) = U.embed () in

      let r : U.t ref = ref (of_int 13) in

      begin
        assert (to_int !r = Some 13);
        assert (to_string !r = None);

        r := of_string &quot;foo&quot;;

        assert (to_string !r = Some &quot;foo&quot;);
        assert (to_int !r = None);
      end
  end;;
      </pre>
    
    <p>One possible implementation is via the use of exceptions
    together with local modules. The core idea exploits the fact that
    the primitive type <code>exn</code> is an open extensible
    sum. Here's the complete implementation. We'll break it down
    later.
    </p><pre class="prettyprint ml">
module Universal_exn : UNIVERSAL = struct

  type t = exn

  module type ANY = sig
    type c
    exception E of c
  end

  type &alpha; any = (module ANY with type c = &alpha;)

  let mk : unit &rarr; &alpha; any =
    fun (type s) () &rarr;
      (module struct
        type c = s
        exception E of c
      end : ANY with type c = s)

  let inj (type s) (p : s any) (x : s) : t =
    let module Any = (val p : ANY with type c = s) in
    Any.E x

  let proj (type s) (p : s any) (y : t) : s option =
    let module Any = (val p : ANY with type c = s) in
    match y with
    | Any.E x &rarr; Some x
    | _ as e &rarr;  None

  let embed () = let p = mk () in inj p, proj p

end;;
    </pre>
    Before delving into an explanation of the program, one can verify
    it satisfies the basic test.
   <pre class="prettyprint ml">
# module Test_basic = Mk_universal_test(Universal_exn);;
# Test_basic.run ();;
- : unit = ()
   </pre>
   
   <p>The definition of the universal type <code>t</code> is an alias
   to the predefined type <code>exn</code>.
   </p><pre class="prettyprint ml">
type t = exn
   </pre>
   A module type <code>ANY</code> is introduced. Modules that
   implement this signature define an abstract type <code>c</code> and
   introduce an <code>exn</code> constructor <code>E of c</code>.
   <pre class="prettyprint ml">
module type ANY = sig
  type c
  exception E of c
end
   </pre>
   An alias for the type of a module value satisfying this signature
   comes next. Using aliases of this kind are helpful in reducing
   &quot;syntactic verbosity&quot; in code accepting and returning module values.
   <pre class="prettyprint ml">
type &alpha; any = (module ANY with type c = &alpha;)
   </pre>
   Next follow a set of functions that are private to the
   implementation of the module. The first of these
   is <code>mk</code>.
   <pre class="prettyprint ml">
let mk : unit &rarr; &alpha; any =
  fun (type s) () &rarr;
    (module struct
      type c = s
      exception E of c
    end : ANY with type c = s)
   </pre>
   This function <code>mk</code> takes the <code>unit</code> argument
   and each invocation computes a new module instance which is packed
   as a first class value and returned. The locally abstract
   type <code>s</code> connects to the <code>&alpha;</code> in the
   return type.
   
   <p>
   The next function to be defined is <code>inj</code> which computes
   a universal type value from its argument.
   </p><pre class="prettyprint ml">
let inj (type s) (p : s any) (x : s) : t =
  let module Any = (val p : ANY with type c = s) in
  Any.E x
   </pre>
    As was the case for <code>mk</code>, a locally abstract type is
    used in the definition of <code>inj</code> and observe how that
    type ensures a coherence between the module
    parameter <code>p</code> and the type of the parameter to be
    embedded <code>x</code>.
   
   <p>
   The projection function <code>proj</code> comes next and also uses
   a locally abstract type ensuring coherence among its parameters.
   </p><pre class="prettyprint ml">
let proj (type s) (p : s any) (y : t) : s option =
  let module Any = (val p : ANY with type c = s) in
  match y with
  | Any.E x &rarr; Some x
  | _ as e &rarr;  None
   </pre>
   The body of <code>proj</code> unpacks the module value parameter into
   a module named <code>Any</code> and then attempts to
   match <code>y</code> against the constructor defined
   by <code>Any</code>. Recall, at the end of the day, <code>y</code>
   is of type <code>exn</code>. The match contains two cases : the
   first matching the constructor <code>Any.E x</code>
   with <code>x</code> having type <code>s</code>, the second anything
   else (that is, <code>proj</code> is total).
   
   <p>Finally we come to the public function <code>embed</code>.
   </p><pre class="prettyprint ml">
let embed () = let p = mk () in inj p, proj p
   </pre>
   <code>embed</code> calls <code>mk</code> to produce a new
   embedding <code>p</code> and returns the pair of partial
   applications <code>(inj p, proj p)</code>.
   
   <p>Our examination of the implementation is concluded. There are
   however various implications of the implementation we are now in a
   position to understand that are not immediately obvious from the
   specification. As a first example, consider the inferred type of a
   call to <code>embed</code>.
   </p><pre class="prettyprint ml">
# module U = Universal_exn;;
# let inj, proj = U.embed ();;
val inj : '_a &rarr; U.t = <fun>
val proj : U.t &rarr; '_a option = <fun>
   </fun></fun></pre>
   <b>Property 1 : </b><code>embed</code> produces weakly polymorphic
   functions.
   <br/>
   <br/>
   Consider the following scenario:
   <pre class="prettyprint ml">
# let of_int, to_int = U.embed ();;
# let of_string, to_string = U.embed ();;
   </pre>
   At this point all
   of <code>of_int</code>, <code>to_int</code>, <code>of_string</code>
   and <code>to_string</code> are weakly polymorphic.
   <pre class="prettyprint ml">
# let r : U.t ref = ref (of_int 13);;
   </pre>
   The call to <code>of_int</code> fixes it's type to <code>int &rarr;
   U.t</code> and that of <code>to_int</code> to <code>U.t &rarr; int
   option</code>. The types of <code>of_string</code>
   and <code>to_string</code> remain unfixed.
   <pre class="prettyprint ml">
# to_string !r = Some 13;;
- : bool = false
   </pre>
   The programmer has mistakenly used a projection function from a
   different embedding.
   <pre class="prettyprint ml">
# r := of_string &quot;foo&quot;;;
Error: This expression has type string but an expression was expected of
type int
   </pre>
   The erroneous usage of <code>to_string</code> incidentally fixed
   the type of <code>of_string</code> to <code>int &rarr; U.t</code>! One
   can imagine errors of this kind being difficult to diagnose.
   
   <p>
   <b>Property 2 :</b> Injection/projection functions of different
   embeddings may not be mixed.
   </p><pre class="prettyprint ml">
# let ((of_int : int &rarr; U.t), (to_int : U.t &rarr; int option)) = U.embed ();;
# let ((of_int' : int &rarr; U.t), (to_int' : U.t &rarr; int option)) = U.embed ();;
   </pre>
   Two embeddings have been created, the programmer has fixed the
   types of the injection/projection functions <i>a priori</i>
   (presumably as a defense against the problems of the preceding
   example).
   <pre class="prettyprint ml">
# let r : U.t ref = ref (of_int 13);;
# to_int !r = Some 13;;
- : bool = true
   </pre>
   The first embedding is used to inject an integer. That integer can
   be extracted using the projection function of that embedding.
   <pre class="prettyprint ml">
#  to_int' !r = Some 13;;
- : bool = false
   </pre>
   We cannot extract the integer from the universal type value using
   the projection function from the other embedding despite all of the
   types involved being the same. One can imagine that also as being
   quite the source of bugs and confusion to the unknowing programmer.
   
   <p>
   The constraint of property 2 is beyond the ability of the type
   system to enforce. About the best one can do is to enhance the
   specification of the type with documentation.
    </p><pre class="prettyprint ml">
module type UNIV = sig
  type t

  val embed : unit &rarr; (&alpha; &rarr; t) * (t &rarr; &alpha; option)
 
  (* A pair [(inj, proj)] returned by [embed] works together in that
     [proj u] will return [Some v] if and only if [u] was created by
     [inj v]. If [u] was created by a different function then [proj u] 
     will return [None]. *)

end;;
    </pre>
   <hr/>

