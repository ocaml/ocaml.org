---
title: 'Ocsigen: client-server widgets'
description:
url: https://ocsigen.github.io/blog/2016/02/22/tutorial-widgets/
date: 2016-02-22T00:00:00-00:00
preview_image:
featured:
authors:
- Vincent Balat
---

<p>This short tutorial is an example of client-server Eliom application. It gives an example of client-server widgets. You can find the original version of this tutorial (and many others) <a href="http://ocsigen.org/tuto/manual/tutowidgets">here</a>.</p>

<p>It is probably a good starting point if you know OCaml well, and want to quickly learn how to write a client-server Eliom application with a short example and concise explanations. For more detailed explanations, see the <a href="http://ocsigen.org/tuto/manual/application">&ldquo;Graffiti&rdquo; tutorial</a>, or read the manuals.</p>

<p>The goal is to show that, unlike many JavaScript libraries that build their widgets programmatically (by instantiating classes or calling functions), Eliom enables server-side widget generation, before sending them to the client. Pages can thus be indexed by search engines.</p>

<p>This tutorial also shows that it is possible to use the same code to build the widget either on client or server side.</p>

<p>We choose a very simple widget, that could be the base for example for implementing a drop-down menu. It consists of several boxes with a title and a content. Clicking on the title opens or closes the content. Furthermore, it is possible to group some of the boxes together to make them behave like radio buttons: when you open one of them, the previously opened one is closed.</p>

<p><img src="http://ocsigen.org/tuto/files/tutorial/tutowidgets/ex-final.png" alt="Screenshot"/></p>

<h2>First step: define an application with a basic service</h2>

<p>The following code defines a client-server Web application with only one service, registered at URL / (the root of the website).</p>

<p>The code also defines a client-side application (section <code class="language-plaintext highlighter-rouge">[%%client ... ]</code>) that appends a client-side generated widget to the page. Section <code class="language-plaintext highlighter-rouge">[%%shared ... ]</code> is compiled on both the server and client side programs. Alternatively, you can write <code class="language-plaintext highlighter-rouge">let%client</code>, <code class="language-plaintext highlighter-rouge">let%server</code> or <code class="language-plaintext highlighter-rouge">let%shared</code> (default) to define values on client side, on server side, or on both sides.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
    <span class="k">open</span> <span class="nc">Eliom_content</span>
    <span class="k">open</span> <span class="nc">Html5</span>
    <span class="k">open</span> <span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span>
<span class="p">]</span>

<span class="k">module</span> <span class="nc">Ex_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span> <span class="p">(</span><span class="k">struct</span> <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;ex&quot;</span> <span class="k">end</span><span class="p">)</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span>
  <span class="nn">Ex_app</span><span class="p">.</span><span class="n">register_service</span> <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="bp">[]</span> <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
         <span class="p">(</span><span class="nn">Eliom_tools</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">html</span> <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="s2">&quot;ex&quot;</span> <span class="o">~</span><span class="n">css</span><span class="o">:</span><span class="p">[[</span><span class="s2">&quot;css&quot;</span><span class="p">;</span> <span class="s2">&quot;ex.css&quot;</span><span class="p">]]</span>
            <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h2</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Welcome to Ocsigen!&quot;</span><span class="p">]])))</span>

<span class="p">[</span><span class="o">%%</span><span class="n">client</span>
<span class="k">let</span> <span class="n">mywidget</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">button</span>  <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;button&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s1</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">content</span> <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;content&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s2</span><span class="p">]</span> <span class="k">in</span>
  <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;mywidget&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">button</span><span class="p">;</span> <span class="n">content</span><span class="p">]</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">%</span><span class="n">lwt</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Lwt_js_events</span><span class="p">.</span><span class="n">onload</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="nn">Dom</span><span class="p">.</span><span class="n">appendChild</span>
    <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span><span class="o">##.</span><span class="n">body</span><span class="p">)</span>
    <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="p">(</span><span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;Hello!&quot;</span><span class="p">));</span>
  <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span>
<span class="p">]</span></code></pre></figure>

<p>To compile it, first create a project by calling</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>eliom-distillery -name ex -template basic.ppx
</code></pre></div></div>

<p>The name of the project must match the name given to the functor <code class="language-plaintext highlighter-rouge">Eliom_registration.App</code>.</p>

<p>After you adapt the file <code class="language-plaintext highlighter-rouge">ex.eliom</code>, you can compile by calling make, and run the server by calling <code class="language-plaintext highlighter-rouge">make test.byte</code>. Download the <a href="http://ocsigen.org/tuto/files/tutorial/tutowidgets/ex.css">CSS file</a> and place it in directory <code class="language-plaintext highlighter-rouge">static/css</code>. Then open a browser window and go to URL <code class="language-plaintext highlighter-rouge">http://localhost:8080</code>.</p>

<p>Screenshot:</p>

<p><img src="http://ocsigen.org/tuto/files/tutorial/tutowidgets/ex1.png" alt="Screenshot"/></p>

<h3>More explanations</h3>

<p>This section gives very quick explanations on the rest of the program. For more detailed explanations, see the tutorial for the graffiti app or the manual of each of the projects.</p>

<ul>
  <li>The client side program is sent with the first page belonging to the application (registered through module <code class="language-plaintext highlighter-rouge">Ex_app</code>).</li>
  <li>The <code class="language-plaintext highlighter-rouge">##</code> is used to call a JS method from OCaml and <code class="language-plaintext highlighter-rouge">##.</code> to access a JS object field (See Js_of_ocaml&rsquo;s documentation: <a href="http://ocsigen.org/js_of_ocaml/api/Ppx_js">Ppx_js</a>).</li>
  <li>If there are several services in your application, the client-side program will be sent only with the first page, and will not stop if you go to another page of the application.</li>
  <li><code class="language-plaintext highlighter-rouge">Lwt</code> is the concurrent library used to program threads on both client and server sides. The syntax <code class="language-plaintext highlighter-rouge">let%lwt a = e1 in e2</code> allows waiting (without blocking the rest of the program) for an Lwt thread to terminate before continuing. <code class="language-plaintext highlighter-rouge">e2</code> must ben a Lwt thread itself. <code class="language-plaintext highlighter-rouge">Lwt.return</code> enables creating an already-terminated Lwt thread.</li>
  <li><code class="language-plaintext highlighter-rouge">Lwt_js_events</code> defines a convenient way to program interface events (mouse, keyboard, &hellip;). For example, <code class="language-plaintext highlighter-rouge">Lwt_js_events.onload</code> is a Lwt thread that waits until the page is loaded. There are similar functions to wait for other events, e.g., for a click on an element of the page, or for a key press.</li>
</ul>

<h2>Second step: bind the button</h2>

<p>To make the widget work, we must bind the click event. Replace function <code class="language-plaintext highlighter-rouge">mywidget</code> by the following lines:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">switch_visibility</span> <span class="n">elt</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="n">elt</span> <span class="k">in</span>
  <span class="k">if</span> <span class="nn">Js</span><span class="p">.</span><span class="n">to_bool</span> <span class="p">(</span><span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">contains</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">))</span> <span class="k">then</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">remove</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>
  <span class="k">else</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">add</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">mywidget</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">button</span>  <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;button&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s1</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">content</span> <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;content&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s2</span><span class="p">]</span> <span class="k">in</span>
  <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
    <span class="nn">Lwt_js_events</span><span class="p">.</span><span class="n">clicks</span> <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="n">button</span><span class="p">)</span>
      <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">switch_visibility</span> <span class="n">content</span><span class="p">;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span><span class="p">));</span>
  <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;mywidget&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">button</span><span class="p">;</span> <span class="n">content</span><span class="p">]</span></code></pre></figure>

<ul>
  <li>Once again, we use <code class="language-plaintext highlighter-rouge">Lwt_js_events</code>. Function <code class="language-plaintext highlighter-rouge">clicks</code> is used to bind a handler to clicks on a specific element.</li>
  <li>Function <code class="language-plaintext highlighter-rouge">async</code> runs an <code class="language-plaintext highlighter-rouge">Lwt</code> thread asynchronously (without waiting for its result).</li>
  <li><code class="language-plaintext highlighter-rouge">Lwt_js_events.clicks elt f</code> calls function <code class="language-plaintext highlighter-rouge">f</code> for each mouseclick on element <code class="language-plaintext highlighter-rouge">elt</code>.</li>
  <li><code class="language-plaintext highlighter-rouge">To_dom.of_element</code>, <code class="language-plaintext highlighter-rouge">Js.string</code> and <code class="language-plaintext highlighter-rouge">Js.to_bool</code> are conversion functions between OCaml values and JS values.</li>
</ul>

<h2>Third step: Generating the widget on server side</h2>

<p>The following version of the program shows how to generate the widget on server side, before sending it to the client.</p>

<p>The code is exactly the same, with the following modifications:</p>

<ul>
  <li>We place function mywidget out of client section.</li>
  <li>The portion of code that must be run on client side (binding the click event) is written as a <em>client value</em>, inside <code class="language-plaintext highlighter-rouge">[%client (... : unit) ]</code>. This code will be executed by the client-side program when it receives the page. Note that you must give the type (here <code class="language-plaintext highlighter-rouge">unit</code>), as the type inference for client values is currently very limited. The client section may refer to server side values, using the <code class="language-plaintext highlighter-rouge">~%x</code> syntax. These values will be serialized and sent to the client automatically with the page.</li>
  <li>We include the widget on the server side generated page instead of adding it to the page from client side.</li>
</ul>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
    <span class="k">open</span> <span class="nc">Eliom_content</span>
    <span class="k">open</span> <span class="nc">Html5</span>
    <span class="k">open</span> <span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span>
<span class="p">]</span>

<span class="k">module</span> <span class="nc">Ex_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span><span class="p">(</span><span class="k">struct</span> <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;ex&quot;</span> <span class="k">end</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">switch_visibility</span> <span class="n">elt</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="n">elt</span> <span class="k">in</span>
  <span class="k">if</span> <span class="nn">Js</span><span class="p">.</span><span class="n">to_bool</span> <span class="p">(</span><span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="p">(</span><span class="n">contains</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)))</span> <span class="k">then</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">remove</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>
  <span class="k">else</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">add</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>

<span class="k">let</span> <span class="n">mywidget</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">button</span>  <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;button&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s1</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">content</span> <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;content&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s2</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
    <span class="p">(</span><span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="nn">Lwt_js_events</span><span class="p">.</span><span class="n">clicks</span> <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="o">~%</span><span class="n">button</span><span class="p">)</span>
         <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">switch_visibility</span> <span class="o">~%</span><span class="n">content</span><span class="p">;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span><span class="p">))</span>
     <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span>
  <span class="p">]</span> <span class="k">in</span>
  <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;mywidget&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">button</span><span class="p">;</span> <span class="n">content</span><span class="p">]</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span>
  <span class="nn">Ex_app</span><span class="p">.</span><span class="n">register_service</span> <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="bp">[]</span> <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
         <span class="p">(</span><span class="nn">Eliom_tools</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">html</span> <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="s2">&quot;ex&quot;</span> <span class="o">~</span><span class="n">css</span><span class="o">:</span><span class="p">[[</span><span class="s2">&quot;css&quot;</span><span class="p">;</span> <span class="s2">&quot;ex.css&quot;</span><span class="p">]]</span>
            <span class="p">(</span><span class="n">body</span> <span class="p">[</span><span class="n">h2</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Welcome to Ocsigen!&quot;</span><span class="p">];</span>
                   <span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;Hello!&quot;</span><span class="p">])))</span></code></pre></figure>

<h2>Fourth step: widget usable either on client or server sides</h2>

<p>If you make function <code class="language-plaintext highlighter-rouge">mywidget</code> <em>shared</em>, it will be available both on server and client sides:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span><span class="o">%</span><span class="n">shared</span> <span class="n">mywidget</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="o">...</span></code></pre></figure>

<p>Screenshot:</p>

<p><img src="http://ocsigen.org/tuto/files/tutorial/tutowidgets/ex2.png" alt="Screenshot"/></p>

<h2>Fifth step: close last window when opening a new one</h2>

<p>To implement this, we record a client-side reference to a function for closing the currently opened window.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
    <span class="k">open</span> <span class="nc">Eliom_content</span>
    <span class="k">open</span> <span class="nc">Html5</span>
    <span class="k">open</span> <span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span>
<span class="p">]</span>

<span class="k">module</span> <span class="nc">Ex_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span> <span class="p">(</span><span class="k">struct</span> <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;ex&quot;</span> <span class="k">end</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">close_last</span> <span class="o">=</span> <span class="n">ref</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">switch_visibility</span> <span class="n">elt</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="n">elt</span> <span class="k">in</span>
  <span class="k">if</span> <span class="nn">Js</span><span class="p">.</span><span class="n">to_bool</span> <span class="p">(</span><span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="p">(</span><span class="n">contains</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)))</span> <span class="k">then</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">remove</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>
  <span class="k">else</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">add</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">shared</span> <span class="n">mywidget</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">button</span>  <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;button&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s1</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">content</span> <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;content&quot;</span><span class="p">;</span> <span class="s2">&quot;hidden&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s2</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
    <span class="p">(</span><span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="nn">Lwt_js_events</span><span class="p">.</span><span class="n">clicks</span> <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="o">~%</span><span class="n">button</span><span class="p">)</span>
         <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="n">_</span> <span class="o">-&gt;</span>
            <span class="o">!</span><span class="n">close_last</span><span class="bp">()</span><span class="p">;</span>
            <span class="n">close_last</span> <span class="o">:=</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">switch_visibility</span> <span class="o">~%</span><span class="n">content</span><span class="p">);</span>
            <span class="n">switch_visibility</span> <span class="o">~%</span><span class="n">content</span><span class="p">;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span><span class="p">))</span>
     <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span>
  <span class="p">]</span> <span class="k">in</span>
  <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;mywidget&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">button</span><span class="p">;</span> <span class="n">content</span><span class="p">]</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span>
  <span class="nn">Ex_app</span><span class="p">.</span><span class="n">register_service</span> <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="bp">[]</span> <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
         <span class="p">(</span><span class="nn">Dom</span><span class="p">.</span><span class="n">appendChild</span>
            <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span><span class="o">##.</span><span class="n">body</span><span class="p">)</span>
            <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="p">(</span><span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;client side&quot;</span><span class="p">))</span>
          <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span>
       <span class="p">]</span> <span class="k">in</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
         <span class="p">(</span><span class="nn">Eliom_tools</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">html</span> <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="s2">&quot;ex&quot;</span> <span class="o">~</span><span class="n">css</span><span class="o">:</span><span class="p">[[</span><span class="s2">&quot;css&quot;</span><span class="p">;</span> <span class="s2">&quot;ex.css&quot;</span><span class="p">]]</span>
            <span class="p">(</span><span class="n">body</span> <span class="p">[</span>
               <span class="n">h2</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Welcome to Ocsigen!&quot;</span><span class="p">];</span>
               <span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span><span class="p">;</span>
               <span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span><span class="p">;</span>
               <span class="n">mywidget</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span>
             <span class="p">])))</span></code></pre></figure>

<h2>Last step: several sets of widgets</h2>

<p>Now we want to enable several sets of widgets in the same page. A single reference no longer suffices. In the following version, the server-side program asks the client-side program to generate two different references, by calling function <code class="language-plaintext highlighter-rouge">new_set</code>. This function returns what we call a <em>client value</em>. Client values are values of the client side program that can be manipulated on server side (but not evaluated). On server side, they have an abstract type.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="p">[</span><span class="o">%%</span><span class="n">shared</span>
    <span class="k">open</span> <span class="nc">Eliom_content</span>
    <span class="k">open</span> <span class="nc">Html5</span>
    <span class="k">open</span> <span class="nn">Html5</span><span class="p">.</span><span class="nc">D</span>
<span class="p">]</span>

<span class="k">module</span> <span class="nc">Ex_app</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nc">App</span> <span class="p">(</span><span class="k">struct</span> <span class="k">let</span> <span class="n">application_name</span> <span class="o">=</span> <span class="s2">&quot;ex&quot;</span> <span class="k">end</span><span class="p">)</span>

<span class="k">let</span> <span class="n">new_set</span> <span class="bp">()</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span> <span class="p">(</span><span class="n">ref</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="p">)</span> <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="n">ref</span><span class="p">)]</span>

<span class="k">let</span><span class="o">%</span><span class="n">client</span> <span class="n">switch_visibility</span> <span class="n">elt</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="n">elt</span> <span class="k">in</span>
  <span class="k">if</span> <span class="nn">Js</span><span class="p">.</span><span class="n">to_bool</span> <span class="p">(</span><span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="p">(</span><span class="n">contains</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)))</span> <span class="k">then</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">remove</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>
  <span class="k">else</span>
    <span class="n">elt</span><span class="o">##.</span><span class="n">classList</span><span class="o">##</span><span class="n">add</span> <span class="p">(</span><span class="nn">Js</span><span class="p">.</span><span class="n">string</span> <span class="s2">&quot;hidden&quot;</span><span class="p">)</span>

<span class="k">let</span><span class="o">%</span><span class="n">shared</span> <span class="n">mywidget</span> <span class="n">set</span> <span class="n">s1</span> <span class="n">s2</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">button</span>  <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;button&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s1</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">content</span> <span class="o">=</span> <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;content&quot;</span><span class="p">;</span> <span class="s2">&quot;hidden&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">pcdata</span> <span class="n">s2</span><span class="p">]</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
    <span class="p">(</span><span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="nn">Lwt_js_events</span><span class="p">.</span><span class="n">clicks</span> <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="o">~%</span><span class="n">button</span><span class="p">)</span>
         <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="n">_</span> <span class="o">-&gt;</span>
            <span class="o">!</span> <span class="o">~%</span><span class="n">set</span><span class="bp">()</span><span class="p">;</span>
            <span class="o">~%</span><span class="n">set</span> <span class="o">:=</span> <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">switch_visibility</span> <span class="o">~%</span><span class="n">content</span><span class="p">);</span>
            <span class="n">switch_visibility</span> <span class="o">~%</span><span class="n">content</span><span class="p">;</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="bp">()</span><span class="p">))</span>
     <span class="o">:</span> <span class="kt">unit</span><span class="p">)]</span>
  <span class="k">in</span>
  <span class="n">div</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;mywidget&quot;</span><span class="p">]]</span> <span class="p">[</span><span class="n">button</span><span class="p">;</span> <span class="n">content</span><span class="p">]</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span>
  <span class="nn">Ex_app</span><span class="p">.</span><span class="n">register_service</span> <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="bp">[]</span> <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">unit</span>
    <span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="bp">()</span> <span class="o">-&gt;</span>
       <span class="k">let</span> <span class="n">set1</span> <span class="o">=</span> <span class="n">new_set</span> <span class="bp">()</span> <span class="k">in</span>
       <span class="k">let</span> <span class="n">set2</span> <span class="o">=</span> <span class="n">new_set</span> <span class="bp">()</span> <span class="k">in</span>
       <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="p">[</span><span class="o">%</span><span class="n">client</span>
         <span class="p">(</span><span class="nn">Dom</span><span class="p">.</span><span class="n">appendChild</span>
            <span class="p">(</span><span class="nn">Dom_html</span><span class="p">.</span><span class="n">document</span><span class="o">##.</span><span class="n">body</span><span class="p">)</span>
            <span class="p">(</span><span class="nn">To_dom</span><span class="p">.</span><span class="n">of_element</span> <span class="p">(</span><span class="n">mywidget</span> <span class="o">~%</span><span class="n">set2</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;client side&quot;</span><span class="p">))</span>
          <span class="o">:</span> <span class="kt">unit</span><span class="p">)</span>
       <span class="p">]</span> <span class="k">in</span>
       <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span>
         <span class="p">(</span><span class="nn">Eliom_tools</span><span class="p">.</span><span class="nn">D</span><span class="p">.</span><span class="n">html</span> <span class="o">~</span><span class="n">title</span><span class="o">:</span><span class="s2">&quot;ex&quot;</span> <span class="o">~</span><span class="n">css</span><span class="o">:</span><span class="p">[[</span><span class="s2">&quot;css&quot;</span><span class="p">;</span> <span class="s2">&quot;ex.css&quot;</span><span class="p">]]</span>
            <span class="p">(</span><span class="n">body</span> <span class="p">[</span>
               <span class="n">h2</span> <span class="p">[</span><span class="n">pcdata</span> <span class="s2">&quot;Welcome to Ocsigen!&quot;</span><span class="p">];</span>
               <span class="n">mywidget</span> <span class="n">set1</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span><span class="p">;</span>
               <span class="n">mywidget</span> <span class="n">set1</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span><span class="p">;</span>
               <span class="n">mywidget</span> <span class="n">set2</span> <span class="s2">&quot;Click me&quot;</span> <span class="s2">&quot;server side&quot;</span>
             <span class="p">])))</span></code></pre></figure>

<p>Screenshot:</p>

<p><img src="http://ocsigen.org/tuto/files/tutorial/tutowidgets/ex-final.png" alt="Screenshot"/></p>

<h2>And now?</h2>

<h3>Calling server functions</h3>

<p>An important feature missing from this tutorial is the ability to call server functions from the client-side program (&ldquo;server functions&rdquo;). You can find a quick description of this in this <a href="http://ocsigen.org/tuto/manual/how-to-call-a-server-side-function-from-client-side">mini HOWTO</a> or in <a href="http://ocsigen.org/eliom/manual/clientserver-communication#rpc">Eliom&rsquo;s manual</a>.</p>

<h3>Services</h3>

<p>For many applications, you will need several services. By default, client-side Eliom programs do not stop when you follow a link or send a form. This enables combining rich client side features (playing music, animations, stateful applications &hellip;) with traditional Web interaction (links, forms, bookmarks, back button &hellip;). Eliom proposes several ways to identify services, either by the URL (and parameters), or by a session identifier (we call this kind of service a coservice). Eliom also allows creating new (co-)services dynamically, for example coservices depending on previous interaction with a user. More information on the service identification mechanism in <a href="http://ocsigen.org/eliom/manual/server-services">Eliom&rsquo;s manual</a>.</p>

<h3>Sessions</h3>

<p>Eliom also offers a rich session mechanism, with scopes (see <a href="http://ocsigen.org/eliom/manual/server-state">Eliom&rsquo;s manual</a>).</p>

