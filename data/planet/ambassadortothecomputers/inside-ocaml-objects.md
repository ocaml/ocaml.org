---
title: Inside OCaml objects
description: In the ocamljs  project I wanted to implement the OCaml object system
  in a way that is interoperable with Javascript objects. Mainly I wante...
url: http://ambassadortothecomputers.blogspot.com/2010/03/inside-ocaml-objects.html
date: 2010-03-23T22:32:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>In the <a href="http://github.com/jaked/ocamljs">ocamljs</a> project I wanted to implement the OCaml object system in a way that is interoperable with Javascript objects. Mainly I wanted to be able to call Javascript methods with the OCaml method call syntax, but it is also useful to write objects in OCaml which are callable in the usual way from Javascript.</p> 
 
<p>I spent some time a few months ago figuring out how OCaml objects are put together in order to implement this (it is in the unreleased <code>ocamljs</code> trunk&mdash;new release coming soon I hope). I got a <a href="http://github.com/jaked/ocamljs/issues/issue/1">bug report</a> against it the other day, and it turns out I don&rsquo;t remember much of what I figured out. So I am going to figure it out again, and write it down, here in this very blog post!</p> 
 
<p>Objects are implemented mostly in the <code>CamlinternalOO</code> library module, with a few compiler primitives for method invocation. The compiler generates <code>CamlinternalOO</code> calls to construct classes and objects. Our main tool for figuring out what is going on is to write a test program, dump out its lambda code with <code>-dlambda</code>, and read the <code>CamlinternalOO</code> source to see what it means. I will explain functions from <a href="http://caml.inria.fr/cgi-bin/viewcvs.cgi/ocaml/trunk/stdlib/camlinternalOO.ml?rev=8768">camlinternalOO.ml</a> but not embed them in the post, so you may want it available for reference.</p> 
 
<p>I have hand-translated (apologies for any errors) the lambda code back to pseudo-OCaml to make it more readable. The compiler-generated code works directly with the OCaml <a href="http://caml.inria.fr/pub/docs/manual-ocaml/manual032.html#toc129">heap representation</a>, and generally doesn&rsquo;t fit into the OCaml type system. Where the heap representation can be translated back to an OCaml value I do that; otherwise I write blocks with array notation, and atoms with integers. Finally I have used <code>OO</code> as an abbreviation for <code>CamlinternalOO</code>.</p> 
<b>Immediate objects</b> 
<p>Here is a first test program, defining an immediate object:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">p</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">x</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">method</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">x</span> 
  <span class="k">method</span> <span class="n">move</span> <span class="n">d</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&lt;-</span> <span class="n">x</span> <span class="o">+</span> <span class="n">d</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>And this is what it compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">shared</span> <span class="o">=</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">;</span><span class="s2">&quot;get_x&quot;</span><span class="o">|]</span> 
<span class="k">let</span> <span class="n">p</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">clas</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">create_table</span> <span class="n">shared</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="n">obj_init</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">ids</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">new_methods_variables</span> <span class="n">clas</span> <span class="n">shared</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">move</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">1</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">2</span><span class="o">)</span> <span class="k">in</span> 
    <span class="nn">OO</span><span class="p">.</span><span class="n">set_methods</span> <span class="n">clas</span> <span class="o">[|</span> 
      <span class="n">get_x</span><span class="o">;</span> <span class="nn">OO</span><span class="p">.</span><span class="nc">GetVar</span><span class="o">;</span> <span class="n">x</span><span class="o">;</span> 
      <span class="n">move</span><span class="o">;</span> <span class="o">(</span><span class="k">fun</span> <span class="n">self</span> <span class="n">d</span> <span class="o">-&gt;</span> <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">+</span> <span class="n">d</span><span class="o">);</span> 
    <span class="o">|];</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">env</span> <span class="o">-&gt;</span> 
       <span class="k">let</span> <span class="n">self</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">create_object_opt</span> <span class="mi">0</span> <span class="n">clas</span> <span class="k">in</span> 
       <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="mi">0</span><span class="o">;</span> 
       <span class="n">self</span><span class="o">)</span> <span class="k">in</span> 
  <span class="nn">OO</span><span class="p">.</span><span class="n">init_class</span> <span class="n">clas</span><span class="o">;</span> 
  <span class="n">obj_init</span> <span class="mi">0</span> 
</code></pre> 
</div> 
<p>An object has a class, created with <code>create_table</code> and filled in with <code>new_methods_variables</code>, <code>set_methods</code>, and <code>init_class</code>; the object itself is created by calling <code>create_object_opt</code> with the class as argument, then initializing the instance variable.</p> 
 
<p>A table (the value representing a class) has the following fields (and some others we won&rsquo;t cover):</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">type</span> <span class="n">table</span> <span class="o">=</span> <span class="o">{</span> 
  <span class="k">mutable</span> <span class="n">size</span><span class="o">:</span> <span class="kt">int</span><span class="o">;</span> 
  <span class="k">mutable</span> <span class="n">methods</span><span class="o">:</span> <span class="n">closure</span> <span class="kt">array</span><span class="o">;</span> 
  <span class="k">mutable</span> <span class="n">methods_by_name</span><span class="o">:</span> <span class="n">meths</span><span class="o">;</span> 
  <span class="k">mutable</span> <span class="n">methods_by_label</span><span class="o">:</span> <span class="n">labs</span><span class="o">;</span> 
  <span class="k">mutable</span> <span class="n">vars</span><span class="o">:</span> <span class="n">vars</span><span class="o">;</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>Each instance variable has a slot (its index in the block which represents the object); <code>vars</code> maps variable names to slots. The <code>size</code> field records the total number of slots (including internal slots, see below).</p> 
 
<p>Each public method has a label, computed by hashing the method name. The <code>methods</code> field (used for method dispatch) holds each method of the class, with the label of the method at the following index (the type is misleading). Each method then has a slot (the index in <code>methods</code> of the method function); <code>methods_by_name</code> maps method names to slots, and the confusingly-named <code>methods_by_label</code> marks slots to whether it is occupied by a public method.</p> 
 
<p>The <code>create_table</code> call assigns slots to methods, fills in the method labels in <code>methods</code>, and sets up <code>methods_by_name</code> and <code>methods_by_label</code>. The <code>new_methods_variables</code> call returns the slot of each public method and each instance variable in a block (which is unpacked into local variables).</p> 
 
<p>The <code>set_methods</code> call sets up the method functions in <code>methods</code>. Its argument is a block containing alternating method slots and method descriptions (the description can take more than one item in the block). For some methods (e.g. <code>move</code>) the description is just an OCaml function (here you can see that <code>self</code> is passed as the first argument). For some the description is given by a value of the variant <code>OO.impl</code> along with some other arguments. For <code>get_x</code> it is <code>GetVar</code> followed by the slot for <code>x</code>. The actual function that gets the instance variable is generated by <code>set_methods</code>. As far as I understand it, the point of this is to reduce object code size by factoring out the common code from frequently occurring methods.</p> 
 
<p>Finally <code>create_object_opt</code> allocates a block of <code>clas.size</code>, then fills in the first slot with the <code>methods</code> array of the class and the second with the object&rsquo;s unique ID. (We will see below what the <code>_opt</code> part is about.)</p> 
<b>Method calls</b> 
<p>A public method call:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="n">p</span><span class="o">#</span><span class="n">get_x</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="n">send</span> <span class="n">p</span> <span class="mi">291546447</span> 
</code></pre> 
</div> 
<p>where <code>send</code> is a built-in lambda term. The number is the method label. To understand how the method is applied we have to go a little deeper. In <code>bytegen.ml</code> there is a case for <code>Lsend</code> which generates the <code>Kgetpubmet</code> bytecode instruction to find the method function; the function is then applied like any other function. Next we look to the <code>GETPUBMET</code> case in <code>interp.c</code> to see how public methods are looked up in the <code>methods</code> block (stored in the first field of the object).</p> 
 
<p>A couple details about <code>methods</code> we didn&rsquo;t cover before: The first field contains the number of public methods. The second contains a bitmask used for method caching&mdash;briefly, it is enough bits to store offsets into <code>methods</code>. The rest of the block is method functions and labels as above, padded out so that the range of an offset masked by the bitmask does not overflow the block.</p> 
 
<p>Returning to <code>GETPUBMET</code>, we first check to see if the method cache for this call site is valid. The method cache is an extra word at each call site which stores an offset into <code>methods</code> (but may be garbage&mdash;masking it takes care of this). If the method label at this offset matches the label we&rsquo;re looking for, the associated method function is returned. Otherwise, we binary search <code>methods</code> to find the method label (methods are sorted in label order in <code>transclass.ml</code>), then store the offset in the cache and return the associated method function.</p> 
<b>Classes</b> 
<p>A class definition:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">x</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">method</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">x</span> 
  <span class="k">method</span> <span class="n">move</span> <span class="n">d</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&lt;-</span> <span class="n">x</span> <span class="o">+</span> <span class="n">d</span> 
<span class="k">end</span> 
<span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="k">new</span> <span class="n">point</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">shared</span> <span class="o">=</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">;</span><span class="s2">&quot;get_x&quot;</span><span class="o">|]</span> 
<span class="k">let</span> <span class="n">point</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">ids</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">new_methods_variables</span> <span class="n">clas</span> <span class="n">shared</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">move</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">1</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">2</span><span class="o">)</span> <span class="k">in</span> 
    <span class="nn">OO</span><span class="p">.</span><span class="n">set_methods</span> <span class="n">clas</span> <span class="o">[|</span> 
      <span class="n">get_x</span><span class="o">;</span> <span class="nn">OO</span><span class="p">.</span><span class="nc">GetVar</span><span class="o">;</span> <span class="n">x</span><span class="o">;</span> 
      <span class="n">move</span><span class="o">;</span> <span class="o">(</span><span class="k">fun</span> <span class="n">self</span> <span class="n">d</span> <span class="o">-&gt;</span> <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">+</span> <span class="n">d</span><span class="o">);</span> 
    <span class="o">|];</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">env</span> <span class="n">self</span> <span class="o">-&gt;</span> 
       <span class="k">let</span> <span class="n">self</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">create_object_opt</span> <span class="n">self</span> <span class="n">clas</span> <span class="k">in</span> 
       <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="mi">0</span><span class="o">;</span> 
       <span class="n">self</span><span class="o">)</span> <span class="k">in</span> 
  <span class="nn">OO</span><span class="p">.</span><span class="n">make_class</span> <span class="n">shared</span> <span class="n">point_init</span> 
<span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="o">(</span><span class="n">point</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="mi">0</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>This is similar to the immediate object code, except that the class constructor takes the class table as an argument rather than constructing it itself, and the object constructor takes <code>self</code> as an argument. We will see that class and object constructors are each chained up the inheritance hierarchy, and the tables / objects are passed up the chain. The <code>make_class</code> call calls <code>create_table</code> and <code>init_class</code> in the same way we saw in the immediate object case, and returns a tuple, of which the first component is the object constructor. So the <code>new</code> invocation calls the constructor.</p> 
<b>Inheritance</b> 
<p>A subclass definition:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">class</span> <span class="n">point_sub</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">inherit</span> <span class="n">point</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">y</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">method</span> <span class="n">get_y</span> <span class="o">=</span> <span class="n">y</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">let</span> <span class="n">point_sub</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_sub_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">ids</span> <span class="o">=</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">new_methods_variables</span> <span class="n">clas</span> <span class="o">[|</span><span class="s2">&quot;get_y&quot;</span><span class="o">|]</span> <span class="o">[|</span><span class="s2">&quot;y&quot;</span><span class="o">|]</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">get_y</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="n">ids</span><span class="o">.(</span><span class="mi">1</span><span class="o">)</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">inh</span> <span class="o">=</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">inherits</span> 
        <span class="n">clas</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="o">[||]</span> <span class="o">[|</span><span class="s2">&quot;get_x&quot;</span><span class="o">;</span><span class="s2">&quot;move&quot;</span><span class="o">|]</span> <span class="n">point</span> <span class="bp">true</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">obj_init</span> <span class="o">=</span> <span class="n">inh</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
    <span class="nn">OO</span><span class="p">.</span><span class="n">set_methods</span> <span class="n">clas</span> <span class="o">[|</span> <span class="n">get_y</span><span class="o">;</span> <span class="nc">GetVar</span><span class="o">;</span> <span class="n">y</span> <span class="o">|];</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">env</span> <span class="n">self</span> <span class="o">-&gt;</span> 
      <span class="k">let</span> <span class="n">self'</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">create_object_opt</span> <span class="n">self</span> <span class="n">clas</span> <span class="k">in</span> 
      <span class="n">obj_init</span> <span class="n">self'</span><span class="o">;</span> 
      <span class="n">self'</span><span class="o">.(</span><span class="n">y</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="mi">0</span><span class="o">;</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">run_initializers_opt</span> <span class="n">self</span> <span class="n">self'</span> <span class="n">clas</span><span class="o">)</span> <span class="k">in</span> 
  <span class="nn">OO</span><span class="p">.</span><span class="n">make_class</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">;</span><span class="s2">&quot;get_x&quot;</span><span class="o">;</span><span class="s2">&quot;get_y&quot;</span><span class="o">|]</span> <span class="n">point_sub_init</span> 
</code></pre> 
</div> 
<p>The subclass is connected to its superclass through <code>inherits</code>, which calls the superclass constructor on the subclass (filling in <code>methods</code> with the superclass methods) and returns the superclass object constructor (and some other stuff). In the subclass object constructor, the superclass object constructor is called. (This is why the object is created optionally&mdash;the class on which <code>new</code> is invoked actually allocates the object; further superclass constructors just initialize instance variables.) In addition, we run any initializers, since some superclass may have them.</p> 
<b>Self- and super-calls</b> 
<p>A class with a self-call:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> 
<span class="k">object</span> <span class="o">(</span><span class="n">s</span><span class="o">)</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">x</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">method</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">x</span> 
  <span class="k">method</span> <span class="n">get_x5</span> <span class="o">=</span> <span class="n">s</span><span class="o">#</span><span class="n">get_x</span> <span class="o">+</span> <span class="mi">5</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>becomes:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="o">...</span> <span class="c">(* as before *)</span> 
    <span class="nn">OO</span><span class="p">.</span><span class="n">set_methods</span> <span class="n">clas</span> <span class="o">[|</span> 
      <span class="n">get_x</span><span class="o">;</span> <span class="nn">OO</span><span class="p">.</span><span class="nc">GetVar</span><span class="o">;</span> <span class="n">x</span><span class="o">;</span> 
      <span class="n">get_x5</span><span class="o">;</span> <span class="o">(</span><span class="k">fun</span> <span class="n">self</span> <span class="o">-&gt;</span> <span class="n">sendself</span> <span class="n">self</span> <span class="n">get_x</span> <span class="o">+</span> <span class="mi">5</span><span class="o">);</span> 
    <span class="o">|]</span> 
    <span class="o">...</span> 
</code></pre> 
</div> 
<p>Here <code>sendself</code> is a form of <code>Lsend</code> for self-calls, where we know the method slot at compile time. Instead of generating the <code>Kgetpubmet</code> bytecode, it generates <code>Kgetmethod</code>, which just does an array reference to find the method.</p> 
 
<p>A class with a super-call:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">class</span> <span class="n">point_sub</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">inherit</span> <span class="n">point</span> <span class="k">as</span> <span class="n">super</span> 
  <span class="k">method</span> <span class="n">move1</span> <span class="n">n</span> <span class="o">=</span> <span class="n">super</span><span class="o">#</span><span class="n">move</span> <span class="n">n</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>becomes:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">let</span> <span class="n">point_sub</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_sub_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="o">...</span> 
    <span class="k">let</span> <span class="n">inh</span> <span class="o">=</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">inherits</span> 
        <span class="n">clas</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="o">[||]</span> <span class="o">[|</span><span class="s2">&quot;get_x&quot;</span><span class="o">;</span><span class="s2">&quot;move&quot;</span><span class="o">|]</span> <span class="n">point</span> <span class="bp">true</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">move</span> <span class="o">=</span> <span class="n">inh</span><span class="o">.(</span><span class="mi">3</span><span class="o">)</span> <span class="k">in</span> 
    <span class="o">...</span> 
    <span class="nn">OO</span><span class="p">.</span><span class="n">set_methods</span> <span class="n">clas</span> <span class="o">[|</span> 
      <span class="n">move1</span><span class="o">;</span> <span class="o">(</span><span class="k">fun</span> <span class="n">self</span> <span class="n">n</span> <span class="o">-&gt;</span> <span class="n">move</span> <span class="n">self</span> <span class="n">n</span><span class="o">)</span> 
    <span class="o">|];</span> 
    <span class="o">...</span> 
</code></pre> 
</div> 
<p>In this case, we are able to look up the actual function for the super-call in the class constructor (returned from <code>inherits</code>), so the invocation is just a function application rather than a slot dereference.</p> 
 
<p>I don&rsquo;t totally understand why we don&rsquo;t know the function for self calls. I think it is because the superclass constructor runs before the subclass constructor, so the slot is assigned (this happens before the class constructors are called) but the function hasn&rsquo;t been filled in yet. Still it seems like the knot could somehow be tied at class construction time to avoid a runtime slot dereference.</p> 
<b>ocamljs implementation</b> 
<p>The main design goal is that we be able to call methods on ordinary Javascript objects with the OCaml method call syntax, simply by declaring a class type giving the signature of the object. So if you want to work with the browser DOM you can say:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="k">type</span> <span class="n">document</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">method</span> <span class="n">getElementById</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="o">#</span><span class="n">element</span> 
  <span class="o">...</span> <span class="c">(* and so on *)</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>for some appropriate <code>element</code> type (see <code>src/dom/dom.mli</code> in <code>ocamljs</code> for a full definition), and say:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="n">document</span><span class="o">#</span><span class="n">getElementById</span> <span class="s2">&quot;content&quot;</span> 
</code></pre> 
</div> 
<p>to make the call.</p> 
 
<p>These are always public method calls, so they use the <code>Lsend</code> lambda form. We don&rsquo;t want to do method label dispatch, since Javascript already has dispatch by name, so first off we need to carry the name rather than the label in <code>Lsend</code>.</p> 
 
<p>We have seen how <code>self</code> is passed as the first argument when methods are invoked. We can&rsquo;t do that for an arbitrary Javascript function, but the function might use <code>this</code>, so we need to be sure that <code>this</code> points to the object.</p> 
 
<p>There is no way to know at compile time whether a particular method invocation is on a regular Javascript object or an OCaml object. Maybe we could mark OCaml objects somehow and do a check at runtime, but I decided to stick with a single calling convention. So whatever OCaml objects compile to, they have to support the convention for regular Javascript objects&mdash;<code>foo#bar</code> compiles to <code>foo.bar</code>, with <code>this</code> set to <code>foo</code>.</p> 
 
<p>As we have seen, self-calls are compiled to a slot lookup rather than a name lookup, so we also need to support indexing into <code>methods</code>.</p> 
 
<p>So here&rsquo;s the design: an OCaml object is represented by a Javascript object, with numbered slots containing the instance variables. There is a constructor for each class, with <code>prototype</code> set up so each method is accessible by name, and the whole <code>methods</code> block is accessible in a special field, so we can call by slot. (Since we don&rsquo;t need method labels, <code>methods</code> just holds functions.)</p> 
 
<p>The calling convention passes <code>self</code> in <code>this</code>, so we bind a local <code>self</code> variable to <code>this</code> on entry to each method. It doesn&rsquo;t work to say <code>this</code> everywhere instead of <code>self</code>, because <code>this</code> in Javascript is a bit fragile. In particular, if you define and apply a local function (<code>ocamljs</code> does this frequently), <code>this</code> is null rather than the lexically-visible <code>this</code>.</p> 
 
<p>For <code>sendself</code> we look up the function by slot in the special methods field. Finally, for super-calls, we know the function at class construction time. In this case the function is applied directly, but we need to take care to treat it as a method application rather than an ordinary function call, since the calling convention is different.</p> 
<b>The bug</b> 
<p>The OCaml compiler turns super-calls into function applications very early in compilation (during typechecking in <code>typecore.ml</code>). There is no difference in calling convention for regular OCaml, so it doesn&rsquo;t matter that later phases don&rsquo;t know that these function applications are super-calls. But in our case we have to carry this information forward to the point where we generate Javascript (in <code>jsgen.ml</code>). It is a little tricky without changing the &ldquo;typedtree&rdquo; intermediate language.</p> 
 
<p>I had put in a hack to mark these applications with a special extra argument, and it worked fine for my test program, where the method had no arguments. I didn&rsquo;t think through or test the case where the method has arguments though. I was able to fix it (I think!) with a different hack: super calls are compiled to self calls (that is, to <code>Texp_send</code> with <code>Tmeth_val</code>) but the identifier in <code>Tmeth_val</code> is marked with an unused bit to indicate that it binds a function rather than a slot, so we don&rsquo;t need to dereference it.</p> 
<hr/><b>Appendix: other features</b> 
<p>It is interesting to see how the various features of the object system are implemented, but maybe not that interesting, so here they are as an appendix.</p> 
<b>Constructor parameters</b> 
<p>A class definition with a constructor parameter:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="n">x_init</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">x</span> <span class="o">=</span> <span class="n">x_init</span> 
  <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="o">...</span> <span class="c">(* as before *)</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">env</span> <span class="n">self</span> <span class="n">x_init</span> <span class="o">-&gt;</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">create_object_opt</span> <span class="n">self</span> <span class="n">clas</span><span class="o">;</span> 
      <span class="n">self</span><span class="o">.(</span><span class="n">x</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">x_init</span><span class="o">;</span> 
      <span class="n">self</span><span class="o">)</span> <span class="k">in</span> 
  <span class="o">...</span> <span class="c">(* as before *)</span> 
</code></pre> 
</div> 
<p>So the constructor parameter in the surface syntax just turns into a constructor parameter internally. (There is a slightly funny interaction between constructor parameters and <code>let</code>-bound expressions after <code>class</code> but before <code>object</code>: if there is no constructor parameter the <code>let</code> is evaluated at class construction, but if there is a parameter it is evaluated at object construction, whether or not it depends on the parameter.)</p> 
<b>Virtual methods and instance variables</b> 
<p>A class definition with a virtual method:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="k">virtual</span> <span class="n">abs_point</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">method</span> <span class="k">virtual</span> <span class="n">move</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">abs_point</span> <span class="o">=</span> <span class="o">[|</span> 
  <span class="mi">0</span><span class="o">;</span> 
  <span class="o">(</span><span class="k">fun</span> <span class="n">clas</span> <span class="o">-&gt;</span> 
    <span class="k">let</span> <span class="n">move</span> <span class="o">=</span> <span class="nn">OO</span><span class="p">.</span><span class="n">get_method_label</span> <span class="n">clas</span> <span class="s2">&quot;move&quot;</span> <span class="k">in</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">env</span> <span class="n">self</span> <span class="o">-&gt;</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">create_object_opt</span> <span class="n">self</span> <span class="n">clas</span><span class="o">);</span> 
  <span class="mi">0</span><span class="o">;</span> <span class="mi">0</span> 
<span class="o">|]</span> 
</code></pre> 
</div> 
<p>Since a virtual class can&rsquo;t be instantiated, there&rsquo;s no need to create the class table with <code>make_class</code>; we just return the tuple that represents the class, containing the class and object constructor. (I don&rsquo;t understand the call to <code>get_method_label</code>, since its value is unused; possibly it is called for its side effect, which is to register the method in the class table if it does not already exist.)</p> 
 
<p>A subclass implementing the virtual method inherits from the virtual class in the usual way.</p> 
 
<p>A class declaration with a virtual instance variable:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="k">virtual</span> <span class="n">abs_point2</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="k">virtual</span> <span class="n">x</span> <span class="o">:</span> <span class="kt">int</span> 
  <span class="k">method</span> <span class="n">move</span> <span class="n">d</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&lt;-</span> <span class="n">x</span> <span class="o">+</span> <span class="n">d</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>becomes:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">abs_point</span> <span class="o">=</span> <span class="o">[|</span> 
  <span class="mi">0</span><span class="o">;</span> 
  <span class="o">(</span><span class="k">fun</span> <span class="n">clas</span> 
    <span class="k">let</span> <span class="n">ids</span> <span class="o">=</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">new_methods_variables</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">|]</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="k">in</span> 
    <span class="o">...</span> <span class="c">(* as before *)</span><span class="o">);</span> 
  <span class="mi">0</span><span class="o">;</span> <span class="mi">0</span> 
<span class="o">|]</span> 
</code></pre> 
</div> 
<p>Again, a subclass providing the instance variable inherits from the virtual class in the usual way. By the time <code>new_methods_variables</code> is called in the superclass, the subclass has registered a slot for the variable.</p> 
<b>Private methods</b> 
<p>A class definition with a private method:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">val</span> <span class="k">mutable</span> <span class="n">x</span> <span class="o">=</span> <span class="mi">0</span> 
  <span class="k">method</span> <span class="n">get_x</span> <span class="o">=</span> <span class="n">x</span> 
  <span class="k">method</span> <span class="k">private</span> <span class="n">move</span> <span class="n">d</span> <span class="o">=</span> <span class="n">x</span> <span class="o">&lt;-</span> <span class="n">x</span> <span class="o">+</span> <span class="n">d</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>compiles to:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_init</span> <span class="n">clas</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">ids</span> <span class="o">=</span> 
      <span class="nn">OO</span><span class="p">.</span><span class="n">new_methods_variables</span> <span class="n">clas</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">;</span><span class="s2">&quot;get_x&quot;</span><span class="o">|]</span> <span class="o">[|</span><span class="s2">&quot;x&quot;</span><span class="o">|]</span> <span class="k">in</span> 
    <span class="o">...</span> <span class="c">(* as before *)</span> 
  <span class="nn">OO</span><span class="p">.</span><span class="n">make_class</span> <span class="o">[|</span><span class="s2">&quot;get_x&quot;</span><span class="o">|]</span> <span class="n">point_init</span> 
</code></pre> 
</div> 
<p>Everything is the same except that the private method is not listed in the public methods of the class. Since a private method is callable only from code in which the class of the object is statically known, there is no need for dispatch or a method label. The private method functions are stored in <code>methods</code> after the public methods and method labels.</p> 
 
<p>If we expose a private method in a subclass:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">class</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">class</span> <span class="n">point_sub</span> <span class="o">=</span> 
<span class="k">object</span> 
  <span class="k">inherit</span> <span class="n">point</span> 
  <span class="k">method</span> <span class="k">virtual</span> <span class="n">move</span> <span class="o">:</span> <span class="o">_</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>we get:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">point</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
<span class="k">let</span> <span class="n">point_sub</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="n">point_sub_init</span> <span class="n">clas</span> <span class="o">=</span> <span class="o">...</span> <span class="c">(* as before *)</span> 
  <span class="nn">OO</span><span class="p">.</span><span class="n">make_class</span> <span class="o">[|</span><span class="s2">&quot;move&quot;</span><span class="o">;</span><span class="s2">&quot;get_x&quot;</span><span class="o">|]</span> <span class="n">point_sub_init</span> 
</code></pre> 
</div> 
<p>Putting <code>&quot;move&quot;</code> in the call to <code>make_class</code> registers it as a public method, so later, when <code>set_method</code> is called for <code>move</code> in the superclass constructor, it puts the method and its label in <code>methods</code> for dispatch.</p>
