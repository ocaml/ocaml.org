---
title: Update on Typeful Normalization by Evaluation
description: "In October, I publicized here\_a new draft on normalization by evaluation,
  which provoked some very helpful comments and constructive criticisms. Together
  with Chantal and Olivier, we thus revised t\u2026"
url: https://syntaxexclamation.wordpress.com/2014/02/14/update-on-typeful-normalization-by-evaluation/
date: 2014-02-14T19:11:50-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>In October, I publicized here&nbsp;<a href="https://syntaxexclamation.wordpress.com/2013/10/29/new-draft-on-normalization-by-evaluation-using-gadts/" title="New draft on Normalization by Evaluation using&nbsp;GADTs">a new draft on normalization by evaluation</a>, which provoked some very helpful comments and constructive criticisms. Together with <a href="http://cs.au.dk/~chkeller" title="Chantal Keller">Chantal</a> and <a href="http://cs.au.dk/~danvy/" title="Olivier Danvy">Olivier</a>, we thus revised the draft profoundly and a <a href="http://cs.au.dk/~mpuech/typeful.pdf" title="Typeful Normalization by Evaluation">revamped version is available</a> on my <a href="http://cs.au.dk/~mpuech" title="Matthias Puech">web site</a>.</p>
<p>Besides the enhanced form and better explanations, we included a completely new section on what it means for NbE to be written in Continuation-Passing Style, that I am particularly excited about. This allowed us to extend our typeful NbE formalization beyond the minimal &lambda;-calculus to sums and <strong>call/cc</strong> (which is known to be difficult). Taking our code, you can write a program with <strong>call/cc</strong> and <strong>if</strong> statements, and partially evaluate it: all redexes will be removed and your code will be specialized. All this, as before, is done <em>typefully</em>, thanks to OCaml&rsquo;s GADTs: this means that the transformation is guaranteed to map well-typed terms to well-typed normal forms.</p>
<p><span></span></p>
<p>What I really liked about working on program transformations with GADTs, is that they enable an efficient methodology to devise your tranformations, and read off of them the (typed) target language. Let me give you an example. Say we write the canonical, direct-style evaluator for the &lambda;-calculus:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec eval = function
  | Lam f -&gt; Fun (fun x -&gt; eval (f (Var x)))
  | App (m, n) -&gt; let Fun f = eval m in f (eval n)
  | Var x -&gt; x
</pre>
<p>If the input language is simply typed:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a tm =
  | Lam : ('a tm -&gt; 'b tm) -&gt; ('a -&gt; 'b) tm
  | App : ('a -&gt; 'b) tm * 'a tm -&gt; 'b tm
  | Var : 'a vl -&gt; 'a tm
</pre>
<p>then so can be the output language:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a vl = Fun : ('a vl -&gt; 'b vl) -&gt; ('a -&gt; 'b) vl
</pre>
<p>and the type of <code>eval</code> then guarantees to preserve types: <code>type a. a tm -&gt; a vl</code>. Up to here, no big news. Now what if I CPS-transform the code above? Following the usual, call-by value CPS transformation, I get:</p>
<pre class="brush: fsharp; title: ; notranslate">
type o

let rec eval : type a. a tm -&gt; (a vl -&gt; o) -&gt; o = function
  | Lam f -&gt; fun k -&gt; k (Fun (fun x k -&gt; eval (f (Var x)) k))
  | App (m, n) -&gt; fun k -&gt; eval m (fun (Fun v1) -&gt; 
                           eval n (fun v2 -&gt; v1 v2 k))
  | Var x -&gt; fun k -&gt; k x
</pre>
<p>My input language is unchanged, but what about the output values? As you can hint from the <code>Lam</code> and <code>App</code> cases, the type of constructor <code>Fun</code> has been changed. Using type inference, type errors and <code>C-c C-t</code> in my <code>tuareg-mode</code>, I can read off the new type it should have:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a vl = Fun : ('a vl -&gt; ('b vl -&gt; o) -&gt; o) -&gt; ('a -&gt; 'b) vl
</pre>
<p>Yes, this is the type of CPS values! For instance, I can write the CPS-transformed applicator:</p>
<pre class="brush: fsharp; title: ; notranslate">
let app : type a b. ((a -&gt; b) -&gt; a -&gt; b) vl =
  Fun (fun (Fun f) k -&gt; k (Fun (fun x k -&gt; f x k)))
</pre>
<p>The same way, if I write the usual Normalization by Evaluation algorithm from typed values to typed normal forms and CPS-transform it, I can deduce the specialized syntax of normal forms in CPS:<br/>
<code><br/>
S ::= let v = R M in S | return k M<br/>
M ::= &lambda;xk. S | R<br/>
R ::= x | v<br/>
</code></p>
<p>If this excites you or puzzles you, come read our draft, and do not hesitate to leave any comment below!</p>

