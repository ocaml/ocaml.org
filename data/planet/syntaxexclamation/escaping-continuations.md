---
title: Escaping continuations
description: "Beta\_had a funny joke at POPL last year; he said: \u201Cyou exit a
  monad like you exit a building on fire: by running\u201D. I recently got myself
  in the stressful situation of being trapped in a monad&#8212\u2026"
url: https://syntaxexclamation.wordpress.com/2014/06/26/escaping-continuations/
date: 2014-06-26T21:59:46-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p><a href="https://www.mpi-sws.org/~beta/Research.html">Beta</a>&nbsp;had a funny joke at POPL last year; he said: &ldquo;you exit a monad like you exit a building on fire: by running&rdquo;. I recently got myself in the stressful situation of being trapped in a monad&mdash;the continuation monad&mdash;but without a possibility to &ldquo;run&rdquo;. There&nbsp;an exit nonetheless: just jump out! This is the (short) story of an escape.</p>
<p><span></span></p>
<h4>A&nbsp;seemingly&nbsp;inescapable monad</h4>
<p>Say we have a continuation monad, but its&nbsp;answer type <code>o</code> is fixed in advance:</p>
<pre>type o
type 'a m = ('a -&gt; o) -&gt; o

let ret : 'a. 'a -&gt; 'a m = fun v k -&gt; k v
let bind : 'a 'b. 'a m -&gt; ('a -&gt; 'b m) -&gt; 'b m = 
  fun x f k -&gt; x (fun v -&gt; f v (fun v -&gt; k v))</pre>
<p>Usually, we consider <code>o</code>, the type of final answers to CPS, to be universally quantified, so that it can be instantiated to whatever we want. Then, as usual, we can run the computation by applying the identity continuation, i.e. we can instantiate type <code>o</code> with <code>'a</code>:</p>
<pre>let run : 'a. 'a m -&gt; 'a = fun f -&gt; f (fun x -&gt; x)</pre>
<p>But here, we specified explicitly that <code>o</code> was&nbsp;<em>not</em> our choice but was fixed (it is abstract), so the previous line gives a typing error: the identity function is&nbsp;<em>not</em> a valid continuation to give to our monadic value. I have seen this situation when using delimited continuations: the answer type gets instantiated when you use a local effect somewhere in your program. For instance, <a href="http://www.brics.dk/RS/07/6/index.html" title="On One-Pass CPS Transformations">one-pass</a> <a href="ftp://ftp.daimi.au.dk/BRICS/RS/02/52/BRICS-RS-02-52.pdf" title="A New One-Pass Transformation into Monadic Normal Form">transformations</a> are of this form; their type is in the lines of&nbsp;<code>exp -&gt; (triv -&gt; ser) -&gt; ser</code> (<code>triv</code> is for trivial term, <code>ser</code> for serious term), because when they return from&nbsp;their final continuation, they must be in the context of a serious term.</p>
<h4>Taking the Midnight Express</h4>
<p>What to do then? how do you run a CPS computation when you cannot choose the answer type? Well, there is a way out, involving exceptions: instead of the identity continuation, pass a &ldquo;trick continuation&rdquo; that, when called at the end of the computation, will jump out of it (raise an exception) and return to a top-level exception handler. If the initial continuation is actually called, and in the dynamic scope of the exception handler, then we&rsquo;ll have our result. Here it is:</p>
<pre>let jump : 'a 'b. ('a -&gt; 'b m) -&gt; 'a -&gt; 'b = fun (type b) f x -&gt;
  let module M = struct exception E of b end in
  try ignore (f x (fun x -&gt; raise (M.E x))); failwith &quot;f was not pure&quot;
  with M.E i -&gt; i</pre>
<p>A local exception is defined, which contains a value of the return type <code>b</code>. This exception is eventually raised in the initial continuation, and the actual return value of function <code>f</code> is ignored, because it is not supposed to return anymore.</p>
<p>So, as you see, <code>jump</code> is turning a function defined in CPS, <code>f</code>, into an &ldquo;equivalent&rdquo; direct style function, <code>jump f</code>. Careful! It is equivalent if <code>f</code> is applying its initial continuation, i.e. if <code>f</code> has a pure, direct style counterpart. Otherwise, e.g. if <code>f</code> drops&nbsp;its continuation at one point, then the exception might not be raised, <code>f</code> might terminate and <code>jump f</code> fail with my error <code>Failure(&quot;f was not pure&quot;)</code>.</p>
<h4>Examples</h4>
<p>Let&rsquo;s define the function&nbsp;&lambda;<em>x</em>. (<em>x</em>&nbsp;+ 1) = 0 in CPS and then test it on 1:</p>
<pre>let isz x = ret (x=0)
let succ x = ret (x+1)

let () = assert (jump (fun x -&gt; bind (succ x) isz) 0 = false)</pre>
<p>I can even use <code>callcc</code> in my programs, which proves that <em>some</em> effects are actually OK:</p>
<pre>let callcc : 'a 'b. (('a -&gt; 'b m) -&gt; 'a m) -&gt; 'a m =
 fun f k -&gt; f (fun v x -&gt; k v) (fun v -&gt; k v)

let () =  assert (jump (fun x -&gt; 
  callcc (fun k -&gt; bind (k x) (fun v -&gt; ret (1 + v)))) 1 = 1)</pre>
<p>What I cannot do is instantiate <code>o</code> and bypass the initial continuation:</p>
<pre>type o = An_inhabitant
let () = ignore (jump (fun x k -&gt; An_inhabitant) 1)</pre>
<p>This last example raises the exception <code>Failure(&quot;f was not pure&quot;)</code></p>
<h4>Open questions</h4>
<p>Now my questions to you, acute and knowledgeable reader, are:</p>
<ul>
<li>First, is this <code>jump</code> operator as well-behaved as I think? Precisely what kind of effects can trigger an error? Also, can we make the exception <code>M.E</code> escape its scope?</li>
<li>Secondly, what does this mean, on the other side of the Curry-Howard looking glass? How can I interpret this result proof-theoretically? <code>jump</code> is a theorem close to, but weaker than double negation elimination it seems.</li>
</ul>

