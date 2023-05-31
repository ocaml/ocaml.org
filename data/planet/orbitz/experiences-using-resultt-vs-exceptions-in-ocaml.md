---
title: Experiences using Result.t vs Exceptions in Ocaml
description: 'Disclaimer: I have not compiled any of the example code in this post.  Mostly
  because they are snippets meant to illustrate a point rather ...'
url: http://functional-orbitz.blogspot.com/2013/01/experiences-using-resultt-vs-exceptions.html
date: 2013-01-04T20:37:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
<i>Disclaimer: I have not compiled any of the example code in this post.  Mostly because they are snippets meant to illustrate a point rather than be complete on their own.  If they have any errors then apologies.</i>
</p>

<p>
Previously I gave an <a href="http://functional-orbitz.blogspot.se/2013/01/introduction-to-resultt-vs-exceptions.html">introduction to return values vs exceptions</a> in Ocaml.  But a lot of ideas in software engineering sound good, how does this particular one work out in real software?
</p>

<p>
I have used this style in two projects.  The first is a project that was originally written using exceptions and I have converted most of it to using return values.  The second is one that was written from the start using return values.  They can be found <a href="http://code.google.com/p/para-mugsy/">here</a> and <a href="https://github.com/orbitz/opass">here</a>.  <i>I make no guarantees about the quality of the code, in fact I believe some of it to be junk.  These are just my subjective opinions in writing software with a particular attribute</i>.
</p>

<h1>The Good</h1>
<h3>Expected Result</h3>
<p>
The whole system worked as expected.  I get compile-time errors for all failure cases I do not handle.  This has helped me catch some failure cases I had forgotten about previously, some of which would require an unlikely chain of events to hit, which would have made finding in a test harder, but obviously not impossible.  In particular, ParaMugsy is (although the current rewrite does not cover this yet) meant to run in a distributed environment, which increases the cost of errors.  Both in debugging and reproducing.  In the case of opass, writing the DB is important to get right. Missing handling a failure here can mean the users database of passwords can be lost, a tragic event.
</p>

<h3>Not Cumbersome</h3>
<p>
In the Introduction I showed that for a simple program, return-values are no more cumbersome than exceptions.  In these larger projects the same holds. This shouldn't really be a surprise though, as the monadic operators actually simulate the exact flow of exception code.  But the 'not cumbersome' is half of a lie, which is explained more below.
</p>

<h3>Refactoring Easier</h3>
<p>
Ocaml is a great language when it comes to refactoring.  Simply make the change you want and iterate on compiler errors.  This style has made it even easier for me.  I can add new failures to my functions and work through the compiler errors to make sure the change is handled in every location.
</p>

<h3>Works No Matter The Concurrent Framework</h3>
<p>
The original implementation of ParaMugsy used Lwt.  In the rewrite I decided to use Core's Async library.  Both are monadic.  And both handle exceptions quite differently.  Porting functions over that did return-values was much easier because they didn't rely on the framework to handle and propagate failures.  Exceptions are tricky in a concurrent framework and concurrency is purely library based in Ocaml rather than being part of the language, which means libraries can choose incompatible ways to handle them.  Return-values give one less thing to worry about when porting code or trying to get code to work in multiple frameworks.
</p>

<h1>The Bad</h1>
<h3>Prototyping Easier With Exceptions</h3>
<p>
The whole idea is to make it hard to miss an error case.  But that can be annoying when you just want to get something running.  Often times we write software in such a way that the success path is the first thing we write and we handle the errors after that.  I don't think there is necessarily a good reason for this other than it's much more satisfying to see the results of the hard work sooner rather than later.  In this case, my solution is to relax the ban on exceptions temporarily.  Any place that I will return an <code>Error</code> I instead write <code>failwith &quot;not yet implemented&quot;</code>.  That way there is an easily grepable string to ensure I have replaced all exceptions with <code>Error</code>'s when I am done.  This is an annoyance but thankfully with a fairly simple solution.
</p>

<h3>Cannot Express All Invariants In Type System</h3>
<p>
Sometimes there are sections of code where I know something is true, but it is not expressible in the type system.  For example, perhaps I have a data structure that updates multiple pieces of information together.  I know when I access one piece of information it will be in the other place.  Or perhaps I have a pattern match that I need to handle due to exhaustiveness but I know that it cannot happen given some invariants I have established earlier.  In the case where I am looking up data that I know will exist, I will use a lookup function that can throw an exception if it is easiest.  In the case where I have a pattern match that I know will never happen, I use <code>assert</code>.  But note, these are cases where I have metaphysical certitude that such events will not happen.  Not cases where I'm just pretty sure they work.
</p>

<h3>Many Useful Libraries Throw Exceptions</h3>
<p>
Obviously a lot of libraries throw exceptions.  Luckily the primary library I use is Jane St's Core Suite, where they share roughly the same aversion of exceptions.  Some functions still do throw exceptions though, most notably <code>In_channel.with_file</code> and <code>Out_channel.with_file</code>.  This can be solved by wrapping those functions in return-value ones.  The problem comes in: what happens when the function being wrapped is poorly documented or at some point can throw more exceptional cases than when it was originally wrapped.  One option is to always catch <code>_</code> and turn it into a fairly generic variant type.  Or maybe a function only has a few logical failure conditions so collapsing them to a few variant types makes sense.  I'm not aware of any really good solution here.
</p>

<h1>A Few Examples</h1>
<p>
There are a few transformations that come up often when converting exception code to return-value code.  Here are some in detail.
</p>

<h3>Building Things</h3>
<p>
It's common to want to do some work and then construct a value from it.  In exception-land that is as simple, just something like <code>Constructor (thing_that_may_throw_exception ())</code>.  This doesn't work with return-values.  Instead we have to do what we did in the Introduction post.  Here is an example:
</p>

<pre><code><b><font color="#0000FF">let</font></b> f <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
  thing_that_may_fail <font color="#990000">()</font> <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> v <font color="#990000">-&gt;</font>
  <font color="#009900">Ok</font> <font color="#990000">(</font><font color="#009900">Constructor</font> v<font color="#990000">)</font>
</code></pre>

<h3>Looping</h3>
<p>
Some loops cannot be written in their most obvious style.  Consider an implementation of <code>map</code> that expects the function passed to it to use <code>Result.t</code> to signal failures.  The very naive implementation of <code>map</code> is:
</p>

<pre><code><b><font color="#0000FF">let</font></b> map f <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
  <font color="#990000">|</font> <font color="#990000">[]</font>    <font color="#990000">-&gt;</font> <font color="#990000">[]</font>
  <font color="#990000">|</font> x<font color="#990000">::</font>xs <font color="#990000">-&gt;</font> <font color="#990000">(</font>f x<font color="#990000">)::(</font>map xs<font color="#990000">)</font>
</code></pre>

<p>
There are two ways to write this.  The first requires two passes over the elements.  The first pass applies the function and the second one checks which value each function returned or the first error that was hit.
</p>

<pre><code><b><font color="#0000FF">let</font></b> map f l <font color="#990000">=</font>
  <b><font color="#000080">Result</font></b><font color="#990000">.</font>all <font color="#990000">(</font><b><font color="#000080">List</font></b><font color="#990000">.</font>map f l<font color="#990000">)</font>
</code></pre>

<p>
<code>Result.all</code> has the type <code>('a, 'b) Core.Std.Result.t list -&gt; ('a list, 'b) Core.Std.Result.t</code>
</p>

<p>
The above is simple but could be inefficient. The entire map is preformed regardless of failure and then walked again.  If the function being applied is expensive this could be a problem.  The other solution is a pretty standard pattern in Ocaml of using an accumulator and reversing it on output.  The monadic operator could be replaced by a <code>match</code> in this example, I just prefer the operator.
</p>

<pre><code><b><font color="#0000FF">let</font></b> map f l <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#0000FF">rec</font></b> map' f acc <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
    <font color="#990000">|</font> <font color="#990000">[]</font>    <font color="#990000">-&gt;</font> <font color="#009900">Ok</font> <font color="#990000">(</font><b><font color="#000080">List</font></b><font color="#990000">.</font>rev acc<font color="#990000">)</font>
    <font color="#990000">|</font> x<font color="#990000">::</font>xs <font color="#990000">-&gt;</font> <b><font color="#0000FF">begin</font></b>
      <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
      f x <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> v <font color="#990000">-&gt;</font>
      map' f <font color="#990000">(</font>v<font color="#990000">::</font>acc<font color="#990000">)</font> xs
    <b><font color="#0000FF">end</font></b>
  <b><font color="#0000FF">in</font></b>
  map' f <font color="#990000">[]</font> l
</code></pre>

<p>
I'm sure someone cleverer in Ocaml probably has a superior solution but this has worked well for me.
</p>

<h3>try/with</h3>
<p>
A lot of exception code looks like the following.
</p>

<pre><code><b><font color="#0000FF">let</font></b> <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">try</font></b>
    thing1 <font color="#990000">();</font>
    thing2 <font color="#990000">();</font>
    thing3 <font color="#990000">()</font>
  <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Error1</font> <font color="#990000">-&gt;</font> handle_error1 <font color="#990000">()</font>
    <font color="#990000">|</font> <font color="#009900">Error2</font> <font color="#990000">-&gt;</font> handle_error2 <font color="#990000">()</font>
    <font color="#990000">|</font> <font color="#009900">Error3</font> <font color="#990000">-&gt;</font> handle_error3 <font color="#990000">()</font>
</code></pre>

<p>
The scheme I use would break this into two functions.  The one inside the try and the one handling its result.  This might sound heavy but the syntax to define a new function in Ocaml is very light.  In my experience this hasn't been a problem.
</p>

<pre><code><b><font color="#0000FF">let</font></b> do_things <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> <b><font color="#000080">open</font></b> <b><font color="#000080">Result</font></b><font color="#990000">.</font><font color="#009900">Monad_infix</font> <b><font color="#0000FF">in</font></b>
  thing1 <font color="#990000">()</font> <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  thing2 <font color="#990000">()</font> <font color="#990000">&gt;&gt;=</font> <b><font color="#0000FF">fun</font></b> <font color="#990000">()</font> <font color="#990000">-&gt;</font>
  thing3

<b><font color="#0000FF">let</font></b> <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">match</font></b> do_things <font color="#990000">()</font> <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#009900">Ok</font> _ <font color="#990000">-&gt;</font> <font color="#990000">()</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> <font color="#009900">Error1</font> <font color="#990000">-&gt;</font> handle_error1 <font color="#990000">()</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> <font color="#009900">Error2</font> <font color="#990000">-&gt;</font> handle_error2 <font color="#990000">()</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> <font color="#009900">Error3</font> <font color="#990000">-&gt;</font> handle_error3 <font color="#990000">()</font>
</code></pre>

<h1>Conclusion</h1>
<p>
Using return-values instead of exceptions in my Ocaml projects has had nearly the exact output I anticipated.  I have compile-time guarantees for handling failure cases and the cost to my code has been minimal.  Any difficulties I've run into have had straight forward solutions.  In some cases it's simply a matter of thinking about the problems from a new perspective and the solution is clear.  I plan on continuing to develop code with these principles and creating larger projects.  I believe that this style scales well in larger projects and actually becomes less cumbersome as the project increases since the guarantees can help make it easier to reason about the project.
</p>
