---
title: 'Flambda2 Ep. 2: Loopifying Tail-Recursive Functions'
description: Welcome to a new episode of The Flambda2 Snippets! Today's topic is Loopify,
  one of Flambda2's many optimisation algorithms which specifically deals with optimising
  both purely tail-recursive and/or functions annotated with the [@@loop] attribute
  in OCaml. A lazy explanation for its utility would be...
url: https://ocamlpro.com/blog/2024_05_07_the_flambda2_snippets_2
date: 2024-05-07T12:13:29-00:00
preview_image: https://www.ocamlpro.com/blog/assets/img/F2S_loopify_figure.png
authors:
- "\n    Nathana\xEBlle Courant\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/F2S_loopify_figure.png">
      <img src="https://ocamlpro.com/blog/assets/img/F2S_loopify_figure.png" alt="Two camels are taking a break from crossing the desert, they know their path could not have been more optimised."/>
    </a>
    </p><div class="caption">
      Two camels are taking a break from crossing the desert, they know their path could not have been more optimised.
    </div>
  
</div>

<h3>Welcome to a new episode of <strong>The Flambda2 Snippets</strong>!</h3>
<p>Today's topic is <code>Loopify</code>, one of <code>Flambda2</code>'s many optimisation algorithms
which specifically deals with optimising both <em>purely tail-recursive</em> and/or
functions <em>annotated</em> with the <code>[@@loop]</code> attribute in OCaml.</p>
<p>A lazy explanation for its utility would be to say that it simply aims at
reducing the number of memory allocations in the context of <em>recursive</em> and
<em>tail-recursive</em> function calls in OCaml. However, we will see that is just
<strong>part</strong> of the point and thus we will tend to address the broader context:
what are <em>tail-calls</em>, how they are optimised and how they fit in the
functional programming world, what dilemma does <code>Loopify</code> nullify exactly and,
in time, many details on how it's all implemented!</p>
<p>If you happen to be stumbling upon this article and wish to get a bird's-eye
view of the entire <strong>F2S</strong> series, be sure to refer to <a href="https://ocamlpro.com/blog/2024_03_18_the_flambda2_snippets_0">Episode
0</a> which does a good amount of
contextualising as well as summarising of, and pointing to, all subsequent
episodes.</p>
<p><strong>All feedback is welcome, thank you for staying tuned and happy reading!</strong></p>
<blockquote>
<p>The <strong>F2S</strong> blog posts aim at gradually introducing the world to the
inner-workings of a complex piece of software engineering: The <code>Flambda2 Optimising Compiler</code>, a technical marvel born from a 10 year-long effort in
Research &amp; Development and Compilation; with many more years of expertise in
all aspects of Computer Science and Formal Methods.</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#tco">Tail-Call Optimisation</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#tailcallsinocaml">Tail-Calls in OCaml</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conundrum">The Conundrum of Reducing allocations Versus Writing Clean Code</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#loopify">Loopify</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#concept">Concept</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#toloopifyornottoloopify">Deciding to Loopify or not</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#thetransformation">The nature of the transformation</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#tco" class="anchor-link">Tail-Call Optimisation</a>
          </h2>
<p>As far as we know, Tail-Call optimisation (TCO) has been a reality since at
least the 70s. Some LISP implementations used it and Scheme specified it into
its language around 1975.</p>
<p>The debate to support TCO happens regularly today still. Nowadays, it's a given
that most functional languages support it (Scala, OCaml, Haskell, Scheme and so
on...). Other languages and compilers have supported it for some time too.
Either optionally, with some C compilers (gcc and clang) that support TCO in
some specific compilation scenarios; or systematically, like Lua, which, despite
not usually being considered a functional language, specifies that TCO occurs
whenever possible (<a href="https://www.lua.org/manual/5.3/manual.html#3.4.10">you may want to read section 3.4.10 of the Lua manual
here</a>).</p>
<p><strong>So what exactly is Tail-Call Optimisation ?</strong></p>
<p>A place to start would be the <a href="https://en.wikipedia.org/wiki/Tail-call_optimisation">Wikipedia
page</a>. You may also find
some precious insight about the link between the semantics of <code>GOTO</code> and tail
calls <a href="https://www.college-de-france.fr/fr/agenda/cours/structures-de-controle-de-goto-aux-effets-algebriques/programmer-ses-structures-de-controle-continuations-et-operateurs-de-controle">here</a>,
a course from Xavier Leroy at the <em>College de France</em>, which is in French.</p>
<p>Additionally to these resources, here are images to help you visualise how TCO
improves stack memory consumption. Assume that <code>g</code> is a recursive function
called from <code>f</code>:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/F2S_2_stack_no_tail_rec_call.svg">
      <img src="https://ocamlpro.com/blog/assets/img/F2S_2_stack_no_tail_rec_call.svg" alt="A representation of the textbook behaviour for recursive functions stackframe allocations. You can see here that the stackframes of non-tail-recursive functions are allocated sequentially on decreasing memory addresses which may eventually lead to a stack overflow."/>
    </a>
    </p><div class="caption">
      A representation of the textbook behaviour for recursive functions stackframe allocations. You can see here that the stackframes of non-tail-recursive functions are allocated sequentially on decreasing memory addresses which may eventually lead to a stack overflow.
    </div>
  
</div>

<p>Now, let's consider a tail-recursive implementation of the <code>g</code> function in a
context where TCO is <strong>not</strong> supported. Tail-recursion means that the last
thing <code>t_rec_g</code> does before returning is calling itself. The key is that we
still have a frame for the caller version of <code>t_rec_g</code> but we know that it will
only be used to return to the parent. The frame itself no longer holds any
relevant information besides the return address and thus the corresponding memory
space is therefore mostly wasted.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/F2S_2_stack_tail_rec_call_no_tco.svg">
      <img src="https://ocamlpro.com/blog/assets/img/F2S_2_stack_tail_rec_call_no_tco.svg" alt="A representation of the textbook behaviour for tail-recursive functions stackframe allocations without Tail Call Optimisation (TCO). When TCO is not implemented the behaviour for these allocations and the potential for a stack overflow are the same as with non-tail-recursive functions."/>
    </a>
    </p><div class="caption">
      A representation of the textbook behaviour for tail-recursive functions stackframe allocations without Tail Call Optimisation (TCO). When TCO is not implemented the behaviour for these allocations and the potential for a stack overflow are the same as with non-tail-recursive functions.
    </div>
  
</div>

<p>And finally, let us look at the same function in a context where TCO <strong>is</strong>
supported. It is now apparent that memory consumption is much improved by the
fact that we reuse the space from the previous stackframe to allocate the next
one all the while preserving its return address:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/F2S_2_stack_tail_rec_call_tco.svg">
      <img src="https://ocamlpro.com/blog/assets/img/F2S_2_stack_tail_rec_call_tco.svg" alt="A representation of the textbook behaviour for tail-recursive functions stackframe allocations with TCO. Since TCO is implemented, we can see that the stack memory consumption is now constant, and that the potential that this specific tail-recursive function will lead to a stack overflow is diminished."/>
    </a>
    </p><div class="caption">
      A representation of the textbook behaviour for tail-recursive functions stackframe allocations with TCO. Since TCO is implemented, we can see that the stack memory consumption is now constant, and that the potential that this specific tail-recursive function will lead to a stack overflow is diminished.
    </div>
  
</div>

<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#tailcallsinocaml" class="anchor-link">Tail-Calls in OCaml</a>
          </h3>
<p>The <code>List</code> data structure is fundamental to and ubiquitous in functional
programming. Therefore, it's important to not have an arbitrary limit on the
size of lists that one can manipulate. Indeed, most <code>List</code> manipulation functions
are naturally expressed as recursive functions, and can most of the time be
implemented as tail-recursive functions. Without guaranteed TCO, a programmer
could not have the assurance that their program would not stack overflow at
some point. That reasoning also applies to a lot of other recursive data
structures that commonly occur in programs or libraries.</p>
<p>In OCaml, TCO is guaranteed. Ever since its inception, Cameleers have
unanimously agreed to guarantee the optimisation of tail-calls.
While the compiler's support for TCO has been a thing from the beginning,
<a href="https://v2.ocaml.org/manual/attributes.html#ss:builtin-attributes">an attribute</a>,
<code>[@tailcall]</code> was later added to help users ensure that their calls are in tail
position.</p>
<p>Recently, TCO was also extended with the <a href="https://v2.ocaml.org/manual/tail_mod_cons.html"><code>Tail Mod Cons</code>
optimisation</a> which allows to
generate tail-calls in more cases.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conundrum" class="anchor-link">The Conundrum of Reducing Allocations Versus Writing Clean Code</a>
          </h3>
<p>One would find one of the main purposes for the existence of <code>Loopify</code> in the
following conversation: a Discuss Post about <a href="https://discuss.ocaml.org/t/how-to-speed-up-this-function/10286">the unboxing of floating-point
values in
OCaml</a> and
performance.</p>
<p><a href="https://discuss.ocaml.org/t/how-to-speed-up-this-function/10286/9">This specific
comment</a>
sparks a secondary conversation that you may want to read yourself but will
find a quick breakdown of below and that will be a nice starting point to
understand today's subject.</p>
<p>Consider the following code:</p>
<pre><code class="language-ocaml">let sum l =
  let rec loop s l =
    match l with
    | [] -&gt; s
    | hd :: tl -&gt;
      (* This allocates a boxed float *)
      let s = s +. hd in
      loop s tl 
  in
  loop 0. l
</code></pre>
<p>This is a simple tail-recursive implementation of a <code>sum</code> function for a list of
floating-point numbers. However this is not as efficient as we would like it to
be.</p>
<p>Indeed, OCaml needs an uniform representation of its values in order to
implement polymorphic functions. In the case of floating-point numbers this
means that the numbers are boxed whenever they need to be used as generic
values.</p>
<p>Besides, everytime we call a function all parameters have to be considered as
generic values. We thus cannot avoid their allocation at each recursive call in
this function.</p>
<p>If we were to optimise it in order to get every last bit of performance out of
it, we could try something like:</p>
<p><strong>Warning: The following was coded by trained professionnals, do NOT try this at home.</strong></p>
<pre><code class="language-ocaml">let sum l = 
  (* Local references *)
  let s = ref 0. in
  let cur = ref l in
  try
    while true do
      match !cur with
      | [] -&gt; raise Exit
      | hd :: tl -&gt;
        (* Unboxed floats -&gt; No allocation *)
        s := !s +. hd;
        cur := tl
    done; assert false
  with Exit -&gt; !s (* The only allocation *)
</code></pre>
<p>While in general references introduce one allocation and a layer of indirection,
when the compiler can prove that a reference is strictly local to a given function
it will use mutable variables instead of reference cells.</p>
<p>In our case <code>s</code> and <code>cur</code> do not escape the function and are therefore eligible
to this optimisation.</p>
<p>After this optimisation, <code>s</code> is now a mutable variable of type <code>float</code> and so it
can also trigger another optimisation: <em>float unboxing</em>.</p>
<p>You can see more details
<a href="https://www.lexifi.com/blog/ocaml/unboxed-floats-ocaml/#">here</a> but note that,
in this specific example, all occurrences of boxing operations disappear except
a single one at the end of the function.</p>
<p><strong>We like to think that not forcing the user to write such code is a benefit, to
say the least.</strong></p>
<hr/>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#loopify" class="anchor-link">Loopify</a>
          </h2>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#concept" class="anchor-link">Concept</a>
          </h3>
<p>There is a general concept of transforming function-level control-flow into
direct <strong>IR</strong> continuations to benefit from &quot;basic block-level&quot; optimisations. One
such pattern is present in the local-function optimisation triggered by the
<code>[@local]</code> attribute. <a href="https://github.com/ocaml/ocaml/pull/2143">Here's the link to the PR that implements
it</a>. <code>Loopify</code> is an attempt to
extend the range of this kind of optimisation to proper (meaning <code>self</code>)
tail-recursive calls.</p>
<p>As you saw previously, in some cases (e.g.: numerical calculus), recursive
functions sometimes hurt performances because they introduce some allocations.</p>
<p>That lost performance can be recovered by hand-writing loops using local
references however it's unfortunate to encourage non-functional code in a
language such as OCaml.</p>
<p>One of <code>Flambda</code> and <code>Flambda2</code>'s goals is to avoid situations such as those and
allow for good-looking, functional code, to be as performant as code which is
written and optimised by hand at the user-level.</p>
<p>Therefore, we introduce a solution to the specific problem described above with
<code>Loopify</code>, which, in a nutshell, transforms tail-recursive functions into
non-recursive functions containing a loop, hence the name.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#toloopifyornottoloopify" class="anchor-link">Deciding to Loopify or not</a>
          </h3>
<p>The decision to loopify a given function is made during the conversion from the
<code>Lambda</code> <strong>IR</strong> to the <code>Flambda2</code> <strong>IR</strong>. The conversion is triggered in two cases:</p>
<ul>
<li>when a function is purely tail-recursive -- meaning all its uses within its
body are <code>self-tail</code> calls, they are called <em>proper calls</em>;
</li>
<li>when an annotation is given by the user in the source code using the
<code>[@loop]</code> attribute;
</li>
</ul>
<p>Let's see two examples for them:</p>
<pre><code class="language-ocaml">(* Not a tail-rec function: is not loopified *)
let rec map f = function
  | [] -&gt; []
  | x :: r -&gt; f x :: map f r

(* Is tail-rec: is loopified *)
let rec fold_left f acc = function
  | [] -&gt; acc
  | x :: r -&gt; fold_left f (f acc x) r
</code></pre>
<p>Here, the decision to <code>loopify</code> is automatic and requires no input from the
user. Quite straightforward.</p>
<hr/>
<p>Onto the second case now:</p>
<pre><code class="language-ocaml">(* Helper function, not recursive, nothing to do. *)
let log dbg f arg =
  if dbg then
    print_endline &quot;Logging...&quot;;
  f arg
[@@inline]

(* 
  Not tail-rec in the source, but may become
  tail-rec after inlining of the [log] function.
  At this point we can loopify, provided that the
  user specified a [@@loop] attribute.
*)
let rec iter_with_log dbg f = function
  | [] -&gt; ()
  | x :: r -&gt;
    f x;
    log dbg (iter_with_log dbg f) r
[@@loop]
</code></pre>
<p>The recursive function <code>iter_with_log</code>, is not initially purely tail-recursive.</p>
<p>However after the inlining of the <code>log</code> function and then simplification, the new
code for <code>iter_with_log</code> becomes purely tail-recursive.</p>
<p>At that point we have the ability to <code>loopify</code> the function, but we keep from
doing so unless the user specifies the <code>[@@loop]</code> attribute on the function definition.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#thetransformation" class="anchor-link">The nature of the transformation</a>
          </h3>
<p>Onto the details of the transformation.</p>
<p>First, we introduce a recursive continuation at the start of the function. Lets
call it <code>self</code>.</p>
<p>Then, at each tail-recursive call, we replace the function call with a
continuation call to <code>self</code> with the same arguments as the original call.</p>
<pre><code class="language-ocaml">let rec iter_with_log dbg f l =
  let_cont rec k_self dbg f l =
    match l with
    | [] -&gt; ()
    | x :: r -&gt;
      f x;
      log dbg (iter_with_log dbg f) r
  in
  apply_cont k_self (dbg, f, l)
</code></pre>
<p>Then, we inline the <code>log</code> function:</p>
<pre><code class="language-ocaml">let rec iter_with_log dbg f l =
  let_cont k_self dbg f l =
    match l with
    | [] -&gt; ()
    | x :: r -&gt;
      f x;
      (* Here the inlined code starts *)
      (*
        We first start by binding the arguments of the
        original call to the parameters of the function's code
       *)
      let dbg = dbg in
      let f = iter_with_log dbg f in
      let arg = r in
      if dbg then
        print_endline &quot;Logging...&quot;;
      f arg
  in
  apply_cont k_self (dbg, f, l)
</code></pre>
<p>Then, we discover a <em>proper</em> tail-recursive call subsequently to these
transformations that we replace with the adequate continuation call.</p>
<pre><code class="language-ocaml">let rec iter_with_log dbg f l =
  let_cont k_self dbg f l =
    match l with
    | [] -&gt; ()
    | x :: r -&gt;
      f x;
      (* Here the inlined code starts *)
      (*
        Here, the let bindings have been substituted
        by the simplification.
       *)
      if dbg then
        print_endline &quot;Logging...&quot;;
      apply_cont k_self (dbg, f, l)
  in
  apply_cont k_self (dbg, f, l)
</code></pre>
<p>In this context, the benefit of transforming a function call to a continuation
call is mainly about allowing other optimisations to take place. As shown
in the previous section, one of these optimisations is <code>unboxing</code> which can be
important in some cases like numerical calculus. Such optimisations can take
place because continuations allow more freedom than function calls which must
respect the OCaml calling conventions.</p>
<p>One could think that a continuation call is intrinsically cheaper than a
function call. However, the OCaml compiler already optimises self-tail-calls
such that they are already as cheap as continuation calls (i.e, a single <code>jump</code>
instruction).</p>
<p>An astute reader could realise that this transformation can apply to any
function and will result in one of three outcomes:</p>
<ul>
<li>if the function is not tail-recursive, or even not recursive at all, nothing
will happen, the transformation does nothing.
</li>
<li>if a function is purely tail-recursive then all recursive calls will be
replaced to a continuation call and the function after optimisation will no
longer be recursive. This allows us to later inline it and even specialise
some of its arguments. This happens precisely when we automatically decide to
loopify a function;
</li>
<li>if a function is not purely tail-recursive, but contains some tail-recursive
calls then the transformation will rewrite those calls but not the other
ones. This may result in better code but it's hard to be sure in advance. In
such cases (and cases where functions become purely tail-recursive only after
<code>inlining</code>), users can force the transformation by using the <code>[@@loop]</code>
attribute
</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h2>
<p>Here it is, the concept behind the <code>Loopify</code> optimisation pass as well as the
general context and philosophy which led to its inception!</p>
<p>It should be clear enough now that having to choose between writing clean <strong>or</strong>
efficient code was always unsatisfactory to us. With <code>Loopify</code>, as well as with
the rest of the <code>Flambda</code> and <code>Flambda2</code> compiler backends, we aim at making
sure that users should <strong>not</strong> have to write imperative code for it to be as
efficient as functional code. Thus ideally making any which way of writing a
piece of code as efficient as the next.</p>
<p>This article describes one of the very first user-facing optimisations of this
series of snippets on <code>Flambda2</code>. We have not gotten into any of the neat
implementation details yet. This is a topic for another time. The functioning
of <code>Loopify</code> will be much clearer next time we talk about it.</p>
<p><code>Loopify</code> is only applied automatically when the tail-recursive nature of a
function call is visible in the source from the get-go. However, the
optimisations applied by <code>Loopify</code> can still very much be useful in other
situations as seen in <a href="https://ocamlpro.com/blog/feed#toloopifyornottoloopify">this section</a>. That is why we
have the <code>[@loop]</code> attribute in order to enforce <em>loopification</em>. Good canonical
examples for applying <code>Loopify</code> with the <code>[@loop]</code> attribute would be either of
the following: loopifying a partially tail-recursive function (i.e, a function
with only <em>some</em> tail-recursive paths), or for functions which are not
obviously tail-recursive in the source code, but could become so after some
optimisation steps.</p>
<p>This transformation illustrates a core principle behind the <code>Flambda2</code> design:
applying a somewhat na&iuml;ve optimisation that is not transformative by itself,
but changes the way the compiler can look at the code and trigger a whole lot
of other useful ones. Conversely, it being triggered in the middle of the
inlining phase can allow some non-obvious cases to become radically better.
Coding a single optimisation that would discover the cases demonstrated in the
examples above would be quite complex, while this one is rather simple thanks
to these principles.</p>
<p>Throughout the entire series of snippets, we will continue seeing these
principles in action, starting with the next blog post that will introduce
<code>Downward and Upward Traversals</code>.</p>
<p><strong>Stay tuned, and thank you for reading, until next time, <em>see you Space
Cowboy</em>. <a href="https://fr.wikipedia.org/wiki/Cowboy_Bebop">&#129312;</a></strong></p>
</div>
