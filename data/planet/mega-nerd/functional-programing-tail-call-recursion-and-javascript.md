---
title: Functional Programing, Tail Call Recursion and Javascript.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/fp-tail-js.html
date: 2010-11-30T10:47:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
About 6 weeks ago, I got an email from
	<a href="http://blogs.atlassian.com/developer/csharkie/">
	Craig Sharkie</a>,
who runs the Sydney Javascript group,
	<a href="http://sydjs.com/">
	SydJS</a>.
He was contacting me because I run the
	<a href="http://groups.google.com/group/fp-syd">
	Sydney functional programing group</a>
and he was asking if I knew anyone who might be able to give a presentation
about tail call recursion at SydJS.
In the spirit of FP-Syd outreach I volunteered to do it, even though I haven't
really done all that much Javascript.
</p>

<p>
On the night, I showed up, had a beer and then presented
	<a href="http://www.mega-nerd.com/erikd/Blog/files/js-tail-call.pdf">
	my slides</a>.
I started off explaining what functional programming is and why its is
interesting (hint; common language features like garbage collection, dynamic
typing, lambda expression and type inference all started in functional
languages).
</p>

<p>
I used the factorial function as an example of function that can be implemented
recursively and I demoed the
	<a href="http://www.mega-nerd.com/erikd/Blog/files/js-demo/">
	Javascript versions</a>
in a web browser.
I gave the standard recursive form whose stack usage grows linearly with
<tt><b>n</b></tt>:
</p>

<pre class="code">

  function factorial (n)
  {
      /* Termination condition. */
      if (n &lt;= 1)
          return 1 ;

    /* Recursion. */
      return n * factorial (n - 1) ;
  }

</pre>

<p>
followed by the tail recursive form:
</p>

<pre class="code">

  function factorial (n)
  {
      function fac_helper (n, fac)
      {
          if (n &lt;= 1)
              return fac ;
          return fac_helper (n - 1, n * fac) ;
      }

      return fac_helper (n, 1) ;
  }

</pre>

<p>
Unfortunately even though this is written in tail recursive form, it still doesn't
run in constant stack space.
That's because neither the ECMAScript 3 and 5 standards mandate tail call
optimisation and few of the Javascript engines implement it.
</p>

<p>
For languages whose compilers do implement the TCO, the above function will
run in constant stack space and I demonstrated this using the same function
	<a href="http://www.mega-nerd.com/erikd/Blog/files/mlfactorial.ml">
	written in Ocaml</a>:
</p>

<pre class="code">

  (* Compile using: ocamlopt nums.cmxa mlfactorial.ml -o mlfactorial *)

  open Big_int

  (*
      val mult_int_big_int : int -&gt; big_int -&gt; big_int
          Multiplication of a big integer by a small integer
  *)
  let ($*) = mult_int_big_int

  let factorial n =
      let rec fac_helper x fac =
          if x &lt;= 1 then
              fac
          else
              fac_helper (x - 1) (x $* fac)
      in
      fac_helper n unit_big_int

  let () =
      let n = int_of_string Sys.argv.(1) in
      let facn = factorial n in
      Printf.printf &quot;factorial %d = %s\n&quot; n (string_of_big_int facn)

</pre>

<p>
When this program is run through the Ocaml compiler, the compiler detects that
the factorial function is written in tail recursive form and that it can
therefore use the Tail Call Optimisation and create a executable that runs in
constant stack space.
I demostrated the constant stack space usage by running it under valgrind using
valgrind's DRD tool:
</p>

<pre class="code">

  <b>&gt;</b> valgrind --quiet --tool=drd --show-stack-usage=yes ./factorial 5
  factorial 5 = 120
  ==3320== thread 1 finished and used 11728 bytes out of 8388608 on its stack. Margin: 8376880 bytes.
  <b>&gt;</b> valgrind --quiet --tool=drd --show-stack-usage=yes ./factorial 10
  factorial 10 = 3628800
  ==3323== thread 1 finished and used 11728 bytes out of 8388608 on its stack. Margin: 8376880 bytes.
  <b>&gt;</b> valgrind --quiet --tool=drd --show-stack-usage=yes ./factorial 20
  factorial 20 = 2432902008176640000
  ==3326== thread 1 finished and used 11728 bytes out of 8388608 on its stack. Margin: 8376880 bytes.

</pre>

<p>
Regardless of the value of <tt><b>n</b></tt> the stack space used is constant
(although, for much larger values of <tt><b>n</b></tt>, the
<tt><b>Big_int</b></tt> calculations start easting a little more stack, but
thats much less of a problem).
</p>

<p>
Finally, I showed a way of doing TCO by hand using a technique I found in
Spencer Tipping's
	<a href="https://github.com/spencertipping/js-in-ten-minutes/">
	<i>&quot;Javascipt in Ten Minutes&quot;</i></a>.
The solution adds a couple of new properties to the prototype of the
<tt><b>Function</b></tt> object to provide delimited continuations (another
idea from functional programming).
See the
	<a href="http://www.mega-nerd.com/erikd/Blog/files/js-demo/demo5-factorial.js">
	the code</a>
for the details.
Suffice to say that this solution is really elegant and should be safe to run
in just about any browser whose Javascript implementation is not completely
broken.
</p>

<p>
As far as I am concerned, my presentation was received very well and the Twitter
responses (all two of them) ranged from
	<a href="https://twitter.com/sydjs/status/4821816115728384">
	<i>&quot;brain melting&quot;</i></a>
to
	<a href="https://twitter.com/pamelafox/status/4884534680092672">
	<i>&quot;awesome&quot;</i></a>.
</p>

<p>
I then hung around for the rest of the meeting, had another beer and chatted to
people.
One interesting part of the meeting was called &quot;Di-<i>script</i>-ions&quot;, where a
member of the audience would put up small 4-10 line snippets of Javascript code
and asked the audience what they did and why.
What was surprising to me that for some cases the semantics of a small piece of
Javascript code is completely non-obvious.
Javascript seems to have some very weird interactions between scoping rules,
whether functions are defined directly or as a variable and the sequence of
initialisation.
Strange indeed.
</p>

<p>
Anyway, thanks to Craig Sharkie for inviting me.
I had a great time.
</p>



