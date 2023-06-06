---
title: Three uses for a binary heap
description: Lately I have been interviewing for jobs, so doing a lot of whiteboard
  programming, and binary heaps  keep arising in the solutions to these...
url: http://ambassadortothecomputers.blogspot.com/2010/11/three-uses-for-binary-heap.html
date: 2010-11-25T04:58:00-00:00
preview_image:
featured:
authors:
- ambassadortothecomputers
---

<p>Lately I have been interviewing for jobs, so doing a lot of whiteboard programming, and <a href="http://en.wikipedia.org/wiki/Binary_heap">binary heaps</a> keep arising in the solutions to these interview problems. There is nothing new or remarkable about these applications (binary heaps and their uses are covered in any undergraduate algorithms class), but I thought I would write them down because they are cute, and in the hope that they might be useful to someone else who (like me) gets by most days as a working programmer with no algorithm fancier than quicksort or binary search.</p> 
<b>Binary heaps</b> 
<p>Here&rsquo;s a signature for a binary heap module <code>Heap</code>:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">module</span> <span class="k">type</span> <span class="nc">OrderedType</span> <span class="o">=</span> 
<span class="k">sig</span> 
  <span class="k">type</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">compare</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">int</span> 
<span class="k">end</span> 
 
<span class="k">module</span> <span class="k">type</span> <span class="nc">S</span> <span class="o">=</span> <span class="k">sig</span> 
  <span class="k">type</span> <span class="n">elt</span> 
  <span class="k">type</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">make</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="n">t</span> 
  <span class="k">val</span> <span class="n">add</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">elt</span> <span class="o">-&gt;</span> <span class="kt">unit</span> 
  <span class="k">val</span> <span class="n">peek_min</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">elt</span> <span class="n">option</span> 
  <span class="k">val</span> <span class="n">take_min</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">elt</span> 
  <span class="k">val</span> <span class="n">size</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">int</span> 
<span class="k">end</span> 
 
<span class="k">module</span> <span class="nc">Make</span> <span class="o">(</span><span class="nc">O</span> <span class="o">:</span> <span class="nc">OrderedType</span><span class="o">)</span> <span class="o">:</span> <span class="nc">S</span> <span class="k">with</span> <span class="k">type</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">O</span><span class="p">.</span><span class="n">t</span> 
</code></pre> 
</div> 
<p>We start with a signature for ordered types (following the <code>Set</code> and <code>Map</code> modules in the standard library), so we can provide a type-specific comparison function.</p> 
 
<p>From an ordered type we can make a heap which supports adding elements, peeking the smallest element (<code>None</code> if there are no elements) without removing it, removing and returning the smallest element (raising <code>Not_found</code> if the heap is empty), and returning the number of elements.</p> 
 
<p>We&rsquo;ll work out the asymptotic running times of the algorithms below, so it will be useful to know that the worst-case running time of the <code>add</code> and <code>take_min</code> functions is <code>O(log n)</code> where <code>n</code> is the number of elements in the heap.</p> 
<b>Finding the k smallest elements in a list</b> 
<p>Here&rsquo;s a simple one. To find the smallest element in a list, we could sort the list then take the first element in the sorted list, at a cost of <code>O(log n)</code>. Or we could just take a pass over the list keeping a running minimum, at a cost of <code>O(n)</code>.</p> 
 
<p>What if we want the <code>k</code> smallest elements? Again, we could sort the list, but if <code>k &lt; n</code> we can do better by generalizing the single-pass solution. The idea is to keep the <code>k</code> smallest elements we&rsquo;ve seen so far in a binary heap. For each element in the list we add it to the heap, then (if there were already <code>k</code> elements in the heap) remove the largest element in the heap, leaving the <code>k</code> smallest.</p> 
 
<p>The running time is <code>O(n log k)</code> since we do an <code>add</code> and a <code>take_min</code> in a heap of size <code>k</code> for each of <code>n</code> elements in the list. Here&rsquo;s the code:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">kmin</span> <span class="o">(</span><span class="k">type</span> <span class="n">s</span><span class="o">)</span> <span class="n">k</span> <span class="n">l</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">OT</span> <span class="o">=</span> <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="n">s</span> 
    <span class="k">let</span> <span class="n">compare</span> <span class="n">e1</span> <span class="n">e2</span> <span class="o">=</span> <span class="n">compare</span> <span class="n">e2</span> <span class="n">e1</span> 
  <span class="k">end</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">H</span> <span class="o">=</span> <span class="nn">Heap</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">OT</span><span class="o">)</span> <span class="k">in</span> 
 
  <span class="k">let</span> <span class="n">h</span> <span class="o">=</span> <span class="nn">H</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span> <span class="k">in</span> 
  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="n">e</span> <span class="o">-&gt;</span> 
       <span class="nn">H</span><span class="p">.</span><span class="n">add</span> <span class="n">h</span> <span class="n">e</span><span class="o">;</span> 
       <span class="k">if</span> <span class="nn">H</span><span class="p">.</span><span class="n">size</span> <span class="n">h</span> <span class="o">&gt;</span> <span class="n">k</span> 
       <span class="k">then</span> <span class="n">ignore</span> <span class="o">(</span><span class="nn">H</span><span class="p">.</span><span class="n">take_min</span> <span class="n">h</span><span class="o">))</span> 
    <span class="n">l</span><span class="o">;</span> 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">loop</span> <span class="n">mins</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="nn">H</span><span class="p">.</span><span class="n">peek_min</span> <span class="n">h</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">mins</span> 
      <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="n">loop</span> <span class="o">(</span><span class="nn">H</span><span class="p">.</span><span class="n">take_min</span> <span class="n">h</span> <span class="o">::</span> <span class="n">mins</span><span class="o">)</span> <span class="k">in</span> 
  <span class="n">loop</span> <span class="bp">[]</span> 
</code></pre> 
</div> 
<p>Here we make good use of OCaml 3.12&rsquo;s new feature for <a href="http://caml.inria.fr/pub/docs/manual-ocaml/manual021.html#toc80">explicitly naming type variables</a> in a polymorphic function to make a structure matching <code>OrderedType</code>. The heap has the same element type as the list, but we reverse the comparison since we want to remove the largest rather than smallest element from the heap in the loop. At the end of <code>kmin</code> we drain the heap to build a list of the <code>k</code> smallest elements.</p> 
<b>Merging k lists</b> 
<p>Suppose we want to merge <code>k</code> lists. We could merge them pairwise until there is only one list, but that would take <code>k - 1</code> passes, for a worst-case running time of <code>O(n * (k - 1))</code>. Instead we can merge them all in one pass, using a binary heap so we can find the next smallest element of <code>k</code> lists in <code>O(log k)</code> time, for a running time of <code>O(n
log k)</code>. Here&rsquo;s the code:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">let</span> <span class="n">merge</span> <span class="o">(</span><span class="k">type</span> <span class="n">s</span><span class="o">)</span> <span class="n">ls</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">OT</span> <span class="o">=</span> <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="n">s</span> <span class="kt">list</span> 
    <span class="k">let</span> <span class="n">compare</span> <span class="n">e1</span> <span class="n">e2</span> <span class="o">=</span> 
      <span class="n">compare</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">hd</span> <span class="n">e1</span><span class="o">)</span> <span class="o">(</span><span class="nn">List</span><span class="p">.</span><span class="n">hd</span> <span class="n">e2</span><span class="o">)</span> 
  <span class="k">end</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">H</span> <span class="o">=</span> <span class="nn">Heap</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">OT</span><span class="o">)</span> <span class="k">in</span> 
 
  <span class="k">let</span> <span class="n">h</span> <span class="o">=</span> <span class="nn">H</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="n">add</span> <span class="o">=</span> <span class="k">function</span> 
    <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="bp">()</span> 
    <span class="o">|</span> <span class="n">l</span> <span class="o">-&gt;</span> <span class="nn">H</span><span class="p">.</span><span class="n">add</span> <span class="n">h</span> <span class="n">l</span> <span class="k">in</span> 
  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">add</span> <span class="n">ls</span><span class="o">;</span> 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">loop</span> <span class="bp">()</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="nn">H</span><span class="p">.</span><span class="n">peek_min</span> <span class="n">h</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="bp">[]</span> 
      <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> 
          <span class="k">match</span> <span class="nn">H</span><span class="p">.</span><span class="n">take_min</span> <span class="n">h</span> <span class="k">with</span> 
            <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span> 
            <span class="o">|</span> <span class="n">m</span> <span class="o">::</span> <span class="n">t</span> <span class="o">-&gt;</span> 
                <span class="n">add</span> <span class="n">t</span><span class="o">;</span> 
                <span class="n">m</span> <span class="o">::</span> <span class="n">loop</span> <span class="bp">()</span> <span class="k">in</span> 
  <span class="n">loop</span> <span class="bp">()</span> 
</code></pre> 
</div> 
<p>We store the lists in the heap, and compare them by comparing their head element (we&rsquo;re careful not to put an empty list in the heap). When we take the smallest list from the heap, its head becomes the next element in the output list, and we return its tail (if it is not empty) to the heap.</p> 
<b>Computing a skyline</b> 
<p>The next problem was told to me in terms of computing the skyline of a set of buildings. A building has a height and a starting and ending <code>x</code>-coordinate; buildings may overlap. The skyline of a set of buildings is a list of (<code>x</code>, <code>y</code>) pairs (in ascending <code>x</code> order), describing a sequence of horizontal line segments (each starting at (<code>x</code>, <code>y</code>) and ending at the subsequent <code>x</code>), such that at any <code>x</code> there is no space between the line segment and the tallest building. (Here&rsquo;s <a href="http://stackoverflow.com/questions/1066234/the-skyline-problem">another description</a> with diagrams.)</p> 
 
<p>I googled a bit to see what this is useful for, and didn&rsquo;t find much. One application is to extract a monophonic line from polyphonic music, where <code>x</code> is time and height is some metric on notes, like pitch or volume. It might be useful for searching data which is only intermittently applicable&mdash;say, to compute a schedule over time of the nearest open restaurant.</p> 
 
<p>The algorithm scans the building start and end points in ascending <code>x</code> order, keeping the &ldquo;active&rdquo; buildings (those which overlap the current <code>x</code>) in a binary heap. The height of the skyline can only change at a building start or end point. We can determine the tallest building at a point by calling <code>peek_min</code> on the heap.</p> 
 
<p>When we hit a start point we add the building to the heap; for an end point we do nothing (the heap has no operation to remove an element). So we may have inactive buildings in the heap. We remove them lazily&mdash;before checking the height of the highest building, we call <code>take_min</code> to remove any higher inactive buildings.</p> 
 
<p>The worst-case running time is <code>O(n log n)</code>, since we do some heap operations for each building, and we might end up with all the buildings in the heap.</p> 
 
<p>Here&rsquo;s the code:</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">type</span> <span class="n">building</span> <span class="o">=</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span> <span class="c">(* x0, x1, h *)</span> 
 
<span class="k">let</span> <span class="n">skyline</span> <span class="n">bs</span> <span class="o">=</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">OT</span> <span class="o">=</span> <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="kt">int</span> <span class="o">*</span> <span class="n">building</span> 
    <span class="k">let</span> <span class="n">compare</span> <span class="o">(</span><span class="n">x1</span><span class="o">,</span> <span class="o">_)</span> <span class="o">(</span><span class="n">x2</span><span class="o">,</span> <span class="o">_)</span> <span class="o">=</span> <span class="n">compare</span> <span class="n">x1</span> <span class="n">x2</span> 
  <span class="k">end</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">Events</span> <span class="o">=</span> <span class="nn">Heap</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">OT</span><span class="o">)</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="n">events</span> <span class="o">=</span> <span class="nn">Events</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span> <span class="k">in</span> 
  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> 
    <span class="o">(</span><span class="k">fun</span> <span class="o">((</span><span class="n">x0</span><span class="o">,</span><span class="n">x1</span><span class="o">,_)</span> <span class="k">as</span> <span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> 
       <span class="nn">Events</span><span class="p">.</span><span class="n">add</span> <span class="n">events</span> <span class="o">(</span><span class="n">x0</span><span class="o">,</span> <span class="n">b</span><span class="o">);</span> 
       <span class="nn">Events</span><span class="p">.</span><span class="n">add</span> <span class="n">events</span> <span class="o">(</span><span class="n">x1</span><span class="o">,</span> <span class="n">b</span><span class="o">))</span> 
    <span class="n">bs</span><span class="o">;</span> 
 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">OT</span> <span class="o">=</span> <span class="k">struct</span> 
    <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="n">building</span> 
    <span class="k">let</span> <span class="n">compare</span> <span class="o">(_,_,</span><span class="n">h1</span><span class="o">)</span> <span class="o">(_,_,</span><span class="n">h2</span><span class="o">)</span> <span class="o">=</span> <span class="n">compare</span> <span class="n">h2</span> <span class="n">h1</span> 
  <span class="k">end</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="k">module</span> <span class="nc">Heights</span> <span class="o">=</span> <span class="nn">Heap</span><span class="p">.</span><span class="nc">Make</span><span class="o">(</span><span class="nc">OT</span><span class="o">)</span> <span class="k">in</span> 
  <span class="k">let</span> <span class="n">heights</span> <span class="o">=</span> <span class="nn">Heights</span><span class="p">.</span><span class="n">make</span> <span class="bp">()</span> <span class="k">in</span> 
 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">loop</span> <span class="n">last</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="nn">Events</span><span class="p">.</span><span class="n">peek_min</span> <span class="n">events</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="bp">[]</span> 
      <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> 
          <span class="k">let</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="o">(</span><span class="n">x0</span><span class="o">,_,</span><span class="n">h</span> <span class="k">as</span> <span class="n">b</span><span class="o">))</span> <span class="o">=</span> <span class="nn">Events</span><span class="p">.</span><span class="n">take_min</span> <span class="n">events</span> <span class="k">in</span> 
          <span class="k">if</span> <span class="n">x</span> <span class="o">=</span> <span class="n">x0</span> <span class="k">then</span> <span class="nn">Heights</span><span class="p">.</span><span class="n">add</span> <span class="n">heights</span> <span class="n">b</span><span class="o">;</span> 
          <span class="k">while</span> <span class="o">(</span><span class="k">match</span> <span class="nn">Heights</span><span class="p">.</span><span class="n">peek_min</span> <span class="n">heights</span> <span class="k">with</span> 
                   <span class="o">|</span> <span class="nc">Some</span> <span class="o">(_,</span><span class="n">x1</span><span class="o">,_)</span> <span class="o">-&gt;</span> <span class="n">x1</span> <span class="o">&lt;=</span> <span class="n">x</span> 
                   <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">false</span><span class="o">)</span> <span class="k">do</span> 
            <span class="n">ignore</span> <span class="o">(</span><span class="nn">Heights</span><span class="p">.</span><span class="n">take_min</span> <span class="n">heights</span><span class="o">)</span> 
          <span class="k">done</span><span class="o">;</span> 
          <span class="k">let</span> <span class="n">h</span> <span class="o">=</span> 
            <span class="k">match</span> <span class="nn">Heights</span><span class="p">.</span><span class="n">peek_min</span> <span class="n">heights</span> <span class="k">with</span> 
              <span class="o">|</span> <span class="nc">Some</span> <span class="o">(_,_,</span><span class="n">h</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">h</span> 
              <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="mi">0</span> <span class="k">in</span> 
          <span class="k">match</span> <span class="n">last</span> <span class="k">with</span> 
            <span class="o">|</span> <span class="nc">Some</span> <span class="n">h'</span> <span class="k">when</span> <span class="n">h</span> <span class="o">=</span> <span class="n">h'</span> <span class="o">-&gt;</span> <span class="n">loop</span> <span class="n">last</span> 
            <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">h</span><span class="o">)</span> <span class="o">::</span> <span class="n">loop</span> <span class="o">(</span><span class="nc">Some</span> <span class="n">h</span><span class="o">)</span> <span class="k">in</span> 
  <span class="n">loop</span> <span class="nc">None</span> 
</code></pre> 
</div> 
<p>We use a second heap <code>events</code> to store the &ldquo;events&rdquo; (the start and end points of all the buildings), in order to process them in ascending <code>x</code> order. (This use is not dynamic&mdash;we do not add new elements to the heap while processing them&mdash;so we could just as well use another means of sorting the points.) In this heap we store the <code>x</code> coordinate and the building (we can tell whether we have a start or end point by comparing the <code>x</code> coordinate to the building&rsquo;s start point), and compare elements by comparing just the <code>x</code> coordinates.</p> 
 
<p>The main heap <code>heights</code> stores buildings, and we compare them by comparing heights (reversed, so <code>peek_min</code> peeks the tallest building). While there are still events, we add the building to <code>heights</code> if the event is a start point, clear out inactive buildings, then return the pair (<code>x</code>, <code>y</code>) where <code>x</code> is the point we&rsquo;re processing and <code>y</code> is the height of the tallest active building. Additionally we filter out adjacent pairs with the same height; these can arise when a shorter building starts or ends while a taller building is active.</p> 
<b>Implementing binary heaps</b> 
<p>The following implementation is derived from the one in Daniel B&uuml;nzli&rsquo;s <a href="http://erratique.ch/software/react">React</a> library (edited a little bit for readability). The <a href="http://en.wikipedia.org/wiki/Binary_heap">Wikipedia article on binary heaps</a> explains the standard technique well, so I won&rsquo;t repeat it.</p> 
 
<p>The only piece of trickiness is the use of <code>Obj.magic 0</code> for unused elements of the array, so we can grow it by doubling the size rather than adding a single element each time, and thereby amortize the cost of blitting the old array.</p> 
<div class="highlight"><pre><code class="ocaml"><span class="k">module</span> <span class="nc">Make</span> <span class="o">(</span><span class="nc">O</span> <span class="o">:</span> <span class="nc">OrderedType</span><span class="o">)</span> <span class="o">:</span> <span class="nc">S</span> <span class="k">with</span> <span class="k">type</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">O</span><span class="p">.</span><span class="n">t</span> <span class="o">=</span> 
<span class="k">struct</span> 
  <span class="k">type</span> <span class="n">elt</span> <span class="o">=</span> <span class="nn">O</span><span class="p">.</span><span class="n">t</span> 
  <span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="o">{</span> <span class="k">mutable</span> <span class="n">arr</span> <span class="o">:</span> <span class="n">elt</span> <span class="kt">array</span><span class="o">;</span> <span class="k">mutable</span> <span class="n">len</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">}</span> 
 
  <span class="k">let</span> <span class="n">make</span> <span class="bp">()</span> <span class="o">=</span> <span class="o">{</span> <span class="n">arr</span> <span class="o">=</span> <span class="o">[||];</span> <span class="n">len</span> <span class="o">=</span> <span class="mi">0</span><span class="o">;</span> <span class="o">}</span> 
 
  <span class="k">let</span> <span class="n">compare</span> <span class="n">h</span> <span class="n">i1</span> <span class="n">i2</span> <span class="o">=</span> <span class="nn">O</span><span class="p">.</span><span class="n">compare</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i1</span><span class="o">)</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i2</span><span class="o">)</span> 
 
  <span class="k">let</span> <span class="n">swap</span> <span class="n">h</span> <span class="n">i1</span> <span class="n">i2</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i1</span><span class="o">)</span> <span class="k">in</span> 
    <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i1</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i2</span><span class="o">);</span> 
    <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">i2</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">t</span> 
 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">up</span> <span class="n">h</span> <span class="n">i</span> <span class="o">=</span> 
    <span class="k">if</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span> <span class="k">then</span> <span class="bp">()</span> 
    <span class="k">else</span> 
      <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="o">(</span><span class="n">i</span> <span class="o">-</span> <span class="mi">1</span><span class="o">)</span> <span class="o">/</span> <span class="mi">2</span> <span class="k">in</span> 
      <span class="k">if</span> <span class="n">compare</span> <span class="n">h</span> <span class="n">i</span> <span class="n">p</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="k">begin</span> 
        <span class="n">swap</span> <span class="n">h</span> <span class="n">i</span> <span class="n">p</span><span class="o">;</span> 
        <span class="n">up</span> <span class="n">h</span> <span class="n">p</span> 
      <span class="k">end</span> 
 
  <span class="k">let</span> <span class="k">rec</span> <span class="n">down</span> <span class="n">h</span> <span class="n">i</span> <span class="o">=</span> 
    <span class="k">let</span> <span class="n">l</span> <span class="o">=</span> <span class="mi">2</span> <span class="o">*</span> <span class="n">i</span> <span class="o">+</span> <span class="mi">1</span> <span class="k">in</span> 
    <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="mi">2</span> <span class="o">*</span> <span class="n">i</span> <span class="o">+</span> <span class="mi">2</span> <span class="k">in</span> 
    <span class="k">if</span> <span class="n">l</span> <span class="o">&gt;=</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="k">then</span> <span class="bp">()</span> 
    <span class="k">else</span> 
      <span class="k">let</span> <span class="n">child</span> <span class="o">=</span> 
        <span class="k">if</span> <span class="n">r</span> <span class="o">&gt;=</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="k">then</span> <span class="n">l</span> 
        <span class="k">else</span> <span class="k">if</span> <span class="n">compare</span> <span class="n">h</span> <span class="n">l</span> <span class="n">r</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="n">l</span> <span class="k">else</span> <span class="n">r</span> <span class="k">in</span> 
      <span class="k">if</span> <span class="n">compare</span> <span class="n">h</span> <span class="n">i</span> <span class="n">child</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="k">begin</span> 
        <span class="n">swap</span> <span class="n">h</span> <span class="n">i</span> <span class="n">child</span><span class="o">;</span> 
        <span class="n">down</span> <span class="n">h</span> <span class="n">child</span> 
      <span class="k">end</span> 
 
  <span class="k">let</span> <span class="n">add</span> <span class="n">h</span> <span class="n">e</span> <span class="o">=</span> 
    <span class="k">if</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">=</span> <span class="nn">Array</span><span class="p">.</span><span class="n">length</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span> 
    <span class="k">then</span> <span class="k">begin</span> 
      <span class="k">let</span> <span class="n">len</span> <span class="o">=</span> <span class="mi">2</span> <span class="o">*</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">+</span> <span class="mi">1</span> <span class="k">in</span> 
      <span class="k">let</span> <span class="n">arr'</span> <span class="o">=</span> <span class="nn">Array</span><span class="p">.</span><span class="n">make</span> <span class="n">len</span> <span class="o">(</span><span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
      <span class="nn">Array</span><span class="p">.</span><span class="n">blit</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span> <span class="mi">0</span> <span class="n">arr'</span> <span class="mi">0</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span><span class="o">;</span> 
      <span class="n">h</span><span class="o">.</span><span class="n">arr</span> <span class="o">&lt;-</span> <span class="n">arr'</span> 
    <span class="k">end</span><span class="o">;</span> 
    <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">h</span><span class="o">.</span><span class="n">len</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">e</span><span class="o">;</span> 
    <span class="n">up</span> <span class="n">h</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span><span class="o">;</span> 
    <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">&lt;-</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">+</span> <span class="mi">1</span> 
 
  <span class="k">let</span> <span class="n">peek_min</span> <span class="n">h</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="nc">None</span> 
      <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> 
 
  <span class="k">let</span> <span class="n">take_min</span> <span class="n">h</span> <span class="o">=</span> 
    <span class="k">match</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="k">with</span> 
      <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="nc">Not_found</span> 
      <span class="o">|</span> <span class="mi">1</span> <span class="o">-&gt;</span> 
          <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
          <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="o">(</span><span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="mi">0</span><span class="o">);</span> 
          <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">&lt;-</span> <span class="mi">0</span><span class="o">;</span> 
          <span class="n">m</span> 
      <span class="o">|</span> <span class="n">k</span> <span class="o">-&gt;</span> 
          <span class="k">let</span> <span class="n">m</span> <span class="o">=</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span> 
          <span class="k">let</span> <span class="n">k</span> <span class="o">=</span> <span class="n">k</span> <span class="o">-</span> <span class="mi">1</span> <span class="k">in</span> 
          <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="mi">0</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">k</span><span class="o">);</span> 
          <span class="n">h</span><span class="o">.</span><span class="n">arr</span><span class="o">.(</span><span class="n">k</span><span class="o">)</span> <span class="o">&lt;-</span> <span class="o">(</span><span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="mi">0</span><span class="o">);</span> 
          <span class="n">h</span><span class="o">.</span><span class="n">len</span> <span class="o">&lt;-</span> <span class="n">k</span><span class="o">;</span> 
          <span class="n">down</span> <span class="n">h</span> <span class="mi">0</span><span class="o">;</span> 
          <span class="n">m</span> 
 
  <span class="k">let</span> <span class="n">size</span> <span class="n">h</span> <span class="o">=</span> <span class="n">h</span><span class="o">.</span><span class="n">len</span> 
<span class="k">end</span> 
</code></pre> 
</div> 
<p>(Complete code is <a href="https://github.com/jaked/ambassadortothecomputers.blogspot.com/tree/master/_code/binary-heaps">here</a>.)</p>
