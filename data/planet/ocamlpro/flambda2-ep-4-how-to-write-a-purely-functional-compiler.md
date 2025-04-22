---
title: 'Flambda2 Ep. 4: How to write a purely functional compiler'
description: Welcome to a new episode of The Flambda2 Snippets! Today, we will cover
  key high-level aspects of the algorithm of Flambda2. We will do our best to explain
  the fundamental design decisions pertaining to the architecture of the compiler.
  We will touch on how we managed to make a purely functional opt...
url: https://ocamlpro.com/blog/2025_02_19_the_flambda2_snippets_4
date: 2025-02-19T08:24:40-00:00
preview_image: https://www.ocamlpro.com/blog/assets/img/F2S_picture_son_doong_cave.jpg
authors:
- "\n    Pierre Chambart\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/F2S_picture_son_doong_cave.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/F2S_picture_son_doong_cave.jpg" alt="As we dive deeper into the Flambda2 Optimising Compiler, who knows what marvels might await us. Picture: Son Doong Cave (Vietnam). Credit: Collected.">
    </a>
    </p><div class="caption">
      As we dive deeper into the Flambda2 Optimising Compiler, who knows what marvels might await us. Picture: Son Doong Cave (Vietnam). Credit: Collected.
    </div>
  <p></p>
</div>
<p></p>
<h3>Welcome to a new episode of The Flambda2 Snippets!</h3>
<p>Today, we will cover key high-level aspects of the algorithm of <code>Flambda2</code>. We
will do our best to explain the <a href="https://ocamlpro.com/blog/2024_03_19_the_flambda2_snippets_1/">fundamental design
decisions</a>
pertaining to the architecture of the compiler. We will touch on how we managed
to make a <strong>purely</strong> functional optimising compiler (leveraging
<a href="https://ocamlpro.com/blog/2024_05_07_the_flambda2_snippets_2/#tco">tail-recursion</a>,
backtracking, and non-linear traversal) by covering how the code is traversed,
what actions this design facilitates, and more!</p>
<p><strong>All feedback is welcome, thank you for staying tuned and happy reading!</strong></p>
<blockquote>
<p>The <strong>F2S</strong> blog posts aim at gradually introducing the world to the
inner-workings of a complex piece of software engineering: The <code>Flambda2 Optimising Compiler</code> for OCaml, a technical marvel born from a 10 year-long
effort in Research &amp; Development and Compilation; with many more years of
expertise in all aspects of Computer Science and Formal Methods.</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong><p></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#exprtraversal">Expression traversal</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#traversalsoverview">Overview of the traversal</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#downwardtraversal">Downward traversal</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#let_val">Let_val</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#let_cont">Let_cont</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#apply_cont">Apply_cont</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#apply_val">Apply_val</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#upwardtraversal">Upward traversal</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#uenv">Upward environment</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#deadcodeelimination">Dead code elimination</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>
</li>
</ul>
<p></p></div><p></p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#exprtraversal" class="anchor-link">Expression traversal</a>
          </h2>
<p>Here's a code snippet we would like to be able to optimise and that
demonstrates a set of properties that we want our code optimiser to have.</p>
<pre><code class="language-ocaml">(* original code *)
let bar x =
  let d = x + x
  let y = x, d in
  y

let foo z =
  let x, d = bar z in
  if x = z then x + 1 else d
</code></pre>
<p>We will optimise this code to :</p>
<pre><code class="language-ocaml">let foo z =
  z + 1
</code></pre>
<p>And we will do that in a <strong>single pass</strong> that is both <strong>efficient</strong> and <strong>maintainable</strong>.</p>
<p>Here are the key transformations we would like to apply to this codeblock:</p>
<ul>
<li>the first element of the pair returned by the <code>bar</code> function is an alias
to the <code>z</code> argument of <code>foo</code>, thus the <code>if</code> condition in <code>foo</code>
always evaluates to <code>true</code>.
</li>
<li>That means that the <code>d</code> variable is never used, since the <code>else</code> branch in
<code>foo</code> is never executed.
</li>
</ul>
<p>That being said, to discover the aliased values <code>x</code> and <code>z</code>, we have to
follow the <code>z</code> variable from <code>foo</code> to <code>bar</code> and back again. And to
discover that the <code>let d = x + x</code> is unused in <code>bar</code> we have to know about
the alias and then go back from the <code>d</code> used in <code>foo</code> to the <code>let</code> in
<code>bar</code>. The point is, there is a complex order of dependencies between
these properties that we have to follow in order to learn about the code.</p>
<p>Keep in mind that we aim for our compiler to remain reasonably fast. In
order to do that, we conduct all code transformations at the same time as the
analysis. This entails that we cannot just plug a constraint solver inside
of <code>Flambda2</code> in order to discover these properties.</p>
<p>You have to understand that there are two kinds of properties that we want to
track.
One of them, like discovering that the <code>if</code> condition always evaluates
to <code>true</code>, flows in the order of evaluation, i.e: top-down. While the others,
like finding <em>dead code</em>, like <code>let d = x + x</code>, and thus eliminating it, can
only be done in the reverse order of the evaluation, i.e: bottom-up.</p>
<blockquote>
<p>Interesting detail: properties of the first category, sometimes help discover
properties from the second, like in that specific example, but never the
other way round.</p>
</blockquote>
<p>And now, we will explain, how we have designed <code>Flambda2</code> to be able to operate
within these constraints while transforming the code at the same time.</p>
<pre><code class="language-ocaml">(*
  CPS-converted version
  Same code as before in the FL2 IR.
  All variables with names starting with `k` are continuations.
*)
let bar x k_ret =
  let d = x + x in
  apply_cont k_ret x d

let foo z k_ret =
  let_cont k x d =
    let r = x + 1 in
    if x = z then
      apply_cont k_ret r
    else
      apply_cont k_ret d
  in
  apply bar z k
</code></pre>
<p>If you recall our <a href="http://localhost:8888/blog/2024_03_19_the_flambda2_snippets_1">very first F2S
snippet</a>, we
mentioned one of the fundamental design decisions of <code>Flambda2</code> which consists
in representing programs <a href="https://ocamlpro.com/blog/2024_03_19_the_flambda2_snippets_1/#cps">using
CPS</a>. One of
the main reasons for that is that inlining becomes very simple.</p>
<p><strong>But there's a catch…</strong></p>
<p>If you refer back to the original version of the CPS-converted codeblock above,
you will see that <code>if x = z then x + 1 else d</code> is <strong>inside</strong> the scope of the
the <code>bar</code> function call. It's no longer the case once the function
has been converted to CPS. This shrinking of the scope, is inherent to CPS
representation. In an expression language, value analysis can simply be written
as a recursive function on expressions, propagating properties through an
environment. That is how the simplification pass was written on our previous <strong>IR</strong> <code>Flambda1</code>. It did
produce some imprecisions here and there, but the trade-off in code simplicity
favoured this route rather than the one we have taken with <code>Flambda2</code> today.</p>
<p>In direct-style language representations, traversals in the order of evaluation
may be roughly emulated by simply traversing the tree recursively. On the other
hand, in CPS-style language representations, this doesn't hold.</p>
<p>That's the catch: <strong>analysing CPS code entails more complex algorithms</strong>.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#traversalsoverview" class="anchor-link">Overview of the traversal</a>
          </h2>
<p><strong>Reasoning about code requires having a specific kind of data structure.</strong></p>
<p>This data structure must behave like a kind of database of properties of
expressions, we naturally attach a name to each expression, and the data
structure itself keeps track of the properties related to them. This data
structure will be named <code>acc</code> in the following code blocks (short for
<em>accumulator</em>).</p>
<p>A design decision we made early was that we wanted to traverse the code only
once while doing the maximum amount of simplifications. Of course, there are
exceptions to this rule but that’s a topic for another time.</p>
<p>Experience gained from designing <code>Flambda1</code> guided this decision. In practice,
this overarching traversal manifests itself as two distinct passes: one
downwards and one upwards. <strong>The downwards pass performs static analysis and
inlining, while the upwards one handles code reconstruction and dead code
elimination, we call this whole process "Simplify"</strong>.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#downwardtraversal" class="anchor-link">Downward traversal</a>
          </h2>
<p>As mentioned in
<a href="https://ocamlpro.com/blog/2024_03_19_the_flambda2_snippets_1/#term">F2S1</a>, the
FL2 AST is simple and represented with only 6 different cases. You can find it
again below:</p>
<pre><code class="language-ocaml">type expr =
  | Let_val of { var; prim; body : expr }
  | Let_cont of { k; param; handler : expr ; body : expr }
  | Apply_cont of { k; arg }
  | Apply_val of { f; k_return; arg }
  | Switch of { arg; cases }
  | Invalid
</code></pre>
<p>We are going to cover each of these cases separately and explain how each behave
and their role in how they help us reason about the code. Then, once all that is
clear, we will explain how we traverse each constructor. This should help you
understand what information we accumulate during both passes, and what
exactly we can do with them.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#let_val" class="anchor-link">Let_val</a>
          </h3>
<pre><code class="language-ocaml">type expr =
  | Let_val of
	{
	  var : variable ;
	  prim : named ;
	  body : expr ;
	}
[…]
</code></pre>
<h4>Overview and semantics:</h4>
<p>The <code>Let_val</code> constructor evaluates a <code>named</code> primitive, and binds it to a
<code>variable</code> inside the <code>body</code> and then evaluates that <code>body</code>. A <code>named</code>
primitive is a single atomic operation applied to some <code>variable</code>s. Primitives
have no impact on control flow, for instance they cannot raise exceptions.</p>
<h4>Traversal algorithm:</h4>
<p>This is the easy case, we just follow the evaluation order above. We analyse
the <code>named</code> primitive, extend the <code>acc</code> data structure with the discovered
properties, and proceed with analysing the body using the new <code>acc</code>.</p>
<p>The most important thing about this process on the way down is <em>this specific
extension</em> of the <code>acc</code> data structure. Most other constructors will pipe the
<code>acc</code> smartly all along the computation rather than extending it.</p>
<h4>Additional details:</h4>
<p>One interesting thing to note: we can discover properties on the arguments of
the primitive and not only on the bound <code>variable</code>. For example, the primitive
that reads the field of a value allows us to discover that the argument is a
block where that field exists in the current <code>acc</code>.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#let_cont" class="anchor-link">Let_cont</a>
          </h3>
<pre><code class="language-ocaml">type expr =
  | Let_cont of
	{
	  body : expr;
	  k : continuation;
	  params : variable list;
	  handler : expr;
	}
[…]
</code></pre>
<h4>Overview and semantics:</h4>
<p>The <code>Let_cont</code> constructor evaluates <code>body</code>. <code>body</code> is allowed to refer
to the <code>k continuation</code>, and when encountering an application of <code>k</code> the
control flow will evaluate <code>handler</code> after binding the arguments of the given
application to <code>params</code>.</p>
<h4>Traversal algorithm:</h4>
<p>The first thing to note is that there might be several <code>apply_cont</code> to <code>k</code>
inside the <code>body</code>, and since we want to analyse the <code>handler</code> only once, we
cannot just follow the evaluation order naively like with the <code>Let_expr</code> case.</p>
<p>Therefore, we first analyse the <code>body</code>, and collect all the data about the
applications of <code>k</code> (see the <code>apply_cont</code> case below).</p>
<p>Once we have that, we can analyse and deduce the properties that we can know
about the arguments given to <code>k</code>. We can then bind these properties to the
corresponding parameters and then analyse the <code>handler</code> itself.</p>
<h4>Quick rundown:</h4>
<p>Let's consider the following code snippet.</p>
<pre><code class="language-ocaml">let foo_d b k_ret = 
  let_cont k x =
    let y = (x &lt;= 1) in
    apply_cont k_ret y
  in
  if b then apply_cont k 0
  else apply_cont k 1
</code></pre>
<p>When we analyse the <code>let_cont</code> we first analyse the body and see the
conditional on <code>b</code>. We'll see the two <code>apply_cont</code>s to <code>k</code> and we'll be able
to deduce that the argument given to <code>k</code> is either <code>0</code> or <code>1</code>. With that
knowledge, we can analyse the <code>handler</code> of <code>k</code> and deduce that <code>y</code> is always
<code>true</code>.</p>
<ul>
<li>Side note:
</li>
</ul>
<p>So far, we've only considered the case where <code>let_cont</code>s are <strong>not</strong> recursive.
We also allow <code>let_cont</code> to be recursive, namely to represent the control-flow
of loops, which means that the <code>handler</code> can contain <code>apply_cont k</code>. Since we
won't be able to see all <code>apply_cont</code>s before analysing the <code>handler</code> we will
have to stay conservative by over-approximating the properties we know about
the parameters.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#apply_cont" class="anchor-link">Apply_cont</a>
          </h3>
<pre><code class="language-ocaml">type expr =
  | Apply_cont of
	{
	  k : continuation;
	  args : variable list;
	}
[…]
</code></pre>
<h4>Overview and semantics:</h4>
<p>As described in <code>Let_cont</code> this only transfers the control to the handler
associated to <code>k</code> using the <code>args</code> to populate the value of the parameters of
<code>k</code>.</p>
<h4>Traversal algorithm:</h4>
<p>In this constructor, we extend the <code>acc</code> by associating the current context to
<code>k</code>. This will be retrieved later (see <code>Let_cont</code> case) to know
which contexts led to this continuation, and thus setup a context for the
handler.</p>
<p>Furthermore, <code>Apply_cont</code> has no underlying field of type <code>expr</code> so it is
a leaf of the on-going traversal. Assuming that there was a <code>Let_cont</code> earlier,
the traversal will forward the <code>acc</code> to the last <code>Let_cont</code> encountered and
proceed from there again as explained above.</p>
<p>If there is no remaining <code>Let_cont</code> then it means that the analysis of the
function is over and that we've traversed all the <strong>live</strong> code.</p>
<p><strong>See the <code>Let_cont</code> example.</strong></p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#apply_val" class="anchor-link">Apply_val</a>
          </h3>
<pre><code class="language-ocaml">type expr =
  | Apply_val of
	{
	  f : variable;
	  args : variable list;
	  k_return : continuation;
	}
[…]
</code></pre>
<h4>Overview and semantics:</h4>
<p><code>Apply_val</code> is the usual function application. <code>f</code> is interpreted as a
<em>functional value</em> so control-flow jumps to the associated code, binding <code>args</code>
to the function parameters. Since this is CPS, when the function returns, the
control is transfered to <code>k_return</code>, same as for an <code>Apply_cont</code>, its return
value is bound to the parameter of <code>k_return</code>.</p>
<p>It closely ressembles something like:</p>
<pre><code class="language-ocaml">let x = f args in
apply_cont k_return x
</code></pre>
<p>But since we don't allow normal function applications inside of a <code>Let_val</code>, we
have an <code>Apply_val</code> constructor to handle it.</p>
<h4>Traversal algorithm:</h4>
<p>The first thing we do is: recover the known properties about <code>f</code> from our <code>acc</code>.</p>
<p>Depending on what properties we have discovered so far, we decide whether to
inline <code>f</code> or not:
If we choose <strong>not</strong> to inline <code>f</code>, we handle this <code>Apply_val</code> as another
<code>Apply_cont</code> to <code>k_return</code>, but if we <strong>do</strong> decide to inline it, we replace
the current <code>Apply_val</code> with the body of the <code>f</code> function and continue the
traversal from there.</p>
<p>The properties that matter for the inlining decision include:</p>
<ul>
<li>Do we know the <strong>actual</strong> function called (as shown above, <code>f</code> is a variable,
and we <strong>may</strong> or <strong>may not</strong> know which function it refers to)
</li>
<li>Are there any user annotation, either on the definition of <code>f</code> such as
<code>[@inline]</code>, or at the application, with <code>[@inlined]</code>
</li>
<li>The size of <code>f</code> is important too because inlining large functions may be
detrimental
</li>
<li>The value of the <code>args</code> matter because, for instance, when we know nothing
about the arguments, inlining <code>f</code> is less likely to be benefitial
</li>
<li>In some case, this is where we try <a href="https://ocamlpro.com/blog/2024_08_09_the_flambda2_snippets_3/">Speculative Inlining</a>
</li>
</ul>
<hr>
<p>Some static analysis requires a whole-view of the program, or at least, the
current function.</p>
<p>So when the downwards pass has traversed the whole term, we trigger a few
analyses that we could not do on-the-fly like properties that involve
loops. Such properties can't be computed during a single pass, they usually
require a fix-point. Once that is done, we use the result of the downward pass,
we can use that to initialise the <code>upward environment</code> (<code>uenv</code>).</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#upwardtraversal" class="anchor-link">Upward traversal</a>
          </h2>
<p>You will be happy to learn that the upward traversal is much easier to break
down than the downward one! 🎉</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#uenv" class="anchor-link">Upward environment</a>
          </h3>
<p>Since we have all the data accumulated on our way down at our disposal, we only
have a few more properties to track on our way back up. As said previously, we
gathered the properties inside an <em>accumulator</em> while following the evaluation
order, on our way down. On our way up, we will feed something more akin to an
<em>environment</em>.</p>
<pre><code class="language-ocaml">(* example of a rebuilding step function *)
val rebuild_let : var -&gt; prim -&gt; args : var list -&gt; body : (term * uenv) -&gt; term * uenv
</code></pre>
<p>This upward environment (<code>uenv</code>) will mainly hold data about:</p>
<ul>
<li>free (live) variables, which are variables that are used in the subterms of
the term being traversed;
</li>
<li>relevant information to aid the <strong>Speculative Inlining</strong> heuristic, which include
the size of the term and the optimization benefits, for instance the number
of operations eliminated during both traversals.
</li>
</ul>
<p>These properties are inherently structural. Thus, tracking them is easily done
while traversing the tree in the structural order.</p>
<p>Furthermore, these are properties of the rebuilt version of the term, not the
original one:</p>
<ul>
<li>Since some optimisations can remove variable uses (making such variables
potentially useless), we are required to work with a rebuilt version of that
term;
</li>
<li>Obviously, optimization benefits can only be computed after actually
performing them;
</li>
</ul>
<p>That is why we could not have tracked them on the way down, thus relegating
them to the way back up. Hence, we have designed the upward pass to follow the
structural order to track that effortlessly.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#deadcodeelimination" class="anchor-link">Dead code elimination</a>
          </h3>
<p>Free variables are useful for <em>dead code elimination</em>.</p>
<p>Dead code is code which can be removed from the term without altering its
semantic.</p>
<p>There are two kinds of <em>dead code</em>:</p>
<ul>
<li>Pure expressions whose result is never used;
</li>
<li>Code sections that are never reached;
</li>
</ul>
<p>The first one can be detected by looking for variables which are never
mentioned outside of their definition.</p>
<p>The second is the same, but relative to continuation names.</p>
<p>In order to understand how it is done, let's see how we do it for a simple
<code>let</code> binding, and then we'll see how it is done through continuations with
<code>let_cont</code>.</p>
<hr>
<p><strong>Let-bindings</strong>: when rebuilding the <code>let</code>, we have the rebuilt body, and the
set of free-variables of the rebuilt body, and if the variable bound by the
<code>let</code> is not part of the free-variables, we delete that <code>let</code>.</p>
<p><strong>Rundown:</strong></p>
<pre><code class="language-ocaml">let x = 1 in
(* Step 2 *)
let z = 0 in
(* Step 1 *)
let y = x + 1 in
(* Step 0 *)
42 + z
</code></pre>
<p>The rebuilding order follows the <code>Step</code> annotations of the example from 0 to 2.</p>
<ul>
<li>
<p><strong>Step 0</strong>: the free-variable of the body of the <code>let y</code> is <code>{ z }</code>. <code>y</code> is not
present in that set so we don't rebuild the <code>let</code>. Had we rebuilt it, <code>x</code> would
have been part of the free-variables set. So we just keep <code>{ z }</code> as the set of
free-variables.</p>
</li>
<li>
<p><strong>Step 1</strong>: We rebuild the <code>let z</code> and remove <code>z</code> from the free-variables set
because it is now bound.</p>
</li>
<li>
<p><strong>Step 2</strong>: And now we continue onto the <code>let x</code> that we also remove.</p>
</li>
</ul>
<p>We can observe that this method can remove all useless <code>let</code>s in a single traversal.</p>
<p>Let's see now, how we can extend this method to rebuilding <code>let_cont</code>s while
still maintaining this property.</p>
<hr>
<p><strong>Let_conts</strong>: As for <code>let_cont</code>, we want to be able to remove the unused
parameters of the continuation. We can see that a parameter is unused <strong>after</strong>
having analysed the continuation handler: when the parameter is absent from the
set of free-variables of the handler.</p>
<p>Furthermore, we need to change the <code>apply_cont</code> of the continuation from which
we remove parameters. We need to only pass arguments for live parameters.</p>
<p>That entails to go through the body of the continuation <strong>after</strong> traversing
its handler, because it's inside the body that <code>apply_cont</code>s to that
continuation appear (we are going to put aside recursive continuations for the
sake of simplicity).</p>
<p>And so, we keep track of which of these continuations' parameters we removed in
order to rebuild the <code>apply_cont</code>.</p>
<p><strong>Rundown:</strong></p>
<pre><code class="language-ocaml">(* Step 0 *)
let_cont k0 z =
(* Step 1 (k0 handler) *)
  return 42
in
(* Step 2 (k0 body) *)
let_cont k1 y =
(* Step 4 (k1 handler) *)
  let z1 = y + 1 in 
(* Step 3 (k1 handler) *)
  apply_cont k0 z1
in
(* Step 5 (k1 body) *)
apply_cont k1 420
</code></pre>
<p>The rebuilding order follows the <code>Step</code> annotations of the example from 0 to 5,
though, we will only mention the relevant steps.</p>
<ul>
<li>
<p><strong>Step 1</strong>: Parameter <code>z</code> of <code>k0</code> is dead, so we get rid of it.</p>
</li>
<li>
<p><strong>Step 3</strong>: So now, we have to update the <code>apply_cont k0 z1</code> which in turn becomes
<code>apply_cont k0</code> (the argument disappears).</p>
</li>
<li>
<p><strong>Step 4</strong>: Since <code>z1</code> was deleted, its <code>let</code> is then removed, and <code>y</code> becomes
useless and in turn, eliminated.</p>
</li>
<li>
<p><strong>Step 5</strong>: Eventually, we can replace the <code>apply_cont k1 420</code> with <code>apply_cont k1</code>
because the <code>y</code> parameter was previously eradicated.</p>
</li>
</ul>
<p><strong>It is this traversal order, which allows to conduct simplications on CPS in one
go and perform dead code elimination on the upwards traversal.</strong></p>
<hr>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h2>
<p>In this episode of <em>The Flambda2 Snippets</em>, we have explored how the <em>Flambda2
Optimising Compiler</em> <strong>performs upwards and downwards traversals to analyze and
transform OCaml code efficiently</strong>. By structuring our passes in this way, we
ensure that <strong>static analysis and optimizations</strong> are performed in a <strong>single
traversal</strong> while maintaining precision and efficiency.</p>
<p>The <strong>downward traversal enables us to propagate information</strong> about variables,
functions, and continuations, allowing for effective inlining and
simplification. Meanwhile, the <strong>upward traversal facilitates optimizations</strong> such
as dead code elimination by identifying and removing unnecessary expressions in
a structured and efficient manner.</p>
<p>Through these mechanisms, <code>Flambda2</code> is able to navigate the complexities
introduced by <strong>CPS conversion</strong> while still achieving significant performance
gains. Understanding these traversal strategies is key to grasping the power
behind <code>Flambda2</code>’s approach to optimization and why it stands as a robust
solution for compiling OCaml code.</p>
<p><strong>Thank you all for reading! We hope these articles keep the community eager to
dive even deeper with us into OCaml compilation. Until next time, mind the
stalactites!
<a href="https://ocamlpro.github.io/ocaml-canvas/examples/saucisse.html">⛏️🔦</a></strong></p>

