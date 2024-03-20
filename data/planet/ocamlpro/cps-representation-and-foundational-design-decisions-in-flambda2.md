---
title: CPS Representation and Foundational Design Decisions in Flambda2
description: In this first post of the Flambda2 Snippets, we dive into the powerful
  CPS-based internal representation used within the Flambda2 optimizer, which was
  one of the main motivation to move on from the former Flambda optimizer. Credit
  goes to Andrew Kennedy's paper Compiling with Continuations, Continue...
url: https://ocamlpro.com/blog/2024_03_19_the_flambda2_snippets_1
date: 2024-03-19T14:46:44-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
featured:
authors:
- "\n    Pierre Chambart\n  "
source:
---

<p>In this first post of <a href="https://ocamlpro.com/blog/2024_03_18_the_flambda2_snippets_0/">the Flambda2
Snippets</a>, we
dive into the powerful CPS-based internal representation used within the
<a href="https://github.com/ocaml-flambda/flambda-backend/tree/main/middle_end/flambda2">Flambda2 optimizer</a>,
which was one of the main motivation to move on from the former Flambda optimizer.</p>
<p>Credit goes to Andrew Kennedy's paper <a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2007/10/compilingwithcontinuationscontinued.pdf"><em>Compiling with Continuations,
Continued</em></a>
for pointing us in this direction.</p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#cps">CPS (Continuation Passing Style)</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#double-barrelled">Double Barrelled CPS</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#term">The Flambda2 Term Language</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#roadmap">Following up</a>

</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#cps" class="anchor-link">CPS (Continuation Passing Style)</a>
          </h2>
<p>Terms in the <code>Flambda2</code> IR are represented in CPS style, so let us briefly
explain what that means.</p>
<p>Some readers may already be familiar with what we call <em>First-Class CPS</em> where
continuations are represented using functions of the language:</p>
<pre><code class="language-ocaml">(* Non-tail-recursive implementation of map *)
let rec map f = function
| [] -&gt; []
| x :: r -&gt; f x :: map f r

(* Tail-recursive CPS implementation of map *)
let rec map_cps f l k =
match l with
| [] -&gt; k []
| x :: r -&gt;  let fx = f x in map_cps f r (fun r -&gt; fx :: r)
</code></pre>
<p>This kind of transformation is useful to make a recursive function
tail-recursive and sometimes to avoid allocations for functions returning
multiple values.</p>
<p>In <code>Flambda2</code>, we use <em>Second-Class CPS</em> instead, where continuations are
<strong>control-flow constructs in the Intermediate Language</strong>. In practice, this is
equivalent to an explicit representation of a control-flow graph.</p>
<p>Here's an example using some <strong>hopefully</strong> intuitive syntax for the <code>Flambda2</code>
IR.</p>
<pre><code class="language-ocaml">let rec map f = function
| [] -&gt; []
| x :: r -&gt; f x :: map f r

(* WARNING: FLAMBDA2 PSEUDO-SYNTAX INBOUND *)
let rec map
  ((f : &lt;whatever_type1&gt; ),
  (param : &lt;whatever_type2&gt;))
  {k_return_continuation : &lt;return_type&gt;}
{
  let_cont k_empty () = k_return_continuation [] in 
  let_cont k_nonempty x r =
    let_cont k_after_f fx =
      let_cont k_after_map map_result =
        let result = fx :: map_result in
        k_return_continuation result 
      in
      Apply (map f r {k_after_map})
    in
    Apply (f x {k_after_f})
  in
  match param with
  | [] -&gt; k_empty ()
  | x :: r -&gt; k_nonempty x r
}
</code></pre>
<p>Every <code>let_cont</code> binding declares a new sequence of instructions in the
control-flow graph, which can be terminated either by:</p>
<ul>
<li>calling a continuation (for example, <code>k_return_continuation</code>) which takes a
fixed number of parameters;
</li>
<li>applying an OCaml function (<code>Apply</code>), this function takes as a special
parameter the continuation which it must jump to at the end of its execution.
Unlike continuations, OCaml functions can take a number of arguments that
does not match the number of parameters at their definition;
</li>
<li>branching constructions like <code>match _ with</code> and <code>if _ then _ else _</code>, in
these cases each branch is a call to a (potentially different) continuation;
</li>
</ul>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/flambda2_snippets2_ep1_figure1.png">
      <img src="https://ocamlpro.com/blog/assets/img/flambda2_snippets2_ep1_figure1.png" alt="This image shows the previous code represented as a graph."/>
    </a>
    </p><div class="caption">
      This image shows the previous code represented as a graph.
    </div>
  
</div>

<blockquote>
<p>Notice that some boxes are nested to represent scoping relations: variables
defined in the outer boxes are available in the inner ones.</p>
</blockquote>
<p>To demonstrate the kinds of optimisations that such control-flow graphs allow
us, see the following simple example:</p>
<p><strong>Original Program:</strong></p>
<pre><code class="language-ocaml">let f cond =
  let v =
    if cond then
      raise Failure
    else 0
  in
  v, v
</code></pre>
<p>We then represent the same program using CPS in two steps, the first is the
direct translation of the original program, the second is an equivalent program
represented in a more compact form.</p>
<p><strong>Minimal CPS transformation, using pseudo-syntax</strong></p>
<pre><code class="language-ocaml">(* showing only the body of f *)
(* STEP 1 - Before graph compaction *)
let_cont k_after_if v =
  let result = v, v in
  k_return_continuation result
in
let_cont k_then () = k_raise_exception Failure in 
let_cont k_else () = k_after_if 0 in
if cond then k_then () else k_else ()
</code></pre>
<p>which becomes after inlining <code>k_after_if</code>:</p>
<pre><code class="language-ocaml">(* STEP 2 - After graph compaction *)
let_cont k_then () = k_raise_exception Failure in 
let_cont k_else () =
  let v = 0 in 
  let result = v, v in
  k_return_continuation result
in
if cond then k_then () else k_else ()
</code></pre>
<p>This allows us, by using the translation to CPS and back, to transform the
original program into the following:</p>
<p><strong>Optimized original program</strong></p>
<pre><code class="language-ocaml">let f cond =
  if cond then
    raise Failure
  else 0, 0 
</code></pre>
<p>As you can see, the original program is simpler now. The nature of the changes
operated on the code are in fact not tied to a particular optimisation but
rather the nature of the CPS transformation itself. Moreover, we do want to
actively perform optimisations and to that extent, having an intermediate
representation that is equivalent to a control-flow graph allows us to benefit
from the huge amount of literature on the subject of static analysis of
imperative programs which often are represented as control-flow graphs.</p>
<p>To be fair, in the previous example, we have cheated in how we have translated
the <code>raise</code> primitive. Indeed we used a simple continuation
(<code>k_raise_exception</code>) but we haven't defined it anywhere prior. This is
possible because our use of Double Barrelled CPS.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#double-barrelled" class="anchor-link">Double Barrelled CPS</a>
          </h2>
<p>In OCaml, all functions can not only return normally (Barrel 1) but also throw
exceptions (Barrel 2), it corresponds to two different paths in the
control-flow and we need the ability to represent it in our own control-flow graph.</p>
<p>Hence the name: <code>Double Barrelled CPS</code>, that we took from <a href="https://web.archive.org/web/20210420165356/https://www.cs.bham.ac.uk/~hxt/research/HOSC-double-barrel.pdf">this
paper</a>,
by Hayo Thielecke. In practice this only has consequences in four places:</p>
<ol>
<li>the function definitions must have two special parameters instead of one:
the exception continuation (<code>k_raise_exception</code>) in addition to the normal
return continuation (<code>k_return_continuation</code>);
</li>
<li>the function applications must have two special arguments, reciprocally;
</li>
<li><code>try ... with</code> terms are translated using regular continuations with the
exception handler (the <code>with</code> path of the construct) compiled to a
continuation handler (<code>let_cont</code>);
</li>
<li><code>raise</code> terms are translated into continuation calls, to either the current
function exception continuation (e.g. in case of uncaught exception) or the
enclosing <code>try ... with</code> handler continuation.
</li>
</ol>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#term" class="anchor-link">The Flambda2 Term Language</a>
          </h2>
<p>This CPS form has directed the concrete implementation of the FL2 language.</p>
<p>We can see that the previous IRs have very descriptive representations, with
about 20 constructors for <code>Clambda</code> and 15 for <code>Flambda</code> while <code>Flambda2</code> has
regrouped all these features into only 6 categories which are sorted by how
they affect the control-flow.</p>
<pre><code class="language-ocaml">type expr =
  | Let of let_expr
  | Let_cont of let_cont_expr
  | Apply of apply
  | Apply_cont of apply_cont
  | Switch of switch
  | Invalid of { message : string }
</code></pre>
<p>The main benefits we reap from such a strong design choice are that:</p>
<ul>
<li>Code organisation is better: dealing with control-flow is only done when
matching on full expressions and dealing with specific features of the
language is done at a lower level;
</li>
<li>Reduce code duplication: features that behave in a similar way will have
their common code shared by design;
</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#roadmap" class="anchor-link">Following up</a>
          </h2>
<p>The goal of this article was to show a fundamental design choice in <code>Flambda2</code>
which is using a CPS-based representation. This design is felt throughout the
<code>Flambda2</code> architecture and will be mentioned and strengthened again in later
posts.</p>
<p><code>Flambda2</code> takes the <code>Lambda</code> IR as input, then performs <code>CPS conversion</code>,
followed by <code>Closure conversion</code>, each of them worth their own blog post, and
this produces the terms in the <code>Flambda2</code> IR.</p>
<p>From there, we have our main optimisation pass that we call <code>Simplify</code> which
first performs static analysis on the term during a single <code>Downwards Traversal</code>,
and then rebuilds an optimised term during the <code>Upwards Traversal</code>.</p>
<p>Once we have an optimised term, we can convert it to the <code>CMM</code> IR and feed it
to the rest of the backend. This part is mostly CPS elimination but with added
original and interesting work we will detail in a specific snippet.</p>
<p>The single-pass design allows us to consider all the interactions between
optimisations</p>
<p>Some examples of optimisations performed during <code>Simplify</code>:</p>
<ul>
<li>Inlining of function calls;
</li>
<li>Constant propagation;
</li>
<li>Dead code elimination
</li>
<li>Loopification, that is transforming tail-recursive functions into loops;
</li>
<li>Unboxing;
</li>
<li>Specialisation of polymorphic primitives;
</li>
</ul>
<p>Most of the following snippets will detail one of several parts of these
optimisations.</p>
<p>Stay tuned, and thank you for reading !</p>
</div>
