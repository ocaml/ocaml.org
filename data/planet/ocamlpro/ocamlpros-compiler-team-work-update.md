---
title: "OCamlPro\u2019s compiler team work update"
description: The OCaml compiler team at OCamlPro is happy to present some of the work
  recently done jointly with JaneStreet's team. A lot of work has been done towards
  a new framework for optimizations in the compiler, called Flambda2, aiming at solving
  the shortcomings that became apparent in the Flambda optimi...
url: https://ocamlpro.com/blog/2019_08_30_ocamlpros_compiler_team_work_update
date: 2019-08-30T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Vincent Laviron\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/picture_cpu_compiler.jpeg" alt=""/></p>
<p>The OCaml compiler team at OCamlPro is happy to present some of the work recently done jointly with JaneStreet's team.</p>
<p>A lot of work has been done towards a new framework for optimizations in the compiler, called Flambda2, aiming at solving the shortcomings that became apparent in the Flambda optimization framework (see below for more details). While that work is in progress, the team also worked on some more short-term improvements, notably on the current Flambda optimization framework, as well as some compiler modifications that will benefit Flambda2.</p>
<blockquote>
<p><em>This work is funded by JaneStreet :D</em></p>
</blockquote>
<h3>Short-term improvements</h3>
<h4>Recursive values compilation</h4>
<p>OCaml supports quite a large range of recursive definitions. In addition to recursive (and mutually-recursive) functions, one can also define regular values recursively, as for the infinite list <code>let rec l = 0 :: l</code>.</p>
<p>Not all recursive constructions are allowed, of course. For instance, the definition <code>let rec x = x</code> is rejected because there is no way to actually build a value that would behave correctly.</p>
<p>The basic rule for deciding whether a definition is allowed or not is made under the assumption that recursive values (except for functions, mostly) are compiled by first allocating space in the heap for the recursive values, binding the recursively defined variables to the allocated (but not yet initialized) values. The defining expressions are then evaluated, yielding new values (that can contain references the non-initialized values). Finally, the fields of these new values are copied one-by-one into the corresponding fields of the initial values.</p>
<p>For this approach to work, some restrictions need to apply:</p>
<ul>
<li>the compiler needs to be able to compute the size of the values beforehand (these values must be allocated values, in order to avoid defining an integer recursively),
</li>
<li>and since during the evaluation of the defining expressions their fields are not valid, one cannot write any code that may read these fields, like pattern-matching on the value, or passing the value to some function (or storing it in a mutable field of some record).
</li>
</ul>
<p>All of those restrictions have recently been reworked and formalized based on work from Alban Reynaud during an internship at Inria, reviewed and completed by Gabriel Scherer and Jeremy Yallop.</p>
<p>Unfortunately, this work only covers checking whether the recursive definitions are allowed or not; actual compilation is done later in the compiler, in one place for bytecode and another for native code, and these pieces of code have not been linked with the new check so there have been a few cases where the check allowed code that wasn't actually compiled correctly.</p>
<p>Since we didn't want to deal with it directly in our new version of Flambda, we had started working on a patch to move the compilation of recursive values up in the compilation pipeline, before the split between bytecode and native code. After some amount of hacking (we discovered that compilation of classes creates recursive value bindings that would not pass the earlier recursive check&hellip;), we have a patch that is mostly ready for review and will soon start engaging with the rest of the compiler team with the aim of integrating it into the compiler.</p>
<h4>Separate compilation of recursive modules, compilation units as functors</h4>
<p>Some OCaml developers like to encapsulate each type definition in its own module, with an interface that can expose the needed types and functions, while abstracting away as much of the actual implementation as possible. It is then common to have each of these modules in its own file, to simplify management and avoid unseemly big files.</p>
<p>However, this breaks down when one needs to define several types that depend on each other. The usual solutions are either to use recursive modules, which have the drawback of requiring all the modules to be in the same compilation unit, leading to very big files (we have seen a real case of a more than 10,000-lines file), or make each module parametric in the other modules, translating them into functors, and then instantiate all the functors when building the outwards-facing interface.</p>
<p>To address these issues, we have been working on two main patches to improve the life of developers facing these problems.</p>
<p>The first one allows compiling several different files as mutually recursive modules, reusing the approach used to compile regular recursive modules. In practice, this will allow developers using recursive modules extensively to properly separate not only the different modules from each other, but also the implementation and interfaces into a <code>.ml</code> and <code>.mli</code> files. This would of course need some additional support from the different build tools, but we're confident we can get at least <code>dune</code> to support the feature.</p>
<p>The second one allows compiling a single compilation unit as a functor instead of a regular module. The arguments of the functor would be specified on the command line, their signature taken from their corresponding interface file. This can be useful not only to break recursive dependencies, like the previous patch (though in a different way), but also to help developers relying on multiple implementations of a same <code>.mli</code> interface functorize their code with minimal effort.</p>
<p>These two improvements will also benefit packs, whereas recursive compilation units could be packed in a single module and packs could be functorized themselves.</p>
<h4>Small improvements to Flambda</h4>
<p>We are still committed to maintain the Flambda part of the compiler. Few bugs have been found, so we concentrate our efforts on small features that either yield overall performance gains or allow naive code patterns to be compiled as efficiently as their equivalent but hand-optimized versions.</p>
<p>As an example, one optimization that we should be able to submit soon looks for cases where an immutable block is allocated but an immutable block with the same exact fields and tag already exists.</p>
<p>This can be demonstrated with the following example:</p>
<pre><code class="language-ocaml">let result_bind f = function
  | Ok x -&gt; f x
  | Error e -&gt; Error e
</code></pre>
<p>The usual way to avoid the extra allocation of <code>Error e</code> is to write the clause as <code>| (Error e) as r -&gt; r</code>. With this new patch, the redundant allocation will be detected and removed automatically! This can be even more interesting with inlining:</p>
<pre><code class="language-ocaml">let my_f x =
  if (* some condition *)
  then Ok x
  else (* something else *)

let _ =
  (* ... *)
  let r = result_bind my_f (* some argument *) in
  (* ... *)
</code></pre>
<p>In this example, inlining <code>result_bind</code> then <code>my_f</code> can match the allocation <code>Ok x</code> in <code>my_f</code> with the pattern matching in <code>result_bind</code>. This removes an allocation that would be very hard to remove otherwise. We expect these patterns to occur quite often with some programming styles relying on a great deal of abstraction and small independent functions.</p>
<h3>Flambda 2.0</h3>
<p>We are building on the work done for Flambda and the experience of its users to develop Flambda 2.0, the next optimization framework.</p>
<p>Our goal is to build a framework for analyzing the costs and benefits of code transformations. The framework focuses on reducing the runtime cost of abstractions and removing as many short-lived allocations as possible.</p>
<p>The aim of Flambda 2.0 is roughly the same as the original Flambda. So why did we decide to write a new framework instead of patching the existing one? Several points led us to this decision.</p>
<ul>
<li>An invariant on the representation of closures that ensured that every closure had a unique identifier, which was convenient for a number of reasons, turned out to be quite expensive to maintain and prevented some optimizations.
</li>
<li>The internal representation of Flambda terms included too many different cases that were either redundant or not relevant to the optimizations we were interested in, making a lot of code more complicated than necessary.
</li>
<li>The ANF-like representation we used was not perfect. We wanted an easier way to do control flow optimizations, which led us to choose a CPS-like representation for Flambda 2.0.
</li>
<li>Finally, the original Flambda was thought of as an alternative to the closure conversion and inlining algorithms performed by the <code>Closure</code> module of the compiler, translating from the <code>Lambda</code> representation to <code>Clambda</code>. However, a number of optimizations (most importantly unboxing) are done during the next phase of compilation, <code>Cmmgen</code>, which translates to the <code>Cmm</code> representation. The original Flambda had trouble to estimate correctly which optimizations would trigger and what would their benefit be. It may be noted that correctly estimating benefit is a key in Flambda's algorithms, and we know of a number of cases where Flambda is not as good as it could be because it couldn't predict the unboxing opportunities that inlining would have allowed. Flambda 2.0 will go from <code>Lambda</code> to <code>Cmm</code>, and will handle all transformations done in both <code>Closure</code> and <code>Cmmgen</code> in a single framework.
</li>
</ul>
<p>These improvements are still very much a work in progress. We have not reached the point where other developers can try out the new framework on their codebases yet.</p>
<p>This does not mean there are no news to enjoy before our efforts show on the mainstream compiler! While working on Flambda 2.0, we did deploy a number of patches on the compiler both before and after the Flambda stage. We proposed all the changes independant enough to be proposed on their own. Some of these fixes have been merged already. Others are still under discussion and some, like the recursive values patch mentioned above, are still waiting for cleanup or documentation before submission.</p>
<h1>Comments</h1>
<p>Jon Harrop (30 August 2019 at 20 h 11 min):</p>
<blockquote>
<p>What is the status of multicore OCaml?</p>
</blockquote>
<p>Vincent Laviron (2 September 2019 at 16 h 22 min):</p>
<blockquote>
<p>OCamlPro is not working on multicore OCaml. It is still being worked on elsewhere, with efforts concentrated around OCaml Labs, but I don&rsquo;t have more information than what is publicly available. All of the work we described here is not expected to interfere with multicore.</p>
</blockquote>
<p>Lindsay (25 September 2020 at 20 h 20 min):</p>
<blockquote>
<p>Thanks for your continued work on the compiler and tooling! Am curious if there is any news regarding the item &ldquo;Separate compilation of recursive modules&rdquo;.</p>
</blockquote>

