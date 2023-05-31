---
title: More type classes in OCaml
description: "More type classes in OCaml    More type classes Author:  Joel Bj\xF6rnson
  \  About the author: Joel has been enjoying functional programming ..."
url: http://blog.shaynefletcher.org/2017/05/more-type-classes-in-ocaml.html
date: 2017-05-22T16:34:00-00:00
preview_image:
featured:
authors:
- Unknown
---

<html> <head>  <title>More type classes in OCaml</title> </head> <body> <h1>More type classes</h1><p><i><b>Author:</b> Joel Bj&ouml;rnson<br/>
<br/>
<b>About the author: </b>Joel has been enjoying functional programming ever since being introduced to Haskell at Chalmers University (Sweden). Since then he's been dabbling in F# and more recently OCaml. He's currently based in London, working at the intersection of functional programming and finance.</i></p><p>As demonstrated in previous articles on this blog, OCaml comes with a rich module system. Among other things it enables developers to write code that is polymorphic over module signatures.  As such, parameterized modules (aka functors) play a similar role to what type classes do in Haskell, and as explained <a href="http://blog.shaynefletcher.org/2016/10/implementing-type-classes-as-ocaml.html">here</a>, it is straightforward to map simple type classes to modules in OCaml. In Haskell, type classes are often used as design patterns for structuring programs and over the years a taxonomy of type classes inspired by <a href="https://en.wikipedia.org/wiki/Category_theory">Category Theory</a> has evolved.  Standard patterns such as <i>functor</i>, <i>monad</i> and <i>monoid</i> have had a strong influence on the design of common APIs.  In OCaml there is less focus on such idioms. In this post we explore how some of the Haskell patterns implemented in terms of type classes can be ported to OCaml and how that impacts program design. In particular we cover four commonly used type classes that ships with standard Haskell distributions: </p><ul><li>Functor</li>
<li>Monoid</li>
<li>Applicative Functor</li>
<li>Traversable</li>
</ul>For a more comprehensive guide to these patterns and others <a href="https://wiki.haskell.org/Typeclassopedia">Typclassopedia</a> serves as a good resource. Before tackling the technical aspects it may be worth  elaborating a bit on the motivation behind introducing these types of  abstractions in the first place. Justifications fall under different categories: <ol><li>API design</li>
<li>Code reusability</li>
<li>Testability</li>
</ol>The first one is about program design - by mapping a data type to a pattern such as applicative functor, we obtain a set of combinators for operating on values of that type. Ideally that means less time spent on inventing custom operators and figuring out their semantics. When multiple libraries share patterns it also increases the likelihood that consumers of anyone of those libraries already are familiar with the corresponding combinators. For example looking at the <code class="code">map</code> function over some custom data type, one should expect it to have similar properties to the function <code class="code">List.map</code> operating on lists.  The second point is about code reuse. By writing functions that are expressed solely in terms of other module signatures they become reusable in different contexts; For instance by implementing the primitive operators for a monoid we get additional combinators (such as <code class="code">concat</code>) defined generically for any monoid for free!  Thirdly, these patterns all come with a set of theoretically well founded properties. As demonstrated by some of the examples below, it is also possible to write generic tests that can be used to validate concrete implementations of the patterns for different underlying data types. <h2>Prerequisites and conventions</h2><p>From now on we'll be using lowercase names such as <i>applicative functor</i> to describe the patterns themselves. Names starting with uppercase, for instance <code>Applicative</code> refers to the Haskell name of the type class, while signature names in OCaml are all uppercase (e.g <code class="code">APPLICATIVE</code> ).  To avoid confusion between the terms <i>functor</i> as in the <i>functor pattern</i> and OCaml functors referring to parameterized modules, we use the name <i>ocaml-functor</i> to mean the latter.  Basic familiarity with Haskell syntax is also be assumed. Importantly, note that Haskell uses the infix operator <code>(.)</code> for function composition: </p><pre><code>f . g = \x -&gt; f (g x)
</code></pre><br/>
In the OCaml code below we instead use <code class="code">( &lt;&lt; )</code> to be defined similarly along with (the more idiomatic) pattern of forward composition <code class="code">( &gt;&gt; )</code> , an identity function <code class="code">id</code> and a function <code class="code">const</code>:  <pre><code class="code"><span class="keyword">let</span> ( &lt;&lt; ) f g x = f (g x);;
<span class="keyword">let</span> ( &gt;&gt; ) f g = g &lt;&lt; f;;
<span class="keyword">let</span> id x       = x;;
<span class="keyword">let</span> const x _  = x;;
</code></pre><br/>
We also deviate slightly from the naming conventions in Haskell for operations, for instance <code>fmap</code> becomes <code class="code">map</code> and <code>mconcat</code> is named <code class="code">concat</code>. <h2>Representing the patterns</h2><p>We use a standard approach for mapping type classes in Haskell to module signatures in OCaml. </p><h3>Functors</h3><p>The <code>Functor</code> type class captures the pattern of mapping over the value(s) of some parameterized data type. In Haskell it can be defined as: </p><pre><code>class  Functor f  where
  fmap :: (a -&gt; b) -&gt; f a -&gt; f b
</code></pre><br/>
In OCaml we may instead construct a corresponding module signature: <pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">FUNCTOR</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> map : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
<span class="keyword">end</span>;;
</code></pre><p>In order for a type to qualify as a functor, one need to provide an implementation for <code class="code">map</code> (<code>fmap</code> in Haskell) that satisfies the signature.  For instance, the <code>Functor</code> instance for the list type in Haskell is given by: </p><pre><code>instance Functor [] where
  fmap = map
</code></pre><br/>
Here, <code>map</code> is the standard map function over lists.  In OCaml we create a module implementing the <code class="code">FUNCTOR</code> signature, which for lists may look like: <pre><code class="code"><span class="keyword">module</span> <span class="constructor">ListFunctor</span> : <span class="constructor">FUNCTOR</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list = <span class="keyword">struct</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list
  <span class="keyword">let</span> map f = <span class="constructor">List</span>.map f
<span class="keyword">end</span>;;
</code></pre><p>One difference is that the module is named which allows for multiple instances of the same signature for the same type to coexist. The <code class="code">with type</code> construct is required in order to be able to export the type <code class="code">'a t</code> specified by the signature. It makes the fact that <code class="code">ListFunctor.t</code> is indeed the type <code class="code">list</code> transparent, allowing us to apply <code class="code">ListFunctor.map</code> to ordinary lists. </p><p>Type classes in Haskell often come with a set of <i>laws</i>. These are specifications that any instance of the type class must obey. However they are not enforced by the type system and thus need to be considered when writing the implementation. For <code>Functor</code>s, any instances should satisfy the following constraints: </p><pre><code>fmap id = id fmap (f . g)  = fmap f . fmap g
</code></pre><br/>
These invariants state that the map function must be <i>structure preserving</i>, i.e. is not allowed to change the shape of the given value mapped over. They also have a deeper theoretical justification when described in terms of <a href="https://en.wikipedia.org/wiki/Functor">Functors in Category Theory</a>.  From a practical point of view it is sufficient to note that violating this constraint leads to code that is difficult to reason about and refactor. Consider for instance a function: <pre><code class="code"><span class="keyword">let</span> increment_twice xs =
  xs
  |&gt; <span class="constructor">List</span>.map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> x + 1)
  |&gt; <span class="constructor">List</span>.map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> x + 1)
;;
</code></pre><br/>
One should expect that applying the following optimization: <pre><code class="code"><span class="keyword">let</span> increment_twice xs = <span class="constructor">List</span>.map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> x + 2) xs;;

</code></pre>does not impact its semantics. <p>An immediate advantage of capturing the functor pattern explicitly via a signature (<code class="code">FUNCTOR</code>) is that it enables us to to define an additional parameterized module with tests for validating any concrete implementation of the signature: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TestFunctor</span> (<span class="constructor">F</span> : <span class="constructor">FUNCTOR</span>) = <span class="keyword">struct</span>

  <span class="keyword">let</span> test_id x = <span class="constructor">F</span>.map id x = x

  <span class="keyword">let</span> test_compose xs =
    <span class="keyword">let</span> f x = x <span class="keyword">mod</span> 2 <span class="keyword">in</span>
    <span class="keyword">let</span> g x = x - 1 <span class="keyword">in</span>
    <span class="constructor">F</span>.map (g &gt;&gt; f) xs = <span class="constructor">F</span>.map f (<span class="constructor">F</span>.map g xs)

<span class="keyword">end</span>;;
</code></pre><br/>
The tests here correspond to the two <i>functor laws</i> stated above. <p>For instance to test <code class="code">ListFunctor</code> we first apply <code class="code">TestFunctor</code> to this module in order to retrieve a specialized version: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TFL</span> = <span class="constructor">TestFunctor</span> (<span class="constructor">ListFunctor</span>);;
</code></pre><p>Here are a few examples of using the module: </p><pre><code class="code"><span class="constructor">TFL</span>.test_id [];;
<span class="constructor">TFL</span>.test_id [1;2];;
<span class="constructor">TFL</span>.test_compose [];;
<span class="constructor">TFL</span>.test_compose [1;2;3];;
</code></pre><p>The <code class="code">option</code> type in OCaml also forms a functor: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">OptionFunctor</span> : <span class="constructor">FUNCTOR</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a option = <span class="keyword">struct</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a option
  <span class="keyword">let</span> map f = <span class="keyword">function</span>
    <span class="keywordsign">|</span> <span class="constructor">Some</span> x  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (f x)
    <span class="keywordsign">|</span> <span class="constructor">None</span>    <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
<span class="keyword">end</span>;;
</code></pre><br/>
And similar to the list example, we get a test module for free: <pre><code class="code"><span class="keyword">module</span> <span class="constructor">TOF</span> = <span class="constructor">TestFunctor</span> (<span class="constructor">OptionFunctor</span>);;

<span class="constructor">TOF</span>.test_id (<span class="constructor">Some</span> 42);;
<span class="constructor">TOF</span>.test_id <span class="constructor">None</span>;;
<span class="constructor">TOF</span>.test_compose (<span class="constructor">Some</span> 42);;
<span class="constructor">TOF</span>.test_compose <span class="constructor">None</span>;;
</code></pre><p>As will be illustrated by some of the examples below, functors are not only applicable to container like types and also not all containers form functors. </p><h3>Monoids</h3><p>Monoid is another example of a common pattern where instances can be found for a variety of types. In Haskell it's defined as: </p><pre><code>class Monoid m where
  mempty :: m
  mappend :: m -&gt; m -&gt; m
</code></pre><br/>
Any type qualifying as a monoid must have identity value (<code>mempty</code>) and a binary operator (<code>mappend</code>) for composing any two elements. <p>The OCaml version can be specified by the following module type: </p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">MONOID</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> t
  <span class="keyword">val</span> empty : t
  <span class="keyword">val</span> append : t <span class="keywordsign">-&gt;</span> t <span class="keywordsign">-&gt;</span> t
<span class="keyword">end</span>;;
</code></pre><p>There are also a few laws that instances should obey: </p><pre><code>mappend mempty x        = x
mappend x mempty        = x
mappend x (mappend y z) = mappend (mappend x y) z
</code></pre><p>The first two state that <code>mempty</code> is an identity element with respect to <code>mappend</code> and the second one that <code>mappend</code> must be associative. Again, this can be captured by a test module: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TestMonoid</span> (<span class="constructor">M</span> : <span class="constructor">MONOID</span>) = <span class="keyword">struct</span>

  <span class="keyword">let</span> test_left_id x = <span class="constructor">M</span>.append <span class="constructor">M</span>.empty x = x

  <span class="keyword">let</span> test_right_id x = <span class="constructor">M</span>.append x <span class="constructor">M</span>.empty = x

  <span class="keyword">let</span> test_assoc x y z =
    <span class="constructor">M</span>.append x (<span class="constructor">M</span>.append y z) = <span class="constructor">M</span>.append (<span class="constructor">M</span>.append x y) z

<span class="keyword">end</span>;;
</code></pre><p>One of the more famous monoids is given by the natural numbers with addition and identity element <i>0</i>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">IntAddMonoid</span> : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = int = <span class="keyword">struct</span>
  <span class="keyword">type</span> t = int
  <span class="keyword">let</span> empty = 0
  <span class="keyword">let</span> append = ( + )
<span class="keyword">end</span>;;
</code></pre><p>Another advantage of formalizing patterns by explicit signatures is that it enables us to define derived combinators generically. For example, the <code class="code">append</code> operation from <code class="code">IntAddMonoid</code> can be lifted to a sum function accepting a list of integers, adding them together or defaulting to 0 if the empty list is given: </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">IntAddMonoid</span>;;
<span class="keyword">let</span> sum xs = <span class="constructor">List</span>.fold_left append empty xs;;
</code></pre><p>The scheme can be generalized to operate on any list of monoids. To avoid having to specify the implementation manually for each monoid instance, one may construct a module-functor for generating extension functions: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">MonoidUtils</span> (<span class="constructor">M</span> : <span class="constructor">MONOID</span>) = <span class="keyword">struct</span>
  <span class="keyword">include</span> <span class="constructor">M</span>
  <span class="keyword">let</span> ( &lt;+&gt; ) x y = append x y
  <span class="keyword">let</span> concat xs = <span class="constructor">List</span>.fold_left ( &lt;+&gt; ) empty xs
<span class="keyword">end</span>;;
</code></pre><p>Here <code class="code">MonoidUtils</code> takes a <code class="code">MONOID</code> module and re-exports its definition along with two additional utility functions, an infix version of append <code class="code">( &lt;+&gt; )</code> and <code class="code">concat</code>. </p><p>Another example of a monoid is a list, parameterized over any type. In Haskell the instance is given by: </p><pre>instance Monoid [a] where
  mempty = []
  mappend x y = x ++ y
</pre><br/>
Where <code>(++)</code> is the concatenation operator for lists. In OCaml one could imagine attempting something like: <pre><code class="code"><span class="comment">(* Pseudo-code - not valid OCaml! *)</span>
<span class="keyword">module</span> <span class="constructor">ListMonoid</span> : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = <span class="keywordsign">'</span>a list = <span class="keyword">struct</span>
  <span class="keyword">type</span> t = <span class="keywordsign">'</span>a list
  <span class="keyword">let</span> empty = []
  <span class="keyword">let</span> append xs ys = xs @ ys
<span class="keyword">end</span>;;
</code></pre><br/>
However it is not possible to directly parameterize modules by types. A work around can be achieved by first introducing a dummy module for wrapping the type and passing it along as a module parameter: <pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">TYPE</span> = <span class="keyword">sig</span> <span class="keyword">type</span> t <span class="keyword">end</span>;;

<span class="keyword">module</span> <span class="constructor">ListMonoid</span> (<span class="constructor">T</span> : <span class="constructor">TYPE</span>) : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = <span class="constructor">T</span>.t list = <span class="keyword">struct</span>
  <span class="keyword">type</span> t = <span class="constructor">T</span>.t list
  <span class="keyword">let</span> empty = []
  <span class="keyword">let</span> append xs ys = xs @ ys
<span class="keyword">end</span>;;
</code></pre><p>This comes with an obvious disadvantage of having to create specialized versions for each concrete list type. Some of the inconvenience is compensated for by explicit type parameters and support for local modules, created at run-time.  Here's an example implementing <code class="code">concat</code> for lists in terms of the generic list monoid: </p><pre><code class="code"><span class="keyword">let</span> concat (<span class="keyword">type</span> a) xs =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">MU</span> = <span class="constructor">MonoidUtils</span> (<span class="constructor">ListMonoid</span>(<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
  <span class="constructor">MU</span>.concat xs;;
</code></pre><p>Its signature is inferred as: </p><pre><code class="code"><span class="keyword">val</span> concat : <span class="keywordsign">'</span>a list list <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a list
</code></pre><h3>Applicative Functors</h3><p>An applicative functor has more structure than a regular functor. In Haskell it can be defined as: </p><pre>class (Functor f) =&gt; Applicative f where
    pure  :: a -&gt; f a
    (&lt;*&gt;) :: f (a -&gt; b) -&gt; f a -&gt; f b
</pre><br/>
The function <code class="code">pure</code> turns a (pure) value into an applicative value and <code class="code">( &lt;*&gt; )</code> takes a function wrapped inside an applicative along with an applicative value and returns an applicative result corresponding to applying the value to the function. The additional constraint (<code>(Functor f) =&gt; Applicative f</code> enforces that any type that instantiates the <code>Applicative</code> type class must also be an instance of <code>Functor</code>. <p>In OCaml we can achieve something similar by including the <code class="code">FUNCTOR</code> signature within a new signature <code class="code">APPLICATIVE</code> as in: </p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">APPLICATIVE</span> = <span class="keyword">sig</span>
  <span class="keyword">include</span> <span class="constructor">FUNCTOR</span>
  <span class="keyword">val</span> pure : <span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> apply : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
<span class="keyword">end</span>;;
</code></pre><br/>
Here the infix operator <code class="code">( &lt;*&gt; )</code> is named <code class="code">apply</code>. <p>For a concrete example consider the applicative instance for the list type. Using the <code class="code">ListFunctor</code> module from above: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ListApplicative</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list = <span class="keyword">struct</span>
  <span class="keyword">include</span> <span class="constructor">ListFunctor</span>

  <span class="keyword">let</span> pure x = [x]

  <span class="keyword">let</span> apply fs xs =
    concat @@ map (<span class="keyword">fun</span> f <span class="keywordsign">-&gt;</span> map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> f x) xs) fs

<span class="keyword">end</span>;;
</code></pre><br/>
<code class="code">ListApplicative</code> simply re-exports the implementation of <code class="code">ListFunctor</code> to satisfy the functor part of the signature, also mirroring the constraint from the Haskell version. <p><code class="code">pure</code> wraps a value in a list. <code class="code">apply</code> takes a list of functions, a list of values and applies each function to all elements of the list. Once again we may construct a <i>utility module</i> with some extra operators implemented using the primitive functions: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ApplicativeUtils</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) = <span class="keyword">struct</span>
  <span class="keyword">include</span> <span class="constructor">A</span>
  <span class="keyword">let</span> ( &lt;$&gt; ) f     = map f
  <span class="keyword">let</span> ( &lt;*&gt; ) f     = apply f
  <span class="keyword">let</span> ( &lt;* ) x y    = const &lt;$&gt; x &lt;*&gt; y
  <span class="keyword">let</span> ( *&gt; ) x y    = (<span class="keyword">fun</span> _ y <span class="keywordsign">-&gt;</span> y) &lt;$&gt; x &lt;*&gt; y
  <span class="keyword">let</span> liftA2 f x y  = f &lt;$&gt; x &lt;*&gt; y
<span class="keyword">end</span>;;
</code></pre><p>The infix operators are variations of apply and map, <code class="code">liftA2</code> is for conveniently <em>lifting</em> a regular function of two arguments into a function operating on two applicative values. </p><p>By applying <code class="code">ListApplicative</code> to the <code>ApplicativeUtils</code> functor we obtain a concrete module for operating on lists: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">LAU</span> = <span class="constructor">ApplicativeUtils</span> (<span class="constructor">ListApplicative</span>);;
</code></pre><br/>
Its full signature can be listed by: <pre><code class="code"><span class="keywordsign">#</span>show_module <span class="constructor">LAU</span>;;
</code></pre><br/>
Producing the following output: <pre><code class="code"><span class="keyword">module</span> <span class="constructor">LAU</span> :
    <span class="keyword">sig</span>
      <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">ListApplicative</span>.t
      <span class="keyword">val</span> map : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
      <span class="keyword">val</span> pure : <span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
      <span class="keyword">val</span> apply : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
      <span class="keyword">val</span> ( &lt;$&gt; ) : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
      <span class="keyword">val</span> ( &lt;* ) : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
      <span class="keyword">val</span> ( *&gt; ) : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
      <span class="keyword">val</span> liftA2 : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>c) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>c t
    <span class="keyword">end</span>
</code></pre><p>Finally let's a take a look at a concrete example to see what the applicative interface actually brings in terms of functionality. Say we want to generate some mock data to be used for testing. Given the following types: </p><pre><code class="code"><span class="keyword">type</span> offer = <span class="constructor">Ask</span> <span class="keywordsign">|</span> <span class="constructor">Bid</span>;;

<span class="keyword">type</span> quote =
  {
    time : int;
    offer : offer;
    ticker : string;
    value : float;
  };;
</code></pre><p>The snippet below produces a list of all possible combinations of some example data by combining a set of properties: </p><pre><code class="code"><span class="keyword">let</span> quotes =
  <span class="keyword">let</span> <span class="keyword">open</span> <span class="constructor">LAU</span> <span class="keyword">in</span>
  (<span class="keyword">fun</span> time offer ticker value <span class="keywordsign">-&gt;</span> { time; offer; ticker; value })
  &lt;$&gt; [1;2;3;4;5]
  &lt;*&gt; [<span class="constructor">Ask</span>; <span class="constructor">Bid</span>]
  &lt;*&gt; [<span class="string">&quot;XYZ&quot;</span>; <span class="string">&quot;ZYK&quot;</span>; <span class="string">&quot;ABC&quot;</span>;<span class="string">&quot;CDE&quot;</span>; <span class="string">&quot;QRZ&quot;</span>]
  &lt;*&gt; [100.; 90.; 80.; 70.];;
</code></pre><br/>
By composing applications of <code class="code">pure</code> and <code class="code">( &lt;*&gt; )</code> we lift functions of arbitrary arity into applicative versions. For the list applicative, that means a generalized version of Cartesian products. <p>Another useful instance of an applicative functor is the <code class="code">option</code> type: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">OptionApplicative</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a option =
<span class="keyword">struct</span>
  <span class="keyword">include</span> <span class="constructor">OptionFunctor</span>

  <span class="keyword">let</span> pure x = <span class="constructor">Some</span> x

  <span class="keyword">let</span> apply fo xo =
    <span class="keyword">match</span> fo, xo <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">Some</span> f, <span class="constructor">Some</span> x  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (f x)
    <span class="keywordsign">|</span> _               <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>

<span class="keyword">end</span>;;
</code></pre><p>Here we rely on the <code class="code">OptionFunctor</code> module to manage the functor part. <code class="code">pure</code> returns a value wrapped by the <code class="code">Some</code> constructor and <code class="code">apply</code> only produces a value if neither of its arguments are <code class="code">None</code> values. As with many other examples of instances, there is basically only one feasible implementation to choose from given the type constraints of the function signature. </p><p>With the implementation of the core interface, utilities come for free: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">OAU</span> = <span class="constructor">ApplicativeUtils</span> (<span class="constructor">OptionApplicative</span>);;
</code></pre><p>We can now use it to conveniently lift operations into versions accepting optional arguments. Consider the following (safe) versions of division and square-root functions: </p><pre><code class="code"><span class="keyword">let</span> ( //. ) n d = <span class="keyword">if</span> d = 0. <span class="keyword">then</span> <span class="constructor">None</span> <span class="keyword">else</span> <span class="constructor">Some</span> (n /. d);;
<span class="keyword">let</span> ssqrt x = <span class="keyword">if</span> x &lt; 0. <span class="keyword">then</span> <span class="constructor">None</span> <span class="keyword">else</span> <span class="constructor">Some</span> (sqrt x);;
</code></pre><p>Say we want to implement the formula <code class="code">f(x,y,z) = (x / y) + sqrt(x) - sqrt(y)</code>. The obvious approach is to use pattern matching as in: </p><pre><code class="code"><span class="keyword">let</span> f x y z =
  <span class="keyword">match</span> x //. y, ssqrt x, ssqrt y <span class="keyword">with</span>
  <span class="keywordsign">|</span> <span class="constructor">Some</span> z, <span class="constructor">Some</span> r1, <span class="constructor">Some</span> r2  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (z +. r1 -. r2)
  <span class="keywordsign">|</span> _                         <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
;;
</code></pre><p>Using the applicative operators from the <code class="code">OAU</code> module enables an alternative (more succinct) definition: </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">OAU</span>;;
<span class="keyword">let</span> f x y z =
 (<span class="keyword">fun</span> z r1 r2 <span class="keywordsign">-&gt;</span> z +. r1 -. r2) &lt;$&gt; (x //. y) &lt;*&gt; ssqrt x &lt;*&gt; ssqrt y
;;
</code></pre><p>Applicative functors also come with a set of laws. In Haskell expressed as: </p><pre>-- Identity
pure id &lt;*&gt; v                 = v

-- Homomorphism
pure f &lt;*&gt; pure x             = pure (f x)

-- Interchange
u &lt;*&gt; pure y                  = pure ($ y) &lt;*&gt; u

--- Composition
pure (.) &lt;*&gt; u &lt;*&gt; v &lt;*&gt; w   = u &lt;*&gt; (v &lt;*&gt; w)
</pre><p>These may again be turned into a generic testing module: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TestApplicative</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) = <span class="keyword">struct</span>

  <span class="keyword">module</span> <span class="constructor">AU</span> = <span class="constructor">ApplicativeUtils</span>(<span class="constructor">A</span>)

  <span class="keyword">open</span> <span class="constructor">AU</span>

  <span class="keyword">let</span> test_id x = (pure id &lt;*&gt; x) = x

  <span class="keyword">let</span> test_hom f x = pure f &lt;*&gt; pure x = pure (f x)

  <span class="keyword">let</span> test_interchange u y =
    (u &lt;*&gt; pure y) = (pure (<span class="keyword">fun</span> f <span class="keywordsign">-&gt;</span> f y) &lt;*&gt; u)

  <span class="keyword">let</span> test_composition u v w =
    (pure ( &lt;&lt; ) &lt;*&gt; u &lt;*&gt; v &lt;*&gt; w) = (u &lt;*&gt; (v &lt;*&gt; w))

<span class="keyword">end</span>;;
</code></pre><br/>
and be used to validate arbitrary instances of this pattern. <p>For example to test the list instance, we first construct a concrete module using the <code class="code">TestApplicative</code> functor: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TAL</span> = <span class="constructor">TestApplicative</span> (<span class="constructor">ListApplicative</span>);;
</code></pre><br/>
This may be used as in: <pre><code class="code"><span class="constructor">TAL</span>.test_hom <span class="constructor">String</span>.length <span class="string">&quot;Homomorphism&quot;</span>;;
</code></pre><h3>Traversables</h3><p>Traversable is an interesting type class which also brings a couple of additional challenges to our effort of mapping Haskell patterns to OCaml. It may be described as a generalization of the <i>iterator pattern</i> and is defined in Haskell as: </p><pre>class (Functor t, Foldable t) =&gt; Traversable t where
  traverse  :: Applicative f =&gt; (a -&gt; f b) -&gt; t a -&gt; f (t b)
  sequenceA :: Applicative f =&gt; t (f a) -&gt; f (t a)
  mapM      ::       Monad m =&gt; (a -&gt; m b) -&gt; t a -&gt; m (t b)
  sequence  ::       Monad m =&gt; t (m a) -&gt; m (t a)
</pre><p>Concrete instances can be written by implementing any one of the above functions as they can all be expressed in terms of each other. We could potentially replicate this flexibility in OCaml by a set of different module-functors with signatures wrapping each function. However, for the purpose of this exercise we settle on <code class="code">traverse</code> as the defining implementation. Traverse is also parameterized over an <code class="code">Applicative</code> functor. A first attempt in OCaml might be something along the lines of: </p><pre><code class="code"><span class="comment">(*Psuedo-code - not valid OCaml!*)</span>
<span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">TRAVERSABLE</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> traverse :  (<span class="keyword">type</span> a)
                  (<span class="keyword">module</span> <span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a a)
                  (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b a) <span class="keywordsign">-&gt;</span>
                  <span class="keywordsign">'</span>a <span class="constructor">A</span>.t <span class="keywordsign">-&gt;</span>
                  (<span class="keywordsign">'</span>b t) a
<span class="keyword">end</span>;;
</code></pre><p>However here the type <code class="code">a</code> would itself require a type parameter.  In Haskell lingo it is said to have kind <code>(* -&gt; *)</code>.  Unfortunately OCaml does not support higher-kinded polymorphism. </p><p>Instead of passing <code class="code">APPLICATIVE</code> as an argument to each invocation of <code class="code">traverse</code> we can embed it in the module signature: </p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">TRAVERSABLE</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t
  <span class="keyword">module</span> <span class="constructor">Applicative</span> : <span class="constructor">APPLICATIVE</span>
  <span class="keyword">val</span> traverse : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b <span class="constructor">Applicative</span>.t) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> (<span class="keywordsign">'</span>b t) <span class="constructor">Applicative</span>.t
<span class="keyword">end</span>;;
</code></pre><br/>
To mimic the Haskell constraints it is tempting to also require the <code class="code">FUNCTOR</code> interface by throwing in a extra <code class="code">include FUNCTOR</code>. However, there's a technical reason for why this may not be a good idea which we'll return to in a bit. <p>Even though the signature references a specific implementation of an <code class="code">APPLICATIVE</code> we can recover genericity by relying on module-functors to specify the implementation of a traversable for any applicative argument.  Let's consider the functor for list traversables: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ListTraversable</span>  (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) :
                        <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list
                            <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t =
<span class="keyword">struct</span>

  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list

  <span class="keyword">module</span> <span class="constructor">Applicative</span> = <span class="constructor">A</span>

  <span class="keyword">let</span> <span class="keyword">rec</span> traverse f xs =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">AU</span> = <span class="constructor">ApplicativeUtils</span>(<span class="constructor">A</span>) <span class="keyword">in</span>
    <span class="keyword">let</span> <span class="keyword">open</span> <span class="constructor">AU</span> <span class="keyword">in</span>
    <span class="keyword">match</span> xs <span class="keyword">with</span>
    <span class="keywordsign">|</span> []      <span class="keywordsign">-&gt;</span> <span class="constructor">A</span>.pure []
    <span class="keywordsign">|</span> x :: xs <span class="keywordsign">-&gt;</span> (<span class="keyword">fun</span> y ys <span class="keywordsign">-&gt;</span> y :: ys) &lt;$&gt; f x &lt;*&gt; traverse f xs

<span class="keyword">end</span>;;
</code></pre><p>Here one has to accept some extra verbosity compared to the Haskell version, although the code itself is fairly straightforward.  The functor argument <code class="code">A</code> of type <code class="code">APPLICATIVE</code> serves to fulfil the requirement of having to export the <code class="code">APPLICATIVE</code> module.  The implementation of <code class="code">traverse</code> is the interesting bit. Note that it is indeed defined generically for any applicative functor. The <code class="code">ApplicativeUtils</code> module constructor comes in handy for accessing the infix versions of the operators. </p><p>To give <code class="code">ListTraversable</code> a try, consider how it can be used for option effects: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">LTO</span> = <span class="constructor">ListTraversable</span> (<span class="constructor">OptionApplicative</span>);;
</code></pre><p>This results in a module with the following signature: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">LTO</span> :
  <span class="keyword">sig</span>
    <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list
    <span class="keyword">val</span> map : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
    <span class="keyword">module</span> <span class="constructor">Applicative</span> : <span class="keyword">sig</span>  <span class="keyword">end</span>
    <span class="keyword">val</span> traverse : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b <span class="constructor">Applicative</span>.t) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="constructor">Applicative</span>.t
  <span class="keyword">end</span>;;
</code></pre><br/>
where we also know that the <code class="code">Applicative</code> sub-module is in fact our <code class="code">OptionApplicative</code>. <p><code class="code">traverse</code> in this context is a function that allows us to map each element of a list to an optional value where the computation produces a list with all values collected, only in case every element was successfully mapped to a <code class="code">Some</code> value. </p><p>For example using the safe square root function from above we can transform it into a version operating on lists: </p><pre><code class="code"><span class="keyword">let</span> all_roots = <span class="constructor">LTO</span>.traverse ssqrt;;
</code></pre><p>It only returns a list of values with the results in case each element produced a valid square root. A few examples: </p><pre><code class="code"><span class="keywordsign">#</span> all_roots [4.;9.;16.];;
- : float <span class="constructor">LTO</span>.t <span class="constructor">LTO</span>.<span class="constructor">Applicative</span>.t = <span class="constructor">Some</span> [2.; 3.; 4.]

<span class="keywordsign">#</span> all_roots [4.;-9.; 16.];;
- : float <span class="constructor">LTO</span>.t <span class="constructor">LTO</span>.<span class="constructor">Applicative</span>.t = <span class="constructor">None</span>
</code></pre><p>Next, let's consider a custom type (<code class="code">'a tree</code>) for which we are also able to implement the traversable interface: </p><pre><code class="code"><span class="keyword">type</span> <span class="keywordsign">'</span>a tree =
  <span class="keywordsign">|</span> <span class="constructor">Leaf</span>
  <span class="keywordsign">|</span> <span class="constructor">Node</span> <span class="keyword">of</span> <span class="keywordsign">'</span>a tree * <span class="keywordsign">'</span>a * <span class="keywordsign">'</span>a tree
;;

<span class="keyword">let</span> node l x r = <span class="constructor">Node</span> (l,x,r);;
</code></pre><p>Following is an instance of traversable for <code class="code">tree</code>s: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TreeTraversable</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) :
                        <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a tree
                                  <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t =
<span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="constructor">Applicative</span> = <span class="constructor">A</span>

  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a tree
  <span class="keyword">type</span> <span class="keywordsign">'</span>a a = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t

  <span class="keyword">let</span> <span class="keyword">rec</span> traverse f t =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">AU</span> = <span class="constructor">ApplicativeUtils</span>(<span class="constructor">A</span>) <span class="keyword">in</span> <span class="keyword">let</span> <span class="keyword">open</span> <span class="constructor">AU</span> <span class="keyword">in</span>
    <span class="keyword">match</span> t <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">Leaf</span>          <span class="keywordsign">-&gt;</span> pure <span class="constructor">Leaf</span>
    <span class="keywordsign">|</span> <span class="constructor">Node</span> (l,x,r)  <span class="keywordsign">-&gt;</span> node &lt;$&gt; traverse f l &lt;*&gt; f x &lt;*&gt; traverse f r

<span class="keyword">end</span>;;
</code></pre><p>From the Haskell specification we know that any traversable must be a functor.  Comparing the signatures for <code class="code">map</code> and <code class="code">traverse</code> also reveals their similarities: </p><pre><code class="code"><span class="keyword">val</span> map       : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> b)       <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
<span class="keyword">val</span> traverse  : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>t <span class="constructor">A</span>.t)  <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> (<span class="keywordsign">'</span>b t) <span class="constructor">A</span>.t
</code></pre><br/>
However, embedding <code class="code">map</code> in the module signature for <code class="code">TRAVERSABLE</code> forces the user to define it manually. Would it be possible to achieve a generic implementation expressed in terms of the traverse function? <p>It can be done by choosing a suitable <code>Applicative</code> where the effect does not impact the result. The simplest possible type forming an applicative functor is the identity type: </p><pre><code class="code"><span class="keyword">type</span> <span class="keywordsign">'</span>a id = <span class="keywordsign">'</span>a;;
</code></pre><br/>
for which a trivial <code>APPLICATIVE</code> instance exist: <pre><code class="code"><span class="keyword">module</span> <span class="constructor">IdApplicative</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a id = <span class="keyword">struct</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t     = <span class="keywordsign">'</span>a id
  <span class="keyword">let</span> pure x    = x
  <span class="keyword">let</span> map f     = f
  <span class="keyword">let</span> apply f   = map f
<span class="keyword">end</span>;;
</code></pre><p>Using <code class="code">IdApplicative</code> for the effect, <code class="code">traverse</code> collapses into <code class="code">map</code>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TreeTraversableId</span> = <span class="constructor">TreeTraversable</span> (<span class="constructor">IdApplicative</span>);;
<span class="keyword">let</span> map f = <span class="constructor">TreeTraversableId</span>.traverse f;;
</code></pre><p>Similar to the pattern of utility modules for extending the interface with additional functions we may implement another module-functor <code class="code">TraversableFunctor</code> that produces a functor instance given a module-functor for building traversables: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TraversableFunctor</span> (<span class="constructor">MT</span> : <span class="keyword">functor</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) <span class="keywordsign">-&gt;</span>
             <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t) =
<span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="constructor">TI</span> = <span class="constructor">MT</span>(<span class="constructor">IdApplicative</span>)
  <span class="keyword">let</span> map f = <span class="constructor">TI</span>.traverse f
<span class="keyword">end</span>;;
</code></pre><p>Following is an example creating a functor for trees derived from its traversable implementation: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TTU</span> = <span class="constructor">TraversableFunctor</span> (<span class="constructor">TreeTraversable</span>);;
</code></pre><br/>
Its map function can be used as in: <pre><code class="code"><span class="constructor">TTU</span>.map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> x * x) (node <span class="constructor">Leaf</span> 3 (node <span class="constructor">Leaf</span> 5 <span class="constructor">Leaf</span>));;
</code></pre><p>We could also define another utility module for deriving the <code>sequence</code> operator, in order to recover some of the functionality from Haskell, where <code>sequence</code> can be defined by instantiating <code>Traversable</code> and only implementing <code>traverse</code>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TraversableSequence</span>  (<span class="constructor">T</span> : <span class="constructor">TRAVERSABLE</span> ) = <span class="keyword">struct</span>
  <span class="keyword">let</span> sequence xs = <span class="constructor">T</span>.traverse id xs
<span class="keyword">end</span>;;
</code></pre><p>The Haskell documentation for <code>Applicative</code> also dictates a set of laws: </p><pre>-- Naturality
t . traverse f = traverse (t . f)

-- Identity
traverse Identity = Identity

-- Composition
traverse (Compose . fmap g . f) = Compose . fmap (traverse g) . traverse f
</pre><p>The <em>naturality law</em> assumes that <code>t</code> is a <em>natural transformation</em> from one applicative functor to another. Porting it to OCaml requires a couple of further tricks. First we dedicate a specific module functor for the task which takes two arguments for the applicatives mapped between, along with a traversable constructor. In order to also connect the types, an additional module <code class="code">TYPE2</code> representing types of kind <code>(* -&gt; *)</code> is introduced: </p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">TYPE2</span> = <span class="keyword">sig</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t <span class="keyword">end</span>;;

<span class="keyword">module</span> <span class="constructor">TestTraversableNat</span> (<span class="constructor">T2</span> : <span class="constructor">TYPE2</span>)
                          (<span class="constructor">A1</span> : <span class="constructor">APPLICATIVE</span>)
                          (<span class="constructor">A2</span> : <span class="constructor">APPLICATIVE</span>)
                          (<span class="constructor">MT</span> : <span class="keyword">functor</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) <span class="keywordsign">-&gt;</span>
                            <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
                                  <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t
                                            <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t ) =
<span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="constructor">T1</span> : <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
     <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A1</span>.t <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t = <span class="constructor">MT</span> (<span class="constructor">A1</span>)

  <span class="keyword">module</span> <span class="constructor">T2</span> : <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
     <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A2</span>.t <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t = <span class="constructor">MT</span> (<span class="constructor">A2</span>)

  <span class="keyword">type</span> nat = { t : <span class="keywordsign">'</span>a. <span class="keywordsign">'</span>a <span class="constructor">A1</span>.t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a <span class="constructor">A2</span>.t }

  <span class="keyword">let</span> test f {t} x = t (<span class="constructor">T1</span>.traverse f x) = <span class="constructor">T2</span>.traverse ( f &gt;&gt; t) x
<span class="keyword">end</span>;;
</code></pre><p>Here, <code class="code">nat</code> represents the mapping from <code class="code">A1</code> to <code class="code">A2</code> and the type is introduced in order to be able to express that the transformation is existentially quantified over all type parameters to <code class="code">A1.t</code>. </p><p>Here's an example of a concrete realization of a test module: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TTN</span> =
    <span class="constructor">TestTraversableNat</span> (<span class="keyword">struct</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list <span class="keyword">end</span>)
                       (<span class="constructor">IdApplicative</span>)
                       (<span class="constructor">OptionApplicative</span>)
                       (<span class="constructor">ListTraversable</span>)
<span class="keyword">end</span>;;
</code></pre><p>The second law, <em>identity</em>, is expressed in terms of the type <code>Identity</code> and its functor and applicative instances in Haskell. <code>Identity</code> in haskell is defined as: </p><pre>newtype Identity a = Identity a

instance Functor Identity where
  fmap f (Identity x)  = Identity (f x)

instance Applicative Identity where
  pure = Identity
  (Identity f) &lt;*&gt; (Identity x) = Identity (f x)
</pre><p>We've already seen its corresponding OCaml type <code class="code">'a id</code> and the applicative instance, <code>IdApplicative</code>. Using that we may create another test module for the <em>identity</em> law: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TestTraversableId</span> ( <span class="constructor">MT</span> : <span class="keyword">functor</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) <span class="keywordsign">-&gt;</span>
                      <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t) =
<span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="constructor">TI</span> = <span class="constructor">MT</span> (<span class="constructor">IdApplicative</span>)
  <span class="keyword">let</span> test x = <span class="constructor">TI</span>.traverse id x = x
<span class="keyword">end</span>;;
</code></pre><p>The following example shows how it can be used to test the <code class="code">ListTraversable</code> module-functor: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TTIL</span> = <span class="constructor">TestTraversableId</span> (<span class="constructor">ListTraversable</span>);;
<span class="constructor">TTIL</span>.test [1;2;3];;
</code></pre><p>The final law, <i>composibility</i>, relies on the type <code>Compose</code> which takes two higher-kinded type arguments and composes them: </p><pre>newtype Compose f g a = Compose (f (g a))
</pre><p>Its functor and applicative functor instances are achieved by: </p><pre>instance (Functor f, Functor g) =&gt; Functor (Compose f g) where
  fmap f (Compose x) = Compose (fmap (fmap f) x)

instance (Applicative f, Applicative g) =&gt; Applicative (Compose f g) where
  pure x = Compose (pure (pure x))
  Compose f &lt;*&gt; Compose x = Compose ((&lt;*&gt;) &lt;$&gt; f &lt;*&gt; x)
</pre><p>Once again to circumvent the higher-kinded type restriction we need to resort to modules in OCaml. The following module-functor takes two applicatives as arguments and produces an <code class="code">APPLICATIVE</code> module for the composed type: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ComposeApplicative</span> (<span class="constructor">F</span> : <span class="constructor">APPLICATIVE</span>)
                          (<span class="constructor">G</span> : <span class="constructor">APPLICATIVE</span>)
                          : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = (<span class="keywordsign">'</span>a <span class="constructor">G</span>.t) <span class="constructor">F</span>.t =
<span class="keyword">struct</span>

  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = (<span class="keywordsign">'</span>a <span class="constructor">G</span>.t) <span class="constructor">F</span>.t

  <span class="keyword">let</span> pure x = <span class="constructor">F</span>.pure (<span class="constructor">G</span>.pure x)

  <span class="keyword">let</span> map f = <span class="constructor">F</span>.map (<span class="constructor">G</span>.map f)

  <span class="keyword">let</span> apply f x =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">FU</span> = <span class="constructor">ApplicativeUtils</span>(<span class="constructor">F</span>) <span class="keyword">in</span> <span class="keyword">let</span> <span class="keyword">open</span> <span class="constructor">FU</span> <span class="keyword">in</span>
    (<span class="constructor">G</span>.apply) &lt;$&gt; f &lt;*&gt; x

<span class="keyword">end</span>;;
</code></pre><p>Finally tackling the law expressed using the <code>Compose</code> type: </p><pre>traverse (Compose . fmap g . f) = Compose . fmap (traverse g) . traverse f
</pre><br/>
requires some even heavier plumbing. To demonstrate that it's possible, here's an implementation: <pre><code class="code"><span class="keyword">module</span> <span class="constructor">TestTraversableCompose</span> (<span class="constructor">T2</span> : <span class="constructor">TYPE2</span>)
                              (<span class="constructor">F</span>  : <span class="constructor">APPLICATIVE</span>)
                              (<span class="constructor">G</span>  : <span class="constructor">APPLICATIVE</span>)
                              (<span class="constructor">MT</span> : <span class="keyword">functor</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) <span class="keywordsign">-&gt;</span>
                              <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t
                                                    <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t) =
<span class="keyword">struct</span>

  <span class="keyword">module</span> <span class="constructor">AC</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span>
        <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">G</span>.t <span class="constructor">F</span>.t = <span class="constructor">ComposeApplicative</span>(<span class="constructor">F</span>) (<span class="constructor">G</span>)

  <span class="keyword">module</span> <span class="constructor">TF</span> : <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
        <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">F</span>.t
          <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t = <span class="constructor">MT</span> (<span class="constructor">F</span>)

  <span class="keyword">module</span> <span class="constructor">TG</span> : <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
        <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">G</span>.t
          <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t = <span class="constructor">MT</span> (<span class="constructor">G</span>)

  <span class="keyword">module</span> <span class="constructor">TC</span> : <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span>
        <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">G</span>.t <span class="constructor">F</span>.t
          <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a <span class="constructor">T2</span>.t = <span class="constructor">MT</span> (<span class="constructor">AC</span>)

  <span class="keyword">let</span> test f g x =
    <span class="constructor">F</span>.map (<span class="constructor">TG</span>.traverse g) (<span class="constructor">TF</span>.traverse f x) = <span class="constructor">TC</span>.traverse (f &gt;&gt; <span class="constructor">F</span>.map g) x

<span class="keyword">end</span>;;
</code></pre><p>It can be used for testing various combinations of traversables and applicatives. For example: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">TTCL</span> = <span class="constructor">TestTraversableCompose</span>  (<span class="keyword">struct</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a list <span class="keyword">end</span>)
                                      (<span class="constructor">ListApplicative</span>)
                                      (<span class="constructor">OptionApplicative</span>)
                                      (<span class="constructor">ListTraversable</span>);;
<span class="constructor">TTCL</span>.test (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> [x; x + 1])
          (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> <span class="keyword">if</span> x &gt; 10 <span class="keyword">then</span> <span class="constructor">Some</span> (-x) <span class="keyword">else</span> <span class="constructor">None</span>)
          [1;2;3;5];;
</code></pre><h2>Using the patterns</h2><p>Now that we've laid the ground and introduced formalized interfaces for some common patterns, the next sections provide a couple of more examples of how these idioms can be used in practice when designing libraries and programs. </p><h3>A minimal parsing library</h3><p>In the following example we implement a simple parsing library and see how monoids and applicative functors guide the design of the API. </p><p>First consider a suitable definition of a parser type: </p><pre><code class="code"><span class="keyword">type</span> <span class="keywordsign">'</span>a p = char list <span class="keywordsign">-&gt;</span> (<span class="keywordsign">'</span>a * char list) option;;
</code></pre><p>A parser <code class="code">'a p</code> is a function from a list of characters (input) to an option of a tuple of a value of type <code class="code">'a</code>, produced by the parser along with the remaining tokens of the input. The type is similar in spirit to parsing combinator libraries such as Haskell's <a href="https://hackage.haskell.org/package/parsec">Parsec</a>. </p><p>To be able to define parsers that parses a single character, here's a function that takes a mapping function from a character to an optional value and returns a parser that, when successful, produces a value and consumes one element of the input: </p><pre><code class="code"><span class="keyword">let</span> token f = <span class="keyword">function</span>
  <span class="keywordsign">|</span> []      <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
  <span class="keywordsign">|</span> x :: xs <span class="keywordsign">-&gt;</span> <span class="constructor">OptionFunctor</span>.map (<span class="keyword">fun</span> y <span class="keywordsign">-&gt;</span> (y, xs)) @@ f x
;;
</code></pre><p>It can be used to implement a specialized version <code class="code">char</code> for matching characters: </p><pre><code class="code"><span class="keyword">let</span> char c = token (<span class="keyword">fun</span> c' <span class="keywordsign">-&gt;</span> <span class="keyword">if</span> c = c' <span class="keyword">then</span> <span class="constructor">Some</span> c <span class="keyword">else</span> <span class="constructor">None</span>);;
</code></pre><p>Another useful parser is the one matching an empty list of input: </p><pre><code class="code"><span class="keyword">let</span> empty = <span class="keyword">function</span>
  <span class="keywordsign">|</span> []  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> ((), [])
  <span class="keywordsign">|</span> _   <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
;;
</code></pre><p>In order to compose parsers, either by sequencing them - one parser followed by another, or choosing between multiple parsers, we need to come up with a set of suitable combinators. </p><p>Rather than trying to derive such functions directly one can start by looking at existing patterns and identify the ones applicable to parsers. </p><p>Doing that requires little thinking besides coming up with feasible implementations and ensuring that the implementation is compliant with the corresponding set of constraints (laws). </p><p>For instance, with the parser definition above, we are able to to define an applicative functor interface: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ParserApplicative</span> : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a p = <span class="keyword">struct</span>

  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a p

  <span class="keyword">let</span> map f p = p &gt;&gt; <span class="constructor">OptionFunctor</span>.map (<span class="keyword">fun</span> (x, cs) <span class="keywordsign">-&gt;</span> (f x, cs))

  <span class="keyword">let</span> pure x cs = <span class="constructor">Some</span> (x, cs)

  <span class="keyword">let</span> apply f x cs =
    <span class="keyword">match</span> f cs <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">Some</span> (f, cs)  <span class="keywordsign">-&gt;</span> map f x cs
    <span class="keywordsign">|</span> <span class="constructor">None</span>          <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>

<span class="keyword">end</span>;;
</code></pre><p>To convince ourselves that the implementation is sound we can use <a href="https://wiki.haskell.org/Equational_reasoning_examples"> equational reasoning</a> to prove the laws explicitly. Relying on the <code class="code">TestApplicative</code> module in this case is problematic since it requires comparing for equality and our parser type is a function.  A better implementation of the test modules would also allow parameterization of a comparator module. </p><p>The <code class="code">ParserApplicative</code> module grants us access to the functions <code class="code">( &lt;*&gt; )</code> and <code class="code">( &lt;$&gt; )</code> for composing parsers of different types: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">APU</span> = <span class="constructor">ApplicativeUtils</span> (<span class="constructor">ParserApplicative</span>);;
</code></pre><p>To give an example, here is a parser that parses the input <code class="code">['a';'b';'c']</code> and produces a unit result: </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">APU</span>;;
<span class="keyword">let</span> abc = (<span class="keyword">fun</span> _ _ _ <span class="keywordsign">-&gt;</span> ()) &lt;$&gt; char <span class="string">'a'</span> &lt;*&gt; char <span class="string">'b'</span> &lt;*&gt; char <span class="string">'c'</span>;;
</code></pre><p>In order to represent grammars that allow alternative parsing constructs, we need a way to choose between a set of potential parsers. That is, collapsing a set of parsers into a single parser. Phrased differently, we are looking for a monoid: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ParserMonoid</span> (<span class="constructor">T</span> : <span class="constructor">TYPE</span>) : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = <span class="constructor">T</span>.t p = <span class="keyword">struct</span>

  <span class="keyword">type</span> t = <span class="constructor">T</span>.t p

  <span class="keyword">let</span> empty _ = <span class="constructor">None</span>

  <span class="keyword">let</span> append p q  cs =
    <span class="keyword">match</span> p cs <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">Some</span> x  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> x
    <span class="keywordsign">|</span> <span class="constructor">None</span>    <span class="keywordsign">-&gt;</span> q cs

<span class="keyword">end</span>;;
</code></pre><br/>
Here, <code class="code">empty</code> is the parser that always fails and <code class="code">append</code> takes two parsers and returns a parser that for any input first attempts to run the first parser and in case it fails resorts to the second one. <p>We can now use the <code class="code">ParserMonoid</code> to define a few utility functions: </p><pre><code class="code"><span class="keyword">let</span> fail (<span class="keyword">type</span> a) =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">M</span> = <span class="constructor">ParserMonoid</span>(<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>) <span class="keyword">in</span>
  <span class="constructor">M</span>.empty
;;

<span class="keyword">let</span> choose (<span class="keyword">type</span> a) ps =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">MU</span> = <span class="constructor">MonoidUtils</span> (<span class="constructor">ParserMonoid</span>(<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
  <span class="constructor">MU</span>.concat ps
;;

<span class="keyword">let</span> ( &lt;|&gt; ) p q = choose [p; q];;
</code></pre><p>The functor, applicative functor and a monoid combinators for the parser type, form the baseline of the API.  They are also sufficient for implementing a function for turning any parser into one that applies the parser recursively and collects the results in a list: </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">APU</span>;;

<span class="keyword">let</span> delay f cs = f () cs;;

<span class="keyword">let</span> <span class="keyword">rec</span> many p =
  <span class="constructor">List</span>.cons &lt;$&gt; p &lt;*&gt; (delay @@ <span class="keyword">fun</span> _ <span class="keywordsign">-&gt;</span> many p)
  &lt;|&gt;
  pure []
;;
</code></pre><p>The purpose of the function <code class="code">delay</code> is to avoid infinite recursion by allowing to construct parsers lazily (ones that are only realized on demand). </p><p>The definition of <code class="code">many</code> states that it is a parser that either parses one result of the given parser <code class="code">p</code> followed by many results; Or in case it fails, consumes no input and returns an empty list (<code class="code">pure []</code>). </p><p>Another handy combinator is <code class="code">filter</code> that takes a predicate function for <i>filtering</i> a parser by only allowing it to succeed when its result satisfies the predicate: </p><pre><code class="code"><span class="keyword">let</span> filter f p cs =
  <span class="keyword">match</span> p cs <span class="keyword">with</span>
  <span class="keywordsign">|</span> <span class="constructor">Some</span> (x, cs) <span class="keyword">when</span> f x <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (x,cs)
  <span class="keywordsign">|</span> _                     <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
;;
</code></pre><p>We can use it to define a variation of <code class="code">many</code> for parsing one or more elements: </p><pre><code class="code"><span class="keyword">let</span> many_one p = filter ((&lt;&gt;) []) @@ many p;;
</code></pre><p>When it comes to actually exposing the API for a parser combinator library we may still choose to shield users from any references to modules such as <code class="code">ParserApplicative</code> or <code class="code">ParserMonoid</code> and also include a sub-set of the derived utility functions. </p><p>Here is an example of such a module signature: </p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">PARSER</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t

  <span class="keyword">val</span> empty : unit t
  <span class="keyword">val</span> run : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> string <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a option
  <span class="keyword">val</span> map : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
  <span class="keyword">val</span> pure : <span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> apply : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
  <span class="keyword">val</span> ( &lt;$&gt; ) : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
  <span class="keyword">val</span> ( &lt;*&gt; ) : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b) t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
  <span class="keyword">val</span> ( &lt;*  ) : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> ( *&gt;  ) : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b t
  <span class="keyword">val</span> token : (char <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a option) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> char : char <span class="keywordsign">-&gt;</span> char t
  <span class="keyword">val</span> fail : <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> choose : <span class="keywordsign">'</span>a t list <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> ( &lt;|&gt; ) : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t
  <span class="keyword">val</span> many : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a list t
  <span class="keyword">val</span> many_one : <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a list t
  <span class="keyword">val</span> filter : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> bool) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a t

<span class="keyword">end</span>;;
</code></pre><p>Note that it also makes the parser type itself abstract and instead exposes a run function that takes a string as input rather than a list of characters.  To turn a string into a list of characters, access to a function such as: </p><pre><code class="code"><span class="keyword">let</span> list_of_string s =
  <span class="keyword">let</span> <span class="keyword">rec</span> aux i l = <span class="keyword">if</span> i &lt; 0 <span class="keyword">then</span> l <span class="keyword">else</span> aux (i - 1) (s.[i] :: l) <span class="keyword">in</span>
  aux (<span class="constructor">String</span>.length s - 1) []
;;
</code></pre><br/>
is assumed. <p>The following implementation realizes the signature using the <code class="code">ParserMonoid</code> and applicative utils (<code class="code">APU</code>) as defined above: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">Parser</span> : <span class="constructor">PARSER</span> = <span class="keyword">struct</span>
  <span class="keyword">include</span> <span class="constructor">APU</span>

  <span class="keyword">let</span> run p s = <span class="constructor">OptionFunctor</span>.map fst @@ p @@ list_of_string s

  <span class="keyword">let</span> empty = <span class="keyword">function</span>
    <span class="keywordsign">|</span> []  <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> ((), [])
    <span class="keywordsign">|</span> _   <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>

  <span class="keyword">let</span> token f = <span class="keyword">function</span>
    <span class="keywordsign">|</span> []      <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
    <span class="keywordsign">|</span> x :: xs <span class="keywordsign">-&gt;</span> <span class="constructor">OptionFunctor</span>.map (<span class="keyword">fun</span> y <span class="keywordsign">-&gt;</span> (y, xs)) @@ f x

  <span class="keyword">let</span> char c = token (<span class="keyword">fun</span> c' <span class="keywordsign">-&gt;</span> <span class="keyword">if</span> c = c' <span class="keyword">then</span> <span class="constructor">Some</span> c <span class="keyword">else</span> <span class="constructor">None</span>)

  <span class="keyword">let</span> fail (<span class="keyword">type</span> a) =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">M</span> = <span class="constructor">ParserMonoid</span>(<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>) <span class="keyword">in</span>
    <span class="constructor">M</span>.empty

  <span class="keyword">let</span> choose (<span class="keyword">type</span> a) ps =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">MU</span> = <span class="constructor">MonoidUtils</span>(<span class="constructor">ParserMonoid</span>(<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
    <span class="constructor">MU</span>.concat ps

  <span class="keyword">let</span> ( &lt;|&gt; ) p q = choose [p; q]

  <span class="keyword">let</span> delay f cs = f () cs

  <span class="keyword">let</span> <span class="keyword">rec</span> many p =
    <span class="constructor">List</span>.cons &lt;$&gt; p &lt;*&gt; (delay @@ <span class="keyword">fun</span> _ <span class="keywordsign">-&gt;</span> many p)
    &lt;|&gt;
    pure []

  <span class="keyword">let</span> filter f p cs =
    <span class="keyword">match</span> p cs <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">Some</span> (x, cs) <span class="keyword">when</span> f x <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> (x,cs)
    <span class="keywordsign">|</span> _                     <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>

  <span class="keyword">let</span> many_one p = filter ((&lt;&gt;) []) @@ many p

<span class="keyword">end</span>;;
</code></pre><p>Finally for an example of how to use the library, consider a parser for parsing dates of the format <code>YYYY-MM-DD</code>: </p><pre><code class="code"><span class="keyword">open</span> <span class="constructor">Parser</span>;;

<span class="comment">(* Parser for a single digit *)</span>
<span class="keyword">let</span> digit = <span class="string">&quot;0123456789&quot;</span> |&gt; list_of_string |&gt; <span class="constructor">List</span>.map char |&gt; choose;;

<span class="comment">(* Integer parser *)</span>
<span class="keyword">let</span> int =
  <span class="keyword">let</span> string_of_list = <span class="constructor">List</span>.map (<span class="constructor">String</span>.make 1) &gt;&gt; <span class="constructor">String</span>.concat <span class="string">&quot;&quot;</span> <span class="keyword">in</span>
  (string_of_list &gt;&gt; int_of_string) &lt;$&gt; many_one digit;;

<span class="comment">(* Integers in a given range *)</span>
<span class="keyword">let</span> int_range mn mx = filter (<span class="keyword">fun</span> n <span class="keywordsign">-&gt;</span> mn &lt;= n <span class="keywordsign">&amp;&amp;</span> n &lt;= mx) int;;

<span class="comment">(* Parser for digit prefixed by '0'. Ex &quot;07&quot; *)</span>
<span class="keyword">let</span> zero_digit = char <span class="string">'0'</span> *&gt; int_range 1 9;;

<span class="comment">(* Years between 1700 and 2400 *)</span>
<span class="keyword">let</span> year  = int_range 1700 2400;;

<span class="comment">(* Month as in '01, 02, .. , 11' *)</span>
<span class="keyword">let</span> month = zero_digit &lt;|&gt; int_range 11 12;;

<span class="comment">(* Day as in '01, 02, .. 31 *)</span>
<span class="keyword">let</span> day = zero_digit &lt;|&gt; int_range 11 31;;

<span class="comment">(* Parser for date of format &quot;YYYY-MM-DD&quot; *)</span>
<span class="keyword">let</span> date =
  (<span class="keyword">fun</span> y m d <span class="keywordsign">-&gt;</span> (y,m,d))
  &lt;$&gt; (year &lt;* char <span class="string">'-'</span>)
  &lt;*&gt; (month &lt;* char <span class="string">'-'</span>)
  &lt;*&gt; day
;;
</code></pre><p>Here are a few examples of running the <code class="code">date</code> parser with different string inputs: </p><pre><code class="code"><span class="keywordsign">#</span> run date <span class="string">&quot;2019-01-23&quot;</span>;;
- : (int * int * int) option = <span class="constructor">Some</span> (2019, 1, 23)

<span class="keywordsign">#</span> run date <span class="string">&quot;2019-1-23&quot;</span>;;
- : (int * int * int) option = <span class="constructor">None</span>

<span class="keywordsign">#</span> run date <span class="string">&quot;999-1-23&quot;</span>;;
- : (int * int * int) option = <span class="constructor">None</span>
</code></pre><h3>Analyzing boolean expressions</h3><p>In the next example we consider designing a library for representing and operating on boolean expressions. It naturally generalizes to other forms of deeply embedded domain specific languages (EDSLs). </p><p>Consider the following data type for representing a boolean expression with variables, parameterized over the variable type. </p><pre><code class="code"><span class="keyword">type</span> <span class="keywordsign">'</span>a exp =
  <span class="keywordsign">|</span> <span class="constructor">True</span>
  <span class="keywordsign">|</span> <span class="constructor">False</span>
  <span class="keywordsign">|</span> <span class="constructor">And</span> <span class="keyword">of</span> <span class="keywordsign">'</span>a exp * <span class="keywordsign">'</span>a exp
  <span class="keywordsign">|</span> <span class="constructor">Or</span> <span class="keyword">of</span> <span class="keywordsign">'</span>a exp * <span class="keywordsign">'</span>a exp
  <span class="keywordsign">|</span> <span class="constructor">Not</span> <span class="keyword">of</span> <span class="keywordsign">'</span>a exp
  <span class="keywordsign">|</span> <span class="constructor">Var</span> <span class="keyword">of</span> <span class="keywordsign">'</span>a
;;
</code></pre><p>For convenience we define some helper functions corresponding to the expression constructors: </p><pre><code class="code"><span class="keyword">let</span> etrue           = <span class="constructor">True</span>;;
<span class="keyword">let</span> efalse          = <span class="constructor">False</span>;;
<span class="keyword">let</span> ( &lt;&amp;&gt; ) e1 e2   = <span class="constructor">And</span> (e1, e2);;
<span class="keyword">let</span> ( &lt;|&gt; ) e1 e2   = <span class="constructor">Or</span> (e1, e2);;
<span class="keyword">let</span> enot e          = <span class="constructor">Not</span> e;;
<span class="keyword">let</span> var x           = <span class="constructor">Var</span> x;;
</code></pre><p>What patterns are applicable to the <code class="code">'a exp</code> type? There are two monoid instances corresponding to the boolean operators <code class="code">and</code> and <code class="code">or</code>.  Expressions form a monoid with identity <code class="code">false</code> and the append function <code class="code">or</code>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">MonoidOrFalse</span> (<span class="constructor">T</span> : <span class="constructor">TYPE</span>) : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = <span class="constructor">T</span>.t exp = <span class="keyword">struct</span>
  <span class="keyword">type</span> t = <span class="constructor">T</span>.t exp
  <span class="keyword">let</span> empty = efalse <span class="keyword">and</span> append = ( &lt;|&gt; )
<span class="keyword">end</span>;;
</code></pre><p>The other monoid is for <code class="code">true</code> and <code class="code">and</code>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">MonoidAndTrue</span> (<span class="constructor">T</span> : <span class="constructor">TYPE</span>) : <span class="constructor">MONOID</span> <span class="keyword">with</span> <span class="keyword">type</span> t = <span class="constructor">T</span>.t exp = <span class="keyword">struct</span>
  <span class="keyword">type</span> t = <span class="constructor">T</span>.t exp
  <span class="keyword">let</span> empty = etrue <span class="keyword">and</span> append = ( &lt;&amp;&gt; )
<span class="keyword">end</span>;;
</code></pre><p>As demonstrated previously, monoids can be promoted to operate on lists. In this case for composing a list of expression values: </p><pre><code class="code"><span class="keyword">let</span> any (<span class="keyword">type</span> a) es =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">M</span> = <span class="constructor">MonoidUtils</span> (<span class="constructor">MonoidOrFalse</span> (<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
  <span class="constructor">M</span>.concat es;;

<span class="keyword">let</span> all (<span class="keyword">type</span> a) es =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">M</span> = <span class="constructor">MonoidUtils</span> (<span class="constructor">MonoidAndTrue</span> (<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
  <span class="constructor">M</span>.concat es;;
</code></pre><p>Continuing through the list of patterns - the expression type naturally forms a traversable: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">ExpTraversable</span> (<span class="constructor">A</span> : <span class="constructor">APPLICATIVE</span>) :
             <span class="constructor">TRAVERSABLE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a exp
                 <span class="keyword">and</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a <span class="constructor">Applicative</span>.t = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t =
<span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="constructor">Applicative</span> = <span class="constructor">A</span>

  <span class="keyword">type</span> <span class="keywordsign">'</span>a a = <span class="keywordsign">'</span>a <span class="constructor">A</span>.t
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="keywordsign">'</span>a exp

  <span class="keyword">let</span> <span class="keyword">rec</span> traverse f exp =
    <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">AU</span> = <span class="constructor">ApplicativeUtils</span>(<span class="constructor">A</span>) <span class="keyword">in</span>
    <span class="keyword">let</span> <span class="keyword">open</span> <span class="constructor">AU</span> <span class="keyword">in</span>
    <span class="keyword">match</span> exp <span class="keyword">with</span>
    <span class="keywordsign">|</span> <span class="constructor">True</span>          <span class="keywordsign">-&gt;</span> <span class="constructor">A</span>.pure etrue
    <span class="keywordsign">|</span> <span class="constructor">False</span>         <span class="keywordsign">-&gt;</span> <span class="constructor">A</span>.pure efalse
    <span class="keywordsign">|</span> <span class="constructor">And</span> (e1, e2)  <span class="keywordsign">-&gt;</span> (&lt;&amp;&gt;) &lt;$&gt; traverse f e1 &lt;*&gt; traverse f e2
    <span class="keywordsign">|</span> <span class="constructor">Or</span> (e1, e2)   <span class="keywordsign">-&gt;</span> (&lt;|&gt;) &lt;$&gt; traverse f e1 &lt;*&gt; traverse f e2
    <span class="keywordsign">|</span> <span class="constructor">Not</span> e         <span class="keywordsign">-&gt;</span> enot  &lt;$&gt; traverse f e
    <span class="keywordsign">|</span> <span class="constructor">Var</span> v         <span class="keywordsign">-&gt;</span> var   &lt;$&gt; f v

<span class="keyword">end</span>;;
</code></pre><p>Using this module we also obtain the functor instance for free and are able to implement a map function for expressions via: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">EF</span> = <span class="constructor">TraversableFunctor</span> (<span class="constructor">ExpTraversable</span>);;
<span class="keyword">let</span> map f = <span class="constructor">EF</span>.map f;;
</code></pre><p>For example we may use <code class="code">map</code> to create a function that adds a prefix to each variable for values of type <code class="code">string exp</code>: </p><pre><code class="code"><span class="keyword">let</span> add_var_prefix p = map (<span class="constructor">Printf</span>.sprintf <span class="string">&quot;%s%s&quot;</span> p);;
</code></pre>The traversable instance may also be utilized when it comes to evaluating expressions. First consider the following function for evaluating expressions parameterized by a boolean value, that is expressions where each variable is realized as concrete boolean value: <pre><code class="code"><span class="keyword">let</span> <span class="keyword">rec</span> eval_bool_exp = <span class="keyword">function</span>
  <span class="keywordsign">|</span> <span class="constructor">True</span>          <span class="keywordsign">-&gt;</span> <span class="keyword">true</span>
  <span class="keywordsign">|</span> <span class="constructor">False</span>         <span class="keywordsign">-&gt;</span> <span class="keyword">false</span>
  <span class="keywordsign">|</span> <span class="constructor">And</span> (e1, e2)  <span class="keywordsign">-&gt;</span> eval_bool_exp e1 <span class="keywordsign">&amp;&amp;</span> eval_bool_exp e2
  <span class="keywordsign">|</span> <span class="constructor">Or</span> (e1, e2)   <span class="keywordsign">-&gt;</span> eval_bool_exp e1 <span class="keywordsign">||</span> eval_bool_exp e2
  <span class="keywordsign">|</span> <span class="constructor">Not</span> e         <span class="keywordsign">-&gt;</span> not (eval_bool_exp e)
  <span class="keywordsign">|</span> <span class="constructor">Var</span> x         <span class="keywordsign">-&gt;</span> x
;;
</code></pre><p>In order to write a more generic version that evaluates expressions parameterized by an arbitrary type we need to pass an environment for mapping variables to boolean values. The task can be solved by considering the traversable instance for expressions where the effect is given by the option applicative, and then map over the result and evaluate with <code class="code">eval_bool_exp</code>: </p><pre><code class="code"><span class="keyword">let</span> eval env =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">T</span> = <span class="constructor">ExpTraversable</span> (<span class="constructor">OptionApplicative</span>) <span class="keyword">in</span>
  <span class="constructor">T</span>.traverse env &gt;&gt; <span class="constructor">OptionFunctor</span>.map eval_bool_exp
;;
</code></pre><p>To test, assume an environment with two variables (<code>x</code> and <code class="code">y</code>): </p><pre><code class="code"><span class="keyword">let</span> env = <span class="keyword">function</span>
  <span class="keywordsign">|</span> <span class="string">&quot;x&quot;</span>   <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> <span class="keyword">true</span>
  <span class="keywordsign">|</span> <span class="string">&quot;y&quot;</span>   <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> <span class="keyword">false</span>
  <span class="keywordsign">|</span> _     <span class="keywordsign">-&gt;</span> <span class="constructor">None</span>
;;
</code></pre><p>Here are a couple of examples of evaluation expressions using the environment: </p><pre><code class="code"><span class="keywordsign">#</span> eval env (var <span class="string">&quot;x&quot;</span> &lt;|&gt; enot (var <span class="string">&quot;y&quot;</span> &lt;&amp;&gt; var <span class="string">&quot;y&quot;</span>));;
- : bool <span class="constructor">OptionFunctor</span>.t = <span class="constructor">Some</span> <span class="keyword">true</span>

<span class="keywordsign">#</span> eval env (var <span class="string">&quot;z&quot;</span> &lt;|&gt; enot (var <span class="string">&quot;y&quot;</span> &lt;&amp;&gt; var <span class="string">&quot;y&quot;</span>));;
- : bool <span class="constructor">OptionFunctor</span>.t = <span class="constructor">None</span>
</code></pre><p>Next, say we're asked to write a function that extracts all variables from an expression. Could we leverage the traversable instance for this task as well? </p><p>At a first glance this may seem like a stretch as traverse maps over an expression and rebuilds it. This time we're only interested in collecting the variables traversed over. The trick is to pick an appropriate applicative instance; In this case where the effect is accumulating the results. Following is a module-functor, for creating an applicative functor that accumulates results of some type in a list: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">BagApplicative</span> (<span class="constructor">T</span> : <span class="constructor">TYPE</span>) : <span class="constructor">APPLICATIVE</span> <span class="keyword">with</span> <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="constructor">T</span>.t list =
<span class="keyword">struct</span>
  <span class="keyword">type</span> <span class="keywordsign">'</span>a t = <span class="constructor">T</span>.t list
  <span class="keyword">let</span> pure _ = []
  <span class="keyword">let</span> map _ x = x
  <span class="keyword">let</span> apply f = (@) f
<span class="keyword">end</span>;;
</code></pre><p>Note that the type parameter <code class="code">'a</code> in <code class="code">'a t</code> is not actually used and its only purpose is to satisfy the signature of <code class="code">APPLICATIVE</code>. The function <code class="code">pure</code> creates an empty list ignoring its argument. <code class="code">map</code> is effectively a no-op and <code class="code">apply</code> simply concatenates the results of both arguments (which are both lists of accumulated items). </p><p>With <code class="code">BagApplicative</code> at our disposal, extracting the variables is a matter of traversing an expression and for each variable encountered putting it in the bag: </p><pre><code class="code"><span class="keyword">let</span> variables (<span class="keyword">type</span> a) exp =
  <span class="keyword">let</span> <span class="keyword">module</span> <span class="constructor">T</span> = <span class="constructor">ExpTraversable</span> (<span class="constructor">BagApplicative</span> (<span class="keyword">struct</span> <span class="keyword">type</span> t = a <span class="keyword">end</span>)) <span class="keyword">in</span>
  <span class="constructor">T</span>.traverse <span class="constructor">ListApplicative</span>.pure exp
;;
</code></pre><p>This works for any expression type as the explicit type parameter <code class="code">a</code> is used to instantiate the <code>BagApplicative</code> module-functor. The purpose of <code>ListApplicative.pure</code> is to wrap a variable in a singleton list, synonymous with <code class="code">fun x -&gt; [x]</code>. </p><p>Here's an example of using it to collect variables of a <code class="code">string exp</code>: </p><pre><code class="code"><span class="keywordsign">#</span> variables (var <span class="string">&quot;x&quot;</span>  &lt;|&gt; (var <span class="string">&quot;y&quot;</span> &lt;&amp;&gt; (enot (var <span class="string">&quot;z&quot;</span>))));;
- : string list = [<span class="string">&quot;x&quot;</span>; <span class="string">&quot;y&quot;</span>; <span class="string">&quot;z&quot;</span>]
</code></pre><p>Let's take a look at yet another exercise for where traversables prove to be useful. Say we wish to expand an expression with variables into all possible realizations.  For example, the expression <code class="code">var &quot;x&quot; &lt;|&gt; (var &quot;y&quot; &lt;&amp;&gt; (enot (var &quot;z&quot;)))</code> contains three variables so there are <i>2<sup>3</sup></i> different realizations corresponding to each permutation of <code class="code">true/false</code> assignments to <code class="code">x</code>, <code class="code">y</code> and <code class="code">z</code>. </p><p>Every one of them gives rise to an expression where the variable is replaced with a boolean value. The <code>variables</code> function above already allows us to extract the list but how can we generate all permutations? </p><p>For traversing a list (in this case of variables, we may use <code class="code">ListTraversable</code>.  Since each variable yields two possible values (variable and bool pair) we can collect them using the <code>ListApplicative</code>: </p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">LTLA</span> = <span class="constructor">ListTraversable</span> (<span class="constructor">ListApplicative</span>);;
</code></pre><p>The module <code class="code">LTLA</code> now contains a traverse function: </p><pre><code class="code"><span class="keyword">val</span> traverse : (<span class="keywordsign">'</span>a <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>b list) <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a list <span class="keywordsign">-&gt;</span> <span class="keywordsign">'</span>a list list
</code></pre><br/>
Given that <code class="code">ListApplicative</code> corresponds to the Cartesian product, the effect of <code class="code">traverse</code> is to generate all permutations. <p>For instance: </p><pre><code class="code"><span class="keywordsign">#</span> <span class="constructor">LTLA</span>.traverse (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> [<span class="string">'a'</span>]) [1;2;3];;
-: char <span class="constructor">LTLA</span>.t <span class="constructor">LTLA</span>.<span class="constructor">Applicative</span>.t = [[<span class="string">'a'</span>; <span class="string">'a'</span>; <span class="string">'a'</span>]]
</code></pre><br/>
Here, each value <i>1</i>, <i>2</i> and <i>3</i>, can replaced with exactly one value <code class="code">a</code> producing a list with a single permutation. <p>Allowing each number to be mapped to two possible values yields <i>8</i> results: </p><pre><code class="code"><span class="keywordsign">#</span> <span class="constructor">LTLA</span>.traverse (<span class="keyword">fun</span> _ <span class="keywordsign">-&gt;</span> [<span class="string">'a'</span>; <span class="string">'b'</span>]) [1;2;3];;
  - : char <span class="constructor">LTLA</span>.t <span class="constructor">LTLA</span>.<span class="constructor">Applicative</span>.t =
  [[<span class="string">'a'</span>; <span class="string">'a'</span>; <span class="string">'a'</span>]; [<span class="string">'a'</span>; <span class="string">'a'</span>; <span class="string">'b'</span>]; [<span class="string">'a'</span>; <span class="string">'b'</span>; <span class="string">'a'</span>]; [<span class="string">'a'</span>; <span class="string">'b'</span>; <span class="string">'b'</span>];
   [<span class="string">'b'</span>; <span class="string">'a'</span>; <span class="string">'a'</span>]; [<span class="string">'b'</span>; <span class="string">'a'</span>; <span class="string">'b'</span>]; [<span class="string">'b'</span>; <span class="string">'b'</span>; <span class="string">'a'</span>]; [<span class="string">'b'</span>; <span class="string">'b'</span>; <span class="string">'b'</span>]]
</code></pre><p>In our case we're interested in mapping the unique set of collected variables to the values <code class="code">true</code> or <code class="code">false</code> for which each resulting permutation yields a lookup function. The function <code class="code">realizations</code> below also maps over the lookup function to replace the variables with their corresponding boolean values for the given expression: </p><pre><code class="code"><span class="keyword">let</span> realizations exp =
  variables exp
  |&gt; <span class="constructor">LTLA</span>.traverse (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> [(x,<span class="keyword">true</span>); (x,<span class="keyword">false</span>)])
  |&gt; <span class="constructor">ListFunctor</span>.map (<span class="keyword">fun</span> xs <span class="keywordsign">-&gt;</span> map (<span class="keyword">fun</span> x <span class="keywordsign">-&gt;</span> <span class="constructor">List</span>.assoc x xs) exp)
;;
</code></pre>Here's an example of using it: <pre><code class="code"><span class="keywordsign">#</span> realizations (var <span class="string">&quot;x&quot;</span>  &lt;|&gt; (var <span class="string">&quot;y&quot;</span> &lt;&amp;&gt; (enot (var <span class="string">&quot;z&quot;</span>))));;
</code></pre><br/>
returning the following result: <pre><code class="code">[
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">true</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">false</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">true</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">false</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">true</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">true</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">false</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">true</span>)));
  <span class="constructor">Or</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">And</span> (<span class="constructor">Var</span> <span class="keyword">false</span>, <span class="constructor">Not</span> (<span class="constructor">Var</span> <span class="keyword">false</span>)))
]
</code></pre><p>To see why such a function may be useful, consider how it can be used for evaluating all expanded versions of an expression in order to deduce whether or not an expression always evaluates to true or false, irrespective of the choice of variables: </p><pre><code class="code"><span class="keyword">let</span> always_true exp =
  realizations exp
  |&gt; all
  |&gt; eval_bool_exp
;;

<span class="keyword">let</span> always_false exp =
  realizations exp
  |&gt; any
  |&gt; eval_bool_exp
  |&gt; not
;;
</code></pre><p>At last, a few examples to demonstrate their behavior: </p><pre><code class="code"><span class="keywordsign">#</span> always_true (var <span class="string">&quot;x&quot;</span>);;
- : bool = <span class="keyword">false</span>

<span class="keywordsign">#</span> always_true (var <span class="string">&quot;x&quot;</span> &lt;|&gt; etrue);;
- : bool = <span class="keyword">true</span>

<span class="keywordsign">#</span> always_true (var <span class="string">&quot;x&quot;</span> &lt;|&gt; (enot (var <span class="string">&quot;x&quot;</span>)));;
- : bool = <span class="keyword">true</span>

<span class="keywordsign">#</span> always_false (var <span class="string">&quot;x&quot;</span>);;
- : bool = <span class="keyword">false</span>

<span class="keywordsign">#</span> always_false (var <span class="string">&quot;x&quot;</span> &lt;&amp;&gt; (enot (var <span class="string">&quot;x&quot;</span>)));;
- : bool = <span class="keyword">true</span>
</code></pre><h2>Summary</h2><p>Many Haskell patterns implemented in terms of type classes may indeed be ported to OCaml. As demonstrated by the introduction of functor, monoid, applicative functor and traversable module signatures, and the examples, there is a case to be made for why leveraging patterns can help with guiding the specification of APIs and enable code reuse. </p><p>On a more philosophical level - thinking in terms of patterns changes the methodology of writing programs. Under this regime, rather than solving isolated problems one starts by implementing generic functionality and later focus on how to make use of it for addressing more specific problems. </p><p>In the parser example we saw how two patterns, monoid and applicative functor, were sufficient for describing the primitive set of base combinators (<code class="code">(&lt;|&gt;</code>, <code class="code">&lt;*&gt;</code> etc), out of which others could be inferred (e.g. <code class="code">many</code> and <code class="code">many_one</code>). </p><p>In the example for representing and operating on boolean expressions, defining a traversable instance formed the cornerstone from which a variety of functionality was derived, including: </p><ul><li>Mapping over expression</li>
<li>Evaluating expressions</li>
<li>Collecting variables from expressions</li>
</ul>This was all accomplished by customizing the <em>effect</em> of <code class="code">traverse</code> by varying the applicative functor argument. </body> </html>  
