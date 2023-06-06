---
title: 'Ocsigen: step by step tutorial for client-server Web application (2/2)'
description:
url: https://ocsigen.github.io/blog/2016/03/30/tuto-graffiti2/
date: 2016-03-30T00:00:00-00:00
preview_image:
featured:
authors:
- Ocsigen team
---

<p>This is the end of the tutorial about writing a collaborative Web drawing
in OCaml. Have a look at
<a href="http://ocsigen.org/tuto/manual/application">the full tutorial</a>
if you haven&rsquo;t read the first part or if you want a version with full
colors and links.</p>

<p>In the last part, we&rsquo;ve seen how to create a client-server Web application
in OCaml. The server generates a Web page and sends it together with an
OCaml program (compiled to JavaScript) to the browser.</p>

<p>We will now see how to draw on the canvas, program mouse events with Lwt,
and do server to client communication on a bus.</p>

<h2>Collaborative drawing application</h2>

<h3>Drawing on a canvas</h3>

<p>We now want to draw something on the page using an HTML5 canvas. The
drawing primitive is defined in the client-side function called
<code class="language-plaintext highlighter-rouge">draw</code> that just draws a line between two given points in a canvas.</p>

<p>To start our collaborative drawing application, we define another
client-side function <code class="language-plaintext highlighter-rouge">init_client</code>, which just draws a single
line for now.</p>

<p>Here is the (full) new version of the program:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
  <span class="c">(* Modules opened in the shared-section are available in client-
     and server-code *)</span>
  <span class="k">open</span> <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span>
  <span class="k">open</span> <span class="nc">Lwt</span>
<span class="p">]</span>

<span class="k">module</span> <span class="nc">Graffiti_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span> <span class="p">(</span>
    <span class="k">struct</span>
      <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;graffiti&quot;</span>
    <span class="k">end</span><span class="p">)</span>
    
<span class="k">let</span><span class="o">%</span><span class="n">shared</span> <span class="n">width</span> <span class="o">=</span> <span class="mi">700</span>
<span class="k">let</span><span class="o">%</span><span class="n">shared</span> <span class="n">height</span> <span class="o">=</span> <span class="mi">400</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">draw</span> <span class="n">ctx</span> <span class="p">((</span><span class="n">r</span><span class="o">,</span> <span class="n">g</span><span class="o">,</span> <span class="n">b</span><span class="p">)</span><span class="o">,</span> <span class="n">size</span><span class="o">,</span> <span class="p">(</span><span class="n">x1</span><span class="o">,</span> <span class="n">y1</span><span class="p">)</span><span class="o">,</span> <span class="p">(</span><span class="n">x2</span><span class="o">,</span> <span class="n">y2</span><span class="p">))</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">color</span> <span class="o">=</span> <span class="nn">CSS</span><span class="p">.</span><span class="nn">Color</span><span class="p">.</span><span class="n">string_of_t</span> <span class="p">(</span><span class="nn">CSS</span><span class="p">.</span><span class="nn">Color</span><span class="p">.</span><span class="n">rgb</span> <span class="n">r</span> <span class="n">g</span> <span class="n">b</span><span class="p">)</span> <span class="k">in</span>
  <span class="n">ctx</span><span class="o">##.</span><span class="n">strokeStyle</span> <span class="o">:=</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="n">color</span><span class="p">);</span>
  <span class="n">ctx</span><span class="o">##.</span><span class="n">lineWidth</span> <span class="o">:=</span> <span class="kt">float</span> <span class="n">size</span><span class="p">;</span>
  <span class="n">ctx</span><span class="o">##</span><span class="n">beginPath</span><span class="p">;</span>
  <span class="n">ctx</span><span class="o">##</span><span class="p">(</span><span class="n">moveTo</span> <span class="p">(</span><span class="kt">float</span> <span class="n">x1</span><span class="p">)</span> <span class="p">(</span><span class="kt">float</span> <span class="n">y1</span><span class="p">));</span>
  <span class="n">ctx</span><span class="o">##</span><span class="p">(</span><span class="n">lineTo</span> <span class="p">(</span><span class="kt">float</span> <span class="n">x2</span><span class="p">)</span> <span class="p">(</span><span class="kt">float</span> <span class="n">y2</span><span class="p">));</span>
  <span class="n">ctx</span><span class="o">##</span><span class="n">stroke</span>

<span class="k">let</span> <span class="n">canvas_elt</span> <span class="o">=</span>
  <span class="n">canvas</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_width</span> <span class="n">width</span><span class="p">;</span> <span class="n">a_height</span> <span class="n">height</span><span class="p">]</span>
    <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;your browser doesn't support canvas&quot;</span><span class="p">]</span>

<span class="k">let</span> <span class="n">page</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="p">(</span><span class="n">html</span>
     <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">))</span> <span class="bp">[]</span><span class="p">)</span>
     <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">];</span>
            <span class="n">canvas_elt</span><span class="p">]))</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">init_client</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">canvas</span> <span class="o">=</span> <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_canvas</span> <span class="o">~%</span><span class="n">canvas_elt</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">ctx</span> <span class="o">=</span> <span class="n">canvas</span><span class="o">##</span><span class="p">(</span><span class="n">getContext</span> <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">_2d_</span><span class="p">))</span> <span class="k">in</span>
  <span class="n">ctx</span><span class="o">##.</span><span class="n">lineCap</span> <span class="o">:=</span> <span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;round&quot;</span><span class="p">;</span>
  <span class="n">draw</span> <span class="n">ctx</span> <span class="p">((</span><span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="p">)</span><span class="o">,</span> <span class="mi">12</span><span class="o">,</span> <span class="p">(</span><span class="mi">10</span><span class="o">,</span> <span class="mi">10</span><span class="p">)</span><span class="o">,</span> <span class="p">(</span><span class="mi">200</span><span class="o">,</span> <span class="mi">100</span><span class="p">))</span>

<span class="k">let</span> <span class="n">main_service</span> <span class="o">=</span>
  <span class="nn">Graffiti_app</span><span class="p">.</span><span class="n">register_service</span> <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;&quot;</span><span class="p">]</span> <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="c">(* Cf. section &quot;Client side side-effects on the server&quot; *)</span>
       <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span> <span class="p">(</span><span class="n">init_client</span> <span class="bp">()</span> <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span> <span class="p">]</span> <span class="k">in</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="p">(</span><span class="n">page</span> <span class="bp">()</span><span class="p">))</span></code></pre></figure>

<h3>JavaScript datatypes in OCaml</h3>

<p>Here we use the function <code class="language-plaintext highlighter-rouge">Js.string</code>
  from Js_of_ocaml&rsquo;s library to convert an OCaml string
  into a JS string.</p>

<h3>Client side side-effect on the server</h3>

<p>What sounds a bit weird at first, is a very convenient practice for
  processing request in a client-server application: If a client value
  is created while processing a request, it will be evaluated on the
  client once it receives the response and the document is created;
  the corresponding side effects are then executed.
  For example, the line</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml">    <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span> <span class="p">(</span><span class="n">init_client</span> <span class="bp">()</span> <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span> <span class="p">]</span> <span class="k">in</span>
    <span class="o">...</span></code></pre></figure>

<p>creates a client value for the sole purpose of performing side
  effects on the client.  The client value can also be named (as
  opposed to ignored via <code class="language-plaintext highlighter-rouge">_</code>), thus enabling server-side
  manipulation of client-side values (see below).</p>

<h3>Single user drawing application</h3>

<p><strong>(Lwt, Mouse events with Lwt)</strong></p>

<p>We now want to catch mouse events to draw lines with the mouse like
with the <em>brush</em> tools of any classical drawing application. One
solution would be to mimic typical JavaScript code in OCaml; for
example by using function <code class="language-plaintext highlighter-rouge">Dom_events.listen</code>
that is the Js_of_ocaml&rsquo;s equivalent of
<code class="language-plaintext highlighter-rouge">addEventListener</code>. However, this solution is at least as verbose
as the JavaScript equivalent, hence not satisfactory. Js_of_ocaml&rsquo;s
library provides a much easier way to do that with the help of Lwt.</p>

<p>Replace the <code class="language-plaintext highlighter-rouge">init_client</code> of the previous example by the
following piece of code, then compile and draw!</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">init_client</span> <span class="bp">()</span> <span class="o">=</span>

  <span class="k">let</span> <span class="n">canvas</span> <span class="o">=</span> <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_canvas</span> <span class="o">~%</span><span class="n">canvas_elt</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">ctx</span> <span class="o">=</span> <span class="n">canvas</span><span class="o">##</span><span class="p">(</span><span class="n">getContext</span> <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">_2d_</span><span class="p">))</span> <span class="k">in</span>
  <span class="n">ctx</span><span class="o">##.</span><span class="n">lineCap</span> <span class="o">:=</span> <span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;round&quot;</span><span class="p">;</span>

  <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="ow">and</span> <span class="n">y</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span>

  <span class="k">let</span> <span class="n">set_coord</span> <span class="n">ev</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">x0</span><span class="o">,</span> <span class="n">y0</span> <span class="o">=</span> <span class="nn">Dom_html</span><span class="p">.</span><span class="n">elementClientPosition</span> <span class="n">canvas</span> <span class="k">in</span>
    <span class="n">x</span> <span class="o">:=</span> <span class="n">ev</span><span class="o">##.</span><span class="n">clientX</span> <span class="o">-</span> <span class="n">x0</span><span class="p">;</span> <span class="n">y</span> <span class="o">:=</span> <span class="n">ev</span><span class="o">##.</span><span class="n">clientY</span> <span class="o">-</span> <span class="n">y0</span>
  <span class="k">in</span>

  <span class="k">let</span> <span class="n">compute_line</span> <span class="n">ev</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">oldx</span> <span class="o">=</span> <span class="o">!</span><span class="n">x</span> <span class="ow">and</span> <span class="n">oldy</span> <span class="o">=</span> <span class="o">!</span><span class="n">y</span> <span class="k">in</span>
    <span class="n">set_coord</span> <span class="n">ev</span><span class="p">;</span>
    <span class="p">((</span><span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="p">)</span><span class="o">,</span> <span class="mi">5</span><span class="o">,</span> <span class="p">(</span><span class="n">oldx</span><span class="o">,</span> <span class="n">oldy</span><span class="p">)</span><span class="o">,</span> <span class="p">(</span><span class="o">!</span><span class="n">x</span><span class="o">,</span> <span class="o">!</span><span class="n">y</span><span class="p">))</span>
  <span class="k">in</span>

  <span class="k">let</span> <span class="n">line</span> <span class="n">ev</span> <span class="o">=</span> <span class="n">draw</span> <span class="n">ctx</span> <span class="p">(</span><span class="n">compute_line</span> <span class="n">ev</span><span class="p">);</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span> <span class="k">in</span>

  <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
    <span class="k">let</span> <span class="k">open</span> <span class="nc">Lwt_js_events</span> <span class="k">in</span>
    <span class="n">mousedowns</span> <span class="n">canvas</span>
      <span class="p">(</span><span class="k">fun</span> <span class="n">ev</span> <span class="n">_</span> <span class="o">-&gt;</span>
         <span class="n">set_coord</span> <span class="n">ev</span><span class="p">;</span> <span class="n">line</span> <span class="n">ev</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
           <span class="nn">Lwt</span><span class="p">.</span><span class="n">pick</span>
             <span class="p">[</span><span class="n">mousemoves</span> <span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">line</span> <span class="n">x</span><span class="p">);</span>
	      <span class="n">mouseup</span> <span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span> <span class="o">&gt;&gt;=</span> <span class="n">line</span><span class="p">]))</span></code></pre></figure>

<p>We use two references <code class="language-plaintext highlighter-rouge">x</code> and <code class="language-plaintext highlighter-rouge">y</code> to record the last mouse
position.  The function <code class="language-plaintext highlighter-rouge">set_coord</code> updates those references from
mouse event data.  The function <code class="language-plaintext highlighter-rouge">compute_line</code> computes the
coordinates of a line from the initial (old) coordinates to the new
coordinates&ndash;the event data sent as a parameter.</p>

<p>The last four lines of code implement the event-handling loop.  They
can be read as follows: for each <code class="language-plaintext highlighter-rouge">mousedown</code> event on the canvas,
do <code class="language-plaintext highlighter-rouge">set_coord</code>, then <code class="language-plaintext highlighter-rouge">line</code> (this will draw a dot), then
behave as the <code class="language-plaintext highlighter-rouge">first</code> of the two following lines that terminates:</p>

<ul>
  <li>For each mousemove event on the document, call <code class="language-plaintext highlighter-rouge">line</code> (never
terminates)</li>
  <li>If there is a mouseup event on the document, call <code class="language-plaintext highlighter-rouge">line</code>.</li>
</ul>

<h3>More on Lwt</h3>

<p>Functions in Eliom and Js_of_ocaml which do not implement just a
computation or direct side effect, but rather wait for user activity,
or file system access, or need a unforeseeable amount of time to return
are defined <em>with Lwt</em>; instead of returning a value of type <code class="language-plaintext highlighter-rouge">a</code>
they return an Lwt thread of type <code class="language-plaintext highlighter-rouge">a Lwt.t</code>.</p>

<p>The only way to use the result of such functions (ones that return
values in the <em>Lwt monad</em>), is to use <code class="language-plaintext highlighter-rouge">Lwt.bind</code>.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="nn">Lwt</span><span class="p">.</span><span class="n">bind</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span></code></pre></figure>

<p>It is convenient to define an infix operator like this:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="p">(</span><span class="o">&gt;&gt;=</span><span class="p">)</span> <span class="o">=</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">bind</span></code></pre></figure>

<p>Then the code</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="n">f</span> <span class="bp">()</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span></code></pre></figure>

<p>is conceptually similar to</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">in</span></code></pre></figure>

<p>but only for functions returning a value in the Lwt monad.</p>

<p>For more clarity, there is a syntax extension for Lwt, defining
<code class="language-plaintext highlighter-rouge">let%lwt</code> to be used instead of <code class="language-plaintext highlighter-rouge">let</code> for Lwt functions:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">lwt</span> <span class="n">x</span> <span class="o">=</span> <span class="n">f</span> <span class="bp">()</span> <span class="k">in</span></code></pre></figure>

<p><code class="language-plaintext highlighter-rouge">Lwt.return</code> creates a terminated thread from a value: <code class="language-plaintext highlighter-rouge">Lwt.return : 'a -&gt; 'a Lwt.t</code> Use it when you must
return something in the Lwt monad (for example in a service handler,
or often after a <code class="language-plaintext highlighter-rouge">Lwt.bind</code>).</p>

<h4>Why Lwt?</h4>

<p>An Eliom application is a cooperative program, as the server must be
able to handle several requests at the same time.  Ocsigen is using
cooperative threading instead of the more widely used preemptive
threading paradigm. It means that no scheduler will interrupt your
functions whenever it wants. Switching from one thread to another is
done only when there is a <em>cooperation point</em>.</p>

<p>We will use the term <em>cooperative functions</em> to identify functions
implemented in cooperative way, that is: if something takes
(potentially a long) time to complete (for example reading a value
from a database), they insert a cooperation point to let other threads
run.  Cooperative functions return a value in the Lwt monad
(that is, a value of type <code class="language-plaintext highlighter-rouge">'a Lwt.t</code> for some type <code class="language-plaintext highlighter-rouge">'a</code>).</p>

<p><code class="language-plaintext highlighter-rouge">Lwt.bind</code> and <code class="language-plaintext highlighter-rouge">Lwt.return</code> do not introduce cooperation points.</p>

<p>In our example, the function <code class="language-plaintext highlighter-rouge">Lwt_js_events.mouseup</code> may introduce
a cooperation point, because it is unforeseeable when this event
happens. That&rsquo;s why it returns a value in the Lwt monad.</p>

<p>Using cooperative threads has a huge advantage: given that you know
precisely where the cooperation points are, <em>you need very few
mutexes</em> and you have <em>very low risk of deadlocks</em>!</p>

<p>Using Lwt is very easy and does not cause trouble, provided you never
use <em>blocking functions</em> (non-cooperative functions).  <em>Blocking
functions can cause the entre server to hang!</em> Remember:</p>

<ul>
  <li>Use the functions from module <code class="language-plaintext highlighter-rouge">Lwt_unix</code> instead of module
 <code class="language-plaintext highlighter-rouge">Unix</code>,</li>
  <li>Use cooperative database libraries (like PG&rsquo;Ocaml for Lwt),</li>
  <li>If you want to use a non-cooperative function, detach it in another
preemptive thread using <code class="language-plaintext highlighter-rouge">Lwt_preemptive.detach</code>,</li>
  <li>If you want to launch a long-running computation, manually insert
cooperation points using <code class="language-plaintext highlighter-rouge">Lwt_unix.yield</code>,</li>
  <li><code class="language-plaintext highlighter-rouge">Lwt.bind</code> does not introduce any cooperation point.</li>
</ul>

<h3>Handling events with Lwt</h3>

<p>The module <code class="language-plaintext highlighter-rouge">Lwt_js_events</code>
  allows easily defining event listeners using Lwt.  For example,
  <code class="language-plaintext highlighter-rouge">Lwt_js_events.click</code> takes a
  DOM element and returns an Lwt thread that will wait until a click
  occures on this element.</p>

<p>Functions with an ending &ldquo;s&rdquo; (<code class="language-plaintext highlighter-rouge">Lwt_js_events.clicks</code>,
  <code class="language-plaintext highlighter-rouge">Lwt_js_events.mousedowns</code>, &hellip;) start again waiting after the
  handler terminates.</p>

<p><code class="language-plaintext highlighter-rouge">Lwt.pick</code> behaves as the first thread
  in the list to terminate, and cancels the others.</p>

<h2>Collaborative drawing application</h2>

<p><strong>(Client server communication)</strong></p>

<p>In order to see what other users are drawing, we now want to do the
following:</p>

<ul>
  <li>Send the coordinates to the server when the user draw a line, then</li>
  <li>Dispatch the coordinates to all connected users.</li>
</ul>

<p>We first declare a type, shared by the server and the client,
describing the color (as RGB values) and coordinates of drawn lines.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
  <span class="k">type</span> <span class="n">messages</span> <span class="o">=</span>
    <span class="p">((</span><span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span><span class="p">)</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">*</span> <span class="p">(</span><span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span><span class="p">)</span> <span class="o">*</span> <span class="p">(</span><span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span><span class="p">))</span>
    <span class="p">[</span><span class="o">@@</span><span class="n">deriving</span> <span class="n">json</span><span class="p">]</span>
<span class="p">]</span></code></pre></figure>

<p>We annotate the type declaration with <code class="language-plaintext highlighter-rouge">[@@deriving json]</code> to allow
type-safe deserialization of this type. Eliom forces you to use this
in order to avoid server crashes if a client sends corrupted data.
This is defined using a JSON plugin for
<a href="https://github.com/whitequark/ppx_deriving">ppx_deriving</a>, which you
need to install. You need to do that for each type of data sent by the
client to the server.  This annotation can only be added on types
containing exclusively basic types, or other types annotated with
<code class="language-plaintext highlighter-rouge">[@@deriving json]</code>.</p>

<p>Then we create an Eliom bus to broadcast drawing events to all client
with the function <code class="language-plaintext highlighter-rouge">Eliom_bus.create</code>.
This function take as parameter the type of
values carried by the bus.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">bus</span> <span class="o">=</span> <span class="nn">Eliom_bus</span><span class="p">.</span><span class="n">create</span> <span class="p">[</span><span class="o">%</span><span class="n">derive</span><span class="o">.</span><span class="n">json</span><span class="o">:</span> <span class="n">messages</span><span class="p">]</span></code></pre></figure>

<p>To write draw commands into the bus, we just replace the function
<code class="language-plaintext highlighter-rouge">line</code> in <code class="language-plaintext highlighter-rouge">init_client</code> by:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">line</span> <span class="n">ev</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">v</span> <span class="o">=</span> <span class="n">compute_line</span> <span class="n">ev</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Eliom_bus</span><span class="p">.</span><span class="n">write</span> <span class="o">~%</span><span class="n">bus</span> <span class="n">v</span> <span class="k">in</span>
  <span class="n">draw</span> <span class="n">ctx</span> <span class="n">v</span><span class="p">;</span>
  <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span> <span class="k">in</span></code></pre></figure>

<p>Finally, to interpret the draw orders read on the bus, we add the
following line at the end of function <code class="language-plaintext highlighter-rouge">init_client</code>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml">  <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="nn">Lwt_stream</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="n">draw</span> <span class="n">ctx</span><span class="p">)</span> <span class="p">(</span><span class="nn">Eliom_bus</span><span class="p">.</span><span class="n">stream</span> <span class="o">~%</span><span class="n">bus</span><span class="p">))</span></code></pre></figure>

<p>Now you can try the program using two browser windows to see that the
lines are drawn on both windows.</p>

<h3>Communication channels</h3>

<p>Eliom provides multiple ways for the server to send unsolicited data
  to the client:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">Eliom_bus.t</code> are broadcasting channels where
client and server can participate (see also &laquo;a_api project=&rdquo;eliom&rdquo;
subproject=&rdquo;client&rdquo; | type Eliom_bus.t&nbsp;&raquo; in the client
API).</li>
  <li><code class="language-plaintext highlighter-rouge">Eliom_react</code> allows sending
<a href="http://erratique.ch/software/react/doc/React">React events</a> from
the server to the client, and conversely.</li>
  <li>
    <p><code class="language-plaintext highlighter-rouge">Eliom_comet.Channel.t</code> are one-way communication channels
allowing finer-grained control. It allows sending <code class="language-plaintext highlighter-rouge">Lwt_stream</code>
to the client.
<code class="language-plaintext highlighter-rouge">Eliom_react</code> and <code class="language-plaintext highlighter-rouge">Eliom_bus</code> are implemented over
<code class="language-plaintext highlighter-rouge">Eliom_coment</code>.</p>

    <p>It is possible to control the idle behaviour with module
<code class="language-plaintext highlighter-rouge">Eliom_comet.Configuration</code>.</p>
  </li>
</ul>

<h2>Color and size of the brush</h2>

<p><strong>(Widgets with Ocsigen-widgets)</strong></p>

<p>In this section, we add a color picker and slider to choose the size
of the brush. For the colorpicker we used a widget available in
<code class="language-plaintext highlighter-rouge">Ocsigen-widgets</code>.</p>

<p>To install Ocsigen widgets, do:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam pin add ocsigen-widgets https://github.com/ocsigen/ocsigen-widgets.git
opam install ocsigen-widgets
</code></pre></div></div>

<p>In <code class="language-plaintext highlighter-rouge">Makefile.options</code>, created by Eliom&rsquo;s distillery, add
<code class="language-plaintext highlighter-rouge">ocsigen-widgets.client</code> to the
<code class="language-plaintext highlighter-rouge">CLIENT_PACKAGES</code>:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>CLIENT_PACKAGES := ... ocsigen-widgets.client
</code></pre></div></div>

<p>To create the widget, we add the following code in the
<code class="language-plaintext highlighter-rouge">init_client</code> immediately after canvas configuration:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* Color of the brush *)</span>
<span class="k">let</span> <span class="n">colorpicker</span> <span class="o">=</span> <span class="nn">Ow_color_picker</span><span class="p">.</span><span class="n">create</span> <span class="o">~</span><span class="n">width</span><span class="o">:</span><span class="mi">150</span> <span class="bp">()</span> <span class="k">in</span>
<span class="nn">Ow_color_picker</span><span class="p">.</span><span class="n">append_at</span> <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span><span class="o">##.</span><span class="n">body</span><span class="p">)</span> <span class="n">colorpicker</span><span class="p">;</span>
<span class="nn">Ow_color_picker</span><span class="p">.</span><span class="n">init_handler</span> <span class="n">colorpicker</span><span class="p">;</span></code></pre></figure>

<p>We subsequently add a simple HTML5 slider to change the size of the
brush. Near the <code class="language-plaintext highlighter-rouge">canvas_elt</code> definition, simply add the following
code:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">slider</span> <span class="o">=</span>
  <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="nn">Form</span><span class="p">.</span><span class="n">input</span>
    <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span>
      <span class="nn">Html5</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">a_id</span> <span class="s2">&quot;slider&quot;</span><span class="p">;</span>
      <span class="nn">Html5</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">a_input_min</span> <span class="mi">1</span><span class="o">.;</span>
      <span class="nn">Html5</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">a_input_max</span> <span class="mi">80</span><span class="o">.</span>
    <span class="p">]</span>
    <span class="o">~</span><span class="n">input_type</span><span class="o">:</span><span class="nt">`Range</span>
    <span class="nn">Html5</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="nn">Form</span><span class="p">.</span><span class="n">int</span></code></pre></figure>

<p><code class="language-plaintext highlighter-rouge">Form.int</code> is a typing information telling that this input takes
an integer value. This kind of input can only be associated to
services taking an integer as parameter.</p>

<p>We then add the slider to the page body, as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">page</span> <span class="o">=</span>
  <span class="p">(</span><span class="n">html</span>
    <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">))</span> <span class="bp">[]</span><span class="p">)</span>
    <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">];</span>
           <span class="n">canvas_elt</span><span class="p">;</span>
           <span class="n">div</span> <span class="p">[</span><span class="n">slider</span><span class="p">]]</span> <span class="p">))</span></code></pre></figure>

<p>To change the size and the color of the brush, we replace the last
line of the function <code class="language-plaintext highlighter-rouge">compute_line</code> in <code class="language-plaintext highlighter-rouge">init_client</code> by:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">rgb</span> <span class="o">=</span> <span class="nn">Ow_color_picker</span><span class="p">.</span><span class="n">get_rgb</span> <span class="n">colorpicker</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">size_slider</span> <span class="o">=</span> <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_input</span> <span class="o">~%</span><span class="n">slider</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">size</span> <span class="o">=</span> <span class="n">int_of_string</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">to_string</span> <span class="n">size_slider</span><span class="o">##.</span><span class="n">value</span><span class="p">)</span> <span class="k">in</span>
<span class="p">(</span><span class="n">rgb</span><span class="o">,</span> <span class="n">size</span><span class="o">,</span> <span class="p">(</span><span class="n">oldx</span><span class="o">,</span> <span class="n">oldy</span><span class="p">)</span><span class="o">,</span> <span class="p">(</span><span class="o">!</span><span class="n">x</span><span class="o">,</span> <span class="o">!</span><span class="n">y</span><span class="p">))</span></code></pre></figure>

<p>Finally, we need to add a stylesheet in the headers of our page. To
easily create the <code class="language-plaintext highlighter-rouge">head</code> HTML element, we use the function
<code class="language-plaintext highlighter-rouge">Eliom_tools.F.head</code>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">page</span> <span class="o">=</span>
  <span class="n">html</span>
    <span class="p">(</span><span class="nn">Eliom_tools</span><span class="p">.</span><span class="nn">F</span><span class="p">.</span><span class="n">head</span> <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="s2">&quot;Graffiti&quot;</span>
       <span class="o">~</span><span class="n">css</span><span class="o">:</span><span class="p">[</span>
         <span class="p">[</span><span class="s2">&quot;css&quot;</span><span class="p">;</span><span class="s2">&quot;graffiti.css&quot;</span><span class="p">];]</span>
      <span class="o">~</span><span class="n">js</span><span class="o">:</span><span class="bp">[]</span> <span class="bp">()</span><span class="p">)</span>
    <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">];</span> <span class="n">canvas_elt</span><span class="p">;</span> <span class="n">div</span> <span class="p">[</span><span class="n">slider</span><span class="p">]])</span></code></pre></figure>

<p>You need to install the corresponding stylesheets and images into your
project. The stylesheet files should go to the directory
<code class="language-plaintext highlighter-rouge">static/css</code>.
File <a href="http://ocsigen.org/tuto/files/tutorial/static/css/graffiti.css">graffiti.css</a> is a custom-made CSS file.</p>

<p>You can then test your application (<code class="language-plaintext highlighter-rouge">make test.byte</code>).</p>

<h3>Ocsigen-widgets</h3>

<p>Ocsigen-widgets is a Js_of_ocaml library providing useful widgets
  for your Eliom applications. You can use it for building complex
  user interfaces.</p>

<h2>Sending the initial image</h2>

<p><strong>(Services sending other data types)</strong></p>

<p>To finish the first part of the tutorial, we want to save the current
drawing on server side and send the current image when a new user
arrives. To do that, we will use the
<a href="http://www.cairographics.org/cairo-ocaml/">Cairo binding</a> for OCaml.</p>

<p>For using Cairo, first, make sure that it is installed (it is
available as <code class="language-plaintext highlighter-rouge">cairo2</code> via OPAM). Second, add it to the
<code class="language-plaintext highlighter-rouge">SERVER_PACKAGES</code> in your <code class="language-plaintext highlighter-rouge">Makefile.options</code>: <code class="language-plaintext highlighter-rouge">SERVER_PACKAGES := ... cairo2</code></p>

<p>The <code class="language-plaintext highlighter-rouge">draw_server</code> function below is the equivalent of the
<code class="language-plaintext highlighter-rouge">draw</code> function on the server side and the <code class="language-plaintext highlighter-rouge">image_string</code>
function outputs the PNG image in a string.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">draw_server</span><span class="o">,</span> <span class="n">image_string</span> <span class="o">=</span>

  <span class="k">let</span> <span class="n">surface</span> <span class="o">=</span> <span class="nn">Cairo</span><span class="p">.</span><span class="nn">Image</span><span class="p">.</span><span class="n">create</span> <span class="nn">Cairo</span><span class="p">.</span><span class="nn">Image</span><span class="p">.</span><span class="nc">ARGB32</span> <span class="o">~</span><span class="n">width</span> <span class="o">~</span><span class="n">height</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">ctx</span> <span class="o">=</span> <span class="nn">Cairo</span><span class="p">.</span><span class="n">create</span> <span class="n">surface</span> <span class="k">in</span>

  <span class="k">let</span> <span class="n">rgb_floats_from_ints</span> <span class="p">(</span><span class="n">r</span><span class="o">,</span> <span class="n">g</span><span class="o">,</span> <span class="n">b</span><span class="p">)</span> <span class="o">=</span>
    <span class="kt">float</span> <span class="n">r</span> <span class="o">/.</span> <span class="mi">255</span><span class="o">.,</span> <span class="kt">float</span> <span class="n">g</span> <span class="o">/.</span> <span class="mi">255</span><span class="o">.,</span> <span class="kt">float</span> <span class="n">b</span> <span class="o">/.</span> <span class="mi">255</span><span class="o">.</span> <span class="k">in</span>

  <span class="p">((</span><span class="k">fun</span> <span class="p">(</span><span class="n">rgb</span><span class="o">,</span> <span class="n">size</span><span class="o">,</span> <span class="p">(</span><span class="n">x1</span><span class="o">,</span> <span class="n">y1</span><span class="p">)</span><span class="o">,</span> <span class="p">(</span><span class="n">x2</span><span class="o">,</span> <span class="n">y2</span><span class="p">))</span> <span class="o">-&gt;</span>

    <span class="c">(* Set thickness of brush *)</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">set_line_width</span> <span class="n">ctx</span> <span class="p">(</span><span class="kt">float</span> <span class="n">size</span><span class="p">)</span> <span class="p">;</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">set_line_join</span> <span class="n">ctx</span> <span class="nn">Cairo</span><span class="p">.</span><span class="nc">JOIN_ROUND</span> <span class="p">;</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">set_line_cap</span> <span class="n">ctx</span> <span class="nn">Cairo</span><span class="p">.</span><span class="nc">ROUND</span> <span class="p">;</span>
    <span class="k">let</span> <span class="n">r</span><span class="o">,</span> <span class="n">g</span><span class="o">,</span> <span class="n">b</span> <span class="o">=</span>  <span class="n">rgb_floats_from_ints</span> <span class="n">rgb</span> <span class="k">in</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">set_source_rgb</span> <span class="n">ctx</span> <span class="o">~</span><span class="n">r</span> <span class="o">~</span><span class="n">g</span> <span class="o">~</span><span class="n">b</span> <span class="p">;</span>

    <span class="nn">Cairo</span><span class="p">.</span><span class="n">move_to</span> <span class="n">ctx</span> <span class="p">(</span><span class="kt">float</span> <span class="n">x1</span><span class="p">)</span> <span class="p">(</span><span class="kt">float</span> <span class="n">y1</span><span class="p">)</span> <span class="p">;</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">line_to</span> <span class="n">ctx</span> <span class="p">(</span><span class="kt">float</span> <span class="n">x2</span><span class="p">)</span> <span class="p">(</span><span class="kt">float</span> <span class="n">y2</span><span class="p">)</span> <span class="p">;</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="nn">Path</span><span class="p">.</span><span class="n">close</span> <span class="n">ctx</span> <span class="p">;</span>

    <span class="c">(* Apply the ink *)</span>
    <span class="nn">Cairo</span><span class="p">.</span><span class="n">stroke</span> <span class="n">ctx</span> <span class="p">;</span>
   <span class="p">)</span><span class="o">,</span>
   <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
     <span class="k">let</span> <span class="n">b</span> <span class="o">=</span> <span class="nn">Buffer</span><span class="p">.</span><span class="n">create</span> <span class="mi">10000</span> <span class="k">in</span>
     <span class="c">(* Output a PNG in a string *)</span>
     <span class="nn">Cairo</span><span class="p">.</span><span class="nn">PNG</span><span class="p">.</span><span class="n">write_to_stream</span> <span class="n">surface</span> <span class="p">(</span><span class="nn">Buffer</span><span class="p">.</span><span class="n">add_string</span> <span class="n">b</span><span class="p">);</span>
     <span class="nn">Buffer</span><span class="p">.</span><span class="n">contents</span> <span class="n">b</span>
   <span class="p">))</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Lwt_stream</span><span class="p">.</span><span class="n">iter</span> <span class="n">draw_server</span> <span class="p">(</span><span class="nn">Eliom_bus</span><span class="p">.</span><span class="n">stream</span> <span class="n">bus</span><span class="p">)</span></code></pre></figure>

<p>We also define a service that sends the picture:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">imageservice</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nn">String</span><span class="p">.</span><span class="n">register_service</span>
    <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;image&quot;</span><span class="p">]</span>
    <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="p">(</span><span class="n">image_string</span> <span class="bp">()</span><span class="o">,</span> <span class="s2">&quot;image/png&quot;</span><span class="p">))</span></code></pre></figure>

<h3>Eliom_registration</h3>

<p>The module <code class="language-plaintext highlighter-rouge">Eliom_registration</code> defines several modules with
  registration functions for a variety of data types. We have already
  seen <code class="language-plaintext highlighter-rouge">Eliom_registration.Html5</code> and <code class="language-plaintext highlighter-rouge">Eliom_registration.App</code>.
  The module <code class="language-plaintext highlighter-rouge">Eliom_registration.String</code> sends arbitrary byte output
  (represented by an OCaml string). The handler function must return
  a pair consisting of the content and the content-type.</p>

<p>There are also several other output modules, for example:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">Eliom_registration.File</code> to send static files</li>
  <li><code class="language-plaintext highlighter-rouge">Eliom_registration.Redirection</code> to create a redirection towards another page</li>
  <li><code class="language-plaintext highlighter-rouge">Eliom_registration.Any</code> to create services that decide late what
they want to send</li>
  <li><code class="language-plaintext highlighter-rouge">Eliom_registration.Ocaml</code> to send any OCaml data to be used in a
client side program</li>
  <li><code class="language-plaintext highlighter-rouge">Eliom_registration.Action</code> to create service with no output
(the handler function just performs a side effect on the server)
and reload the current page (or not). We will see an example of actions
in the next chapter.</li>
</ul>

<h3>Loading the initial image</h3>

<p>We now want to load the initial image once the canvas is created.  Add
the following lines just between the creation of the canvas context and the
creation of the slider:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="c">(* The initial image: *)</span>
<span class="k">let</span> <span class="n">img</span> <span class="o">=</span>
  <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_img</span>
    <span class="p">(</span><span class="n">img</span> <span class="o">~</span><span class="n">alt</span><span class="o">:</span><span class="s2">&quot;canvas&quot;</span>
       <span class="o">~</span><span class="n">src</span><span class="o">:</span><span class="p">(</span><span class="n">make_uri</span> <span class="o">~</span><span class="n">service</span><span class="o">:~%</span><span class="n">imageservice</span> <span class="bp">()</span><span class="p">)</span>
       <span class="bp">()</span><span class="p">)</span>
<span class="k">in</span>
<span class="n">img</span><span class="o">##.</span><span class="n">onload</span> <span class="o">:=</span> <span class="nn">Dom_html</span><span class="p">.</span><span class="n">handler</span>
    <span class="p">(</span><span class="k">fun</span> <span class="n">ev</span> <span class="o">-&gt;</span> <span class="n">ctx</span><span class="o">##</span><span class="n">drawImage</span> <span class="n">img</span> <span class="mi">0</span><span class="o">.</span> <span class="mi">0</span><span class="o">.;</span> <span class="nn">Js</span><span class="p">.</span><span class="n">_false</span><span class="p">);</span></code></pre></figure>

<p>You are then ready to try your graffiti-application by
<code class="language-plaintext highlighter-rouge">make test.byte</code>.</p>

<p>Note, that the <code class="language-plaintext highlighter-rouge">Makefile</code> from the distillery automatically adds
the packages defined in <code class="language-plaintext highlighter-rouge">SERVER_PACKAGES</code> as an extension in your
configuration file <code class="language-plaintext highlighter-rouge">local/etc/graffiti/graffiti-test.conf</code>:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;extension findlib-package=&quot;cairo2&quot; /&gt;
</code></pre></div></div>


