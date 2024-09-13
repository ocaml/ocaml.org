---
title: 'Flambda2 Ep. 3: Speculative Inlining '
description: 'Welcome to a new episode of The Flambda2 Snippets! The F2S blog posts
  aim at gradually introducing the world to the inner-workings of a complex piece
  of software engineering: The Flambda2 Optimising Compiler for OCaml, a technical
  marvel born from a 10 year-long effort in Research & Development and ...'
url: https://ocamlpro.com/blog/2024_08_09_the_flambda2_snippets_3
date: 2024-08-09T10:02:59-00:00
preview_image: https://www.ocamlpro.com/blog/assets/img/picture_egyptian_weighing_of_heart.jpg
authors:
- "\n    Pierre Chambart\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/picture_egyptian_weighing_of_heart.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/picture_egyptian_weighing_of_heart.jpg" alt="A representation of Speculative Inlining through the famous Weighing Of The Heart of Egyptian Mythology. Egyptian God Anubis weighs his OCaml function, to see if it is worth inlining.<br />Credit: The Weighing of the Heart Ceremony, Ammit. Angus McBride (British, 1931-2007)">
    </a>
    </p><div class="caption">
      A representation of Speculative Inlining through the famous Weighing Of The Heart of Egyptian Mythology. Egyptian God Anubis weighs his OCaml function, to see if it is worth inlining.<br>Credit: The Weighing of the Heart Ceremony, Ammit. Angus McBride (British, 1931-2007)
    </div>
  <p></p>
</div>
<p></p>
<h3>Welcome to a new episode of The Flambda2 Snippets!</h3>
<blockquote>
<p>The <strong>F2S</strong> blog posts aim at gradually introducing the world to the
inner-workings of a complex piece of software engineering: The <code>Flambda2 Optimising Compiler</code> for OCaml, a technical marvel born from a 10 year-long
effort in Research &amp; Development and Compilation; with many more years of
expertise in all aspects of Computer Science and Formal Methods.</p>
</blockquote>
<p>Today's article will serve as an introduction to one of the key design
decisions structuring <code>Flambda2</code> that we will cover in the next episode in the
series: <code>Upward and Downward Traversals</code>.</p>
<p>See, there are interesting things to be said about how <code>inlining</code> is conducted
inside of our compiler. <code>Inlining</code> in itself is rather ubiquitous in compilers.
The goal here is to show how we approach <code>inlining</code>, and present what we call
<code>Speculative Inlining</code>.</p>
<p></p><div>
<strong>Table of contents</strong><p></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#inliningingeneral">Inlining in general</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#detrimentalinlining">When inlining is detrimental</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#beneficialinlining">How to decide when inlining is beneficial</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#speculativeinlining">Speculative inlining</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#speculativeinlininginpractice">Speculative inlining in practice</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#summary">Summary</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>
</li>
</ul>
<p></p></div><p></p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#inliningingeneral" class="anchor-link">Inlining in general</a>
          </h2>
<p>Given the way people write functional programs, <strong>inlining</strong> is an important part
of the optimisation pipeline of such functional langages.</p>
<p>What we call <strong>inlining</strong> in this series is the process of duplicating some
code to specialise it to a specific context.</p>
<p>Usually, this can be thought as copy-pasting the body of a function at its
call site. A common misunderstanding is to think that the main benefit of this
optimisation is to remove the cost of the function call. However, with modern
computer architectures, this has become less and less relevant in the last
decades. The actual benefit is to use the specific context to trigger further
optimisations.</p>
<p>Suppose we have the following <code>option_map</code> and <code>double</code> functions:</p>
<pre><code class="language-ocaml">let option_map f x =
  match x with
  | None -&gt; None
  | Some x -&gt; Some (f x)

let double i =
  i + i
</code></pre>
<p>Additionally, suppose we are currently considering the following function:</p>
<pre><code class="language-ocaml">let stuff () =
  option_map double (Some 21)
</code></pre>
<p>In this short example, inlining the <code>option_map</code> function would perform the
following transformation:</p>
<pre><code class="language-ocaml">let stuff () =
  let f = double in
  let x = Some 21 in
  match x with
  | None -&gt; None
  | Some x -&gt; Some (f x)
</code></pre>
<p>Now we can inline the <code>double</code> function.</p>
<pre><code class="language-ocaml">let stuff () =
  let x = Some 21 in
  match x with
  | None -&gt; None
  | Some x -&gt;
    Some (let i = x in i + i)
</code></pre>
<p>As you can see, inlining alone isn't that useful of an optimisation per se. In
this context, appliquing <code>Constant Propagation</code> will optimise and simplify it
to the following:</p>
<pre><code class="language-ocaml">let stuff () = Some 42
</code></pre>
<p>Although this is a toy example, combining small functions is a common pattern
in functional programs. It's very convenient that using combinators is <strong>not</strong>
significantly worse than writing this function by hand.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#detrimentalinlining" class="anchor-link">When inlining is detrimental</a>
          </h2>
<p>We cannot just go around and inline everything, everywhere... all at once.</p>
<p>As we said, inlining is mainly code duplication and that would be
detrimental and blow the size of the compiled code drastically. However, there
is a sweet spot to be found, between both absolute inlining and no inlining at
all, but it is hard to find.</p>
<p>Here's an example of exploding code at inlining time:</p>
<pre><code class="language-ocaml">(* val h : int -&gt; int *)
let h n = (* Some non constant expression *)

(* val f : (int -&gt; int) -&gt; int -&gt; int *)
let f g x = g (g x)

(* 4 calls to f -&gt; 2^4 calls to h *)
let n = f (f (f (f h))) 42
</code></pre>
<p>Following through with the inlining process will produce a very large binary
relative to its source code. This contrived example highlights potential
problems that might arise in ordinary codebases in the wild, even if this one
is tailored to be <strong>quite nasty</strong> for inlining: notice the exponential blowup
in the number of nested calls, every additional call to <code>f</code> doubles the number
of calls to <code>h</code> after inlining.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#beneficialinlining" class="anchor-link">How to decide when inlining is beneficial</a>
          </h2>
<p>Most compilers use a collection of heuristics to guide them in the decision
making. A good collection of heuristics is hard to both design, and fine-tune.
They also can be quite specific to a programming style and unfit for other
compilers to integrate. The take away is: <strong>there is no best way</strong>.</p>
<blockquote>
<p><strong>Side Note:</strong></p>
<p>This topic would make for an interesting blog post but,
unfortunately, rather remote from the point of this article. If you are
interested in going deeper into that subject right now, we have found
references for you to explore until we get around to writing a comprehensive,
and more digestable, explanation about the heuristic nature of inlining:</p>
<ul>
<li><a href="https://www.cambridge.org/core/services/aop-cambridge-core/content/view/8DD9A82FF4189A0093B7672193246E22/S0956796802004331a.pdf/secrets-of-the-glasgow-haskell-compiler-inliner.pdf"><strong>Secrets of the Glasgow Haskell Compiler inliner</strong>, <em>by SIMON PEYTON JONES and SIMON MARLOW, 2002</em></a>.
</li>
<li><a href="https://web.archive.org/web/20010615153947/https://www.cs.indiana.edu/~owaddell/papers/thesis.ps.gz"><strong>Extending the Scope of Syntactic Abstraction</strong>, <em>by OSCAR WADDELL, 1999. Section 4.4</em> (<strong>PDF Download link</strong>)</a>, for the case of Scheme.
</li>
<li><a href="https://dl.acm.org/doi/10.1145/182409.182489"><strong>Towards Better Inlining Decisions Using Inlining Trials</strong>, <em>by JEFFREY DEAN and CRAIG CHAMBERS, 1994</em></a>.
</li>
<li><a href="https://ethz.ch/content/dam/ethz/special-interest/infk/ast-dam/documents/Theodoridis-ASPLOS22-Inlining-Paper.pdf"><strong>Understanding and Exploiting Optimal Function Inlining</strong>, <em>by THEODOROS THEODORIDIS, TOBIAS GROSSER, ZHENDONG SU, 2022</em></a>.
</li>
</ul>
</blockquote>
<p>Before we get to a concrete example, and break down <code>Speculative Inlining</code> for
you, we would like to discuss the trade-offs of duplicating code.</p>
<p>CPUs execute instructions one by one, or at least they pretend that they do. In
order to execute an instruction, they need to load up into memory both code and
data. In modern CPUs, most instructions take only a few cycles to execute and
in practice, the CPUs often execute several at the same time. To put into
perspective, loading memory, however, in the worst case, can take hundreds of
CPU cycles... Most of the time it's not the case because CPUs have complex
memory cache hierarchies such that loading from instruction cache can take just
a few cycles, loading from level 2 caches may take dozens of them, and the
worst case is loading from main memory which can take hundreds of cycles.</p>
<p>The take away is, when executing a program, the cost of one instruction
that has to be loaded from main memory can be
<a href="https://norvig.com/21-days.html#answers">larger</a> than the cost of executing a
hundred instructions in caches.</p>
<p>There is a way to avoid the worst case scenario. Since caches are rather small
in size, the main component to keeping from loading from main memory is to keep
your program rather small, or at least the parts of it that are regularly
executed.</p>
<p>Keep these orders of magnitude in mind when we address the trade-offs between
improving the number of instructions that we run and keeping the program to a
reasonably small size.</p>
<hr>
<p>Before explaining <code>Speculative Inlining</code> let's consider a piece of code.</p>
<p>The following pattern is quite common in OCaml and other functional languages,
let's see how one would go about inlining this code snippet.</p>
<p><strong>Example 1:</strong> Notice the higher-order function <code>f</code>:</p>
<pre><code class="language-ocaml">(*
  val f :
    (condition:bool -&gt; int -&gt; unit) 
    -&gt; condition:bool
    -&gt; int
    -&gt; unit
 *)
let f g ~condition n =
  for i = 0 to n do
    g ~condition i
  done

let g_real ~condition i =
  if condition then
    (* small operation *)
  else
    (* big piece of code *)

let condition = true

let foo n =
  f g_real ~condition n
</code></pre>
<p>Even for such a small example we will see that the heuristics involved to finding
the right solution can become quite complex.</p>
<p>Keeping in mind the fact that <code>condition</code> is always <code>true</code>, the best set of
inlining decisions would yield the following code:</p>
<pre><code class="language-ocaml">(* All the code before [foo] is kept as is, from the previous codeblock *)
let foo x = 
  for i = 0 to x do
    (* small operation *)
  done
</code></pre>
<p>But if <code>condition</code> had been always <code>false</code>, instead of <code>small operation</code>, we
would have had a big chunk of <code>g_real</code> duplicated in <code>foo</code> (i.e: <code>(* big piece of code *)</code>). Moreover it would
have only spared us the running time of a few <code>call</code> instructions. Therefore,
we would have probably preferred to have kept ourselves from inlining anything.</p>
<p>Specifically, we would have liked to have stopped from inlining <code>g</code>, as well as
to have avoided inlining <code>f</code> because it would have needlessly increased the
size of the code with no substantial benefit.</p>
<p>However, if we want to be able to take an educated decision based on the value
of <code>condition</code>, we will have to consider the entirety of the code relevant to
that choice. Indeed, if we just look at the code for <code>f</code>, or its call site in
<code>foo</code>, nothing would guide us to the right decision. In order to take the
right decision, we need to understand that if the <code>~condition</code> parameter to the
<code>g_real</code> function is <code>true</code>, then we can remove a <strong>large</strong> piece of code,
namely: the <code>else</code> branch and the condition check as well.</p>
<p>But to understand that the <code>~condition</code> in <code>g_real</code> is always <code>true</code>, we need
to see it in the context of  <code>f</code> in <code>foo</code>. This implies again that, that choice
of inlining is not based on a property of <code>g_real</code> but rather a property of the
context of its call.</p>
<p>There exists a <strong>very large</strong> number of combinations of such difficult
situations that would each require <strong>different</strong> heuristics which would be
incredibly tedious to design, implement, and maintain.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#speculativeinlining" class="anchor-link">Speculative inlining</a>
          </h2>
<p>We manage to circumvent the hurdle that this decision problem represents
thanks to what we call <code>Speculative Inlining</code>. This strategy requires two
properties from the compiler: the ability to inline and optimise at the same
time, as well as being able to backtrack inlining decisions.</p>
<p>Lets look at <strong>Example 1</strong> again and look into the <code>Speculative Inlining</code>
strategy.</p>
<pre><code class="language-ocaml">let f g ~condition n =
  for i = 0 to n do
    g ~condition i
  done

let g_real ~condition x =
  if condition then
    (* small operation *)
  else
    (* big piece of code *)

let condition = true

let foo x =
  f g_real ~condition x
</code></pre>
<p>We will focus only on the traversal of the <code>foo</code> function.</p>
<p>Before we try and inline anything, there are a couple things we have to keep in
mind about values and functions in OCaml:</p>
<ol>
<li><strong>Application arity may not match function arity</strong>
</li>
</ol>
<p>To give you an idea, the function <code>foo</code> could also been written in the
following way:</p>
<pre><code class="language-ocaml">let foo x =
  let f1 = f in
  let f2 = f1 g_real in 
  let f3 = f2 ~condition in
  f3 x
</code></pre>
<p>We expect the compiler to translate it as well as the original, but we cannot
inline a function unless all its arguments are provided. To solve this, we need
to handle partial applications precisely. Over-applications also present
similar challenges.</p>
<ol start="2">
<li><strong>Functions are values in OCaml</strong>
</li>
</ol>
<p>We have to understand that the call to <code>f</code> in <code>foo</code> is <strong>not</strong> trivially a
direct call to <code>f</code> in this context. Indeed, at this point functions could
instead be stored in pairs, or lists, or even hashtables, to be later retrieved
and applied at will, and we call such functions <strong>general functions</strong>.</p>
<p>Since our goal is to inline it, we <strong>need</strong> to know the body of the function. We
call a function <strong>concrete</strong> when we have knowledge of its body. This entails
<a href="https://en.wikipedia.org/wiki/Constant_folding"><code>Constant Propagation</code></a>
in order to associate a <strong>concrete</strong> function to <strong>general</strong> function values and,
consequently, be able to simplify it while inlining.</p>
<p>Here's the simplest case to demonstrate the importance of <code>Constant Propagation</code>.</p>
<pre><code class="language-ocaml">let foo_bar y =
  let pair = foo, y in
  (fst pair) (snd pair)
</code></pre>
<p>In this case, we have to look inside the pair in order to find the function,
this demonstrates that we sometimes have to do some amount of <strong>value analysis</strong> in
order to proceed. It's quite common to come across such cases in OCaml programs
due to the module system and other functional languages present similar
characteristics.</p>
<p>There are many scenarios which also require a decent amount of context in order
to identify which function should be called. For example, when a function
passed as parameter is called, we need to know the context of the caller
function<strong>s</strong>, sometimes up to an arbitrarily large context. Analysing the
relevant context will tell us which function is being called and thus help
us make educated inlining decisions. This problem is specific to functional
languages, functions in good old imperative languages are seldom ambiguous;
even though such considerations would be relevant when function pointers are
involved.</p>
<p>This small code snippet shows us that we <strong>have</strong> to inline some functions in
order to know whether we should have inlined them.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#speculativeinlininginpractice" class="anchor-link">Speculative inlining in practice</a>
          </h3>
<p>In practice, <code>Speculative Inlining</code> is being able to quantify the benefits
brought by a set of optimisations, which have to be applied after a given
inlining decision, and use these results to determine if said inlining decision
is in fact worth to carry out all things considered.</p>
<p>The criteria for accepting an inlining decision is that the resulting code
<strong>should be</strong> faster that the original one. We use <em>"should be"</em> because
program speed cannot be fully understood with absolutes.</p>
<p>That's why we use a heuristic algorithm in order to compare the original and
the optimised versions of the code. It roughly consists in counting the number
of retired (executed) instructions and comparing it to the increase in code
size introduced by inlining the body of that function. The value of that
cut-off ratio is by definition heuristic and different compilation options
given to <code>ocamlopt</code> change it.</p>
<p>As said previously, we cannot go around and evaluate each inlining decision
independently because there are cases where inlining a function allows for more
of them to happen, and sometimes a given inlining choice validates another one.
We can see this in <strong>Example 1</strong>, where deciding <strong>not</strong> to inline function
<code>g_real</code> would make the inlining of function <code>f</code> useless.</p>
<p>Naturally, every combination of inlining decision cannot be explored
exhaustively. We can only explore a small subset of them, and for that we have
another heuristic that was already used in <code>Flambda1</code>, although <code>Flambda2</code> does
not yet implement it in full.</p>
<p>It's quite simple: we choose to consider inlining decision relationships only
when there are nested calls. As for any other heuristic, it does not cover
every useful case, but not only is it the easiest to implement, we are also
fairly confident that it covers the most important cases.</p>
<p>Here's a small rundown of that heuristic:</p>
<ul>
<li><code>A</code> is a function which calls <code>B</code>
<ul>
<li><strong>Case 1</strong>: we evaluate the body of <code>A</code> at its definition, possibly inlining
<code>B</code> in the process
</li>
<li><strong>Case 2</strong>: at a specific callsite of <code>A</code>, we evaluate <code>A</code> in the inlining
context.
<ul>
<li><strong>Case 2.a</strong>: inlining <code>A</code> is beneficial no matter the decision on <code>B</code>, so we
do it.
</li>
<li><strong>Case 2.b</strong>: inlining <code>A</code> is potentially detrimental, so we go and evaluate
<code>B</code> before deciding to inline <code>A</code> for good.
</li>
</ul>
</li>
</ul>
</li>
</ul>
<p>Keep in mind that case <strong>2.b</strong> is recursive and can go arbitrarily deep. This
amounts to looking for the best leaf in the decision tree. Since we can't
explore the whole tree, we do have a some limit to the depth of the
exploration.</p>
<blockquote>
<p><strong>Reminder for our fellow Cameleers</strong>: <code>Flambda1</code> and <code>Flambda2</code> have a flag
you can pass through the CLI which will generate a <code>.org</code> file which will
detail all the inlining decisions taken by the compiler. That flag is:
<code>-inlining-report</code>. Note that <code>.org</code> files allow to easily visualise a
decision tree inside of the Emacs editor.</p>
</blockquote>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#summary" class="anchor-link">Summary</a>
          </h2>
<p>By now, you should have a better understanding of the intricacies inherent to
<code>Speculative Inlining</code>. Prior to its initial inception, it was fair to question
how feasible (and eligible, considering the many requirements for developping a
compiler), such an algorithm would be in practice. Since then, it has
demonstrated its usefulness in <code>Flambda1</code> and, consequently, its porting to
<code>Flambda2</code> was called for.</p>
<p>So before we move on to the next stop in the
<a href="https://ocamlpro.com/blog/2024_03_18_the_flambda2_snippets_0#listing"><strong>F2S</strong></a> series, lets
summarize what we know of <code>Speculative Inlining</code>.</p>
<p>We learned that <strong>inlining</strong> is the process of copying the body of a function at
its callsite. We also learned that it is not a very interesting transformation by
itself, especially nowadays with how efficient modern CPUs are, but that its
usefulness is found in how it <strong>facilitates other optimisations</strong> to take place
later.</p>
<p>We also learned about the <strong>heuristic</strong> nature of inlining and how it would be
difficult to maintain finely-tailored heuristics in the long run as many others
have tried before us. Actually, it is because <strong>there is no best way</strong> that we
have come up with the need for an algorithm that is capable of simultaneously
performing <strong>inlining</strong> and <strong>optimising</strong> as well as <strong>backtracking</strong> when needed
which we called <code>Speculative Inlining</code>. In a nutshell, <code>Speculative Inlining</code>
is one of the algorithms of the optimisation framework of <code>Flambda2</code> which
facilitates other optimisations to take place.</p>
<p>We have covered the constraints that the algorithm has to respect for it to
hold ground in practice, like <strong>performance</strong>. We value a fast compiler and aim
to keep both its execution but also the code it generates to be so. Take an
optimisation such as <code>Constant Propagation</code> as an example.
It would be a <em>naïve</em> approach to try and perform this transformation
everywhere because the resulting complexity of the compiler would amount to
something like <code>size_of_the_code * number_of_inlinings_performed</code> which is
unacceptable to say the least. We aim at making the complexity of our compiler
linear to the code size, which in turn entails plenty of <strong>logarithms</strong> anytime
it is possible. Instead, we choose to apply any transformation only in the
inlined parts of the code.</p>
<p>With all these parameters in mind, can we imagine ways to tackle these
<strong>multi-layered challenges</strong> all at the same time ? There are solutions out there
that do so in an imperative manner. In fact, the most intuitive way to
implement such an algorithm may be fairly easily done with imperative code. You
may want to read about <code>Equality Saturation</code> for instance, or even <a href="http://www-sop.inria.fr/members/Manuel.Serrano/publi/serrano-plilp97.ps.gz">download
Manuel Serrano's Paper inside the Scheme Bigloo
compiler</a>
to learn more about it. However, we require backtracking, and the nested
nature of these transformations (inlining, followed by different optimising
transformations) <strong>would make backtracking bug-prone and tedious to
maintain</strong> if it was to be written imperatively.</p>
<p>It soon became evident for us that we were going to leverage one of the key
characteristics of functional languages in order to make this whole ordeal
easier to design, implement and maintain: <strong>purity of terms</strong>. Indeed, not only is
it easier to support backtracking when manipulating <strong>pure</strong> code, but it also
becomes impossible for us to introduce cascades of hard to detect nested
bugs by avoiding transforming code <strong>in place</strong>. From this point on, we knew we
had to perform all transformations at the same time, making our inlining
function one that would return an <strong>optimised inlined function</strong>. This does
introduce complexities that we have chosen over the hurdles of maintaining an
imperative version of that same algorithm, which can be seen as pertaining to
<code>graph traversal</code> and <code>tree rewriting</code> for all intents and purposes.</p>
<p>Despite the density of this article, keep in mind that we aim at explaining
<code>Flambda2</code> in the most comprehensive manner possible and that there are
voluntary shortcuts taken throughout these snippets for all of this to make
sense for the broader audience.
In time, these articles will go deep into the guts of the compiler and by then,
hopefully, we will have done a good job at providing our readers with all
necessary information for all of you to continue enjoying this rabbit-hole with
us!</p>
<p>Here's a pseudo-code snippet representing <code>Speculative Inlining</code>.</p>
<pre><code class="language-ocaml">(* Pseudo-code to rpz the actual speculation *)
let try_inlining f env args =
  let inlined_version_of_f = inline f env args in
  let benefit = compare inlined_version_of_f f in
  if benefit &gt; 0 then
    inlined_version_of_f
  else
    f
</code></pre>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h2>
<p>As we said at the start of this article, this one is but an introduction to a
major topic we will cover next, namely: <code>Upwards and Downwards Traversals</code>.</p>
<p>We had to cover <code>Speculative Inlining</code> first. It is a reasonably approachable
solution to a complex problem, and having an idea of all the requirements for
its good implementation is half of the work done for understanding key design
decisions such as how code traversal was designed for algorithms such as
<code>Speculative Inlining</code> to hold out.</p>
<hr>
<p><strong>Thank you all for reading! We hope that these articles will keep the
community hungry for more!</strong></p>
<p><strong>Until next time, keep calm and OCaml!</strong>
<a href="https://egypt-museum.com/the-weighing-of-the-heart-ceremony/">⚱️🐫🏺📜</a></p>

