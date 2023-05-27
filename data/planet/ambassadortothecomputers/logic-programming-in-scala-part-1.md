---
title: Logic programming in Scala, part 1
description: I got a new job where I am hacking some Scala. I thought I would learn
  something by translating some functional code into Scala, and a frien...
url: http://ambassadortothecomputers.blogspot.com/2011/04/logic-programming-in-scala-part-1.html
date: 2011-04-07T05:03:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>I got a new job where I am hacking some Scala. I thought I would learn something by translating some functional code into Scala, and a friend had recently pointed me to Kiselyov et al.&rsquo;s <a href="http://okmij.org/ftp/Computation/LogicT.pdf">Backtracking, Interleaving, and Terminating Monad Transformers</a>, which provides a foundation for Prolog-style logic programming. Of course, a good translation should use the local idiom. So in this post (and the next) I want to explore an embedded domain-specific language for logic programming in Scala.</p> 
<b>A search problem</b> 
<p>Here is a problem I sometimes give in interviews:</p> 
 
<blockquote> 
<p>Four people need to cross a rickety bridge, which can hold only two people at a time. It&rsquo;s a moonless night, so they need a light to cross; they have one flashlight with a battery which lasts 60 minutes. Each person crosses the bridge at a different speed: Alice takes 5 minutes, Bob takes 10, Candace takes 20 minutes, and Dave 25. How do they get across?</p> 
</blockquote> 
 
<p>I&rsquo;m not interested in the answer&mdash;I&rsquo;m interviewing programmers, not law school applicants&mdash;but rather in how to write a program to find the answer.</p> 
 
<p>The basic shape of the solution is to represent the state of the world (where are the people, where is the flashlight, how much battery is left), write a function to compute from any particular state the set of possible next states, then search for an answer (a path from the start state to the final state) in the tree formed by applying the next state function transitively to the start state. (<a href="http://web.engr.oregonstate.edu/~erwig/papers/Zurg_JFP04.pdf">Here is a paper</a> describing solutions in Prolog and Haskell.)</p> 
 
<p>Here is a first solution in Scala:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">object</span> <span class="nc">Bridge0</span> <span class="o">{</span> 
  <span class="k">object</span> <span class="nc">Person</span> <span class="k">extends</span> <span class="nc">Enumeration</span> <span class="o">{</span> 
    <span class="k">type</span> <span class="kt">Person</span> <span class="o">=</span> <span class="nc">Value</span> 
    <span class="k">val</span> <span class="nc">Alice</span><span class="o">,</span> <span class="nc">Bob</span><span class="o">,</span> <span class="nc">Candace</span><span class="o">,</span> <span class="nc">Dave</span> <span class="k">=</span> <span class="nc">Value</span> 
    <span class="k">val</span> <span class="n">all</span> <span class="k">=</span> <span class="nc">List</span><span class="o">(</span><span class="nc">Alice</span><span class="o">,</span> <span class="nc">Bob</span><span class="o">,</span> <span class="nc">Candace</span><span class="o">,</span> <span class="nc">Dave</span><span class="o">)</span> <span class="c1">// values is broken</span> 
  <span class="o">}</span> 
  <span class="k">import</span> <span class="nn">Person._</span> 
 
  <span class="k">val</span> <span class="n">times</span> <span class="k">=</span> <span class="nc">Map</span><span class="o">(</span><span class="nc">Alice</span> <span class="o">-&gt;</span> <span class="mi">5</span><span class="o">,</span> <span class="nc">Bob</span> <span class="o">-&gt;</span> <span class="mi">10</span><span class="o">,</span> <span class="nc">Candace</span> <span class="o">-&gt;</span> <span class="mi">20</span><span class="o">,</span> <span class="nc">Dave</span> <span class="o">-&gt;</span> <span class="mi">25</span><span class="o">)</span> 
 
  <span class="k">case</span> <span class="k">class</span> <span class="nc">State</span><span class="o">(</span><span class="n">left</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">Person</span><span class="o">],</span> 
                   <span class="n">lightOnLeft</span><span class="k">:</span> <span class="kt">Boolean</span><span class="o">,</span> 
                   <span class="n">timeRemaining</span><span class="k">:</span> <span class="kt">Int</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>We define an enumeration of people (the <code>Enumeration</code> class is a <a href="https://lampsvn.epfl.ch/trac/scala/ticket/3687">bit broken</a> in Scala 2.8.1), a map of the time each takes to cross, and a case class to store the state of the world: the list of people on the left side of the bridge (the right side is just the complement); whether the flashlight is on the left; and how much time remains in the flashlight.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">chooseTwo</span><span class="o">(</span><span class="n">list</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">Person</span><span class="o">])</span><span class="k">:</span> <span class="kt">List</span><span class="o">[(</span><span class="kt">Person</span>,<span class="kt">Person</span><span class="o">)]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">val</span> <span class="n">init</span><span class="k">:</span> <span class="kt">List</span><span class="o">[(</span><span class="kt">Person</span>, <span class="kt">Person</span><span class="o">)]</span> <span class="k">=</span> <span class="nc">Nil</span> 
    <span class="n">list</span><span class="o">.</span><span class="n">foldLeft</span><span class="o">(</span><span class="n">init</span><span class="o">)</span> <span class="o">{</span> <span class="o">(</span><span class="n">pairs</span><span class="o">,</span> <span class="n">p1</span><span class="o">)</span> <span class="k">=&gt;</span> 
      <span class="n">list</span><span class="o">.</span><span class="n">foldLeft</span><span class="o">(</span><span class="n">pairs</span><span class="o">)</span> <span class="o">{</span> <span class="o">(</span><span class="n">pairs</span><span class="o">,</span> <span class="n">p2</span><span class="o">)</span> <span class="k">=&gt;</span> 
        <span class="k">if</span> <span class="o">(</span><span class="n">p1</span> <span class="o">&lt;</span> <span class="n">p2</span><span class="o">)</span> <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">)</span> <span class="o">::</span> <span class="n">pairs</span> <span class="k">else</span> <span class="n">pairs</span> 
      <span class="o">}</span> 
    <span class="o">}</span> 
  <span class="o">}</span> 
</code></pre> 
</div> 
<p>This function returns the list of pairs of people from the input list. We use <code>foldLeft</code> to do a double loop over the input list, accumulating pairs <code>(p1, p2)</code> where <code>p1 &lt; p2</code>; this avoids returning <code>(Alice, Bob)</code> and also <code>(Bob, Alice)</code>. The use of <code>foldLeft</code> is rather OCamlish, and if you know Scala you will complain that <code>foldLeft</code> is not idiomatic&mdash;we will repair this shortly.</p> 
 
<p>In Scala, <code>Nil</code> doesn&rsquo;t have type <code>'a list</code> like in OCaml and Haskell, but rather <code>List[Nothing]</code>. The way local type inference works, the type variable in the type of <code>foldLeft</code> is instantiated with the type of the <code>init</code> argument, so you have to ascribe a type to <code>init</code> (or explicitly instantiate the type variable with <code>foldLeft[List[(Person,
Person)]]</code>) or else you get a type clash between <code>List[Nothing]</code> and <code>List[(Person, Person)]</code>.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">next</span><span class="o">(</span><span class="n">state</span><span class="k">:</span> <span class="kt">State</span><span class="o">)</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">if</span> <span class="o">(</span><span class="n">state</span><span class="o">.</span><span class="n">lightOnLeft</span><span class="o">)</span> <span class="o">{</span> 
      <span class="k">val</span> <span class="n">init</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]</span> <span class="k">=</span> <span class="nc">Nil</span> 
      <span class="n">chooseTwo</span><span class="o">(</span><span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">).</span><span class="n">foldLeft</span><span class="o">(</span><span class="n">init</span><span class="o">)</span> <span class="o">{</span> 
        <span class="k">case</span> <span class="o">(</span><span class="n">states</span><span class="o">,</span> <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">))</span> <span class="k">=&gt;</span> 
          <span class="k">val</span> <span class="n">timeRemaining</span> <span class="k">=</span> 
            <span class="n">state</span><span class="o">.</span><span class="n">timeRemaining</span> <span class="o">-</span> <span class="n">math</span><span class="o">.</span><span class="n">max</span><span class="o">(</span><span class="n">times</span><span class="o">(</span><span class="n">p1</span><span class="o">),</span> <span class="n">times</span><span class="o">(</span><span class="n">p2</span><span class="o">))</span> 
          <span class="k">if</span> <span class="o">(</span><span class="n">timeRemaining</span> <span class="o">&gt;=</span> <span class="mi">0</span><span class="o">)</span> <span class="o">{</span> 
            <span class="k">val</span> <span class="n">left</span> <span class="k">=</span> 
              <span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">.</span><span class="n">filterNot</span> <span class="o">{</span> <span class="n">p</span> <span class="k">=&gt;</span> <span class="n">p</span> <span class="o">==</span> <span class="n">p1</span> <span class="o">||</span> <span class="n">p</span> <span class="o">==</span> <span class="n">p2</span> <span class="o">}</span> 
            <span class="nc">State</span><span class="o">(</span><span class="n">left</span><span class="o">,</span> <span class="kc">false</span><span class="o">,</span> <span class="n">timeRemaining</span><span class="o">)</span> <span class="o">::</span> <span class="n">states</span> 
          <span class="o">}</span> 
          <span class="k">else</span> 
            <span class="n">states</span> 
      <span class="o">}</span> 
    <span class="o">}</span> <span class="k">else</span> <span class="o">{</span> 
      <span class="k">val</span> <span class="n">right</span> <span class="k">=</span> <span class="nc">Person</span><span class="o">.</span><span class="n">all</span><span class="o">.</span><span class="n">filterNot</span><span class="o">(</span><span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">.</span><span class="n">contains</span><span class="o">)</span> 
      <span class="k">val</span> <span class="n">init</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]</span> <span class="k">=</span> <span class="nc">Nil</span> 
      <span class="n">right</span><span class="o">.</span><span class="n">foldLeft</span><span class="o">(</span><span class="n">init</span><span class="o">)</span> <span class="o">{</span> <span class="o">(</span><span class="n">states</span><span class="o">,</span> <span class="n">p</span><span class="o">)</span> <span class="k">=&gt;</span> 
        <span class="k">val</span> <span class="n">timeRemaining</span> <span class="k">=</span> <span class="n">state</span><span class="o">.</span><span class="n">timeRemaining</span> <span class="o">-</span> <span class="n">times</span><span class="o">(</span><span class="n">p</span><span class="o">)</span> 
        <span class="k">if</span> <span class="o">(</span><span class="n">timeRemaining</span> <span class="o">&gt;=</span> <span class="mi">0</span><span class="o">)</span> 
          <span class="nc">State</span><span class="o">(</span><span class="n">p</span> <span class="o">::</span> <span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">,</span> <span class="kc">true</span><span class="o">,</span> <span class="n">timeRemaining</span><span class="o">)</span> <span class="o">::</span> <span class="n">states</span> 
        <span class="k">else</span> 
          <span class="n">states</span> 
      <span class="o">}</span> 
    <span class="o">}</span> 
  <span class="o">}</span> 
</code></pre> 
</div> 
<p>Here we compute the set of successor states for a state. We make a heuristic simplification: when the flashlight is on the left (the side where everyone begins) we move two people from the left to the right; when it is on the right we move only one. I don&rsquo;t have a proof that an answer must take this form, but I believe it, and it makes the code shorter.</p> 
 
<p>So when the light is on the left we fold over all the pairs of people still on the left, compute the time remaining if they were to cross, and if it is not negative build a new state where they and the flashlight are moved to the right and the time remaining updated.</p> 
 
<p>If the light is on the right we do the same in reverse, but choose only one person to move.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">tree</span><span class="o">(</span><span class="n">path</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">])</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]]</span> <span class="k">=</span> 
    <span class="n">next</span><span class="o">(</span><span class="n">path</span><span class="o">.</span><span class="n">head</span><span class="o">).</span> 
      <span class="n">map</span><span class="o">(</span><span class="n">s</span> <span class="k">=&gt;</span> <span class="n">tree</span><span class="o">(</span><span class="n">s</span> <span class="o">::</span> <span class="n">path</span><span class="o">)).</span> 
        <span class="n">foldLeft</span><span class="o">(</span><span class="nc">List</span><span class="o">(</span><span class="n">path</span><span class="o">))</span> <span class="o">{</span> <span class="k">_</span> <span class="o">++</span> <span class="k">_</span> <span class="o">}</span> 
 
  <span class="k">def</span> <span class="n">search</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">val</span> <span class="n">start</span> <span class="k">=</span> <span class="nc">List</span><span class="o">(</span><span class="nc">State</span><span class="o">(</span><span class="nc">Person</span><span class="o">.</span><span class="n">all</span><span class="o">,</span> <span class="kc">true</span><span class="o">,</span> <span class="mi">60</span><span class="o">))</span> 
    <span class="n">tree</span><span class="o">(</span><span class="n">start</span><span class="o">).</span><span class="n">filter</span> <span class="o">{</span> <span class="n">_</span><span class="o">.</span><span class="n">head</span><span class="o">.</span><span class="n">left</span> <span class="o">==</span> <span class="nc">Nil</span> <span class="o">}</span> 
  <span class="o">}</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>A list of successive states is a <em>path</em> (with the starting state at the end and the most recent state at the beginning); the state tree is a set of paths. The tree rooted at a path is the set of paths with the input path as a suffix. To compute this tree, we find the successor states of the head of the path, augment the path with each state in turn, recursively find the tree rooted at each augmented path, then append them all (including the input path).</p> 
 
<p>Then to find an answer, we generate the state tree rooted at the path consisting only of the start state (everybody and the flashlight on the left, 60 minutes remaining on the light), then filter out the paths which end in a final state (everybody on the right).</p> 
<b>For-comprehensions</b> 
<p>To make the code above more idiomatic Scala (and more readable), we would of course use for-comprehensions, for example:</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">chooseTwo</span><span class="o">(</span><span class="n">list</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">Person</span><span class="o">])</span><span class="k">:</span> <span class="kt">List</span><span class="o">[(</span><span class="kt">Person</span>,<span class="kt">Person</span><span class="o">)]</span> <span class="k">=</span> 
    <span class="k">for</span> <span class="o">{</span> <span class="n">p1</span> <span class="k">&lt;-</span> <span class="n">list</span><span class="o">;</span> <span class="n">p2</span> <span class="k">&lt;-</span> <span class="n">list</span><span class="o">;</span> <span class="k">if</span> <span class="n">p1</span> <span class="o">&lt;</span> <span class="n">p2</span> <span class="o">}</span> <span class="k">yield</span> <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>Just as before, we do a double loop over the input list, returning pairs where <code>p1 &lt; p2</code>. (However, under the hood the result list is constructed by appending to a <code>ListBuffer</code> rather than with <code>::</code>, so the pairs are returned in the reverse order.)</p> 
 
<p>The for-comprehension syntax isn&rsquo;t specific to lists. It&rsquo;s syntactic sugar which translates to method calls, so we can use it on any objects which implement the right methods. The methods we need are</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">filter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">map</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">B</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">flatMap</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">B</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">withFilter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
</code></pre> 
</div> 
<p>where <code>T</code> is some type constructor, like <code>List</code>. For <code>List</code>, <code>filter</code> and <code>map</code> have their ordinary meaning, and <code>flatMap</code> is a <code>map</code> (where the result type must be a list) which concatenates the resulting lists (that is, it flattens the list of lists).</p> 
 
<p><code>WithFilter</code> is like <code>filter</code> but should be implemented as a &ldquo;virtual&rdquo; filter for efficiency&mdash;for <code>List</code> it doesn&rsquo;t build a new filtered list, but instead just keeps track of the filter function; this way multiple adjacent filters can be combined and the result produced with a single pass over the list.</p> 
 
<p>The details of the translation are in the <a href="http://www.scala-lang.org/docu/files/ScalaReference.pdf">Scala reference manual</a>, section 6.19. Roughly speaking, <code>&lt;-</code> becomes <code>flatMap</code>, <code>if</code> becomes <code>filter</code>, and <code>yield</code> becomes <code>map</code>. So another way to write <code>chooseTwo</code> is:</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">chooseTwo</span><span class="o">(</span><span class="n">list</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">Person</span><span class="o">])</span><span class="k">:</span> <span class="kt">List</span><span class="o">[(</span><span class="kt">Person</span>,<span class="kt">Person</span><span class="o">)]</span> <span class="k">=</span> 
    <span class="n">list</span><span class="o">.</span><span class="n">flatMap</span><span class="o">(</span><span class="n">p1</span> <span class="k">=&gt;</span> 
      <span class="n">list</span><span class="o">.</span><span class="n">filter</span><span class="o">(</span><span class="n">p2</span> <span class="k">=&gt;</span> <span class="n">p1</span> <span class="o">&lt;</span> <span class="n">p2</span><span class="o">).</span><span class="n">map</span><span class="o">(</span><span class="n">p2</span> <span class="k">=&gt;</span> <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">)))</span> 
</code></pre> 
</div><b>The logic monad</b> 
<p>So far we have taken a concrete view of the choices that arise in searching the state tree, by representing a choice among alternatives as a list. For example, in the <code>chooseTwo</code> function we returned a list of alternative pairs. I want now to take a more abstract view, and define an abstract type <code>T[A]</code> to represent a choice among alternatives of type <code>A</code>, along with operations on the type, packaged into a trait:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">trait</span> <span class="nc">Logic</span> <span class="o">{</span> <span class="n">L</span> <span class="k">=&gt;</span> 
  <span class="k">type</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
 
  <span class="k">def</span> <span class="n">fail</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">unit</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">a</span><span class="k">:</span> <span class="kt">A</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">or</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t1</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">t2</span><span class="k">:</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">apply</span><span class="o">[</span><span class="kt">A</span>,<span class="kt">B</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">B</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">bind</span><span class="o">[</span><span class="kt">A</span>,<span class="kt">B</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">B</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">filter</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">split</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span><span class="k">:</span> <span class="kt">Option</span><span class="o">[(</span><span class="kt">A</span>,<span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])]</span> 
</code></pre> 
</div> 
<p>A <code>fail</code> value is a choice among no alternatives. A <code>unit(a)</code> is a choice of a single alternative. The value <code>or(t1, t2)</code> is a choice among the alternatives represented by <code>t1</code> together with the alternatives represented by <code>t2</code>.</p> 
 
<p>The meaning of <code>apply</code>ing a function to a choice of alternatives is a choice among the results of applying the function to each alternative; that is, if <code>t</code> represents a choice among <code>1</code>, <code>2</code>, and <code>3</code>, then <code>apply(t, f)</code> represents a choice among <code>f(1)</code>, <code>f(2)</code>, and <code>f(3)</code>.</p> 
 
<p><code>Bind</code> is the same except the function returns a choice of alternatives, so we must combine all the alternatives in the result; that is, if <code>t</code> is a choice among <code>1</code>, <code>3</code>, and <code>5</code>, and <code>f</code> is <code>{ x =&gt; or(unit(x), unit(x + 1)) }</code>, then <code>bind(t, f)</code> is a choice among <code>1</code>, <code>2</code>, <code>3</code>, <code>4</code>, <code>5</code>, and <code>6</code>.</p> 
 
<p>A <code>filter</code> of a choice of alternatives by a predicate is a choice among only the alternatives which pass the the predicate.</p> 
 
<p>Finally, <code>split</code> is a function which returns the first alternative in a choice of alternatives (if there is at least one) along with a choice among the remaining alternatives.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">or</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">as</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> 
    <span class="n">as</span><span class="o">.</span><span class="n">foldRight</span><span class="o">(</span><span class="n">fail</span><span class="o">[</span><span class="kt">A</span><span class="o">])((</span><span class="n">a</span><span class="o">,</span> <span class="n">t</span><span class="o">)</span> <span class="k">=&gt;</span> <span class="n">or</span><span class="o">(</span><span class="n">unit</span><span class="o">(</span><span class="n">a</span><span class="o">),</span> <span class="n">t</span><span class="o">))</span> 
 
  <span class="k">def</span> <span class="n">run</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">n</span><span class="k">:</span> <span class="kt">Int</span><span class="o">)</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> 
    <span class="k">if</span> <span class="o">(</span><span class="n">n</span> <span class="o">&lt;=</span> <span class="mi">0</span><span class="o">)</span> <span class="nc">Nil</span> <span class="k">else</span> 
      <span class="n">split</span><span class="o">(</span><span class="n">t</span><span class="o">)</span> <span class="k">match</span> <span class="o">{</span> 
        <span class="k">case</span> <span class="nc">None</span> <span class="k">=&gt;</span> <span class="nc">Nil</span> 
        <span class="k">case</span> <span class="nc">Some</span><span class="o">((</span><span class="n">a</span><span class="o">,</span> <span class="n">t</span><span class="o">))</span> <span class="k">=&gt;</span> <span class="n">a</span> <span class="o">::</span> <span class="n">run</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">n</span> <span class="o">-</span> <span class="mi">1</span><span class="o">)</span> 
      <span class="o">}</span> 
</code></pre> 
</div> 
<p>As a convenience, <code>or(as: List[A])</code> means a choice among the elements of <code>as</code>. And <code>run</code> returns a list of the first <code>n</code> alternatives in a choice, picking them off one by one with <code>split</code>; this is how we get answers out of a <code>T[A]</code>.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">case</span> <span class="k">class</span> <span class="nc">Syntax</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span> <span class="o">{</span> 
    <span class="k">def</span> <span class="n">map</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">B</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> <span class="k">=</span> <span class="n">L</span><span class="o">.</span><span class="n">apply</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">f</span><span class="o">)</span> 
    <span class="k">def</span> <span class="n">filter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> <span class="n">L</span><span class="o">.</span><span class="n">filter</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">p</span><span class="o">)</span> 
    <span class="k">def</span> <span class="n">flatMap</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">B</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> <span class="k">=</span> <span class="n">L</span><span class="o">.</span><span class="n">bind</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">f</span><span class="o">)</span> 
    <span class="k">def</span> <span class="n">withFilter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> <span class="n">L</span><span class="o">.</span><span class="n">filter</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">p</span><span class="o">)</span> 
 
    <span class="k">def</span> <span class="o">|(</span><span class="n">t2</span><span class="k">:</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> <span class="n">L</span><span class="o">.</span><span class="n">or</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">t2</span><span class="o">)</span> 
  <span class="o">}</span> 
 
  <span class="k">implicit</span> <span class="k">def</span> <span class="n">syntax</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span> <span class="k">=</span> <span class="nc">Syntax</span><span class="o">(</span><span class="n">t</span><span class="o">)</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>Here we hook into the for-comprehension notation, by wrapping values of type <code>T[A]</code> in an object with the methods we need (and <code>|</code> as an additional bit of syntactic sugar), which methods just delegate to the functions defined above. We arrange with an implicit conversion for these wrappers to spring into existence when we need them.</p> 
<b>The bridge puzzle with the logic monad</b> 
<p>Now we can rewrite the solution in terms of the <code>Logic</code> trait:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">class</span> <span class="nc">Bridge</span><span class="o">(</span><span class="nc">Logic</span><span class="k">:</span> <span class="kt">Logic</span><span class="o">)</span> <span class="o">{</span> 
  <span class="k">import</span> <span class="nn">Logic._</span> 
</code></pre> 
</div> 
<p>We pass an implementation of the logic monad in, then open it so the implicit conversion is available (we can also use <code>T[A]</code> and the <code>Logic</code> functions without qualification).</p> 
 
<p>The <code>Person</code>, <code>times</code>, and <code>State</code> definitions are as before.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">private</span> <span class="k">def</span> <span class="n">chooseTwo</span><span class="o">(</span><span class="n">list</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">Person</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[(</span><span class="kt">Person</span>,<span class="kt">Person</span><span class="o">)]</span> <span class="k">=</span> 
    <span class="k">for</span> <span class="o">{</span> <span class="n">p1</span> <span class="k">&lt;-</span> <span class="n">or</span><span class="o">(</span><span class="n">list</span><span class="o">);</span> <span class="n">p2</span> <span class="k">&lt;-</span> <span class="n">or</span><span class="o">(</span><span class="n">list</span><span class="o">);</span> <span class="k">if</span> <span class="n">p1</span> <span class="o">&lt;</span> <span class="n">p2</span> <span class="o">}</span> 
    <span class="k">yield</span> <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>As we saw, we can write <code>chooseTwo</code> more straightforwardly using a for-comprehension. In the previous version we punned on <code>list</code> as a concrete list and as a choice among alternatives; here we convert one to the other explicitly.</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">private</span> <span class="k">def</span> <span class="n">next</span><span class="o">(</span><span class="n">state</span><span class="k">:</span> <span class="kt">State</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">State</span><span class="o">]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">if</span> <span class="o">(</span><span class="n">state</span><span class="o">.</span><span class="n">lightOnLeft</span><span class="o">)</span> <span class="o">{</span> 
      <span class="k">for</span> <span class="o">{</span> 
        <span class="o">(</span><span class="n">p1</span><span class="o">,</span> <span class="n">p2</span><span class="o">)</span> <span class="k">&lt;-</span> <span class="n">chooseTwo</span><span class="o">(</span><span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">)</span> 
        <span class="n">timeRemaining</span> <span class="k">=</span> 
          <span class="n">state</span><span class="o">.</span><span class="n">timeRemaining</span> <span class="o">-</span> <span class="n">math</span><span class="o">.</span><span class="n">max</span><span class="o">(</span><span class="n">times</span><span class="o">(</span><span class="n">p1</span><span class="o">),</span> <span class="n">times</span><span class="o">(</span><span class="n">p2</span><span class="o">))</span> 
        <span class="k">if</span> <span class="n">timeRemaining</span> <span class="o">&gt;=</span> <span class="mi">0</span> 
      <span class="o">}</span> <span class="k">yield</span> <span class="o">{</span> 
        <span class="k">val</span> <span class="n">left</span> <span class="k">=</span> 
          <span class="n">state</span><span class="o">.</span><span class="n">left</span><span class="o">.</span><span class="n">filterNot</span> <span class="o">{</span> <span class="n">p</span> <span class="k">=&gt;</span> <span class="n">p</span> <span class="o">==</span> <span class="n">p1</span> <span class="o">||</span> <span class="n">p</span> <span class="o">==</span> <span class="n">p2</span> <span class="o">}</span> 
        <span class="nc">State</span><span class="o">(</span><span class="n">left</span><span class="o">,</span> <span class="kc">false</span><span class="o">,</span> <span class="n">timeRemaining</span><span class="o">)</span> 
      <span class="o">}</span> 
    <span class="o">}</span> <span class="k">else</span> <span class="o">{</span> <span class="c1">// ...</span> 
</code></pre> 
</div> 
<p>This is pretty much as before, except with for-comprehensions instead of <code>foldLeft</code> and explicit consing. (You can easily figure out the branch for the flashlight on the right.)</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">private</span> <span class="k">def</span> <span class="n">tree</span><span class="o">(</span><span class="n">path</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]]</span> <span class="k">=</span> 
    <span class="n">unit</span><span class="o">(</span><span class="n">path</span><span class="o">)</span> <span class="o">|</span> 
      <span class="o">(</span><span class="k">for</span> <span class="o">{</span> 
         <span class="n">state</span> <span class="k">&lt;-</span> <span class="n">next</span><span class="o">(</span><span class="n">path</span><span class="o">.</span><span class="n">head</span><span class="o">)</span> 
         <span class="n">path</span> <span class="k">&lt;-</span> <span class="n">tree</span><span class="o">(</span><span class="n">state</span> <span class="o">::</span> <span class="n">path</span><span class="o">)</span> 
       <span class="o">}</span> <span class="k">yield</span> <span class="n">path</span><span class="o">)</span> 
 
  <span class="k">def</span> <span class="n">search</span><span class="o">(</span><span class="n">n</span><span class="k">:</span> <span class="kt">Int</span><span class="o">)</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">val</span> <span class="n">start</span> <span class="k">=</span> <span class="nc">List</span><span class="o">(</span><span class="nc">State</span><span class="o">(</span><span class="nc">Person</span><span class="o">.</span><span class="n">all</span><span class="o">,</span> <span class="kc">true</span><span class="o">,</span> <span class="mi">60</span><span class="o">))</span> 
    <span class="k">val</span> <span class="n">t</span> <span class="k">=</span> 
      <span class="k">for</span> <span class="o">{</span> <span class="n">path</span> <span class="k">&lt;-</span> <span class="n">tree</span><span class="o">(</span><span class="n">start</span><span class="o">);</span> <span class="k">if</span> <span class="n">path</span><span class="o">.</span><span class="n">head</span><span class="o">.</span><span class="n">left</span> <span class="o">==</span> <span class="nc">Nil</span> <span class="o">}</span> 
      <span class="k">yield</span> <span class="n">path</span> 
    <span class="n">run</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">n</span><span class="o">)</span> 
  <span class="o">}</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>In <code>tree</code> we use <code>|</code> to adjoin the input path (previously we gave it in the initial value of <code>foldLeft</code>). In <code>search</code> we need to actually run the <code>Logic.T[A]</code> value rather than returning it, because it&rsquo;s an abstract type and can&rsquo;t escape the module (see the Postscript for an alternative); this is why the other methods must be <code>private</code>.</p> 
<b>Implementing the logic monad with lists</b> 
<p>We can recover the original solution by implementing <code>Logic</code> with lists:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">object</span> <span class="nc">LogicList</span> <span class="k">extends</span> <span class="nc">Logic</span> <span class="o">{</span> 
  <span class="k">type</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> <span class="nc">List</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
 
  <span class="k">def</span> <span class="n">fail</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> <span class="nc">Nil</span> 
  <span class="k">def</span> <span class="n">unit</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">a</span><span class="k">:</span> <span class="kt">A</span><span class="o">)</span> <span class="k">=</span> <span class="n">a</span> <span class="o">::</span> <span class="nc">Nil</span> 
  <span class="k">def</span> <span class="n">or</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t1</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">t2</span><span class="k">:</span> <span class="o">=&gt;</span> <span class="nc">List</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span> <span class="k">=</span> <span class="n">t1</span> <span class="o">:::</span> <span class="n">t2</span> 
  <span class="k">def</span> <span class="n">apply</span><span class="o">[</span><span class="kt">A</span>,<span class="kt">B</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">B</span><span class="o">)</span> <span class="k">=</span> <span class="n">t</span><span class="o">.</span><span class="n">map</span><span class="o">(</span><span class="n">f</span><span class="o">)</span> 
  <span class="k">def</span> <span class="n">bind</span><span class="o">[</span><span class="kt">A</span>,<span class="kt">B</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">List</span><span class="o">[</span><span class="kt">B</span><span class="o">])</span> <span class="k">=</span> <span class="n">t</span><span class="o">.</span><span class="n">flatMap</span><span class="o">(</span><span class="n">f</span><span class="o">)</span> 
  <span class="k">def</span> <span class="n">filter</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> <span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span> <span class="k">=</span> <span class="n">t</span><span class="o">.</span><span class="n">filter</span><span class="o">(</span><span class="n">p</span><span class="o">)</span> 
  <span class="k">def</span> <span class="n">split</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span><span class="n">t</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span> <span class="k">=</span> 
    <span class="n">t</span> <span class="k">match</span> <span class="o">{</span> 
      <span class="k">case</span> <span class="nc">Nil</span> <span class="k">=&gt;</span> <span class="nc">None</span> 
      <span class="k">case</span> <span class="n">h</span> <span class="o">::</span> <span class="n">t</span> <span class="k">=&gt;</span> <span class="nc">Some</span><span class="o">(</span><span class="n">h</span><span class="o">,</span> <span class="n">t</span><span class="o">)</span> 
    <span class="o">}</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>A choice among alternatives is just a <code>List</code> of the alternatives, so the semantics we sketched above are realized in a very direct way.</p> 
 
<p>The downside to the <code>List</code> implementation is that we compute all the alternatives, even if we only care about one of them. (In the bridge problem any path to the final state is a satisfactory answer, but our program computes all such paths, even if we pass an argument to <code>search</code> requesting only one answer.) We might even want to solve problems with an infinite number of solutions.</p> 
 
<p>Next time we&rsquo;ll repair this downside by implementing the backtracking monad from the paper by Kiselyov et al.</p> 
 
<p>See the complete code <a href="https://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/scala-logic">here</a>.</p> 
<b>Postscript: modules in Scala</b> 
<p>I got the idea of implementing the for-comprehension methods as an implict wrapper from Edward Kmett&rsquo;s <a href="https://github.com/ekmett/functorial">functorial</a> library. It&rsquo;s nice that <code>T[A]</code> remains completely abstract, and the for-comprehension notation is just sugar. I also tried an implementation where <code>T[A]</code> is bounded by a trait containing the methods:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">trait</span> <span class="nc">Monadic</span><span class="o">[</span><span class="kt">T</span><span class="o">[</span><span class="k">_</span><span class="o">]</span>, <span class="kt">A</span><span class="o">]</span> <span class="o">{</span> 
  <span class="k">def</span> <span class="n">map</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">B</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">filter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">flatMap</span><span class="o">[</span><span class="kt">B</span><span class="o">](</span><span class="n">f</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">B</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">B</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">withFilter</span><span class="o">(</span><span class="n">p</span><span class="k">:</span> <span class="kt">A</span> <span class="o">=&gt;</span> <span class="nc">Boolean</span><span class="o">)</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
 
  <span class="k">def</span> <span class="o">|(</span><span class="n">t</span><span class="k">:</span> <span class="o">=&gt;</span> <span class="n">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> 
  <span class="k">def</span> <span class="n">split</span><span class="k">:</span> <span class="kt">Option</span><span class="o">[(</span><span class="kt">A</span>,<span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">])]</span> 
<span class="o">}</span> 
 
<span class="k">trait</span> <span class="nc">Logic</span> <span class="o">{</span> 
  <span class="k">type</span> <span class="kt">T</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">&lt;:</span> <span class="nc">Monadic</span><span class="o">[</span><span class="kt">T</span>, <span class="kt">A</span><span class="o">]</span> 
  <span class="c1">// no Syntax class needed</span> 
</code></pre> 
</div> 
<p>This works too but the type system hackery is a bit ugly, and it constrains implementations of <code>Logic</code> more than is necessary.</p> 
 
<p>Another design choice is whether <code>T[A]</code> is an abstract type (as I have it) or a type parameter of <code>Logic</code>:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">trait</span> <span class="nc">Logic</span><span class="o">[</span><span class="kt">T</span><span class="o">[</span><span class="k">_</span><span class="o">]]</span> <span class="o">{</span> <span class="n">L</span> <span class="k">=&gt;</span> 
  <span class="c1">// no abstract type T[A] but otherwise as before</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>Neither alternative provides the expressivity of OCaml modules (<em>but see addendum below</em>): with abstract types, consumers of <code>Logic</code> cannot return values of <code>T[A]</code> (as we saw above); with a type parameter, they can, but the type is no longer abstract.</p> 
 
<p>In OCaml we would write</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">module</span> <span class="k">type</span> <span class="nc">Logic</span> <span class="o">=</span> 
<span class="k">sig</span> 
  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> 
 
  <span class="k">val</span> <span class="kt">unit</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> 
  <span class="c">(* and so on *)</span> 
<span class="k">end</span> 
 
<span class="k">module</span> <span class="nc">Bridge</span><span class="o">(</span><span class="nc">L</span> <span class="o">:</span> <span class="nc">Logic</span><span class="o">)</span> <span class="o">=</span> 
<span class="k">struct</span> 
  <span class="k">type</span> <span class="n">state</span> <span class="o">=</span> <span class="o">...</span> 
  <span class="k">val</span> <span class="n">search</span> <span class="o">:</span> <span class="n">state</span> <span class="kt">list</span> <span class="nn">L</span><span class="p">.</span><span class="n">t</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>and get both the abstract type and the ability to return values of the type.</p> 
 
<p><em>Addendum</em></p> 
 
<p>Jorge Ortiz points out in the comments that it is possible to keep <code>T[A]</code> abstract and also return its values from <code>Bridge</code>, by making the <code>Logic</code> argument a (public) <code>val</code>. We can then remove the <code>private</code>s, and write <code>search</code> as just:</p> 
<div class="highlight"><pre><code class="scala">  <span class="k">def</span> <span class="n">search</span><span class="k">:</span> <span class="kt">T</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">State</span><span class="o">]]</span> <span class="k">=</span> <span class="o">{</span> 
    <span class="k">val</span> <span class="n">start</span> <span class="k">=</span> <span class="nc">List</span><span class="o">(</span><span class="nc">State</span><span class="o">(</span><span class="nc">Person</span><span class="o">.</span><span class="n">all</span><span class="o">,</span> <span class="kc">true</span><span class="o">,</span> <span class="mi">60</span><span class="o">))</span> 
    <span class="k">for</span> <span class="o">{</span> <span class="n">path</span> <span class="k">&lt;-</span> <span class="n">tree</span><span class="o">(</span><span class="n">start</span><span class="o">);</span> <span class="k">if</span> <span class="n">path</span><span class="o">.</span><span class="n">head</span><span class="o">.</span><span class="n">left</span> <span class="o">==</span> <span class="nc">Nil</span> <span class="o">}</span> 
    <span class="k">yield</span> <span class="n">path</span> 
  <span class="o">}</span> 
</code></pre> 
</div> 
<p>instead of baking <code>run</code> into it. Now, if we write <code>val b = new Bridge(LogicList)</code> then <code>b.search</code> has type <code>b.Logic.T[List[b.State]]</code>, and we can call <code>b.Logic.run</code> to evaluate it.</p> 
 
<p>This is only a modest improvement; what&rsquo;s still missing, compared to the OCaml version, is the fact that <code>LogicList</code> and <code>b.Logic</code> are the same module. So we can&rsquo;t call <code>LogicList.run(b.search)</code> directly. Worse, we can&rsquo;t compose modules which use the same <code>Logic</code> implementation, because they each have their own incompatibly-typed <code>Logic</code> member.</p> 
 
<p>I thought there might be a way out of this using singleton types&mdash;the idea is that a match of a value <code>v</code> against a typed pattern where the type is <code>w.type</code> succeeds when <code>v eq w</code> (section 8.2 in the reference manual). So we can define</p> 
<div class="highlight"><pre><code class="scala"><span class="k">def</span> <span class="n">run</span><span class="o">[</span><span class="kt">A</span><span class="o">](</span> 
  <span class="nc">Logic</span><span class="k">:</span> <span class="kt">Logic</span><span class="o">,</span> 
  <span class="n">b</span><span class="k">:</span> <span class="kt">Bridge</span><span class="o">,</span> 
  <span class="n">t</span><span class="k">:</span> <span class="kt">b.Logic.T</span><span class="o">[</span><span class="kt">A</span><span class="o">],</span> 
  <span class="n">n</span><span class="k">:</span> <span class="kt">Int</span><span class="o">)</span><span class="k">:</span> <span class="kt">List</span><span class="o">[</span><span class="kt">A</span><span class="o">]</span> <span class="k">=</span> 
<span class="o">{</span> 
  <span class="nc">Logic</span> <span class="k">match</span> <span class="o">{</span> 
    <span class="k">case</span> <span class="n">l</span> <span class="k">:</span> <span class="kt">b.Logic.</span><span class="k">type</span> <span class="o">=&gt;</span> <span class="n">l</span><span class="o">.</span><span class="n">run</span><span class="o">(</span><span class="n">t</span><span class="o">,</span> <span class="n">n</span><span class="o">)</span> 
  <span class="o">}</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>which is accepted, but sadly</p> 
<div class="highlight"><pre><code class="scala"><span class="n">scala</span><span class="o">&gt;</span> <span class="n">run</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">b.State</span><span class="o">]](</span><span class="nc">LogicList</span><span class="o">,</span> <span class="n">b</span><span class="o">,</span> <span class="n">b</span><span class="o">.</span><span class="n">search</span><span class="o">,</span> <span class="mi">2</span><span class="o">)</span> 
<span class="o">&lt;</span><span class="n">console</span><span class="o">&gt;:</span><span class="mi">8</span><span class="k">:</span> <span class="kt">error:</span> <span class="k">type</span> <span class="kt">mismatch</span><span class="o">;</span> 
 <span class="n">found</span>   <span class="k">:</span> <span class="kt">b.Logic.T</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">b.State</span><span class="o">]]</span> 
 <span class="n">required</span><span class="k">:</span> <span class="kt">b.Logic.T</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">b.State</span><span class="o">]]</span> 
       <span class="n">run</span><span class="o">[</span><span class="kt">List</span><span class="o">[</span><span class="kt">b.State</span><span class="o">]](</span><span class="nc">LogicList</span><span class="o">,</span> <span class="n">b</span><span class="o">,</span> <span class="n">b</span><span class="o">.</span><span class="n">search</span><span class="o">,</span> <span class="mi">2</span><span class="o">)</span> 
                                          <span class="o">^</span> 
</code></pre> 
</div> 
<p><em>Addendum addendum</em></p> 
 
<p>Some further advice from Jorge Ortiz: the specific type of <code>Logic</code> (not just <code>Logic.type</code>) can be exposed outside <code>Bridge</code> either through polymorphism:</p> 
<div class="highlight"><pre><code class="scala"><span class="k">class</span> <span class="nc">Bridge</span><span class="o">[</span><span class="kt">L</span> <span class="k">&lt;:</span> <span class="kt">Logic</span><span class="o">](</span><span class="k">val</span> <span class="nc">Logic</span><span class="k">:</span> <span class="kt">L</span><span class="o">)</span> <span class="o">{</span> 
  <span class="o">...</span> 
<span class="o">}</span> 
 
<span class="k">val</span> <span class="n">b</span> <span class="k">=</span> <span class="k">new</span> <span class="nc">Bridge</span><span class="o">(</span><span class="nc">LogicList</span><span class="o">)</span> 
</code></pre> 
</div> 
<p>or by defining an abstract value (this works the same if <code>Bridge</code> is a trait):</p> 
<div class="highlight"><pre><code class="scala"><span class="k">abstract</span> <span class="k">class</span> <span class="nc">Bridge</span> <span class="o">{</span> 
  <span class="k">val</span> <span class="nc">Logic</span><span class="k">:</span> <span class="kt">Logic</span> 
  <span class="o">...</span> 
<span class="o">}</span> 
</code></pre> 
</div> 
<p>So we can compose uses of <code>T</code> but it remains abstract.</p>
