---
title: Extensible Records in OCaml Using dmap
description: We show how it is possible to use dmap to implement extensible records
  (that is, records which can be extended with new fields after they have been defined)
  in OCaml.
url: https://soap.coffee/~lthms/posts/ExtensibleRecordsInOCaml.html
date: 2023-06-20T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Extensible Records in OCaml Using <code class="hljs">dmap</code></h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> </div>
<p><a href="https://ocaml.org/p/dmap/latest/" marked=""><code class="hljs">dmap</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> is a library to create and
manipulate heterogeneous maps. It features a very straightforward API which
leverages the common trick of tagging the type of the keys with a parameter
specifying the types of the associated values<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">This article assumes readers are familiar with GADTs. </span>
</span>. That is, given <code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> key</code> the type of keys of a heterogeneous map <code class="hljs language-ocaml">t</code>, then the
value associated to a key <code class="hljs language-ocaml">k</code> of type <code class="hljs language-ocaml"><span class="hljs-built_in">bool</span> key</code> is expected to
be of type <code class="hljs language-ocaml"><span class="hljs-built_in">bool</span></code>.</p>
<p>In this write-up, we show how it is possible to use <code class="hljs">dmap</code> to implement
extensible records (that is, records which can be extended with new fields
after they have been defined) in OCaml. I have also published on GitHub <a href="https://github.com/lthms/extensible-records-minimal" marked="">a
repository containing the implementation presented in this
article&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>. While <code class="hljs">dmap</code> is
far from being the only available solution for this use case<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">For heterogeneous maps, <a href="https://ocaml.org/p/gmap/latest" marked=""><code class="hljs">gmap</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> is
apparently a popular alternative, and so is
<a href="https://ocaml.org/p/hmap/latest" marked=""><code class="hljs">hmap</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. For extensible records,
<a href="https://ocaml.org/p/orec/latest" marked=""><code class="hljs">orec</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> looks like a very interesting
library I should probably take a long look at. </span>
</span>, it is the
one I happened to use for implementing a “plugin system” in a library where
each plugin can manipulate a shared state in a type-safe way.</p>
<h2>Encoding Extensible Records</h2>
<p>The (simplified) module type of a heterogeneous map built using <code class="hljs">dmap</code> is as
follows.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-keyword">type</span> <span class="hljs-type">S</span> = <span class="hljs-keyword">sig</span>
  <span class="hljs-keyword">type</span> t
  
  <span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> key

  <span class="hljs-keyword">type</span> binding = <span class="hljs-type">Binding</span> : <span class="hljs-symbol">'a</span> key * <span class="hljs-symbol">'a</span> -&gt; binding

  <span class="hljs-keyword">val</span> empty : t

  <span class="hljs-keyword">val</span> add : <span class="hljs-symbol">'a</span> key -&gt; <span class="hljs-symbol">'a</span> -&gt; t -&gt; t

  <span class="hljs-keyword">val</span> find_opt : <span class="hljs-symbol">'a</span> key -&gt; t -&gt; <span class="hljs-symbol">'a</span> option

  <span class="hljs-keyword">val</span> fold_left : (<span class="hljs-symbol">'a</span> -&gt; binding -&gt; a) -&gt; <span class="hljs-symbol">'a</span> -&gt; t -&gt; <span class="hljs-symbol">'a</span>
<span class="hljs-keyword">end</span>
</code></pre>
<p>The use case for heterogeneous maps I’ve been interested in recently is
encoding records. More precisely, constructors of keys encode fields containing
collections of values. In such approach, a constructor <code class="hljs language-ocaml"><span class="hljs-type">Foo</span> : <span class="hljs-built_in">int</span> key</code>
encodes a field of type <code class="hljs">int option</code>, while a constructor <code class="hljs language-ocaml"><span class="hljs-type">Bar</span> : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">bool</span> key</code> encodes a field of type <code class="hljs">bool StringMap.t</code>. That is, the
heterogeneous map <code class="hljs">HMap.t</code>, such as</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> _ key = <span class="hljs-type">Foo</span> : <span class="hljs-built_in">int</span> key | <span class="hljs-type">Bar</span> : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">bool</span> key

<span class="hljs-keyword">module</span> <span class="hljs-type">HMap</span> : <span class="hljs-type">S</span> <span class="hljs-keyword">with</span> <span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> key  = <span class="hljs-symbol">'a</span> key
</code></pre>
<p>can be used to encode values of a record type</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> t = {
  foo : <span class="hljs-built_in">int</span> option;
  bar : <span class="hljs-built_in">bool</span> <span class="hljs-type">StringMap</span>.t;
}
</code></pre>
<p>as the following conversion functions demonstrates.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> of_record {foo; bar} =
  <span class="hljs-keyword">let</span> res = <span class="hljs-type">HMap</span>.empty <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> res = <span class="hljs-type">HMap</span>.add <span class="hljs-type">Foo</span> foo res <span class="hljs-keyword">in</span>
  <span class="hljs-type">StringMap</span>.fold_left
    (<span class="hljs-keyword">fun</span> res (key, <span class="hljs-keyword">value</span>) -&gt; <span class="hljs-type">HMap</span>.add (<span class="hljs-type">Bar</span> key) <span class="hljs-keyword">value</span> res)
    res
    bar

<span class="hljs-keyword">let</span> of_hmap map =
  {
    foo = <span class="hljs-type">HMap</span>.find_opt <span class="hljs-type">Foo</span> map;
    bar = <span class="hljs-type">HMap</span>.fold_left
            (<span class="hljs-keyword">fun</span> smap (<span class="hljs-type">Binding</span> binding) -&gt;
               <span class="hljs-keyword">match</span> binding <span class="hljs-keyword">with</span>
               | (<span class="hljs-type">Bar</span> k, v) -&gt; <span class="hljs-type">StringMap</span>.add k v smap
               | _ -&gt; smap)
            <span class="hljs-type">StringMap</span>.empty
            map;
  }
</code></pre>
<p>As a consequence, to construct a heterogeneous map whose type of keys is
extensible is a way to get extensible records in OCaml.</p>
<p>To that end, <code class="hljs">dmap</code> only asks for a function to compare two arbitrary keys.
More precisely, given the type</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> _ key = ..
</code></pre>
<p>the challenge is to write the function <code class="hljs">compare</code> of type</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> compare : <span class="hljs-symbol">'a</span> key -&gt; <span class="hljs-symbol">'b</span> key -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) <span class="hljs-type">Dmap</span>.cmp
</code></pre>
<p>with <code class="hljs language-ocaml"><span class="hljs-type">Dmap</span>.cmp</code> being defined<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">This definition of <code class="hljs language-ocaml">cmp</code> enforces that two keys can only be
equal if and only if the values associated to them are of the same type. </span>
</span> as</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> (_, _) cmp =
  | <span class="hljs-type">Lt</span> : (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) cmp
  | <span class="hljs-type">Eq</span>  : (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'a</span>) cmp
  | <span class="hljs-type">Gt</span> : (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) cmp
</code></pre>
<h2>The Solution</h2>
<p>To use extensible types in this kind of setting, the trick I am aware of is to
use a registration mechanism<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">For instance, this is what the <code class="hljs">tezos-error-monad</code> package is
using for being able to <a href="https://ocaml.org/p/tezos-error-monad/13.0/doc/Tezos_error_monad/Error_monad/index.html#val-register_error_kind" marked="">print the values of its extensible error
type&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. </span>
</span>.</p>
<p>The <code class="hljs language-ocaml">compare</code> function will work as follows.</p>
<ol>
<li>We assign an integer to each constructor of the type <code class="hljs language-ocaml">key</code>.</li>
<li>We compare these integers when the arguments of <code class="hljs">compare</code> are constructed
from different constructors.</li>
<li>We implement one comparison function per constructors, to be called when the
two arguments of <code class="hljs">compare</code> are the same.</li>
</ol>
<p>The exercise is being made a bit more complicated than what the previous
paragraph suggests due to the fact that both <code class="hljs">key</code> and <code class="hljs">cmp</code> are GADTs. As a
consequence, the rest of the article will proceed as follows. First, we will
implement the overall logic of the <code class="hljs language-ocaml">compare</code> function implemented with
a registration mechanism, and only then will we tackle the OCaml compiler
errors GADTs so often bring.</p>
<h3>Step 1: Forget About GADTs</h3>
<p>To implement our registration mechanism, we rely on a good old reference to a
list<label for="fn5" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">It is a good idea to hide this implementation “details”
behind a nice API, using a <code class="hljs">mli</code> file. </span>
</span>. The position of a registered object within the list will
determine the integer attributed to it.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> registered_keys = <span class="hljs-built_in">ref</span> <span class="hljs-literal">[]</span>

<span class="hljs-keyword">let</span> register_key key =
  registered_keys := key :: !registered_keys
</code></pre>
<p>In this list, we store a collection of first-class modules which provide
us everything we need to compare two <code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> key</code> values obtained from the
same constructors.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-keyword">type</span> <span class="hljs-type">KEY</span> = <span class="hljs-keyword">sig</span>
  <span class="hljs-keyword">type</span> t

  <span class="hljs-keyword">val</span> proj : <span class="hljs-symbol">'a</span> key -&gt; t option
  <span class="hljs-keyword">val</span> compare : t -&gt; t -&gt; <span class="hljs-built_in">int</span>
<span class="hljs-keyword">end</span>
</code></pre>
<p>The type <code class="hljs language-ocaml">t</code> of the module type <code class="hljs language-ocaml"><span class="hljs-type">KEY</span></code> is the type of one
constructor’s arguments. The simplest definition of <code class="hljs language-ocaml">t</code> is
<code class="hljs language-ocaml"><span class="hljs-built_in">unit</span></code>, which means the field encoded with the related constructor
points to a singleton value (as <code class="hljs language-ocaml">foo</code> did in the previous section).</p>
<p>However, it is also possible to have keys’ constructors taking arguments, which
would translate into a field pointing to collections of value. This was the case
for <code class="hljs">bar</code>, which was pointing to a mapping of strings to booleans.</p>
<p>The <code class="hljs">compare</code> function will consist in iterating over the first-class modules
registered in <code class="hljs">registered_keys</code>, in order to determine to which ones the two
arguments belong to.</p>
<p>This means that considering a call <code class="hljs">compare left right</code>, for each first-class module
of <code class="hljs">registered_keys</code>, either</p>
<ol>
<li>both <code class="hljs">left</code> and <code class="hljs">right</code> have not yet been associated to a first-class module,</li>
<li>or <code class="hljs">left</code> has, but `right hasn’t</li>
<li>or <code class="hljs">right</code> has, but <code class="hljs">left</code> hasn’t</li>
<li>or both <code class="hljs">left</code> and `right have been associated to a first-class module.</li>
</ol>
<p>Only when the fourth stage has been reached can we provide the expected result
of <code class="hljs">compare</code>, whose type we have simplified in this section to return a <code class="hljs">int</code>
instead of the GADT <code class="hljs">Dmap.cmp</code>.</p>
<p>To encode these stages, we introduce a dedicated accumulator type.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) acc =
  | <span class="hljs-type">Init</span> : <span class="hljs-symbol">'a</span> key * <span class="hljs-symbol">'b</span> key -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) acc
  | <span class="hljs-type">Compare_left_with</span> : <span class="hljs-symbol">'a</span> key * <span class="hljs-built_in">int</span> -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) acc
  | <span class="hljs-type">Compare_right_with</span> : <span class="hljs-built_in">int</span> * <span class="hljs-symbol">'b</span> key -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) acc
  | <span class="hljs-type">Res</span> : <span class="hljs-built_in">int</span> -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) acc
</code></pre>
<p>This allows us to implement <code class="hljs">compare</code><label for="fn6" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Note the use of the <code class="hljs">Seq</code> module here. It is motivated by the fact that
<code class="hljs">List.fold_lefti</code> does not exist.</span>
<span class="footnote-p">We need to know the position of the current first-class module we are
testing the keys against, hence the need for a <code class="hljs">fold_lefti</code>. Of course, we
could have added the current position to the <code class="hljs">acc</code> type, but the function
is already cumbersome enough, and using <code class="hljs">Seq.t</code> is mostly free. </span>
</span>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> compare : <span class="hljs-keyword">type</span> a b. a key -&gt; b key -&gt; <span class="hljs-built_in">int</span> =
 <span class="hljs-keyword">fun</span> left right -&gt;
  <span class="hljs-type">List</span>.to_seq !registered_keys
  |&gt; <span class="hljs-type">Seq</span>.fold_lefti
       (<span class="hljs-keyword">fun</span> (acc : (a, b) acc) i (<span class="hljs-keyword">module</span> <span class="hljs-type">K</span> : <span class="hljs-type">KEY</span>) -&gt;
         <span class="hljs-keyword">match</span> acc <span class="hljs-keyword">with</span>
         | <span class="hljs-type">Init</span> (left, right) -&gt; (
             <span class="hljs-keyword">match</span> (<span class="hljs-type">K</span>.proj left, <span class="hljs-type">K</span>.proj right) <span class="hljs-keyword">with</span>
             | <span class="hljs-type">Some</span> left, <span class="hljs-type">Some</span> right -&gt; <span class="hljs-type">Res</span> (<span class="hljs-type">K</span>.compare left right)
             | <span class="hljs-type">Some</span> _, <span class="hljs-type">None</span> -&gt; <span class="hljs-type">Compare_right_with</span> (i, right)
             | <span class="hljs-type">None</span>, <span class="hljs-type">Some</span> _ -&gt; <span class="hljs-type">Compare_left_with</span> (left, i)
             | <span class="hljs-type">None</span>, <span class="hljs-type">None</span> -&gt; acc)
         | <span class="hljs-type">Compare_right_with</span> (j, right) -&gt; (
             <span class="hljs-keyword">match</span> <span class="hljs-type">K</span>.proj right <span class="hljs-keyword">with</span>
             | <span class="hljs-type">Some</span> _ -&gt; <span class="hljs-type">Res</span> (<span class="hljs-type">Int</span>.compare j i)
             | <span class="hljs-type">None</span> -&gt; acc)
         | <span class="hljs-type">Compare_left_with</span> (left, j) -&gt; (
             <span class="hljs-keyword">match</span> <span class="hljs-type">K</span>.proj left <span class="hljs-keyword">with</span>
             | <span class="hljs-type">Some</span> _ -&gt; <span class="hljs-type">Res</span> (<span class="hljs-type">Int</span>.compare i j)
             | <span class="hljs-type">None</span> -&gt; acc)
         | _ -&gt; acc)
       (<span class="hljs-type">Init</span> (left, right))
  |&gt; <span class="hljs-keyword">function</span>
  | <span class="hljs-type">Res</span> x -&gt; x
  | _ -&gt;
      raise
        (<span class="hljs-type">Invalid_argument</span>
           <span class="hljs-string">"comparison with at least one unregistered key variant"</span>)
</code></pre>
<p>This function gives us the overall structure and logic of <code class="hljs">compare</code>, but of
course we are not done yet.</p>
<h3>Step 2: Deal with GADTs</h3>
<p>In practice and as hinted in the introduction of this section, <code class="hljs">dmap</code> is not
expected a comparison function of type <code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> key -&gt; <span class="hljs-symbol">'b</span> key -&gt; (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'b</span>) <span class="hljs-type">Dmap</span>.cmp</code>, not <code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> key -&gt; <span class="hljs-symbol">'b</span> key -&gt; <span class="hljs-built_in">int</span></code>.</p>
<p>The first step is to update <code class="hljs">acc</code> accordingly.</p>
<pre><code class="hljs language-patch">type ('a, 'b) acc =
   | Init : 'a key * 'b key -&gt; ('a, 'b) acc
   | Compare_left_with : 'a key * int -&gt; ('a, 'b) acc
   | Compare_right_with : int * 'b key -&gt; ('a, 'b) acc
<span class="hljs-deletion">-  | Res : int -&gt; ('a, 'b) acc</span>
<span class="hljs-addition">+  | Res : ('a, 'b) Dmap.cmp -&gt; ('a, 'b) acc</span>
</code></pre>
<p>Then, we focus our attention to modifying <code class="hljs language-ocaml">compare</code>, by modifying its
type signature, and by updating its definition to make use of the new
<code class="hljs language-ocaml">acc</code> type.</p>
<pre><code class="hljs language-patch"><span class="hljs-deletion">-let compare : type a b. a key -&gt; b key -&gt; int =</span>
<span class="hljs-addition">+let compare : type a b. a key -&gt; b key -&gt; (a, b) Dmap.cmp =</span>
  fun left right -&gt;
   List.to_seq !registered_keys
   |&gt; Seq.fold_lefti
       (fun (acc : (a, b) acc) i (module K : KEY) -&gt;
          match acc with
          | Init (left, right) -&gt; (
              match (K.proj left, K.proj right) with
<span class="hljs-deletion">-             | Some left, Some right -&gt; Res (K.compare left right)</span>
<span class="hljs-addition">+             | Some left, Some right -&gt;</span>
<span class="hljs-addition">+                 let x = K.compare left right in</span>
<span class="hljs-addition">+                 Res (if x = 0 then Eq else if x &lt; 0 then Lt else Gt)</span>
              | Some _, None -&gt; Compare_right_with (i, right)
              | None, Some _ -&gt; Compare_left_with (left, i)
              | None, None -&gt; acc)
          | Compare_right_with (j, right) -&gt; (
              match K.proj right with
<span class="hljs-deletion">-             | Some _ -&gt; Res (Int.compare j i)</span>
<span class="hljs-addition">+             | Some _ -&gt;</span>
<span class="hljs-addition">+                 let x = Int.compare j i in</span>
<span class="hljs-addition">+                 Res (if x &lt; 0 then Lt else Gt)</span>
              | None -&gt; acc)
          | Compare_left_with (left, j) -&gt; (
              match K.proj left with
<span class="hljs-deletion">-             | Some _ -&gt; Res (Int.compare i j)</span>
<span class="hljs-addition">+             | Some _ -&gt;</span>
<span class="hljs-addition">+                 let x = Int.compare j i in</span>
<span class="hljs-addition">+                 Res (if x &lt; 0 then Lt else Gt)</span>
              | None -&gt; acc)
          | _ -&gt; acc)
        (Init (left, right))
</code></pre>
<p>At this point, we are remembered that the OCaml compiler is not that easy to
please when GADTs are involved. In particular, it complains for our use
of <code class="hljs">Eq</code>.</p>
<pre><code class="hljs">46 |               Res (if x = 0 then Eq else if x &lt; 0 then Lt else Gt)
                                      ^^
Error: This expression has type (a, a) Dmap.cmp
       but an expression was expected of type (a, b) Dmap.cmp
       Type a is not compatible with type b
</code></pre>
<p>This error message is the result of a tragedy in two acts:</p>
<ol>
<li>The <code class="hljs">Eq</code> constructor of <code class="hljs">cmp</code> is of type <code class="hljs">('a, 'a) cmp</code>. That is, only two
keys associated with values of the same type can be equal.</li>
<li><code class="hljs">compare</code> takes two keys whose types can be different, and even if <code class="hljs">proj</code> is
expected to return a <code class="hljs">Some</code> only when both keys are constructed with the
same constructor, <em>nothing</em> in its type enforces that invariant.</li>
</ol>
<p>As such, OCaml is not convinced with our code alone that <code class="hljs">a = b</code>, and rejects
it.</p>
<p>One possible trick here is to rely on an equality witness type<label for="fn7" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">This is <em>the</em> trick to keep in mind when playing with GADTs, to a
point where <code class="hljs language-ocaml">eq</code> could arguably be added to the OCaml’s standard
library. </span>
</span>, and
refine <code class="hljs">proj</code> in order to convince OCaml our code is type-safe.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> (_, _) eq = <span class="hljs-type">Refl</span> : (<span class="hljs-symbol">'a</span>, <span class="hljs-symbol">'a</span>) eq
</code></pre>
<p>We then modify <code class="hljs language-ocaml"><span class="hljs-type">KEY</span></code> to have <code class="hljs language-ocaml">proj</code> not only return the
arguments of the constructor, but also a type equality witness to unify the
polymorphic argument of <code class="hljs">key</code> to the expected value type of said constructor.</p>
<pre><code class="hljs language-patch"> module type KEY = sig
   type t
<span class="hljs-addition">+  type r</span>
 
<span class="hljs-deletion">-  val proj : 'a key -&gt; t option</span>
<span class="hljs-addition">+  val proj : 'a key -&gt; (t * ('a, r) eq) option</span>
   val compare : t -&gt; t -&gt; int
 end
</code></pre>
<p>This is enough to convince OCaml that <code class="hljs">a = b</code>, because it gets a proof that <code class="hljs">a = K.r</code> and <code class="hljs">b = K.r</code><label for="fn8" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">But only if you actually match <code class="hljs">Refl</code> explicitly, meaning the
pattern <code class="hljs">Some (left, _), Some (right, _)</code> would still lead to the same
error as not returning <code class="hljs">Refl</code> at all. </span>
</span>.</p>
<pre><code class="hljs language-patch">           match (K.proj left, K.proj right) with
<span class="hljs-deletion">-          | Some left, Some right -&gt;</span>
<span class="hljs-addition">+          | Some (left, Refl), Some (right, Refl) -&gt;</span>
               let x = K.compare left right in
               Res (if x = 0 then Eq else if x &lt; 0 then Lt else Gt)
           | Some _, None -&gt; Compare_right_with (i, right)
           | None, Some _ -&gt; Compare_left_with (left, i)
</code></pre>
<p>That’s it. <code class="hljs">compare</code> is done, compiles, and satisfies the expectations of
<code class="hljs">dmap</code>. We can instantiate its functor with our <code class="hljs language-ocaml">key</code> extensible
type<label for="fn9" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">This approach will lead every value of type <code class="hljs">Extensible_record.t</code>
to share the same fields, which might not be you need.</span>
<span class="footnote-p">One can imagine embedding the <code class="hljs">registered_keys</code> list of known keys inside
the extensible records values, along with a heterogeneous map. This
would allow each value to have its own dynamic set of fields. </span>
</span>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">module</span> <span class="hljs-type">Extensible_record</span> = <span class="hljs-type">Dmap</span>.<span class="hljs-type">Make</span> (<span class="hljs-keyword">struct</span>
  <span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> t = <span class="hljs-symbol">'a</span> key

  <span class="hljs-keyword">let</span> compare = compare
<span class="hljs-keyword">end</span>)
</code></pre>
<h3>Step 3: Profit</h3>
<p>To wrap up this article, we can come back to our initial example of a record
with two fields <code class="hljs language-ocaml">foo</code> and <code class="hljs language-ocaml">bar</code>.</p>
<p>Here is how we can extend <code class="hljs">key</code> to have a <code class="hljs language-ocaml"><span class="hljs-type">Foo</span></code> constructor.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> _ key += <span class="hljs-type">Foo</span> : <span class="hljs-built_in">int</span> key

<span class="hljs-keyword">let</span> <span class="hljs-literal">()</span> =
  register_key
    (<span class="hljs-keyword">module</span> <span class="hljs-keyword">struct</span>
      <span class="hljs-keyword">type</span> t = <span class="hljs-built_in">unit</span>
      <span class="hljs-keyword">type</span> r = <span class="hljs-built_in">int</span>

      <span class="hljs-keyword">let</span> proj : <span class="hljs-keyword">type</span> a. a key -&gt; (t * (a, r) eq) option = <span class="hljs-keyword">function</span>
        | <span class="hljs-type">Foo</span> -&gt; <span class="hljs-type">Some</span> (<span class="hljs-literal">()</span>, <span class="hljs-type">Refl</span>)
        | _ -&gt; <span class="hljs-type">None</span>

      <span class="hljs-keyword">let</span> compare <span class="hljs-literal">()</span> <span class="hljs-literal">()</span> = <span class="hljs-number">0</span>
    <span class="hljs-keyword">end</span>)
</code></pre>
<p>Similarly, here is how we can register <code class="hljs language-ocaml"><span class="hljs-type">Bar</span></code>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> _ key += <span class="hljs-type">Bar</span> : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">bool</span> key

<span class="hljs-keyword">let</span> <span class="hljs-literal">()</span> =
  register_key
    (<span class="hljs-keyword">module</span> <span class="hljs-keyword">struct</span>
      <span class="hljs-keyword">type</span> t = <span class="hljs-built_in">string</span>
      <span class="hljs-keyword">type</span> r = <span class="hljs-built_in">bool</span>

      <span class="hljs-keyword">let</span> proj : <span class="hljs-keyword">type</span> a. a key -&gt; (t * (a, r) eq) option = <span class="hljs-keyword">function</span>
        | <span class="hljs-type">Bar</span> arg -&gt; <span class="hljs-type">Some</span> (arg, <span class="hljs-type">Refl</span>)
        | _ -&gt; <span class="hljs-type">None</span>

      <span class="hljs-keyword">let</span> compare = <span class="hljs-type">String</span>.compare
    <span class="hljs-keyword">end</span>)
</code></pre>
<p>Once registered, these two fields/keys can be used to populate an
<code class="hljs">Extensible_record.t</code> value with values of the expected types.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> <span class="hljs-literal">()</span> =
  <span class="hljs-keyword">let</span> record = <span class="hljs-type">Extensible_record</span>.empty <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> record = <span class="hljs-type">Extensible_record</span>.add <span class="hljs-type">Foo</span> <span class="hljs-number">3</span> record <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> record = <span class="hljs-type">Extensible_record</span>.add (<span class="hljs-type">Bar</span> <span class="hljs-string">"foobar"</span>) <span class="hljs-literal">true</span> record <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">assert</span> (<span class="hljs-type">Extensible_record</span>.find <span class="hljs-type">Foo</span> record = <span class="hljs-number">3</span>) ;
  <span class="hljs-keyword">assert</span> (<span class="hljs-type">Extensible_record</span>.find (<span class="hljs-type">Bar</span> <span class="hljs-string">"foobar"</span>) record)
</code></pre>
<p>A nice happy consequence of this approach is that it allows us to register
private fields only a given module can manipulate. Indeed, if this module does
not expose the constructor of the key it relies on, then only it can interact
with this part of the extensible record.</p>
        
      
