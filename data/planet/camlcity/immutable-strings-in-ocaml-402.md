---
title: Immutable strings in OCaml-4.02
description:
url: http://blog.camlcity.org/blog/bytes1.html
date: 2014-07-04T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>Why the concept is not good enough</b><br/>&nbsp;
</div>

<div>
  
In the upcoming release 4.02 of the OCaml programming language, the type
<code>string</code> can be made immutable by a compiler
switch. Although this won't be the default yet, this should be seen as
the announcement of a quite disruptive change in the
language. Eventually this will be the default in a future version. In
this article I explain why I disagree with this particular plan, and
which modifications would be better.

</div>

<div>
  
<p>
Of course, the fact that <code>string</code> is mutable doesn't fit
well into a functional language. Nevertheless, it has been seen as
acceptable for a long time, probably because the developers of OCaml
did not pay much attention to strings, and felt that the benefits of a
somewhat cleaner concept wouldn't outweigh the practical disadvantages
of immutable strings. Apparently, this attitude changed, and we will
see a new <code>bytes</code> type in OCaml-4.02. This type is
accompanied by a <code>Bytes</code> module with library functions
supporting it. The compiler was also extended so
that <code>string</code> and <code>bytes</code> can be used
interchangably by default. If, however, the <code>-safe-strings</code>
switch is set on the command-line, the compiler
sees <code>string</code> and <code>bytes</code> as two completely
separate types.
</p>

<p>
This is a disruptive change (if enabled): Almost all code bases will
need modifications in order to be compatible with the new
concept. Although this will often be trivial, there are also harder
cases where strings are frequently used as buffers. Before discussing
that a bit more in detail, let me point out why such disruptive
changes are so problematic. So far there was an implicit guarantee
that your code will be compatible to new compiler versions if you
stick to the well-established parts of the language and avoid
experimental additions.  I have in deed code that was developed for
OCaml-1.03 (the first version I checked out), and that code still
runs. Especially in a commercial context this is a highly appreciated
feature, because this protects the investment in the code base. As I'm
trying to sell OCaml to companies in my carreer this is a point that
bothers me. Giving up this history of excellent backward compatibility
is something we shouldn't do easily, and if so, only if we get something
highly valuable back. (Of course, if you only look at the open source
and academic use of OCaml, you'll put less emphasis on the compatibility
point, but it's also not completely unimportant there.)
</p>


<h2>The problem</h2>
<p>
I'm fully aware that immutable strings fix some problems (the
worst probably: so far even string literals can be mutated, which can be
very surprising). However, creating a completely new type <code>bytes</code>
comes also with some disadvantages:

</p><ul>
<li>Lack of generic accessor functions: There is <code>String.get</code> and
there is <code>Bytes.get</code>. The shorthand <code>s.[k]</code> is now
restricted to strings. This is mostly a stylistic problem.

</li><li>The conversion of string to bytes and vice versa requires a copy:
<code>Bytes.of_string</code>, and <code>Bytes.to_string</code>. You have
to pay a performance penalty.

</li><li>In practical programming, there is sometimes no clear conceptual 
distinction between string data that are read-only and those that require
mutation. For example, if you add data to a buffer, the data may come from
a string or from another buffer. So how do you type such an <code>add</code>
function?
</li></ul>

This latter point is, in my opinion, the biggest problem. Let's assume
we wanted to reimplement the <code>Lexing</code> module of the
standard library in pure OCaml without resorting to unsafe coding
(currently it's done in C). This module implements the lexing buffer
that backs the lexers generated with ocamllex. We now have to
use <code>bytes</code> for the core of this buffer. There are three
functions in <code>Lexing</code> for creating new buffers:

<pre>
val from_channel : in_channel -&gt; lexbuf
val from_string : string -&gt; lexbuf
val from_function : (string -&gt; int -&gt; int) -&gt; lexbuf
</pre>

The first observation is that we'll better offer two more constructors
to the users of this module:

<pre>
val from_bytes : bytes -&gt; lexbuf
val from_bytes_function : (bytes -&gt; int -&gt; int) -&gt; lexbuf
</pre>

So why do we need the ability to read from <code>bytes</code>,
i.e. copy from one buffer to the other? We could just be a bad host
and don't offer these functions to the users of the module. However,
it's unavoidable anyway for <code>from_channel</code>, because I/O
buffers are of course <code>bytes</code>:

<pre>
let from_channel ch =
  from_bytes_function (Pervasives.input ch)
</pre>

So whenever we implement buffers that also include I/O capabilities,
it is likely that we need to handle both the <code>bytes</code> and
the <code>string</code> case. This is not only a problem for the
interface design. Because <code>string</code> and <code>bytes</code>
are completely separated, we need two different
implementations: <code>from_string</code> and
<code>from_bytes</code> cannot share much code.


<p>
This is the ironical part of the new concept: Although it tries to
make the handling of strings more sound and safe, the immediate
consequence in reality is that code needs to be duplicated because of
missing polymorphisms. Any half-way intelligent programmer will of
course fall back to unsafe functions for casting bytes to strings and
vice versa (<code>Bytes.unsafe_to_string</code>
and <code>Bytes.unsafe_of_string</code>), and this only means
that the new <code>-safe-strings</code> option will be a driving force
for using unsafe language features.
</p>

<p>
Let's look at three modifications of the concept. Is there some easy
fix?
</p>

<h2>Idea 1: <code>string</code> as a supertype of <code>bytes</code></h2>
<p>
We just allow that <code>bytes</code> can officially be
coerced to <code>string</code>:
</p>

<pre>
let s = (b : bytes :&gt; string)
</pre>

<p>
Of course, this weakens the immutability property: <code>string</code>
may now be a read-only interface for a <code>bytes</code> buffer, and
this buffer can be mutated, and this mutation can be observed through
the <code>string</code> type:
</p>

<pre>
let mutable_string() =
  let b = Bytes.make 1 'X' in
  let s = (b :&gt; string) in
  (s, Bytes.set 0)

let (s, set) = mutable_string()
(* s is now &quot;X&quot; *)
let () = set 'Y'
(* s is now &quot;Y&quot; *)
</pre>

<p>
Nevertheless, this concept is not meaningless. In particular, if a
function takes a string argument, it is guaranteed that the string
isn't modified. Also, string literals are immutable. Only when a
function returns a string, we cannot be sure that the string isn't
modified by a side effect.
</p>

<p>
This variation of the concept also solves the polymorphism problem we
explained at the example of the <code>Lexing</code> module: It is now
sufficient when we implement <code>Lexing.from_string</code>, because
<code>bytes</code> can always be coerced to <code>string</code>:

</p><pre>
let from_bytes s =
  from_string (s :&gt; string)
</pre>


<h2>Idea 2: Add a read-only type <code>stringlike</code></h2>
<p>
Some people may feel uncomfortable with the implication of Idea 1 that
the immutability of <code>string</code> can be easily circumvented.
This can be avoided with a variation: Add a third type
<code>stringlike</code> as the common supertype of both
<code>string</code> and <code>bytes</code>. So we allow:

</p><pre>
let sl1 = (s : string :&gt; stringlike)
let sl2 = (b : bytes :&gt; stringlike)
</pre>

Of course, <code>stringlike</code> doesn't implement mutators (like
<code>string</code>). It is nevertheless different from <code>string</code>:

<ul>
<li><code>string</code> is considered as absolutely immutable (there is no
way to coerce <code>bytes</code> to <code>string</code>)
</li><li><code>stringlike</code> is seen as the read-only API for either
<code>string</code> or <code>bytes</code>, and it is allowed to mutate
a <code>stringlike</code> behind the back of this API
</li></ul>

<p>
<code>stringlike</code> is especially interesting for interfaces that
need to be compatible to both <code>string</code> and <code>bytes</code>.
In the <code>Lexing</code> example, we would just define

</p><pre>
val from_stringlike : stringlike -&gt; lexbuf
val from_stringlike_function : (stringlike -&gt; int -&gt; int) -&gt; lexbuf
</pre>

and then reduce the other constructors to just these two, e.g.

<pre>
let from_string s =
  from_stringlike (s :&gt; stringlike)

let from_bytes b =
  from_stringlike (b :&gt; bytes)
</pre>

These other constructors are now only defined for the convenience
of the user.

<h2>Idea 3: Base <code>bytes</code> on bigarrays</h2>

<p>
This idea doesn't fix any of the mentioned problems. Instead, the
thinking is: If we already accept the incompatibility
between <code>string</code> and <code>bytes</code>, let's at least do
in a way so that we get the maximum out of it. Especially for I/O
buffers, bigarrays are way better suited than strings:

</p><ul>
<li>I/O primitives can directly pass the bigarrays to the operating
system (no need for an intermediate buffer as it is currently the case
for <code>Unix.read</code> and <code>Unix.write</code>)

</li><li>Bigarrays support the slicing of buffers (i.e. you can reference
subbuffers directly)

</li><li>Bigarrays can be aligned to page boundaries (which is accelerated
for some operating systems when used for I/O)
</li></ul>

<p>
So let's define:

</p><pre>
type bytes =
  (char,Bigarray.int8_unsigned_elt,Bigarray.c_layout) Bigarray.Array1.t
</pre>

Sure, there is now no way to unsafely cast strings to bytes and vice
versa anymore, but arguably we shouldn't prefer a design over the other
only for it's unsafety.


<p>
Regarding <code>stringlike</code>, it is in deed possible to define it,
but there is some runtime cost. As <code>string</code> and <code>bytes</code>
have now different representations, any accessor function for 
<code>stringlike</code> would have to check at runtime whether it is
backed by a <code>string</code> or by <code>bytes</code>. At least, this
check is very cheap.
</p>


<h2>Conclusion</h2>

I hope it has become clear that the current plan is not far reaching
enough, as the programmer would have to choose between bad alternatives:
either pay a runtime penalty for additional copying and accept that
some code needs to be duplicated, or use unsafe coercion
between <code>string</code> and <code>bytes</code>. The latter is not
desirable, of course, but it is surely the task of the language
(designer) to make sound and safe string handling an attractive option.
I've presented three ideas that would all improve the concept in
some respect. In particular, the combination of the ideas 2 and 3
seems to be very attractive: back <code>bytes</code> by bigarrays,
and provide an <code>stringlike</code> supertype for easing the
programming of application buffers.

<img src="http://blog.camlcity.org/files/img/blog/bytes1_bug.gif" width="1" height="1"/>


</div>

<div>
  Gerd Stolpmann works as O'Caml consultant

</div>

<div>
  
</div>


          
