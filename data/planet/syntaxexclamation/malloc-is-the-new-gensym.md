---
title: malloc() is the new gensym()
description: "Teaching an introductory course to \u201Ccompilation\u201D this semester
  (actually it was called Virtual Machines, but it was really about compiling expressions
  to stack machines), I realized something I had\u2026"
url: https://syntaxexclamation.wordpress.com/2013/05/04/malloc-is-the-new-gensym/
date: 2013-05-04T15:15:44-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>Teaching an introductory course to &ldquo;compilation&rdquo; this semester (actually it was called  <a href="http://www.pps.univ-paris-diderot.fr/~puech/ens/mv6.html">Virtual Machines</a>, but it was really about compiling expressions to stack machines), I realized something I hadn&rsquo;t heard before, and wish I had been told when I first learned OCaml many years ago. Here it is: as soon as you are programming in a functional language with physical equality (i.e. pointer equality, the <code>(==)</code> operator in OCaml), then you are actually working in a &ldquo;weakly impure&rdquo; language, and you can for example implement a limited form of <code>gensym</code>. What? <code>gensym</code> is this classic &ldquo;innocuously effectful&rdquo; function returning a different <i>symbol</i>&mdash;usually a string&mdash;each time it is called. It is used pervasively to generate fresh variable names, in compilers notably. How? well, you actually don&rsquo;t have much to do, except let the runtime call <code>malloc</code>: it will return a &ldquo;fresh&rdquo; pointer where to store your data. <code>malloc</code> and the garbage collector together ensures this freshness condition, and you can then compare two pointers with <code>(==)</code>. As a bonus, you can even store data along your fresh symbol.</p>
<p>In this post, I&rsquo;ll exploit that simple idea to develop an assembler for a little stack machine close to that of OCaml.</p>
<p><span></span></p>
<h3>The idea</h3>
<p>In OCaml, something as simple as this is a <code>gensym</code>:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'a sym = C of 'a
let gensym x = C x
</pre>
<p>Each call to say <code>gensym ()</code> will allocate one new data block in memory; you can then compare two symbols with the physical equality <code>(==)</code>.What we care about here is not the content of that memory span, but its <i>address</i>, which is unique.</p>
<p>A few warnings first: in OCaml, the constructor must have arguments, otherwise the compiler optimizes the representation to a simple integer and nothing is allocated. Also, don&rsquo;t replace the argument <code>x</code> to <code>C</code> by a constant, say <code>()</code>, in the function code: if you do so, the compiler will place value <code>C ()</code> in the data segment of the program, and calling <code>gensym</code> will not trigger an allocation either. There is an excellent and already classic series of blog post about OCaml&rsquo;s value representation <a href="http://rwmj.wordpress.com/2009/08/04/ocaml-internals/">here</a>.</p>
<p>Another way of saying the same thing is that (non-cyclic) values in OCaml are not trees, as they can be thought of considering the purely functional fragment, but DAGs, that is trees with sharing. </p>
<p>I think that not many beginner/intermediate OCaml programmers realize the power of this, so I&rsquo;d like to show a cool application of this remark. We will code a small compiler from a arithmetic language to a stack machine. Bear with me, it&rsquo;s going to be fun!</p>
<h3>An application: compiling expressions to a stack machine</h3>
<p>The input language of expressions is:</p>
<pre class="brush: fsharp; title: ; notranslate">
type expr =
  | Int of int
  | Plus of expr * expr
  | If of expr * expr * expr
</pre>
<p>Its semantics should be clear, except for the fact that <code>If</code> are like in C: if their condition is different than 0, then their first branch is taken; if it is 0, then the second is taken. Because we have these conditionals, the stack machine will need instructions to jump around in the code. The instructions of this stack machine are:</p>
<ul>
<li><code>Push i</code> pushes <code>i</code> on the stack;</li>
<li><code>Add</code> pops two values off the stack and pushes their sum;</li>
<li><code>Halt</code> stops the machine and returning the (supposedly unique) stack value;</li>
<li><code>Branch o</code> skips the next <code>o</code> instructions in the code;</li>
<li><code>Branchif o</code> skips the next <code>o</code> instructions <i>if</i> the top of the stack is not <code>0</code>, and has no effect otherwise
</li></ul>
<p>For instance, the expression <i>1 + (if 0 then 2 else (3+3))</i> is compiled into:</p>
<pre class="brush: fsharp; title: ; notranslate">
[Push 1; Push 0; Branchif 3; 
   Push 3; Push 3; Add; Branch 1;
   Push 2;
 Add; Halt]
</pre>
<p>and evaluates of course to <code>7</code>. Notice how the two branches of the <code>If</code> are turned around in the code? First, we&rsquo;ve got the code of expression <i>2</i>, then the code of <i>3+3</i>. In general, expression <i>if e1 then e2 else e3</i> will be compiled to [<i>c1</i>; <code>Branchif</code> (|<i>c3</i>|+1); <i>c3</i>; <code>Branch</code> |<i>c2</i>|; <i>c2</i>; &hellip;] where <i>ci</i> is the compiled code of <i>ei</i>, and |<i>l</i>| is the size of code <i>l</i>. But I&rsquo;m getting ahead of myself.</p>
<h3>Compilation</h3>
<p>Now, compiling an <code>expr</code> to a list of instructions in one pass would be a little bit messy, because we have to compute these integer offset for jumps. Let&rsquo;s follow instead the common practice and first compile expressions to an assembly language where some suffixes of the code have <i>labels</i>, which are the names referred to by instructions <code>Branch</code> and <code>Branchif</code>. This assembly language <code>asm</code> will then be well&hellip; assembled into actual <code>code</code>, where jumps are translated to integer offsets. But instead of generating label names by side-effect as customary, let&rsquo;s use our trick: we will refer to them by a unique <i>pointer</i> to the code attached to it. In other words, the arguments to <code>Branch</code> and <code>Branchif</code> will actually be pointers to <code>asm</code> programs, comparable by <code>(==)</code>.</p>
<p>To represent the <code>code</code> and <code>asm</code> data structures, we generalize over the notion of label:</p>
<pre class="brush: fsharp; title: ; notranslate">
type 'label instr =
  | Push of int
  | Add
  | Branchif of 'label
  | Branch of 'label
  | Halt
</pre>
<p>An assembly program is a list of instruction where labels are themselves assembly programs (the <code>-rectypes</code> option of OCaml is required here):</p>
<pre class="brush: fsharp; title: ; notranslate">
type asm = asm instr list
</pre>
<p>For instance, taking our previous example,</p>
<pre class="brush: fsharp; title: ; notranslate">
Plus (Int 1, If (Int 0, Int 2, Plus (Int 3, Int 3)))
</pre>
<p>is compiled to the (shared) value:</p>
<pre class="brush: fsharp; title: ; notranslate">
Push 1 :: Push 0 :: 
  let k = [Add; Halt] in 
  Branchif (Push 2 :: k) :: 
  Push 3 :: Push 3 :: Add :: k
</pre>
<p>See how the suffix <code>k</code> (the continuation of the <code>If</code>) is shared among the <code>Branchif</code> and the main branch? In call-by-value, this is a value: if you reduce it any further by inlining <code>k</code>, you will get a different value, that can be told apart from the first by using <code>(==)</code>. So don&rsquo;t let OCaml&rsquo;s pretty-printing of values fool you: this is not a tree, the sharing of <code>k</code> <i>is</i> important! What you get is the DAG of all possible execution traces of your program; they eventually all merge in one point, the code suffix <code>k = [Add; Halt]</code>.</p>
<p>The compilation function is relatively straightforward; it&rsquo;s an accumulator-based function:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec compile e k = match e with
  | Int i -&gt; Push i :: k
  | Plus (e1, e2) -&gt; compile e1 (compile e2 (Add :: k))
  | If (e1, e2, e3) -&gt;
    compile e1 (Branchif (compile e2 k) :: compile e3 k)

let compile e = compile e [Halt]
</pre>
<p>The sharing discussed above is realized here in the <code>If</code> case, by compiling its two branches using the accumulator (continuation) <code>k</code> twice. Again, many people think of this erroneously as <i>duplicating</i> a piece of value. Actually, this is only mentioning twice a pointer to an already-allocated unique piece of value; and since we can compare pointers, we have a way to know that they are the same. Note also that this compilation function is purely compositional: to each subexpression corresponds a contiguous span of assembly code.</p>
<h3>Assembly</h3>
<p>Now, real code for our machine is simply a list of instructions where labels are represented by (positive) integers:</p>
<pre class="brush: fsharp; title: ; notranslate">
type code = int instr list
</pre>
<p>Why positive? Well, since we have no way to make a loop, code can be arranged such that all jumps are made <i>forward</i> in the code.</p>
<p>The assembly function took me a while to figure out. It &ldquo;linearizes&rdquo; the assembly, a DAG, into a list by traversing it depth-first. The tricky part is that we don&rsquo;t want to repeat the common suffixes of all branches; that&rsquo;s where we use the fact that they are at the same memory address, which we can check with <code>(==)</code>. If a piece of input code has already been compiled <i>n</i> instructions ahead in the output code, instead of repeating it we just emit a <code>Branch</code> <i>n</i>.</p>
<p>So practically, we must keep as an argument an association list <code>k</code> mapping already-compiled suffixes of the input to the corresponding output instruction; think of it as a kind of &ldquo;cache&rdquo; of the function. It also doubles as the <i>result</i> of the process: it is what&rsquo;s eventually returned by <code>assemble</code>. For each input <code>is</code>, we first traverse that list <code>k</code> looking for the pointer <code>is</code>; if we find it, then we have our <code>Branch</code> instruction; otherwise, we assemble the next instruction. This first part of the job corresponds to the <code>assemble</code> function:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec assemble is k =
  try (is, Branch (List.index (fun (is', _) -&gt; is == is') k)) :: k
  with Not_found -&gt; assem is k
</pre>
<p>(<code>List.index p xs</code> returns the index of the first element <code>x</code> of <code>xs</code> such that <code>p x</code> is <code>true</code>). </p>
<p>Now the auxiliary function <code>assem</code> actually assembles instructions into a list of pairs of source programs and target instruction:</p>
<pre class="brush: fsharp; title: ; notranslate">
and assem asm k = match asm with
  | (Push _ | Add | Halt as i) :: is -&gt;
    (asm, i) :: assemble is k
  | Branchif is :: js -&gt;
    let k = assemble is k in
    let k' = assemble js k in
    (asm, Branchif (List.length k' - List.length k)) :: k'
  | Branch _ :: _ -&gt; assert false
  | [] -&gt; k
</pre>
<p>Think of the arguments <code>asm</code> and <code>k</code> as one unique list <code>asm @ k</code> that is &ldquo;open&rdquo; for insertion in two places: at top-level, as usual, and in the middle, between <code>asm</code> and <code>k</code>. The <code>k</code> part is the already-processed suffix, and <code>asm</code> is what remains to be processed. The first case inserts the non-branching instructions <code>Push, Add, Halt</code> at top-level in the output (together with their corresponding assembly suffix of course). The second one, <code>Branchif</code>, begins by inserting the branch <code>is</code> at top-level, and then inserts the remainder <code>js</code> in front of it. Note that when assembling this remainder, we can discover sharing that was recorded in <code>k</code> when compiling the branch. Note also that there can&rsquo;t be any <code>Branch</code> in the assembly since it would not make much sense (everything after a <code>Branch</code> instruction would be dead code), hence the <code>assert false</code>.</p>
<p>Finally, we can strip off the &ldquo;cached&rdquo; information in the returned list, keeping only the target instructions:</p>
<pre class="brush: fsharp; title: ; notranslate">
let assemble is = snd (List.split (assemble is []))
</pre>
<h3>Conclusion</h3>
<p>That&rsquo;s it, we have a complete compilation chain for our expression language! We can execute the target code on this machine:</p>
<pre class="brush: fsharp; title: ; notranslate">
let rec exec = function
  | s, Push i :: c -&gt; exec (i :: s, c)
  | i :: j :: s, Add :: c -&gt; exec (i + j :: s, c)
  | s, Branch n :: c -&gt; exec (s, List.drop n c)
  | i :: s, Branchif n :: c -&gt; exec (s, List.drop (if i&lt;&gt;0 then n else 0) c)
  | [i], Halt :: _ -&gt; i
  | _ -&gt; failwith &quot;error&quot;

let exec c = exec ([], c)
</pre>
<p>The idea of using labels that are actual pointers to the code seems quite natural and seems to scale well (I implemented a compiler from a mini-ML to a virtual machine close to OCaml&rsquo;s bytecode). In terms of performance however, <code>assemble</code> is quadratic: before assembling each instruction, we look up if we didn&rsquo;t assemble it already. When we have real (string) labels, we can represent the &ldquo;cache&rdquo; as a data structure with faster lookup; unfortunately, if labels are pointers, we can&rsquo;t really do this because we don&rsquo;t have a total order on pointers, only equality <code>(==)</code>.</p>
<p>This is only one example of how we can exploit pointer equality in OCaml to mimick a name generator. I&rsquo;m sure there are lots of other applications to be discovered, or that I don&rsquo;t know of (off the top of my head: to represent variables in the lambda-calculus). The big unknown for me is the nature of the language we&rsquo;ve been working in, functional OCaml + pointer equality. Can we still consider it a functional language? How to reason on its programs? The comment section is right below!</p>

