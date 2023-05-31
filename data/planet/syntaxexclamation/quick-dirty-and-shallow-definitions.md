---
title: Quick, dirty and shallow definitions
description: "Here is a quick hack. A few months ago, I advocated for pointer equality
  in OCaml (==) as a way to deal with fresh symbols in a toy compiler. Today, I\u2019ll
  show another application of pointer e\u2026"
url: https://syntaxexclamation.wordpress.com/2013/11/21/quick-dirty-and-shallow-definitions/
date: 2013-11-21T14:21:29-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>Here is a quick hack. <a href="https://syntaxexclamation.wordpress.com/2013/05/04/malloc-is-the-new-gensym/" title="malloc() is the new&nbsp;gensym()">A few months ago</a>, I advocated for pointer equality in OCaml (==) as a way to deal with fresh symbols in a toy compiler. Today, I&rsquo;ll show another application of pointer equality: how to trivially implement a mechanism of definitions, to e.g. pretty-print programs in a more readable way. Once again, this is really easy, but I never heard of such a trick, so here it is.<span></span></p>
<p>Have you ever implemented an quick prototype for a language, and be annoyed by the lack of definition mechanism? For instance, you define a small&nbsp;calculus and encode a few constructs to test it, but end up with outputs like:</p>
<pre>((\n. \p. \f. \x. n f (p f x)) (\f. \x. f (f x)) (\f. \x. f (f x)))
(\b. (\b. \x. \y. b x y) b (\x. \y. x) (\x. \y. x))</pre>
<p>when you only wanted the system to print:</p>
<pre>2 + 2</pre>
<p>(these two constants being Church-encoded in the &lambda;-calculus, FWIW).</p>
<p>One possibility, the Right One<img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/2122.png" alt="&trade;" class="wp-smiley" style="height: 1em; max-height: 1em;"/>, is to add a definition construct to your language, together with a map from name to definition:</p>
<pre class="brush: fsharp; title: ; notranslate">
type exp =
  | ...
  | Def of string

type env = (string * exp) list
type program = env * exp
</pre>
<p>Some would call this a <i>deep encoding</i> of definitions. But it is unfortunately very boring: for each function traversing your programs, you will now have to add a case that traverses constructs by looking up their definitions.</p>
<p>Here is another, <i>shallow</i> solution: keep the expressions as they are, and just have a global, reverse map from expression pointers to names. Each time you want to pretty-print a term, first look if it is not associated with a name in the table. Let me implement that.</p>
<p>First, we will need a simplistic map module with pointer equality comparison:</p>
<pre class="brush: fsharp; title: ; notranslate">
module QMap (T : sig type t type u end) : sig open T
 val register : u -&gt; t -&gt; t
 val lookup_or : (t -&gt; u) -&gt; t -&gt; u
end = struct
 let tbl = ref []
 let register v x = tbl := (x, v) :: !tbl; x
 let lookup_or f x = try List.assq x !tbl with Not_found -&gt; f x
end
</pre>
<p>It is implemented as a list (we can&rsquo;t really do better than this), and the <code>lookup</code> function first tries to find a match with the same memory address (function <code>List.assq</code>), or applies a certain function in case of failure.</p>
<p>Then we define our language (here the &lambda;-calculus), and instantiate the functor with a target type of strings:</p>
<pre class="brush: fsharp; title: ; notranslate">

type exp =
  | Lam of string * exp
  | App of exp * exp
  | Var of string

include QMap (struct type t = exp type u = string end)
</pre>
<p>Let&rsquo;s now encode some (classic) example expressions for testing:</p>
<pre class="brush: fsharp; title: ; notranslate">
(* church numerals *)
let num n =
  let rec aux = function
    | 0 -&gt; Var &quot;x&quot;
    | n -&gt; App (Var &quot;f&quot;, aux (n-1)) in
  register (string_of_int n) (Lam (&quot;f&quot;, Lam (&quot;x&quot;, aux n)))

(* addition *)
let add = register &quot;add&quot;
    (Lam (&quot;n&quot;, Lam (&quot;p&quot;, Lam (&quot;f&quot;, Lam (&quot;x&quot;,
                                        App (App (Var &quot;n&quot;, Var &quot;f&quot;),
                                             App (App (Var &quot;p&quot;, Var &quot;f&quot;),
                                                  Var &quot;x&quot;)))))))</pre>
<p>Notice how, as we define these encodings, we give them a name by registering them in the map. Now defining the pretty-printer:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec to_string () =
  let rec lam = function
      | Lam (x, m) -&gt; &quot;\\&quot; ^ x ^ &quot;. &quot; ^ lam m
      | e -&gt; app e
  and app = function
    | App (m, n) -&gt; app m ^ &quot; &quot; ^ to_string () n
    | f -&gt; to_string () f
  in lookup_or (function
    | Var s -&gt;  s
    | m -&gt; &quot;(&quot; ^ lam m ^ &quot;)&quot;)
</pre>
<p>Notice the use of function <code>lookup_or</code>? At each iteration, we look in the table for a name, and either return it or continue pretty-printing. (Before you ask, the unit argument to <code>to_string</code> is there to convince OCaml that we are indeed defining a proper recursive function, which I wish it could find out by itself).</p>
<p>That&rsquo;s it! Now we can ask, say, to print a large term composed by our previous definitions:</p>
<pre class="brush: fsharp; title: ; notranslate">
 print_string (to_string () (App (App (add, num 2), num 2)));;
</pre>
<p>and get this output:</p>
<pre>(add 2 2)</pre>
<p>while retaining the structure of the underlying term. I could then go ahead and define various transformations, interpreters etc. As long as they preserve the memory location of unchanged terms, (i.e. do not reallocate too much), my pretty-printing will be well&hellip; pretty.</p>
<p>Does this scale up? Probably not. What else can we do with this trick? Memoization anyone?</p>

