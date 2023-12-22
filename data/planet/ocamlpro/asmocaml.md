---
title: ASM.OCaml
description: As you may know, there is a subset of Javascript that compiles efficiently
  to assembly used as backend of various compilers including a C compiler like emscripten.
  We'd like to present you in the same spirit how never to allocate in OCaml. Before
  starting to write anything, we must know how to find ...
url: https://ocamlpro.com/blog/2016_04_01_asm_ocaml
date: 2016-04-01T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    chambart\n  "
source:
---

<p>As you may know, there is a subset of Javascript that compiles efficiently to assembly used as backend of various compilers including a C compiler like emscripten. We'd like to present you in the same spirit how never to allocate in OCaml.</p>
<p>Before starting to write anything, we must know how to find if a code is allocating. The best way currently is to look at the Cmm intermediate representation. We can see it by calling <code>ocamlopt</code> with the <code>-dcmm</code> option:</p>
<p><code>ocamlopt -c -dcmm test.ml</code></p>
<pre><code class="language-ocaml">let f x = (x,x)
</code></pre>
<p>Some excerpt from the output:</p>
<pre><code class="language-lisp">(function camlTest__f_4 (x_6/1204: val) (alloc 2048 x_6/1204 x_6/1204))
</code></pre>
<p>To improve readability, in this post we will clean a bit the variable names:</p>
<pre><code class="language-lisp">(function f (x: val) (alloc 2048 x x))
</code></pre>
<p>We see that the function f (named <code>camlTest__f_4</code>) is calling the <code>alloc</code> primitive, which obviously is an allocation. Here, this creates a size 2 block with tag 0 (2048 = 2 &lt;&lt; 10 + 0) and containing two times the value <code>x_6/1204</code> which was <code>x</code> is the source. So we can detect if some code is allocating by doing <code>ocamlopt -c -dcmm test.ml 2&amp;&gt;1 | grep alloc</code> (obviously any function or variable named alloc will also appear).</p>
<p>It is possible to write some code that don't allocate (in the heap) at all, but what are the limitations ? For instance the omnipresent fibonacci function does not allocate:</p>
<pre><code class="language-ocaml">let rec fib = function
  | 0 -&gt; 0
  | 1 -&gt; 1
  | n -&gt; fib (n-1) + fib (n-2)
</code></pre>
<pre><code class="language-lisp">(function fib (n: val)
  (if (!= n 1)
  (if (!= n 3)
    (let Paddint_arg (app &quot;fib&quot; (+ n -4) val)
    (+ (+ (app &quot;fib&quot; (+ n -2) val) Paddint_arg) -1))
    3)
  1))
</code></pre>
<p>But quite a lot of common patterns do:</p>
<ul>
<li>Building structured values will allocate (tuple, records, sum types containing an element, ...)
</li>
<li>Using floats, int64, ... will allocate
</li>
<li>Declaring non-toplevel functions will allocate
</li>
</ul>
<p>Considering that, it can appear that it is almost impossible to write any non-trivial code without using those. But that's not completely true.</p>
<p>There are some exceptions to those rules, where some normally allocating constructions can be optimised away. We will explain how to exploit them to be able to write some more code.</p>
<h2>Local references</h2>
<p>Maybe the most important one is the case of local references.</p>
<pre><code class="language-ocaml">let fact n =
  let result = ref 1 in
  for i = 1 to n do
    result := n * !result
  done;
  !result
</code></pre>
<p>To improve readability, this has been cleaned and demangled</p>
<pre><code class="language-lisp">(function fact (n: val)
  (let (result 3)
  (seq
    (let (i 3 bound n)
    (catch
      (if (&gt; i bound) (exit 3)
      (loop
        (assign result (+ (* (+ n -1) (&gt;&gt;s result 1)) 1))
        (assign i (+ i 2))
      (if (== i bound) (exit 3) [])
    with(3) []))))
  result)))
</code></pre>
<p>You can notice that allocation of the reference disappeared. The modifications were replaced by assignments (the <code>assign</code> operator) to the result variable. This transformation can happen when a reference is never used anywhere else than as an argument of the ! and := operator and does not appear in the closure of any local function like:</p>
<pre><code class="language-ocaml">let counter () =
  let count = ref 0 in
  let next () = count := !count + 1; !count in
  next
</code></pre>
<p>This won't happen in this case since count is in the closure of next.</p>
<h2>Unboxing</h2>
<p>The float, int32, int64 and nativeint types do not fit in the generic representation of values that can be stored in the OCaml heap, so they are boxed. This means that they are allocated and there is an annotation to tell the garbage collector to skip their content. So using them in general will allocate. But an important optimization is that local uses (some cases that obviously won't go in the heap) are 'unboxed', i.e. not allocated.</p>
<h2>If/match couple</h2>
<p>Some 4.03 change also improve some cases of branching returning tuples</p>
<pre><code class="language-ocaml">let positive_difference x y =
  let (min, max) =
    if x &lt; y then
      (x, y)
    else
      (y, x)
  in
  max - min
</code></pre>
<pre><code class="language-lisp">(function positive_difference (x: val y: val)
  (catch
    (if (&lt; x y) (exit 7 y x)
    (exit 7 x y))
  with(7 max min) (+ (- max min) 1)))
</code></pre>
<h2>Control flow</h2>
<p>You can do almost any control flow like that, but this is quite
unpractical and is still limited in many ways.</p>
<p>If you don't want to write everything as for and while loops, you can
write functions for your control flow, but to prevent allocation you
will have to refrain from doing a few things. For instance, you should
not pass record or tupple as argument to functions of course, you
should pass each field separately as a different argument.</p>
<p>But what happens when you want to return multiple values ? There is
some ongoing project to try to optimise the allocations of some of
those cases away, but currently you can't. Really ? NO !</p>
<h2>Returning multiple values</h2>
<p>If you bend a bit your mind, you may see that returning from a
function is almost the same thing as calling one... Or you can make it
that way. So let's transform our code in 'Continuation Passing Style'</p>
<p>For instance, let's write a function that finds the minimum and the maximum of a list. That could be written like that:</p>
<pre><code class="language-ocaml">let rec fold_left f init l =
  match l with
  | [] -&gt; init
  | h :: t -&gt;
    let acc = f init h in
    fold_left f acc t

let keep_min_max (min, max) v =
  let min = if v &lt; min then v else min in
  let max = if v &gt; max then v else max in
  min, max

let find_min_max l =
  match l with
  | [] -&gt; invalid_arg &quot;find_min_max&quot;
  | h :: t -&gt;
    fold_left keep_min_max (h, h) t
</code></pre>
<h3>Continuation Passing Style</h3>
<p>Transforming it to continuation passing style (CPS) replace every function return by a tail-call to a function representing 'what happens after'. This function is usually called a continuation and a convention is to use the variable name 'k' for it.</p>
<p>Let's start simply by turning only the keep_min_max function into continuation passing style.</p>
<pre><code class="language-ocaml">let keep_min_max (min, max) v k =
  let min = if v &lt; min then v else min in
  let max = if v &gt; max then v else max in
  k (min, max)

val keep_min_max : 'a * 'a -&gt; 'a -&gt; ('a * 'a -&gt; 'b) -&gt; 'b
</code></pre>
<p>That's all here. But of course we need to modify a bit the function calling it.</p>
<pre><code class="language-ocaml">let rec fold_left f init l =
  match l with
  | [] -&gt; init
  | h :: t -&gt;
    let k acc =
      fold_left f acc t
    in
    f init h k

val fold_left : ('a -&gt; 'b -&gt; ('a -&gt; 'a) -&gt; 'a) -&gt; 'a -&gt; 'b list -&gt; 'a
val find_min_max : 'a list -&gt; 'a * 'a
</code></pre>
<p>Here instead of calling f then recursively calling fold_left, we prepare what we will do after calling f (that is calling fold_left) and then we call f with that continuation. find_min_max is unchanged and still has the same type.</p>
<p>But we can continue turning things in CPS, and a full conversion would result in:</p>
<pre><code class="language-ocaml">let rec fold_left_k f init l k =
  match l with
  | [] -&gt; k init
  | h :: t -&gt;
    let k acc =
      fold_left_k f acc t k
    in
    f init h k
val fold_left_k : ('a -&gt; 'b -&gt; ('a -&gt; 'c) -&gt; 'c) -&gt; 'a -&gt; 'b list -&gt; ('a -&gt; 'c) -&gt; 'c

let keep_min_max_k (min, max) v k =
  let min = if v &lt; min then v else min in
  let max = if v &gt; max then v else max in
  k (min, max)
val keep_min_max_k : 'a * 'a -&gt; 'a -&gt; ('a * 'a -&gt; 'b) -&gt; 'b

let find_min_max_k l k =
  match l with
  | [] -&gt; invalid_arg &quot;find_min_max&quot;
  | h :: t -&gt;
    fold_left_k keep_min_max (h, h) t k
val find_min_max_k : 'a list -&gt; ('a * 'a -&gt; 'b) -&gt; 'b

let find_min_max l =
  find_min_max_k l (fun x -&gt; x)
val find_min_max : 'a list -&gt; 'a * 'a
</code></pre>
<h3>Where rectypes matter for performance reasons</h3>
<p>That's nice, we only have tail calls now, but we are not done removing allocation yet of course. We now need to get rid of the allocation of the closure in fold_left_k and of the couples in keep_min_max_k. For that, we need to pass everything that should be allocated as argument:</p>
<pre><code class="language-ocaml">let rec fold_left_k2 f init1 init2 l k =
  match l with
  | [] -&gt; k init1 init2
  | h :: t -&gt;
    f init1 init2 h t fold_left_k2 k

val fold_left_k2 :
  ('b -&gt; 'c -&gt; 'd -&gt; 'd list -&gt; 'a -&gt; ('b -&gt; 'c -&gt; 'e) -&gt; 'e) -&gt;
  'b -&gt; 'c -&gt; 'd list -&gt; ('b -&gt; 'c -&gt; 'e) -&gt; 'e as 'a

let rec keep_min_max_k2 = fun min max v k_arg k k2 -&gt;
  let min = if v &lt; min then v else min in
  let max = if v &gt; max then v else max in
  k keep_min_max_k2 min max k_arg k2

val keep_min_max_k2 :
  'b -&gt; 'b -&gt; 'b -&gt; 'c -&gt; ('a -&gt; 'b -&gt; 'b -&gt; 'c -&gt; 'd -&gt; 'e) -&gt; 'd -&gt; 'e as 'a

let find_min_max_k2 l k =
  match l with
  | [] -&gt; invalid_arg &quot;find_min_max&quot;
  | h :: t -&gt;
    fold_left_k2 keep_min_max_k2 h h t k

val find_min_max_k2 : 'a list -&gt; ('a -&gt; 'a -&gt; 'b) -&gt; 'b
</code></pre>
<p>For some reason, we now need to activate 'rectypes' to allow functions to have a recursive type (the 'as 'a') but we managed to completely get rid of allocations.</p>
<pre><code class="language-lisp">(function fold_left_k2 (f: val init1: val init2: val l: val k: val)
  (if (!= l 1)
  (app &quot;caml_apply6&quot; init1 init2 (load val l) l &quot;fold_left_k2&quot; k f val))
  (app &quot;caml_apply2&quot; init1 init2 k val)))

(function keep_min_max_k2 (min: val max: val v: val k: val k: val k2: val)
  (let
  (min
  (if (!= (extcall &quot;caml_lessthan&quot; v min val) 1)
  v min)
  max
  (if (!= (extcall &quot;caml_greaterthan&quot; v max val) 1)
  v max))
  (app &quot;caml_apply5&quot; &quot;keep_min_max_k2&quot; min max k k2 k val)))

(function find_min_max_k2 (l: val k: val)
  (if (!= l 1)
  (let h (load val l)
  (app &quot;fold_left_k2&quot; &quot;keep_min_max_k2&quot; h h t k val))
  (raise &quot;exception&quot;)))
</code></pre>
<p>So we can turn return points into call points and get rid of a lot of potential allocations like that. But of course there is no way to handle functions passing or returning sum types like that ! Well, I'm not so sure.</p>
<h2>Sum types</h2>
<p>Let's try with the option type for instance:</p>
<pre><code class="language-ocaml">type 'a option =
  | None
  | Some of 'a

let add_an_option_value opt v =
  match opt with
  | None -&gt; v
  | Some n -&gt; n + v

let n1 = add_an_option_value (Some 3) 4
let n2 = add_an_option_value None 4
</code></pre>
<p>The case of the sum type tells us if there is some more values that we can get and their type. But there is another way to associate some type information with an actual value: GADTs</p>
<pre><code class="language-ocaml">type ('a, 'b) option_case =
  | None' : ('a, unit) option_case
  | Some' : ('a, 'a) option_case

let add_an_option_value (type t) (opt: (int, t) option_case) (n:t) v =
  match opt with
  | None' -&gt; v
  | Some' -&gt; n + v

let n1 = add_an_option_value Some' 3 4
let n2 = add_an_option_value None' () 4
</code></pre>
<p>And voil&agrave;, no allocation anymore !</p>
<p>Combining that with the CPS transformation can get you quite far without allocating !</p>
<h2>Manipulating Memory</h2>
<p>Now that we can manage almost any control flow without allocating, we need also to manipulate some values. That's the point where we simply suggest to use the same approach as ASM.js: allocate a single large bigarray (this is some kind of malloc), consider integers as pointers and you can do anything. We won't go into too much details here as this would require another post for that topic.</p>
<p>For some low level packed bitfield manipulation you can have a look at <a href="https://gist.github.com/chambart/a0382fb4d908a3e45744">some more tricks</a></p>
<h2>Conclusion</h2>
<p>So if you want to write non allocating code in OCaml, turn everything in CPS, add additional arguments everywhere, turn your sum types in unboxed GADTs, manipulate a single large bigarrays. And enjoy !</p>
<h1>Comments</h1>
<p>Gaetan Dubreil (3 April 2016 at 11 h 16 min):</p>
<blockquote>
<p>Thank you for this attractive and informative post.
Just to be sure, is it not &lsquo;t&rsquo; rather than &lsquo;l&rsquo; that must be past to the fold_left function?
You said &ldquo;we only have tail calls now&rdquo; but I don&rsquo;t see any none tail calls in the first place, am I wrong?</p>
</blockquote>
<p>Pierre Chambart (4 April 2016 at 14 h 48 min):</p>
<blockquote>
<p>There where effectively some typos. Thanks for noticing.</p>
<p>There is one non-tail call in fold_left: the call to f. But effectively the recursion is tail.</p>
</blockquote>
<p>kantien (25 May 2016 at 13 h 57 min):</p>
<blockquote>
<p>Interesting article, but i have one question. Can we say, from the proof theory point of view, that turning the code in CPS style not to allocate is just an application of the Gentzen&rsquo;s cut-elimination theorem ?
I explain in more details this interpretation : if we have a proof P1 of the proposition A and a proof P2 of the proposition A &rArr; B, we can produce a proof P3 of proposition B by applying the cut rule or modus ponens, but the theorem says that we can eliminate the use of cut rule and produce a direct proof P4 of the proposition B. But modus ponens (or cut rule) is just the rule for typing function application : if f has type &lsquo;a -&gt; &lsquo;b and x has type &lsquo;a then f x has type &lsquo;b. And so the cut-elimination theorem says that we can produce an object of type &lsquo;b without allocate an object of type &lsquo;a (this is not necessary to produce the P1 proof, or more exactly this is not necessary to put the P1&rsquo;s conclusion in the environment in order to use it as a premise of the P2 proof ). Am I right ?</p>
</blockquote>
<p>jdxu (4 January 2021 at 11 h 36 min):</p>
<blockquote>
<p>Very useful article. BTW, is there any document/tutorial/article about cmm syntax?</p>
</blockquote>

