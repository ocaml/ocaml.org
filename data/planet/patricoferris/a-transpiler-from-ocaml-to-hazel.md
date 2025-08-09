---
title: A Transpiler from OCaml to Hazel
description:
url: https://patrick.sirref.org/hazel-of-ocaml/
date: 2025-05-02T00:00:00-00:00
preview_image:
authors:
- https://patrick.sirref.org/Patrick%20Ferris/
source:
ignore:
---


        <p>Over the past few months, I have been piecing together a transpiler from <a href="https://patrick.sirref.org/hazel/">Hazel</a> to OCaml. This is, in part, to help one of my third-year undergraduate students who is working on <a href="https://patrick.sirref.org/part-ii-hazel/">type error debugging in Hazel</a>.</p>
        <section>
          <header>
            <h2>Typed Holes</h2>
          </header>
          <p><a href="https://patrick.sirref.org/hazel/">Hazel</a> is a <a href="https://patrick.sirref.org/omar-hazel-2017/">functional programming language with typed holes</a>. Holes are pieces of your program that have not yet been filled in. Holes can appear anywhere in your program both as expression or types. Hazel can still evaluate your program in the presence of holes.</p>
          <p>To get a flavour of Hazel, take a regular map function for lists.</p>
          <pre>let map = fun f -&gt; fun xs -&gt; case xs
  | [] =&gt; []
  | x :: xs =&gt; f (x) :: map(f)(xs) 
end in
map(fun x -&gt; ?)([1, 2, 3])</pre>
          <p>The question mark ( <code>?</code>) is a hole. The program evaluates to the following expression of type <code>[?]</code> (for people more  familiar with OCaml types <code>? list</code>).</p>
          <pre>[ ?, ?, ? ]</pre>
          <p>Hazel supports <a href="https://patrick.sirref.org/zhao-typeerror-2024/">local type inference</a> but nothing involving unification variables. For example, a simple <code>add_one</code> function in <a href="https://patrick.sirref.org/hazel/">Hazel</a> ( <code>fun x -&gt; x + 1</code>) has type <code>? -&gt; Int</code>.</p>
        </section>
        <section>
          <header>
            <h2>From OCaml to Hazel</h2>
          </header>
          <p>The ability to transpile OCaml programs to Hazel programs is motivated by one simple thought: there are more OCaml programs than there are Hazel programs. This could help bootstrap projects by alleviating the need to rewrite boilerplate code (e.g. URI parsing or standard library functions for strings).</p>
          <section>
            <header>
              <h3>A Transformation of Syntax</h3>
            </header>
            <p>Hazel markets itself as an "Elm/ML-like functional programming language". From the previous example of <code>map</code>, it should be apparent just how close to OCaml the language is.</p>
            <p>It turns out that a majority of the transpiler is a <em>transformation of syntax</em>. Take a simple ADT for an arithmetic programming language.</p>
            <pre class="hilite">              <code><span class="ocaml-keyword-other">type</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Float</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">of</span><span class="ocaml-source"> </span><span class="ocaml-support-type">float</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Add</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">of</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">*</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Sub</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">of</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">*</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Mul</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">of</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">*</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-capital-identifier">Div</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">of</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">*</span><span class="ocaml-source"> </span><span class="ocaml-source">expr</span><span class="ocaml-source">
</span></code>
            </pre>
            <p>And when we run <a href="https://patrick.sirref.org/hazel_of_ocaml/">hazel_of_ocaml</a> over this OCaml type declaration.</p>
            <pre>type expr =
  + Float(Float)
  + Add((expr, expr))
  + Sub((expr, expr))
  + Mul((expr, expr))
  + Div((expr, expr))
 in ?</pre>
            <p>Not much has changed expect some syntax. <a href="https://patrick.sirref.org/hazel/">Hazel</a> does not have a notion of top-level expression so <a href="https://patrick.sirref.org/hazel_of_ocaml/">hazel_of_ocaml</a> wraps the program into one set of value bindings. For the most part, Hazel acts as a subset of the pure, functional part of OCaml. At the time of writing, this subset is fairly limited with no support for modules or labelled records out of the box (there are plenty of development branches  with these features).</p>
            <p>If we try out the same <code>map</code> function but written in OCaml and transpiled to Hazel we get.</p>
            <pre class="hilite">              <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-keyword">rec </span><span class="ocaml-entity-name-function-binding">map</span><span class="ocaml-source"> </span><span class="ocaml-source">f</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">function</span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-list">[] </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-list">[] </span><span class="ocaml-source">
</span>
<span class="ocaml-source">  </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-source">xs</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-source">f</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-source">map</span><span class="ocaml-source"> </span><span class="ocaml-source">f</span><span class="ocaml-source"> </span><span class="ocaml-source">xs</span><span class="ocaml-source">
</span></code>
            </pre>
            <p>Which becomes the following hazel program.</p>
            <pre>let map = fun f -&gt; fun x1 -&gt; case x1
  | [] =&gt; []
  | x :: xs =&gt; f(x) :: map(f)(xs)
end in ?</pre>
            <p>We could have a field day discussing the syntax of OCaml and Hazel (parentheses for function arguments, well-scoped cases for pattern-matching, a  different arrow for pattern-matching etc.). What would be more interesting is  taking a look at how to handle polymorphism in Hazel.</p>
          </section>
          <section>
            <header>
              <h3>Explicit Polymorphism</h3>
            </header>
            <p>Hazel has <em>explicit polymorphism</em>. So far, we have not seen it as we have let the types have holes in them. The <code>map</code> function in OCaml has the following type.</p>
            <pre class="hilite">              <code><span class="ocaml-keyword-other">val</span><span class="ocaml-source"> </span><span class="ocaml-source">map</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> 
</span>
<span class="ocaml-source">  </span><span class="ocaml-source">( </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'b</span><span class="ocaml-source">) </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'a</span><span class="ocaml-source"> </span><span class="ocaml-source">list</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-storage-type">'b</span><span class="ocaml-source"> </span><span class="ocaml-source">list</span><span class="ocaml-source">
</span></code>
            </pre>
            <p>We must remind ourselves (by reading <a href="https://www.craigfe.io/posts/polymorphic-type-constraints">Craig's excellent blogpost on the matter</a>) that in OCaml</p>
            <blockquote>
              <p>... type variables in signatures are implicitly universally-quantified</p>
            </blockquote>
            <p>So in reality, we have that <code>map</code> has the following type.</p>
            <pre>val map : ∀ a b. (a -&gt;  b) -&gt; a list -&gt; b list</pre>
            <p>In Hazel, we have to explicitly type our <code>map</code> function to be polymorphic. Not only does this mean the type annotation requires universally quantified type variables, but we must also perform type application wherever we choose to apply the <code>map</code> function (whether that be recursively or somewhere later in our  program).</p>
            <pre>let map : forall a -&gt; forall b -&gt; (a -&gt; b) -&gt; [a] -&gt; [b] =
  typfun a -&gt; typfun b -&gt; fun f -&gt; fun xs -&gt; case xs
    | [] =&gt; []
    | x :: xs =&gt; f (x) :: map@&lt;a&gt;@&lt;b&gt;(f)(xs) 
end in
map@&lt;Int&gt;@&lt;Int&gt;(fun x -&gt; ?)([1, 2, 3])</pre>
            <p><code>forall</code> introduces a universally quantified type variable into our type annotation, and <code>typfun</code> introduces it into the function itself (à la System F). Type application  requires <code>@&lt;T&gt;</code> where <code>T</code> is some type. This allows hazel to quite easily support higher rank polymorphism, but we will not worry too much about that.</p>
          </section>
          <section>
            <header>
              <h3>Propagating OCaml Types into Hazel</h3>
            </header>
            <p>Most often, OCaml users interact with <em>prenex</em> polymorphism (rank-1) where the universal quantifiers are  at the front of the type. <a href="https://ocaml.org/manual/5.2/polymorphism.html#s:higher-rank-poly">OCaml does support quantifiers inside certain types like records</a>.</p>
            <p>What this means for the transpiler is that we can <strong>reuse OCaml's type inference</strong> to safely instantiate the correct type annotations and type applications in Hazel! To do this, <code>hazel_of_ocaml</code> uses <a href="https://ocaml.github.io/merlin/">Merlin</a> to inspect the type of the function in either a value binding or at the point of a function application.</p>
            <p>Take a simple, polymorphic <code>length</code> function.</p>
            <pre class="hilite">              <code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-keyword">rec </span><span class="ocaml-entity-name-function-binding">length</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other">function</span><span class="ocaml-source">
</span>
<span class="ocaml-source"> </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-list">[] </span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">0</span><span class="ocaml-source">
</span>
<span class="ocaml-source"> </span><span class="ocaml-keyword-other">|</span><span class="ocaml-source"> </span><span class="ocaml-constant-language">_</span><span class="ocaml-source"> </span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-keyword-other-ocaml punctuation-other-colon punctuation">:</span><span class="ocaml-source"> </span><span class="ocaml-source">xs</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">-&gt;</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">1</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">+</span><span class="ocaml-source"> </span><span class="ocaml-source">length</span><span class="ocaml-source"> </span><span class="ocaml-source">xs</span><span class="ocaml-source">
</span>
<span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">int_len</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">length</span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">1</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">2</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">3</span><span class="ocaml-source"> </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span>
<span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">str_len</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">length</span><span class="ocaml-source"> </span><span class="ocaml-source">[ </span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">only</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">two</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source"> </span><span class="ocaml-source">] </span><span class="ocaml-source">
</span></code>
            </pre>
            <p>When we run this through <code>hazel_of_ocaml</code> with the <code>-type</code> flag we get.</p>
            <pre>let length : forall a -&gt; [a] -&gt; Int = typfun a -&gt; fun x1 -&gt; case x1
  | [] =&gt; 0
  | _ :: xs =&gt; 1 + length@&lt;a&gt;(xs)
end in
let int_len : Int = length@&lt;Int&gt;(1 :: 2 :: [3]) in
let str_len : Int = length@&lt;String&gt;("only" :: ["two"])
in ?</pre>
            <p><code>hazel_of_ocaml</code> has correctly instantiated the type for <code>length</code> inside the recursive function and then in each case with the integer list and the string list.</p>
          </section>
        </section>
        <section>
          <header>
            <h2>A Corpus of Hazel Programs</h2>
          </header>
          <p>The impetus for this work was to derive a corpus of ill-typed Hazel programs. Luckily, such a corpus exists for OCaml! <a href="https://patrick.sirref.org/ocaml-corpus/">Seidel et al.</a> created a corpus of OCaml programs from their undergraduate students at UC San Diego. <a href="https://github.com/patricoferris/hazel-corpus">Some of these programs have been transpiled to Hazel</a>.</p>
        </section>
        <section>
          <header>
            <h2>Future Work</h2>
          </header>
          <p><a href="https://patrick.sirref.org/hazel/">Hazel</a> is a fun, research programming language. Potential third-year students may find it interesting to take this work further. For example, how would this look in terms of a module system? From a purely engineering perspective, plenty of work would be needed to convert a multi-library OCaml project to Hazel (e.g. handling the <code>cmi</code> files).</p>
          <p>Another line of research would be to have Hazel target one of the intermediate representations in OCaml which would give Hazel a fully functioning compiler to "native" code?</p>
        </section>
      
