---
title: 'Ocsigen: step by step tutorial for client-server Web application (1/2)'
description:
url: https://ocsigen.github.io/blog/2016/03/15/tuto-graffiti1/
date: 2016-03-15T00:00:00-00:00
preview_image:
featured:
authors:
- Vincent Balat
---

<p>This post (and the following one) is a step by step tutorial about
client-server Web applications in OCaml. You can find the full
tutorial <a href="http://ocsigen.org/tuto/manual/application">here</a>. It
introduces the basics of Web programming with OCaml: type-checking
HTML, defining services, using lightweight threads, writing a
client-server program &hellip;</p>

<p>We will write a collaborative drawing application. It is a
client-server Web application displaying an area where users can draw
using the mouse, and see what other users are drawing at the same time
and in real-time.</p>

<p>The final eliom code is available for download
<a href="https://github.com/ocsigen/graffiti/tree/master/simple">on github</a>.
<a href="https://github.com/ocsigen/graffiti/releases/tag/eliom-5.0">Git tag eliom-5.0</a>
has been tested against Eliom 5.0.</p>

<p>The application is running online <a href="http://ocsigen.org/graffiti/">here</a>.</p>

<h2>Basics</h2>

<p>To get started, we recommend using Eliom&rsquo;s distillery, a program which
creates scaffolds for Eliom projects. The following command creates a
very simple project called graffiti in the directory graffiti:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ eliom-distillery -name graffiti -template basic.ppx -target-directory graffiti
</code></pre></div></div>

<h2>My first page</h2>

<p><strong>(Services, Configuration file, Static validation of HTML)</strong></p>

<p>Our web application consists of a single page for now. Let&rsquo;s start by
creating a very basic page. We define the service that will implement
this page by the following declaration:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">open</span> <span class="nn">Eliom_content</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span> <span class="c">(* provides functions to create HTML nodes *)</span>

<span class="k">let</span> <span class="n">main_service</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="n">register_service</span>
    <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;graff&quot;</span><span class="p">]</span>
    <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
      <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
        <span class="p">(</span><span class="n">html</span>
           <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;Page title&quot;</span><span class="p">))</span> <span class="bp">[]</span><span class="p">)</span>
           <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">]])))</span></code></pre></figure>

<p>If you are using eliom-distillery just replace the content of the
eliom-file by the above lines and run</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ make test.byte
</code></pre></div></div>

<p>This will compile your application and run ocsigenserver on it. (Refer
to the manual on how to compile your project &ldquo;by hand&rdquo;.)</p>

<p>Your page is now available at URL <code class="language-plaintext highlighter-rouge">http://localhost:8080/graff</code>.</p>

<h3>Services</h3>

<p>Unlike typical web programming techniques (CGI, PHP, &hellip;), with Eliom you do not need to write one file per URL. The application can be split into multiple files as per the developer&rsquo;s style. What matters is that you eventually produce a single module (*.cmo or *.cma) for the whole website.</p>

<p>Module
<a href="http://ocsigen.org/eliom/5.0/api/client/Eliom_service">Eliom_service</a>
allows to create new entry points to your web site, called services.
In general, services are attached to a URL and generate a web page.
Services are represented by OCaml values, through which you must
register a function that will generate a page.</p>

<p>Parameter <code class="language-plaintext highlighter-rouge">~path</code> corresponds to the URL where you want to attach your service. It is a list of strings. The value <code class="language-plaintext highlighter-rouge">[&quot;foo&quot;; &quot;bar&quot;]</code> corresponds to URL <code class="language-plaintext highlighter-rouge">foo/bar</code>. <code class="language-plaintext highlighter-rouge">[&quot;dir&quot;; &quot;&quot;]</code> corresponds to URL <code class="language-plaintext highlighter-rouge">dir/</code> (that is: the default page of the directory dir).</p>

<h3>Configuration file</h3>

<p>In the directory of the project created by the Eliom-distillery, you can find the file <code class="language-plaintext highlighter-rouge">graffiti.conf.in</code>. This file is used in conjunction with the variables in Makefile.options to generate the ocsigenserver configuration file.</p>

<p>Once you start up your application via <code class="language-plaintext highlighter-rouge">make test.byte</code>, the configuration file becomes available at <code class="language-plaintext highlighter-rouge">local/etc/graffiti/graffiti-test.conf</code>. It contains various directives for Ocsigen server (port, log files, extensions to be loaded, etc.), taken from Makefile.options, and something like:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;host&gt;
  &lt;static dir=&quot;static&quot; /&gt;
  &lt;eliommodule module=&quot;/path_to/graffiti.cma&quot; /&gt;
  &lt;eliom /&gt;
&lt;/host&gt;
</code></pre></div></div>

<p>Line <code class="language-plaintext highlighter-rouge">&lt;eliommodule ... /&gt;</code> asks the server to load Eliom module
<code class="language-plaintext highlighter-rouge">graffiti.cma</code>, containing the Eliom application, at startup and
attach it to this host (and site).</p>

<p>Extensions <code class="language-plaintext highlighter-rouge">&lt;static ... /&gt;</code> (staticmod) and <code class="language-plaintext highlighter-rouge">&lt;eliom /&gt;</code> are called successively:</p>

<ul>
  <li>If they exist, files from the directory <code class="language-plaintext highlighter-rouge">/path_to/graffiti/static</code>
will be served,</li>
  <li>Otherwise, Server will try to generate pages with Eliom (<code class="language-plaintext highlighter-rouge">&lt;eliom /&gt;</code>),</li>
  <li>Otherwise it will generate a 404 (Not found) error (default).</li>
</ul>

<h3>Static validation of HTML</h3>

<p>There are several ways to create pages for Eliom. You can generate
pages as strings (as in other web frameworks). However, it is
preferable to generate HTML in a way that provides compile-time HTML
correctness guarantees. This tutorial achieves this by using
module <a href="http://ocsigen.org/eliom/5.0/api/client/Eliom_content.Html5.D">Eliom_content.&#8203;Html5.&#8203;D</a>, which is implemented using the TyXML
library. The module defines a construction function for each HTML5
tag.</p>

<p>Note that it is also possible to use the usual HTML syntax directly in OCaml.</p>

<p>The TyXML library (and thus <a href="http://ocsigen.org/eliom/5.0/api/client/Eliom_content.Html5.D">Eliom_content.&#8203;Html5.&#8203;D</a>) is very strict and compels you to respect HTML5 standard (with some limitations). For example if you write:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">(</span><span class="n">html</span>
   <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;&quot;</span><span class="p">))</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;&quot;</span><span class="p">])</span>
   <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Hallo&quot;</span><span class="p">]))</span></code></pre></figure>

<p>You will get an error message similar to the following, referring to the end of line 2:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Error: This expression has type ([&gt; `PCDATA ] as 'a) Html5.elt
       but an expression was expected of type
         Html5_types.head_content_fun Html5.elt
       Type 'a is not compatible with type Html5_types.head_content_fun =
           [ `Base
           | `Command
           | `Link
           | `Meta
           | `Noscript of [ `Link | `Meta | `Style ]
           | `Script
           | `Style ]
       The second variant type does not allow tag(s) `PCDATA
</code></pre></div></div>

<p>where <code class="language-plaintext highlighter-rouge">Html5_types.&#8203;head_content_fun</code> is the type of content allowed inside <code class="language-plaintext highlighter-rouge">&lt;head&gt;</code> (<code class="language-plaintext highlighter-rouge">&lt;base&gt;</code>, <code class="language-plaintext highlighter-rouge">&lt;command&gt;</code>, <code class="language-plaintext highlighter-rouge">&lt;link&gt;</code>, <code class="language-plaintext highlighter-rouge">&lt;meta&gt;</code>, etc.). Notice that <code class="language-plaintext highlighter-rouge">&amp;lt;PCDATA</code> (i.e. raw text) is not included in this polymorphic variant type.</p>

<p>Most functions take as parameter the list representing its contents. See other examples below. Each of them take un optional <code class="language-plaintext highlighter-rouge">?a</code> parameter for optional HTML attributes. Mandatory HTML attributes correspond to mandatory OCaml parameters. See below for examples.</p>

<h3>Lwt</h3>

<p>Important warning: All the functions you write must be written in a cooperative manner using Lwt. Lwt is a convenient way to implement concurrent programs in OCaml, and is now also widely used for applications unrelated to Ocsigen.</p>

<p>For now we will just use the <code class="language-plaintext highlighter-rouge">Lwt.return</code> function as above. We will come back to Lwt programming later. You can also have a look at the Lwt programming guide.</p>

<h2>Execute parts of the program on the client</h2>

<p><strong>(Service sending an application,
Client and server code, Compiling a web application with server and client parts, Calling JavaScript methods with Js_of_ocaml)</strong></p>

<p>To create our first service, we used the function <a href="http://ocsigen.org/eliom/5.0/api/client/Eliom_registration.Html5#VALregister_service">Eliom_registration.&#8203;Html5.&#8203;register_service</a>, as all we wanted to do was return HTML5. But we actually want a service that corresponds to a full Eliom application with client and server parts. To do so, we need to create our own registration module by using the functor <code class="language-plaintext highlighter-rouge">Eliom_registration.App</code>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">module</span> <span class="nc">Graffiti_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span> <span class="p">(</span><span class="k">struct</span>
      <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;graffiti&quot;</span>
    <span class="k">end</span><span class="p">)</span></code></pre></figure>

<p>It is now possible to use <code class="language-plaintext highlighter-rouge">My_app</code> for registering our main service
(now at URL <code class="language-plaintext highlighter-rouge">/</code>):</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">main_service</span> <span class="o">=</span>
  <span class="nn">Graffiti_app</span><span class="p">.</span><span class="n">register_service</span>
    <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;&quot;</span><span class="p">]</span>
    <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
      <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
        <span class="p">(</span><span class="n">html</span>
           <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">))</span> <span class="bp">[]</span><span class="p">)</span>
           <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">]])</span> <span class="p">)</span> <span class="p">)</span></code></pre></figure>

<p>We can now add some OCaml code to be executed by the browser. For this purpose, Eliom provides a syntax extension to distinguish between server and client code in the same file. We start by a very basic program, that will display a message to the user by calling the JavaScript function alert. Add the following lines to the program:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Eliom_lib</span><span class="p">.</span><span class="n">alert</span> <span class="s2">&quot;Hello!&quot;</span></code></pre></figure>

<p>After running again make test.byte, and visiting <code class="language-plaintext highlighter-rouge">http://localhost:8080/</code>, the browser will load the file <code class="language-plaintext highlighter-rouge">graffiti.js</code>, and open an alert-box.</p>

<h3>Splitting the code into server and client parts</h3>

<p>At the very toplevel of your source file (i.e. not inside modules or other server- /client-parts), you can use the following constructs to indicate which side the code should run on.</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">[%%client ... ]</code> : the list of enclosed definitions is client-only code (similarly for <code class="language-plaintext highlighter-rouge">[%%server ... ]</code>). With <code class="language-plaintext highlighter-rouge">[%%shared ... ]</code>, the code is used both on the server and client.</li>
  <li><code class="language-plaintext highlighter-rouge">let%client</code>, <code class="language-plaintext highlighter-rouge">let%server</code>, <code class="language-plaintext highlighter-rouge">let%shared</code>: same as above for a single definition.</li>
  <li><code class="language-plaintext highlighter-rouge">[%%client.start]</code>, <code class="language-plaintext highlighter-rouge">[%%server.start]</code>, <code class="language-plaintext highlighter-rouge">[%%shared.start]</code>: these set the default location for all definitions that follow, and which do not use the preceding constructs.</li>
</ul>

<p>If no location is specified, the code is assumed to be for the server.</p>

<p>The above constructs are implemented by means of PPX, OCaml&rsquo;s new mechanism for implementing syntax extensions. See <a href="http://ocsigen.org/eliom/5.0/manual/ppx-syntax">Ppx_eliom</a> for details.</p>

<p><strong>Client parts are executed once, when the client side process is launched.</strong> The client process is not restarted after each page change.</p>

<p>In the <code class="language-plaintext highlighter-rouge">Makefile</code> created by the distillery, we automatically split the code into client and server parts, compile the server part as usual, and compile the client part to a JavaScript file using <code class="language-plaintext highlighter-rouge">js_of_ocaml</code>.</p>

<h3>Client values on the server</h3>

<p>Additionally, it is possible to create client values within the server code by the following quotation:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%</span><span class="n">client</span> <span class="p">(</span><span class="n">expr</span> <span class="o">:</span> <span class="n">typ</span><span class="p">)</span> <span class="p">]</span></code></pre></figure>

<p>where <code class="language-plaintext highlighter-rouge">typ</code> is the type of an expression <code class="language-plaintext highlighter-rouge">expr</code> on the client. Note, that such a client value is abstract on the server, but becomes concrete, once it is sent to the client with the next request.</p>

<p>(<code class="language-plaintext highlighter-rouge">typ</code> can be ommitted if it can be inferred from the usage of the client value in the server code.)</p>

<p><strong>Client values are executed on the client after the service returns.</strong> You can use client values when a service wants to ask the client to run something, for example binding some event handler on some element produced by the service.</p>

<h3>Js_of_ocaml</h3>

<p>The client-side parts of the program are compiled to JavaScript by <code class="language-plaintext highlighter-rouge">js_of_ocaml</code>. (Technically, <code class="language-plaintext highlighter-rouge">js_of_ocaml</code> compiles OCaml bytecode to JavaScript.) It is easy to bind JavaScript libraries so that OCaml programs can call JavaScript functions. In the example, we are using the <a href="http://ocsigen.org/js_of_ocaml/2.7/api/Dom_html">Dom_html</a> module, which is a binding that allows the manipulation of an HTML page.</p>

<p>Js_of_ocaml is using a syntax extension to call JavaScript methods:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">obj##m a b c</code> to call the method <code class="language-plaintext highlighter-rouge">m</code> of object <code class="language-plaintext highlighter-rouge">obj</code> with parameters <code class="language-plaintext highlighter-rouge">a</code>, <code class="language-plaintext highlighter-rouge">b</code>, <code class="language-plaintext highlighter-rouge">c</code>,</li>
  <li><code class="language-plaintext highlighter-rouge">obj##.m</code> to get a property,</li>
  <li><code class="language-plaintext highlighter-rouge">obj##.m := e</code> to set a property, and</li>
  <li><code class="language-plaintext highlighter-rouge">new%js constr a b c</code> to call a JavaScript constructor.</li>
</ul>

<p>More information can be found in the Js_of_ocaml manual, in the module
<a href="http://ocsigen.org/js_of_ocaml/2.7/api/Ppx_js">Ppx_js</a>.</p>

<h2>Accessing server side variables on client side code</h2>

<p><strong>(Executing client side code after loading a page,
Sharing server side values,
Converting an HTML value to a portion of page (a.k.a. Dom node),
Manipulating HTML node &lsquo;by reference&rsquo;)</strong></p>

<p>The client side process is not strictly separated from the server side. We can access some server variables from the client code. For instance:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">count</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span>

<span class="k">let</span> <span class="n">main_service</span> <span class="o">=</span>
  <span class="nn">Graffiti_app</span><span class="p">.</span><span class="n">register_service</span>
    <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;&quot;</span><span class="p">]</span>
    <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="k">let</span> <span class="n">c</span> <span class="o">=</span> <span class="n">incr</span> <span class="n">count</span><span class="p">;</span> <span class="o">!</span><span class="n">count</span> <span class="k">in</span>
       <span class="n">ignore</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
         <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">window</span><span class="o">##</span><span class="n">alert</span>
            <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span>
               <span class="p">(</span><span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="s2">&quot;You came %i times to this page&quot;</span> <span class="o">~%</span><span class="n">c</span><span class="p">))</span>
          <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span>
       <span class="p">];</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
         <span class="p">(</span><span class="n">html</span>
            <span class="p">(</span><span class="n">head</span> <span class="p">(</span><span class="n">title</span> <span class="p">(</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">))</span> <span class="bp">[]</span><span class="p">)</span>
            <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h1</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Graffiti&quot;</span><span class="p">]])))</span></code></pre></figure>

<p>Here, we are increasing the reference count each time the page is accessed. When the page is loaded and the document is in-place, the client program initializes the value inside <code class="language-plaintext highlighter-rouge">[%client ... ]</code>, and thus triggers an alert window. More specifically, the variable <code class="language-plaintext highlighter-rouge">c</code>, in the scope of the client value on the server is made available to the client value using the syntax extension <code class="language-plaintext highlighter-rouge">~%c</code>. In doing so, the server side value <code class="language-plaintext highlighter-rouge">c</code> is displayed in a message box on the client.</p>

<p>###Injections: Using server side values in client code</p>

<p>Client side code can reference copies of server side values using syntax <code class="language-plaintext highlighter-rouge">~%variable</code>. Values sent that way are weakly type checked: the name of the client side type must match the server side one. If you define a type and want it to be available on both sides, declare it in <code class="language-plaintext highlighter-rouge">[%%shared ... ]</code>. The Eliom manual provides more information on the <a href="http://ocsigen.org/eliom/5.0/api/ppx/Ppx_eliom">Eliom&rsquo;s syntax extension</a> and its <a href="http://ocsigen.org/eliom/5.0/manual/workflow-compilation#compilation">compilation process</a>.</p>

<p>Note that the value of an injection into a <code class="language-plaintext highlighter-rouge">[%%client ... ]</code> section is sent only once when starting the application in the browser, and not synced automatically later. In contrast, the values of injections into client values which are created during a request are sent alongside the next response.</p>

<h2>Next week</h2>

<p>In next tutorial, we will turn the program into a collaborative drawing
application, and learn:</p>

<ul>
  <li>How to draw on a canvas,</li>
  <li>How to program mouse events with <code class="language-plaintext highlighter-rouge">js_of_ocaml</code>,</li>
  <li>More about Lwt,</li>
  <li>How to create communication channels with the server</li>
  <li>How to create other types of services</li>
</ul>

<p>The impatient can find the full tutorial
<a href="http://ocsigen.org/tuto/manual/application">here</a>.</p>

