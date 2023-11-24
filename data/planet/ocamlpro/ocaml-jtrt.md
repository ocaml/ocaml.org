---
title: OCaml JTRT
description: 'This time of the year is, just like Christmas time, a time for laughs
  and magic... although the magic we are talking about, in the OCaml community, is
  not exactly nice, nor beautiful. Let''s say that we are somehow akin to many religions:
  we know magic does exist , but that it is satanic and shouldn''...'
url: https://ocamlpro.com/blog/2018_04_01_ocaml_jtrt
date: 2018-04-01T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    chambart\n  "
source:
---

<p>This time of the year is, just like Christmas time, a time for laughs and magic... although the magic we are talking about, in the OCaml community, is not exactly nice, nor beautiful. Let's say that we are somehow akin to many religions: we know magic <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Obj.html#VALmagic"><em>does</em> exist</a> , but that it is <a href="https://en.wikipedia.org/wiki/Religious_debates_over_the_Harry_Potter_series">satanic and shouldn't be introduced to children</a>.</p>
<h2>Introducing Just The Right Time (JTRT)</h2>
<p>Let me first introduce you to the concept of 'Just The Right Time' <a href="https://ocamlpro.com/blog/feed#footnote1">[1]</a>. JTRT is somehow a 'Just In Time' compiler, but one that runs at <em>the</em> right time, not at some random moment decided by a contrived heuristic.</p>
<p>How does the compiler know when that specific good moment occurs? Well, he doesn't, and that's the point: you certainly know far better. In the OCaml world, we like good performances, like any other, but we prefer predictable ones to performances that may sometimes be awesome, and sometimes really slow. And we are ready to trade off some annotations for better predictability (<em>or is it just me trying to give the impression that my opinion is everyone's opinion...</em>). Don't forget that OCaml is a compiled language; hence the average generated code is good enough. Runtime compilation only matters for some subtle situations where a patterns gets repeated a lot, and you don't know about that pattern before receiving some inputs.</p>
<p>Of course the tradeoff wouldn't be the same in Javascript if you had to write something like that to get your code to perform decently.</p>
<pre><code class="language-javascript">function fact(n) {
   &quot;compile this&quot;;
   if (n == 0) {
      &quot;compile this too&quot;;
      return 1
   } else {
      &quot;Yes, I really want to compile that&quot;;
      return (n * fact(n - 1););
   }
 }
</code></pre>
<h2>The magical <code>this_is_the_right_time</code> function</h2>
<p>There are already nice tools for doing that in OCaml. In particular, you should look at metaocaml, which is an extension of the language that has been maintained for years. But it requires you to think a bit about what your program is doing and add a few types, here and there.</p>
<p>Fortunately, today is the day you may want to try this ugly weekend hack instead.</p>
<p>To add a bit of context, let's say there are 1/ the Dirty Little Tricks, and 2/ the Other Kind of Ugly Hacks. We are presenting one of the latter; the kind of hacks for which you are both ashamed <em>and</em> a bit proud (but you should really be a lot more ashamed). I've made quite a few of those, and this one would probably rank well among the top 5 (and I'm deeply sorry about the other ones that are still in production somewhere...).</p>
<p>This is composed of two parts: a small compiler patch, and a runtime library. That library only exposes the following single function:</p>
<pre><code class="language-ocaml">val this_is_the_right_time : 'a -&gt; 'a
</code></pre>
<p>Let's take an example:</p>
<pre><code class="language-ocaml">let f x =
  let y = x + x in
  let g z = z * y in
  g

let multiply_by_six = f 3
</code></pre>
<p>You can 'optimize' it by changing it to:</p>
<pre><code class="language-ocaml">let f x =
  let y = x + x in
  let g z = z * y in
  g

let multiply_by_six = this_is_the_right_time (f 3)
</code></pre>
<p>That's all. By stating that this is the right time, you told the compiler to take that function and do its magic on it.</p>
<h2>How <em>the f</em><em>k</em> does that work?!</h2>
<p>The compiler patch is quite simple. It adds to every function some annotation to allow the compiler to know enough things about it. (It is annotated with its representation in the Flambda IR.) This is just a partial dump of the compiler memory state when transforming the Flambda IR to clambda. I tried to do it in some more 'disciplined' way (it used some magic to traverse the compiler internal memory representation to create a static version of it in the binary), but 'ld' was not so happy linking a ~500MB binary. So I went the 'marshal' way.</p>
<p>This now means that at runtime the program can find the representation of the closures. To give an example of the kind of code you really shouldn't write, here is the magic invocation to retrieve that representation:</p>
<pre><code class="language-ocaml">let extract_representation_from_closure (value:'a)
                                 : Flambda.set_of_closures =
   let obj = Obj.repr value in
   let size = Obj.size obj in
   let id = Obj.obj (Obj.field obj (size - 2)) in
   let marshalled = Obj.field obj (size - 1) in
   (Marshal.from_string marshalled 0).(id)
</code></pre>
<p>With that, we now know the layout of the closure and we can extract all the variables that it binds. We can further inspect the value of those bound variables, and build an IR representation for them. That's the nice thing about having an untyped IR, you can produce some even when you lost the types. It will just probably be quite wrong, but who cares...</p>
<p>Now that we know everything about our closure, we can rebuild it, and so will we. As we can't statically build a non-closed function (the flambda IR happens after closure conversion), we will instead build a closed function that allocates the closure for us. For our example, it would look like this:</p>
<pre><code class="language-ocaml">let build_my_closure previous_version_of_the_closure =
   let closure_field_y = previous_version_of_the_closure.y in
   fun z -&gt; z * 6 (* closure_field_y * closure_field_y *)
</code></pre>
<p>In that case the function that we are building is closed, so we don't need the old closure to extract its field. But this shows the generic pattern. This would be used like that:</p>
<pre><code class="language-ocaml">let this_is_the_right_time optimize_this =
   let ir_version = extract_representation_from_closure optimize_this in
   let build_my_closure = magic_building_function ir_version in
   build_my_closure optimize_this
</code></pre>
<p>I won't go too much into the details of the <code>magic_building_function</code>, because it would be quite tedious. Let's just say that it is using mechanisms provided for the native toplevel of OCaml.</p>
<h2>A more sensible example</h2>
<p>To finish on something a bit more interesting than <code>time_6</code>, let's suppose that we designed a super nice language whose AST and evaluator are:</p>
<pre><code class="language-ocaml">type expr =
 | Add of expr * expr
 | Const of int
 | Var

let rec eval_expr expr x =
  match expr with
  | Add (e1, e2) -&gt; eval_expr e1 x + eval_expr e2 x
  | Const i -&gt; i
  | Var -&gt; x
</code></pre>
<p>But we want to optimize it a bit, and hence wrote a super powerful pass:</p>
<pre><code class="language-ocaml">let rec optimize expr =
   match expr with
   | Add (Const n1, Add (e, Const n2)) -&gt; Add (Const (n1 + n2), optimize e)
   | Add (e1, e2) -&gt; Add (optimize e1, optimize e2)
   | _ -&gt; expr
</code></pre>
<p>The user writes some expression, that gets parsed to <code>Add (Const 11, Add (Var, Const 22))</code>, it goes through optimizing and results in <code>Add (Const 33, Var)</code>. Then you find that this looks like <em>the right time</em>.</p>
<pre><code class="language-ocaml">let optimized =
  this_is_the_right_time
    (fun x -&gt; (eval_expr (optimize user_ast) x))
</code></pre>
<p>Annnnd... nothing happens. The reason being that there is no way to distinguish between mutable and immutable values at runtime, hence the safe assumption is to assume that everything is mutable, which limits optimizations a lot. So let's enable the 'special' mode:</p>
<pre><code class="language-ocaml">incorrect_mode := true
</code></pre>
<p>And MAGIC happens! The code that gets spitted out is exactly what we want (that is <code>fun x -&gt; 33 + x</code>).</p>
<h2>Conclusion</h2>
<p>Just so that you know, I don't really recommend using it. It's buggy, and many details are left unresolved (I suspect that the names you would come up for that kind of <em>details</em> would often sound like 'segfault'). Flambda was not designed to be used that way. In particular, there are some invariants that must be maintained, like the uniqueness of variables and functions... that we completely disregarded. That lead to some 'funny' behaviors (like <code>power 2 8</code> returning <code>512</code>...). It is possible to do that correctly, but that would require far more than a few hours' hacking. This might be a lot easier with the upcoming version of Flambda.</p>
<p>So this is far from ready, and it's not going to be anytime soon (<em>supposing that this is a good idea, which I'm still not convinced it is</em>).</p>
<p>But if you still want to play with it: <a href="https://github.com/chambart/ocaml-1/tree/flambda_jit">the sources are available.</a></p>
<hr/>
<p><span>[1]</span> Not that it exists in real-world.</p>

