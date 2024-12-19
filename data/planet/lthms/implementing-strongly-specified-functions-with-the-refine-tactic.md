---
title: Implementing Strongly-Specified Functions with the refine Tactic
description: We see how to implement strongly-specified list manipulation functions
  in Coq. Strong specifications are used to ensure some properties on functions' arguments
  and return value. It makes Coq type system very expressive.
url: https://soap.coffee/~lthms/posts/StronglySpecifiedFunctionsRefine.html
date: 2015-01-11T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Implementing Strongly-Specified Functions with the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> Tactic</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/coq.html" marked="" class="tag">coq</a> </div>
<p>I started to play with Coq, the interactive theorem prover
developed by Inria, a few weeks ago. It is a very powerful tool,
yet hard to master. Fortunately, there are some very good readings
if you want to learn (I recommend the Coq'Art). This article is
not one of them.</p>
<p>In this article, we will see how to implement strongly specified
list manipulation functions in Coq. Strong specifications are used
to ensure some properties on functions' arguments and return
value. It makes Coq type system very expressive. Thus, it is
possible to specify in the type of the function <code class="hljs language-coq">pop</code> that the return
value is the list passed as an argument in which the first element has been
removed, for example.</p>
<h2>Is This List Empty?</h2>
<p>It's the first question to deal with when manipulating
lists. There are some functions that require their arguments not
to be empty. It's the case for the <code class="hljs language-coq">pop</code> function, for instance
it is not possible to remove the first element of a list that does
not have any elements in the first place.</p>
<p>When one wants to answer such a question as “Is this list empty?”,
he has to keep in mind that there are two ways to do it: by a
predicate or by a boolean function. Indeed, <code class="hljs language-coq"><span class="hljs-keyword">Prop</span></code> and <code class="hljs language-coq">bool</code> are
two different worlds that do not mix easily. One solution is to
write two definitions and to prove their equivalence.  That is
<code class="hljs language-coq"><span class="hljs-keyword">forall</span> args, predicate args &lt;-&gt; bool_function args = true</code>.</p>
<p>Another solution is to use the <code class="hljs language-coq">sumbool</code> type as middlemen. The
scheme is the following:</p>
<ul>
<li>Defining <code class="hljs language-coq">predicate : args → <span class="hljs-keyword">Prop</span></code></li>
<li>Defining <code class="hljs language-coq">predicate_dec : args -&gt; { predicate args } + { ~predicate args }</code></li>
<li>Defining <code class="hljs language-coq">predicate_b</code>:</li>
</ul>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> predicate_b (args) :=
  <span class="hljs-keyword">if</span> predicate_dec args <span class="hljs-keyword">then</span> true <span class="hljs-keyword">else</span> false.
</code></pre>
<h3>Defining the <code class="hljs language-coq">empty</code> Predicate</h3>
<p>A list is empty if it is <code class="hljs language-coq">[]</code> (<code class="hljs language-coq">nil</code>). It's as simple as that!</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> empty {a} (l : list a) : <span class="hljs-keyword">Prop</span> := l = [].
</code></pre>
<h3>Defining a decidable version of <code class="hljs language-coq">empty</code></h3>
<p>A decidable version of <code class="hljs language-coq">empty</code> is a function which takes a list
<code class="hljs language-coq">l</code> as its argument and returns either a proof that <code class="hljs language-coq">l</code> is empty,
or a proof that <code class="hljs language-coq">l</code> is not empty. This is encoded in the Coq
standard library with the <code class="hljs language-coq">sumbool</code> type, and is written as
follows: <code class="hljs language-coq">{ empty l } + { ~ empty l }</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> empty_dec {a} (l : list a)
  : { empty l } + { ~ empty l }.
<span class="hljs-keyword">Proof</span>.
  <span class="hljs-built_in">refine</span> (<span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
          | <span class="hljs-type">[] =&gt; left</span> <span class="hljs-keyword">_</span> <span class="hljs-keyword">_</span>
          | <span class="hljs-type">_</span> =&gt; <span class="hljs-built_in">right</span> <span class="hljs-keyword">_</span> <span class="hljs-keyword">_</span>
          <span class="hljs-keyword">end</span>);
    <span class="hljs-built_in">unfold</span> empty; <span class="hljs-built_in">trivial</span>.
  <span class="hljs-built_in">unfold</span> not; <span class="hljs-built_in">intro</span> H; <span class="hljs-built_in">discriminate</span> H.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>In this example, I decided to use the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> tactic which is
convenient when we manipulate the <code class="hljs language-coq"><span class="hljs-keyword">Set</span></code> and <code class="hljs language-coq"><span class="hljs-keyword">Prop</span></code> sorts at the
same time.</p>
<h3>Defining <code class="hljs language-coq">empty_b</code></h3>
<p>With <code class="hljs language-coq">empty_dec</code>, we can define <code class="hljs language-coq">empty_b</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> empty_b {a} (l : list a) : bool :=
  <span class="hljs-keyword">if</span> empty_dec l <span class="hljs-keyword">then</span> true <span class="hljs-keyword">else</span> false.
</code></pre>
<p>Let's try to extract <code class="hljs language-coq">empty_b</code>:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> <span class="hljs-built_in">bool</span> =
| <span class="hljs-type">True</span>
| <span class="hljs-type">False</span>

<span class="hljs-keyword">type</span> sumbool =
| <span class="hljs-type">Left</span>
| <span class="hljs-type">Right</span>

<span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span> =
| <span class="hljs-type">Nil</span>
| <span class="hljs-type">Cons</span> <span class="hljs-keyword">of</span> <span class="hljs-symbol">'a</span> * <span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span>

<span class="hljs-comment">(** val empty_dec : 'a1 list -&gt; sumbool **)</span>

<span class="hljs-keyword">let</span> empty_dec = <span class="hljs-keyword">function</span>
| <span class="hljs-type">Nil</span> -&gt; <span class="hljs-type">Left</span>
| <span class="hljs-type">Cons</span> (a, l0) -&gt; <span class="hljs-type">Right</span>

<span class="hljs-comment">(** val empty_b : 'a1 list -&gt; bool **)</span>

<span class="hljs-keyword">let</span> empty_b l =
  <span class="hljs-keyword">match</span> empty_dec l <span class="hljs-keyword">with</span>
  | <span class="hljs-type">Left</span> -&gt; <span class="hljs-type">True</span>
  | <span class="hljs-type">Right</span> -&gt; <span class="hljs-type">False</span>
</code></pre>
<p>In addition to <code class="hljs language-ocaml"><span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span></code>, Coq has created the <code class="hljs language-ocaml">sumbool</code> and
<code class="hljs language-ocaml"><span class="hljs-built_in">bool</span></code> types and <code class="hljs language-ocaml">empty_b</code> is basically a translation from the
former to the latter. We could have stopped with <code class="hljs language-ocmal">empty_dec</code>, but
<code class="hljs language-ocaml"><span class="hljs-type">Left</span></code> and <code class="hljs language-ocaml"><span class="hljs-type">Right</span></code> are less readable that <code class="hljs language-ocaml"><span class="hljs-type">True</span></code> and
<code class="hljs language-ocaml"><span class="hljs-type">False</span></code>. Note that it is possible to configure the Extraction mechanism
to use primitive OCaml types instead, but this is out of the scope of this
article.</p>
<h2>Defining Some Utility Functions</h2>
<h3>Defining <code class="hljs language-coq">pop</code></h3>
<p>There are several ways to write a function that removes the first
element of a list. One is to return <code class="hljs">nil</code> if the given list was
already empty:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> pop {a} ( l :list a) :=
  <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
  | <span class="hljs-type">_</span> :: l =&gt; l
  | <span class="hljs-type">[] =&gt; []
  end</span>.
</code></pre>
<p>But it's not really satisfying. A <code class="hljs">pop</code> call over an empty list should not be
possible. It can be done by adding an argument to <code class="hljs">pop</code>: the proof that the
list is not empty.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> pop {a} (l : list a) (h : ~ empty l)
  : list a.
</code></pre>
<p>There are, as usual when it comes to lists, two cases to
consider.</p>
<ul>
<li><code class="hljs language-coq">l = x :: rst</code>, and therefore <code class="hljs language-coq">pop (x :: rst) h</code> is <code class="hljs language-coq">rst</code></li>
<li><code class="hljs language-coq">l = []</code>, which is not possible since we know <code class="hljs language-coq">l</code> is not empty.</li>
</ul>
<p>The challenge is to convince Coq that our reasoning is
correct. There are, again, several approaches to achieve that.  We
can, for instance, use the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> tactic again, but this time we
need to know a small trick to succeed as using a “regular” <code class="hljs language-coq"><span class="hljs-keyword">match</span></code>
will not work.</p>
<p>From the following goal:</p>
<pre><code class="hljs">  a : Type
  l : list a
  h : ~ empty l
  ============================
  list a
</code></pre>
<p>Using the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> tactic naively, for instance, this way:</p>
<pre><code class="hljs language-coq">  <span class="hljs-built_in">refine</span> (<span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
          | <span class="hljs-type">_</span> :: rst =&gt; rst
          | <span class="hljs-type">[] =&gt; _</span>
          <span class="hljs-keyword">end</span>).
</code></pre>
<p>leaves us the following goal to prove:</p>
<pre><code class="hljs">  a : Type
  l : list a
  h : ~ empty l
  ============================
  list a
</code></pre>
<p>Nothing has changed! Well, not exactly. See, <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> has taken
our incomplete Gallina term, found a hole, done some
type-checking, found that the type of the missing piece of our
implementation is <code class="hljs language-coq">list a</code> and therefore has generated a new
goal of this type.  What <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> has not done, however, is
remembering that we are in the case where <code class="hljs language-coq">l = []</code>.</p>
<p>We need to generate a goal from a hole wherein this information is
available. It is possible to use a long form of <code class="hljs language-coq"><span class="hljs-keyword">match</span></code>. The
general approach is this: rather than returning a value of type
<code class="hljs language-coq">list a</code>, our match will return a function of type <code class="hljs language-coq">l = ?l' -&gt; list a</code>, where <code class="hljs language-coq">?l</code> is a value of <code class="hljs language-coq">l</code> for a given case (that is,
either <code class="hljs language-coq">x :: rst</code> or <code class="hljs language-coq">[]</code>). Of course and as a consequence, the type
of the <code class="hljs language-coq"><span class="hljs-keyword">match</span></code> in now a function which awaits a proof to return
the expected result. Fortunately, this proof is trivial: it is
<code class="hljs language-coq">eq_refl</code>.</p>
<pre><code class="hljs language-coq">  <span class="hljs-built_in">refine</span> (<span class="hljs-keyword">match</span> l <span class="hljs-built_in">as</span> l'
                <span class="hljs-keyword">return</span> l = l' -&gt; list a
          <span class="hljs-built_in">with</span>
          | <span class="hljs-type">_</span> :: rst =&gt; <span class="hljs-keyword">fun</span> <span class="hljs-keyword">_</span> =&gt; rst
          | <span class="hljs-type">[] =&gt; fun</span> equ =&gt; <span class="hljs-keyword">_</span>
          <span class="hljs-keyword">end</span> eq_refl).
</code></pre>
<p>For us to conclude the proof, this is way better.</p>
<pre><code class="hljs">  a : Type
  l : list a
  h : ~ empty l
  equ : l = []
  ============================
  list a
</code></pre>
<p>We conclude the proof, and therefore the definition of <code class="hljs language-coq">pop</code>.</p>
<pre><code class="hljs language-coq">  <span class="hljs-built_in">rewrite</span> equ <span class="hljs-built_in">in</span> h.
  <span class="hljs-built_in">exfalso</span>.
  now <span class="hljs-built_in">apply</span> h.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>It's better and yet it can still be improved. Indeed, according to its type,
<code class="hljs language-coq">pop</code> returns “some list.” As a matter of fact, <code class="hljs language-coq">pop</code> returns “the
same list without its first argument.” It is possible to write
such precise definition thanks to sigma types, defined as:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> sig (A : <span class="hljs-keyword">Type</span>) (P : A -&gt; <span class="hljs-keyword">Prop</span>) : <span class="hljs-keyword">Type</span> :=
  exist : <span class="hljs-keyword">forall</span> (x : A), P x -&gt; sig P.
</code></pre>
<p>Rather than <code class="hljs language-coq">sig A p</code>, sigma-types can be written using the
notation <code class="hljs language-coq">{ a | <span class="hljs-type">P</span> }</code>. They express subsets, and can be used to constraint
arguments and results of functions.</p>
<p>We finally propose a strongly specified definition of <code class="hljs language-coq">pop</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> pop {a} (l : list a | <span class="hljs-type">~ empty</span> l)
  : { l' | <span class="hljs-type">exists</span> a, proj1_sig l = cons a l' }.
</code></pre>
<p>If you think the previous use of <code class="hljs language-coq"><span class="hljs-keyword">match</span></code> term was ugly, brace yourselves.</p>
<pre><code class="hljs language-coq">  <span class="hljs-built_in">refine</span> (<span class="hljs-keyword">match</span> proj1_sig l <span class="hljs-built_in">as</span> l'
                <span class="hljs-keyword">return</span> proj1_sig l = l'
                       -&gt; { l' | <span class="hljs-type">exists</span> a, proj1_sig l = cons a l' }
          <span class="hljs-built_in">with</span>
          | <span class="hljs-type">[] =&gt; fun</span> equ =&gt; <span class="hljs-keyword">_</span>
          | <span class="hljs-type">(_</span> :: rst) =&gt; <span class="hljs-keyword">fun</span> equ =&gt; exist <span class="hljs-keyword">_</span> rst <span class="hljs-keyword">_</span>
          <span class="hljs-keyword">end</span> eq_refl).
</code></pre>
<p>This leaves us two goals to tackle.</p>
<p>First, we need to discard the case where <code class="hljs language-coq">l</code> is the empty list.</p>
<pre><code class="hljs">  a : Type
  l : {l : list a | ~ empty l}
  equ : proj1_sig l = []
  ============================
  {l' : list a | exists a0 : a, proj1_sig l = a0 :: l'}
</code></pre>
<pre><code class="hljs language-coq">  + <span class="hljs-built_in">destruct</span> l <span class="hljs-built_in">as</span> [l nempty]; <span class="hljs-built_in">cbn</span> <span class="hljs-built_in">in</span> *.
    <span class="hljs-built_in">rewrite</span> equ <span class="hljs-built_in">in</span> nempty.
    <span class="hljs-built_in">exfalso</span>.
    now <span class="hljs-built_in">apply</span> nempty.
</code></pre>
<p>Then, we need to prove that the result we provide (<code class="hljs language-coq">rst</code>) when the
list is not empty is correct with respect to the specification of
<code class="hljs language-coq">pop</code>.</p>
<pre><code class="hljs">  a : Type
  l : {l : list a | ~ empty l}
  a0 : a
  rst : list a
  equ : proj1_sig l = a0 :: rst
  ============================
  exists a1 : a, proj1_sig l = a1 :: rst
</code></pre>
<pre><code class="hljs language-coq">  + <span class="hljs-built_in">destruct</span> l <span class="hljs-built_in">as</span> [l nempty]; <span class="hljs-built_in">cbn</span> <span class="hljs-built_in">in</span> *.
    <span class="hljs-built_in">rewrite</span> equ.
    now <span class="hljs-built_in">exists</span> a0.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>Let's have a look at the extracted code:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(** val pop : 'a1 list -&gt; 'a1 list **)</span>

<span class="hljs-keyword">let</span> pop = <span class="hljs-keyword">function</span>
| <span class="hljs-type">Nil</span> -&gt; <span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span> <span class="hljs-comment">(* absurd case *)</span>
| <span class="hljs-type">Cons</span> (a, l0) -&gt; l0
</code></pre>
<p>If one tries to call <code class="hljs language-coq">pop nil</code>, the <code class="hljs language-coq"><span class="hljs-built_in">assert</span></code> ensures the call fails. Extra
information given by the sigma type has been stripped away. It can be
confusing, and in practice it means that, we you rely on the extraction
mechanism to provide a certified OCaml module, you <em>cannot expose
strongly specified functions in its public interface</em> because nothing in the
OCaml type system will prevent a misuse which will in practice leads to an
<code class="hljs language-ocaml"><span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span></code>. *)</p>
<h2>Defining <code class="hljs language-coq">push</code></h2>
<p>It is possible to specify <code class="hljs language-coq">push</code> the same way <code class="hljs language-coq">pop</code> has been. The only
difference is <code class="hljs language-coq">push</code> accepts lists with no restriction at all. Thus, its
definition is a simpler, and we can write it without <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> push {a} (l : list a) (x : a)
  : { l' | <span class="hljs-type">l</span>' = x :: l } :=
  exist <span class="hljs-keyword">_</span> (x :: l) eq_refl.
</code></pre>
<p>And the extracted code is just as straightforward.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> push l a =
  <span class="hljs-type">Cons</span> (a, l)
</code></pre>
<h2>Defining <code class="hljs language-coq">head</code></h2>
<p>Same as <code class="hljs language-coq">pop</code> and <code class="hljs language-coq">push</code>, it is possible to add extra information in the
type of <code class="hljs language-coq">head</code>, namely the returned value of <code class="hljs language-coq">head</code> is indeed the first value
of <code class="hljs language-coq">l</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> head {a} (l : list a | <span class="hljs-type">~ empty</span> l)
  : { x | <span class="hljs-type">exists</span> r, proj1_sig l = x :: r }.
</code></pre>
<p>It's not a surprise its definition is very close to <code class="hljs language-coq">pop</code>.</p>
<pre><code class="hljs language-coq">  <span class="hljs-built_in">refine</span> (<span class="hljs-keyword">match</span> proj1_sig l <span class="hljs-built_in">as</span> l'
                <span class="hljs-keyword">return</span> proj1_sig l = l' -&gt; <span class="hljs-keyword">_</span>
          <span class="hljs-built_in">with</span>
          | <span class="hljs-type">[] =&gt; fun</span> equ =&gt; <span class="hljs-keyword">_</span>
          | <span class="hljs-type">x</span> :: <span class="hljs-keyword">_</span> =&gt; <span class="hljs-keyword">fun</span> equ =&gt; exist <span class="hljs-keyword">_</span> x <span class="hljs-keyword">_</span>
          <span class="hljs-keyword">end</span> eq_refl).
</code></pre>
<p>The proof is also very similar, and are left to read as an exercise for
passionate readers.</p>
<pre><code class="hljs language-coq">  + <span class="hljs-built_in">destruct</span> l <span class="hljs-built_in">as</span> [l falso]; <span class="hljs-built_in">cbn</span> <span class="hljs-built_in">in</span> *.
    <span class="hljs-built_in">rewrite</span> equ <span class="hljs-built_in">in</span> falso.
    <span class="hljs-built_in">exfalso</span>.
    now <span class="hljs-built_in">apply</span> falso.
  + <span class="hljs-built_in">exists</span> l0.
    now <span class="hljs-built_in">rewrite</span> equ.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>Finally, the extracted code is as straightforward as it can get.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> head = <span class="hljs-keyword">function</span>
| <span class="hljs-type">Nil</span> -&gt; <span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span> <span class="hljs-comment">(* absurd case *)</span>
| <span class="hljs-type">Cons</span> (a, l0) -&gt; a
</code></pre>
<h2>Conclusion</h2>
<p>Writing strongly specified functions allows for reasoning about the result
correctness while computing it. This can help in practice. However, writing
these functions with the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> tactic does not enable a very idiomatic
Coq code.</p>
<p>To improve the situation, the <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> framework distributed with the
Coq standard library helps, but it is better to understand what <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code>
achieves under its hood, which is basically what we have done in this article.</p>
        
      
