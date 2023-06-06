---
title: Gen_server in Ocaml
description: Note, this post is written against the 2.0.1 version of gen_server     Erlang
  comes with a rich set of small concurrency primitives to make...
url: http://functional-orbitz.blogspot.com/2013/12/genserver-in-ocaml.html
date: 2013-12-23T23:17:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
<i>Note, this post is written against the 2.0.1 version of <code>gen_server</code></i>
</p>

<p>
Erlang comes with a rich set of small concurrency primitives to make handling and manipulating state easier.  The most generic of the frameworks is the <code>gen_server</code> which is also the most commonly used.  A <code>gen_server</code> provides a way to control state over multiple requests.  It serializes operations and handles both synchronous and asynchronous communication with clients.  The strength of a <code>gen_server</code> is the ability to create multiple, lightweight, servers inside an application where each operation inside of it runs in serial but individually the <code>gen_server</code>s run concurrently.  
</p>

<p>
While it is not possible to provide all of the Erlang semantics in Ocaml, we can create something roughly analogous.  We can also get some properties that Erlang can not give us.  In particular, the implementation of <code>gen_server</code> provided here:
</p>

<a name="more"></a>

<p>
</p><ul>
<li>Does not have the concept of a process or a process id.  A <code>gen_server</code> is an abstract type that is parameterized by a message type.</li>
<li>Uses queues to communicate messages between clients and servers.</li>
<li><code>gen_server</code>s are typesafe, only messages that they can handle can be sent to them.</li>
<li>You can only communicate with <code>gen_server</code>s in your own process,  there is no concept of location ignorance.</li>
<li>Only provides an asynchronous communication function, called <code>send</code> that has pushback.  That means a <code>send</code> will be evaluated when the <code>gen_server</code> accepts the message but will not wait for the <code>gen_server</code> to complete the processing of the message.</li>
<li>Has the concept of process linking, however it is not preemptive.  When a <code>gen_server</code> stops, for any reason, any calls to <code>send</code> will return an error stating the <code>gen_server</code> has closed itself.  This will not force the termination of any other <code>gen_server</code>s in Ocaml, but the termination can at least be detected.</li>
<li>Any thrown exceptions are handled by the <code>gen_server</code> framework and result in the <code>gen_server</code> being gracefully terminated.</li>
</ul>


<p>
Relative to Erlang the Ocaml version isn't very impressive, however it's still a useful technique for encapsulating state in a concurrent environment.
</p>

<p>
This implementation of <code>gen_server</code> is on top of Jane St's Async.  What does it look like?  The primary interface looks like this:
</p>

<pre><code><b><font color="#0000FF">val</font></b> start  <font color="#990000">:</font>
    'i <font color="#990000">-&gt;</font>
    <font color="#990000">(</font>'i<font color="#990000">,</font> 's<font color="#990000">,</font> 'm<font color="#990000">,</font> 'ie<font color="#990000">,</font> 'he<font color="#990000">)</font> <b><font color="#000080">Server</font></b><font color="#990000">.</font>t <font color="#990000">-&gt;</font>
    <font color="#990000">(</font>'m t<font color="#990000">,</font> <font color="#990000">[&gt;</font> 'ie init_ret <font color="#990000">])</font> <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><b><font color="#000080">Result</font></b><font color="#990000">.</font>t

<b><font color="#0000FF">val</font></b> stop   <font color="#990000">:</font>
    'm t <font color="#990000">-&gt;</font>
    <font color="#990000">(</font><font color="#009900">unit</font><font color="#990000">,</font> <font color="#990000">[&gt;</font> `<font color="#009900">Closed</font> <font color="#990000">])</font> <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><b><font color="#000080">Result</font></b><font color="#990000">.</font>t

<b><font color="#0000FF">val</font></b> send   <font color="#990000">:</font>
    'm t <font color="#990000">-&gt;</font>
    'm <font color="#990000">-&gt;</font>
    <font color="#990000">(</font>'m<font color="#990000">,</font> <font color="#990000">[&gt;</font> send_ret <font color="#990000">])</font> <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><b><font color="#000080">Result</font></b><font color="#990000">.</font>t
</code></pre>

<p>
The interface is only three functions: <code>start</code>, <code>stop</code> and <code>send</code>.
</p>

<p>
</p><ul>
<li>The <code>start</code> function is a bit harry looking but don't be put off by the server type parameterized on five type variables.  The <code>start</code> function takes two parameters, the first is the initial parameters to pass to the <code>gen_server</code>, the second is the callbacks of the <code>gen_server</code>.</li>
<li><code>stop</code> takes a <code>gen_server</code> and returns <code>Ok ()</code> on success and <code>Error `Closed</code> if the <code>gen_server</code> is not running.</li>
<li><code>send</code> takes a <code>gen_server</code> and a message.  The message must be the same type the <code>gen_server</code> accepts.  It returns <code>Ok msg</code> on success and <code>Error `Closed</code> if the <code>gen_server</code> is not running.</li>
</ul>


<p>
The most confusion part is probably the <code>('i, 's, 'm, 'ie, 'he) Server.t</code>.  This is the type that the implementer of the <code>gen_server</code> writes.  It is three callbacks: <code>init</code>, <code>handle_call</code> and <code>terminate</code>.  Let's breakdown the type variables:
</p>

<p>
</p><ul>
<li>'i - This is the type of the variable that you pass to <code>start</code> and will be given to the <code>init</code> callback.</li>
<li>'s - This is the type of the state that the <code>gen_server</code> will encapsulate.  This will be passed to <code>handle_call</code> and <code>terminate</code>.  The <code>handle_call</code> callback will manipulate the state and return a new one.</li>
<li>'m - This is the message type that the <code>gen_server</code> will accept.</li>
<li>'ie - This is the type of error that the <code>init</code> callback can return.</li>
<li>'he - This is the type of error that the <code>handle_call</code> callback can return.</li>
</ul>


<p>
While the server type looks complicated, as you can see each variable corresponds to all of the type information needed to understand a <code>gen_server</code>.  So what does a server look like?  While the types are big it's actually not too bad.  Below is an example of a call to <code>start</code>.  The full source code can be found <a href="https://github.com/orbitz/gen_server/blob/master/examples/simple.ml">here</a>.
</p>

<pre><code><i><font color="#9A1900">(* Package the callbacks *)</font></i>
<b><font color="#0000FF">let</font></b> callbacks <font color="#990000">=</font>
  <font color="#FF0000">{</font> <b><font color="#000080">Gen_server</font></b><font color="#990000">.</font><b><font color="#000080">Server</font></b><font color="#990000">.</font>init<font color="#990000">;</font> handle_call<font color="#990000">;</font> terminate <font color="#FF0000">}</font>

<b><font color="#0000FF">let</font></b> start <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#000080">Gen_server</font></b><font color="#990000">.</font>start <font color="#990000">()</font> callbacks
</code></pre>

<p>
And what do the callbacks look like?  Below is a simplified version of what a set of callbacks could look like, with comments.
</p>

<pre><code><b><font color="#0000FF">module</font></b> <font color="#009900">Resp</font> <font color="#990000">=</font> <b><font color="#000080">Gen_server</font></b><font color="#990000">.</font><font color="#009900">Response</font>

<b><font color="#0000FF">module</font></b> <font color="#009900">Gs</font> <font color="#990000">=</font> <font color="#009900">Gen_server</font>

<i><font color="#9A1900">(* Callbacks *)</font></i>
<b><font color="#0000FF">let</font></b> init self init <font color="#990000">=</font>
  <b><font color="#000080">Deferred</font></b><font color="#990000">.</font>return <font color="#990000">(</font><font color="#009900">Ok</font> <font color="#990000">())</font>

<b><font color="#0000FF">let</font></b> handle_call self state <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
  <font color="#990000">|</font> <b><font color="#000080">Msg</font></b><font color="#990000">.</font><font color="#009900">Msg1</font> <font color="#990000">-&gt;</font>
    <i><font color="#9A1900">(* Success *)</font></i>
    <b><font color="#000080">Deferred</font></b><font color="#990000">.</font>return <font color="#990000">(</font><b><font color="#000080">Resp</font></b><font color="#990000">.</font><font color="#009900">Ok</font> state<font color="#990000">)</font>
  <font color="#990000">|</font> <b><font color="#000080">Msg</font></b><font color="#990000">.</font><font color="#009900">Msg2</font> <font color="#990000">-&gt;</font>
    <i><font color="#9A1900">(* Error *)</font></i>
    <b><font color="#000080">Deferred</font></b><font color="#990000">.</font>return <font color="#990000">(</font><b><font color="#000080">Resp</font></b><font color="#990000">.</font><font color="#009900">Error</font> <font color="#990000">(</font>reason<font color="#990000">,</font> state<font color="#990000">))</font>
  <font color="#990000">|</font> <b><font color="#000080">Msg</font></b><font color="#990000">.</font><font color="#009900">Msg3</font> <font color="#990000">-&gt;</font>
    <i><font color="#9A1900">(* Exceptions can be thrown too *)</font></i>
    failwith <font color="#FF0000">&quot;blowin' up&quot;</font>

<i><font color="#9A1900">(* Exceptions thrown from terminate are silently ignored *)</font></i>
<b><font color="#0000FF">let</font></b> terminate reason state <font color="#990000">=</font>
   <b><font color="#0000FF">match</font></b> reason <b><font color="#0000FF">with</font></b>
     <font color="#990000">|</font> <b><font color="#000080">Gs</font></b><font color="#990000">.</font><b><font color="#000080">Server</font></b><font color="#990000">.</font><font color="#009900">Normal</font> <font color="#990000">-&gt;</font>
       <i><font color="#9A1900">(* Things exited normally *)</font></i>
       <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><font color="#009900">unit</font>
     <font color="#990000">|</font> <b><font color="#000080">Gs</font></b><font color="#990000">.</font><b><font color="#000080">Server</font></b><font color="#990000">.</font><font color="#009900">Exn</font> <font color="#009900">exn</font> <font color="#990000">-&gt;</font>
       <i><font color="#9A1900">(* An exception was thrown *)</font></i>
       <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><font color="#009900">unit</font>
     <font color="#990000">|</font> <b><font color="#000080">Gs</font></b><font color="#990000">.</font><b><font color="#000080">Server</font></b><font color="#990000">.</font><font color="#009900">Error</font> err <font color="#990000">-&gt;</font>
       <i><font color="#9A1900">(* User returned an error *)</font></i>
       <b><font color="#000080">Deferred</font></b><font color="#990000">.</font><font color="#009900">unit</font>
</code></pre>

<p>
There isn't much more to it than that.
</p>

<p>
A functor implementation is also provided. I prefer the non-functor version, I think it's a bit less verbose and easier to work with, but some people like them.
</p>

<h1>How To Get It?</h1>
<p>
You can install <code>gen_server</code> through <code>opam</code>, simply: <code>opam install gen_server</code>
</p>

<p>
The source can be found <a href="https://github.com/orbitz/gen_server">here</a>.  Only the tags should be trusted as working.
</p>

<p>
There are a few examples <a href="https://github.com/orbitz/gen_server/tree/master/examples">here</a>.
</p>

<p>
Enjoy.
</p>

