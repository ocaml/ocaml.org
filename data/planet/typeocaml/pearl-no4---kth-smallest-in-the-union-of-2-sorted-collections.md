---
title: Pearl No.4 - Kth Smallest in the Union of 2 Sorted Collections
description: 'Here is the Pearl No.4:   Let A and B be two disjoint ordered collections
  with distinct elements inside. Their combined size is greater than k.          A
  and B are sorted, but the underlying data structures are not specified as...'
url: http://typeocaml.com/2017/10/19/pearl-no-4-double-binary-search/
date: 2017-10-19T13:37:30-00:00
preview_image: http://typeocaml.com/content/images/2017/10/cube-2.jpg
featured:
authors:
- typeocaml
---

<p><img src="http://typeocaml.com/content/images/2017/10/cube-2-1.jpg#hero" alt="hero"/></p>

<p>Here is the Pearl No.4:</p>

<blockquote>
  <p>Let A and B be two disjoint ordered collections with distinct elements inside. Their combined size is greater than k. </p>
  
  <ol>
  <li>A and B are sorted, but the underlying data structures are not specified as they are collections.</li>
  <li>A and B do not have common elements, since they are <em>disjoint</em></li>
  <li>All elements in A and B are distinct</li>
  <li>The total number of all elements is larger than k</li>
  </ol>
  
  <p><strong>Find the kth smallest element of A &cup; B.</strong></p>
  
  <p>By definition, the kth smallest element of a collection is one for which there are exactly k elements smaller than it, so the 0th smallest is the smallest, i.e., <strong>k starts from 0</strong>.</p>
</blockquote>

<p>Let's have a look at an example.</p>

<p><img src="http://typeocaml.com/content/images/2015/12/example-4.jpg" alt="example"/></p>

<h1>Easy Solution - Merge</h1>

<p>I believe it is easy enough to come out with the <strong>merge</strong> solution. Since both A and B are sorted, we can just start from the beginning of A and B and do the regular <a href="http://typeocaml.com/2014/12/04/recursion-reloaded/">merge operation</a> until we reach <code>kth</code>. (In fact, when I tried to produce the example figure above with <code>k = 7</code>, I did use <em>merge</em> in my head to find the target element <code>36</code>.)</p>

<p>Say A and B are <em>lists</em>, we can have the following solution in OCaml:</p>

<pre><code class="ocaml">let kth_merge a b k =  
  let rec merge i = function
    | x::_, y::_ when i = k -&gt; min x y
    | m::_, [] | [], m::_ when i = k -&gt; m
    | _::ms, [] | [], _::ms when i &lt; k -&gt; merge (i+1) ([], ms)
    | x::xs, y::ys when i &lt; k -&gt; 
      merge (i+1) (if x &lt; y then xs, y::ys else x::xs, ys)
    | _ -&gt; assert false
  in
  merge 0 (a,b)
</code></pre>

<p>The time complexity of this is obviously <code>O(n)</code> or more precisely <code>O(k)</code>. </p>

<p>This approach assumes A and B being lists and <em>merge</em> should be a quite optimal solution. However, the problem doesn't force us to use <em>list</em> only. If we assume A and B to be <em>array</em>, can we do better?</p>

<h1>Recall Binary Search</h1>

<p>As described in <a href="http://typeocaml.com/2015/01/20/mutable/">Mutable</a>, when looking for an element in a <em>sorted array</em>, we can use <em>binary search</em> to obtain <code>O(log(n))</code> performance, instead of linear searching.</p>

<blockquote>
  <p>For binary search, we just go to the middle and then turn left or right depending on the comparison of the middle value and our target.</p>
</blockquote>

<p><img src="http://typeocaml.com/content/images/2015/12/binary_search.jpg" alt="binary search"/></p>

<p>Coming back to our current problem, </p>

<ol>
<li>We are searching for something (a value with a rank instead of a particular value itself though)  </li>
<li>The data structures of A and B are not limited to <em>lists</em>, but also can be <em>arrays</em>.  </li>
<li>Both A and B are sorted.</li>
</ol>

<p>These characteristics present <em>nothing directly</em> towards a classic binary search problem, however, they seem hinting us that <em>binary search</em> is worth trying. </p>

<p>Let's have a go.</p>

<h1>Double Binary Rank Search</h1>

<p>So here is the A and B, we want to find the <code>kth</code> smallest value</p>

<p><img src="http://typeocaml.com/content/images/2017/10/ds_1-2.jpg" alt="ds_1"/></p>

<p>Since we are trying <em>binary search</em>, we can just split A and B by their middle values respectively.</p>

<p><img src="http://typeocaml.com/content/images/2017/10/ds_2.jpg" alt="ds_2"/></p>

<p>So what now? </p>

<p>In single binary search, we can compare the middle value with the target varlue. And if target is larger, then we go right; otherwise, we go left. </p>

<p>But in this double binary rank search problem, it is a little trickier:</p>

<ol>
<li>We have 2 sorted arrays instead of 1  </li>
<li>We are not searching for an element with a particular value, instead, with a particular rank (kth smallest)</li>
</ol>

<p>From point 1 above, the middle values split the two arrays into four parts; From point 2 above, we have to find out which part (out of the four) the kth would fall into. In addition, since its about rank instead of a value, it must be related to the lengths of the parts.</p>

<p>Let's assume <em>a &lt; b</em> (if not, then we can simply swap A and B).</p>

<p>So if a &lt; b, what we can induct?</p>

<p><img src="http://typeocaml.com/content/images/2017/10/ds_3-9.jpg" alt="ds_3"/></p>

<p>The relationships between all the parts (including <code>a</code> and <code>b</code>) are demonstrated as above. The position of <code>ha</code> is dynamic as we only know the middle points a &lt; b. However, the relationship between <code>la, a, lb</code> and <code>b</code> is determined and we know for sure that there are definitely at least <code>la + lb + 1 (lenth of a is 1)</code> numbers smaller than <code>b</code>. Thus considering the rank <code>k</code>, if <code>k &lt;= la + lb + 1</code>:</p>

<ol>
<li>From Case 1 and 2, the kth element must be in <code>la</code>, or <code>a</code>, or <code>ha</code>, or <code>lb</code>  </li>
<li>From Case 3, it must be in <code>la</code>, or <code>a</code>, or <code>lb</code></li>
</ol>

<p>We therefore can know simply that <strong>if k &lt;= la + lb + 1, the kth smallest number definitely won't be in <code>hb</code></strong>.</p>

<p><img src="http://typeocaml.com/content/images/2017/10/ds_4-3.jpg" alt="ds_4"/></p>

<p>What if k &gt; la + lb + 1? Going back to the 3 cases:</p>

<ol>
<li>The kth element might be in <code>hb</code> because k can be big enough.  </li>
<li>From Case 1, it might be in <code>ha</code> if <code>ha</code> are all larger than <code>lb</code> otherwise, it might be in <code>lb</code>  </li>
<li>From Case 2, it might be in <code>ha</code> or <code>b</code>  </li>
<li>From Case 3, it is obviously that <code>la</code> doesn't have a chance to have the kth element.</li>
</ol>

<p>Thus <strong>if k &gt; la + lb + 1, the kth smallest number definitely won't be in <code>la</code></strong>.</p>

<p><img src="http://typeocaml.com/content/images/2017/10/ds_5.jpg" alt="ds_5"/></p>

<p>So every time we compare <code>k</code> with <code>la + lb + 1</code> and at least one part can be eliminated out. If a &lt; b, then either <code>la</code> or <code>hb</code> is removed; otherwise, either <code>lb</code> or <code>ha</code> is removed (as said, we can simply swap A and B).</p>

<pre><code class="ocaml">let kth_union k a b =  
  let sa = Array.length a and sb = Array.length b in
  let rec kth k (a, la, ha) (b, lb, hb) =
    if la &gt;= ha+1 then b.(k+lb)
    else if lb &gt;= hb+1 then a.(k+la)
    else  
      let ma = (ha+la)/2 and mb = (hb+lb)/2 in
      match a.(ma) &lt; b.(mb), k &gt;= ma-la+1+mb-lb with 
      | true, true -&gt; kth (k-(ma-la+1)) (a, ma+1, ha) (b, lb, hb)
      | true, false -&gt; kth k (a, la, ha) (b, lb, mb-1)
      | _ -&gt; kth k (b, lb, hb) (a, la, ha) (* swap *)
  in 
  kth k (a, 0, sa-1) (b, 0, sb-1)
</code></pre>

<p>Since every time we remove <code>1 / 4</code> elements, the complexity is <code>O(2*log(N))</code>, i.e., <code>O(log(N))</code>.</p>

<h1>Remark</h1>

<p>This pearl is comparatively not difficult, however, the idea of process of elimination is worth noting. Instead of choosing which part is positive towards our answer, we can remove parts that is impossible and eventually we can achieve similar algorithmic complexity. </p>

<h1>A further slight improvement</h1>

<p>From a reply in <a href="https://news.ycombinator.com/reply?id=15514451">hackernews</a>, it was suggested that</p>

<blockquote>
  <p>If the data structures can be split (as it seems), then the first step should be to get the head k element of both collections, so we only have to work with a maximum of 2k elements. Then the solution is not O(2 * log(N)) but O(2 * log(min(N,2k))).</p>
</blockquote>

<p>This would not significantly improve the performance however it makes sense especially when <code>k</code> is smaller than the lengths of both <code>A</code> and <code>B</code>. </p>
