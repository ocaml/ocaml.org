---
title: Generic mappings over pairs
description: Browsing around on Oleg Kiselyov's  excellent site, I came across a very
  interesting paper about " Advanced Polymorphism in Simpler-Typed L...
url: http://blog.shaynefletcher.org/2016/06/generic-mappings-over-pairs.html
date: 2016-06-17T19:39:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<h2></h2>
<p>Browsing around on <a href="http://okmij.org/ftp/">Oleg Kiselyov's</a> excellent site, I came across a very interesting paper about &quot;<a href="http://okmij.org/ftp/Computation/extra-polymorphism.html">Advanced Polymorphism in Simpler-Typed Languages</a>&quot;. One of the neat examples I'm about to present is concerned with expressing mappings over pairs that are generic not only in the datatypes involved but also over the number of arguments. The idea is to produce a family of functions $pair\_map_{i}$ such that
</p><pre>
pair_map_1 f g (x, y) (x', y') &rarr; (f x, g y) 
pair_map_2 f g (x, y) (x', y') &rarr; (f x x', g y y') 
pair_map_3 f g (x, y) (x', y') (x'', y'', z'') &rarr; (f x x' x'', g y y' y'')
       .
       .
       .
</pre>
The technique used to achieve this brings a whole bunch of functional programming ideas together : higher order functions, combinators and continuation passing style (and also leads into topics like the &quot;value restriction&quot; typing rules in the Hindley-Milner system).
<pre class="prettyprint ml">
let ( ** ) app k = fun x y -&gt; k (app x y)
let pc k a b = k (a, b)
let papp (f1, f2) (x1, x2) = (f1 x1, f2 x2)
let pu x = x
</pre>
With the above definitions, $pair\_map_{i}$ is generated like so.
<pre class="prettyprint ml">
(*The argument [f] in the below is for the sake of value restriction*)
let pair_map_1 f = pc (papp ** pu) (f : &alpha; -&gt; &beta;)
let pair_map_2 f = pc (papp ** papp ** pu) (f : &alpha; -&gt; &beta; -&gt; &gamma;)
let pair_map_3 f = pc (papp ** papp ** papp ** pu) (f : &alpha; -&gt; &beta; -&gt; &gamma; -&gt; &delta;)
</pre>
For example,
<pre>
# pair_map_2 ( + ) ( - ) (1, 2) (3, 4) ;;
- : int * int = (4, -2)
</pre>

<p>Reverse engineering how this works requires a bit of algebra.
</p>
<p>Let's tackle $pair\_map_{1}$. First
</p><pre>
pc (papp ** pu) = (&lambda;k f g. k (f, g)) (papp ** pu) = &lambda;f g. (papp ** pu) (f, g)
</pre>
and,
<pre>
papp ** pu = &lambda;x y. pu (papp x y) = &lambda;x y. papp x y
</pre>
so,
<pre>
&lambda;f g. (papp ** pu) (f, g) =
    &lambda;f g. (&lambda;(a, b) (x, y). (a x, b y)) (f, g) =
    &lambda;f g (x, y). (f x, g y)
</pre>
that is,
<code>pair_map_1 = pc (papp ** pu) = &lambda;f g (x, y). (f x, g y)</code> and, we can read the type off from that last equation as <code>(&alpha; &rarr; &beta;) &rarr; (&gamma; &rarr; &delta;) &rarr; &alpha; * &gamma; &rarr; &beta; * &delta;</code>.

<p>Now for $pair\_map_{2}$. We have
</p><pre>
pc (papp ** papp ** pu) =
    (&lambda;k f g. k (f, g)) (papp ** papp ** pu) =
    &lambda;f g. (papp ** papp ** pu) (f, g)
</pre>
where,
<pre>
papp ** papp ** pu = papp ** (papp ** pu) =
    papp ** (&lambda;a' b'. pu (papp a' b')) =
    papp ** (&lambda;a' b'. papp a' b') = 
    &lambda;a b. (&lambda;a' b'. papp a' b') (papp a b)
</pre>
which means,
<pre>
pc (papp ** papp ** pu) = 
    &lambda;f g. (papp ** papp ** pu) (f, g) =
    &lambda;f g. (&lambda;a b.(&lambda;a' b'. papp a' b') (papp a b)) (f, g) =
    &lambda;f g. (&lambda;b. (&lambda;a' b'. papp a' b') (papp (f, g) b)) =
    &lambda;f g. &lambda;(x, y). &lambda;a' b'. (papp a' b') (papp (f, g) (x, y)) =
    &lambda;f g. &lambda;(x, y). &lambda;a' b'. (papp a' b') (f x, g y) =
    &lambda;f g. &lambda;(x, y). &lambda;b'. papp (f x, g y) b' =
    &lambda;f g. &lambda;(x, y). &lambda;(x', y'). papp (f x, g y) (x', y') =
    &lambda;f g (x, y) (x', y'). (f x x', g y y')
</pre>
that is, a function in two binary functions and two pairs as we expect. Phew! The type in this instance is <code>(&alpha; &rarr; &beta; &rarr; &gamma;) &rarr; (&delta; &rarr; &epsilon; &rarr; &zeta;) &rarr; &alpha; * &delta; &rarr; &beta; * &epsilon; &rarr; &gamma; * &zeta;</code>.

<p>
To finish off, here's the program transliterated into C++(14).
</p><pre class="prettyprint c++">
#include &lt;utility&gt;
#include &lt;iostream&gt;

//let pu x = x
auto pu = [](auto x) { return x; };

//let ( ** ) app k  = fun x y -&gt; k (app x y)
template &lt;class F, class K&gt;
auto operator ^ (F app, K k) {
  return [=](auto x) {
    return [=] (auto y) {
      return k ((app (x)) (y));
    };
  };
}

//let pc k a b = k (a, b)
auto pc = [](auto k) {
  return [=](auto a) {
    return [=](auto b) { 
      return k (std::make_pair (a, b)); };
  };
};

//let papp (f, g) (x, y) = (f x, g y)
auto papp = [](auto f) { 
  return [=](auto x) { 
    return std::make_pair (f.first (x.first), f.second (x.second)); };
};

int main () {

  auto pair = &amp;std::make_pair&lt;int, int&gt;;

  {
  auto succ= [](int x){ return x + 1; };
  auto pred= [](int x){ return x - 1; };
  auto p  = (pc (papp ^ pu)) (succ) (pred) (pair (1, 2));
  std::cout &lt;&lt; p.first &lt;&lt; &quot;, &quot; &lt;&lt; p.second &lt;&lt; std::endl;
  }

  {
  auto add = [](int x) { return [=](int y) { return x + y; }; };
  auto sub = [](int x) { return [=](int y) { return x - y; }; };
  auto p = pc (papp ^ papp ^ pu) (add) (sub) (pair(1, 2)) (pair (3, 4));
  std::cout &lt;&lt; p.first &lt;&lt; &quot;, &quot; &lt;&lt; p.second &lt;&lt; std::endl;
  }

  return 0;
}
</pre>


