---
title: Writing a Function Whose Argument is a Polymorphic Function in OCaml
description: In OCaml, it is not possible to write a function whose argument is a
  polymorphic function. Trying to write such a function results in the type-checker
  complaining back at you. The trick to be able to write such a function is to use
  records.
url: https://soap.coffee/~lthms/posts/RankNTypesInOCaml.html
date: 2022-08-07T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Writing a Function Whose Argument is a Polymorphic Function in OCaml</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> </div>
<p>In OCaml, it is not possible to write a function whose argument is a
polymorphic function. Trying to write such a function results in the
type-checker complaining back at you.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> foo (<span class="hljs-keyword">type</span> a b) id (x : a) (y : b) = (id x, id y)
</code></pre>
<pre><code class="hljs">Line 1, characters 50-51:
1 | let foo (type a b) id (x : a) (y : b) = (id x, id y);;
                                                      ^
Error: This expression has type b but an expression was expected
of type a
</code></pre>
<p>When OCaml tries to type check <code class="hljs language-ocaml">foo</code>, it infers <code class="hljs language-ocaml">id</code> expects an
argument of type <code class="hljs language-ocaml">a</code> because of <code class="hljs language-ocaml">id x</code>, then fails when trying
to type check <code class="hljs language-ocaml">id y</code>.</p>
<p>The trick to be able to write <code class="hljs language-ocaml">foo</code> is to use records. Indeed, while
the argument of a function cannot be polymorphic, the field of a record can.
This effectively makes it possible to write <code class="hljs language-ocaml">foo</code>, at the cost of a
level of indirection.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> id = {id : <span class="hljs-symbol">'a</span>. <span class="hljs-symbol">'a</span> -&gt; <span class="hljs-symbol">'a</span>}

<span class="hljs-keyword">let</span> foo {id} x y = (id x, id y)
</code></pre>
<p>From a runtime perspective, it is possible to tell OCaml to remove the
introduced indirection with the <code class="hljs language-ocaml">unboxed</code> annotation. There is nothing
we can do in the source, though. We need to destruct <code class="hljs language-ocaml">id</code> in
<code class="hljs language-ocaml">foo</code>, and we need to construct it at its call site.</p>
<pre><code class="hljs language-ocaml">g {id = <span class="hljs-keyword">fun</span> x -&gt; x}
</code></pre>
<p>As a consequence, this solution is not a silver bullet, but it is an option
that is worth considering if, <em>e.g.</em>, it allows us to export a cleaner API to the
consumer of a module. Personally, I have been considering this trick recently
to remove the need for a library to be implemented as a functor.</p>
        
      
