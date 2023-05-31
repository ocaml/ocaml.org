---
title: Mutable
description: This post describes when to use imperative style in OCaml. It uses binary
  search, state count, shuffle, memorize, memorize rec, lazy as examples. Also it
  gives general suggestions on how....
url: http://typeocaml.com/2015/01/20/mutable/
date: 2015-01-21T01:09:42-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/01/mutable_2.jpg#hero" alt="mutable"/></p>

<p>While OCaml is a functional programming language and emphasises pure functional style, it allows <em>mutable</em> (variables and values) and hence imperative programming style. The reason is said in <a href="https://realworldocaml.org/v1/en/html/imperative-programming-1.html">Real World OCaml</a>:</p>

<blockquote>
  <p>Imperative code is of fundamental importance to any practical programming language, because real-world tasks require that you interact with the outside world, which is by its nature imperative. Imperative programming can also be important for performance. While pure code is quite efficient in OCaml, there are many algorithms that can only be implemented efficiently using imperative techniques.</p>
</blockquote>

<p>How to write imperative code in OCaml has been well introduced in both <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.02/coreexamples.html#sec12">OCaml's documentation and user's manual</a> and <a href="https://realworldocaml.org/v1/en/html/imperative-programming-1.html">Real World OCaml</a>. The imperative logic flow is very similar as in other imperative languages. For example, we can write an OCaml <em>binary search</em> like this:</p>

<pre><code class="ocaml">let binary_search a x =  
  let len = Array.length a in
  let p = ref 0 and q = ref (len-1) in
  let loc = ref None in
  while !p &lt;= !q &amp;&amp; !loc = None &amp;&amp; !p &gt;= 0  &amp;&amp; !q &lt; len do
    let mi = (!p + !q) / 2 in
    if x = a.(mi) then loc := Some mi
    else if x &gt; a.(mi) then p := mi + 1
    else q := mi - 1
  done;
  !loc
</code></pre>

<p><em>Mutable</em> or <em>imperative</em> could be a snake. People, who are <em>forced</em> to use OCaml (for work or course assignments) <em>while they are not yet convinced by the potential functional power</em>, may be happy when they know stuff can be written like in Java. They may also intend to (secretly) write imperative code in OCaml as much as possible to just get things done. </p>

<p>It sounds bad and it indeed is. What is the point to code in a heavily imperative way with a functional programming language?</p>

<p>However, I won't be worried even if one does that, because I know it is just the initial avoidance and it won't last long. Why? Because writing imperative code is a bit troublesome anyway. Let's revisit the <code>binary_search</code> we wrote before.</p>

<p>You can see that nothing is straightforward there. </p>

<ol>
<li>When we define a mutable variable, we have to use <code>ref</code>;  </li>
<li>When we get the value out, we have to use <code>!</code> everywhere;  </li>
<li>When we assign a value, we can't forget <code>:</code> before <code>=</code>;  </li>
<li>We even need to add <code>.</code> before <code>()</code> when we access arrays. </li>
</ol>

<p>Even after we finish the function, it appears quite verbose and a little bit uncomfortable to read, right? This is why I am sure in longer term, one may give up imperative style, just truly learn the functional style and eventually understand OCaml's beautiful side. </p>

<p>So if we will not / should not write everything imperatively, when to leverage the benefits from <em>mutable</em>?</p>

<h1>When performance requires it</h1>

<p>In order to manipulate a sequence of elements, we noramlly will use <code>array</code> in imperative languages; however, in pure functional language, we prefer <code>list</code> as it is immutable. </p>

<p>The best thing <code>array</code> offers us is the <em>O(1)</em> speed in accessing an element via its index. But we lose this advantage if using <code>list</code>, i.e.,  we have to do a linear scan, which is <code>O(n)</code>, to get the <code>ith</code> value. Sometimes it would be too slow. To demonstrate this, let's have a look at the problem of <em>shuffle</em>:</p>

<blockquote>
  <p>Given a sequence, randomize the order of all the elements inside. </p>
</blockquote>

<p>A typical algorithm for <em>shuffle</em> can be:</p>

<ol>
<li><code>i</code> initially is <code>0</code> and <code>len</code> is the length of the sequence.  </li>
<li>Randomly generate an integer <code>r</code> within <code>[i, len)</code>.  </li>
<li>Swap the element at <code>i</code> and the one at <code>r</code>.  </li>
<li>Increase <code>i</code> for next targeting element.  </li>
<li>Repeat from step 2. </li>
</ol>

<p>If we use <code>list</code> in OCaml, then we will have:</p>

<pre><code class="ocaml">let rm_nth n l =  
  let rec aux acc i = function
    | [] -&gt; List.rev acc
    | _::tl when i = n -&gt; List.rev_append acc tl
    | x::tl -&gt; aux (x::acc) (i+1) tl
  in 
  aux [] 0 l

(* a slight modification when using list.
   we do not swap, instead, we remove the element from the randomised index 
   and put it to the new list.
*)
let shuffle l =  
  Random.self_init();
  let len = List.length l in
  let rec aux i acc l =
    if i &lt; len then
      let r = Random.int (len - i) in
      aux (i+1) (List.nth l r ::acc) (rm_nth r l)
    else acc
  in
  aux 0 [] l
</code></pre>

<p>We have to scan the list twice in each iteration: once to get the element at the randomised index <code>r</code> and once to remove it. Totally we have <code>n</code> iterations, thus, the time complexity is <em>O(n^2)</em>. </p>

<p>If we use <code>array</code>, then it is much faster with time complexity of <em>O(n)</em> as locating an element and swapping two elements in array just cost <em>O(1)</em>.</p>

<pre><code class="ocaml">let swap a i j =  
  let tmp = a.(i) in
  a.(i) &lt;- a.(j);
  a.(j) &lt;- tmp

let shuffle_array a =  
  Random.self_init();
  let len = Array.length a in
  for i = 0 to len-1 do
    let r = i + Random.int (len - i) in
    swap a i r
  done
</code></pre>

<p>In addition to <code>array</code>, some other imperative data structures can also improve performance. For example, the <code>Hashtbl</code> is the traditional <code>hash table</code> with <code>O(1)</code> time complexity. However, the functional <code>Map</code> module uses <em>AVL</em> tree and thus provides <code>O(logN)</code>. If one really cares about such a difference, <code>Hashtbl</code> can be used with higher priority.</p>

<p>Note that we <em>should not use potential performance boost as an excuse</em> to use imperative code wildly in OCaml. In many cases, functional data structures and algorithms have similar performance, such as the <em>2-list</em> based <a href="http://www.cs.cornell.edu/Courses/cs3110/2014sp/recitations/7/functional-stacks-queues-dictionaries-fractions.html">functional queue</a> can offer us amortised <code>O(1)</code>.</p>

<h1>When we need to remember something</h1>

<p>Constantly creating new values makes functional programming safer and logically clearer, as <a href="http://typeocaml.com/2015/01/02/immutable/">discussed previously</a>. However, occasionally we don't want everything to be newly created; instead, we need a mutable <em>object</em> that stays put in the memory but can be updated. In this way, we can remember values in a single place.</p>

<blockquote>
  <p>Write a function that does <code>x + y * z</code>. It outputs the correct result and in addition, prints how many times it has been called so far.</p>
</blockquote>

<p>The <code>x + y * z</code> part is trivial, but the later recording the times of calls is tricky. Let's try to implement such a function in pure functional style first.</p>

<pre><code class="ocaml">(* pure functional solution *)
let f x y z last_called_count =  
  print_int (last_called_count+1);
  x + y * z, last_called_count + 1
</code></pre>

<p>The code above can roughly achieve the goal. However, it is not great. </p>

<ol>
<li>It needs an additional argument which is meant to be the most recent count of calls. The way could work but is very vulnerable because it accepts whatever integer and there is no way to constrain it to be the real last count.  </li>
<li>It has to return the new call count along with the real result</li>
</ol>

<p>When a user uses this function, he / she will feel awkward. <code>last_called_count</code> needs to be taken care of very carefully in the code flow to avoid miscounting. The result returned is a tuple so pattern matching is necessary to obtain the real value of <code>x + y * z</code>. Also again, one need to somehow remember the new call count so he / she can supply to the next call.</p>

<p>This is where imperative programming comes to help:</p>

<pre><code class="ocaml">(* with help of imperative programming.
   note that the function g can be anonymous.*)
let f =  
  let countable_helper () =
    let called_count = ref 0 in
    let g x y z = 
      called_count := !called_count + 1;
      print_int !called_count;
      x + y * z
    in
    g
  in 
  countable_helper()
</code></pre>

<p><code>countable_helper</code> is a helper function. If it is called, it first creates a mutable <code>called_count</code> and then pass it to <code>g</code>. Because <code>called_count</code> is mutable, so <code>g</code> can freely increase its value by <code>1</code>. Eventually <code>x + y * z</code> is done after printing <code>called_count</code>. <code>g</code> is returned to f as it is the result of <code>countable_helper()</code>, i.e., <code>f</code> is <code>g</code>. </p>

<h1>When we need later substitution</h1>

<p>I found this interesting case from <a href="https://realworldocaml.org/v1/en/html/imperative-programming-1.html#memoization-and-dynamic-programming">The chapter for imperative programming in Real World OCaml</a> and it is about <em>memoize</em>. In this section, we borrow contents directly from the book but will emphasise <em>the substitution</em> part.  </p>

<p>Python developers should be quite familiar with the <code>memoize</code> decorator . Essentially, it makes functions remember the <em>argument, result</em> pairs so that if the same arguments are supplied again then the stored result is returned immediately without repeated computation.</p>

<p>We can write <code>memoize</code> in OCaml too:</p>

<pre><code class="ocaml">(* directly copied from Real World OCaml, does not use anonymous function *)
let memoize f =  
  let table = Hashtbl.Poly.create () in
  let g x = 
    match Hashtbl.find table x with
    | Some y -&gt; y
    | None -&gt;
      let y = f x in
      Hashtbl.add_exn table ~key:x ~data:y;
      y
  in
  g
</code></pre>

<p>It uses <code>Hashtbl</code> as the imperative storage box and the mechanism is similar as our previous example of <em>call count</em>.</p>

<p>The fascinating bit comes from the fact that this <code>memoize</code> cannot handle recursive functions. If you don't believe it, let's try with the <em>fibonacci</em> function:</p>

<pre><code class="ocaml">let rec fib n =  
  if n &lt;= 1 then 1 else fib(n-1) + fib(n-2)

let fib_mem = memoize fib  
</code></pre>

<p>Hmmm...it will compile and seems working. Yes, <code>fib_mem</code> will return correct results, but we shall have a closer look to see whether it really remembers the <em>argument, result</em> pairs. So what is <code>fib_mem</code> exactly? By replacing <code>f</code> with <code>fib</code> inside <code>memoize</code>, we get:</p>

<pre><code class="ocaml">(* not proper ocaml code, just for demonstration purpose *)

fib_mem is actually  
  match Hashtbl.find table x with
  | Some y -&gt; y
  | None -&gt;
    let y = fib x in (* here is fib *)
    Hashtbl.add_exn table ~key:x ~data:y;
    y
</code></pre>

<p>So inside <code>fib_mem</code>, if a new argument comes, it will call <code>fib</code> and <code>fib</code> is actually not memoized at all. What does this mean? It means <code>fib_mem</code> may eventually remember the new argument and its result, but will never remember all the arguments and their results along the recusive way.</p>

<p>For example, let's do <code>fib_mem 5</code>.</p>

<ol>
<li><code>5</code> is not in the Hashtbl, so <code>fib 5</code> is called.  </li>
<li>According to the definition of <code>fib</code>, <code>fib 5 = fib 4 + fib 3</code>, so now <code>fib 4</code>.  </li>
<li><code>fib 4 = fib 3 + fib 2</code>, no problem, but look, <code>fib 3</code> will be done after <code>fib 4</code> finishes.  </li>
<li>Assuming <code>fib 4</code> is done, then we go back to the right hand side of the <code>+</code> in point 2, which means we need to do <code>fib 3</code>.  </li>
<li>Will we really do <code>fib 3</code> now? Yes, unfortunately. Even though it has been done during <code>fib 4</code>, because <code>fib</code> is not memoized.</li>
</ol>

<p>To solve this problem, we need <em>the substitution</em> technique with the help of imperative programming.</p>

<h2>An attractive but WRONG solution</h2>

<p>When I read the book for the first time, before continuing for the solution of memoized fib, I tried something on my own.</p>

<p>So the problem is the <code>f</code> inside <code>memoize</code> is not memoized, right? How about we make that that <code>f</code> mutable, then after we define <code>g</code>, we give <code>g</code> to <code>f</code>? Since <code>g</code> is memoized and <code>g</code> is calling <code>g</code> inside, then the whole thing would be memoized, right?</p>

<pre><code class="ocaml">let mem_rec_bad f =  
  let table = Hashtbl.Poly.create () in
  let sub_f = ref f in
  let g x = 
    match Hashtbl.find table x with
    | Some y -&gt; y
    | None -&gt;
      let y = !sub_f x in
      Hashtbl.add_exn table ~key:x ~data:y;
      y
  in
  sub_f := g;
  g
</code></pre>

<p>It can pass compiler but will stackoverflow if you do <code>let fib_mem = mem_rec_bad fib;; fib_mem 5</code>. After we define <code>g</code> and replae the original value of <code>sub_f</code> with <code>g</code>, it seems fine, but What is <code>g</code> now?</p>

<pre><code class="ocaml">(* g is now actually like: *)
let g x =  
  match Hashtbl.find table x with
  | Some y -&gt; y
  | None -&gt;
    let y = g x in
    Hashtbl.add_exn table ~key:x ~data:y;
    y
</code></pre>

<p><code>g</code> will check the Hashtbl forever! And we totally lose the functionality of the original <code>f</code> and <code>g</code> becomes meaningless at all. </p>

<p>So we can't directly replace the <code>f</code> inside. Is there any way to reserve the functionality of <code>f</code> but somehow substitute some part with the memoization? </p>

<h2>The elegant solution</h2>

<p><strong>Updated on 2015-01-25:</strong> Please go to <a href="http://typeocaml.com/2015/01/25/memoize-rec-untying-the-recursive-knot/">Recursive Memoize &amp; Untying the Recursive Knot</a> for better explanation of recursive memoize. This following content here is not that good.</p>

<p>The answer is Yes, and we have to build a non-recusive function out of the recusive <code>fib</code>.</p>

<pre><code class="ocaml">(* directly copied from the book *)
let fib_norec f n =  
  if n &lt;= 1 then 1
  else f(n-2) + f(n-1)

let fib_rec n = fib_norec fib_rec n  
</code></pre>

<p>(I never thought before that a recursive function can be split like this, honestly. I don't know how to induct such a way and can't explain more. I guess we just learn it as it is and continue. More descriptions of it is in the book.) (<em>[1]</em>)</p>

<p>Basically, for a recursive function <code>f_rec</code>, we can </p>

<ol>
<li>change <code>f_rec</code> to <code>f_norec</code> with an additional parameter <code>f</code>  </li>
<li>replace the <code>f_rec</code> in the original body with <code>f</code>  </li>
<li>then <code>let rec f_rec parameters = f_norec f_rec parameters</code>  </li>
<li>In this way, <code>f_rec</code> will bring up <code>f_norec</code> whenever being called, so actually the recusive logic is still controled by <code>f_norec</code>. </li>
</ol>

<p>Here the important part is <code>f_norec</code> and its parameter <code>f</code> gives us the chance for correct substitution. </p>

<pre><code class="ocaml">let memo_rec f_norec =  
  let fref = ref (fun _ -&gt; assert false) in
  (* !fref below will have the new function defined next, which is
     the memoized one *)
  let h x = f_norec !fref x in 
  let f_mem = memoize h in
  fref := f_mem;
  f_mem
</code></pre>

<p>Now, <code>fref</code>'s value will become the memoized one with <code>f_norec</code>. Since <code>f_norec</code> controls the logic and real work, we do not lose any functionality but can remember every <em>argument, result</em> pairs along the recursive way.</p>

<h1>Summary</h1>

<p>In this post, we just list out three quite typical cases where imperative programming can be helpful. There are many others, such as <a href="http://typeocaml.com/2014/11/13/magic-of-thunk-lazy/">lazy</a>, etc. </p>

<p>Moreover, one more suggestion on using imperative style is that <em>don't expose imperative interface to public if you can</em>. That means we should try to embed imperative code inside pure function as much as possible, so that the users of our functions cannot access the mutable parts. This way can let our functional code continue being pure enough while enjoying the juice of imperative programming internally.</p>

<hr/>

<p><strong>[1].</strong> glacialthinker has commented <a href="http://www.reddit.com/r/ocaml/comments/2t49p9/mutable_and_when_shall_we_use_imperative/cnvryku">here</a>. This technique is called <em>untying the recursive knot</em>.</p>

<p><a href="http://en.wikipedia.org/wiki/Mystique_(comics)">Mystique</a> in the head image is another major character in <a href="http://en.wikipedia.org/wiki/X-Men">X-Men's world</a>. <em>She is a shapeshifter who can mimic the appearance and voice of any person with exquisite precision.</em> Similar like the <em>mutable</em> in OCaml that always sticks to the same type once being created, human is the only <em>thing</em> she can mutate to.</p>
