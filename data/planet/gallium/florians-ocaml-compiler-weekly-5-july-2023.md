---
title: Florian's OCaml compiler weekly, 5 July 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-07-05
date: 2023-07-05T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---




<p>This series of blog posts aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. The subject this
week is a cartography of the source of opam packages breakage in OCaml
5.1.0 .</p>


  

<p>With the recent release of the first beta for OCaml 5.1, I have spent
some time at the state of the opam ecosystem looking for package that
broke with OCaml 5.1 .</p>
<p>Interestingly, for this beta there most of those incompatibility
stemmed from 7 changes in OCaml 5.1, which is a small enough number that
I can list all those potentially package-breaking changes in this blog
post.</p>
<h3>Stdlib changes</h3>
<p>Unsurprisingly, most of the package build failures finds their source
in small changes of the standard library. Those changes accounts for at
least 8 package build failures in the opam repository at the time of the
first beta release.</p>
<h4>Updated module
types in the standard library</h4>
<p>More precisely, one source of build failure is the changes in module
types defined in the standard library. Such module types are a known
source of backward compatibility difficulty. Depending on the uses of
those module types, any change in the module types can create a build
failure.</p>
<p>And OCaml 5.1 updated three of such module types.</p>
<p>First, the <code>hash</code> function inside the
<code>Hashtbl.SeededHashedType</code> module type has been renamed to
<code>seeded_hash</code>. This changes make it possible for a module to
implement both <code>Hashtbl.SeededHashedType</code> and
<code>Hashtbl.HashedType</code> (<a href="https://github.com/ocaml/ocaml/pull/11157">#11157</a>).
Unfortunately, this change breaks modules that were using
<code>Hashtbl.MakeSeeded</code> with the previous signature for the
argument of the functor.</p>
<p>When the change was proposed there were only 6 opam packages affected
by this change. Thus, the improved usability for the
<code>Hashtbl.MakeSeeded</code> functor seemed worth the price. And at
the time of the first beta release, I have only seen two remaining
packages still affected by this change.</p>
<p>Second, a more subtle problem occurred for libraries that were using
the <code>Map.S</code> or <code>Set.S</code> module types: the
signatures has been expanded with new functions (<code>to_list</code>
for <code>Set.S</code> and <code>to_list</code> <code>of_list</code>,
and <code>add_to_list</code> for <code>Map.S</code>).</p>
<p>Consequently, three libraries that were defining new <code>Map</code>
or <code>Set</code> functors using this signature as a constraint need
to add those missing functions to their <code>Map</code> and
<code>Set</code> implementations. Those failures are maybe less
surprising: if one library use a module type provided by the standard
library for one of its own implementation, it inevitably couple strongly
itself to the standard library specification.</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/11581">New modules in the
standard library</a></h4>
<p>Another source of difficulty is that the standard library has been
added a new <code>Type</code> module in OCaml 5.1. This new module
defines the well-know equality GADT (Generalized Abstract Data
Type):</p>
<div class="highlight"><pre><span></span>type (_, _) eq = Equal : ('a, 'a) eq
</pre></div>

<p>and type identity witnesses. In other words, this is mostly a module
for heavy users of GADTs.</p>
<p>Normally, adding a new module to the standard library can be done
painlessly: Standard library modules have a lower priority compared to
local modules. Thus, if someone has a project which defines a
<code>Type</code> module, the non-qualified name <code>Type</code> will
refer to the local module, and the standard library module will be
accessible with <code>Stdlib.Type</code>. However, this low priority
behaviour requires some special support in the compiler and alternative
standard library lacks this support. Consequently, libraries (at least
three) that are defining a local <code>Type</code> module while using
alternative standard library (like <code>base</code>) might be required
to find a non-conflicting short-name for their local <code>Type</code>
module (which might be as simple as</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">Ty</span> = <span class="n">Type</span>
<span class="nb">open</span>! <span class="n">Base</span>
</pre></div>

<p>)</p>
<h3>Internal API changes</h3>
<p>The second ex &aelig;quo source of build failures in opam packages is the
changes in internal API, either in the OCaml runtime or in the compiler
library.</p>
<h4>Changes in the runtime
internal API</h4>
<p>The internal runtime function <code>caml_shared_try_alloc</code> now
takes the number of reserved bits in the header as a supplementary
argument. This change affected at least one opam package.</p>
<h4>Change in the compiler-libs
API</h4>
<p>To improve the rendering of weakly polymorphic row variables, OCaml
5.1 has switched its high-level display representation of type aliases
to make it easier to display &ldquo;weakly polymorphic aliases&rdquo;:</p>
<div class="highlight"><pre><span></span> [&gt; `X of int]  as _weak1
</pre></div>

<p>rather than</p>
<div class="highlight"><pre><span></span>_[&gt; `X of int]
</pre></div>

<p>This caused a build failure for at least one package that was relying
on the previous API.</p>
<h3>Type system change</h3>
<p>The third ex &aelig;quo source of build failures is small changes in the
type system, where package that were at the frontier of the technically
correct and bugs ended up falling on the other side of the fence during
this release.</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12211">Inexact explicit type
annotation for anonymous row variable</a></h4>
<p>For instance, due to a bug fix, OCaml 5.1 is stricter when mixing
explicitly polymorphic type annotations and anonymous row variables.
Even with all the precautions described in
http://gallium.inria.fr/blog/florian-compiler-weekly-2023-04-28, there
was at least one opam package that was affected. On the bright side,
this was probably a bug in the lone affected package.</p>
<h4>Generative
functors must be used generatively</h4>
<p>When a functor is defined as an applicative functor</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">App</span>() = <span class="n">struct</span>
  <span class="nb">type</span> <span class="nb">t</span>
<span class="nb">end</span>
</pre></div>

<p>OCaml 5.1 forbids now to apply as if it was a generative functor:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">Ok</span> = <span class="n">App</span>(<span class="n">struct</span> <span class="nb">end</span>)
<span class="k">module</span> <span class="n">New_error</span> = <span class="n">App</span>()
</pre></div>

<p>Previous version of OCaml did not make any difference between
<code>struct end</code> or <code>()</code> in functor applications and
thus allowed the form <code>App(struct end)</code>.</p>
<p>The reverse situation, where a generative functor is applied to
<code>struct end</code> is allowed but emits a warning</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="n">Gen</span>() = <span class="n">struct</span>
  <span class="nb">type</span> <span class="nb">t</span>
<span class="nb">end</span>
<span class="k">module</span> <span class="n">New_warning</span> = <span class="n">Gen</span>(<span class="n">struct</span> <span class="nb">end</span>)
</pre></div>

<div class="highlight"><pre><span></span><span class="nv">Warning</span> <span class="mi">73</span> [<span class="nv">generative</span><span class="o">-</span><span class="nv">application</span><span class="o">-</span><span class="nv">expects</span><span class="o">-</span><span class="nv">unit</span>]: <span class="nv">A</span> <span class="nv">generative</span> <span class="nv">functor</span>
<span class="nv">should</span> <span class="nv">be</span> <span class="nv">applied</span> <span class="nv">to</span> <span class="s1">'</span><span class="s">()</span><span class="s1">'</span><span class="c1">; using '(struct end)' is deprecated.</span>
</pre></div>

<p>This restriction is there to make clearer the distinction between
applicative and generative application. But at least $one opam package
needed to be updated (at the time of the beta release).</p>
<h3>Unique case</h3>
<p>Sometimes, there are also backward compatible issue with packages
that were using the compiler in surprising ways. For instance, this
time, one package build failed because it was trying to link without
<code>-for-pack</code> modules compiled with <code>-for-pack</code>,
which happened to sometimes work in previous version of OCaml. OCaml 5.1
took the decision to stop relying on such happenstance, and mixing
different <code>-for-pack</code> mode now always result in an error.</p>


