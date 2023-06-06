---
title: 'TodoMVC: a reactive version'
description:
url: https://ocsigen.github.io/blog/2015/10/07/react-example-todomvc/
date: 2015-10-07T00:00:00-00:00
preview_image:
featured:
authors:
- "St\xE9phane Legrand"
---

<p><a href="http://todomvc.com/">TodoMVC</a> is a project which offers the same Todo
application implemented using <a href="https://en.wikipedia.org/wiki/Model-view-controller">MV*</a> concepts in most of the
popular JavaScript MV* frameworks. One of the aims of TodoMVC is to
enable a fair comparison between several frameworks, by providing
implementations of the same application. A <a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml (JSOO)</a>
version is now available:</p>

<ul>
  <li><a href="https://github.com/slegrand45/examples_ocsigen/tree/master/jsoo/todomvc-react">Source code</a></li>
  <li><a href="http://slegrand45.github.io/examples_ocsigen.site/jsoo/todomvc-react/">Demo</a></li>
</ul>

<p>Our version is powered by the <a href="http://erratique.ch/software/react"><code class="language-plaintext highlighter-rouge">React</code></a> module for <a href="https://en.wikipedia.org/wiki/Functional_reactive_programming">functional
reactive programming (FRP)</a>.</p>

<p>In this post, we outline the architecture of our implementation, with
a particular emphasis on how it applies MVC and FRP concepts.</p>

<h2>MVC</h2>

<p><a href="https://en.wikipedia.org/wiki/Model-view-controller">MVC</a>, which stands for <em>Model-View-Controller</em>, is a software
architecture very commonly used for implementing user interfaces. MVC
divides an application into three components:</p>

<ul>
  <li>
    <p>the <em>Model</em> manages the data, logic and rules of the application;</p>
  </li>
  <li>
    <p>the <em>Controller</em> manages events from the view, and accordingly
updates the model;</p>
  </li>
  <li>
    <p>the <em>View</em> generates an output presentation (a web page for
instance) based on the model data.</p>
  </li>
</ul>

<p>For the Todo application, we have three corresponding OCaml
modules. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L38"><code class="language-plaintext highlighter-rouge">Model</code></a> mainly contains the task list and the new
task field value. It uses <a href="https://ocsigen.org/js_of_ocaml/api/Deriving_Json"><code class="language-plaintext highlighter-rouge">Deriving_Json</code></a> to convert
the data to JSON and vice versa, in order to be able to save and
restore the application state. This module is otherwise written with
basic OCaml code. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L111"><code class="language-plaintext highlighter-rouge">Controller</code></a> produces new models
according to the actions it receives. Whenever a new model is built,
the model becomes the new reactive signal value. We will elaborate on
this point later. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L175"><code class="language-plaintext highlighter-rouge">View</code></a> builds the HTML to display the
page. It receives as input the dynamic data from the model. The HTML
also contains the event management code needed to emit the
corresponding actions.</p>

<p>Besides these three MVC modules, the application uses three
helpers. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L14"><code class="language-plaintext highlighter-rouge">Storage</code></a>
contains the functions to read and write a string value in the browser
local storage. This module is used to save and restore the application
data in JSON
format. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L94"><code class="language-plaintext highlighter-rouge">Action</code></a>
contains all the actions available from the user
interface. <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L3"><code class="language-plaintext highlighter-rouge">ReactList</code></a>
contains a single function to ease the creation of a reactive list via
the <a href="https://github.com/hhugo/reactiveData"><code class="language-plaintext highlighter-rouge">ReactiveData</code> library</a>.</p>

<h2>React</h2>

<p><a href="http://erratique.ch/software/react">React</a> is an OCaml module for <a href="https://en.wikipedia.org/wiki/Functional_reactive_programming">functional reactive programming
(FRP)</a>. In our TodoMVC example, <code class="language-plaintext highlighter-rouge">React</code> provides a way to
automatically refresh the view whenever a new model is built by the
controller. To achieve this goal, the application uses a reactive
signal which carries the model values (which vary over time). The
model value may initially be equal to the <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L60-L65">empty model</a>. When
this value is modified by the controller, <em>i.e.,</em> after a new model
has been generated, the view automatically refreshes its reactive
parts.</p>

<h2>Mixing MVC and FRP</h2>

<p>The following figure shows what happens when the user interacts with
the application, <em>e.g.,</em> by adding a new task, or by clicking on a
checkbox to select a specific task:</p>

<p><img src="https://ocsigen.org/img/posts/2015/react-example-todomvc-steps.png" alt="MVC with `React`"/></p>

<ol>
  <li>
    <p>the view sends the action to the controller;</p>
  </li>
  <li>
    <p>the controller gets the current model from the reactive signal, and
builds a new model accordingly to the action;</p>
  </li>
  <li>
    <p>the controller sets this new model as the new reactive signal
value;</p>
  </li>
  <li>
    <p>the view reacts to the newly-available model (new signal value) and
updates itself with the corresponding data.</p>
  </li>
</ol>

<p>We proceed to describe our implementation of the above scheme, with an
emphasis on the reactive features.</p>

<h3>Initialization</h3>

<p>The <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L393">main function</a> creates the reactive signal with an initial
(possibly empty) model. The <code class="language-plaintext highlighter-rouge">m</code> value is of type <code class="language-plaintext highlighter-rouge">Model.t</code>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">rp</span> <span class="o">=</span> <span class="nn">React</span><span class="p">.</span><span class="nn">S</span><span class="p">.</span><span class="n">create</span> <span class="n">m</span> <span class="k">in</span> <span class="c">(* ... *)</span></code></pre></figure>

<p><code class="language-plaintext highlighter-rouge">React.S.create</code> returns a tuple, the first part of which is a
primitive signal; the second part is a function used by the controller
<a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L170">to set a new model as the new signal value</a>.</p>

<h3>Reactive attribute</h3>

<p>We first explain how the CSS style of a HTML node <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L267-L299">becomes
reactive</a>. In the Todo application, the task list is
displayed in a <code class="language-plaintext highlighter-rouge">&lt;section&gt;</code> HTML tag. The CSS style of this HTML node
must contain <code class="language-plaintext highlighter-rouge">visibility: hidden;</code> if the tasks list is empty, and
<code class="language-plaintext highlighter-rouge">visibility: visible;</code> otherwise (<em>i.e.,</em> if the number of tasks is
greater than zero). The style attribute of this <code class="language-plaintext highlighter-rouge">&lt;section&gt;</code> node must
therefore change according to the model content:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="nn">R</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="n">a_style</span> <span class="p">(</span><span class="nn">React</span><span class="p">.</span><span class="nn">S</span><span class="p">.</span><span class="n">map</span> <span class="n">css_visibility</span> <span class="n">r</span><span class="p">)</span></code></pre></figure>

<p>We use the <a href="https://ocsigen.org/js_of_ocaml/api/Tyxml_js"><code class="language-plaintext highlighter-rouge">Tyxml_js</code></a> module to safely build the HTML
code. The first thing to note is that we use the reactive <code class="language-plaintext highlighter-rouge">R.Html5</code>
submodule, not the plain <code class="language-plaintext highlighter-rouge">Html5</code> submodule. The <code class="language-plaintext highlighter-rouge">a_style</code> function
implements a reactive attribute; it expects a reactive signal as its
argument. Here we use <code class="language-plaintext highlighter-rouge">React.S.map</code>, which has the signature <code class="language-plaintext highlighter-rouge">('a -&gt;
'b) -&gt; 'a React.signal -&gt; 'b React.signal</code>. The first argument to
<code class="language-plaintext highlighter-rouge">map</code> is the <code class="language-plaintext highlighter-rouge">css_visibility</code> function:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">css_visibility</span> <span class="n">m</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">tasks</span> <span class="o">=</span> <span class="n">m</span><span class="o">.</span><span class="nn">Model</span><span class="p">.</span><span class="n">tasks</span> <span class="k">in</span>
  <span class="k">match</span> <span class="n">tasks</span> <span class="k">with</span>
  <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="s2">&quot;visibility: hidden;&quot;</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="s2">&quot;visibility: visible;&quot;</span></code></pre></figure>

<p>As you can see, <code class="language-plaintext highlighter-rouge">css_visibility</code> receives a model <code class="language-plaintext highlighter-rouge">m</code> as its
argument. When wrapped by <code class="language-plaintext highlighter-rouge">React.S.map</code> as above, <code class="language-plaintext highlighter-rouge">css_visibility</code>
operates on signals. The function returns the right style, depending
on whether the list of tasks is empty or not.</p>

<p>The second argument to <code class="language-plaintext highlighter-rouge">React.S.map</code> is the value named <code class="language-plaintext highlighter-rouge">r</code>, which is
the primitive signal. <code class="language-plaintext highlighter-rouge">r</code> is the first value returned by the
<code class="language-plaintext highlighter-rouge">React.S.create</code> function.</p>

<p>Each time the signal value gets updated by the controller, the
<code class="language-plaintext highlighter-rouge">css_visibility</code> function is automatically called with the new signal
value (a new model) as its argument, and the style attribute is
automatically modified.</p>

<h3>Reactive list</h3>

<p>Reactive attributes alone would not suffice to build a user
interface. We also need a reactive list of child nodes. Such a list is
for example needed to display the task list. (<a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L267-L299">The source code section
is the same as for the first
example.</a>) It
is a list of <code class="language-plaintext highlighter-rouge">&lt;li&gt;</code> nodes contained in a <code class="language-plaintext highlighter-rouge">&lt;ul&gt;</code> node. We accordingly
have a reactive node, as follows:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="nn">R</span><span class="p">.</span><span class="nn">Html5</span><span class="p">.</span><span class="n">ul</span> <span class="o">~</span><span class="n">a</span><span class="o">:</span><span class="p">[</span><span class="n">a_class</span> <span class="p">[</span><span class="s2">&quot;todo-list&quot;</span><span class="p">]]</span> <span class="n">rl</span></code></pre></figure>

<p>As before, we use the <code class="language-plaintext highlighter-rouge">R.Html5</code> module. This time we do not use
<code class="language-plaintext highlighter-rouge">R.Html5</code> to build an attribute, but rather a (<code class="language-plaintext highlighter-rouge">&lt;ul&gt;</code>) node. <code class="language-plaintext highlighter-rouge">rl</code>
contains the node&rsquo;s children:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">rl</span> <span class="o">=</span> <span class="nn">ReactList</span><span class="p">.</span><span class="n">list</span> <span class="p">(</span><span class="nn">React</span><span class="p">.</span><span class="nn">S</span><span class="p">.</span><span class="n">map</span> <span class="n">visible_tasks</span> <span class="n">r</span><span class="p">)</span></code></pre></figure>

<p>We create the reactive list via the helper module
<a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L3">ReactList</a>. As for the previous example, we use
<code class="language-plaintext highlighter-rouge">React.S.map</code> to build a reactive signal, <code class="language-plaintext highlighter-rouge">r</code> being again the
primitive signal. The <code class="language-plaintext highlighter-rouge">visible_tasks</code> function generates the <code class="language-plaintext highlighter-rouge">&lt;li&gt;</code>
elements from the task list, filtered by the current selected
visibility:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">visible_tasks</span> <span class="n">m</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">visibility</span> <span class="o">=</span> <span class="n">m</span><span class="o">.</span><span class="nn">Model</span><span class="p">.</span><span class="n">visibility</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">is_visible</span> <span class="n">todo</span> <span class="o">=</span>
    <span class="k">match</span> <span class="n">visibility</span> <span class="k">with</span>
    <span class="o">|</span> <span class="nn">Model</span><span class="p">.</span><span class="nc">Completed</span> <span class="o">-&gt;</span> <span class="n">todo</span><span class="o">.</span><span class="nn">Model</span><span class="p">.</span><span class="n">completed</span>
    <span class="o">|</span> <span class="nc">Active</span> <span class="o">-&gt;</span> <span class="n">not</span> <span class="n">todo</span><span class="o">.</span><span class="n">completed</span>
    <span class="o">|</span> <span class="nc">All</span> <span class="o">-&gt;</span> <span class="bp">true</span>
  <span class="k">in</span>
  <span class="k">let</span> <span class="n">tasks</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">filter</span> <span class="n">is_visible</span> <span class="n">m</span><span class="o">.</span><span class="nn">Model</span><span class="p">.</span><span class="n">tasks</span> <span class="k">in</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">rev</span> <span class="p">(</span><span class="nn">List</span><span class="p">.</span><span class="n">fold_left</span> <span class="p">(</span><span class="n">todo_item</span> <span class="p">(</span><span class="n">r</span><span class="o">,</span> <span class="n">f</span><span class="p">))</span> <span class="bp">[]</span> <span class="n">tasks</span><span class="p">)</span></code></pre></figure>

<p>Following the same principle as for the reactive attribute, each time
the signal value gets updated by the controller, the <code class="language-plaintext highlighter-rouge">&lt;li&gt;</code> nodes are
automatically refreshed.</p>

<h3>Signal typing</h3>

<p>You may have noticed that the code <a href="https://github.com/slegrand45/examples_ocsigen/blob/d6766d404a449d0b1d36ad3cd916b0c444390a19/jsoo/todomvc-react/todomvc.ml#L89-L91">includes the following
types</a>:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">type</span> <span class="n">rs</span> <span class="o">=</span> <span class="nn">Model</span><span class="p">.</span><span class="n">t</span> <span class="nn">React</span><span class="p">.</span><span class="n">signal</span>
<span class="k">type</span> <span class="n">rf</span> <span class="o">=</span> <span class="o">?</span><span class="n">step</span><span class="o">:</span><span class="nn">React</span><span class="p">.</span><span class="n">step</span> <span class="o">-&gt;</span> <span class="nn">Model</span><span class="p">.</span><span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">type</span> <span class="n">rp</span> <span class="o">=</span> <span class="n">rs</span> <span class="o">*</span> <span class="n">rf</span></code></pre></figure>

<p>These types are used whenever type annotations are required, <em>e.g.,</em>
for the <code class="language-plaintext highlighter-rouge">update</code> function from the <code class="language-plaintext highlighter-rouge">Controller</code> module:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">update</span> <span class="n">a</span> <span class="p">((</span><span class="n">r</span><span class="o">,</span> <span class="n">f</span><span class="p">)</span> <span class="o">:</span> <span class="n">rp</span><span class="p">)</span> <span class="o">=</span> <span class="c">(* ... *)</span></code></pre></figure>

<h2>Comparison with the Elm implementation</h2>

<p><a href="http://elm-lang.org/">Elm</a> is a functional programming language
dedicated to frontend web application development. Elm was designed by
Evan Czaplicki. The language should feel familiar to OCaml
programmers.</p>

<p>Our TodoMVC example is based on the <a href="https://github.com/evancz/elm-todomvc">Elm
implementation</a>, which follows
the structure used in <a href="https://github.com/evancz/elm-architecture-tutorial/">all Elm
programs</a>: a
model, an update function, and a view. Like Elm, our example uses the
functional reactive programming style, enabled in our case by the
<code class="language-plaintext highlighter-rouge">React</code> library and the reactive modules <code class="language-plaintext highlighter-rouge">Tyxml_js.R</code> and
<code class="language-plaintext highlighter-rouge">ReactiveData</code>.</p>

<h2>Conclusion</h2>

<p>The combination of OCaml, js_of_ocaml, and functional reactive
programming provides a killer feature combination for building rich
web clients. Additionally, OCaml static typing can provide
compile-time HTML validity checking (via TyXML), thus increasing
reliability.</p>


