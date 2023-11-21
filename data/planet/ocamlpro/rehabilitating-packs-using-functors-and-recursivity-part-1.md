---
title: Rehabilitating Packs using Functors and Recursivity, part 1.
description: OCamlPro has a long history of dedicated efforts to support the development
  of the OCaml compiler, through sponsorship or direct contributions from Flambda
  Team. An important one is the Flambda intermediate representation designed for optimizations,
  and in the future its next iteration Flambda 2. Th...
url: https://ocamlpro.com/blog/2020_09_24_rehabilitating_packs_using_functors_and_recursivity_part_1
date: 2020-09-24T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Pierrick Couderc\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/train.jpg" alt=""/></p>
<p>OCamlPro has a long history of dedicated efforts to support the development of the OCaml compiler, through sponsorship or direct contributions from <em>Flambda Team</em>. An important one is the Flambda intermediate representation designed for optimizations, and in the future its next iteration Flambda 2. This work is funded by JaneStreet.</p>
<p>Packs in the OCaml ecosystem are kind of an outdated concept (options <code>-pack</code> and <code>-for-pack</code> in the <a href="https://caml.inria.fr/pub/docs/manual-ocaml/comp.html">OCaml manual</a>), and their main utility has been overtaken by the introduction of <a href="https://caml.inria.fr/pub/docs/manual-ocaml/modulealias.html">module aliases</a> in OCaml 4.02. What if we tried to redeem them and give them a new youth and utility by adding the possibility to generate functors or recursive packs?</p>
<p>This blog post covers the <a href="https://github.com/ocaml/RFCs/pull/11">functor units and functor packs</a>, while the next one will be centered around <a href="https://github.com/ocaml/RFCs/pull/20">recursive packs</a>. Both RFCs are currently developed by JaneStreet and OCamlPro. This idea was initially introduced by <a href="https://ocamlpro.com/blog/2011_08_10_packing_and_functors">functor packs</a> (Fabrice Le Fessant) and later generalized by <a href="https://ocaml.org/meetings/ocaml/2014/ocaml2014_8.pdf">functorized namespaces</a> (Pierrick Couderc et al.).</p>
<h2>Packs for the masses</h2>
<p>First of all let's take a look at what packs are, and how they fixed some issues that arose when the ecosystem started to grow and the number of libraries got quite large.</p>
<p>One common problem in any programming language is how names are treated and disambiguated. For example, look at this small piece of code:</p>
<pre><code class="language-Ocaml">let x = &quot;something&quot;

let x = &quot;something else&quot;
</code></pre>
<p>We declare two variables <code>x</code>, but actually the first one is shadowed by the second, and is now unavailable for the rest of the program. It is perfectly valid in OCaml. Let's try to do the same thing with modules:</p>
<pre><code class="language-Ocaml">module M = struct end

module M = struct end
</code></pre>
<p>The compiler rejects it with the following error:</p>
<pre><code class="language-shell-session">File &quot;m.ml&quot;, line 3, characters 0-21:
3 | module M = struct end
    ^^^^^^^^^^^^^^^^^^^^^
Error: Multiple definition of the module name M.
       Names must be unique in a given structure or signature.
</code></pre>
<p>This also applies with programs linking two compilation units of the same name. Imagine you are using two libraries (here <code>lib_a</code> and <code>lib_b</code>), that both define a module named <code>Misc</code>.</p>
<pre><code class="language-shell-session">ocamlopt -o prog.asm -I lib_a -I lib_b lib_a.cmxa lib_b.cmxa prog.ml 
File &quot;prog.ml&quot;, line 1:
Error: The files lib_a/a.cmi and lib_b/b.cmi make inconsistent assumptions
over interface Misc
</code></pre>
<p>At link time, the compiler will reject your program since you are trying to link two modules with the same name but different implementations. The compiler is unable to differentiate the two compilation units since they define some identical symbols, as such cannot link the program. Enforcing unique module names in the same namespace (<em>i.e.</em> a signature) is consistent with the inability to link two modules of the same name in the same program.</p>
<p>However, <code>Misc</code> is a common name for a module in any project. How can we avoid that? As a user of the libraries there is nothing you can do, since you cannot rename the modules (you will eventually need to link two files named <code>misc.cmx</code>). As the developer, you need to ensure that your module names are unique enough to be used along any other libraries. One solution would be to use prefixes for each of your compilation units, for example by naming your files <code>mylib_misc.ml</code>, with the drawback that you will need to use those long module names inside your library. Another solution is packing your units.</p>
<p>A pack is simply a generated module that appends all your compilation units into one. For example, suppose you have two files <code>a.ml</code> and <code>b.ml</code>, you can generate a pack (<em>i.e.</em> a module) <code>mylib.cmx</code> that is equivalent to:</p>
<pre><code class="language-Ocaml">module A = struct &lt;content of a.ml&gt; end
module B = struct &lt;content of b.ml&gt; end
</code></pre>
<p>As such, <code>A</code> and <code>B</code> can retain their original module name, and be accessed from the outside as <code>Mylib.A</code> and <code>Mylib.B</code>. It uses the namespacing induced by the module system. A developer can simply generate a pack for its library, assuming its library name will be unique enough to be linked with other modules without the risk of name clashing. However it has one big downside: suppose you use a library with many modules but only use one. Without packs the compiler will only link the necessary compilation units from this library, but since the pack is one big compilation unit this means your program embeds the complete library.</p>
<p>This problem is fixed using module aliases and the compiler option <code>-no-alias-deps</code> since OCaml 4.02, and the result for the user is equivalent to a pack, making them more or less deprecated.</p>
<h2>Functorizing packs, or how to parameterize a library</h2>
<p>Packs being modules representing libraries, a useful feature would be to be able to produce libraries that take modules as parameters, just like functors. Another usage would be to split a huge functor into multiple files. In other words, we want our pack <code>Mylib</code> to be compiled as:</p>
<pre><code class="language-Ocaml">functor (P : sig .. end) -&gt; struct 
  module A = struct &lt;content of a.ml&gt; end
  module B = struct &lt;content of b.ml&gt; end
end
</code></pre>
<p>while <code>A</code> and <code>B</code> would use the parameter <code>P</code> as a module, and <code>Mylib</code> instantiated later as</p>
<pre><code class="language-Ocaml">module Mylib = Mylib(Some_module_with_sig_compatible_with_P)
</code></pre>
<p>One can notice that our pack is indeed a functor, and not simply a module that binds a functor. To be able to do that, we also extends classical compilation units to be compiled as functors. Such functors are not expressed in the language, we do not provide a syntax for that, they are a matter of options at compile-time. For example:</p>
<pre><code class="language-shell-session">ocamlopt -c -parameter P m.ml
</code></pre>
<p>will compile <code>m.ml</code> as a functor that has a parameter <code>P</code> whose interface is described in <code>p.cmi</code> in the compilation path. Similarly, our pack <code>Mylib</code> can be produced by the following compilation steps:</p>
<pre><code class="language-shell-session">ocamlopt -c -parameter-of Mylib p.mli
ocamlopt -c -for-pack &quot;Mylib(P)&quot; a.ml
ocamlopt -c -for-pack &quot;MyLib(P)&quot; b.ml
ocamlopt -pack -o mylib.cmx -parameter P a.cmx b.cmx
</code></pre>
<p>In details:</p>
<ul>
<li>The parameter is compiled with the flag <code>-parameter-of Mylib</code>, as such it won't be used as the interface of an implementation.
</li>
<li>The two modules packed are compiled with the flag <code>-for-pack &quot;MyLib(P)&quot;</code>. Expressing the parameter of the pack is mandatory since <code>P</code> must be known as a functor parameter (we will see why in the next section).
</li>
<li>The pack is compiled with <code>-parameter P</code>, which will indeed produce a functorized compilation unit.
</li>
</ul>
<p>Functors are not limited to a unique parameter, as such they can be compiled with multiple <code>-parameter</code> options and multiple arguments in <code>-for-pack</code>. This implementation being on the build system side, it does not need to change the syntax of the language. We expect build tools like dune to provide supports for this feature, making it maybe more easier to use. Moreover, it makes compilation units on par with modules which can have a functor type. One downside however is that we cannot express type equalities between two parameters or with the functor body type as we would do with substitutions in module types.</p>
<h3>Functor packs under the hood</h3>
<p>In terms of implementation, packs should be seen as a concatenation of the compilation units then a rebinding of each of them in the newly created one. For example, a pack <code>P</code> of two units <code>m.cmx</code> and <code>n.cmx</code> is actually compiled as something like:</p>
<pre><code class="language-Ocaml">module P__M = &lt;code of m.cmx&gt; 
module P__N = &lt;code of n.cmx&gt; 
module M = P__M 
module N = P__N
</code></pre>
<p>According to this representation, if we tried to naively implement our previous functor pack <code>Mylib(P)</code> we would end up with a functor looking like this:</p>
<pre><code class="language-Ocaml">module Mylib__A = &lt;code of a.cmx, with references to P&gt;
module Mylib__B = &lt;code of b.cmx, with references to P&gt;

functor (P : &lt;signature of p.cmi&gt;) -&gt; struct
  module A = Mylib__A
  module B = Mylib__B
end
</code></pre>
<p>Unfortunately, this encoding of functor packs is wrong: <code>P</code> is free in <code>a.cmx</code> and <code>b.cmx</code> and its identifier cannot correspond to the one generated for the functor retrospectively. The solution is actually quite simple and relies on a transformation known as <strong><a href="https://en.wikipedia.org/wiki/Lambda_lifting">closure conversion</a></strong>. In other words we will transform our modules into functors that takes as parameters their free variables, which in our case are the parameters of the functor pack and the dependencies from the same pack. Let's do it on a concrete functor equivalent to Mylib:</p>
<pre><code class="language-Ocaml">module Mylib' (P : P_SIG) = struct
  module A = struct .. &lt;references to P&gt; end
  module B = struct .. &lt;references to P&gt; &lt;references to A&gt; end
end
</code></pre>
<p>Our goal here is to move <code>A</code> and <code>B</code> outside of the functor, as such out of the scope of <code>P</code>, which is done by transforming those two modules into functors that takes a parameter <code>P'</code> with the same signature as <code>P</code>:</p>
<pre><code class="language-Ocaml">module A_funct (P' : P_SIG) = struct .. &lt;references to P as P'&gt; end 
module B_funct (P' : P_SIG) = struct 
  module A' = A_funct(P') 
  .. 
  &lt;references to P as P'&gt; 
  &lt;references to A as A'&gt; 
end 

module Mylib' (P : P_SIG) = struct 
  module A = A_funct(P) 
  module B = B_funct(P) 
end
</code></pre>
<p>While this code compiles it is not semantically equivalent. <code>A_funct</code> is instantiated twice,  its side effects are computed twice: the first time when instantiating <code>A</code> in the functor, and the second when instantiating <code>B</code>. The solution is simply to go further with closure conversion and make the result of applying <code>A_funct</code> to <code>P</code> an argument of <code>B_funct</code>.</p>
<pre><code class="language-Ocaml">module A_funct (P' : P_SIG) = struct .. &lt;references to P as P'&gt; end
module B_funct (P' : P_SIG)(A': module type of A_funct(P'))= struct
  ..
  &lt;references to P as P'&gt;
  &lt;references to A as A'&gt;
end

module Mylib' (P : P_SIG) = struct
  module A = A_funct(P)
  module B = B_funct(P)(A)
end
</code></pre>
<p>This represents exactly how our functor pack <code>Mylib</code> is encoded. Since we need to compile modules in a specific way if they belong to a functor pack, the compiler has to know in the argument <code>-for-pack</code> that the pack is a functor, and what are its parameters.</p>
<h3>Functor packs applied to <code>ocamlopt</code></h3>
<p>What we described is a functional prototype of functor packs, implemented on OCaml 4.10, as described in <a href="https://github.com/ocaml/RFCs/pull/11">RFC#11</a>. In practice, we already have one usage that we could benefit of in the future: cross-compilation of native code. At the moment the compiler is configured to target the architecture which it is compiled on. The modules relative to the current architecture are linked symbolically into the backend folder and the backend is compiled as if it only supported one architecture. One downside of this approach is that changes into the interface of the backend that need some modifications in each architecture are not detected at compile time, but only for the current one. You need to reconfigure the OCaml compiler and rebuild it to check if another architecture still compiles. One interesting property is that each architecture backend defines the same set of modules with compatible interfaces. In other words, these modules could simply be parameters of a functor, that is instantiated for a given architecture.</p>
<p>Following this idea, we implemented a prototype of native compiler whose backend is indeed packed into a functor, and instantiated at the initialization of the compiler. With this approach, we can easily switch the targeted architecture, and moreover we can be sure that each architecture is compiled, leveraging the fact that some necessary refactoring is always done when changes happen in the backend interface. Implementing such a functor is mainly a matter of adapting the build system to produce a functor pack, writing few signatures for the functor and its parameters, and instantiating the backend at the right time.</p>
<p>This proof of concept shows how functor packs can ease some complicated build system and allows new workflow.</p>
<h2>Making packs useful again</h2>
<p>Packs were an old concept mainly outdated by module aliases. They were not practical as they are some sort of monolithic libraries shaped into a unique module containing sub modules. While they perfectly use the module system for its namespacing properties, their usage enforces the compiler to link an entire library even if only one module is actually used. This improvement allows programmers to define big functors, functors that are split among multiple files, resulting in what we can view as a way to implement some form of parameterized libraries.</p>
<p>In the second part, we will cover another aspect of the rehabilitation of packs: using packs to implement mutually recursive compilation units.</p>
<h1>Comments</h1>
<p>Fran&ccedil;ois Bobot (25 September 2020 at 9 h 16 min):</p>
<blockquote>
<p>I believe there is a typo</p>
</blockquote>
<pre><code class="language-ocaml">module Mylib&rsquo; (P : P_SIG) = struct
module A = A_funct(P)
module B = A_funct(P)
end
</code></pre>
<blockquote>
<p>The last must be <code>B_funct(P)</code>, the next example as also the same typo.</p>
</blockquote>
<p>Pierrick Couderc (25 September 2020 at 10 h 31 min):</p>
<blockquote>
<p>Indeed, thank you!</p>
</blockquote>
<p>Cyrus Omar (8 February 2021 at 3 h 49 min):</p>
<blockquote>
<p>This looks very useful! Any updates on this work? I&rsquo;d like to be able to use it from dune.</p>
</blockquote>

