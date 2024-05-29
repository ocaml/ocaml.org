---
title: Rethinking OCaml abstract signatures
description:
url: http://gallium.inria.fr/blog/rethinking-ocaml-abstract-signatures
date: 2023-12-01T08:00:00-00:00
preview_image:
authors:
- GaGallium
source:
---




<p>Abstract module types are one of the less understood features of the
OCaml module system. They have been one of the obstacles in the on-going
effort to specify, and eventually redesign, the module system.</p>
<p>In this blog post, I (Cl&eacute;ment Blaudeau) present an explanation of
what are those abstract module types, and propose a slightly restricted
version that might be easier to understand and specify while remaining
pretty expressive.</p>


  

<p>For the past 2 years, I&rsquo;ve been working on building a new
specification for the OCaml module system based on F&omega;. The goal, besides
the theoretical interest, is to eventually redo (the module part of) the
typechecker with this approach, which would have several benefits:</p>
<ul>
<li>fix some soundness issues and edge-cases that have appeared and
built up over the years, due to unforeseen interactions between
features</li>
<li>simplify the (notoriously hard) code of the typechecker by removing
ad-hoc techniques and hacks (such as the <em>strengthening</em> or the
treatment of <em>aliases</em> for instance)</li>
<li>provide a clean base to add new and awaited features. Notably,
transparent ascription and modular implicits are proposals for OCaml
modules stalled by the lack of specification of the module system.</li>
</ul>
<p>Yet, a key aspect in OCaml development culture is to ensure backward
compatibility. Therefore, the new F&omega; approach I&rsquo;ve been building should
not only subsumes the current typechecker in normal use cases, but
actually support <em>all</em> of the features of the module system. For
long, <em>abstract signatures</em> (also called <em>abstract module
types</em>) were believed to be, at least, <em>problematic</em> for F&omega;.
Hopefully, we found out that a slightly restricted version of the
feature was encodable in F&omega;, and, in passing, made the semantics of
abstract signatures much simpler. Thus, only one question remains: does
this restricted form actually covers all use cases, i.e., is the
restriction backward compatible ?</p>
<p>Here, we aim at presenting the current state of abstract signatures
and our proposed simplification purely from an <strong>OCaml user point
of view</strong>, not from the theoretical one. We welcome any feedback,
specifically, use cases or potential use cases that significantly differ
from our examples.</p>
<p>We start by introducing abstract signatures through examples. Then,
we present the current state of abstract signatures in OCaml: we explain
the syntactic approach and the issues associated with it. We argue that
it has surprising behaviors and, in its current <em>unrestricted</em>
form, it is actually <em>too powerful for its own good</em>. Then, we
propose a restriction to make the system <em>predicative</em> which, by
decreasing its expressiveness, actually makes it more usable. (Our
actual proposal is given in 3.3). We finish by other aspect related to
usability (syntax, inference).</p>
<h4>1. What are abstract signatures
?</h4>
<p>The art of modularity is all about controlling abstraction and
interfaces. ML languages offer this control via a <em>module
system</em>, which contains a <em>signature</em> language to describe
interfaces. Signatures contain <em>declarations</em> (fields): values
<code>val x : t</code>, types <code>type t = int</code>, modules
<code>module X : S</code>, and module types
<code>module type T = S</code>. Type and module type declarations can
also be abstract <code>type t</code>, <code>module type T</code>, which
serves both to hide implementation details via <em>sealing</em> and to
have polymorphic interfaces, using <em>functors</em>.</p>
<p>Here, we focus on the construct <code>module type T</code>, called
<em>abstract module type</em> or <em>abstract signature</em>. We start
with examples adapted from <a href="https://discuss.ocaml.org/t/what-are-abstract-module-types-useful-for/10121/3">this
forum discussion</a>.</p>
<h5>1.1 Module-level sealing</h5>
<p>Let&rsquo;s consider the following scenario. Two modules providing an
implementation of UDP (<code>UDP1</code> and <code>UDP2</code>) are
developed with different design trade-offs. They both implement a
signature with basic send and receive operations. Then, functors are
added as layers on top: taking a udp library as input, they return
another udp library as an output.</p>
<ul>
<li><code>Reliable</code> adds sequence numbers to the packets and
re-sends missing packets;</li>
<li><code>CongestionControl</code> tracks the rate of missing packets to
adapt the throughput to network congestion situations;</li>
<li><code>Encryption</code> encrypts the content of all messages.</li>
</ul>
<p>A project might need different combinations of the basic libraries
and functors, while requiring that <strong>all</strong> combinations use
encryption. To enforce this, the solution is to use the module-level
<em>sealing</em> of abstract signatures. In practice, the signature of
the whole library containing implementations and functors
<code>UDPLib</code> (typically, its <code>.mli</code> file) is rewritten
to abstract all interfaces except for the output of the
<code>Encryption</code> functor.</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">UDPLib</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">module</span> <span class="k">type</span> <span class="nc">UNSAFE</span>

  <span class="k">module</span> <span class="nc">UDP1</span> <span class="o">:</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">UDP2</span> <span class="o">:</span> <span class="nc">UNSAFE</span>

  <span class="k">module</span> <span class="nc">Reliable</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">CongestionControl</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span> <span class="nc">UNSAFE</span>

  <span class="k">module</span> <span class="nc">Encryption</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span>
    <span class="k">sig</span> <span class="k">val</span> <span class="n">send</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="c">(* ... *)</span> <span class="k">end</span>
<span class="k">end</span>
</pre></div>

<p>Just as type abstraction, signature abstraction can be used to
enforce certain code patterns: users of <code>UDPLib</code> will only be
able to use the content of modules after calling the
<code>Encryption</code> functor, and yet they have the freedom to choose
between different implementations and features:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">UDPKeyHandshake</span> <span class="o">=</span> <span class="nc">Encryption</span><span class="o">(</span><span class="nc">Reliable</span><span class="o">(</span><span class="nc">UDP1</span><span class="o">))</span>
<span class="k">module</span> <span class="nc">UDPVideoStream</span>  <span class="o">=</span> <span class="nc">Encryption</span><span class="o">(</span><span class="nc">CongestionControl</span><span class="o">(</span><span class="nc">UDP2</span><span class="o">))</span>
<span class="c">(* etc *)</span>
</pre></div>

<h5>1.2 Module-level polymorphism</h5>
<p>Another use is to introduce polymorphism at the module level. Just as
polymorphic functions can be used to factor code, module-level
polymorphic functors can be used to factor module expressions. If a code
happens to often feature functor applications of the form
<code>Hashtbl.Make(F(X))</code> or <code>Set.Make(F(X))</code>, one can
define the <code>MakeApply</code> functor as follows:</p>
<div class="highlight"><pre><span></span><span class="c">(* Factorizing common expressions *)</span>
<span class="k">module</span> <span class="k">type</span> <span class="nc">Type</span> <span class="o">=</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">T</span> <span class="k">end</span>
<span class="k">module</span> <span class="nc">MakeApply</span>
  <span class="o">(</span><span class="nc">A</span><span class="o">:</span><span class="nc">Type</span><span class="o">)</span> <span class="o">(</span><span class="nc">X</span><span class="o">:</span> <span class="nn">A</span><span class="p">.</span><span class="nc">T</span><span class="o">)</span>
  <span class="o">(</span><span class="nc">B</span><span class="o">:</span><span class="nc">Type</span><span class="o">)</span> <span class="o">(</span><span class="nc">F</span><span class="o">:</span> <span class="nn">A</span><span class="p">.</span><span class="nc">T</span> <span class="o">-&gt;</span> <span class="nn">B</span><span class="p">.</span><span class="nc">T</span><span class="o">)</span>
  <span class="o">(</span><span class="nc">C</span><span class="o">:</span><span class="nc">Type</span><span class="o">)</span> <span class="o">(</span><span class="nc">H</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="nc">Make</span> <span class="o">:</span> <span class="nn">B</span><span class="p">.</span><span class="nc">T</span> <span class="o">-&gt;</span> <span class="nn">C</span><span class="p">.</span><span class="nc">T</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span> <span class="nn">H</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">F</span><span class="o">(</span><span class="nc">X</span><span class="o">))</span>
</pre></div>

<p>Downstream the code is rewritten into
<code>MakeApply(...)(X)(...)(F)(...)(Set)</code> or
<code>MakeApply(...)(X)(...)(F)(...)(Hashtbl)</code> Right now, the
verbosity of such example would probably be a deal-breaker. We address
this aspect at the end. Ignoring the verbosity, this can be useful for
maintenance: by channeling all applications through
<code>MakeApply</code>, only one place needs to be updated if the arity
or order of arguments is changed. Similarly, if several functors expect
a <em>constant argument</em> containing &ndash; for instance &ndash; global
variables, a <code>ApplyGv</code> functor can be defined to always
provide the right second argument, which can even latter be hidden away
to the user of <code>ApplyGv</code>:</p>
<div class="highlight"><pre><span></span><span class="c">(* Constant argument *)</span>
<span class="k">module</span> <span class="nc">Gv</span> <span class="o">:</span> <span class="nc">GlobalVars</span>
<span class="k">module</span> <span class="nc">ApplyGv</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">B</span> <span class="k">end</span><span class="o">)</span>
    <span class="o">(</span><span class="nc">F</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span> <span class="o">-&gt;</span> <span class="nc">GlobalVars</span> <span class="o">-&gt;</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">B</span><span class="o">)(</span><span class="nc">X</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span><span class="o">)</span> <span class="o">=</span> <span class="nc">F</span><span class="o">(</span><span class="nc">X</span><span class="o">)(</span><span class="nc">Gv</span><span class="o">)</span>
</pre></div>

<p>Downstream, code featuring <code>F(X)(GlobalVars)</code> is rewritten
into <code>ApplyGv(...)(F)(X)</code> Then, the programmer can hide the
<code>GlobalVars</code> module while letting users use
<code>ApplyGv</code>, ensuring that global variables are not modified in
uncontrolled ways by certain part of the program.</p>
<p>Finally, polymorphism can also be used by a developer to prevent
unwanted dependencies on implementation details. If the body of a
functor uses an argument with a submodule <code>X</code>, but actually
does not depend on the content of <code>S</code>, abstracting it is a
&ldquo;good practice&rdquo;.</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">F</span> <span class="o">(</span><span class="nc">Arg</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nn">S</span> <span class="p">...</span> <span class="n">end</span><span class="o">)</span> <span class="o">=</span>
  <span class="o">...</span> <span class="c">(* polymorphism is not enforced *)</span>

<span class="k">module</span> <span class="nc">F'</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">S</span> <span class="k">end</span><span class="o">)</span>
    <span class="o">(</span><span class="nc">Arg</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nn">S</span> <span class="p">...</span> <span class="n">end</span> <span class="o">)</span> <span class="o">=</span>
  <span class="o">...</span> <span class="c">(* polymorphism is enforced *)</span>
</pre></div>

<h5>1.3 So it&rsquo;s just
normal use cases of abstraction ?</h5>
<p>Fundamentally, these example are not surprising for developers that
are used to rely on abstraction to protect invariants and factor code.
Their specificity lies in the fact that there are at the module level,
and therefore require projects with a certain size and a strong emphasis
on modularity to be justified.</p>
<h4>2. OCaml&rsquo;
abstract signatures, an incidental feature ?</h4>
<p>The challenge for understanding (and implementing) abstract
signatures lies more in the meaning of the module-level
<em>polymorphism</em> that they offer than the module level sealing, the
latter being pretty straightforward. More specifically, the crux lies in
the meaning of the <em>instantiation</em> of an abstract signature
variable <code>A</code> by some other signature <code>S</code>, that
happens when a polymorphic functor is applied. OCaml follows an
<em>unrestricted syntactical approach</em>: <code>A</code> can be
instantiated by any (well-formed) signature <code>S</code>. During
instantiation, all occurrences of <code>A</code> are just replaced by
<code>S</code> ; finally, the resulting signature is
<strong>re-interpreted</strong>&mdash;as if it were written <em>as is</em> by
the user.</p>
<p>However, this syntactical rewriting interferes with the
<em>variant</em> interpretation of signatures, which can lead to
surprising behaviors. We discuss this aspect first. The
<em>unrestricted</em> aspect leads to the (infamous) <em>Type :
Type</em> issue which has some theoretical consequences. We finish this
section by mentioning other&mdash;more technical&mdash;issues.</p>
<h5>2.1 Syntactical rewriting</h5>
<p>The first key issue of this approach comes from the fact that
signatures in OCaml have a variant interpretation: abstract fields (1)
have a different meaning (sealing or polymorphism) depending on whether
they occur in positive or negative positions, and (2) abstract fields
open new scopes, i.e.&nbsp;duplicating an abstract type field introduces two
different abstract types. Overall, OCaml signatures can be thought of as
having <em>implicit quantifiers</em>: using a signature in positive or
negative position changes its implicit quantifiers (from existential to
universal) while duplicating a signature duplicates the quantifiers (and
therefore introduces new incompatible abstract types).</p>
<p>Therefore, when instantiating an abstract signature with a signature
that has abstract fields, the user must be aware of this, and mentally
infer the meaning of the resulting signature. To illustrate how it can
be confusing, let&rsquo;s revisit the first motivating example and let&rsquo;s
assume that the developer actually want to expose part of the interface
of the raw <code>UDP</code> libraries. One might be tempted to
instantiate <code>UNSAFE</code> with something along the following
lines:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">UDPLib_expose</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">include</span> <span class="nc">UDPLib</span> <span class="k">with</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">UNSAFE</span> <span class="o">=</span>
    <span class="k">sig</span>
      <span class="k">module</span> <span class="k">type</span> <span class="nc">CORE_UNSAFE</span>
      <span class="k">module</span> <span class="nc">Unsafe</span> <span class="o">:</span> <span class="nc">CORE_UNSAFE</span> <span class="c">(* this part remains abstract *)</span>
      <span class="k">module</span> <span class="nc">Safe</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">end</span> <span class="c">(* this part is exposed *)</span>
    <span class="k">end</span>
<span class="k">end</span>
</pre></div>

<p>This returns :</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">UDPLib_expose</span> <span class="o">=</span>  <span class="k">sig</span>
  <span class="k">module</span> <span class="k">type</span> <span class="nc">UNSAFE</span> <span class="o">=</span>
    <span class="k">sig</span>
      <span class="k">module</span> <span class="k">type</span> <span class="nc">CORE_UNSAFE</span>
      <span class="k">module</span> <span class="nc">Unsafe</span> <span class="o">:</span> <span class="nc">CORE_UNSAFE</span>
      <span class="k">module</span> <span class="nc">Safe</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">end</span>
    <span class="k">end</span>
  <span class="k">module</span> <span class="nc">UDP1</span> <span class="o">:</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">UDP2</span> <span class="o">:</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">Reliable</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">CongestionControl</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span> <span class="nc">UNSAFE</span>
  <span class="k">module</span> <span class="nc">Encryption</span> <span class="o">:</span> <span class="nc">UNSAFE</span> <span class="o">-&gt;</span> <span class="k">sig</span> <span class="k">val</span> <span class="n">send</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="c">(* ... *)</span> <span class="k">end</span>
<span class="k">end</span>
</pre></div>

<p>However, the syntactical rewriting and reinterpretation of this
signature in the negative positions produces a counter-intuitive result.
For instance, if we expand the signature of the argument for the functor
<code>Reliable</code> (for instance) we see:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Reliable</span> <span class="o">:</span>
<span class="k">sig</span>
  <span class="k">module</span> <span class="k">type</span> <span class="nc">CORE_UNSAFE</span>
  <span class="k">module</span> <span class="nc">Unsafe</span> <span class="o">:</span> <span class="nc">CORE_UNSAFE</span>
  <span class="k">module</span> <span class="nc">Safe</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">end</span>
<span class="k">end</span> <span class="o">-&gt;</span> <span class="nc">UNSAFE</span>
</pre></div>

<p>This means that the functor actually has to be <em>polymorphic</em>
in the underlying implementation of <code>CORE_UNSAFE</code>, rather
than using the internal details, which has the <strong>opposite
meaning</strong> as before. If the user wants to hide a <em>shared</em>
unsafe core, accessible to the functor when they were defined and then
abstracted away, the following pattern may be used instead:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="k">type</span> <span class="nc">UDPLib_expose'</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">module</span> <span class="k">type</span> <span class="nc">CORE_UNSAFE</span>
  <span class="k">include</span> <span class="nc">UDPLib</span> <span class="k">with</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">UNSAFE</span> <span class="o">=</span> <span class="k">sig</span>
    <span class="k">module</span> <span class="k">type</span> <span class="nc">CORE_UNSAFE</span> <span class="o">=</span> <span class="nc">CORE_UNSAFE</span>
    <span class="k">module</span> <span class="nc">Unsafe</span> <span class="o">:</span> <span class="nc">CORE_UNSAFE</span>
    <span class="k">module</span> <span class="nc">Safe</span> <span class="o">:</span> <span class="k">sig</span> <span class="o">...</span> <span class="k">end</span>
  <span class="k">end</span>
<span class="k">end</span>
</pre></div>

<p>Doing so, the instantiated signature does not contain abstract fields
and therefore its variant reinterpretation will not introduce unwanted
polymorphism. This observation is at the core of the proposal of this
post.</p>
<h5>2.2 <code>Type : Type</code> and
impredicativity</h5>
<p>Abstract module types are impredicative: a signature containing an
abstract signature can be instantiated by itself. One can trick the
subtyping algorithm into an infinite loop of instantiating an abstract
signature by itself, as shown by <a href="https://sympa.inria.fr/sympa/arc/caml-list/1999-07/msg00027.html">Andreas
Rosseberg</a>, adapting an example from <a href="https://doi.org/10.1145/174675.176927">Harper and Lillibridge
(POPL &rsquo;94)</a>. This also allows type-checking of (non-terminating)
programs with an absurd type, as shown by the encoding of the Girard&rsquo;s
paradox done by <a href="https://github.com/lpw25/girards-paradox/tree/master">Leo
White</a>.</p>
<h5>2.3 Other issues</h5>
<p>The current implementation of the typechecker does not handle
abstract signatures correctly in some scenarios. It&rsquo;s unclear if they
are just bugs or pose theoretical challenges.</p>
<h6>2.3.1 Invalid module aliases</h6>
<p>Inside a functor, module aliases are disallowed between the parameter
and the body (for soundness reasons, due to coercive subtyping).
However, this check can be bypassed by using an abstract signature that
is then instantiated with an alias. If we try to use it to produce a
functor that exports its argument as an alias, the typechecker crashes.
This is discussed in <a href="https://github.com/ocaml/ocaml/issues/11441">#11441</a></p>
<div class="highlight"><pre><span></span><span class="c">(* crashes the typechecker in current OCaml *)</span>
<span class="k">module</span> <span class="nc">F</span> <span class="o">(</span><span class="nc">Type</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">T</span> <span class="k">end</span><span class="o">)(</span><span class="nc">Y</span> <span class="o">:</span> <span class="nn">Type</span><span class="p">.</span><span class="nc">T</span><span class="o">)</span> <span class="o">=</span> <span class="nc">Y</span>

<span class="k">module</span> <span class="nc">Crash</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span>
  <span class="nc">F</span><span class="o">(</span><span class="k">struct</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">T</span> <span class="o">=</span> <span class="k">sig</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">=</span> <span class="nc">Y</span> <span class="k">end</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<h6>2.3.2 Loss of applicativity</h6>
<p>The use of abstract signatures clashes with applicativity of
functors, as discussed <a href="https://github.com/ocaml/ocaml/issues/12204">in #12204</a>.</p>
<h6>2.3.3 Invalid signatures and
avoidance</h6>
<p>Another known issue is that the typechecker can abstract a signature
when it contains unreachable type fields (types pointing to anonymous
modules). This can lead to the production of <em>invalid signatures</em>
: signatures that are refused by the typechecker when re-entered back
in.</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">F</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span>
  <span class="k">struct</span>
    <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">sig</span>
      <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="nn">Y</span><span class="p">.</span><span class="n">t</span> <span class="c">(* this will force the abstraction of all of A *)</span>
      <span class="k">type</span> <span class="n">u</span>
    <span class="k">end</span>
    <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">struct</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="nn">Y</span><span class="p">.</span><span class="n">t</span> <span class="k">type</span> <span class="n">u</span> <span class="o">=</span> <span class="kt">int</span> <span class="k">end</span>
    <span class="k">type</span> <span class="n">u</span> <span class="o">=</span> <span class="nn">X</span><span class="p">.</span><span class="n">u</span>
  <span class="k">end</span>

<span class="k">module</span> <span class="nc">Test</span> <span class="o">=</span> <span class="nc">F</span><span class="o">(</span><span class="k">struct</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span><span class="o">)</span>

<span class="c">(* returns *)</span>
<span class="k">module</span> <span class="nc">Test</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">type</span> <span class="n">u</span> <span class="o">=</span> <span class="nn">X</span><span class="p">.</span><span class="n">u</span> <span class="k">end</span>
</pre></div>

<p>Here, the type field <code>type u = X.u</code> is invalid as
<code>X</code> has an abstract signature (and therefore, no fields).</p>
<h4>3. A solution: simple
abstract signatures</h4>
<p>In this section we explore solutions for fixing the issues of the
current approach. The core criticism we make of the OCaml approach is
that it is actually <em>too expressive for its own good</em>. Abstract
signatures are <em>impredicative</em>: they can be instantiated by
themselves. Having impredicative instantiation with variant
reinterpretation is hard to track for the user and interacts in very
subtle ways with other features of the module system, slowing down its
development&mdash;and breaking its theoretical properties. To address this, we
take the opposite stance and propose to make the system actually
<em>predicative</em>: we restrict the set of signatures that can be used
to instantiate an abstract signature. This also indirectly addresses the
complexity of the variant reinterpretation.</p>
<p>We start with the simplest solution where instantiation of abstract
signatures is restricted to signatures containing no abstract fields.
Then, we propose to relax this restriction and allow for signatures that
contain abstract <em>type</em> fields (but no abstract module types),
which we call <em>simple</em> signatures. This will requires us to
briefly discuss the need for module-level sharing.</p>
<p>In this section we focus on the theoretical aspects, but present them
informally with examples. The practical aspects, notably syntax and
inference, are discussed in the next section.</p>
<h5>3.1 No abstraction</h5>
<p>One might wonder why abstract types and abstract signatures
syntactically resembles one another and yet, the latter is much more
complex than the former. The key lies in the fact that abstract types
can only be instantiated by <em>concrete</em> type expressions, without
free variables. Informally, this:</p>
<div class="highlight"><pre><span></span><span class="k">sig</span>
  <span class="k">type</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">x</span> <span class="o">:</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">f</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">t</span>
<span class="k">end</span> <span class="k">with</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="o">(</span><span class="kt">int</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span><span class="o">)</span>
</pre></div>

<p>is not allowed, notably because (1) the scope of the abstract type
variable <code>'a</code> is unclear, (2) values of type <code>t</code>,
like <code>x</code>, would be ill-typed.</p>
<p>Therefore, a first solution is to <strong>require abstract signatures
to be instantiated only by concrete signatures, i.e.&nbsp;signatures with no
abstract fields</strong> (neither types nor module types). This
circumvents the clash between the rewriting and variant reinterpretation
of abstract fields (by disallowing them).</p>
<p>This is simple and sound but prevents some valid uses of abstract
types: in the first example, <code>UNSAFE</code> could not be
instantiated with abstract type fields, forcing <code>UDP1</code> and
<code>UDP2</code> to have the same type definitions.</p>
<h5>3.2 The issue of module-level
sharing</h5>
<p>If we want to relax the no-abstraction proposal, some abstract fields
will be allowed when instantiating signatures. Then, the question of
what sharing (i.e., type equalities) should be kept <em>between
different occurrences of the abstract fields</em> arises.</p>
<p>In OCaml signatures, sharing between two modules is usually expressed
<em>at the core-level</em> by rewriting the fields of the signature of
the second module to refer to their counterpart in the first one. This
cannot be done with abstract signatures, as they have no fields.
Instead, the language needs module-level sharing, which in OCaml is very
restricted. Indeed, it provides a form of module aliases (only for
submodules, not at the top-level of a signature), but aliasing between a
functor body and its parameter is not allowed&mdash;while it is typically the
use-case for abstract signatures in polymorphic functors. Consider the
following code:</p>
<div class="highlight"><pre><span></span><span class="c">(* Code *)</span>
<span class="k">module</span> <span class="nc">F1</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">X</span>
<span class="k">module</span> <span class="nc">F2</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span> <span class="o">(</span><span class="nn">Y</span><span class="p">.</span><span class="nc">X</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span><span class="o">)</span>
</pre></div>

<p>Currently, the typechecker cannot distinguish between the two and
returns the same signature, while we would expect the first one to keep
the sharing between the parameter and the body.</p>
<div class="highlight"><pre><span></span><span class="c">(* Currently, both are given the same type: *)</span>
<span class="k">module</span> <span class="nc">F1</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">:</span> <span class="nc">A</span>
<span class="k">module</span> <span class="nc">F2</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">:</span> <span class="nc">A</span>
</pre></div>

<p>As an example, we can consider the argument for the functors:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Y</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span>
  <span class="k">module</span> <span class="nc">X</span> <span class="o">=</span> <span class="k">struct</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="k">end</span>
<span class="k">end</span>

<span class="k">module</span> <span class="nc">Test1</span> <span class="o">=</span> <span class="nc">F1</span><span class="o">(</span><span class="nc">Y</span><span class="o">)</span>
<span class="k">module</span> <span class="nc">Test2</span> <span class="o">=</span> <span class="nc">F2</span><span class="o">(</span><span class="nc">Y</span><span class="o">)</span>
</pre></div>

<p>This returns :</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Test1</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span>
<span class="k">module</span> <span class="nc">Test2</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span>
</pre></div>

<p>While we would expect :</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Test1</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="k">end</span>
<span class="k">module</span> <span class="nc">Test2</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">type</span> <span class="n">t</span> <span class="k">end</span>
</pre></div>

<p>Two possible extensions would help tackle this issue.</p>
<h6>Lazy strengthening</h6>
<p>A recently proposed experimentation, named <em>lazy
strengthening</em>, extends the signature language with an operator
<code>S with P</code>, where <code>S</code> is a signature and
<code>P</code> a module path. It is interpreted as <code>S</code>
strengthened by <code>P</code>, i.e.&nbsp;<code>S</code> in which all
abstract fields are rewritten to point to their counterpart in
<code>P</code>. Initially considered for performance reasons, it would
allow for tracking of type equalities when using abstract
signatures.</p>
<div class="highlight"><pre><span></span><span class="c">(* Lazy strengthening would keep type equalities: *)</span>
<span class="k">module</span> <span class="nc">F1</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">=</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span> <span class="k">with</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">X</span>
</pre></div>

<h6>Transparent ascription</h6>
<p>A more involved solution is the use of an extension of aliasing
called <em>transparent ascription</em>, where both the alias
<em>and</em> the signature are stored in the signature. The signature
language would be extended with an operator <code>(= P &lt; S)</code>.
The technical implications of this choice are beyond the scope of this
discussion.</p>
<div class="highlight"><pre><span></span><span class="c">(* Transparent ascription would keep module equalities: *)</span>
<span class="k">module</span> <span class="nc">F1</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">:</span> <span class="o">(=</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">X</span> <span class="o">&lt;</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span><span class="o">)</span>
</pre></div>

<h5>3.3 Our proposal :
<em>simple</em> abstract signatures</h5>
<p>Maintaining a predicative approach, we propose to <strong>restrict
instantiation only by <em>simple</em> signatures, i.e., signatures that
may contain abstract type fields, but no abstract module types</strong>.
This reintroduces the need to express module-level sharing and the
mental gymnastic of variant re-interpretation of abstract type fields.
However, it guarantees that all modules sharing the same abstract
signature will also share the same structure (same fields) after
instantiation, and can only differ in their type fields. We believe this
makes for a good compromise.</p>
<h6>Expressivity (and
prenex-form)</h6>
<p>One might wonder how restrictive is this proposal. Specifically, if
we consider a simple polymorphic functor as:</p>
<div class="highlight"><pre><span></span><span class="k">module</span> <span class="nc">Apply</span> <span class="o">(</span><span class="nc">Y</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="k">end</span><span class="o">)</span> <span class="o">(</span><span class="nc">F</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span> <span class="o">-&gt;</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span><span class="o">)(</span><span class="nc">X</span> <span class="o">:</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">A</span><span class="o">)</span> <span class="o">=</span> <span class="nc">F</span><span class="o">(</span><span class="nc">X</span><span class="o">)</span>
</pre></div>

<p>The following partial application would be rejected:</p>
<div class="highlight"><pre><span></span><span class="c">(* Rejected as A would be instantiated by `sig module type B module X : B -&gt; B end` *)</span>
<span class="k">module</span> <span class="nc">Apply'</span> <span class="o">=</span> <span class="nc">Apply</span><span class="o">(</span><span class="k">struct</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">B</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">B</span> <span class="o">-&gt;</span> <span class="nc">B</span> <span class="k">end</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<p>However, this could be circumvented by eta-expanding, thus
expliciting module type parameters, and instantiating only a simple
signature:</p>
<div class="highlight"><pre><span></span><span class="c">(* Accepted as A is instantiated by a signature with no abstract fields *)</span>
<span class="k">module</span> <span class="nc">Apply''</span> <span class="o">=</span> <span class="k">functor</span> <span class="o">(</span><span class="nc">Y</span><span class="o">:</span><span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">B</span> <span class="k">end</span><span class="o">)</span> <span class="o">-&gt;</span>
  <span class="nc">Apply</span><span class="o">(</span><span class="k">struct</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">A</span> <span class="o">=</span> <span class="k">sig</span> <span class="k">module</span> <span class="k">type</span> <span class="nc">B</span> <span class="o">=</span> <span class="nn">Y</span><span class="p">.</span><span class="nc">B</span> <span class="k">module</span> <span class="nc">X</span> <span class="o">:</span> <span class="nc">B</span> <span class="o">-&gt;</span> <span class="nc">B</span> <span class="k">end</span> <span class="k">end</span><span class="o">)</span>
</pre></div>

<h6>Higher-abstraction ?</h6>
<p>Concrete and simple signatures can be seen as the first two levels of
the predicative approach for types declarations. There are no more
levels for type declarations, as types cannot be <em>partially
abstract</em> (see 3.1). Could it be useful to add even more
expressivity and authorize instantiation by a signature containing again
an abstract module type field (which would need to be restricted with a
level system like <em>universes</em>)? We have found no example where
this was useful. Besides, it would add a great layer of complexity.</p>
<h4>4. Other practical aspects</h4>
<h6>Syntax</h6>
<p>A key aspect of abstract module types that reduces their usability is
the verbosity of the syntax. Rather than having to pass signature as
part of a module argument to a polymorphic functor, using a separate
notation for module type parameters could be more concise. In practice,
abstract signature arguments could be indicated by using brackets
instead of parenthesis, and interleaved with normal module arguments, as
in this example:</p>
<div class="highlight"><pre><span></span><span class="c">(* At definition *)</span>
<span class="k">module</span> <span class="nc">MakeApply</span>
    <span class="o">[</span><span class="nc">A</span><span class="o">]</span> <span class="o">(</span><span class="nc">X</span><span class="o">:</span><span class="nc">A</span><span class="o">)</span>
    <span class="o">[</span><span class="nc">B</span><span class="o">]</span> <span class="o">(</span><span class="nc">F</span><span class="o">:</span> <span class="nc">A</span> <span class="o">-&gt;</span> <span class="nc">B</span><span class="o">)</span>
    <span class="o">[</span><span class="nc">C</span><span class="o">]</span> <span class="o">(</span><span class="nc">H</span> <span class="o">:</span> <span class="k">sig</span> <span class="k">module</span> <span class="nc">Make</span> <span class="o">:</span> <span class="nc">B</span> <span class="o">-&gt;</span> <span class="nc">C</span> <span class="k">end</span><span class="o">)</span>
  <span class="o">=</span> <span class="nn">H</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">F</span><span class="o">(</span><span class="nc">X</span><span class="o">))</span>

<span class="k">module</span> <span class="nc">ApplyGv</span>
    <span class="o">[</span><span class="nc">A</span><span class="o">]</span> <span class="o">[</span><span class="nc">B</span><span class="o">]</span> <span class="o">(</span><span class="nc">F</span><span class="o">:</span><span class="nc">A</span> <span class="o">-&gt;</span> <span class="nc">GlobalVars</span> <span class="o">-&gt;</span> <span class="nc">B</span><span class="o">)</span> <span class="o">(</span><span class="nc">X</span><span class="o">:</span><span class="nc">A</span><span class="o">)</span>
  <span class="o">=</span> <span class="nc">F</span><span class="o">(</span><span class="nc">X</span><span class="o">)(</span><span class="nc">Gv</span><span class="o">)</span>

<span class="c">(* At the call site *)</span>
<span class="k">module</span> <span class="nc">M1</span> <span class="o">=</span> <span class="nc">MakeApply</span>
    <span class="o">[</span><span class="nc">T</span><span class="o">]</span> <span class="o">(</span><span class="nc">X</span><span class="o">)</span>
    <span class="o">[</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="nc">HashedType</span><span class="o">]</span> <span class="o">(</span><span class="nc">F</span><span class="o">)</span>
    <span class="o">[</span><span class="nn">Hashtbl</span><span class="p">.</span><span class="nc">S</span><span class="o">]</span> <span class="o">(</span><span class="nc">Hashtbl</span><span class="o">)</span>

<span class="k">module</span> <span class="nc">M2</span> <span class="o">=</span> <span class="nc">ApplyGv</span> <span class="o">[</span><span class="nc">A</span><span class="o">]</span> <span class="o">[</span><span class="nc">B</span><span class="o">]</span> <span class="o">(</span><span class="nc">F</span><span class="o">)</span> <span class="o">(</span><span class="nc">X</span><span class="o">)</span>
</pre></div>

<p>Technically, this is not just syntactic sugar for anonymous
parameters due to the fact that OCaml relies on names for applicativity
of functors.</p>
<h6>Inference</h6>
<p>Following up on the previous point, usability of abstract signatures
could even be improved with some form of inference at call sites.
Further work is needed to understand to what extend this could be
done.</p>
<h4>Conclusion</h4>
<p>We have presented the feature of <em>abstract signatures</em> in
OCaml. After showing use cases via examples, we explained the issues
associated with the unrestricted syntactical approach. Then, we propose
a new specification: <em>simple abstract signatures</em>. In addition to
making the behavior of abstract signatures much more predictable for the
user, this approach can be fully formalized by translation into F&omega;
(extended with predicative kinds).</p>
<p>As stated above, our goal here was both to sum up the current state
and our proposal, but also to gather feedback from users or potential
users. In particular, we want to see if it can indeed cover all use
cases, and if we missed other usability problems.</p>


