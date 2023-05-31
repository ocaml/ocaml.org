---
title: Dictionaries as functions
description: This is an "oldie but a goodie". It's super easy.   A dictionary is a
  data structure that represents a map from keys to values. The questi...
url: http://blog.shaynefletcher.org/2016/04/dictionaries-as-functions.html
date: 2016-04-13T16:58:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

&amp;#60;h2&amp;#62;&amp;#60;/h2&amp;#62;
&amp;#60;p&amp;#62;
This is an &amp;#34;oldie but a goodie&amp;#34;. It's super easy.
&amp;#60;/p&amp;#62;
&amp;#60;p&amp;#62;
A dictionary is a data structure that represents a map from keys to values. The question is, can this data structure and its characteristic operations be encoded using only functions?
&amp;#60;/p&amp;#62;
&amp;#60;p&amp;#62;
The answer of course is yes and indeed, here's one such an encoding in OCaml.
&amp;#60;p&amp;#62;
&amp;#60;pre class=&amp;#34;prettyprint ml&amp;#34;&amp;#62;
(*The type of a dictionary with keys of type [&amp;#38;alpha;] and values of type
  [&amp;#38;beta;]*)
type (&amp;#38;alpha;, &amp;#38;beta;) dict = &amp;#38;alpha; -&amp;#62; &amp;#38;beta; option

(*The empty dictionary maps every key to [None]*)
let empty (k : &amp;#38;alpha;) : &amp;#38;beta; option = None

(*[add d k v] is the dictionary [d] together with a binding of [k] to
  [v]*)
let add (d : (&amp;#38;alpha;, &amp;#38;beta;) dict) (k : &amp;#38;alpha;) (v : &amp;#38;beta;) : (&amp;#38;alpha;, &amp;#38;beta;) dict = 
  fun l -&amp;#62; 
    if l = k then Some v else d l

(*[find d k] retrieves the value bound to [k]*)
let find (d : (&amp;#38;alpha;, &amp;#38;beta;) dict) (k : &amp;#38;alpha;) : &amp;#38;beta; option = d k
&amp;#60;/pre&amp;#62;
Test it like this.
&amp;#60;pre class=&amp;#34;prettyprint ml&amp;#34;&amp;#62;
(*e.g.

  Name                            &amp;#38;#124; Age
  ================================+====
  &amp;#34;Felonius Gru&amp;#34;                  &amp;#38;#124;  53
  &amp;#34;Dave the Minion&amp;#34;               &amp;#38;#124; 4.54e9
  &amp;#34;Dr. Joseph Albert Nefario&amp;#34;     &amp;#38;#124;  80

*)
let despicable = 
  add 
    (add 
       (add 
          empty &amp;#34;Felonius Gru&amp;#34; 53
       ) 
       &amp;#34;Dave the Minion&amp;#34; (int_of_float 4.54e9)
    )
    &amp;#34;Dr. Nefario&amp;#34; 80 

let _ = 
  find despicable &amp;#34;Dave the Minion&amp;#34; &amp;#38;#124;&amp;#62; 
      function &amp;#38;#124; Some x -&amp;#62; x &amp;#38;#124; _ -&amp;#62; failwith &amp;#34;Not found&amp;#34;
&amp;#60;/pre&amp;#62;
&amp;#60;/p&amp;#62;
&amp;#60;p&amp;#62;Moving on, can we implement this in C++? Sure. Here's one way.
&amp;#60;pre class=&amp;#34;prettyprint ml&amp;#34;&amp;#62;
#include &amp;#38;lt;pgs/pgs.hpp&amp;#38;gt;

#include &amp;#38;lt;functional&amp;#38;gt;
#include &amp;#38;lt;iostream&amp;#38;gt;
#include &amp;#38;lt;cstdint&amp;#38;gt;

using namespace pgs;

// -- A rough and ready `'a option` (given the absence of
// `std::experimental::optional`

struct None {};

template &amp;#38;lt;class A&amp;#38;gt;
struct Some { 
  A val;
  template &amp;#38;lt;class Arg&amp;#38;gt;
  explicit Some (Arg&amp;#38;&amp;#38; s) : val { std::forward&amp;#38;lt;Arg&amp;#38;gt; (s) }
  {}
};

template &amp;#38;lt;class B&amp;#38;gt;
using option = sum_type&amp;#38;lt;None, Some&amp;#38;lt;B&amp;#38;gt;&amp;#38;gt;;

template &amp;#38;lt;class B&amp;#38;gt;
std::ostream&amp;#38; operator &amp;#38;lt;&amp;#38;lt; (std::ostream&amp;#38; os, option&amp;#38;lt;B&amp;#38;gt; const&amp;#38; o) {
  return o.match&amp;#38;lt;std::ostream&amp;#38;&amp;#38;gt;(
    [&amp;#38;](Some&amp;#38;lt;B&amp;#38;gt; const&amp;#38; a) -&amp;#38;gt; std::ostream&amp;#38; { return os &amp;#38;lt;&amp;#38;lt; a.val; },
    [&amp;#38;](None) -&amp;#38;gt; std::ostream&amp;#38; { return os &amp;#38;lt;&amp;#38;lt; &amp;#34;&amp;#38;lt;empty&amp;#38;gt;&amp;#34;; }
  );
}

//-- Encoding of dictionaries as functions

template &amp;#38;lt;class K, class V&amp;#38;gt;
using dict_type = std::function&amp;#38;lt;option&amp;#38;lt;V&amp;#38;gt;(K)&amp;#38;gt;;

//`empty` is a dictionary constant (a function that maps any key to
//`None`)
template &amp;#38;lt;class A, class B&amp;#38;gt;
dict_type&amp;#38;lt;A, B&amp;#38;gt; empty = 
  [](A const&amp;#38;) { 
    return option&amp;#38;lt;B&amp;#38;gt;{ constructor&amp;#38;lt;None&amp;#38;gt;{} }; 
};

//`add (d, k, v)` extends `d` with a binding of `k` to `v`
template &amp;#38;lt;class A, class B&amp;#38;gt;
dict_type&amp;#38;lt;A, B&amp;#38;gt; add (dict_type&amp;#38;lt;A, B&amp;#38;gt; const&amp;#38; d, A const&amp;#38; k, B const&amp;#38; v) {
  return [=](A const&amp;#38; l) {
    return (k == l) ? option&amp;#38;lt;B&amp;#38;gt;{ constructor&amp;#38;lt;Some&amp;#38;lt;B&amp;#38;gt;&amp;#38;gt;{}, v} : d (l);
  };
}

//`find (d, k)` searches for a binding in `d` for `k`
template &amp;#38;lt;class A, class B&amp;#38;gt;
option&amp;#38;lt;B&amp;#38;gt; find (dict_type&amp;#38;lt;A, B&amp;#38;gt; const&amp;#38; d, A const&amp;#38; k) {
  return d (k);
}

//-- Test driver

int main () {

  using dict_t = dict_type&amp;#38;lt;std::string, std::int64_t&amp;#38;gt;;

  auto nil = empty&amp;#38;lt;std::string, std::int64_t&amp;#38;gt;;
  dict_t(*insert)(dict_t const&amp;#38;, std::string const&amp;#38;, std::int64_t const&amp;#38;) = &amp;#38;add;


  dict_t despicable = 
    insert (
      insert (
        insert (nil
           , std::string {&amp;#34;Felonius Gru&amp;#34;}, std::int64_t{53})
           , std::string {&amp;#34;Dave the Minion&amp;#34;}, std::int64_t{4530000000})
          , std::string {&amp;#34;Dr. Joseph Albert Nefario&amp;#34;}, std::int64_t{80})
     ;

  std::cout &amp;#38;lt;&amp;#38;lt; 
    find (despicable, std::string {&amp;#34;Dave the Minion&amp;#34;}) &amp;#38;lt;&amp;#38;lt; std::endl;

  return 0;
}
&amp;#60;/pre&amp;#62;
&amp;#60;/p&amp;#62;
