---
title: Recursive Memoize & Untying the Recursive Knot
description: This post explains recursive memoize function in OCaml and also introduces  untying
  the recursive knot in OCaml. and its usage....
url: http://typeocaml.com/2015/01/25/memoize-rec-untying-the-recursive-knot/
date: 2015-01-25T13:22:15-00:00
preview_image:
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2015/01/knot-1.jpg#hero" alt=""/></p>

<p>When I wrote the section of <em>When we need later substitution</em> in  <a href="http://typeocaml.com/2015/01/20/mutable/">Mutable</a>, I struggled. I found out that I didn't fully understand the recursive memoize myself, so what I had to do was just copying the knowledge from <a href="https://realworldocaml.org/v1/en/html/imperative-programming-1.html#memoization-and-dynamic-programming">Real World OCaml</a>. Luckily, after the post was published, <em>glacialthinker</em> <a href="http://www.reddit.com/r/ocaml/comments/2t49p9/mutable_and_when_shall_we_use_imperative/cnvryku">commented</a> in <a href="http://www.reddit.com/r/ocaml/comments/2t49p9/mutable_and_when_shall_we_use_imperative/">reddit</a>:</p>

<blockquote>
  <blockquote>
    <p>(I never thought before that a recursive function can be split like this, honestly. I don't know how to induct such a way and can't explain more. I guess we just learn it as it is and continue. More descriptions of it is in the book.)</p>
  </blockquote>
  
  <p>This is &quot;untying the recursive knot&quot;. And I thought I might find a nice wikipedia or similiar entry... but I mostly find Harrop. :) He actually had a nice article on this many years back in his OCaml Journal. Anyway, if the author swings by, searching for that phrase may turn up more material on the technique.</p>
</blockquote>

<p>It greatly enlightened me. Hence, in this post, I will share with you my futher understanding on <em>recursive memoize</em> together with the key cure <em>untying the recursive knot</em> that makes it possible. </p>

<h1>Simple Memoize revamped</h1>

<p>We talked about the simple <em>memoize</em> before. It takes a non-recursive function and returns a new function which has exactly the same logic as the original function but with new new ability of caching the <em>argument, result</em> pairs. </p>

<pre><code class="ocaml">let memoize f =  
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

<p><img src="http://typeocaml.com/content/images/2015/01/simple_memoize-1.jpg" alt=""/></p>

<blockquote>
  <p>The greatness of <code>memoize</code> is its flexibility: as long as <code>f</code> takes a single argument, <code>memoize</code> can make a <em>memo version</em> out of it without touching anything inside <code>f</code>.  </p>
</blockquote>

<p>This means while we create <code>f</code>, we don't need to worry about the ability of caching but just focus on its own correct logic. After we finish <code>f</code>, we simply let <code>memoize</code> do its job. <em>Memoization</em> and <em>functionality</em> are perfectly separated. </p>

<p><strong>Unfortunately, the simple <code>memoize</code> cannot handle recursive functions.</strong> If we try to do <code>memoize f_rec</code>, we will get this:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/simple_memoize_rec.jpg" alt=""/></p>

<p><code>f_rec</code> is a recursive function so it will call itself inside its body. <code>memoize f_rec</code> will produce <code>f_rec_memo</code> which is a little similar as the previous <code>f_memo</code>, yet with the difference that it is not a simple single call of <code>f_rec arg</code> like we did <code>f arg</code>. Instead, <code>f_rec arg</code> may call <code>f_rec</code> again and again with new arguments. </p>

<p>Let's look at it more closely with an example. Say, <code>arg</code> in the recursive process will be always decreased by <code>1</code> until <code>0</code>.</p>

<ol>
<li>Let's first od <code>f_rec_memo 4</code>.  </li>
<li><code>f_rec_memo</code> will check the <code>4</code> against <code>Hashtbl</code> and it is not in.  </li>
<li>So <code>f_rec 4</code> will be called for the first time.  </li>
<li>Then <code>f_rec 3</code>, <code>f_rec 2</code>, <code>f_rec 1</code> and <code>f_rec 0</code>.  </li>
<li>After the 5 calls, result is obtained. Then <em>4, result</em> pair is stored in <code>Hashtbl</code> and returned.  </li>
<li>Now let's do <code>f_rec_memo 3</code>, what will happen? Obviously, <code>3</code> won't be found in <code>Hashtbl</code> as only <code>4</code> is stored in step 5.  </li>
<li>But should <em>3, result</em> pair be found? Yes, it should of course because we have dealt with <code>3</code> in step 4, right?  </li>
<li>Why <code>3</code> has been done but is not stored?  </li>
<li>ahh, it is because we did <code>f_rec 3</code> but not <code>f_rec_memo 3</code> while only the latter one has the caching ability. </li>
</ol>

<p>Thus, we can use <code>memoize f_rec</code> to produce a memoized version out of <code>f_rec</code> anyway, but it changes only the surface not the <code>f_rec</code> inside, hence not that useful. How can we make it better then?</p>

<h1>Recursive Memoize revamped</h1>

<p>What we really want for memoizing a recursive function is to blend the <em>memo</em> ability deep inside, like this:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/memoize_rec_wish-1.jpg" alt=""/></p>

<p>Essentially we have to replace <code>f_rec</code> inside with <code>f_rec_memo</code>:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/transform-1.jpg" alt=""/></p>

<p>And only in this way, <code>f_rec</code> can be fully memoized. However, we have one problem: **it seems that we have to change the internal of <code>f_rec</code>.</p>

<p>If we can modify <code>f_rec</code> directly, we can solve it easily . For instance of <em>fibonacci</em>:</p>

<pre><code class="ocaml">let rec fib_rec n =  
  if n &lt;= 1 then 1
  else fib_rec (n-1) + fib_rec (n-2)
</code></pre>

<p>we can make the memoized version:</p>

<pre><code class="ocaml">let fib_rec_memo_trivial n =  
  let table = Hashtbl.Poly.create () in
  let rec fib_rec_memo x = 
    match Hashtbl.find table x with
    | Some y -&gt; y
    | None -&gt;
      let y = fib_rec_memo (x-1) + fib_rec_memo (x-2) in
      Hashtbl.add_exn table ~key:x ~data:y;
      y
  in
  fib_rec_memo
</code></pre>

<p>In the above solution, we replaced the original <code>fib_rec</code> inside with <code>fib_rec_memo</code>, however, we also changed the declaration to <code>fib_rec_memo</code> completely. In fact, now <code>fib_rec</code> is totally ditched and <code>fib_rec_memo</code> is a new function that blends the logic of <em>memoize</em> with the logic of <code>fib_rec</code>. </p>

<p>Well, yes, <code>fib_rec_memo_trivial</code> can achieve our goal, but only for <code>fib_rec</code> specificly. If we need to make a memoized version for another recursive function, then we need to change the body of that function again. This is not what we want. <strong>We wish for a <code>memoize_rec</code> that can turn <code>f_rec</code> directly into a memoized version, just like what the simple <code>memoize</code> can do for <code>f</code></strong>.</p>

<p>So we don't have a shortcut. Here is what we need to achieve:</p>

<ol>
<li>we have to replace the <code>f_rec</code> inside the body of <code>f_rec</code> with <code>f_rec_memo</code>  </li>
<li>We have keep the declaration of <code>f_rec</code>.  </li>
<li>We must assume we can't know the specific logic inside <code>f_rec</code>. </li>
</ol>

<p>It sounds a bit hard. It is like giving you a compiled function without source code and asking you to modify its content. And more imporantly, your solution must be generalised. </p>

<p>Fortunately, we have a great solution to create our <code>memoize_rec</code> without any <em>hacking</em> or <em>reverse-engineering</em> and <strong>untying the recursive knot is the key</strong>. </p>

<h1>Untying the Recursive Knot</h1>

<p>To me, this term sounds quite fancy. In fact, I never heard of it before <em>2015-01-21</em>. After I digged a little bit about it, I found it actually quite simple but very useful (this recursive memoize case is an ideal demonstration). Let's have a look at what it is.</p>

<p>Every recursive function somehow follows a similar pattern where it calls itself inside its body:</p>

<p><img src="http://typeocaml.com/content/images/2015/01/single_f_rec.jpg" alt=""/></p>

<p>Once a recursive function application starts, it is out of our hands and we know it will continue and continue by calling itself until the <em>STOP</em> condition is satisfied. <strong>What if the users of our recursive function need some more control even after it gets started?</strong> </p>

<p>For example, say we provide our users <code>fib_rec</code> without source code, what if the users want to print out the detailed trace of each iteration? They are not able unless they ask us for the source code and make a new version with printing. It is not that convenient.</p>

<p>So if we don't want to give out our source code, somehow we need to reform our <code>fib_rec</code> a little bit and give the space to our users to insert whatever they want for each iteration. </p>

<pre><code class="ocaml">let rec fib_rec n =  
  if n &lt;= 1 then 1
  else fib_rec (n-1) + fib_rec (n-2)
</code></pre>

<p>Have a look at the above <code>fib_rec</code> carefully again, we can see that the logic of <code>fib_rec</code> is already determined during the binding, it is the <code>fib_rec</code>s inside that control the iteration. What if we rename the <code>fib_rec</code>s within the body to be <code>f</code> and add it as an argument?</p>

<pre><code class="ocaml">let fib_norec f n =  
  if n &lt;= 1 then 1
  else f (n-1) + f (n-2)

(* we actually should now change the name of fib_norec 
   to something like fib_alike_norec as it is not necessarily 
   doing fibonacci anymore, depending on f *)
</code></pre>

<p>So now <code>fib_norec</code> won't automatically repeat unless <code>f</code> tells it to. Moreover, <code>fib_norec</code> becomes a pattern which returns <code>1</code> when <code>n</code> is <code>&lt;= 1</code> otherwise <code>add</code> <code>f (n-1)</code> and <code>f (n-2)</code>. As long as you think this pattern is useful for you, you can inject your own logic into it by providing your own <code>f</code>.</p>

<p>Going back to the printing requirement, a user can now build its own version of <code>fib_rec_with_trace</code> like this:</p>

<pre><code class="ocaml">let rec fib_rec_with_trace n =  
  Printf.printf &quot;now fibbing %d\n&quot; n; 
  fib_norec fib_rec_with_trace n
</code></pre>

<blockquote>
  <p>Untying the recusive knot is a functional design pattern. It turns the recursive part inside the body into a new parameter <code>f</code>. In this  way, it breaks the iteration and turns a recursive function into a pattern where new or additional logic can be injected into via <code>f</code>. </p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/01/untie_f_rec.jpg" alt=""/></p>

<p>It is very easy to untie the knots for recusive functions. You just give an addition parameter <code>f</code> and replace <code>f_rec</code> everywhere inside with it. For example, for <code>quicksort</code>:</p>

<pre><code class="ocaml">let quicksort_norec f = function  
  | [] | _::[] as l -&gt; l
  | pivot::rest -&gt;
    let left, right = partition_fold pivot rest in
    f left @ (pivot::f right)

let rec quicksort l = quicksort_norec quicksort l  
</code></pre>

<p>There are more examples in <a href="http://martinsprogrammingblog.blogspot.co.uk/2012/07/untying-recursive-knot.html">Martin's blog</a>, though they are not in OCaml. A formalized description of this topic is in the article <em>Tricks with recursion: knots, modules and polymorphism</em> from <a href="http://www.ffconsultancy.com/products/ocaml_journal/?ob26">The OCaml Journal</a>. </p>

<p>Now let's come back to <em>recursive memoize</em> problem with our new weapon. </p>

<h1>Solve Recursive Memoize</h1>

<p>At first, we can require that every recursive function <code>f_rec</code> must be supplied to <code>memoize_rec</code> in the untied form <code>f_norec</code>. This is not a harsh requirement since it is easy to transform <code>f_rec</code> to <code>f_norec</code>.</p>

<p>Once we get <code>f_norec</code>, we of course cannot apply <code>memoize</code> (non-rec version) on it directly because <code>f_norec</code> now takes two parameters: <code>f</code> and <code>arg</code>. </p>

<p>Although we can create <code>f_rec</code> in the way of <code>let rec f_rec arg = f_norec f_rec arg</code>, we won't do it that straightforward here as it makes no sense to have an exactly the same recursive function. Instead, we can for now do something like <code>let f_rec_tmp arg = f_norec f arg</code>. </p>

<p>We still do not know what <code>f</code> will be, but <code>f_rec_tmp</code> is non-recursive and we can apply <code>memoize</code> on it: <code>let f_rec_tmp_memo = memoize f_tmp</code>.  </p>

<p><code>f_rec_tmp_memo</code> now have the logic of <code>f_norec</code> and the ability of memoization. If <code>f</code> can be <code>f_rec_tmp_memo</code>, then our problem is solved. This is because <code>f</code> is inside <code>f_norec</code> controlling the iteration and we wished it to be memoized.</p>

<p>The magic that can help us here is <strong>making <code>f</code> mutable</strong>. Because <code>f</code> needs to be known in prior and <code>f_rec_tmp_memo</code> is created after, we can temporarily define <code>f</code> as a trivial function and later on after we create <code>f_rec_tmp_memo</code>, we then change <code>f</code> to <code>f_rec_tmp_memo</code>. </p>

<p>Let's use a group of bindings to demonstrate:</p>

<pre><code class="ocaml">(* trivial initial function and it should not be ever applied in this state *)
let f = ref (fun _ -&gt; assert false)

let f_rec_tmp arg = f_norec !f arg

(* memoize is the simple non-rec version *)
let f_rec_tmp_memo = memoize f_rec_tmp

(* the later substitution made possible by being mutable *)
f := f_rec_tmp_memo
</code></pre>

<p>The final code for <code>memoize_rec</code> is:</p>

<pre><code class="ocaml">let memo_rec f_norec =  
  let f = ref (fun _ -&gt; assert false) in
  let f_rec_memo = memoize (fun x -&gt; f_norec !f x) in
  f := f_rec_memo;
  f_rec_memo
</code></pre>
