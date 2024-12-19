---
title: Implementing Strongly-Specified Functions with the Program Framework
description: Program is the heir of the refine tactic. It gives you a convenient way
  to embed proofs within functional programs that are supposed to fade away during
  code extraction.
url: https://soap.coffee/~lthms/posts/StronglySpecifiedFunctionsProgram.html
date: 2017-01-01T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Implementing Strongly-Specified Functions with the <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> Framework</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/coq.html" marked="" class="tag">coq</a> </div>
<h2>The Theory</h2>
<p>If I had to explain <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code>, I would say <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> is the heir of
the <code class="hljs language-coq"><span class="hljs-built_in">refine</span></code> tactic. It gives you a convenient way to embed proofs within
functional programs that are supposed to fade away during code extraction.  But
what do I mean when I say "embed proofs" within functional programs? I found
two ways to do it.</p>
<h3>Invariants</h3>
<p>First, we can define a record with one or more fields of type
<code class="hljs language-coq"><span class="hljs-keyword">Prop</span></code>. By doing so, we can constrain the values of other fields. Put
another way, we can specify invariant for our type. For instance, in
<a href="https://github.com/lthms/SpecCert" marked="">SpecCert&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, I have defined the memory
controller's SMRAMC register as follows:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Record</span> SmramcRegister := {
  d_open: bool;
  d_lock: bool;
  lock_is_close: d_lock = true -&gt; d_open = false;
}.
</code></pre>
<p>So <code class="hljs language-coq">lock_is_closed</code> is an invariant I know each instance of
<code class="hljs">SmramcRegister</code> will have to comply with, because every time I
will construct a new instance, I will have to prove
<code class="hljs language-coq">lock_is_closed</code> holds true. For instance:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> lock (reg: SmramcRegister)
  : SmramcRegister.
  <span class="hljs-built_in">refine</span> ({| <span class="hljs-type">d_open</span> := false; d_lock := true |<span class="hljs-type">}).
</span></code></pre>
<p>Coq leaves us this goal to prove.</p>
<pre><code class="hljs">reg : SmramcRegister
============================
true = true -&gt; false = false
</code></pre>
<p>This sound reasonable enough.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Proof</span>.
  <span class="hljs-built_in">trivial</span>.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>We have seen in my previous article about strongly specified
functions that mixing proofs and regular terms may lead to
cumbersome code.</p>
<p>From that perspective, <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> helps. Indeed, the <code class="hljs language-coq">lock</code> function
can also be defined as follows:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">From</span> Coq <span class="hljs-keyword">Require</span> <span class="hljs-keyword">Import</span> <span class="hljs-keyword">Program</span>.

#[program]
<span class="hljs-keyword">Definition</span> lock' (reg: SmramcRegister)
  : SmramcRegister :=
  {| <span class="hljs-type">d_open</span> := false
   ; d_lock := true
   |<span class="hljs-type">}.
</span></code></pre>
<h3>Pre and Post Conditions</h3>
<p>Another way to "embed proofs in a program" is by specifying pre-
and post-conditions for its component. In Coq, this is done using
sigma types.</p>
<p>On the one hand, a precondition is a proposition a function input has to
satisfy in order for the function to be applied.  For instance, a precondition
for <code class="hljs language-coq">head : <span class="hljs-keyword">forall</span> {a}, list a -&gt; a</code> the function that returns the first
element of a list <code class="hljs language-coq">l</code> requires <code class="hljs language-coq">l</code> to contain at least one element.
We can write that using a sigma-type. The type of <code class="hljs language-coq">head</code> then becomes
<code class="hljs language-coq"><span class="hljs-keyword">forall</span> {a} (l: list a | <span class="hljs-type">l</span> &lt;&gt; []) : a</code>.</p>
<p>On the other hand, a post condition is a proposition a function
output has to satisfy in order for the function to be correctly
implemented. In this way, <code class="hljs">head</code> should in fact return the first
element of <code class="hljs language-coq">l</code> and not something else.</p>
<p><code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> makes writing this specification straightforward.</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Definition</span> head {a} (l : list a | <span class="hljs-type">l</span> &lt;&gt; [])
  : { x : a | <span class="hljs-type">exists</span> l', x :: l' = l }.
</code></pre>
<p>We recall that because <code class="hljs language-coq">{ l: list a | <span class="hljs-type">l</span> &lt;&gt; [] }</code> is not the same as <code class="hljs language-coq">list a</code>, in theory we cannot just compare <code class="hljs language-coq">l</code> with <code class="hljs language-coq">x :: l'</code> (we need to
use <code class="hljs language-coq">proj1_sig</code>). One advantage of <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> is to deal with it using
an implicit coercion.</p>
<p>Note that for the type inference to work as expected, the
unwrapped value (here, <code class="hljs language-coq">x :: l'</code>) needs to be the left operand of
<code class="hljs language-coq">=</code>.</p>
<p>Now that <code class="hljs language-coq">head</code> have been specified, we have to implement it.</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Definition</span> head {a} (l: list a | <span class="hljs-type">l</span> &lt;&gt; [])
  : { x : a | <span class="hljs-type">exists</span> l', cons x l' = l } :=
  <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
  | <span class="hljs-type">x</span> :: l' =&gt; x
  | <span class="hljs-type">[] =&gt; !
  end</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">exists</span> l'.
  <span class="hljs-built_in">reflexivity</span>.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<p>I want to highlight several things here:</p>
<ul>
<li>We return <code class="hljs language-coq">x</code> (of type <code class="hljs language-coq">a</code>) rather than a sigma-type, then
<code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> is smart enough to wrap it. To do so, it tries to prove the post
condition and because it fails, we have to do it ourselves (this is the
Obligation we solve after the function definition.)</li>
<li>The <code class="hljs language-coq">[]</code> case is absurd regarding the precondition, we tell Coq that
using the bang (<code class="hljs language-coq">!</code>) symbol.</li>
</ul>
<p>We can have a look at the extracted code:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(** val head : 'a1 list -&gt; 'a1 **)</span>
<span class="hljs-keyword">let</span> head = <span class="hljs-keyword">function</span>
| <span class="hljs-type">Nil</span> -&gt; <span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span> <span class="hljs-comment">(* absurd case *)</span>
| <span class="hljs-type">Cons</span> (a, _) -&gt; a
</code></pre>
<p>The implementation is pretty straightforward, but the pre- and
post conditions have faded away. Also, the absurd case is
discarded using an assertion. This means one thing: [head] should
not be used directly from the Ocaml world. "Interface" functions
have to be total. *)</p>
<h2>The Practice</h2>
<pre><code class="hljs language-coq"><span class="hljs-keyword">From</span> Coq <span class="hljs-keyword">Require</span> <span class="hljs-keyword">Import</span> Lia.
</code></pre>
<p>I have challenged myself to build a strongly specified library. My goal was to
define a type <code class="hljs language-coq">vector : nat -&gt; <span class="hljs-keyword">Type</span> -&gt; <span class="hljs-keyword">Type</span></code> such as <code class="hljs language-coq">vector a n</code>
is a list of <code class="hljs language-coq">n</code> instance of <code class="hljs language-coq">a</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> vector (a : <span class="hljs-keyword">Type</span>) : nat -&gt; <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">vcons</span> {n} : a -&gt; vector a n -&gt; vector a (S n)
| <span class="hljs-type">vnil</span> : vector a O.

<span class="hljs-keyword">Arguments</span> vcons [a n] <span class="hljs-keyword">_</span> <span class="hljs-keyword">_</span>.
<span class="hljs-keyword">Arguments</span> vnil {a}.
</code></pre>
<p>I had three functions in mind: <code class="hljs language-coq">take</code>, <code class="hljs language-coq">drop</code> and <code class="hljs language-coq">extract</code>.
I learned a few lessons. My main takeaway remains: do not use sigma types,
<code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> and dependent types together. From my point of view, Coq is not
yet ready for this. Maybe it is possible to make those three work together, but
I have to admit I did not find out how. As a consequence, my preconditions are
defined as extra arguments.</p>
<p>To be able to specify the post conditions of my three functions and
some others, I first defined <code class="hljs language-coq">nth</code> to get the <em>nth</em> element of a
vector.</p>
<p>My first attempt to write <code class="hljs language-coq">nth</code> was a failure.</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> nth {a n}
    (v : vector a n) (i : nat) {struct v}
  : option a :=
  <span class="hljs-keyword">match</span> v, i <span class="hljs-built_in">with</span>
  | <span class="hljs-type">vcons</span> x <span class="hljs-keyword">_</span>, O =&gt; Some x
  | <span class="hljs-type">vcons</span> x r, S i =&gt; nth r i
  | <span class="hljs-type">vnil</span>, <span class="hljs-keyword">_</span> =&gt; None
  <span class="hljs-keyword">end</span>.
</code></pre>
<p>raised an anomaly.</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> nth {a n}
    (v : vector a n) (i : nat) {struct v}
  : option a :=
  <span class="hljs-keyword">match</span> v <span class="hljs-built_in">with</span>
  | <span class="hljs-type">vcons</span> x r =&gt;
    <span class="hljs-keyword">match</span> i <span class="hljs-built_in">with</span>
    | <span class="hljs-type">O</span> =&gt; Some x
    | <span class="hljs-type">S</span> i =&gt; nth r i
    <span class="hljs-keyword">end</span>
  | <span class="hljs-type">vnil</span> =&gt; None
  <span class="hljs-keyword">end</span>.
</code></pre>
<p>With <code class="hljs language-coq">nth</code>, it is possible to give a very precise definition of
<code class="hljs language-coq">take</code>:</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> take {a n}
    (v : vector a n) (e : nat | <span class="hljs-type">e</span> &lt;= n)
  : { u : vector a e | <span class="hljs-type">forall</span> i : nat,
        i &lt; e -&gt; nth u i = nth v i } :=
  <span class="hljs-keyword">match</span> e <span class="hljs-built_in">with</span>
  | <span class="hljs-type">S</span> e' =&gt; <span class="hljs-keyword">match</span> v <span class="hljs-built_in">with</span>
            | <span class="hljs-type">vcons</span> x r =&gt; vcons x (take r e')
            | <span class="hljs-type">vnil</span> =&gt; !
            <span class="hljs-keyword">end</span>
  | <span class="hljs-type">O</span> =&gt; vnil
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> le_S_n.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">induction</span> i.
  + <span class="hljs-built_in">reflexivity</span>.
  + <span class="hljs-built_in">apply</span> e0.
    now <span class="hljs-built_in">apply</span> Lt.lt_S_n.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> PeanoNat.Nat.nle_succ_0 <span class="hljs-built_in">in</span> H.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> PeanoNat.Nat.nlt_0_r <span class="hljs-built_in">in</span> H.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>As a side note, I wanted to define the post condition as follows:
<code class="hljs language-coq">{ v': vector A e | <span class="hljs-type">forall</span> (i : nat | <span class="hljs-type">i</span> &lt; e), nth v' i = nth v i }</code>. However, this made the goals and hypotheses become very hard
to read and to use. Sigma types in sigma types: not a good
idea.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(** val take : 'a1 vector -&gt; nat -&gt; 'a1 vector **)</span>

<span class="hljs-keyword">let</span> <span class="hljs-keyword">rec</span> take v = <span class="hljs-keyword">function</span>
| <span class="hljs-type">O</span> -&gt; <span class="hljs-type">Vnil</span>
| <span class="hljs-type">S</span> e' -&gt;
  (<span class="hljs-keyword">match</span> v <span class="hljs-keyword">with</span>
   | <span class="hljs-type">Vcons</span> (_, x, r) -&gt; <span class="hljs-type">Vcons</span> (e', x, (take r e'))
   | <span class="hljs-type">Vnil</span> -&gt; <span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span> <span class="hljs-comment">(* absurd case *)</span>)
</code></pre>
<p>Then I could tackle <code class="hljs">drop</code> in a very similar manner:</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> drop {a n}
    (v : vector a n) (b : nat | <span class="hljs-type">b</span> &lt;= n)
  : { v': vector a (n - b) | <span class="hljs-type">forall</span> i,
        i &lt; n - b -&gt; nth v' i = nth v (b + i) } :=
  <span class="hljs-keyword">match</span> b <span class="hljs-built_in">with</span>
  | <span class="hljs-type">0</span> =&gt; v
  | <span class="hljs-type">S</span> n =&gt; (<span class="hljs-keyword">match</span> v <span class="hljs-built_in">with</span>
           | <span class="hljs-type">vcons</span> <span class="hljs-keyword">_</span> r =&gt; (drop r n)
           | <span class="hljs-type">vnil</span> =&gt; !
           <span class="hljs-keyword">end</span>)
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">rewrite</span> &lt;- Minus.minus_n_O.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">induction</span> n;
    <span class="hljs-built_in">rewrite</span> &lt;- eq_rect_eq;
    <span class="hljs-built_in">reflexivity</span>.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> le_S_n.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> PeanoNat.Nat.nle_succ_0 <span class="hljs-built_in">in</span> H.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>The proofs are easy to write, and the extracted code is exactly what one might
want it to be:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(** val drop : 'a1 vector -&gt; nat -&gt; 'a1 vector **)</span>
<span class="hljs-keyword">let</span> <span class="hljs-keyword">rec</span> drop v = <span class="hljs-keyword">function</span>
| <span class="hljs-type">O</span> -&gt; v
| <span class="hljs-type">S</span> n -&gt;
  (<span class="hljs-keyword">match</span> v <span class="hljs-keyword">with</span>
   | <span class="hljs-type">Vcons</span> (_, _, r) -&gt; drop r n
   | <span class="hljs-type">Vnil</span> -&gt; <span class="hljs-keyword">assert</span> <span class="hljs-literal">false</span> <span class="hljs-comment">(* absurd case *)</span>)
</code></pre>
<p>But <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> really shone when it comes to implementing extract. I just
had to combine <code class="hljs language-coq">take</code> and <code class="hljs language-coq">drop</code>. *)</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Definition</span> extract {a n} (v : vector a n)
    (e : nat | <span class="hljs-type">e</span> &lt;= n) (b : nat | <span class="hljs-type">b</span> &lt;= e)
  : { v': vector a (e - b) | <span class="hljs-type">forall</span> i,
        i &lt; (e - b) -&gt; nth v' i = nth v (b + i) } :=
  take (drop v b) (e - b).


<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">transitivity</span> e; <span class="hljs-built_in">auto</span>.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  now <span class="hljs-built_in">apply</span> PeanoNat.Nat.sub_le_mono_r.
<span class="hljs-keyword">Defined</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">destruct</span> drop; <span class="hljs-built_in">cbn</span> <span class="hljs-built_in">in</span> *.
  <span class="hljs-built_in">destruct</span> take; <span class="hljs-built_in">cbn</span> <span class="hljs-built_in">in</span> *.
  <span class="hljs-built_in">rewrite</span> e1; <span class="hljs-built_in">auto</span>.
  <span class="hljs-built_in">rewrite</span> &lt;- e0; <span class="hljs-built_in">auto</span>.
  <span class="hljs-built_in">lia</span>.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>The proofs are straightforward because the specifications of <code class="hljs language-coq">drop</code> and
<code class="hljs language-coq">take</code> are precise enough, and we do not need to have a look at their
implementations. The extracted version of <code class="hljs language-coq">extract</code> is as clean as we can
anticipate.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(** val extract : 'a1 vector -&gt; nat -&gt; nat -&gt; 'a1 vector **)</span>
<span class="hljs-keyword">let</span> extract v e b =
  take (drop v b) (sub e b)
</code></pre>
<p>I was pretty happy, so I tried some more. Each time, using <code class="hljs language-coq">nth</code>, I managed
to write a precise post condition and to prove it holds true. For instance,
given <code class="hljs language-coq">map</code> to apply a function <code class="hljs language-coq">f</code> to each element of a vector <code class="hljs language-coq">v</code>:</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> map {a b n} (v : vector a n) (f : a -&gt; b)
  : { v': vector b n | <span class="hljs-type">forall</span> i,
        nth v' i = option_map f (nth v i) } :=
  <span class="hljs-keyword">match</span> v <span class="hljs-built_in">with</span>
  | <span class="hljs-type">vnil</span> =&gt; vnil
  | <span class="hljs-type">vcons</span> a v =&gt; vcons (f a) (map v f)
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">induction</span> i.
  + <span class="hljs-built_in">reflexivity</span>.
  + <span class="hljs-built_in">apply</span> e.
<span class="hljs-keyword">Defined</span>.
</code></pre>
<p>I also managed to specify and write <code class="hljs language-coq">append</code>:</p>
<pre><code class="hljs">#[program]
Fixpoint append {a n m}
    (v : vector a n) (u : vector a m)
  : { w : vector a (n + m) | forall i,
        (i &lt; n -&gt; nth w i = nth v i) /\
        (n &lt;= i -&gt; nth w i = nth u (i - n))
    } :=
  match v with
  | vnil =&gt; u
  | vcons a v =&gt; vcons a (append v u)
  end.

Next Obligation.
  split.
  + now intro.
  + intros _.
    now rewrite PeanoNat.Nat.sub_0_r.
Defined.

Next Obligation.
  rename wildcard' into n.
  destruct (Compare_dec.lt_dec i (S n)); split.
  + intros _.
    destruct i.
    ++ reflexivity.
    ++ cbn.
       specialize (a1 i).
       destruct a1 as [a1 _].
       apply a1.
       auto with arith.
  + intros false.
    lia.
  + now intros.
  + intros ord.
    destruct i.
    ++ lia.
    ++ cbn.
       specialize (a1 i).
       destruct a1 as [_ a1].
       apply a1.
       auto with arith.
Defined.
</code></pre>
<p>Finally, I tried to implement <code class="hljs language-coq">map2</code> that takes a vector of <code class="hljs language-coq">a</code>, a vector of
<code class="hljs language-coq">b</code> (both of the same size) and a function <code class="hljs language-coq">f : a -&gt; b -&gt; c</code> and returns a
vector of <code class="hljs language-coq">c</code>.</p>
<p>First, we need to provide a precise specification for <code class="hljs language-coq">map2</code>. To do that, we
introduce <code class="hljs language-coq">option_app</code>, a function that Haskellers know all to well as being
part of the <code class="hljs language-haskell"><span class="hljs-type">Applicative</span></code> type class.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> option_app {a b}
    (opf: option (a -&gt; b))
    (opx: option a)
  : option b :=
  <span class="hljs-keyword">match</span> opf, opx <span class="hljs-built_in">with</span>
  | <span class="hljs-type">Some</span> f, Some x =&gt; Some (f x)
  | <span class="hljs-type">_</span>, <span class="hljs-keyword">_</span> =&gt; None
<span class="hljs-keyword">end</span>.
</code></pre>
<p>We thereafter use <code class="hljs language-coq">&lt;$&gt;</code> as an infix operator for <code class="hljs language-coq">option_map</code> and <code class="hljs language-coq">&lt;*&gt;</code> as
an infix operator for <code class="hljs language-coq">option_app</code>. *)</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Infix</span> <span class="hljs-string">"&lt;$&gt;"</span> := option_map (<span class="hljs-built_in">at</span> level <span class="hljs-number">50</span>).
<span class="hljs-keyword">Infix</span> <span class="hljs-string">"&lt;*&gt;"</span> := option_app (<span class="hljs-built_in">at</span> level <span class="hljs-number">55</span>).
</code></pre>
<p>Given two vectors <code class="hljs language-coq">v</code> and <code class="hljs language-coq">u</code> of the same size and a function <code class="hljs language-coq">f</code>, and given
<code class="hljs language-coq">w</code> the result computed by <code class="hljs language-coq">map2</code>, then we can propose the following
specification for <code class="hljs language-coq">map2</code>:</p>
<p><code class="hljs language-coq"><span class="hljs-keyword">forall</span> (i : nat), nth w i = f &lt;$&gt; nth v i &lt;*&gt; nth u i</code></p>
<p>This reads as follows: the <code class="hljs language-coq">i</code>th element of <code class="hljs language-coq">w</code> is the result of applying
the <code class="hljs language-coq">i</code>th elements of <code class="hljs language-coq">v</code> and <code class="hljs language-coq">u</code> to <code class="hljs language-coq">f</code>.</p>
<p>It turns out implementing <code class="hljs language-coq">map2</code> with the <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code> framework has
proven to be harder than I originally expected. My initial attempt was the
following:</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> map2 {a b c n}
    (v : vector a n) (u : vector b n)
    (f : a -&gt; b -&gt; c) {struct v}
  : { w: vector c n | <span class="hljs-type">forall</span> i,
        nth w i = f &lt;$&gt; nth v i &lt;*&gt; nth u i
    } :=
  <span class="hljs-keyword">match</span> v, u <span class="hljs-built_in">with</span>
  | <span class="hljs-type">vcons</span> x rst, vcons x' rst' =&gt;
      vcons (f x x') (map2 rst rst' f)
  | <span class="hljs-type">vnil</span>, vnil =&gt; vnil
  | <span class="hljs-type">_</span>, <span class="hljs-keyword">_</span> =&gt; !
  <span class="hljs-keyword">end</span>.
</code></pre>
<pre><code class="hljs">Illegal application:
The term "@eq" of type "forall A : Type, A -&gt; A -&gt; Prop"
cannot be applied to the terms
 "nat" : "Set"
 "S wildcard'" : "nat"
 "b" : "Type"
The 3rd term has type "Type" which should be coercible
to "nat".
</code></pre>
<p>So I had to fallback to defining the function in pure Ltac.</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> map2 {a b c n}
    (v : vector a n) (u : vector b n)
    (f : a -&gt; b -&gt; c) {struct v}
  : { w: vector c n | <span class="hljs-type">forall</span> i,
        nth w i = f &lt;$&gt; nth v i &lt;*&gt; nth u i
    } := <span class="hljs-keyword">_</span>.

<span class="hljs-keyword">Next</span> <span class="hljs-keyword">Obligation</span>.
  <span class="hljs-built_in">dependent</span> <span class="hljs-built_in">induction</span> v; <span class="hljs-built_in">dependent</span> <span class="hljs-built_in">induction</span> u.
  + <span class="hljs-built_in">remember</span> (IHv u f) <span class="hljs-built_in">as</span> u'.
    <span class="hljs-built_in">inversion</span> u'.
    <span class="hljs-built_in">refine</span> (exist <span class="hljs-keyword">_</span> (vcons (f a0 a1) x) <span class="hljs-keyword">_</span>).
    <span class="hljs-built_in">intros</span> i.
    <span class="hljs-built_in">induction</span> i.
    * <span class="hljs-built_in">reflexivity</span>.
    * <span class="hljs-built_in">apply</span> (H i).
  + <span class="hljs-built_in">refine</span> (exist <span class="hljs-keyword">_</span> vnil <span class="hljs-keyword">_</span>).
    <span class="hljs-built_in">reflexivity</span>.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h2>Is It Usable?</h2>
<p>This post mostly gives the "happy ends" for each function. I think I tried
too hard for what I got in return and therefore I am convinced <code class="hljs language-coq"><span class="hljs-keyword">Program</span></code>
is not ready (at least for a dependent type, I cannot tell for the rest). For
instance, I found at least one bug in Program logic (I still have to report
it). Have a look at the following code:</p>
<pre><code class="hljs language-coq">#[program]
<span class="hljs-keyword">Fixpoint</span> map2 {a b c n}
     (u : vector a n) (v : vector b n)
     (f : a -&gt; b -&gt; c) {struct v}
  : vector c n :=
  <span class="hljs-keyword">match</span> u <span class="hljs-built_in">with</span>
  | <span class="hljs-type">_</span> =&gt; vnil
  <span class="hljs-keyword">end</span>.
</code></pre>
<p>It gives the following error:</p>
<pre><code class="hljs">Error: Illegal application:
The term "@eq" of type "forall A : Type, A -&gt; A -&gt; Prop"
cannot be applied to the terms
 "nat" : "Set"
 "0" : "nat"
 "wildcard'" : "vector A n'"
The 3rd term has type "vector A n'" which should be
coercible to "nat".
</code></pre>
        
      
