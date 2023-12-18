---
title: EzSudoku
description: As you may have noticed, on the begining of April I have some urge to
  write something technical about some deeply specific point of OCaml. This time I'd
  like to tackle that through sudoku. It appeard that Sudoku is of great importance
  considering the number of posts explaining how to write a solver....
url: https://ocamlpro.com/blog/2017_04_01_ezsudoku
date: 2017-04-01T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    chambart\n  "
source:
---

<p>As you may have noticed, on the begining of April I have some urge to write something technical about some deeply specific point of OCaml. This time I'd like to tackle that through sudoku.</p>
<p>It appeard that Sudoku is of great importance considering the number of posts explaining how to write a solver. Following that trend I will explain how to write one in OCaml. But with a twist.</p>
<p>We will try to optimize it. I won't show you anything as obvious as how to micro-optimize your code or some smart heuristc. No we are not aiming for being merely algorithmically good. We will try to make something serious, we are want it to be solved even before the program starts.</p>
<p>Yes really. Before. And I will show you how to use a feature of OCaml 4.03 that is sadly not well known.</p>
<hr/>
<p>First of all, as we do like type and safe programs, we will define what a well formed sudoku solution looks like. And by defining of course I mean declaring some GADTs with enough constraints to ensure that only well correct solutions are valid.</p>
<p>I assume tha you know the rules of Sudoku and will refrain from infuriating you by explaining it. But we will still need some vocabulary.</p>
<p>So the aim of sudoku is to fill a 'grid' with 'symbols' satisfying some 'row' 'column' and 'square' constraints.</p>
<p>To make the code examples readable we will stick to <code>4*4</code> sudokus. It's the smallest size that behaves the same way as <code>9*9</code> ones (I considered going for <code>1*1</code> ones, but the article ended up being a bit short). Of course everything would still apply to any <code>n^2*n^2</code> sized one.</p>
<p>So let's start digging in some types. As we will refine them along the way, I will leave some parts to be filled later. This is represented by '...' .</p>
<p>First there are symbols, just 4 of them befause we reduced the size. Nothing special about that right now.</p>
<pre><code class="language-ocaml">type ... symbol =
  | A : ...
  | B : ...
  | C : ...
  | D : ...
</code></pre>
<p>And a grid is 16 symbols. To avoid too much visual clutter in the type I just put them linearly. The comment show how it is supposed to be seen in the 2d representation of the grid:</p>
<pre><code class="language-ocaml">(* a b c d
   e f g h
   i j k l
   m n o p *)

type grid =
  Grid :
    ... symbol * (* a *)
    ... symbol * (* b *)
    ... symbol * (* c *)
    ... symbol * (* d *)

    ... symbol * (* e *)
    ... symbol * (* f *)
    ... symbol * (* g *)
    ... symbol * (* h *)

    ... symbol * (* i *)
    ... symbol * (* j *)
    ... symbol * (* k *)
    ... symbol * (* l *)

    ... symbol * (* m *)
    ... symbol * (* n *)
    ... symbol * (* o *)
    ... symbol (* p *)
      -&gt; solution
</code></pre>
<p>Right now grid is a simple 16-uple of symbols, but we will soon start filling those '...' to forbid any set of symbols that is not a valid solution.</p>
<p>Each constraint looks like, 'among those 4 positions neither 2 symbols are the same'. To express that (in fact something equivalent but a bit simpler to state with our types), we will need to name positions. So let's introduce some names:</p>
<pre><code class="language-ocaml">type r1 (* the first position among a row constraint *)
type r2 (* the second position among a row constraint *)
type r3
type r4

type c1 (* the first position among a column constraint *)
type c2
type c3
type c4

type s1
type s2
type s3
type s4

type ('row, 'column, 'square) position
</code></pre>
<p>On the 2d grid this is how the various positions will be mapped.</p>
<pre><code>r1 r2 r3 r4
r1 r2 r3 r4
r1 r2 r3 r4
r1 r2 r3 r4

c1 c1 c1 c1
c2 c2 c2 c2
c3 c3 c3 c3
c4 c4 c4 c4

s1 s2 s1 s2
s3 s4 s3 s4
s1 s2 s1 s2
s3 s4 s4 s4
</code></pre>
<p>For instance, the position g, in the 2nd row, 3rd column, will at the 3rd position in its row constraint, 2nd in its column constraint, and 3rd in its square constraint:</p>
<pre><code class="language-ocaml">type g = (r3, c2, s3) position
</code></pre>
<p>We could have declare a single constraint position type, but this is slightly more readable. than:</p>
<pre><code class="language-ocaml">type g = (p3, p2, p3) position
</code></pre>
<p>The position type is phantom, we could have provided a representation, but since no value of this type will ever be created, it's less confusing to state it that way.</p>
<pre><code class="language-ocaml">type a = (r1, c1, s1) position
type b = (r2, c1, s2) position
type c = (r3, c1, s1) position
type d = (r4, c1, s2) position

type e = (r1, c2, s3) position
type f = (r2, c2, s4) position
type g = (r3, c2, s3) position
type h = (r4, c2, s4) position

type i = (r1, c3, s1) position
type j = (r2, c3, s2) position
type k = (r3, c3, s1) position
type r = (r4, c3, s2) position

type m = (r1, c4, s3) position
type n = (r2, c4, s4) position
type o = (r3, c4, s3) position
type p = (r4, c4, s4) position
</code></pre>
<p>It is now possible to state for each symbol in which position it is, so we will start filling a bit those types.</p>
<pre><code class="language-ocaml">type ('position, ...) symbol =
  | A : (('r, 'c, 's) position, ...) symbol
  | B : (('r, 'c, 's) position, ...) symbol
  | C : (('r, 'c, 's) position, ...) symbol
  | D : (('r, 'c, 's) position, ...) symbol
</code></pre>
<p>This means that a symbol value is then associated to a single position in each constraint. We will need to state that in the grid type too:</p>
<pre><code class="language-ocaml">type grid =
  Grid :
    (a, ...) symbol * (* a *)
    (b, ...) symbol * (* b *)
    (c, ...) symbol * (* c *)
    (d, ...) symbol * (* d *)

    (e, ...) symbol * (* e *)
    (f, ...) symbol * (* f *)
    (g, ...) symbol * (* g *)
    (h, ...) symbol * (* h *)

    (i, ...) symbol * (* i *)
    (j, ...) symbol * (* j *)
    (k, ...) symbol * (* k *)
    (l, ...) symbol * (* l *)

    (m, ...) symbol * (* m *)
    (n, ...) symbol * (* n *)
    (o, ...) symbol * (* o *)
    (p, ...) symbol (* p *)
    -&gt; solution
</code></pre>
<p>We just need to forbid a symbol to appear in two different positions of a given row/column/square to prevent invalid solutions.</p>
<pre><code class="language-ocaml">type 'fields row constraint 'fields = &lt; a : 'a; b : 'b; c : 'c; d : 'd &gt;
type 'fields column constraint 'fields = &lt; a : 'a; b : 'b; c : 'c; d : 'd &gt;
type 'fields square constraint 'fields = &lt; a : 'a; b : 'b; c : 'c; d : 'd &gt;
</code></pre>
<p>Those types represent the statement 'in this line/column/square, the symbol a is at the position 'a, the symbol b is at the position 'b, ...'</p>
<p>For instance, the row 'A D B C' will be represented by</p>
<pre><code class="language-ocaml">&lt; a : l1; b : l3; c : l4; d : l2 &gt; row
</code></pre>
<p>Which reads: 'The symbol A is in first position, B in third position, C in fourth, and D in second'</p>
<p>The object type is used to make things a bit lighter later and allow to state names.</p>
<p>Now the symbols can be a bit more annotated:</p>
<pre><code class="language-ocaml">type ('position, 'row, 'column, 'square) symbol =
  | A : (('r, 'c, 's) position,
         &lt; a : 'r; .. &gt; row,
         &lt; a : 'c; .. &gt; column,
         &lt; a : 's; .. &gt; square)
        symbol

  | B : (('r, 'c, 's) position,
         &lt; b : 'r; .. &gt; row,
         &lt; b : 'c; .. &gt; column,
         &lt; b : 's; .. &gt; square)
        symbol

  | C : (('r, 'c, 's) position,
         &lt; c : 'r; .. &gt; row,
         &lt; c : 'c; .. &gt; column,
         &lt; c : 's; .. &gt; square)
        symbol

  | D : (('r, 'c, 's) position,
         &lt; d : 'r; .. &gt; row,
         &lt; d : 'c; .. &gt; column,
         &lt; d : 's; .. &gt; square)
        symbol
</code></pre>
<p>Notice that '..' is not '...'. Those dots are really part of the OCaml syntax: it means 'put whatever you want here, I don't care'. There is nothing more to add to this type.</p>
<p>This type declaration reports the position information. Using the same variable name 'r in the position and in the row constraint parameter for instance means that both fields will have the same type.</p>
<p>For instance, a symbol 'B' in position 'g' would be in the 3rd position of its row, 2nd position of its column , and 3rd position of its square:</p>
<pre><code class="language-ocaml">let v : (g, _, _, _) symbol = B;;
val v :
  (g, &lt; b : r3 &gt; row,
      &lt; b : c2 &gt; column,
      &lt; b : s3 &gt; square)
symbol = B
</code></pre>
<p>Those types constraints ensure that this is correctly reported.</p>
<p>The real output of the type checker is a bit more verbose, but I remove the irrelevant part:</p>
<pre><code class="language-ocaml">val v :
  (g, &lt; a : 'a; b : r3; c : 'b; d : 'c &gt; row,
      &lt; a : 'd; b : c2; c : 'e; d : 'f &gt; column,
      &lt; a : 'g; b : s3; c : 'h; d : 'i &gt; square)
symbol = B
</code></pre>
<p>We are now quite close from a completely constrained type. We just need to say that the various symbols from the same row/line/column constraint have the same type:</p>
<pre><code class="language-ocaml">type grid =
  Grid :
    (a, 'row1, 'column1, 'square1) symbol *
    (b, 'row1, 'column2, 'square1) symbol *
    (c, 'row1, 'column3, 'square2) symbol *
    (d, 'row1, 'column4, 'square2) symbol *

    (e, 'row2, 'column1, 'square1) symbol *
    (f, 'row2, 'column2, 'square1) symbol *
    (g, 'row2, 'column3, 'square2) symbol *
    (h, 'row2, 'column4, 'square2) symbol *

    (i, 'row3, 'column1, 'square3) symbol *
    (j, 'row3, 'column2, 'square3) symbol *
    (k, 'row3, 'column3, 'square4) symbol *
    (l, 'row3, 'column4, 'square4) symbol *

    (m, 'row4, 'column1, 'square3) symbol *
    (n, 'row4, 'column2, 'square3) symbol *
    (o, 'row4, 'column3, 'square4) symbol *
    (p, 'row4, 'column4, 'square4) symbol *
</code></pre>
<p>That is two symbols in the same row/column/square will share the same 'row/'symbol/'square type. For any couple of symbols in say, a row, they must agree on that type, hence, on the position of every symbol.</p>
<p>Let's look at the 'A' symbol for the 'a' and 'c' position for instance. Both share the same 'row1 type variable. There are two cases. Either both are 'A's ore one is not.</p>
<ul>
<li>If one symbol is not a 'A', let's say those are 'C' and 'A' symbols. Their row type (pun almost intended) will be respectively <code>&lt; c : r1; .. &gt;</code> and <code>&lt; a : r3; .. &gt;</code>. Meaning that 'C' does not care about the position of 'A' and conversly. Those types are compatible. No problem here.
</li>
<li>If both are 'A's then something else happens. Their row types will be <code>&lt; a : r1; .. &gt;</code> and <code>&lt; a : r3; .. &gt;</code> which is certainly not compatible since r1 and r3 are not compatible. This will be rejected.
Now we have a grid type that checks the sudoku constraints !
</li>
</ul>
<p>Let's try it.</p>
<pre><code class="language-ocaml">let ok =
  Grid
    (A, B, C, D,
     C, D, A, B,

     D, A, B, C,
     B, C, D, A)

val ok : grid = Grid (A, B, C, D, C, D, A, B, D, A, B, C, B, C, D, A)

let not_ok =
  Grid
    (A, B, C, D,
     C, D, A, B,

     D, A, B, C,
     B, C, A, D)

     B, C, A, D);;
  ^
Error: This expression has type
  (o, &lt; a : r3; b : r1; c : r2; d : 'a &gt; row,
      &lt; a : c4; b : 'b; c : 'c; d : 'd &gt; column,
      &lt; a : s3; b : 'e; c : 'f; d : 'g &gt; square)
    symbol
but an expression was expected of type
  (o, &lt; a : r3; b : r1; c : r2; d : 'a &gt; row,
      &lt; a : c2; b : c3; c : c1; d : 'h &gt; column,
      &lt; a : 'i; b : s1; c : s2; d : 'j &gt; square)
    symbol
Types for method a are incompatible
</code></pre>
<p>What it is trying to say is that 'A' is both at position '2' and '4' of its column. Well it seems to work.</p>
<h2>Solving it</h2>
<p>But we are not only interested in checking that a solution is correct, we want to find them !</p>
<p>But with 'one weird trick' we will magically transform it into a solver, namely the <code>-&gt; .</code> syntax. It was introduced in OCaml 4.03 for some other <a href="https://ocaml.org/manual/gadts.html#p:gadt-refutation-cases">purpose</a>. But we will now use its hidden power !</p>
<p>This is the right hand side of a pattern. It explicitely states that a pattern is unreachable. For instance</p>
<pre><code class="language-ocaml">type _ t =
  | Int : int -&gt; int t
  | Float : float -&gt; float t

let add (type v) (a : v t) (b : v t) : v t =
  match a, b with
  | Int a, Int b -&gt; Int (a + b)
  | Float a, Float b -&gt; Float (a +. b)
  | _ -&gt; .
</code></pre>
<p>By writing it here you state that you don't expect any other pattern to verify the type constraints. This is effectively the case here. In general you won't need this as the exhaustivity checker will see it. But in some intricate situations it will need some hints to work a bit more. For more information see <a href="http://export.arxiv.org/abs/1702.02281">Jacques Garrigue / Le Normand article</a></p>
<p>This may be a bit obscure, but this is what we now need. Indeed, we can ask the exhaustivity checker if there exist a value verifying the pattern and the type constraints. For instance to solve a problem, we ask the compiler to check if there is any value verifying a partial solution encoded as a pattern.</p>
<pre><code> A _ C _
 _ D _ B
 _ A D _
 D _ B _
</code></pre>
<pre><code class="language-ocaml">let test x =
  match x with
  | Grid
    (A, _, C, _,
     _, D, _, B,

     _, A, D, _,
     D, _, B, _) -&gt; .
  | _ -&gt; ()

Error: This match case could not be refuted.
Here is an example of a value that would reach it:
Grid (A, B, C, D, C, D, A, B, B, A, D, C, D, C, B, A)
</code></pre>
<p>The checker tells us that there is a solution verifying those constraints, and provides it.</p>
<p>If there were no solution, there would have been no error.</p>
<pre><code class="language-ocaml">let test x =
  match x with
  | Grid
    (A, B, C, _,
     _, _, _, D,

     _, _, _, _,
     _, _, _, _) -&gt; .
  | _ -&gt; ()

val test : grid -&gt; unit =
</code></pre>
<p>And that's it !</p>
<h2>Wrapping it up</h2>
<p>Of course that's a bit cheating since the program is not executable, but who cares really ?
If you want to use it, I made a small (ugly) <a href="https://gist.github.com/chambart/15b18770d2368cc703a32f18fe12d179">script</a> generating those types. You can try it on bigger problems, but in fact it is a bit exponential. So you shouldn't really expect an answer too soon.</p>
<h1>Comments</h1>
<p>Louis Gesbert (28 April 2017 at 8 h 11 min):</p>
<blockquote>
<p>Brilliant!</p>
</blockquote>

