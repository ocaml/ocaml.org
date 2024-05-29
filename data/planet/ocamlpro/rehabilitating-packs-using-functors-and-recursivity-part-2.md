---
title: Rehabilitating Packs using Functors and Recursivity, part 2.
description: This blog post and the previous one about functor packs covers two RFCs
  currently developed by OCamlPro and Jane Street. We previously introduced functor
  packs, a new feature adding the possiblity to compile packs as functors, allowing
  the user to implement functors as multiple source files or even ...
url: https://ocamlpro.com/blog/2020_09_30_rehabilitating_packs_using_functors_and_recursivity_part_2
date: 2020-09-30T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Pierrick Couderc\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/train.jpg" alt=""/></p>
<p>This blog post and the previous one about <a href="https://ocamlpro.com/blog/2020_09_24_rehabilitating_packs_using_functors_and_recursivity_part_1">functor packs</a> covers two RFCs currently developed by OCamlPro and Jane Street. We previously introduced functor packs, a new feature adding the possiblity to compile packs as functors, allowing the user to implement functors as multiple source files or even parameterized libraries.</p>
<p>In this blog post, we will cover the other aspect of the packs rehabilitation: allowing anyone to implement recursive compilation units using packs (as described formally in the <a href="https://github.com/ocaml/RFCs/pull/20">RFC#20</a>). Our previous post introduced briefly how packs were compiled and why we needed some bits of closure conversion to effectively implement big functors. Once again, to implement recursive packs we will need to encode modules through this technique, as such we advise the reader to check at least the introduction and the compilation part of functor packs.</p>
<h2>Recursive modules through recursive packs</h2>
<p>Recursive modules are a feature long available in the compiler, but restricted to modules, not compilation units. As such, it is impossible to write two files that depend on each other, except by using scripts that tie up these modules into a single compilation file. Due to the internal representation of recursive modules, it would be difficult to implement recursive (and mutually recursive) compilation units. However, we could use packs to implement these.</p>
<p>One common example of recursive modules are trees whose nodes are represented by sets. To implement such a data structure with the standard library we need recursive modules: <code>Set</code> is a functor that takes as parameter a module describing the values embedded in the set, but in our case the type needs the already applied functor.</p>
<pre><code class="language-Ocaml">module rec T : sig
  type t =
      Leaf of int
    | Node of TSet.t

  val compare : t -&gt; t -&gt; int
end = struct
  type t =
      Leaf of int
    | Node of TSet.t

  let compare t1 t2 =
    match t1, t2 with
      Leaf v1, Leaf v2 -&gt; Int.compare v1 v2
    | Node s1, Node s2 -&gt; TSet.compare s1 s2
    | Leaf _, Node _ -&gt; -1
    | Node _, Leaf _ -&gt; 1
end

and TSet : Set.S with type elt = T.t = Set.Make(T)
</code></pre>
<p>With recursive pack, we can simply put <code>T</code> and <code>TSet</code> into their respective files (<code>t.ml</code> and <code>tSet.ml</code>), and tie them into one module (let's name it <code>P</code>). Signature of recursive modules cannot be infered, as such we also need to define <code>t.mli</code> and <code>tSet.mli</code>. Both must be compiled simultaneously since they refer to each other. The result of the compilation is the following:</p>
<pre><code class="language-shell-session">ocamlopt -c -for-pack P -recursive t.mli tSet.mli
ocamlopt -c -for-pack P -pack-is-recursive P t.ml
ocamlopt -c -for-pack P -pack-is-recursive P tSet.ml
ocamlopt -o p.cmx -recursive-pack t.cmx tSet.cmx
</code></pre>
<p>We have three new compilation options:</p>
<ul>
<li><code>-recursive</code> indicates to the compiler to typecheck all the given <code>mli</code>s simultaneously, as recursive modules.
</li>
<li><code>-pack-is-recursive</code> indicates which pack(s) in the hierarchy are meant to be recursive. This is necessary since it determines how the module must be compiled (<em>i.e</em> if we will need to apply closure conversion).
</li>
<li><code>recursive-pack</code> generates a pack that deals with the initialization of its modules, as for recursive modules.
</li>
</ul>
<h3>Recursives modules compilation</h3>
<p>One may be wondering why we need packs to compile recursive modules. Let's take a look at how they are encoded. We will craft a naive example that is simple enough once compiled:</p>
<pre><code class="language-Ocaml">module rec Even : sig
  val test: int -&gt; bool
end = struct
  let test i =
    if i-1 &lt;= 0 then false else Odd.test (i-1)
end

and Odd : sig
  val test: int -&gt; bool
end = struct
  let test i =
    if i-1 &lt;= 0 then true else Even.test (i-1)
end
</code></pre>
<p>It defines two modules <code>Even</code> and <code>Odd</code>, that both test whether an integer is even or odd, and if that is not the case calls the test function from the other module. Not a really interesting use of recursive modules obviously. The compilation schema for recursive modules is the following:</p>
<ul>
<li>First, it allocates empty blocks for each module according to its <strong>shape</strong> (how many values are bound and what size they need in the block, if the module is a functor and what are its values, etc).
</li>
<li>Then these blocks are filled with the implementation.
</li>
</ul>
<p>In our case, in a pseudo-code that is a bit higher order than Lambda (the first intermediate language of ocaml) it would translate as:</p>
<pre><code class="language-Ocaml">module Even = &lt;allocation of the shape of even.cmx&gt;
module Odd = &lt;allocation of the shape of odd.cmx&gt;

Even := &lt;struct let test = .. end&gt;
Odd := &lt;struct let test = .. end&gt;
</code></pre>
<p>This ensures that every reference to <code>Even</code> in <code>Odd</code> (and vice-versa) are valid pointers. To respect this schema, we will use packs to tie recursive modules together. Without packs, this means we would generate this code when linking the units into an executable which can be tricky. The pack can simply do it as initialization code.</p>
<h3>Compiling modules for recursive pack</h3>
<p>If we tried to compile these modules naively, we would end up in the same situation than for the functor pack: the compilation units would refer to identifiers that do not exist at the time they are generated. Moreover, the initialization part needs to know the shape of the compilation unit to be able to allocate precisely the block that will contain the recursive module. In order to implement recursive compilation units into packs, we extends the compilation units in two ways:</p>
<ul>
<li>The shape of the unit is computed and stored in the <code>cmo</code> (or <code>cmx</code>).
</li>
<li>As for functor pack, we apply closure conversion on the free variables that are modules from the same pack or from packs above in the hierarchy as long as they are recursive.
</li>
</ul>
<p>As an example, we will reuse our <code>Even</code> / <code>Odd</code> example above and split it into two units <code>even.ml</code> and <code>odd.ml</code>, and compile them into a recursive pack <code>P</code>. Both have the same shape: a module with a single value. <code>Even</code> refers to a free variable <code>Odd</code>, which is in the same recursive pack, and vice-versa. The result of the closure conversion is a function that will take the pointer resulting from the initialization. Since the module is also recursive itself, it takes its own pointer resulting from its initialization. The result will look as something like:</p>
<pre><code class="language-Ocaml">(* even.cmx *)
module Even_rec (Even: &lt;even.mli&gt;&lt;even.mli&gt;)(Odd: &lt;odd.mli&gt;&lt;odd.mli&gt;) = ..

(* odd.cmx *)
module Odd_rec (Odd: &lt;odd.mli&gt;&lt;odd.mli&gt;)(Even: &lt;even.mli&gt;&lt;even.mli&gt;) = ..

(* p.cmx *)
module Even = &lt;allocation of the shape of even.cmx&gt;
module Odd = &lt;allocation of the shape of odd.cmx&gt;

Even := Even_rec(Even)(Odd)
Odd := Odd_rec(Odd)(Even)
</code></pre>
<h2>Rejunavating packs</h2>
<p>Under the hood, these new features come with some refactoring in the pack implementation which follows work done for RFC on the <a href="https://github.com/ocaml/RFCs/pull/13">representation of symbols</a> in the middle-end of the compiler. Packs were not really used anymore and were deprecated by module aliases, this work makes them relevant again. These RFCs improve the OCaml ecosystem in multiple ways:</p>
<ul>
<li>Compilation units are now on par with modules, since they can be functors.
</li>
<li>Functor packs allow developers to implement parameterized libraries, without having to rely on scripts to produce multiple libraries linked with different <em>backends</em> (for example, Cohttp can use Lwt or Async as backend, and provides two libraries, one for each of these).
</li>
<li>Recursive packs allow the implementation of recursive modules into separate files.
</li>
</ul>
<p>We hope that such improvements will benefit the users and library developers. Having a way to implement parameterize libraries without having to describe big functors by hand, or use mutually recursive compilation units without using scripts to generate a unique <code>ml</code> file will certainly introduce new workflows.</p>

