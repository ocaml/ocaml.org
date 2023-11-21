---
title: The Generic Syntax Extension
description: 'OCaml 4.01 with its new feature to disambiguate constructors allows
  to do a nice trick: a simple and generic syntax extension that allows to define
  your own syntax without having to write complicated parsetree transformers. We propose
  an implementation in the form of a ppx rewriter. it does only a s...'
url: https://ocamlpro.com/blog/2014_04_01_the_generic_syntax_extension
date: 2014-04-01T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>OCaml 4.01 with its new feature to disambiguate constructors allows to do a nice trick: a simple and generic syntax extension that allows to define your own syntax without having to write complicated parsetree transformers. We propose an implementation in the form of a ppx rewriter.</p>
<p>it does only a simple transformation: replace strings prefixed by an operator starting with ! by a series of constructor applications</p>
<p>for instance:</p>
<pre><code class="language-ocaml">!! &quot;hello 3&quot;
</code></pre>
<p>is rewriten to</p>
<pre><code class="language-ocaml">!! (Start (H (E (L (L (O (Space (N3 (End))))))))
</code></pre>
<p>How is that generic ? We will present you a few examples.</p>
<h4>Base 3 Numbers</h4>
<p>For instance, if you want to declare base 3 arbitrary big numbers, let's define a syntax for it. We first start by declaring some types.</p>
<pre><code class="language-ocaml">type start = Start of p

and p =
  | N0 of stop
  | N1 of q
  | N2 of q

and q =
  | N0 of q
  | N1 of q
  | N2 of q
  | Underscore of q
  | End

and stop = End
</code></pre>
<p>This type will only allow to write strings matching the regexp 0 | (1|2)(0|1|2|_)*. Notice that some constructors appear in multiple types like N0. This is not a problem since constructor desambiguation will choose for us the right one at the right place. Let's now define a few functions to use it:</p>
<pre><code class="language-ocaml">open Num

let rec convert_p = function
  | N0 (End) -&gt; Int 0
  | N1 t -&gt; convert_q (Int 1) t
  | N2 t -&gt; convert_q (Int 2) t

and convert_q acc = function
  | N0 t -&gt; convert_q (acc */ Int 3) t
  | N1 t -&gt; convert_q (Int 1 +/ acc */ Int 3) t
  | N2 t -&gt; convert_q (Int 2 +/ acc */ Int 3) t
  | Underscore t -&gt; convert_q acc t
  | End -&gt; acc

let convert (Start p) = convert_p p
</code></pre>
<pre><code class="language-ocaml"># val convert : start -&gt; Num.num = &lt;fun&gt;
</code></pre>
<p>And we can now try it:</p>
<pre><code class="language-ocaml">let n1 = convert (Start (N0 End))
# val n1 : Num.num = &lt;num 0&gt;
let n2 = convert (Start (N1 (Underscore (N0 End))))
# val n2 : Num.num = &lt;num 3&gt;
let n3 = convert (Start (N1 (N2 (N0 End))))
# val n3 : Num.num = &lt;num 15&gt;
</code></pre>
<p>And the generic syntax extension allows us to write:</p>
<pre><code class="language-ocaml">let ( !! ) = convert

let n4 = !! &quot;120_121_000&quot;
val n4 : Num.num = &lt;num 11367&gt;
</code></pre>
<h4>Specialised Format Strings</h4>
<p>We can implement specialised format strings for a particular usage. Here, for concision we will restrict to a very small subset of the classical format: the characters %, i, c and space</p>
<p>Let's define the constructors.</p>
<pre><code class="language-ocaml">type 'a start = Start of 'a a

and 'a a =
  | Percent : 'a f -&gt; 'a a
  | I : 'a a -&gt; 'a a
  | C : 'a a -&gt; 'a a
  | Space : 'a a -&gt; 'a a
  | End : unit a

and 'a f =
  | I : 'a a -&gt; (int -&gt; 'a) f
  | C : 'a a -&gt; (char -&gt; 'a) f
  | Percent : 'a a -&gt; 'a f
</code></pre>
<p>Let's look at the inferred type for some examples:</p>
<pre><code class="language-ocaml">let (!*) x = x

let v = !* &quot;%i %c&quot;;;
# val v : (int -&gt; char -&gt; unit) start = Start (Percent (I (Space (Percent (C End)))))
let v = !* &quot;ici&quot;;;
# val v : unit start = Start (I (C (I End)))
</code></pre>
<p>This is effectively the types we would like for a format string looking like that. To use it we can define a simple printer:</p>
<pre><code class="language-ocaml">let rec print (Start cons) =
  main cons

and main : type t. t a -&gt; t = function
  | I r -&gt;
    print_string &quot;i&quot;;
    main r
  | C r -&gt;
    print_string &quot;c&quot;;
    main r
  | Space r -&gt;
    print_string &quot; &quot;;
    main r
  | End -&gt; ()
  | Percent f -&gt;
    format f

and format : type t. t f -&gt; t = function
  | I r -&gt;
    fun i -&gt;
      print_int i;
      main r
  | C r -&gt;
    fun c -&gt;
      print_char c;
      main r
  | Percent r -&gt;
    print_string &quot;%&quot;;
    main r

let (!!) cons = print cons
</code></pre>
<p>And voila!</p>
<pre><code class="language-ocaml">let s = !! &quot;%i %c&quot; 1 'c';;
# 1 c
</code></pre>
<h3>How generic is it really ?</h3>
<p>It may not look like it, but we can do almost any syntax we might want this way. For instance we can do any regular language. To explain how we transform a regular language to a type definition, we will use as an example the language a(a|)b</p>
<pre><code class="language-ocaml">type start = Start of a

and a =
  | A of a';

and a' =
  | A of b
  | B of stop

and b = B of stop

and stop = End
</code></pre>
<p>We can try a few things on it:</p>
<pre><code class="language-ocaml">let v = Start (A (A (B End)))
# val v : start = Start (A (A (B End)))

let v = Start (A (B End))
# val v : start = Start (A (B End))

let v = Start (B End)
# Characters 15-16:
#   let v = Start (B End);;
#                  ^
# Error: The variant type a has no constructor B

let v = Start (A (A (A (B End))))
# Characters 21-22:
#  let v = Start (A (A (A (B End))));;
#                        ^
# Error: The variant type b has no constructor A
</code></pre>
<p>Assumes the language is given as an automaton that:</p>
<ul>
<li>has 4 states, a, a', b and stop
</li>
<li>with initial state a
</li>
<li>with final state stop
</li>
<li>with transitions: a - A -&gt; a' a' - A -&gt; b a' - B -&gt; stop b - B -&gt; stop
let's write {c} for the constructor corresponding to the character c and
</li>
</ul>
<p>[c][/c]</p>
<p>for the type corresponding to a state of the automaton.</p>
<ul>
<li>For each state q we have a type declaration [q]
</li>
<li>For each letter a of the alphabet we have a constructor {a}
</li>
<li>For each transition p - l -&gt; q we have a constructor {l} with parameter [q] in type [p]:
</li>
</ul>
<pre><code class="language-ocaml">type [p] = {l} of [q]
</code></pre>
<ul>
<li>The End constructor without any parameter must be present in any final state
</li>
<li>The initial state e is declared by
</li>
</ul>
<pre><code class="language-ocaml">type start = Start of [e]
</code></pre>
<h3>Yet more generic</h3>
<p>In fact we can encode deterministic context free languages (DCFL) also. To do that we encode pushdown automatons. Here we will only give a small example: the language of well parenthesized words</p>
<pre><code class="language-ocaml">type empty
type 'a r = Dummy

type _ q =
  | End : empty q
  | Rparen : 'a q -&gt; 'a r q
  | Lparen : 'a r q -&gt; 'a q

type start = Start of empty q

let !! x = x

let m = ! &quot;&quot;
let m = ! &quot;()&quot;
let m = ! &quot;((())())()&quot;
</code></pre>
<p>To encode the stack, we use the type parameters: Lparen pushes an r to the stack, Rparen consumes it and End checks that the stack is effectively empty.</p>
<p>There are a few more tricks needed to encode tests on the top value in the stack, and a conversion of a grammar to Greibach normal form to allow this encoding.</p>
<h3>We can go even further</h3>
<h4>a^n b^n c^n</h4>
<p>In fact we don't need to restrict to DCFL, we can for instance encode the a^n.b^n.c^n language which is not context free:</p>
<pre><code class="language-ocaml">type zero
type 'a s = Succ

type (_,_) p =
  | End : (zero,zero) p
  | A : ('b s, 'c s) p -&gt; ('b, 'c) p
  | B : ('b, 'c s) q -&gt; ('b s, 'c s) p

and (_,_) q =
  | B : ('b, 'c) q -&gt; ('b s, 'c) q
  | C : 'c r -&gt; (zero, 'c s) q

and _ r =
  | End : zero r
  | C : 'c r -&gt; 'c s r

type start = Start of (zero,zero) p

let v = Start (A (B (C End)))
let v = Start (A (A (B (B (C (C End))))))
</code></pre>
<h4>Non recursive languages</h4>
<p>We can also encode solutions of Post Correspondance Problems (PCP), which are not recursive languages:</p>
<p>Suppose we have two alphabets A = { X, Y, Z } et O = { a, b } and two morphisms m1 and m2 from A to O* defined as</p>
<ul>
<li>m1(X) = a, m1(Y) = ab, m1(Z) = bba
</li>
<li>m2(X) = baa, m2(Y) = aa, m2(Z) = bb
</li>
</ul>
<p>Solutions of this instance of PCP are words such that their images by m1 and m2 are equal. for instance ZYZX is a solution: both images are bbaabbbaa. The language of solution can be represented by this type declaration:</p>
<pre><code class="language-ocaml">type empty
type 'a a = Dummy
type 'a b = Dummy

type (_,_) z =
  | X : ('t1, 't2) s -&gt; ('t1 a, 't2 b a a) z
  | Y : ('t1, 't2) s -&gt; ('t1 a b, 't2 a a) z
  | Z : ('t1, 't2) s -&gt; ('t1 b b a, 't2 b b) z

and (_,_) s =
  | End : (empty,empty) s
  | X : ('t1, 't2) s -&gt; ('t1 a, 't2 b a a) s
  | Y : ('t1, 't2) s -&gt; ('t1 a b, 't2 a a) s
  | Z : ('t1, 't2) s -&gt; ('t1 b b a, 't2 b b) s

type start = Start : ('a, 'a) z -&gt; start

let v = X (Z (Y (Z End)))
let r = Start (X (Z (Y (Z End))))
</code></pre>
<h3>Open question</h3>
<p>Can every context free language (not deterministic) be represented like that ? Notice that the classical example of the palindrome can be represented (proof let to the reader).</p>
<h3>Conclusion</h3>
<p>So we have a nice extension available that allows you to define a new syntax by merely declaring a type. The code is available on <a href="https://github.com/chambart/generic_ppx">github</a>. We are waiting for the nice syntax you will invent !</p>
<p>PS: Their may remain a small problem... If inadvertently you mistype something you may find some quite complicated type errors attacking you like a pyranha instead of a syntax error.</p>

