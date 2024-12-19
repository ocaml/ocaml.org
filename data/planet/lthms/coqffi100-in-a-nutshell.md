---
title: coqffi.1.0.0 In A Nutshell
description: For each entry of a cmi file, coqffi tries to generate an equivalent
  (from the extraction mechanism perspective) Coq definition. In this article, we
  walk through how coqffi works.
url: https://soap.coffee/~lthms/posts/Coqffi-1-0-0.html
date: 2020-12-10T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1><code class="hljs">coqffi.1.0.0</code> In A Nutshell</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/coq.html" marked="" class="tag">coq</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/coqffi.html" marked="" class="tag">coqffi</a> </div>
<p>For each entry of a <code class="hljs">cmi</code> file (a <em>compiled</em> <code class="hljs">mli</code> file), <code class="hljs">coqffi</code>
tries to generate an equivalent (from the extraction mechanism
perspective) Coq definition. In this article, we walk through how
<code class="hljs">coqffi</code> works.</p>
<p>Note that we do not dive into the vernacular commands <code class="hljs">coqffi</code>
generates. They are of no concern for users of <code class="hljs">coqffi</code>.</p>
<h2>Getting Started</h2>
<h3>Requirements</h3>
<p>The latest version of <code class="hljs">coqffi</code> (<code class="hljs">1.0.0~beta8</code>)
is compatible with OCaml <code class="hljs">4.08</code> up to <code class="hljs">4.14</code>, and Coq <code class="hljs">8.12</code> up top
<code class="hljs">8.13</code>.  If you want to use <code class="hljs">coqffi</code>, but have incompatible
requirements of your own, feel free to
<a href="https://github.com/coq-community/coqffi/issues" marked="">submit an issue&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<h3>Installing <code class="hljs">coqffi</code></h3>
<p>The recommended way to install <code class="hljs">coqffi</code> is through the
<a href="https://coq.inria.fr/opam/www" marked="">Opam Coq Archive&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, in the <code class="hljs">released</code>
repository.  If you haven’t activated this repository yet, you can use the
following bash command.</p>
<pre><code class="hljs language-bash">opam repo add coq-released https://coq.inria.fr/opam/released
</code></pre>
<p>Then, installing <code class="hljs">coqffi</code> is as simple as</p>
<pre><code class="hljs language-bash">opam install coq-coqffi
</code></pre>
<p>You can also get the source from <a href="https://github.com/coq-community/coqffi" marked="">the upstream <code class="hljs">git</code>
repository&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. The <code class="hljs">README</code> provides the
necessary pieces of information to build it from source.</p>
<h3>Additional Dependencies</h3>
<p>One major difference between Coq and OCaml is that the former is pure,
while the latter is not. Impurity can be modeled in pure languages,
and Coq does not lack of frameworks in this respect. <code class="hljs">coqffi</code> currently
supports two of them:
<a href="https://github.com/Lysxia/coq-simple-io" marked=""><code class="hljs">coq-simple-io</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> and
<a href="https://github.com/ANSSI-FR/FreeSpec" marked="">FreeSpec&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. It is also possible to use it
with <a href="https://github.com/DeepSpec/InteractionTrees" marked="">Interaction Trees&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, albeit
in a less direct manner.</p>
<h3>Primitive Types</h3>
<p><code class="hljs">coqffi</code> supports a set of primitive types, <em>i.e.</em>, a set of OCaml
types for which it knows an equivalent type in Coq. The list is the
following (the Coq types are fully qualified in the table, but not in
the generated Coq module as the necessary <code class="hljs">Import</code> statements are
generated too).</p>
<table>
<thead>
<tr>
<th>OCaml type</th>
<th>Coq type</th>
</tr>
</thead>
<tbody>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">bool</span></code></td>
<td><code class="hljs">Coq.Init.Datatypes.bool</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">char</span></code></td>
<td><code class="hljs">Coq.Strings.Ascii.ascii</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">int</span></code></td>
<td><code class="hljs">CoqFFI.Data.Int.i63</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span></code></td>
<td><code class="hljs">Coq.Init.Datatypes.list a</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> <span class="hljs-type">Seq</span>.t</code></td>
<td><code class="hljs">CoqFFI.Data.Seq.t</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> option</code></td>
<td><code class="hljs">Coq.Init.Datatypes.option a</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml">(<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'e</span>) result</code></td>
<td><code class="hljs">Coq.Init.Datatypes.sum</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">string</span></code></td>
<td><code class="hljs">Coq.Strings.String.string</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">unit</span></code></td>
<td><code class="hljs">Coq.Init.Datatypes.unit</code></td>
</tr>
<tr>
<td><code class="hljs language-ocaml"><span class="hljs-built_in">exn</span></code></td>
<td><code class="hljs">CoqFFI.Exn</code></td>
</tr>
</tbody>
</table>
<p>The <code class="hljs language-coq">i63</code> type is introduced by the <code class="hljs language-coq">CoqFFI</code> theory to provide
signed primitive integers to Coq users. They are implemented on top of the
(unsigned) Coq native integers introduced in Coq <code class="hljs">8.13</code>. The <code class="hljs">i63</code> type will be
deprecated once the support for <a href="https://github.com/coq/coq/pull/13559" marked="">signed primitive
integers&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> is implemented<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">This is actually one of the sources of incompatibility of <code class="hljs">coqffi</code>
with most recent versions of Coq. </span>
</span>.</p>
<p>When processing the entries of a given interface model, <code class="hljs">coqffi</code> will
check that they only use these types, or types introduced by the
interface module itself.</p>
<p>Sometimes, you may encounter a situation where you have two interface
modules <code class="hljs">b.mli</code> and <code class="hljs">b.mli</code>, such that <code class="hljs">b.mli</code> uses a type introduced
in <code class="hljs">a.mli</code>.  To deal with this scenario, you can use the <code class="hljs">--witness</code>
flag to generate <code class="hljs">A.v</code>.  This will tell <code class="hljs">coqffi</code> to also generate
<code class="hljs">A.ffi</code>; this file can then be used when generating <code class="hljs">B.v</code> thanks to
the <code class="hljs">-I</code> option.  Furthermore, for <code class="hljs">B.v</code> to compile the <code class="hljs">--require</code>
option needs to be used to ensure the <code class="hljs">A</code> Coq library (<code class="hljs">A.v</code>) is
required.</p>
<p>To give a more concrete example, given ~a.mli~</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> t
</code></pre>
<p>and <code class="hljs">b.mli</code></p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> a = <span class="hljs-type">A</span>.t
</code></pre>
<p>To generate <code class="hljs">A.v</code>, we can use the following commands:</p>
<pre><code class="hljs language-bash">ocamlc a.mli
coqffi --witness -o A.v a.cmi
</code></pre>
<p>Which would generate the following axiom for <code class="hljs">t</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> t : <span class="hljs-keyword">Type</span>.
</code></pre>
<p>Then, generating <code class="hljs">B.v</code> can be achieved as follows:</p>
<pre><code class="hljs language-bash">ocamlc b.mli
coqffi -I A.ffi -ftransparent-types -r A -o B.v b.cmi
</code></pre>
<p>which results in the following output for <code class="hljs">v</code>:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Require</span> A.

<span class="hljs-keyword">Definition</span> u : <span class="hljs-keyword">Type</span> := A.t.
</code></pre>
<h2>Code Generation</h2>
<p><code class="hljs">coqffi</code> distinguishes five types of entries: types, pure values,
impure primitives, asynchronous primitives, exceptions, and
modules. We now discuss how each one of them is handled.</p>
<h3>Types</h3>
<p>By default, <code class="hljs">coqffi</code> generates axiomatized definitions for each type defined in
a <code class="hljs">.cmi</code> file. This means that <code class="hljs language-ocaml"><span class="hljs-keyword">type</span> t</code> becomes <code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> t : <span class="hljs-keyword">Type</span></code>.
Polymorphism is supported, <em>i.e.</em>, <code class="hljs language-ocaml"><span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> t</code> becomes <code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> t : <span class="hljs-keyword">forall</span> (a : <span class="hljs-keyword">Type</span>), <span class="hljs-keyword">Type</span></code>.</p>
<p>It is possible to provide a “model” for a type using the <code class="hljs">coq_model</code>
annotation, for instance, for reasoning purposes. That is, we can specify
that a type is equivalent to a <code class="hljs">list</code>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> t [@@coq_model <span class="hljs-string">"list"</span>]
</code></pre>
<p>This generates the following Coq definition.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> t : <span class="hljs-keyword">forall</span> (a : <span class="hljs-keyword">Type</span>), <span class="hljs-keyword">Type</span> := list.
</code></pre>
<p>It is important to be careful when using the =coq_model= annotation. More
precisely, the fact that <code class="hljs">t</code> is a <code class="hljs">list</code> in the “Coq universe” shall not be
used while the implementation phase, only the verification phase.</p>
<p>Unnamed polymorphic type parameters are also supported. In presence of
such parameters, <code class="hljs">coqffi</code> will find it a name that is not already
used. For instance,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> (_, <span class="hljs-symbol">'a</span>) ast
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> ast : <span class="hljs-keyword">forall</span> (b : <span class="hljs-keyword">Type</span>) (a : <span class="hljs-keyword">Type</span>), <span class="hljs-keyword">Type</span>.
</code></pre>
<p>Finally, <code class="hljs">coqffi</code> has got an experimental feature called <code class="hljs">transparent-types</code>
(enabled by using the <code class="hljs">-ftransparent-types</code> command-line argument). If the type
definition is given in the module interface, then <code class="hljs">coqffi</code> tries to generate
an equivalent definition in Coq. For instance,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> llist =
  | <span class="hljs-type">LCons</span> <span class="hljs-keyword">of</span> <span class="hljs-symbol">'a</span> * (<span class="hljs-built_in">unit</span> -&gt; <span class="hljs-symbol">'a</span> llist)
  | <span class="hljs-type">LNil</span>
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> llist (a : <span class="hljs-keyword">Type</span>) : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">LCons</span> (x0 : a) (x1 : unit -&gt; llist a) : llist a
| <span class="hljs-type">LNil</span> : llist a.
</code></pre>
<p>Mutually recursive types are supported, so</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> even = <span class="hljs-type">Zero</span> | <span class="hljs-type">ESucc</span> <span class="hljs-keyword">of</span> odd
<span class="hljs-keyword">and</span> odd = <span class="hljs-type">OSucc</span> <span class="hljs-keyword">of</span> even
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> odd : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">OSucc</span> (x0 : even) : odd
<span class="hljs-built_in">with</span> even : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">Zero</span> : even
| <span class="hljs-type">ESucc</span> (x0 : odd) : even.
</code></pre>
<p>Besides, <code class="hljs">coqffi</code> supports alias types, as suggested in this write-up
when we discuss witness files.</p>
<p>The <code class="hljs">transparent-types</code> feature is <strong>experimental</strong>, and is currently
limited to variant types. It notably does not support records. Besides, it may
generate incorrect Coq types, because it does not check whether or not the
<a href="https://coq.inria.fr/refman/language/core/inductive.html#positivity-condition" marked="">positivity
condition&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
is satisfied.</p>
<h3>Pure values</h3>
<p><code class="hljs">coqffi</code> decides whether or not a given OCaml value is pure or impure
with the following heuristics:</p>
<ul>
<li>Constants are pure</li>
<li>Functions are impure by default</li>
<li>Functions with a <code class="hljs">coq_model</code> annotation are pure</li>
<li>Functions marked with the <code class="hljs">pure</code> annotation are pure</li>
<li>If the <code class="hljs">pure-module</code> feature is enabled (<code class="hljs">-fpure-module</code>), then synchronous
functions (which do not live inside the
<a href="https://ocsigen.org/lwt/5.3.0/manual/manual" marked="">~Lwt~&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> monad) are pure</li>
</ul>
<p>Similarly to types, <code class="hljs">coqffi</code> generates axioms (or definitions if the
<code class="hljs">coq_model</code> annotation is used) for pure values. Then,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> unpack : <span class="hljs-built_in">string</span> -&gt; (<span class="hljs-built_in">char</span> * <span class="hljs-built_in">string</span>) option [@@pure]
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-ocaml"><span class="hljs-type">Axiom</span> unpack : <span class="hljs-built_in">string</span> -&gt; option (ascii * <span class="hljs-built_in">string</span>).
</code></pre>
<p>Polymorphic values are supported.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> map : (<span class="hljs-symbol">'a</span> -&gt; <span class="hljs-symbol">'b</span>) -&gt; <span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span> -&gt; <span class="hljs-symbol">'b</span> <span class="hljs-built_in">list</span> [@@pure]
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> map : <span class="hljs-keyword">forall</span> (a : <span class="hljs-keyword">Type</span>) (b : <span class="hljs-keyword">Type</span>), (a -&gt; b) -&gt; list a -&gt; list b.
</code></pre>
<p>Again, unnamed polymorphic typse are supported, so</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> ast_to_string : _ ast -&gt; <span class="hljs-built_in">string</span> [@@pure]
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> ast_to_string : <span class="hljs-keyword">forall</span> (a : <span class="hljs-keyword">Type</span>), string.
</code></pre>
<h3>Impure Primitives</h3>
<p><code class="hljs">coqffi</code> reserves a special treatment for /impure/ OCaml functions.
Impurity is usually handled in pure programming languages by means of
monads, and <code class="hljs">coqffi</code> is no exception to the rule.</p>
<p>Given the set of impure primitives declared in an interface module,
<code class="hljs">coqffi</code> will (1) generate a typeclass which gathers these primitives,
and (2) generate instances of this typeclass for supported backends.</p>
<p>We illustrate the rest of this section with the following impure
primitives.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> echo : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">unit</span>
<span class="hljs-keyword">val</span> scan : <span class="hljs-built_in">unit</span> -&gt; <span class="hljs-built_in">string</span>
</code></pre>
<p>where <code class="hljs">echo</code> allows writing something the standard output, and <code class="hljs">scan</code>
to read the standard input.</p>
<p>Assuming the processed module interface is named <code class="hljs">console.mli</code>, the
following Coq typeclass is generated.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Class</span> MonadConsole (m : <span class="hljs-keyword">Type</span> -&gt; <span class="hljs-keyword">Type</span>) := { echo : string -&gt; m unit
                                         ; scan : unit -&gt; m string
                                         }.
</code></pre>
<p>Using this typeclass and with the additional support of an additional
<code class="hljs">Monad</code> typeclass, we can specify impure computations which interacts
with the console. For instance, with the support of <code class="hljs">ExtLib</code>, one can
write.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> pipe `{Monad m, MonadConsole m} : m unit :=
  <span class="hljs-keyword">let</span>* msg := scan () <span class="hljs-built_in">in</span>
  echo msg.
</code></pre>
<p>There is no canonical way to model impurity in Coq, but over the years
several frameworks have been released to tackle this challenge.</p>
<p><code class="hljs">coqffi</code> provides three features related to impure primitives.</p>
<h4><code class="hljs">simple-io</code></h4>
<p>When this feature is enabled, <code class="hljs">coqffi</code> generates an instance of the
typeclass for the =IO= monad introduced in the <code class="hljs">coq-simple-io</code> package</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> io_echo : string -&gt; IO unit.
<span class="hljs-keyword">Axiom</span> io_scan : unit -&gt; IO string.

<span class="hljs-keyword">Instance</span> IO_MonadConsole : MonadConsole IO := { echo := io_echo
                                              ; scan := io_scan
                                              }.
</code></pre>
<p>It is enabled by default, but can be disabled using the
<code class="hljs">-fno-simple-io</code> command-line argument.</p>
<h4><code class="hljs">interface</code></h4>
<p>When this feature is enabled, <code class="hljs">coqffi</code> generates an inductive type which
describes the set of primitives available, to be used with frameworks like
<a href="https://github.com/lthms/FreeSpec" marked="">FreeSpec&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> or <a href="https://github.com/DeepSpec/InteractionTrees" marked="">Interactions
Trees&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> CONSOLE : <span class="hljs-keyword">Type</span> -&gt; <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">Echo</span> : string -&gt; CONSOLE unit
| <span class="hljs-type">Scan</span> : unit -&gt; CONSOLE string.

<span class="hljs-keyword">Definition</span> inj_echo `{Inject CONSOLE m} (x0 : string) : m unit :=
  inject (Echo x0).

<span class="hljs-keyword">Definition</span> inj_scan `{Inject CONSOLE m} (x0 : unit) : m string :=
  inject (Scan x0).

<span class="hljs-keyword">Instance</span> Inject_MonadConsole `{Inject CONSOLE m} : MonadConsole m :=
  { echo := inj_echo
  ; scan := inj_scan
  }.
</code></pre>
<p>Providing an instance of the form <code class="hljs language-coq"><span class="hljs-keyword">forall</span> i, Inject i M</code> is enough for
your monad <code class="hljs">M</code> to be compatible with this feature<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">See for instance <a href="https://github.com/lthms/FreeSpec/blob/master/theories/FFI/FFI.v" marked="">how FreeSpec implements
it&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>). </span>
</span>.</p>
<h4><code class="hljs">freespec</code></h4>
<p>When this feature in enabled, <code class="hljs">coqffi</code> generates a semantics for the
inductive type generated by the <code class="hljs">interface</code> feature.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> unsafe_echo : string -&gt; unit.
<span class="hljs-keyword">Axiom</span> unsafe_scan : uint -&gt; string.

<span class="hljs-keyword">Definition</span> console_unsafe_semantics : semantics CONSOLE :=
  bootstrap (<span class="hljs-keyword">fun</span> a e =&gt;
    local <span class="hljs-keyword">match</span> e <span class="hljs-built_in">in</span> CONSOLE a <span class="hljs-keyword">return</span> a <span class="hljs-built_in">with</span>
          | <span class="hljs-type">Echo</span> x0 =&gt; unsafe_echo x0
          | <span class="hljs-type">Scan</span> x0 =&gt; unsafe_scan x0
          <span class="hljs-keyword">end</span>).
</code></pre>
<h3>Asynchronous Primitives</h3>
<p><code class="hljs">coqffi</code> also reserves a special treatment for <em>asynchronous</em>
primitives —<em>i.e.</em>, functions which live inside the <code class="hljs">Lwt</code> monad— when
the <code class="hljs">lwt</code> feature is enabled.</p>
<p>The treatment is very analogous to the one for impure primitives: (1)
a typeclass is generated (with the <code class="hljs">_Async</code> suffix), and (2) an
instance for the <code class="hljs">Lwt</code> monad is generated. Besides, an instance for
the “synchronous” primitives is also generated for <code class="hljs">Lwt</code>. If the
<code class="hljs">interface</code> feature is enabled, an interface datatype is generated,
which means you can potentially use Coq to reason about your
asynchronous programs (using FreeSpec and alike, although the
interleaving of asynchronous programs in not yet supported in
FreeSpec).</p>
<p>By default, the type of the <code class="hljs">Lwt</code> monad is <code class="hljs">Lwt.t</code>. You can override
this setting using the <code class="hljs">--lwt-alias</code> option.  This can be useful when
you are using an alias type in place of <code class="hljs">Lwt.t</code>.</p>
<h3>Exceptions</h3>
<p>OCaml features an exception mechanism. Developers can define their
own exceptions using the <code class="hljs">exception</code> keyword, whose syntax is similar
to the constructors’ definition. For instance,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">exception</span> <span class="hljs-type">Foo</span> <span class="hljs-keyword">of</span> <span class="hljs-built_in">int</span> * <span class="hljs-built_in">bool</span>
</code></pre>
<p>introduces a new exception <code class="hljs">Foo</code> which takes two parameters of type <code class="hljs language-ocaml"><span class="hljs-built_in">int</span></code> and
<code class="hljs language-ocaml"><span class="hljs-built_in">bool</span></code>. <code class="hljs">Foo (x, y)</code> constructs of value of type <code class="hljs language-ocaml"><span class="hljs-built_in">exn</span></code>.</p>
<p>For each new exception introduced in an OCaml module, <code class="hljs">coqffi</code>
generates (1) a so-called “proxy type,” and (2) conversion functions
to and from this type.</p>
<p>Coming back to our example, the “proxy type” generates by <code class="hljs">coqffi</code> is</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> FooExn : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">MakeFooExn</span> (x0 : i63) (x1 : bool) : FooExn.
</code></pre>
<p>Then, <code class="hljs">coqffi</code> generates conversion functions.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> exn_of_foo : FooExn -&gt; exn.
<span class="hljs-keyword">Axiom</span> foo_of_exn : exn -&gt; option FooExn.
</code></pre>
<p>Besides, <code class="hljs">coqffi</code> also generates an instance for the <code class="hljs">Exn</code> typeclass
provided by the <code class="hljs">CoqFFI</code> theory:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Instance</span> FooExn_Exn : Exn FooExn :=
  { to_exn := exn_of_foo
  ; of_exn := foo_of_exn
  }.
</code></pre>
<p>Under the hood, <code class="hljs language-ocaml"><span class="hljs-built_in">exn</span></code> is an
<a href="https://caml.inria.fr/pub/docs/manual-ocaml/extensiblevariants.html" marked="">extensible
datatype&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>,
and how <code class="hljs">coqffi</code> supports it will probably be generalized in future releases.</p>
<p>Finally, <code class="hljs">coqffi</code> has a minimal support for functions which may raise
exceptions. Since OCaml type system does not allow to identify such
functions, they need to be annotated explicitly, using the
=may_raise= annotation. In such a case, <code class="hljs">coqffi</code> will change the
return type of the function to use the =sum= Coq inductive type.</p>
<p>For instance,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> from_option : <span class="hljs-symbol">'a</span> option -&gt; <span class="hljs-symbol">'a</span> [@@may_raise] [@@pure]
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Axiom</span> from_option : <span class="hljs-keyword">forall</span> (a : <span class="hljs-keyword">Type</span>), option a -&gt; <span class="hljs-built_in">sum</span> a exn.
</code></pre>
<h3>Modules</h3>
<p>Lastly, <code class="hljs">coqffi</code> supports OCaml modules described within <code class="hljs">mli</code> files,
when they are specified as <code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-type">T</span> : <span class="hljs-keyword">sig</span> ... <span class="hljs-keyword">end</span></code>. For instance,</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-type">T</span> : <span class="hljs-keyword">sig</span>
  <span class="hljs-keyword">type</span> t

  <span class="hljs-keyword">val</span> to_string : t -&gt; <span class="hljs-built_in">string</span> [@@pure]
<span class="hljs-keyword">end</span>
</code></pre>
<p>becomes</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Module</span> T.
  <span class="hljs-keyword">Axiom</span> t : <span class="hljs-keyword">Type</span>.

  <span class="hljs-keyword">Axiom</span> to_string : t -&gt; string.
<span class="hljs-keyword">End</span> T.
</code></pre>
<p>As of now, the following construction is unfortunately <em>not</em>
supported, and will be ignored by <code class="hljs">coqffi</code>:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-type">S</span> = <span class="hljs-keyword">sig</span>
  <span class="hljs-keyword">type</span> t

  <span class="hljs-keyword">val</span> to_string : t -&gt; <span class="hljs-built_in">string</span> [@@pure]
<span class="hljs-keyword">end</span>

<span class="hljs-keyword">module</span> <span class="hljs-type">T</span> : <span class="hljs-type">S</span>
</code></pre>
<h2>Moving Forward</h2>
<p><code class="hljs">coqffi</code> comes with a comprehensive man page. In addition, the
interested reader can proceed to the next article of this series,
which explains how <a href="https://soap.coffee/~lthms/posts/CoqffiEcho.html" marked=""><code class="hljs">coqffi</code> can be used to easily implement an echo
server in Coq</a>.</p>
        
      
