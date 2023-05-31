---
title: Parametric HOAS with first-class modules
description: "One of the first choice to make when starting the development of a compiler,
  or any program manipulating syntax\_with binders (e.g. programs with functions and
  variables), is how to\_represent these \u2026"
url: https://syntaxexclamation.wordpress.com/2014/06/27/parametric-hoas-with-first-class-modules/
date: 2014-06-27T21:17:37-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>One of the first choice to make when starting the development of a compiler, or any program manipulating syntax&nbsp;with binders (e.g. programs with functions and variables), is how to&nbsp;represent these terms. Some specialized programming languages, like <a href="http://complogic.cs.mcgill.ca/beluga/" title="Beluga">Beluga</a>, have built-in facilities for this. But if you choose a general-purpose one, like OCaml, then you have plenty of choices: Named terms, De Bruijn indices, Locally nameless, Higher-order abstract syntax (HOAS)&hellip; each with their idiosyncrasies, inconvenients etc. This issue is pervasive in PL research and almost formed a subfield of itself. If you are interested, there is a wealth of literature on the topic; a documented discussion happened on LtU <a href="http://lambda-the-ultimate.org/node/3627" title="A Type-theoretic Foundation for Programming with Higher-order Abstract Syntax and First-class Substitutions">some years back</a> (already), which is probably a good starting point, although of course some has&nbsp;happened since then.</p>
<p>Today I will be looking at implementing&nbsp;in OCaml one of the most recent and praised ones: Parametric HOAS (PHOAS). For some reason that I detail hereafter, the traditional way of implementing PHOAS can be cumbersome, and I propose an alternative here, which happens to be one of my very first uses of first-class modules.</p>
<p><span></span></p>
<h4>Parametric HOAS, the traditional way</h4>
<p>The idea of Parametric HOAS goes back <a href="http://dx.doi.org/10.1145/1411204.1411226" title="Boxes go bananas">Geoffrey Washburn and Stephanie Weirich</a>, at least, and was named this way and formalized in Coq by <a href="http://dx.doi.org/10.1145/1411204.1411226" title="Parametric higher-order abstract syntax for mechanized semantics">Adam Chlipala</a>&nbsp;(I recommend the latter, which is a good read). In a nutshell, you encode binders in the language by OCaml binders (like in HOAS), but the term data structure is parameterized by the type <code>'x</code> of variables. We will call these <em>pre-terms</em>:</p>
<pre>type 'x t = (* pre-term *)
  | Lam of ('x -&gt; 'x t)
  | App of 'x t * 'x t
  | Var of 'x</pre>
<p>For instance, this is a perfectly valid pre-term:</p>
<pre>let ex : float t = Lam (fun x -&gt; App (Var 3.14, Var x))</pre>
<p>Its variables have floats dangling from them. But for a pre-term to become a <em>real</em> term, it has to make no assumption on the type of variables. Let&rsquo;s encode this with an explicit universal&nbsp;quantification&nbsp;in a record:</p>
<pre>type tm = {t : 'x. 'x t}</pre>
<p>This parametrization rules out the previous pre-term. It is also what makes it impossible to define so-called &ldquo;exotic&rdquo; terms. <a href="http://bentnib.org/syntaxforfree.html" title="Syntax for Free: Representing Syntax with Binding Using Parametricity">In fact</a>, there are as many inhabitant to this type than there are &lambda;-terms.</p>
<h4>Examples</h4>
<p>This is an example of a&nbsp;<em>real</em> term:</p>
<pre>let ex : tm = {t = Lam (fun x -&gt; Lam (fun y -&gt; App (Var x, Var y)))}</pre>
<p>So, each term comes in a little package that seals the representation of variables to &ldquo;unknown&rdquo;. If you open this little box, you can set it however you want, as long as, when you close it back, it is back to &ldquo;unknown&rdquo;. This is how you define recursive functions on terms: a main function opens the package, and an auxiliary one works with the pre-term inside, instantiating variables as it pleases. Here, the classic example&nbsp;function counting the number of variables in a term:</p>
<pre>let count : tm -&gt; int =
  let rec aux : unit t -&gt; int = function
    | Var () -&gt; 1
    | App (m, n) -&gt; aux m + aux n
    | Lam f -&gt; aux (f ())
  in fun {t} -&gt; aux t</pre>
<p>When I go under a&nbsp;&lambda;-abstraction, I fill the open holes with <code>()</code> (because here there is no information to carry); so during the recursion, the pre-term can have variables instantiated with&nbsp;<code>().</code></p>
<h4>The issue</h4>
<p>This is all well and good, but this encoding can be quite cumbersome for practical reasons. Look again at the definition of pre-terms. Imagine that there is not 3 but 30 constructors, with not one but five kinds of variables, i.e. five parameters: each time, I would have to pass them to each subterm. Who wants to read 30 lines of code of this kind?</p>
<pre>type ('x, 'y, 'z, 't, 'u) t =
 | Var1 of 'x
 | Var2 of 'y
 | App of ('x, 'y, 'z, 't, 'u) t * ('x, 'y, 'z, 't, 'u) t</pre>
<p>Variable types are never changed, and just passed on untouched to the next subterm. It is like defining a recursive function which never let&nbsp;one of its arguments vary: you want to <a href="http://www.brics.dk/RS/99/27/BRICS-RS-99-27.pdf" title="Lambda-Dropping: Transforming Recursive Equations into Programs with Block Structure">lambda-drop</a> it. In Coq, this is easy thanks to sections, which give you the illusion of lambda-dropping, but OCaml does not have this feature. Nonetheless, let us do exactly this: lambda-drop a parametric type definition into&hellip; a module.</p>
<h4>First-class modules to the rescue</h4>
<p>First, we are going to factor out all these occurrences of the &lsquo;x type parameter by lifting type t into a functor.</p>
<pre>module type X = sig type x end

module Tm (X : X) = struct open X
  type t =
    | Lam of (x -&gt; t)
    | App of t * t
    | Var of x
end</pre>
<p>Pre-term is not a parametric type, it is a functor (a parametric structure). Note that the type of variables is &ldquo;lambda-dropped&rdquo; to the parameter of the functor, so the definition of type t is much less verbose; and it would stay as concise&nbsp;with 5 different kinds of variables. For instance, this is a valid pre-term:</p>
<pre>module Pt = T (struct type x = float end)
let ex : Pt.t = Pt.(Lam (fun x -&gt; App (Var x, Var 3.14)))</pre>
<p>OCaml does not let us instantiate functors in type definitions, so we must do this in two steps: first declare the module by instantiating the functor, and then giving an inhabitant to it.</p>
<p>Once again, For a pre-term to become a real term, it has to make no assumption on its &ldquo;variable type&rdquo; module. Let&rsquo;s encode this by a functor, from the structure defining variables to a structure defining an inhabitant of the pre-term type:</p>
<pre>module type TM = functor (X:X) -&gt; sig val t : Tm(X).t end</pre>
<p>Now, thanks to first-class modules, we have the ability to treat an inhabitant of this module type as an usual value:</p>
<pre>type tm = (module TM)</pre>
<p>Here it is, that&rsquo;s our type of terms.</p>
<h4>Examples</h4>
<p>Let me give you an example of term:</p>
<pre>let ex : tm = (module functor (X:X) -&gt; struct module T = Tm(X) let t =
    T.(Lam (fun x -&gt; Lam (fun y -&gt; App (Var x, Var y))))
  end : TM)</pre>
<p>The value is a first-class module that is a functor, just like the <code>TM</code> module type dictates. Yes, it is substantially more to write than in the previous section, but the overhead is fixed. Note that the type annotation on the module is necessary (I don&rsquo;t know why).</p>
<p>A function on this term representation, e.g. the count example from before, has to first unpack the first class module Tm and instantiate it with the right kind of variable X, grab the pre-term t contained in it; Then an auxiliary recursive function can traverse this pre-term. All in all, we get:</p>
<pre>let count : tm -&gt; int = fun (module Tm) -&gt;
  let module X = struct type x = unit end in
  let module TmX = Tm(X) in
  let module TX = T(X) in let open TX in
  let rec aux : T(X).t -&gt; int = function
    | Lam f -&gt; aux (f ())
    | App (t, u) -&gt; aux t + aux u
    | Var () -&gt; 1
  in aux TmX.t</pre>
<p>Again, it seems like a lot to type, but the overhead is constant, so it has better chances to&nbsp;scale.</p>
<h4>Epilogue</h4>
<p>Here was my implementation of PHOAS with &ldquo;lambda-lifting&rdquo; of type arguments, thanks to first-class modules. I guess that this trick could be useful for other large type definitions involving constant parameters, for instance, do you know the <a href="http://www.cs.cmu.edu/~tom7/papers/recursion-abstract.html" title="Functional Pearl: Programming With Recursion Schemes">recursion scheme</a> programming pattern?&nbsp;Also,&nbsp;try to encode the&nbsp;<em>typed</em>&nbsp;&lambda;-calculus this way, <a href="https://syntaxexclamation.wordpress.com/2014/04/12/representing-pattern-matching-with-gadts/" title="Representing pattern-matching with GADTs">using GADTs</a>; you will need type x to be parametric on a type &lsquo;a, therefore encoding rank-2 polymorphism. I did not get there yet.</p>
<p>As a bonus, here is the boring but still relevant identity function on&nbsp;&lambda;-terms, which has the advantage of returning a term (unlike <code>count</code>):</p>
<pre>let id : tm -&gt; tm = fun (module Tm) -&gt; 
  (module functor (X:X) -&gt; struct let t =
    let module TmX = Tm(X) in
    let module TX = T(X) in let open TX in
    let rec id : t -&gt; t = function
      | Lam f -&gt; Lam (fun x -&gt; id (f x))
      | App (t, u) -&gt; App (id t, id u)
      | Var x -&gt; Var x
    in id TmX.t
  end)</pre>
<p>&nbsp;</p>

