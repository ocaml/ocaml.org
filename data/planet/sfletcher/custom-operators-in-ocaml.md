---
title: Custom operators in OCaml
description: If like me, you've always been a little hazy on the rules for defining
  OCaml operators then, this little post might help!   It is possible ...
url: http://blog.shaynefletcher.org/2016/09/custom-operators-in-ocaml.html
date: 2016-09-20T20:08:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---

<p>
If like me, you've always been a little hazy on the rules for defining OCaml operators then, this little post might help!
</p>
<p>
It is possible to &quot;inject&quot; user-defined operator syntax into OCaml programs. Here's how it works. First we define a set of characters called &quot;symbol characters&quot;.
</p>

<h2>Symbol character (definition)</h2>
<p>
A character that is one of 
</p><pre class="prettyprint ml">
! $ % &amp; * + - . / : &lt; = &gt; ? @ ^ | ~
</pre>


<h2>Prefix operators</h2>

<p>
The <code>!</code> (&quot;bang&quot;) prefix operator, has a predefined semantic as the operation of &quot;de-referencing&quot; a reference cell. A custom prefix operator can made by from a <code>!</code> followed by one or more symbol characters.
</p>

<p>
So, to give some examples, one can define prefix operators like <code>!!</code>, <code>!~</code> or even something as exotic as <code>!::&gt;</code>. For example, one might write something like
</p><pre class="prettyprint ml">
let ( !+ ) x : int ref &rarr; unit = incr x
</pre>
as a syntactic sugar equivalent to <code>fun x &rarr; incr x</code>


<p>
Additionally, prefix operators can begin with one of <code>~</code> and <code>?</code> and, as in the case of <code>!</code>, must be followed by one or more symbol characters. So, in summary, a prefix operator begins with one of 
</p><pre class="prettyprint ml">
! ~ ?
</pre>
and is followed by one or more symbol characters.


<p>
For example <code>let ( ~! ) x = incr x</code> defines an alternative syntax equivalent to the <code>!+</code> operator presented earlier.
</p>

<p>
Prefix operators have the highest possible precedence.
</p>

<h2>Infix operators</h2>
<p>
It is in fact possible to define operators in 5 different categories. What distinguish these categories from each other are their associativity and precedence properties.
</p>
<h3>Level 0</h3>
<p>
Level 0 operators are left associative with the same precedence as <code>=</code>. A level 0 operator starts with one of
</p><pre class="prettyprint ml">
= &lt; &gt; | &amp; $
</pre>

and is followed by zero or more symbol chars. For example, <code>&gt;&gt;=</code> is an operator much beloved by monadic programmers and <code>|&gt;</code> (pipe operator) is a builtin equivalent to <code>let ( |&gt; ) x f = f x</code>.


<h3>Level 1</h3>
<p>
Level 1 operators are right associative, have a precedence just above <code>=</code> and start with one of 
</p><pre class="prettyprint ml">
@ ^
</pre>. That is, these operators are consistent with operations involving joining things. <code>@@</code> (the &quot;command&quot; operator) of course has a predefined semantic as function
application, that is, equivalent to the definition <code>let ( @@ ) f x = f x</code>.


<h3>Level 2</h3>
<p>
Level 2 operators are left associative have a precedence level shared with <code>+</code> and <code>-</code> and indeed, are defined with a leading (one of)
</p><pre class="prettyprint ml">
+ -
</pre>
and, as usual, followed by a sequence of symbol characters. These operators are consistent for usage with operations generalizing addition or difference like operations. Some potential operators of this kind are <code>+~</code>, <code>++</code> and so on.


<h3>Level 3</h3>
<p>
Level 3 operators are also left associative and have a precedence level shared with <code>*</code> and <code>/</code>. Operators of this kind start with one of 
</p><pre class="prettyprint ml">
* / %
</pre>
followed by zero or more symbol characters and are evocative of operations akin to multiplication, division. For example, <code>*~</code> might make a good companion for <code>+~</code> of the previous section.


<h3>Level 4</h3>
<p>
Level 4 operators are right associative and have a precedence above <code>*</code>. The level 4 operators begin with 
</p><pre class="prettyprint ml">
**
</pre>
and are followed by zero or more symbol characters. The operation associated with <code>**</code> is exponentiation (binds tight and associates to the right). The syntax <code>**~</code> would fit nicely into the <code>+~</code>, <code>*~</code> set of the earlier sections.


