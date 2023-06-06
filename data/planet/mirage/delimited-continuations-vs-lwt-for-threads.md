---
title: Delimited Continuations vs Lwt for Threads
description:
url: https://mirage.io/blog/delimcc-vs-lwt
date: 2011-06-18T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>MirageOS is a fully event-driven system, with no support for conventional <a href="http://en.wikipedia.org/wiki/POSIX_Threads">preemptive threads</a>.  Instead, programs are woken by events such as incoming network packets, and event callbacks execute until they themselves need to block (due to I/O or timers) or complete their task.</p>
<p>Event-driven systems are simple to implement, scalable to lots of network clients, and very hip due to frameworks like <a href="http://nodejs.org">node.js</a>. However, programming event callbacks directly leads to the control logic being scattered across many small functions, and so we need some abstractions to hide the interruptions of registering and waiting for an event to trigger.</p>
<p>OCaml has the excellent <a href="http://ocsigen.org">Lwt</a> threading library that utilises a monadic approach to solving this.
Consider this simplified signature:</p>
<pre><code class="language-ocaml">  val return : 'a -&gt; 'a Lwt.t 
  val bind : 'a Lwt.t -&gt; ('a -&gt; 'b Lwt.t) -&gt; 'b Lwt.t
  val run : 'a Lwt.t -&gt; 'a
</code></pre>
<p>Threads have the type <code>'a Lwt.t</code>, which means that the thread will have a result of type <code>'a</code> when it finishes.
The <code>return</code> function is the simplest way to construct such a thread from an OCaml value.</p>
<p>If we then wish to use the value of thread, we must compose a function that will be called in the future when the thread completes. This is what the <code>bind</code> function above is for. For example, assume we have a function that will let us sleep for some time:</p>
<pre><code class="language-ocaml">  val sleep: int -&gt; unit Lwt.t
</code></pre>
<p>We can now use the <code>bind</code> function to do something after the sleep is complete:</p>
<pre><code class="language-ocaml">  let x = sleep 5 in
  let y = bind x (fun () -&gt; print_endline &quot;awake!&quot;) in
  run y
</code></pre>
<p><code>x</code> has the type <code>unit Lwt.t</code>, and the closure passed to <code>bind</code> will eventually be called with <code>unit</code> when the sleep finishes. Note that we also need a function to actually begin evaluating an Lwt thread, which is the <code>run</code> function.</p>
<h2>Concerns</h2>
<p>MirageOS currently uses Lwt extensively, and we have been very happy with using it to build a network stack. However, I was surprised to hear a lot of debate at the <a href="http://anil.recoil.org/2011/04/15/ocaml-users-group.html">2011 OCaml Users Group</a> meeting that Lwt is not to everyone's tastes. There are a few issues:</p>
<ul>
<li>
<p>The monadic style means that existing code will not just work. Any code that might block must be adapted to use <code>return</code> and <code>bind</code>, which makes integrating third-party code problematic.</p>
</li>
<li>
<p>More concerningly, any potential blocking points require the allocation of a closure. This allocation is very cheap in OCaml, but is still not free. Jun Furuse notes that combinator-based systems are slower during the development of his <a href="http://camlspotter.blogspot.com/2011/05/planck-small-parser-combinator-library.html">Planck parser</a>.</p>
</li>
</ul>
<p>Lwt addresses the first problem via a comprehensive <a href="http://ocsigen.org/lwt/2.3.0/api/Pa_lwt">syntax extension</a> which provides Lwt equivalents for many common operations. For example, the above example with sleep can be written as:</p>
<pre><code class="language-ocaml">  lwt x = sleep 5 in
  print_endline &quot;awake&quot;
</code></pre>
<p>The <code>lwt</code> keyword indicates the result of the expression should be passed through <code>bind</code>, and this makes it possible to write code that looks more OCaml-like. There are also other keywords like <code>for_lwt</code> and <code>match_lwt</code> that similarly help with common control flow constructs.</p>
<h2>Fibers</h2>
<p>After the meeting, I did get thinking about using alternatives to Lwt in MirageOS. One exciting option is the <a href="http://okmij.org/ftp/continuations/implementations.html">delimcc</a> library which implements <a href="http://en.wikipedia.org/wiki/Delimited_continuation">delimited continuations</a> for OCaml.  These can be used to implement restartable exceptions: a program can raise an exception which can be invoked to resume the execution as if the exception had never happened.
Delimcc can be combined with Lwt very elegantly, and Jake Donham did just this with the <a href="http://ambassadortothecomputers.blogspot.com/2010/08/mixing-monadic-and-direct-style-code.html">Lwt_fiber</a> library. His post also has a detailed explanation of how <code>delimcc</code> works.</p>
<p>The interface for fibers is also simple:</p>
<pre><code class="language-ocaml">  val start: (unit -&gt; 'a) -&gt; 'a Lwt.t
  val await : 'a Lwt.t -&gt; 'a
</code></pre>
<p>A fiber can be launched with <code>start</code>, and during its execution can block on another thread with <code>await</code>.  When it does block, a restartable exception saves the program stack back until the point that <code>start</code> was called, and it will be resumed when the thread it blocked on completes.</p>
<h2>Benchmarks</h2>
<p>I put together a few microbenchmarks to try out the performance of Lwt threads versus fibers. The fiber test looks like this:</p>
<pre><code class="language-ocaml">  module Fiber = struct
    let basic fn yields =
      for i = 1 to 15000 do
        for x = 1 to yields do
          Lwt_fiber.await (fn ())
        done
      done

    let run fn yields =
      Lwt_fiber.start (fun () -&gt; basic fn yields)
  end
</code></pre>
<p>We invoke the run function with two arguments: a thread to use for blocking and the number of times we should yield serially (so we can confirm that an increasing number of yields scales linearly).  The Lwt version is pretty similar:</p>
<pre><code class="language-ocaml">  module LWT = struct
    let basic fn yields =
      for_lwt i = 1 to 15000 do
        for_lwt x = 1 to yields do
          fn ()
        done
      done
  
    let run = basic
  end
</code></pre>
<p>We do not need to do anything special to launch a thread since we are already in the Lwt main loop, and the syntax extension makes the <code>for</code> loops look like the Fiber example above.</p>
<p>The choice of blocking function is important. The first test runs using a fast <code>Lwt.return ()</code> that returns immediately:</p>
<img src="http://chart.apis.google.com/chart?cht=lxy&amp;chs=600x250&amp;chtt=Direct%20non-blocking%20overhead&amp;chco=FF0000,00FF00,0000FF,FFAA00,AA00FF,00FFFF&amp;chxt=x,x,y,y&amp;chxl=1:%7Cnumber-of-yields%7C3:%7Cseconds&amp;chds=a&amp;chg=10,10,1,5&amp;chd=t:50,100,200,300,400,600,800,1000%7C0.101,0.195,0.388,0.581,0.775,1.157,1.548,1.926%7C50,100,200,300,400,600,800,1000%7C0.095,0.188,0.371,0.553,0.737,1.104,1.469,1.836&amp;chdl=delimcc-basic-quick%7Clwt-basic-quick&amp;chdlp=t&amp;chls=2%7C2"/>
<p>The x-axis on the above graph represents the number of yields in each loop. Both <code>Lwt_fiber</code> and pure <code>Lwt</code> optimise the case where a thread returns immediately, and so this graph simply tells us that the fast path is working (which is nice!). The next test replaces the blocking function with two alternatives that force the thread to yield:</p>
<img src="http://chart.apis.google.com/chart?cht=lxy&amp;chs=600x250&amp;chtt=Direct%20blocking%20overhead&amp;chco=FF0000,00FF00,0000FF,FFAA00,AA00FF,00FFFF&amp;chxt=x,x,y,y&amp;chxl=1:%7Cnumber-of-yields%7C3:%7Cseconds&amp;chds=a&amp;chg=10,10,1,5&amp;chd=t:50,100,200,300,400,600,800,1000%7C2.601,5.204,10.401,15.611,20.783,31.221,41.606,52.016%7C50,100,200,300,400,600,800,1000%7C1.270,2.539,5.089,7.626,10.188,15.338,20.385,25.473%7C50,100,200,300,400,600,800,1000%7C4.011,8.013,15.973,23.995,32.075,47.940,63.966,79.914%7C50,100,200,300,400,600,800,1000%7C2.433,4.861,9.692,14.543,19.702,29.579,39.458,49.260&amp;chdl=lwt-basic-slow%7Clwt-basic-medium%7Cdelimcc-basic-slow%7Cdelimcc-basic-medium&amp;chdlp=t&amp;chls=2%7C2%7C2%7C2"/>
<p>There are two blocking functions used in the graph above:</p>
<ul>
<li>the &quot;slow&quot; version is <code>Lwt_unix.sleep 0.0</code> which forces the registration of a timeout.
</li>
<li>the &quot;medium&quot; version is <code>Lwt.pause ()</code> which causes the thread to pause and drop into the thread scheduler. In the case of <code>Lwt_fiber</code>, this causes an exception to be raised so we can benchmark the cost of using a delimited continuation.
</li>
</ul>
<p>Interestingly, using a fiber is slower than normal Lwt here, even though our callstack is not very deep.  I would have hoped that fibers would be significantly cheaper with a small callstack, as the amount of backtracking should be quite low.  Lets confirm that fibers do in fact slow down as the size of the callstack increases via this test:</p>
<pre><code class="language-ocaml">  module Fiber = struct
    let recurse fn depth =
      let rec sum n = 
        Lwt_fiber.await (fn ());
        match n with
        |0 -&gt; 0
        |n -&gt; n + (sum (n-1)) 
      in
      for i = 1 to 15000 do
        ignore(sum depth)
      done

    let run fn depth = 
      Lwt_fiber.start (fun () -&gt; recurse fn depth)
  end
</code></pre>
<p>The <code>recurse</code> function is deliberately not tail-recursive, so that the callstack increases as the <code>depth</code> parameter grows.  The Lwt equivalent is slightly more clunky as we have to rewrite the loop to bind and return:</p>
<pre><code class="language-ocaml">  module LWT = struct
    let recurse fn depth =
      let rec sum n =
        lwt () = fn () in
        match n with
        |0 -&gt; return 0
        |n -&gt;
          lwt n' = sum (n-1) in 
          return (n + n')
      in
      for_lwt i = 1 to 15000 do
        lwt res = sum depth in
        return ()
      done

   let run = recurse
  end
</code></pre>
<p>We then run the experiment using the slow <code>Lwt_unix.sleep 0.0</code> function, and get this graph:</p>
<img src="http://chart.apis.google.com/chart?cht=lxy&amp;chs=600x250&amp;chtt=Recurse%20vs%20basic&amp;chco=FF0000,00FF00,0000FF,FFAA00,AA00FF,00FFFF&amp;chxt=x,x,y,y&amp;chxl=1:%7Cstack-depth%7C3:%7Cseconds&amp;chds=a&amp;chg=10,10,1,5&amp;chd=t:50,100,200,300,400,600,800,1000%7C6.264,15.567,44.297,86.823,142.372,310.036,603.735,939.165%7C50,100,200,300,400,600,800,1000%7C2.601,5.204,10.401,15.611,20.783,31.221,41.606,52.016%7C50,100,200,300,400,600,800,1000%7C2.769,5.564,11.497,17.631,23.826,36.700,49.314,61.794%7C50,100,200,300,400,600,800,1000%7C4.011,8.013,15.973,23.995,32.075,47.940,63.966,79.914&amp;chdl=delimcc-recurse-slow%7Clwt-basic-slow%7Clwt-recurse-slow%7Cdelimcc-basic-slow&amp;chdlp=t&amp;chls=2%7C2%7C2%7C2"/>
<p>The above graph shows the recursive Lwt_fiber getting slower as the recursion depth increases, with normal Lwt staying linear.  The graph also overlays the non-recursing versions as a guideline (<code>*-basic-slow</code>).</p>
<h2>Thoughts</h2>
<p>This first benchmark was a little surprising for me:</p>
<ul>
<li>I would have thought that <code>delimcc</code> to be ahead of Lwt when dealing with functions with a small call-depth and a small amount of blocking (i.e. the traffic pattern that loaded network servers see). The cost of taking a restartable exception seems quite high however.
</li>
<li>The fiber tests still use the Lwt machinery to manage the callback mechanism (i.e. a <code>select</code> loop and the timer priority queue). It may be possible to create a really light-weight version just for <code>delimcc</code>, but the Lwt UNIX backend is already pretty lean and mean and uses the <a href="http://software.schmorp.de/pkg/libev.html">libev</a> to interface with the OS.
</li>
<li>The problem of having to rewrite code to be Lwt-like still exists unfortunately, but it is getting better as the <code>pa_lwt</code> syntax extension matures and is integrated into my <a href="https://github.com/raphael-proust/ocaml_lwt.vim">favourite editor</a> (thanks Raphael!)
</li>
<li>Finally, by far the biggest benefit of <code>Lwt</code> is that it can be compiled straight into Javascript using the <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml</a> compiler, opening up the possibility of cool browser visualisations and tickets to cool <code>node.js</code> parties that I don't normally get invited to.
</li>
</ul>
<p>I need to stress that these benchmarks are very micro, and do not take into account other things like memory allocation. The standalone code for the tests is <a href="http://github.com/avsm/delimcc-vs-lwt">online at Github</a>, and I would be delighted to hear any feedback.</p>
<h2>Retesting recursion [18th Jun 2011]</h2>
<p>Jake Donham comments:</p>
<blockquote>
<p>I speculated in my post that fibers might be faster if the copy/restore were amortized over a large stack. I wonder if you would repeat the experiment with versions where you call fn only in the base case of sum, instead of at every call. I think you're getting N^2 behavior here because you're copying and restoring the stack on each iteration.</p>
</blockquote>
<p>When writing the test, I figured that calling the thread waiting function more often wouldn't alter the result (careless). So I modified the test suite to have a <code>recurse</code> test that only waits a single time at the end of a long call stack (see below) as well as the original N^2 version (now called <code>recurse2</code>).</p>
<pre><code class="language-ocaml">  module Fiber = struct
    let recurse fn depth =
      let rec sum n = 
        match n with
        |0 -&gt; Lwt_fiber.await (fn ()); 0
        |n -&gt; n + (sum (n-1)) 
      in
      for i = 1 to 15000 do
        ignore(sum depth)
      done

    let run fn depth = 
      Lwt_fiber.start (fun () -&gt; recurse fn depth)
  end
</code></pre>
<p>The N^2 version below of course looks the same as the previously run tests, with delimcc getting much worse as it yields more often:</p>
<img src="http://chart.apis.google.com/chart?cht=lxy&amp;chs=600x250&amp;chtt=Recurse2%20vs%20basic&amp;chco=FF0000,00FF00,0000FF,FFAA00,AA00FF,00FFFF&amp;chxt=x,x,y,y&amp;chxl=1:%7Cstack-depth%7C3:%7Cseconds&amp;chds=a&amp;chg=10,10,1,5&amp;chd=t:50,100,200,300,400,600,800,1000%7C0.282,0.566,1.159,1.784,2.416,3.719,5.019,6.278%7C50,100,200,300,400,600,800,1000%7C0.658,1.587,4.426,8.837,14.508,31.066,60.438,94.708&amp;chdl=lwt-recurse2-slow%7Cdelimcc-recurse2-slow&amp;chdlp=t&amp;chls=2%7C2"/> 
<p>However, when we run the <code>recurse</code> test with a single yield at the end of the long callstack, the situation reverses itself and now <code>delimcc</code> is faster. Note that this test ran with more iterations than the <code>recurse2</code> test to make the results scale, and so the absolute time taken cannot be compared.</p>
<img src="http://chart.apis.google.com/chart?cht=lxy&amp;chs=600x250&amp;chtt=Recurse%20vs%20basic&amp;chco=00FF00,FF0000,0000FF,FFAA00,AA00FF,00FFFF&amp;chxt=x,x,y,y&amp;chxl=1:%7Cstack-depth%7C3:%7Cseconds&amp;chds=a&amp;chg=10,10,1,5&amp;chd=t:50,100,200,300,400,600,800,1000%7C0.162,0.216,0.341,0.499,0.622,0.875,1.194,1.435%7C50,100,200,300,400,600,800,1000%7C0.128,0.207,0.394,0.619,0.889,1.538,2.366,3.373&amp;chdl=delimcc-recurse-slow%7Clwt-recurse-slow&amp;chdlp=t&amp;chls=2%7C2"/>
<p>The reason for Lwt being slower in this becomes more clear when we examine what the code looks like after it has been passed through the <code>pa_lwt</code> syntax extension. The code before looks like:</p>
<pre><code class="language-ocaml">  let recurse fn depth =
    let rec sum n =
      match n with
      | 0 -&gt; 
          fn () &gt;&gt; return 0
      | n -&gt;
          lwt n' = sum (n-1) in 
          return (n + n') in
</code></pre>
<p>and after <code>pa_lwt</code> macro-expands it:</p>
<pre><code class="language-ocaml">  let recurse fn depth =
    let rec sum n =
      match n with
      | 0 -&gt;
          Lwt.bind (fn ()) (fun _ -&gt; return 0)
      | n -&gt;
          let __pa_lwt_0 = sum (n - 1)
          in Lwt.bind __pa_lwt_0 (fun n' -&gt; return (n + n')) in
</code></pre>
<p>Every iteration of the recursive loop requires the allocation of a closure (the <code>Lwt.bind</code> call). In the <code>delimcc</code> case, the function operates as a normal recursive function that uses the stack, until the very end when it needs to save the stack in one pass.</p>
<p>Overall, I'm convinced now that the performance difference is insignificant for the purposes of choosing one thread system over the other for MirageOS.  Instead, the question of code interoperability is more important. Lwt-enabled protocol code will work unmodified in Javascript, and Delimcc code helps migrate existing code over.</p>
<p>Interestingly, <a href="https://developer.mozilla.org/en/new_in_javascript_1.7">Javascript 1.7</a> introduces a <em>yield</em> operator, which <a href="http://parametricity.net/dropbox/yield.subc.pdf">has been shown</a> to have comparable expressive power to the <em>shift-reset</em> delimcc operators. Perhaps convergence isn't too far away after all...</p>

      
