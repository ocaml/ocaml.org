---
title: Haskell type-classes in OCaml and C++
description: Haskell type-classes in OCaml and C++            This article examines
  the emulation of Haskell like        type-classes...
url: http://blog.shaynefletcher.org/2016/10/haskell-type-classes-in-ocaml-and-c.html
date: 2016-10-26T19:25:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
     
    
    <title>Haskell type-classes in OCaml and C++</title>
  </head>
  <body>
    <p>This article examines the emulation of Haskell like
       type-classes in OCaml and C++. It follows [1] closely
       (recommended for further reading), extending on some of the
       example code given there to include C++.
    </p>
    <p>First stop, a simplified version of the <code>Show</code>
       type-class with a couple of simple instances.
    </p><pre class="prettyprint haskell">
    class Show a where
      show :: a -&gt; string

    instance Show Int where
      show x = Prelude.show x -- internal

    instance Show Bool where
      str True = &quot;True&quot;
      str False = &quot;False&quot;
    </pre>
    The OCaml equivalent shown here uses the &quot;dictionary passing&quot;
    technique for implementation. The type-class
    declaration <code>Show</code> in Haskell translates to a data-type
    declaration for a polymorphic record <code>&alpha; show</code> in
    OCaml.
    <pre class="prettyprint ocaml">
    type &alpha; show = {
      show : &alpha; &rarr; string
    }

    let show_bool : bool show = {
      show = function | true &rarr; &quot;True&quot; | false &rarr; &quot;False&quot;
    }

    let show_int : int show = {
      show = string_of_int
    }
    </pre>
    In C++ we can use a template class to represent the type-class and
    specializations to represent the instances.
    <pre class="prettyprint c++">
      template &lt;class A&gt; struct Show {};

      template &lt;&gt;
      struct Show&lt;int&gt; {
        static std::string (*show)(int);
      };
      std::string(*Show&lt;int&gt;::show)(int) = &amp;std::to_string;

      template &lt;&gt;
      struct Show&lt;bool&gt; {
        static std::string show (bool);
      };
      std::string Show&lt;bool&gt;::show (bool b) { return b ? &quot;true&quot; : &quot;false&quot;; }
    </pre>
    
    <p>
    Next up <code>print</code>, a parametrically polymorphic function.
    </p><pre class="prettyprint haskell">
      print :: Show a =&gt; a -&gt; IO ()
      print x = putStrLn$ show x
    </pre>
    According to our dictionary passing scheme in OCaml, this renders as the following.
    <pre class="prettyprint ocaml">
      let print : &alpha; show &rarr; &alpha; &rarr; unit = 
        fun {show} &rarr; fun x &rarr; print_endline@@ show x
    </pre>
    The key point to note here is that in OCaml, evidence of
    the <code>&alpha;</code> value's membership in
    the <code>Show</code> class must be produced explicitly by the
    programmer. In C++, like Haskell, no evidence of the argument's
    membership is required, the compiler keeps track of that
    implicitly.
    <pre class="prettyprint c++">
    template &lt;class A&gt;
    void print (A const&amp; a) {
      std::cout &lt;&lt; Show&lt;A&gt;::show (a) &lt;&lt; std::endl;
    }
    </pre>
    
    <p>This next simplified type-class shows a different pattern of
    overloading : the function <code>fromInt</code> is overloaded on
    the result type and the <code>(+)</code> function is binary.
    </p><pre class="prettyprint haskell">
    class Num a where
      fromInt :: Int -&gt; a
      (+)     :: a -&gt; a -&gt; a

    sum :: Num a =&gt; [a] -&gt; a
    sum ls = foldr (+) (fromInt 0) ls
    </pre>
    Translation into OCaml is as in the following.
    <pre class="prettyprint ocaml">
    type &alpha; num = {
      from_int : int &rarr; &alpha;;
      add      : &alpha; &rarr; &alpha; &rarr; &alpha;;
    }

    let sum : &alpha; num &rarr; &alpha; list &rarr; &alpha; = 
      fun {from_int; add= ( + )} &rarr; 
        fun ls &rarr;
          List.fold_right ( + ) ls (from_int 0)
    </pre>
    Translation into C++, reasonably mechanical. One slight
    disappointment is that it doesn't seem possible to get the
    operator '<code>+</code>' syntax as observed in both the Haskell
    and OCaml versions.
    <pre class="prettyprint c++">
    template &lt;class A&gt;
    struct Num {};
    
    namespace detail {
      template &lt;class F, class A, class ItT&gt;
      A fold_right (F f, A z, ItT begin, ItT end) {
        if (begin == end) return z;
        return f (fold_right (f, z, std::next (begin), end), *begin);
      }
    }//namespace&lt;detail&gt; 
    
    template &lt;class ItT&gt;
    typename std::iterator_traits&lt;ItT&gt;::value_type 
    sum (ItT begin, ItT end) {
      using A = typename std::iterator_traits&lt;ItT&gt;::value_type;
      auto add = Num&lt;A&gt;::add;
      auto from_int = Num&lt;A&gt;::from_int;
      return detail::fold_right (add, from_int (0), begin, end);
    }
    </pre>
    In Haskell, <code>Int</code> is made a member of <code>Num</code>
    with this declaration.
    <pre class="prettyprint haskell">
     instance Num Int where
       fromInt x = x
       (+)       = (Prelude.+)
   </pre>
   Returning to OCaml, we can define a couple of instances including the one above like this.
   <pre class="prettyprint ocaml">
    let int_num  : int num  = { 
      from_int = (fun x &rarr; x); 
      add      = Pervasives.( + ); 
    }
    
    let bool_num : bool num = {
      from_int = (function | 0 &rarr; false | _ &rarr; true);
      add = function | true &rarr; fun _ &rarr; true | false &rarr; fun x &rarr; x
    }
   </pre>
   The code defining those above instances in C++ follows.
   <pre class="prettyprint c++">
    template &lt;&gt;
    struct Num&lt;int&gt; {
      static int from_int (int);
      static int add (int, int);
    };
    
    int Num&lt;int&gt;::from_int (int i) { return i; }
    int Num&lt;int&gt;::add (int x, int y) { return x + y; }
    
    template &lt;&gt;
    struct Num&lt;bool&gt; {
      static bool from_int (int);
      static bool add (bool, bool);
    };
    
    bool Num&lt;bool&gt;::from_int (int i) { return i != 0; }
    bool Num&lt;bool&gt;::add (bool x, bool y) { if (x) return true; return y; }
   </pre>
   Here now is a function with two type-class constraints.
   <pre class="prettyprint haskell">
    print_incr :: (Show a, Num a) =&gt; a -&gt; IO ()
    print_incr x = print$ x + fromInt 1
   </pre>
   In OCaml this can be written like so.
   <pre class="prettyprint ocaml">
    let print_incr : (&alpha; show * &alpha; num) &rarr; &alpha; &rarr; unit = 
      fun (show, {from_int; add= ( + )}) &rarr; 
        fun x &rarr; print show (x + (from_int 1))
   </pre>
   In C++, this is said as you see below.
   <pre class="prettyprint c++">
    template &lt;class A&gt;
    void print_incr (A x) {
      print (Num&lt;A&gt;::add (x, Num&lt;A&gt;::from_int (1)));
    }
   </pre>
   Naturally, the above function will only be defined for
   types <code>A</code> that are members of both the <code>Show</code>
   and <code>Num</code> classes and will yield compile errors for
   types that are not.
   
   <p>Moving on, we now look at another common pattern, an instance
   with a constraint : a <code>Show</code> instance for all list
   types <code>[a]</code> when the element instance <code></code> is a
   member of <code>Show</code>.
   </p><pre class="prettyprint haskell">
    instance Show a =&gt; Show [a] where
      show xs = &quot;[&quot; ++ go True xs
        where
          go _ [] = &quot;]&quot;
          go first (h:t) =
            (if first then &quot;&quot; else &quot;, &quot;) ++ show h ++ go False t
   </pre>
   
   In OCaml, this takes the form of a function. The idea is, given
   evidence of a type <code>&alpha;</code>'s membership
   in <code>Show</code> the function produces evidence that the
   type <code>&alpha; list</code> is also in <code>Show</code>.
   <pre class="prettyprint ocaml">
    let show_list : &alpha; show &rarr; &alpha; list show =
      fun {show} &rarr;
        {show = fun xs &rarr;
          let rec go first = function
            | [] &rarr; &quot;]&quot;
            | h :: t &rarr;
              (if (first) then &quot;&quot; else &quot;, &quot;) ^ show h ^ go false t in
          &quot;[&quot; ^ go true xs
        }
   </pre>
   It might be possible to do better than the following partial
   specialization over <code>vector&lt;&gt;</code> in C++ (that is, to
   write something generic, just once, that works for a wider set
   ofsequence types) using some advanced meta-programming &quot;hackery&quot;, I
   don't really know. I suspect finding out might be a bit of a rabbit
   hole best avoided for now.
   <pre class="prettyprint c++">
    template &lt;class A&gt;
    struct Show&lt;std::vector&lt;A&gt;&gt; {
      static std::string show (std::vector&lt;A&gt; const&amp; ls);
    };
    
    template &lt;class A&gt;
    std::string Show&lt;std::vector&lt;A&gt;&gt;::show (std::vector&lt;A&gt; const&amp; ls) {
      bool first=true;
      typename std::vector&lt;A&gt;::const_iterator begin=ls.begin (), end=ls.end ();
      std::string s=&quot;[&quot;;
      while (begin != end) {
        if (first) first = false;
        else s += &quot;, &quot;;
        //A compile time error will result here if if there is no
        //evidence that `A` is in `Show`
        s += Show&lt;A&gt;::show (*begin++);
      }
      s += &quot;]&quot;;
    
      return s;
    }
   </pre>
   

   <p>In this next example, we need a type-class describing types that
      can be compared for equality, <code>Eq</code>. That property and
      the <code>Num</code> class can be combined to produce a
      type-class with a super-class and a default.
   </p><pre class="prettyprint haskell">
    class Eq where
      (==) :: a -&gt; a -&gt; bool
      (/=) :: a -&gt; a -&gt; bool
  
    deriving instance Eq Bool
    deriving instance Eq Int

    class (Eq a, Num a) =&gt; Mul a where
      (*) :: a -&gt; a -&gt; a
      x * _ | x == fromInt 0 = fromInt 0
      x * y | x == fromInt 1 = y
      x * y | y + (x + (fromInt (-1))) * y

    dot :: Mul a =&gt; [a] -&gt; [a] -&gt; a
    dot xs ys = sum$ zipWith ( * ) xs ys
   </pre>
   Modeling the above in OCaml is done with a dictionary for
   the <code>Mul</code> type-class and a function to generate
   instances from super-class instances.
   <pre class="prettyprint ocaml">
    type &alpha; mul = {
      mul_super : &alpha; eq * &alpha; num;
      mul : &alpha; &rarr; &alpha; &rarr; &alpha;
    }
    
    let mul_default : &alpha; eq * &alpha; num &rarr; &alpha; mul = 
      fun (({eq}, {from_int; add = ( + )}) as super) &rarr; 
        {
          mul_super = super;
          mul = let rec loop x y = begin match () with
          | () when eq x (from_int 0) &rarr; from_int 0
          | () when eq x (from_int 1) &rarr; y
          | () &rarr; y + loop (x + (from_int (-1))) y 
          end in loop
        }
    
    let bool_mul : bool mul = 
      mul_default (bool_eq, bool_num)
    
    let int_mul : int mul = {
      mul_super = (int_eq, int_num);
      mul = Pervasives.( * )
    }

    let dot : &alpha; mul &rarr; &alpha; list &rarr; &alpha; list &rarr; &alpha; = 
      fun {mul_super = (eq, num); mul} &rarr;
        fun xs ys &rarr; sum num@@ List.map2 mul xs ys
   </pre>
   As one would expect, expressing the base class/derived class
   relationships in C++ is playing to its strengths.
   <pre class="prettyprint c++">
    template &lt;class A&gt; struct Eq {};
    
    template &lt;&gt;
    struct Eq&lt;bool&gt; {
      static bool eq (bool, bool);
      static bool neq (bool, bool);
    };
    
    bool Eq&lt;bool&gt;::eq (bool s, bool t) { return s == t; }
    bool Eq&lt;bool&gt;::neq (bool s, bool t) { return s != t; }
    
    template &lt;&gt;
    struct Eq&lt;int&gt; {
      static int eq (int, int);
      static int neq (int, int);
    };
    
    int Eq&lt;int&gt;::eq (int s, int t) { return s == t; }
    int Eq&lt;int&gt;::neq (int s, int t) { return s != t; }

    template &lt;class A&gt;
    struct Mul : Eq&lt;A&gt;, Num &lt;A&gt; {
      using Eq&lt;A&gt;::eq;
      using Num&lt;A&gt;::add;
      using Num&lt;A&gt;::from_int;
    
      static A mul (A x, A y);
    };
    
    template &lt;class A&gt;
    A Mul&lt;A&gt;::mul (A x, A y) {
      if (eq (x, from_int (0))) return from_int (0);
      if (eq (x, from_int (1))) return y;
      return add (y, mul ((add (x, from_int (-1))), y));
    }
    
    template struct Mul&lt;bool&gt;;
    template &lt;&gt; int Mul&lt;int&gt;::mul (int x, int y) { return x * y; }
    
    namespace detail{
    
      template &lt;class F, class It, class Acc&gt;
      Acc map2 (F f
       , It xs_begin, It xs_end, It ys_begin, It ys_end, Acc acc) {
        if ((xs_begin == xs_end) || (ys_begin == ys_end)) return acc;
        return map2 (f
              , std::next (xs_begin)
              , xs_end
              , std::next (ys_begin)
              , ys_end
              , *acc++ = f (*xs_begin, *ys_begin));
      }
    
    }//namespace detail
    
    template &lt;class A&gt;
    A dot (std::vector&lt;A&gt; const&amp; xs, std::vector&lt;A&gt; const&amp; ys) {
      std::vector&lt;A&gt; buf;
      detail::map2 (
         Mul&lt;A&gt;::mul
       , xs.begin (), xs.end()
       , ys.begin (), ys.end ()
       , std::back_inserter(buf));
      return sum (buf.begin (), buf.end ());
    }
   </pre>
   
   <p>This very last example is in polymorphic recursion. The Haskell reads as follows.
   </p><pre class="prettyprint haskell">
   print_nested :: Show a =&gt; Int -&gt; a -&gt; IO ()
   print_nested 0 x = print x
   print_nested n x = print_nested (n - 1) (replicate n x)

   test_nested = do
     n &lt;- getLine
     print_nested (read n) (5::Int)
   </pre>
   
   Those two functions are very interesting! Translating it to OCaml
   yields the following.
   <pre class="prettyprint ocaml">
    let rec replicate : int &rarr; &alpha; &rarr; &alpha; list = 
      fun n x &rarr; if n &gt;= 0 then [] else x :: replicate (n - 1) x
    
    let rec print_nested : &alpha;. &alpha; show &rarr; int &rarr; &alpha; &rarr; unit =
      fun show_dict &rarr; function
      | 0 &rarr;
          fun x &rarr;
            print show_dict x
      | n &rarr; 
          fun x &rarr;
            print_nested (show_list show_dict) (n - 1) (replicate n x)

    let test_nested =
      let n = read_int () in
      print_nested show_int n 5
   </pre>
   Now if you examine the output of the above if '4' (say) was
   entered, you'll see something like this:
   <pre>
   [[[[5, 5, 5, 5], [5, 5, 5, 5], [5, 5, 5, 5]], [[5, 5, 5, 5], [5, 5,
   5, 5], [5, 5, 5, 5]]]]
   </pre>
   You can see, looking at this, that the type of the printed list is
   not determinable at compile-time. It is dependent on a runtime
   parameter! It follows that the evidence that the type is in
   the <code>Show</code> class can not be produced statically. It has
   to be computed dynamically which is what you see there in the
   application of <code>show_list</code> to the
   current <code>show_dict</code> in the <code>n &lt;&gt; 0</code>
   branch of the <code>print_nested</code> function. Note also the
   requirement for the universal quantifier in the function
   signature. It's mandatory.
   
   <p>OK, so how about the above code in C++? Well a naive
   transliteration gives the following.
   </p><pre class="prettyprint c++">
    namespace detail {
      template&lt;class A, class ItT&gt;
      ItT replicate (int n, A x, ItT dst) {
        if (n &lt;= 0) return dst;
        return replicate ((n - 1), x, *dst++ = x);
      }
    
    }//namespace detail
    
    template &lt;class A&gt;
    void print_nested (int n, A const&amp; x) {
      if (n == 0)
        print (x);
      else {
        std::vector&lt;A&gt; buf;
        detail::replicate(n, x, std::back_inserter(buf));
        print_nested (n - 1, buf);
      }
    }
    
    void test_nested () {
      int n;
      std::cin &gt;&gt; n;
      print_nested (n, 5);
    }
   </pre>
   Unfortunately though, this program though exhibits unbounded
   compile time recursion (compilation doesn't terminate).
   
   <hr/>
   <p>
     References:<br/>
     [1] <a href="http://okmij.org/ftp/Computation/typeclass.html">Implementing, and Understanding Type Classes</a> -- Oleg Kiselyov
   </p>
  </body>
</html>

